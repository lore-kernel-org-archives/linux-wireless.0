Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:52325 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752282AbYGUN65 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jul 2008 09:58:57 -0400
Date: Mon, 21 Jul 2008 21:58:46 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: jamal <hadi@cyberus.ca>
Cc: davem@davemloft.net, kaber@trash.net, netdev@vger.kernel.org,
	johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 20/31]: pkt_sched: Perform bulk of qdisc destruction in	RCU.
Message-ID: <20080721135846.GA11543@gondor.apana.org.au> (sfid-20080721_155900_846370_B046A8BC)
References: <E1KKu2D-0002kd-00@gondolin.me.apana.org.au> <1216645724.4847.275.camel@localhost> <20080721131918.GA11114@gondor.apana.org.au> <1216648585.4847.303.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1216648585.4847.303.camel@localhost>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 21, 2008 at 09:56:25AM -0400, jamal wrote:
> 
> Ok - You may be able to pull it if you have the exact same hashing on
> hardware rx as it is on transmit stateless filtering.
> I can see a traffic pattern that could be cooked to give some good
> numbers in such a scenario;->

Actually you've hit it on the head, as an alternative to TX hashing
on the packet content, we need to allow TX queue selection based on
the current CPU ID.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
