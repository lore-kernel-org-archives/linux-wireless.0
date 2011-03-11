Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:33170 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754027Ab1CKU3f (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Mar 2011 15:29:35 -0500
Message-ID: <4D7A8628.2030902@openwrt.org>
Date: Fri, 11 Mar 2011 21:29:28 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: linville@tuxdriver.com, lrodriguez@atheros.com,
	vasanth@atheros.com, mark@moxienet.com
Subject: Re: [PATCH v3 4/4] ath9k: improve reliability of beacon transmission
 and stuck beacon handling
References: <1299873695-1062-1-git-send-email-nbd@openwrt.org> <1299873695-1062-2-git-send-email-nbd@openwrt.org> <1299873695-1062-3-git-send-email-nbd@openwrt.org> <1299873695-1062-4-git-send-email-nbd@openwrt.org>
In-Reply-To: <1299873695-1062-4-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-03-11 9:01 PM, Felix Fietkau wrote:
> ath9k calls ath9k_hw_stoptxdma every time it sends a beacon, however there
> is not much point in doing that if the previous beacon and mcast traffic
> went out properly. On AR9380, calling that function too often can result
> in an increase of stuck beacons due to differences in the handling of the
> queue enable/disable functionality.
> 
> With this patch, the queue will only be explicitly stopped if the previous
> data frames were not sent successfully. With the beacon code being the
> only remaining user of ath9k_hw_stoptxdma, this function can be simplified
> in order to remove the now pointless attempts at waiting for transmission
> completion, which would never happen at this point due to the different
> method of tx scheduling of the beacon queue.
> 
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> ---
>  drivers/net/wireless/ath/ath9k/beacon.c |   13 +-----
>  drivers/net/wireless/ath/ath9k/mac.c    |   68 +++---------------------------
>  drivers/net/wireless/ath/ath9k/mac.h    |    2 +-
>  3 files changed, 10 insertions(+), 73 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
> index a4bdfdb..6d2a545f 100644
> --- a/drivers/net/wireless/ath/ath9k/beacon.c
> +++ b/drivers/net/wireless/ath/ath9k/beacon.c
> @@ -373,6 +373,7 @@ void ath_beacon_tasklet(unsigned long data)
>  			ath_dbg(common, ATH_DBG_BSTUCK,
>  				"missed %u consecutive beacons\n",
>  				sc->beacon.bmisscnt);
> +			ath9k_hw_stop_dma_queue(ah, sc->beacon.beaconq);
>  			ath9k_hw_bstuck_nfcal(ah);
>  		} else if (sc->beacon.bmisscnt >= BSTUCK_THRESH) {
>  			ath_dbg(common, ATH_DBG_BSTUCK,
> @@ -450,16 +451,6 @@ void ath_beacon_tasklet(unsigned long data)
>  		sc->beacon.updateslot = OK;
>  	}
>  	if (bfaddr != 0) {
> -		/*
> -		 * Stop any current dma and put the new frame(s) on the queue.
> -		 * This should never fail since we check above that no frames
> -		 * are still pending on the queue.
> -		 */
> -		if (!ath9k_hw_stoptxdma(ah, sc->beacon.beaconq)) {
> -			ath_err(common, "beacon queue %u did not stop?\n",
> -				sc->beacon.beaconq);
> -		}
> -
>  		/* NB: cabq traffic should already be queued and primed */
>  		ath9k_hw_puttxbuf(ah, sc->beacon.beaconq, bfaddr);
>  		ath9k_hw_txstart(ah, sc->beacon.beaconq);
> @@ -780,7 +771,7 @@ void ath9k_set_beaconing_status(struct ath_softc *sc, bool status)
>  		ah->imask &= ~ATH9K_INT_SWBA;
>  		ath9k_hw_set_interrupts(ah, ah->imask);
>  		tasklet_kill(&sc->bcon_tasklet);
> -		ath9k_hw_stoptxdma(ah, sc->beacon.beaconq);
> +		ath9k_hw_stop_dma_queue(ah, sc->beacon.beaconq);
>  	}
>  	ath9k_ps_restore(sc);
>  }
> diff --git a/drivers/net/wireless/ath/ath9k/mac.c b/drivers/net/wireless/ath/ath9k/mac.c
> index b4e9ed9..ff1f860 100644
> --- a/drivers/net/wireless/ath/ath9k/mac.c
> +++ b/drivers/net/wireless/ath/ath9k/mac.c
> @@ -171,84 +171,30 @@ void ath9k_hw_abort_tx_dma(struct ath_hw *ah)
>  }
>  EXPORT_SYMBOL(ath9k_hw_abort_tx_dma);
>  
> -bool ath9k_hw_stoptxdma(struct ath_hw *ah, u32 q)
> +bool ath9k_hw_stop_dma_queue(struct ath_hw *ah, u32 q)
>  {
> -#define ATH9K_TX_STOP_DMA_TIMEOUT	4000    /* usec */
> +#define ATH9K_TX_STOP_DMA_TIMEOUT	1000    /* usec */
>  #define ATH9K_TIME_QUANTUM		100     /* usec */
> -	struct ath_common *common = ath9k_hw_common(ah);
> -	struct ath9k_hw_capabilities *pCap = &ah->caps;
> -	struct ath9k_tx_queue_info *qi;
> -	u32 tsfLow, j, wait;
> -	u32 wait_time = ATH9K_TX_STOP_DMA_TIMEOUT / ATH9K_TIME_QUANTUM;
> -
> -	if (q >= pCap->total_queues) {
> -		ath_dbg(common, ATH_DBG_QUEUE,
> -			"Stopping TX DMA, invalid queue: %u\n", q);
> -		return false;
> -	}
> -
> -	qi = &ah->txq[q];
> -	if (qi->tqi_type == ATH9K_TX_QUEUE_INACTIVE) {
> -		ath_dbg(common, ATH_DBG_QUEUE,
> -			"Stopping TX DMA, inactive queue: %u\n", q);
> -		return false;
> -	}
> +	int wait_time = ATH9K_TX_STOP_DMA_TIMEOUT / ATH9K_TIME_QUANTUM;
> +	int wait;
>  
>  	REG_WRITE(ah, AR_Q_TXD, 1 << q);
>  
>  	for (wait = wait_time; wait != 0; wait--) {
>  		if (ath9k_hw_numtxpending(ah, q) == 0)
>  			break;
> -		udelay(ATH9K_TIME_QUANTUM);
> -	}
Forgot to fix the delay here - will send a v4 :)

- Felix
