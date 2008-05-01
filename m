Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:52901 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753467AbYEALDF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 May 2008 07:03:05 -0400
Date: Thu, 1 May 2008 19:02:53 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: David Miller <davem@davemloft.net>
Cc: johannes@sipsolutions.net, mb@bu3sch.de, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: mac80211 truesize bugs
Message-ID: <20080501110253.GC7490@gondor.apana.org.au> (sfid-20080501_130253_478151_86734B02)
References: <20080501.024320.212547875.davem@davemloft.net> <E1JrW9h-0001tI-00@gondolin.me.apana.org.au> <20080501.034950.261408566.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20080501.034950.261408566.davem@davemloft.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 01, 2008 at 03:49:50AM -0700, David Miller wrote:
>
> Once that is cured, I think we can detect this better, by adding a
> carefully constructed assertion to pskb_expand_head().  Basically, the
> idea is, if "nhead" or "ntail" are non-zero, and there is a socket
> still attached to the SKB, print a warning message.
> 
> Something like:
> 
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 4fe605f..9bfca08 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -699,6 +699,12 @@ int pskb_expand_head(struct sk_buff *skb, int nhead, int ntail,
>  	if (skb_shared(skb))
>  		BUG();
>  
> +	if (unlikely((nhead || ntail) && skb->sk)) {
> +		printk(KERN_ERR "SKB BUG: Illegal pskb expand (%d:%d) "
> +		       "with socket attached\n",
> +		       nhead, ntail);
> +	}

This could actually work :) I was worried about tunnelling doing
a genuine expansion on such a packet but it turns that it does a
skb_clone first.  So perhaps we should just require that if a
packet is to be expanded while attached to a socket then it must
be cloned first.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
