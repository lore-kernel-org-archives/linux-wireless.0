Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:47990 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750969AbeBZVjJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Feb 2018 16:39:09 -0500
Subject: Re: [PATCH] ath9k: break out of irq handler after 5 jiffies
To: Johannes Berg <johannes@sipsolutions.net>,
        Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
References: <1517958324-13536-1-git-send-email-greearb@candelatech.com>
 <2129dcdd-5963-c4da-600e-83f8c394d05c@nbd.name>
 <1518000956.3124.7.camel@sipsolutions.net>
 <2086dc09-485c-2b7f-de74-35ab2e0dfc4c@candelatech.com>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <d787d749-bce7-1785-c90a-41dd4355a717@candelatech.com> (sfid-20180226_223913_363311_0655DC1F)
Date: Mon, 26 Feb 2018 13:39:06 -0800
MIME-Version: 1.0
In-Reply-To: <2086dc09-485c-2b7f-de74-35ab2e0dfc4c@candelatech.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/07/2018 07:39 AM, Ben Greear wrote:
>
>
> On 02/07/2018 02:55 AM, Johannes Berg wrote:
>> On Wed, 2018-02-07 at 10:16 +0100, Felix Fietkau wrote:
>>> On 2018-02-07 00:05, greearb@candelatech.com wrote:
>>>> From: Ben Greear <greearb@candelatech.com>
>>>>
>>>> In case where the system is sluggish, we should probably break out
>>>> early.  Maybe this will fix issues where the OS thinks the IRQ handler
>>>> is not responding and disables the IRQ because 'nobody cared'
>>>>
>>>> Signed-off-by: Ben Greear <greearb@candelatech.com>
>>>
>>> 5 jiffies as a hardcoded value is a bad idea, since it produces
>>> different behavior based on CONFIG_HZ.
>
> I figured that was a benefit since it would run shorter duration on systems with
> a faster HZ clock.
>
>>
>> Also, err, NAPI? Or is something else is going on here?
>
> I don't really know, but part of my test was running traffic while creating
> 1200 stations, so likely there were lots of higher-level lock contention that
> slowed down sending pkts up the stack.
>
> I got a bunch of errors about IRQs being ignored because nobody cared.  I noticed
> that the ath9k loop could handle up to 500 or so frames, and that seemed like too
> many for my particular test case.
>
> Once I put in this patch, I did not see the 'nobody cared' error again.
>
> There could easily be a better fix.  If you all want me to use a fixed time instead
> of HZ, then please suggest a value.  I was testing with HZ of 1000, btw.

Hello,

I don't mind changing this patch, but I could use some guidance as to what
values you all want me to use.

Should I use a millisecond based clock instead of jiffies?

What time duration do you want if 5 Jiffies (or 5ms) is not desired?

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
