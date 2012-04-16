Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23700 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755181Ab2DPVps (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Apr 2012 17:45:48 -0400
Message-ID: <1334612755.5455.6.camel@dcbw.foobar.com> (sfid-20120416_234551_118659_520E2460)
Subject: Re: [RFT] libertas SPI: convert to asynchronous firmware loading
From: Dan Williams <dcbw@redhat.com>
To: Daniel Drake <dsd@laptop.org>
Cc: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org
Date: Mon, 16 Apr 2012 16:45:55 -0500
In-Reply-To: <20120409202402.8523E9D401E@zog.reactivated.net>
References: <20120409202402.8523E9D401E@zog.reactivated.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-04-09 at 21:24 +0100, Daniel Drake wrote:
> Signed-off-by: Daniel Drake <dsd@laptop.org>
> ---
>  drivers/net/wireless/libertas/if_spi.c |  137 +++++++++++++++++++------------
>  1 files changed, 84 insertions(+), 53 deletions(-)
> 
> Request for testing.

Unfortunately I have no way of testing the SPI stuff so we'll have to
rely on others for that :(

Dan

> Requires these patches first:
> 
> [RFC 1/4] libertas: Firmware loading simplifications
> [RFC 2/4] libertas: harden-up exit paths
> [RFC 3/4] libertas: add asynchronous firmware loading capability
> 
> Compile tested only - I don't have the hardware.
> 
> diff --git a/drivers/net/wireless/libertas/if_spi.c b/drivers/net/wireless/libertas/if_spi.c
> index 3a05b58..b948ea78 100644
> --- a/drivers/net/wireless/libertas/if_spi.c
> +++ b/drivers/net/wireless/libertas/if_spi.c
> @@ -76,8 +76,13 @@ struct if_spi_card {
>  
>  	/* True is card suspended */
>  	u8				suspended;
> +
> +	/* True when card is started */
> +	u8				started;
>  };
>  
> +static void if_spi_finish_init(struct if_spi_card *card);
> +
>  static void free_if_spi_card(struct if_spi_card *card)
>  {
>  	struct list_head *cursor, *next;
> @@ -671,6 +676,47 @@ out:
>  	return err;
>  }
>  
> +static void if_spi_prog_firmware(struct lbs_private *priv, int err,
> +				 const struct firmware *helper,
> +				 const struct firmware *mainfw)
> +{
> +	struct if_spi_card *card = priv->card;
> +
> +	if (err) {
> +		netdev_err(priv->dev, "failed to find firmware (%d)\n", err);
> +		return;
> +	}
> +
> +	lbs_deb_spi("Initializing FW for Marvell WLAN 802.11 adapter "
> +			"(chip_id = 0x%04x, chip_rev = 0x%02x) "
> +			"attached to SPI bus_num %d, chip_select %d. "
> +			"spi->max_speed_hz=%d\n",
> +			card->card_id, card->card_rev,
> +			card->spi->master->bus_num,
> +			card->spi->chip_select,
> +			card->spi->max_speed_hz);
> +	err = if_spi_prog_helper_firmware(card, helper);
> +	if (err)
> +		goto out;
> +	err = if_spi_prog_main_firmware(card, mainfw);
> +	if (err)
> +		goto out;
> +	lbs_deb_spi("loaded FW for Marvell WLAN 802.11 adapter\n");
> +
> +	err = spu_set_interrupt_mode(card, 0, 1);
> +	if (err)
> +		goto out;
> +
> +	if (!card->started)
> +		if_spi_finish_init(card);
> +
> +out:
> +	if (helper)
> +		release_firmware(helper);
> +	if (mainfw)
> +		release_firmware(mainfw);
> +}
> +
>  /*
>   * SPI Transfer Thread
>   *
> @@ -1033,8 +1079,6 @@ static int if_spi_init_card(struct if_spi_card *card)
>  	struct lbs_private *priv = card->priv;
>  	int err, i;
>  	u32 scratch;
> -	const struct firmware *helper = NULL;
> -	const struct firmware *mainfw = NULL;
>  
>  	lbs_deb_enter(LBS_DEB_SPI);
>  
> @@ -1051,6 +1095,11 @@ static int if_spi_init_card(struct if_spi_card *card)
>  	if (scratch == SUCCESSFUL_FW_DOWNLOAD_MAGIC)
>  		lbs_deb_spi("Firmware is already loaded for "
>  			    "Marvell WLAN 802.11 adapter\n");
> +		err = spu_set_interrupt_mode(card, 0, 1);
> +		if (err)
> +			goto out;
> +		if (!card->started)
> +			if_spi_finish_init(card);
>  	else {
>  		/* Check if we support this card */
>  		for (i = 0; i < ARRAY_SIZE(fw_table); i++) {
> @@ -1064,41 +1113,17 @@ static int if_spi_init_card(struct if_spi_card *card)
>  			goto out;
>  		}
>  
> -		err = lbs_get_firmware(&card->spi->dev, card->card_id,
> -					&fw_table[0], &helper, &mainfw);
> +		err = lbs_get_firmware_async(priv, &card->spi->dev,
> +					     card->card_id, fw_table,
> +					     if_spi_prog_firmware);
>  		if (err) {
> -			netdev_err(priv->dev, "failed to find firmware (%d)\n",
> +			netdev_err(priv->dev, "failed to request firmware (%d)\n",
>  				   err);
>  			goto out;
>  		}
> -
> -		lbs_deb_spi("Initializing FW for Marvell WLAN 802.11 adapter "
> -				"(chip_id = 0x%04x, chip_rev = 0x%02x) "
> -				"attached to SPI bus_num %d, chip_select %d. "
> -				"spi->max_speed_hz=%d\n",
> -				card->card_id, card->card_rev,
> -				card->spi->master->bus_num,
> -				card->spi->chip_select,
> -				card->spi->max_speed_hz);
> -		err = if_spi_prog_helper_firmware(card, helper);
> -		if (err)
> -			goto out;
> -		err = if_spi_prog_main_firmware(card, mainfw);
> -		if (err)
> -			goto out;
> -		lbs_deb_spi("loaded FW for Marvell WLAN 802.11 adapter\n");
>  	}
>  
> -	err = spu_set_interrupt_mode(card, 0, 1);
> -	if (err)
> -		goto out;
> -
>  out:
> -	if (helper)
> -		release_firmware(helper);
> -	if (mainfw)
> -		release_firmware(mainfw);
> -
>  	lbs_deb_leave_args(LBS_DEB_SPI, "err %d\n", err);
>  
>  	return err;
> @@ -1126,6 +1151,32 @@ static void if_spi_resume_worker(struct work_struct *work)
>  	}
>  }
>  
> +static void if_spi_finish_init(struct if_spi_card *card)
> +{
> +	int err = request_irq(card->spi->irq, if_spi_host_interrupt,
> +			      IRQF_TRIGGER_FALLING, "libertas_spi", card);
> +	if (err) {
> +		pr_err("can't get host irq line-- request_irq failed\n");
> +		return;
> +	}
> +
> +	/*
> +	 * Start the card.
> +	 * This will call register_netdev, and we'll start
> +	 * getting interrupts...
> +	 */
> +	err = lbs_start_card(card->priv);
> +	if (err)
> +		goto release_irq;
> +
> +	card->started = true;
> +	lbs_deb_spi("Finished initializing WLAN module.\n");
> +	return;
> +
> +release_irq:
> +	free_irq(card->spi->irq, card);
> +}
> +
>  static int __devinit if_spi_probe(struct spi_device *spi)
>  {
>  	struct if_spi_card *card;
> @@ -1163,11 +1214,6 @@ static int __devinit if_spi_probe(struct spi_device *spi)
>  
>  	/* Initialize the SPI Interface Unit */
>  
> -	/* Firmware load */
> -	err = if_spi_init_card(card);
> -	if (err)
> -		goto free_card;
> -
>  	/*
>  	 * Register our card with libertas.
>  	 * This will call alloc_etherdev.
> @@ -1191,29 +1237,14 @@ static int __devinit if_spi_probe(struct spi_device *spi)
>  	INIT_WORK(&card->packet_work, if_spi_host_to_card_worker);
>  	INIT_WORK(&card->resume_work, if_spi_resume_worker);
>  
> -	err = request_irq(spi->irq, if_spi_host_interrupt,
> -			IRQF_TRIGGER_FALLING, "libertas_spi", card);
> -	if (err) {
> -		pr_err("can't get host irq line-- request_irq failed\n");
> -		goto terminate_workqueue;
> -	}
> -
> -	/*
> -	 * Start the card.
> -	 * This will call register_netdev, and we'll start
> -	 * getting interrupts...
> -	 */
> -	err = lbs_start_card(priv);
> +	/* Firmware load */
> +	err = if_spi_init_card(card);
>  	if (err)
> -		goto release_irq;
> -
> -	lbs_deb_spi("Finished initializing WLAN module.\n");
> +		goto terminate_workqueue;
>  
>  	/* successful exit */
>  	goto out;
>  
> -release_irq:
> -	free_irq(spi->irq, card);
>  terminate_workqueue:
>  	flush_workqueue(card->workqueue);
>  	destroy_workqueue(card->workqueue);


