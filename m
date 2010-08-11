Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:58394 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754841Ab0HKSnW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Aug 2010 14:43:22 -0400
From: "DebBarma, Tarun Kanti" <tarun.kanti@ti.com>
To: Ohad Ben-Cohen <ohad@wizery.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
CC: Ido Yariv <ido@wizery.com>,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"Chikkature Rajashekar, Madhusudhan" <madhu.cr@ti.com>,
	Luciano Coelho <luciano.coelho@nokia.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	San Mehat <san@google.com>,
	Roger Quadros <roger.quadros@nokia.com>,
	Tony Lindgren <tony@atomide.com>,
	Nicolas Pitre <nico@fluxnic.net>,
	"Pandita, Vikram" <vikram.pandita@ti.com>,
	Kalle Valo <kalle.valo@iki.fi>
Date: Thu, 12 Aug 2010 00:12:18 +0530
Subject: RE: [PATCH v4 3/8] wireless: wl1271: add platform driver to get
 board data
Message-ID: <5A47E75E594F054BAF48C5E4FC4B92AB0324110ABD@dbde02.ent.ti.com>
References: <1281550913-17633-1-git-send-email-ohad@wizery.com>
 <1281550913-17633-4-git-send-email-ohad@wizery.com>
In-Reply-To: <1281550913-17633-4-git-send-email-ohad@wizery.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ohad,

> -----Original Message-----
> From: linux-omap-owner@vger.kernel.org [mailto:linux-omap-
> owner@vger.kernel.org] On Behalf Of Ohad Ben-Cohen
> Sent: Wednesday, August 11, 2010 11:52 PM
> To: linux-wireless@vger.kernel.org; linux-mmc@vger.kernel.org; linux-
> omap@vger.kernel.org
> Cc: Ido Yariv; Mark Brown; linux-arm-kernel@lists.infradead.org;
> Chikkature Rajashekar, Madhusudhan; Luciano Coelho; akpm@linux-
> foundation.org; San Mehat; Roger Quadros; Tony Lindgren; Nicolas Pitre;
> Pandita, Vikram; Kalle Valo; Ohad Ben-Cohen
> Subject: [PATCH v4 3/8] wireless: wl1271: add platform driver to get board
> data
> 
> Dynamically create and register a platform driver, that will
> be used to to receive board-specific information like irq and
> reference clock numbers.
> 
> The driver is created dynamically in order to avoid the 1-device
> limitation of a fixed platform driver name.
> 
> Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
> ---
>  drivers/net/wireless/wl12xx/wl1271.h      |   12 ++++
>  drivers/net/wireless/wl12xx/wl1271_sdio.c |  103
> +++++++++++++++++++++++++++--
>  2 files changed, 108 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/wireless/wl12xx/wl1271.h
> b/drivers/net/wireless/wl12xx/wl1271.h
> index faa5925..013eabb 100644
> --- a/drivers/net/wireless/wl12xx/wl1271.h
> +++ b/drivers/net/wireless/wl12xx/wl1271.h
> @@ -31,6 +31,7 @@
>  #include <linux/list.h>
>  #include <linux/bitops.h>
>  #include <net/mac80211.h>
> +#include <linux/platform_device.h>
> 
>  #include "wl1271_conf.h"
>  #include "wl1271_ini.h"
> @@ -319,8 +320,19 @@ struct wl1271_if_operations {
>  	void (*disable_irq)(struct wl1271 *wl);
>  };
> 
> +/* exact size needed for "wl1271_plat.x" */
> +#define WL12XX_PLAT_NAME_LEN 14
> +
> +struct wl12xx_plat_instance {
> +	struct platform_driver pdriver;
> +	char name[WL12XX_PLAT_NAME_LEN];
> +	struct wl12xx_platform_data *pdata;
> +	struct completion data_ready;
> +};
> +
>  struct wl1271 {
>  	struct platform_device *plat_dev;
> +	struct wl12xx_plat_instance *pinstance;
>  	struct ieee80211_hw *hw;
>  	bool mac80211_registered;
> 
> diff --git a/drivers/net/wireless/wl12xx/wl1271_sdio.c
> b/drivers/net/wireless/wl12xx/wl1271_sdio.c
> index c41293a..68b512b 100644
> --- a/drivers/net/wireless/wl12xx/wl1271_sdio.c
> +++ b/drivers/net/wireless/wl12xx/wl1271_sdio.c
> @@ -28,7 +28,11 @@
>  #include <linux/mmc/sdio_func.h>
>  #include <linux/mmc/sdio_ids.h>
>  #include <linux/mmc/card.h>
> +#include <linux/mmc/host.h>
> +#include <linux/wl12xx.h>
>  #include <linux/gpio.h>
> +#include <linux/platform_device.h>
> +#include <linux/completion.h>
> 
>  #include "wl1271.h"
>  #include "wl12xx_80211.h"
> @@ -182,10 +186,84 @@ static struct wl1271_if_operations sdio_ops = {
>  	.disable_irq	= wl1271_sdio_disable_interrupts
>  };
> 
> +static int wl1271_plat_probe(struct platform_device *pdev)
> +{
> +	struct wl12xx_platform_data *pdata;
> +	struct platform_driver *pdriver;
> +	struct wl12xx_plat_instance *pinstance;
> +
What about checking for pdev here before extracting pdata?

> +	pdata = pdev->dev.platform_data;
> +	if (!pdata) {
> +		wl1271_error("no platform data");
> +		return -ENODEV;
> +	}
> +
> +	pdriver = container_of(pdev->dev.driver, struct platform_driver,
> +								driver);
> +	pinstance = container_of(pdriver, struct wl12xx_plat_instance,
> pdriver);
> +
> +	pinstance->pdata = pdata;
> +
> +	complete(&pinstance->data_ready);
> +
> +	return 0;
> +}
> +
> +static struct wl12xx_platform_data *wl1271_get_data(struct wl1271 *wl,
> int id)
> +{
> +	int ret;
> +	struct wl12xx_plat_instance *pinstance;
> +
> +	#define WL1271_PLAT_NAME "wl1271_plat.%d"
> +
> +	pinstance = kzalloc(sizeof(*pinstance), GFP_KERNEL);
> +	if (!pinstance)
> +		return ERR_PTR(-ENOMEM);
> +
> +	init_completion(&pinstance->data_ready);
> +
> +	pinstance->pdriver.probe = wl1271_plat_probe;
> +
> +	ret = snprintf(pinstance->name, sizeof(pinstance->name),
> +						WL1271_PLAT_NAME, id);
> +	if (ret >= WL12XX_PLAT_NAME_LEN) {
> +		wl1271_error("truncated plat drv name\n");
> +		goto out_free;
> +	}
> +
> +	pinstance->pdriver.driver.name = pinstance->name;
> +	pinstance->pdriver.driver.owner = THIS_MODULE;
> +
> +	ret = platform_driver_register(&pinstance->pdriver);
> +	if (ret < 0) {
> +		wl1271_error("failed to register plat driver: %d", ret);
> +		goto out_free;
> +	}
> +
> +	ret = wait_for_completion_interruptible_timeout(&pinstance-
> >data_ready,
> +						msecs_to_jiffies(15000));
> +	if (ret <= 0) {
> +		wl1271_error("can't get platform device (%d)", ret);
> +		ret = (ret == 0 ? -EAGAIN : ret);
> +		goto unreg;
> +	}
> +
> +	wl->pinstance = pinstance;
> +
> +	return pinstance->pdata;
> +
> +unreg:
> +	platform_driver_unregister(&pinstance->pdriver);
> +out_free:
> +	kfree(pinstance);
> +	return ERR_PTR(ret);
> +}
> +
>  static int __devinit wl1271_probe(struct sdio_func *func,
>  				  const struct sdio_device_id *id)
>  {
>  	struct ieee80211_hw *hw;
> +	struct wl12xx_platform_data *wlan_data;
>  	struct wl1271 *wl;
>  	int ret;
> 
> @@ -205,17 +283,24 @@ static int __devinit wl1271_probe(struct sdio_func
> *func,
>  	/* Grab access to FN0 for ELP reg. */
>  	func->card->quirks |= MMC_QUIRK_LENIENT_FN0;
> 
> +	wlan_data = wl1271_get_data(wl, func->card->host->index);
> +	if (IS_ERR(wlan_data)) {
> +		ret = PTR_ERR(wlan_data);
> +		wl1271_error("missing wlan data (needed for irq/ref_clk)!");
> +		goto out_free;
> +	}
> +
>  	wl->irq = gpio_to_irq(RX71_WL1271_IRQ_GPIO);
>  	if (wl->irq < 0) {
>  		ret = wl->irq;
>  		wl1271_error("could not get irq!");
> -		goto out_free;
> +		goto put_data;
>  	}
> 
>  	ret = request_irq(wl->irq, wl1271_irq, 0, DRIVER_NAME, wl);
>  	if (ret < 0) {
>  		wl1271_error("request_irq() failed: %d", ret);
> -		goto out_free;
> +		goto put_data;
>  	}
> 
>  	set_irq_type(wl->irq, IRQ_TYPE_EDGE_RISING);
> @@ -236,13 +321,13 @@ static int __devinit wl1271_probe(struct sdio_func
> *func,
> 
>  	return 0;
> 
> - out_irq:
> +out_irq:
>  	free_irq(wl->irq, wl);
> -
> -
> - out_free:
> +put_data:
> +	platform_driver_unregister(&wl->pinstance->pdriver);
> +	kfree(wl->pinstance);
> +out_free:
>  	wl1271_free_hw(wl);
> -
>  	return ret;
>  }
> 
> @@ -253,6 +338,10 @@ static void __devexit wl1271_remove(struct sdio_func
> *func)
>  	free_irq(wl->irq, wl);
> 
>  	wl1271_unregister_hw(wl);
> +
> +	platform_driver_unregister(&wl->pinstance->pdriver);
> +	kfree(wl->pinstance);
> +
>  	wl1271_free_hw(wl);
>  }
> 
> --
> 1.7.0.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
