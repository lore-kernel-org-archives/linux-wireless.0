Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f54.google.com ([209.85.214.54]:33456 "EHLO
        mail-it0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757685AbcJQHuL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 17 Oct 2016 03:50:11 -0400
Received: by mail-it0-f54.google.com with SMTP id k64so11210395itb.0
        for <linux-wireless@vger.kernel.org>; Mon, 17 Oct 2016 00:50:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1476690478.19992.4.camel@sipsolutions.net>
References: <1476551776-8099-1-git-send-email-ard.biesheuvel@linaro.org>
 <1476689310.19992.1.camel@sipsolutions.net> <CAKv+Gu_P-6sHW3t7tp1N+3v9ZGqWcQrzMZkASY5g=QR76KN4wg@mail.gmail.com>
 <1476690478.19992.4.camel@sipsolutions.net>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Mon, 17 Oct 2016 08:50:09 +0100
Message-ID: <CAKv+Gu9EPAF+Oihz0tXCqWURGom-wgSPCMp0dEHHnxqw-pYYJw@mail.gmail.com> (sfid-20161017_095036_555119_616B1F0A)
Subject: Re: [PATCH] crypto: ccm - avoid scatterlist for MAC encryption
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Andy Lutomirski <luto@amacapital.net>,
        Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "<linux-wireless@vger.kernel.org>" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jouni Malinen <j@w1.fi>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 17 October 2016 at 08:47, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Mon, 2016-10-17 at 08:37 +0100, Ard Biesheuvel wrote:
>>
>> Could we get a statement first whether it is supported to allocate
>> aead_req (and other crypto req structures) on the stack?
>
> Well, we haven't heard from Herbert :)
>
>> If not, then
>> we have our work cut out for us. But if it is, I'd rather we didn't
>> apply the kzalloc/kfree patch, since it is just a workaround for the
>> broken generic CCM driver, for which a fix is already available.
>
> Yeah but I can't apply it. I just fixed up your kzalloc patch to also
> handle GCM and GMAC, and to have error checking. Will send it in a
> minute.
>

I just realised that patch should probably use
aead_request_alloc/aead_request_free [and drop the memset]. That also
fixes the latent bug where the alignment of the req ctx is not take
into account.

>> Also, regarding your __percpu patch: those are located in the vmalloc
>> area as well, at least on arm64, and likely other architectures too.
>
> Crap. Any other bright ideas?
>

kmem_cache_create() and kmem_cache_alloc()
