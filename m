Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:48098 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752312AbcHDHqG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Aug 2016 03:46:06 -0400
Date: Thu, 4 Aug 2016 15:45:46 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	linux-wireless@vger.kernel.org
Cc: Thomas Graf <tgraf@suug.ch>, tom@herbertland.com
Subject: Re: Buggy rhashtable walking
Message-ID: <20160804074546.GA996@gondor.apana.org.au> (sfid-20160804_094611_627754_FBB091B2)
References: <20160804071846.GA773@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160804071846.GA773@gondor.apana.org.au>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 04, 2016 at 03:18:46PM +0800, Herbert Xu wrote:
> 
> So the question is can wireless handle seeing an entry multiple
> times? In particular, __ieee80211_rx_handle_packet would appear
> to process the same packet multiple times if this were to happen.

It's worse than I thought.  In fact it's not walking the table
at all, rather it's doing a hash lookup by hand!

This cannot possibly work given that rhashtable makes use of
multiple hash tables.

In fact this also demonstrates why putting multiple identical
objects into the same table is crap.  Because there is no sane
way of returning all objects corresponding to a single key, given
that they may be spread over multiple tables.

So I'm going to fix this by consolidating identical objects into
a single rhashtable entry which also lets us get rid of the
insecure_elasticity setting.

So the next time someone comes along and wants to add multiple
objects with the same key to one table, please just say no.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
