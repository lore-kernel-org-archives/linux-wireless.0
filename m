Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:59145 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726692AbeGKUy0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 11 Jul 2018 16:54:26 -0400
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Rajkumar Manoharan <rmanohar@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        make-wifi-fast@lists.bufferbloat.net, Felix Fietkau <nbd@nbd.name>,
        linux-wireless-owner@vger.kernel.org
Subject: Re: [RFC v2 1/4] mac80211: Add TXQ scheduling API
In-Reply-To: <361a221dd15e44028fd35440df657a3d@codeaurora.org>
References: <153115421866.7447.6363834356268564403.stgit@alrua-x1> <153115422491.7447.12479559048433925372.stgit@alrua-x1> <361a221dd15e44028fd35440df657a3d@codeaurora.org>
Date: Wed, 11 Jul 2018 22:48:17 +0200
Message-ID: <87lgahbisu.fsf@toke.dk> (sfid-20180711_224822_358715_F2FA6EBA)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan <rmanohar@codeaurora.org> writes:

> On 2018-07-09 09:37, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> [...]
>> +/**
>> + * ieee80211_schedule_txq - add txq to scheduling loop
>> + *
>> + * @hw: pointer as obtained from ieee80211_alloc_hw()
>> + * @txq: pointer obtained from station or virtual interface
>> + * @reset_seqno: Whether to reset the internal scheduling sequence=20
>> number,
>> + *               allowing this txq to appear again in the current=20
>> scheduling
>> + *               round (see doc for ieee80211_next_txq()).
>> + *
>> + * Returns %true if the txq was actually added to the scheduling,
>> + * %false otherwise.
>> + */
>> +bool ieee80211_schedule_txq(struct ieee80211_hw *hw,
>> +			    struct ieee80211_txq *txq,
>> +			    bool reset_seqno);
>> +
>> +/**
>> + * ieee80211_next_txq - get next tx queue to pull packets from
>> + *
>> + * @hw: pointer as obtained from ieee80211_alloc_hw()
>> + * @ac: filter returned txqs with this AC number. Pass -1 for no=20
>> filtering.
>> + * @inc_seqno: Whether to increase the scheduling sequence number.=20
>> Setting this
>> + *             to true signifies the start of a new scheduling round.=20
>> Each TXQ
>> + *             will only be returned exactly once in each round=20
>> (unless its
>> + *             sequence number is explicitly reset when calling
>> + *             ieee80211_schedule_txq()).
>> + *
> Toke,
>
> Seems like seqno is internal to mac80211 and meant for active_txq list
> manipulation. If so, why would drivers have to worry about increment
> or resetting seqno?

The drivers need to be able to signal when they start a new "scheduling
round" (which is the parameter to next_txq()), and when a queue should
be immediately rescheduled (which is the parameter to schedule_txq()).
See the subsequent patch to ath9k for how this is used; the latter is
signalled when a TXQ successfully dequeued an aggregate...

Now, you're right that the choice to track this via a sequence number is
an implementation detail internal to mac80211... so maybe the parameters
should be called something different.

> IMHO to avoid over serving same txq, two lists (activeq and waitq) can
> be used and always add new txq into waitq list. So that driver will
> not worry about mac80211 txq manipulation. Please correct me If Im
> wrong.
>
> ieee80211_schedule_txq
>     - if schedule_order empty, add txq into waitq list tail.
>
> ieee80211_next_txq
>     - if activeq empty,
>          - move waitq list into activeq
>
>     - if activeq not empty
>          - fetch appropriate txq from activeq
>          - remove txq from activeq list.
>
>     - If txq found, return txq else return NULL


Erm, how would this prevent an infinite loop? With this scheme, at some
point, ieee80211_next_txq() removes the last txq from activeq, and
returns that. Then, when it is called again the next time the driver
loops, it's back to the first case (activeq empty, waitq non-empty); so
it'll move waitq back as activeq and start over... Only the driver
really knows when it is starting a logical "loop through all active
TXQs".

Also, for airtime fairness, the queues are not scheduled strictly
round-robin, so the dual-list scheme wouldn't work there either...

-Toke
