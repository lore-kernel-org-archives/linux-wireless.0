Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostingsmtp01.register.it ([81.88.50.242]:37305 "EHLO
	hostingsmtp.register.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933071Ab2FBXqz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Jun 2012 19:46:55 -0400
Message-Id: <201206022346.q52NkkMX020927@vivaldi16.register.it> (sfid-20120603_014732_859948_52A3ECDD)
From: "Guido Trentalancia" <guido@trentalancia.com>
Reply-To: "Guido Trentalancia" <guido@trentalancia.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH v3]: iw: fix the Makefile for multiple libnl installations
Date: Sun, 03 Jun 2012 01:46:45 +0200
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Johannes.

On Sat, 2012-06-02 at 19:53 +0200, Johannes Berg wrote:
> On Sat, 2012-06-02 at 18:53 +0200, Guido Trentalancia wrote:
> 
> > -NL1FOUND := $(shell $(PKG_CONFIG) --atleast-version=1 libnl-1 && echo Y)
> > -NL2FOUND := $(shell $(PKG_CONFIG) --atleast-version=2 libnl-2.0 && echo Y)
> > -NL3FOUND := $(shell $(PKG_CONFIG) --atleast-version=3 libnl-3.0 && echo Y)
> > -NL31FOUND := $(shell $(PKG_CONFIG) --exact-version=3.1 libnl-3.1 && echo Y)
> > +ifeq ($(NLLIBNAME),)
> >  NL3xFOUND := $(shell $(PKG_CONFIG) --atleast-version=3.2 libnl-3.0 && echo Y)
> > +ifneq ($(NL3xFOUND),Y)
> > +NL31FOUND := $(shell $(PKG_CONFIG) --exact-version=3.1 libnl-3.1 && echo Y)
> > +ifneq ($(NL31FOUND),Y)
> > +NL3FOUND := $(shell $(PKG_CONFIG) --atleast-version=3 libnl-3.0 && echo Y)
> > +ifneq ($(NL3FOUND),Y)
> > +NL2FOUND := $(shell $(PKG_CONFIG) --atleast-version=2 libnl-2.0 && echo Y)
> > +ifneq ($(NL2FOUND),Y)
> > +NL1FOUND := $(shell $(PKG_CONFIG) --atleast-version=1 libnl-1 && echo Y)
> > +endif
> 
> If you have this part, then
> 
> >  ifeq ($(NL2FOUND),Y)
> > -CFLAGS += -DCONFIG_LIBNL20
> > -LIBS += -lnl-genl
> > +CFLAGS = -DCONFIG_LIBNL20
> > +LIBS = -lnl-genl
> 
> All these changes aren't necessary, right? I'd prefer not to make these
> changes since people might want to set some CFLAGS somewhere.

Yes, sure. Two heads, better than one.

Users with specific requirements can then pass specific CFLAGS and LIBS
arguments to make, as in:

CFLAGS="-O2" make V=1 (libnl autodetection + optimisation + verbose)

NLLIBNAME=libnl-2.0 CFLAGS=-DCONFIG_LIBNL20 LIBS=-lnl-genl make (forced
libnl version 2.0)

and so on...

Here is the latest version of the patch (v3) that I have created (there
was another problem unintentionally introduced by patch v2 which was
overriding the default CFLAGS at the top of the Makefile):

All different versions of libnl can cohexist on a system (libnl-1, libnl-2, libnl-3.0, libnl-3.1 and libnl-3.2). When multiple versions are installed only link against the highest versioned one, otherwise there might be unpredictable results (including segmentation faults).

Program received signal SIGSEGV, Segmentation fault.
0x00007ffff7bd7f7d in genl_unregister () from /usr/lib64/libnl-genl.so.3
(gdb) where
#0  0x00007ffff7bd7f7d in genl_unregister () from /usr/lib64/libnl-genl.so.3
#1  0x00007ffff7de9c17 in _dl_fini () at dl-fini.c:254
#2  0x00007ffff7433c01 in __run_exit_handlers (status=0, listp=0x7ffff77b06b8, run_list_atexit=run_list_atexit@entry=true) at exit.c:78
#3  0x00007ffff7433c85 in __GI_exit (status=<optimized out>) at exit.c:100
#4  0x00007ffff741ba4c in __libc_start_main (main=0x401c20 <main>, argc=1, ubp_av=0x7fffffffe368, init=<optimized out>, fini=<optimized out>, rtld_fini=<optimized out>, stack_end=0x7fffffffe358) at libc-start.c:258
#5  0x0000000000401f61 in _start () at ../sysdeps/x86_64/elf/start.S:113

This patch fixes the Makefile and (v3) also allows to manually select the desired nl library version by passing the appropriate NLLIBNAME, CFLAGS and LIBS variables to make.

Signed-off-by: Guido Trentalancia <guido@trentalancia.com>

---
 Makefile |   26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

--- iw-3.4-original/Makefile	2012-03-29 11:05:04.000000000 +0200
+++ iw-3.4/Makefile	2012-06-03 01:29:10.441912179 +0200
@@ -11,8 +11,8 @@ MKDIR ?= mkdir -p
 INSTALL ?= install
 CC ?= "gcc"
 
-CFLAGS ?= -O2 -g
-CFLAGS += -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common -Werror-implicit-function-declaration
+COPT ?= -O2 -g
+CWARN ?= -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common -Werror-implicit-function-declaration
 
 OBJS = iw.o genl.o event.o info.o phy.o 
 	interface.o ibss.o station.o survey.o util.o 
@@ -22,11 +22,25 @@ OBJS = iw.o genl.o event.o info.o phy.o
 OBJS += sections.o
 ALL = iw
 
-NL1FOUND := $(shell $(PKG_CONFIG) --atleast-version=1 libnl-1 && echo Y)
-NL2FOUND := $(shell $(PKG_CONFIG) --atleast-version=2 libnl-2.0 && echo Y)
-NL3FOUND := $(shell $(PKG_CONFIG) --atleast-version=3 libnl-3.0 && echo Y)
-NL31FOUND := $(shell $(PKG_CONFIG) --exact-version=3.1 libnl-3.1 && echo Y)
+ifeq ($(CFLAGS),)
+CFLAGS += $(COPT) $(CWARN)
+endif
+
+ifeq ($(NLLIBNAME),)
 NL3xFOUND := $(shell $(PKG_CONFIG) --atleast-version=3.2 libnl-3.0 && echo Y)
+ifneq ($(NL3xFOUND),Y)
+NL31FOUND := $(shell $(PKG_CONFIG) --exact-version=3.1 libnl-3.1 && echo Y)
+ifneq ($(NL31FOUND),Y)
+NL3FOUND := $(shell $(PKG_CONFIG) --atleast-version=3 libnl-3.0 && echo Y)
+ifneq ($(NL3FOUND),Y)
+NL2FOUND := $(shell $(PKG_CONFIG) --atleast-version=2 libnl-2.0 && echo Y)
+ifneq ($(NL2FOUND),Y)
+NL1FOUND := $(shell $(PKG_CONFIG) --atleast-version=1 libnl-1 && echo Y)
+endif
+endif
+endif
+endif
+endif
 
 ifeq ($(NL1FOUND),Y)
 NLLIBNAME = libnl-1

But, of course, feel free to further rework it the way you prefer...

> johannes

Regards,

Guido
 

