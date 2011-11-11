Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:37023 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760Ab1KKRyc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Nov 2011 12:54:32 -0500
Message-ID: <4EBD6152.5040002@candelatech.com> (sfid-20111111_185435_951830_6A34CC13)
Date: Fri, 11 Nov 2011 09:54:26 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: off- & multi-channel operation
References: <1320844134.3845.61.camel@jlt3.sipsolutions.net>  <4EBABCE2.5000007@candelatech.com>  <1320862529.3845.90.camel@jlt3.sipsolutions.net>  <4EBADA61.5060506@candelatech.com> <1321006412.3977.10.camel@jlt3.sipsolutions.net>
In-Reply-To: <1321006412.3977.10.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/11/2011 02:13 AM, Johannes Berg wrote:
> On Wed, 2011-11-09 at 11:54 -0800, Ben Greear wrote:
>
>>> However, it's not really going to work well for multi-channel capable
>>> drivers: say the driver is continually switching between channels 1 and
>>> 11 for multi-channel operation, but now you want to do a p2p listen
>>> phase on channel 6. That needs to interact with the driver since it has
>>> to stop switching, and it'd be much easier to have the driver manage
>>> that interaction.
>>
>> If mac80211 is controlling the channel switching with off-channel work
>> items, can't it just keep the nic on channel 6 doing the p2p listen
>> for the proper amount of time?  Why does the driver have to make
>> the decision?
>
> mac80211 isn't going to be controlling the switching between 1 and 11 at
> all though. And there will be drivers like iwlwifi and wl12xx that want
> to control the "stay on channel 6" as well.

But at least for ath9k, it certainly *could* do this.  If other NICs
cannot handle this for whatever reason, then they can be handled some
other way.  It would seem to me that mac80211 is going to have a better
picture on what needs doing than the driver (it can see software queues,
all network-devices, the upper network stack if needed, etc).

>> If you expect the driver might have pkts queued for multiple channels,
>> and that is why it would be switching, then you could just have a mac80211
>> call that says 'stay on this channel (6) until I tell you otherwise'.
>> The driver could then stop it's automated switching.  That would seem
>> fairly easy to implement.
>
> Yes, that's what we'll probably need. Actually we already have that in a
> way with the remain_on_channel, but it's not used for work/scan/etc.
> today, only for p2p.

So, I'm suggesting we put this functionality into the work logic.  It's
already doing half-assed on/off channel stuff, as is scan, and it seems
as p2p or other off-channel stations needs as well.  Lets put it all in one
place, and then optimize it to work well.  We could batch work-items for
the same channel together, for instance, and handle the on/off channel
switching so that the stations get enough time to do useful work on their
channel.

>> Worst case, you flush all buffers and
>> then it should certainly stop switching?  (The hard part would seem to be making the
>> driver able to deal with multiple xmit queues and doing automated
>> switching in the first place.  It certainly never worked well when
>> ath9k tried to do something similar with virtual phys)
>
> At least for iwlwifi I expect we'd have multiple hardware queues with
> the uCode handling the switching.

So if the NIC can do everything, then maybe send work-items to it and let
it do the scheduling?  Like:  'spend max of 200ms on this channel and send/rcv as
many pkts as possible', or 'scan this channel for 20ms', or 'do-full-hw-scan'.
If the NIC wants to hop channels on it's own, the off-channel work items could
be considered suggestions and let the NIC schedule how it wants.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
