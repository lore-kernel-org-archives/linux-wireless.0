Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hauke-m.de ([5.39.93.123]:37820 "EHLO hauke-m.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750821AbaIXVTS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Sep 2014 17:19:18 -0400
Message-ID: <54233550.60600@hauke-m.de> (sfid-20140924_231922_872934_DD652756)
Date: Wed, 24 Sep 2014 23:19:12 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-arm-kernel@lists.infradead.org, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
	zajec5@gmail.com, varkabhadram@gmail.com, arend@broadcom.com
Subject: Re: [PATCH v4 1/2] bcma: register bcma as device tree driver
References: <1411339108-22307-1-git-send-email-hauke@hauke-m.de> <4345256.UGZH9SeRYG@wuerfel> <5421EE62.2080701@hauke-m.de> <3856565.LYF1mvpGOq@wuerfel>
In-Reply-To: <3856565.LYF1mvpGOq@wuerfel>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/24/2014 11:48 AM, Arnd Bergmann wrote:
> On Wednesday 24 September 2014 00:04:18 Hauke Mehrtens wrote:
>> I assume this should then look somehow like this:
>>
>> axi@18000000 {
>>         compatible = "brcm,bus-axi";
>>         reg = <0x18000000 0x1000>;
>>         ranges = <0x00000000 0x18000000 0x00100000>;
>>         #address-cells = <1>;
>>         #size-cells = <1>;
>>
>>         #interrupt-cells = <1>;
>>         interrupt-map = <
>>                 /* ChipCommon */
>>                 0x00000000 0 &gic  GIC_SPI 85 IRQ_TYPE_LEVEL_HIGH
>>
>>                 /* PCIe Controller 0 */
>>                 0x00012000 0 &gic GIC_SPI 126 IRQ_TYPE_LEVEL_HIGH
>>                 0x00012000 1 &gic GIC_SPI 127 IRQ_TYPE_LEVEL_HIGH
>>                 0x00012000 2 &gic GIC_SPI 128 IRQ_TYPE_LEVEL_HIGH
>>                 0x00012000 3 &gic GIC_SPI 129 IRQ_TYPE_LEVEL_HIGH
>>                 0x00012000 4 &gic GIC_SPI 130 IRQ_TYPE_LEVEL_HIGH
>>                 0x00012000 5 &gic GIC_SPI 131 IRQ_TYPE_LEVEL_HIGH
>>
>>                 /* USB 2.0 Controller */
>>                 0x00021000 0 &gic GIC_SPI 79 IRQ_TYPE_LEVEL_HIGH
>>                 >;
>>         };
> 
> Right, although I would add a few more '<', '>' and ',' for readability,
> separating each line with a comma.
> 
> You are also missing an 'interrupt-map-mask' property that lists which
> bits of the address are significant.
> 
> Are the interrupt numbers you have in the example (0, 0, 1, 2, ... 5, 0)
> the actual numbers that are present in the hw registers?

Some cores do have more than one IRQ. The NAND core uses 8 IRQs and the
PCIe controller uses 5 (the vendor code just uses the last one which
gets triggered always). How can I handle this cases where one device has
more than one IRQ? There is no hardware register these IRQ get mapped
to. As far as I know the driver just knows that this device needs more
IRQs. Should I just add a special device node entry for such devices?

>> How does the mapping of these interrupts to the devices work?
> 
> The same way that of_irq_parse_and_map_pci() works (the second half of it).
> It's a very similar situation: you have a discoverable bus on which the
> interrupts are listed in a different domain from which they are supposed to
> be on the parent. The trick is to make up your own address property
> and of_phandle_args on the stack and fill that with the data from
> the hw bus scan, so you can get into the middle of the normal DT
> irq code that gets them from device nodes.

Thanks for the description, that worked for me.

>> Do I have to add a device tree entry for every device after all?
> 
> No, unless you want to add other properties in the node, such as
> a MAC address, but then you still only need some of the devices.
> 
>> Do you have some example code where this is handled in code, I could not
>> find the code doing this for PCI.
> 
> drivers/of/of_pci_irq.c, though the hard part is done in drivers/of/irq.c,
> which parses the interrupt-map and interrupt-map-mask properties.


I will split this patch into two patches, one just adding the bcma
registration and an additional RFC patch adding the IRQ stuff.

Hauke
