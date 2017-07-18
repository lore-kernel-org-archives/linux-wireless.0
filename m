Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:56492 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751334AbdGRIkc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Jul 2017 04:40:32 -0400
Date: Tue, 18 Jul 2017 16:39:56 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-crypto@vger.kernel.org, ebiggers@google.com,
        davem@davemloft.net, dm-devel@redhat.com,
        johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
        agk@redhat.com, snitzer@redhat.com
Subject: Re: [PATCH 2/2] crypto/algapi - make crypto_xor() take separate dst
 and src arguments
Message-ID: <20170718083956.GA5813@gondor.apana.org.au> (sfid-20170718_104037_702015_17C39A42)
References: <20170710134548.20234-1-ard.biesheuvel@linaro.org>
 <20170710134548.20234-3-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170710134548.20234-3-ard.biesheuvel@linaro.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 10, 2017 at 02:45:48PM +0100, Ard Biesheuvel wrote:
> There are quite a number of occurrences in the kernel of the pattern
> 
>     if (dst != src)
>             memcpy(dst, src, walk.total % AES_BLOCK_SIZE);
>     crypto_xor(dst, final, walk.total % AES_BLOCK_SIZE);
> 
> or
> 
>     crypto_xor(keystream, src, nbytes);
>     memcpy(dst, keystream, nbytes);

What keeping crypto_xor as it is and adding a new entry point for
the 4-argument case?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
