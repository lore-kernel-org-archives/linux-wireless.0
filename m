Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:40718 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932187AbeEWJqD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 23 May 2018 05:46:03 -0400
Message-ID: <1527068760.3759.13.camel@sipsolutions.net> (sfid-20180523_114627_733570_BF411050)
Subject: Re: [RFC] mac80211: add stop/start logic for software TXQs
From: Johannes Berg <johannes@sipsolutions.net>
To: Manikanta Pubbisetty <mpubbise@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>
Date: Wed, 23 May 2018 11:46:00 +0200
In-Reply-To: <1526672192-3873-1-git-send-email-mpubbise@codeaurora.org>
References: <1526672192-3873-1-git-send-email-mpubbise@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2018-05-19 at 01:06 +0530, Manikanta Pubbisetty wrote:
> Sometimes, it is required to stop the transmissions momentarily and
> resume it later; stopping the txqs becomes very critical in scenarios where
> the packet transmission has to be ceased completely. For example, during
> the hardware restart, during off channel operations,
> when initiating CSA(upon detecting a radar on the DFS channel), etc.
> 
> The TX queue stop/start logic in mac80211 works well in stopping the TX
> when drivers make use of netdev queues, i.e, when Qdiscs in network layer
> take care of traffic scheduling. Since the devices implementing
> wake_tx_queue run without Qdiscs, packets will be handed to mac80211
> directly without queueing them in the netdev queues. Also, mac80211
> does not invoke any of the netif_stop_*/netif_wake_* APIs to stop the
> transmissions and this might very well lead to undesirabled things.

I was ready to say the drivers can handle this ;-)

> For example,
> During hardware restart, we stop the netdev queues so that packets are
> not sent to the driver. Since ath10k implements wake_tx_queue,
> TX queues will not be stopped and packets might reach the hardware while
> it is restarting; this can make hardware unresponsive and can be
> recovered only by rebooting the system.

But yeah, you do have a point here.

> There is another problem to this, it is observed that the packets
> were sent on the DFS channel for a prolonged duration after radar detection
> impacting the channel closing times.

Makes sense.

> We can still invoke netif stop/wake APIs when wake_tx_queue is implemented
> but this could lead to packet drops in network layer; adding stop/start
> logic for software TXQs in mac80211 instead makes more sense; the change
> proposed adds the same in mac80211.

Agree, that seems to make sense.

> +++ b/net/mac80211/agg-tx.c
> @@ -213,11 +213,15 @@ static void
>  ieee80211_agg_start_txq(struct sta_info *sta, int tid, bool enable)
>  {
>  	struct ieee80211_txq *txq = sta->sta.txq[tid];
> +	struct ieee80211_local *local = sta->local;
>  	struct txq_info *txqi;
>  
>  	if (!txq)
>  		return;
>  
> +	if (local->txqs_stopped)
> +		return;
> +
>  	txqi = to_txq_info(txq);

This doesn't seem right, all the logic that clears the TXQ_STOP etc.
still needs to be invoked, otherwise your TXQ will get stuck completely
since you'll never run this code again.

> +	/* pause/resume logic for intermediate software queues,
> +	 * applicable when wake_tx_queue is defined.
> +	 */
> +	unsigned long txqs_stopped;

bool? at least you don't seem to treat it like a bitmap which unsigned
long seems to imply.

> +++ b/net/mac80211/sta_info.c
> @@ -1244,6 +1244,9 @@ void ieee80211_sta_ps_deliver_wakeup(struct sta_info *sta)
>  			if (!txq_has_queue(sta->sta.txq[i]))
>  				continue;
>  
> +			if (local->txqs_stopped)
> +				continue;
> +
>  			drv_wake_tx_queue(local, to_txq_info(sta->sta.txq[i]));
>  		}

That seems like it's in an odd place, why bother going through all the
logic first?

Also, you have the same problem as above - you never re-run this code so
 you'd get stuck completely.

> +++ b/net/mac80211/tx.c
> @@ -1559,6 +1559,9 @@ static bool ieee80211_queue_skb(struct ieee80211_local *local,
>  	    sdata->vif.type == NL80211_IFTYPE_MONITOR)
>  		return false;
>  
> +	if (local->txqs_stopped)
> +		return false;
> +
>  	if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
>  		sdata = container_of(sdata->bss,
>  				     struct ieee80211_sub_if_data, u.ap);

That also seems too early.

> diff --git a/net/mac80211/util.c b/net/mac80211/util.c
> index 2d82c88..da7ae8b 100644
> --- a/net/mac80211/util.c
> +++ b/net/mac80211/util.c
> @@ -298,6 +298,9 @@ static void __ieee80211_wake_queue(struct ieee80211_hw *hw, int queue,
>  	if (local->q_stop_reasons[queue][reason] == 0)
>  		__clear_bit(reason, &local->queue_stop_reasons[queue]);
>  
> +	if (local->ops->wake_tx_queue)
> +		__clear_bit(reason, &local->txqs_stopped);

Ah, never mind, you do use it as a bitmap.

But I think your approach is wrong, somehow you have to make sure you
restart.

Perhaps a good approach would be to have a check when the driver pulls
an SKB, and then record the queue it was pulled. Then, when the stop
bitmap goes to 0, you can drv_wake_tx_queue() all the queues that were
marked as "pulled while stopped" to recover.

johannes
