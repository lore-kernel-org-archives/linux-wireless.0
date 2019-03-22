Return-Path: <SRS0=qAgV=RZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B78C1C10F03
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Mar 2019 14:16:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 91423218E2
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Mar 2019 14:16:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727988AbfCVOQZ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Mar 2019 10:16:25 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:34884 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727719AbfCVOQZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Mar 2019 10:16:25 -0400
Received: by mail-qk1-f196.google.com with SMTP id z13so1298673qki.2;
        Fri, 22 Mar 2019 07:16:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kPZ0I7dSeGGKOKCao/BNvdtgasGpQu8Zb0CtoFpKTLg=;
        b=o7chK2UcOT1UN0zUM0QEWOm/heNkNt+PdP3qhgHCfsdc6kZ77DbW8YweVr0swWiLLp
         fBiXpm/2oZvpuVM0C0ng8baY3eU9Wju85IzXmdDuoCEuVS0WalhxlId6rRFALZ2YJKJD
         3IX7eO0XAiUw042G/GiaRWt1CgHhNDZZ3fiqQb0N9KXemhgWw0j0aL0EEmC5Rgeki4N2
         ELRoQhjTPlEbLnj3Dg2lHOWZk9EBpz5lDCTCiyvzWs/UxpEwG9Nm/KqS3Qkl+MTSBR1v
         0VcNom9DMo7Jdhj1o4ESU6YnxmJN1RO+BoaowE6LI6dnahC2ttngNAL/3pELq/RLvD1v
         /AEg==
X-Gm-Message-State: APjAAAXFtRgBPSj27iWnRgOvK5VY27BkILAC/Bw1T4SYkgHpDzMLIJHQ
        X7w53dMyqNyd+X/nlgG6P8LaGoL5XXPGfJeBI1w=
X-Google-Smtp-Source: APXvYqwH02sqfVWXGx8C2+9pCJoyBkSKx2eHV3HDzQhDtoFp7ctejChFNj3RrwvzMG9nV70rq5V2JzilEYXG9kbePJ0=
X-Received: by 2002:a05:620a:133b:: with SMTP id p27mr7680631qkj.173.1553264184275;
 Fri, 22 Mar 2019 07:16:24 -0700 (PDT)
MIME-Version: 1.0
References: <20190307235735.31487-1-natechancellor@gmail.com>
In-Reply-To: <20190307235735.31487-1-natechancellor@gmail.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Fri, 22 Mar 2019 15:16:06 +0100
Message-ID: <CAK8P3a1vsJ9qUg_p0UN_xSmYupApY++J8ZP2frmYR7Ja3Hc4iQ@mail.gmail.com>
Subject: Re: [PATCH] cfg80211: Change an 'else if' into an 'else' in cfg80211_calculate_bitrate_he
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        clang-built-linux@googlegroups.com,
        Nick Desaulniers <ndesaulniers@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, Mar 8, 2019 at 12:57 AM Nathan Chancellor
<natechancellor@gmail.com> wrote:
>
> When building with -Wsometimes-uninitialized, Clang warns:
>
> net/wireless/util.c:1223:11: warning: variable 'result' is used
> uninitialized whenever 'if' condition is false
> [-Wsometimes-uninitialized]
>
> Clang can't evaluate at this point that WARN(1, ...) always returns true
> because __ret_warn_on is defined as !!(condition), which isn't
> immediately evaluated as 1. Change this branch to else so that it's
> clear to Clang that we intend to bail out here.
>
> Link: https://github.com/ClangBuiltLinux/linux/issues/382
> Suggested-by: Nick Desaulniers <ndesaulniers@google.com>
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> ---
>  net/wireless/util.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/net/wireless/util.c b/net/wireless/util.c
> index e4b8db5e81ec..75899b62bdc9 100644
> --- a/net/wireless/util.c
> +++ b/net/wireless/util.c
> @@ -1220,9 +1220,11 @@ static u32 cfg80211_calculate_bitrate_he(struct rate_info *rate)
>         else if (rate->bw == RATE_INFO_BW_HE_RU &&
>                  rate->he_ru_alloc == NL80211_RATE_INFO_HE_RU_ALLOC_26)
>                 result = rates_26[rate->he_gi];
> -       else if (WARN(1, "invalid HE MCS: bw:%d, ru:%d\n",
> -                     rate->bw, rate->he_ru_alloc))
> +       else {
> +               WARN(1, "invalid HE MCS: bw:%d, ru:%d\n",
> +                    rate->bw, rate->he_ru_alloc);
>                 return 0;
> +       }

Reviewed-by: Arnd Bergmann <arnd@arndb.de>

I independently came up with the same fix before I saw yours,
the only difference was that I avoided the extra curly braces
using

+       else
+               return !WARN(1, "invalid HE MCS: bw:%d, ru:%d\n",
+                            rate->bw, rate->he_ru_alloc);

to avoid the mix of bare if() and if() {}

      Arnd
