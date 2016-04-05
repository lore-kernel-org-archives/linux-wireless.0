Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:55407 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933019AbcDEN5n (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Apr 2016 09:57:43 -0400
Message-ID: <1459864656.18188.60.camel@sipsolutions.net> (sfid-20160405_155746_800354_8163DAA6)
Subject: Re: [PATCHv2 1/2] mac80211: implement fair queuing per txq
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>,
	linux-wireless@vger.kernel.org
Cc: dave.taht@gmail.com, make-wifi-fast@lists.bufferbloat.net,
	codel@lists.bufferbloat.net
Date: Tue, 05 Apr 2016 15:57:36 +0200
In-Reply-To: <1459420104-31554-2-git-send-email-michal.kazior@tieto.com> (sfid-20160331_122620_554927_0C80DD6C)
References: <1458898052-20601-1-git-send-email-michal.kazior@tieto.com>
	 <1459420104-31554-1-git-send-email-michal.kazior@tieto.com>
	 <1459420104-31554-2-git-send-email-michal.kazior@tieto.com>
	 (sfid-20160331_122620_554927_0C80DD6C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2016-03-31 at 12:28 +0200, Michal Kazior wrote:

> +++ b/net/mac80211/codel.h
> +++ b/net/mac80211/codel_i.h

Do we really need all this code in .h files? It seems very odd to me to
have all the algorithm implementation there rather than a C file, you
should (can?) only include codel.h into a single C file anyway.

>  struct txq_info {
> -	struct sk_buff_head queue;
> +	struct txq_flow flow;
> +	struct list_head new_flows;
> +	struct list_head old_flows;

This is confusing, can you please document that? Why are there two
lists of flows, *and* an embedded flow? Is the embedded flow on any of
the lists?

> +	u32 backlog_bytes;
> +	u32 backlog_packets;
> +	u32 drop_codel;

Would it make some sense to at least conceptually layer this a bit?
I.e. rather than calling this "drop_codel" call it "drop_congestion" or
something like that?

> @@ -977,12 +978,9 @@ static void ieee80211_do_stop(struct
> ieee80211_sub_if_data *sdata,
>  	if (sdata->vif.txq) {
>  		struct txq_info *txqi = to_txq_info(sdata->vif.txq);
>  
> -		spin_lock_bh(&txqi->queue.lock);
> -		ieee80211_purge_tx_queue(&local->hw, &txqi->queue);
> -		txqi->byte_cnt = 0;
> -		spin_unlock_bh(&txqi->queue.lock);
> -
> -		atomic_set(&sdata->txqs_len[txqi->txq.ac], 0);
> +		spin_lock_bh(&fq->lock);
> +		ieee80211_purge_txq(local, txqi);
> +		spin_unlock_bh(&fq->lock);

This isn't very nice - you're going from locking a single txqi to
having a global hardware lock.

It's probably fine in this particular case, but I'll need to look for
other places :)

> +/**
> + * struct txq_flow - per traffic flow queue
> + *
> + * This structure is used to distinguish and queue different traffic flows
> + * separately for fair queueing/AQM purposes.
> + *
> + * @txqi: txq_info structure it is associated at given time

Do we actually have to keep that? It's on a list per txqi, no?

> + * @flowchain: can be linked to other flows for RR purposes

RR?

> +void ieee80211_teardown_flows(struct ieee80211_local *local)
> +{
> +	struct ieee80211_fq *fq = &local->fq;
> +	struct ieee80211_sub_if_data *sdata;
> +	struct sta_info *sta;
> +	int i;
> +
> +	if (!local->ops->wake_tx_queue)
> +		return;
> +
> +	list_for_each_entry_rcu(sta, &local->sta_list, list)
> +		for (i = 0; i < IEEE80211_NUM_TIDS; i++)
> +			ieee80211_purge_txq(local,
> +					    to_txq_info(sta->sta.txq[i]));
> +
> +	list_for_each_entry_rcu(sdata, &local->interfaces, list)
> +		ieee80211_purge_txq(local, to_txq_info(sdata->vif.txq));

Using RCU iteration here seems rather strange, since it's a teardown
flow? That doesn't seem necessary, since it's control path and must be
holding appropriate locks anyway to make sure nothing is added to the
lists.

> +	skb = codel_dequeue(flow,
> +			    &flow->backlog,
> +			    0,
> +			    &flow->cvars,
> +			    &fq->cparams,
> +			    codel_get_time(),
> +			    false);

What happened here? :)

> +	if (!skb) {
> +		if ((head == &txqi->new_flows) &&
> +		    !list_empty(&txqi->old_flows)) {
> +			list_move_tail(&flow->flowchain, &txqi->old_flows);
> +		} else {
> +			list_del_init(&flow->flowchain);
> +			flow->txqi = NULL;
> +		}
> +		goto begin;
> +	}

Ouch. Any way you can make that easier to follow?

johannes
