Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:37202 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932574Ab1KIRsX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Nov 2011 12:48:23 -0500
Message-ID: <4EBABCE2.5000007@candelatech.com> (sfid-20111109_184835_501148_BA9051ED)
Date: Wed, 09 Nov 2011 09:48:18 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: off- & multi-channel operation
References: <1320844134.3845.61.camel@jlt3.sipsolutions.net>
In-Reply-To: <1320844134.3845.61.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/09/2011 05:08 AM, Johannes Berg wrote:
> All,
>
> I'm thinking about all the off-channel bugs and multi-channel operation.
>
> We currently have at least one rather important bug: Almost every call
> to ieee80211_tx_skb()/ieee80211_xmit() is wrong because it assumes we
> are on the operating channel. This leads to bugs such as
> https://bugzilla.redhat.com/attachment.cgi?id=530264
> (https://bugzilla.redhat.com/show_bug.cgi?id=749125) where I'd say we
> are sending a frame for connection monitoring while doing some work on
> another channel.
>
> The other thing is more of a design issue: we have multiple ways to
> leave the operating channel: scanning&  work. Soon we'll have to deal
> with multi-channel *operation* so we'll have multiple operating
> channels. I don't even want to have to handle that in mac80211, and I
> think we'll have to push it into devices (or drivers in some cases). In
> my opinion, these two ways should be consolidated.

Seems like you could move the scanning into the work logic.  That might
be a good first step to simplify the off-channel stuff.  And, once you get
the off-channel stuff working better, it would seem to me that just using
that for your off-channel interfaces might be better than trying to re-write
everything and force a bunch of new functionality down into drivers.

For drivers/NICS that can handle off-channel stuff themselves, hopefully
you can add some new API or new arguments to existing API to help
leverage that.

> Also, as devices (or drivers) get more complex, we find ourselves
> further and further away from a model where mac80211 is truly fully
> controlling the device. Given the differences in hardware we support
> now, I think that it obvious now that we need drivers to be smarter in
> many cases.
>
> How do we want to handle these things? I'm sure I want the drivers to
> handle multi-channel operation fairly transparently, with multiple
> (hardware) queues (in the driver), so mac80211 doesn't have to
> start/stop the queues continuously and can just transmit on that
> interface, the frame might only go out a bit later.

This sounds like a very big change.  I think it will somehow have
to be done in stages, maintaining support for the existing API
for a while so that drivers can be migrated to the new
framework at leisure.

> But then what about scanning? Can we, and should we, force such drivers
> to implement hw_scan? I think maybe we should, and maybe drivers such as
> brcmsmac&  ath9k can share a common scan implementation they call into?

Last thing we need is each driver having it's own complicated off-channel
scan logic.  It's bad enough having it in one place in mac80211.

> Authenticating&  associating seems fairly easy, we create a new vif and
> set it to the right channel and then do everything there -- simpler than
> what we have now -- but what about FT-OTA? What if the device supports
> only two channels and is a P2P GO on channel 1 and now wants to roam on
> the infrastructure connection, say from channel 36 to channel 11? How
> can we handle that?

With just an improved off-channel work logic, and as much smarts as possible
to keep un-necessary channel flops and power-saving changes (and driver resets
in general) from happening?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

