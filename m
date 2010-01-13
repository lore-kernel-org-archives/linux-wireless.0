Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lider.pardus.org.tr ([193.140.100.216]:46707 "EHLO
	lider.pardus.org.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932125Ab0AMRCe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jan 2010 12:02:34 -0500
Received: from [192.168.1.2] (unknown [88.249.178.198])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: ozan)
	by lider.pardus.org.tr (Postfix) with ESMTPSA id 664F7A7AB53
	for <linux-wireless@vger.kernel.org>; Wed, 13 Jan 2010 18:53:54 +0200 (EET)
Message-ID: <4B4DFCA8.6020006@pardus.org.tr>
Date: Wed, 13 Jan 2010 19:02:32 +0200
From: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
MIME-Version: 1.0
To: Linux Wireless List <linux-wireless@vger.kernel.org>
Subject: Some remarks about compat-wireless KBuild system
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Current compat-wireless build system has some inconveniences for distribution packaging:


- In Makefile, KLIB is set to /lib/modules/$(uname -r) which avoids compiling the stack
against a non-running kernel. In several other external kernel drivers this can be bypassed
by giving KERNELRELEASE=something to "make" but it's not working for compat-wireless.

- In gen_compat_autoconf.sh and config.mk there are two calls to $(MAKE) for determining KERNEL_SUBLEVEL:

(gen_compat_autoconf.sh) -> SUBLEVEL=$(make -C $KLIB_BUILD kernelversion | sed -n 's/^2\.6\.\([0-9]\+\).*/\1/p')
(config.mk) -> KERNEL_SUBLEVEL := $(shell $(MAKE) -C $(KLIB_BUILD) kernelversion | sed -n 's/^2\.6\.\([0-9]\+\).*/\1/p')

The problem with that calls is that they're executing make in $KLIB_BUILD for version parsing which creates
temporary .tmp files in that directory causing sandboxed builds fail.

KERNELRELEASE=something should also allow bypassing those make calls with something like below:

if KERNELRELEASE is set
 SUBLEVEL=$(echo "@KERNELRELEASE@" | sed -n 's/^2\.6\.\([0-9]\+\).*/\1/p')


- It's impossible to install the modules under a DESTDIR/BUILD_ROOT. KMODPATH_ARG in Makefile
can be used for this purpose but it's not set until the following condition is met:

ifneq ($(origin KLIB), undefined)
KMODPATH_ARG:=  "INSTALL_MOD_PATH=$(KLIB)"

I couldn't figure out the evaluation of the expression and simplified it in the following way in my package:

Index: compat-wireless-2010-01-06/Makefile
===================================================================
--- compat-wireless-2010-01-06.orig/Makefile
+++ compat-wireless-2010-01-06/Makefile
@@ -1,10 +1,6 @@
 export KMODDIR?=       updates
 KMODDIR_ARG:=   "INSTALL_MOD_DIR=$(KMODDIR)"
-ifneq ($(origin KLIB), undefined)
-KMODPATH_ARG:=  "INSTALL_MOD_PATH=$(KLIB)"
-else
-export KLIB:=          /lib/modules/$(shell uname -r)
-endif
+export KLIB:=          /lib/modules/$(shell uname -r)
 export KLIB_BUILD ?=	$(KLIB)/build
 # Sometimes not available in the path
 MODPROBE := /sbin/modprobe
@@ -12,6 +8,7 @@ MADWIFI=$(shell $(MODPROBE) -l ath_pci)
 OLD_IWL=$(shell $(MODPROBE) -l iwl4965)
 
 DESTDIR?=
+KMODPATH_ARG:=  "INSTALL_MOD_PATH=$(DESTDIR)"
 
 ifneq ($(KERNELRELEASE),)


This way calling 

make DESTDIR=/path/to/buildroot install

works correctly.


I may be misusing the kbuild system but just wanted to share these in case there's anything to be done
in upstream,

Thanks!
Ozan Caglayan
 

