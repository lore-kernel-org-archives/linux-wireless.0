Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:37940 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754411Ab0JNXvv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Oct 2010 19:51:51 -0400
Message-ID: <4CB79795.3040301@candelatech.com>
Date: Thu, 14 Oct 2010 16:51:49 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: memory clobber in rx path, maybe related to ath9k.
References: <4CB4AA89.1070009@candelatech.com> <20101013053141.GA15798@vasanth-laptop> <4CB5E0A8.5020502@candelatech.com> <AANLkTimp_GSwwX_RnQSyN9QNe55HQ+0HZJ1yd8Xp+dWG@mail.gmail.com> <AANLkTinyVqdgPqzpyihuaPtVVqDmzj-ZbXzQ-4qdA2yH@mail.gmail.com> <4CB77EA0.1000005@candelatech.com> <AANLkTimC0+6PiqWO+LmtBV7uKCVpZueAQs6m_6kAnbq9@mail.gmail.com> <AANLkTi=1oOCcdvBHo+8WAVHv-M8tE14ntmK4M_09SWh5@mail.gmail.com> <AANLkTi=pp2Ob06YCi6GsR9rtRaDWPP95n2M72qWLdbwM@mail.gmail.com> <20101014225150.GB15740@tux> <20101014231958.GA3242@tux> <4CB79299.7000005@candelatech.com> <AANLkTinQmE6wm1pXkRL6p_3rkMvNrppmirjj3-jagMp8@mail.gmail.com>
In-Reply-To: <AANLkTinQmE6wm1pXkRL6p_3rkMvNrppmirjj3-jagMp8@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/14/2010 04:39 PM, Luis R. Rodriguez wrote:
> On Thu, Oct 14, 2010 at 4:30 PM, Ben Greear<greearb@candelatech.com>  wrote:
>> On 10/14/2010 04:19 PM, Luis R. Rodriguez wrote:
>>>
>>> Ok please try this patch, it cures it for me.
>>
>> Well, it got a lot further than normal, but it still
>> hit the poison check after a few minutes.
>>
>> Current test case is my app loading 130 or so stations, each running
>> wpa_supplicant.  All were created, and quite a few had associated
>> when the poison check hit.
>>
>> So, it definitely looks like a step in the right direction, but
>> not fully fixed yet.
>>
>> I'll do some more testing with this patch applied and using just my
>> perl script to make sure the problem is reproducible outside of my
>> application.
>
> Ok, whatever userspace does it should not corrupt to kernel, unless
> its poking /dev/mem

Sure, but it's nice to have a simpler test case.

I ran my script with 32 stations for maybe 20 minutes...seemed to be doing
OK as far as stability goes..then it crashed in the divide-by-zero ani thing.

I have to run home now, but I'll try my script with more interfaces
and/or some traffic mix, etc, to see if I can get another reasonable way
to reproduce this w/out my big binary application.

I can also work on the divide-by-zero bug if no one beats me to it.

Thanks,
Ben

>
>    Luis


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

