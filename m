Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f48.google.com ([209.85.214.48]:37905 "EHLO
        mail-it0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932848AbcJQNGt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 17 Oct 2016 09:06:49 -0400
Received: by mail-it0-f48.google.com with SMTP id 66so7281332itl.1
        for <linux-wireless@vger.kernel.org>; Mon, 17 Oct 2016 06:06:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <41D0AC2F-E86E-4A98-AD8B-1239D7E6123A@linaro.org>
References: <1476693195-14071-1-git-send-email-johannes@sipsolutions.net>
 <CAKv+Gu-aZhCBvnEQoZUZLDPXCrvgxO1pSd=6EHz+tMB+dFz5hg@mail.gmail.com>
 <1476696226.19992.13.camel@sipsolutions.net> <CAKv+Gu_ZH9hO_xbVfOfk90CxFJ6ZTz3PKWB1v23LRVzpBrb=oQ@mail.gmail.com>
 <1476696918.19992.15.camel@sipsolutions.net> <67161BCC-596E-4DDE-A58E-9195BB5570C2@linaro.org>
 <1476698041.19992.19.camel@sipsolutions.net> <41D0AC2F-E86E-4A98-AD8B-1239D7E6123A@linaro.org>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Mon, 17 Oct 2016 14:06:47 +0100
Message-ID: <CAKv+Gu9OT6r3gbrLi_wzBcPXoA6K9z=-4ybrgQy4X=FvjOOuhA@mail.gmail.com> (sfid-20161017_150912_527299_6CB67350)
Subject: Re: [PATCH v4] mac80211: move extra crypto data off the stack
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "<linux-wireless@vger.kernel.org>" <linux-wireless@vger.kernel.org>,
        Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 17 October 2016 at 11:02, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>
>
>> On 17 Oct 2016, at 10:54, Johannes Berg <johannes@sipsolutions.net> wrote:
>>
>>
>>>> Well, if your other patch to make it OK to be on-stack would be
>>>> applied instead, this wouldn't make much sense either :)
>>>>
>>>
>>> Yes but that one only fixes ccm not gcm
>>
>> Yes, but we can do the same for GCM, no?
>>
>
> No, not really. ccm happens to use aes with the same key for the mac and the encryption. gcm uses an another algo entirely for the mac
>
>>>> In this particular patch, we could reduce the size of the struct,
>>>> but I
>>>> don't actually think it'll make a difference to go from 48 to 36
>>>> bytes,
>>>> given alignment etc., so I think I'll just leave it as is.
>>>>
>>>
>>> I understand you are in a hurry, but this is unlikely to be the only
>>> such issue. I will propose an 'auxdata' feature for the crypto api
>>> that can be used here, but also for any other occurrence where client
>>> data assoiciated with the request can no longer be allocated on the
>>> stack
>>
>> No objections. I'll merge this anyway today I think, reverting is easy
>> later.
>>
>
> ok fair enough

Actually, while I think it will be worthwhile going forward to
implement such an 'auxiliary data' feature in a generic way, I still
think we should address the issue at hand without too much
complication.

If we pedal back to the version of 'mac80211: move struct aead_req off
the stack' that uses kzalloc() instead of aead_request_alloc(), we can
simply add some space for aad[] and/or zero[], and get rid of the kmem
cache entirely.

If you're past this point already, i won't bother but otherwise I can
rework 'mac80211: move struct aead_req off the stack' so that the
other patch is no longer required (and IIRC, this is actually
something you proposed yourself a couple of iterations ago?)
