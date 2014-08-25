Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.10]:65313 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753889AbaHYIEg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Aug 2014 04:04:36 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Hauke Mehrtens <hauke@hauke-m.de>, linux-wireless@vger.kernel.org,
	devicetree@vger.kernel.org, linux-mips@linux-mips.org,
	zajec5@gmail.com
Subject: Re: [RFC 6/7] bcma: get sprom from devicetree
Date: Mon, 25 Aug 2014 10:04:33 +0200
Message-ID: <4882662.VtlSfZ0rSN@wuerfel> (sfid-20140825_100442_523789_6CD4158B)
In-Reply-To: <1408915485-8078-8-git-send-email-hauke@hauke-m.de>
References: <1408915485-8078-1-git-send-email-hauke@hauke-m.de> <1408915485-8078-8-git-send-email-hauke@hauke-m.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 24 August 2014 23:24:44 Hauke Mehrtens wrote:
> +#ifdef CONFIG_OF
> +static int bcma_fill_sprom_with_dt(struct bcma_bus *bus,
> +                                  struct ssb_sprom *out)
> +{
> +       const __be32 *handle;
> +       struct device_node *sprom_node;
> +       struct platform_device *sprom_dev;
> +       struct ssb_sprom *sprom;
> +
> +       if (!bus->host_pdev || !bus->host_pdev->dev.of_node)
> +               return -ENOENT;

You can remove the #ifdef above if you change this into

	if (!IS_ENABLED(CONFIG_OF) || !bus->host_pdev ||
	    !bus->host_pdev->dev.of_node)
		return -ENOENT;

> +       handle = of_get_property(bus->host_pdev->dev.of_node, "sprom", NULL);
> +       if (!handle)
> +               return -ENOENT;
> +
> +       sprom_node = of_find_node_by_phandle(be32_to_cpup(handle));
> +       if (!sprom_node)
> +               return -ENOENT;
> +
> +       sprom_dev = of_find_device_by_node(sprom_node);
> +       if (!sprom_dev)
> +               return -ENOENT;
> +
> +       sprom = platform_get_drvdata(sprom_dev);
> +       if (!sprom)
> +               return -ENOENT;
> +
> +       memcpy(out, sprom, sizeof(*out));
> +
> +       return 0;
> +}

missing of_node_put().

	Arnd
