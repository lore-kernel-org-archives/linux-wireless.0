Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:60504 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429Ab0DZMYJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Apr 2010 08:24:09 -0400
Subject: Re: [RFC PATCHv3 1/2] mac80211: Determine dynamic PS timeout based
 on ps-qos network latency
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: ext Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1272283911.3619.29.camel@jlt3.sipsolutions.net>
References: <1271409274-17162-1-git-send-email-juuso.oikarinen@nokia.com>
	 <1271409274-17162-2-git-send-email-juuso.oikarinen@nokia.com>
	 <1271688177.23671.1.camel@jlt3.sipsolutions.net>
	 <1271740120.6205.5733.camel@wimaxnb.nmp.nokia.com>
	 <1271925939.3605.7.camel@jlt3.sipsolutions.net>
	 <1271926547.6205.8870.camel@wimaxnb.nmp.nokia.com>
	 <1271927257.3605.18.camel@jlt3.sipsolutions.net>
	 <1271928576.6205.8919.camel@wimaxnb.nmp.nokia.com>
	 <1272282845.3619.25.camel@jlt3.sipsolutions.net>
	 <1272283483.6205.10416.camel@wimaxnb.nmp.nokia.com>
	 <1272283911.3619.29.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 26 Apr 2010 15:23:07 +0300
Message-ID: <1272284587.6205.10424.camel@wimaxnb.nmp.nokia.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-04-26 at 14:11 +0200, ext Johannes Berg wrote:
> On Mon, 2010-04-26 at 15:04 +0300, Juuso Oikarinen wrote:
> 
> > > Well I would argue that if the user requires a certain network latency,
> > > that should take precedence. The user is unlikely to be thinking in
> > > terms of "I want my battery to last that long"; rather they want to last
> > > it as long as possible given their quality of service demand
> > > constraints?
> > 
> > Well, this is not entirely correct. In the situation I'm thinking about,
> > the user (the user space network manager is acting on behalf of him)
> > thinks exactly on the lines of "I want my battery to last that long, or
> > longer." The device is in the users pocket, WLAN associated. He does not
> > care about latency at all, so the network manager sets a large enough
> > latency value that allows the WLAN subsystem to sacrifice all latency to
> > just reduce power consumption.
> 
> But in that case you also don't care about latency, obviously. So you
> can just say "don't care about latency", and get all the power savings
> that are possible in such a situation.

Well throw me a bone here! :)

That is essentially what I try to accomplish here! There just currently
isn't a way to say that to cfg80211. You can't say "I don't care about
latency, save as much power as you can."

> Basically there's a trade-off here between power consumption and
> latency. I'm arguing that one should control latency, and power
> consumption follows "best effort", but you seem to also be arguing that
> in some situations one should control power consumption, and latency
> gets bad.
> 
> > > > The ps_timeout could be calculated based on the latency too, I guess.
> > > > I'm just not aware of any simple formula to do this.
> > > 
> > > But you did just base it on that?
> > 
> > Yeah, sorry, I intended to say "based on beacon interval and latency."
> 
> Which might actually make sense, because if for instance required
> latency >> beacon interval, there's not much gain from dynamic power
> saving timeouts.
> 
> > > It just seems to me that you're putting the power consumption
> > > requirements after the quality of service demands, which would seem
> > > wrong?
> > 
> > I'm sorry, I don't understand this statement (literally). To argue
> > anyway: I'm thinking I'm binding power consumption requirements together
> > with QoS demands. :)
> 
> Yeah, but I have a feeling you're thinking about power consumption too
> much. I understand that is a goal, but shouldn't the goal be stated as
> "provide the lowest power consumption under the latency QoS
> constraints"?


Heh, I could in turn say that you think too little about power
consumption :) This particular thing, dynamic ps timer, has a *huge*
effect on the total power consumption just because it's so frequent.

I'm basically open for any means to tell cfg80211 that it should
sacrifice service quality in the name of saving as much power as it can
(apart from shutting the thing down :). Can you give me a hint on what
you would consider an acceptable way to do this?

-Juuso


> johannes
> 


