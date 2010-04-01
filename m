Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:53058 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755617Ab0DASiJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Apr 2010 14:38:09 -0400
Received: from [212.123.130.47] (helo=[10.0.0.8])
	by smtp-out2.tiscali.nl with esmtp (Exim)
	(envelope-from <thijsvanderkraan@telfort.nl>)
	id 1NxPHL-0008Lt-Hy
	for linux-wireless@vger.kernel.org; Thu, 01 Apr 2010 20:38:07 +0200
Subject: zd1211rw: 07b8:6001 is a ZD1211B, but also a ZD1211
From: Thijs van der Kraan <thijsvanderkraan@telfort.nl>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 01 Apr 2010 20:38:06 +0200
Message-ID: <1270147086.3616.10.camel@desktop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm very first post ever, I forgot the subject, so I'll continue under
this one.


I reply to my original question (see below) Gábor Stefanik wrote:
===========================================================
Are you sure this is a ZD1211B, not a regular ZD1211? Try changing the
USB ID definitions to mark this as a ZD1211.
===========================================================


You are right the Shuttle PN15G is a regular ZD1211 device.
I checked the kernel repository and found that the device type was
changed from ZD1211 to ZD1211B about 8 months ago ().
After some further investigation I found that the Shuttle PN18G uses the
same device id (07b8:6001) and it has the ZD1211B.

I patched and rebuild the module and now my PN15G works fine, even in
windows XP.

So the issue now becomes how can we handle both these devices?

I'm hoping there is some argument I could pass to the driver forcing it
to use either the ZD1211 or the ZD1211B.


Any help would be appreciated.

Thijs van der Kraan


Changeset:
===========================================================
http://www.kernel.org/hg/index.cgi/linux-2.6/rev/7e462be807d2

zd1211rw: 07b8:6001 is a ZD1211B

On a shuttle machine here we got 07b8:6001 device, handled by zd1211rw,
which does not work.
Scanning is OK but association does not work, we get "direct probe to AP
xxx timed out"

It appears that this simple patch makes the device work perfectly.

This id was already there in initial import of the driver so I don't
know if it has ever been
working as ZD1211 (which would mean they changed it and kept the
id :( ).

Signed-off-by: Pascal Terjan <pterjan@mandriva.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>

committer: John W. Linville <linville@tuxdriver.com>

author     Pascal Terjan <pterjan@mandriva.com>
date       Wed Jul 08 15:24:08 2009 -0400 (8 months ago)
parents    465d6763e75e
children   489564496656
files 	   drivers/net/wireless/zd1211rw/zd_usb.c
===========================================================


dmseg:
===========================================================
[ 2154.660027] usb 1-8: new high speed USB device using ehci_hcd and
address 4
[ 2154.810883] usb 1-8: configuration #1 chosen from 1 choice
[ 2154.881223] cfg80211: Calling CRDA to update world regulatory domain
[ 2154.969961] cfg80211: World regulatory domain updated:
[ 2154.969969] 	(start_freq - end_freq @ bandwidth), (max_antenna_gain,
max_eirp)
[ 2154.969976] 	(2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000
mBm)
[ 2154.969983] 	(2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000
mBm)
[ 2154.969989] 	(2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000
mBm)
[ 2154.969994] 	(5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000
mBm)
[ 2154.970000] 	(5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000
mBm)
[ 2155.100031] usb 1-8: reset high speed USB device using ehci_hcd and
address 4
[ 2155.300719] phy0: Selected rate control algorithm 'minstrel'
[ 2155.302066] zd1211rw 1-8:1.0: phy0
[ 2155.302105] usbcore: registered new interface driver zd1211rw
[ 2155.371470] usb 1-8: firmware: requesting zd1211/zd1211_ub
[ 2155.410947] usb 1-8: firmware: requesting zd1211/zd1211_uphr
[ 2155.517065] zd1211rw 1-8:1.0: firmware version 4605
[ 2155.557061] zd1211rw 1-8:1.0: zd1211 chip 07b8:6001 v4330 high
00-12-0e RF2959_RF pa0 g----
[ 2155.559415] cfg80211: Calling CRDA for country: JP
[ 2155.562999] cfg80211: Regulatory domain changed to country: JP
[ 2155.563006] 	(start_freq - end_freq @ bandwidth), (max_antenna_gain,
max_eirp)
[ 2155.563012] 	(2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[ 2155.563018] 	(2457000 KHz - 2482000 KHz @ 20000 KHz), (N/A, 2000 mBm)
[ 2155.563023] 	(2474000 KHz - 2494000 KHz @ 20000 KHz), (N/A, 2000 mBm)
[ 2155.563028] 	(4910000 KHz - 4930000 KHz @ 10000 KHz), (N/A, 2300 mBm)
[ 2155.563032] 	(4910000 KHz - 4990000 KHz @ 40000 KHz), (N/A, 2300 mBm)
[ 2155.563037] 	(4930000 KHz - 4950000 KHz @ 10000 KHz), (N/A, 2300 mBm)
[ 2155.563042] 	(5030000 KHz - 5045000 KHz @ 10000 KHz), (N/A, 2300 mBm)
[ 2155.563047] 	(5030000 KHz - 5090000 KHz @ 40000 KHz), (N/A, 2300 mBm)
[ 2155.563052] 	(5050000 KHz - 5060000 KHz @ 10000 KHz), (N/A, 2300 mBm)
[ 2155.563056] 	(5170000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[ 2155.563061] 	(5250000 KHz - 5330000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[ 2155.563066] 	(5490000 KHz - 5710000 KHz @ 40000 KHz), (N/A, 2300 mBm)
[ 2155.617648] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[ 2162.531010] wlan0: authenticate with AP 00:21:29:8b:3a:49
[ 2162.533014] wlan0: authenticated
[ 2162.533019] wlan0: associate with AP 00:21:29:8b:3a:49
[ 2162.535256] wlan0: RX AssocResp from 00:21:29:8b:3a:49 (capab=0x411
status=0 aid=1)
[ 2162.535262] wlan0: associated
[ 2162.536248] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[ 2173.120016] wlan0: no IPv6 routers present
===========================================================




On Sat, Mar 13, 2010 at 5:33 PM, Thijs van der Kraan
<thijsvanderkraan@telfort.nl> wrote:
> The zd1211rw does not work with the Shuttle PN15G (D-Link Corp. WL54).
> After the driver fails it also break the device for my windows XP
> install.
> To get it back in working order I have to physically re-plug it while
> windows is running, this is pretty annoying as the PN15G is meant to be,
> and is, built inside my shuttle box.
>
> I tried another device that uses the same driver, the ZyAIR G-220, and
> it works like a charm.
>
> - Is there a way to get the Shuttle PN15G working ?
> - Can prevent the driver from breaking my device, so it will remain
> working under windows XP.
>
>
> Thijs van de Kraan
>
>
> lsusb:
> ---------------
> Bus 001 Device 004: ID 0586:3401 ZyXEL Communications Corp. ZyAIR G-220
> Bus 001 Device 003: ID 07b8:6001 D-Link Corp. WL54
> Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
> Bus 005 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> Bus 004 Device 002: ID 04fc:05d8 Sunplus Technology Co., Ltd
> Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> Bus 002 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> ---------------
>
> dmesg (Shuttle PN15G):
> ---------------
> [    9.419022] zd1211rw 1-8:1.0: phy0
> [    9.419050] usbcore: registered new interface driver zd1211rw
> [   11.618783] usb 1-8: firmware: requesting zd1211/zd1211b_ub
> [   11.979913] usb 1-8: firmware version 0x4810 and device bootcode
> version 0x4721 differ
> [   11.979919] usb 1-8: firmware: requesting zd1211/zd1211b_ur
> [   12.184918] usb 1-8: firmware: requesting zd1211/zd1211b_uphr
> [   12.261522] zd1211rw 1-8:1.0: RF2959 is currently not supported for
> ZD1211B devices

Are you sure this is a ZD1211B, not a regular ZD1211? Try changing the
USB ID definitions to mark this as a ZD1211.

> [   12.263744] eth0: link down
> [   12.263950] ADDRCONF(NETDEV_UP): eth0: link is not ready
> [   14.491044] usb 1-8: firmware: requesting zd1211/zd1211b_ub
> [   14.496834] usb 1-8: firmware version 0x4810 and device bootcode
> version 0x4721 differ
> [   14.496841] usb 1-8: firmware: requesting zd1211/zd1211b_ur
> [   15.526035] usb 1-8: USB control request for firmware upload failed.
> Error number -110
> [   15.526049] zd1211rw 1-8:1.0: couldn't load firmware. Error number
> -110
>
> dmesg (ZyAIR G-220):
> ---------------
>
> [  283.920025] usb 1-4: new high speed USB device using ehci_hcd and
> address 4
> [  284.070953] usb 1-4: configuration #1 chosen from 1 choice
> [  284.200081] usb 1-4: reset high speed USB device using ehci_hcd and
> address 4
> [  284.351553] phy1: Selected rate control algorithm 'minstrel'
> [  284.352966] zd1211rw 1-4:1.0: phy1
> [  284.387607] usb 1-4: firmware: requesting zd1211/zd1211_ub
> [  284.422786] usb 1-4: firmware version 0x4330 and device bootcode
> version 0x4810 differ
> [  284.422796] usb 1-4: firmware: requesting zd1211/zd1211_ur
> [  284.446550] usb 1-4: firmware: requesting zd1211/zd1211_uphr
> [  284.528039] zd1211rw 1-4:1.0: firmware version 4605
> [  284.568044] zd1211rw 1-4:1.0: zd1211 chip 0586:3401 v4810 high
> 00-13-49 AL2230_RF pa0 -----
> [  284.570691] cfg80211: Calling CRDA for country: DE
> [  284.574176] cfg80211: Regulatory domain changed to country: DE
> [  284.574184]  (start_freq - end_freq @ bandwidth), (max_antenna_gain,
> max_eirp)
> [  284.574190]  (2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A, 2000 mBm)
> [  284.574195]  (5150000 KHz - 5350000 KHz @ 40000 KHz), (N/A, 2000 mBm)
> [  284.574200]  (5470000 KHz - 5725000 KHz @ 40000 KHz), (N/A, 2698 mBm)
> [  284.589627] ADDRCONF(NETDEV_UP): wlan1: link is not ready
> [  291.145078] wlan1: authenticate with AP 00:21:29:8b:3a:49
> [  291.146703] wlan1: authenticated
> [  291.146708] wlan1: associate with AP 00:21:29:8b:3a:49
> [  291.148944] wlan1: RX AssocResp from 00:21:29:8b:3a:49 (capab=0x411
> status=0 aid=2)
> [  291.148950] wlan1: associated
> [  291.149928] ADDRCONF(NETDEV_CHANGE): wlan1: link becomes ready
> [  301.720021] wlan1: no IPv6 routers present
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>







