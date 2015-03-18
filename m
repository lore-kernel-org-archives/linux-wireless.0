Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:34729 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751564AbbCRUDQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Mar 2015 16:03:16 -0400
Message-ID: <5509DA00.6030002@openwrt.org> (sfid-20150318_210319_896224_EC523BD3)
Date: Wed, 18 Mar 2015 21:03:12 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v4] mac80211: add an intermediate software queue implementation
References: <1426609283-83954-1-git-send-email-nbd@openwrt.org> <1426707672.3001.39.camel@sipsolutions.net>
In-Reply-To: <1426707672.3001.39.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2015-03-18 20:41, Johannes Berg wrote:
>> + * The driver is expected to release its own buffered frames and also call
>> + * ieee80211_tx_dequeue() within that callback.
> 
> Perhaps that should read
> "The driver is expected to release its own buffered frames (if any) and
> request the remaining dequeued frames by calling
> ieee80211_tx_dequeue()."
> 
> I'm not really sure it needs to be within that callback? I see no
> particular reason for that.
Releasing multiple packets works, even if there is only one packet
buffered in the driver and the rest in the txq. It also keeps the code
more consistent.
Now that I'm thinking about this some more, it might even make sense to
skip the sta PS queue for txq-enabled drivers. That would allow all sta
data frames to either go through driver scheduling or
release_buffered_frames.

>> + * @tid: the TID for this queue (unused for per-vif queue)
>> + * @ac: the AC for this queue
> 
> AC is also unused for per-vif I guess?
It's set to BE for per-vif to allow the driver to use it to pick the
right tx queue.

>> +++ b/net/mac80211/agg-tx.c
>> @@ -188,6 +188,41 @@ ieee80211_wake_queue_agg(struct ieee80211_sub_if_data *sdata, int tid)
>>  	__release(agg_queue);
>>  }
>>  
>> +static void
>> +ieee80211_agg_stop_txq(struct sta_info *sta, int tid)
>> +{
>> +	struct ieee80211_txq *txq = sta->sta.txq[tid];
>> +	struct txq_info *txqi;
>> +
>> +	if (!txq)
>> +		return;
>> +
>> +	txqi = to_txq_info(txq);
>> +	spin_lock_bh(&txqi->queue.lock);
>> +	set_bit(IEEE80211_TXQ_STOP, &txqi->flags);
>> +	spin_unlock_bh(&txqi->queue.lock);
> 
> What's the point in locking here?
If I don't lock here, one last dequeue call might still be running on
another CPU. This would produce a theoretical race in accessing the
sequence number, which the caller of this function reads before setting
up the BA request.
Dequeueing happens outside of the normal network stack tx context, so
synchronize_net is not enough.

>> +static void
>> +ieee80211_agg_start_txq(struct sta_info *sta, int tid, bool enable)
>> +{
>> +	struct ieee80211_txq *txq = sta->sta.txq[tid];
>> +	struct txq_info *txqi;
>> +
>> +	if (!txq)
>> +		return;
>> +
>> +	txqi = to_txq_info(txq);
>> +
>> +	if (enable)
>> +		set_bit(IEEE80211_TXQ_AMPDU, &txqi->flags);
>> +	else
>> +		clear_bit(IEEE80211_TXQ_AMPDU, &txqi->flags);
>> +
>> +	clear_bit(IEEE80211_TXQ_STOP, &txqi->flags);
> 
> here you don't either
Here only the order of changing IEEE80211_TXQ_AMPDU vs clearing
IEEE80211_TXQ_STOP matters.

- Felix
