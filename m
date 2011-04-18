Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:37256 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067Ab1DREY2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2011 00:24:28 -0400
Received: by pvg12 with SMTP id 12so1974907pvg.19
        for <linux-wireless@vger.kernel.org>; Sun, 17 Apr 2011 21:24:28 -0700 (PDT)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19883.48525.986878.991570@gargle.gargle.HOWL>
Date: Mon, 18 Apr 2011 09:56:53 +0530
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	lrodriguez@atheros.com, jouni.malinen@atheros.com
Subject: [PATCH 1/2] ath9k: fix powersave frame filtering/buffering in AP mode
In-Reply-To: <1303075690-53804-1-git-send-email-nbd@openwrt.org>
References: <1303075690-53804-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau wrote:
> diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
> index 77ad407..a2ddabf 100644
> --- a/drivers/net/wireless/ath/ath9k/ath9k.h
> +++ b/drivers/net/wireless/ath/ath9k/ath9k.h
> @@ -200,6 +200,7 @@ struct ath_atx_ac {
>  	int sched;
>  	struct list_head list;
>  	struct list_head tid_q;
> +	bool clear_ps_filter;

The destination mask is per-station, so would ath_node be a better place for this
variable ?

> +static void ath9k_sta_notify(struct ieee80211_hw *hw,
> +			 struct ieee80211_vif *vif,
> +			 enum sta_notify_cmd cmd,
> +			 struct ieee80211_sta *sta)
> +{
> +	struct ath_softc *sc = hw->priv;
> +	struct ath_node *an = (struct ath_node *) sta->drv_priv;
> +
> +	switch (cmd) {
> +	case STA_NOTIFY_SLEEP:
> +		an->sleeping = true;
> +		if (ath_tx_aggr_sleep(sc, an))
> +			ieee80211_sta_set_tim(sta);
> +		break;
> +	case STA_NOTIFY_AWAKE:
> +		an->sleeping = false;
> +		ath_tx_aggr_wakeup(sc, an);
> +		break;
> +	}
> +}
> +

an->sleeping needs to be locked, no ?
It seems to be accessed from the TX tasklet also.

> diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
> index 3cea3f7..a1230c0 100644
> --- a/drivers/net/wireless/ath/ath9k/xmit.c
> +++ b/drivers/net/wireless/ath/ath9k/xmit.c
> @@ -357,6 +357,7 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
>  	struct ath_frame_info *fi;
>  	int nframes;
>  	u8 tidno;
> +	bool clear_filter;
>  
>  	skb = bf->bf_mpdu;
>  	hdr = (struct ieee80211_hdr *)skb->data;
> @@ -441,22 +442,24 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
>  			/* transmit completion */
>  			acked_cnt++;
>  		} else {
> -			if (!(tid->state & AGGR_CLEANUP) && retry) {
> -				if (fi->retries < ATH_MAX_SW_RETRIES) {
> -					ath_tx_set_retry(sc, txq, bf->bf_mpdu);
> -					txpending = 1;
> -				} else {
> -					bf->bf_state.bf_type |= BUF_XRETRY;
> -					txfail = 1;
> -					sendbar = 1;
> -					txfail_cnt++;
> -				}
> -			} else {
> +			if ((tid->state & AGGR_CLEANUP) || !retry) {
>  				/*
>  				 * cleanup in progress, just fail
>  				 * the un-acked sub-frames
>  				 */
>  				txfail = 1;
> +			} else if (fi->retries < ATH_MAX_SW_RETRIES) {
> +				if (!(ts->ts_status & ATH9K_TXERR_FILT) ||
> +				    !an->sleeping)
> +					ath_tx_set_retry(sc, txq, bf->bf_mpdu);
> +
> +				clear_filter = true;
> +				txpending = 1;
> +			} else {
> +				bf->bf_state.bf_type |= BUF_XRETRY;
> +				txfail = 1;
> +				sendbar = 1;
> +				txfail_cnt++;
>  			}
>  		}
>  
> @@ -496,6 +499,7 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
>  				!txfail, sendbar);
>  		} else {
>  			/* retry the un-acked ones */
> +			ath9k_hw_set_clrdmask(sc->sc_ah, bf->bf_desc, false);
>  			if (!(sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_EDMA)) {
>  				if (bf->bf_next == NULL && bf_last->bf_stale) {
>  					struct ath_buf *tbf;
> @@ -546,7 +550,12 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
>  
>  	/* prepend un-acked frames to the beginning of the pending frame queue */
>  	if (!list_empty(&bf_pending)) {
> +		if (an->sleeping)
> +			ieee80211_sta_set_tim(sta);
> +
>  		spin_lock_bh(&txq->axq_lock);
> +		if (clear_filter)
> +			tid->ac->clear_ps_filter = true;
>  		list_splice(&bf_pending, &tid->buf_q);
>  		ath_tx_queue_tid(txq, tid);
>  		spin_unlock_bh(&txq->axq_lock);
> @@ -816,6 +825,11 @@ static void ath_tx_sched_aggr(struct ath_softc *sc, struct ath_txq *txq,
>  		bf = list_first_entry(&bf_q, struct ath_buf, list);
>  		bf->bf_lastbf = list_entry(bf_q.prev, struct ath_buf, list);
>  
> +		if (tid->ac->clear_ps_filter) {
> +			tid->ac->clear_ps_filter = false;
> +			ath9k_hw_set_clrdmask(sc->sc_ah, bf->bf_desc, true);
> +		}
> +

Can you explain a bit more on the flow ? How exactly is ieee80211_sta_set_tim() to be used
by a driver ? (I would like to port this fix to ath9k_htc).

>  		/* if only one frame, send as non-aggregate */
>  		if (bf == bf->bf_lastbf) {
>  			fi = get_frame_info(bf->bf_mpdu);
> @@ -896,6 +910,67 @@ void ath_tx_aggr_stop(struct ath_softc *sc, struct ieee80211_sta *sta, u16 tid)
>  	ath_tx_flush_tid(sc, txtid);
>  }
>  
> +bool ath_tx_aggr_sleep(struct ath_softc *sc, struct ath_node *an)
> +{
> +	struct ath_atx_tid *tid;
> +	struct ath_atx_ac *ac;
> +	struct ath_txq *txq;
> +	bool buffered = false;
> +	int tidno;
> +
> +	for (tidno = 0, tid = &an->tid[tidno];
> +	     tidno < WME_NUM_TID; tidno++, tid++) {
> +
> +		if (!tid->sched)
> +			continue;

tid->sched has to be locked ?

Sujith
