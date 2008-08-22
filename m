Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:48278 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751611AbYHVHlY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Aug 2008 03:41:24 -0400
Date: Fri, 22 Aug 2008 17:41:15 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: David Miller <davem@davemloft.net>
Cc: hadi@cyberus.ca, kaber@trash.net, netdev@vger.kernel.org,
	johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 20/31]: pkt_sched: Perform bulk of qdisc destruction in RCU.
Message-ID: <20080822074115.GB25615@gondor.apana.org.au> (sfid-20080822_094128_778599_3D3F4C64)
References: <20080721.100821.38432201.davem@davemloft.net> <20080721171141.GA13573@gondor.apana.org.au> <20080822065655.GA18471@gondor.apana.org.au> <20080822.001620.141235108.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20080822.001620.141235108.davem@davemloft.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 22, 2008 at 12:16:20AM -0700, David Miller wrote:
> 
> I suppose you're talking about the grand unified flow cache
> that never gets implemented right?  I classify that in the
> same category as net channels at the moment, theoretically
> very interesting but no practical implementation in sight.

In any case, we could implement what I suggested even without
a flow cache, by simply storing the info in the dst.  This means
that all flows on the same dst will end up in the same queue, which
is not as good as what a flow cache could give, but it's useful
enough to be an option.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
