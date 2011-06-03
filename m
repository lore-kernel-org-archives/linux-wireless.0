Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4780 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753983Ab1FCTR4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jun 2011 15:17:56 -0400
Subject: Re: [PATCH] libertas_sdio: handle spurious interrupts
From: Dan Williams <dcbw@redhat.com>
To: Daniel Drake <dsd@laptop.org>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	libertas-dev@lists.infradead.org, linux-mmc@vger.kernel.org
Date: Fri, 03 Jun 2011 14:20:20 -0500
In-Reply-To: <20110602231327.116A79D401C@zog.reactivated.net>
References: <20110602231327.116A79D401C@zog.reactivated.net>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <1307128821.23945.18.camel@dcbw.foobar.com> (sfid-20110603_211801_180971_05643E19)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-06-03 at 00:13 +0100, Daniel Drake wrote:
> Commit 06e8935febe687e2a561707d4c7ca4245d261dbe adds an IRQ handling
> optimization for single-function SDIO cards like this one, but at the
> same time exposes a small hardware bug.
> 
> During hardware init, an interrupt is generated with (apparently) no
> source. Previously, mmc threw this interrupt away, but now (due to the
> optimization), the mmc layer passes this onto libertas, before it is ready
> (and before it has enabled interrupts), causing a crash.
> 
> Work around this hardware bug by registering the IRQ handler later and
> making it capable of handling interrupts with no cause. The change that
> makes the IRQ handler registration happen later actually eliminates
> the spurious interrupt as well.
> 
> Signed-off-by: Daniel Drake <dsd@laptop.org>

Acked-by: Dan Williams <dcbw@redhat.com>

> ---
>  drivers/net/wireless/libertas/if_sdio.c |   21 ++++++++++++++++-----
>  1 files changed, 16 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/wireless/libertas/if_sdio.c b/drivers/net/wireless/libertas/if_sdio.c
> index a7b5cb0..224e985 100644
> --- a/drivers/net/wireless/libertas/if_sdio.c
> +++ b/drivers/net/wireless/libertas/if_sdio.c
> @@ -907,7 +907,7 @@ static void if_sdio_interrupt(struct sdio_func *func)
>  	card = sdio_get_drvdata(func);
>  
>  	cause = sdio_readb(card->func, IF_SDIO_H_INT_STATUS, &ret);
> -	if (ret)
> +	if (ret || !cause)
>  		goto out;
>  
>  	lbs_deb_sdio("interrupt: 0x%X\n", (unsigned)cause);
> @@ -1008,10 +1008,6 @@ static int if_sdio_probe(struct sdio_func *func,
>  	if (ret)
>  		goto release;
>  
> -	ret = sdio_claim_irq(func, if_sdio_interrupt);
> -	if (ret)
> -		goto disable;
> -
>  	/* For 1-bit transfers to the 8686 model, we need to enable the
>  	 * interrupt flag in the CCCR register. Set the MMC_QUIRK_LENIENT_FN0
>  	 * bit to allow access to non-vendor registers. */
> @@ -1083,6 +1079,21 @@ static int if_sdio_probe(struct sdio_func *func,
>  		card->rx_unit = 0;
>  
>  	/*
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
>  	 * Enable interrupts now that everything is set up
>  	 */
>  	sdio_writeb(func, 0x0f, IF_SDIO_H_INT_MASK, &ret);


