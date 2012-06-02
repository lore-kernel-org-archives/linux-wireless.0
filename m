Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostingsmtp05.register.it ([81.88.50.246]:55223 "EHLO
	hostingsmtp.register.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932557Ab2FBQ5q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Jun 2012 12:57:46 -0400
Message-Id: <201206021650.q52GovY3011788@vivaldi39.register.it> (sfid-20120602_185749_727317_3B8401BB)
From: "Guido Trentalancia" <guido@trentalancia.com>
Reply-To: "Guido Trentalancia" <guido@trentalancia.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH v1]: iw: fix the Makefile for multiple libnl installations
Date: Sat, 02 Jun 2012 18:50:57 +0200
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

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

This is the simplest (v1) patch which fixes the Makefile. A slightly more elaborate modification (v2) also allows to manually select the desired nl library version by passing the appropriate NLLIBNAME, CFLAGS and LIBS variables to make.

Signed-off-by: Guido Trentalancia <guido@trentalancia.com>
---
 Makefile |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- iw-3.4/Makefile	2012-03-29 11:05:04.000000000 +0200
+++ iw-3.4-multiple-libnl-installations/Makefile	2012-06-02 16:53:25.621169916 +0200
@@ -33,30 +33,30 @@ NLLIBNAME = libnl-1
 endif
 
 ifeq ($(NL2FOUND),Y)
-CFLAGS += -DCONFIG_LIBNL20
-LIBS += -lnl-genl
+CFLAGS = -DCONFIG_LIBNL20
+LIBS = -lnl-genl
 NLLIBNAME = libnl-2.0
 endif
 
 ifeq ($(NL3xFOUND),Y)
 # libnl 3.2 might be found as 3.2 and 3.0
 NL3FOUND = N
-CFLAGS += -DCONFIG_LIBNL30
-LIBS += -lnl-genl-3
+CFLAGS = -DCONFIG_LIBNL30
+LIBS = -lnl-genl-3
 NLLIBNAME = libnl-3.0
 endif
 
 ifeq ($(NL3FOUND),Y)
-CFLAGS += -DCONFIG_LIBNL30
-LIBS += -lnl-genl
+CFLAGS = -DCONFIG_LIBNL30
+LIBS = -lnl-genl
 NLLIBNAME = libnl-3.0
 endif
 
 # nl-3.1 has a broken libnl-gnl-3.1.pc file
 # as show by pkg-config --debug --libs --cflags --exact-version=3.1 libnl-genl-3.1;echo $?
 ifeq ($(NL31FOUND),Y)
-CFLAGS += -DCONFIG_LIBNL30
-LIBS += -lnl-genl
+CFLAGS = -DCONFIG_LIBNL30
+LIBS = -lnl-genl
 NLLIBNAME = libnl-3.1
 endif
  

