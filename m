Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:57657 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759107Ab2CPQvQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Mar 2012 12:51:16 -0400
Message-ID: <4F636F81.9070804@candelatech.com> (sfid-20120316_175120_277690_49C0048F)
Date: Fri, 16 Mar 2012 09:51:13 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 4/4] ath9k:  Support ethtool getstats api.
References: <1331853606-28434-1-git-send-email-greearb@candelatech.com> <1331853606-28434-4-git-send-email-greearb@candelatech.com> <4F6356E8.3050906@openwrt.org> <4F6368E9.2040007@candelatech.com> <4F636C07.7060202@openwrt.org>
In-Reply-To: <4F636C07.7060202@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/16/2012 09:36 AM, Felix Fietkau wrote:
> On 2012-03-16 5:23 PM, Ben Greear wrote:
>> On 03/16/2012 08:06 AM, Felix Fietkau wrote:

>> My personal goal is to give my users a better insight into their
>> wireless environment.  I would like to be able to break out the
>> various low-level errors (as well as add them together to present
>> summary errors).
>>
>> For anyone reporting mysterious bugs on mailing lists and such, I'd like
>> to ask them to dump the stats and send it to me/list/whatever.
>> I am still of the mind that looking for patterns in various
>> counters might point to underlying problems, so anything that
>> makes it easier to get that data is a win in my mind.
> That's what debugfs is for, and it's not exactly hard to use.
> I think it would be bad if tools started depending on the counters in
> their current state, they're pretty messy.

With a bit of work, we could make the ethtool stats
available when debugfs is compiled out, which might give
you actual space savings and still allow at least much of
the stats.  Either way, the ability to programatically
parse the ethtool stats is a big win for my use, at least.

>> If there are some stats that really don't work, maybe I
>> will notice, or maybe someone else will and we can fix
>> them.  If you are aware of any specific ones that don't
>> work right, please let me know and I'll at least add some
>> comments to the code to mention they are questionable,
>> or fix them if I'm able.
> There's lots of confusion in the AMPDU/Aggregates counters (some count
> whole A-MPDUs, some count subframes).

That sounds fixable, if it's a problem at all.

> Also, many of these counters are useless unless you're doing live
> debugging and actually know what you're doing - especially the ones that
> display the current queue state.

I tried to skip all of those current-queue-state counters, but I
will double-check.

> Most of the PHY error counters aren't even tracked by the hw, nothing in
> the driver enables their use.

Well, any reason we cannot enable those?

> For some of these counters it might make sense to track them in
> mac80211, as they're sufficiently generic.

That sounds nice.  Maybe add a 'get_stats' object to the driver
api?  If you have a list of what you want to be made
generic I'll make a try at implementing it.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

