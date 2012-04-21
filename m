Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:58735 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751531Ab2DUFEF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Apr 2012 01:04:05 -0400
Received: by lbbgi4 with SMTP id gi4so2748702lbb.11
        for <linux-wireless@vger.kernel.org>; Fri, 20 Apr 2012 22:04:01 -0700 (PDT)
Message-ID: <1334984639.4965.108.camel@cumari> (sfid-20120421_070410_236770_E495F6A8)
Subject: Re: wl1251 build woes (compat-wireless 3.3.1-1, 3.1.1 as well as
 2.6.39)
From: Luciano Coelho <coelho@ti.com>
To: Mr Dash Four <mr.dash.four@googlemail.com>
Cc: linux-wireless@vger.kernel.org
Date: Sat, 21 Apr 2012 08:03:59 +0300
In-Reply-To: <4F91F926.2080507@googlemail.com>
References: <4F91F926.2080507@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2012-04-21 at 01:02 +0100, Mr Dash Four wrote: 
> I am trying to build the wl1251 driver from compat-wireless 3.3.1-1, using a separate (Android-based) kernel as a base, but I am encountering a few snags:
> 
> From the base compat-wireless-3.3.1-1 (CCOMPILER environemnt variable is set to the toolchain directory prefix I use for ARM):
> 
> [mockbuild@test1 compat-wireless-3.3.1-1]$ ./scripts/driver-select wl1251
> [mockbuild@test1 compat-wireless-3.3.1-1]$ make ARCH=arm CROSS_COMPILE=$CCOMPILER KLIB=<android_kernel_dir> KLIB_BUILD=<android_kernel_dir>
> /builddir/compat-wireless-3.3.1-1/config.mk:212: "WARNING: CONFIG_CFG80211_WEXT will be deactivated or not working because kernel was compiled with CONFIG_WIRELESS_EXT=n. Tools using wext interface like iwconfig will not work. To activate it build your kernel e.g. with CONFIG_LIBIPW=m."
> [...]
>   Building modules, stage 2.
>   MODPOST 3 modules
>   CC      /builddir/compat-wireless-3.3-1/compat/compat.mod.o
>   LD [M]  /builddir/compat-wireless-3.3-1/compat/compat.ko
>   CC      /builddir/compat-wireless-3.3-1/net/mac80211/mac80211.mod.o
>   LD [M]  /builddir/compat-wireless-3.3-1/net/mac80211/mac80211.ko
>   CC      /builddir/compat-wireless-3.3-1/net/wireless/cfg80211.mod.o
>   LD [M]  /builddir/compat-wireless-3.3-1/net/wireless/cfg80211.ko
> make[1]: Leaving directory `<android_kernel_dir>'
> 
> Should I be worried about the above warning? I do *not* have "CONFIG_WIRELESS_EXT" anywhere in my (android kernel) .config, but do have CONFIG_WIRELESS=y as well as CONFIG_CFG80211_WEXT=y. Also, I can't see any of the wl1251 drivers from compat-wireless (located in drivers/net/wireless/wl1251) being built at all! Am I missing something? 

No, don't worry.  This is harmless if you don't use WEXT.  Just remove
the CONFIG_CFG80211_WEXT from your .config and the warning should go
away.


> On a slightly different note, I also tried to use previous versions of compat-wireless - 3.1.1 as well as 2.6.39-1 - but things got even more hairy. After executing make, I got this:
> 
> make[3]: *** No rule to make target `/builddir/compat-wireless-3.1.1-1/net/wireless/db.txt', needed by `/builddir/compat-wireless-2.6.39-1/net/wireless/regdb.c'.  Stop.
> 
> After the above error I just copied db.txt from wireless-regdb-2011.04.28.tar.bz2 to net/wireless, but then got this next:
> 
> make[3]: *** No rule to make target `/builddir/compat-wireless-3.1.1-1/net/wireless/genregdb.awk', needed by `/builddir/compat-wireless-3.1.1-1/net/wireless/regdb.c'.  Stop.
> 
> So, again, I copied genregdb.awk from the 3.3.1-1 version of compat-wireless, but that wasn't enough, unfortunately:
> 
> WARNING: "reg_regdb_size" [/builddir/compat-wireless-3.1.1-1/net/wireless/cfg80211.ko] undefined!
> WARNING: "reg_regdb" [/builddir/compat-wireless-3.1.1-1/net/wireless/cfg80211.ko] undefined!

Sometimes compat-wireless breaks, when syncing with the latest upstream
sourcers.  If the newest works for you, use that. ;)


> The wl1251 drivers are not built here either - drivers/net/wireless/wl1251 is untouched! Any help or advice as to how can I resolve this would very much appreciated, thanks!

If this is a recent compat-wireless, then the wl1251 driver was moved to
drivers/net/wireless/ti/wl1251.  Can you check that?

-- 
Cheers,
Luca.

