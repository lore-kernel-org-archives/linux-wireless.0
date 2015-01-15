Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:52741 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094AbbAOHi4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Jan 2015 02:38:56 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Sujith Manoharan <sujith@msujith.org>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: Make HTT fill size configurable
References: <1420432796-10765-1-git-send-email-sujith@msujith.org>
	<87r3uy4t9y.fsf@kamboji.qca.qualcomm.com>
	<21685.35179.110539.780864@gargle.gargle.HOWL>
Date: Thu, 15 Jan 2015 09:38:44 +0200
In-Reply-To: <21685.35179.110539.780864@gargle.gargle.HOWL> (Sujith
	Manoharan's message of "Wed, 14 Jan 2015 02:38:59 +0530")
Message-ID: <87bnm01ojf.fsf@kamboji.qca.qualcomm.com> (sfid-20150115_083859_963161_CDBADDC9)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sujith Manoharan <sujith@msujith.org> writes:

> Kalle Valo wrote:
>> I'm not sure if I really like this path of having interfaces to
>> configure driver internals. I suspect that if we add this, we will have
>> even more later. It's a lot more documenting for us and more work to the
>> users to understand what parameters they should use. Also this means
>> that testing will be more challenging as people will use different
>> values and results won't be comparable.
>> 
>> Isn't there any other way to solve the problem? Like automatically
>> changing the value somehow (no idea how) or some other means?
>
> We are limiting performance by restricting the fill size. A user
> will just use the default, which is still the same and remains
> unchanged. But, having a way to adjust this based on the platform
> seems reasonable to me and I think trying to change this value dynamically
> is overkill.

Did you read at all what I wrote above? For example, what if we later
don't actually use ATH10K_HTT_MAX_NUM_REFILL anymore?

And the fundamental problem is that I still don't know what fill value
you think is the best to use here, and that means neither will the
users. That's why the values need to be within ath10k, not expose driver
internals and use some magic numbers which are not available anywhere.

>> Or if nothing else helps, a crazy idea is to have some sort of platform
>> profile parameter:
>> 
>> 0 = auto
>> 1 = slow
>> 2 = fast
>> 3 = superfast (x86)
>> 
>> And then we would have preset values (not just htt_fill_size) within
>> ath10k and they get chosen based on the profile configured.
>
> I don't think a network driver should limit its performance with
> such profiles. Moreover, x86 can be slow too - at least, my 4 year
> old machine is. :-)

We are not limitting anything more. That's not any different from what
your patch does, just that the parameter name is different and the user
doesn't have direct access to the internal parameter. Let me explain a
bit more how that would work in this HTT fill case:

profile 0 (auto):
profile 1 (slow):
        htt_fill_size = ATH10K_HTT_MAX_NUM_REFILL
        break:
profile 2 (fast):
        htt_fill_size = 77 /* or whatever */
        break;

So in this method the user can still choose optimal settings for a
certain platform, I assume AP148 in this case, and not know about driver
internals. And if there are more parameters we need to change in the
future, we can use the same modparam to change that as well.

-- 
Kalle Valo
