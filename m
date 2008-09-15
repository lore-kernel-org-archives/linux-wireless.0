Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:54827 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751795AbYIOTBD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2008 15:01:03 -0400
Subject: Re: [RFC][PATCH] TX status reporting with help of an ack queue
From: Mattias Nissler <mattias.nissler@gmx.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	Mikko =?ISO-8859-1?Q?Virkkil=E4?= <mikko.virkkila@bluegiga.com>,
	rt2400-devel@lists.sourceforge.net,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1221501786.3700.68.camel@johannes.berg>
References: <1221494693.14102.22.camel@virkkmi-linux>
	 <200809151911.32834.IvDoorn@gmail.com> <1221501417.4511.49.camel@localhost>
	 (sfid-20080915_195731_733752_74D2117C)  <1221501786.3700.68.camel@johannes.berg>
Content-Type: text/plain
Date: Mon, 15 Sep 2008 21:00:51 +0200
Message-Id: <1221505251.4511.77.camel@localhost> (sfid-20080915_210109_001293_801F36C4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-09-15 at 20:03 +0200, Johannes Berg wrote:
> > 2. Make the ACK queue approach generic and wrap it in some library
> > functions that become part of mac80211 and are called from the driver's
> > tx and rx handlers, respectively. This has the advantage that it is less
> > invasive than 1. It is essentially what Ivo has described above. Driver
> > writers would be free to use this framework, but are not required to do
> > so.
> 
> I think this is what we want.

Ok. If we take this path I think we do not need to add more flags to
mac80211 and the drivers that enable special processing w.r.t. the
device packet filters (as suggested by Ivo previously). Instead, the
driver itself should take whatever action is necessary to tell the
hardware to deliver ACK frames. Johannes, could you recap for me
whether the driver should report these additional ACKs to mac80211 or
keep quiet if they weren't requested?

> > > > This doesn't use timers so a message might in theory be
> > > > stuck in the queue indefinitely.
> > > 
> > > Well you wouldn't need timers actually, if you have a list of packets
> > > waiting to be acked you can expect the frames to be acked in the order
> > > of which they were send (when using the same queue).
> 
> Yes, hence you have to keep track of things per queue.

Good point :-) So I suggest we have one function that adds new packets
to the ACK queue (which is represented by a struct an instance of which
a driver can keep in its queue information) and another one that matches
a received ACK with the queue, reports the status to mac80211 and purges
the queue entries up to the match (reporting them as failed).

Mikko: I could hack this up, but since your initial patch is not far
from what's been discussed, I rather wait for a comment on whether you
want to do it.

Mattias

