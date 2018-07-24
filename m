Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:60577 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388334AbeGXMO5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Jul 2018 08:14:57 -0400
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Rajkumar Manoharan <rmanohar@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        make-wifi-fast@lists.bufferbloat.net, Felix Fietkau <nbd@nbd.name>,
        linux-wireless-owner@vger.kernel.org
Subject: Re: [RFC v2 1/4] mac80211: Add TXQ scheduling API
In-Reply-To: <9d2d6156f7bfd173ed5098f528d7ed49@codeaurora.org>
References: <153115421866.7447.6363834356268564403.stgit@alrua-x1> <153115422491.7447.12479559048433925372.stgit@alrua-x1> <361a221dd15e44028fd35440df657a3d@codeaurora.org> <87lgahbisu.fsf@toke.dk> <8d8160cd9c804d1b00ba4e234c8f1520@codeaurora.org> <87k1q09hf1.fsf@toke.dk> <f8038c8ea281b365ec560cae0dd1ec0f@codeaurora.org> <87h8l39rv8.fsf@toke.dk> <01fe0f526e992563e3b1f450f8acc9e4@codeaurora.org> <87wotr2trs.fsf@toke.dk> <25dc507c35c2dff356742626d026989d@codeaurora.org> <877elo48ea.fsf@toke.dk> <9d2d6156f7bfd173ed5098f528d7ed49@codeaurora.org>
Date: Tue, 24 Jul 2018 13:08:56 +0200
Message-ID: <87k1pk3n7b.fsf@toke.dk> (sfid-20180724_130905_269610_90589855)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan <rmanohar@codeaurora.org> writes:

> On 2018-07-21 13:54, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Rajkumar Manoharan <rmanohar@codeaurora.org> writes:
>>=20
>>> On 2018-07-19 07:18, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>>>> Rajkumar Manoharan <rmanohar@codeaurora.org> writes:
>>>>=20
>>>>> On 2018-07-13 06:39, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>>>>>> Rajkumar Manoharan <rmanohar@codeaurora.org> writes:
>>>=20
>>>>>> It is not generally predictable how many times this will loop=20
>>>>>> before
>>>>>> exiting...
>>>>>>=20
>>>>> Agree.. It would be better If the driver does not worry about txq
>>>>> sequence numbering. Perhaps one more API (ieee80211_first_txq) could
>>>>> solve this. Will leave it to you.
>>>>=20
>>>> That is basically what the second parameter to next_txq() does in the
>>>> current patchset. It just needs to be renamed...
>>>>=20
>>> Agree. As next_txq() increments seqno while starting loop for each AC,
>>> It seems bit confusing. i.e A single ath_txq_schedule_all call will
>>> bump schedule_seqno by 4. right?
>>=20
>> Hmm, good point. Guess there should be one seqno per ac...
>>=20
> I would prefer to keep separate list for each AC ;) Prepared one on
> top of your earlier merged changes. Now it needs revisit.

Fine with me. Only reason I used a single list + the filtering mechanism
was to keep things compatible with ath10k ;)

>>> Let assume below case where CPU1 is dequeuing skb from isr context and
>>> CPU2 is enqueuing skbs into same txq.
>>>=20
>>> CPU1                                          CPU2
>>> ----                                          ----
>>> ath_txq_schedule
>>>    -> ieee80211_next_txq(first)
>>>          -> inc_seq
>>>          -> delete from list
>>>          -> txq->seqno =3D local->seqno
>>>                                               ieee80211_tx/fast_xmit
>>>                                                  ->=20
>>> ieee80211_queue_skb
>>>                                                      ->
>>> ieee80211_schedule_txq(reset_seqno)
>>>                                                           -> list_add
>>>                                                           ->=20
>>> txqi->seqno
>>> =3D local->seqno - 1
>>>=20
>>> In above sequence, it is quite possible that the same txq will be
>>> served repeatedly and other txqs will be starved. am I right? IMHO
>>> seqno mechanism will not guarantee that txqs will be processed only
>>> once in an iteration.
>>=20
>> Yeah, ieee80211_queue_skb() shouldn't set reset_seqno; was=20
>> experimenting
>> with that, and guess I ended up picking the wrong value. Thanks for
>> pointing that out :)
>>=20
> A simple change in argument may break algo. What would be seqno of
> first packet of txq if queue_skb() isn't reset seqno?

It would be 0, which would be less than the current seqno in all cases
except just when the seqno counter wraps.

> I am fine in passing start of loop as arg to next_ntx(). But prefer to
> keep loop detecting within mac80211 itself by tracking txq same as
> ath10k. So that no change is needed in schedule_txq() arg list.
> thoughts?

If we remove the reset argument to schedule_txq we lose the ability for
the driver to signal that it is OK to dequeue another series of packets
from the same TXQ in the current scheduling round. I think that things
would mostly still work, but we may risk the hardware running idle for
short periods of time (in ath9k at least). I am not quite sure which
conditions this would happen under, though; and I haven't been able to
trigger it myself with my test hardware. So one approach would be to try
it out without the parameter and put it back later if it turns out to be
problematic...

>>>>>> Well, it could conceivably be done in a way that doesn't require
>>>>>> taking
>>>>>> the activeq_lock. Adding another STOP flag to the TXQ, for=20
>>>>>> instance.
>>>>>> From an API point of view I think that is more consistent with what
>>>>>> we
>>>>>> have already...
>>>>>>=20
>>>>>=20
>>>>> Make sense. ieee80211_txq_may_pull would be better place to decide
>>>>> whether given txq is allowed for transmission. It also makes drivers
>>>>> do not have to worry about deficit. Still I may need
>>>>> ieee80211_reorder_txq API after processing txq. isn't it?
>>>>=20
>>>> The way I was assuming this would work (and what ath9k does), is that=
=20
>>>> a
>>>> driver only operates on one TXQ at a time; so it can get that txq,
>>>> process it, and re-schedule it. In which case no other API is needed;
>>>> the rotating can be done in next_txq(), and schedule_txq() can insert
>>>> the txq back into the rotation as needed.
>>>>=20
>>>> However, it sounds like this is not how ath10k does things? See=20
>>>> below.
>>>>=20
>>> correct. The current rotation works only in push-only mode. i.e when
>>> firmware is not deciding txqs and the driver picks priority txq from
>>> active_txqs list. Unfortunately rotation won't work when the driver
>>> selects txq other than first in the list. In any case separate API
>>> needed for rotation when the driver is processing few packets from txq
>>> instead of all pending frames.
>>=20
>> Rotation is not dependent on the TXQ draining completely. Dequeueing a
>> few packets, then rescheduling the TXQ is fine.
>>=20
> The problem is that when the driver accesses txq directly, it wont
> call next_txq(). So the txq will not dequeued from list and
> schedule_txq() wont be effective. right?
>
> ieee80211_txq_may_pull() - check whether txq is allowed for tx_dequeue()
>                            that helps to keep deficit check in mac80211=20
> itself
>
> ieee80211_reorder_txq() - after dequeuing skb (in direct txq access),
>                            txq will be deleted from list and if there are=
=20
> pending
>                            frames, it will be requeued.

This could work, but reorder_txq() can't do the reordering from the
middle of the rotation. I.e, it can only reorder if the TXQ being passed
in is currently at the head of the list of active TXQs.

If we do go for this, I think it would make sense to use it everywhere.
I.e., next_txq() doesn't remove the queue, it just returns what is
currently at the head; and the driver will have to call reorder() after
processing a TXQ, instead of schedule_txq().

>>>> And if so, how does that interact with ath10k_mac_tx_push_pending()?
>>>> That function is basically doing the same thing that I explained=20
>>>> above
>>>> for ath9k; in the previous version of this patch series I modified=20
>>>> that
>>>> to use next_txq(). But is that a different TX path, or am I
>>>> misunderstanding you?
>>>>=20
>>>> If you could point me to which parts of the ath10k code I should be
>>>> looking at, that would be helpful as well :)
>>>>=20
>>> Depends on firmware htt_tx_mode (push/push_pull),
>>> ath10k_mac_tx_push_pending() downloads all/partial frames to firmware.
>>> Please take a look at ath10k_mac_tx_can_push() in push_pending(). Let
>>> me know If you need any other details.
>>=20
>> Right, so looking at this, it looks like the driver will loop through
>> all the available TXQs, trying to dequeue from each of them if
>> ath10k_mac_tx_can_push() returns true, right? This should actually work
>> fine with the next_txq() / schedule_txq() API. Without airtime fairness
>> that will just translate into basically what the driver is doing now,
>> and I don't think more API functions are needed, as long as that is the
>> only point in the driver that pushes packets to the device...
>>=20
> In push-only mode, this will work with next_txq() / schedule_txq() APIs.
> In ath10k, packets are downloaded to firmware in three places.
>
> wake_tx_queue()
> tx_push_pending()
> htt_rx_tx_fetch_ind() - do txq_lookup() and push_txq()
>
> the above mentioned new APIs are needed to take care of fetch_ind().

Ah! This was what I was missing; thanks!

Right, so with the current DRR scheduler, the only thing we can do with
this setup is throttle fetch_ind() if the TXQ isn't eligible for
scheduling. What happens if we do that? As far as I can tell,
fetch_ind() is triggered on tx completion from the same TXQ, right? So
if we throttle that, the driver falls back to the tx_push_pending()
rotation?

I think adding the throttling to tx_fetch_ind() would basically amount
to disabling that mechanism for most transmission scenarios...

>> With airtime fairness, what is going to happen is that the loop is only
>> going to get a single TXQ (the first one with a positive deficit), then
>> exit. Once that station has transmitted something and its deficit runs
>> negative, it'll get rotated and the next one will get a chance. So I
>> expect that airtime fairness will probably work, but MU-MIMO will
>> break...
>>=20
> Agree.. In your earlier series, you did similar changes in ath10k
> especially in wake_tx_queue and push_pending().
>
>> Don't think we can do MU-MIMO with a DRR airtime scheduler; we'll have
>> to replace it with something different. But I think the same next_txq()
>> / schedule_txq() API will work for that as well...
>>=20
> As mentioned above, have to take of fetch_ind(). All 10.4 based chips
> (QCA99x0, QCA9984, QCA9888, QCA4019, etc.) operates in push-pull mode,
> when the number of connected station increased. As target does not
> have enough memory for buffering frames for each station, it relied on
> host memory. ath10k driver can not identify that whether the received
> fetch_ind is for MU-MIMO or regular transmission.
>
> If we don't handle this case, then ath10k driver can not claim
> mac80211 ATF support. Agree that MU-MIMO won't work with DDR
> scheduler. and it will impact MU-MIMO performace in ath10k when
> mac80211 ATF is claimed by ath10k.

Yeah, so the question is if this is an acceptable tradeoff? Do you have
any idea how often MU-MIMO actually provides a benefit in the real
world?

One approach could be to implement the API and driver support with the
current DRR scheduler, and then evolve the scheduler into something that
can handle MU-MIMO afterwards. I have some ideas for this, but not sure
if they will work; and we want to avoid O(n) behaviour in the number of
associated stations.

-Toke
