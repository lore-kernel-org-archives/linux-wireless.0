Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f48.google.com ([209.85.214.48]:37856 "EHLO
        mail-it0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755943AbcJNNTX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 14 Oct 2016 09:19:23 -0400
Received: by mail-it0-f48.google.com with SMTP id m138so10654644itm.0
        for <linux-wireless@vger.kernel.org>; Fri, 14 Oct 2016 06:19:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1476450941.31114.45.camel@sipsolutions.net>
References: <1476450540-1760-1-git-send-email-ard.biesheuvel@linaro.org>
 <1476450635.31114.42.camel@sipsolutions.net> <CAKv+Gu_eS-C84rH_MLYy--ivC0a99wwJvNDLhETfrBkYXW-XpA@mail.gmail.com>
 <1476450941.31114.45.camel@sipsolutions.net>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Fri, 14 Oct 2016 14:19:21 +0100
Message-ID: <CAKv+Gu81RYq1aZUQ2Aru3Vev4LGgb1zFwWz8gepE0tQEhQi9Uw@mail.gmail.com> (sfid-20161014_152010_086332_23943E58)
Subject: Re: [PATCH] mac80211: aes_ccm: move struct aead_req off the stack
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

On 14 October 2016 at 14:15, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Fri, 2016-10-14 at 14:13 +0100, Ard Biesheuvel wrote:
>>
>> > But if we allocate things anyway, is it worth expending per-CPU
>> > buffers on these?
>>
>> Ehmm, maybe not. I could spin a v2 that allocates a bigger buffer,
>> and copies aad[] into it as well
>
> Copies in/out, I guess. Also there's B_0/J_0 for CCM/GCM, and the
> 'zero' thing that GMAC has.
>

Is the aad[] actually reused? I would assume it only affects the mac
on encryption, and the verification on decryption but I don't think we
actually need it back from the crypto routines.

>> That does not help the other algos though
>
> What do you mean?
>

Exactly what you said above :-) My patch only touches CCM but as you said,

"""
'Also there's B_0/J_0 for CCM/GCM, and the 'zero' thing that GMAC has.
"""
