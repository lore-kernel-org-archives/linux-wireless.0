Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:58833 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933461Ab1ERTQH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 May 2011 15:16:07 -0400
Date: Wed, 18 May 2011 15:07:34 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, lrodriguez@atheros.com
Subject: Re: [PATCH 1/2] ath9k: unify edma and non-edma tx code, improve tx
 fifo handling
Message-ID: <20110518190733.GA2543@tuxdriver.com> (sfid-20110518_211621_136692_E7A0B339)
References: <1305719964-44292-1-git-send-email-nbd@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1305719964-44292-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  CC [M]  drivers/net/wireless/ath/ath9k/xmit.o
drivers/net/wireless/ath/ath9k/xmit.c: In function ‘ath_tx_edma_tasklet’:
drivers/net/wireless/ath/ath9k/xmit.c:2199:18: warning: ‘txq’ may be used uninitialized in this function

Please don't add warnings, especially not valid ones... :-)

On Wed, May 18, 2011 at 01:59:23PM +0200, Felix Fietkau wrote:
> EDMA based chips (AR9380+) have 8 Tx FIFO slots, which are used to fix the
> tx queue start/stop race conditions which have to be worked around for
> earlier chips by keeping the last descriptor in the queue. The current code
> stores all frames that do not fit onto the 8 FIFO slots in a separate
> list. Whenever a FIFO slot is freed up, the next frame (or A-MPDU) from the
> pending queue gets moved to that slot.
> 
> This process is not only inefficient, but also unnecessary. The code can
> be improved visibly by keeping the pending queue fully linked, and moving
> the contents of the entire queue to a FIFO slot as it becomes available.
> 
> This patch makes the necessary changes for that and also merges some code
> that was duplicated for EDMA vs non-EDMA. It changes txq->axq_link to point
> to the last descriptor instead of the link pointer, so that
> ath9k_hw_set_desc_link can be used, which works on all chips.
> 
> With this patch, a small performance increase for non-aggregated traffic
> was observed on AR9380 based embedded hardware.
> 
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>

> diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
> index 97dd1fa..2bfa843 100644
> --- a/drivers/net/wireless/ath/ath9k/xmit.c
> +++ b/drivers/net/wireless/ath/ath9k/xmit.c

> @@ -2237,17 +2193,17 @@ void ath_tx_tasklet(struct ath_softc *sc)
>  
>  void ath_tx_edma_tasklet(struct ath_softc *sc)
>  {
> -	struct ath_tx_status txs;
> +	struct ath_tx_status ts;
>  	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
>  	struct ath_hw *ah = sc->sc_ah;
>  	struct ath_txq *txq;
>  	struct ath_buf *bf, *lastbf;
>  	struct list_head bf_head;
>  	int status;
> -	int txok;
>  
> +	spin_lock_bh(&txq->axq_lock);
>  	for (;;) {
> -		status = ath9k_hw_txprocdesc(ah, NULL, (void *)&txs);
> +		status = ath9k_hw_txprocdesc(ah, NULL, (void *)&ts);
>  		if (status == -EINPROGRESS)
>  			break;
>  		if (status == -EIO) {

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
