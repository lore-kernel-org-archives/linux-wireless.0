Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33532 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388226AbeGXBp7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Jul 2018 21:45:59 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Mon, 23 Jul 2018 17:42:10 -0700
From: Rajkumar Manoharan <rmanohar@codeaurora.org>
To: =?UTF-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Cc: linux-wireless@vger.kernel.org,
        make-wifi-fast@lists.bufferbloat.net, Felix Fietkau <nbd@nbd.name>,
        linux-wireless-owner@vger.kernel.org
Subject: Re: [RFC v2 1/4] mac80211: Add TXQ scheduling API
In-Reply-To: <877elo48ea.fsf@toke.dk>
References: <153115421866.7447.6363834356268564403.stgit@alrua-x1>
 <153115422491.7447.12479559048433925372.stgit@alrua-x1>
 <361a221dd15e44028fd35440df657a3d@codeaurora.org> <87lgahbisu.fsf@toke.dk>
 <8d8160cd9c804d1b00ba4e234c8f1520@codeaurora.org> <87k1q09hf1.fsf@toke.dk>
 <f8038c8ea281b365ec560cae0dd1ec0f@codeaurora.org> <87h8l39rv8.fsf@toke.dk>
 <01fe0f526e992563e3b1f450f8acc9e4@codeaurora.org> <87wotr2trs.fsf@toke.dk>
 <25dc507c35c2dff356742626d026989d@codeaurora.org> <877elo48ea.fsf@toke.dk>
Message-ID: <9d2d6156f7bfd173ed5098f528d7ed49@codeaurora.org> (sfid-20180724_024216_138931_6760EF92)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-07-21 13:54, Toke Høiland-Jørgensen wrote:
> Rajkumar Manoharan <rmanohar@codeaurora.org> writes:
> 
>> On 2018-07-19 07:18, Toke Høiland-Jørgensen wrote:
>>> Rajkumar Manoharan <rmanohar@codeaurora.org> writes:
>>> 
>>>> On 2018-07-13 06:39, Toke Høiland-Jørgensen wrote:
>>>>> Rajkumar Manoharan <rmanohar@codeaurora.org> writes:
>> 
>>>>> It is not generally predictable how many times this will loop 
>>>>> before
>>>>> exiting...
>>>>> 
>>>> Agree.. It would be better If the driver does not worry about txq
>>>> sequence numbering. Perhaps one more API (ieee80211_first_txq) could
>>>> solve this. Will leave it to you.
>>> 
>>> That is basically what the second parameter to next_txq() does in the
>>> current patchset. It just needs to be renamed...
>>> 
>> Agree. As next_txq() increments seqno while starting loop for each AC,
>> It seems bit confusing. i.e A single ath_txq_schedule_all call will
>> bump schedule_seqno by 4. right?
> 
> Hmm, good point. Guess there should be one seqno per ac...
> 
I would prefer to keep separate list for each AC ;) Prepared one on top 
of
your earlier merged changes. Now it needs revisit.

>> Let assume below case where CPU1 is dequeuing skb from isr context and
>> CPU2 is enqueuing skbs into same txq.
>> 
>> CPU1                                          CPU2
>> ----                                          ----
>> ath_txq_schedule
>>    -> ieee80211_next_txq(first)
>>          -> inc_seq
>>          -> delete from list
>>          -> txq->seqno = local->seqno
>>                                               ieee80211_tx/fast_xmit
>>                                                  -> 
>> ieee80211_queue_skb
>>                                                      ->
>> ieee80211_schedule_txq(reset_seqno)
>>                                                           -> list_add
>>                                                           -> 
>> txqi->seqno
>> = local->seqno - 1
>> 
>> In above sequence, it is quite possible that the same txq will be
>> served repeatedly and other txqs will be starved. am I right? IMHO
>> seqno mechanism will not guarantee that txqs will be processed only
>> once in an iteration.
> 
> Yeah, ieee80211_queue_skb() shouldn't set reset_seqno; was 
> experimenting
> with that, and guess I ended up picking the wrong value. Thanks for
> pointing that out :)
> 
A simple change in argument may break algo. What would be seqno of first
packet of txq if queue_skb() isn't reset seqno? I am fine in passing 
start
of loop as arg to next_ntx(). But prefer to keep loop detecting within
mac80211 itself by tracking txq same as ath10k. So that no change is 
needed
in schedule_txq() arg list. thoughts?

>>>>> Well, it could conceivably be done in a way that doesn't require
>>>>> taking
>>>>> the activeq_lock. Adding another STOP flag to the TXQ, for 
>>>>> instance.
>>>>> From an API point of view I think that is more consistent with what
>>>>> we
>>>>> have already...
>>>>> 
>>>> 
>>>> Make sense. ieee80211_txq_may_pull would be better place to decide
>>>> whether given txq is allowed for transmission. It also makes drivers
>>>> do not have to worry about deficit. Still I may need
>>>> ieee80211_reorder_txq API after processing txq. isn't it?
>>> 
>>> The way I was assuming this would work (and what ath9k does), is that 
>>> a
>>> driver only operates on one TXQ at a time; so it can get that txq,
>>> process it, and re-schedule it. In which case no other API is needed;
>>> the rotating can be done in next_txq(), and schedule_txq() can insert
>>> the txq back into the rotation as needed.
>>> 
>>> However, it sounds like this is not how ath10k does things? See 
>>> below.
>>> 
>> correct. The current rotation works only in push-only mode. i.e when
>> firmware is not deciding txqs and the driver picks priority txq from
>> active_txqs list. Unfortunately rotation won't work when the driver
>> selects txq other than first in the list. In any case separate API
>> needed for rotation when the driver is processing few packets from txq
>> instead of all pending frames.
> 
> Rotation is not dependent on the TXQ draining completely. Dequeueing a
> few packets, then rescheduling the TXQ is fine.
> 
The problem is that when the driver accesses txq directly, it wont call
next_txq(). So the txq will not dequeued from list and schedule_txq() 
wont
be effective. right?

ieee80211_txq_may_pull() - check whether txq is allowed for tx_dequeue()
                           that helps to keep deficit check in mac80211 
itself

ieee80211_reorder_txq() - after dequeuing skb (in direct txq access),
                           txq will be deleted from list and if there are 
pending
                           frames, it will be requeued.

>>> And if so, how does that interact with ath10k_mac_tx_push_pending()?
>>> That function is basically doing the same thing that I explained 
>>> above
>>> for ath9k; in the previous version of this patch series I modified 
>>> that
>>> to use next_txq(). But is that a different TX path, or am I
>>> misunderstanding you?
>>> 
>>> If you could point me to which parts of the ath10k code I should be
>>> looking at, that would be helpful as well :)
>>> 
>> Depends on firmware htt_tx_mode (push/push_pull),
>> ath10k_mac_tx_push_pending() downloads all/partial frames to firmware.
>> Please take a look at ath10k_mac_tx_can_push() in push_pending(). Let
>> me know If you need any other details.
> 
> Right, so looking at this, it looks like the driver will loop through
> all the available TXQs, trying to dequeue from each of them if
> ath10k_mac_tx_can_push() returns true, right? This should actually work
> fine with the next_txq() / schedule_txq() API. Without airtime fairness
> that will just translate into basically what the driver is doing now,
> and I don't think more API functions are needed, as long as that is the
> only point in the driver that pushes packets to the device...
> 
In push-only mode, this will work with next_txq() / schedule_txq() APIs.
In ath10k, packets are downloaded to firmware in three places.

wake_tx_queue()
tx_push_pending()
htt_rx_tx_fetch_ind() - do txq_lookup() and push_txq()

the above mentioned new APIs are needed to take care of fetch_ind().

> With airtime fairness, what is going to happen is that the loop is only
> going to get a single TXQ (the first one with a positive deficit), then
> exit. Once that station has transmitted something and its deficit runs
> negative, it'll get rotated and the next one will get a chance. So I
> expect that airtime fairness will probably work, but MU-MIMO will
> break...
> 
Agree.. In your earlier series, you did similar changes in ath10k 
especially
in wake_tx_queue and push_pending().

> Don't think we can do MU-MIMO with a DRR airtime scheduler; we'll have
> to replace it with something different. But I think the same next_txq()
> / schedule_txq() API will work for that as well...
> 
As mentioned above, have to take of fetch_ind(). All 10.4 based chips 
(QCA99x0,
QCA9984, QCA9888, QCA4019, etc.) operates in push-pull mode, when the 
number of
connected station increased. As target does not have enough memory for 
buffering
frames for each station, it relied on host memory. ath10k driver can not 
identify
that whether the received fetch_ind is for MU-MIMO or regular 
transmission.

If we don't handle this case, then ath10k driver can not claim mac80211 
ATF support.
Agree that MU-MIMO won't work with DDR scheduler. and it will impact 
MU-MIMO performace
in ath10k when mac80211 ATF is claimed by ath10k.

-Rajkumar
