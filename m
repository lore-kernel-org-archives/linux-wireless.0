Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:47973 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750884AbbG3KWv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2015 06:22:51 -0400
Message-ID: <1438251763.15571.29.camel@tiscali.nl> (sfid-20150730_122311_848529_CC3DC71F)
Subject: Re: [PATCH] nfc: s3fwrn5: Add driver for Samsung S3FWRN5 NFC Chip
From: Paul Bolle <pebolle@tiscali.nl>
To: Robert Baldyga <r.baldyga@samsung.com>
Cc: lauro.venancio@openbossa.org, aloisio.almeida@openbossa.org,
	sameo@linux.intel.com, robh+dt@kernel.org, pawel.moll@arm.com,
	mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
	galak@codeaurora.org, linux-wireless@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-nfc@lists.01.org, m.szyprowski@samsung.com
Date: Thu, 30 Jul 2015 12:22:43 +0200
In-Reply-To: <1438172116-27099-1-git-send-email-r.baldyga@samsung.com>
References: <1438172116-27099-1-git-send-email-r.baldyga@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On wo, 2015-07-29 at 14:15 +0200, Robert Baldyga wrote:
> --- /dev/null
> +++ b/drivers/nfc/s3fwrn5/Kconfig
> @@ -0,0 +1,22 @@
> +config NFC_S3FWRN5
> +	tristate "Samsung S3FWRN5 NFC driver"
> +	depends on NFC_NCI
> +	default n
> +	---help---
> +	  Core driver for Samsung S3FWRN5 NFC chip.
> +
> +	  To compile this driver as a module, choose m here. The module will
> +	  be called s3fwrn5.ko.
> +	  Say N if unsure.

If I scanned the code correctly then all this module does is exporting
three functions to s3fwrn5_i2c.ko. Note that there's also no
module_unit() in sight. So it's a library, of sorts. And there's no
reason to load this module without also loading s3fwrn5_i2c.ko. Likewise
there's no reason to build it without also building s3fwrn5_i2c.ko.

So perhaps you could merge the two Kconfig symbols you add in this
patch.

Or, if you'd like to keep both Kconfig symbols, for whatever reason, you
might want to make NFC_S3FWRN5 a "silent" symbol that will be selected
by NFC_S3FWRN5_I2C. (That probably requires NFC_S3FWRN5_I2C to depend on
both NFC_NCI and I2C.)

Would either of the above two options work here?

> +config NFC_S3FWRN5_I2C
> +	tristate "Samsung S3FWRN5 I2C support"
> +	depends on NFC_S3FWRN5 && I2C
> +	default y

You only added "default y" to make setting this symbol in "make *config"
a one step process, right?

> +	---help---
> +	  This module adds support for an I2C interface to the S3FWRN5 chip.
> +	  Select this if your platform is using the I2C bus.
> +
> +	  To compile this driver as a module, choose m here. The module will
> +	  be called s3fwrn5_i2c.ko.
> +	  Say N if unsure.

(This advice is at odds with "default y" above, by the way.)

> --- /dev/null
> +++ b/drivers/nfc/s3fwrn5/Makefile

> +s3fwrn5-objs = core.o firmware.o nci.o
> +s3fwrn5_i2c-objs = i2c.o
> +
> +obj-$(CONFIG_NFC_S3FWRN5) += s3fwrn5.o
> +obj-$(CONFIG_NFC_S3FWRN5_I2C) += s3fwrn5_i2c.o

> --- /dev/null
> +++ b/drivers/nfc/s3fwrn5/core.c

> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms and conditions of the GNU General Public License,
> + * version 2, as published by the Free Software Foundation.

> +int s3fwrn5_probe(struct nci_dev **ndev, void *phy_id, struct device *pdev,
> +	struct s3fwrn5_phy_ops *phy_ops, unsigned int max_payload)
> +{
> +	[...]
> +}
> +EXPORT_SYMBOL(s3fwrn5_probe);
> +
> +void s3fwrn5_remove(struct nci_dev *ndev)
> +{
> +	[...]
> +}
> +EXPORT_SYMBOL(s3fwrn5_remove);
> +
> +int s3fwrn5_recv_frame(struct nci_dev *ndev, struct sk_buff *skb,
> +	enum s3fwrn5_mode mode)
> +{
> +	[...]
> +}
> +EXPORT_SYMBOL(s3fwrn5_recv_frame);

> +MODULE_LICENSE("GPL");

> --- /dev/null
> +++ b/drivers/nfc/s3fwrn5/i2c.c

> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms and conditions of the GNU General Public License,
> + * version 2, as published by the Free Software Foundation.

> +static int s3fwrn5_i2c_fw_read(struct s3fwrn5_i2c_phy *phy)
> +{
> +	[...]
> +
> +	return s3fwrn5_recv_frame(phy->ndev, skb, S3FWRN5_MODE_FW);
> +}
> +
> +static int s3fwrn5_i2c_nci_read(struct s3fwrn5_i2c_phy *phy)
> +{
> +	[...]
> +
> +	return s3fwrn5_recv_frame(phy->ndev, skb, S3FWRN5_MODE_NCI);
> +}

> +static int s3fwrn5_i2c_probe(struct i2c_client *client,
> +				  const struct i2c_device_id *id)
> +{
> +	[...]
> +
> +	ret = s3fwrn5_probe(&phy->ndev, phy, &phy->i2c_dev->dev, &i2c_phy_ops,
> +		S3FWRN5_I2C_MAX_PAYLOAD);
> +	[...]
> +		s3fwrn5_remove(phy->ndev);
> +
> +	[...]
> +}
> +
> +static int s3fwrn5_i2c_remove(struct i2c_client *client)
> +{
> +	[...]
> +
> +	s3fwrn5_remove(phy->ndev);
> +
> +	[...]
> +}

> +MODULE_LICENSE("GPL");

Nit: both modules' code contain a comment referring to the "GNU General
Public License, version 2". They also both use the "GPL" ident in their
MODULE_LICENSE() macro. And, according to include/linux/module.h, that
ident states the license is GPL v2 or later. So I think either the
comments or the idents need to change.

Thanks,


Paul Bolle
