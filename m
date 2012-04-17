Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62703 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755774Ab2DQQIn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Apr 2012 12:08:43 -0400
Message-ID: <1334678918.1748.3.camel@dcbw.foobar.com> (sfid-20120417_180846_832699_825B847B)
Subject: Re: [RFT] libertas CS: convert to asynchronous firmware loading
From: Dan Williams <dcbw@redhat.com>
To: Daniel Drake <dsd@laptop.org>
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org
Date: Tue, 17 Apr 2012 11:08:38 -0500
In-Reply-To: <20120409202355.405269D401E@zog.reactivated.net>
References: <20120409202355.405269D401E@zog.reactivated.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-04-09 at 21:23 +0100, Daniel Drake wrote:
> Signed-off-by: Daniel Drake <dsd@laptop.org>
> ---
>  drivers/net/wireless/libertas/if_cs.c |   92 ++++++++++++++++++---------------
>  1 files changed, 51 insertions(+), 41 deletions(-)
> 
> Request for testing.

Works for me with an XG-838 (fw 5.0.20p2).

Dan

> Requires these patches first:
> 
> [RFC 1/4] libertas: Firmware loading simplifications
> [RFC 2/4] libertas: harden-up exit paths
> [RFC 3/4] libertas: add asynchronous firmware loading capability
> 
> Compile tested only - I don't have the hardware. 
> 
> diff --git a/drivers/net/wireless/libertas/if_cs.c b/drivers/net/wireless/libertas/if_cs.c
> index bb3deb3..c211b86 100644
> --- a/drivers/net/wireless/libertas/if_cs.c
> +++ b/drivers/net/wireless/libertas/if_cs.c
> @@ -738,6 +738,52 @@ done:
>  	return ret;
>  }
>  
> +static void if_cs_prog_firmware(struct lbs_private *priv, int ret,
> +				 const struct firmware *helper,
> +				 const struct firmware *mainfw)
> +{
> +	struct if_cs_card *card = priv->card;
> +
> +	if (ret) {
> +		pr_err("failed to find firmware (%d)\n", ret);
> +		return;
> +	}
> +
> +	/* Load the firmware */
> +	ret = if_cs_prog_helper(card, helper);
> +	if (ret == 0 && (card->model != MODEL_8305))
> +		ret = if_cs_prog_real(card, mainfw);
> +	if (ret)
> +		goto out;
> +
> +	/* Now actually get the IRQ */
> +	ret = request_irq(card->p_dev->irq, if_cs_interrupt,
> +		IRQF_SHARED, DRV_NAME, card);
> +	if (ret) {
> +		pr_err("error in request_irq\n");
> +		goto out;
> +	}
> +
> +	/*
> +	 * Clear any interrupt cause that happened while sending
> +	 * firmware/initializing card
> +	 */
> +	if_cs_write16(card, IF_CS_CARD_INT_CAUSE, IF_CS_BIT_MASK);
> +	if_cs_enable_ints(card);
> +
> +	/* And finally bring the card up */
> +	priv->fw_ready = 1;
> +	if (lbs_start_card(priv) != 0) {
> +		pr_err("could not activate card\n");
> +		free_irq(card->p_dev->irq, card);
> +	}
> +
> +out:
> +	if (helper)
> +		release_firmware(helper);
> +	if (mainfw)
> +		release_firmware(mainfw);
> +}
>  
> 
>  /********************************************************************/
> @@ -809,8 +855,6 @@ static int if_cs_probe(struct pcmcia_device *p_dev)
>  	unsigned int prod_id;
>  	struct lbs_private *priv;
>  	struct if_cs_card *card;
> -	const struct firmware *helper = NULL;
> -	const struct firmware *mainfw = NULL;
>  
>  	lbs_deb_enter(LBS_DEB_CS);
>  
> @@ -890,20 +934,6 @@ static int if_cs_probe(struct pcmcia_device *p_dev)
>  		goto out2;
>  	}
>  
> -	ret = lbs_get_firmware(&p_dev->dev, card->model, &fw_table[0],
> -				&helper, &mainfw);
> -	if (ret) {
> -		pr_err("failed to find firmware (%d)\n", ret);
> -		goto out2;
> -	}
> -
> -	/* Load the firmware early, before calling into libertas.ko */
> -	ret = if_cs_prog_helper(card, helper);
> -	if (ret == 0 && (card->model != MODEL_8305))
> -		ret = if_cs_prog_real(card, mainfw);
> -	if (ret)
> -		goto out2;
> -
>  	/* Make this card known to the libertas driver */
>  	priv = lbs_add_card(card, &p_dev->dev);
>  	if (!priv) {
> @@ -911,37 +941,22 @@ static int if_cs_probe(struct pcmcia_device *p_dev)
>  		goto out2;
>  	}
>  
> -	/* Finish setting up fields in lbs_private */
> +	/* Set up fields in lbs_private */
>  	card->priv = priv;
>  	priv->card = card;
>  	priv->hw_host_to_card = if_cs_host_to_card;
>  	priv->enter_deep_sleep = NULL;
>  	priv->exit_deep_sleep = NULL;
>  	priv->reset_deep_sleep_wakeup = NULL;
> -	priv->fw_ready = 1;
>  
> -	/* Now actually get the IRQ */
> -	ret = request_irq(p_dev->irq, if_cs_interrupt,
> -		IRQF_SHARED, DRV_NAME, card);
> +	/* Get firmware */
> +	ret = lbs_get_firmware_async(priv, &p_dev->dev, card->model, fw_table,
> +				     if_cs_prog_firmware);
>  	if (ret) {
> -		pr_err("error in request_irq\n");
> -		goto out3;
> -	}
> -
> -	/*
> -	 * Clear any interrupt cause that happened while sending
> -	 * firmware/initializing card
> -	 */
> -	if_cs_write16(card, IF_CS_CARD_INT_CAUSE, IF_CS_BIT_MASK);
> -	if_cs_enable_ints(card);
> -
> -	/* And finally bring the card up */
> -	if (lbs_start_card(priv) != 0) {
> -		pr_err("could not activate card\n");
> +		pr_err("failed to find firmware (%d)\n", ret);
>  		goto out3;
>  	}
>  
> -	ret = 0;
>  	goto out;
>  
>  out3:
> @@ -951,11 +966,6 @@ out2:
>  out1:
>  	pcmcia_disable_device(p_dev);
>  out:
> -	if (helper)
> -		release_firmware(helper);
> -	if (mainfw)
> -		release_firmware(mainfw);
> -
>  	lbs_deb_leave_args(LBS_DEB_CS, "ret %d", ret);
>  	return ret;
>  }


