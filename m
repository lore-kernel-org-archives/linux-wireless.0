Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:41022 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354Ab1KITyQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Nov 2011 14:54:16 -0500
Message-ID: <4EBADA61.5060506@candelatech.com> (sfid-20111109_205420_175788_7C0C7C04)
Date: Wed, 09 Nov 2011 11:54:09 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: off- & multi-channel operation
References: <1320844134.3845.61.camel@jlt3.sipsolutions.net>  <4EBABCE2.5000007@candelatech.com> <1320862529.3845.90.camel@jlt3.sipsolutions.net>
In-Reply-To: <1320862529.3845.90.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/09/2011 10:15 AM, Johannes Berg wrote:
> On Wed, 2011-11-09 at 09:48 -0800, Ben Greear wrote:
>
>>> The other thing is more of a design issue: we have multiple ways to
>>> leave the operating channel: scanning&   work. Soon we'll have to deal
>>> with multi-channel *operation* so we'll have multiple operating
>>> channels. I don't even want to have to handle that in mac80211, and I
>>> think we'll have to push it into devices (or drivers in some cases). In
>>> my opinion, these two ways should be consolidated.
>>
>> Seems like you could move the scanning into the work logic.  That might
>> be a good first step to simplify the off-channel stuff.  And, once you get
>> the off-channel stuff working better, it would seem to me that just using
>> that for your off-channel interfaces might be better than trying to re-write
>> everything and force a bunch of new functionality down into drivers.
>
> Yeah, I had that thought a long time ago, it just never happened :-)

Well, now that you've got the state machine back to 'simple', maybe
it will be easier :P

> However, it's not really going to work well for multi-channel capable
> drivers: say the driver is continually switching between channels 1 and
> 11 for multi-channel operation, but now you want to do a p2p listen
> phase on channel 6. That needs to interact with the driver since it has
> to stop switching, and it'd be much easier to have the driver manage
> that interaction.

If mac80211 is controlling the channel switching with off-channel work
items, can't it just keep the nic on channel 6 doing the p2p listen
for the proper amount of time?  Why does the driver have to make
the decision?

If you expect the driver might have pkts queued for multiple channels,
and that is why it would be switching, then you could just have a mac80211
call that says 'stay on this channel (6) until I tell you otherwise'.
The driver could then stop it's automated switching.  That would seem
fairly easy to implement.  Worst case, you flush all buffers and
then it should certainly stop switching?  (The hard part would seem to be making the
driver able to deal with multiple xmit queues and doing automated
switching in the first place.  It certainly never worked well when
ath9k tried to do something similar with virtual phys)

>> For drivers/NICS that can handle off-channel stuff themselves, hopefully
>> you can add some new API or new arguments to existing API to help
>> leverage that.
>
> We have some APIs already, but they aren't actually used for things like
> auth/assoc etc. and are optional at this point so we can't start using
> them either.

You could start using them on hardware/drivers that supports the options, and
keep fallback code for others?

>>> But then what about scanning? Can we, and should we, force such drivers
>>> to implement hw_scan? I think maybe we should, and maybe drivers such as
>>> brcmsmac&   ath9k can share a common scan implementation they call into?
>>
>> Last thing we need is each driver having it's own complicated off-channel
>> scan logic.  It's bad enough having it in one place in mac80211.
>
> Well, so ... each driver will have to have its own channel switching
> logic for implementing multi-channel operation, and off-channel logic
> for scanning sorta falls into that. The scan logic could be similar to
> now, but I think essentially "remain_on_channel" will have to be
> supported by drivers.

I think mac80211 should have a good scan implementation, and just
let drivers without hw-scan use it.  The remain-on-channel could be
part of the work/scan logic in mac80211.  Sounds like you need
remain-on-channel work logic to make p2p work anyway?

>>> Authenticating&   associating seems fairly easy, we create a new vif and
>>> set it to the right channel and then do everything there -- simpler than
>>> what we have now -- but what about FT-OTA? What if the device supports
>>> only two channels and is a P2P GO on channel 1 and now wants to roam on
>>> the infrastructure connection, say from channel 36 to channel 11? How
>>> can we handle that?
>>
>> With just an improved off-channel work logic, and as much smarts as possible
>> to keep un-necessary channel flops and power-saving changes (and driver resets
>> in general) from happening?
>
> Thing is that this doesn't really work too well even today with a lot of
> devices we support, e.g. iwlwifi or even iwlegacy isn't really built to
> do this. You're mostly looking at it from an ath9k perspective I suppose
> where all of this is really quite simple :-)

If you can put the scan state machine into the work logic,
the work logic will get much better testing, and hopefully
that will simplify the on-off channel logic (just having no
scan_channel to worry about would simplify on/off channel
logic that I wrote (and which was just removed).

The only driver I have any idea about is ath9k:  What does iw* do
that makes this difficult?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

