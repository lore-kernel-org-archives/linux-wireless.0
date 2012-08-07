Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hub022-nj-3.exch022.serverdata.net ([206.225.164.186]:51708
	"EHLO HUB022-nj-3.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754911Ab2HGNWi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Aug 2012 09:22:38 -0400
Message-ID: <50211696.40607@posedge.com> (sfid-20120807_152251_749651_9DCFEDA4)
Date: Tue, 7 Aug 2012 18:52:30 +0530
From: Mahesh Palivela <maheshp@posedge.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Srinivasan B <srinivasanb@posedge.com>, <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] cfg80211: Fix for crash in cfg80211
References: <5020BF4F.2090304@posedge.com> <1344339753.15172.0.camel@jlt3.sipsolutions.net>
In-Reply-To: <1344339753.15172.0.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8/7/2012 5:12 PM, Johannes Berg wrote:
> On Tue, 2012-08-07 at 12:40 +0530, Srinivasan B wrote:
>> Patch Description:
>>                       cfg80211 module crashes when cfg80211 & mac80211
>> loaded and unloading lmac driver.
>>
>> Scenario Explanation:
>>                       (Step 1) : cfg80211, mac80211 and lmac driver
>> modules are loaded initially.
>>                       (Step 2) : unload the lmac driver.
>>                                       then any dev calls to stack causes
>> the crash.
>> Code Changes:
>>                       dev->ethtools_ops is assigned during
>> NETDEV_REGISTER and the same can be cleared during NETDEV_UNREGISTER.
>
> This doesn't make any sense to me at all.
>
cleanup of ethtools_ops pointer is required upon netdev_unreg 
notification. we are assigning this pointer to cfg80211_ethtool_ops on 
netdev_reg notification. Is it not required?

we have seen crash when keeping cfg80211 and mac80211 loaded and lmac 
driver unloaded. With this fix, we didn't see crash. Crash doesn't 
happen right away. Only when some operation trying to access ethtool_ops.

> johannes
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
