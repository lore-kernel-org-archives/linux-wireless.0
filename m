Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:40710 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752577AbYHVKrk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Aug 2008 06:47:40 -0400
Date: Fri, 22 Aug 2008 20:47:30 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: David Miller <davem@davemloft.net>
Cc: hadi@cyberus.ca, kaber@trash.net, netdev@vger.kernel.org,
	johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 20/31]: pkt_sched: Perform bulk of qdisc destruction in RCU.
Message-ID: <20080822104730.GA19742@gondor.apana.org.au> (sfid-20080822_124744_158684_62CF9B8A)
References: <20080822065655.GA18471@gondor.apana.org.au> <20080822.001620.141235108.davem@davemloft.net> <20080822074115.GB25615@gondor.apana.org.au> <20080822.034217.135152551.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20080822.034217.135152551.davem@davemloft.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 22, 2008 at 03:42:17AM -0700, David Miller wrote:
> 
> I had another idea in the back of my head that I wanted to mention.
> 
> The SKB has a hash, and sources set the hash.  It doesn't matter
> where in the stack it comes from.

Yes this sounds great!
 
> So in the simplest case for forwarding, the RX side puts the RSS
> hash or whatever into this SKB hash location.

This works on all the routers.

> Then, taking things to the next level, protocols set hashes for
> locally created packets.  And this leads to being able to delete
> the simple_tx_hash() code entirely and also we won't have to add
> support for every protocol on the planet to that function. :)

And this takes care of the hosts.

Best of all it's per flow and we don't even need to add any new
infrastructure :)

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
