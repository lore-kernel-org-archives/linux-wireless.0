Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:41186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750871AbdJCESq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Oct 2017 00:18:46 -0400
Received: from mail-it0-f50.google.com (mail-it0-f50.google.com [209.85.214.50])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E3B1D2188C
        for <linux-wireless@vger.kernel.org>; Tue,  3 Oct 2017 04:18:45 +0000 (UTC)
Received: by mail-it0-f50.google.com with SMTP id d192so10089825itd.1
        for <linux-wireless@vger.kernel.org>; Mon, 02 Oct 2017 21:18:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1506997522-26684-1-git-send-email-baijiaju1990@163.com>
References: <1506997522-26684-1-git-send-email-baijiaju1990@163.com>
From: Andy Lutomirski <luto@kernel.org>
Date: Mon, 2 Oct 2017 21:18:24 -0700
Message-ID: <CALCETrWdXjTTTywbb3duCEsLYNxkeGx7bf3SM4PYKeErCyiUNQ@mail.gmail.com> (sfid-20171003_061855_003891_B94A14C6)
Subject: Re: [PATCH V2] Fix a sleep-in-atomic bug in shash_setkey_unaligned
To: Jia-Ju Bai <baijiaju1990@163.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Neil Horman <nhorman@tuxdriver.com>, vyasevich@gmail.com,
        Andrew Lutomirski <luto@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        linux-sctp@vger.kernel.org,
        Linux Wireless List <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> On Oct 2, 2017, at 7:25 PM, Jia-Ju Bai <baijiaju1990@163.com> wrote:
>
> The SCTP program may sleep under a spinlock, and the function call path is:
> sctp_generate_t3_rtx_event (acquire the spinlock)
>  sctp_do_sm
>    sctp_side_effects
>      sctp_cmd_interpreter
>        sctp_make_init_ack
>          sctp_pack_cookie
>            crypto_shash_setkey
>              shash_setkey_unaligned
>                kmalloc(GFP_KERNEL)
>

I'm going to go out on a limb here: why on Earth is out crypto API so
full of indirection that we allocate memory at all here?

We're synchronously computing a hash of a small amount of data using
either HMAC-SHA1 or HMAC-SHA256 (determined at runtime) if I read it
right.  There's a sane way to do this that doesn't need kmalloc,
alloca, or fancy indirection.  And then there's crypto_shash_xyz().

--Andy, who is sick of seeing stupid bugs caused by the fact that it's
basically impossible to use the crypto API in a sane way.

P.S. gnulib has:

int hmac_sha256 (const void *key, size_t keylen, const void *in,
size_t inlen, void *resbuf);

An init/update/final-style API would be nice, but something like this
would be a phenomenal improvement over what we have.
