Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:52804 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932219Ab3BKVot (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Feb 2013 16:44:49 -0500
Received: by mail-wg0-f42.google.com with SMTP id 12so2803787wgh.1
        for <linux-wireless@vger.kernel.org>; Mon, 11 Feb 2013 13:44:48 -0800 (PST)
Message-ID: <5119664D.9030902@gmail.com> (sfid-20130211_224454_184955_9CFC30F2)
Date: Mon, 11 Feb 2013 22:44:45 +0100
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
MIME-Version: 1.0
To: "users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: rt2800usb_txdone_entry_check: Warning - TX status report missed for
 queue XX entry ZZ
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi,

( 3.7.6-102.fc17.x86_64 + compat-drivers-3.8-rc7-1 )

with this device:
usb 2-1.5: new high-speed USB device number 9 using ehci_hcd
usb 2-1.5: New USB device found, idVendor=148f, idProduct=5370
usb 2-1.5: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 2-1.5: Product: 802.11 n WLAN
usb 2-1.5: Manufacturer: Ralink
usb 2-1.5: SerialNumber: 1.0
usb 2-1.5: reset high-speed USB device number 9 using ehci_hcd
phy4 -> rt2x00_set_chip: Info - Chipset detected - rt: 5390, rf: 5370, rev: 0502.
ieee80211 phy4: Selected rate control algorithm 'minstrel_ht'
Registered led device: rt2800usb-phy4::radio
Registered led device: rt2800usb-phy4::assoc
Registered led device: rt2800usb-phy4::quality
phy4 -> rt2x00lib_request_firmware: Info - Loading firmware file 'rt2870.bin'.
phy4 -> rt2x00lib_request_firmware: Info - Firmware detected - version: 0.33.
phy4 -> rt2x00mac_conf_tx: Info - Configured TX queue 0 - CWmin: 4, CWmax: 10, Aifs: 2, TXop: 0.
phy4 -> rt2x00mac_conf_tx: Info - Configured TX queue 1 - CWmin: 4, CWmax: 10, Aifs: 2, TXop: 0.
phy4 -> rt2x00mac_conf_tx: Info - Configured TX queue 2 - CWmin: 4, CWmax: 10, Aifs: 2, TXop: 0.
phy4 -> rt2x00mac_conf_tx: Info - Configured TX queue 3 - CWmin: 4, CWmax: 10, Aifs: 2, TXop: 0.

and debug enabled, I see a lot of:
Feb 11 22:34:28 chuchi kernel: [  935.675466] phy5 -> rt2800usb_txdone_entry_check: Warning - TX status report missed for queue 2 entry 7
Feb 11 22:34:29 chuchi kernel: [  935.745710] phy5 -> rt2800usb_txdone_entry_check: Warning - TX status report missed for queue 2 entry 11
Feb 11 22:34:29 chuchi kernel: [  935.747333] phy5 -> rt2800usb_txdone_entry_check: Warning - TX status report missed for queue 2 entry 12
Feb 11 22:34:29 chuchi kernel: [  936.019967] phy5 -> rt2800usb_txdone_entry_check: Warning - TX status report missed for queue 2 entry 8
Feb 11 22:34:29 chuchi kernel: [  936.020076] phy5 -> rt2800usb_txdone_entry_check: Warning - TX status report missed for queue 2 entry 9
Feb 11 22:34:29 chuchi kernel: [  936.096074] phy5 -> rt2800usb_txdone_entry_check: Warning - TX status report missed for queue 2 entry 5
Feb 11 22:34:29 chuchi kernel: [  936.098823] phy5 -> rt2800usb_txdone_entry_check: Warning - TX status report missed for queue 2 entry 6
Feb 11 22:34:29 chuchi kernel: [  936.149845] phy5 -> rt2800usb_txdone_entry_check: Warning - TX status report missed for queue 2 entry 10
Feb 11 22:34:29 chuchi kernel: [  936.150821] phy5 -> rt2800usb_txdone_entry_check: Warning - TX status report missed for queue 2 entry 15
Feb 11 22:34:29 chuchi kernel: [  936.265444] phy5 -> rt2800usb_txdone_entry_check: Warning - TX status report missed for queue 2 entry 10
Feb 11 22:34:29 chuchi kernel: [  936.265607] phy5 -> rt2800usb_txdone_entry_check: Warning - TX status report missed for queue 2 entry 11
Feb 11 22:34:29 chuchi kernel: [  936.266106] phy5 -> rt2800usb_txdone_entry_check: Warning - TX status report missed for queue 2 entry 12
Feb 11 22:34:29 chuchi kernel: [  936.266943] phy5 -> rt2800usb_txdone_entry_check: Warning - TX status report missed for queue 2 entry 13
Feb 11 22:34:29 chuchi kernel: [  936.267817] phy5 -> rt2800usb_txdone_entry_check: Warning - TX status report missed for queue 2 entry 14
Feb 11 22:34:29 chuchi kernel: [  936.268693] phy5 -> rt2800usb_txdone_entry_check: Warning - TX status report missed for queue 2 entry 15
Feb 11 22:34:29 chuchi kernel: [  936.269569] phy5 -> rt2800usb_txdone_entry_check: Warning - TX status report missed for queue 2 entry 0
Feb 11 22:34:29 chuchi kernel: [  936.270441] phy5 -> rt2800usb_txdone_entry_check: Warning - TX status report missed for queue 2 entry 1
Feb 11 22:34:29 chuchi kernel: [  936.271315] phy5 -> rt2800usb_txdone_entry_check: Warning - TX status report missed for queue 2 entry 2
Feb 11 22:34:29 chuchi kernel: [  936.272192] phy5 -> rt2800usb_txdone_entry_check: Warning - TX status report missed for queue 2 entry 3
Feb 11 22:34:29 chuchi kernel: [  936.404580] phy5 -> rt2800usb_txdone_entry_check: Warning - TX status report missed for queue 2 entry 8
Feb 11 22:34:29 chuchi kernel: [  936.404702] phy5 -> rt2800usb_txdone_entry_check: Warning - TX status report missed for queue 2 entry 9
Feb 11 22:34:29 chuchi kernel: [  936.404826] phy5 -> rt2800usb_txdone_entry_check: Warning - TX status report missed for queue 2 entry 10
Feb 11 22:34:29 chuchi kernel: [  936.404952] phy5 -> rt2800usb_txdone_entry_check: Warning - TX status report missed for queue 2 entry 11
Feb 11 22:34:29 chuchi kernel: [  936.405063] phy5 -> rt2800usb_txdone_entry_check: Warning - TX status report missed for queue 2 entry 12
Feb 11 22:34:29 chuchi kernel: [  936.405185] phy5 -> rt2800usb_txdone_entry_check: Warning - TX status report missed for queue 2 entry 13
Feb 11 22:34:29 chuchi kernel: [  936.405310] phy5 -> rt2800usb_txdone_entry_check: Warning - TX status report missed for queue 2 entry 14
Feb 11 22:34:29 chuchi kernel: [  936.408937] phy5 -> rt2800usb_txdone_entry_check: Warning - TX status report missed for queue 2 entry 0
Feb 11 22:34:29 chuchi kernel: [  936.409440] phy5 -> rt2800usb_txdone_entry_check: Warning - TX status report missed for queue 2 entry 1
Feb 11 22:34:29 chuchi kernel: [  936.410687] phy5 -> rt2800usb_txdone_entry_check: Warning - TX status report missed for queue 2 entry 2
Feb 11 22:34:29 chuchi kernel: [  936.411562] phy5 -> rt2800usb_txdone_entry_check: Warning - TX status report missed for queue 2 entry 3
Feb 11 22:34:29 chuchi kernel: [  936.412437] phy5 -> rt2800usb_txdone_entry_check: Warning - TX status report missed for queue 2 entry 4
Feb 11 22:34:29 chuchi kernel: [  936.413310] phy5 -> rt2800usb_txdone_entry_check: Warning - TX status report missed for queue 2 entry 5
Feb 11 22:34:29 chuchi kernel: [  936.494060] phy5 -> rt2800usb_txdone_entry_check: Warning - TX status report missed for queue 2 entry 4
Feb 11 22:34:29 chuchi kernel: [  936.494183] phy5 -> rt2800usb_txdone_entry_check: Warning - TX status report missed for queue 2 entry 5
Feb 11 22:34:29 chuchi kernel: [  936.561721] phy5 -> rt2800usb_txdone_entry_check: Warning - TX status report missed for queue 2 entry 7
Feb 11 22:34:29 chuchi kernel: [  936.561808] phy5 -> rt2800usb_txdone_entry_check: Warning - TX status report missed for queue 2 entry 8
Feb 11 22:34:29 chuchi kernel: [  936.606682] phy5 -> rt2800usb_txdone_entry_check: Warning - TX status report missed for queue 2 entry 5
Feb 11 22:34:29 chuchi kernel: [  936.606846] phy5 -> rt2800usb_txdone_entry_check: Warning - TX status report missed for queue 2 entry 6
Feb 11 22:34:29 chuchi kernel: [  936.607681] phy5 -> rt2800usb_txdone_entry_check: Warning - TX status report missed for queue 2 entry 7
Feb 11 22:34:29 chuchi kernel: [  936.608550] phy5 -> rt2800usb_txdone_entry_check: Warning - TX status report missed for queue 2 entry 8
Feb 11 22:34:29 chuchi kernel: [  936.609430] phy5 -> rt2800usb_txdone_entry_check: Warning - TX status report missed for queue 2 entry 9
Feb 11 22:34:29 chuchi kernel: [  936.610303] phy5 -> rt2800usb_txdone_entry_check: Warning - TX status report missed for queue 2 entry 10
Feb 11 22:34:29 chuchi kernel: [  936.611554] phy5 -> rt2800usb_txdone_entry_check: Warning - TX status report missed for queue 2 entry 11
Feb 11 22:34:29 chuchi kernel: [  936.612431] phy5 -> rt2800usb_txdone_entry_check: Warning - TX status report missed for queue 2 entry 12
Feb 11 22:34:29 chuchi kernel: [  936.613304] phy5 -> rt2800usb_txdone_entry_check: Warning - TX status report missed for queue 2 entry 13
Feb 11 22:34:29 chuchi kernel: [  936.697053] phy5 -> rt2800usb_txdone_entry_check: Warning - TX status report missed for queue 2 entry 5
Feb 11 22:34:29 chuchi kernel: [  936.697177] phy5 -> rt2800usb_txdone_entry_check: Warning - TX status report missed for queue 2 entry 6
Feb 11 22:34:30 chuchi kernel: [  936.808551] phy5 -> rt2800usb_txdone_entry_check: Warning - TX status report missed for queue 2 entry 0
