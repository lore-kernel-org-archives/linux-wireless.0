Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f173.google.com ([209.85.223.173]:37246 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803AbaI3Kly convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Sep 2014 06:41:54 -0400
MIME-Version: 1.0
In-Reply-To: <3484902.1UVy7lmJAD@wuerfel>
References: <1411892641-5662-1-git-send-email-zajec5@gmail.com>
	<1412072546-3529-1-git-send-email-zajec5@gmail.com>
	<3484902.1UVy7lmJAD@wuerfel>
Date: Tue, 30 Sep 2014 12:41:53 +0200
Message-ID: <CACna6rx8vm3cqws7hqH0yGZnJiteVy9hsCgi8hXZD5oFdyp_FQ@mail.gmail.com> (sfid-20140930_124201_070835_1AD75EBC)
Subject: Re: [PATCH V3] bcma: use device from DT (brcm, bus-chipcommon) for
 SoC GPIO chip
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Hauke Mehrtens <hauke@hauke-m.de>, devicetree@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 30 September 2014 12:36, Arnd Bergmann <arnd@arndb.de> wrote:
> On Tuesday 30 September 2014 12:22:26 Rafał Miłecki wrote:
>> @@ -218,6 +218,12 @@ int bcma_gpio_init(struct bcma_drv_cc *cc)
>>  #if IS_BUILTIN(CONFIG_BCM47XX)
>>         chip->to_irq            = bcma_gpio_to_irq;
>>  #endif
>> +#if IS_BUILTIN(CONFIG_OF)
>> +       if (cc->core->bus->hosttype == BCMA_HOSTTYPE_SOC)
>> +               chip->of_node   = of_find_compatible_node(
>> +                                       bus->host_pdev->dev.of_node, NULL,
>> +                                       "brcm,bus-chipcommon");
>> +#endif
>>         switch (cc->core->bus->chipinfo.id) {
>
> This doesn't: you are now searching through all nodes starting at the
> axi node rather than searching just through the children.
>
> I think it would be better with the first change in place to set
> chip->of_node to cc->core->dev.of_node, and set that pointer in
> bcma_bus_scan by matching the 'reg' number. I think that is what
> an earlier version of the bcma DT support did in order to find the
> IRQs. We no longer need it for that purpose, but it seems like a
> good idea anyway, as I expect other bcma_devices to have similar
> requirements to add additional properties.

Ohh, of course, I didn't notice that
[PATCH v6] bcma: register bcma as device tree driver
already contains bcma_of_fill_device. This will simplify my search a lot!

-- 
Rafał
