Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:47624 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754713Ab0LHAqX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Dec 2010 19:46:23 -0500
Message-ID: <4CFED55B.20303@candelatech.com>
Date: Tue, 07 Dec 2010 16:46:19 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2.6.37] ath9k: fix a DMA related race condition on reset
References: <1291576673-1462-1-git-send-email-nbd@openwrt.org>
In-Reply-To: <1291576673-1462-1-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/05/2010 11:17 AM, Felix Fietkau wrote:
> When ath_drain_all_txq fails to stop DMA, it issues a hw reset. This reset
> happens at a very problematic point in time, when the hardware rx path has
> not been stopped yet. This could lead to memory corruption, hardware hangs
> or other issues.
> To fix these issues, simply remove the reset entirely and check the tx DMA
> stop status to prevent problems with fast channel changes.

Should we put this change into wireless-testing as well?

Thanks,
Ben

>
> Signed-off-by: Felix Fietkau<nbd@openwrt.org>
> ---
>   drivers/net/wireless/ath/ath9k/ath9k.h |    2 +-
>   drivers/net/wireless/ath/ath9k/main.c  |    5 +++--
>   drivers/net/wireless/ath/ath9k/xmit.c  |   22 ++++++----------------
>   3 files changed, 10 insertions(+), 19 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
> index 0d0bec3..0963071 100644
> --- a/drivers/net/wireless/ath/ath9k/ath9k.h
> +++ b/drivers/net/wireless/ath/ath9k/ath9k.h
> @@ -329,7 +329,7 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp);
>   struct ath_txq *ath_txq_setup(struct ath_softc *sc, int qtype, int subtype);
>   void ath_tx_cleanupq(struct ath_softc *sc, struct ath_txq *txq);
>   int ath_tx_setup(struct ath_softc *sc, int haltype);
> -void ath_drain_all_txq(struct ath_softc *sc, bool retry_tx);
> +bool ath_drain_all_txq(struct ath_softc *sc, bool retry_tx);
>   void ath_draintxq(struct ath_softc *sc,
>   		     struct ath_txq *txq, bool retry_tx);
>   void ath_tx_node_init(struct ath_softc *sc, struct ath_node *an);
> diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
> index dace215..928ef68 100644
> --- a/drivers/net/wireless/ath/ath9k/main.c
> +++ b/drivers/net/wireless/ath/ath9k/main.c
> @@ -244,11 +244,12 @@ int ath_set_channel(struct ath_softc *sc, struct ieee80211_hw *hw,
>   	 * the relevant bits of the h/w.
>   	 */
>   	ath9k_hw_set_interrupts(ah, 0);
> -	ath_drain_all_txq(sc, false);
> +	stopped = ath_drain_all_txq(sc, false);
>
>   	spin_lock_bh(&sc->rx.pcu_lock);
>
> -	stopped = ath_stoprecv(sc);
> +	if (!ath_stoprecv(sc))
> +		stopped = false;
>
>   	/* XXX: do not flush receive queue here. We don't want
>   	 * to flush data frames already in queue because of
> diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
> index f2ade24..aff0478 100644
> --- a/drivers/net/wireless/ath/ath9k/xmit.c
> +++ b/drivers/net/wireless/ath/ath9k/xmit.c
> @@ -1120,7 +1120,7 @@ void ath_draintxq(struct ath_softc *sc, struct ath_txq *txq, bool retry_tx)
>   	}
>   }
>
> -void ath_drain_all_txq(struct ath_softc *sc, bool retry_tx)
> +bool ath_drain_all_txq(struct ath_softc *sc, bool retry_tx)
>   {
>   	struct ath_hw *ah = sc->sc_ah;
>   	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
> @@ -1128,7 +1128,7 @@ void ath_drain_all_txq(struct ath_softc *sc, bool retry_tx)
>   	int i, npend = 0;
>
>   	if (sc->sc_flags&  SC_OP_INVALID)
> -		return;
> +		return true;
>
>   	/* Stop beacon queue */
>   	ath9k_hw_stoptxdma(sc->sc_ah, sc->beacon.beaconq);
> @@ -1142,25 +1142,15 @@ void ath_drain_all_txq(struct ath_softc *sc, bool retry_tx)
>   		}
>   	}
>
> -	if (npend) {
> -		int r;
> -
> -		ath_print(common, ATH_DBG_FATAL,
> -			  "Failed to stop TX DMA. Resetting hardware!\n");
> -
> -		spin_lock_bh(&sc->sc_resetlock);
> -		r = ath9k_hw_reset(ah, sc->sc_ah->curchan, ah->caldata, false);
> -		if (r)
> -			ath_print(common, ATH_DBG_FATAL,
> -				  "Unable to reset hardware; reset status %d\n",
> -				  r);
> -		spin_unlock_bh(&sc->sc_resetlock);
> -	}
> +	if (npend)
> +		ath_print(common, ATH_DBG_FATAL, "Failed to stop TX DMA!\n");
>
>   	for (i = 0; i<  ATH9K_NUM_TX_QUEUES; i++) {
>   		if (ATH_TXQ_SETUP(sc, i))
>   			ath_draintxq(sc,&sc->tx.txq[i], retry_tx);
>   	}
> +
> +	return !npend;
>   }
>
>   void ath_tx_cleanupq(struct ath_softc *sc, struct ath_txq *txq)


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

