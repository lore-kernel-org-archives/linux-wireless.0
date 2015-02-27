Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.187]:60694 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754564AbbB0I0W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Feb 2015 03:26:22 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
	Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v3 2/2] wl18xx: add basic device-tree support
Date: Fri, 27 Feb 2015 09:26:13 +0100
Message-ID: <2194797.iarD5YIxEd@wuerfel> (sfid-20150227_092629_947331_4D0D6733)
In-Reply-To: <1424362401-8228-2-git-send-email-eliad@wizery.com>
References: <1424362401-8228-1-git-send-email-eliad@wizery.com> <1424362401-8228-2-git-send-email-eliad@wizery.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 19 February 2015 18:13:21 Eliad Peller wrote:
> +
> +static struct wl12xx_platform_data *wlcore_probe_of(struct device *dev)
> +{
> +       struct device_node *np = dev->of_node;
> +       struct wl12xx_platform_data *pdata;
> +
> +       if (!np || !of_match_node(wlcore_sdio_of_match_table, np)) {
> +               dev_err(dev, "No platform data set\n");
> +               return NULL;
> +       }
> +
> +       pdata = kzalloc(sizeof(*pdata), GFP_KERNEL);
> +       if (!pdata)
> +               return NULL;
> +
> +       pdata->irq = irq_of_parse_and_map(np, 0);
> +       if (!pdata->irq) {
> +               dev_err(dev, "No irq in platform data\n");
> +               kfree(pdata);
> +               return NULL;
> +       }
> +
> +       return pdata;
> +}
> +#else
> +static struct wl12xx_platform_data *wlcore_probe_of(struct device *dev)
> +{
> +       return NULL;
> +}
> +#endif
> +
> +static struct wl12xx_platform_data *
> +wlcore_get_platform_data(struct device *dev)
> +{
> +       struct wl12xx_platform_data *pdata;
> +
> +       pdata = wl12xx_get_platform_data();
> +       if (!IS_ERR(pdata))
> +               return kmemdup(pdata, sizeof(*pdata), GFP_KERNEL);
> +
> +       return wlcore_probe_of(dev);
> +}

I think the probe_of needs to come first here, otherwise you cannot
override the pdata quirk with actual DT data.

I've looked up the what boards actually use this data and found that
all of them already support booting from DT: some omap2 boards using
arch/arm/mach-omap2/pdata-quirks.c to provide the data, and the
davinci 850evm. Can you make sure you add the correct data to all
of these dts files as part of your series and remove the
wl12xx_platform_data references?

	Arnd
