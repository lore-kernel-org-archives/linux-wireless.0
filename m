Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:43085 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757326Ab2CPRGu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Mar 2012 13:06:50 -0400
Message-ID: <4F637325.2020205@openwrt.org> (sfid-20120316_180653_660569_B0457AD6)
Date: Fri, 16 Mar 2012 18:06:45 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Ben Greear <greearb@candelatech.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 4/4] ath9k:  Support ethtool getstats api.
References: <1331853606-28434-1-git-send-email-greearb@candelatech.com> <1331853606-28434-4-git-send-email-greearb@candelatech.com> <4F6356E8.3050906@openwrt.org> <4F6368E9.2040007@candelatech.com> <4F636C07.7060202@openwrt.org> <4F636F81.9070804@candelatech.com>
In-Reply-To: <4F636F81.9070804@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-03-16 5:51 PM, Ben Greear wrote:
> On 03/16/2012 09:36 AM, Felix Fietkau wrote:
>> On 2012-03-16 5:23 PM, Ben Greear wrote:
>>> On 03/16/2012 08:06 AM, Felix Fietkau wrote:
> 
>>> My personal goal is to give my users a better insight into their
>>> wireless environment.  I would like to be able to break out the
>>> various low-level errors (as well as add them together to present
>>> summary errors).
>>>
>>> For anyone reporting mysterious bugs on mailing lists and such, I'd like
>>> to ask them to dump the stats and send it to me/list/whatever.
>>> I am still of the mind that looking for patterns in various
>>> counters might point to underlying problems, so anything that
>>> makes it easier to get that data is a win in my mind.
>> That's what debugfs is for, and it's not exactly hard to use.
>> I think it would be bad if tools started depending on the counters in
>> their current state, they're pretty messy.
> 
> With a bit of work, we could make the ethtool stats
> available when debugfs is compiled out, which might give
> you actual space savings and still allow at least much of
> the stats.  Either way, the ability to programatically
> parse the ethtool stats is a big win for my use, at least.
I'm OK with exporting some stats in a way that can be easily parsed, but
it should be limited to data that actually makes sense and isn't
available through normal API.

>>> If there are some stats that really don't work, maybe I
>>> will notice, or maybe someone else will and we can fix
>>> them.  If you are aware of any specific ones that don't
>>> work right, please let me know and I'll at least add some
>>> comments to the code to mention they are questionable,
>>> or fix them if I'm able.
>> There's lots of confusion in the AMPDU/Aggregates counters (some count
>> whole A-MPDUs, some count subframes).
> That sounds fixable, if it's a problem at all.
> 
>> Also, many of these counters are useless unless you're doing live
>> debugging and actually know what you're doing - especially the ones that
>> display the current queue state.
> 
> I tried to skip all of those current-queue-state counters, but I
> will double-check.
Yeah, seems like I misread something there.

>> Most of the PHY error counters aren't even tracked by the hw, nothing in
>> the driver enables their use.
> 
> Well, any reason we cannot enable those?
The hardware has a limited number of counter registers available for
tracking PHY errors. Enabling PHY errors to be reported via DMA wastes
tons of precious CPU cycles.

>> For some of these counters it might make sense to track them in
>> mac80211, as they're sufficiently generic.
> 
> That sounds nice.  Maybe add a 'get_stats' object to the driver
> api?  If you have a list of what you want to be made
> generic I'll make a try at implementing it.
I don't have a list.

- Felix
