Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:45666 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752293AbcDZInY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Apr 2016 04:43:24 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 1/2] mt76: add common code shared between multiple chipsets
References: <1457039737-61262-1-git-send-email-nbd@openwrt.org>
Date: Tue, 26 Apr 2016 11:43:19 +0300
In-Reply-To: <1457039737-61262-1-git-send-email-nbd@openwrt.org> (Felix
	Fietkau's message of "Thu, 3 Mar 2016 22:15:36 +0100")
Message-ID: <87potczro8.fsf@kamboji.qca.qualcomm.com> (sfid-20160426_104329_854840_4BC326B5)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau <nbd@openwrt.org> writes:

> This will be used by drivers for MT76x2e, MT7603e and MT7628
>
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>

[...]

> +static int
> +mt76_get_of_eeprom(struct mt76_dev *dev, int len)
> +{
> +#ifdef CONFIG_OF
> +	struct device_node *np = dev->dev->of_node;
> +	struct mtd_info *mtd;
> +	const __be32 *list;
> +	const char *part;
> +	phandle phandle;
> +	int offset = 0;
> +	int size;
> +	size_t retlen;
> +	int ret;
> +
> +	if (!np)
> +		return -ENOENT;
> +
> +	list = of_get_property(np, "mediatek,mtd-eeprom", &size);
> +	if (!list)
> +		return -ENOENT;
> +
> +	phandle = be32_to_cpup(list++);
> +	if (!phandle)
> +		return -ENOENT;
> +
> +	np = of_find_node_by_phandle(phandle);
> +	if (!np)
> +		return -EINVAL;
> +
> +	part = of_get_property(np, "label", NULL);
> +	if (!part)
> +		part = np->name;
> +
> +	mtd = get_mtd_device_nm(part);
> +	if (IS_ERR(mtd))
> +		return PTR_ERR(mtd);
> +
> +	if (size <= sizeof(*list))
> +		return -EINVAL;
> +
> +	offset = be32_to_cpup(list);
> +	ret = mtd_read(mtd, offset, len, &retlen, dev->eeprom.data);
> +	put_mtd_device(mtd);
> +	if (ret)
> +		return ret;
> +
> +	if (retlen < len)
> +		return -EINVAL;
> +
> +	return 0;
> +#else
> +	return -ENOENT;
> +#endif
> +}
> +
> +void
> +mt76_eeprom_override(struct mt76_dev *dev)
> +{
> +#ifdef CONFIG_OF
> +	struct device_node *np = dev->dev->of_node;
> +	const __be32 *val;
> +	const u8 *mac;
> +	int size;
> +
> +	if (!np)
> +		return;
> +
> +	val = of_get_property(np, "mediatek,2ghz", &size);
> +	if (val)
> +		dev->cap.has_2ghz = be32_to_cpup(val);
> +
> +	val = of_get_property(np, "mediatek,5ghz", &size);
> +	if (val)
> +		dev->cap.has_5ghz = be32_to_cpup(val);
> +
> +	mac = of_get_mac_address(np);
> +	if (mac)
> +		memcpy(dev->macaddr, mac, ETH_ALEN);
> +#endif

All device tree properties need a binding document in
Documentation/devicetree/bindings/ which will be reviewed by the device
tree maintainers.

> +MODULE_LICENSE("GPL");

"GPL v2"?

-- 
Kalle Valo
