Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:54787 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754321AbYIOUUN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2008 16:20:13 -0400
Subject: Re: [RFC][PATCH] TX status reporting with help of an ack queue
From: Mattias Nissler <mattias.nissler@gmx.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	Mikko =?ISO-8859-1?Q?Virkkil=E4?= <mikko.virkkila@bluegiga.com>,
	rt2400-devel@lists.sourceforge.net,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1221507988.3700.84.camel@johannes.berg>
References: <1221494693.14102.22.camel@virkkmi-linux>
	 <200809151911.32834.IvDoorn@gmail.com> <1221501417.4511.49.camel@localhost>
	 (sfid-20080915_195731_733752_74D2117C)  <1221501786.3700.68.camel@johannes.berg>
	 <1221505251.4511.77.camel@localhost>
	 (sfid-20080915_210128_632488_FB448E33)  <1221506496.3700.81.camel@johannes.berg>
	 <1221507551.4511.89.camel@localhost>
	 (sfid-20080915_213946_840165_74EE062B)  <1221507988.3700.84.camel@johannes.berg>
Content-Type: text/plain
Date: Mon, 15 Sep 2008 22:20:09 +0200
Message-Id: <1221510009.4511.99.camel@localhost> (sfid-20080915_222018_454070_D5F512EA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-09-15 at 21:46 +0200, Johannes Berg wrote:
> On Mon, 2008-09-15 at 21:39 +0200, Mattias Nissler wrote:
> 
> > > Yes, but we could also make the ack queue processing part of mac80211,
> > > i.e. we stick the packet on the queue before ->tx() and add a few new
> > > flags to the status callback which can then process the queue.
> > 
> > Just to get this straight: By queue you mean the to-be-introduced
> > unknown status queue?
> 
> Yes.
> 
> > Of course you can do it that way, but then you'll have all the flags and
> > data structures built into mac80211 unconditionally instead of letting
> > the driver developer decide.
> 
> Oh, I'm fine with building them in there as long as the code paths
> aren't actually used for drivers that don't need them. This isn't a big
> thing.

Well, I'm a big fan of modularizing everything in a clean way. This
whole mac80211 thingy is complex enough... But I don't really care as
long as everybody here is happy with it. Let's wait what Mikko says,
it's his code so far.

> 
> > > > Good point :-) So I suggest we have one function that adds new packets
> > > > to the ACK queue (which is represented by a struct an instance of which
> > > > a driver can keep in its queue information) and another one that matches
> > > > a received ACK with the queue, reports the status to mac80211 and purges
> > > > the queue entries up to the match (reporting them as failed).
> > > 
> > > can we stop talking about "ACK queue"? It really is a "unknown status
> > > queue" or something like that.
> > 
> > Ok, I don't really care how it's called as long as the one writing that
> > stuff chooses an appropriate name in the code :-)
> 
> :)
> But ACK is getting confusing, we're just reporting status based on
> reception (or non-reception!) of ACKs :) How about retries in the hw?

Retries in the hw? I don't understand? You mean that as a name?

Mattias

