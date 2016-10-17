Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:49134 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757687AbcJQH5q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 17 Oct 2016 03:57:46 -0400
Message-ID: <1476691059.19992.6.camel@sipsolutions.net> (sfid-20161017_095949_711509_94BA1964)
Subject: Re: [PATCH] crypto: ccm - avoid scatterlist for MAC encryption
From: Johannes Berg <johannes@sipsolutions.net>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Andy Lutomirski <luto@amacapital.net>,
        Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "<linux-wireless@vger.kernel.org>" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jouni Malinen <j@w1.fi>
Date: Mon, 17 Oct 2016 09:57:39 +0200
In-Reply-To: <CAKv+Gu9EPAF+Oihz0tXCqWURGom-wgSPCMp0dEHHnxqw-pYYJw@mail.gmail.com> (sfid-20161017_095011_197525_132B0910)
References: <1476551776-8099-1-git-send-email-ard.biesheuvel@linaro.org>
         <1476689310.19992.1.camel@sipsolutions.net>
         <CAKv+Gu_P-6sHW3t7tp1N+3v9ZGqWcQrzMZkASY5g=QR76KN4wg@mail.gmail.com>
         <1476690478.19992.4.camel@sipsolutions.net>
         <CAKv+Gu9EPAF+Oihz0tXCqWURGom-wgSPCMp0dEHHnxqw-pYYJw@mail.gmail.com>
         (sfid-20161017_095011_197525_132B0910)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2016-10-17 at 08:50 +0100, Ard Biesheuvel wrote:

> I just realised that patch should probably use
> aead_request_alloc/aead_request_free [and drop the memset]. That also
> fixes the latent bug where the alignment of the req ctx is not take
> into account.

Good point, I'll fix that up.

> > 
> > > 
> > > Also, regarding your __percpu patch: those are located in the
> > > vmalloc
> > > area as well, at least on arm64, and likely other architectures
> > > too.
> > 
> > Crap. Any other bright ideas?
> > 
> 
> kmem_cache_create() and kmem_cache_alloc()

for the aad/b0/j0/etc? Hmm. Yeah I guess we should do those dynamically
as well then.

johannes
