Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47068 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387768AbeGMAp5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 12 Jul 2018 20:45:57 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Thu, 12 Jul 2018 17:33:54 -0700
From: Rajkumar Manoharan <rmanohar@codeaurora.org>
To: =?UTF-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Cc: linux-wireless@vger.kernel.org,
        make-wifi-fast@lists.bufferbloat.net, Felix Fietkau <nbd@nbd.name>,
        linux-wireless-owner@vger.kernel.org
Subject: Re: [RFC v2 1/4] mac80211: Add TXQ scheduling API
In-Reply-To: <87k1q09hf1.fsf@toke.dk>
References: <153115421866.7447.6363834356268564403.stgit@alrua-x1>
 <153115422491.7447.12479559048433925372.stgit@alrua-x1>
 <361a221dd15e44028fd35440df657a3d@codeaurora.org> <87lgahbisu.fsf@toke.dk>
 <8d8160cd9c804d1b00ba4e234c8f1520@codeaurora.org> <87k1q09hf1.fsf@toke.dk>
Message-ID: <f8038c8ea281b365ec560cae0dd1ec0f@codeaurora.org> (sfid-20180713_023358_777899_7C2514A4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-07-12 16:13, Toke Høiland-Jørgensen wrote:
> Rajkumar Manoharan <rmanohar@codeaurora.org> writes:
> 
>> On 2018-07-11 13:48, Toke Høiland-Jørgensen wrote:
>>> Rajkumar Manoharan <rmanohar@codeaurora.org> writes:
>>> 
>>>> On 2018-07-09 09:37, Toke Høiland-Jørgensen wrote:
>>>> [...]
>>>>> +/**
[...]

>>> Erm, how would this prevent an infinite loop? With this scheme, at 
>>> some
>>> point, ieee80211_next_txq() removes the last txq from activeq, and
>>> returns that. Then, when it is called again the next time the driver
>>> loops, it's back to the first case (activeq empty, waitq non-empty); 
>>> so
>>> it'll move waitq back as activeq and start over... Only the driver
>>> really knows when it is starting a logical "loop through all active
>>> TXQs".
>>> 
>> Oops.. My bad.. The idea is that ieee80211_next_txq process txq from
>> activeq only and keep processed txqs separately. Having single list
>> eventually needs tracking mechanism. The point is that once activeq
>> becomes empty, splice waitq list and return NULL. So that driver can
>> break from the loop.
>> 
>> ieee80211_next_txq
>>       - if activeq empty,
>>            - move waitq list into activeq
>>            - return NULL
>> 
>>       - if activeq not empty
>>            - fetch appropriate txq from activeq
>>            - remove txq from activeq list.
>> 
>>       - If txq found, return txq else return NULL
> 
> Right, so this would ensure the driver only sees each TXQ once *if it
> keeps looping*. But it doesn't necessarily; if the hardware queues fill
> up, for instance, it might abort earlier. In that case it would need to
> signal mac80211 that it is done for now, which is equivalent to
> signalling when it starts a scheduler round.
> 
Hmm... I thought driver will call ieee80211_schedule_txq when it runs 
out
of hardware descriptor and break the loop. The serving txq will be added
back to head of activeq list. no?

>>> Also, for airtime fairness, the queues are not scheduled strictly
>>> round-robin, so the dual-list scheme wouldn't work there either...
>>> 
>> As you know, ath10k driver will operate in two tx modes (push-only,
>> push-pull). These modes will be switched dynamically depends on
>> firmware load or resource availability. In push-pull mode, firmware
>> will query N number of frames for set of STA, TID.
> 
> Ah, so it will look up the TXQ without looping through the list of
> pending queues at all? Didn't realise that is what it's doing; yeah,
> that would be problematic for airtime fairness :)
> 
>> So the driver will directly dequeue N number of frames from given txq.
>> In this case txq ordering alone wont help. I am planning to add below
>> changes in exiting API and add new API ieee80211_reorder_txq.
>> 
>> ieee80211_txq_get_depth
>>       - return deficit status along with frm_cnt
>> 
>> ieee80211_reorder_txq
>>       - if txq deficit > 0
>>             - return;
>>       - if txq is last
>>              - return
>>       - delete txq from list
>>       - move it to tail
>>       - update deficit by quantum
>> 
>> ath10k_htt_rx_tx_fetch_ind
>>       - get txq deficit status
>>       - if txq deficit > 0
>>             - dequeue skb
>>       - else if deficit < 0
>>             - return NULL
>> 
>> Please share your thoughts.
> 
> Hmm, not sure exactly how this would work; seems a little complicated?
> Also, I'd rather if drivers were completely oblivious to the deficit;
> that is a bit of an implementation detail...
> 
Agree.. Initially I thought of adding deficit check in 
ieee80211_tx_dequeue.
But It will be overhead of taking activeq_lock for every skbs. Perhaps
it can be renamed as allowed_to_dequeue instead of deficit.

> We could have an ieee80211_txq_may_pull(); or maybe just have
> ieee80211_tx_dequeue() return NULL if the deficit is negative?
> 
As I said earlier, checking deficit for every skb will be an overhead.
It should be done once before accessing txq.

> the reasonable thing for the driver to do, then, would be to ask
> ieee80211_next_txq() for another TXQ to pull from if the current one
> doesn't work for whatever reason.
> 
> Would that work for push-pull mode?
> 
Not really. Driver shouldn't send other txq data instead of asked one.
In MU-MIMO, firmware will query N packets from given set of {STA,TID}.
So the driver not supposed to send other txq's data.

-Rajkumar
