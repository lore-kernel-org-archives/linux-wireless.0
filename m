Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:60495 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750881AbYGURCo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jul 2008 13:02:44 -0400
Date: Tue, 22 Jul 2008 01:02:33 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: David Miller <davem@davemloft.net>
Cc: hadi@cyberus.ca, kaber@trash.net, netdev@vger.kernel.org,
	johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 20/31]: pkt_sched: Perform bulk of qdisc destruction in RCU.
Message-ID: <20080721170233.GA13417@gondor.apana.org.au> (sfid-20080721_190248_765411_3FE939E9)
References: <20080721161616.GA12938@gondor.apana.org.au> <20080721.092556.227421936.davem@davemloft.net> <20080721164306.GA13131@gondor.apana.org.au> <20080721.095124.89249903.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20080721.095124.89249903.davem@davemloft.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 21, 2008 at 09:51:24AM -0700, David Miller wrote:
>
> How so?  If the TX hash is well distributed, which it should be,
> it is at least going to approximate the distribution provided by
> the RX hash.

This is a matter of probabilities :) In general, if the TX hash
and the RX hash are completely unrelated, then the end result of
the hash distribution should be independent of each other (independent
in the probablistic sense).  That is, for the flows which have
been RX hashed into one queue, they should be hashed on average
across all queues by the TX hash.  Conversely, those that have
been hashed into one TX queue would be distributed across all
RX queues.

Now if you've bound each RX queue to a specific CPU, then this
means for a given TX queue, its packets are going to come from
all the CPUs (well all those involved in network reception anyway).

As each TX queue is designed to be accessed by only one CPU at
a time, somebody somewhere has to pay for all this synchronisation :)

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
