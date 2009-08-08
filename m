Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:1726 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144AbZHHQVL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Aug 2009 12:21:11 -0400
Date: Sat, 8 Aug 2009 12:20:01 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Julia Lawall <julia@diku.dk>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	Jiri Slaby <jirislaby@gmail.com>, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
	linville@tuxdriver.com
Subject: Re: [PATCH] drivers/net/wireless/ath/ath5k: Change constant name
Message-ID: <20090808162001.GA18271@hash.localnet>
References: <Pine.LNX.4.64.0908081521210.27715@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <Pine.LNX.4.64.0908081521210.27715@ask.diku.dk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Aug 08, 2009 at 03:22:26PM +0200, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> Elsewhere, the tqi_type field is compared to constants having a name
> beginning with AR5K_TX_QUEUE, rather than AR5K_TX_QUEUE_ID.  I have thus
> converted AR5K_TX_QUEUE_ID_CAB to AR5K_TX_QUEUE_CAB.  This does, however,
> change the value, so perhaps something else was wanted.
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>

Nice catch, thanks.  Shouldn't cause any problem with 2.6.31 since we
don't use the CAB queue yet, but it was definitely wrong.

Acked-by: Bob Copeland <me@bobcopeland.com>


> diff --git a/drivers/net/wireless/ath/ath5k/qcu.c b/drivers/net/wireless/ath/ath5k/qcu.c
> index 6d5aaf0..eeebb9a 100644
> --- a/drivers/net/wireless/ath/ath5k/qcu.c
> +++ b/drivers/net/wireless/ath/ath5k/qcu.c
> @@ -362,7 +362,7 @@ int ath5k_hw_reset_tx_queue(struct ath5k_hw *ah, unsigned int queue)
>  		}
>  
>  		if (tq->tqi_ready_time &&
> -		(tq->tqi_type != AR5K_TX_QUEUE_ID_CAB))
> +		(tq->tqi_type != AR5K_TX_QUEUE_CAB))
>  			ath5k_hw_reg_write(ah, AR5K_REG_SM(tq->tqi_ready_time,
>  				AR5K_QCU_RDYTIMECFG_INTVAL) |
>  				AR5K_QCU_RDYTIMECFG_ENABLE,
> 

-- 
Bob Copeland %% www.bobcopeland.com

