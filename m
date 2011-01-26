Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48323 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750809Ab1AZHHJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Jan 2011 02:07:09 -0500
Date: Wed, 26 Jan 2011 08:05:32 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	mickflemm@gmail.com, Bruno Randolf <br1@einfach.org>,
	jirislaby@gmail.com, lrodriguez@atheros.com
Subject: Re: [PATCH 1/2] ath5k: fix error handling in ath5k_hw_dma_stop
Message-ID: <20110126070531.GA2357@redhat.com>
References: <1295929904-11806-1-git-send-email-me@bobcopeland.com>
 <20110125135249.GA2610@redhat.com>
 <20110126015034.GA8600@hash.localnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20110126015034.GA8600@hash.localnet>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 25, 2011 at 08:50:34PM -0500, Bob Copeland wrote:
> From: Bob Copeland <me@bobcopeland.com>
> Date: Mon, 24 Jan 2011 09:25:11 -0500
> Subject: [PATCH] ath5k: fix error handling in ath5k_hw_dma_stop
> 
> Review spotted a problem with the error handling in ath5k_hw_dma_stop:
> a successful return from ath5k_hw_stop_tx_dma will be treated as
> an error, so we always bail out of the loop after processing a single
> active queue.  As a result, we may not actually stop some queues during
> reset.
> 
> Signed-off-by: Bob Copeland <me@bobcopeland.com>
> ---
> 
> > Patch is good, but does not make code fully correct. When last queue
> > is inactive, we return -EINVAL from ath5_hw_dma_stop(). So we need
> > also:
> > 
> >  		if (err && err != -EINVAL)
> >  			return err;
> > +		err = 0;
> >  	}
> 
> > But perhaps, would be better just return 0 from 
> > ath5k_hw_stop_tx_dma() when queue is inactive.
> 
> How about this version instead? 
It's better :)

> diff --git a/drivers/net/wireless/ath/ath5k/dma.c b/drivers/net/wireless/ath/ath5k/dma.c
> index 0064be7..21091c2 100644
> --- a/drivers/net/wireless/ath/ath5k/dma.c
> +++ b/drivers/net/wireless/ath/ath5k/dma.c
> @@ -838,9 +838,9 @@ int ath5k_hw_dma_stop(struct ath5k_hw *ah)
>  	for (i = 0; i < qmax; i++) {
>  		err = ath5k_hw_stop_tx_dma(ah, i);
>  		/* -EINVAL -> queue inactive */
> -		if (err != -EINVAL)
> +		if (err && err != -EINVAL)
>  			return err;
>  	}
>  
> -	return err;
> +	return 0;
>  }

Reviewed-by: Stanislaw Gruszka <sgruszka@redhat.com>
