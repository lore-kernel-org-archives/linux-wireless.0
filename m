Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bluegiga.fi ([194.100.31.45]:36291 "EHLO darkblue.bluegiga.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751574AbYIPGYg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Sep 2008 02:24:36 -0400
Subject: Re: [RFC][PATCH] TX status reporting with help of an ack queue
From: Mikko =?ISO-8859-1?Q?Virkkil=E4?= <mikko.virkkila@bluegiga.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Mattias Nissler <mattias.nissler@gmx.de>,
	Ivo van Doorn <ivdoorn@gmail.com>,
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
Date: Tue, 16 Sep 2008 09:24:34 +0300
Message-Id: <1221546274.14102.88.camel@virkkmi-linux> (sfid-20080916_082440_592919_31F477F3)
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
> 
> johannes

My suggestion would be something along the lines of
awaiting_status_queue because the packets are waiting for status info
about their transmission.

To get the AP mode working (my main interest) hostapd needs to know that
the other party has received the packet so that it can advance in its
state machine without losing sync. 

The rate control algorithms on the other hand are probably interested in
getting a lot more details. Currently drivers seem to keep internal
statistics in addition to the external ones. Maybe some way of exporting
additional statistics is needed and tackling that should perhaps not be
tied to the status reporting? Rate control algorithms will probably also
want to modify re-transmission intervals, contention time settings etc.
Is there already some unified way of doing this?


Mikko

