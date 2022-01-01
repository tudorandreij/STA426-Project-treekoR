# Makefile 

# Master file:
MASTER = report

# File lists:
RNW = $(wildcard chapter*.Rnw)
R = $(patsubst %.Rnw, %.R, $(RNW))
TEX = $(patsubst %.Rnw, %.tex, $(RNW))


# Targets:
all: $(MASTER).pdf

$(MASTER).pdf: $(MASTER).tex 
	latexmk -bibtex -pdf -use-make -synctex=1 \
		 -pdflatex="pdflatex -interaction=nonstopmode" $(MASTER).tex 

$(MASTER).tex: $(RNW) $(MASTER).Rnw
	Rscript -e "library(knitr); knitr::knit('$(MASTER).Rnw')"

%.tex: %.Rnw
	Rscript -e "library(knitr); knitr::knit('$<')"
	
%.R: %.Rnw
	Rscript -e "library(knitr); knitr::purl('$<',documentation=0L)"

%.pdf: %.tex
	latexmk -bibtex -pdf -use-make -synctex=1 \
		 -pdflatex="pdflatex -interaction=nonstopmode" $< 


clean:
	rm -f *~   *.out Rplots.pdf \
         *.idx *.ilg *.brf *.blg *.spl  $(MASTER).dvi \
         *.backup *.toc *.fls  *fdb_latexmk *.synctex.gz  *-concordance.tex

cleanall: clean
	rm -f  *.out Rplots.pdf 
	rm -f  *.idx *.ilg *.brf *.blg *.spl  $(MASTER).dvi
	rm -f *.aux *.log *.ind *.ist
	rm -f figure/ch??_fig*.pdf figure/unnamed-chunk*.pdf 
	rm -f chapter??.tex $(MASTER).bbl  $(MASTER).tex $(MASTER).pdf
	rm -f cache/*.* cache/__packages
	echo "\nRemoved all files to precompilation status\n"

# Some technical details
.SUFFIXES: .Rnw .R .tex .pdf
.SILENT: *.pdf *.tex
.PHONY: all clean cleanall

# Reinhard Furrer for STA472
