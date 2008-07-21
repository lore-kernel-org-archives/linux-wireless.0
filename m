Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:54630 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751478AbYGUL6p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jul 2008 07:58:45 -0400
From: Herbert Xu <herbert@gondor.apana.org.au>
To: hadi@cyberus.ca
Subject: Re: [PATCH 20/31]: pkt_sched: Perform bulk of qdisc destruction in	RCU.
Cc: davem@davemloft.net, kaber@trash.net, netdev@vger.kernel.org,
	johannes@sipsolutions.net, linux-wireless@vger.kernel.org
In-Reply-To: <1216606839.4847.159.camel@localhost>
Message-Id: <E1KKu2D-0002kd-00@gondolin.me.apana.org.au> (sfid-20080721_135847_700711_90F04C7B)
Date: Mon, 21 Jul 2008 19:58:33 +0800
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

jamal <hadi@cyberus.ca> wrote:
>
>> Otherwise, there is zero point in all of these TX multiqueue features
>> in the hardware if we can't parallelize things fully.
> 
> parallelization is achieveable in the ideal case.

I think I get you now.  You're suggesting that we essentially
do what Dave has right now in the non-contending case, i.e.,
bypassing the qdisc so we get fully parallel processing until
one of the hardware queues seizes up.

At that point you'd stop all queues and make every packet go
through the software qdisc to ensure ordering.  This continues
until all queues have vacancies again.

If this is what you're suggesting, then I think that will offer
pretty much the same behaviour as what we've got, while still
offering at least some (perhaps even most, but that is debatable)
of the benefits of multi-queue.

At this point I don't think this is something that we need right
now, but it would be good to make sure that the architecture
allows such a thing to be implemented in future.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
