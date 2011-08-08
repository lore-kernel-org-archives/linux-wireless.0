Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:47142 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080Ab1HHIlQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Aug 2011 04:41:16 -0400
Received: by pzk37 with SMTP id 37so7950497pzk.1
        for <linux-wireless@vger.kernel.org>; Mon, 08 Aug 2011 01:41:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CACna6rz9gChYwT-qhdNLKt0pizrN0Qe5mfQYJpeLWNp-M3r4KQ@mail.gmail.com>
References: <1311422254-7104-1-git-send-email-hauke@hauke-m.de>
	<CACna6rz9gChYwT-qhdNLKt0pizrN0Qe5mfQYJpeLWNp-M3r4KQ@mail.gmail.com>
Date: Mon, 8 Aug 2011 10:41:15 +0200
Message-ID: <CACna6ryBgAg0TCH1NbD-scvQgnqA_XTkmtLuUf7s75S3maBj_Q@mail.gmail.com> (sfid-20110808_104119_201907_75B2C71E)
Subject: Re: [PATCH 1/2] b43: read correct register on bcma bus.
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 23 lipca 2011 16:00 użytkownik Rafał Miłecki <zajec5@gmail.com> napisał:
> 2011/7/23 Hauke Mehrtens <hauke@hauke-m.de>:
>> This causes an databus error on a Broadcom SoC using bcma.
>>
>> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
>> ---
>>  drivers/net/wireless/b43/dma.c |   20 +++++++++++++++++---
>>  1 files changed, 17 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/net/wireless/b43/dma.c b/drivers/net/wireless/b43/dma.c
>> index 0953ce1..646d6ae 100644
>> --- a/drivers/net/wireless/b43/dma.c
>> +++ b/drivers/net/wireless/b43/dma.c
>> @@ -795,9 +795,23 @@ static u64 supported_dma_mask(struct b43_wldev *dev)
>>        u32 tmp;
>>        u16 mmio_base;
>>
>> -       tmp = b43_read32(dev, SSB_TMSHIGH);
>> -       if (tmp & SSB_TMSHIGH_DMA64)
>> -               return DMA_BIT_MASK(64);
>> +       switch (dev->dev->bus_type) {
>> +#ifdef CONFIG_B43_BCMA
>> +       case B43_BUS_BCMA:
>> +               tmp = bcma_aread32(dev->dev->bdev, BCMA_IOST);
>> +               if (tmp & BCMA_IOST_DMA64)
>> +                       return DMA_BIT_MASK(64);
>> +               break;
>> +#endif
>> +#ifdef CONFIG_B43_SSB
>> +       case B43_BUS_SSB:
>> +               tmp = ssb_read32(dev->dev->sdev, SSB_TMSHIGH);
>> +               if (tmp & SSB_TMSHIGH_DMA64)
>> +                       return DMA_BIT_MASK(64);
>> +               break;
>> +#endif
>> +       }
>> +
>>        mmio_base = b43_dmacontroller_base(0, 0);
>>        b43_write32(dev, mmio_base + B43_DMA32_TXCTL, B43_DMA32_TXADDREXT_MASK);
>>        tmp = b43_read32(dev, mmio_base + B43_DMA32_TXCTL);
>> --
>> 1.7.4.1
>
> Ack. Code was half-correctly using b43_read32 for SSB_TMSHIGH and
> that's how I missed it. Reading non-existent register on PC resulted
> in 0xFFFFFFFF, but not bus error.
>
> Thanks Hauke.

There is not support for SoC in 3.1-rc1, but reading SSB_TMSHIGH on
PC/laptop still can be dangerous, can't it? It didn't blow my machine,
but don't know what will happen on other, including notebooks.

Should we take this patch as fix for 3.1?

-- 
Rafał
