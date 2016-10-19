Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f182.google.com ([209.85.223.182]:32797 "EHLO
        mail-io0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S944471AbcJSPIN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Oct 2016 11:08:13 -0400
Received: by mail-io0-f182.google.com with SMTP id q192so34801733iod.0
        for <linux-wireless@vger.kernel.org>; Wed, 19 Oct 2016 08:08:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1476862995.5927.3.camel@sipsolutions.net>
References: <1476551776-8099-1-git-send-email-ard.biesheuvel@linaro.org>
 <1476689310.19992.1.camel@sipsolutions.net> <CAKv+Gu_P-6sHW3t7tp1N+3v9ZGqWcQrzMZkASY5g=QR76KN4wg@mail.gmail.com>
 <CALCETrUWW2A1XK7BzcajTcBzg58SDUCTE35Hj1vmbywTLCe2vQ@mail.gmail.com>
 <CAKv+Gu-25OvTSbyE06Ln8N+HsqNyV1T6oOudK2tyAAOmmXXqgA@mail.gmail.com>
 <20161019033157.GA1457@gondor.apana.org.au> <1476862995.5927.3.camel@sipsolutions.net>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Wed, 19 Oct 2016 16:08:11 +0100
Message-ID: <CAKv+Gu9CppR+AN5_RdDJ6ZBRr1EDDLB+nABPddyaj5TKb5=j_Q@mail.gmail.com> (sfid-20161019_170846_484171_CE1DDA28)
Subject: Re: [PATCH] crypto: ccm - avoid scatterlist for MAC encryption
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        Andy Lutomirski <luto@amacapital.net>,
        Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "<linux-wireless@vger.kernel.org>" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jouni Malinen <j@w1.fi>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 19 October 2016 at 08:43, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Wed, 2016-10-19 at 11:31 +0800, Herbert Xu wrote:
>> On Mon, Oct 17, 2016 at 06:21:14PM +0100, Ard Biesheuvel wrote:
>> >
>> >
>> > Annoyingly, all this complication with scatterlists etc is for
>> > doing
>> > asynchronous crypto via DMA capable crypto accelerators, and the
>> > networking code (ipsec as well as mac80211, afaik) only allow
>> > synchronous in the first place, given that they execute in softirq
>> > context.
>>
>> I'm still thinking about the issue (in particular, whether we
>> should continue to rely on the request context being SG-capable
>> or allow it to be on the stack for AEAD).
>
> :)
>
>> But IPsec definitely supports async crypto.  In fact it was the
>> very first user of async crypto.
>
> Yeah.
>

Ah yes, my bad.

>> mac80211 on the other hand is currently sync-only.
>
> We could probably make mac80211 do that too, but can we guarantee in-
> order processing? Anyway, it's pretty low priority, maybe never
> happening, since hardly anyone really uses "software" crypto, the wifi
> devices mostly have it built in anyway.
>

Indeed. The code is now correct in terms of API requirements, so let's
just wait for someone to complain about any performance regressions.
