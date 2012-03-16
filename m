Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from g4t0017.houston.hp.com ([15.201.24.20]:23476 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756384Ab2CPROV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Mar 2012 13:14:21 -0400
Message-ID: <4F6374EA.6020605@hp.com> (sfid-20120316_181447_225399_A6367824)
Date: Fri, 16 Mar 2012 10:14:18 -0700
From: Rick Jones <rick.jones2@hp.com>
MIME-Version: 1.0
To: Florian Fainelli <florian@openwrt.org>
CC: Ben Greear <greearb@candelatech.com>,
	"John W. Linville" <linville@tuxdriver.com>,
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
>> On 03/16/2012 07:18 AM, Florian Fainelli wrote:
>>> Hello,
>>>
>>> Le 03/16/12 14:49, John W. Linville a écrit :
>>>> On Thu, Mar 15, 2012 at 11:56:24AM -0700, Ben Greear wrote:
>>>>> On 03/15/2012 11:52 AM, Johannes Berg wrote:
>>>>>> On Thu, 2012-03-15 at 10:39 -0700, greearb@candelatech.com wrote:
>>>>>>> From: Ben Greear<greearb@candelatech.com>
>>>>>>>
>>>>>>> This lets ethtool print out stats related to station
>>>>>>> interfaces. Does not yet get stats from the underlying
>>>>>>> driver.
>>>>>>
>>>>>> Hmm. What's the advantage of using ethtool over iw, which already
>>>>>> has a bunch of these numbers?
>>>>>
>>>>> Well, ethtool api might be easier for some apps to use,
>>>>> and perhaps easier for users to read if all they want
>>>>> are stats.
>>>>
>>>> And they can use the same tool for both wired and wireless interfaces
>>>> -- could be handy.
>>>
>>> iw already provides statistics which are relevant for wireless
>>> interfaces. I really don't see the point in also reporting them via
>>> ethtool, also it is going to
>>> be error prone if someone updates the netlink interface and forgets
>>> about the ethtool one.
>>
>> Ethtool provides what it provides. If it's missing a stat, I or
>> someone else can add it.
>
> What if we don't want to bloat ethtool with new stats? I mean, someone
> else one day will see wireless stats in, and say, hey why don't I add
> atm, x25, or any protocol of the moment to ethtool, then what do we do?

Rejoice and perhaps add an alias to ethtool called nictool or linktool 
or somesuch?   As already pointed-out there is a non-trivial niceness to 
not having to have umpteen different tools to get stats from a network 
interface.

"What's in a name" may apply, but these are wireless *ethernet* 
interfaces right?

rick jones
