Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f42.google.com ([209.85.214.42]:35348 "EHLO
        mail-it0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934255AbcJROa7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Oct 2016 10:30:59 -0400
Received: by mail-it0-f42.google.com with SMTP id 4so83041630itv.0
        for <linux-wireless@vger.kernel.org>; Tue, 18 Oct 2016 07:30:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1476800647.6425.38.camel@sipsolutions.net>
References: <1476799713-16188-1-git-send-email-ard.biesheuvel@linaro.org>
 <1476799713-16188-3-git-send-email-ard.biesheuvel@linaro.org>
 <1476800194.6425.35.camel@sipsolutions.net> <CAKv+Gu8aE4AfewHeMDf2RQfJtSsrp6Fb1A_ygFsqEwpyP6hDjQ@mail.gmail.com>
 <1476800647.6425.38.camel@sipsolutions.net>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Tue, 18 Oct 2016 15:30:56 +0100
Message-ID: <CAKv+Gu8c_5FpDfDE=HfSC6Xi5dGDzp1nQDH2Sw=YjnYkeEG4rw@mail.gmail.com> (sfid-20161018_163136_422089_4072A07E)
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

On 18 October 2016 at 15:24, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Tue, 2016-10-18 at 15:18 +0100, Ard Biesheuvel wrote:
>>
>> > Hmm. Is it really worth having a per-CPU variable for each possible
>> > key? You could have a large number of those (typically three when
>> > you're a client on an AP, and 1 + 1 for each client when you're the
>> > AP).
>
> 2 + 1 for each client, actually, since you have 2 GTKs present in the
> "steady state"; not a big difference though.
>
>> > Would it be so bad to have to set the TFM every time (if that's
>> > even possible), and just have a single per-CPU cache?
>
>> That would be preferred, yes. The only snag here is that
>> crypto_alloc_aead() is not guaranteed to return the same algo every
>> time, which means the request size is not guaranteed to be the same
>> either. This is a rare corner case, of course, but it needs to be
>> dealt with regardless
>
> Ah, good point. Well I guess you could allocate a bigger one it if it's
> too small, but then we'd have to recalculate the size all the time
> (which we already did anyway, but saving something else would be good).
> Then we'd be close to just having a per-CPU memory block cache though.
>

Well, ideally we'd allocate the ccm(aes) crypto_alg a single time and
'spawn' the transforms for each key. This is how the crypto API
implements templates internally, but I don't think this functionality
is publicly accessible. Herbert?
