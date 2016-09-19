Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:42698 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754851AbcISIf3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Sep 2016 04:35:29 -0400
Date: Mon, 19 Sep 2016 16:35:18 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, Thomas Graf <tgraf@suug.ch>,
        tom@herbertland.com
Subject: Re: [PATCH 0/2] rhashtable: rhashtable with duplicate objects
Message-ID: <20160919083518.GA11821@gondor.apana.org.au> (sfid-20160919_103652_166456_F49812B1)
References: <20160804071846.GA773@gondor.apana.org.au>
 <20160804074546.GA996@gondor.apana.org.au>
 <1470377813.2977.14.camel@sipsolutions.net>
 <20160805104858.GA9297@gondor.apana.org.au>
 <1470394233.2977.37.camel@sipsolutions.net>
 <20160918135030.GA7062@gondor.apana.org.au>
 <1474273219.4469.7.camel@sipsolutions.net>
 <1474273518.4469.8.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1474273518.4469.8.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 19, 2016 at 10:25:18AM +0200, Johannes Berg wrote:
> 
> > Yes, it's passing all the wpa_supplicant tests, so
> > 
> > Acked-by: Johannes Berg <johannes@sipsolutions.net>
> > 
> 
> I take that back. I think it's leaking memory - my tests never used to
> run out of memory, but now they eventually do.
> 
> I'll try to figure out more.

Interesting.  The kernel test robot found a bug in the insertion
slowpath where we end up inserting without taking the inner spinlock
in case of a nested table.  Not sure whether that's the same issue
as you're seeing but I'll do a v2 posting.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
