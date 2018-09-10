Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:45045 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727269AbeIJQHb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Sep 2018 12:07:31 -0400
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org,
        make-wifi-fast@lists.bufferbloat.net
Cc: Rajkumar Manoharan <rmanohar@codeaurora.org>,
        Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH RFC v3 2/4] mac80211: Add airtime accounting and scheduling to TXQs
In-Reply-To: <1536567496.3224.36.camel@sipsolutions.net>
References: <153635803319.14170.10011969968767927187.stgit@alrua-x1> <153635897061.14170.17999956909203163571.stgit@alrua-x1> <1536567496.3224.36.camel@sipsolutions.net>
Date: Mon, 10 Sep 2018 13:13:55 +0200
Message-ID: <87h8ixli4s.fsf@toke.dk> (sfid-20180910_131401_601839_B5B2328D)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Sat, 2018-09-08 at 00:22 +0200, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>>=20
>> +/**
>> + * ieee80211_airtime_may_transmit - check whether TXQ is allowed to tra=
nsmit
>> + *
>> + * This function is used to check whether given txq is allowed to trans=
mit by
>> + * the airtime scheduler, and can be used by drivers to access the airt=
ime
>> + * fairness accounting without going using the scheduling order enfored=
 by
>> + * next_txq().
>> + *
>> + * Returns %true if the airtime scheduler does not think the TXQ should=
 be
>> + * throttled. This function can also have the side effect of rotating t=
he TXQ in
>> + * the scheduler rotation, which will eventually bring the deficit to p=
ositive
>> + * and allow the station to transmit again.
>> + *
>> + * If this function returns %true, the TXQ will have been removed from =
the
>> + * scheduling. It is the driver's responsibility to add it back (by cal=
ling
>> + * ieee80211_schedule_txq()) if needed.
>> + *
>> + * @hw: pointer as obtained from ieee80211_alloc_hw()
>> + * @txq: pointer obtained from station or virtual interface
>> + *
>> + */
>
> Spurious newline there at the end.
>
> (As an aside from the review, perhaps this would be what we could use in
> iwlwifi, but I'll need to think about _when_ to add it back to the
> scheduling later).

Yeah, this is the API that would be used by drivers where the actual
scheduling of TXQs is done by the hardware (i.e., ath10k in pull/push
mode, and iwlwifi if I understand you correctly); whereas the next_txq()
call is for drivers that do the scheduling in software (ath10k without
pull/push, ath9k and mt76).

Basically, the way I envision this is the drivers doing something like:

function on_hw_notify(hw, txq) {
  if (ieee80211_airtime_may_transmit(txq)) {
     while (hw_has_space() && (pkt =3D ieee80211_tx_dequeue(hw, txq)))
         push_to_hw(pkt);

     ieee80211_schedule_txq(txq);
  }
}
=20=20=20=20=20=20
>> + * @NL80211_EXT_FEATURE_AIRTIME_FAIRNESS: Driver supports airtime fairn=
ess
>> + *      scheduling.
>> + *
>>   * @NUM_NL80211_EXT_FEATURES: number of extended features.
>>   * @MAX_NL80211_EXT_FEATURES: highest extended feature index.
>>   */
>> @@ -5269,6 +5272,7 @@ enum nl80211_ext_feature_index {
>>  	NL80211_EXT_FEATURE_SCAN_RANDOM_SN,
>>  	NL80211_EXT_FEATURE_SCAN_MIN_PREQ_CONTENT,
>>  	NL80211_EXT_FEATURE_CAN_REPLACE_PTK0,
>> +	NL80211_EXT_FEATURE_AIRTIME_FAIRNESS,
>
> Why is this necessary in this patch?

It's meant as a way for the driver to signal that it has a source of
airtime information, and thus would like to be scheduled to take this
into account.

> I think that this should probably come with more documentation too,
> particularly what's expected of the driver here.

Right :)

> I'd prefer you reorder patches 2 and 3, and define everything in
> cfg80211 first. That also makes it easier to reason about what happens
> when the feature is not supported (since it will not be supported
> anywhere). Then this can be included in the cfg80211 patch instead,
> which places it better, and the mac80211 bits from the cfg80211 patch=20
> can be included here, which also places those better.

Good idea, will do!

>> -			       txqi->flags & (1<<IEEE80211_TXQ_STOP) ? "STOP" : "RUN",
>> -			       txqi->flags & (1<<IEEE80211_TXQ_AMPDU) ? " AMPDU" : "",
>> -			       txqi->flags & (1<<IEEE80211_TXQ_NO_AMSDU) ? " NO-AMSDU" : "");
>> +			       txqi->flags & (1 << IEEE80211_TXQ_STOP) ? "STOP" : "RUN",
>> +			       txqi->flags & (1 << IEEE80211_TXQ_AMPDU) ? " AMPDU" : "",
>> +			       txqi->flags & (1 << IEEE80211_TXQ_NO_AMSDU) ? " NO-AMSDU" : "=
");
>
> consider BIT() instead as a cleanup? :)
>
> (or maybe this is just a leftover from merging some other patches?)

Yeah, this is a merging artifact; Rajkumar's patch added another flag,
that I removed again. Didn't notice that there was still a whitespace
change in this patch...

>> +static bool ieee80211_txq_check_deficit(struct ieee80211_local *local,
>> +					struct txq_info *txqi)
>
> Maybe this should be called "has_deficit" or so - the polarity isn't
> immediately clear to me.

Yup, I suck at naming; gotcha ;)

>> +{
>> +	struct sta_info *sta;
>> +
>> +	lockdep_assert_held(&local->active_txq_lock);
>> +
>> +	if (!txqi->txq.sta)
>> +		return true;
>> +
>> +	sta =3D container_of(txqi->txq.sta, struct sta_info, sta);
>> +
>> +	if (sta->airtime.deficit[txqi->txq.ac] > 0)
>> +		return true;
>> +
>> +	if (txqi =3D=3D list_first_entry_or_null(&local->active_txqs[txqi->txq=
.ac],
>
> nit: I don't think you need _or_null here, since list_first_entry() will
> "return" the head itself if the list is empty, which cannot match txqi?
> Doesn't matter that much though, and if you think this is easier to
> understand then that's fine.
>
>> +					     struct txq_info,
>> +					     schedule_order)) {
>> +		sta->airtime.deficit[txqi->txq.ac] +=3D sta->airtime.weight;
>> +		list_move_tail(&txqi->schedule_order,
>> +			       &local->active_txqs[txqi->txq.ac]);
>> +	}
>> +
>> +	return false;
>> +}
>> +
>>  struct ieee80211_txq *ieee80211_next_txq(struct ieee80211_hw *hw, s8 ac,
>>  					 bool first)
>>  {
>> @@ -3659,6 +3701,7 @@ struct ieee80211_txq *ieee80211_next_txq(struct ie=
ee80211_hw *hw, s8 ac,
>>  	if (first)
>>  		local->schedule_round[ac]++;
>>=20=20
>> + begin:
>>  	if (list_empty(&local->active_txqs[ac]))
>>  		goto out;
>>=20=20
>> @@ -3666,6 +3709,9 @@ struct ieee80211_txq *ieee80211_next_txq(struct ie=
ee80211_hw *hw, s8 ac,
>>  				struct txq_info,
>>  				schedule_order);
>>=20=20
>> +	if (!ieee80211_txq_check_deficit(local, txqi))
>> +		goto begin;
>
> This code isn't so badly indented - you could use a do { } while () loop
> instead?
>
>>  	if (txqi->schedule_round =3D=3D local->schedule_round[ac])
>>  		txqi =3D NULL;
>
> and maybe you want this check first, it's much cheaper?
>
> do {
> ...
> } while (txqi->schedule_round !=3D local->schedule_round[ac] &&
>          !has_deficit())
>
> or so?
>
> That is to say, I'm not sure why you'd want to abort if you find a
> queue that has no deficit but is part of the next round? Or is that
> the abort condition for having gone around the whole list once? Hmm.
> But check_deficit() also moves them to the end, so you don't really
> get that anyway?

The move to the end for check_deficit() is what replenishes the airtime
deficit and ensures fairness. So that can loop several times in a single
call to the function. The schedule_round counter is there to prevent the
driver from looping indefinitely when doing `while (txq =3D
ieee80211_next_txq())`. We'd generally want the deficit replenish to
happen in any case; previously, the schedule_round type check was in the
driver; moving it here is an attempt at simplifying the logic needed in
the driver when using the API.

>> @@ -3681,6 +3727,25 @@ struct ieee80211_txq *ieee80211_next_txq(struct i=
eee80211_hw *hw, s8 ac,
>>  }
>>  EXPORT_SYMBOL(ieee80211_next_txq);
>>=20=20
>> +bool ieee80211_txq_may_transmit(struct ieee80211_hw *hw,
>> +				struct ieee80211_txq *txq)
>> +{
>> +	struct ieee80211_local *local =3D hw_to_local(hw);
>> +	struct txq_info *txqi =3D to_txq_info(txq);
>> +	bool may_tx =3D false;
>> +
>> +	spin_lock_bh(&local->active_txq_lock);
>> +
>> +	if (ieee80211_txq_check_deficit(local, txqi)) {
>> +		may_tx =3D true;
>> +		list_del_init(&txqi->schedule_order);
>
> Manipulating the list twice like this here seems slightly odd ...
> perhaps move the list manipulation out of txq_check_deficit() entirely?
> Clearly it's logically fine, but seems harder than necessary to
> understand.
>
> Also, if the check_deficit() function just returns a value, the renaming
> I suggested is easier to accept :)

Yeah, maybe; it'll result in some duplication between next_txq() and
txq_may_transmit() (to the point where I'm not sure if the separate
check_deficit() function is really needed anymore), but it may be that
that is actually easier to understand?

-Toke
