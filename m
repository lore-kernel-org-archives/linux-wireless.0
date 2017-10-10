Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:43439 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932300AbdJJRvi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 10 Oct 2017 13:51:38 -0400
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Johannes Berg <johannes@sipsolutions.net>,
        make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org
Subject: Re: [RFC 1/3] mac80211: Add TXQ scheduling API
In-Reply-To: <1507650823.26041.70.camel@sipsolutions.net>
References: <20171010140208.1515-1-toke@toke.dk> <1507650823.26041.70.camel@sipsolutions.net>
Date: Tue, 10 Oct 2017 19:51:30 +0200
Message-ID: <87k2027uxp.fsf@toke.dk> (sfid-20171010_195146_648515_38804C00)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Tue, 2017-10-10 at 16:02 +0200, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>
>> +++ b/net/mac80211/agg-tx.c
>> @@ -226,9 +226,11 @@ ieee80211_agg_start_txq(struct sta_info *sta,
>> int tid, bool enable)
>>  		clear_bit(IEEE80211_TXQ_AMPDU, &txqi->flags);
>>=20=20
>>  	clear_bit(IEEE80211_TXQ_STOP, &txqi->flags);
>> +	ieee80211_schedule_txq(&sta->sdata->local->hw, txq);
>> +
>>  	local_bh_disable();
>>  	rcu_read_lock();
>> -	drv_wake_tx_queue(sta->sdata->local, txqi);
>> +	drv_wake_tx_queue(sta->sdata->local);
>>  	rcu_read_unlock();
>>  	local_bh_enable();
>
> It seems like there could be some sort of TX batching here - maybe
> only call the driver if the queue was actually scheduled?

Yeah, I guess that should be doable.

>> @@ -1121,6 +1122,9 @@ struct ieee80211_local {
>>  	struct codel_vars *cvars;
>>  	struct codel_params cparams;
>>=20=20
>> +	struct list_head active_txqs;
>> +	spinlock_t active_txq_lock;
>
> Is there much point in having a separate lock? We probably need the fq
> lock in most places related to this anyway?

Well, once the scheduler gets a bit smarter it may be necessary to much
with the order of TXQs on there without touching any of the queues
(e.g., when calculating airtime usage on TX and RX completion). Not sure
if that is enough to warrant a separate lock, though; I hadn't thought
about just grabbing fq->lock...

>> +void ieee80211_schedule_txq(struct ieee80211_hw *hw,
>> +			     struct ieee80211_txq *txq)
>> +{
>> +	struct ieee80211_local *local =3D hw_to_local(hw);
>> +	struct txq_info *txqi =3D to_txq_info(txq);
>> +
>> +	spin_lock_bh(&local->active_txq_lock);
>> +
>> +	if (!list_empty(&txqi->schedule_order))
>> +		list_add_tail(&txqi->schedule_order, &local-
>> >active_txqs);
>
> What's with the !list_empty()? Seems inverted to me? You need to add
> it if it's empty?

Yeah, nice catch. This started out as an "unschedule" function before I
decided this way was better. Guess I forgot to switch the logic :)

> Also maybe you should only do that if the TXQ isn't *empty*, so the
> driver could call this unconditionally?

There can be cases where the driver wants the queue to be scheduled even
though it looks empty from mac80211's point of view. For ath9k, the
driver keeps its retry queue in the drv_priv part of the txq structure,
so it will check if that is empty before deciding to call the schedule
function.

This is also related to the PS behaviour, so guess this could be changed
once that is all TXQ-based...

-Toke
