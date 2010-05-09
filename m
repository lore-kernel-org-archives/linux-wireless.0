Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:65138 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828Ab0EIJDo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 May 2010 05:03:44 -0400
Received: by bwz19 with SMTP id 19so1239605bwz.21
        for <linux-wireless@vger.kernel.org>; Sun, 09 May 2010 02:03:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1273354826-4335-2-git-send-email-gwingerde@gmail.com>
References: <1273354826-4335-1-git-send-email-gwingerde@gmail.com>
	 <1273354826-4335-2-git-send-email-gwingerde@gmail.com>
Date: Sun, 9 May 2010 11:03:42 +0200
Message-ID: <AANLkTikWtLvG-J9UclCEsp7V1B7_J69eujVseWVsZk2y@mail.gmail.com>
Subject: Re: [PATCH 1/9] rt2x00: Fix setting of txdesc->length field.
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, May 8, 2010 at 11:40 PM, Gertjan van Wingerde
<gwingerde@gmail.com> wrote:
> We should take the stripping of the IV into account for the txdesc->length
> field.
>
> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/rt2x00crypto.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2x00crypto.c b/drivers/net/wireless/rt2x00/rt2x00crypto.c
> index d291c78..583dacd 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00crypto.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00crypto.c
> @@ -128,6 +128,7 @@ void rt2x00crypto_tx_remove_iv(struct sk_buff *skb, struct txentry_desc *txdesc)
>
>        /* Pull buffer to correct size */
>        skb_pull(skb, txdesc->iv_len);
> +       txdesc->length -= txdesc->iv_len;
>
>        /* IV/EIV data has officially been stripped */
>        skbdesc->flags |= SKBDESC_IV_STRIPPED;
> --
> 1.7.1
>
>
