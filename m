Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:38004 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758164Ab3BTAjb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Feb 2013 19:39:31 -0500
Message-ID: <51241B3B.9030405@candelatech.com> (sfid-20130220_013935_236838_C8A8CBC3)
Date: Tue, 19 Feb 2013 16:39:23 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Crash on removal of 400 interfaces (3.7.6+)
References: <5122A7C7.3070508@candelatech.com>  (sfid-20130218_231436_933191_3F8FE600) <1361225773.8555.50.camel@jlt4.sipsolutions.net> <51240249.6060801@candelatech.com> <512409B1.7090800@candelatech.com> <51240EE6.9040201@candelatech.com>
In-Reply-To: <51240EE6.9040201@candelatech.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/19/2013 03:46 PM, Ben Greear wrote:
> On 02/19/2013 03:24 PM, Ben Greear wrote:
>> On 02/19/2013 02:52 PM, Ben Greear wrote:
>>> On 02/18/2013 02:16 PM, Johannes Berg wrote:
>>>> On Mon, 2013-02-18 at 14:14 -0800, Ben Greear wrote:
>>>>> We often see crashes in work-queue processing when deleting
>>>>> lots of wifi station interfaces.  I'm guessing that there is probably
>>>>> a work item that was not properly un-registered before deleting
>>>>> memory.  I have backported some wifi fixes from upstream, so
>>>>> maybe they are to blame, but in case anyone has any suggestions
>>>>> for places to look, please let me know.
>>>>
>>>> Enable CONFIG_DEBUG_OBJECTS and CONFIG_DEBUG_OBJECTS_WORK :)
>>>
>>> That did not catch anything.
>
> So, maybe the problem is in the sta_quiesce logic.
>
> It cancels the work items before it stops the timers, so
> I think it could re-add the work before the timers are
> stopped??

Maybe not just this, at least.  In my case, I'm never seeing the
sta_quiesce code called at all..I guess it is just for cases
where we are quiescing the hardware.

So, what is supposed to clean up these work items (and timers?)
when we are deleting an interface?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

