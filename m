Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:55918 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032779Ab2CPOT0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Mar 2012 10:19:26 -0400
Received: by eekc41 with SMTP id c41so2121324eek.19
        for <linux-wireless@vger.kernel.org>; Fri, 16 Mar 2012 07:19:25 -0700 (PDT)
Message-ID: <4F634BB2.8050408@openwrt.org> (sfid-20120316_151932_274184_1BFFAAB3)
Date: Fri, 16 Mar 2012 15:18:26 +0100
From: Florian Fainelli <florian@openwrt.org>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Ben Greear <greearb@candelatech.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC 2/2] mac80211:  Support getting sta_info stats via ethtool.
References: <1331833159-12694-1-git-send-email-greearb@candelatech.com> <1331833159-12694-2-git-send-email-greearb@candelatech.com> <1331837531.3432.36.camel@jlt3.sipsolutions.net> <4F623B58.1070106@candelatech.com> <20120316134909.GA2563@tuxdriver.com>
In-Reply-To: <20120316134909.GA2563@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

Le 03/16/12 14:49, John W. Linville a écrit :
> On Thu, Mar 15, 2012 at 11:56:24AM -0700, Ben Greear wrote:
>> On 03/15/2012 11:52 AM, Johannes Berg wrote:
>>> On Thu, 2012-03-15 at 10:39 -0700, greearb@candelatech.com wrote:
>>>> From: Ben Greear<greearb@candelatech.com>
>>>>
>>>> This lets ethtool print out stats related to station
>>>> interfaces.  Does not yet get stats from the underlying
>>>> driver.
>>>
>>> Hmm. What's the advantage of using ethtool over iw, which already has a
>>> bunch of these numbers?
>>
>> Well, ethtool api might be easier for some apps to use,
>> and perhaps easier for users to read if all they want
>> are stats.
>
> And they can use the same tool for both wired and wireless interfaces
> -- could be handy.

iw already provides statistics which are relevant for wireless 
interfaces. I really don't see the point in also reporting them via 
ethtool, also it is going to be error prone if someone updates the 
netlink interface and forgets about the ethtool one.
--
Florian
