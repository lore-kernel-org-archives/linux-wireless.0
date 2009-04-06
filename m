Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:32819 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753813AbZDFUVN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Apr 2009 16:21:13 -0400
Subject: Re: [PATCH] libertas: increase spi driver thread priority
From: Dan Williams <dcbw@redhat.com>
To: Anna Neal <anna@cozybit.com>
Cc: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org,
	javier@cozybit.com
In-Reply-To: <49d54fd9.1aba720a.5b57.ffffe3f6@mx.google.com>
References: <49d54fd9.1aba720a.5b57.ffffe3f6@mx.google.com>
Content-Type: text/plain
Date: Mon, 06 Apr 2009 16:22:14 -0400
Message-Id: <1239049334.28824.10.camel@localhost.localdomain> (sfid-20090406_222115_484815_D63FE696)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-04-02 at 14:44 -0700, Anna Neal wrote:
> Currently, the libertas main thread contends with the spi driver thread
> in the TX path.  To improve throughput, ensure that the driver thread
> has higher scheduling priority than the libertas main thread.  Do this
> by making the libertas spi driver thread a low priority real time
> thread.
> 
> We measured an average throughput improvement of 13%.
> 
> Signed-off-by: Anna Neal <anna@cozybit.com>
> Signed-off-by: Andrey Yurovsky <andrey@cozybit.com>

Sure; looks fine to me.  

Acked-by: Dan Williams <dcbw@redhat.com>

> ---
>  drivers/net/wireless/libertas/if_spi.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/libertas/if_spi.c b/drivers/net/wireless/libertas/if_spi.c
> index 07311e7..97493e2 100644
> --- a/drivers/net/wireless/libertas/if_spi.c
> +++ b/drivers/net/wireless/libertas/if_spi.c
> @@ -1020,6 +1020,7 @@ static int __devinit if_spi_probe(struct spi_device *spi)
>  	struct libertas_spi_platform_data *pdata = spi->dev.platform_data;
>  	int err = 0;
>  	u32 scratch;
> +	struct sched_param param = { .sched_priority = 1 };
>  
>  	lbs_deb_enter(LBS_DEB_SPI);
>  
> @@ -1123,6 +1124,9 @@ static int __devinit if_spi_probe(struct spi_device *spi)
>  		lbs_pr_err("error creating SPI thread: err=%d\n", err);
>  		goto remove_card;
>  	}
> +	if (sched_setscheduler(card->spi_thread, SCHED_FIFO, &param))
> +		lbs_pr_err("Error setting scheduler, using default.\n");
> +
>  	err = request_irq(spi->irq, if_spi_host_interrupt,
>  			IRQF_TRIGGER_FALLING, "libertas_spi", card);
>  	if (err) {

