Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.24]:56867 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755339AbaIQQdu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Sep 2014 12:33:50 -0400
Date: Wed, 17 Sep 2014 18:33:46 +0200
From: Heinz Diehl <htd+ml@fritha.org>
To: linux-wireless@vger.kernel.org
Subject: TX queue 2 DMA timed out, invoke forced forced reset
Message-ID: <20140917163346.GA9684@fritha.org> (sfid-20140917_183353_714098_18AE80B2)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

once in a while, I get those warnings in dmesg:

[....]
[   25.237842] ieee80211 phy1: rt2800usb_txdone: Warning - Data pending for entry 4 in queue 2 
[   49.444105] ieee80211 phy1: rt2x00usb_watchdog_tx_dma: Warning - TX queue 2 DMA timed out, invoke forced forced reset 
[   50.439536] ieee80211 phy1: rt2800usb_txdone: Warning - Data pending for entry 11 in queue 2 
[   50.443291] ieee80211 phy1: rt2x00usb_watchdog_tx_dma: Warning - TX queue 2 DMA timed out, invoke forced forced reset 
[   51.432610] ieee80211 phy1: rt2x00usb_watchdog_tx_dma: Warning - TX queue 2 DMA timed out, invoke forced forced reset 
[   52.442402] ieee80211 phy1: rt2x00usb_watchdog_tx_dma: Warning - TX queue 2 DMA timed out, invoke forced forced reset 
[   57.437047] ieee80211 phy1: rt2x00usb_watchdog_tx_dma: Warning - TX queue 2 DMA timed out, invoke forced forced reset 
[   58.438481] ieee80211 phy1: rt2x00usb_watchdog_tx_dma: Warning - TX queue 2 DMA timed out, invoke forced forced reset 
[   60.435439] ieee80211 phy1: rt2x00usb_watchdog_tx_dma: Warning - TX queue 2 DMA timed out, invoke forced forced reset 
[....]

Then, the connection gets creepingly slow and unuseable, and I have to
pull the network adapter and re-insert it to get it working again.

The network adapter is an Asus USB-N53:
Bus 002 Device 007: ID 148f:3573 Ralink Technology, Corp. RT3573 Wireless Adapter

[ 6265.112311] ieee80211 phy4: rt2x00_set_rt: Info - RT chipset 3572, rev 0223 detected
[ 6265.141134] ieee80211 phy4: rt2x00_set_rf: Info - RF chipset 0009 detected
[ 6265.141724] ieee80211 phy4: Selected rate control algorithm 'minstrel_ht'
[ 6265.159432] systemd-udevd[9784]: renamed network interface wlan0 to wlp0s29u1u1
[ 6265.166219] ieee80211 phy4: rt2x00lib_request_firmware: Info -Loading firmware file 'rt2870.bin'
[ 6265.166264] ieee80211 phy4: rt2x00lib_request_firmware: Info -Firmware detected - version: 0.29

[root@kiera log]# lsmod | grep ^rt
rt2800usb              27189  0 
rt2800lib              86717  1 rt2800usb
rt2x00usb              19835  1 rt2800usb
rt2x00lib              52760  3 rt2x00usb,rt2800lib,rt2800usb

[root@kiera log]# uname -a
Linux kiera.fritha.org 3.16.3-rc1 #2 SMP PREEMPT Tue Sep 16 11:21:20 CEST 2014 x86_64 x86_64 x86_64 GNU/Linux

(The same happens with 3.17-rc5).

Could this simply be a driver bug, or why could it be that the adapter
disbehaves this way?

Thanks,
 Heinz.

P.S.: Please Cc: me, since I'm not subscribed to linux-wireless.




