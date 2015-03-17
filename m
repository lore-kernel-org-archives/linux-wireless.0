Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:54509 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932164AbbCQLYT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Mar 2015 07:24:19 -0400
Message-ID: <1426591453.1985.40.camel@sipsolutions.net> (sfid-20150317_122426_272725_064781D5)
Subject: Re: [PATCH v3] mac80211: add an intermediate software queue
 implementation
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 17 Mar 2015 12:24:13 +0100
In-Reply-To: <1426587719-99940-1-git-send-email-nbd@openwrt.org>
References: <1426587719-99940-1-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-03-17 at 11:21 +0100, Felix Fietkau wrote:

> +/**
> + * DOC: mac80211 software tx queueing
> + *
> + * mac80211 provides an optional intermediate queueing implementation designed
> + * to allow the driver to keep hardware queues short and provide some fairness
> + * between different stations/interfaces.
> + * In this model, the driver pulls data frames from the mac80211 queue instead
> + * of letting mac80211 push them via drv_tx(). Management frames are still sent
> + * via drv_tx().

IIRC there were some other frames - perhaps it should read "Some frames
(e.g. management) are still sent via drv_tx()."?

Also, I wonder if this is really correct, since bufferable management
frames are probably *not* desired to go through that?

> + * For AP powersave TIM handling, the driver only needs to indicate if it has
> + * buffered packets in the driver specific data structures. 

Maybe you should say how to indicate it.

> For frames buffered
> + * in the ieee80211_txq struct, mac80211 sets TIM and the driver is expected
> + * to dequeue and transmit packets on demand via the .release_buffered_frames
> + * op.
> + */

"via" reads odd here to me, perhaps say "to dequeue and transmit packets
on demand as requested by the .release_buffered_frames op"?

> @@ -1257,6 +1284,8 @@ struct ieee80211_vif {
>  	u8 cab_queue;
>  	u8 hw_queue[IEEE80211_NUM_ACS];
>  
> +	struct ieee80211_txq *txq;

This is just one txq, the mcast one? Perhaps that should be cab_txq
then?

Or is it multiple, then perhaps it should be "txqs"?

> +	struct ieee80211_txq *txq[IEEE80211_NUM_TIDS];

I wonder if there's a way to make this a single pointer here only? But I
guess with variable-sized driver data this would be really difficult.

>  /**
> + * struct ieee80211_txq - Software intermediate tx queue
> + *
> + * @vif: &struct ieee80211_vif pointer from the add_interface callback.
> + * @sta: station table entry, may be NULL for per-vif queue
> + * @tid: the TID for this queue (unset for per-vif queue)

"unset" is probably not really true (and it's 0) - "unused" might be
better?

> @@ -1818,6 +1872,9 @@ enum ieee80211_hw_flags {
>   * @n_cipher_schemes: a size of an array of cipher schemes definitions.
>   * @cipher_schemes: a pointer to an array of cipher scheme definitions
>   *	supported by HW.
> + *
> + * @txq_ac_max_pending: maximum number of frames per AC pending in all txq
> + *	entries for a vif.

I think you should give some guidance on how to best set this value,
like max aggregation size or something? I'm not really sure :)

> +static inline void drv_wake_tx_queue(struct ieee80211_local *local,
> +				     struct txq_info *txq)
> +{
> +	struct ieee80211_sub_if_data *sdata = vif_to_sdata(txq->txq.vif);
> +
> +	if (!check_sdata_in_driver(sdata))
> +		return;
> +
> +	if (txq->txq.sta)
> +		trace_drv_wake_sta_tx_queue(local, sdata, txq->txq.sta,
> +					    txq->txq.tid);
> +	else
> +		trace_drv_wake_vif_tx_queue(local, sdata);

Having separate tracepoints seems a bit strange - can't we unify them
and have any necessary if inside the fast_assign() part of the macro?
That way we stub out everything if tracing isn't enabled.

>  	if (ndev) {
> +		struct txq_info *txqi = NULL;
> +
> +		if (local->ops->wake_tx_queue) {
> +			txqi = kzalloc(sizeof(*txqi) +
> +				      local->hw.txq_data_size, GFP_KERNEL);
> +			if (txqi)
> +				ieee80211_init_tx_queue(sdata, NULL, txqi, 0);

Might be worth wrapping that into a single alloc_and_init() function? Or
really just alloc() since the init could be implied?

>  void ieee80211_if_remove(struct ieee80211_sub_if_data *sdata)
>  {
> +	struct txq_info *txqi;
>  	ASSERT_RTNL();
>  
>  	mutex_lock(&sdata->local->iflist_mtx);
> @@ -1790,6 +1804,11 @@ void ieee80211_if_remove(struct ieee80211_sub_if_data *sdata)
>  
>  	synchronize_rcu();
>  
> +	if (sdata->vif.txq) {
> +		txqi = container_of(sdata->vif.txq, struct txq_info, txq);

you could move the variable here

> @@ -1831,6 +1851,12 @@ void ieee80211_remove_interfaces(struct ieee80211_local *local)
>  	list_for_each_entry_safe(sdata, tmp, &local->interfaces, list) {
>  		list_del(&sdata->list);
>  
> +		if (sdata->vif.txq) {
> +			txqi = container_of(sdata->vif.txq, struct txq_info,
> +					   txq);

similar here

> @@ -1197,6 +1198,20 @@ static void sta_ps_start(struct sta_info *sta)
>  		drv_sta_notify(local, sdata, STA_NOTIFY_SLEEP, &sta->sta);
>  	ps_dbg(sdata, "STA %pM aid %d enters power save mode\n",
>  	       sta->sta.addr, sta->sta.aid);
> +
> +	if (!sta->txqi)
> +		return;
> +
> +	for (tid = 0; tid < IEEE80211_NUM_TIDS; tid++) {
> +		struct txq_info *txqi;
> +
> +		txqi = container_of(sta->sta.txq[tid], struct txq_info, txq);

Perhaps you should also have an inline for all the container_of() since
you do that a lot.

> -	if (sta_prepare_rate_control(local, sta, gfp)) {
> -		kfree(sta);
> -		return NULL;
> +	if (local->ops->wake_tx_queue) {
> +		void *txq_data;
> +		int size = sizeof(struct txq_info) +
> +			   ALIGN(hw->txq_data_size, sizeof(void *));
> +
> +		txq_data = kcalloc(IEEE80211_NUM_TIDS, size, gfp);
> +		if (!txq_data)
> +			goto free;
> +
> +		sta->txqi = txq_data;
> +		for (i = 0; i < IEEE80211_NUM_TIDS; i++) {
> +			struct txq_info *txq = txq_data + i * size;
> +			ieee80211_init_tx_queue(sdata, sta, txq, i);
> +		}
>  	}

Oh, so you do have a combined allocation scheme? I guess I need to look
at this in more detail.

> +	if (sta_prepare_rate_control(local, sta, gfp))
> +		goto free_txq;

Does it even have to come before rate control?

> @@ -1090,10 +1119,25 @@ void ieee80211_sta_ps_deliver_wakeup(struct sta_info *sta)
>  
>  	BUILD_BUG_ON(BITS_TO_LONGS(IEEE80211_NUM_TIDS) > 1);
>  	sta->driver_buffered_tids = 0;
> +	sta->txq_buffered_tids = 0;
>  
>  	if (!(local->hw.flags & IEEE80211_HW_AP_LINK_PS))
>  		drv_sta_notify(local, sdata, STA_NOTIFY_AWAKE, &sta->sta);
>  
> +	if (sta->txqi) {
> +		for (i = 0; i < ARRAY_SIZE(sta->sta.txq); i++) {
> +			struct txq_info *txqi;
> +
> +			txqi = container_of(sta->sta.txq[i], struct txq_info,
> +					    txq);
> +
> +			if (!skb_queue_len(&txqi->queue))
> +				continue;
> +
> +			drv_wake_tx_queue(local, txqi);
> +		}
> +	}

This could be an interesting race. If you wake the queue, and then the
station goes to sleep again before the driver had a chance to pull
frames, what happens? Should the driver be responsible for this? But you
don't have "unwake_tx_queue", so maybe you should not return any frame
from the dequeue in such a case?

> @@ -1447,6 +1493,8 @@ ieee80211_sta_ps_deliver_response(struct sta_info *sta,
>  
>  		sta_info_recalc_tim(sta);
>  	} else {
> +		unsigned long tids = sta->txq_buffered_tids & driver_release_tids;

I'm not sure I understand this. Are you treating txq_buffered_tids as
driver-buffered?

>  		/*
>  		 * We need to release a frame that is buffered somewhere in the
>  		 * driver ... it'll have to handle that.
> @@ -1466,8 +1514,25 @@ ieee80211_sta_ps_deliver_response(struct sta_info *sta,
>  		 * that the TID(s) became empty before returning here from the
>  		 * release function.
>  		 * Either way, however, when the driver tells us that the TID(s)
> -		 * became empty we'll do the TIM recalculation.
> +		 * became empty or we find that a txq became empty, we'll do the
> +		 * TIM recalculation.
>  		 */
> +
> +		if (!sta->txqi)
> +			return;
> +
> +		for (tid = 0; tid < IEEE80211_NUM_TIDS; tid++) {
> +			struct txq_info *txqi;
> +
> +			txqi = container_of(sta->sta.txq[tid], struct txq_info,
> +					    txq);
> +
> +			if (!(tids & BIT(tid)) || skb_queue_len(&txqi->queue))
> +				continue;
> +
> +			sta_info_recalc_tim(sta);
> +			break;
> +		}

[left as context in case you need it to explain]

> @@ -368,6 +369,8 @@ struct sta_info {
>  	struct sk_buff_head ps_tx_buf[IEEE80211_NUM_ACS];
>  	struct sk_buff_head tx_filtered[IEEE80211_NUM_ACS];
>  	unsigned long driver_buffered_tids;
> +	unsigned long txq_buffered_tids;
> +	struct txq_info *txqi;

Hm, so, internally you allocate one big thing and externally to the
driver you have a per-TID array.

Why not just remove this pointer, and keep only the per-TID array? You'd
have to do a bit more container_of() but I don't think that's a big
deal? Plus you can't really use this anyway since you can't index it,
i.e. you cannot say sta->txqi[t] since the size doesn't match up.

> +static void ieee80211_drv_tx(struct ieee80211_local *local,
> +			     struct ieee80211_vif *vif,
> +			     struct ieee80211_sta *pubsta,
> +			     struct sk_buff *skb)
> +{
> +	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
> +	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
> +	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
> +	struct ieee80211_tx_control control = {
> +		.sta = pubsta
> +	};
> +	struct ieee80211_txq *txq = NULL;
> +	struct txq_info *txqi;
> +	u8 ac;
> +
> +	if (info->control.flags & IEEE80211_TX_CTRL_PS_RESPONSE)
> +		goto tx_normal;
> +
> +	if (ieee80211_is_mgmt(hdr->frame_control) ||
> +	    ieee80211_is_ctl(hdr->frame_control))
> +		goto tx_normal;

Doesn't this become awkward with powersave handling for bufferable mgmt
frames? They'd be stored on the per-station non-txq queues, but then the
wakeup handling needs to see which ones to take first? Having these on
the txqs might make that part easier?

OTOH, I guess it would make building A-MPDUs or even A-MSDUs far more
complicated, so I guess it's a reasonable tradeoff.

> +struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
> +				     struct ieee80211_txq *txq)
> +{
> +	struct ieee80211_local *local = hw_to_local(hw);
> +	struct ieee80211_sub_if_data *sdata = vif_to_sdata(txq->vif);
> +	struct txq_info *txqi = container_of(txq, struct txq_info, txq);
> +	struct sk_buff *skb;
> +	u8 ac = txq->ac;
> +
> +	skb = skb_dequeue(&txqi->queue);
> +	if (!skb)
> +		return ERR_PTR(-EAGAIN);

why not just return NULL?

> +	atomic_dec(&sdata->txqs_len[ac]);
> +	if (__netif_subqueue_stopped(sdata->dev, ac))
> +		ieee80211_propagate_queue_wake(local, sdata->vif.hw_queue[ac]);

Do you really want to do that unconditionally? There could be a lot of
frames on the queue still, or even on other station queues?

> +	if (sta) {
> +		txqi->txq.sta = &sta->sta;
> +		sta->sta.txq[tid] = &txqi->txq;
> +		txqi->txq.ac = ieee802_1d_to_ac[tid & 7];

I think you should probably restrict this to 8 TIDs anyway... nobody
uses 16 TIDs, and the mapping for the higher 8 TIDs is dynamic so this
is always wrong. Using just 8 instead of 16 will also save a lot of
memory I guess.

If you want TSPECs, then you probably want the WMM ones, which also only
use the lower 8 TIDs. Only if you really wanted the 802.11 QoS TSPEC you
might need the higher 8 TIDs ...


Anyway - overall I think this looks pretty good. What we discussed in
Ottawa was that we should perhaps forego the whole qdisc and netdev
queue start/stop and just do something like the qdisc would do in the
layer of these queues, although then we'd have to first convert every
driver or make this layer mandatory in some other way. That's something
we should explore here I think.

johannes

