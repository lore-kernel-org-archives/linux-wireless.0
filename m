Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:4270 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752693AbXKXONa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Nov 2007 09:13:30 -0500
Date: Sat, 24 Nov 2007 22:13:19 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: dsd@gentoo.org, davem@davemloft.net, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: wireless vs. alignment requirements
Message-ID: <20071124141319.GA27819@gondor.apana.org.au> (sfid-20071124_141337_031370_25A97B3E)
References: <E1IvoID-0006aR-00@gondolin.me.apana.org.au> <1195893216.4149.186.camel@johannes.berg> <20071124133200.GA27531@gondor.apana.org.au> <1195912176.4149.194.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1195912176.4149.194.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Nov 24, 2007 at 02:49:36PM +0100, Johannes Berg wrote:
> 
> Right. I just didn't think that would be a valid value for an
> architecture to set.

OK.  Let me clarify this a bit more.  We require at least one
of the following rules to be met:

* the IPv4/IPv6 header is aligned by 8 bytes on reception;
* or the platform provides unaligned exception handlers.

So if your platform violates both rules then it won't work with
the IP stack, simple as that.  Fortunately I don't think such a
platform exists currently on Linux.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
