Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33124 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754565Ab1DGVn1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Apr 2011 17:43:27 -0400
Subject: Re: [PATCH RFC 1/3] libertas_spi: cancel packet work on module
 removal
From: Dan Williams <dcbw@redhat.com>
To: Vasily Khoruzhick <anarsoul@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org
Date: Thu, 07 Apr 2011 16:43:59 -0500
In-Reply-To: <1302207960-28536-2-git-send-email-anarsoul@gmail.com>
References: <1302207960-28536-1-git-send-email-anarsoul@gmail.com>
	 <1302207960-28536-2-git-send-email-anarsoul@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <1302212641.17586.1.camel@dcbw.foobar.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-04-07 at 23:25 +0300, Vasily Khoruzhick wrote:
> Signed-off-by: Vasily Khoruzhick <anarsoul@gmail.com>

Acked-by: Dan Williams <dcbw@redhat.com>

> ---
>  drivers/net/wireless/libertas/if_spi.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/libertas/if_spi.c b/drivers/net/wireless/libertas/if_spi.c
> index 078ef43..d893560 100644
> --- a/drivers/net/wireless/libertas/if_spi.c
> +++ b/drivers/net/wireless/libertas/if_spi.c
> @@ -1195,6 +1195,7 @@ static int __devexit libertas_spi_remove(struct spi_device *spi)
>  	lbs_remove_card(priv); /* will call free_netdev */
>  
>  	free_irq(spi->irq, card);
> +	cancel_work_sync(&card->packet_work);
>  	flush_workqueue(card->workqueue);
>  	destroy_workqueue(card->workqueue);
>  	if (card->pdata->teardown)


