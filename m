Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:55613 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753685Ab2CPQjp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Mar 2012 12:39:45 -0400
Message-ID: <4F636CBB.8090700@candelatech.com> (sfid-20120316_173949_184290_08894B97)
Date: Fri, 16 Mar 2012 09:39:23 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Florian Fainelli <florian@openwrt.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC 2/2] mac80211:  Support getting sta_info stats via ethtool.
References: <1331833159-12694-1-git-send-email-greearb@candelatech.com> <1331833159-12694-2-git-send-email-greearb@candelatech.com> <1331837531.3432.36.camel@jlt3.sipsolutions.net> <4F623B58.1070106@candelatech.com> <20120316134909.GA2563@tuxdriver.com> <4F634BB2.8050408@openwrt.org> <4F63543A.2000108@candelatech.com> <4F635562.6090505@openwrt.org>
In-Reply-To: <4F635562.6090505@openwrt.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/16/2012 07:59 AM, Florian Fainelli wrote:
> Le 03/16/12 15:54, Ben Greear a écrit :

>> Ethtool provides what it provides. If it's missing a stat, I or someone else can add it.
>
> What if we don't want to bloat ethtool with new stats? I mean, someone else one day will see wireless stats in, and say, hey why don't I add atm, x25, or any
> protocol of the moment to ethtool, then what do we do?

Cheer and be happy!  Or, make the code conditionally compiled
if you are very scarce on RAM.

>> And if it's not there, then users can do without or get it elsewhere.
>>
>> iw does not provide any way to get underlying wifi radio counters, and
>> the only other way I've found is to parse various debugfs files that
>> are subject to change at a whim.
>
> That's another topic, if debugfs interface changes you should complain to their maintainers.
>
>> Ethtool is a step up from that at least.
>>
>> iw is also not supposed to be screen-scraped, while ethtool stats are a
>> fairly easily parsed output so scripts and such could use that.
>
> Why not fix iw instead so its output gets nicely parsed?

debugfs and iw output is meant to be parsed by humans.
In particular, debugfs is not a 'real' api and can change
all the time.

> Would there be no reporting tool that I would not object, otherwise I prefer to keep things where they are consistent, that is, iw configures and reports stats
> for wireless, and so does ethtool for Ethernet interfaces.

Another problem with using iw:  You have to modify user-space as well
as the kernel to get new stats.  But, with ethtool, you can just modify
the kernel and any remotely modern ethtool executable can display
the new stats.

Note that my patches require NO changes to the ethtool binary to display
the new stats.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

