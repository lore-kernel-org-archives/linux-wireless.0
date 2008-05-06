Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:48161 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757430AbYEFBdT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 May 2008 21:33:19 -0400
Date: Tue, 6 May 2008 09:32:53 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: David Miller <davem@davemloft.net>
Cc: johannes@sipsolutions.net, tomasw@gmail.com,
	linville@tuxdriver.com, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC v2] mac80211: assign needed_headroom/tailroom for netdevs
Message-ID: <20080506013253.GA13460@gondor.apana.org.au> (sfid-20080506_033241_046190_C5A67AE0)
References: <1210027447.8012.15.camel@johannes.berg> <20080505.161458.46071527.davem@davemloft.net> <1210029835.8012.30.camel@johannes.berg> <20080505.163916.239187195.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20080505.163916.239187195.davem@davemloft.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 05, 2008 at 04:39:16PM -0700, David Miller wrote:
> 
> On free, since skb->nohdr is set, we'll decrement both of (1 <<
> SKB_DATAREF_SHIFT) and the low 16-bit counter.

skb->nohdr is cleared for clones.  Only the copy held by TCP
should have it set.  So this should work correctly, in theory :)

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
