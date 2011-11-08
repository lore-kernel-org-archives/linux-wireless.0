Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:33220 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247Ab1KHRZz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Nov 2011 12:25:55 -0500
Message-ID: <4EB9661F.9040901@candelatech.com> (sfid-20111108_182603_810469_ED01238B)
Date: Tue, 08 Nov 2011 09:25:51 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFT/FYI] mac80211: revert on-channel work optimisations
References: <1320772222.24797.22.camel@jlt3.sipsolutions.net>  <4EB96416.5040700@candelatech.com> <1320772727.24797.23.camel@jlt3.sipsolutions.net>
In-Reply-To: <1320772727.24797.23.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/08/2011 09:18 AM, Johannes Berg wrote:
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
>
> Can't even understand it, I have a better chance just rewriting it.

That's fine by me, I found the code complex as well.  All the tmp
and scan and active channel pointers makes for a real mess.  But if
you want multiple vifs to work well, then you really need to be able
to continue to function on-channel when some other vif is scanning
on that channel.  My use of the wifi stack requires this to work,
so if it takes any significant time to get the new code in I'm going
to have to stick with my complex crap.

> Like I said -- I know I'll have to do that, but I need to think about
> this in the context of using different channels on different virtual
> interfaces etc. and probably rework the channel config logic in mac80211
> significantly...

Well, good luck with that.  I'll test patches if you post them.

Thanks,
Ben

>
> johannes


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

