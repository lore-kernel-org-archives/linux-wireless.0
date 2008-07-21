Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:34191 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753686AbYGUPWf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jul 2008 11:22:35 -0400
Date: Mon, 21 Jul 2008 23:22:20 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: David Miller <davem@davemloft.net>
Cc: hadi@cyberus.ca, kaber@trash.net, netdev@vger.kernel.org,
	johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 20/31]: pkt_sched: Perform bulk of qdisc destruction in RCU.
Message-ID: <20080721152220.GA12341@gondor.apana.org.au> (sfid-20080721_172243_078992_C72A18C3)
References: <20080721131918.GA11114@gondor.apana.org.au> <1216648585.4847.303.camel@localhost> <20080721135846.GA11543@gondor.apana.org.au> <20080721.080901.214889979.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20080721.080901.214889979.davem@davemloft.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 21, 2008 at 08:09:01AM -0700, David Miller wrote:
>
> > Actually you've hit it on the head, as an alternative to TX hashing
> > on the packet content, we need to allow TX queue selection based on
> > the current CPU ID.
> 
> This we should avoid, it would allow reordering within a flow.

Not if the RX hashing is flow-based...

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
