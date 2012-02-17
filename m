Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:40302 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805Ab2BQQNa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Feb 2012 11:13:30 -0500
Message-ID: <4F3E7CA5.7010207@candelatech.com> (sfid-20120217_171334_128038_3AC27A65)
Date: Fri, 17 Feb 2012 08:13:25 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFT/FYI] mac80211: revert on-channel work optimisations
References: <1320772222.24797.22.camel@jlt3.sipsolutions.net>  <4EB96416.5040700@candelatech.com> (sfid-20111108_181718_795911_9F0A2B63) <1329493491.3786.6.camel@jlt3.sipsolutions.net>
In-Reply-To: <1329493491.3786.6.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/17/2012 07:44 AM, Johannes Berg wrote:
> On Tue, 2011-11-08 at 09:17 -0800, Ben Greear wrote:
>> On 11/08/2011 09:10 AM, Johannes Berg wrote:
>>> FYI -- I'm going to test this a bit more but I am going to put it in.
>>> The code is a mess -- look at how much code I remove below (and that's
>>> after everybody elses cleanups!) for a dubious optimisation.
>>>
>>> I agree that we should address this and we need to really do this to not
>>> mess up our aggregation state, but the current code is too complex and
>>> causing too many issues. We also need to think about this in the context
>>> of multi-virtual-channel support.
>>
>> Well crap.  Why don't you try to fix it right instead?
>>
>> I'll probably end up carrying this in my own tree so
>> that multiple vifs work well and don't constantly
>> reset the ath9k causing it to shit itself...
>
> Given the auth/assoc redesign that went in now, are you still carrying
> this? Does the redesign address your problem?

I haven't looked yet...still stuck back on 3.0 kernel for the
most part.

I should be moving to 3.3 sometime soon, and will see how it works.

I was thinking that I would ignore the work logic for now and probably
just focus on re-applying the on-channel scan optimization first.

Are you done, or mostly done with the re-architecture you were working on?

I know you didn't like the scan optimization from before...do you have any
ideas on how it might be done more to your liking?

Thanks,
Ben


>
> johannes


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
