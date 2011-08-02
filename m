Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:41237 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314Ab1HBJEk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Aug 2011 05:04:40 -0400
Received: by fxh19 with SMTP id 19so5418552fxh.19
        for <linux-wireless@vger.kernel.org>; Tue, 02 Aug 2011 02:04:39 -0700 (PDT)
From: Vasily Khoruzhick <anarsoul@gmail.com>
To: libertas-dev@lists.infradead.org
Subject: Re: [PATCH 2/2] libertas: implement if_sdio runtime power management
Date: Tue, 2 Aug 2011 12:04:08 +0300
Cc: Daniel Drake <dsd@laptop.org>, linville@tuxdriver.com,
	dcbw@redhat.com, linux-wireless@vger.kernel.org
References: <20110801154327.D0BB09D4020@zog.reactivated.net>
In-Reply-To: <20110801154327.D0BB09D4020@zog.reactivated.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201108021204.08632.anarsoul@gmail.com> (sfid-20110802_110444_168562_34FF1EC4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 01 August 2011 18:43:27 Daniel Drake wrote:
> The SDIO card is now fully powered down when the network interface is
> brought down.
> 
> Signed-off-by: Daniel Drake <dsd@laptop.org>
> ---
>  drivers/net/wireless/libertas/if_sdio.c |  277
> +++++++++++++++++++------------ 1 files changed, 171 insertions(+), 106
> deletions(-)
> 
> diff --git a/drivers/net/wireless/libertas/if_sdio.c
> b/drivers/net/wireless/libertas/if_sdio.c index 387786e..c962e21 100644
> --- a/drivers/net/wireless/libertas/if_sdio.c
> +++ b/drivers/net/wireless/libertas/if_sdio.c
> @@ -39,6 +39,7 @@
>  #include <linux/mmc/sdio_ids.h>
>  #include <linux/mmc/sdio.h>
>  #include <linux/mmc/host.h>
> +#include <linux/pm_runtime.h>
> 
>  #include "host.h"
>  #include "decl.h"
> @@ -47,6 +48,8 @@
>  #include "cmd.h"
>  #include "if_sdio.h"
> 
> +static void if_sdio_interrupt(struct sdio_func *func);
> +
>  /* The if_sdio_remove() callback function is called when
>   * user removes this module from kernel space or ejects
>   * the card from the slot. The driver handles these 2 cases
> @@ -757,6 +760,136 @@ out:
>  	return ret;
>  }
> 
> +/********************************************************************/
> +/* Power management                                                 */
> +/********************************************************************/
> +
> +static int if_sdio_power_on(struct if_sdio_card *card)
> +{
> +	struct sdio_func *func = card->func;
> +	struct lbs_private *priv = card->priv;
> +	struct mmc_host *host = func->card->host;
> +	int ret;
> +
> +	sdio_claim_host(func);
> +
> +	ret = sdio_enable_func(func);
> +	if (ret)
> +		goto release;
> +
> +	/* For 1-bit transfers to the 8686 model, we need to enable the
> +	 * interrupt flag in the CCCR register. Set the MMC_QUIRK_LENIENT_FN0
> +	 * bit to allow access to non-vendor registers. */
> +	if ((card->model == MODEL_8686) &&
> +	    (host->caps & MMC_CAP_SDIO_IRQ) &&
> +	    (host->ios.bus_width == MMC_BUS_WIDTH_1)) {
> +		u8 reg;
> +
> +		func->card->quirks |= MMC_QUIRK_LENIENT_FN0;
> +		reg = sdio_f0_readb(func, SDIO_CCCR_IF, &ret);
> +		if (ret)
> +			goto disable;
> +
> +		reg |= SDIO_BUS_ECSI;
> +		sdio_f0_writeb(func, reg, SDIO_CCCR_IF, &ret);
> +		if (ret)
> +			goto disable;
> +	}
> +
> +	card->ioport = sdio_readb(func, IF_SDIO_IOPORT, &ret);
> +	if (ret)
> +		goto disable;
> +
> +	card->ioport |= sdio_readb(func, IF_SDIO_IOPORT + 1, &ret) << 8;
> +	if (ret)
> +		goto disable;
> +
> +	card->ioport |= sdio_readb(func, IF_SDIO_IOPORT + 2, &ret) << 16;
> +	if (ret)
> +		goto disable;
> +
> +	sdio_release_host(func);
> +	ret = if_sdio_prog_firmware(card);
> +	sdio_claim_host(func);
> +	if (ret)
> +		goto disable;
> +
> +	/*
> +	 * Get rx_unit if the chip is SD8688 or newer.
> +	 * SD8385 & SD8686 do not have rx_unit.
> +	 */
> +	if ((card->model != MODEL_8385)
> +			&& (card->model != MODEL_8686))
> +		card->rx_unit = if_sdio_read_rx_unit(card);
> +	else
> +		card->rx_unit = 0;
> +
> +	/*
> +	 * Set up the interrupt handler late.
> +	 *
> +	 * If we set it up earlier, the (buggy) hardware generates a spurious
> +	 * interrupt, even before the interrupt has been enabled, with
> +	 * CCCR_INTx = 0.
> +	 *
> +	 * We register the interrupt handler late so that we can handle any
> +	 * spurious interrupts, and also to avoid generation of that known
> +	 * spurious interrupt in the first place.
> +	 */
> +	ret = sdio_claim_irq(func, if_sdio_interrupt);
> +	if (ret)
> +		goto disable;
> +
> +	/*
> +	 * Enable interrupts now that everything is set up
> +	 */
> +	sdio_writeb(func, 0x0f, IF_SDIO_H_INT_MASK, &ret);
> +	if (ret)
> +		goto release_irq;
> +
> +	sdio_release_host(func);
> +
> +	/*
> +	 * FUNC_INIT is required for SD8688 WLAN/BT multiple functions
> +	 */
> +	if (card->model == MODEL_8688) {
> +		struct cmd_header cmd;
> +
> +		memset(&cmd, 0, sizeof(cmd));
> +
> +		lbs_deb_sdio("send function INIT command\n");
> +		if (__lbs_cmd(priv, CMD_FUNC_INIT, &cmd, sizeof(cmd),
> +				lbs_cmd_copyback, (unsigned long) &cmd))
> +			netdev_alert(priv->dev, "CMD_FUNC_INIT cmd failed\n");
> +	}
> +
> +	priv->fw_ready = 1;
> +
> +	return 0;
> +
> +release_irq:
> +	sdio_release_irq(func);
> +disable:
> +	sdio_disable_func(func);
> +release:
> +	sdio_release_host(func);
> +	return ret;
> +}
> +
> +static int if_sdio_power_off(struct if_sdio_card *card)
> +{
> +	struct sdio_func *func = card->func;
> +	struct lbs_private *priv = card->priv;
> +
> +	priv->fw_ready = 0;
> +
> +	sdio_claim_host(func);
> +	sdio_release_irq(func);
> +	sdio_disable_func(func);
> +	sdio_release_host(func);
> +	return 0;
> +}
> +
> +
>  /*******************************************************************/
>  /* Libertas callbacks                                              */
>  /*******************************************************************/
> @@ -923,6 +1056,32 @@ static void if_sdio_reset_card(struct lbs_private
> *priv) schedule_work(&card_reset_work);
>  }
> 
> +static int if_sdio_power_save(struct lbs_private *priv)
> +{
> +	struct if_sdio_card *card = priv->card;
> +	int ret;
> +
> +	flush_workqueue(card->workqueue);
> +
> +	ret = if_sdio_power_off(card);
> +
> +	/* Let runtime PM know the card is powered off */
> +	pm_runtime_put_sync(&card->func->dev);
> +
> +	return ret;
> +}
> +
> +static int if_sdio_power_restore(struct lbs_private *priv)
> +{
> +	struct if_sdio_card *card = priv->card;
> +
> +	/* Make sure the card will not be powered off by runtime PM */
> +	pm_runtime_get_sync(&card->func->dev);
> +
> +	return if_sdio_power_on(card);
> +}
> +
> +
>  /*******************************************************************/
>  /* SDIO callbacks                                                  */
>  /*******************************************************************/
> @@ -976,7 +1135,6 @@ static int if_sdio_probe(struct sdio_func *func,
>  	int ret, i;
>  	unsigned int model;
>  	struct if_sdio_packet *packet;
> -	struct mmc_host *host = func->card->host;
> 
>  	lbs_deb_enter(LBS_DEB_SDIO);
> 
> @@ -1033,45 +1191,6 @@ static int if_sdio_probe(struct sdio_func *func,
>  		goto free;
>  	}
> 
> -	sdio_claim_host(func);
> -
> -	ret = sdio_enable_func(func);
> -	if (ret)
> -		goto release;
> -
> -	/* For 1-bit transfers to the 8686 model, we need to enable the
> -	 * interrupt flag in the CCCR register. Set the MMC_QUIRK_LENIENT_FN0
> -	 * bit to allow access to non-vendor registers. */
> -	if ((card->model == MODEL_8686) &&
> -	    (host->caps & MMC_CAP_SDIO_IRQ) &&
> -	    (host->ios.bus_width == MMC_BUS_WIDTH_1)) {
> -		u8 reg;
> -
> -		func->card->quirks |= MMC_QUIRK_LENIENT_FN0;
> -		reg = sdio_f0_readb(func, SDIO_CCCR_IF, &ret);
> -		if (ret)
> -			goto release_int;
> -
> -		reg |= SDIO_BUS_ECSI;
> -		sdio_f0_writeb(func, reg, SDIO_CCCR_IF, &ret);
> -		if (ret)
> -			goto release_int;
> -	}
> -
> -	card->ioport = sdio_readb(func, IF_SDIO_IOPORT, &ret);
> -	if (ret)
> -		goto release_int;
> -
> -	card->ioport |= sdio_readb(func, IF_SDIO_IOPORT + 1, &ret) << 8;
> -	if (ret)
> -		goto release_int;
> -
> -	card->ioport |= sdio_readb(func, IF_SDIO_IOPORT + 2, &ret) << 16;
> -	if (ret)
> -		goto release_int;
> -
> -	sdio_release_host(func);
> -
>  	sdio_set_drvdata(func, card);
> 
>  	lbs_deb_sdio("class = 0x%X, vendor = 0x%X, "
> @@ -1079,14 +1198,11 @@ static int if_sdio_probe(struct sdio_func *func,
>  			func->class, func->vendor, func->device,
>  			model, (unsigned)card->ioport);
> 
> -	ret = if_sdio_prog_firmware(card);
> -	if (ret)
> -		goto reclaim;
> 
>  	priv = lbs_add_card(card, &func->dev);
>  	if (!priv) {
>  		ret = -ENOMEM;
> -		goto reclaim;
> +		goto free;
>  	}
> 
>  	card->priv = priv;
> @@ -1097,62 +1213,21 @@ static int if_sdio_probe(struct sdio_func *func,
>  	priv->exit_deep_sleep = if_sdio_exit_deep_sleep;
>  	priv->reset_deep_sleep_wakeup = if_sdio_reset_deep_sleep_wakeup;
>  	priv->reset_card = if_sdio_reset_card;
> +	priv->power_save = if_sdio_power_save;
> +	priv->power_restore = if_sdio_power_restore;
> 
> -	sdio_claim_host(func);
> -
> -	/*
> -	 * Get rx_unit if the chip is SD8688 or newer.
> -	 * SD8385 & SD8686 do not have rx_unit.
> -	 */
> -	if ((card->model != MODEL_8385)
> -			&& (card->model != MODEL_8686))
> -		card->rx_unit = if_sdio_read_rx_unit(card);
> -	else
> -		card->rx_unit = 0;
> -
> -	/*
> -	 * Set up the interrupt handler late.
> -	 *
> -	 * If we set it up earlier, the (buggy) hardware generates a spurious
> -	 * interrupt, even before the interrupt has been enabled, with
> -	 * CCCR_INTx = 0.
> -	 *
> -	 * We register the interrupt handler late so that we can handle any
> -	 * spurious interrupts, and also to avoid generation of that known
> -	 * spurious interrupt in the first place.
> -	 */
> -	ret = sdio_claim_irq(func, if_sdio_interrupt);
> -	if (ret)
> -		goto disable;
> -
> -	/*
> -	 * Enable interrupts now that everything is set up
> -	 */
> -	sdio_writeb(func, 0x0f, IF_SDIO_H_INT_MASK, &ret);
> -	sdio_release_host(func);
> +	ret = if_sdio_power_on(card);

Why do you power on card here? Maybe it's possible do it in lbs_start_card?

>  	if (ret)
> -		goto reclaim;
> -
> -	priv->fw_ready = 1;
> -
> -	/*
> -	 * FUNC_INIT is required for SD8688 WLAN/BT multiple functions
> -	 */
> -	if (card->model == MODEL_8688) {
> -		struct cmd_header cmd;
> -
> -		memset(&cmd, 0, sizeof(cmd));
> -
> -		lbs_deb_sdio("send function INIT command\n");
> -		if (__lbs_cmd(priv, CMD_FUNC_INIT, &cmd, sizeof(cmd),
> -				lbs_cmd_copyback, (unsigned long) &cmd))
> -			netdev_alert(priv->dev, "CMD_FUNC_INIT cmd failed\n");
> -	}
> +		goto err_activate_card;
> 
>  	ret = lbs_start_card(priv);
> +	if_sdio_power_off(card);

Same for power off.

>  	if (ret)
>  		goto err_activate_card;
> 
> +	/* Tell PM core that we don't need the card to be powered now */
> +	pm_runtime_put_noidle(&func->dev);
> +
>  out:
>  	lbs_deb_leave_args(LBS_DEB_SDIO, "ret %d", ret);
> 
> @@ -1161,14 +1236,6 @@ out:
>  err_activate_card:
>  	flush_workqueue(card->workqueue);
>  	lbs_remove_card(priv);
> -reclaim:
> -	sdio_claim_host(func);
> -release_int:
> -	sdio_release_irq(func);
> -disable:
> -	sdio_disable_func(func);
> -release:
> -	sdio_release_host(func);
>  free:
>  	destroy_workqueue(card->workqueue);
>  	while (card->packets) {
> @@ -1195,6 +1262,9 @@ static void if_sdio_remove(struct sdio_func *func)
> 
>  	card = sdio_get_drvdata(func);
> 
> +	/* Undo decrement done above in if_sdio_probe */
> +	pm_runtime_get_noresume(&func->dev);
> +
>  	if (user_rmmod && (card->model == MODEL_8688)) {
>  		/*
>  		 * FUNC_SHUTDOWN is required for SD8688 WLAN/BT
> @@ -1219,11 +1289,6 @@ static void if_sdio_remove(struct sdio_func *func)
>  	flush_workqueue(card->workqueue);
>  	destroy_workqueue(card->workqueue);
> 
> -	sdio_claim_host(func);
> -	sdio_release_irq(func);
> -	sdio_disable_func(func);
> -	sdio_release_host(func);
> -
>  	while (card->packets) {
>  		packet = card->packets;
>  		card->packets = card->packets->next;

Regards
Vasily
