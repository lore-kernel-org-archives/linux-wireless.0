Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:53160 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751325Ab2HPWiN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Aug 2012 18:38:13 -0400
Message-ID: <502D764C.1060501@hauke-m.de> (sfid-20120817_003817_310529_2C979130)
Date: Fri, 17 Aug 2012 00:38:04 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: Arend van Spriel <arend@broadcom.com>,
	Florian Fainelli <florian@openwrt.org>, ralf@linux-mips.org,
	linux-mips@linux-mips.org, linux-wireless@vger.kernel.org,
	john@phrozen.org
Subject: Re: [PATCH v2 3/3] MIPS: BCM47xx: rewrite GPIO handling and use gpiolib
References: <1345132801-8430-1-git-send-email-hauke@hauke-m.de> <1345132801-8430-4-git-send-email-hauke@hauke-m.de> <1791263.5FQJJv4xHF@bender> <CACna6rxVOFO-n5J_6J7HFSt+WnoX0=2ULjiRv3p9va47K2Edsw@mail.gmail.com> <502D3F3F.7060207@broadcom.com> <CACna6ryphAPip5hpAuzCMQjqvZe70MpPnFkCyzrMhFkk5iLS+A@mail.gmail.com>
In-Reply-To: <CACna6ryphAPip5hpAuzCMQjqvZe70MpPnFkCyzrMhFkk5iLS+A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/16/2012 09:29 PM, Rafał Miłecki wrote:
> 2012/8/16 Arend van Spriel <arend@broadcom.com>:
>> On 08/16/2012 07:39 PM, Rafał Miłecki wrote:
>>>
>>> 2012/8/16 Florian Fainelli<florian@openwrt.org>:
>>>>>
>>>>>>> +void __init bcm47xx_gpio_init(void)
>>>>>>> +{
>>>>>>> +     int err;
>>>>>>> +
>>>>>>> +     switch (bcm47xx_bus_type) {
>>>>>>> +#ifdef CONFIG_BCM47XX_SSB
>>>>>>> +     case BCM47XX_BUS_TYPE_SSB:
>>>>>>> +             bcm47xx_gpio_count = ssb_gpio_count(&bcm47xx_bus.ssb);
>>>>>>> +#endif
>>>>>>> +#ifdef CONFIG_BCM47XX_BCMA
>>>>>>> +     case BCM47XX_BUS_TYPE_BCMA:
>>>>>>> +             bcm47xx_gpio_count =
>>>>>>> bcma_gpio_count(&bcm47xx_bus.bcma.bus);
>>>>>>> +#endif
>>>>>>> +     }
>>>>
>>>>>
>>>>> Is this exclusive? Cannot we have both SSB and BCMA on the same device?
>>>
>>> This applies to SoC only, so I believe it's fine. We don't have SoCs
>>> based on BCMA and SSB at the same time.
>>
>>
>> It is indeed more than unlikely for a chip to have two silicon
>> interconnects, which is what SSB and BCMA are. However, it does look
>> suspicious from a code reading perspective. So I general I stick to the rule
>> that each case must have a break and fall-thru are clearly commented.
> 
> Ahh, I though question is related to the enum used for bustype. I
> definitely vote for using "break"

I will add the missing break.

Hauke

