Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:53542 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751246AbeFHPIE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Jun 2018 11:08:04 -0400
MIME-Version: 1.0
In-Reply-To: <1528375527-22761-1-git-send-email-geert@linux-m68k.org>
References: <1528375527-22761-1-git-send-email-geert@linux-m68k.org>
From: Ramon Fried <ramon.fried@gmail.com>
Date: Fri, 8 Jun 2018 18:08:02 +0300
Message-ID: <CA+Kvs9m_XnE-4F+R9jKD4sD9=7eQP7rBidA_7Hi0XVLs7-KhUA@mail.gmail.com> (sfid-20180608_170820_126684_C8BFA44B)
Subject: Re: [PATCH] wcn36xx: Remove Unicode Byte Order Mark from testcode
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Eyal Ilsar <eilsar@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>,
        wcn36xx@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 7, 2018 at 3:45 PM, Geert Uytterhoeven <geert@linux-m68k.org> w=
rote:
> Older gcc (< 4.4) doesn't like files starting with a Unicode BOM:
>
>     drivers/net/wireless/ath/wcn36xx/testmode.c:1: error: stray =E2=80=98=
\357=E2=80=99 in program
>     drivers/net/wireless/ath/wcn36xx/testmode.c:1: error: stray =E2=80=98=
\273=E2=80=99 in program
>     drivers/net/wireless/ath/wcn36xx/testmode.c:1: error: stray =E2=80=98=
\277=E2=80=99 in program
>
> Remove the BOM, the rest of the file is plain ASCII anyway.
>
> Output of "file drivers/net/wireless/ath/wcn36xx/testmode.c" before:
>
>     drivers/net/wireless/ath/wcn36xx/testmode.c: C source, UTF-8 Unicode =
(with BOM) text
>
> and after:
>
>     drivers/net/wireless/ath/wcn36xx/testmode.c: C source, ASCII text
>
> Fixes: 87f825e6e246cee0 ("wcn36xx: Add support for Factory Test Mode (FTM=
)")
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Thanks Geert !
Acked-by: Ramon Fried <ramon.fried@gmail.com>

> ---
>  drivers/net/wireless/ath/wcn36xx/testmode.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/ath/wcn36xx/testmode.c b/drivers/net/wi=
reless/ath/wcn36xx/testmode.c
> index 1279064a3b716c2e..51a038022c8b8040 100644
> --- a/drivers/net/wireless/ath/wcn36xx/testmode.c
> +++ b/drivers/net/wireless/ath/wcn36xx/testmode.c
> @@ -1,4 +1,4 @@
> -=EF=BB=BF/*
> +/*
>   * Copyright (c) 2018, The Linux Foundation. All rights reserved.
>   *
>   * Permission to use, copy, modify, and/or distribute this software for =
any
> --
> 2.7.4
>
>
> _______________________________________________
> wcn36xx mailing list
> wcn36xx@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/wcn36xx
