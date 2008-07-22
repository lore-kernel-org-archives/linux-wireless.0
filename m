Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.172]:60859 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755589AbYGVOyl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jul 2008 10:54:41 -0400
Received: by ug-out-1314.google.com with SMTP id h2so387042ugf.16
        for <linux-wireless@vger.kernel.org>; Tue, 22 Jul 2008 07:54:39 -0700 (PDT)
Message-ID: <4885F42F.9050503@gmail.com> (sfid-20080722_165500_848383_2BB56854)
Date: Tue, 22 Jul 2008 16:52:31 +0200
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, jirislaby@gmail.com, mcgrof@gmail.com,
	Nick Kossifidis <mickflemm@gmail.com>
Subject: Re: [PATCH 6/12] ath5k: Reorder calibration calls during reset and
 update hw_set_power
References: <20080720034126.GF7440@makis>
In-Reply-To: <20080720034126.GF7440@makis>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/20/2008 05:41 AM, Nick Kossifidis wrote:
>  * Update ath5k_hw_reset and add some more documentation about PHY calibration
>  * Fix ath5k_hw_set_power to use AR5K_SLEEP_CTL_SLE_ALLOW for Network sleep
>  * Preserve sleep duration field while setting AR5K_SLEEP_CTL and reduce delays & checks for register's status (got this from decompiling & dumps, it works for me but it needs testing)
> 
>  Changes-licensed-under: ISC
>  Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>
> 
> ---
> diff --git a/drivers/net/wireless/ath5k/hw.c b/drivers/net/wireless/ath5k/hw.c
> index cab1a8a..4fb048c 100644
> --- a/drivers/net/wireless/ath5k/hw.c
> +++ b/drivers/net/wireless/ath5k/hw.c
[...]
> @@ -1461,6 +1496,7 @@ int ath5k_hw_stop_tx_dma(struct ath5k_hw *ah, unsigned int queue)
>  
>  		/* Stop queue */
>  		ath5k_hw_reg_write(ah, tx_queue, AR5K_CR);
> +		ath5k_hw_reg_read(ah, AR5K_CR);

This one was in my patch already.

>  	} else {
>  		/*
>  		 * Schedule TX disable and wait until queue is empty
> @@ -1705,6 +1741,7 @@ enum ath5k_int ath5k_hw_set_intr(struct ath5k_hw *ah, enum ath5k_int new_mask)

Adding from the code:
         /*
          * Disable card interrupts to prevent any race conditions
>  	 * (they will be re-enabled afterwards).
>  	 */
>  	ath5k_hw_reg_write(ah, AR5K_IER_DISABLE, AR5K_IER);
> +	ath5k_hw_reg_read(ah, AR5K_IER);

Is this first flush needed? Writes cannot be reordered, they are just 
asynchronous and flushed below. What race is this against? The interrupt might 
be processed (or pending) at this moment on other processor anyway.

>  	old_mask = ah->ah_imr;
>  
> @@ -1737,6 +1774,7 @@ enum ath5k_int ath5k_hw_set_intr(struct ath5k_hw *ah, enum ath5k_int new_mask)
>  
>  	/* ..re-enable interrupts */
>  	ath5k_hw_reg_write(ah, AR5K_IER_ENABLE, AR5K_IER);
> +	ath5k_hw_reg_read(ah, AR5K_IER);

This was fixed too.
