Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:51707 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758813AbYGUDR1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jul 2008 23:17:27 -0400
Date: Mon, 21 Jul 2008 11:17:16 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: jamal <hadi@cyberus.ca>
Cc: kaber@trash.net, davem@davemloft.net, netdev@vger.kernel.org,
	johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 20/31]: pkt_sched: Perform bulk of qdisc destruction in	RCU.
Message-ID: <20080721031716.GA7535@gondor.apana.org.au> (sfid-20080721_051733_774871_A79863BA)
References: <E1KKZmE-0000ty-00@gondolin.me.apana.org.au> <1216568119.4847.101.camel@localhost> <20080721001119.GA6515@gondor.apana.org.au> <1216607637.4847.172.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1216607637.4847.172.camel@localhost>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jul 20, 2008 at 10:33:57PM -0400, jamal wrote:
> 
> True. 
> But note: this is only during rule creation - once you create the
> rule (user space to kernel path), then no more hash table reference.
> Fast path has already a filter with actions attached, and is a mere
> pointer dereference.

Unfortunately the scenario that I wrote this for requires frequent
addition/removal.

> > We could do a dynamic table but so far I'm not convinced that
> > it's worth anybody's effort to implement :)
> 
> If user<->kernel performance insertion/deletion is important, it is
> worth it.

Only if you also want to share it :) In the end I patched it to
not share it which is much easier.

> For example:
> Dave implemented dynamic hash tables on xfrm (voip setup time with ipsec
> is a metric used in the industry in that case) . The only operational
> problem i had with xfrm was lack of an upper bound of how large a table
> can grow; i would rather user space be told ENOMEM than continuing to
> grow in some cases (I actually implemented a patch which put a stop
> after a certain number of sad/spd - but i dont expect hugs if i was to
> post it;->).

Of course if you're volunteering to write the dynamic hash table
for actions then I'd happily switch back to sharing :)

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
