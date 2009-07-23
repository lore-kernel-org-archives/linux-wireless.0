Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:41900 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751193AbZGWAlE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jul 2009 20:41:04 -0400
Date: Thu, 23 Jul 2009 08:40:46 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Andreas Oberritter <obi@linuxtv.org>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: fix autoloading of crypto modules for WEP
Message-ID: <20090723004046.GA8201@gondor.apana.org.au>
References: <4A677126.3040907@linuxtv.org> <1248294007.19121.9.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1248294007.19121.9.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 22, 2009 at 10:20:07PM +0200, Johannes Berg wrote:
> On Wed, 2009-07-22 at 22:05 +0200, Andreas Oberritter wrote:
> > If at least one of arc4 and ecb is built as a module, then autoloading
> > of the algorithm fails, because crypto_alloc_blkcipher tries to
> > request the module "ecb(arc4)", which does not exist.
> > 
> > This patch was made against 2.6.30, but should apply cleanly on top of
> > the wireless-2.6 git tree.
> 
> > +       /*
> > +        * crypto_alloc_blkcipher() will request the
> > +        * module "ecb(arc4)", which does not exist.
> > +        */
> > +#ifdef CONFIG_CRYPTO_ARC4_MODULE
> > +       request_module("arc4");
> > +#endif
> > +#ifdef CONFIG_CRYPTO_ECB_MODULE
> > +       request_module("ecb");
> > +#endif
> > +
> >         local->wep_tx_tfm = crypto_alloc_blkcipher("ecb(arc4)", 0,
> >                                                 CRYPTO_ALG_ASYNC);
> 
> But it will absolutely not _be_ applied. Fix the crypto layer instead if
> it has a problem loading modules.

Agreed.  Andreas, please attach your config file.  Also, please
show us the error that you get without loading those modules by
hand.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
