Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:3293 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751140AbXKXGP1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Nov 2007 01:15:27 -0500
From: Herbert Xu <herbert@gondor.apana.org.au>
To: johannes@sipsolutions.net (Johannes Berg)
Subject: Re: wireless vs. alignment requirements
Cc: dsd@gentoo.org, davem@davemloft.net, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org
In-Reply-To: <1195850001.4149.165.camel@johannes.berg>
Message-Id: <E1IvoID-0006aR-00@gondolin.me.apana.org.au> (sfid-20071124_061542_639365_63E58562)
Date: Sat, 24 Nov 2007 14:15:05 +0800
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> wrote:
>
> Now, the IP stack actually assumes that its header is four-byte aligned
> (see comment at NET_IP_ALIGN, although it is not said explicitly that
> the alignment requirement for an IP header is four) so that is actually
> something for the hardware/firmware (!) to do, for example Broadcom

Good point.  In fact IIRC we've always had the policy that drivers
should do their best to generate aligned packets but it is not a
requirement since on some platforms it's more important for the DMA
to be aligned.

So it's up the platform code to fix up any exceptions should they
show up.

Daniel, what's the specific case that you had in mind with this
patch?

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
