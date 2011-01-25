Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30t.wh2.ocn.ne.jp ([125.206.180.136]:35776 "HELO
	mail30t.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751456Ab1AYFMm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Jan 2011 00:12:42 -0500
Received: from vs3007.wh2.ocn.ne.jp (125.206.180.235)
	by mail30t.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 5-0389242361
	for <linux-wireless@vger.kernel.org>; Tue, 25 Jan 2011 14:12:41 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: Bob Copeland <me@bobcopeland.com>
Subject: Re: [PATCH 1/2] ath5k: fix error handling in ath5k_hw_dma_stop
Date: Tue, 25 Jan 2011 14:12:37 +0900
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	mickflemm@gmail.com, jirislaby@gmail.com, lrodriguez@atheros.com
References: <1295929904-11806-1-git-send-email-me@bobcopeland.com>
In-Reply-To: <1295929904-11806-1-git-send-email-me@bobcopeland.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201101251412.37485.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue January 25 2011 13:31:43 Bob Copeland wrote:
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
> diff --git a/drivers/net/wireless/ath/ath5k/dma.c
> b/drivers/net/wireless/ath/ath5k/dma.c index 0064be7..e828b98 100644
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

Acked-by: Bruno Randolf <br1@einfach.org>
