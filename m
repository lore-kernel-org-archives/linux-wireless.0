Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:36486 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752573Ab1K1P7O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Nov 2011 10:59:14 -0500
Received: by eaak14 with SMTP id k14so1936794eaa.19
        for <linux-wireless@vger.kernel.org>; Mon, 28 Nov 2011 07:59:13 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4ED3A6E8.4050000@aol.com>
References: <4ED3A6E8.4050000@aol.com>
Date: Mon, 28 Nov 2011 16:59:13 +0100
Message-ID: <CACna6ryNkHeVXWXxFfod1-KQs8HQVv7wF-xpY5MA-Qs6fCypCg@mail.gmail.com> (sfid-20111128_165919_708039_884E4249)
Subject: Re: Trouble with Macbook Pro 8,2 (broadcom 4331) and latest b43
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: AndrewL733 <AndrewL733@aol.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/11/28 AndrewL733 <AndrewL733@aol.com>:
> Hi,
>
> ----------------------
> I'm apologize in advance if this posting repeats another posting I made on
> 26 Nov.  I submitted it but don't see it in the archives. I'm thinking it
> never arrived so I am sending it again.
> -----------------------
>
> I'm wondering if anybody has any clues about why I cannot get a Broadcom
> 4331-based wireless device to work in my Macbook Pro (Model 8,2). When I try
> to load the driver with "modprobe b43" I get the following in dmesg:
>
> [ 3279.117137] bcma-pci-bridge 0000:03:00.0: PCI INT A disabled
> [ 3281.301279] bcma-pci-bridge 0000:03:00.0: PCI INT A -> GSI 17 (level,
> low) -> IRQ 17
> [ 3281.301297] bcma-pci-bridge 0000:03:00.0: setting latency timer to 64
> [ 3281.301381] bcma: Core 0 found: ChipCommon (manuf 0x4BF, id 0x800, rev
> 0x25, class 0x0)
> [ 3281.301405] bcma: Core 1 found: IEEE 802.11 (manuf 0x4BF, id 0x812, rev
> 0x1D, class 0x0)
> [ 3281.301459] bcma: Core 2 found: PCIe (manuf 0x4BF, id 0x820, rev 0x13,
> class 0x0)
> [ 3281.301581] bcma: PMU resource config unknown for device 0x4331
> [ 3281.301583] bcma: Enabling Ext PA lines not implemented
> [ 3281.310508] bcma: Bus registered
> [ 3281.312814] cfg80211: Calling CRDA to update world regulatory domain
> [ 3281.316215] b43-phy0: Broadcom 4331 WLAN found (core revision 29)
> [ 3281.316383] b43-phy0 ERROR: FOUND UNSUPPORTED PHY (Analog 9, Type 7,
> Revision 1)

This seems to be standard HT PHY:
#define B43_PHYTYPE_HT			0x07
So your b43 must be compiled without support for HT.


>  CC [M]
>  /home/andy/kernel/compat-wireless-2011-11-22/drivers/net/wireless/b43/phy_ht.o
>  CC [M]
>  /home/andy/kernel/compat-wireless-2011-11-22/drivers/net/wireless/b43/tables_phy_ht.o
>  CC [M]
>  /home/andy/kernel/compat-wireless-2011-11-22/drivers/net/wireless/b43/radio_2059.o

Here we can see you compile b43 from compat-wireless with HT-PHY
support. So there must be something wrong with the way you install
compat-wireless.

I can give you some hints:
1) find -name "b43.ko" /lib/modules
2) modinfo b43
3) modinfo b43 | grep filename

But I don't know what exactly are you doing wrong.

-- 
Rafał
