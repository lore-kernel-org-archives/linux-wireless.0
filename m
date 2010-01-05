Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:40376 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755175Ab0AERU3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jan 2010 12:20:29 -0500
Date: Tue, 5 Jan 2010 18:20:27 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless@vger.kernel.org, Felix Fietkau <nbd@openwrt.org>,
	Sasidhar Subramaniam <Sasidhar.Subramaniam@atheros.com>,
	Senthilkumar Balasubramanian
	<Senthilkumar.Balasubramanian@atheros.com>
Subject: Re: infinite transmit buffering issue in 2.6.32 mac80211
Message-ID: <20100105172027.GS1735@mail.wantstofly.org>
References: <20100105083803.GP1735@mail.wantstofly.org> <43e72e891001050901v2d07ddd9m16789b200f096ef8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <43e72e891001050901v2d07ddd9m16789b200f096ef8@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Luis,


On Tue, Jan 05, 2010 at 09:01:23AM -0800, Luis R. Rodriguez wrote:

> > Routing from a wired interface to wireless, and flooding the wired
> > interface with traffic to be routed, say with a traffic generator (for
> > performance testing) can trigger OOM and cripple the box in seconds,
> > but I think (but haven't verified) that even just simple non-forwarded
> > bulk TCP upload should be able to trigger OOM as well on sufficiently
> > constrained machines.
> 
> Don't traffic generators typically cripple boxes though?

The way that the traffic generators I have access to will try to
establish wired routing performance is by determining the maximum
loss-free forwarding rate that a certain setup can handle, i.e. the
maximum data rate at which there is 0% packet loss.  This tends to
be done by binary search -- transmitting data at 1000 Mb/s, 500 Mb/s,
250 Mb/s, 125 Mb/s, etc until there is no packet loss anymore, and
then increasing the transmit rate again, etc.

All hardware of course has its performance limits.  If you stress it
beyond those limits, it should simply drop packets, and while it is
probably acceptable that it will become temporarily unresponsive during
the test, it should not crash or go OOM like 2.6.32 will happily do.


> How about with plain iperf pusing 1gbit/s over the ethernet and
> routing out via the wireless interface?

It won't manage to keep up.  But before 2.6.32, at most 1000 packets
would accumulate in the wmaster0 qdisc, and any packets after that
would be dropped in net/sched/sch_generic.c:pfifo_fast_enqueue().  As
of 2.6.32, it will keep queuing packets in mac80211 ad infinitum.


> > The only way I see to solve all of these issues cleanly is to convert
> > the AP/STA/etc subinterfaces to be multiqueue interfaces, with the same
> > number of transmit queues as the hardware has, so that there are
> > independently stoppable/resumable virtual output queues all the way
> > from userland to the actual hardware, and then to stop/resume those
> > queues in response to the hardware DMA queues filling up and draining.
> 
> How does this resolve the main OOM issues you are seeing though? I
> don't see the link yet.

Once you stop the queues on the devices via netif_stop_queue (or one
of the subqueue variants), the qdisc attached to the netdev will take
over and start queueing packets that are handed to netif_queue_xmit().

The default qdisc is pfifo_fast, and its default limit is 1000, so any
packets that we're trying to queue beyond the 1000th will be dropped
by pfifo_fast -- i.e. the in-stack queueing that will kick in once you
stop the netdev queue is limited to 1000 packets.  (Which is probably
OK for gigabit but _way_ too many for typical wireless data rates --
but that's an issue for another day.)


cheers,
Lennert
