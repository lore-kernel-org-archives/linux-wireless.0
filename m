Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:56975 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753553Ab1AaTEt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 14:04:49 -0500
Message-ID: <4D4707CD.60903@candelatech.com>
Date: Mon, 31 Jan 2011 11:04:45 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211:  Recalculate channel-type on iface removal.
References: <1296499072-6721-1-git-send-email-greearb@candelatech.com>	 <1296499462.3812.41.camel@jlt3.sipsolutions.net>	 <4D470416.9020403@candelatech.com> <1296500220.3812.43.camel@jlt3.sipsolutions.net>
In-Reply-To: <1296500220.3812.43.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/31/2011 10:57 AM, Johannes Berg wrote:
> On Mon, 2011-01-31 at 10:48 -0800, Ben Greear wrote:
>> On 01/31/2011 10:44 AM, Johannes Berg wrote:
>>> On Mon, 2011-01-31 at 10:37 -0800, greearb@candelatech.com wrote:
>>>
>>>> Also, use WARN_ON_ONCE instead of WARN_ON if user has
>>>> ht40- stations in conjunction with ht40+.  It's not
>>>> really a kernel bug, just a mis-configuration of the
>>>> user's wifi environment.
>>>
>>> But how did we end up here to start with -- shouldn't that have been
>>> rejected?
>>
>> The set-channel-type logic will complain, and I imagine the interfaces
>> will bounce around and attempt to re-associate, but I think it can
>> get into the mixed state.
>
> I think we should try to avoid that.

Ok.  I haven't actually tested that case yet.  It's possible
that we can't actually get in that case..but I haven't found
anything that prevents it while reading code.  Assuming there is a problem,
what would be the preferred fix?  Maybe force to NO_HT if an interface
tries to associate with HT40+/- mis-match?

Do you want me to repost this patch without the WARN_ON_ONCE
changes?

>> Regardless of that, it may be something more mundane where we have
>> some HT-40 and HT-20 interfaces that can co-exist, but one of those
>> leaves.  We should still re-calculate in case their leaving changes
>> the super-chan calculation.
>
> Yeah, no argument about that part of the patch.
>
> johannes

Thanks,
Ben

>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

