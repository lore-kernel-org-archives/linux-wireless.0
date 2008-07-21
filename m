Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58572
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752381AbYGURIV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jul 2008 13:08:21 -0400
Date: Mon, 21 Jul 2008 10:08:21 -0700 (PDT)
Message-Id: <20080721.100821.38432201.davem@davemloft.net> (sfid-20080721_190828_256640_A623DBC6)
To: herbert@gondor.apana.org.au
Cc: hadi@cyberus.ca, kaber@trash.net, netdev@vger.kernel.org,
	johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 20/31]: pkt_sched: Perform bulk of qdisc destruction in
 RCU.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080721170233.GA13417@gondor.apana.org.au>
References: <20080721164306.GA13131@gondor.apana.org.au>
	<20080721.095124.89249903.davem@davemloft.net>
	<20080721170233.GA13417@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Tue, 22 Jul 2008 01:02:33 +0800

> On Mon, Jul 21, 2008 at 09:51:24AM -0700, David Miller wrote:
> >
> > How so?  If the TX hash is well distributed, which it should be,
> > it is at least going to approximate the distribution provided by
> > the RX hash.
> 
> This is a matter of probabilities :) In general, if the TX hash
> and the RX hash are completely unrelated, then the end result of
> the hash distribution should be independent of each other (independent
> in the probablistic sense).  That is, for the flows which have
> been RX hashed into one queue, they should be hashed on average
> across all queues by the TX hash.  Conversely, those that have
> been hashed into one TX queue would be distributed across all
> RX queues.

Theoretically perhaps you are right.

Can I at least get some commitment that someone will test
that this really is necessary before we add the CPU ID
hash option?
