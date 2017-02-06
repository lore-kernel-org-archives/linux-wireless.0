Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f46.google.com ([209.85.214.46]:38359 "EHLO
        mail-it0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751412AbdBFJIl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 6 Feb 2017 04:08:41 -0500
Received: by mail-it0-f46.google.com with SMTP id c7so52675791itd.1
        for <linux-wireless@vger.kernel.org>; Mon, 06 Feb 2017 01:08:40 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1486370872.14226.6.camel@sipsolutions.net>
References: <1486308208-3252-1-git-send-email-ard.biesheuvel@linaro.org>
 <1486308208-3252-2-git-send-email-ard.biesheuvel@linaro.org> <1486370872.14226.6.camel@sipsolutions.net>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Mon, 6 Feb 2017 09:08:39 +0000
Message-ID: <CAKv+Gu9KdJCzkWtGYDaK_6_WgW4aZ4Wtm-O581STyDKj7RzyrA@mail.gmail.com> (sfid-20170206_101042_358338_268EF06D)
Subject: Re: [PATCH v2 1/2] mac80211: fils_aead: Use crypto api CMAC shash
 rather than bare cipher
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Jouni Malinen <jouni@qca.qualcomm.com>,
        "<linux-wireless@vger.kernel.org>" <linux-wireless@vger.kernel.org>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 6 February 2017 at 08:47, Johannes Berg <johannes@sipsolutions.net> wrote:
>
>>  {
>>       u8 d[AES_BLOCK_SIZE], tmp[AES_BLOCK_SIZE];
>> +     struct shash_desc *desc;
>> +     u8 buf[sizeof(*desc) + crypto_shash_descsize(tfm)]
>> CRYPTO_MINALIGN_ATTR;

I realised we have a more idiomatic SHASH_DESC_ON_STACK for this.

>>       size_t i;
>> -     const u8 *data[2];
>> -     size_t data_len[2], data_elems;
>> +
>> +     desc = (struct shash_desc *)buf;
>> +     desc->tfm = tfm;
>>
>> +     crypto_shash_digest(desc, (u8[AES_BLOCK_SIZE]){},
>> AES_BLOCK_SIZE, d);
>
> That's an interesting expression in there. Can we name it into a real
> variable? :)
>

Sure, if you prefer.

> I'm also slightly worried about stack usage now - do we know none of
> this goes into an sg list eventually?
>

Shashes do not usually use scatterlists: the shash API does not use
them, but uses u8[] arrays and lengths everywhere, and shashes are
explicitly synchronous, which means they are unsuitable for being
exposed on top of a high latency peripheral that uses DMA.
