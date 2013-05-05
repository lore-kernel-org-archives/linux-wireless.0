Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f178.google.com ([209.85.214.178]:33816 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769Ab3EEQbV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 May 2013 12:31:21 -0400
Received: by mail-ob0-f178.google.com with SMTP id 16so2574666obc.9
        for <linux-wireless@vger.kernel.org>; Sun, 05 May 2013 09:31:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CACna6rwk0akD0x+sWTmjDDoaQqF0Y=NQ58rzqgZH92GCug6CeQ@mail.gmail.com>
References: <alpine.DEB.2.02.1304231851040.1513@kelly.ryd.net>
	<CACna6rxWPOqQPNUaASaj=v=O+Wjt0okjX4jNwE3tv-=etfATCg@mail.gmail.com>
	<CACna6rwk0akD0x+sWTmjDDoaQqF0Y=NQ58rzqgZH92GCug6CeQ@mail.gmail.com>
Date: Sun, 5 May 2013 18:31:20 +0200
Message-ID: <CACna6ry+F45PhCXahPpJtzu-w+vLE29ksHo9njXfTcfY3Av6LA@mail.gmail.com> (sfid-20130505_183135_295054_C900867E)
Subject: Re: [PATCH] B43: Handle DMA RX descriptor underrun
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Thommy Jakobsson <thommyj@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	b43-dev@lists.infradead.org, m@bues.ch, piotras@gmail.com,
	Larry.Finger@lwfinger.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2013/5/5 Rafał Miłecki <zajec5@gmail.com>:
> 2013/5/5 Rafał Miłecki <zajec5@gmail.com>:
>> 2013/4/23 Thommy Jakobsson <thommyj@gmail.com>:
>>> Add handling of rx descriptor underflow. This fixes a fault that could
>>> happen on slow machines, where data is received faster than the CPU can
>>> handle. In such a case the device will use up all rx descriptors and
>>> refuse to send any more data before confirming that it is ok. This
>>> patch enables necessary interrupt to discover such a situation and will
>>> handle them by dropping everything in the ring buffer.
>>
>> Thommy: does it mean firmware actually ignores what we write to the
>> B43_DMA64_RXINDEX (recently renamed to the B43_DMA64_RXSTOPINDEX)? Is
>> our set_current_rxslot and op64_set_current_rxslot (same for 32bit
>> version) useless in this situation?
>
> I've also grab some old logs from BCM4311 from wl driver.
>
> DMA setup:
> write32 0xfaafc210 <- 0x0000083d        B43_DMA32_RXCTL
> write32 0xfaafc214 <- 0x5581e000        B43_DMA32_RXRING
> write32 0xfaafc218 <- 0x00000100        B43_DMA32_RXINDEX
>
> While running:
>
>  read32 0xfaafc21c -> 0x02001018        B43_DMA32_RXSTATUS
>  read32 0xfaafc21c -> 0x02001018        B43_DMA32_RXSTATUS
>  read32 0xfaafc180 -> 0x0006230f
>  read32 0xfaafc184 -> 0x00000000
> write32 0xfaafc218 <- 0x00000118        B43_DMA32_RXINDEX
>
> (...)
>
>  read32 0xfaafc21c -> 0x02801020        B43_DMA32_RXSTATUS
>  read32 0xfaafc21c -> 0x02801020        B43_DMA32_RXSTATUS
>  read32 0xfaafc180 -> 0x00064c28
>  read32 0xfaafc184 -> 0x00000000
> write32 0xfaafc218 <- 0x00000120        B43_DMA32_RXINDEX
>
> Interesting part is that they write amount of slots + slot index to
> the B43_DMA32_RXINDEX (like 0x120 instead of 0x20). May be worth
> investigating.

Hm, this may be related to the unaligned addressing. After hacking
b43_dma_rx to:
ops->set_current_rxslot(ring, ring->nr_slots + 4);
(I've added ring->nr_slots) stopped stopping firmware from using slot
4. So I think we can ignore my above research.

Still worth considering is my previous e-mail. Why writing (for
example) 1 to RXSTOPINDEX doesn't stop firmware from using slot 1?
Can it be because it's "too late"? For example:
1) Firmware writes to slot 0, changes "curr descr" to 1
2) Firmware grabs slot 1
3) Firmware generates IRQ
4) Driver reads slot 0
5) Driver writes RX stop index 1

Firmware took slot 1 before driver forbid it to use it.

-- 
Rafał
