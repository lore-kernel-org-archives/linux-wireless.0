Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:58430 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872Ab0DZMF2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Apr 2010 08:05:28 -0400
Subject: Re: [RFC PATCHv3 1/2] mac80211: Determine dynamic PS timeout based
 on ps-qos network latency
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: ext Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1272282845.3619.25.camel@jlt3.sipsolutions.net>
References: <1271409274-17162-1-git-send-email-juuso.oikarinen@nokia.com>
	 <1271409274-17162-2-git-send-email-juuso.oikarinen@nokia.com>
	 <1271688177.23671.1.camel@jlt3.sipsolutions.net>
	 <1271740120.6205.5733.camel@wimaxnb.nmp.nokia.com>
	 <1271925939.3605.7.camel@jlt3.sipsolutions.net>
	 <1271926547.6205.8870.camel@wimaxnb.nmp.nokia.com>
	 <1271927257.3605.18.camel@jlt3.sipsolutions.net>
	 <1271928576.6205.8919.camel@wimaxnb.nmp.nokia.com>
	 <1272282845.3619.25.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 26 Apr 2010 15:04:43 +0300
Message-ID: <1272283483.6205.10416.camel@wimaxnb.nmp.nokia.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-04-26 at 13:54 +0200, ext Johannes Berg wrote:
> On Thu, 2010-04-22 at 12:29 +0300, Juuso Oikarinen wrote:
> 
> > > Still I think you should say why you need to actually tune the PS
> > > timeout value directly? I can't see how your high-level design says "set
> > > dynamic PS timeout to 100ms" rather than "make sure that while the user
> > > is operating the device, there's no delay of more than 50ms" or
> > > something like that?
> > 
> > You're partly right asking this. The high-level design obviously does
> > not know about dynamic PS timeouts. It seems you're mainly looking at
> > this from the angle of the network latency itself - i.e. network
> > performance. My primary angle currently is power consumption.
> > 
> > IMHO both angles are correct. The if the user sets a tight
> > network-latency requirement, the value can be used to tune things so
> > that the requirement can be met. If they set a loose requirement, it can
> > be used as a signal to do more aggressive power saving, which often
> > means reduced latency.
> 
> Well I would argue that if the user requires a certain network latency,
> that should take precedence. The user is unlikely to be thinking in
> terms of "I want my battery to last that long"; rather they want to last
> it as long as possible given their quality of service demand
> constraints?

Well, this is not entirely correct. In the situation I'm thinking about,
the user (the user space network manager is acting on behalf of him)
thinks exactly on the lines of "I want my battery to last that long, or
longer." The device is in the users pocket, WLAN associated. He does not
care about latency at all, so the network manager sets a large enough
latency value that allows the WLAN subsystem to sacrifice all latency to
just reduce power consumption.

> 
> > While the mechanism I'm proposing here is rather crude, it does save
> > power when the user-space loosens their latency requirement. The values
> > chosen for the dynamic ps-timeout bear no direct relation to user space
> > requirements. They are simply values that we have found to give decent
> > results in typical AP configurations.
> > 
> > The ps_timeout could be calculated based on the latency too, I guess.
> > I'm just not aware of any simple formula to do this.
> 
> But you did just base it on that?

Yeah, sorry, I intended to say "based on beacon interval and latency."

> It just seems to me that you're putting the power consumption
> requirements after the quality of service demands, which would seem
> wrong?

I'm sorry, I don't understand this statement (literally). To argue
anyway: I'm thinking I'm binding power consumption requirements together
with QoS demands. :)

-Juuso

> johannes
> 


