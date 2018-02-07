Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:37870 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754412AbeBGPjV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Feb 2018 10:39:21 -0500
Subject: Re: [PATCH] ath9k: break out of irq handler after 5 jiffies
To: Johannes Berg <johannes@sipsolutions.net>,
        Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
References: <1517958324-13536-1-git-send-email-greearb@candelatech.com>
 <2129dcdd-5963-c4da-600e-83f8c394d05c@nbd.name>
 <1518000956.3124.7.camel@sipsolutions.net>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <2086dc09-485c-2b7f-de74-35ab2e0dfc4c@candelatech.com> (sfid-20180207_163925_630451_41E7F62D)
Date: Wed, 7 Feb 2018 07:39:13 -0800
MIME-Version: 1.0
In-Reply-To: <1518000956.3124.7.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 02/07/2018 02:55 AM, Johannes Berg wrote:
> On Wed, 2018-02-07 at 10:16 +0100, Felix Fietkau wrote:
>> On 2018-02-07 00:05, greearb@candelatech.com wrote:
>>> From: Ben Greear <greearb@candelatech.com>
>>>
>>> In case where the system is sluggish, we should probably break out
>>> early.  Maybe this will fix issues where the OS thinks the IRQ handler
>>> is not responding and disables the IRQ because 'nobody cared'
>>>
>>> Signed-off-by: Ben Greear <greearb@candelatech.com>
>>
>> 5 jiffies as a hardcoded value is a bad idea, since it produces
>> different behavior based on CONFIG_HZ.

I figured that was a benefit since it would run shorter duration on systems with
a faster HZ clock.

>
> Also, err, NAPI? Or is something else is going on here?

I don't really know, but part of my test was running traffic while creating
1200 stations, so likely there were lots of higher-level lock contention that
slowed down sending pkts up the stack.

I got a bunch of errors about IRQs being ignored because nobody cared.  I noticed
that the ath9k loop could handle up to 500 or so frames, and that seemed like too
many for my particular test case.

Once I put in this patch, I did not see the 'nobody cared' error again.

There could easily be a better fix.  If you all want me to use a fixed time instead
of HZ, then please suggest a value.  I was testing with HZ of 1000, btw.

Thanks,
Ben

>
> johannes
>

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
