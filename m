Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39342 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752739AbdBHHAc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Feb 2017 02:00:32 -0500
Message-ID: <1486537227.4603.2.camel@sipsolutions.net> (sfid-20170208_080051_692418_E95A8F81)
Subject: Re: [PATCH v3 1/2] mac80211: fils_aead: Use crypto api CMAC shash
 rather than bare cipher
From: Johannes Berg <johannes@sipsolutions.net>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-wireless@vger.kernel.org
Cc: davem@davemloft.net, netdev@vger.kernel.org, jouni@qca.qualcomm.com
Date: Wed, 08 Feb 2017 08:00:27 +0100
In-Reply-To: <1486378168-31028-2-git-send-email-ard.biesheuvel@linaro.org> (sfid-20170206_114945_027134_93100C60)
References: <1486378168-31028-1-git-send-email-ard.biesheuvel@linaro.org>
         <1486378168-31028-2-git-send-email-ard.biesheuvel@linaro.org>
         (sfid-20170206_114945_027134_93100C60)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This looks strange to me:

> +static int aes_s2v(struct crypto_shash *tfm,
>  		   size_t num_elem, const u8 *addr[], size_t len[],
> u8 *v)
>  {
> -	u8 d[AES_BLOCK_SIZE], tmp[AES_BLOCK_SIZE];
> +	u8 d[AES_BLOCK_SIZE], tmp[AES_BLOCK_SIZE] = {};
> +	SHASH_DESC_ON_STACK(desc, tfm);

desc declared

> 
> +	crypto_shash_digest(desc, tmp, AES_BLOCK_SIZE, d);

used here
 
> +	crypto_shash_init(desc);

but initialized now?

johannes
