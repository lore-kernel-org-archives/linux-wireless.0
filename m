Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f175.google.com ([209.85.223.175]:36437 "EHLO
        mail-io0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753478AbdBHHpw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Feb 2017 02:45:52 -0500
Received: by mail-io0-f175.google.com with SMTP id j13so109727730iod.3
        for <linux-wireless@vger.kernel.org>; Tue, 07 Feb 2017 23:45:52 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1486537227.4603.2.camel@sipsolutions.net>
References: <1486378168-31028-1-git-send-email-ard.biesheuvel@linaro.org>
 <1486378168-31028-2-git-send-email-ard.biesheuvel@linaro.org> <1486537227.4603.2.camel@sipsolutions.net>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Wed, 8 Feb 2017 07:45:51 +0000
Message-ID: <CAKv+Gu9Be-bA-Trn5cMwVvf4+yMm8w2Krm59WGAhdM3bxBSJfw@mail.gmail.com> (sfid-20170208_084817_810576_801F3841)
Subject: Re: [PATCH v3 1/2] mac80211: fils_aead: Use crypto api CMAC shash
 rather than bare cipher
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "<linux-wireless@vger.kernel.org>" <linux-wireless@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        Jouni Malinen <jouni@qca.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8 February 2017 at 07:00, Johannes Berg <johannes@sipsolutions.net> wrote:
> This looks strange to me:
>
>> +static int aes_s2v(struct crypto_shash *tfm,
>>                  size_t num_elem, const u8 *addr[], size_t len[],
>> u8 *v)
>>  {
>> -     u8 d[AES_BLOCK_SIZE], tmp[AES_BLOCK_SIZE];
>> +     u8 d[AES_BLOCK_SIZE], tmp[AES_BLOCK_SIZE] = {};
>> +     SHASH_DESC_ON_STACK(desc, tfm);
>
> desc declared
>
>>
>> +     crypto_shash_digest(desc, tmp, AES_BLOCK_SIZE, d);
>
> used here
>

Each digest() call combines a init()/update()/final() sequence

>> +     crypto_shash_init(desc);
>
> but initialized now?
>

... for the 6th time, or so. The final vector may require two
update()s, so we cannot use digest() here. But we can use finup() for
the last one, which combines update() and final().

Hence,

init()/finup()

or

init()/update()/finup()

depending on the length of the last vector.
