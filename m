Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:58802 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933725AbdJQHH3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 17 Oct 2017 03:07:29 -0400
Message-ID: <1508224046.10607.67.camel@sipsolutions.net> (sfid-20171017_090733_203568_4931749D)
Subject: Re: [PATCH 2/2] mac80211: Add airtime accounting and scheduling to
 TXQs
From: Johannes Berg <johannes@sipsolutions.net>
To: Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org
Date: Tue, 17 Oct 2017 09:07:26 +0200
In-Reply-To: <20171016160902.8970-2-toke@toke.dk> (sfid-20171016_180933_942626_9939A5C5)
References: <20171016160902.8970-1-toke@toke.dk>
         <20171016160902.8970-2-toke@toke.dk> (sfid-20171016_180933_942626_9939A5C5)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Only ath9k currently sets the AIRTIME_ACCOUNTING flag.

I think you should actually make that a separate patch.

In the previous patch that's not possible or it breaks things, but this
patch just adds a new feature that drivers _may_ use, they don't have
to since it doesn't change the API, so you should split the patches.

[snip ath9k, I don't really know anything about it]

> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -1202,6 +1202,7 @@ struct ieee80211_rx_status {
>  	u32 device_timestamp;
>  	u32 ampdu_reference;
>  	u32 flag;
> +	u16 rx_time;

I'd prefer this were called "airtime" or such, and you clearly need to
add documentation regarding this field. In particular, you should point
to the IEEE80211_HW_AIRTIME_ACCOUNTING hw flag, and document what
should be taken into account here (preamble length, IFS, rts/cts/ack,
etc.?) and additionally how this should be handled wrt. A-MPDU (and A-
MSDU where decapsulated by the device.)

For aggregation, either form, I expect you just want to see 0 for all
but the very first frame? but that may be very difficult for some
drivers to implement.

> +++ b/net/mac80211/rx.c
> @@ -1637,6 +1637,15 @@ ieee80211_rx_h_sta_process(struct
> ieee80211_rx_data *rx)
>  	if (ieee80211_vif_is_mesh(&rx->sdata->vif))
>  		ieee80211_mps_rx_h_sta_process(sta, hdr);
>  
> +	/* airtime accounting */
> +	if (ieee80211_hw_check(&sta->local->hw, AIRTIME_ACCOUNTING)
> &&

Is there much point in this check? I think we can assume drivers are
well-behaved and just leave the field at 0 if they don't support it?

> +	    status->rx_time) {
> +		spin_lock_bh(&sta->lock);
> +		sta->airtime_stats.rx_airtime += status->rx_time;
> +		sta->airtime_deficit -= status->rx_time;
> +		spin_unlock_bh(&sta->lock);
> +	}

I can't say I'm a big fan of the locking here, we have multi-queue RX
where we spread the load across multiple CPUs, and this will lead to
massive cache-line bouncing. Maybe we can make it per-CPU or something?

This gets tricky though, so perhaps we can defer that to a separate
patch to make it multi-queue aware.

Perhaps for such drivers it'd be better anyway to report the used RX
airtime per station *separately*, as part of some kind of statistics
API, rather than inline through RX - there's no need for the inline
reporting after all as long as the values are updated frequently
enough.

> +++ b/net/mac80211/status.c
> @@ -823,6 +823,13 @@ static void __ieee80211_tx_status(struct
> ieee80211_hw *hw,
>  				ieee80211_lost_packet(sta, info);
>  			}
>  		}
> +
> +		if (info->status.tx_time) {
> +			spin_lock_bh(&sta->lock);
> +			sta->airtime_stats.tx_airtime += info->status.tx_time;
> +			sta->airtime_deficit -= info->status.tx_time;
> +			spin_unlock_bh(&sta->lock);
> +		}
>  	}

Those lines also seem pretty long, and the concerns from above apply.

Here you also don't have the hw_check,

>  	/* SNMP counters
> @@ -947,6 +954,14 @@ void ieee80211_tx_status_ext(struct ieee80211_hw
> *hw,
>  			sta->status_stats.retry_failed++;
>  		sta->status_stats.retry_count += retry_count;
>  
> +		if (ieee80211_hw_check(&local->hw, AIRTIME_ACCOUNTING) &&

but here you do?

tx_time already existed anyway though, for other purposes, so you
probably need the check (or do useless work if the driver uses tx_time
for WMM-AC but not for airtime accounting).

>  	if (list_empty(&txqi->schedule_order)) {
> -		list_add_tail(&txqi->schedule_order, &local->active_txqs);
> +		list_add_tail(&txqi->schedule_order, &local->active_txqs_new);
>  		ret = 1;
>  	}

lines seem long?

> +	txqi = list_first_entry(head, struct txq_info,
> schedule_order);
> +
> +	if (txqi->txq.sta) {
> +		struct sta_info *sta = container_of(txqi->txq.sta,
> struct sta_info, sta);
> +
> +		spin_lock_bh(&sta->lock);
> +		if (sta->airtime_deficit < 0) {
> +			sta->airtime_deficit +=
> IEEE80211_AIRTIME_QUANTUM;
> +			list_move_tail(&txqi->schedule_order,
> &local->active_txqs_old);
> +			spin_unlock_bh(&sta->lock);
> +			goto begin;
> +		}
> +		spin_unlock_bh(&sta->lock);
> +	}

ditto here.

johannes
