Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:60713 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727767AbeGUVsc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 21 Jul 2018 17:48:32 -0400
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Rajkumar Manoharan <rmanohar@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        make-wifi-fast@lists.bufferbloat.net, Felix Fietkau <nbd@nbd.name>,
        linux-wireless-owner@vger.kernel.org
Subject: Re: [RFC v2 1/4] mac80211: Add TXQ scheduling API
In-Reply-To: <25dc507c35c2dff356742626d026989d@codeaurora.org>
References: <153115421866.7447.6363834356268564403.stgit@alrua-x1> <153115422491.7447.12479559048433925372.stgit@alrua-x1> <361a221dd15e44028fd35440df657a3d@codeaurora.org> <87lgahbisu.fsf@toke.dk> <8d8160cd9c804d1b00ba4e234c8f1520@codeaurora.org> <87k1q09hf1.fsf@toke.dk> <f8038c8ea281b365ec560cae0dd1ec0f@codeaurora.org> <87h8l39rv8.fsf@toke.dk> <01fe0f526e992563e3b1f450f8acc9e4@codeaurora.org> <87wotr2trs.fsf@toke.dk> <25dc507c35c2dff356742626d026989d@codeaurora.org>
Date: Sat, 21 Jul 2018 22:54:21 +0200
Message-ID: <877elo48ea.fsf@toke.dk> (sfid-20180721_225434_403759_51A99068)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan <rmanohar@codeaurora.org> writes:

> On 2018-07-19 07:18, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Rajkumar Manoharan <rmanohar@codeaurora.org> writes:
>>=20
>>> On 2018-07-13 06:39, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>>>> Rajkumar Manoharan <rmanohar@codeaurora.org> writes:
>
>>>> It is not generally predictable how many times this will loop before
>>>> exiting...
>>>>=20
>>> Agree.. It would be better If the driver does not worry about txq
>>> sequence numbering. Perhaps one more API (ieee80211_first_txq) could
>>> solve this. Will leave it to you.
>>=20
>> That is basically what the second parameter to next_txq() does in the
>> current patchset. It just needs to be renamed...
>>=20
> Agree. As next_txq() increments seqno while starting loop for each AC,
> It seems bit confusing. i.e A single ath_txq_schedule_all call will
> bump schedule_seqno by 4. right?

Hmm, good point. Guess there should be one seqno per ac...

> Let assume below case where CPU1 is dequeuing skb from isr context and
> CPU2 is enqueuing skbs into same txq.
>
> CPU1                                          CPU2
> ----                                          ----
> ath_txq_schedule
>    -> ieee80211_next_txq(first)
>          -> inc_seq
>          -> delete from list
>          -> txq->seqno =3D local->seqno
>                                               ieee80211_tx/fast_xmit
>                                                  -> ieee80211_queue_skb
>                                                      ->=20
> ieee80211_schedule_txq(reset_seqno)
>                                                           -> list_add
>                                                           -> txqi->seqno=
=20
> =3D local->seqno - 1
>
> In above sequence, it is quite possible that the same txq will be
> served repeatedly and other txqs will be starved. am I right? IMHO
> seqno mechanism will not guarantee that txqs will be processed only
> once in an iteration.

Yeah, ieee80211_queue_skb() shouldn't set reset_seqno; was experimenting
with that, and guess I ended up picking the wrong value. Thanks for
pointing that out :)

>>>> Well, it could conceivably be done in a way that doesn't require=20
>>>> taking
>>>> the activeq_lock. Adding another STOP flag to the TXQ, for instance.
>>>> From an API point of view I think that is more consistent with what=20
>>>> we
>>>> have already...
>>>>=20
>>>=20
>>> Make sense. ieee80211_txq_may_pull would be better place to decide
>>> whether given txq is allowed for transmission. It also makes drivers
>>> do not have to worry about deficit. Still I may need
>>> ieee80211_reorder_txq API after processing txq. isn't it?
>>=20
>> The way I was assuming this would work (and what ath9k does), is that a
>> driver only operates on one TXQ at a time; so it can get that txq,
>> process it, and re-schedule it. In which case no other API is needed;
>> the rotating can be done in next_txq(), and schedule_txq() can insert
>> the txq back into the rotation as needed.
>>=20
>> However, it sounds like this is not how ath10k does things? See below.
>>=20
> correct. The current rotation works only in push-only mode. i.e when
> firmware is not deciding txqs and the driver picks priority txq from
> active_txqs list. Unfortunately rotation won't work when the driver
> selects txq other than first in the list. In any case separate API
> needed for rotation when the driver is processing few packets from txq
> instead of all pending frames.

Rotation is not dependent on the TXQ draining completely. Dequeueing a
few packets, then rescheduling the TXQ is fine.

>> And if so, how does that interact with ath10k_mac_tx_push_pending()?
>> That function is basically doing the same thing that I explained above
>> for ath9k; in the previous version of this patch series I modified that
>> to use next_txq(). But is that a different TX path, or am I
>> misunderstanding you?
>>=20
>> If you could point me to which parts of the ath10k code I should be
>> looking at, that would be helpful as well :)
>>=20
> Depends on firmware htt_tx_mode (push/push_pull),
> ath10k_mac_tx_push_pending() downloads all/partial frames to firmware.
> Please take a look at ath10k_mac_tx_can_push() in push_pending(). Let
> me know If you need any other details.

Right, so looking at this, it looks like the driver will loop through
all the available TXQs, trying to dequeue from each of them if
ath10k_mac_tx_can_push() returns true, right? This should actually work
fine with the next_txq() / schedule_txq() API. Without airtime fairness
that will just translate into basically what the driver is doing now,
and I don't think more API functions are needed, as long as that is the
only point in the driver that pushes packets to the device...

With airtime fairness, what is going to happen is that the loop is only
going to get a single TXQ (the first one with a positive deficit), then
exit. Once that station has transmitted something and its deficit runs
negative, it'll get rotated and the next one will get a chance. So I
expect that airtime fairness will probably work, but MU-MIMO will
break...

Don't think we can do MU-MIMO with a DRR airtime scheduler; we'll have
to replace it with something different. But I think the same next_txq()
/ schedule_txq() API will work for that as well...

-Toke
