Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:40127 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732234AbeGLXZM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 12 Jul 2018 19:25:12 -0400
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Rajkumar Manoharan <rmanohar@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        make-wifi-fast@lists.bufferbloat.net, Felix Fietkau <nbd@nbd.name>,
        linux-wireless-owner@vger.kernel.org
Subject: Re: [RFC v2 1/4] mac80211: Add TXQ scheduling API
In-Reply-To: <8d8160cd9c804d1b00ba4e234c8f1520@codeaurora.org>
References: <153115421866.7447.6363834356268564403.stgit@alrua-x1> <153115422491.7447.12479559048433925372.stgit@alrua-x1> <361a221dd15e44028fd35440df657a3d@codeaurora.org> <87lgahbisu.fsf@toke.dk> <8d8160cd9c804d1b00ba4e234c8f1520@codeaurora.org>
Date: Fri, 13 Jul 2018 01:13:22 +0200
Message-ID: <87k1q09hf1.fsf@toke.dk> (sfid-20180713_011328_984293_98FF2C79)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan <rmanohar@codeaurora.org> writes:

> On 2018-07-11 13:48, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Rajkumar Manoharan <rmanohar@codeaurora.org> writes:
>>=20
>>> On 2018-07-09 09:37, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>>> [...]
>>>> +/**
>>>> + * ieee80211_schedule_txq - add txq to scheduling loop
>>>> + *
>>>> + * @hw: pointer as obtained from ieee80211_alloc_hw()
>>>> + * @txq: pointer obtained from station or virtual interface
>>>> + * @reset_seqno: Whether to reset the internal scheduling sequence
>>>> number,
>>>> + *               allowing this txq to appear again in the current
>>>> scheduling
>>>> + *               round (see doc for ieee80211_next_txq()).
>>>> + *
>>>> + * Returns %true if the txq was actually added to the scheduling,
>>>> + * %false otherwise.
>>>> + */
>>>> +bool ieee80211_schedule_txq(struct ieee80211_hw *hw,
>>>> +			    struct ieee80211_txq *txq,
>>>> +			    bool reset_seqno);
>>>> +
>>>> +/**
>>>> + * ieee80211_next_txq - get next tx queue to pull packets from
>>>> + *
>>>> + * @hw: pointer as obtained from ieee80211_alloc_hw()
>>>> + * @ac: filter returned txqs with this AC number. Pass -1 for no
>>>> filtering.
>>>> + * @inc_seqno: Whether to increase the scheduling sequence number.
>>>> Setting this
>>>> + *             to true signifies the start of a new scheduling=20
>>>> round.
>>>> Each TXQ
>>>> + *             will only be returned exactly once in each round
>>>> (unless its
>>>> + *             sequence number is explicitly reset when calling
>>>> + *             ieee80211_schedule_txq()).
>>>> + *
>>> Toke,
>>>=20
>>> Seems like seqno is internal to mac80211 and meant for active_txq list
>>> manipulation. If so, why would drivers have to worry about increment
>>> or resetting seqno?
>>=20
>> The drivers need to be able to signal when they start a new "scheduling
>> round" (which is the parameter to next_txq()), and when a queue should
>> be immediately rescheduled (which is the parameter to schedule_txq()).
>> See the subsequent patch to ath9k for how this is used; the latter is
>> signalled when a TXQ successfully dequeued an aggregate...
>>=20
>> Now, you're right that the choice to track this via a sequence number=20
>> is
>> an implementation detail internal to mac80211... so maybe the=20
>> parameters
>> should be called something different.
>>=20
>>> IMHO to avoid over serving same txq, two lists (activeq and waitq) can
>>> be used and always add new txq into waitq list. So that driver will
>>> not worry about mac80211 txq manipulation. Please correct me If Im
>>> wrong.
>>>=20
>>> ieee80211_schedule_txq
>>>     - if schedule_order empty, add txq into waitq list tail.
>>>=20
>>> ieee80211_next_txq
>>>     - if activeq empty,
>>>          - move waitq list into activeq
>>>=20
>>>     - if activeq not empty
>>>          - fetch appropriate txq from activeq
>>>          - remove txq from activeq list.
>>>=20
>>>     - If txq found, return txq else return NULL
>>=20
>>=20
>> Erm, how would this prevent an infinite loop? With this scheme, at some
>> point, ieee80211_next_txq() removes the last txq from activeq, and
>> returns that. Then, when it is called again the next time the driver
>> loops, it's back to the first case (activeq empty, waitq non-empty); so
>> it'll move waitq back as activeq and start over... Only the driver
>> really knows when it is starting a logical "loop through all active
>> TXQs".
>>=20
> Oops.. My bad.. The idea is that ieee80211_next_txq process txq from
> activeq only and keep processed txqs separately. Having single list
> eventually needs tracking mechanism. The point is that once activeq
> becomes empty, splice waitq list and return NULL. So that driver can
> break from the loop.
>
> ieee80211_next_txq
>       - if activeq empty,
>            - move waitq list into activeq
>            - return NULL
>
>       - if activeq not empty
>            - fetch appropriate txq from activeq
>            - remove txq from activeq list.
>
>       - If txq found, return txq else return NULL

Right, so this would ensure the driver only sees each TXQ once *if it
keeps looping*. But it doesn't necessarily; if the hardware queues fill
up, for instance, it might abort earlier. In that case it would need to
signal mac80211 that it is done for now, which is equivalent to
signalling when it starts a scheduler round.

>> Also, for airtime fairness, the queues are not scheduled strictly
>> round-robin, so the dual-list scheme wouldn't work there either...
>>=20
> As you know, ath10k driver will operate in two tx modes (push-only,
> push-pull). These modes will be switched dynamically depends on
> firmware load or resource availability. In push-pull mode, firmware
> will query N number of frames for set of STA, TID.

Ah, so it will look up the TXQ without looping through the list of
pending queues at all? Didn't realise that is what it's doing; yeah,
that would be problematic for airtime fairness :)

> So the driver will directly dequeue N number of frames from given txq.
> In this case txq ordering alone wont help. I am planning to add below
> changes in exiting API and add new API ieee80211_reorder_txq.
>
> ieee80211_txq_get_depth
>       - return deficit status along with frm_cnt
>
> ieee80211_reorder_txq
>       - if txq deficit > 0
>             - return;
>       - if txq is last
>              - return
>       - delete txq from list
>       - move it to tail
>       - update deficit by quantum
>
> ath10k_htt_rx_tx_fetch_ind
>       - get txq deficit status
>       - if txq deficit > 0
>             - dequeue skb
>       - else if deficit < 0
>             - return NULL
>
> Please share your thoughts.

Hmm, not sure exactly how this would work; seems a little complicated?
Also, I'd rather if drivers were completely oblivious to the deficit;
that is a bit of an implementation detail...

We could have an ieee80211_txq_may_pull(); or maybe just have
ieee80211_tx_dequeue() return NULL if the deficit is negative? I think
the reasonable thing for the driver to do, then, would be to ask
ieee80211_next_txq() for another TXQ to pull from if the current one
doesn't work for whatever reason.

Would that work for push-pull mode?

-Toke
