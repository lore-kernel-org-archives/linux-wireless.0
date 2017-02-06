Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37194 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750956AbdBFIr5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 6 Feb 2017 03:47:57 -0500
Message-ID: <1486370872.14226.6.camel@sipsolutions.net> (sfid-20170206_094806_472930_39562865)
Subject: Re: [PATCH v2 1/2] mac80211: fils_aead: Use crypto api CMAC shash
 rather than bare cipher
From: Johannes Berg <johannes@sipsolutions.net>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>, jouni@qca.qualcomm.com,
        linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org, davem@davemloft.net
Date: Mon, 06 Feb 2017 09:47:52 +0100
In-Reply-To: <1486308208-3252-2-git-send-email-ard.biesheuvel@linaro.org> (sfid-20170205_162529_852496_51AF58D1)
References: <1486308208-3252-1-git-send-email-ard.biesheuvel@linaro.org>
         <1486308208-3252-2-git-send-email-ard.biesheuvel@linaro.org>
         (sfid-20170205_162529_852496_51AF58D1)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


>  {
>  	u8 d[AES_BLOCK_SIZE], tmp[AES_BLOCK_SIZE];
> +	struct shash_desc *desc;
> +	u8 buf[sizeof(*desc) + crypto_shash_descsize(tfm)]
> CRYPTO_MINALIGN_ATTR;
>  	size_t i;
> -	const u8 *data[2];
> -	size_t data_len[2], data_elems;
> +
> +	desc = (struct shash_desc *)buf;
> +	desc->tfm = tfm;
> 
> +	crypto_shash_digest(desc, (u8[AES_BLOCK_SIZE]){},
> AES_BLOCK_SIZE, d);

That's an interesting expression in there. Can we name it into a real
variable? :)

I'm also slightly worried about stack usage now - do we know none of
this goes into an sg list eventually?

johannes
