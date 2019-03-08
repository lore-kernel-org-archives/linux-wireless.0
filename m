Return-Path: <SRS0=wltO=RL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 512B3C43381
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Mar 2019 00:11:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 20CE42054F
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Mar 2019 00:11:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rrEh/Kz/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726328AbfCHAKx (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 7 Mar 2019 19:10:53 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:45132 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726172AbfCHAKx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Mar 2019 19:10:53 -0500
Received: by mail-pf1-f194.google.com with SMTP id v21so12714381pfm.12
        for <linux-wireless@vger.kernel.org>; Thu, 07 Mar 2019 16:10:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FPWrQ1cSPMenIAj108hM5wihwBVvhY7nmepw5K/L790=;
        b=rrEh/Kz/UkCKlwKoFikz58ADbzrpl6uII1IkLRBtSgs+fMTCX19lkMhDpRdwisIdcT
         2hyzfRVN1ndSN+K+kVjWsYMXNeeE3n3XoXrMJMEHlYw/aVi5/4cyzrKBUE1H89icFAb7
         cyRkqn+/jGJk0YS/ff94hjMCXRmmmHh5PqOjjfihTYHcllBshYeOkqq5KwMZS9gmO/46
         CCgSLy/pkXULfqAOcF9xaCY3I0n1epfxQg0qvSj5k9EHOz3tNroBFZrzRYyUsq8oH6fH
         O70/8IEJNH5oLtZgKykqj9fdPAhisEI9XFftFE9ejNuehLigIKzO+IEi5sL+9TVIEua+
         Y5tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FPWrQ1cSPMenIAj108hM5wihwBVvhY7nmepw5K/L790=;
        b=JugPFmI9fW4sCe+bjhlPBVv2t/AshbmYvyhwmgbwpzr44cIGQn67qhpPfOSm1BXb3P
         +SZogSMtqkc1SHa5/ceW2SFKCFbDr/5L1lOvnMELfxM6GmdrSuWkX6xvZBendxz+f09L
         FLTQSNM3qDSCwQbTV0PsX7Dy6cGMdI2rN7Jn+tIO6YvKdxrtab4rW8vWxMUKc6vZM2wh
         VO8Kko6pcokrmWX9ubO7w+1YFcQVrCD49qLXPVhfVQbxQ/5VqYc8lRSJ2kZ5hZ7CRtRY
         C2yoRyy+i9mW98p0mpMF5y+HEP26D6Cl9hTS0Vn+IKgzrq+BJZpin/pmzqASlkhHyLlT
         6Ahw==
X-Gm-Message-State: APjAAAWywFl3uOR/KgsJdbcfEuZip5Vy6DdhSRSdhafG1/g6AuN3oACl
        h8udwVZ2NBgVDx6VlhMNx4iRKSCMdSM0eIdRCmPko2esock=
X-Google-Smtp-Source: APXvYqwClCVQPtzQu8hgy2ct8axlYfAuq/rk5+P0Xz8rHY9dMhDfaL0yJcOkkRNNa4M57LG6PXIwZb1rXMmGmS0aF5g=
X-Received: by 2002:a17:902:380c:: with SMTP id l12mr4033884plc.238.1552003852417;
 Thu, 07 Mar 2019 16:10:52 -0800 (PST)
MIME-Version: 1.0
References: <20190307235735.31487-1-natechancellor@gmail.com>
In-Reply-To: <20190307235735.31487-1-natechancellor@gmail.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Thu, 7 Mar 2019 16:10:41 -0800
Message-ID: <CAKwvOdmX64a+aaSKU=FmnMSKnu0WiEezHds0OL9PMnEHe-OrJw@mail.gmail.com>
Subject: Re: [PATCH] cfg80211: Change an 'else if' into an 'else' in cfg80211_calculate_bitrate_he
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        clang-built-linux@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, Mar 7, 2019 at 3:57 PM Nathan Chancellor
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

Thanks for the quick fix!
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>

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
>
>         /* now scale to the appropriate MCS */
>         tmp = result;
> --
> 2.21.0
>


-- 
Thanks,
~Nick Desaulniers
