Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:60263 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535AbZC1Ezi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Mar 2009 00:55:38 -0400
Date: Sat, 28 Mar 2009 00:55:29 -0400
From: "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: Re: [PATCH 7/8] mac80211: fix aggregation to not require queue stop
Message-ID: <20090328045529.GF5543@bombadil.infradead.org> (sfid-20090328_055541_275246_A61BE1FE)
References: <20090323162834.154525349@sipsolutions.net> <20090323163053.344441542@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090323163053.344441542@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 23, 2009 at 05:28:41PM +0100, Johannes Berg wrote:
> Instead of stopping the entire AC queue when enabling aggregation
> (which was only done for hardware with aggregation queues) buffer
> the packets for each station, and release them to the pending skb
> queue once aggregation is turned on successfully.

Thank you for the nice compromised solution.

> We get a little more code, but it becomes conceptually simpler and
> we can remove the entire virtual queue mechanism from mac80211 in
> a follow-up patch.
> 
> This changes how mac80211 behaves towards drivers that support
> aggregation but have no hardware queues -- those drivers will now
> not be handed packets while the aggregation session is being
> established, but only after it has been fully established.

That's fine from a logical point of view as compromise here as our
ampdu start should be relatively quick. Now while I can say this
from a logical point of view this patch obviously needed more
testing but lets see how it holds up and I'm glad you're the one
who wrote it. I'm confident there won't be any issues but that
is something I cannot gaurantee just based on the review. We now
need to go out and tests this. All other patches previous to this
make 100% perfect sense.

I'm particularly interested in seeing results with AP support.
Did you get to test that with ath9k by any chance?

Hauke -- just a heads up since you're quick with this now :)  :
skb_queue_splice_tail_init() needs some backporting to 2.6.27. I'd do
it but I'm beat and calling it a day now.

More comments below. I've tried to remove all the hunks I didn't have
comments on.

> @@ -308,21 +296,19 @@ int ieee80211_start_tx_ba_session(struct
>  			ret = -ENOSPC;
>  			goto err_unlock_sta;
>  		}
> -
> -		/*
> -		 * If we successfully allocate the session, we can't have
> -		 * anything going on on the queue this TID maps into, so
> -		 * stop it for now. This is a "virtual" stop using the same
> -		 * mechanism that drivers will use.
> -		 *
> -		 * XXX: queue up frames for this session in the sta_info
> -		 *	struct instead to avoid hitting all other STAs.
> -		 */
> -		ieee80211_stop_queue_by_reason(
> -			&local->hw, hw->queues + qn,
> -			IEEE80211_QUEUE_STOP_REASON_AGGREGATION);
>  	}
>  
> +	/*
> +	 * While we're asking the driver about the aggregation,
> +	 * stop the AC queue so that we don't have to worry
> +	 * about frames that came in while we were doing that,
> +	 * which would require us to put them to the AC pending
> +	 * afterwards which just makes the code more complex.
> +	 */
> +	ieee80211_stop_queue_by_reason(
> +		&local->hw, ieee80211_ac_from_tid(tid),
> +		IEEE80211_QUEUE_STOP_REASON_AGGREGATION);
> +

ath9k's ampdu start is pretty quick anyway, so this
won't be for long.

> @@ -404,6 +399,45 @@ int ieee80211_start_tx_ba_session(struct
>  }
>  EXPORT_SYMBOL(ieee80211_start_tx_ba_session);
>  
> +/*
> + * splice packets from the STA's pending to the local pending,
> + * requires a call to ieee80211_agg_splice_finish and holding
> + * local->ampdu_lock across both calls.
> + */
> +static void ieee80211_agg_splice_packets(struct ieee80211_local *local,
> +					 struct sta_info *sta, u16 tid)
> +{
> +	unsigned long flags;
> +	u16 queue = ieee80211_ac_from_tid(tid);
> +
> +	ieee80211_stop_queue_by_reason(
> +		&local->hw, queue,
> +		IEEE80211_QUEUE_STOP_REASON_AGGREGATION);

No point in stopping the queue if the STA's tid queue is empty.

> @@ -602,22 +637,19 @@ void ieee80211_stop_tx_ba_cb(struct ieee
>  			WLAN_BACK_INITIATOR, WLAN_REASON_QSTA_NOT_USE);
>  
>  	spin_lock_bh(&sta->lock);
> +	spin_lock(&local->ampdu_lock);
>  
> -	if (*state & HT_AGG_STATE_INITIATOR_MSK &&
> -	    hw->ampdu_queues) {
> -		/*
> -		 * Wake up this queue, we stopped it earlier,
> -		 * this will in turn wake the entire AC.
> -		 */
> -		ieee80211_wake_queue_by_reason(hw,
> -			hw->queues + sta->tid_to_tx_q[tid],
> -			IEEE80211_QUEUE_STOP_REASON_AGGREGATION);
> -	}
> +	ieee80211_agg_splice_packets(local, sta, tid);

Is it possible for ieee80211_stop_tx_ba_cb() to be called while
state of the tid is not yet operational? from what I can tell
that's the only case when we would have added skbs to the STA's tid
pending queue.

>  
>  	*state = HT_AGG_STATE_IDLE;
> +	/* from now on packets are no longer put onto sta->pending */

I think it would help to refer to the pendign queue consitantly instead
as something like "STA's TID pending queue" as that is what it is. We also
now have the local->pending queue. STA's pending queue seems to imply
its also used for non-aggregation sessions.

See -- if the state is not operation nothing would have gone
been put into the STA's tid pending queue. Might also be worth
mentioning that in the comment.

> @@ -1013,20 +1013,53 @@ __ieee80211_tx_prepare(struct ieee80211_
>  		 */
>  	}
>  
> +	/*
> +	 * If this flag is set to true anywhere, and we get here,
> +	 * we are doing the needed processing, so remove the flag
> +	 * now.
> +	 */
> +	info->flags &= ~IEEE80211_TX_INTFL_NEED_TXPROCESSING;
> +
>  	hdr = (struct ieee80211_hdr *) skb->data;
>  
>  	tx->sta = sta_info_get(local, hdr->addr1);
>  
> -	if (tx->sta && ieee80211_is_data_qos(hdr->frame_control)) {
> +	if (tx->sta && ieee80211_is_data_qos(hdr->frame_control) &&
> +	    (local->hw.flags & IEEE80211_HW_AMPDU_AGGREGATION)) {

Hm, why were we not crashing here before? I figure we would have
with something like this:

state = &tx->sta->ampdu_mlme.tid_state_tx[tid];

That it itself should be separate patch, but too late now. Anyway
the new added check for IEEE80211_HW_AMPDU_AGGREGATION should go
to stable.

>  		unsigned long flags;
> +		struct tid_ampdu_tx *tid_tx;
> +
>  		qc = ieee80211_get_qos_ctl(hdr);
>  		tid = *qc & IEEE80211_QOS_CTL_TID_MASK;
>  
>  		spin_lock_irqsave(&tx->sta->lock, flags);
> +		/*
> +		 * XXX: This spinlock could be fairly expensive, but see the
> +		 *	comment in agg-tx.c:ieee80211_agg_tx_operational().
> +		 *	One way to solve this would be to do something RCU-like
> +		 *	for managing the tid_tx struct and using atomic bitops
> +		 *	for the actual state -- by introducing an actual
> +		 *	'operational' bit that would be possible. It would
> +		 *	require changing ieee80211_agg_tx_operational() to
> +		 *	set that bit, and changing the way tid_tx is managed
> +		 *	everywhere, including races between that bit and
> +		 *	tid_tx going away (tid_tx being added can be easily
> +		 *	committed to memory before the 'operational' bit).
> +		 */
> +		tid_tx = tx->sta->ampdu_mlme.tid_tx[tid];
>  		state = &tx->sta->ampdu_mlme.tid_state_tx[tid];
> -		if (*state == HT_AGG_STATE_OPERATIONAL)
> +		if (*state == HT_AGG_STATE_OPERATIONAL) {
>  			info->flags |= IEEE80211_TX_CTL_AMPDU;

See, when its operational we don't add stuff to the STA's TID pending 
queue.

This piece:

> +		} else if (*state != HT_AGG_STATE_IDLE) {
> +			/* in progress */
> +			queued = true;
> +			info->flags |= IEEE80211_TX_INTFL_NEED_TXPROCESSING;
> +			__skb_queue_tail(&tid_tx->pending, skb);
> +		}

Can probably be ported to stable too, to just TX_DROP.

> @@ -1251,7 +1295,12 @@ static int ieee80211_tx(struct net_devic
>  			do {
>  				next = skb->next;
>  				skb->next = NULL;
> -				skb_queue_tail(&local->pending[queue], skb);
> +				if (unlikely(txpending))
> +					skb_queue_head(&local->pending[queue],
> +						       skb);
> +				else
> +					skb_queue_tail(&local->pending[queue],
> +						       skb);

For someone who hasn't read all the pending queue code stuff the above would be
a little brain twister. It might be good to leave a comment explaining why
txpendign would be set and why we add it to the head (i.e. because the "skb" sent
at a previous time was put into a pending queue). Maybe even rename txpending to
something like skb_was_pending.

> @@ -1360,7 +1407,7 @@ int ieee80211_master_start_xmit(struct s
>  		       "originating device\n", dev->name);
>  #endif
>  		dev_kfree_skb(skb);
> -		return 0;
> +		return NETDEV_TX_OK;

All these NETDEV_TX_OK could've gone into a separate patch.

  Luis
