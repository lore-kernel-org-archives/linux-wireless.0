Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57601 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752829Ab0LBQjo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Dec 2010 11:39:44 -0500
Subject: Re: [PATCH 2/2] libertas: fix invalid access
From: Dan Williams <dcbw@redhat.com>
To: Daniel Drake <dsd@laptop.org>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	andrey@cozybit.com, s.neumann@raumfeld.com,
	libertas-dev@lists.infradead.org
Date: Thu, 02 Dec 2010 10:38:57 -0600
In-Reply-To: <20101124160200.294D79D401B@zog.reactivated.net>
References: <20101124160200.294D79D401B@zog.reactivated.net>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <1291307939.3156.8.camel@dcbw.foobar.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-11-24 at 16:02 +0000, Daniel Drake wrote:
> From: Sven Neumann <s.neumann@raumfeld.com>
> 
> card->priv must not be accessed after lbs_remove_card() was called
> as lbs_remove_card() frees card->priv via free_netdev().
> 
> For libertas_sdio this is a regression introduced by 23b149c1890f9.
> The correct fix to the issue described there is simply to remove the
> assignment. This flag is set at the appropriate time inside
> lbs_remove_card anyway.
> 
> Reported-by: Daniel Drake <dsd@laptop.org>
> Signed-off-by: Sven Neumann <s.neumann@raumfeld.com>
> Signed-off-by: Daniel Drake <dsd@laptop.org>

Acked-by: Dan Williams <dcbw@redhat.com>

> ---
>  drivers/net/wireless/libertas/if_sdio.c |    1 -
>  drivers/net/wireless/libertas/if_spi.c  |    1 -
>  2 files changed, 0 insertions(+), 2 deletions(-)
> 
> Please apply for 2.6.37
> 
> diff --git a/drivers/net/wireless/libertas/if_sdio.c b/drivers/net/wireless/libertas/if_sdio.c
> index e5685dc..b4de0ca 100644
> --- a/drivers/net/wireless/libertas/if_sdio.c
> +++ b/drivers/net/wireless/libertas/if_sdio.c
> @@ -1170,7 +1170,6 @@ static void if_sdio_remove(struct sdio_func *func)
>  	lbs_deb_sdio("call remove card\n");
>  	lbs_stop_card(card->priv);
>  	lbs_remove_card(card->priv);
> -	card->priv->surpriseremoved = 1;
>  
>  	flush_workqueue(card->workqueue);
>  	destroy_workqueue(card->workqueue);
> diff --git a/drivers/net/wireless/libertas/if_spi.c b/drivers/net/wireless/libertas/if_spi.c
> index 79bcb4e..ecd4d04 100644
> --- a/drivers/net/wireless/libertas/if_spi.c
> +++ b/drivers/net/wireless/libertas/if_spi.c
> @@ -1055,7 +1055,6 @@ static int __devexit libertas_spi_remove(struct spi_device *spi)
>  	lbs_stop_card(priv);
>  	lbs_remove_card(priv); /* will call free_netdev */
>  
> -	priv->surpriseremoved = 1;
>  	free_irq(spi->irq, card);
>  	if_spi_terminate_spi_thread(card);
>  	if (card->pdata->teardown)


