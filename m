Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:57956 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753951AbYEDCMZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 May 2008 22:12:25 -0400
Date: Sun, 4 May 2008 10:12:13 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: David Miller <davem@davemloft.net>, mb@bu3sch.de,
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: mac80211 truesize bugs
Message-ID: <20080504021213.GA30660@gondor.apana.org.au> (sfid-20080504_041156_193304_41A8D49F)
References: <1209760731.3608.17.camel@johannes.berg> <20080502.163334.148944203.davem@davemloft.net> <1209815533.3987.21.camel@johannes.berg> <20080503.180300.10562559.davem@davemloft.net> <1209865354.6210.23.camel@johannes.berg> <20080504020203.GA30514@gondor.apana.org.au> <1209866916.6210.39.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1209866916.6210.39.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, May 04, 2008 at 04:08:36AM +0200, Johannes Berg wrote:
>
> So, what is mac80211 supposed to do? It needs up to 54 bytes of
> available headroom (for an encrypted mesh packet which currently can't
> really happen, but anyway) yet it cannot pskb_expand_head() either.
> Cloning each packet seems even more expensive, and just like skb_orphan
> subverts the purpose of the socket accounting.

If all/the majority of your packets need the space then put it in
LL_MAX_HEADER.  In any case, you should always expand the packet
if necessary in your output routine since LL_MAX_HEADER is just a
hint.  Yes cloning is expensive compared to not having to do it,
but as long as this is only done for the exception then it's
irrelevant.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
