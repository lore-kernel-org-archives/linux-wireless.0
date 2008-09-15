Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:58813 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754129AbYIOVlZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2008 17:41:25 -0400
Subject: Re: [RFC][PATCH] TX status reporting with help of an ack queue
From: Mattias Nissler <mattias.nissler@gmx.de>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Mikko =?ISO-8859-1?Q?Virkkil=E4?= <mikko.virkkila@bluegiga.com>,
	rt2400-devel@lists.sourceforge.net,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200809152328.50471.IvDoorn@gmail.com>
References: <1221494693.14102.22.camel@virkkmi-linux>
	 <1221510009.4511.99.camel@localhost>
	 <1221510785.3700.87.camel@johannes.berg>
	 <200809152328.50471.IvDoorn@gmail.com>
Content-Type: text/plain
Date: Mon, 15 Sep 2008 23:41:21 +0200
Message-Id: <1221514881.4511.118.camel@localhost> (sfid-20080915_234140_241514_0F2B9B2F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-09-15 at 23:28 +0200, Ivo van Doorn wrote:
> On Monday 15 September 2008, Johannes Berg wrote:
> > On Mon, 2008-09-15 at 22:20 +0200, Mattias Nissler wrote:
> > 
> > > Well, I'm a big fan of modularizing everything in a clean way. This
> > > whole mac80211 thingy is complex enough... But I don't really care as
> > > long as everybody here is happy with it. Let's wait what Mikko says,
> > > it's his code so far.
> > 
> > Sure. If you manage to split it out entirely, maybe by some struct that
> > drivers embed in their private vif struct, that'd be great too.
> 
> I think the ACK handling could become quite complex, and although it
> would be nice to modularize it a bit, however I am not really sure about
> what the best approach would be for the implementation other then that
> the driver should do as little as possible. ;)

Huh? I think a single function call for the matching in the rx path is
enough. You call it in the rx handler for every received frame. It
returns true if it found a match and reported the tx status (in which
case you stop processing) or false and you can go on doing with the
frame whatever you want. Am I missing something?

> 
> Perhaps Mikko or the zd1211rw developers will have better ideas on this subject. :)
> 
> > > > But ACK is getting confusing, we're just reporting status based on
> > > > reception (or non-reception!) of ACKs :) How about retries in the hw?
> > > 
> > > Retries in the hw? I don't understand? You mean that as a name?
> > 
> > Well, with all this we won't know how many times the hardware attempted
> > to send a frame before it got an ACK, if it got one at all. We'd like to
> > know this too, I guess, for the rate control algorithm.
> 
> Well this information would definately get lost with this ACK handling,
> but at least we get *some* information about the TX status. ;)

The (not) failed decision is definitely enough to get the PID algo doing
something useful.

Mattias

