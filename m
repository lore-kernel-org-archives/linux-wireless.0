Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f41.google.com ([209.85.214.41]:37639 "EHLO
        mail-it0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755624AbcJNNNK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 14 Oct 2016 09:13:10 -0400
Received: by mail-it0-f41.google.com with SMTP id m138so10500161itm.0
        for <linux-wireless@vger.kernel.org>; Fri, 14 Oct 2016 06:13:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1476450635.31114.42.camel@sipsolutions.net>
References: <1476450540-1760-1-git-send-email-ard.biesheuvel@linaro.org> <1476450635.31114.42.camel@sipsolutions.net>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Fri, 14 Oct 2016 14:13:08 +0100
Message-ID: <CAKv+Gu_eS-C84rH_MLYy--ivC0a99wwJvNDLhETfrBkYXW-XpA@mail.gmail.com> (sfid-20161014_151501_488619_0381CF5C)
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

On 14 October 2016 at 14:10, Johannes Berg <johannes@sipsolutions.net> wrote:
>
>> So use kzalloc
>
> Do we really need kzalloc()? We have things on the stack right now, and
> don't initialize, so surely we don't really need to zero things?
>
>> This only addresses one half of the problem. The other problem, i.e.,
>> the fact that the aad[] array lives on the stack of the caller, is
>> handled adequately imo by the change proposed by Johannes.
>
> But if we allocate things anyway, is it worth expending per-CPU buffers
> on these?
>

Ehmm, maybe not. I could spin a v2 that allocates a bigger buffer, and
copies aad[] into it as well
That does not help the other algos though
