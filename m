Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:55036 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753215AbYIOTjR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2008 15:39:17 -0400
Subject: Re: [RFC][PATCH] TX status reporting with help of an ack queue
From: Mattias Nissler <mattias.nissler@gmx.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	Mikko =?ISO-8859-1?Q?Virkkil=E4?= <mikko.virkkila@bluegiga.com>,
	rt2400-devel@lists.sourceforge.net,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1221506496.3700.81.camel@johannes.berg>
References: <1221494693.14102.22.camel@virkkmi-linux>
	 <200809151911.32834.IvDoorn@gmail.com> <1221501417.4511.49.camel@localhost>
	 (sfid-20080915_195731_733752_74D2117C)  <1221501786.3700.68.camel@johannes.berg>
	 <1221505251.4511.77.camel@localhost>
	 (sfid-20080915_210128_632488_FB448E33)  <1221506496.3700.81.camel@johannes.berg>
Content-Type: text/plain
Date: Mon, 15 Sep 2008 21:39:11 +0200
Message-Id: <1221507551.4511.89.camel@localhost> (sfid-20080915_213921_815666_5E374E5A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-09-15 at 21:21 +0200, Johannes Berg wrote:
> On Mon, 2008-09-15 at 21:00 +0200, Mattias Nissler wrote:
> 
> > Ok. If we take this path I think we do not need to add more flags to
> > mac80211 and the drivers that enable special processing w.r.t. the
> > device packet filters (as suggested by Ivo previously). Instead, the
> > driver itself should take whatever action is necessary to tell the
> > hardware to deliver ACK frames.
> 
> Yes, but we could also make the ack queue processing part of mac80211,
> i.e. we stick the packet on the queue before ->tx() and add a few new
> flags to the status callback which can then process the queue.

Just to get this straight: By queue you mean the to-be-introduced
unknown status queue?

Of course you can do it that way, but then you'll have all the flags and
data structures built into mac80211 unconditionally instead of letting
the driver developer decide.

> 
> > Johannes, could you recap for me
> > whether the driver should report these additional ACKs to mac80211 or
> > keep quiet if they weren't requested?
> 
> This is largely theoretical right now as mac80211 is _always_ requesting
> status reports via IEEE80211_TX_CTL_REQ_TX_STATUS. This is something I
> can't talk much about, you helped designed the rate control algorithm
> and I think you're in a much better position to evaluate how this should
> work with respect to rate control.
> 
> Then again, I think I'm misunderstanding you, are you thinking whether
> it should hand those frames to mac80211? It doesn't matter to mac80211,
> to be honest.

Ok, that's what I meant.

> 
> > Good point :-) So I suggest we have one function that adds new packets
> > to the ACK queue (which is represented by a struct an instance of which
> > a driver can keep in its queue information) and another one that matches
> > a received ACK with the queue, reports the status to mac80211 and purges
> > the queue entries up to the match (reporting them as failed).
> 
> can we stop talking about "ACK queue"? It really is a "unknown status
> queue" or something like that.

Ok, I don't really care how it's called as long as the one writing that
stuff chooses an appropriate name in the code :-)

Mattias

