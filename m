Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f169.google.com ([209.85.223.169]:34439 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752305AbbCXJc0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Mar 2015 05:32:26 -0400
Received: by iedfl3 with SMTP id fl3so63742193ied.1
        for <linux-wireless@vger.kernel.org>; Tue, 24 Mar 2015 02:32:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150323140814.GA27609@mwanda>
References: <20150323132409.GA20999@jouni.qca.qualcomm.com>
	<20150323140814.GA27609@mwanda>
Date: Tue, 24 Mar 2015 10:32:25 +0100
Message-ID: <CAKv+Gu_UUceETqDKBXxDYwKR0ApwROpSg8UxRg_DKQmyNvfBFQ@mail.gmail.com> (sfid-20150324_103229_611326_6C6649CB)
Subject: Re: [patch] mac80111: aes_ccm: cleanup ieee80211_aes_key_setup_encrypt()
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	"<linux-wireless@vger.kernel.org>" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 23 March 2015 at 15:08, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> This code is written using an anti-pattern called "success handling"
> which makes it hard to read, especially if you are used to normal kernel
> style.  It should instead be written as a list of directives in a row
> with branches for error handling.
>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Thanks,
Ard.

>
> diff --git a/net/mac80211/aes_ccm.c b/net/mac80211/aes_ccm.c
> index 7869bb40..208df7c 100644
> --- a/net/mac80211/aes_ccm.c
> +++ b/net/mac80211/aes_ccm.c
> @@ -85,11 +85,15 @@ struct crypto_aead *ieee80211_aes_key_setup_encrypt(const u8 key[],
>                 return tfm;
>
>         err = crypto_aead_setkey(tfm, key, key_len);
> -       if (!err)
> -               err = crypto_aead_setauthsize(tfm, mic_len);
> -       if (!err)
> -               return tfm;
> +       if (err)
> +               goto free_aead;
> +       err = crypto_aead_setauthsize(tfm, mic_len);
> +       if (err)
> +               goto free_aead;
> +
> +       return tfm;
>
> +free_aead:
>         crypto_free_aead(tfm);
>         return ERR_PTR(err);
>  }
