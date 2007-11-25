Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:4185 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752972AbXKYBIu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Nov 2007 20:08:50 -0500
Date: Sun, 25 Nov 2007 09:08:14 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: Johannes Berg <johannes@sipsolutions.net>, dsd@gentoo.org,
	davem@davemloft.net, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: wireless vs. alignment requirements
Message-ID: <20071125010814.GD31668@gondor.apana.org.au> (sfid-20071125_010855_524561_A0ADFE80)
References: <E1IvoID-0006aR-00@gondolin.me.apana.org.au> <1195893216.4149.186.camel@johannes.berg> <20071124133200.GA27531@gondor.apana.org.au> <1195912176.4149.194.camel@johannes.berg> <20071124141319.GA27819@gondor.apana.org.au> <4748855C.5090103@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4748855C.5090103@linux-foundation.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Nov 24, 2007 at 12:11:08PM -0800, Stephen Hemminger wrote:
>
> Then what about hardware that can't dma ethernet to non-aligned address.
> Sky2 hardware breaks if DMA is not 8 byte aligned.  IMHO the IP stack should
> handle any alignment, and do the appropriate memove if the CPU requires 
> alignment.

Luckily all sky2 users have been on x86 so far :)

Here's an idea.  Put the data of the packet into the page frags
where alignment is not an issue but copy the header so that it
is aligned.

Would that work?

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
