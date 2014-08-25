Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.10]:58058 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754490AbaHYH5m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Aug 2014 03:57:42 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Hauke Mehrtens <hauke@hauke-m.de>, linux-wireless@vger.kernel.org,
	devicetree@vger.kernel.org, linux-mips@linux-mips.org,
	zajec5@gmail.com
Subject: Re: [RFC 4/7] bcma: register bcma as device tree driver
Date: Mon, 25 Aug 2014 09:57:36 +0200
Message-ID: <2462012.kILSFadzpm@wuerfel> (sfid-20140825_095746_562734_4E9E1CA0)
In-Reply-To: <1408915485-8078-6-git-send-email-hauke@hauke-m.de>
References: <1408915485-8078-1-git-send-email-hauke@hauke-m.de> <1408915485-8078-6-git-send-email-hauke@hauke-m.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 24 August 2014 23:24:42 Hauke Mehrtens wrote:
> This driver is used by the bcm53xx ARM SoC code. Now it is possible to
> give the address of the chipcommon core in device tree and bcma will
> search for all the other cores.
> 
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>

Looks good to me overall. Two small comments:

>  Documentation/devicetree/bindings/bus/bcma.txt | 46 +++++++++++++++++
>  drivers/bcma/host_soc.c                        | 70 ++++++++++++++++++++++++++
>  include/linux/bcma/bcma.h                      |  2 +
>  3 files changed, 118 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/bus/bcma.txt
> 
> diff --git a/Documentation/devicetree/bindings/bus/bcma.txt b/Documentation/devicetree/bindings/bus/bcma.txt
> new file mode 100644
> index 0000000..52fb929
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/bus/bcma.txt
> @@ -0,0 +1,46 @@
> +Broadcom AIX bcma bus driver
> +
> +
> +Required properties:
> +
> +- compatible : brcm,bus-aix
> +
> +- reg : iomem address range of chipcommon core
> +
> +Optional properties:
> +
> +- sprom: reference to a sprom driver. This is needed for sprom less devices.
> +        Use bcm47xx_sprom for example.
> +
> +
> +The cores on the AIX bus are auto detected by bcma. Detection of the
> +IRQ number is not supported on BCM47xx/BCM53xx ARM SoCs, so it is
> +possible to provide the IRQ number over device tree. The IRQ number and
> +the device tree child entry will be added to the core with the matching
> +reg address.

What is the problem with the interrupt numbers? Is that information
missing completely from the data available to the brcm bus, or is it
in an inconvenient format?

> +Example:
> +
> +       aix@18000000 {
> +               compatible = "brcm,bus-aix";
> +               reg = <0x18000000 0x1000>;
> +               ranges = <0x00000000 0x18000000 0x00100000>;
> +               #address-cells = <1>;
> +               #size-cells = <1>;
> +               sprom = <&sprom0>;
> +
> +               gmac@0 {
> +                       reg = <0x18024000 0x1000>;
> +                       interrupts = <GIC_SPI 147 IRQ_TYPE_LEVEL_HIGH>;
> +               };

The @0 part seems wrong here: the address should generally match
the first entry in the reg property, which would be gmac@18024000.

Also, you probably mean ethernet@ not gmac@.

> +               gmac@1 {
> +                       reg = <0x18025000 0x1000>;
> +                       interrupts = <GIC_SPI 148 IRQ_TYPE_LEVEL_HIGH>;
> +               };
> +
> +               pcie@0 {
> +                       reg = <0x18012000 0x1000>;
> +                       interrupts = <GIC_SPI 131 IRQ_TYPE_LEVEL_HIGH>;
> +               };
> +       };

We may require additional properties for the pcie node, depending on whether
we want to use the DT probing interfaces for it, or whether it should just
hardcode the settings used on brcm based on the ID.

	Arnd

