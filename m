Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from viefep16-int.chello.at ([62.179.121.36]:11152 "EHLO
	viefep16-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757412Ab0CMIF2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Mar 2010 03:05:28 -0500
Received: from edge01.upcmail.net ([192.168.13.236])
          by viefep15-int.chello.at
          (InterMail vM.8.01.02.00 201-2260-120-20100118) with ESMTP
          id <20100313075012.DFOL16925.viefep15-int.chello.at@edge01.upcmail.net>
          for <linux-wireless@vger.kernel.org>;
          Sat, 13 Mar 2010 08:50:12 +0100
Message-ID: <4B9B43B0.1030801@dp.fce.vutbr.cz>
Date: Sat, 13 Mar 2010 08:50:08 +0100
From: Jan Martinek <honza@dp.fce.vutbr.cz>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: ISL3890, master mode, prism54 -> p54pci regression
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I have been using prism54 driver and my PCI wireless card was working in 
Master mode. After upgrade to kernel-2.6.32 there is no prism54 driver 
so I switched to p54pci. The problem is that I cannot set the Master 
mode anymore, I get this error:

# iwconfig wlan0 mode master
Error for wireless request "Set Mode" (8B06) :
     SET failed on device wlan0 ; Invalid argument.

This is my wireless card:

03:05.0 Network controller: Intersil Corporation ISL3890 [Prism GT/Prism 
Duette]/ISL3886 [Prism Javelin/Prism Xbow] (rev 01)

this is my kernel version: kernel-2.6.32.9-70.fc12.x86_64
And here is what I found in dmesg:

cfg80211: World regulatory domain updated:
	(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
	(2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
	(2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
	(2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
	(5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
	(5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
p54pci 0000:03:05.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
p54pci 0000:03:05.0: firmware: requesting isl3886pci
phy0: p54 detected a LM86 firmware
p54: rx_mtu reduced from 3240 to 2376
phy0: FW rev 2.13.12.0 - Softmac protocol 5.9
phy0: cryptographic accelerator WEP:YES, TKIP:YES, CCMP:YES
phy0: hwaddr 00:60:b3:1c:41:e5, MAC:isl3890 RF:Frisbee
phy0: Selected rate control algorithm 'minstrel'
Registered led device: p54-phy0::assoc
Registered led device: p54-phy0::tx
Registered led device: p54-phy0::rx
Registered led device: p54-phy0::radio
p54pci 0000:03:05.0: is registered as 'phy0'
cfg80211: Calling CRDA for country: CZ
cfg80211: Regulatory domain changed to country: CZ
	(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
	(2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A, 2000 mBm)
	(5150000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2301 mBm)
	(5250000 KHz - 5350000 KHz @ 40000 KHz), (N/A, 2301 mBm)
	(5470000 KHz - 5725000 KHz @ 40000 KHz), (N/A, 3000 mBm)

Is there any possibility to set the master mode?

Thank you,
Jan Martinek
