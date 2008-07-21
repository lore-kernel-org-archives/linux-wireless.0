Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:38418 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751954AbYGUQQ2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jul 2008 12:16:28 -0400
Date: Tue, 22 Jul 2008 00:16:16 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: David Miller <davem@davemloft.net>
Cc: hadi@cyberus.ca, kaber@trash.net, netdev@vger.kernel.org,
	johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 20/31]: pkt_sched: Perform bulk of qdisc destruction in RCU.
Message-ID: <20080721161616.GA12938@gondor.apana.org.au> (sfid-20080721_181633_794375_CC9EB55F)
References: <20080721135846.GA11543@gondor.apana.org.au> <20080721.080901.214889979.davem@davemloft.net> <20080721152220.GA12341@gondor.apana.org.au> <20080721.082627.128593651.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20080721.082627.128593651.davem@davemloft.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 21, 2008 at 08:26:27AM -0700, David Miller wrote:
>
> It is totally unwise to do CPU based TX hashing.

Right I'm not suggesting having this as a default.  However,
if you have a finely tuned system (e.g., a router) where you've
pinned all you RX queues to specific CPUs and your local apps
as well then it would make sense to provide this as an alternative.

If this alternative doesn't exist, then unless the RX hash happens
to match the TX hash, for routing at least the packets are going
to jump all over the place which isn't nice.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
