Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:48642 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752831AbYIQXIc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Sep 2008 19:08:32 -0400
Subject: Re: [RFC][PATCH] TX status reporting with help of an ack queue
From: Mattias Nissler <mattias.nissler@gmx.de>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Mikko =?ISO-8859-1?Q?Virkkil=E4?= <mikko.virkkila@bluegiga.com>,
	rt2400-devel@lists.sourceforge.net,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200809162017.31956.IvDoorn@gmail.com>
References: <1221494693.14102.22.camel@virkkmi-linux>
	 <200809152328.50471.IvDoorn@gmail.com>
	 <1221514881.4511.118.camel@localhost>
	 <200809162017.31956.IvDoorn@gmail.com>
Content-Type: text/plain
Date: Thu, 18 Sep 2008 01:08:28 +0200
Message-Id: <1221692908.4488.5.camel@localhost> (sfid-20080918_010836_391313_881525C9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-09-16 at 20:17 +0200, Ivo van Doorn wrote:
> On Monday 15 September 2008, Mattias Nissler wrote:
> > On Mon, 2008-09-15 at 23:28 +0200, Ivo van Doorn wrote:
> > > On Monday 15 September 2008, Johannes Berg wrote:
> > > > On Mon, 2008-09-15 at 22:20 +0200, Mattias Nissler wrote:
> > > > 
> > > > > Well, I'm a big fan of modularizing everything in a clean way. This
> > > > > whole mac80211 thingy is complex enough... But I don't really care as
> > > > > long as everybody here is happy with it. Let's wait what Mikko says,
> > > > > it's his code so far.
> > > > 
> > > > Sure. If you manage to split it out entirely, maybe by some struct that
> > > > drivers embed in their private vif struct, that'd be great too.
> > > 
> > > I think the ACK handling could become quite complex, and although it
> > > would be nice to modularize it a bit, however I am not really sure about
> > > what the best approach would be for the implementation other then that
> > > the driver should do as little as possible. ;)
> > 
> > Huh? I think a single function call for the matching in the rx path is
> > enough. You call it in the rx handler for every received frame. It
> > returns true if it found a match and reported the tx status (in which
> > case you stop processing) or false and you can go on doing with the
> > frame whatever you want. Am I missing something?
> 
> Although this isn't much overhead for a driver, but if it comes down
> to a single function call anyway, why not handle it in mac80211 completely?

Simply because most drivers don't need it and it adds another item to
mac80211's bag of complex stuff to understand ;-)

Mattias

