Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:19372 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934801Ab0CMSop convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Mar 2010 13:44:45 -0500
Received: by fg-out-1718.google.com with SMTP id l26so798181fgb.1
        for <linux-wireless@vger.kernel.org>; Sat, 13 Mar 2010 10:44:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1268497994.2475.12.camel@desktop>
References: <1268497994.2475.12.camel@desktop>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Sat, 13 Mar 2010 19:44:23 +0100
Message-ID: <69e28c911003131044o4747dd88yd9aa90167b4a583f@mail.gmail.com>
Subject: Re:
To: Thijs van der Kraan <thijsvanderkraan@telfort.nl>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

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
> [    9.419022] zd1211rw 1-8:1.0: phy0
> [    9.419050] usbcore: registered new interface driver zd1211rw
> [   11.618783] usb 1-8: firmware: requesting zd1211/zd1211b_ub
> [   11.979913] usb 1-8: firmware version 0x4810 and device bootcode
> version 0x4721 differ
> [   11.979919] usb 1-8: firmware: requesting zd1211/zd1211b_ur
> [   12.184918] usb 1-8: firmware: requesting zd1211/zd1211b_uphr
> [   12.261522] zd1211rw 1-8:1.0: RF2959 is currently not supported for
> ZD1211B devices

Are you sure this is a ZD1211B, not a regular ZD1211? Try changing the
USB ID definitions to mark this as a ZD1211.

> [   12.263744] eth0: link down
> [   12.263950] ADDRCONF(NETDEV_UP): eth0: link is not ready
> [   14.491044] usb 1-8: firmware: requesting zd1211/zd1211b_ub
> [   14.496834] usb 1-8: firmware version 0x4810 and device bootcode
> version 0x4721 differ
> [   14.496841] usb 1-8: firmware: requesting zd1211/zd1211b_ur
> [   15.526035] usb 1-8: USB control request for firmware upload failed.
> Error number -110
> [   15.526049] zd1211rw 1-8:1.0: couldn't load firmware. Error number
> -110
>
> dmesg (ZyAIR G-220):
> ---------------
>
> [  283.920025] usb 1-4: new high speed USB device using ehci_hcd and
> address 4
> [  284.070953] usb 1-4: configuration #1 chosen from 1 choice
> [  284.200081] usb 1-4: reset high speed USB device using ehci_hcd and
> address 4
> [  284.351553] phy1: Selected rate control algorithm 'minstrel'
> [  284.352966] zd1211rw 1-4:1.0: phy1
> [  284.387607] usb 1-4: firmware: requesting zd1211/zd1211_ub
> [  284.422786] usb 1-4: firmware version 0x4330 and device bootcode
> version 0x4810 differ
> [  284.422796] usb 1-4: firmware: requesting zd1211/zd1211_ur
> [  284.446550] usb 1-4: firmware: requesting zd1211/zd1211_uphr
> [  284.528039] zd1211rw 1-4:1.0: firmware version 4605
> [  284.568044] zd1211rw 1-4:1.0: zd1211 chip 0586:3401 v4810 high
> 00-13-49 AL2230_RF pa0 -----
> [  284.570691] cfg80211: Calling CRDA for country: DE
> [  284.574176] cfg80211: Regulatory domain changed to country: DE
> [  284.574184]  (start_freq - end_freq @ bandwidth), (max_antenna_gain,
> max_eirp)
> [  284.574190]  (2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A, 2000 mBm)
> [  284.574195]  (5150000 KHz - 5350000 KHz @ 40000 KHz), (N/A, 2000 mBm)
> [  284.574200]  (5470000 KHz - 5725000 KHz @ 40000 KHz), (N/A, 2698 mBm)
> [  284.589627] ADDRCONF(NETDEV_UP): wlan1: link is not ready
> [  291.145078] wlan1: authenticate with AP 00:21:29:8b:3a:49
> [  291.146703] wlan1: authenticated
> [  291.146708] wlan1: associate with AP 00:21:29:8b:3a:49
> [  291.148944] wlan1: RX AssocResp from 00:21:29:8b:3a:49 (capab=0x411
> status=0 aid=2)
> [  291.148950] wlan1: associated
> [  291.149928] ADDRCONF(NETDEV_CHANGE): wlan1: link becomes ready
> [  301.720021] wlan1: no IPv6 routers present
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
