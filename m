Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:57317 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753728Ab0JEDpn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Oct 2010 23:45:43 -0400
Message-ID: <4CAA9F60.9030207@candelatech.com>
Date: Mon, 04 Oct 2010 20:45:36 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Bruno Randolf <br1@einfach.org>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Putting APs into bridges?
References: <4CAA0D5E.2090700@candelatech.com> <1286216969.3620.44.camel@jlt3.sipsolutions.net> <201010051243.45190.br1@einfach.org>
In-Reply-To: <201010051243.45190.br1@einfach.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/04/2010 08:43 PM, Bruno Randolf wrote:
> On Tue October 5 2010 03:29:29 Johannes Berg wrote:
>> On Mon, 2010-10-04 at 10:22 -0700, Ben Greear wrote:
>>> It seems he put two VAPs into a bridge device, and got an
>>> assert here (nevermind the printk, I just added that to
>>> help debug the issue).
>>>
>>> static void __ieee80211_wake_queue(struct ieee80211_hw *hw, int queue,
>>>
>>> 				   enum queue_stop_reason reason)
>>>
>>> {
>>>
>>> 	struct ieee80211_local *local = hw_to_local(hw);
>>> 	struct ieee80211_sub_if_data *sdata;
>>> 	
>>> 	trace_wake_queue(local, queue, reason);
>>> 	
>>> 	if (WARN_ON(queue>= hw->queues)) {
>>> 	
>>> 		printk(KERN_WARNING "%s:  queue: %i  hw->queues: %i\n",
>>> 		
>>> 		       sdata->name, queue, hw->queues);
>>> 		
>>> 		return;
>>> 	
>>> 	}
>>>
>>> Before I try to reproduce this, it is valid to add APs to bridge
>>> devices in the first place?
>>
>> Yes, it's valid, we catch the invalid cases in cfg80211.
>>
>> Hitting the assert there is rather strange though.
>
> hey!
>
> i'm seeing the same. i think it's due to a bug in ath5k concerning power save.
> we put frames in the CAB queue, but obviously we shouldn't tell mac80211 to
> wake this queue (number 6) since mac80211 knows nothing about it.

Interesting...we couldn't reproduce it at all (two APs in a bridge worked as
expected, as far as we could tell).

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
