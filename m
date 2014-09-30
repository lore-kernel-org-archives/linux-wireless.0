Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.187]:57009 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484AbaI3Kgg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Sep 2014 06:36:36 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>,
	devicetree@vger.kernel.org
Subject: Re: [PATCH V3] bcma: use device from DT (brcm, bus-chipcommon) for SoC GPIO chip
Date: Tue, 30 Sep 2014 12:36:28 +0200
Message-ID: <3484902.1UVy7lmJAD@wuerfel> (sfid-20140930_123647_197966_9F978728)
In-Reply-To: <1412072546-3529-1-git-send-email-zajec5@gmail.com>
References: <1411892641-5662-1-git-send-email-zajec5@gmail.com> <1412072546-3529-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 30 September 2014 12:22:26 Rafał Miłecki wrote:
> 
> +The top-level axi bus may contain children representing attached cores
> +(devices). This is needed since some hardware details can't be auto
> +detected (e.g. IRQ numbers). Also some of the cores may be responsible
> +for extra things, e.g. ChipCommon providing access to the GPIO chip.
> +
>  Example:
>  
>         axi@18000000 {
> @@ -17,4 +22,12 @@ Example:
>                 ranges = <0x00000000 0x18000000 0x00100000>;
>                 #address-cells = <1>;
>                 #size-cells = <1>;
> +
> +               chipcommon {
> +                       compatible = "brcm,bus-chipcommon";
> +                       reg = <0x00000000 0x1000>;
> +
> +                       gpio-controller;
> +                       #gpio-cells = <2>;
> +               };
>         };

Looks good.


> diff --git a/drivers/bcma/driver_gpio.c b/drivers/bcma/driver_gpio.c
> index 8ea497c..28bdbe5 100644
> --- a/drivers/bcma/driver_gpio.c
> +++ b/drivers/bcma/driver_gpio.c
> @@ -218,6 +218,12 @@ int bcma_gpio_init(struct bcma_drv_cc *cc)
>  #if IS_BUILTIN(CONFIG_BCM47XX)
>         chip->to_irq            = bcma_gpio_to_irq;
>  #endif
> +#if IS_BUILTIN(CONFIG_OF)
> +       if (cc->core->bus->hosttype == BCMA_HOSTTYPE_SOC)
> +               chip->of_node   = of_find_compatible_node(
> +                                       bus->host_pdev->dev.of_node, NULL,
> +                                       "brcm,bus-chipcommon");
> +#endif
>         switch (cc->core->bus->chipinfo.id) {

This doesn't: you are now searching through all nodes starting at the
axi node rather than searching just through the children.

I think it would be better with the first change in place to set
chip->of_node to cc->core->dev.of_node, and set that pointer in
bcma_bus_scan by matching the 'reg' number. I think that is what
an earlier version of the bcma DT support did in order to find the
IRQs. We no longer need it for that purpose, but it seems like a
good idea anyway, as I expect other bcma_devices to have similar
requirements to add additional properties.

	Arnd
