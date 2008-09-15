Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:58711 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754799AbYIOVBb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2008 17:01:31 -0400
Subject: Re: [RFC][PATCH] TX status reporting with help of an ack queue
From: Mattias Nissler <mattias.nissler@gmx.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	Mikko =?ISO-8859-1?Q?Virkkil=E4?= <mikko.virkkila@bluegiga.com>,
	rt2400-devel@lists.sourceforge.net,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1221510785.3700.87.camel@johannes.berg>
References: <1221494693.14102.22.camel@virkkmi-linux>
	 <200809151911.32834.IvDoorn@gmail.com> <1221501417.4511.49.camel@localhost>
	 (sfid-20080915_195731_733752_74D2117C)  <1221501786.3700.68.camel@johannes.berg>
	 <1221505251.4511.77.camel@localhost>
	 (sfid-20080915_210128_632488_FB448E33)  <1221506496.3700.81.camel@johannes.berg>
	 <1221507551.4511.89.camel@localhost>
	 (sfid-20080915_213946_840165_74EE062B)  <1221507988.3700.84.camel@johannes.berg>
	 <1221510009.4511.99.camel@localhost>
	 (sfid-20080915_222042_138159_E2373F89)  <1221510785.3700.87.camel@johannes.berg>
Content-Type: text/plain
Date: Mon, 15 Sep 2008 23:01:27 +0200
Message-Id: <1221512487.4511.105.camel@localhost> (sfid-20080915_230135_247504_A19B3A6B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-09-15 at 22:33 +0200, Johannes Berg wrote:
> On Mon, 2008-09-15 at 22:20 +0200, Mattias Nissler wrote:
> 
> > Well, I'm a big fan of modularizing everything in a clean way. This
> > whole mac80211 thingy is complex enough... But I don't really care as
> > long as everybody here is happy with it. Let's wait what Mikko says,
> > it's his code so far.
> 
> Sure. If you manage to split it out entirely, maybe by some struct that
> drivers embed in their private vif struct, that'd be great too.
> 
> 
> > > But ACK is getting confusing, we're just reporting status based on
> > > reception (or non-reception!) of ACKs :) How about retries in the hw?
> > 
> > Retries in the hw? I don't understand? You mean that as a name?
> 
> Well, with all this we won't know how many times the hardware attempted
> to send a frame before it got an ACK, if it got one at all. We'd like to
> know this too, I guess, for the rate control algorithm.

That's right, the rate control algorithm might want to know. However,
the PID algorithm doesn't care too much about the number of retries, it
just classifies frames into the categories: successfull, single retry,
multiple retries (IIRC, that is).

Btw. lately I've been thinking about a new RC algo that simply
calculates the throughput achievable by a specific rate (based on the
estimated frame transmission failure ratio and transmission times) and
then selects the one that provides the best throughput. It's still a
very vague idea, but I think it might be interesting to try.

Mattias

