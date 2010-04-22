Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42252 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752185Ab0DVJFp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Apr 2010 05:05:45 -0400
Subject: Re: [RFC PATCHv3 1/2] mac80211: Determine dynamic PS timeout based
 on ps-qos network latency
From: Johannes Berg <johannes@sipsolutions.net>
To: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1271926547.6205.8870.camel@wimaxnb.nmp.nokia.com>
References: <1271409274-17162-1-git-send-email-juuso.oikarinen@nokia.com>
	 <1271409274-17162-2-git-send-email-juuso.oikarinen@nokia.com>
	 <1271688177.23671.1.camel@jlt3.sipsolutions.net>
	 <1271740120.6205.5733.camel@wimaxnb.nmp.nokia.com>
	 <1271925939.3605.7.camel@jlt3.sipsolutions.net>
	 <1271926547.6205.8870.camel@wimaxnb.nmp.nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 22 Apr 2010 11:05:43 +0200
Message-ID: <1271927143.3605.16.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-04-22 at 11:55 +0300, Juuso Oikarinen wrote:

> > > Well you have to see where I'm coming from - I must come up with a way
> > > to tune the dynamic ps timeout value from user-space in a way that is
> > > agreeable with others, and that is somewhat future-proof.
> > 
> > Well I personally think that's your first mistake ;)
> > 
> > Why does userspace care about the dynamic PS timeout value to start
> > with? All it should care about is the latency with which it can react to
> > network packets, no?
> > 
> > > That said, obviously the network latency should be tuned as, well, the
> > > expected network latency. In this phase though, there are no other
> > > parameters affected by the network latency, so the result is quite
> > > obvious - your fear will realise itself ;)
> > 
> > But there are, like the max sleep period in # of beacons.
> 
> Yeah, okay there is. You probably noticed I posted a version of the
> patches with "saner" latency-values for this reason.

Right.

> I think there is something fishy in the max-sleep-period implementation.
> I don't yet understand it fully, but it seems to me the host is trying
> to set up it's own dtim interval, regardless of what the AP is
> configured with. It seems to me that this could lead to loss of
> broadcast/multicast frames, if the sta is not waking up a AP dtim
> beacons, but instead has its own cycle. But I have to look into this
> deeper at some point, so let's not get caught in this now.

Ah, I guess you can't just use the value we calculate as the real
period, it's just the max. This depends on the device implementation
though. If your device needs to have a value "wake up ever N beacons"
then in fact you cannot use the value but have to use gcd(value, dtim).
But if the device can e.g. "wake up after N, N, N, M beacons" then you
can set N=value, M=dtim_period-3*value or something like that ...

johannes

