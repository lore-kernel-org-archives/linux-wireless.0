Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:43436 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753027AbbCQMEk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Mar 2015 08:04:40 -0400
Message-ID: <55081851.4030105@openwrt.org> (sfid-20150317_130448_280419_25A9A036)
Date: Tue, 17 Mar 2015 13:04:33 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v3] mac80211: add an intermediate software queue implementation
References: <1426587719-99940-1-git-send-email-nbd@openwrt.org> <1426591453.1985.40.camel@sipsolutions.net>
In-Reply-To: <1426591453.1985.40.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2015-03-17 12:24, Johannes Berg wrote:
> On Tue, 2015-03-17 at 11:21 +0100, Felix Fietkau wrote:
>> @@ -1257,6 +1284,8 @@ struct ieee80211_vif {
>>  	u8 cab_queue;
>>  	u8 hw_queue[IEEE80211_NUM_ACS];
>>  
>> +	struct ieee80211_txq *txq;
> 
> This is just one txq, the mcast one? Perhaps that should be cab_txq
> then?
That would be misleading, since this queue is only used when CAB isn't
(i.e. no sta in PS).

> Or is it multiple, then perhaps it should be "txqs"?
> 
>> +	struct ieee80211_txq *txq[IEEE80211_NUM_TIDS];
> 
> I wonder if there's a way to make this a single pointer here only? But I
> guess with variable-sized driver data this would be really difficult.
Maybe a potential optimization for later - I'd like to keep it simple
for now...

>> @@ -1818,6 +1872,9 @@ enum ieee80211_hw_flags {
>>   * @n_cipher_schemes: a size of an array of cipher schemes definitions.
>>   * @cipher_schemes: a pointer to an array of cipher scheme definitions
>>   *	supported by HW.
>> + *
>> + * @txq_ac_max_pending: maximum number of frames per AC pending in all txq
>> + *	entries for a vif.
> 
> I think you should give some guidance on how to best set this value,
> like max aggregation size or something? I'm not really sure :)
I don't have any guidance for tuning this in the driver just yet.
For devices with software aggregation, it should just be left at the
default value.

>> +	if (sta_prepare_rate_control(local, sta, gfp))
>> +		goto free_txq;
> 
> Does it even have to come before rate control?
It doesn't have to, but I figured cleanup is simpler that way.

>> @@ -1090,10 +1119,25 @@ void ieee80211_sta_ps_deliver_wakeup(struct sta_info *sta)
>>  
>>  	BUILD_BUG_ON(BITS_TO_LONGS(IEEE80211_NUM_TIDS) > 1);
>>  	sta->driver_buffered_tids = 0;
>> +	sta->txq_buffered_tids = 0;
>>  
>>  	if (!(local->hw.flags & IEEE80211_HW_AP_LINK_PS))
>>  		drv_sta_notify(local, sdata, STA_NOTIFY_AWAKE, &sta->sta);
>>  
>> +	if (sta->txqi) {
>> +		for (i = 0; i < ARRAY_SIZE(sta->sta.txq); i++) {
>> +			struct txq_info *txqi;
>> +
>> +			txqi = container_of(sta->sta.txq[i], struct txq_info,
>> +					    txq);
>> +
>> +			if (!skb_queue_len(&txqi->queue))
>> +				continue;
>> +
>> +			drv_wake_tx_queue(local, txqi);
>> +		}
>> +	}
> 
> This could be an interesting race. If you wake the queue, and then the
> station goes to sleep again before the driver had a chance to pull
> frames, what happens? Should the driver be responsible for this? But you
> don't have "unwake_tx_queue", so maybe you should not return any frame
> from the dequeue in such a case?
The driver is responsible for making sure that any queue of a sleeping
sta is not scheduled.

>> @@ -1447,6 +1493,8 @@ ieee80211_sta_ps_deliver_response(struct sta_info *sta,
>>  
>>  		sta_info_recalc_tim(sta);
>>  	} else {
>> +		unsigned long tids = sta->txq_buffered_tids & driver_release_tids;
> 
> I'm not sure I understand this. Are you treating txq_buffered_tids as
> driver-buffered?
Yes. As explained in the DOC section, PS delivery of txq buffered frames
goes through drv_release_buffered_frames. Maybe I could change the
wording a bit to make it more clear.

>> @@ -368,6 +369,8 @@ struct sta_info {
>>  	struct sk_buff_head ps_tx_buf[IEEE80211_NUM_ACS];
>>  	struct sk_buff_head tx_filtered[IEEE80211_NUM_ACS];
>>  	unsigned long driver_buffered_tids;
>> +	unsigned long txq_buffered_tids;
>> +	struct txq_info *txqi;
> 
> Hm, so, internally you allocate one big thing and externally to the
> driver you have a per-TID array.
> 
> Why not just remove this pointer, and keep only the per-TID array? You'd
> have to do a bit more container_of() but I don't think that's a big
> deal? Plus you can't really use this anyway since you can't index it,
> i.e. you cannot say sta->txqi[t] since the size doesn't match up.
Will do

>> +static void ieee80211_drv_tx(struct ieee80211_local *local,
>> +			     struct ieee80211_vif *vif,
>> +			     struct ieee80211_sta *pubsta,
>> +			     struct sk_buff *skb)
>> +{
>> +	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
>> +	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
>> +	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
>> +	struct ieee80211_tx_control control = {
>> +		.sta = pubsta
>> +	};
>> +	struct ieee80211_txq *txq = NULL;
>> +	struct txq_info *txqi;
>> +	u8 ac;
>> +
>> +	if (info->control.flags & IEEE80211_TX_CTRL_PS_RESPONSE)
>> +		goto tx_normal;
>> +
>> +	if (ieee80211_is_mgmt(hdr->frame_control) ||
>> +	    ieee80211_is_ctl(hdr->frame_control))
>> +		goto tx_normal;
> 
> Doesn't this become awkward with powersave handling for bufferable mgmt
> frames? They'd be stored on the per-station non-txq queues, but then the
> wakeup handling needs to see which ones to take first? Having these on
> the txqs might make that part easier?
I guess I'll change it to throw bufferable mgmt frames in the txq as well.

> OTOH, I guess it would make building A-MPDUs or even A-MSDUs far more
> complicated, so I guess it's a reasonable tradeoff.
> 
>> +struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
>> +				     struct ieee80211_txq *txq)
>> +{
>> +	struct ieee80211_local *local = hw_to_local(hw);
>> +	struct ieee80211_sub_if_data *sdata = vif_to_sdata(txq->vif);
>> +	struct txq_info *txqi = container_of(txq, struct txq_info, txq);
>> +	struct sk_buff *skb;
>> +	u8 ac = txq->ac;
>> +
>> +	skb = skb_dequeue(&txqi->queue);
>> +	if (!skb)
>> +		return ERR_PTR(-EAGAIN);
> 
> why not just return NULL?
I guess initially I wanted to be able to return other error codes as
well, but now I'm not sure I need that anymore. I'll change it to NULL.

>> +	atomic_dec(&sdata->txqs_len[ac]);
>> +	if (__netif_subqueue_stopped(sdata->dev, ac))
>> +		ieee80211_propagate_queue_wake(local, sdata->vif.hw_queue[ac]);
> 
> Do you really want to do that unconditionally? There could be a lot of
> frames on the queue still, or even on other station queues?
Unconditionally? ieee80211_propagate_queue_wake checks the per-sdata txq
limit.

>> +	if (sta) {
>> +		txqi->txq.sta = &sta->sta;
>> +		sta->sta.txq[tid] = &txqi->txq;
>> +		txqi->txq.ac = ieee802_1d_to_ac[tid & 7];
> 
> I think you should probably restrict this to 8 TIDs anyway... nobody
> uses 16 TIDs, and the mapping for the higher 8 TIDs is dynamic so this
> is always wrong. Using just 8 instead of 16 will also save a lot of
> memory I guess.
> 
> If you want TSPECs, then you probably want the WMM ones, which also only
> use the lower 8 TIDs. Only if you really wanted the 802.11 QoS TSPEC you
> might need the higher 8 TIDs ...
Right, limiting it to 8 makes sense.

> Anyway - overall I think this looks pretty good. What we discussed in
> Ottawa was that we should perhaps forego the whole qdisc and netdev
> queue start/stop and just do something like the qdisc would do in the
> layer of these queues, although then we'd have to first convert every
> driver or make this layer mandatory in some other way. That's something
> we should explore here I think.
I agree. Figuring out what tx queue scheduling should look like for
devices with firmware based aggregation is going to be interesting
though...

- Felix
