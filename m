Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:54332 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754579AbcJSDcP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Oct 2016 23:32:15 -0400
Date: Wed, 19 Oct 2016 11:31:57 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Andy Lutomirski <luto@amacapital.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "<linux-wireless@vger.kernel.org>" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jouni Malinen <j@w1.fi>
Subject: Re: [PATCH] crypto: ccm - avoid scatterlist for MAC encryption
Message-ID: <20161019033157.GA1457@gondor.apana.org.au> (sfid-20161019_053223_380457_744A085D)
References: <1476551776-8099-1-git-send-email-ard.biesheuvel@linaro.org>
 <1476689310.19992.1.camel@sipsolutions.net>
 <CAKv+Gu_P-6sHW3t7tp1N+3v9ZGqWcQrzMZkASY5g=QR76KN4wg@mail.gmail.com>
 <CALCETrUWW2A1XK7BzcajTcBzg58SDUCTE35Hj1vmbywTLCe2vQ@mail.gmail.com>
 <CAKv+Gu-25OvTSbyE06Ln8N+HsqNyV1T6oOudK2tyAAOmmXXqgA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAKv+Gu-25OvTSbyE06Ln8N+HsqNyV1T6oOudK2tyAAOmmXXqgA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 17, 2016 at 06:21:14PM +0100, Ard Biesheuvel wrote:
>
> Annoyingly, all this complication with scatterlists etc is for doing
> asynchronous crypto via DMA capable crypto accelerators, and the
> networking code (ipsec as well as mac80211, afaik) only allow
> synchronous in the first place, given that they execute in softirq
> context.

I'm still thinking about the issue (in particular, whether we
should continue to rely on the request context being SG-capable
or allow it to be on the stack for AEAD).

But IPsec definitely supports async crypto.  In fact it was the
very first user of async crypto.

mac80211 on the other hand is currently sync-only.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
