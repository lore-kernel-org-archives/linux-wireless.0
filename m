Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f198.google.com ([209.85.216.198]:33177 "EHLO
	mail-px0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933489Ab0CMKLP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Mar 2010 05:11:15 -0500
Received: by pxi36 with SMTP id 36so1128702pxi.21
        for <linux-wireless@vger.kernel.org>; Sat, 13 Mar 2010 02:11:15 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B9B43B0.1030801@dp.fce.vutbr.cz>
References: <4B9B43B0.1030801@dp.fce.vutbr.cz>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Sat, 13 Mar 2010 02:10:55 -0800
Message-ID: <43e72e891003130210r8df9a1bnb9fddc25df951116@mail.gmail.com>
Subject: Re: ISL3890, master mode, prism54 -> p54pci regression
To: Jan Martinek <honza@dp.fce.vutbr.cz>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/3/12 Jan Martinek <honza@dp.fce.vutbr.cz>:
> Hello,
>
> I have been using prism54 driver and my PCI wireless card was working in
> Master mode. After upgrade to kernel-2.6.32 there is no prism54 driver so I
> switched to p54pci. The problem is that I cannot set the Master mode
> anymore, I get this error:
>
> # iwconfig wlan0 mode master
> Error for wireless request "Set Mode" (8B06) :
>    SET failed on device wlan0 ; Invalid argument.
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
>        (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
>        (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
>        (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
>        (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
>        (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
>        (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
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
>        (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
>        (2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A, 2000 mBm)
>        (5150000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2301 mBm)
>        (5250000 KHz - 5350000 KHz @ 40000 KHz), (N/A, 2301 mBm)
>        (5470000 KHz - 5725000 KHz @ 40000 KHz), (N/A, 3000 mBm)
>
> Is there any possibility to set the master mode?

p54pci uses mac80211 and for all mac80211 drivers you need to use the
hostapd nl80211 driver. You cannot use wext on mac80211 drivers for AP
mode. Read this:

http://wireless.kernel.org/en/users/Documentation/hostapd

  Luis
