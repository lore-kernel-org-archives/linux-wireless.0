Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.236]:39823 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429AbYHVNnr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Aug 2008 09:43:47 -0400
Received: by rv-out-0506.google.com with SMTP id k40so440387rvb.1
        for <linux-wireless@vger.kernel.org>; Fri, 22 Aug 2008 06:43:46 -0700 (PDT)
Subject: Re: [PATCH 20/31]: pkt_sched: Perform bulk of qdisc destruction in
	RCU.
From: jamal <hadi@cyberus.ca>
Reply-To: hadi@cyberus.ca
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: David Miller <davem@davemloft.net>, kaber@trash.net,
	netdev@vger.kernel.org, johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org
In-Reply-To: <20080822065655.GA18471@gondor.apana.org.au>
References: <20080721164306.GA13131@gondor.apana.org.au>
	 <20080721.095124.89249903.davem@davemloft.net>
	 <20080721170233.GA13417@gondor.apana.org.au>
	 <20080721.100821.38432201.davem@davemloft.net>
	 <20080721171141.GA13573@gondor.apana.org.au>
	 <20080822065655.GA18471@gondor.apana.org.au>
Content-Type: text/plain
Date: Fri, 22 Aug 2008 09:43:42 -0400
Message-Id: <1219412622.4672.34.camel@localhost> (sfid-20080822_154354_252031_859C5A26)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2008-22-08 at 16:56 +1000, Herbert Xu wrote:
> On Tue, Jul 22, 2008 at 01:11:41AM +0800, Herbert Xu wrote:
> > On Mon, Jul 21, 2008 at 10:08:21AM -0700, David Miller wrote:

> I haven't had a chance to do the test yet but I've just had an
> idea of how we can get the best of both worlds.
> 
> The problem with always directing traffic based on the CPU alone
> is that processes move around and we don't want to introduce packet
> reordering because to that.

Assuming multi-rx queues with configurable MSI or otherwise to map
to a receive processor, then in the case of routing/bridging or
otherfavoriteformofforwarding:
If you tie static filters to a specific cpu that will always work.
So no reordering there.
Local traffic i can see migration/reordering happening.

> The problem with hashing based on packet headers alone is that
> it doesn't take CPU affinity into account at all so we may end
> up with a situation where one thread out of a thread pool (e.g.,
> a web server) has n sockets which are hashed to n different
> queues.

Indeed. In the forwarding case, the problem is not reordering rather
all flows will always end up in the same cpu. So if you may end up
just overloading one cpu while the other 1023 stayed idle.
My earlier statement was you could cook traffic scenarios where all
1024 are being fully utilized (the operative term is "cook");->

> So here's the idea, we determine the tx queue for a flow based
> on the CPU on which we saw its first packet.  Once we have decided
> on a queue we store that in a dst object (see below).  This
> ensures that all subsequent packets of that flow ends up in
> the same queue so there is no reordering.  It also avoids the
> problem where traffic genreated by one CPU gets scattered across
> queues.

Wont work with static multi-rx nic; iirc, changing those filters is
_expensive_. so you want it to stay static.

cheers,
jamal

