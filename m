Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:41081 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932852Ab2DXWiI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Apr 2012 18:38:08 -0400
Received: by wejx9 with SMTP id x9so742597wej.19
        for <linux-wireless@vger.kernel.org>; Tue, 24 Apr 2012 15:38:06 -0700 (PDT)
Message-ID: <4F972B46.90306@googlemail.com> (sfid-20120425_003841_393182_AC03D43C)
Date: Tue, 24 Apr 2012 23:37:58 +0100
From: Mr Dash Four <mr.dash.four@googlemail.com>
MIME-Version: 1.0
To: Luciano Coelho <coelho@ti.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: wl1251 build woes (compat-wireless 3.3.1-1, 3.1.1 as well as
 2.6.39)
References: <4F91F926.2080507@googlemail.com> <1334984639.4965.108.camel@cumari> <4F92A8A7.9090302@googlemail.com>
In-Reply-To: <4F92A8A7.9090302@googlemail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


>> If this is a recent compat-wireless, then the wl1251 driver was moved to
>> drivers/net/wireless/ti/wl1251.  Can you check that?
>>   
> I initially used compat-wireless-3.3.1-1 as it was the latest "stable" 
> kernel edition released. The wl1251 drivers are in 
> net/wireless/wl1251, not drivers/net/wireless/ti/wl1251. That is also 
> the case with the latest released compat-wireless - 3.4-rc3-1.
>
> I did a bit of hacking/tweaking, but ran into much bigger problems and 
> simply gave up in the end. When I looked at various compat-wireless 
> makefiles I saw that, somehow the inclusion of wl1251 as well as 
> wl12xx depends on CONFIG_CRC7 and CONFIG_WL12XX_PLATFORM_DATA being 
> set (the latter also depends on wl12xx, so if I wanted it included, I 
> had to switch to "wl12xx" instead of "wl1251"). So, I did the following:
>
> ./scripts/driver-select restore
> ./scripts/driver-select wl12xx
> make ARCH=arm CROSS_COMPILE=$CCOMPILER KLIB=<android_kernel_dir> 
> KLIB_BUILD=<android_kernel_dir> CONFIG_CRC7=y 
> CONFIG_WL12XX_PLATFORM_DATA=y
>
> I then get the following errors:
>
> /builddir/compat-wireless-3.3-1/drivers/net/wireless/wl12xx/sdio.c: In 
> function 'wl12xx_sdio_power_on':
> /builddir/compat-wireless-3.3-1/drivers/net/wireless/wl12xx/sdio.c:126:2: 
> error: implicit declaration of function 'pm_runtime_enabled' 
> [-Werror=implicit-function-declaration]
> /builddir/compat-wireless-3.3-1/drivers/net/wireless/wl12xx/sdio.c:132:7: 
> error: void value not ignored as it ought to be
> /builddir/compat-wireless-3.3-1/drivers/net/wireless/wl12xx/sdio.c: In 
> function 'wl12xx_sdio_power_off':
> /builddir/compat-wireless-3.3-1/drivers/net/wireless/wl12xx/sdio.c:153:6: 
> error: void value not ignored as it ought to be
> cc1: some warnings being treated as errors
>
> make[4]: *** 
> [/builddir/compat-wireless-3.3-1/drivers/net/wireless/wl12xx/sdio.o] 
> Error 1
> make[3]: *** 
> [/builddir/compat-wireless-3.3-1/drivers/net/wireless/wl12xx] Error 2
> make[2]: *** [/builddir/compat-wireless-3.3-1/drivers/net/wireless] 
> Error 2
> make[1]: *** [_module_/builddir/compat-wireless-3.3-1] Error 2
> make[1]: Leaving directory `<android_kernel_dir>'
> make: *** [modules] Error 2
>
> Apparently, "pm_runtime_enabled" is defined in 
> include/linux/pm_runtime.h, but this is for the 3.0+ version of the 
> kernel - I am using 2.6.37! Something seems to be seriously screwed 
> up! The above is valid for all 3.x versions of compat-wireless I 
> tried! I was under the impression that compat-wireless is 
> backward-compatible with "older" kernel versions, like mine, is that 
> not the case?!
>
> When I tried the latest compat-wireless before 3.x (2.6.39-1) I don't 
> get the first error, but get the other two, albeit with modified 
> function names (wl1271_sdio_* instead of wl12xx_sdio_*).
>
> In addition to the above, for some reason when I run compat-wireless 
> for versions prior to 3.x (I tried 2 such versions - 2.6.39-1 and 
> 2.6.38-2) I also get a weird error that 
> "<android_kernel_dir>//builddir/compat-wireless-XXX/net/wireless/db.txt 
> cannot be found" - the search path there is completely wrong, it 
> should either be <android_kernel_dir>" or 
> "/builddir/compat-wireless-XXX/net/wireless/db.txt" and not this weird 
> concatenated path containing both!
>
> Again, this only happens with the 2 releases prior to 3.x I tried and 
> only when I have "db.txt" and "genregdb.awk" from 3.3.1-1 manually 
> copied to net/wireless. Any help?
I've had somewhat limited success with this - I was able to build 
2.6.38-2 compat-wireless by manually copying "db.txt" as well as 
"genregdb.awk" to 
<android_kernel_dir>//builddir/compat-wireless-XXX/net/wireless (yeah, I 
created it manually) as well as forcing CONFIG_CRC7=y and 
CONFIG_WL12XX_PLATFORM_DATA=y.

"make modules-install" gives me 6 modules: compat, cfg80211, mac80211, 
wl1251, wl12xx_platform_data and wl1251_sdio. I "modprobe" them in that 
order, but then I get this error:

Compat-wireless backport release: compat-wireless-2.6.38.2-2
Backport based on linux-2.6-allstable.git v2.6.38.2
cfg80211: Calling CRDA to update world regulatory domain
cfg80211: World regulatory domain updated:
cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, 
max_eirp)
cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
***1 wl12xx_platform_data: module license 'unspecified' taints kernel.
***1 Disabling lock debugging due to kernel taint

***1 - this happens when I execute "modprobe wl12xx_platform_data". As 
evident from the above also, the firmware does not load either. Here is 
what I have:

localhost ~ # lsmod
Module                  Size  Used by    Tainted: P 
wl1251_sdio             3315  0
wl12xx_platform_data      540  1 wl1251_sdio
wl1251                 67238  1 wl1251_sdio
mac80211              199498  2 wl1251_sdio,wl1251
cfg80211              140370  2 wl1251,mac80211
compat                  3729  2 mac80211,cfg80211

localhost ~ # ls -las /etc/firmware/
     2 drwxr-xr-x    1 root     root          2048 Apr 22 00:18 .
     2 drwxr-xr-x    1 root     root          2048 Mar 28 00:33 ..
    14 -rw-r--r--    1 root     root         14087 Aug  1  2008 brf6300.bin
   190 -rw-r--r--    1 root     root        194188 Apr 21 23:07 
wl1251-fw.bin
     1 -rw-r--r--    1 root     root           752 Apr 21 23:07 
wl1251-nvs.bin

localhost ~ # iwconfig wlan0
wlan0     No such device

localhost ~ # iwconfig wlan0 power on
Error for wireless request "Set Power Management" (8B2D) :
    GET failed on device wlan0 ; No such device.

I have also tried to build the latest snapshot (tried the one from 21 
April 2012), but things there got a bit more messy - the ti drivers were 
indeed moved to the ti/ directory, the Makefile, however, after 
selecting "ti" (or any of the TI drivers - TI1251 or TI12XX) is 
completely empty. I did a bit of investigation and it turns out that the 
offending part of the code is in the select-driver script, which 
executes "egrep WL1251|WL12XX" on the original Makefile and since the 
Makefile CONFIG_* setting does not contain either of these values for 
the ti/ directory (it has something like CONFIG_TI_*) that results in an 
empty Makefile.

Even if I correct this and leave just the ti-related settings in that 
Makefile, I am still faced with my original problem I already pointed 
out above - wl1251, wl1251_sdio and wl12xx are not built - just compat, 
mac80211 and cfg80211 are compiled, so I am stuck - good and proper, again.

Luciano, anyone?

