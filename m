Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:20433 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219AbbAOIJf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Jan 2015 03:09:35 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Sujith Manoharan <sujith@msujith.org>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: Make HTT fill size configurable
References: <1420432796-10765-1-git-send-email-sujith@msujith.org>
	<87r3uy4t9y.fsf@kamboji.qca.qualcomm.com>
	<21685.35179.110539.780864@gargle.gargle.HOWL>
	<87bnm01ojf.fsf@kamboji.qca.qualcomm.com>
	<21687.29026.962216.812998@gargle.gargle.HOWL>
Date: Thu, 15 Jan 2015 10:09:22 +0200
In-Reply-To: <21687.29026.962216.812998@gargle.gargle.HOWL> (Sujith
	Manoharan's message of "Thu, 15 Jan 2015 13:20:58 +0530")
Message-ID: <87vbk8zcr1.fsf@kamboji.qca.qualcomm.com> (sfid-20150115_090939_139338_E5F7A85C)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sujith Manoharan <sujith@msujith.org> writes:

> Kalle Valo wrote:
>> Did you read at all what I wrote above? For example, what if we later
>> don't actually use ATH10K_HTT_MAX_NUM_REFILL anymore?
>> 
>> And the fundamental problem is that I still don't know what fill value
>> you think is the best to use here, and that means neither will the
>> users. That's why the values need to be within ath10k, not expose driver
>> internals and use some magic numbers which are not available anywhere.
>
> What magic numbers ?
>
> How is 16 less a magic number than 128 or 96 or the original 1000 ?

Magic number for the _user_. With an user I mean an engineer installing
ath10k to his device/distro/whatever.

Of course an ath10k developer will understand the internal numbers
inside out, but we are not here talking about ath10k developers.

>> We are not limitting anything more. That's not any different from what
>> your patch does, just that the parameter name is different and the user
>> doesn't have direct access to the internal parameter. Let me explain a
>> bit more how that would work in this HTT fill case:
>> 
>> profile 0 (auto):
>> profile 1 (slow):
>>         htt_fill_size = ATH10K_HTT_MAX_NUM_REFILL
>>         break:
>> profile 2 (fast):
>>         htt_fill_size = 77 /* or whatever */
>>         break;
>> 
>> So in this method the user can still choose optimal settings for a
>> certain platform, I assume AP148 in this case, and not know about driver
>> internals. And if there are more parameters we need to change in the
>> future, we can use the same modparam to change that as well.
>
> You seem to be fixated on some imaginary user that is going to be
> confused by a module parameter.

Imaginary? You should do some IT support sometime to see how it really
is like there :) People have even problems installing firmware images.

> I don't see how adding more complexity by adding profiles and such
> is going to make a user less confused.

Because it's easy to document three values, or actually two in this
case. I STILL don't know what values you think people should use with
the htt_fill parameter.

But of course I would prefer that there would be no need to configure
any module parameters at all and ath10k would work in optimal speed out
of box. That's what we should strive for.

-- 
Kalle Valo
