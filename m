Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:34851 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbbCKAeV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Mar 2015 20:34:21 -0400
Received: by wggy19 with SMTP id y19so5602205wgg.2
        for <linux-wireless@vger.kernel.org>; Tue, 10 Mar 2015 17:34:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1425915402-10012-2-git-send-email-eliad@wizery.com>
References: <1425915402-10012-1-git-send-email-eliad@wizery.com>
	<1425915402-10012-2-git-send-email-eliad@wizery.com>
Date: Wed, 11 Mar 2015 01:34:19 +0100
Message-ID: <CABxcv=mygdT2Q+ByVKPx4+o_Oj9KSy=zVX9ng9yN25ivkfSn1A@mail.gmail.com> (sfid-20150311_013425_146687_E3199B23)
Subject: Re: [PATCH v5 2/3] wl18xx: add basic device-tree support
From: Javier Martinez Canillas <javier@dowhile0.org>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	Arnd Bergmann <arnd@arndb.de>, Ido Yariv <ido@wizery.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Eliad,

On Mon, Mar 9, 2015 at 4:36 PM, Eliad Peller <eliad@wizery.com> wrote:
> When running with device-tree, we no longer have a board file
> that can set up the platform data for wlcore.
> Allow this data to be passed from DT.
>
> For now, parse only the irq used. Other (optional) properties
> can be added later on.
>
> Signed-off-by: Ido Yariv <ido@wizery.com>
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---

I see this is a v5 but I don't know what was changed from prior
revisions. It would be good if the patches had a versions history.

>  drivers/net/wireless/ti/wlcore/sdio.c | 80 ++++++++++++++++++++++++++++++++---
>  1 file changed, 74 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/net/wireless/ti/wlcore/sdio.c b/drivers/net/wireless/ti/wlcore/sdio.c
> index d3dd7bf..ee556ac 100644
> --- a/drivers/net/wireless/ti/wlcore/sdio.c
> +++ b/drivers/net/wireless/ti/wlcore/sdio.c
> @@ -34,6 +34,8 @@
>  #include <linux/wl12xx.h>
>  #include <linux/pm_runtime.h>
>  #include <linux/printk.h>
> +#include <linux/of.h>
> +#include <linux/of_irq.h>
>
>  #include "wlcore.h"
>  #include "wl12xx_80211.h"
> @@ -214,6 +216,69 @@ static struct wl1271_if_operations sdio_ops = {
>         .set_block_size = wl1271_sdio_set_block_size,
>  };
>
> +#ifdef CONFIG_OF
> +static const struct of_device_id wlcore_sdio_of_match_table[] = {
> +       { .compatible = "ti,wl1801" },
> +       { .compatible = "ti,wl1805" },
> +       { .compatible = "ti,wl1807" },
> +       { .compatible = "ti,wl1831" },
> +       { .compatible = "ti,wl1835" },
> +       { .compatible = "ti,wl1837" },
> +       { }
> +};
> +
> +static struct wl12xx_platform_data *wlcore_probe_of(struct device *dev)
> +{
> +       struct device_node *np = dev->of_node;
> +       struct wl12xx_platform_data *pdata;
> +
> +       if (!np || !of_match_node(wlcore_sdio_of_match_table, np))
> +               return NULL;
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
> +       /* first, look for DT data */

I thought it was the opposite, that platform data should over-rule DT.
That way you can still use the data filled in
arch/arm/mach-omap2/pdata-quirks.c even after the driver supports your
new DT binding.

> +       pdata = wlcore_probe_of(dev);
> +       if (pdata)
> +               return pdata;
> +
> +       /* if not found - fallback to static platform data */
> +       pdata = wl12xx_get_platform_data();
> +       if (!IS_ERR(pdata))
> +               return kmemdup(pdata, sizeof(*pdata), GFP_KERNEL);
> +
> +       dev_err(dev, "No platform data set\n");
> +       return NULL;
> +}
> +
> +static void wlcore_del_platform_data(struct wl12xx_platform_data *pdata)
> +{
> +       kfree(pdata);
> +}
> +

This function seems to be an unnecessary, why not just call kfree() directly?

Or better, maybe the resource-managed devm_*() functions can be used
so the data doesn't have to be explicitly freed?

Best regards,
Javier
