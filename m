Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.10]:57818 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073AbaIVH1N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Sep 2014 03:27:13 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Hauke Mehrtens <hauke@hauke-m.de>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
	zajec5@gmail.com, varkabhadram@gmail.com, arend@broadcom.com
Subject: Re: [PATCH v4 1/2] bcma: register bcma as device tree driver
Date: Mon, 22 Sep 2014 09:26:51 +0200
Message-ID: <4345256.UGZH9SeRYG@wuerfel> (sfid-20140922_092718_680042_143C97FC)
In-Reply-To: <1411339108-22307-1-git-send-email-hauke@hauke-m.de>
References: <1411339108-22307-1-git-send-email-hauke@hauke-m.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 22 September 2014 00:38:27 Hauke Mehrtens wrote:
> +
> +- reg : iomem address range of chipcommon core
> +
> +The cores on the AXI bus are automatically detected by bcma with the
> +memory ranges they are using and they get registered afterwards.
> +Automatic detection of the IRQ number is not reliable on
> +BCM47xx/BCM53xx ARM SoCs. To assign IRQ numbers to the cores, provide
> +them manually through device tree. The IRQ number and the device tree
> +child entry will get assigned to the core with the matching reg address.
> +
> +Example:
> +
> +       axi@18000000 {
> +               compatible = "brcm,bus-axi";
> +               reg = <0x18000000 0x1000>;
> +               ranges = <0x00000000 0x18000000 0x00100000>;
> +               #address-cells = <1>;
> +               #size-cells = <1>;
> +
> +               pcie@12000 {
> +                       reg = <0x00012000 0x1000>;
> +                       interrupts = <GIC_SPI 131 IRQ_TYPE_LEVEL_HIGH>;
> +               };
> +
> +               ethernet@24000 {
> +                       reg = <0x00024000 0x1000>;
> +                       interrupts = <GIC_SPI 147 IRQ_TYPE_LEVEL_HIGH>;
> +               };
> +
> +               ethernet@25000 {
> +                       reg = <0x00025000 0x1000>;
> +                       interrupts = <GIC_SPI 148 IRQ_TYPE_LEVEL_HIGH>;
> +               };
> +       };
> 

While reading through this new version, I had a new idea about how
this could be handled better for any machines that have a unique
number in the interrupt field: If you do the same thing as PCI
and add an interrupt-map property [1], you can translate that
number into a real interrupt specifier for the child nodes.

This can work even if every device lists the local interrupt
as '0', since you can have device-specific lookup entries if you
use the correct interrupt-map-mask property.

	Arnd

[1] http://www.openfirmware.org/1275/practice/imap/imap0_9d.pdf
