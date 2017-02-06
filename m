Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:54111 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751376AbdBFJBJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 6 Feb 2017 04:01:09 -0500
Date: Mon, 6 Feb 2017 17:00:39 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Jouni Malinen <jouni@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH] mac80211: Allocate a sync skcipher explicitly for FILS
 AEAD
Message-ID: <20170206090039.GA9467@gondor.apana.org.au> (sfid-20170206_100303_921394_0107D93F)
References: <1486224522-26392-1-git-send-email-jouni@qca.qualcomm.com>
 <1486364077.14226.1.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1486364077.14226.1.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 06, 2017 at 07:54:37AM +0100, Johannes Berg wrote:
> Hi,
> 
> > The skcipher could have been of the async variant which may return
> > from skcipher_encrypt() with -EINPROGRESS after having queued the
> > request.
> > The FILS AEAD implementation here does not have code for dealing with
> > that possibility, so allocate a sync cipher explicitly to avoid
> > potential issues with hardware accelerators.
> 
> > -	tfm2 = crypto_alloc_skcipher("ctr(aes)", 0, 0);
> > +	tfm2 = crypto_alloc_skcipher("ctr(aes)", 0,
> > CRYPTO_ALG_ASYNC);
> 
> I'll apply this, after having found some code elsewhere that does
> something similar, but I'll note that this is super confusing, since
> the only documentation mentioning this flag says:
> 
> The mask flag restricts the type of cipher. The only allowed flag is
> CRYPTO_ALG_ASYNC to restrict the cipher lookup function to
> asynchronous ciphers. Usually, a caller provides a 0 for the mask flag.

The type and mask are used as follows when checking an algorithm:

	alg->type & mask == type & mask

So to request a synchronous algorithm (that is, one with the
CRYPTO_ALG_ASYNC bit set to zero), you would set type to 0 and
mask to CRYPTO_ALG_ASYNC.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
