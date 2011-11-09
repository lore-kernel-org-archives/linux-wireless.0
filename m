Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41504 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171Ab1KISPe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Nov 2011 13:15:34 -0500
Subject: Re: off- & multi-channel operation
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <4EBABCE2.5000007@candelatech.com>
References: <1320844134.3845.61.camel@jlt3.sipsolutions.net>
	 <4EBABCE2.5000007@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 09 Nov 2011 19:15:29 +0100
Message-ID: <1320862529.3845.90.camel@jlt3.sipsolutions.net> (sfid-20111109_191537_062875_2C7EB40D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-11-09 at 09:48 -0800, Ben Greear wrote:

> > The other thing is more of a design issue: we have multiple ways to
> > leave the operating channel: scanning&  work. Soon we'll have to deal
> > with multi-channel *operation* so we'll have multiple operating
> > channels. I don't even want to have to handle that in mac80211, and I
> > think we'll have to push it into devices (or drivers in some cases). In
> > my opinion, these two ways should be consolidated.
> 
> Seems like you could move the scanning into the work logic.  That might
> be a good first step to simplify the off-channel stuff.  And, once you get
> the off-channel stuff working better, it would seem to me that just using
> that for your off-channel interfaces might be better than trying to re-write
> everything and force a bunch of new functionality down into drivers.

Yeah, I had that thought a long time ago, it just never happened :-)

However, it's not really going to work well for multi-channel capable
drivers: say the driver is continually switching between channels 1 and
11 for multi-channel operation, but now you want to do a p2p listen
phase on channel 6. That needs to interact with the driver since it has
to stop switching, and it'd be much easier to have the driver manage
that interaction.

> For drivers/NICS that can handle off-channel stuff themselves, hopefully
> you can add some new API or new arguments to existing API to help
> leverage that.

We have some APIs already, but they aren't actually used for things like
auth/assoc etc. and are optional at this point so we can't start using
them either.

> > Also, as devices (or drivers) get more complex, we find ourselves
> > further and further away from a model where mac80211 is truly fully
> > controlling the device. Given the differences in hardware we support
> > now, I think that it obvious now that we need drivers to be smarter in
> > many cases.
> >
> > How do we want to handle these things? I'm sure I want the drivers to
> > handle multi-channel operation fairly transparently, with multiple
> > (hardware) queues (in the driver), so mac80211 doesn't have to
> > start/stop the queues continuously and can just transmit on that
> > interface, the frame might only go out a bit later.
> 
> This sounds like a very big change.  I think it will somehow have
> to be done in stages, maintaining support for the existing API
> for a while so that drivers can be migrated to the new
> framework at leisure.

I agree, and in fact I think support for devices that can only handle a
single channel (or where nobody can be bothered to write driver support)
needs to be done in a very easy way, possibly completely integrated in
mac80211.

> > But then what about scanning? Can we, and should we, force such drivers
> > to implement hw_scan? I think maybe we should, and maybe drivers such as
> > brcmsmac&  ath9k can share a common scan implementation they call into?
> 
> Last thing we need is each driver having it's own complicated off-channel
> scan logic.  It's bad enough having it in one place in mac80211.

Well, so ... each driver will have to have its own channel switching
logic for implementing multi-channel operation, and off-channel logic
for scanning sorta falls into that. The scan logic could be similar to
now, but I think essentially "remain_on_channel" will have to be
supported by drivers.

> > Authenticating&  associating seems fairly easy, we create a new vif and
> > set it to the right channel and then do everything there -- simpler than
> > what we have now -- but what about FT-OTA? What if the device supports
> > only two channels and is a P2P GO on channel 1 and now wants to roam on
> > the infrastructure connection, say from channel 36 to channel 11? How
> > can we handle that?
> 
> With just an improved off-channel work logic, and as much smarts as possible
> to keep un-necessary channel flops and power-saving changes (and driver resets
> in general) from happening?

Thing is that this doesn't really work too well even today with a lot of
devices we support, e.g. iwlwifi or even iwlegacy isn't really built to
do this. You're mostly looking at it from an ath9k perspective I suppose
where all of this is really quite simple :-)

johannes

