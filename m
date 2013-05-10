Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:59786 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753657Ab3EJVeF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 May 2013 17:34:05 -0400
Message-ID: <518D67C6.9090406@candelatech.com> (sfid-20130510_233410_445963_61617772)
Date: Fri, 10 May 2013 14:33:58 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: mac80211:  3.9.0+:  Invalid WDS/flush state and non-connecting
 station.
References: <5182C38B.7060107@candelatech.com>    (sfid-20130502_215043_578677_76592D19) <1367526288.11375.2.camel@jlt4.sipsolutions.net>   <5182D078.4020605@candelatech.com> <518A7AD4.2060100@candelatech.com>  <1368035937.8279.25.camel@jlt4.sipsolutions.net>  <518A9618.1020107@candelatech.com> <518D64E6.8000102@candelatech.com> <1368221128.8390.47.camel@jlt4.sipsolutions.net>
In-Reply-To: <1368221128.8390.47.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/10/2013 02:25 PM, Johannes Berg wrote:
> On Fri, 2013-05-10 at 14:21 -0700, Ben Greear wrote:
>
>> void cfg80211_mlme_down(struct cfg80211_registered_device *rdev,
>> 			struct net_device *dev)
>> {
>> 	struct wireless_dev *wdev = dev->ieee80211_ptr;
>> 	struct cfg80211_deauth_request req;
>> 	u8 bssid[ETH_ALEN];
>>
>> 	ASSERT_WDEV_LOCK(wdev);
>>
>> 	printk("mlme_down: %s: type: %i  sme_state: %i current-bss: %p\n",
>>                  dev->name, (int)(wdev->iftype), (int)(wdev->sme_state),
>> 	       wdev->current_bss);
>>
>> I see this printout for the stuck station (this is dmesg | grep sta74,
>> so it skips errors about other interfaces that are also hung).
>>
>> I am guessing we should never be calling mlme_down with state
>> of CFG80211_SME_CONNECTED when bss is NULL?
>
> We should _never_ be in a state where current_bss is NULL but the state
> is != IDLE. The question I can't seem to find an answer for is how we
> got into that state, that we're in the state in down() is really less
> interesting.
>
> Since you seem to be able to reproduce this, maybe it'd help to mark all
> state transitions and current_bss assignments, and then backtrack them
> after the fact.

I'll work on instrumenting all of those assignments.  I plan to use
a helper macro to assign them and print out call sites..

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

