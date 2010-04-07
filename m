Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:35113 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756503Ab0DGJZH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Apr 2010 05:25:07 -0400
Date: Wed, 7 Apr 2010 17:25:01 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: linux-crypto@vger.kernel.org, linux-wireless@vger.kernel.org,
	linux-ppp@vger.kernel.org
Subject: Re: [PATCH v2] crypto: add blkcipher implementation of ARC4
Message-ID: <20100407092501.GA29993@gondor.apana.org.au>
References: <1270280969-11357-1-git-send-email-sebastian@breakpoint.cc> <1270280969-11357-3-git-send-email-sebastian@breakpoint.cc> <20100405084209.GA16788@gondor.apana.org.au> <20100405170406.GA24215@Chamillionaire.breakpoint.cc> <20100406124412.GA24488@gondor.apana.org.au> <20100406203002.GA1842@Chamillionaire.breakpoint.cc> <20100407003109.GA27617@gondor.apana.org.au> <20100407082300.GB6619@Chamillionaire.breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20100407082300.GB6619@Chamillionaire.breakpoint.cc>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 07, 2010 at 10:23:00AM +0200, Sebastian Andrzej Siewior wrote:
>
> So arc4_setup_iv() should do what the internal arc4_ivsetup() does and
> we change void to int and check the keysize in there right? The problem
> here is that we are bounded to *this* implementation of the algorithm
> and are not able to replace it with a different implementation. Not that
> this is likely to happen for RC4 but it may be true for other stream
> ciphers.

By setting an IV we're already requiring the other implementations
use the IV format used by our arc4.  So they would always work with
this arc4_ivsetup anyway.

If and when we do have a piece of hardware that cannot do this
(which I doubt would ever happen, considering how fast arc4 is
already), then we can talk about changing this.

> >I'm pretty sure testmgr will call setkey even for keylen == 0, no?
> Prior patch #3 it has no test case so it should not test it at all.
> Patch #3 adds a flag in order to distinguish it. You want to look at
> patch #3 now :)

I see.

But still we should at least not crash when crypto_blkcipher_setkey
is called.  This might happen in future when we get a user-space
API.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
