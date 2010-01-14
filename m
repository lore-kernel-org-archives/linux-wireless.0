Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f225.google.com ([209.85.220.225]:51731 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292Ab0ANDDk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jan 2010 22:03:40 -0500
Received: by fxm25 with SMTP id 25so95109fxm.21
        for <linux-wireless@vger.kernel.org>; Wed, 13 Jan 2010 19:03:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B4DFCA8.6020006@pardus.org.tr>
References: <4B4DFCA8.6020006@pardus.org.tr>
Date: Thu, 14 Jan 2010 03:03:37 +0000
Message-ID: <3ace41891001131903g38f4da27w6f469e6121eaf668@mail.gmail.com>
Subject: Re: Some remarks about compat-wireless KBuild system
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
Cc: Linux Wireless List <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 13, 2010 at 5:02 PM, Ozan Çağlayan <ozan@pardus.org.tr> wrote:
> Hi,
>
> Current compat-wireless build system has some inconveniences for distribution packaging:
>
>
> - In Makefile, KLIB is set to /lib/modules/$(uname -r) which avoids compiling the stack
> against a non-running kernel. In several other external kernel drivers this can be bypassed
> by giving KERNELRELEASE=something to "make" but it's not working for compat-wireless.

Did you not read README (or the instruction in the README not working
any more)?

compat-wireless can be used with a non-running kernel, and the
instruction is in the top-level README. (I contributed part of it, the
part on the non-running kernel which has just been distro-installed,
e.g. to build and install compat-wireless during a routine upgrade
which installs a new kernel but before a reboot to it).


>
> - In gen_compat_autoconf.sh and config.mk there are two calls to $(MAKE) for determining KERNEL_SUBLEVEL:
>
> (gen_compat_autoconf.sh) -> SUBLEVEL=$(make -C $KLIB_BUILD kernelversion | sed -n 's/^2\.6\.\([0-9]\+\).*/\1/p')
> (config.mk) -> KERNEL_SUBLEVEL := $(shell $(MAKE) -C $(KLIB_BUILD) kernelversion | sed -n 's/^2\.6\.\([0-9]\+\).*/\1/p')
>
> The problem with that calls is that they're executing make in $KLIB_BUILD for version parsing which creates
> temporary .tmp files in that directory causing sandboxed builds fail.
>
> KERNELRELEASE=something should also allow bypassing those make calls with something like below:
>
> if KERNELRELEASE is set
>  SUBLEVEL=$(echo "@KERNELRELEASE@" | sed -n 's/^2\.6\.\([0-9]\+\).*/\1/p')
>
>
> - It's impossible to install the modules under a DESTDIR/BUILD_ROOT. KMODPATH_ARG in Makefile
> can be used for this purpose but it's not set until the following condition is met:
>
> ifneq ($(origin KLIB), undefined)
> KMODPATH_ARG:=  "INSTALL_MOD_PATH=$(KLIB)"
>
> I couldn't figure out the evaluation of the expression and simplified it in the following way in my package:
>
> Index: compat-wireless-2010-01-06/Makefile
> ===================================================================
> --- compat-wireless-2010-01-06.orig/Makefile
> +++ compat-wireless-2010-01-06/Makefile
> @@ -1,10 +1,6 @@
>  export KMODDIR?=       updates
>  KMODDIR_ARG:=   "INSTALL_MOD_DIR=$(KMODDIR)"
> -ifneq ($(origin KLIB), undefined)
> -KMODPATH_ARG:=  "INSTALL_MOD_PATH=$(KLIB)"
> -else
> -export KLIB:=          /lib/modules/$(shell uname -r)
> -endif
> +export KLIB:=          /lib/modules/$(shell uname -r)
>  export KLIB_BUILD ?=   $(KLIB)/build
>  # Sometimes not available in the path
>  MODPROBE := /sbin/modprobe
> @@ -12,6 +8,7 @@ MADWIFI=$(shell $(MODPROBE) -l ath_pci)
>  OLD_IWL=$(shell $(MODPROBE) -l iwl4965)
>
>  DESTDIR?=
> +KMODPATH_ARG:=  "INSTALL_MOD_PATH=$(DESTDIR)"
>
>  ifneq ($(KERNELRELEASE),)
>
>
> This way calling
>
> make DESTDIR=/path/to/buildroot install
>
> works correctly.
>
>
> I may be misusing the kbuild system but just wanted to share these in case there's anything to be done
> in upstream,
>
> Thanks!
> Ozan Caglayan
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
