Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:35399 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933489Ab0CMKYt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Mar 2010 05:24:49 -0500
Received: by bwz1 with SMTP id 1so1697297bwz.21
        for <linux-wireless@vger.kernel.org>; Sat, 13 Mar 2010 02:24:48 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Jan Martinek <honza@dp.fce.vutbr.cz>
Subject: Re: ISL3890, master mode, prism54 -> p54pci regression
Date: Sat, 13 Mar 2010 11:26:57 +0100
Cc: linux-wireless@vger.kernel.org
References: <4B9B43B0.1030801@dp.fce.vutbr.cz>
In-Reply-To: <4B9B43B0.1030801@dp.fce.vutbr.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Message-Id: <201003131126.57729.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 13 March 2010 08:50:08 Jan Martinek wrote:
> Hello,
> 
> I have been using prism54 driver and my PCI wireless card was working in 
> Master mode. After upgrade to kernel-2.6.32 there is no prism54 driver 
> so I switched to p54pci. The problem is that I cannot set the Master 
> mode anymore, I get this error:
> 
> # iwconfig wlan0 mode master
> Error for wireless request "Set Mode" (8B06) :
>      SET failed on device wlan0 ; Invalid argument.
> 
> This is my wireless card:
> 
> 03:05.0 Network controller: Intersil Corporation ISL3890 [Prism GT/Prism 
> Duette]/ISL3886 [Prism Javelin/Prism Xbow] (rev 01)
> 
> this is my kernel version: kernel-2.6.32.9-70.fc12.x86_64
> And here is what I found in dmesg:
> 
> cfg80211: World regulatory domain updated:
> 	(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
> 	(2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> 	(2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
> 	(2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
> 	(5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> 	(5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> p54pci 0000:03:05.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
> p54pci 0000:03:05.0: firmware: requesting isl3886pci
> phy0: p54 detected a LM86 firmware
> p54: rx_mtu reduced from 3240 to 2376
> phy0: FW rev 2.13.12.0 - Softmac protocol 5.9
> phy0: cryptographic accelerator WEP:YES, TKIP:YES, CCMP:YES
> phy0: hwaddr 00:60:b3:1c:41:e5, MAC:isl3890 RF:Frisbee
> phy0: Selected rate control algorithm 'minstrel'
> Registered led device: p54-phy0::assoc
> Registered led device: p54-phy0::tx
> Registered led device: p54-phy0::rx
> Registered led device: p54-phy0::radio
> p54pci 0000:03:05.0: is registered as 'phy0'
> cfg80211: Calling CRDA for country: CZ
> cfg80211: Regulatory domain changed to country: CZ
> 	(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
> 	(2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A, 2000 mBm)
> 	(5150000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2301 mBm)
> 	(5250000 KHz - 5350000 KHz @ 40000 KHz), (N/A, 2301 mBm)
> 	(5470000 KHz - 5725000 KHz @ 40000 KHz), (N/A, 3000 mBm)
> 
> Is there any possibility to set the master mode?

The mac80211 stack _outsourced_ most of the 802.11 management code,
so it can't operate in master mode all by itself.

Therefore you'll need hostapd.

We have an up-to-date wiki entry (+ some WPA(2) examples):
http://wireless.kernel.org/en/users/Documentation/hostapd


BTW: There are also back-ports of the mac80211-stack (+ drivers)
(aka compat-wireless). So, if you run into weird AP problems,
you know where to look for updates.

http://linuxwireless.org/en/users/Download

Regards,
	Chr

PS: What card do you have? Is it a Z-Com XG-600?
