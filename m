Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:35890 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750881AbdBFGym (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 6 Feb 2017 01:54:42 -0500
Message-ID: <1486364077.14226.1.camel@sipsolutions.net> (sfid-20170206_075445_282208_870633F2)
Subject: Re: [PATCH] mac80211: Allocate a sync skcipher explicitly for FILS
 AEAD
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <jouni@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Date: Mon, 06 Feb 2017 07:54:37 +0100
In-Reply-To: <1486224522-26392-1-git-send-email-jouni@qca.qualcomm.com>
References: <1486224522-26392-1-git-send-email-jouni@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> The skcipher could have been of the async variant which may return
> from skcipher_encrypt() with -EINPROGRESS after having queued the
> request.
> The FILS AEAD implementation here does not have code for dealing with
> that possibility, so allocate a sync cipher explicitly to avoid
> potential issues with hardware accelerators.

> -	tfm2 = crypto_alloc_skcipher("ctr(aes)", 0, 0);
> +	tfm2 = crypto_alloc_skcipher("ctr(aes)", 0,
> CRYPTO_ALG_ASYNC);

I'll apply this, after having found some code elsewhere that does
something similar, but I'll note that this is super confusing, since
the only documentation mentioning this flag says:

The mask flag restricts the type of cipher. The only allowed flag is
CRYPTO_ALG_ASYNC to restrict the cipher lookup function to
asynchronous ciphers. Usually, a caller provides a 0 for the mask flag.

(I have a vague feeling the first sentence was intended to be
documentation for the algorithm *implementation* specifying the flag,
and the second for a caller doing a lookup, or something strange?)

johannes
