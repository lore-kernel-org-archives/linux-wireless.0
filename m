Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.182]:27399 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752140AbYGTWcy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jul 2008 18:32:54 -0400
Received: by py-out-1112.google.com with SMTP id p76so876628pyb.10
        for <linux-wireless@vger.kernel.org>; Sun, 20 Jul 2008 15:32:53 -0700 (PDT)
Subject: Re: [PATCH 20/31]: pkt_sched: Perform bulk of qdisc destruction in
	RCU.
From: jamal <hadi@cyberus.ca>
Reply-To: hadi@cyberus.ca
To: David Miller <davem@davemloft.net>
Cc: kaber@trash.net, netdev@vger.kernel.org, johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org
In-Reply-To: <20080720.102534.246150854.davem@davemloft.net>
References: <1216387641.4833.96.camel@localhost>
	 <20080718.140539.122169028.davem@davemloft.net>
	 <1216566963.4847.81.camel@localhost>
	 <20080720.102534.246150854.davem@davemloft.net>
Content-Type: text/plain
Date: Sun, 20 Jul 2008 18:32:50 -0400
Message-Id: <1216593170.4847.137.camel@localhost> (sfid-20080721_003303_071961_899A7E1C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2008-20-07 at 10:25 -0700, David Miller wrote:

> They tend to implement round-robin or some similar fairness algorithm
> amongst the queues, with zero concern about packet priorities.

pfifo_fast would be a bad choice in that case, but even a pfifo cannot
guarantee proper RR because it would present packets in a FIFO order
(and example the first 10 could go to hardware queue1 and the next to
hardware queue2).
 
My view: i think you need a software queue per hardware queue.
Maybe even these queues residing in the driver; that way you take care
of congestion and it doesnt matter if the hardware is RR or strict prio
(and you dont need the pfifo or pfifo_fast anymore).
The use case would be something along:
packets comes in, you classify find its for queue1, grab the
per-hardware-queue1 lock, find the hardware queue1 is overloaded and
stash it instead in s/ware queue1. If it wasnt congested, it would go on
hardware queue1.
When hardware queue1 becomes available and netif-woken, you pick first
from s/ware queue1 (and batching could apply cleanly here) and send them
to hardware queue.

> It really is just like a bunch of queues to the phsyical layer,
> fairly shared.

I am suprised prioritization is not an issue. [My understanding of the
intel/cisco datacentre cabal is they serve virtual machines using
virtual wires; i would think in such scenarios youd have some customers
who pay more than others].

> These things are built for parallelization, not prioritization.

Total parallelization happens in the ideal case. If X cpus classify
packets going to X different hardware queueus each CPU grabs only locks
for that hardware queue. In virtualization, where only one customer's
traffic is going to a specific hardware queue, things would work well.
Non-virtualization scenario may result in collision in which two or more
CPUs may contend for the same hardware queue (either transmitting or
netif-waking etc).
 
cheers,
jamal

