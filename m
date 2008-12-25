Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:19422 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751479AbYLYAzX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Dec 2008 19:55:23 -0500
Subject: Re: 4965AGN Not Associating
From: Zhu Yi <yi.zhu@intel.com>
To: Delphi Real Estate <Info@delphi-real-estate.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <200812241158.29493.Info@delphi-real-estate.com>
References: <200812241158.29493.Info@delphi-real-estate.com>
Content-Type: text/plain
Date: Thu, 25 Dec 2008 08:56:51 +0800
Message-Id: <1230166611.2688.3.camel@debian.sh.intel.com> (sfid-20081225_015529_626997_6941B69F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2008-12-25 at 03:58 +0800, Delphi Real Estate wrote:
> Running Kubuntu Hardy and typically compile a custom kernel.  First I
> downloaded and compiled compat-wireless-old.tar.bz2 and compiled it to
> my kernel 2.6.24.  Driver loaded fine and the wlan0 interface came up,
> but would no longer associate as the old driver did.  Rebooted, but a
> second or so after the blue wireless light came on, the kernel crashed
> with an Aieeee!  No way to see exactly where or why, as it'd scrolled
> off the screen and there's nothing in the logs.

You can either use fb to make your console show more lines and take a
picture for it or use netconsole to capture the log.

> So I tried just compiling kernels 2.6.27 and .28 to test their iwlagn
> functionality, but unfortunately no version of .27 or .28 will compile
> on my laptop.  .27 does compile on my HTPC, but not where it counts:
>   OFFSETS arch/x86/boot/offsets.h
>   OBJCOPY arch/x86/boot/vmlinux.bin
>   AS      arch/x86/boot/header.o
>   LD      arch/x86/boot/setup.elf
>   OBJCOPY arch/x86/boot/setup.bin
>   BUILD   arch/x86/boot/bzImage
> Root device is (8, 1)
> Setup is 11916 bytes (padded to 12288 bytes).
> System is 2904 kB
> CRC 30db084d
> Kernel: arch/x86/boot/bzImage is ready  (#1)
> ERROR: "snd_hwdep_new" [ubuntu/misc/media/snd-bt-sco.ko] undefined!
> WARNING: modpost: Found 4 section mismatch(es).
> To see full details build your kernel with:
> 'make CONFIG_DEBUG_SECTION_MISMATCH=y'
> make[1]: *** [__modpost] Error 1
> make: *** [modules] Error 2

CONFIG_SND_HWDEP?

Also make sure you get the correct firmware.

Thanks,
-yi

