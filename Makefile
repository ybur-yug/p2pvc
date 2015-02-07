CC=gcc
OBJDIR=objs
SRCDIR=src
INCDIR=$(SRCDIR)/inc
CFLAGS+=-I$(INCDIR)

SRCS=$(wildcard $(SRCDIR)/*.c)
OBJS=$(patsubst $(SRCDIR)/%.c,$(OBJDIR)/%.o,$(SRCS))

CFLAGS+=-O2 -Wall -std=c99 -fPIC
CFLAGS_DEBUG+=-O0 -g3 -Werror -DDEBUG -pedantic
LDFLAGS+=-lpthread

all: p2pvc

debug: CC+=$(CFLAGS_DEBUG)
debug: p2pvc .FORCE

.FORCE:

p2pvc: $(OBJS)
	$(CC) $(CFLAGS) $^ -o $@ $(LDFLAGS)

video: CFLAGS := $(CFLAGS) -DVIDEOONLY
video: $(filter-out objs/p2pvc.o, $(OBJS))
	$(CC) $(CFLAGS) $^ -o $@ $(LDFLAGS) -DVCONLY

audio: CFLAGS := $(CFLAGS) -DAUDIOONLY
audio: $(filter-out objs/p2pvc.o, $(OBJS))
	$(CC) $(CFLAGS) $^ -o $@ $(LDFLAGS)

$(OBJS): | $(OBJDIR)
$(OBJDIR):
	mkdir -p $@

$(OBJDIR)/%.o: $(SRCDIR)/%.c $(wildcard $(INCDIR)/*.h) Makefile
	$(CC) $(CFLAGS) $< -c -o $@

clean:
	rm -rf $(OBJDIR) audio video p2pvc
