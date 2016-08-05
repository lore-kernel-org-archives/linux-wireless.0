Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:53617 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759596AbcHEKtM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Aug 2016 06:49:12 -0400
Date: Fri, 5 Aug 2016 18:48:58 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org, Thomas Graf <tgraf@suug.ch>,
	tom@herbertland.com
Subject: Re: Buggy rhashtable walking
Message-ID: <20160805104858.GA9297@gondor.apana.org.au> (sfid-20160805_125036_108397_E26B1D0C)
References: <20160804071846.GA773@gondor.apana.org.au>
 <20160804074546.GA996@gondor.apana.org.au>
 <1470377813.2977.14.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1470377813.2977.14.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 05, 2016 at 08:16:53AM +0200, Johannes Berg wrote:
> 
> Hm. Would you rather allocate a separate head entry for the hashtable,
> or chain the entries?

My plan is to build support for this directly into rhashtable.
So I'm adding a struct rhlist_head that would be used in place
of rhash_head for these cases and it'll carry an extra pointer
for the list of identical entries.

I will then add an additional layer of insert/lookup interfaces
for rhlist_head.

So bottom-line is that if you have no identical entries that you
only incur an extra 8 bytes per-object.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
