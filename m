Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:40220 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751690AbYGTOU4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jul 2008 10:20:56 -0400
From: Herbert Xu <herbert@gondor.apana.org.au>
To: hadi@cyberus.ca
Subject: Re: [PATCH 20/31]: pkt_sched: Perform bulk of qdisc destruction in	RCU.
Cc: kaber@trash.net, davem@davemloft.net, netdev@vger.kernel.org,
	johannes@sipsolutions.net, linux-wireless@vger.kernel.org
In-Reply-To: <1216301732.4726.26.camel@localhost>
Message-Id: <E1KKZmE-0000ty-00@gondolin.me.apana.org.au> (sfid-20080720_162100_430258_228A3FA3)
Date: Sun, 20 Jul 2008 22:20:42 +0800
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

jamal <hadi@cyberus.ca> wrote:
>
> Actions are fine because they are intended to be globaly shared.
> [i.e A classifier on ethx with qdiscA:Y (in/egress) can share an action
> with  classifer on  ethy with qdiscB:Z (eg/ingress)].

Not all actions :) That nat action for example wasn't intended to
be shared at all.  In fact I still need to submit a patch to make
it skip the shared hash as otherwise it simply won't scale as the
number of nat actions increases (e.g., to 256K).

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
