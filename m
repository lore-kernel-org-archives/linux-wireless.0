Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:54450 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249Ab1A1RLx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Jan 2011 12:11:53 -0500
Message-ID: <4D42F8D3.6090806@candelatech.com>
Date: Fri, 28 Jan 2011 09:11:47 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: Multiple vifs and HT v/s non-HT.
References: <4D41FACB.2010807@candelatech.com> <1296220663.5118.0.camel@jlt3.sipsolutions.net>
In-Reply-To: <1296220663.5118.0.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/28/2011 05:17 AM, Johannes Berg wrote:
> On Thu, 2011-01-27 at 15:07 -0800, Ben Greear wrote:
>> We found something fun while playing with HT mode:
>>
>> We had some vifs associated with an AP with HT enabled,
>> and other VIFS to an AP with HT disabled.
>>
>> They managed to associate, but with slow rates and
>> for whatever reason, nothing is able to send traffic.
>> I would have expected one set or the other would
>> be able to send traffic.
>>
>> The ath9k hardware ended up in HT mode according to
>> ath9k debugfs wiphy file, but that was probably
>> just luck.
>>
>> I'm not too sure how to ensure this mixed-mode HT
>> scenario doesn't happen at this point...
>
> So that patch you sent addressed this?

Well, I could no longer (easily?) reproduce the problem,
but to be honest, I don't see how my changes could have fixed
the problem that I saw.  I still think that patch is useful
and could fix other problems, however.

I ran 30 STAs w/out HT and 30 with all night, about 175kbps UDP tx + rx on
each interface, and it ran OK.

But, there may still be issues/races with initial setup and state transitions.

At the least, the set-channel-type method should do WARN_ON_ONCE
instead of WARN_ON if you have HT40+ on some VIFs and HT40-
on others.  I was also thinking that the first vif(s) to associate
on a channel-type should win..and just fail to set the channel type
to something invalid (ie, ht40- -> ht40+) in that case.  Otherwise,
I think you would get endless flapping.

Thanks,
Ben

>
> johannes
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
