Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f50.google.com ([209.85.214.50]:35332 "EHLO
        mail-it0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755573AbcJROS1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Oct 2016 10:18:27 -0400
Received: by mail-it0-f50.google.com with SMTP id 4so82651750itv.0
        for <linux-wireless@vger.kernel.org>; Tue, 18 Oct 2016 07:18:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1476800194.6425.35.camel@sipsolutions.net>
References: <1476799713-16188-1-git-send-email-ard.biesheuvel@linaro.org>
 <1476799713-16188-3-git-send-email-ard.biesheuvel@linaro.org> <1476800194.6425.35.camel@sipsolutions.net>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Tue, 18 Oct 2016 15:18:26 +0100
Message-ID: <CAKv+Gu8aE4AfewHeMDf2RQfJtSsrp6Fb1A_ygFsqEwpyP6hDjQ@mail.gmail.com> (sfid-20161018_161833_028300_469EC260)
Subject: Re: [RFC PATCH 2/2] mac80211: aes_ccm: cache AEAD request structures
 per CPU
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "<linux-wireless@vger.kernel.org>" <linux-wireless@vger.kernel.org>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jouni Malinen <j@w1.fi>, Andy Lutomirski <luto@amacapital.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 18 October 2016 at 15:16, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Tue, 2016-10-18 at 15:08 +0100, Ard Biesheuvel wrote:
>>
>> +     aead_req = *this_cpu_ptr(ccmp->reqs);
>> +     if (!aead_req) {
>> +             aead_req = kzalloc(reqsize + CCM_AAD_LEN, GFP_ATOMIC);
>> +             if (!aead_req)
>> +                     return -ENOMEM;
>> +             *this_cpu_ptr(ccmp->reqs) = aead_req;
>> +             aead_request_set_tfm(aead_req, ccmp->tfm);
>> +     }
>
> Hmm. Is it really worth having a per-CPU variable for each possible
> key? You could have a large number of those (typically three when
> you're a client on an AP, and 1 + 1 for each client when you're the
> AP).
>
> Would it be so bad to have to set the TFM every time (if that's even
> possible), and just have a single per-CPU cache?
>

That would be preferred, yes. The only snag here is that
crypto_alloc_aead() is not guaranteed to return the same algo every
time, which means the request size is not guaranteed to be the same
either. This is a rare corner case, of course, but it needs to be
dealt with regardless
