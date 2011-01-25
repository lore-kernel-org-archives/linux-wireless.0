Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:16093 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753599Ab1AYNxd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Jan 2011 08:53:33 -0500
Date: Tue, 25 Jan 2011 14:52:50 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	mickflemm@gmail.com, Bruno Randolf <br1@einfach.org>,
	jirislaby@gmail.com, lrodriguez@atheros.com
Subject: Re: [PATCH 1/2] ath5k: fix error handling in ath5k_hw_dma_stop
Message-ID: <20110125135249.GA2610@redhat.com>
References: <1295929904-11806-1-git-send-email-me@bobcopeland.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1295929904-11806-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 24, 2011 at 11:31:43PM -0500, Bob Copeland wrote:
> Review spotted a problem with the error handling in ath5k_hw_dma_stop:
> a successful return from ath5k_hw_stop_tx_dma will be treated as
> an error, so we always bail out of the loop after processing a single
> active queue.  As a result, we may not actually stop some queues during
> reset.
> 
> Signed-off-by: Bob Copeland <me@bobcopeland.com>
> ---
> These two patches fix some buglets I found when reviewing some old code.
> 
>  drivers/net/wireless/ath/ath5k/dma.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath5k/dma.c b/drivers/net/wireless/ath/ath5k/dma.c
> index 0064be7..e828b98 100644
> --- a/drivers/net/wireless/ath/ath5k/dma.c
> +++ b/drivers/net/wireless/ath/ath5k/dma.c
> @@ -838,7 +838,7 @@ int ath5k_hw_dma_stop(struct ath5k_hw *ah)
>  	for (i = 0; i < qmax; i++) {
>  		err = ath5k_hw_stop_tx_dma(ah, i);
>  		/* -EINVAL -> queue inactive */
> -		if (err != -EINVAL)
> +		if (err && err != -EINVAL)
>  			return err;
>  	}

Patch is good, but does not make code fully correct. When last queue
is inactive, we return -EINVAL from ath5_hw_dma_stop(). So we need
also:

 		if (err && err != -EINVAL)
 			return err;
+		err = 0;
 	}

But perhaps, would be better just return 0 from 
ath5k_hw_stop_tx_dma() when queue is inactive.

I think that could fix "ath5k phy0: can't reset hardware (-5)"
bugs reported in a few places, so patch should go to stable
as well.

Stanislaw
