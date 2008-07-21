Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:52866 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750849AbYGURLu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jul 2008 13:11:50 -0400
Date: Tue, 22 Jul 2008 01:11:41 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: David Miller <davem@davemloft.net>
Cc: hadi@cyberus.ca, kaber@trash.net, netdev@vger.kernel.org,
	johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 20/31]: pkt_sched: Perform bulk of qdisc destruction in RCU.
Message-ID: <20080721171141.GA13573@gondor.apana.org.au> (sfid-20080721_191154_318094_22534DEA)
References: <20080721164306.GA13131@gondor.apana.org.au> <20080721.095124.89249903.davem@davemloft.net> <20080721170233.GA13417@gondor.apana.org.au> <20080721.100821.38432201.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20080721.100821.38432201.davem@davemloft.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 21, 2008 at 10:08:21AM -0700, David Miller wrote:
>
> Can I at least get some commitment that someone will test
> that this really is necessary before we add the CPU ID
> hash option?

Sure, I'll be testing some related things on this front so I'll
try to produce some results that compare these two cases.

For the purposes of demonstrating this I'll choose the worst-case
scenario, that is, I'll ensure that the TX hash result exactly
distributes each RX hash preimage across all possible TX hash
values.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
