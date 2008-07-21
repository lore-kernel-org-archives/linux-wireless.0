Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44801
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751430AbYGUQZ4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jul 2008 12:25:56 -0400
Date: Mon, 21 Jul 2008 09:25:56 -0700 (PDT)
Message-Id: <20080721.092556.227421936.davem@davemloft.net> (sfid-20080721_182600_521788_CFBA6A43)
To: herbert@gondor.apana.org.au
Cc: hadi@cyberus.ca, kaber@trash.net, netdev@vger.kernel.org,
	johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 20/31]: pkt_sched: Perform bulk of qdisc destruction in
 RCU.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080721161616.GA12938@gondor.apana.org.au>
References: <20080721152220.GA12341@gondor.apana.org.au>
	<20080721.082627.128593651.davem@davemloft.net>
	<20080721161616.GA12938@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Tue, 22 Jul 2008 00:16:16 +0800

> On Mon, Jul 21, 2008 at 08:26:27AM -0700, David Miller wrote:
> >
> > It is totally unwise to do CPU based TX hashing.
> 
> Right I'm not suggesting having this as a default.  However,
> if you have a finely tuned system (e.g., a router) where you've
> pinned all you RX queues to specific CPUs and your local apps
> as well then it would make sense to provide this as an alternative.
> 
> If this alternative doesn't exist, then unless the RX hash happens
> to match the TX hash, for routing at least the packets are going
> to jump all over the place which isn't nice.

Where are these places they are going to "jump all over"? :-)

You can view the RX and TX queues as roughly independent namespaces.

If the TX hash is good enough (current one certainly isn't and I will
work on fixing that), it is likely to spread the accesses enough that
there won't be many collisions to matter.

If you really think about it, this is even pointless.  Packets that
hit RX queue A will always hit TX queue B, and so on and so forth.
Therefore there will be no new level of separation afforded by using
some kind of strict RX to TX mapping.

We could provide the option, but it is so dangerous and I also see no
real tangible benfit from it.
