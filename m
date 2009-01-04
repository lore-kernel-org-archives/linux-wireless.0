Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from generic.ettema.net ([82.95.246.81]:55835 "EHLO
	generic.ettema.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475AbZADWzc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Jan 2009 17:55:32 -0500
Received: from me.ettema.net ([2001:888:1730:0:21d:7dff:fe0a:182a])
	by generic.ettema.net with esmtpsa (Exim 5.12)
	id 1LJbBI-0001KI-Lf
	for <linux-wireless@vger.kernel.org>; Sun, 04 Jan 2009 23:10:55 +0100
From: Michiel <michiel@ettema.net>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain
Date: Sun, 04 Jan 2009 23:10:45 +0100
Message-Id: <1231107045.26702.33.camel@ME> (sfid-20090104_235536_871645_FE286E09)
Mime-Version: 1.0
Subject: Adding usb id of Thomson 121G wireless usb adapter to P54 driver
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

Since Michael Wu's mailbox seems to have overflowed also to this list.

I have a Thomson wireless USB adapter, type SpeedTouch 121g. This
adapter uses the Prism chipset but the USB device ID is not present in
p54usb.c. After I added the ID to this file and recompiled, the adapter
worked fine. Can this ID be added permanently to the driver ? If any
additional information is needed I'd gladly arrange for that.

Regards,

Michiel

Commercial datasheet of the adapter:
http://www.tijdhof.com/docs/datasheet121g.pdf

Patch:

--- linux-2.6.28/drivers/net/wireless/p54/p54usb.c.orig 2008-12-25
00:26:37.000000000 +0100
+++ linux-2.6.28/drivers/net/wireless/p54/p54usb.c      2009-01-04
20:41:11.000000000 +0100
@@ -54,6 +54,7 @@ static struct usb_device_id p54u_table[]
        {USB_DEVICE(0x050d, 0x7050)},   /* Belkin F5D7050 ver 1000 */
        {USB_DEVICE(0x0572, 0x2000)},   /* Cohiba Proto board */
        {USB_DEVICE(0x0572, 0x2002)},   /* Cohiba Proto board */
+       {USB_DEVICE(0x06b9, 0x0121)},   /* Thomson SpeedTouch 121g */
        {USB_DEVICE(0x0707, 0xee13)},   /* SMC 2862W-G version 2 */
        {USB_DEVICE(0x083a, 0x4521)},   /* Siemens Gigaset USB Adapter
54
version 2 */
        {USB_DEVICE(0x0846, 0x4240)},   /* Netgear WG111 (v2) */
 


dmesg output after adding the ID:

[  110.548194] usb 3-1: new high speed USB device using ehci_hcd and
address 2
[  110.735339] usb 3-1: configuration #1 chosen from 1 choice
[  111.382681] cfg80211: Using static regulatory domain info
[  111.382690] cfg80211: Regulatory domain: US
[  111.382696]  (start_freq - end_freq @ bandwidth), (max_antenna_gain,
max_eirp)
[  111.382706]  (2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2700
mBm)
[  111.382714]  (5170000 KHz - 5190000 KHz @ 40000 KHz), (600 mBi, 2300
mBm)
[  111.382722]  (5190000 KHz - 5210000 KHz @ 40000 KHz), (600 mBi, 2300
mBm)
[  111.382730]  (5210000 KHz - 5230000 KHz @ 40000 KHz), (600 mBi, 2300
mBm)
[  111.382739]  (5230000 KHz - 5330000 KHz @ 40000 KHz), (600 mBi, 2300
mBm)
[  111.382747]  (5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, 3000
mBm)
[  111.382754] cfg80211: Calling CRDA for country: US
[  111.525337] usb 3-1: firmware: requesting isl3887usb_bare
[  111.542469] p54: LM86 firmware
[  111.542474] p54: FW rev 2.5.8.0 - Softmac protocol 3.0
[  111.982602] p54: unknown eeprom code : 0x1
[  111.982611] p54: unknown eeprom code : 0x3
[  111.982617] p54: unknown eeprom code : 0x1905
[  111.982630] p54: unknown eeprom code : 0x1007
[  111.982636] p54: unknown eeprom code : 0x1008
[  111.982641] p54: unknown eeprom code : 0x1100
[  111.982653] phy0: hwaddr 00:12:bf:08:4c:d4, MAC:isl3887 RF:Frisbee
[  111.993155] phy0: Selected rate control algorithm 'pid'
[  112.171837] usbcore: registered new interface driver p54usb
[  116.302327] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[  117.056530] wlan0: direct probe to AP 00:1b:fc:8f:12:87 try 1
[  117.256060] wlan0: direct probe to AP 00:1b:fc:8f:12:87 try 2
[  117.456077] wlan0: direct probe to AP 00:1b:fc:8f:12:87 try 3
[  117.656077] wlan0: direct probe to AP 00:1b:fc:8f:12:87 timed out
[  122.706655] wlan0: authenticate with AP 00:1d:68:6f:cd:5b
[  122.709314] wlan0: authenticated
[  122.709324] wlan0: associate with AP 00:1d:68:6f:cd:5b
[  122.711921] wlan0: RX AssocResp from 00:1d:68:6f:cd:5b (capab=0x431
status=0 aid=2)
[  122.711929] wlan0: associated
[  122.715106] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[  183.069232] wlan0 direct probe responded
[  183.069247] wlan0: authenticate with AP 00:1d:68:6f:cd:5b
[  183.071075] wlan0: authenticated
[  183.071084] wlan0: associate with AP 00:1d:68:6f:cd:5b
[  183.076489] wlan0: RX ReassocResp from 00:1d:68:6f:cd:5b (capab=0x431
status=0 aid=2)
[  183.076497] wlan0: associated
[  193.082193] wlan0: disassociating by local choice (reason=3)
[  193.774448] wlan0: authenticate with AP 00:1d:68:6f:cd:5b
[  193.779684] wlan0: authenticated
[  193.779695] wlan0: associate with AP 00:1d:68:6f:cd:5b
[  193.782318] wlan0: RX ReassocResp from 00:1d:68:6f:cd:5b (capab=0x431
status=0 aid=2)
[  193.782326] wlan0: associated
[  535.159295] usb 3-1: USB disconnect, address 2
[  569.173285] ADDRCONF(NETDEV_UP): eth1: link is not ready
[  569.516699] ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready


