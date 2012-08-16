Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1137 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754031Ab2HPSn1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Aug 2012 14:43:27 -0400
Message-ID: <502D3F3F.7060207@broadcom.com> (sfid-20120816_204331_608766_4D07C858)
Date: Thu, 16 Aug 2012 20:43:11 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
cc: "Florian Fainelli" <florian@openwrt.org>,
	"Hauke Mehrtens" <hauke@hauke-m.de>, ralf@linux-mips.org,
	linux-mips@linux-mips.org, linux-wireless@vger.kernel.org,
	john@phrozen.org
Subject: Re: [PATCH v2 3/3] MIPS: BCM47xx: rewrite GPIO handling and use
 gpiolib
References: <1345132801-8430-1-git-send-email-hauke@hauke-m.de>
 <1345132801-8430-4-git-send-email-hauke@hauke-m.de>
 <1791263.5FQJJv4xHF@bender>
 <CACna6rxVOFO-n5J_6J7HFSt+WnoX0=2ULjiRv3p9va47K2Edsw@mail.gmail.com>
In-Reply-To: <CACna6rxVOFO-n5J_6J7HFSt+WnoX0=2ULjiRv3p9va47K2Edsw@mail.gmail.com>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/16/2012 07:39 PM, Rafał Miłecki wrote:
> 2012/8/16 Florian Fainelli<florian@openwrt.org>:
>>> >>+void __init bcm47xx_gpio_init(void)
>>> >>+{
>>> >>+     int err;
>>> >>+
>>> >>+     switch (bcm47xx_bus_type) {
>>> >>+#ifdef CONFIG_BCM47XX_SSB
>>> >>+     case BCM47XX_BUS_TYPE_SSB:
>>> >>+             bcm47xx_gpio_count = ssb_gpio_count(&bcm47xx_bus.ssb);
>>> >>+#endif
>>> >>+#ifdef CONFIG_BCM47XX_BCMA
>>> >>+     case BCM47XX_BUS_TYPE_BCMA:
>>> >>+             bcm47xx_gpio_count = bcma_gpio_count(&bcm47xx_bus.bcma.bus);
>>> >>+#endif
>>> >>+     }
>> >
>> >Is this exclusive? Cannot we have both SSB and BCMA on the same device?
> This applies to SoC only, so I believe it's fine. We don't have SoCs
> based on BCMA and SSB at the same time.

It is indeed more than unlikely for a chip to have two silicon 
interconnects, which is what SSB and BCMA are. However, it does look 
suspicious from a code reading perspective. So I general I stick to the 
rule that each case must have a break and fall-thru are clearly commented.

> You can find devices with multiple buses, but additional ones are
> connected via PCIE or USB interface (or some other I don't know
> about).
>
> -- Rafał

Gr. AvS

