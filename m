Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:32941 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754307Ab1LMVAW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Dec 2011 16:00:22 -0500
Date: Tue, 13 Dec 2011 15:47:17 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, mcgrof@qca.qualcomm.com
Subject: Re: [PATCH 5/6] ath9k: simplify tx locking
Message-ID: <20111213204717.GD2613@tuxdriver.com> (sfid-20111213_220029_895169_8C82ED63)
References: <1323720386-46132-1-git-send-email-nbd@openwrt.org>
 <1323720386-46132-2-git-send-email-nbd@openwrt.org>
 <1323720386-46132-3-git-send-email-nbd@openwrt.org>
 <1323720386-46132-4-git-send-email-nbd@openwrt.org>
 <1323720386-46132-5-git-send-email-nbd@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1323720386-46132-5-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 12, 2011 at 09:06:25PM +0100, Felix Fietkau wrote:
> Instead of releasing and taking back the lock over and over again in the
> tx path, hold the lock a bit longer, requiring much fewer lock/unlock pairs.
> This makes locking much easier to review and should not have any noticeable
> performance/latency impact.
> 
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>

> @@ -2259,6 +2230,7 @@ void ath_tx_edma_tasklet(struct ath_softc *sc)
>  	struct list_head bf_head;
>  	int status;
>  
> +	spin_lock_bh(&txq->axq_lock);
>  	for (;;) {
>  		if (work_pending(&sc->hw_reset_work))
>  			break;

Pretty sure this is wrong -- gcc seems to agree:

  CC [M]  drivers/net/wireless/ath/ath9k/xmit.o
drivers/net/wireless/ath/ath9k/xmit.c: In function ‘ath_tx_edma_tasklet’:
drivers/net/wireless/ath/ath9k/xmit.c:2249:18: warning: ‘txq’ may be used uninitialized in this function

> @@ -2278,12 +2250,8 @@ void ath_tx_edma_tasklet(struct ath_softc *sc)
>  
>  		txq = &sc->tx.txq[ts.qid];
>  
> -		spin_lock_bh(&txq->axq_lock);
> -
> -		if (list_empty(&txq->txq_fifo[txq->txq_tailidx])) {
> -			spin_unlock_bh(&txq->axq_lock);
> -			return;
> -		}
> +		if (list_empty(&txq->txq_fifo[txq->txq_tailidx]))
> +			break;
>  
>  		bf = list_first_entry(&txq->txq_fifo[txq->txq_tailidx],
>  				      struct ath_buf, list);

Looks like txq doesn't get initialized until this loop?

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
