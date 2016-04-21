Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f52.google.com ([209.85.218.52]:34245 "EHLO
	mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740AbcDUBgh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Apr 2016 21:36:37 -0400
Received: by mail-oi0-f52.google.com with SMTP id k142so63173322oib.1
        for <linux-wireless@vger.kernel.org>; Wed, 20 Apr 2016 18:36:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1461126052-12164-1-git-send-email-mfaltesek@google.com>
References: <1461126052-12164-1-git-send-email-mfaltesek@google.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Thu, 21 Apr 2016 11:36:17 +1000
Message-ID: <CAGRGNgV85z2w-kQBbeWpQpbpAO1qmJy1DFQ8uTVERYq+wHZydg@mail.gmail.com> (sfid-20160421_033641_690921_4B28BE03)
Subject: Re: [PATCH v2] mwifiex: fw download does not release sdio bus during failure
To: Marty Faltesek <mfaltesek@google.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Amitkumar Karwar <akarwar@marvell.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi All,

On Wed, Apr 20, 2016 at 2:20 PM, Marty Faltesek <mfaltesek@google.com> wrote:
> Signed-off-by: Marty Faltesek <mfaltesek@google.com>

This looks right to me.

Reviewed-by: Julian Calaby <julian.calaby@gmail.com>

Thanks,

Julian Calaby


> ---
>  drivers/net/wireless/marvell/mwifiex/sdio.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.c b/drivers/net/wireless/marvell/mwifiex/sdio.c
> index 4c8cae6..d6ef34f 100644
> --- a/drivers/net/wireless/marvell/mwifiex/sdio.c
> +++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
> @@ -1026,13 +1026,12 @@ static int mwifiex_prog_fw_w_helper(struct mwifiex_adapter *adapter,
>                 offset += txlen;
>         } while (true);
>
> -       sdio_release_host(card->func);
> -
>         mwifiex_dbg(adapter, MSG,
>                     "info: FW download over, size %d bytes\n", offset);
>
>         ret = 0;
>  done:
> +       sdio_release_host(card->func);
>         kfree(fwbuf);
>         return ret;
>  }
> --
> 2.8.0.rc3.226.g39d4020
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
