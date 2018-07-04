Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f182.google.com ([209.85.223.182]:35334 "EHLO
        mail-io0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932319AbeGDIDf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 4 Jul 2018 04:03:35 -0400
Received: by mail-io0-f182.google.com with SMTP id q4-v6so4091981iob.2
        for <linux-wireless@vger.kernel.org>; Wed, 04 Jul 2018 01:03:34 -0700 (PDT)
MIME-Version: 1.0
From: Jian-Hong Pan <jian-hong@endlessm.com>
Date: Wed, 4 Jul 2018 16:03:33 +0800
Message-ID: <CAPpJ_ed1oFQW_xmBtetP-ztoL7Z14T6akOSgKJ_8jxogdf3FWg@mail.gmail.com> (sfid-20180704_100421_694441_3352FDD6)
Subject: [BUG] staging: r8822be: RTL8822be can't find any wireless AP
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        "Frank A. Cancio Bello" <frank@generalsoftwareinc.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        devel@driverdev.osuosl.org, Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Upstreaming Team <linux@endlessm.com>,
        Colin Ian King <colin.king@canonical.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

We have an ASUS X530UN (Intel(R) Core(TM) i7-8550U CPU @ 1.80GHz)
laptop equipped with Realtek rtl8822be wireless which cannot find any
access point after WiFi is launched.

Realtek rtl8822be wireless' information:
dev@endless:~/linux-eos$ sudo lspci -nnvs 02:00.0
02:00.0 Network controller [0280]: Realtek Semiconductor Co., Ltd.
Device [10ec:b822] (rev ff) (prog-if ff)
!!! Unknown header type 7f
Kernel driver in use: r8822be
Kernel modules: r8822be

System always hits the error: "halmac_init_hal failed" in dmesg after
WiFi is launched.

[ 8.591333] r8822be: module is from the staging directory, the quality
is unknown, you have been warned.
[ 8.593122] r8822be 0000:02:00.0: enabling device (0000 -> 0003)
[ 8.669163] r8822be: Using firmware rtlwifi/rtl8822befw.bin
[ 9.289939] r8822be: rtlwifi: wireless switch is on
[ 10.056426] r8822be 0000:02:00.0 wlp2s0: renamed from wlan0
...
[ 11.952534] r8822be: halmac_init_hal failed
[ 11.955933] r8822be: halmac_init_hal failed
[ 11.956227] r8822be: halmac_init_hal failed
[ 22.007942] r8822be: halmac_init_hal failed

We noticed the r8822be module parameter "aspm"'s default value is 1.
Here is the parameter list of r8822be:
dev@endless:~$ sudo grep "" /sys/module/r8822be/parameters/*
/sys/module/r8822be/parameters/aspm:1
/sys/module/r8822be/parameters/debug_level:0
/sys/module/r8822be/parameters/debug_mask:0
/sys/module/r8822be/parameters/disable_watchdog:N
/sys/module/r8822be/parameters/dma64:N
/sys/module/r8822be/parameters/fwlps:Y
/sys/module/r8822be/parameters/ips:Y
/sys/module/r8822be/parameters/msi:Y
/sys/module/r8822be/parameters/swenc:N
/sys/module/r8822be/parameters/swlps:N

If I make a module options like "options r8822be aspm=0" which
disables ASPM and reboot, the WiFi works correctly.  It can find the
access points, then connects.
Here is the parameter list of r8822be:
dev@endless:~$ sudo grep "" /sys/module/r8822be/parameters/*
/sys/module/r8822be/parameters/aspm:0
/sys/module/r8822be/parameters/debug_level:0
/sys/module/r8822be/parameters/debug_mask:0
/sys/module/r8822be/parameters/disable_watchdog:N
/sys/module/r8822be/parameters/dma64:N
/sys/module/r8822be/parameters/fwlps:Y
/sys/module/r8822be/parameters/ips:Y
/sys/module/r8822be/parameters/msi:Y
/sys/module/r8822be/parameters/swenc:N
/sys/module/r8822be/parameters/swlps:N

This issue can be reproduced on Linux stable 4.16.17, 4.17.2 and
4.18.0-rc3. (I list versions that we have tried)

Besides, I also notice there is a comment in
drivers/staging/rtlwifi/rtl8822be/sw.c rtl8822be_init_aspm_vars
function.

/*
 * This setting works for those device with
 * backdoor ASPM setting such as EPHY setting.
 * 0 - Not support ASPM,
 * 1 - Support ASPM,
 * 2 - According to chipset.
 */

The value 2 for ASPM interests me.  It says "Enable or disable ASPM
according to chipset."
I tried the setting value 2 for ASPM.  Here is the parameter list of r8822be:
dev@endless:~$ sudo grep "" /sys/module/r8822be/parameters/*
/sys/module/r8822be/parameters/aspm:2
/sys/module/r8822be/parameters/debug_level:0
/sys/module/r8822be/parameters/debug_mask:0
/sys/module/r8822be/parameters/disable_watchdog:N
/sys/module/r8822be/parameters/dma64:N
/sys/module/r8822be/parameters/fwlps:Y
/sys/module/r8822be/parameters/ips:Y
/sys/module/r8822be/parameters/msi:Y
/sys/module/r8822be/parameters/swenc:N
/sys/module/r8822be/parameters/swlps:N

The value 2 for ASPM also works correctly on ASUS X530UN.

Jian-Hong Pan
