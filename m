Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:34940 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757559Ab0EABX6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Apr 2010 21:23:58 -0400
From: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>
To: "David H. Lynch Jr." <dhlii@dlasys.net>
Subject: Re: ar9170-fw
Date: Sat, 1 May 2010 03:23:49 +0200
Cc: linux-wireless@vger.kernel.org
References: <4BDB72AA.7000203@dlasys.net>
In-Reply-To: <4BDB72AA.7000203@dlasys.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201005010323.53295.s.L-H@gmx.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

On Saturday 01 May 2010, David H. Lynch Jr. wrote:
>      I tried to build the toolchain from an uptodate pull of the git 
> repository,
> 
>      I am getting a sequence of errors when the build reach libssp.
> 
>      My guess would be that libssp is not needed for the ar9170 firmware.
> 
>      Is this correct and I would appreciate an easy suguestion to 
> disable it if so.
> 
> make[3]: Entering directory `/usr/src/ar9170-fw/toolchain/build/gcc/sh-elf/libssp'
[...]
> -I/usr/src/ar9170-fw/toolchain/src/gcc-4.3.3/libssp -I. -Wall -O2 -g -g -O2 -MT
> ssp.lo -MD -MP -MF .deps/ssp.Tpo -c
> /usr/src/ar9170-fw/toolchain/src/gcc-4.3.3/libssp/ssp.c -o ssp.o
> /usr/src/ar9170-fw/toolchain/src/gcc-4.3.3/libssp/ssp.c: In function
> '__guard_setup':
> /usr/src/ar9170-fw/toolchain/src/gcc-4.3.3/libssp/ssp.c:70: warning: implicit
> declaration of function 'open'
> /usr/src/ar9170-fw/toolchain/src/gcc-4.3.3/libssp/ssp.c:70: error: 'O_RDONLY'
> undeclared (first use in this function)
[...]

I assume your host's /bin/sh is not bash.

---------------------------------------------------------------------------

ar9170.fw: fix bashisms while building the cross toolchain.

Signed-off-by: Stefan Lippers-Hollmann <s.l-h@gmx.de>

--- a/toolchain/Makefile
+++ b/toolchain/Makefile
@@ -31,7 +31,8 @@ src/newlib-$(NEWLIB_VER): src/$(NEWLIB_T
 
 src/gcc-$(GCC_VER): src/$(GCC_TAR) src/newlib-$(NEWLIB_VER)
 	tar -C src -xjf $<
-	ln -s $(BASEDIR)/src/newlib-$(NEWLIB_VER)/{newlib,libgloss} $@
+	ln -s $(BASEDIR)/src/newlib-$(NEWLIB_VER)/newlib $@
+	ln -s $(BASEDIR)/src/newlib-$(NEWLIB_VER)/libgloss $@
 
 binutils: src/binutils-$(BINUTILS_VER)
 	mkdir -p build/binutils

---------------------------------------------------------------------------

While you're at it, I'd suggest to bump the versions for the required 
cross-build environment as well, as it noticably improves stability of the 
firmware images built by it (still not perfectly, but better).

---------------------------------------------------------------------------

ar9170.fw: update cross-toolchain.

Updating the toolchain improves stability of the built firmware images 
significantly.

* gcc-4.4.4
* binutils-2.20.1
* newlib 1.18.0

Signed-off-by: Stefan Lippers-Hollmann <s.l-h@gmx.de>

--- a/toolchain/Makefile
+++ b/toolchain/Makefile
@@ -1,12 +1,12 @@
-BINUTILS_VER=2.19.1
+BINUTILS_VER=2.20.1
 BINUTILS_URL=http://mirrors.kernel.org/gnu/binutils/binutils-$(BINUTILS_VER).tar.bz2
 BINUTILS_TAR=binutils-$(BINUTILS_VER).tar.bz2
 
-NEWLIB_VER=1.17.0
+NEWLIB_VER=1.18.0
 NEWLIB_URL=ftp://sources.redhat.com/pub/newlib/newlib-$(NEWLIB_VER).tar.gz
 NEWLIB_TAR=newlib-$(NEWLIB_VER).tar.gz
 
-GCC_VER=4.3.3
+GCC_VER=4.4.4
 GCC_URL=http://mirrors.kernel.org/gnu/gcc/gcc-$(GCC_VER)/gcc-core-$(GCC_VER).tar.bz2
 GCC_TAR=gcc-core-$(GCC_VER).tar.bz2
 
---------------------------------------------------------------------------

Regards
	Stefan Lippers-Hollmann
