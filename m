Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45455
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751345AbYGURfx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jul 2008 13:35:53 -0400
Date: Mon, 21 Jul 2008 10:35:53 -0700 (PDT)
Message-Id: <20080721.103553.121723118.davem@davemloft.net> (sfid-20080721_193557_755761_4EF7744D)
To: herbert@gondor.apana.org.au
Cc: hadi@cyberus.ca, kaber@trash.net, netdev@vger.kernel.org,
	johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 20/31]: pkt_sched: Perform bulk of qdisc destruction in
 RCU.
From: David Miller <davem@davemloft.net>
In-Reply-To: <E1KKu2D-0002kd-00@gondolin.me.apana.org.au>
References: <1216606839.4847.159.camel@localhost>
	<E1KKu2D-0002kd-00@gondolin.me.apana.org.au>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Mon, 21 Jul 2008 19:58:33 +0800

> I think I get you now.  You're suggesting that we essentially
> do what Dave has right now in the non-contending case, i.e.,
> bypassing the qdisc so we get fully parallel processing until
> one of the hardware queues seizes up.
> 
> At that point you'd stop all queues and make every packet go
> through the software qdisc to ensure ordering.  This continues
> until all queues have vacancies again.
> 
> If this is what you're suggesting, then I think that will offer
> pretty much the same behaviour as what we've got, while still
> offering at least some (perhaps even most, but that is debatable)
> of the benefits of multi-queue.
> 
> At this point I don't think this is something that we need right
> now, but it would be good to make sure that the architecture
> allows such a thing to be implemented in future.

Doing something like the noqueue_qdisc (bypassing the qdisc entirely)
is very attractive because it eliminates the qdisc lock.  We're only
left with the TX lock.

This whole idea of doing an optimized send to the device when the
TX queue has space is indeed tempting.

But we can't do it for qdiscs that measure rates, enforce limits, etc.

And if the device kicks back at us with an error, we have to
perform the normal ->enqueue() path.
