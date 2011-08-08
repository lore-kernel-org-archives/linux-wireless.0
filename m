Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:60924 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750868Ab1HHV1h (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Aug 2011 17:27:37 -0400
Message-ID: <4E4054C2.3010407@hauke-m.de> (sfid-20110808_232741_762193_517DBD9B)
Date: Mon, 08 Aug 2011 23:27:30 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] b43: read correct register on bcma bus.
References: <1311422254-7104-1-git-send-email-hauke@hauke-m.de>	<CACna6rz9gChYwT-qhdNLKt0pizrN0Qe5mfQYJpeLWNp-M3r4KQ@mail.gmail.com> <CACna6ryBgAg0TCH1NbD-scvQgnqA_XTkmtLuUf7s75S3maBj_Q@mail.gmail.com>
In-Reply-To: <CACna6ryBgAg0TCH1NbD-scvQgnqA_XTkmtLuUf7s75S3maBj_Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/08/2011 10:41 AM, Rafał Miłecki wrote:
> W dniu 23 lipca 2011 16:00 użytkownik Rafał Miłecki <zajec5@gmail.com> napisał:
>> 2011/7/23 Hauke Mehrtens <hauke@hauke-m.de>:
>>> This causes an databus error on a Broadcom SoC using bcma.
>>>
>>> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
>>> ---
>>>  drivers/net/wireless/b43/dma.c |   20 +++++++++++++++++---
>>>  1 files changed, 17 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/drivers/net/wireless/b43/dma.c b/drivers/net/wireless/b43/dma.c
>>> index 0953ce1..646d6ae 100644
>>> --- a/drivers/net/wireless/b43/dma.c
>>> +++ b/drivers/net/wireless/b43/dma.c
>>> @@ -795,9 +795,23 @@ static u64 supported_dma_mask(struct b43_wldev *dev)
>>>        u32 tmp;
>>>        u16 mmio_base;
>>>
>>> -       tmp = b43_read32(dev, SSB_TMSHIGH);
>>> -       if (tmp & SSB_TMSHIGH_DMA64)
>>> -               return DMA_BIT_MASK(64);
>>> +       switch (dev->dev->bus_type) {
>>> +#ifdef CONFIG_B43_BCMA
>>> +       case B43_BUS_BCMA:
>>> +               tmp = bcma_aread32(dev->dev->bdev, BCMA_IOST);
>>> +               if (tmp & BCMA_IOST_DMA64)
>>> +                       return DMA_BIT_MASK(64);
>>> +               break;
>>> +#endif
>>> +#ifdef CONFIG_B43_SSB
>>> +       case B43_BUS_SSB:
>>> +               tmp = ssb_read32(dev->dev->sdev, SSB_TMSHIGH);
>>> +               if (tmp & SSB_TMSHIGH_DMA64)
>>> +                       return DMA_BIT_MASK(64);
>>> +               break;
>>> +#endif
>>> +       }
>>> +
>>>        mmio_base = b43_dmacontroller_base(0, 0);
>>>        b43_write32(dev, mmio_base + B43_DMA32_TXCTL, B43_DMA32_TXADDREXT_MASK);
>>>        tmp = b43_read32(dev, mmio_base + B43_DMA32_TXCTL);
>>> --
>>> 1.7.4.1
>>
>> Ack. Code was half-correctly using b43_read32 for SSB_TMSHIGH and
>> that's how I missed it. Reading non-existent register on PC resulted
>> in 0xFFFFFFFF, but not bus error.
>>
>> Thanks Hauke.
> 
> There is not support for SoC in 3.1-rc1, but reading SSB_TMSHIGH on
> PC/laptop still can be dangerous, can't it? It didn't blow my machine,
> but don't know what will happen on other, including notebooks.
> 
> Should we take this patch as fix for 3.1?
> 
I would be for adding this to 3.1 as it does exactly the same for ssb
devices and bcma based device were not supported with kernel versions
before 3.1. On an bcma devices we are reading some memory and do not
know what could happen because of this. On pci devices we haven't seen
any problem yet because the cpu does not have a problem with reading
this address, but under some not "normal" conditions this could be a
problem.

Hauke
