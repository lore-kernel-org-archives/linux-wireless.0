Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:41637 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862Ab0KDNv6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Nov 2010 09:51:58 -0400
Received: by ywc21 with SMTP id 21so1381911ywc.19
        for <linux-wireless@vger.kernel.org>; Thu, 04 Nov 2010 06:51:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1288822429-24541-3-git-send-email-notasas@gmail.com>
References: <1288822429-24541-1-git-send-email-notasas@gmail.com> <1288822429-24541-3-git-send-email-notasas@gmail.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Thu, 4 Nov 2010 09:51:24 -0400
Message-ID: <AANLkTimfXO9r=DTW3CAiVswmsoKES2qxEiYz4JBOTGu_@mail.gmail.com>
Subject: Re: [PATCH 2/3] wl1251: add runtime PM support for SDIO
To: Grazvydas Ignotas <notasas@gmail.com>
Cc: linux-wireless@vger.kernel.org, Kalle Valo <kvalo@adurom.com>,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 3, 2010 at 6:13 PM, Grazvydas Ignotas <notasas@gmail.com> wrote:
> Add runtime PM support, similar to how it's done for wl1271.
> This allows to power down the card when the driver is loaded but
> network is not in use.
>
> CC: Ohad Ben-Cohen <ohad@wizery.com>
> Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>
> ---
>  drivers/net/wireless/wl1251/sdio.c |   62 ++++++++++++++++++++++++++++++++++--
>  1 files changed, 59 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/wireless/wl1251/sdio.c b/drivers/net/wireless/wl1251/sdio.c
> index 0285190..0a5db21 100644
> --- a/drivers/net/wireless/wl1251/sdio.c
> +++ b/drivers/net/wireless/wl1251/sdio.c
> @@ -26,6 +26,7 @@
>  #include <linux/platform_device.h>
>  #include <linux/wl12xx.h>
>  #include <linux/irq.h>
> +#include <linux/pm_runtime.h>
>
>  #include "wl1251.h"
>
> @@ -173,10 +174,36 @@ static void wl1251_disable_line_irq(struct wl1251 *wl)
>
>  static int wl1251_sdio_set_power(struct wl1251 *wl, bool enable)
>  {
> -       if (wl->set_power)
> -               wl->set_power(enable);
> +       struct sdio_func *func = wl_to_func(wl);
> +       int ret;
>
> -       return 0;
> +       if (enable) {
> +               /* Power up the card */
> +               if (wl->set_power)
> +                       wl->set_power(true);

Why do you still need that ->set_power() handler ?

> +
> +               ret = pm_runtime_get_sync(&func->dev);

This call should do all the power-related work for you (assuming you
have a fixed regulator in place).


> +               if (ret < 0)
> +                       goto out;
> +
> +               sdio_claim_host(func);
> +               sdio_enable_func(func);
> +               sdio_release_host(func);
> +       } else {
> +               sdio_claim_host(func);
> +               sdio_disable_func(func);
> +               sdio_release_host(func);
> +
> +               ret = pm_runtime_put_sync(&func->dev);
> +               if (ret < 0)
> +                       goto out;
> +
> +               if (wl->set_power)
> +                       wl->set_power(false);
> +       }
> +
> +out:
> +       return ret;
>  }
>
>  static struct wl1251_if_operations wl1251_sdio_ops = {
> @@ -277,6 +304,10 @@ static int wl1251_sdio_probe(struct sdio_func *func,
>                goto out_free_irq;
>
>        sdio_set_drvdata(func, wl);
> +
> +       /* Tell PM core that we don't need the card to be powered now */
> +       pm_runtime_put_noidle(&func->dev);
> +
>        return ret;
>
>  out_free_irq:
> @@ -298,6 +329,9 @@ static void __devexit wl1251_sdio_remove(struct sdio_func *func)
>        struct wl1251 *wl = sdio_get_drvdata(func);
>        struct wl1251_sdio *wl_sdio = wl->if_priv;
>
> +       /* Undo decrement done above in wl1271_probe */
> +       pm_runtime_get_noresume(&func->dev);
> +
>        if (wl->irq)
>                free_irq(wl->irq, wl);
>        kfree(wl_sdio);
> @@ -309,11 +343,33 @@ static void __devexit wl1251_sdio_remove(struct sdio_func *func)
>        sdio_release_host(func);
>  }
>
> +static int wl1251_suspend(struct device *dev)
> +{
> +       /*
> +        * Tell MMC/SDIO core it's OK to power down the card
> +        * (if it isn't already), but not to remove it completely
> +        */
> +       return 0;
> +}
> +
> +static int wl1251_resume(struct device *dev)
> +{
> +       return 0;
> +}
> +
> +static const struct dev_pm_ops wl1251_sdio_pm_ops = {
> +       .suspend        = wl1251_suspend,
> +       .resume         = wl1251_resume,
> +};
> +
>  static struct sdio_driver wl1251_sdio_driver = {
>        .name           = "wl1251_sdio",
>        .id_table       = wl1251_devices,
>        .probe          = wl1251_sdio_probe,
>        .remove         = __devexit_p(wl1251_sdio_remove),
> +       .drv = {
> +               .pm     = &wl1251_sdio_pm_ops,
> +       },
>  };
>
>  static int __init wl1251_sdio_init(void)
> --
> 1.6.3.3
>
>
