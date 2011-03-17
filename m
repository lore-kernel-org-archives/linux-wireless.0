Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56117 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754781Ab1CQQnS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Mar 2011 12:43:18 -0400
Subject: Re: [PATCH RESEND] libertas_spi: Add support for suspend/resume
From: Dan Williams <dcbw@redhat.com>
To: Vasily Khoruzhick <anarsoul@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Marek Vasut <marek.vasut@gmail.com>,
	libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	Colin McCabe <colin@cozybit.com>
Date: Thu, 17 Mar 2011 11:44:27 -0500
In-Reply-To: <1300286506-13318-1-git-send-email-anarsoul@gmail.com>
References: <20110315204155.GE2542@tuxdriver.com>
	 <1300286506-13318-1-git-send-email-anarsoul@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <1300380270.11539.8.camel@dcbw.foobar.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-03-16 at 16:41 +0200, Vasily Khoruzhick wrote:
> Add support for suspend/resume in if_spi.
> 
> Signed-off-by: Vasily Khoruzhick <anarsoul@gmail.com>

Unless Marek chimes in, I don't have a problem with this patch if it
fixes the problem.  The one issue I can see is that if userspace isn't
ready yet, the request_firmware() call will fail because we're not
caching firmware anywhere, and we probably shouldn't be since the
firmware is large.  I'm not sure there's a good solution without caching
firmware though, but I don't want that to block the patch...

Acked-by: Dan Williams <dcbw@redhat.com>

> ---
>  drivers/net/wireless/libertas/if_spi.c |   65 ++++++++++++++++++++++++++++++++
>  1 files changed, 65 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/libertas/if_spi.c b/drivers/net/wireless/libertas/if_spi.c
> index f6c2cd6..078ef43 100644
> --- a/drivers/net/wireless/libertas/if_spi.c
> +++ b/drivers/net/wireless/libertas/if_spi.c
> @@ -57,6 +57,7 @@ struct if_spi_card {
>  	/* Handles all SPI communication (except for FW load) */
>  	struct workqueue_struct		*workqueue;
>  	struct work_struct		packet_work;
> +	struct work_struct		resume_work;
>  
>  	u8				cmd_buffer[IF_SPI_CMD_BUF_SIZE];
>  
> @@ -68,6 +69,9 @@ struct if_spi_card {
>  
>  	/* Protects cmd_packet_list and data_packet_list */
>  	spinlock_t			buffer_lock;
> +
> +	/* True is card suspended */
> +	u8				suspended;
>  };
>  
>  static void free_if_spi_card(struct if_spi_card *card)
> @@ -1057,6 +1061,28 @@ out:
>  	return err;
>  }
>  
> +static void if_spi_resume_worker(struct work_struct *work)
> +{
> +	struct if_spi_card *card;
> +
> +	card = container_of(work, struct if_spi_card, resume_work);
> +
> +	if (card->suspended) {
> +		if (card->pdata->setup)
> +			card->pdata->setup(card->spi);
> +
> +		/* Init card ... */
> +		if_spi_init_card(card);
> +
> +		enable_irq(card->spi->irq);
> +
> +		/* And resume it ... */
> +		lbs_resume(card->priv);
> +
> +		card->suspended = 0;
> +	}
> +}
> +
>  static int __devinit if_spi_probe(struct spi_device *spi)
>  {
>  	struct if_spi_card *card;
> @@ -1107,6 +1133,7 @@ static int __devinit if_spi_probe(struct spi_device *spi)
>  		goto free_card;
>  	}
>  	card->priv = priv;
> +	priv->setup_fw_on_resume = 1;
>  	priv->card = card;
>  	priv->hw_host_to_card = if_spi_host_to_card;
>  	priv->enter_deep_sleep = NULL;
> @@ -1117,6 +1144,7 @@ static int __devinit if_spi_probe(struct spi_device *spi)
>  	/* Initialize interrupt handling stuff. */
>  	card->workqueue = create_workqueue("libertas_spi");
>  	INIT_WORK(&card->packet_work, if_spi_host_to_card_worker);
> +	INIT_WORK(&card->resume_work, if_spi_resume_worker);
>  
>  	err = request_irq(spi->irq, if_spi_host_interrupt,
>  			IRQF_TRIGGER_FALLING, "libertas_spi", card);
> @@ -1161,6 +1189,8 @@ static int __devexit libertas_spi_remove(struct spi_device *spi)
>  	lbs_deb_spi("libertas_spi_remove\n");
>  	lbs_deb_enter(LBS_DEB_SPI);
>  
> +	cancel_work_sync(&card->resume_work);
> +
>  	lbs_stop_card(priv);
>  	lbs_remove_card(priv); /* will call free_netdev */
>  
> @@ -1174,6 +1204,40 @@ static int __devexit libertas_spi_remove(struct spi_device *spi)
>  	return 0;
>  }
>  
> +static int if_spi_suspend(struct device *dev)
> +{
> +	struct spi_device *spi = to_spi_device(dev);
> +	struct if_spi_card *card = spi_get_drvdata(spi);
> +
> +	if (!card->suspended) {
> +		lbs_suspend(card->priv);
> +		flush_workqueue(card->workqueue);
> +		disable_irq(spi->irq);
> +
> +		if (card->pdata->teardown)
> +			card->pdata->teardown(spi);
> +		card->suspended = 1;
> +	}
> +
> +	return 0;
> +}
> +
> +static int if_spi_resume(struct device *dev)
> +{
> +	struct spi_device *spi = to_spi_device(dev);
> +	struct if_spi_card *card = spi_get_drvdata(spi);
> +
> +	/* Schedule delayed work */
> +	schedule_work(&card->resume_work);
> +
> +	return 0;
> +}
> +
> +static const struct dev_pm_ops if_spi_pm_ops = {
> +	.suspend	= if_spi_suspend,
> +	.resume		= if_spi_resume,
> +};
> +
>  static struct spi_driver libertas_spi_driver = {
>  	.probe	= if_spi_probe,
>  	.remove = __devexit_p(libertas_spi_remove),
> @@ -1181,6 +1245,7 @@ static struct spi_driver libertas_spi_driver = {
>  		.name	= "libertas_spi",
>  		.bus	= &spi_bus_type,
>  		.owner	= THIS_MODULE,
> +		.pm	= &if_spi_pm_ops,
>  	},
>  };
>  


