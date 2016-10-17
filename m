Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f178.google.com ([209.85.223.178]:33207 "EHLO
        mail-io0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754561AbcJQNUj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 17 Oct 2016 09:20:39 -0400
Received: by mail-io0-f178.google.com with SMTP id q192so187763530iod.0
        for <linux-wireless@vger.kernel.org>; Mon, 17 Oct 2016 06:20:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1476710169.315.1.camel@sipsolutions.net>
References: <1476693195-14071-1-git-send-email-johannes@sipsolutions.net>
 <CAKv+Gu-aZhCBvnEQoZUZLDPXCrvgxO1pSd=6EHz+tMB+dFz5hg@mail.gmail.com>
 <1476696226.19992.13.camel@sipsolutions.net> <CAKv+Gu_ZH9hO_xbVfOfk90CxFJ6ZTz3PKWB1v23LRVzpBrb=oQ@mail.gmail.com>
 <1476696918.19992.15.camel@sipsolutions.net> <67161BCC-596E-4DDE-A58E-9195BB5570C2@linaro.org>
 <1476698041.19992.19.camel@sipsolutions.net> <41D0AC2F-E86E-4A98-AD8B-1239D7E6123A@linaro.org>
 <CAKv+Gu9OT6r3gbrLi_wzBcPXoA6K9z=-4ybrgQy4X=FvjOOuhA@mail.gmail.com> <1476710169.315.1.camel@sipsolutions.net>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Mon, 17 Oct 2016 14:20:38 +0100
Message-ID: <CAKv+Gu_jdiQn+o5PAZmPfMsQYt8PsOkDE6YNU11VH9WM_QPcvg@mail.gmail.com> (sfid-20161017_152046_609291_A360F226)
Subject: Re: [PATCH v4] mac80211: move extra crypto data off the stack
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "<linux-wireless@vger.kernel.org>" <linux-wireless@vger.kernel.org>,
        Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 17 October 2016 at 14:16, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Mon, 2016-10-17 at 14:06 +0100, Ard Biesheuvel wrote:
>>
>> Actually, while I think it will be worthwhile going forward to
>> implement such an 'auxiliary data' feature in a generic way, I still
>> think we should address the issue at hand without too much
>> complication.
>>
>> If we pedal back to the version of 'mac80211: move struct aead_req
>> off the stack' that uses kzalloc() instead of aead_request_alloc(),
>> we can simply add some space for aad[] and/or zero[], and get rid of
>> the kmem cache entirely.
>>
>> If you're past this point already, i won't bother but otherwise I can
>> rework 'mac80211: move struct aead_req off the stack' so that the
>> other patch is no longer required (and IIRC, this is actually
>> something you proposed yourself a couple of iterations ago?)
>
> Yes, I did consider that.
>
> It makes some sense, and I guess the extra memcpy() would be cheaper
> than the extra alloc?
>
> I'd happily use that instead of the combination of my two patches. The
> aead_request_alloc() is just a simple inline anyway, so no real problem
> not using it.
>

Indeed. And it keeps the clutter inside the aes_xxx.c files, which
could easily be updated in the future to use some auxdata feature if
it ever materializes.

I think it would help this code, but also the ESP code you pointed
out, to have some kind of 'ordered synchronous' CRYPTO_xxx flag, where
the crypto API could manage the kmem cache and percpu pointers to
allocations. This goes well beyond what we can do as a fix, though, so
we need an intermediate solution in any case.

Shall I propose the patch?
