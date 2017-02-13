Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43246 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750943AbdBMP2p (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 13 Feb 2017 10:28:45 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Felix Fietkau <nbd@nbd.name>
Cc: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath9k: clean up and fix ath_tx_count_airtime
References: <20170212132931.43510-1-nbd@nbd.name>
        <87lgtb5t9h.fsf@alrua-karlstad>
        <fbda67b4-7db6-984a-af50-610ec25d2fe0@nbd.name>
        <87d1entltw.fsf@kamboji.qca.qualcomm.com>
        <61049ab3-a15e-b1cf-ca1d-4840a8aa35d9@nbd.name>
Date: Mon, 13 Feb 2017 17:28:35 +0200
In-Reply-To: <61049ab3-a15e-b1cf-ca1d-4840a8aa35d9@nbd.name> (Felix Fietkau's
        message of "Sun, 12 Feb 2017 17:32:35 +0100")
Message-ID: <874lzyt8ik.fsf@kamboji.qca.qualcomm.com> (sfid-20170213_163010_679138_E41CA726)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau <nbd@nbd.name> writes:

> On 2017-02-12 17:28, Kalle Valo wrote:
>> Felix Fietkau <nbd@nbd.name> writes:
>>=20
>>> On 2017-02-12 16:22, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>>>> Felix Fietkau <nbd@nbd.name> writes:
>>>>=20
>>>>> ath_tx_count_airtime is doing a lot of unnecessary work:
>>>>>
>>>>> - Redundant station lookup
>>>>> - Redundant rcu_read_lock/unlock
>>>>> - Useless memcpy of bf->rates
>>>>> - Useless NULL check of bf->bf_mpdu
>>>>> - Redundant lookup of the skb tid
>>>>>
>>>>> Additionally, it tries to look up the mac80211 queue index from the t=
xq,
>>>>> which fails if the frame was delivered via the power save queue.
>>=20
>> What does this mean in practise, what's the user level impact?
>>=20
>>>>> This patch fixes all of these issues by passing down the right set of
>>>>> pointers instead of doing extra work
>>>>>
>>>>> Cc: stable@vger.kernel.org
>>>>> Fixes: 63fefa050477 ("ath9k: Introduce airtime fairness scheduling
>>>>> between stations")
>>>>> Signed-off-by: Felix Fietkau <nbd@nbd.name>
>>>>=20
>>>> Not sure if there's anything for stable to do with this; don't think t=
he
>>>> airtime fairness code has gone into a release yet? Otherwise:
>>>>=20
>>>> Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>
>>>
>>> I added this, because I'm not sure this patch will make it to 4.10 in
>>> time, since we're really close to a release. I assume this patch will
>>> probably go into 4.11.
>>=20
>> Yeah, to try to get a patch to 4.10 at this point needs to be a really
>> high profile regression. That is if Linus doesn't release 4.10 today, of
>> course.
>
> The symptoms are kernel crashes at least when operating in AP mode.
> It's pretty severe, so getting it into 4.10 would be preferable.

Indeed, that's pretty severe :) But better to mention that in the commit
log, I'll add that during commit.

Like Toke said, luckily 63fefa050477 is not in 4.10 so I'll push this to
4.11.

--=20
Kalle Valo
