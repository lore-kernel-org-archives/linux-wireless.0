Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60851 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752620Ab1KKKNi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Nov 2011 05:13:38 -0500
Subject: Re: off- & multi-channel operation
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <4EBADA61.5060506@candelatech.com>
References: <1320844134.3845.61.camel@jlt3.sipsolutions.net>
	 <4EBABCE2.5000007@candelatech.com>
	 <1320862529.3845.90.camel@jlt3.sipsolutions.net>
	 <4EBADA61.5060506@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 11 Nov 2011 11:13:32 +0100
Message-ID: <1321006412.3977.10.camel@jlt3.sipsolutions.net> (sfid-20111111_111342_314201_03372762)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-11-09 at 11:54 -0800, Ben Greear wrote:

> > However, it's not really going to work well for multi-channel capable
> > drivers: say the driver is continually switching between channels 1 and
> > 11 for multi-channel operation, but now you want to do a p2p listen
> > phase on channel 6. That needs to interact with the driver since it has
> > to stop switching, and it'd be much easier to have the driver manage
> > that interaction.
> 
> If mac80211 is controlling the channel switching with off-channel work
> items, can't it just keep the nic on channel 6 doing the p2p listen
> for the proper amount of time?  Why does the driver have to make
> the decision?

mac80211 isn't going to be controlling the switching between 1 and 11 at
all though. And there will be drivers like iwlwifi and wl12xx that want
to control the "stay on channel 6" as well.

> If you expect the driver might have pkts queued for multiple channels,
> and that is why it would be switching, then you could just have a mac80211
> call that says 'stay on this channel (6) until I tell you otherwise'.
> The driver could then stop it's automated switching.  That would seem
> fairly easy to implement.

Yes, that's what we'll probably need. Actually we already have that in a
way with the remain_on_channel, but it's not used for work/scan/etc.
today, only for p2p.

> Worst case, you flush all buffers and
> then it should certainly stop switching?  (The hard part would seem to be making the
> driver able to deal with multiple xmit queues and doing automated
> switching in the first place.  It certainly never worked well when
> ath9k tried to do something similar with virtual phys)

At least for iwlwifi I expect we'd have multiple hardware queues with
the uCode handling the switching.

> > Thing is that this doesn't really work too well even today with a lot of
> > devices we support, e.g. iwlwifi or even iwlegacy isn't really built to
> > do this. You're mostly looking at it from an ath9k perspective I suppose
> > where all of this is really quite simple :-)
> 
> If you can put the scan state machine into the work logic,
> the work logic will get much better testing, and hopefully
> that will simplify the on-off channel logic (just having no
> scan_channel to worry about would simplify on/off channel
> logic that I wrote (and which was just removed).
> 
> The only driver I have any idea about is ath9k:  What does iw* do
> that makes this difficult?

Uh, that would be a really really long explanation so I think for now
you'll just have to take my word for it. It's just the way the firmware
is designed.

johannes

