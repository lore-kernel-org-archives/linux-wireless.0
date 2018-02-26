Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:56080 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751094AbeBZWIX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Feb 2018 17:08:23 -0500
Received: by mail-wm0-f65.google.com with SMTP id q83so20427677wme.5
        for <linux-wireless@vger.kernel.org>; Mon, 26 Feb 2018 14:08:22 -0800 (PST)
Subject: Re: [PATCH] ath9k: break out of irq handler after 5 jiffies
To: Ben Greear <greearb@candelatech.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
References: <1517958324-13536-1-git-send-email-greearb@candelatech.com>
 <2129dcdd-5963-c4da-600e-83f8c394d05c@nbd.name>
 <1518000956.3124.7.camel@sipsolutions.net>
 <2086dc09-485c-2b7f-de74-35ab2e0dfc4c@candelatech.com>
 <d787d749-bce7-1785-c90a-41dd4355a717@candelatech.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5A948555.2020106@broadcom.com> (sfid-20180226_230826_396050_AE6BF0E1)
Date: Mon, 26 Feb 2018 23:08:21 +0100
MIME-Version: 1.0
In-Reply-To: <d787d749-bce7-1785-c90a-41dd4355a717@candelatech.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2/26/2018 10:39 PM, Ben Greear wrote:
> On 02/07/2018 07:39 AM, Ben Greear wrote:
>>
>>
>> On 02/07/2018 02:55 AM, Johannes Berg wrote:
>>> On Wed, 2018-02-07 at 10:16 +0100, Felix Fietkau wrote:
>>>> On 2018-02-07 00:05, greearb@candelatech.com wrote:
>>>>> From: Ben Greear <greearb@candelatech.com>
>>>>>
>>>>> In case where the system is sluggish, we should probably break out
>>>>> early.  Maybe this will fix issues where the OS thinks the IRQ handler
>>>>> is not responding and disables the IRQ because 'nobody cared'
>>>>>
>>>>> Signed-off-by: Ben Greear <greearb@candelatech.com>
>>>>
>>>> 5 jiffies as a hardcoded value is a bad idea, since it produces
>>>> different behavior based on CONFIG_HZ.
>>
>> I figured that was a benefit since it would run shorter duration on
>> systems with
>> a faster HZ clock.
>>
>>>
>>> Also, err, NAPI? Or is something else is going on here?
>>
>> I don't really know, but part of my test was running traffic while
>> creating
>> 1200 stations, so likely there were lots of higher-level lock
>> contention that
>> slowed down sending pkts up the stack.
>>
>> I got a bunch of errors about IRQs being ignored because nobody
>> cared.  I noticed
>> that the ath9k loop could handle up to 500 or so frames, and that
>> seemed like too
>> many for my particular test case.
>>
>> Once I put in this patch, I did not see the 'nobody cared' error again.
>>
>> There could easily be a better fix.  If you all want me to use a fixed
>> time instead
>> of HZ, then please suggest a value.  I was testing with HZ of 1000, btw.
>
> Hello,
>
> I don't mind changing this patch, but I could use some guidance as to what
> values you all want me to use.
>
> Should I use a millisecond based clock instead of jiffies?
>
> What time duration do you want if 5 Jiffies (or 5ms) is not desired?

Hi Ben,

Instead of using some time unit you could consider breaking out after 
handing 'x' number of frames and make 'x' configurable through debugfs.

Regards,
Arend
