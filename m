Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:53578 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754441Ab2CPQXJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Mar 2012 12:23:09 -0400
Message-ID: <4F6368E9.2040007@candelatech.com> (sfid-20120316_172314_292899_ACA6E902)
Date: Fri, 16 Mar 2012 09:23:05 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 4/4] ath9k:  Support ethtool getstats api.
References: <1331853606-28434-1-git-send-email-greearb@candelatech.com> <1331853606-28434-4-git-send-email-greearb@candelatech.com> <4F6356E8.3050906@openwrt.org>
In-Reply-To: <4F6356E8.3050906@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/16/2012 08:06 AM, Felix Fietkau wrote:
> On 2012-03-16 12:20 AM, greearb@candelatech.com wrote:
>> From: Ben Greear<greearb@candelatech.com>
>>
>> This returns many of the values that formerly could
>> only be obtained from debugfs.  This should be an
>> improvement when trying to access these counters
>> programatically.  Currently this support is only
>> enabled when DEBUGFS is enabled because otherwise
>> these stats are not accumulated.
>>
>> Signed-off-by: Ben Greear<greearb@candelatech.com>
> I don't really like the idea just throwing every random counter into
> ethtool. Many of these counters are actually quite misleading, not
> properly tracked, or not even updated properly, and thus do not deserve
> to be made visible through ethtool.
>
> I think before something gets exported that way, it should be made clear
> what it's for and what the limitations are.

My personal goal is to give my users a better insight into their
wireless environment.  I would like to be able to break out the
various low-level errors (as well as add them together to present
summary errors).

For anyone reporting mysterious bugs on mailing lists and such, I'd like
to ask them to dump the stats and send it to me/list/whatever.
I am still of the mind that looking for patterns in various
counters might point to underlying problems, so anything that
makes it easier to get that data is a win in my mind.

If there are some stats that really don't work, maybe I
will notice, or maybe someone else will and we can fix
them.  If you are aware of any specific ones that don't
work right, please let me know and I'll at least add some
comments to the code to mention they are questionable,
or fix them if I'm able.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

