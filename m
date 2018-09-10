Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:53085 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727674AbeIJP4R (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Sep 2018 11:56:17 -0400
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org,
        make-wifi-fast@lists.bufferbloat.net
Cc: Rajkumar Manoharan <rmanohar@codeaurora.org>,
        Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH RFC v3 1/4] mac80211: Add TXQ scheduling API
In-Reply-To: <1536566666.3224.24.camel@sipsolutions.net>
References: <153635803319.14170.10011969968767927187.stgit@alrua-x1> <153635897010.14170.2992498632345986102.stgit@alrua-x1> <1536566666.3224.24.camel@sipsolutions.net>
Date: Mon, 10 Sep 2018 13:02:44 +0200
Message-ID: <87k1ntlinf.fsf@toke.dk> (sfid-20180910_130250_336542_670B7E27)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Sat, 2018-09-08 at 00:22 +0200, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>
>> +/**
>> + * ieee80211_next_txq - get next tx queue to pull packets from
>> + *
>> + * @hw: pointer as obtained from ieee80211_alloc_hw()
>> + * @ac: AC number to return packets from.
>> + * @first: Setting this to true signifies the start of a new scheduling=
 round.
>> + *         Each TXQ will only be returned at most exactly once in each =
round.
>> + *
>> + * Returns the next txq if successful, %NULL if no queue is eligible. I=
f a txq
>> + * is returned, it will have been removed from the scheduler queue and =
needs to
>> + * be re-scheduled with ieee80211_schedule_txq() to continue to be acti=
ve. Note
>> + * that the driver is responsible for locking to ensuring two different=
 threads
>> + * don't schedule the same AC simultaneously.
>
> "Note that [...] to ensure [...]" would seem better to me?
>
>> + */
>> +struct ieee80211_txq *ieee80211_next_txq(struct ieee80211_hw *hw, s8 ac,
>> +					 bool first);
>
> Why should "ac" be signed? Is there some (undocumented) behaviour that
> allows for passing -1 for "don't care" or "pick highest with frames"?
>
> You said "optionally" in the commit message, but I don't think that's
> true, since you just use ac to index the array in the code.

There was in the previous version, but I removed that; guess I forgot to
change the sign and the commit message ;)

>> +bool ieee80211_schedule_txq(struct ieee80211_hw *hw,
>> +			    struct ieee80211_txq *txq)
>> +{
>> +	struct ieee80211_local *local =3D hw_to_local(hw);
>> +	struct txq_info *txqi =3D to_txq_info(txq);
>> +	bool ret =3D false;
>> +
>> +	spin_lock_bh(&local->active_txq_lock);
>> +
>> +	if (list_empty(&txqi->schedule_order)) {
>
> Is there a case where it's allowed to call this while *not* empty? At
> least for the drivers it seems not, so perhaps when called from the
> driver it should WARN() here or so?

Yeah, mac80211 calls this on wake_txq, where it will often be scheduled
already. And since that can happen while drivers schedule stuff, it
could also be the case that a driver re-schedules a queue that is
already scheduled.

> I'm just a bit worried that drivers will get this a bit wrong, and
> we'll never know, but things won't work properly in some weird way.

What, subtle bugs in the data path that causes hangs in hard-to-debug
cases? Nah, that never happens ;)

>> +		list_add_tail(&txqi->schedule_order,
>> +			      &local->active_txqs[txq->ac]);
>> +		ret =3D true;
>> +	}
>> +
>> +	spin_unlock_bh(&local->active_txq_lock);
>> +
>> +	return ret;
>> +}
>> +EXPORT_SYMBOL(ieee80211_schedule_txq);
>
> I'd remove the return value - the driver has no need to know that it
> raced with potential rescheduling in mac80211 due to a new packet, and
> you don't use the return value in mac80211 either.

Yeah, good point; that was left over from when the call to wake_txq was
conditional on this actually doing something...

> It also seems to me that you forgot to say when it should be
> rescheduled? As is, following the documentation would sort of makes it
> seem you should take the queue and put it back at the end (without any
> conditions), and that could lead to "scheduling loops" since empty
> queues would always be put back when they shouldn't be?
>
> Also, come to think of it, but I guess the next patch(es) solve(s) that
> - if mac80211 adds a packet while you have this queue scheduled then you
> would take that packet even if it's questionable it belongs to this
> round?
>
> From a driver perspective, I think I'd prefer an API called e.g.
>
> 	ieee80211_return_txq()
>
> that does the check internally if we need to schedule the queue (i.e.
> there are packets on it). I was going to say we could even annotate with
> sparse, but no - we can't because ieee80211_next_txq() may return NULL.
> Still, it's easier to ensure that all cleanup paths call
> ieee80211_return_txq() if it's not conditional, IMHO.

Good idea, will do.

>> +struct ieee80211_txq *ieee80211_next_txq(struct ieee80211_hw *hw, s8 ac,
>> +					 bool first)
>> +{
>> +	struct ieee80211_local *local =3D hw_to_local(hw);
>> +	struct txq_info *txqi =3D NULL;
>> +
>> +	spin_lock_bh(&local->active_txq_lock);
>> +
>> +	if (first)
>> +		local->schedule_round[ac]++;
>
> (here - clearly ac must be 0 <=3D ac < IEEE80211_NUM_ACS)
>
>> +	if (list_empty(&local->active_txqs[ac]))
>> +		goto out;
>> +
>> +	txqi =3D list_first_entry(&local->active_txqs[ac],
>> +				struct txq_info,
>> +				schedule_order);
>> +
>> +	if (txqi->schedule_round =3D=3D local->schedule_round[ac])
>> +		txqi =3D NULL;
>
> that assigment seems unnecessary? txqi defaults to NULL.

No, this is an 'undo' of the previous line. I.e., we get the first txqi,
check if we've already seen it this round, and if we have, unset txqi so
the function returns NULL (causing the driver to stop looping).

-Toke
