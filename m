Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:58815 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967589AbaLLNk3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Dec 2014 08:40:29 -0500
Message-ID: <548AF047.9080404@openwrt.org> (sfid-20141212_144032_336936_0EBB7A96)
Date: Fri, 12 Dec 2014 14:40:23 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: add an intermediate software queue implementation
References: <1416352495-82172-1-git-send-email-nbd@openwrt.org> <1418390516.2470.46.camel@sipsolutions.net>
In-Reply-To: <1418390516.2470.46.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2014-12-12 14:21, Johannes Berg wrote:
> On Wed, 2014-11-19 at 00:14 +0100, Felix Fietkau wrote:
> 
>> +	struct txq_info *txq;
>> +	atomic_t txq_len[IEEE80211_NUM_ACS];
> 
> I think you should consider renaming the latter to txqs_len or so - it
> doesn't just cover one txq as is be implied by the name now. Otherwise
> the skb_queue_head also maintains the length anyway, but I think you
> need the aggregate for all stations here...
> 
> Some documentation for this and the vif.txq would be good too :)
> 
> In fact - it might be worthwhile to take parts of the commit message and
> elaborate a bit on it and write a whole DOC: section?
Yeah, makes sense.

>> --- a/net/mac80211/sta_info.h
>> +++ b/net/mac80211/sta_info.h
>> @@ -371,6 +371,7 @@ struct sta_info {
>>  	struct sk_buff_head ps_tx_buf[IEEE80211_NUM_ACS];
>>  	struct sk_buff_head tx_filtered[IEEE80211_NUM_ACS];
>>  	unsigned long driver_buffered_tids;
>> +	void *txq;
> 
> You can still use struct txq_info * here even when it's not declared yet
> (since it's in the other header file)
OK.

>> +static void ieee80211_drv_tx(struct ieee80211_local *local,
>> +			     struct ieee80211_vif *vif,
>> +			     struct ieee80211_sta *pubsta,
>> +			     struct sk_buff *skb)
>> +{
>> +	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
>> +	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
>> +	struct ieee80211_tx_control control = {
>> +		.sta = pubsta
>> +	};
>> +	struct ieee80211_txq *pubtxq = NULL;
>> +	struct txq_info *txq;
>> +	u8 ac;
>> +
>> +	if (ieee80211_is_mgmt(hdr->frame_control) ||
>> +	    ieee80211_is_ctl(hdr->frame_control))
>> +		goto tx_normal;
>> +
>> +	if (pubsta) {
>> +		u8 tid = skb->priority & IEEE80211_QOS_CTL_TID_MASK;
>> +		pubtxq = pubsta->txq[tid];
>> +	} else {
>> +		pubtxq = vif->txq;
>> +	}
> 
> This is a bit confusing - isn't this the same as &sdata->txq.txq?
Right, I should probably use that.

> Then
> again what even sets vif->txq? Shouldn't those be per-AC? Do you really
> want to mix 'normal' and txq-TX?
Are we even using multiple ACs for packets that don't belong to a
particular sta? I thought normal mcast data frames only use non-QoS
frames. And yes, I'm currently mixing normal and txq-TX to prioritize
ctl/mgmt frames over other less important traffic.

> I think you should also use txqi as variables for txq_info - it gets
> cumbersome to distinguish the two everywhere.
Will do.

> Also in many cases where you have txq allocation failures you just
> continue as is, I'm not sure that's such a great idea. Those driver
> paths will practically never get tested.
It will just do normal tx in that case, which should work.

>> +	if (!pubtxq)
>> +		goto tx_normal;
>> +
>> +	ac = pubtxq->ac;
>> +	txq = container_of(pubtxq, struct txq_info, txq);
>> +	atomic_inc(&sdata->txq_len[ac]);
>> +	if (atomic_read(&sdata->txq_len[ac]) >= local->hw.txq_ac_max_pending)
>> +		netif_stop_subqueue(sdata->dev, ac);
>> +
>> +	skb_queue_tail(&txq->queue, skb);
>> +	drv_wake_tx_queue(local, txq);
> 
> You might consider doing locking differently here - I think you probably
> don't need the txq->queue spinlock at all since you're in per-AC and
> mappings are static. Not sure how that interacts with other parts of the
> code though.
I wanted to use the lock to give the driver the freedom to call
ieee80211_tx_dequeue from outside of normal per-AC tx context.

>> +int ieee80211_tx_dequeue(struct ieee80211_hw *hw, struct ieee80211_txq *pubtxq,
>> +			 struct sk_buff **dest)
> 
> I'd prefer you return the skb and use ERR_PTR() for errors.
Will do

>> +void ieee80211_init_tx_queue(struct ieee80211_sub_if_data *sdata,
>> +			     struct sta_info *sta,
>> +			     struct txq_info *txq, int tid)
>> +{
>> +	skb_queue_head_init(&txq->queue);
>> +	txq->txq.vif = &sdata->vif;
>> +
>> +	if (sta) {
>> +		txq->txq.sta = &sta->sta;
>> +		sta->sta.txq[tid] = &txq->txq;
>> +		txq->txq.ac = ieee802_1d_to_ac[tid & 7];
>> +	} else {
>> +		sdata->vif.txq = &txq->txq;
>> +		txq->txq.ac = IEEE80211_AC_BE;
>> +	}
> 
> Again, I don't quite understand the single AC queue here per vif. It
> seems it should be one for each AC and possibly one for cab? Or none at
> all - I don't really see what this single one would be used for, in the
> TX code you seem to use it for mcast data only but then I don't really
> see the point. It's also not part of the queue length accounting.
I handle CAB through normal mac80211 mcast buffering.

>> +void ieee80211_flush_tx_queue(struct ieee80211_local *local,
>> +			      struct ieee80211_txq *pubtxq)
>> +{
>> +	struct txq_info *txq = container_of(pubtxq, struct txq_info, txq);
>> +	struct ieee80211_sub_if_data *sdata = vif_to_sdata(pubtxq->vif);
>> +	struct sk_buff *skb;
>> +
>> +	while ((skb = skb_dequeue(&txq->queue)) != NULL) {
>> +		atomic_dec(&sdata->txq_len[pubtxq->ac]);
>> +		ieee80211_free_txskb(&local->hw, skb);
>> +	}
>> +}
> 
> You can rewrite this a bit smarter to just do one atomic op.
Will do.

- Felix
