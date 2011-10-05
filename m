Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:1866 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934365Ab1JENEL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Oct 2011 09:04:11 -0400
Date: Wed, 5 Oct 2011 08:33:24 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Jiri Slaby <jirislaby@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
	kernel-janitors@vger.kernel.org
Subject: Re: [patch] ath5k: remove some unneeded error handling code
Message-ID: <20111005123324.GB3662@hash.lan> (sfid-20111005_150416_334789_9A58524C)
References: <20111005054637.GA32077@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20111005054637.GA32077@elgon.mountain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 05, 2011 at 08:46:37AM +0300, Dan Carpenter wrote:
> th5k_hw_setup_tx_queue() returns a valid offset into the ah->ah_txq[]

ath5k_....

> array.  The ah->ah_txq[] and the ah->txqs[] array are the same size.
> Both have AR5K_NUM_TX_QUEUES elements.  So this error handling code
> will never trigger.

This originally came from the HAL.  I concur that this code will not
be executed, since the enum from which ath5k_hw_setup_tx_queue() selects
qnum has all elements less than AR5K_NUM_TX_QUEUES, which in turn is equal
to ARRAY_SIZE(ah->txqs).  ath5k_hw_setup_tx_queue() already uses qnum in
a memset of a same-sized array (ah->txq).

> Also it's wrong.  The call to ath5k_hw_release_tx_queue() with a qnum
> of AR5K_NUM_TX_QUEUES or more will just trigger a WARN_ON() and
> return.  Or if it missed the WARN_ON(), it would just corrupt some
> memory and return.

"corrupt memory and return" sounds undeserving of the adverb 'just' :)
I guess you are trying to say that it should not have called
ath5k_hw_release_tx_queue() but I read this comment as saying the
ATH5K_ERR() was superfluous?

ath5k_hw_release_tx_queue() compares against the queue capabilities
instead of AR5K_NUM_TX_QUEUES, so there's extra potential for the
"just corrupt memory and return" case -- but since those are also
initialized to AR5K_NUM_TX_QUEUES{,_NO_QCU}, that case won't happen
either.

All that to say the patch is fine, but the patch description didn't
convince me so I double-checked.  My comments above reflect how I
might have worded it.

Thanks for the patch!

Reviewed-by: Bob Copeland <me@bobcopeland.com>

> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
> index e9ea38d..b346d04 100644
> --- a/drivers/net/wireless/ath/ath5k/base.c
> +++ b/drivers/net/wireless/ath/ath5k/base.c
> @@ -921,12 +921,6 @@ ath5k_txq_setup(struct ath5k_hw *ah,
>  		 */
>  		return ERR_PTR(qnum);
>  	}
> -	if (qnum >= ARRAY_SIZE(ah->txqs)) {
> -		ATH5K_ERR(ah, "hw qnum %u out of range, max %tu!\n",
> -			qnum, ARRAY_SIZE(ah->txqs));
> -		ath5k_hw_release_tx_queue(ah, qnum);
> -		return ERR_PTR(-EINVAL);
> -	}
>  	txq = &ah->txqs[qnum];
>  	if (!txq->setup) {
>  		txq->qnum = qnum;
> 

-- 
Bob Copeland %% www.bobcopeland.com

