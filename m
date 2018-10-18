Return-Path: <SRS0=Zpd3=M6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85CE2C5ACCC
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Oct 2018 18:14:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4E2FE204FD
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Oct 2018 18:14:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="WZOKI3HI"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4E2FE204FD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728683AbeJSB6t (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 18 Oct 2018 21:58:49 -0400
Received: from mail-vs1-f65.google.com ([209.85.217.65]:42239 "EHLO
        mail-vs1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728406AbeJSB6t (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 Oct 2018 21:58:49 -0400
Received: by mail-vs1-f65.google.com with SMTP id e126so23651019vsc.9
        for <linux-wireless@vger.kernel.org>; Thu, 18 Oct 2018 10:56:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ChYX7KbjKBP047D/DbX+uKfb91MeojRQBXgtEq5xQ18=;
        b=WZOKI3HIj+vNAs7PmChGpqA6asehB+XRuM8k9wCZSqBBXiwQInv5tG9TiN6VhVHCsw
         AZUMPuiRz2E8+G11Jp0phxSmGGc49o5j+aViBDVzlXNy+OnLQqwuSZXbqMsRLdCZgB1N
         dtFjHTbN6yoebEGmXpe8IdI8Tm4onCtds77xc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ChYX7KbjKBP047D/DbX+uKfb91MeojRQBXgtEq5xQ18=;
        b=cuPl+EBDrurnqDs/flMZBS3kyg9/fo0P3zF+Ci58guFhxYIl3u5b5gaBtzE0S87vPy
         OQXKSpSqIkNLj/7/fnTsx3gSjDSyd/JZbSB7bH2lFpXDrkSow/OeWoXzUAxPToL6DAEz
         SOQMwKe31VZvdWhuUGVx4bnj03UZSb+d+Gi26els5ejsuKbMZFEDwnL16Lk8IJksAMgb
         RNeTkh/sba1ezS+/U9/0IwxgBWJ4vTqAErXq1bqQbzHVaF1sb6EBMrrNeHTtWjs0AnIc
         27ZZii00BFZU2tg5Ch5dATlpkpyWYg88wVStfQ+qckGknAJHUzJdKBHD1wSblX6B3l9b
         QYCw==
X-Gm-Message-State: ABuFfohhXimLfB7/zmuQVthL0eKX/4glMjCb1SL0ZLJ0R5zxZ6H3gftH
        FPDmXAH57SI2JqWTM7icSuFw1H2t2J8=
X-Google-Smtp-Source: ACcGV60fYcXJVcbw5x/8GnZTAVLbyOs1jc6B6BXOphs21Whqmb+qkYyqRe6/OUC58Inujok/n1kMEA==
X-Received: by 2002:a67:c39d:: with SMTP id s29mr692291vsj.143.1539885403758;
        Thu, 18 Oct 2018 10:56:43 -0700 (PDT)
Received: from mail-ua1-f47.google.com (mail-ua1-f47.google.com. [209.85.222.47])
        by smtp.gmail.com with ESMTPSA id c189-v6sm6230164vka.22.2018.10.18.10.56.42
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Oct 2018 10:56:42 -0700 (PDT)
Received: by mail-ua1-f47.google.com with SMTP id j13so6493843ual.0
        for <linux-wireless@vger.kernel.org>; Thu, 18 Oct 2018 10:56:42 -0700 (PDT)
X-Received: by 2002:ab0:150:: with SMTP id 74mr14096666uak.83.1539885401702;
 Thu, 18 Oct 2018 10:56:41 -0700 (PDT)
MIME-Version: 1.0
References: <20181013005504.46399-1-briannorris@chromium.org> <20181013005504.46399-3-briannorris@chromium.org>
In-Reply-To: <20181013005504.46399-3-briannorris@chromium.org>
From:   Doug Anderson <dianders@chromium.org>
Date:   Thu, 18 Oct 2018 10:56:30 -0700
X-Gmail-Original-Message-ID: <CAD=FV=VvaNTqEEC8XuOZ4ekNtPaj-KO3WdENQ6evweMjp8yoew@mail.gmail.com>
Message-ID: <CAD=FV=VvaNTqEEC8XuOZ4ekNtPaj-KO3WdENQ6evweMjp8yoew@mail.gmail.com>
Subject: Re: [PATCH 3/4] ath10k: snoc: relax voltage requirements
To:     Brian Norris <briannorris@chromium.org>
Cc:     kvalo@qca.qualcomm.com, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org,
        Govind Singh <govinds@codeaurora.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,
On Fri, Oct 12, 2018 at 5:55 PM Brian Norris <briannorris@chromium.org> wrote:
>
> I rarely see drivers specify precise voltage requirements like this, but
> if we really have to...let's at least give a little wiggle room. Board
> designs (and accompanying device trees) may not provide exactly the
> voltage listed here, and we shouldn't fail to probe just because of
> this.
>
> Round these ranges down to the nearest volt, and provide a 0.05V margin.
> The regulator should provide its own supported ranges, which will
> helpfully intersect with these ranges.
>
> I would just as well remove these ranges entirely, but if I understand
> correctly, there's some reason that QCOM SoC's like to set zero /
> non-zero voltages.

Yeah, I'll try to up-prioritize working on making that better
(assuming others like my ideas in that area).


> Signed-off-by: Brian Norris <briannorris@chromium.org>
> ---
>  drivers/net/wireless/ath/ath10k/snoc.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath10k/snoc.c b/drivers/net/wireless/ath/ath10k/snoc.c
> index b63ae8b006b4..5a8e87339df2 100644
> --- a/drivers/net/wireless/ath/ath10k/snoc.c
> +++ b/drivers/net/wireless/ath/ath10k/snoc.c
> @@ -47,10 +47,10 @@ static char *const ce_name[] = {
>  };
>
>  static struct ath10k_vreg_info vreg_cfg[] = {
> -       {NULL, "vdd-0.8-cx-mx", 800000, 800000, 0, 0, false},
> -       {NULL, "vdd-1.8-xo", 1800000, 1800000, 0, 0, false},
> -       {NULL, "vdd-1.3-rfa", 1304000, 1304000, 0, 0, false},
> -       {NULL, "vdd-3.3-ch0", 3312000, 3312000, 0, 0, false},
> +       {NULL, "vdd-0.8-cx-mx", 800000, 850000, 0, 0, false},
> +       {NULL, "vdd-1.8-xo", 1800000, 1850000, 0, 0, false},
> +       {NULL, "vdd-1.3-rfa", 1300000, 1350000, 0, 0, false},
> +       {NULL, "vdd-3.3-ch0", 3300000, 3350000, 0, 0, false},

These look fine to me.  I find it really funny that this array has all
those load values and they're all 0, but that's not new to your patch.

Reviewed-by: Douglas Anderson <dianders@chromium.org>
