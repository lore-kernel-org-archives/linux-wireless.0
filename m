Return-Path: <SRS0=CI53=33=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E6D0C35247
	for <linux-wireless@archiver.kernel.org>; Fri,  7 Feb 2020 02:11:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3EE1F222D9
	for <linux-wireless@archiver.kernel.org>; Fri,  7 Feb 2020 02:11:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=endlessm-com.20150623.gappssmtp.com header.i=@endlessm-com.20150623.gappssmtp.com header.b="osEHepPh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727512AbgBGCLS (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 6 Feb 2020 21:11:18 -0500
Received: from mail-ot1-f66.google.com ([209.85.210.66]:45707 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727028AbgBGCLS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Feb 2020 21:11:18 -0500
Received: by mail-ot1-f66.google.com with SMTP id 59so660774otp.12
        for <linux-wireless@vger.kernel.org>; Thu, 06 Feb 2020 18:11:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=endlessm-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GWc7Ijn6yHG/2KgjgfrGjVuqZdUeAuHimZKaD1xcjgA=;
        b=osEHepPh3mVNSEYrrEd5xYSh7kAlTn3tjhRZ9OoEYMbMjm+g/LUzJnaKqJCqD7L1Mq
         lTBh+yLS4yhmL4Fn49c4RM2Y9ea9O5kapLQsaDoc/EQ8YpPERESZf4nAvaawscnnJEUM
         xpH+umK+5wXgMBtAvVTbWSd5MyZudhqUGLfhHnyKnPU4TgsnfvwWJebz1Wo/EQ+QkqCU
         PTpBT4NvADmRcTtuS9pxYonbeN+KKv3NZQXLhuOwP2iC76eY5aHc4uQswp9kFfsDWoJV
         mlP83+yp0QEShNz/bIH4XtagoBePELe54O8LJmdxTE46HjEGyiCk29YYkm8c00hcwgfZ
         mIJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GWc7Ijn6yHG/2KgjgfrGjVuqZdUeAuHimZKaD1xcjgA=;
        b=IfYqobal126yinxdgUW6tt/NYyXlHPwgO3Nr3LdVI81R2EvJ3++R6HBQuQH/Ogmp/B
         Dhlz76iQ5ErNeBMKeYvkgmYs4MWnAv9oGU97pi6AyiBCgpTzOYCNa8pYcKLC67CVlDVU
         RGUHRPGE54TZe6KUCvlSMXauELvggAz/KWJCsjMd8jBmUoPbOW5iEuXZq363BRqRFKV/
         0zIj/+kkDTTcliiRF4u69DGHjchql+JBqv+FaDF6svHuw0aB6Pqqlro6sF+B2YEv3GEF
         rjEB9/SENG+eWLGmy3beHRxr4xs4brNHPT1fyadYOUlQM5HYp4gg6A4/JcJH82bHGxuW
         OnDA==
X-Gm-Message-State: APjAAAUd/CCFhUA9X+QE+jXv5IASCyYOlbMBZexGM5khTabgQBAUoH7M
        Vcjq38J+BYrXXWpTKP2RZV1aTlTSgPIUVTSbwND4fw==
X-Google-Smtp-Source: APXvYqzY1NQd2nFxJ3rFX0KM9A/8Rjz0gRHdmL98amPSfjzfUMTUIo/Hac7rOCKU3xAr2AtdFMeiEMKEI3VdzfzknBs=
X-Received: by 2002:a9d:774e:: with SMTP id t14mr898875otl.358.1581041477467;
 Thu, 06 Feb 2020 18:11:17 -0800 (PST)
MIME-Version: 1.0
References: <20200206032801.25835-1-yhchuang@realtek.com>
In-Reply-To: <20200206032801.25835-1-yhchuang@realtek.com>
From:   Chris Chiu <chiu@endlessm.com>
Date:   Fri, 7 Feb 2020 10:11:06 +0800
Message-ID: <CAB4CAwe_uiCitczp2KYQ-H5gAVE_fPGr8GzRqnKAoXSxVw9meQ@mail.gmail.com>
Subject: Re: [PATCH v2] rtw88: Fix incorrect beamformee role setting
To:     Tony Chuang <yhchuang@realtek.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Brian Norris <briannorris@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, Feb 6, 2020 at 11:28 AM <yhchuang@realtek.com> wrote:
>
> From: Tzu-En Huang <tehuang@realtek.com>
>
> In associating and configuring beamformee, bfee->role is not
> correctly set before rtw_chip_ops::config_bfee().
> Fix it by setting it correctly.
>
> Fixes: 0bd9557341b7 ("rtw88: Enable 802.11ac beamformee support")
> Signed-off-by: Tzu-En Huang <tehuang@realtek.com>
> Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
> ---
>
> v1 -> v2
>   * cannot put bfee->role = RTW_BFEE_NONE after out_unlock
>     put it enclosed by else
>
>  drivers/net/wireless/realtek/rtw88/bf.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/wireless/realtek/rtw88/bf.c b/drivers/net/wireless/realtek/rtw88/bf.c
> index fda771d23f71..073c754e9e70 100644
> --- a/drivers/net/wireless/realtek/rtw88/bf.c
> +++ b/drivers/net/wireless/realtek/rtw88/bf.c
> @@ -99,10 +98,11 @@ void rtw_bf_assoc(struct rtw_dev *rtwdev, struct ieee80211_vif *vif,
>                 }
>
>                 chip->ops->config_bfee(rtwdev, rtwvif, bfee, true);
> +       } else {
> +               bfee->role = RTW_BFEE_NONE;
>         }
>

Do we really need this `else` section? The bfee->role is only for
`config_bfee`, right? If we don't
need to config_bfee for RTW_BFEE_NONE, then we don't need the `else` part.

Chris

>  out_unlock:
> -       bfee->role = bfee_role;
>         rcu_read_unlock();
>  }
>
> --
> 2.17.1
>
