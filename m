Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.178]:55950 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752688AbYGUNIs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jul 2008 09:08:48 -0400
Received: by py-out-1112.google.com with SMTP id p76so1032875pyb.10
        for <linux-wireless@vger.kernel.org>; Mon, 21 Jul 2008 06:08:47 -0700 (PDT)
Subject: Re: [PATCH 20/31]: pkt_sched: Perform bulk of qdisc destruction
	in	RCU.
From: jamal <hadi@cyberus.ca>
Reply-To: hadi@cyberus.ca
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: davem@davemloft.net, kaber@trash.net, netdev@vger.kernel.org,
	johannes@sipsolutions.net, linux-wireless@vger.kernel.org
In-Reply-To: <E1KKu2D-0002kd-00@gondolin.me.apana.org.au>
References: <E1KKu2D-0002kd-00@gondolin.me.apana.org.au>
Content-Type: text/plain
Date: Mon, 21 Jul 2008 09:08:44 -0400
Message-Id: <1216645724.4847.275.camel@localhost> (sfid-20080721_150859_777395_EFF563F6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-21-07 at 19:58 +0800, Herbert Xu wrote:

> I think I get you now.  You're suggesting that we essentially
> do what Dave has right now in the non-contending case, i.e.,
> bypassing the qdisc so we get fully parallel processing until
> one of the hardware queues seizes up.

yes. That way there is no need for an intermediate queueing. As it is
now, packets first get queued to qdisc then we dequeu and send to driver
even when the driver would be happy to take it. That approach is fine
if you want to support non-work conserving schedulers on single-hwqueue
hardware.

> At that point you'd stop all queues and make every packet go
> through the software qdisc to ensure ordering.  This continues
> until all queues have vacancies again.

I always visualize these as a single netdevice per hardware tx queue.
If i understood correctly, ordering is taken care of already in the
current patches because the  stateless filter selects a hardware-queue.

Dave has those queues sitting as a qdisc level (as pfifo) - which seems
better in retrospect (than what i was thinking that they should sit in
the driver) because one could decide they want to shape packets in the
future on a per-virtual-customer-sharing-a-virtual-wire and attach an
HTB instead.

The one thing i am unsure of still:
I think it would be cleaner to just stop a single queue (instead of all)
when one hardware queue fills up. i.e if there is no congestion on the
other hardware queues, packets should continue to be fed to their
hardware queues and not be buffered at qdisc level.

> If this is what you're suggesting, then I think that will offer
> pretty much the same behaviour as what we've got, while still
> offering at least some (perhaps even most, but that is debatable)
> of the benefits of multi-queue.
> 
> At this point I don't think this is something that we need right
> now, but it would be good to make sure that the architecture
> allows such a thing to be implemented in future.

I think it is a pretty good first start (I am a lot more optimistic to
be honest).
Parallelization would work if you can get X CPUs to send to X hardware
queues concurently. Feasible in static host setup like virtualization
environment where you can tie a vm to a cpu. Not very feasible in
routing where you are driven to a random hardware tx queue by arriving
packets.

cheers,
jamal

