Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:43488 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751259AbZFVOs1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jun 2009 10:48:27 -0400
Subject: Re: [PATCH] libertas: correct card cleanup order in SPI driver
From: Dan Williams <dcbw@redhat.com>
To: Andrey Yurovsky <andrey@cozybit.com>
Cc: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org
In-Reply-To: <1245343917-15534-1-git-send-email-andrey@cozybit.com>
References: <20090618081206.GB2770@Chamillionaire.breakpoint.cc>
	 <1245343917-15534-1-git-send-email-andrey@cozybit.com>
Content-Type: text/plain
Date: Mon, 22 Jun 2009 10:48:13 -0400
Message-Id: <1245682093.4338.26.camel@dhcp-100-3-98.bos.redhat.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-06-18 at 09:51 -0700, Andrey Yurovsky wrote:
> The SPI driver does a couple of card cleanup steps in the wrong order on
> module removal.  If IEEE PS is enabled, this results in the card being
> left in IEEE PS mode and subsequent failures to reload the module.  The
> problem is that the surpriseremoved flag is set before calling
> lbs_remove_card, but that function needs to issue a command to exit IEEE
> PS mode (the flag blocks the command path).  In addition, lbs_stop_card
> should be called first because it clears out any pending commands.
> 
> Tested on a GSPI device with V9 firmware by confirming that we can
> reload the module with or without IEEE PS enabled.
> 
> Also fix a warning from the wrong uint format in a printk.
> 
> V2: use z modifier, thanks Sebastian.
> 
> Signed-off-by: Andrey Yurovsky <andrey@cozybit.com>

Acked-by: Dan Williams <dcbw@redhat.com>

> ---
>  drivers/net/wireless/libertas/if_spi.c |    7 ++++---
>  1 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/libertas/if_spi.c b/drivers/net/wireless/libertas/if_spi.c
> index 923ed58..8d8bc0b 100644
> --- a/drivers/net/wireless/libertas/if_spi.c
> +++ b/drivers/net/wireless/libertas/if_spi.c
> @@ -737,7 +737,7 @@ static int if_spi_c2h_data(struct if_spi_card *card)
>  		goto out;
>  	} else if (len > MRVDRV_ETH_RX_PACKET_BUFFER_SIZE) {
>  		lbs_pr_err("%s: error: card has %d bytes of data, but "
> -			   "our maximum skb size is %lu\n",
> +			   "our maximum skb size is %zu\n",
>  			   __func__, len, MRVDRV_ETH_RX_PACKET_BUFFER_SIZE);
>  		err = -EINVAL;
>  		goto out;
> @@ -1171,12 +1171,13 @@ static int __devexit libertas_spi_remove(struct spi_device *spi)
>  
>  	lbs_deb_spi("libertas_spi_remove\n");
>  	lbs_deb_enter(LBS_DEB_SPI);
> -	priv->surpriseremoved = 1;
>  
>  	lbs_stop_card(priv);
> +	lbs_remove_card(priv); /* will call free_netdev */
> +
> +	priv->surpriseremoved = 1;
>  	free_irq(spi->irq, card);
>  	if_spi_terminate_spi_thread(card);
> -	lbs_remove_card(priv); /* will call free_netdev */
>  	if (card->pdata->teardown)
>  		card->pdata->teardown(spi);
>  	free_if_spi_card(card);

