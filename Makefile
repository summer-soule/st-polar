# st - simple terminal
# See LICENSE file for copyright and license details.
.POSIX:

include config.mk

SRC = st.c x.c
OBJ = $(SRC:.c=.o)

all: st-polar

config.h:
	cp config.def.h config.h

.c.o:
	$(CC) $(STCFLAGS) -c $<

st.o: config.h st.h win.h
x.o: arg.h config.h st.h win.h

$(OBJ): config.h config.mk

st-polar: $(OBJ)
	$(CC) -o $@ $(OBJ) $(STLDFLAGS)

patch: 
	git apply --verbose patches/st-polar-0.9.2.diff

clean:
	rm -f st-polar $(OBJ) st-polar-$(VERSION).tar.gz

dist: clean
	mkdir -p st-polar-$(VERSION)
	cp -R FAQ LEGACY TODO LICENSE Makefile README config.mk\
		config.def.h st.info st.1 arg.h st.h win.h patches $(SRC)\
		st-polar-$(VERSION)
	tar -cf - st-polar-$(VERSION) | gzip > st-polar-$(VERSION).tar.gz
	rm -rf st-polar-$(VERSION)

install: st-polar
	mkdir -p $(DESTDIR)$(PREFIX)/bin
	cp -f st-polar $(DESTDIR)$(PREFIX)/bin
	chmod 755 $(DESTDIR)$(PREFIX)/bin/st-polar
	mkdir -p $(DESTDIR)$(MANPREFIX)/man1
	sed "s/VERSION/$(VERSION)/g" < st.1 > $(DESTDIR)$(MANPREFIX)/man1/st-polar.1
	chmod 644 $(DESTDIR)$(MANPREFIX)/man1/st-polar.1
	tic -sx st-polar.info
	@echo Please see the README file regarding the terminfo entry of st-polar.

uninstall:
	rm -f $(DESTDIR)$(PREFIX)/bin/st-polar
	rm -f $(DESTDIR)$(MANPREFIX)/man1/st-polar.1

.PHONY: all clean dist install uninstall patch
