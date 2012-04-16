Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6058 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755424Ab2DPVoc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Apr 2012 17:44:32 -0400
Message-ID: <1334612679.5455.4.camel@dcbw.foobar.com> (sfid-20120416_234446_858138_BF23A0ED)
Subject: Re: [RFC 4/4] libertas SDIO: convert to asynchronous firmware
 loading
From: Dan Williams <dcbw@redhat.com>
To: Daniel Drake <dsd@laptop.org>
Cc: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org
Date: Mon, 16 Apr 2012 16:44:39 -0500
In-Reply-To: <20120403160319.B26CF9D401E@zog.reactivated.net>
References: <20120403160319.B26CF9D401E@zog.reactivated.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-04-03 at 17:03 +0100, Daniel Drake wrote:
> Signed-off-by: Daniel Drake <dsd@laptop.org>

Works on my standalone SD8686 dev board; though I do get:

[32350.237619] libertas_sdio mmc0:0001:1: (unregistered net_device):
00:50:43:20:74:05, fw 9.70.3p36, cap 0x00000303
[32350.239847] libertas_sdio mmc0:0001:1: (unregistered net_device):
PREP_CMD: command 0x00a3 failed: 2

where the "unregistered net_device" is a bit odd.  Perhaps we should fix
that before the final series.

Dan

> ---
>  drivers/net/wireless/libertas/if_sdio.c |  210 ++++++++++++++++++-------------
>  1 files changed, 123 insertions(+), 87 deletions(-)
> 
> diff --git a/drivers/net/wireless/libertas/if_sdio.c b/drivers/net/wireless/libertas/if_sdio.c
> index 26c7235..0e0fb2b 100644
> --- a/drivers/net/wireless/libertas/if_sdio.c
> +++ b/drivers/net/wireless/libertas/if_sdio.c
> @@ -117,6 +117,8 @@ struct if_sdio_card {
>  	int			model;
>  	unsigned long		ioport;
>  	unsigned int		scratch_reg;
> +	bool			started;
> +	wait_queue_head_t	pwron_waitq;
>  
>  	u8			buffer[65536] __attribute__((aligned(4)));
>  
> @@ -129,6 +131,9 @@ struct if_sdio_card {
>  	u8			rx_unit;
>  };
>  
> +static void if_sdio_finish_power_on(struct if_sdio_card *card);
> +static int if_sdio_power_off(struct if_sdio_card *card);
> +
>  /********************************************************************/
>  /* I/O                                                              */
>  /********************************************************************/
> @@ -669,12 +674,41 @@ out:
>  	return ret;
>  }
>  
> +static void if_sdio_do_prog_firmware(struct lbs_private *priv, int ret,
> +				     const struct firmware *helper,
> +				     const struct firmware *mainfw)
> +{
> +	struct if_sdio_card *card = priv->card;
> +
> +	if (ret) {
> +		pr_err("failed to find firmware (%d)\n", ret);
> +		return;
> +	}
> +
> +	ret = if_sdio_prog_helper(card, helper);
> +	if (ret)
> +		goto out;
> +
> +	lbs_deb_sdio("Helper firmware loaded\n");
> +
> +	ret = if_sdio_prog_real(card, mainfw);
> +	if (ret)
> +		goto out;
> +
> +	lbs_deb_sdio("Firmware loaded\n");
> +	if_sdio_finish_power_on(card);
> +
> +out:
> +	if (helper)
> +		release_firmware(helper);
> +	if (mainfw)
> +		release_firmware(mainfw);
> +}
> +
>  static int if_sdio_prog_firmware(struct if_sdio_card *card)
>  {
>  	int ret;
>  	u16 scratch;
> -	const struct firmware *helper = NULL;
> -	const struct firmware *mainfw = NULL;
>  
>  	lbs_deb_enter(LBS_DEB_SDIO);
>  
> @@ -708,43 +742,18 @@ static int if_sdio_prog_firmware(struct if_sdio_card *card)
>  	 */
>  	if (scratch == IF_SDIO_FIRMWARE_OK) {
>  		lbs_deb_sdio("firmware already loaded\n");
> -		goto success;
> +		if_sdio_finish_power_on(card);
> +		return 0;
>  	} else if ((card->model == MODEL_8686) && (scratch & 0x7fff)) {
>  		lbs_deb_sdio("firmware may be running\n");
> -		goto success;
> +		if_sdio_finish_power_on(card);
> +		return 0;
>  	}
>  
> -	ret = lbs_get_firmware(&card->func->dev, card->model, &fw_table[0],
> -				&helper, &mainfw);
> -	if (ret) {
> -		pr_err("failed to find firmware (%d)\n", ret);
> -		goto out;
> -	}
> -
> -	ret = if_sdio_prog_helper(card, helper);
> -	if (ret)
> -		goto out;
> -
> -	lbs_deb_sdio("Helper firmware loaded\n");
> -
> -	ret = if_sdio_prog_real(card, mainfw);
> -	if (ret)
> -		goto out;
> -
> -	lbs_deb_sdio("Firmware loaded\n");
> -
> -success:
> -	sdio_claim_host(card->func);
> -	sdio_set_block_size(card->func, IF_SDIO_BLOCK_SIZE);
> -	sdio_release_host(card->func);
> -	ret = 0;
> +	ret = lbs_get_firmware_async(card->priv, &card->func->dev, card->model,
> +				     fw_table, if_sdio_do_prog_firmware);
>  
>  out:
> -	if (helper)
> -		release_firmware(helper);
> -	if (mainfw)
> -		release_firmware(mainfw);
> -
>  	lbs_deb_leave_args(LBS_DEB_SDIO, "ret %d", ret);
>  	return ret;
>  }
> @@ -753,55 +762,15 @@ out:
>  /* Power management                                                 */
>  /********************************************************************/
>  
> -static int if_sdio_power_on(struct if_sdio_card *card)
> +/* Finish power on sequence (after firmware is loaded) */
> +static void if_sdio_finish_power_on(struct if_sdio_card *card)
>  {
>  	struct sdio_func *func = card->func;
>  	struct lbs_private *priv = card->priv;
> -	struct mmc_host *host = func->card->host;
>  	int ret;
>  
>  	sdio_claim_host(func);
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
> -			goto disable;
> -
> -		reg |= SDIO_BUS_ECSI;
> -		sdio_f0_writeb(func, reg, SDIO_CCCR_IF, &ret);
> -		if (ret)
> -			goto disable;
> -	}
> -
> -	card->ioport = sdio_readb(func, IF_SDIO_IOPORT, &ret);
> -	if (ret)
> -		goto disable;
> -
> -	card->ioport |= sdio_readb(func, IF_SDIO_IOPORT + 1, &ret) << 8;
> -	if (ret)
> -		goto disable;
> -
> -	card->ioport |= sdio_readb(func, IF_SDIO_IOPORT + 2, &ret) << 16;
> -	if (ret)
> -		goto disable;
> -
> -	sdio_release_host(func);
> -	ret = if_sdio_prog_firmware(card);
> -	sdio_claim_host(func);
> -	if (ret)
> -		goto disable;
> +	sdio_set_block_size(card->func, IF_SDIO_BLOCK_SIZE);
>  
>  	/*
>  	 * Get rx_unit if the chip is SD8688 or newer.
> @@ -826,7 +795,7 @@ static int if_sdio_power_on(struct if_sdio_card *card)
>  	 */
>  	ret = sdio_claim_irq(func, if_sdio_interrupt);
>  	if (ret)
> -		goto disable;
> +		goto release;
>  
>  	/*
>  	 * Enable interrupts now that everything is set up
> @@ -852,11 +821,79 @@ static int if_sdio_power_on(struct if_sdio_card *card)
>  	}
>  
>  	priv->fw_ready = 1;
> +	wake_up(&card->pwron_waitq);
>  
> -	return 0;
> +	if (!card->started) {
> +		ret = lbs_start_card(priv);
> +		if_sdio_power_off(card);
> +		if (ret == 0) {
> +			card->started = true;
> +			/* Tell PM core that we don't need the card to be
> +			 * powered now */
> +			pm_runtime_put_noidle(&func->dev);
> +		}
> +	}
> +
> +	return;
>  
>  release_irq:
>  	sdio_release_irq(func);
> +release:
> +	sdio_release_host(func);
> +}
> +
> +static int if_sdio_power_on(struct if_sdio_card *card)
> +{
> +	struct sdio_func *func = card->func;
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
> +	if (ret) {
> +		sdio_disable_func(func);
> +		return ret;
> +	}
> +
> +	return 0;
> +
>  disable:
>  	sdio_disable_func(func);
>  release:
> @@ -1063,11 +1100,17 @@ static int if_sdio_power_save(struct lbs_private *priv)
>  static int if_sdio_power_restore(struct lbs_private *priv)
>  {
>  	struct if_sdio_card *card = priv->card;
> +	int r;
>  
>  	/* Make sure the card will not be powered off by runtime PM */
>  	pm_runtime_get_sync(&card->func->dev);
>  
> -	return if_sdio_power_on(card);
> +	r = if_sdio_power_on(card);
> +	if (r)
> +		return r;
> +
> +	wait_event(card->pwron_waitq, priv->fw_ready);
> +	return 0;
>  }
>  
> 
> @@ -1168,6 +1211,7 @@ static int if_sdio_probe(struct sdio_func *func,
>  	spin_lock_init(&card->lock);
>  	card->workqueue = create_workqueue("libertas_sdio");
>  	INIT_WORK(&card->packet_worker, if_sdio_host_to_card_worker);
> +	init_waitqueue_head(&card->pwron_waitq);
>  
>  	/* Check if we support this card */
>  	for (i = 0; i < ARRAY_SIZE(fw_table); i++) {
> @@ -1209,14 +1253,6 @@ static int if_sdio_probe(struct sdio_func *func,
>  	if (ret)
>  		goto err_activate_card;
>  
> -	ret = lbs_start_card(priv);
> -	if_sdio_power_off(card);
> -	if (ret)
> -		goto err_activate_card;
> -
> -	/* Tell PM core that we don't need the card to be powered now */
> -	pm_runtime_put_noidle(&func->dev);
> -
>  out:
>  	lbs_deb_leave_args(LBS_DEB_SDIO, "ret %d", ret);
>  


