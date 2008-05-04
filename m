Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:56567 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751045AbYEDM5G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 May 2008 08:57:06 -0400
Date: Sun, 4 May 2008 20:56:52 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: David Miller <davem@davemloft.net>, mb@bu3sch.de,
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: mac80211 truesize bugs
Message-ID: <20080504125652.GA1618@gondor.apana.org.au> (sfid-20080504_145634_021948_BA1F36DE)
References: <1209867740.6210.46.camel@johannes.berg> <20080504031652.GA30993@gondor.apana.org.au> <1209890847.6210.51.camel@johannes.berg> <1209892489.6210.56.camel@johannes.berg> <20080504094444.GA541@gondor.apana.org.au> <1209894754.6210.58.camel@johannes.berg> <1209900355.6210.64.camel@johannes.berg> <1209904088.4065.11.camel@johannes.berg> <20080504124542.GA1455@gondor.apana.org.au> <1209905561.4065.23.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1209905561.4065.23.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, May 04, 2008 at 02:52:41PM +0200, Johannes Berg wrote:
>
> > have no cache at all,
> 
> That wouldn't be good either I think since we can actually use the
> ethernet header quite well.

Actually this is not as bad as it sounds.  Since you're constructing
the hardware header anyway, it may turn out to be easier to tack on
the Ethernet header while you're at it.

Please note that the hardware cache is not the same as the neighbour
cache.  Just because you lose the hardware cache doesn't mean that
you'd lose the neighbour (ARP) cache.

However, this would mean that you'd no longer have an Ethernet device
which is both good and bad.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
