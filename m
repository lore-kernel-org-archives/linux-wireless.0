Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:45722 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754095Ab2IIPWN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Sep 2012 11:22:13 -0400
Message-ID: <504CB41E.6070201@hauke-m.de> (sfid-20120909_172244_767999_3181E96D)
Date: Sun, 09 Sep 2012 17:22:06 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: ralf@linux-mips.org, john@phrozen.org, linux-mips@linux-mips.org,
	linux-wireless@vger.kernel.org, florian@openwrt.org
Subject: Re: [PATCH v3 2/3] bcma: add GPIO driver for SoCs
References: <1346427485-12801-1-git-send-email-hauke@hauke-m.de> <1346427485-12801-3-git-send-email-hauke@hauke-m.de> <CACna6rwb15pfbM6rM5ros0yCSW+uv1CbwWz5pUz8OgvONKKrvg@mail.gmail.com>
In-Reply-To: <CACna6rwb15pfbM6rM5ros0yCSW+uv1CbwWz5pUz8OgvONKKrvg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/03/2012 09:15 PM, Rafał Miłecki wrote:
> 2012/8/31 Hauke Mehrtens <hauke@hauke-m.de>:
>> +u32 bcma_gpio_in(struct bcma_bus *bus, u32 mask)
>> +{
>> +       unsigned long flags;
>> +       u32 res = 0;
>> +
>> +       spin_lock_irqsave(&bus->gpio_lock, flags);
>> +       res = bcma_chipco_gpio_in(&bus->drv_cc, mask);
>> +       spin_unlock_irqrestore(&bus->gpio_lock, flags);
>> +
>> +       return res;
>> +}
>> +EXPORT_SYMBOL(bcma_gpio_in);
> 
> 
> Could we put here direct ops on ChipCommon regs and drop GPIO
> functions from driver_chipcommon.c?

So you mean that all accesses to the gpio registers are locked, also
when b43 or bcma accesses them? If so, I will change my patch and test
it on my devices. I am currently not at my development machine and do
not have the test devices here, but I will see if I find some time on
Tuesday when I am home again.

So bcma_chipco_gpio_XXX() should not be exported in the way it is done
now any more and all accesses to the gpio registers should be locked.

Hauke
