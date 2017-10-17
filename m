Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:53973 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933027AbdJQHeT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 17 Oct 2017 03:34:19 -0400
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Johannes Berg <johannes@sipsolutions.net>,
        make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] mac80211: Add airtime accounting and scheduling to TXQs
In-Reply-To: <1508224046.10607.67.camel@sipsolutions.net>
References: <20171016160902.8970-1-toke@toke.dk> <20171016160902.8970-2-toke@toke.dk> <1508224046.10607.67.camel@sipsolutions.net>
Date: Tue, 17 Oct 2017 09:34:14 +0200
Message-ID: <871sm2p6rt.fsf@toke.dk> (sfid-20171017_093424_943920_568BDF51)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

>> Only ath9k currently sets the AIRTIME_ACCOUNTING flag.
>
> I think you should actually make that a separate patch.
>
> In the previous patch that's not possible or it breaks things, but
> this patch just adds a new feature that drivers _may_ use, they don't
> have to since it doesn't change the API, so you should split the
> patches.

Yeah, I did that initially. The reason I ended up squashing them is that
this patch moved the per-station 'airtime' debugfs-entry that was
previously created by ath9k into mac80211. I assumed it would create
problems if both the driver and mac80211 tried to create the same file;
not sure how to handle that if it's split into two patches?

> [snip ath9k, I don't really know anything about it]
>
>> --- a/include/net/mac80211.h
>> +++ b/include/net/mac80211.h
>> @@ -1202,6 +1202,7 @@ struct ieee80211_rx_status {
>>  	u32 device_timestamp;
>>  	u32 ampdu_reference;
>>  	u32 flag;
>> +	u16 rx_time;
>
> I'd prefer this were called "airtime" or such,

Right. I picked rx_time for symmetry with the tx side; should I rename
that as well, then, or is asymmetry fine?

> and you clearly need to add documentation regarding this field. In
> particular, you should point to the IEEE80211_HW_AIRTIME_ACCOUNTING hw
> flag, and document what should be taken into account here (preamble
> length, IFS, rts/cts/ack, etc.?) and additionally how this should be
> handled wrt. A-MPDU (and A- MSDU where decapsulated by the device.)

Ah yes, of course; will add some documentation.

> For aggregation, either form, I expect you just want to see 0 for all
> but the very first frame? but that may be very difficult for some
> drivers to implement.

Well yeah, either report the airtime of the whole aggregate on the first
frame and zero on the rest, or report the aggregate overhead on the
first frame and the data+padding time on each frame. Depends on the
information the driver has handy / can calculate, I guess.

>> +++ b/net/mac80211/rx.c
>> @@ -1637,6 +1637,15 @@ ieee80211_rx_h_sta_process(struct
>> ieee80211_rx_data *rx)
>>  	if (ieee80211_vif_is_mesh(&rx->sdata->vif))
>>  		ieee80211_mps_rx_h_sta_process(sta, hdr);
>>  
>> +	/* airtime accounting */
>> +	if (ieee80211_hw_check(&sta->local->hw, AIRTIME_ACCOUNTING)
>> &&
>
> Is there much point in this check? I think we can assume drivers are
> well-behaved and just leave the field at 0 if they don't support it?

I guess it could be omitted for the RX side, yeah. I added the flag
because the tx_time field overlaps with other fields in the tx_info
struct and so can be non-zero even if the driver doesn't add airtime
information (but seems I botched the TX side check as you noted below).

>> +	    status->rx_time) {
>> +		spin_lock_bh(&sta->lock);
>> +		sta->airtime_stats.rx_airtime += status->rx_time;
>> +		sta->airtime_deficit -= status->rx_time;
>> +		spin_unlock_bh(&sta->lock);
>> +	}
>
> I can't say I'm a big fan of the locking here, we have multi-queue RX
> where we spread the load across multiple CPUs, and this will lead to
> massive cache-line bouncing. Maybe we can make it per-CPU or
> something?

A per-CPU counter on RX and a separate task that sums those into the
global counter, perhaps?

> This gets tricky though, so perhaps we can defer that to a separate
> patch to make it multi-queue aware.

ACK. I also don't have any hardware to test this, so would probably be
good to leave that as a separate entry once we're convinced that the
rest is correct.

> Perhaps for such drivers it'd be better anyway to report the used RX
> airtime per station *separately*, as part of some kind of statistics
> API, rather than inline through RX - there's no need for the inline
> reporting after all as long as the values are updated frequently
> enough.

Ah yes, that would be an option as well.

>> +++ b/net/mac80211/status.c
>> @@ -823,6 +823,13 @@ static void __ieee80211_tx_status(struct
>> ieee80211_hw *hw,
>>  				ieee80211_lost_packet(sta, info);
>>  			}
>>  		}
>> +
>> +		if (info->status.tx_time) {
>> +			spin_lock_bh(&sta->lock);
>> +			sta->airtime_stats.tx_airtime += info->status.tx_time;
>> +			sta->airtime_deficit -= info->status.tx_time;
>> +			spin_unlock_bh(&sta->lock);
>> +		}
>>  	}
>
> Those lines also seem pretty long, and the concerns from above apply.
>
> Here you also don't have the hw_check,

Yeah, oops. :)

[snip]

Will fix the rest of your comments and resend. Thanks!

-Toke
