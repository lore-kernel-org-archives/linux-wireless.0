Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:44425 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731008AbeGSPCZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 Jul 2018 11:02:25 -0400
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Rajkumar Manoharan <rmanohar@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        make-wifi-fast@lists.bufferbloat.net, Felix Fietkau <nbd@nbd.name>,
        linux-wireless-owner@vger.kernel.org
Subject: Re: [RFC v2 1/4] mac80211: Add TXQ scheduling API
In-Reply-To: <01fe0f526e992563e3b1f450f8acc9e4@codeaurora.org>
References: <153115421866.7447.6363834356268564403.stgit@alrua-x1> <153115422491.7447.12479559048433925372.stgit@alrua-x1> <361a221dd15e44028fd35440df657a3d@codeaurora.org> <87lgahbisu.fsf@toke.dk> <8d8160cd9c804d1b00ba4e234c8f1520@codeaurora.org> <87k1q09hf1.fsf@toke.dk> <f8038c8ea281b365ec560cae0dd1ec0f@codeaurora.org> <87h8l39rv8.fsf@toke.dk> <01fe0f526e992563e3b1f450f8acc9e4@codeaurora.org>
Date: Thu, 19 Jul 2018 16:18:47 +0200
Message-ID: <87wotr2trs.fsf@toke.dk> (sfid-20180719_161919_584680_54F64318)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan <rmanohar@codeaurora.org> writes:

> On 2018-07-13 06:39, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Rajkumar Manoharan <rmanohar@codeaurora.org> writes:
>>=20
> [...]
>
>>> Hmm... I thought driver will call ieee80211_schedule_txq when it runs
>>> out of hardware descriptor and break the loop. The serving txq will be
>>> added back to head of activeq list. no?
>>=20
>> Yes, and then the next one will be serviced... It's basically:
>>=20
>> while (!hwq_is_full()) {
>>  txq =3D next_txq():
>>  build_one_aggr(txq); // may or may not succeed
>>  if (!empty(txq))
>>    schedule_txq(txq);
>> }
>>=20
>> It is not generally predictable how many times this will loop before
>> exiting...
>>=20
> Agree.. It would be better If the driver does not worry about txq
> sequence numbering. Perhaps one more API (ieee80211_first_txq) could
> solve this. Will leave it to you.

That is basically what the second parameter to next_txq() does in the
current patchset. It just needs to be renamed...

>>>>>=20
>>>>> ieee80211_txq_get_depth
>>>>>       - return deficit status along with frm_cnt
>>>>>=20
>>>>> ieee80211_reorder_txq
>>>>>       - if txq deficit > 0
>>>>>             - return;
>>>>>       - if txq is last
>>>>>              - return
>>>>>       - delete txq from list
>>>>>       - move it to tail
>>>>>       - update deficit by quantum
>>>>>=20
>>>>> ath10k_htt_rx_tx_fetch_ind
>>>>>       - get txq deficit status
>>>>>       - if txq deficit > 0
>>>>>             - dequeue skb
>>>>>       - else if deficit < 0
>>>>>             - return NULL
>>>>>=20
>>>>> Please share your thoughts.
>>>>=20
>>>> Hmm, not sure exactly how this would work; seems a little=20
>>>> complicated?
>>>> Also, I'd rather if drivers were completely oblivious to the deficit;
>>>> that is a bit of an implementation detail...
>>>>=20
>>> Agree.. Initially I thought of adding deficit check in
>>> ieee80211_tx_dequeue.
>>> But It will be overhead of taking activeq_lock for every skbs. Perhaps
>>> it can be renamed as allowed_to_dequeue instead of deficit.
>>>=20
>>>> We could have an ieee80211_txq_may_pull(); or maybe just have
>>>> ieee80211_tx_dequeue() return NULL if the deficit is negative?
>>>>=20
>>> As I said earlier, checking deficit for every skb will be an overhead.
>>> It should be done once before accessing txq.
>>=20
>> Well, it could conceivably be done in a way that doesn't require taking
>> the activeq_lock. Adding another STOP flag to the TXQ, for instance.
>> From an API point of view I think that is more consistent with what we
>> have already...
>>=20
>
> Make sense. ieee80211_txq_may_pull would be better place to decide
> whether given txq is allowed for transmission. It also makes drivers
> do not have to worry about deficit. Still I may need
> ieee80211_reorder_txq API after processing txq. isn't it?

The way I was assuming this would work (and what ath9k does), is that a
driver only operates on one TXQ at a time; so it can get that txq,
process it, and re-schedule it. In which case no other API is needed;
the rotating can be done in next_txq(), and schedule_txq() can insert
the txq back into the rotation as needed.

However, it sounds like this is not how ath10k does things? See below.

>>>> the reasonable thing for the driver to do, then, would be to ask
>>>> ieee80211_next_txq() for another TXQ to pull from if the current one
>>>> doesn't work for whatever reason.
>>>>=20
>>>> Would that work for push-pull mode?
>>>>=20
>>> Not really. Driver shouldn't send other txq data instead of asked one.
>>=20
>> I didn't necessarily mean immediately. As long as it does it=20
>> eventually.
>> If a TXQ's deficit runs negative, that TXQ will not be allowed to send
>> again until its deficit has been restored to positive through enough
>> cycles of the loop in next_txq().
>>=20
>
> Thats true. Are you suggesting to run the loop until the txq deficit
> becomes positive?

Yeah, or rather until the first station with a positive deficit is
found.

>>> In MU-MIMO, firmware will query N packets from given set of {STA,TID}.
>>> So the driver not supposed to send other txq's data.
>>=20
>> Hmm, it'll actually be interesting to see how the airtime fairness
>> scheduler interacts with MU-MIMO. I'm not quite sure that it'll be in a
>> good way; the DRR scheduler generally only restores one TXQ to positive
>> deficit at a time, so it may be that MU-MIMO will break completely and
>> we'll have to come up with another scheduling algorithm.
>>=20
>
> In push-pull method, driver reports to firmware that number of frames
> queued for each tid per station by wake_tx_queue. Later firmware will
> query N frames from each TID and after dequeue driver will update
> remaining frames for that tid. In ATF case, when driver is not able to
> dequeue frames, driver will simply update remaining frames. The
> consecutive fetch_ind get opportunity to dequeue the frames. By This
> way, transmission for serving client will be paused for a while and
> opportunity will be given to others.

This sounds like the driver doesn't do anything other than notify the
firmware that a txq has pending frames, and everything else is handled
by the firmware? Is this the case?

And if so, how does that interact with ath10k_mac_tx_push_pending()?
That function is basically doing the same thing that I explained above
for ath9k; in the previous version of this patch series I modified that
to use next_txq(). But is that a different TX path, or am I
misunderstanding you?

If you could point me to which parts of the ath10k code I should be
looking at, that would be helpful as well :)

-Toke
