Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:35195 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758969AbYEGLl1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 May 2008 07:41:27 -0400
Date: Wed, 7 May 2008 19:41:23 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	Ron Rindjunsky <ron.rindjunsky@intel.com>,
	Tomas Winkler <tomasw@gmail.com>,
	Ivo van Doorn <ivdoorn@gmail.com>,
	Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
Subject: Re: [PATCH] mac80211: rewrite fragmentation code
Message-ID: <20080507114123.GA26073@gondor.apana.org.au> (sfid-20080507_134046_018331_474DED34)
References: <20080430124055.091382000@sipsolutions.net> <20080430130050.105344000@sipsolutions.net> <20080507071026.GA24407@gondor.apana.org.au> <1210150217.9305.39.camel@johannes.berg> <20080507090040.GA25186@gondor.apana.org.au> <1210159339.5642.13.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1210159339.5642.13.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 07, 2008 at 01:22:19PM +0200, Johannes Berg wrote:
>
> +	if (unlikely(netif_queue_stopped(local->mdev) ||
> +		     __ieee80211_queue_stopped(local, control->queue)))
> +		return NETDEV_TX_BUSY;

Returning busy should be avoided because not everything expects it.
For example, this can cause tcpdump to see the same packet twice.

Besides, I'm not sure if this will even work if you're fiddling
with skb->next.  Perhaps you can stash it in a pointer local to
your device.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
