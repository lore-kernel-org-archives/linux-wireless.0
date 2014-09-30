Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.13]:53392 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844AbaI3NkX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Sep 2014 09:40:23 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	zajec5@gmail.com, arend@broadcom.com,
	linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
	varkabhadram@gmail.com
Subject: Re: [PATCH v6] bcma: register bcma as device tree driver
Date: Tue, 30 Sep 2014 15:40:10 +0200
Message-ID: <7004113.vCTZUyLSaf@wuerfel> (sfid-20140930_154026_965587_4A19E562)
In-Reply-To: <1411682959-21557-1-git-send-email-hauke@hauke-m.de>
References: <1411682959-21557-1-git-send-email-hauke@hauke-m.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 26 September 2014 00:09:19 Hauke Mehrtens wrote:
> This driver is used by the bcm53xx ARM SoC code. Now it is possible to
> give the address of the chipcommon core in device tree and bcma will
> search for all the other cores.
> 
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>

I'm basically happy with this patch, so

Acked-by: Arnd Bergmann <arnd@arndb.de>

A few details that I think are worth improving:

> diff --git a/Documentation/devicetree/bindings/bus/bcma.txt b/Documentation/devicetree/bindings/bus/bcma.txt
> new file mode 100644
> index 0000000..e9070c1
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/bus/bcma.txt
> @@ -0,0 +1,20 @@
> +Driver for ARM AXI Bus with Broadcom Plugins (bcma)
> +
> +Required properties:
> +
> +- compatible : brcm,bus-axi
> +
> +- reg : iomem address range of chipcommon core
> +
> +The cores on the AXI bus are automatically detected by bcma with the
> +memory ranges they are using and they get registered afterwards.
> +
> +Example:
> +
> +	axi@18000000 {
> +		compatible = "brcm,bus-axi";
> +		reg = <0x18000000 0x1000>;
> +		ranges = <0x00000000 0x18000000 0x00100000>;
> +		#address-cells = <1>;
> +		#size-cells = <1>;
> +	};

I think it would be good to document how you can specify child nodes
here, and give one node as the example.

> +
> +#ifdef CONFIG_OF
> +static int bcma_host_soc_probe(struct platform_device *pdev)
> +{

We generally try to avoid #ifdef in device drivers, I think it would
be trivial to avoid this one by moving the contents into a new file.

> +	struct device *dev = &pdev->dev;
> +	struct device_node *np = dev->of_node;
> +	struct bcma_bus *bus;
> +	int err;
> +
> +	/* Alloc */
> +	bus = devm_kzalloc(dev, sizeof(*bus), GFP_KERNEL);
> +	if (!bus)
> +		return -ENOMEM;
> +
> +	/* Map MMIO */
> +	bus->mmio = of_iomap(np, 0);
> +	if (!bus->mmio)
> +		return -ENOMEM;

this could use devm_ioremap_resource() to avoid the iounmap
in the failu

> +#ifdef CONFIG_OF
> +static struct device_node *bcma_of_find_child_device(struct platform_device *parent,
> +						     struct bcma_device *core)
> +{
> +	struct device_node *node;
> +	u64 size;
> +	const __be32 *reg;
> +
> +	if (!parent || !parent->dev.of_node)
> +		return NULL;
> +
> +	for_each_child_of_node(parent->dev.of_node, node) {
> +		reg = of_get_address(node, 0, &size, NULL);
> +		if (!reg)
> +			continue;
> +		if (of_translate_address(node, reg) == core->addr)
> +			return node;
> +	}
> +	return NULL;
> +}

I think this will compile into nothing if CONFIG_OF is disabled, so no
need for the #ifdef.

> +
> +static void bcma_of_fill_device(struct platform_device *parent,
> +				struct bcma_device *core)
> +{
> +	struct device_node *node;
> +
> +	node = bcma_of_find_child_device(parent, core);
> +	if (node)
> +		core->dev.of_node = node;
> +}

and consequently, this function can be moved into the caller.

	Arnd
