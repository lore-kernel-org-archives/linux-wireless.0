Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.10]:49962 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774AbaIYF4q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Sep 2014 01:56:46 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-arm-kernel@lists.infradead.org, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
	zajec5@gmail.com, varkabhadram@gmail.com, arend@broadcom.com
Subject: Re: [PATCH v4 1/2] bcma: register bcma as device tree driver
Date: Thu, 25 Sep 2014 07:55:56 +0200
Message-ID: <3098264.dzR8BlVP6B@wuerfel> (sfid-20140925_075657_693362_B299031C)
In-Reply-To: <54233550.60600@hauke-m.de>
References: <1411339108-22307-1-git-send-email-hauke@hauke-m.de> <3856565.LYF1mvpGOq@wuerfel> <54233550.60600@hauke-m.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 24 September 2014 23:19:12 Hauke Mehrtens wrote:
> On 09/24/2014 11:48 AM, Arnd Bergmann wrote:
> > On Wednesday 24 September 2014 00:04:18 Hauke Mehrtens wrote:
> >> I assume this should then look somehow like this:
> >>
> >> axi@18000000 {
> >>         compatible = "brcm,bus-axi";
> >>         reg = <0x18000000 0x1000>;
> >>         ranges = <0x00000000 0x18000000 0x00100000>;
> >>         #address-cells = <1>;
> >>         #size-cells = <1>;
> >>
> >>         #interrupt-cells = <1>;
> >>         interrupt-map = <
> >>                 /* ChipCommon */
> >>                 0x00000000 0 &gic  GIC_SPI 85 IRQ_TYPE_LEVEL_HIGH
> >>
> >>                 /* PCIe Controller 0 */
> >>                 0x00012000 0 &gic GIC_SPI 126 IRQ_TYPE_LEVEL_HIGH
> >>                 0x00012000 1 &gic GIC_SPI 127 IRQ_TYPE_LEVEL_HIGH
> >>                 0x00012000 2 &gic GIC_SPI 128 IRQ_TYPE_LEVEL_HIGH
> >>                 0x00012000 3 &gic GIC_SPI 129 IRQ_TYPE_LEVEL_HIGH
> >>                 0x00012000 4 &gic GIC_SPI 130 IRQ_TYPE_LEVEL_HIGH
> >>                 0x00012000 5 &gic GIC_SPI 131 IRQ_TYPE_LEVEL_HIGH
> >>
> >>                 /* USB 2.0 Controller */
> >>                 0x00021000 0 &gic GIC_SPI 79 IRQ_TYPE_LEVEL_HIGH
> >>                 >;
> >>         };
> > 
> > Right, although I would add a few more '<', '>' and ',' for readability,
> > separating each line with a comma.
> > 
> > You are also missing an 'interrupt-map-mask' property that lists which
> > bits of the address are significant.
> > 
> > Are the interrupt numbers you have in the example (0, 0, 1, 2, ... 5, 0)
> > the actual numbers that are present in the hw registers?
> 
> Some cores do have more than one IRQ. The NAND core uses 8 IRQs and the
> PCIe controller uses 5 (the vendor code just uses the last one which
> gets triggered always). How can I handle this cases where one device has
> more than one IRQ? There is no hardware register these IRQ get mapped
> to. As far as I know the driver just knows that this device needs more
> IRQs. Should I just add a special device node entry for such devices?


You create your own local irq domain (in the DT sense, not the Linux sense)
by using #interrrupt-cells = <1> or more, and then use whatever input data
you have available.

Ideally there would be registers that you can use to look up a token
you use (like the BCMA_MIPS_MIPS74K_INTMASK), if you don't have them
here, just use the local index, and pass that down to bcma_core_irq(),
from where you put it into the of_phandle_args.

	Arnd
