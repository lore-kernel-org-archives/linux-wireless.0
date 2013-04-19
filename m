Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f178.google.com ([209.85.223.178]:45795 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967950Ab3DSJtn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Apr 2013 05:49:43 -0400
Received: by mail-ie0-f178.google.com with SMTP id aq17so2949523iec.37
        for <linux-wireless@vger.kernel.org>; Fri, 19 Apr 2013 02:49:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1366201848-18009-3-git-send-email-stf_xl@wp.pl>
References: <1366201848-18009-1-git-send-email-stf_xl@wp.pl>
	<1366201848-18009-3-git-send-email-stf_xl@wp.pl>
Date: Fri, 19 Apr 2013 11:49:42 +0200
Message-ID: <CAL1gcdNQMRyiR+dyuPWYFCfokG9azoZugFQOqAZqt2x4UbKoLA@mail.gmail.com> (sfid-20130419_114946_821953_72068EA7)
Subject: Re: [rt2x00-users] [PATCH 2/2] rt2800: nulify all last words of TXWI
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: Stanislaw Gruszka <stf_xl@wp.pl>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	rt2x00 Users List <users@rt2x00.serialmonkey.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Stanislaw,

On Wed, Apr 17, 2013 at 2:30 PM,  <stf_xl@wp.pl> wrote:
> From: Stanislaw Gruszka <stf_xl@wp.pl>
>
> Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
> ---
>  drivers/net/wireless/rt2x00/rt2800lib.c |   11 +++++++----
>  1 files changed, 7 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
> index 5c20e98..35f58bb 100644
> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
> @@ -542,6 +542,7 @@ void rt2800_write_tx_data(struct queue_entry *entry,
>  {
>         __le32 *txwi = rt2800_drv_get_txwi(entry);
>         u32 word;
> +       int i;
>
>         /*
>          * Initialize TX Info descriptor
> @@ -584,14 +585,16 @@ void rt2800_write_tx_data(struct queue_entry *entry,
>         rt2x00_desc_write(txwi, 1, word);
>
>         /*
> -        * Always write 0 to IV/EIV fields, hardware will insert the IV
> -        * from the IVEIV register when TXD_W3_WIV is set to 0.
> +        * Always write 0 to IV/EIV fields (word 2 and 3), hardware will insert
> +        * the IV from the IVEIV register when TXD_W3_WIV is set to 0.
>          * When TXD_W3_WIV is set to 1 it will use the IV data
>          * from the descriptor. The TXWI_W1_WIRELESS_CLI_ID indicates which
>          * crypto entry in the registers should be used to encrypt the frame.
> +        *
> +        * Nulify all remaining words as well, we don't know how to program them.
>          */
> -       _rt2x00_desc_write(txwi, 2, 0 /* skbdesc->iv[0] */);
> -       _rt2x00_desc_write(txwi, 3, 0 /* skbdesc->iv[1] */);
> +       for (i = 2; i < entry->queue->winfo_size / sizeof(__le32); i++)
> +               _rt2x00_desc_write(txwi, i, 0);
>  }
>  EXPORT_SYMBOL_GPL(rt2800_write_tx_data);
>

Wouldn't it be easier / better to simply clear the whole descriptor at
the start, instead of selective clearing parts of it after everything
has been written already?

---
Gertjan
