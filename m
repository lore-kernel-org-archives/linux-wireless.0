Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:58764 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751807Ab2DBLfJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Apr 2012 07:35:09 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1SEfXQ-0003vz-6W
	for linux-wireless@vger.kernel.org; Mon, 02 Apr 2012 13:35:08 +0200
Received: from linuxconsulting.iasi.rdsnet.ro ([86.124.39.167])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 02 Apr 2012 13:35:08 +0200
Received: from npavel by linuxconsulting.iasi.rdsnet.ro with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 02 Apr 2012 13:35:08 +0200
To: linux-wireless@vger.kernel.org
From: Nicu Pavel <npavel@mini-box.com>
Subject: Re: Problem with the rtl8192cu - kernelmodule after ifdown, ifup
Date: Mon, 2 Apr 2012 11:32:57 +0000 (UTC)
Message-ID: <loom.20120402T132942-864@post.gmane.org> (sfid-20120402_133516_101526_CE2B56DA)
References: <4F0EEA1B.3040501@wut.de> <4F0FA4DD.5020601@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,
> On 01/12/2012 08:11 AM, Markus Königshaus wrote:
> > Hello,
> >
> > I am using a USB WLAN - Stick with Realtek 8192 kernel driver. After 
plugging it
> > works fine, connecting to a WPA - network works. After ifdown wlan0, ifup 
wlan0
> > the stick no longer works , it stucks on scanning. Only a modprobe -r 
rtl8192cu;
> > modprobe rtl8192cu fixes the problem. The problem only appear if more than 
one
> > wireless - network is in range.The problem appear only in connection with 
the
> > rtl8192cu driver, other USB - sticks (with different Chipset) and other PCIE 
-
> > boards operate properly.
> > In order to reproduce the behavior repeat the sequenceifdown wlan0, ifup 
wlan0 a
> > few times.
> >
> > wpa_cli status->
> > Selected interface 'wlan0'
> > wpa_state=SCANNING
> > < no change after 10 minutes>
> >
> > dmesg ->
> > rtl8192cu: MAC auto ON okay!
> > rtl8192cu: Tx queue select: 0x05
> > rtl8192c_common: Loading firmware file rtlwifi/rtl8192cufw.bin
> > wlan0: authenticate with 00:08:54:9a:b2:5f (try 1)
> > wlan0: authenticated
> > wlan0: associate with 00:08:54:9a:b2:5f (try 1)
> > wlan0: RX AssocResp from 00:08:54:9a:b2:5f (capab=0x411 status=0 aid=1)
> > wlan0: associated
> > < ifdown wlan0 >
> > wlan0: disassociated from 00:08:54:9a:b2:5f (Reason: 14)
> > wlan0: deauthenticating from 00:08:54:9a:b2:5f by local choice (reason=3)
> > cfg80211: Calling CRDA for country: US
> > rtl8192cu: MAC auto ON okay!
> > rtl8192cu: Tx queue select: 0x05
> > rtl8192c_common: Loading firmware file rtlwifi/rtl8192cufw.bin
> > < ifup wlan0 >
> > rtl8192cu: MAC auto ON okay!
> > rtl8192cu: Tx queue select: 0x05
> > rtl8192c_common: Loading firmware file rtlwifi/rtl8192cufw.bin
> >
> >
> > cat /sys/class/net/wlan0/carrier -> 0
> > cat /sys/class/net/wlan0/operstate -> down
> >
> > Kernelversion: 3.1.8
> >
> > modinfo rtl8192cu->
> > filename: kernel/drivers/net/wireless/rtlwifi/rtl8192cu/rtl8192cu.ko
> > description: Realtek 8192C/8188C 802.11n USB wireless
> > author: Larry Finger <Larry.Finger@...>
> > author: Georgia <georgia@...>
> > license: GPL
> > vermagic: 3.1.8-WuT preempt mod_unload ARMv5
> > firmware: rtlwifi/rtl8192cufw.bin
> > depends: rtlwifi,rtl8192c-common
> >
> > lsusb ->
> > Bus 001 Device 001: ID 1d6b:0002
> > Bus 001 Device 003: ID 0bda:8176
> 
> I will try to duplicate your results; however,there are two things I would 
like 
> you to try. First is to get a copy of the bleeding-edge compat-wireless code, 
> build and install the package, and test to see if it still fails. If it does, 
I 
> want you to load the driver with a 'debug=4' option. In other words, use
> 
> modprobe -v rtl8192cu debug=4
> 
> Then, after a failure occurs, send me the output of a dmesg command.

I'm having the same behavior, on a 3.1 kernel tested with 2 USB Realtek 8192cu 
sticks.
However I'm unable to test with the latest compat-wireless because it's crashing 
when I load the rtl8192cu module.


Compat-wireless backport release: compat-wireless-2012-03-14-2-g7bfa0a3
Backport based on linux-next.git next-20120316
<6>cfg80211: Calling CRDA to update world regulatory domain
<6>rtl8192cu: Chip version 0x10
<6>rtl8192cu: MAC address: 80:1f:02:1b:d7:b1
<6>rtl8192cu: Board Type 0
<6>rtl8192cu: Loading firmware rtlwifi/rtl8192cufw.bin
<4>------------[ cut here ]------------
<4>WARNING: at /indevel/minibox-android/android-kernel/minibox-kernel-
modules/compat-wireless-2012-03-18/net/wireless/core.c:577 
wiphy_register+0x19c/0x494 )
<4>Modules linked in: rtl8192cu(+) rtl8192c_common rtlwifi mac80211 cfg80211 
compat
<4>Backtrace: 
<4>[<c00128ec>] (dump_backtrace+0x0/0x110) from [<c0012e34>] 
(dump_stack+0x18/0x1c)
<4> r6:bf04dbe8 r5:bf0699ac r4:00000241
<4>[<c0012e1c>] (dump_stack+0x0/0x1c) from [<c0021334>] 
(warn_slowpath_common+0x58/0x70)
<4>[<c00212dc>] (warn_slowpath_common+0x0/0x70) from [<c0021370>] 
(warn_slowpath_null+0x24/0x2c)
<4> r8:00000000 r7:00000820 r6:00000040 r5:bf06b840 r4:c27fc0e0
<4>[<c002134c>] (warn_slowpath_null+0x0/0x2c) from [<bf04dbe8>] 
(wiphy_register+0x19c/0x494 [cfg80211])
<4>[<bf04da4c>] (wiphy_register+0x0/0x494 [cfg80211]) from [<bf07f628>] 
(ieee80211_register_hw+0x43c/0x688 [mac80211])
<4>[<bf07f1ec>] (ieee80211_register_hw+0x0/0x688 [mac80211]) from [<bf0cb3c0>] 
(rtl_fw_cb+0x8c/0xd0 [rtlwifi])
<4>[<bf0cb334>] (rtl_fw_cb+0x0/0xd0 [rtlwifi]) from [<c01b79d4>] 
(request_firmware_work_func+0x5c/0x7c)
<4> r7:c01b7978 r6:c27b8be0 r5:00000000 r4:c27b8be0
<4>[<c01b7978>] (request_firmware_work_func+0x0/0x7c) from [<c003a174>] 
(kthread+0x88/0x90)
<4> r5:cec43d30 r4:c27f9fcc
<4>[<c003a0ec>] (kthread+0x0/0x90) from [<c00248a0>] (do_exit+0x0/0x634)
<4> r7:00000013 r6:c00248a0 r5:c003a0ec r4:cec43d30
<4>---[ end trace 5941e5b8e919d8dc ]---
<6>rtlwifi: rx_max_size 15360, rx_urb_num 8, in_ep 1
<6>usbcore: registered new interface driver rtl8192cu

Thanks,
Nicu


> 
> Larry
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@...
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 




