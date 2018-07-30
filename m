Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:46510 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731165AbeG3Wqz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 30 Jul 2018 18:46:55 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Mon, 30 Jul 2018 14:10:04 -0700
From: Rajkumar Manoharan <rmanohar@codeaurora.org>
To: =?UTF-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Cc: linux-wireless@vger.kernel.org,
        make-wifi-fast@lists.bufferbloat.net, Felix Fietkau <nbd@nbd.name>,
        linux-wireless-owner@vger.kernel.org
Subject: Re: [RFC v2 1/4] mac80211: Add TXQ scheduling API
In-Reply-To: <87k1pk3n7b.fsf@toke.dk>
References: <153115421866.7447.6363834356268564403.stgit@alrua-x1>
 <153115422491.7447.12479559048433925372.stgit@alrua-x1>
 <361a221dd15e44028fd35440df657a3d@codeaurora.org> <87lgahbisu.fsf@toke.dk>
 <8d8160cd9c804d1b00ba4e234c8f1520@codeaurora.org> <87k1q09hf1.fsf@toke.dk>
 <f8038c8ea281b365ec560cae0dd1ec0f@codeaurora.org> <87h8l39rv8.fsf@toke.dk>
 <01fe0f526e992563e3b1f450f8acc9e4@codeaurora.org> <87wotr2trs.fsf@toke.dk>
 <25dc507c35c2dff356742626d026989d@codeaurora.org> <877elo48ea.fsf@toke.dk>
 <9d2d6156f7bfd173ed5098f528d7ed49@codeaurora.org> <87k1pk3n7b.fsf@toke.dk>
Message-ID: <aaa234780cad834c2ca0a36d7a007571@codeaurora.org> (sfid-20180730_231008_870631_17F8EB6A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-07-24 04:08, Toke Høiland-Jørgensen wrote:
> Rajkumar Manoharan <rmanohar@codeaurora.org> writes:
> 

Sorry for the late reply.

>> I would prefer to keep separate list for each AC ;) Prepared one on
>> top of your earlier merged changes. Now it needs revisit.
> 
> Fine with me. Only reason I used a single list + the filtering 
> mechanism
> was to keep things compatible with ath10k ;)
> 
Thanks :). If so, I will defer the per-ac-list later.

>> A simple change in argument may break algo. What would be seqno of
>> first packet of txq if queue_skb() isn't reset seqno?
> 
> It would be 0, which would be less than the current seqno in all cases
> except just when the seqno counter wraps.
> 

One point should be mentioned in comment section of next_txq() that
the driver has to ensure that next_txq() iteration is serialized i.e
no parallel txq traversal are encouraged. Though txqs_list is maintained
in mac80211, parallel iteration may change the behavior. For example
I thought of get rid of txqs_lock in ath10k as txqs_list is moved to 
mac80211.
But it is still needed. right?

>> I am fine in passing start of loop as arg to next_ntx(). But prefer to
>> keep loop detecting within mac80211 itself by tracking txq same as
>> ath10k. So that no change is needed in schedule_txq() arg list.
>> thoughts?
> 
> If we remove the reset argument to schedule_txq we lose the ability for
> the driver to signal that it is OK to dequeue another series of packets
> from the same TXQ in the current scheduling round. I think that things
> would mostly still work, but we may risk the hardware running idle for
> short periods of time (in ath9k at least). I am not quite sure which
> conditions this would happen under, though; and I haven't been able to
> trigger it myself with my test hardware. So one approach would be to 
> try
> it out without the parameter and put it back later if it turns out to 
> be
> problematic...
> 
Agree. Based on experiments, additional arguments can be extended later.
Currently in ath10k, txqs are added back to list when there are pending
frames and are not considered again in the same iteration. It will be
processed in next loop.


>> ieee80211_reorder_txq() - after dequeuing skb (in direct txq access),
>>                            txq will be deleted from list and if there 
>> are
>> pending
>>                            frames, it will be requeued.
> 
> This could work, but reorder_txq() can't do the reordering from the
> middle of the rotation. I.e, it can only reorder if the TXQ being 
> passed
> in is currently at the head of the list of active TXQs.
> 
> If we do go for this, I think it would make sense to use it everywhere.
> I.e., next_txq() doesn't remove the queue, it just returns what is
> currently at the head; and the driver will have to call reorder() after
> processing a TXQ, instead of schedule_txq().
> 
Hmm.. reorder_txq() API may not needed. Calling next_txq() takes care of
reordering list though the driver is accessing txqs directly.

And also as we discussed earlier, I will drop txq_may_pull() API and 
move
the deficit check under tx_dequeue().

> Right, so with the current DRR scheduler, the only thing we can do with
> this setup is throttle fetch_ind() if the TXQ isn't eligible for
> scheduling. What happens if we do that? As far as I can tell,
> fetch_ind() is triggered on tx completion from the same TXQ, right? So
> if we throttle that, the driver falls back to the tx_push_pending()
> rotation?
> 
The fallback push will be effective only if current queued count is 
lesser than
allowed. Otherwise push_pending() won't be effective even after 
throttling
fetch_ind(). The same txq will be served in further fetch_ind() when the 
driver
reports to firmware about pending counts.

> I think adding the throttling to tx_fetch_ind() would basically amount
> to disabling that mechanism for most transmission scenarios...
> 
If you don't throttle fetch_ind(), fairness won't be effective. Also I 
am
thinking of reordering push_pending() after processing fetch_ind_q. This 
will
give enough chances for fetch_ind().

>> If we don't handle this case, then ath10k driver can not claim
>> mac80211 ATF support. Agree that MU-MIMO won't work with DDR
>> scheduler. and it will impact MU-MIMO performace in ath10k when
>> mac80211 ATF is claimed by ath10k.
> 
> Yeah, so the question is if this is an acceptable tradeoff? Do you have
> any idea how often MU-MIMO actually provides a benefit in the real
> world?
> 
Hmm.. We have some criteria of ~1.9 gain in Mu-MIMO test cases with 50 
11ac clients.

-Rajkumar
