Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:45182 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728101AbeGUBvp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 20 Jul 2018 21:51:45 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Fri, 20 Jul 2018 18:01:00 -0700
From: Rajkumar Manoharan <rmanohar@codeaurora.org>
To: =?UTF-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Cc: linux-wireless@vger.kernel.org,
        make-wifi-fast@lists.bufferbloat.net, Felix Fietkau <nbd@nbd.name>,
        linux-wireless-owner@vger.kernel.org
Subject: Re: [RFC v2 1/4] mac80211: Add TXQ scheduling API
In-Reply-To: <87wotr2trs.fsf@toke.dk>
References: <153115421866.7447.6363834356268564403.stgit@alrua-x1>
 <153115422491.7447.12479559048433925372.stgit@alrua-x1>
 <361a221dd15e44028fd35440df657a3d@codeaurora.org> <87lgahbisu.fsf@toke.dk>
 <8d8160cd9c804d1b00ba4e234c8f1520@codeaurora.org> <87k1q09hf1.fsf@toke.dk>
 <f8038c8ea281b365ec560cae0dd1ec0f@codeaurora.org> <87h8l39rv8.fsf@toke.dk>
 <01fe0f526e992563e3b1f450f8acc9e4@codeaurora.org> <87wotr2trs.fsf@toke.dk>
Message-ID: <25dc507c35c2dff356742626d026989d@codeaurora.org> (sfid-20180721_030131_480241_06139FE0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-07-19 07:18, Toke Høiland-Jørgensen wrote:
> Rajkumar Manoharan <rmanohar@codeaurora.org> writes:
> 
>> On 2018-07-13 06:39, Toke Høiland-Jørgensen wrote:
>>> Rajkumar Manoharan <rmanohar@codeaurora.org> writes:

>>> It is not generally predictable how many times this will loop before
>>> exiting...
>>> 
>> Agree.. It would be better If the driver does not worry about txq
>> sequence numbering. Perhaps one more API (ieee80211_first_txq) could
>> solve this. Will leave it to you.
> 
> That is basically what the second parameter to next_txq() does in the
> current patchset. It just needs to be renamed...
> 
Agree. As next_txq() increments seqno while starting loop for each AC,
It seems bit confusing. i.e A single ath_txq_schedule_all call will bump
schedule_seqno by 4. right?

Let assume below case where CPU1 is dequeuing skb from isr context and
CPU2 is enqueuing skbs into same txq.

CPU1                                          CPU2
----                                          ----
ath_txq_schedule
   -> ieee80211_next_txq(first)
         -> inc_seq
         -> delete from list
         -> txq->seqno = local->seqno
                                              ieee80211_tx/fast_xmit
                                                 -> ieee80211_queue_skb
                                                     -> 
ieee80211_schedule_txq(reset_seqno)
                                                          -> list_add
                                                          -> txqi->seqno 
= local->seqno - 1

In above sequence, it is quite possible that the same txq
will be served repeatedly and other txqs will be starved. am I right?
IMHO seqno mechanism will not guarantee that txqs will be processed
only once in an iteration.

[...]

>>> Well, it could conceivably be done in a way that doesn't require 
>>> taking
>>> the activeq_lock. Adding another STOP flag to the TXQ, for instance.
>>> From an API point of view I think that is more consistent with what 
>>> we
>>> have already...
>>> 
>> 
>> Make sense. ieee80211_txq_may_pull would be better place to decide
>> whether given txq is allowed for transmission. It also makes drivers
>> do not have to worry about deficit. Still I may need
>> ieee80211_reorder_txq API after processing txq. isn't it?
> 
> The way I was assuming this would work (and what ath9k does), is that a
> driver only operates on one TXQ at a time; so it can get that txq,
> process it, and re-schedule it. In which case no other API is needed;
> the rotating can be done in next_txq(), and schedule_txq() can insert
> the txq back into the rotation as needed.
> 
> However, it sounds like this is not how ath10k does things? See below.
> 
correct. The current rotation works only in push-only mode. i.e when 
firmware
is not deciding txqs and the driver picks priority txq from active_txqs 
list.
Unfortunately rotation won't work when the driver selects txq other than 
first
in the list. In any case separate API needed for rotation when the 
driver is
processing few packets from txq instead of all pending frames.

>> In push-pull method, driver reports to firmware that number of frames
>> queued for each tid per station by wake_tx_queue. Later firmware will
>> query N frames from each TID and after dequeue driver will update
>> remaining frames for that tid. In ATF case, when driver is not able to
>> dequeue frames, driver will simply update remaining frames. The
>> consecutive fetch_ind get opportunity to dequeue the frames. By This
>> way, transmission for serving client will be paused for a while and
>> opportunity will be given to others.
> 
> This sounds like the driver doesn't do anything other than notify the
> firmware that a txq has pending frames, and everything else is handled
> by the firmware? Is this the case?
> 

Correct. In push-pull method, DRR algorithm running in firmware and so
firmware decides txq.

> And if so, how does that interact with ath10k_mac_tx_push_pending()?
> That function is basically doing the same thing that I explained above
> for ath9k; in the previous version of this patch series I modified that
> to use next_txq(). But is that a different TX path, or am I
> misunderstanding you?
> 
> If you could point me to which parts of the ath10k code I should be
> looking at, that would be helpful as well :)
> 
Depends on firmware htt_tx_mode (push/push_pull), 
ath10k_mac_tx_push_pending()
downloads all/partial frames to firmware. Please take a look at 
ath10k_mac_tx_can_push()
in push_pending(). Let me know If you need any other details.

-Rajkumar
