Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:55539 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229Ab2DUMbl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Apr 2012 08:31:41 -0400
Received: by wejx9 with SMTP id x9so6577726wej.19
        for <linux-wireless@vger.kernel.org>; Sat, 21 Apr 2012 05:31:40 -0700 (PDT)
Message-ID: <4F92A8A7.9090302@googlemail.com> (sfid-20120421_143146_094001_10203EFF)
Date: Sat, 21 Apr 2012 13:31:35 +0100
From: Mr Dash Four <mr.dash.four@googlemail.com>
MIME-Version: 1.0
To: Luciano Coelho <coelho@ti.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: wl1251 build woes (compat-wireless 3.3.1-1, 3.1.1 as well as
 2.6.39)
References: <4F91F926.2080507@googlemail.com> <1334984639.4965.108.camel@cumari>
In-Reply-To: <1334984639.4965.108.camel@cumari>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


>> Should I be worried about the above warning? I do *not* have "CONFIG_WIRELESS_EXT" anywhere in my (android kernel) .config, but do have CONFIG_WIRELESS=y as well as CONFIG_CFG80211_WEXT=y. Also, I can't see any of the wl1251 drivers from compat-wireless (located in drivers/net/wireless/wl1251) being built at all! Am I missing something? 
>>     
>
> No, don't worry.  This is harmless if you don't use WEXT.  Just remove
> the CONFIG_CFG80211_WEXT from your .config and the warning should go
> away.
>   
OK, I'll do that, thanks!

>> WARNING: "reg_regdb_size" [/builddir/compat-wireless-3.1.1-1/net/wireless/cfg80211.ko] undefined!
>> WARNING: "reg_regdb" [/builddir/compat-wireless-3.1.1-1/net/wireless/cfg80211.ko] undefined!
>>     
>
> Sometimes compat-wireless breaks, when syncing with the latest upstream
> sourcers.  If the newest works for you, use that. ;)
>   
That doesn't appear to be the case, unfortunately - see below.

>> The wl1251 drivers are not built here either - drivers/net/wireless/wl1251 is untouched! Any help or advice as to how can I resolve this would very much appreciated, thanks!
>>     
>
> If this is a recent compat-wireless, then the wl1251 driver was moved to
> drivers/net/wireless/ti/wl1251.  Can you check that?
>   
I initially used compat-wireless-3.3.1-1 as it was the latest "stable" 
kernel edition released. The wl1251 drivers are in net/wireless/wl1251, 
not drivers/net/wireless/ti/wl1251. That is also the case with the 
latest released compat-wireless - 3.4-rc3-1.

I did a bit of hacking/tweaking, but ran into much bigger problems and 
simply gave up in the end. When I looked at various compat-wireless 
makefiles I saw that, somehow the inclusion of wl1251 as well as wl12xx 
depends on CONFIG_CRC7 and CONFIG_WL12XX_PLATFORM_DATA being set (the 
latter also depends on wl12xx, so if I wanted it included, I had to 
switch to "wl12xx" instead of "wl1251"). So, I did the following:

./scripts/driver-select restore
./scripts/driver-select wl12xx
make ARCH=arm CROSS_COMPILE=$CCOMPILER KLIB=<android_kernel_dir> 
KLIB_BUILD=<android_kernel_dir> CONFIG_CRC7=y CONFIG_WL12XX_PLATFORM_DATA=y

I then get the following errors:

/builddir/compat-wireless-3.3-1/drivers/net/wireless/wl12xx/sdio.c: In 
function 'wl12xx_sdio_power_on':
/builddir/compat-wireless-3.3-1/drivers/net/wireless/wl12xx/sdio.c:126:2: 
error: implicit declaration of function 'pm_runtime_enabled' 
[-Werror=implicit-function-declaration]
/builddir/compat-wireless-3.3-1/drivers/net/wireless/wl12xx/sdio.c:132:7: 
error: void value not ignored as it ought to be
/builddir/compat-wireless-3.3-1/drivers/net/wireless/wl12xx/sdio.c: In 
function 'wl12xx_sdio_power_off':
/builddir/compat-wireless-3.3-1/drivers/net/wireless/wl12xx/sdio.c:153:6: 
error: void value not ignored as it ought to be
cc1: some warnings being treated as errors

make[4]: *** 
[/builddir/compat-wireless-3.3-1/drivers/net/wireless/wl12xx/sdio.o] Error 1
make[3]: *** 
[/builddir/compat-wireless-3.3-1/drivers/net/wireless/wl12xx] Error 2
make[2]: *** [/builddir/compat-wireless-3.3-1/drivers/net/wireless] Error 2
make[1]: *** [_module_/builddir/compat-wireless-3.3-1] Error 2
make[1]: Leaving directory `<android_kernel_dir>'
make: *** [modules] Error 2

Apparently, "pm_runtime_enabled" is defined in 
include/linux/pm_runtime.h, but this is for the 3.0+ version of the 
kernel - I am using 2.6.37! Something seems to be seriously screwed up! 
The above is valid for all 3.x versions of compat-wireless I tried! I 
was under the impression that compat-wireless is backward-compatible 
with "older" kernel versions, like mine, is that not the case?!

When I tried the latest compat-wireless before 3.x (2.6.39-1) I don't 
get the first error, but get the other two, albeit with modified 
function names (wl1271_sdio_* instead of wl12xx_sdio_*).

In addition to the above, for some reason when I run compat-wireless for 
versions prior to 3.x (I tried 2 such versions - 2.6.39-1 and 2.6.38-2) 
I also get a weird error that 
"<android_kernel_dir>//builddir/compat-wireless-XXX/net/wireless/db.txt 
cannot be found" - the search path there is completely wrong, it should 
either be <android_kernel_dir>" or 
"/builddir/compat-wireless-XXX/net/wireless/db.txt" and not this weird 
concatenated path containing both!

Again, this only happens with the 2 releases prior to 3.x I tried and 
only when I have "db.txt" and "genregdb.awk" from 3.3.1-1 manually 
copied to net/wireless. Any help?

Luciano, seeing as you work for TI, I have one more query for you, if I 
may - the need for me to turn to build compat-wireless was borne out of 
my continuous, *completely fruitless* and *extremely frustrating* 
attempts for me to build a decent version of wpa_supplicant for my 
android device, which uses the "native" TI-supplied wireless driver for 
that device (tiwlan) - it proved an absolutely impossible task as the 
TI-supplied driver refuses to build with wpa_supplicant which has 
version any other than v5.11 (I have tried *all* released versions after 
this one - 6.11, 0.7.1, 0.7.3, 1.0-rc, 1.0 as well as the latest from 
git)! "Newer" TI-supplied drivers do *not* work with my TI-1251 device 
at all!

Is there a decent driver for TI-1251 which could be integrated with a 
relatively recent/decent version of the wpa_supplicant?

It is imperative that I build a decent version of wpa_supplicant for my 
device and it is the sole reason why I have chosen this route and turned 
to the Linux-based wireless stack, but unfortunately my assumption that 
the process there would be more straight-forward proved to be rather 
naive and my earlier optimism completely misplaced! :-(
