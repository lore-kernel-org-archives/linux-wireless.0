Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33919 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750756AbbCRTlT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Mar 2015 15:41:19 -0400
Message-ID: <1426707672.3001.39.camel@sipsolutions.net> (sfid-20150318_204123_529555_5FD7F6AF)
Subject: Re: [PATCH v4] mac80211: add an intermediate software queue
 implementation
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 18 Mar 2015 20:41:12 +0100
In-Reply-To: <1426609283-83954-1-git-send-email-nbd@openwrt.org>
References: <1426609283-83954-1-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> + * For AP powersave TIM handling, the driver only needs to indicate if it has
> + * buffered packets in the driver specific data structures by calling
> + * ieee80211_sta_set_buffered(). For frames buffered in the ieee80211_txq
> + * struct, mac80211 sets TIM and calls .release_buffered_frames().

could perhaps be elaborated to

[...] mac80211 sets the appropriate TIM PVB bits and calls [...]

but I don't really care

> + * The driver is expected to release its own buffered frames and also call
> + * ieee80211_tx_dequeue() within that callback.

Perhaps that should read
"The driver is expected to release its own buffered frames (if any) and
request the remaining dequeued frames by calling
ieee80211_tx_dequeue()."

I'm not really sure it needs to be within that callback? I see no
particular reason for that.

>  /**
> + * struct ieee80211_txq - Software intermediate tx queue
> + *
> + * @vif: &struct ieee80211_vif pointer from the add_interface callback.
> + * @sta: station table entry, may be NULL for per-vif queue

well, "may be" is a bit of an understatement ;-)

just say "%NULL for per-vif queue"?

(%NULL just causes different formatting in kernel-doc)

> + * @tid: the TID for this queue (unused for per-vif queue)
> + * @ac: the AC for this queue

AC is also unused for per-vif I guess?


> +/**
> + * ieee80211_tx_dequeue - dequeue a packet from a software tx queue
> + *
> + * @hw: pointer as obtained from ieee80211_alloc_hw()
> + * @txq: pointer obtained from .add_tx_queue() call
> + *
> + * Returns the skb if successful, NULL if no frame was available.

Perhaps also use %NULL here. Not really important though.

> +++ b/net/mac80211/agg-tx.c
> @@ -188,6 +188,41 @@ ieee80211_wake_queue_agg(struct ieee80211_sub_if_data *sdata, int tid)
>  	__release(agg_queue);
>  }
>  
> +static void
> +ieee80211_agg_stop_txq(struct sta_info *sta, int tid)
> +{
> +	struct ieee80211_txq *txq = sta->sta.txq[tid];
> +	struct txq_info *txqi;
> +
> +	if (!txq)
> +		return;
> +
> +	txqi = to_txq_info(txq);
> +	spin_lock_bh(&txqi->queue.lock);
> +	set_bit(IEEE80211_TXQ_STOP, &txqi->flags);
> +	spin_unlock_bh(&txqi->queue.lock);

What's the point in locking here?

> +static void
> +ieee80211_agg_start_txq(struct sta_info *sta, int tid, bool enable)
> +{
> +	struct ieee80211_txq *txq = sta->sta.txq[tid];
> +	struct txq_info *txqi;
> +
> +	if (!txq)
> +		return;
> +
> +	txqi = to_txq_info(txq);
> +
> +	if (enable)
> +		set_bit(IEEE80211_TXQ_AMPDU, &txqi->flags);
> +	else
> +		clear_bit(IEEE80211_TXQ_AMPDU, &txqi->flags);
> +
> +	clear_bit(IEEE80211_TXQ_STOP, &txqi->flags);

here you don't either

> +		for (i = 0; i < ARRAY_SIZE(sta->sta.txq); i++) {
> +			struct txq_info *txq = txq_data + i * size;
> +			ieee80211_init_tx_queue(sdata, sta, txq, i);

I'd prefer you left a blank line after the declaration

> +	if (pubsta) {
> +		u8 tid = skb->priority & IEEE80211_QOS_CTL_TID_MASK;
> +		txq = pubsta->txq[tid];

same here

> +	} else if (vif) {
> +		txq = vif->txq;
> +	}
> +
> +	if (!txq)
> +		goto tx_normal;
> +
> +	ac = txq->ac;
> +	txqi = container_of(txq, struct txq_info, txq);

to_txq_info()?

> +struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
> +				     struct ieee80211_txq *txq)
> +{
> +	struct ieee80211_local *local = hw_to_local(hw);
> +	struct ieee80211_sub_if_data *sdata = vif_to_sdata(txq->vif);
> +	struct txq_info *txqi = container_of(txq, struct txq_info, txq);
> +	struct ieee80211_hdr *hdr;
> +	struct sk_buff *skb = NULL;
> +	u8 ac = txq->ac;
> +
> +	spin_lock_bh(&txqi->queue.lock);
> +
> +	if (test_bit(IEEE80211_TXQ_STOP, &txqi->flags))
> +		goto out;

I don't really see much point in this locking scheme.

Fundamentally, one of the places will win if they execute concurrently,
and then it doesn't matter whether you're already past the stop check or
not, so I think you can just do that unlocked, and leave just the
dequeue itself locked?

> +void ieee80211_flush_tx_queue(struct ieee80211_local *local,
> +			      struct ieee80211_txq *txq)

I think you should consider renaming this, it doesn't really flush
anything out, it just frees the packets.

johannes

