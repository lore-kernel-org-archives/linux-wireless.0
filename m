Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:54708 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752050Ab1CJI7L (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Mar 2011 03:59:11 -0500
Received: from mail.atheros.com ([10.10.20.104])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 10 Mar 2011 00:58:49 -0800
Date: Thu, 10 Mar 2011 14:28:47 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: Felix Fietkau <nbd@openwrt.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
Subject: Re: [PATCH 2/4] ath9k: fix stopping tx dma on reset
Message-ID: <20110310085847.GB28100@vasanth-laptop>
References: <1299717303-42430-1-git-send-email-nbd@openwrt.org> <1299717303-42430-2-git-send-email-nbd@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1299717303-42430-2-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 10, 2011 at 06:05:01AM +0530, Felix Fietkau wrote:
> +bool ath9k_hw_abort_tx_dma(struct ath_hw *ah)
> +{
> +	int i, q;
> +
> +	REG_WRITE(ah, AR_Q_TXD, AR_Q_TXD_M);
> +
> +	REG_SET_BIT(ah, AR_PCU_MISC, AR_PCU_FORCE_QUIET_COLL | AR_PCU_CLEAR_VMF);
> +	REG_SET_BIT(ah, AR_DIAG_SW, AR_DIAG_FORCE_CH_IDLE_HIGH);
> +	REG_SET_BIT(ah, AR_D_GBL_IFS_MISC, AR_D_GBL_IFS_MISC_IGNORE_BACKOFF);
> +
> +	for (q = 0; q < AR_NUM_QCU; q++) {
> +		for (i = 1000; i > 0; i--) {
> +			if (!ath9k_hw_numtxpending(ah, q))
> +				break;
> +
> +			udelay(5);
> +		}
> +	}
> +	if (!i)
> +		return false;

Here the assumption looks like a reset would follow to configure
those registers back, may be some comment will be useful.

> diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
> index e16136d..bb1d29e 100644
> --- a/drivers/net/wireless/ath/ath9k/xmit.c
> +++ b/drivers/net/wireless/ath/ath9k/xmit.c
> @@ -1194,16 +1194,14 @@ bool ath_drain_all_txq(struct ath_softc *sc, bool retry_tx)
>  	if (sc->sc_flags & SC_OP_INVALID)
>  		return true;
>  
> -	/* Stop beacon queue */
> -	ath9k_hw_stoptxdma(sc->sc_ah, sc->beacon.beaconq);
> +	ath9k_hw_abort_tx_dma(ah);
>  
> -	/* Stop data queues */
> +	/* Check if any queue remains active */
>  	for (i = 0; i < ATH9K_NUM_TX_QUEUES; i++) {
> -		if (ATH_TXQ_SETUP(sc, i)) {
> -			txq = &sc->tx.txq[i];
> -			ath9k_hw_stoptxdma(ah, txq->axq_qnum);
> -			npend += ath9k_hw_numtxpending(ah, txq->axq_qnum);
> -		}
> +		if (!ATH_TXQ_SETUP(sc, i))
> +			continue;
> +
> +		npend += ath9k_hw_numtxpending(ah, sc->tx.txq[i].axq_qnum);

This can be moved to ath9k_hw_abort_tx_dma() and make it return
npend as the current return value is unused anyway.

Vasanth
