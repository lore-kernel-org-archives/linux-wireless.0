Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:61184 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755894Ab2HPRjM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Aug 2012 13:39:12 -0400
Received: by weyx8 with SMTP id x8so1901126wey.19
        for <linux-wireless@vger.kernel.org>; Thu, 16 Aug 2012 10:39:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1791263.5FQJJv4xHF@bender>
References: <1345132801-8430-1-git-send-email-hauke@hauke-m.de>
	<1345132801-8430-4-git-send-email-hauke@hauke-m.de>
	<1791263.5FQJJv4xHF@bender>
Date: Thu, 16 Aug 2012 19:39:10 +0200
Message-ID: <CACna6rxVOFO-n5J_6J7HFSt+WnoX0=2ULjiRv3p9va47K2Edsw@mail.gmail.com> (sfid-20120816_193916_440859_5DF8D635)
Subject: Re: [PATCH v2 3/3] MIPS: BCM47xx: rewrite GPIO handling and use gpiolib
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Florian Fainelli <florian@openwrt.org>
Cc: Hauke Mehrtens <hauke@hauke-m.de>, ralf@linux-mips.org,
	linux-mips@linux-mips.org, linux-wireless@vger.kernel.org,
	john@phrozen.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012/8/16 Florian Fainelli <florian@openwrt.org>:
>> +void __init bcm47xx_gpio_init(void)
>> +{
>> +     int err;
>> +
>> +     switch (bcm47xx_bus_type) {
>> +#ifdef CONFIG_BCM47XX_SSB
>> +     case BCM47XX_BUS_TYPE_SSB:
>> +             bcm47xx_gpio_count = ssb_gpio_count(&bcm47xx_bus.ssb);
>> +#endif
>> +#ifdef CONFIG_BCM47XX_BCMA
>> +     case BCM47XX_BUS_TYPE_BCMA:
>> +             bcm47xx_gpio_count = bcma_gpio_count(&bcm47xx_bus.bcma.bus);
>> +#endif
>> +     }
>
> Is this exclusive? Cannot we have both SSB and BCMA on the same device?

This applies to SoC only, so I believe it's fine. We don't have SoCs
based on BCMA and SSB at the same time.

You can find devices with multiple buses, but additional ones are
connected via PCIE or USB interface (or some other I don't know
about).

-- 
Rafał
