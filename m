Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:39339 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752059Ab1BNPfM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Feb 2011 10:35:12 -0500
Message-ID: <4D594BA2.5080905@candelatech.com>
Date: Mon, 14 Feb 2011 07:34:58 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
Subject: Re: [PATCH] mac80211:  Make some mlme timers module paramaters.
References: <1296862224-19489-1-git-send-email-greearb@candelatech.com> <1297685561.3785.36.camel@jlt3.sipsolutions.net>
In-Reply-To: <1297685561.3785.36.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/14/2011 04:12 AM, Johannes Berg wrote:
> On Fri, 2011-02-04 at 15:30 -0800, greearb@candelatech.com wrote:
>> From: Ben Greear<greearb@candelatech.com>
>>
>> This allows users to tune the connection-loss algorithms
>> to be more or less lenient.  In particular, larger
>> null-func retries helps when using lots of virtual
>> stations on a loaded network.
>
> I see this has been merged, but I really think it should be reverted. It
> doesn't really fix anything, and it makes the behaviour less
> predictable. Also, even on a loaded network the nullfunc frames should
> be transmitted quickly as they go out on VO. I'm thinking the fact that
> it doesn't will also affect other things -- like the bufferbloat
> discussion -- and fixing the problem would be a much better idea.

The defaults stay the same, and allowing the values to be set a bit larger
lets 128 stations associate, where without this, they constantly fail the
null-func retries counter.

Imagine 128 stations all trying to associate and auth WPA at the
same time, and start DHCP and some IPv6 auto-negotiation
as soon as they are up...  That is quite a lot of packets
for a bunch of timing-sensitive operations.

I know my particular use is pretty strange, but surely I'm not
the only one that would like a good way to stress-test APs.

I can also imagine that other users might like their system even more
trigger happy..perhaps that would speed up roaming in some cases.
Or users on very poor/congested networks, flakey APs, etc.

The default values seem to be chosen arbitrarily to work for most
users most of the time.  I think it adds way more benefit to allow
these easily changed than any harm that comes from giving users
the option.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
