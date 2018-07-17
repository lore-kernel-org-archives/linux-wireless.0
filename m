Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:38086 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730002AbeGQBgf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 16 Jul 2018 21:36:35 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Mon, 16 Jul 2018 18:06:36 -0700
From: Rajkumar Manoharan <rmanohar@codeaurora.org>
To: =?UTF-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Cc: linux-wireless@vger.kernel.org,
        make-wifi-fast@lists.bufferbloat.net, Felix Fietkau <nbd@nbd.name>,
        linux-wireless-owner@vger.kernel.org
Subject: Re: [RFC v2 1/4] mac80211: Add TXQ scheduling API
In-Reply-To: <87h8l39rv8.fsf@toke.dk>
References: <153115421866.7447.6363834356268564403.stgit@alrua-x1>
 <153115422491.7447.12479559048433925372.stgit@alrua-x1>
 <361a221dd15e44028fd35440df657a3d@codeaurora.org> <87lgahbisu.fsf@toke.dk>
 <8d8160cd9c804d1b00ba4e234c8f1520@codeaurora.org> <87k1q09hf1.fsf@toke.dk>
 <f8038c8ea281b365ec560cae0dd1ec0f@codeaurora.org> <87h8l39rv8.fsf@toke.dk>
Message-ID: <01fe0f526e992563e3b1f450f8acc9e4@codeaurora.org> (sfid-20180717_030640_731457_31592F0C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-07-13 06:39, Toke Høiland-Jørgensen wrote:
> Rajkumar Manoharan <rmanohar@codeaurora.org> writes:
> 
[...]

>> Hmm... I thought driver will call ieee80211_schedule_txq when it runs
>> out of hardware descriptor and break the loop. The serving txq will be
>> added back to head of activeq list. no?
> 
> Yes, and then the next one will be serviced... It's basically:
> 
> while (!hwq_is_full()) {
>  txq = next_txq():
>  build_one_aggr(txq); // may or may not succeed
>  if (!empty(txq))
>    schedule_txq(txq);
> }
> 
> It is not generally predictable how many times this will loop before
> exiting...
> 
Agree.. It would be better If the driver does not worry about txq 
sequence
numbering. Perhaps one more API (ieee80211_first_txq) could solve this.
Will leave it to you.

>>>> 
>>>> ieee80211_txq_get_depth
>>>>       - return deficit status along with frm_cnt
>>>> 
>>>> ieee80211_reorder_txq
>>>>       - if txq deficit > 0
>>>>             - return;
>>>>       - if txq is last
>>>>              - return
>>>>       - delete txq from list
>>>>       - move it to tail
>>>>       - update deficit by quantum
>>>> 
>>>> ath10k_htt_rx_tx_fetch_ind
>>>>       - get txq deficit status
>>>>       - if txq deficit > 0
>>>>             - dequeue skb
>>>>       - else if deficit < 0
>>>>             - return NULL
>>>> 
>>>> Please share your thoughts.
>>> 
>>> Hmm, not sure exactly how this would work; seems a little 
>>> complicated?
>>> Also, I'd rather if drivers were completely oblivious to the deficit;
>>> that is a bit of an implementation detail...
>>> 
>> Agree.. Initially I thought of adding deficit check in
>> ieee80211_tx_dequeue.
>> But It will be overhead of taking activeq_lock for every skbs. Perhaps
>> it can be renamed as allowed_to_dequeue instead of deficit.
>> 
>>> We could have an ieee80211_txq_may_pull(); or maybe just have
>>> ieee80211_tx_dequeue() return NULL if the deficit is negative?
>>> 
>> As I said earlier, checking deficit for every skb will be an overhead.
>> It should be done once before accessing txq.
> 
> Well, it could conceivably be done in a way that doesn't require taking
> the activeq_lock. Adding another STOP flag to the TXQ, for instance.
> From an API point of view I think that is more consistent with what we
> have already...
> 

Make sense. ieee80211_txq_may_pull would be better place to decide 
whether
given txq is allowed for transmission. It also makes drivers do not have 
to
worry about deficit. Still I may need ieee80211_reorder_txq API after
processing txq. isn't it?

>>> the reasonable thing for the driver to do, then, would be to ask
>>> ieee80211_next_txq() for another TXQ to pull from if the current one
>>> doesn't work for whatever reason.
>>> 
>>> Would that work for push-pull mode?
>>> 
>> Not really. Driver shouldn't send other txq data instead of asked one.
> 
> I didn't necessarily mean immediately. As long as it does it 
> eventually.
> If a TXQ's deficit runs negative, that TXQ will not be allowed to send
> again until its deficit has been restored to positive through enough
> cycles of the loop in next_txq().
> 

Thats true. Are you suggesting to run the loop until the txq deficit 
becomes
positive?

>> In MU-MIMO, firmware will query N packets from given set of {STA,TID}.
>> So the driver not supposed to send other txq's data.
> 
> Hmm, it'll actually be interesting to see how the airtime fairness
> scheduler interacts with MU-MIMO. I'm not quite sure that it'll be in a
> good way; the DRR scheduler generally only restores one TXQ to positive
> deficit at a time, so it may be that MU-MIMO will break completely and
> we'll have to come up with another scheduling algorithm.
> 

In push-pull method, driver reports to firmware that number of frames
queued for each tid per station by wake_tx_queue. Later firmware will 
query
N frames from each TID and after dequeue driver will update remaining 
frames
for that tid. In ATF case, when driver is not able to dequeue frames, 
driver
will simply update remaining frames. The consecutive fetch_ind get 
opportunity
to dequeue the frames. By This way, transmission for serving client will 
be paused
for a while and opportunity will be given to others.

-Rajkumar
