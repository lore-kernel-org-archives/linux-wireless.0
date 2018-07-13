Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:48633 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729634AbeGMNym (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Jul 2018 09:54:42 -0400
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Rajkumar Manoharan <rmanohar@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        make-wifi-fast@lists.bufferbloat.net, Felix Fietkau <nbd@nbd.name>,
        linux-wireless-owner@vger.kernel.org
Subject: Re: [RFC v2 1/4] mac80211: Add TXQ scheduling API
In-Reply-To: <f8038c8ea281b365ec560cae0dd1ec0f@codeaurora.org>
References: <153115421866.7447.6363834356268564403.stgit@alrua-x1> <153115422491.7447.12479559048433925372.stgit@alrua-x1> <361a221dd15e44028fd35440df657a3d@codeaurora.org> <87lgahbisu.fsf@toke.dk> <8d8160cd9c804d1b00ba4e234c8f1520@codeaurora.org> <87k1q09hf1.fsf@toke.dk> <f8038c8ea281b365ec560cae0dd1ec0f@codeaurora.org>
Date: Fri, 13 Jul 2018 15:39:55 +0200
Message-ID: <87h8l39rv8.fsf@toke.dk> (sfid-20180713_154003_675804_FCA63BB9)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan <rmanohar@codeaurora.org> writes:

> On 2018-07-12 16:13, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Rajkumar Manoharan <rmanohar@codeaurora.org> writes:
>>=20
>>> On 2018-07-11 13:48, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>>>> Rajkumar Manoharan <rmanohar@codeaurora.org> writes:
>>>>=20
>>>>> On 2018-07-09 09:37, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>>>>> [...]
>>>>>> +/**
> [...]
>
>>>> Erm, how would this prevent an infinite loop? With this scheme, at=20
>>>> some
>>>> point, ieee80211_next_txq() removes the last txq from activeq, and
>>>> returns that. Then, when it is called again the next time the driver
>>>> loops, it's back to the first case (activeq empty, waitq non-empty);=20
>>>> so
>>>> it'll move waitq back as activeq and start over... Only the driver
>>>> really knows when it is starting a logical "loop through all active
>>>> TXQs".
>>>>=20
>>> Oops.. My bad.. The idea is that ieee80211_next_txq process txq from
>>> activeq only and keep processed txqs separately. Having single list
>>> eventually needs tracking mechanism. The point is that once activeq
>>> becomes empty, splice waitq list and return NULL. So that driver can
>>> break from the loop.
>>>=20
>>> ieee80211_next_txq
>>>       - if activeq empty,
>>>            - move waitq list into activeq
>>>            - return NULL
>>>=20
>>>       - if activeq not empty
>>>            - fetch appropriate txq from activeq
>>>            - remove txq from activeq list.
>>>=20
>>>       - If txq found, return txq else return NULL
>>=20
>> Right, so this would ensure the driver only sees each TXQ once *if it
>> keeps looping*. But it doesn't necessarily; if the hardware queues fill
>> up, for instance, it might abort earlier. In that case it would need to
>> signal mac80211 that it is done for now, which is equivalent to
>> signalling when it starts a scheduler round.
>>=20
> Hmm... I thought driver will call ieee80211_schedule_txq when it runs
> out of hardware descriptor and break the loop. The serving txq will be
> added back to head of activeq list. no?

Yes, and then the next one will be serviced... It's basically:

while (!hwq_is_full()) {
 txq =3D next_txq():
 build_one_aggr(txq); // may or may not succeed
 if (!empty(txq))
   schedule_txq(txq);
}

It is not generally predictable how many times this will loop before
exiting...

>>>> Also, for airtime fairness, the queues are not scheduled strictly
>>>> round-robin, so the dual-list scheme wouldn't work there either...
>>>>=20
>>> As you know, ath10k driver will operate in two tx modes (push-only,
>>> push-pull). These modes will be switched dynamically depends on
>>> firmware load or resource availability. In push-pull mode, firmware
>>> will query N number of frames for set of STA, TID.
>>=20
>> Ah, so it will look up the TXQ without looping through the list of
>> pending queues at all? Didn't realise that is what it's doing; yeah,
>> that would be problematic for airtime fairness :)
>>=20
>>> So the driver will directly dequeue N number of frames from given txq.
>>> In this case txq ordering alone wont help. I am planning to add below
>>> changes in exiting API and add new API ieee80211_reorder_txq.
>>>=20
>>> ieee80211_txq_get_depth
>>>       - return deficit status along with frm_cnt
>>>=20
>>> ieee80211_reorder_txq
>>>       - if txq deficit > 0
>>>             - return;
>>>       - if txq is last
>>>              - return
>>>       - delete txq from list
>>>       - move it to tail
>>>       - update deficit by quantum
>>>=20
>>> ath10k_htt_rx_tx_fetch_ind
>>>       - get txq deficit status
>>>       - if txq deficit > 0
>>>             - dequeue skb
>>>       - else if deficit < 0
>>>             - return NULL
>>>=20
>>> Please share your thoughts.
>>=20
>> Hmm, not sure exactly how this would work; seems a little complicated?
>> Also, I'd rather if drivers were completely oblivious to the deficit;
>> that is a bit of an implementation detail...
>>=20
> Agree.. Initially I thought of adding deficit check in=20
> ieee80211_tx_dequeue.
> But It will be overhead of taking activeq_lock for every skbs. Perhaps
> it can be renamed as allowed_to_dequeue instead of deficit.
>
>> We could have an ieee80211_txq_may_pull(); or maybe just have
>> ieee80211_tx_dequeue() return NULL if the deficit is negative?
>>=20
> As I said earlier, checking deficit for every skb will be an overhead.
> It should be done once before accessing txq.

Well, it could conceivably be done in a way that doesn't require taking
the activeq_lock. Adding another STOP flag to the TXQ, for instance.
>From an API point of view I think that is more consistent with what we
have already...

>> the reasonable thing for the driver to do, then, would be to ask
>> ieee80211_next_txq() for another TXQ to pull from if the current one
>> doesn't work for whatever reason.
>>=20
>> Would that work for push-pull mode?
>>=20
> Not really. Driver shouldn't send other txq data instead of asked one.

I didn't necessarily mean immediately. As long as it does it eventually.
If a TXQ's deficit runs negative, that TXQ will not be allowed to send
again until its deficit has been restored to positive through enough
cycles of the loop in next_txq().=20

> In MU-MIMO, firmware will query N packets from given set of {STA,TID}.
> So the driver not supposed to send other txq's data.

Hmm, it'll actually be interesting to see how the airtime fairness
scheduler interacts with MU-MIMO. I'm not quite sure that it'll be in a
good way; the DRR scheduler generally only restores one TXQ to positive
deficit at a time, so it may be that MU-MIMO will break completely and
we'll have to come up with another scheduling algorithm.

How does the firmware the airtime of a MU-MIMO transmission to each of
the involved stations?

-Toke
