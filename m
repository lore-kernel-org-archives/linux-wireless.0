Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:60410 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731576AbeITCRu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Sep 2018 22:17:50 -0400
Message-ID: <1537389479.10305.94.camel@sipsolutions.net> (sfid-20180919_223825_794067_9198C8B1)
Subject: Re: [PATCH crypto-next 03/23] lib80211: Remove VLA usage of skcipher
From: Johannes Berg <johannes@sipsolutions.net>
To: Kees Cook <keescook@chromium.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-wireless@vger.kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Eric Biggers <ebiggers@google.com>,
        linux-crypto <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Wed, 19 Sep 2018 22:37:59 +0200
In-Reply-To: <20180919021100.3380-4-keescook@chromium.org> (sfid-20180919_041111_811472_0A3A2E21)
References: <20180919021100.3380-1-keescook@chromium.org>
         <20180919021100.3380-4-keescook@chromium.org>
         (sfid-20180919_041111_811472_0A3A2E21)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2018-09-18 at 19:10 -0700, Kees Cook wrote:
> In the quest to remove all stack VLA usage from the kernel[1], this
> replaces struct crypto_skcipher and SKCIPHER_REQUEST_ON_STACK() usage
> with struct crypto_sync_skcipher and SYNC_SKCIPHER_REQUEST_ON_STACK(),
> which uses a fixed stack size.
> 
> [1] https://lkml.kernel.org/r/CA+55aFzCG-zNmZwX4A2FQpadafLfEzK6CC=qPXydAacU1RqZWA@mail.gmail.com
> 

I know this lib80211 stuff landed on my plate as the maintainer (and the
others are probably more or less copies thereof), but honestly I don't
even have a device I could test this on, and quite possibly never had
(after the old non-mac80211 b43 driver was killed.)

So basically I'll just trust you to be doing the right thing, since you
probably did the same transformation on other code that is better
tested...

johannes
