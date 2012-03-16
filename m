Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:51303 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422755Ab2CPPAr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Mar 2012 11:00:47 -0400
Received: by bkcik5 with SMTP id ik5so2971016bkc.19
        for <linux-wireless@vger.kernel.org>; Fri, 16 Mar 2012 08:00:46 -0700 (PDT)
Message-ID: <4F635562.6090505@openwrt.org> (sfid-20120316_160101_448263_DD7D41AA)
Date: Fri, 16 Mar 2012 15:59:46 +0100
From: Florian Fainelli <florian@openwrt.org>
MIME-Version: 1.0
To: Ben Greear <greearb@candelatech.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC 2/2] mac80211:  Support getting sta_info stats via ethtool.
References: <1331833159-12694-1-git-send-email-greearb@candelatech.com> <1331833159-12694-2-git-send-email-greearb@candelatech.com> <1331837531.3432.36.camel@jlt3.sipsolutions.net> <4F623B58.1070106@candelatech.com> <20120316134909.GA2563@tuxdriver.com> <4F634BB2.8050408@openwrt.org> <4F63543A.2000108@candelatech.com>
In-Reply-To: <4F63543A.2000108@candelatech.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Le 03/16/12 15:54, Ben Greear a écrit :
> On 03/16/2012 07:18 AM, Florian Fainelli wrote:
>> Hello,
>>
>> Le 03/16/12 14:49, John W. Linville a écrit :
>>> On Thu, Mar 15, 2012 at 11:56:24AM -0700, Ben Greear wrote:
>>>> On 03/15/2012 11:52 AM, Johannes Berg wrote:
>>>>> On Thu, 2012-03-15 at 10:39 -0700, greearb@candelatech.com wrote:
>>>>>> From: Ben Greear<greearb@candelatech.com>
>>>>>>
>>>>>> This lets ethtool print out stats related to station
>>>>>> interfaces. Does not yet get stats from the underlying
>>>>>> driver.
>>>>>
>>>>> Hmm. What's the advantage of using ethtool over iw, which already 
>>>>> has a
>>>>> bunch of these numbers?
>>>>
>>>> Well, ethtool api might be easier for some apps to use,
>>>> and perhaps easier for users to read if all they want
>>>> are stats.
>>>
>>> And they can use the same tool for both wired and wireless interfaces
>>> -- could be handy.
>>
>> iw already provides statistics which are relevant for wireless 
>> interfaces. I really don't see the point in also reporting them via 
>> ethtool, also it is going to
>> be error prone if someone updates the netlink interface and forgets 
>> about the ethtool one.
>
> Ethtool provides what it provides.  If it's missing a stat, I or 
> someone else can add it.

What if we don't want to bloat ethtool with new stats? I mean, someone 
else one day will see wireless stats in, and say, hey why don't I add 
atm, x25, or any protocol of the moment to ethtool, then what do we do?

>
> And if it's not there, then users can do without or get it elsewhere.
>
> iw does not provide any way to get underlying wifi radio counters, and
> the only other way I've found is to parse various debugfs files that
> are subject to change at a whim. 

That's another topic, if debugfs interface changes you should complain 
to their maintainers.

> Ethtool is a step up from that at least.
>
> iw is also not supposed to be screen-scraped, while ethtool stats are a
> fairly easily parsed output so scripts and such could use that.

Why not fix iw instead so its output gets nicely parsed?
Would there be no reporting tool that I would not object, otherwise I 
prefer to keep things where they are consistent, that is, iw configures 
and reports stats for wireless, and so does ethtool for Ethernet interfaces.
--
Florian
