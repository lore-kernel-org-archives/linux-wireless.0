Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:44929 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761777Ab2CPOzK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Mar 2012 10:55:10 -0400
Message-ID: <4F63543A.2000108@candelatech.com> (sfid-20120316_155519_558028_0F42D668)
Date: Fri, 16 Mar 2012 07:54:50 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Florian Fainelli <florian@openwrt.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC 2/2] mac80211:  Support getting sta_info stats via ethtool.
References: <1331833159-12694-1-git-send-email-greearb@candelatech.com> <1331833159-12694-2-git-send-email-greearb@candelatech.com> <1331837531.3432.36.camel@jlt3.sipsolutions.net> <4F623B58.1070106@candelatech.com> <20120316134909.GA2563@tuxdriver.com> <4F634BB2.8050408@openwrt.org>
In-Reply-To: <4F634BB2.8050408@openwrt.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/16/2012 07:18 AM, Florian Fainelli wrote:
> Hello,
>
> Le 03/16/12 14:49, John W. Linville a écrit :
>> On Thu, Mar 15, 2012 at 11:56:24AM -0700, Ben Greear wrote:
>>> On 03/15/2012 11:52 AM, Johannes Berg wrote:
>>>> On Thu, 2012-03-15 at 10:39 -0700, greearb@candelatech.com wrote:
>>>>> From: Ben Greear<greearb@candelatech.com>
>>>>>
>>>>> This lets ethtool print out stats related to station
>>>>> interfaces. Does not yet get stats from the underlying
>>>>> driver.
>>>>
>>>> Hmm. What's the advantage of using ethtool over iw, which already has a
>>>> bunch of these numbers?
>>>
>>> Well, ethtool api might be easier for some apps to use,
>>> and perhaps easier for users to read if all they want
>>> are stats.
>>
>> And they can use the same tool for both wired and wireless interfaces
>> -- could be handy.
>
> iw already provides statistics which are relevant for wireless interfaces. I really don't see the point in also reporting them via ethtool, also it is going to
> be error prone if someone updates the netlink interface and forgets about the ethtool one.

Ethtool provides what it provides.  If it's missing a stat, I or someone else can add it.

And if it's not there, then users can do without or get it elsewhere.

iw does not provide any way to get underlying wifi radio counters, and
the only other way I've found is to parse various debugfs files that
are subject to change at a whim.  Ethtool is a step up from that at least.

iw is also not supposed to be screen-scraped, while ethtool stats are a
fairly easily parsed output so scripts and such could use that.

Thanks,
Ben

> --
> Florian


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
