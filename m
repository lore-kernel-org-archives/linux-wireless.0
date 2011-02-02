Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:37343 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754178Ab1BBWMP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Feb 2011 17:12:15 -0500
Message-ID: <4D49D6BB.1050503@candelatech.com>
Date: Wed, 02 Feb 2011 14:12:11 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v9] mac80211: Optimize scans on current operating channel.
References: <1296670694-28596-1-git-send-email-greearb@candelatech.com>	 <1296672941.5671.38.camel@jlt3.sipsolutions.net>	 <4D49AEFA.6090202@candelatech.com> <1296682103.5671.41.camel@jlt3.sipsolutions.net>
In-Reply-To: <1296682103.5671.41.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/02/2011 01:28 PM, Johannes Berg wrote:
> On Wed, 2011-02-02 at 11:22 -0800, Ben Greear wrote:
>
>>> Based on the powersave comments I had earlier, maybe we should remove
>>> that bit for now? Work items here require powersave is disabled, but we
>>> won't do that right now if we're on the same channel.
>>
>> The problem is, if we leave the work_work() in the original
>> manner, the on/off channel state changes are not properly
>> tracked because work blindly assumes it goes off/on channel.
>> This breaks assumptions about when we must call the return-to-channel
>> logic.  I think if we do not religiously track the on/off channel
>> state changes it would be too easy to get in a state where we think
>> we are on-channel but haven't actually re-enabled xmit queues, etc.
>
> But if we pretend all work is off-channel, won't it be OK to return from
> off-channel, even if it isn't really another channel?

That should be fine unless a scan can run in conjunction
with work.  Then, it could confuse scan's idea of whether it
is off or on channel.

Seems they are currently mutually-exclusive, so I guess
it doesn't matter currently.

I'll take a look at what it would take to do the power-save
stuff and we can then decide if it should be broken into
separate patches...

>> I think I would rather change the work logic to expressly disable/enable
>> powersave.  That wouldn't be difficult, would it?
>
> Probably not -- but the code you modified regarding powersave probably
> needs adjustment then.
>
>> I don't think it does anything if we are scanning on-channel
>> with my patch.
>> The enable/disable logic is now in the offchannel code...
>>
>> Do we need to disable it if we are scanning on channel?  If so,
>> I can add that explicitly to the scanning code.
>
> Yes, I think we do need to do that, since otherwise we won't actually
> receive any beacons other than from our own AP.

I'm seeing multiple APs reported in my testing.  Receiving all beacons
seems to be related to setting the filter properly.  I'm using ath9k
though...maybe other nics behave differently about this?

Or maybe my NIC is so busy it never goes to power-save anyway?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

