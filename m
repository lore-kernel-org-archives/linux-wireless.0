Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:42220 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751261AbdBLQka (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 12 Feb 2017 11:40:30 -0500
Subject: Re: [PATCH] ath9k: clean up and fix ath_tx_count_airtime
To: =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@toke.dk>
References: <20170212132931.43510-1-nbd@nbd.name>
 <87lgtb5t9h.fsf@alrua-karlstad>
 <fbda67b4-7db6-984a-af50-610ec25d2fe0@nbd.name>
 <87d1entltw.fsf@kamboji.qca.qualcomm.com>
 <61049ab3-a15e-b1cf-ca1d-4840a8aa35d9@nbd.name>
 <87efz35pt4.fsf@alrua-karlstad>
Cc: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org
From: Felix Fietkau <nbd@nbd.name>
Message-ID: <e8a1dd5f-79a2-28b4-6cc7-fc1b28a6f327@nbd.name> (sfid-20170212_174033_148136_53E102D8)
Date: Sun, 12 Feb 2017 17:40:27 +0100
MIME-Version: 1.0
In-Reply-To: <87efz35pt4.fsf@alrua-karlstad>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2017-02-12 17:36, Toke Høiland-Jørgensen wrote:
> Felix Fietkau <nbd@nbd.name> writes:
> 
>> On 2017-02-12 17:28, Kalle Valo wrote:
>>> Felix Fietkau <nbd@nbd.name> writes:
>>> 
>>>> On 2017-02-12 16:22, Toke Høiland-Jørgensen wrote:
>>>>> Felix Fietkau <nbd@nbd.name> writes:
>>>>> 
>>>>>> ath_tx_count_airtime is doing a lot of unnecessary work:
>>>>>>
>>>>>> - Redundant station lookup
>>>>>> - Redundant rcu_read_lock/unlock
>>>>>> - Useless memcpy of bf->rates
>>>>>> - Useless NULL check of bf->bf_mpdu
>>>>>> - Redundant lookup of the skb tid
>>>>>>
>>>>>> Additionally, it tries to look up the mac80211 queue index from the txq,
>>>>>> which fails if the frame was delivered via the power save queue.
>>> 
>>> What does this mean in practise, what's the user level impact?
>>> 
>>>>>> This patch fixes all of these issues by passing down the right set of
>>>>>> pointers instead of doing extra work
>>>>>>
>>>>>> Cc: stable@vger.kernel.org
>>>>>> Fixes: 63fefa050477 ("ath9k: Introduce airtime fairness scheduling
>>>>>> between stations")
>>>>>> Signed-off-by: Felix Fietkau <nbd@nbd.name>
>>>>> 
>>>>> Not sure if there's anything for stable to do with this; don't think the
>>>>> airtime fairness code has gone into a release yet? Otherwise:
>>>>> 
>>>>> Acked-by: Toke Høiland-Jørgensen <toke@toke.dk>
>>>>
>>>> I added this, because I'm not sure this patch will make it to 4.10 in
>>>> time, since we're really close to a release. I assume this patch will
>>>> probably go into 4.11.
>>> 
>>> Yeah, to try to get a patch to 4.10 at this point needs to be a really
>>> high profile regression. That is if Linus doesn't release 4.10 today, of
>>> course.
>> The symptoms are kernel crashes at least when operating in AP mode.
>> It's pretty severe, so getting it into 4.10 would be preferable.
> 
> I'm confused now. Wasn't the airtime fairness patch queued for 4.11?
I'll check again, maybe I got the git-describe output wrong.

- Felix
