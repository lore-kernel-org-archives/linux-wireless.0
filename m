Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:51767 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751616Ab1DRIyy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2011 04:54:54 -0400
Message-ID: <4DABFC54.8030502@openwrt.org>
Date: Mon, 18 Apr 2011 10:54:44 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Sujith <m.sujith@gmail.com>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	lrodriguez@atheros.com, jouni.malinen@atheros.com
Subject: Re: [PATCH 1/2] ath9k: fix powersave frame filtering/buffering in
 AP mode
References: <1303075690-53804-1-git-send-email-nbd@openwrt.org> <19883.48525.986878.991570@gargle.gargle.HOWL>
In-Reply-To: <19883.48525.986878.991570@gargle.gargle.HOWL>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-04-18 6:26 AM, Sujith wrote:
> Felix Fietkau wrote:
>>  diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
>>  index 77ad407..a2ddabf 100644
>>  --- a/drivers/net/wireless/ath/ath9k/ath9k.h
>>  +++ b/drivers/net/wireless/ath/ath9k/ath9k.h
>>  @@ -200,6 +200,7 @@ struct ath_atx_ac {
>>   	int sched;
>>   	struct list_head list;
>>   	struct list_head tid_q;
>>  +	bool clear_ps_filter;
>
> The destination mask is per-station, so would ath_node be a better place for this
> variable ?
That's what I thought at first as well, but the problem with that is 
that when using multiple queues there is no guarantee that the A-MPDU 
enqueued first is also transmitted first, so I decided to do it once per 
AC. Most of the time, only BE is active anyway...

>>  +static void ath9k_sta_notify(struct ieee80211_hw *hw,
>>  +			 struct ieee80211_vif *vif,
>>  +			 enum sta_notify_cmd cmd,
>>  +			 struct ieee80211_sta *sta)
>>  +{
>>  +	struct ath_softc *sc = hw->priv;
>>  +	struct ath_node *an = (struct ath_node *) sta->drv_priv;
>>  +
>>  +	switch (cmd) {
>>  +	case STA_NOTIFY_SLEEP:
>>  +		an->sleeping = true;
>>  +		if (ath_tx_aggr_sleep(sc, an))
>>  +			ieee80211_sta_set_tim(sta);
>>  +		break;
>>  +	case STA_NOTIFY_AWAKE:
>>  +		an->sleeping = false;
>>  +		ath_tx_aggr_wakeup(sc, an);
>>  +		break;
>>  +	}
>>  +}
>>  +
>
> an->sleeping needs to be locked, no ?
> It seems to be accessed from the TX tasklet also.
It is only updated in this function and these updates should be atomic 
anyway, so I don't think locking would be useful here.

>>  diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
>>  index 3cea3f7..a1230c0 100644
>>  --- a/drivers/net/wireless/ath/ath9k/xmit.c
>>  +++ b/drivers/net/wireless/ath/ath9k/xmit.c
>>  @@ -357,6 +357,7 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
>>   	struct ath_frame_info *fi;
>>   	int nframes;
>>   	u8 tidno;
>>  +	bool clear_filter;
>>
>>   	skb = bf->bf_mpdu;
>>   	hdr = (struct ieee80211_hdr *)skb->data;
>>  @@ -816,6 +825,11 @@ static void ath_tx_sched_aggr(struct ath_softc *sc, struct ath_txq *txq,
>>   		bf = list_first_entry(&bf_q, struct ath_buf, list);
>>   		bf->bf_lastbf = list_entry(bf_q.prev, struct ath_buf, list);
>>
>>  +		if (tid->ac->clear_ps_filter) {
>>  +			tid->ac->clear_ps_filter = false;
>>  +			ath9k_hw_set_clrdmask(sc->sc_ah, bf->bf_desc, true);
>>  +		}
>>  +
>
> Can you explain a bit more on the flow ? How exactly is ieee80211_sta_set_tim() to be used
> by a driver ? (I would like to port this fix to ath9k_htc).
The driver calls ieee80211_sta_set_tim on STA_NOTIFY_SLEEP whenever it 
still has some buffered frames that it intends to keep until the client 
wakes up again (i.e. frames that will not be returned to mac80211 as 
filtered).

>>   		/* if only one frame, send as non-aggregate */
>>   		if (bf == bf->bf_lastbf) {
>>   			fi = get_frame_info(bf->bf_mpdu);
>>  @@ -896,6 +910,67 @@ void ath_tx_aggr_stop(struct ath_softc *sc, struct ieee80211_sta *sta, u16 tid)
>>   	ath_tx_flush_tid(sc, txtid);
>>   }
>>
>>  +bool ath_tx_aggr_sleep(struct ath_softc *sc, struct ath_node *an)
>>  +{
>>  +	struct ath_atx_tid *tid;
>>  +	struct ath_atx_ac *ac;
>>  +	struct ath_txq *txq;
>>  +	bool buffered = false;
>>  +	int tidno;
>>  +
>>  +	for (tidno = 0, tid =&an->tid[tidno];
>>  +	     tidno<  WME_NUM_TID; tidno++, tid++) {
>>  +
>>  +		if (!tid->sched)
>>  +			continue;
>
> tid->sched has to be locked ?
Yeah, I think that one might need locking.

- Felix
