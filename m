Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.10]:57625 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818AbaI3K3E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Sep 2014 06:29:04 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Hauke Mehrtens <hauke@hauke-m.de>, devicetree@vger.kernel.org
Subject: Re: [PATCH V2] bcma: use device from DT (brcm, bus-gpio) for SoC GPIO chip
Date: Tue, 30 Sep 2014 12:28:21 +0200
Message-ID: <9255570.ha3Ad1aI6v@wuerfel> (sfid-20140930_122909_610243_44F1AC7A)
In-Reply-To: <CACna6ry-mmc8QD-bYUNGLfTh07TcUepjZdPYqKyxLc3HbMPung@mail.gmail.com>
References: <1411741733-13888-1-git-send-email-zajec5@gmail.com> <7035315.8m6ICWZ25d@wuerfel> <CACna6ry-mmc8QD-bYUNGLfTh07TcUepjZdPYqKyxLc3HbMPung@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 30 September 2014 11:56:20 Rafał Miłecki wrote:
> On 30 September 2014 11:37, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Sunday 28 September 2014 10:24:01 Rafał Miłecki wrote:
> >> @@ -17,4 +33,12 @@ Example:
> >>               ranges = <0x00000000 0x18000000 0x00100000>;
> >>               #address-cells = <1>;
> >>               #size-cells = <1>;
> >> +
> >> +             chipcommon@0 {
> >> +                     gpio@0 {
> >> +                             compatible = "brcm,bus-gpio";
> >> +                             gpio-controller;
> >> +                             #gpio-cells = <2>;
> >> +                     };
> >> +             };
> >
> > I think you should list the 'reg' property of the chipcommon area
> > and make that match the unit address, rather than using '0', mostly
> > for consistency.
> 
> Do you mean this chipcommon@0? We propose this foo@offset syntax since
> V1 which was posted 1,5 month ago, it's nothing new.

Is 'chipcommon' at the start of the 0x18000000 range? If so, that's
great, but it would still be good to have the 'reg' property in there
explicitly.

> >> @@ -218,6 +218,11 @@ int bcma_gpio_init(struct bcma_drv_cc *cc)
> >>  #if IS_BUILTIN(CONFIG_BCM47XX)
> >>       chip->to_irq            = bcma_gpio_to_irq;
> >>  #endif
> >> +#if IS_BUILTIN(CONFIG_OF)
> >> +     if (cc->core->bus->hosttype == BCMA_HOSTTYPE_SOC)
> >> +             chip->of_node   = of_find_compatible_node(NULL, NULL,
> >> +                                                       "brcm,bus-gpio");
> >> +#endif
> >
> > Just commenting on the general style here, I think you can skip this
> > step entirely, as mentioned above.
> >
> > You should use C syntax here:
> >
> >         if (IS_BUILTIN(CONFIG_OF) && cc->core->bus->hosttype == BCMA_HOSTTYPE_SOC))
> >                 chip->of_node = of_find_compatible_node(NULL, NULL, "brcm,bus-gpio");
> 
> OK
> 
> 
> > If CONFIG_OF is not set, of_find_compatible_node() is turned into an inline
> > function that returns NULL, so you probably don't even need that.
> 
> But I need to have of_node defined. Please check out "struct gpio_chip".

I see. This is something we might want to change, but you don't need to
bother with it now, so just leave this part as it is.

> > Finally, of_find_compatible_node() is a really slow operation, and "brcm,bus-gpio"
> > is a much too generic name. If you need to look for something that is a child
> > node, use something based on for_each_available_child_of_node().
> 
> Will see what I can do.

ok, thanks.

	Arnd
