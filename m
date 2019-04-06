Return-Path: <SRS0=AXTt=SI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E904DC282DA
	for <linux-wireless@archiver.kernel.org>; Sat,  6 Apr 2019 09:12:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A9D1F2173C
	for <linux-wireless@archiver.kernel.org>; Sat,  6 Apr 2019 09:12:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XnQG6UQj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726316AbfDFJMJ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 6 Apr 2019 05:12:09 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:44974 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726036AbfDFJMI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 6 Apr 2019 05:12:08 -0400
Received: by mail-wr1-f67.google.com with SMTP id y7so10552114wrn.11;
        Sat, 06 Apr 2019 02:12:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aIrpe3jK9YRA4TrJjFmGutaVzAkGlsrgPpN+cpGwvlE=;
        b=XnQG6UQjt52d51v+1l7h6xYxGYalll7p9C/ExTp9mWsbCAkourcHoOfvN4e4w+c+3A
         OETyuonUKzlEkrfdCvzjyWI/YovTorW6hv7+XyMYE9A9b96TF0t8mPsZxTp9alyjrLSt
         LNBg/9s6DSq9zpcPuMeOm9UhnVWkvR7z/EPBpwDm9AA3edApkhqPRQflQlm6rJMYuXCq
         ZC34DtPkJVaXxpMHmL7ZZEKqDLUrEAr6GJCQekybV4a0WbbueHTn78G7t9HDCnRVwYkB
         H29NuNrZnyHy9U25Wn8deu511nTdICcK5hoLltHBebjEkrJSqWySIYzNnC4pyD0hiF0f
         ovfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aIrpe3jK9YRA4TrJjFmGutaVzAkGlsrgPpN+cpGwvlE=;
        b=JpzabWb6ELRG5i7uLMO3jYpULLDJwdmUc6JYShAren/efbCztgehXWzW/lk7YVPgji
         2Kvj+C2Rp93O+cP9wP6BGQUMSPECtC7AaS++2YKXpY/WaHchm9WmVrkOcaHV/9lIeX4Y
         d9oQl2/XGjKeqaDDol93ZOY4Qz/hb5uAB7hb0rkYc+K285gs38P0Nr2jmsrtkPaTuktC
         ECaMSH7PkhiVP0UQx/303DmRnPQ6Vo02m8XASnJOtfqfMk7mK7cQSBEJkPGUIL4Of/ih
         TOzZ1vU9V/oAYZ7c7ZqPAPG8/ZE1SV2Qja2wFM02Q8sejl+h2V5wsos9sct9Bn139GPt
         uidg==
X-Gm-Message-State: APjAAAXmaqk/Bm3DzcSw2H+OKiaI8BQmnI2ZhkMVpVVgu5fHiuUrZYNv
        OwDpOZ4aP+8p9VmEhJ2Z6ARM/fkiFtNxPAN/YA0=
X-Google-Smtp-Source: APXvYqzrqBby/4QihDA4bR4mBRDMEwa1e6a9aGmRAeRoZ0SzSFPFc+gFsyDqX+5xrEFprPcz1oPx+yFvjsBMTUkkPr8=
X-Received: by 2002:adf:828f:: with SMTP id 15mr11142565wrc.17.1554541926911;
 Sat, 06 Apr 2019 02:12:06 -0700 (PDT)
MIME-Version: 1.0
References: <1554540030-12740-1-git-send-email-hofrat@osadl.org>
In-Reply-To: <1554540030-12740-1-git-send-email-hofrat@osadl.org>
From:   Julian Calaby <julian.calaby@gmail.com>
Date:   Sat, 6 Apr 2019 20:11:55 +1100
Message-ID: <CAGRGNgUy1Gva7AcwkjoGP0KmJrduDQAk1aMWP0XC89HXz48hKA@mail.gmail.com>
Subject: Re: [PATCH V2] staging: wilc1000: drop explicit conversion to bool
To:     Nicholas Mc Guire <hofrat@osadl.org>
Cc:     Adham Abozaeid <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Nicholas,

On Sat, Apr 6, 2019 at 7:48 PM Nicholas Mc Guire <hofrat@osadl.org> wrote:
>
> As the expression evaluates to a boolean anyway (relational and logical
> operators) conversion with the ternary operator is not needed here as
> coccinelle notes (boolconv.cocci)
>
> Signed-off-by: Nicholas Mc Guire <hofrat@osadl.org>
> ---
>
> V2: sent out the wrong version - the commit message was longer than 75
>     chars - only change here is the commit message wrapping.
>
> scripts/coccinelle/misc/boolconv.cocci warned about:
> drivers/staging/wilc1000/wilc_wlan.c:14:48-53: WARNING: conversion to bool not needed here
>
> Patch was compile tested with: x86_64_defconfig + Staging=y,
> WILC1000_SDIO=m, WILC1000_SPI=m, WILC1000=m
> (checkpatch, sparse and cocci clean otherwise)
>
> Patch is against 5.1-rc3 (localversion-next is -next-20190403)
>
>  drivers/staging/wilc1000/wilc_wlan.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
> index c238969..6c9fd3a 100644
> --- a/drivers/staging/wilc1000/wilc_wlan.c
> +++ b/drivers/staging/wilc1000/wilc_wlan.c
> @@ -11,7 +11,7 @@
>
>  static inline bool is_wilc1000(u32 id)
>  {
> -       return ((id & 0xfffff000) == 0x100000 ? true : false);
> +       return ((id & 0xfffff000) == 0x100000);

Whilst you're here, you might as well remove the superfluous parentheses.

Other than that,

Reviewed-by: Julian Calaby <julian.calaby@gmail.com>

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
