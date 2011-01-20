Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:49716 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753323Ab1ATSV3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Jan 2011 13:21:29 -0500
Message-ID: <4D387D25.7080902@candelatech.com>
Date: Thu, 20 Jan 2011 10:21:25 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [RFC 2/3] mac80211: Support scanning only current active channel.
References: <1295544750-6704-1-git-send-email-greearb@candelatech.com>	 <1295544750-6704-2-git-send-email-greearb@candelatech.com>	 <1295545143.3693.44.camel@jlt3.sipsolutions.net>	 <4D3879A6.2060909@candelatech.com> <1295547439.3693.46.camel@jlt3.sipsolutions.net>
In-Reply-To: <1295547439.3693.46.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/20/2011 10:17 AM, Johannes Berg wrote:
> On Thu, 2011-01-20 at 10:06 -0800, Ben Greear wrote:
>
>>> This doesn't seem to make much sense either -- even if we do a scan over
>>> multiple channels we should be able to optimise the part on the current
>>> channel (maybe put it at the beginning or end too).
>>
>> Maybe..but user-space can specify the channels it wants to scan,
>> and I assume that means what order to scan them in.  I have no
>> idea if changing that order would confuse some application.
>
> No, it can't actually determine the order -- we sort them in cfg80211
> anyway to de-duplicate them.

Ok, so assuming we re-work scanning across the board, maybe the first
thing is to sort them such that the current channel is always first
(if it's in the list at all)?

>> It seems to me that it would take quite a bit of re-work of the
>> mac80211 scanning logic to deal with scanning on the current
>> channel w/out affecting other tx/rx packets (as my patch attempts
>> to do), without setting some explicit flag before you enter
>> the scan state machine.
>
> Yeah, so maybe it needs some re-work, but I think what you're doing is a
> pretty strange hack.

If you have time to write some patches, I'll be happy to test them on
our ath9k and ath5k systems.

If you don't, then I can make an attempt.  Suggestions for an acceptable
way to go about doing this would be welcome.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

