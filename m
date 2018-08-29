Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:34673 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727107AbeH2NST (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 29 Aug 2018 09:18:19 -0400
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Cc: make-wifi-fast@lists.bufferbloat.net, Felix Fietkau <nbd@nbd.name>
Subject: Re: [RFC v2 1/4] mac80211: Add TXQ scheduling API
In-Reply-To: <1535528167.5215.15.camel@sipsolutions.net>
References: <153115421866.7447.6363834356268564403.stgit@alrua-x1> <153115422491.7447.12479559048433925372.stgit@alrua-x1> <1535528167.5215.15.camel@sipsolutions.net>
Date: Wed, 29 Aug 2018 11:22:18 +0200
Message-ID: <87a7p54jed.fsf@toke.dk> (sfid-20180829_112223_461273_FA2E914E)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> Rather belatedly reviewing this too ...
>
>> + * The driver can't access the queue directly. To dequeue a frame from a
>> + * txq, it calls ieee80211_tx_dequeue(). Whenever mac80211 adds a new frame to a
>> + * queue, it calls the .wake_tx_queue driver op.
>> + *
>> + * Drivers can optionally delegate responsibility for scheduling queues to
>> + * mac80211, to take advantage of airtime fairness accounting. In this case, to
>> + * obtain the next queue to pull frames from, the driver calls
>> + * ieee80211_next_txq(). The driver is then expected to re-schedule the txq
>> + * using ieee80211_schedule_txq() if it is still active after the driver has
>> + * finished pulling packets from it.
>
> Maybe you could clarify what "is still active" means here? I'm
> guessing it means "tx_dequeue() would return non-NULL" but I doubt you
> really want such a strong requirement, perhaps "the last tx_dequeue()
> returned non-NULL" is sufficient?

Yeah, the latter should suffice. Really it should be put back "if it is
not known to be empty", but, well, that doesn't read so well...

> We're also working on adding a TXQ for (bufferable) management packets
> - I wonder how that should interact here? Always be scheduled first?

Ah, cool! It may be that it should be given priority, yeah. Presently,
the multicast queue just rotates in the RR with the others, but is never
throttled as it doesn't have an airtime measure (though perhaps it
should)? But that might not be desirable for management frames, as
presumable those need to go out as fast as possible?

>> +/**
>> + * ieee80211_schedule_txq - add txq to scheduling loop
>> + *
>> + * @hw: pointer as obtained from ieee80211_alloc_hw()
>> + * @txq: pointer obtained from station or virtual interface
>> + * @reset_seqno: Whether to reset the internal scheduling sequence number,
>> + *               allowing this txq to appear again in the current scheduling
>> + *               round (see doc for ieee80211_next_txq()).
>> + *
>> + * Returns %true if the txq was actually added to the scheduling,
>> + * %false otherwise.
>> + */
>> +bool ieee80211_schedule_txq(struct ieee80211_hw *hw,
>> +			    struct ieee80211_txq *txq,
>> +			    bool reset_seqno);
>
> I concur with Rajkumar in a way that "seqno" is a really bad name for
> this since it's so loaded in the context of wifi. He didn't say it this
> way, but said it was an "internal to mac80211" concept here, and was
> perhaps also/more referring to the manipulations by drivers.
>
> Perhaps calling it something like scheduling_round or something would be
> better? That's not really what it is, schedule_id? Even schedule_seq[no]
> would be clearer.

Yeah, definitely going to change that :)

>> +/**
>> + * ieee80211_next_txq - get next tx queue to pull packets from
>> + *
>> + * @hw: pointer as obtained from ieee80211_alloc_hw()
>> + * @ac: filter returned txqs with this AC number. Pass -1 for no filtering.
>> + * @inc_seqno: Whether to increase the scheduling sequence number. Setting this
>> + *             to true signifies the start of a new scheduling round. Each TXQ
>> + *             will only be returned exactly once in each round (unless its
>> + *             sequence number is explicitly reset when calling
>> + *             ieee80211_schedule_txq()).
>
> Here you already talk about "scheduling sequence number" after all :)
>
>> +	ieee80211_schedule_txq(&local->hw, &txqi->txq, true);
>>  	drv_wake_tx_queue(local, txqi);
>
> These always seem to come paired - perhaps a helper is useful?
>
> Although it looks like there are sometimes different locking contexts,
> not sure if that's really necessary though.

Hmm, I seem to recall thinking about just putting the call to
schedule_txq() into drv_wake_tx_queue; don't remember why I ended up
dropping that; but will take another look at whether it makes sense to
combine things.

-Toke
