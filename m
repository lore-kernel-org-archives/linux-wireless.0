Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.tohojo.dk ([77.235.48.147]:57463 "EHLO mail2.tohojo.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751478AbcFSIwW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Jun 2016 04:52:22 -0400
From: =?utf-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Tim Shepard <shep@alum.mit.edu>
Cc: linux-wireless@vger.kernel.org,
	make-wifi-fast@lists.bufferbloat.net, ath9k-devel@lists.ath9k.org,
	Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH] ath9k: Switch to using mac80211 intermediate software
	queues.
References: <E1bETEY-0000BM-00@www.xplot.org>
Date: Sun, 19 Jun 2016 10:52:16 +0200
In-Reply-To: <E1bETEY-0000BM-00@www.xplot.org> (Tim Shepard's message of "Sat,
	18 Jun 2016 23:17:13 -0400")
Message-ID: <87k2hlsgqn.fsf@toke.dk> (sfid-20160619_105227_467136_1EDC5111)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tim Shepard <shep@alum.mit.edu> writes:

>> +static struct sk_buff *
>> +ath_tid_pull(struct ath_atx_tid *tid)
>> +{
>> +	struct ath_softc *sc = tid->an->sc;
>> +	struct ieee80211_hw *hw = sc->hw;
>> +	struct ath_tx_control txctl = {
>> +		.txq = tid->txq,
>> +		.sta = tid->an->sta,
>> +	};
>> +	struct sk_buff *skb;
>> +	struct ath_frame_info *fi;
>> +	int q;
>> +
>> +	if (!tid->has_queued)
>> +		return NULL;
>> +
>> +	skb = ieee80211_tx_dequeue(hw, container_of((void*)tid, struct ieee80211_txq, drv_priv));
>> +	if (!skb) {
>> +		tid->has_queued = false;
>> +		return NULL;
>> +	}
>> +
>> +	if (ath_tx_prepare(hw, skb, &txctl)) {
>> +		ieee80211_free_txskb(hw, skb);
>> +		return NULL;
>> +	}
>> +
>> +	q = skb_get_queue_mapping(skb);
>> +	if (tid->txq == sc->tx.txq_map[q]) {
>> +		fi = get_frame_info(skb);
>> +		fi->txq = q;
>> +		++tid->txq->pending_frames;
>> +	}
>> +
>> +	return skb;
>> + }
>> +
>> +
>
> The increment of ->pending_frames lacks a corresponding check against
> sc->tx.txq_max_pending to see if we've reached the limit.  (Which begs
> the question: what to do if it has?)
>
> I discovered this bug doing experiments by trying to turn down the
> various /sys/kernel/debug/ieee80211/phy0/ath9k/qlen_* to low numbers
> (including as low as one, and then even zero) and found it had no
> effect.

You're right that it doesn't check the max. However, this is less of a
problem now that there is no intermediate queueing in the driver; and
indeed the utility of haven the qlen_* tunables is somewhat questionable
with the patch applied: The only thing this is going to control is the
size of the retry queue, and possible limit the size of the retry queue.
The actual queueing is happening in the mac80211 layer, which these
tunables can't control (and which is not FQ-CoDel controlled in
mac80211-next). So it might actually be that simply removing the
tunables is the right thing to do with this patch.

Removing the limits would also probably mean getting rid of txq->stopped
and the calls to ieee80211_wake_queue() and ieee80211_stop_queue().
I suspect that is fine when using the mac80211 intermediate queues, but
I'm not sure.

Felix, care to comment? :)

> The second more mysterious bug which I'm still struggling to
> understand is why doesn't large values in these ath9k/qlen_* (or more
> accurately, given the first bug above, the failure to check these qlen
> limit values at all) allow for increased hardware queue bloat (with
> observable delay).

Because there's a second limit in play (which has always been there): in
ath_tx_sched_aggr() there is this check:

	if ((aggr && txq->axq_ampdu_depth >= ATH_AGGR_MIN_QDEPTH) ||
	    (!aggr && txq->axq_depth >= ATH_NON_AGGR_MIN_QDEPTH)) {
		__skb_queue_tail(&tid->retry_q, bf->bf_mpdu);
		*stop = true;
		return false;
	}

The two constants are 2 and 8 respectively. This means that, with
aggregation enabled, no more than two full aggregates will be queued up.
The size of the aggregates is dynamically computed from the current
rate: they are limited a maximum of four milliseconds of (estimated)
airtime (for the BE queue; the others have different limits).

So in a sense there's already a dynamic limit on the hardware queues.
Now, whether four milliseconds is the right maximum aggregate size might
be worth discussing. It is the maximum allowed by the standard. Dave and
I have been 

-Toke
