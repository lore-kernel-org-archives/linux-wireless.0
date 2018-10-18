Return-Path: <SRS0=Zpd3=M6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 952FBECDE43
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Oct 2018 17:54:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5D450204FD
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Oct 2018 17:54:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="eletsFXf"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5D450204FD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727188AbeJSB46 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 18 Oct 2018 21:56:58 -0400
Received: from mail-vk1-f195.google.com ([209.85.221.195]:37889 "EHLO
        mail-vk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726463AbeJSB45 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 Oct 2018 21:56:57 -0400
Received: by mail-vk1-f195.google.com with SMTP id w123so2227977vkh.5
        for <linux-wireless@vger.kernel.org>; Thu, 18 Oct 2018 10:54:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iaBvYQ5J1frnGMFcPK3mz41HT4cWn1XQODE5HjSX4ds=;
        b=eletsFXfU1MVK70TQOkD8aIhe5kjfL0JUp4RC/R0fejuNcwxJEs6uPxBbvsuG0mN48
         JLvpDksy3I+AoPW2XnRBvYOTtslmRPodoUpkA6sreYE3AmSeyRkYuTBZFL444gL/L6g6
         2zVGyL0CsN+trZxmAXs/5hMgeMTNMuQwvlekk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iaBvYQ5J1frnGMFcPK3mz41HT4cWn1XQODE5HjSX4ds=;
        b=r0LiQXowticErnncmS2MXieP1zs4FPAO5w23XFTsU52PnP6bFvYSQFN1d/UO5Xm27j
         5fQJr35UYBBLrIy/sPJd7H2Vp10xdvDGPVPtbO+ytDyGDQVHmNH0rJQG0MLpXJpIahYf
         Vi58xZAU2PekeTbK8Pc4/bnPTOS9ifGKPvTNHtbQjZ2MOGKbUxR72enYkPU2t1xjmvUd
         Zlz1dJ+A9yBBSEwyGIYX9jsPoWXnOOl8mErNvXuOueVJ8YDOiZyDS4a+qec/oJB1rUir
         xbkEW5vO4+Sc5xxfeTtytzwLfXPBZUf9EloTkdIo0MaRZtnFQFCCkN6X5w5a4xzTAJp0
         tvWQ==
X-Gm-Message-State: ABuFfoipLCcXeZiLJ0BI8t59fYWAx2JqAUly/nYBNW/BlEdMh80P+pg9
        ZTf7c+r44wFdP1trhApsUXF0Uf///Go=
X-Google-Smtp-Source: ACcGV60FC44eRX2mM7vXaq2nEoMva+yeop/76/2OSf9KoXCi6UR8X1Oy/LTXQCtSrX1KO9VKwzUGmQ==
X-Received: by 2002:a1f:34c8:: with SMTP id b191mr11912551vka.52.1539885292700;
        Thu, 18 Oct 2018 10:54:52 -0700 (PDT)
Received: from mail-ua1-f45.google.com (mail-ua1-f45.google.com. [209.85.222.45])
        by smtp.gmail.com with ESMTPSA id d189-v6sm3967470vsc.8.2018.10.18.10.54.51
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Oct 2018 10:54:51 -0700 (PDT)
Received: by mail-ua1-f45.google.com with SMTP id z8so6486813uap.13
        for <linux-wireless@vger.kernel.org>; Thu, 18 Oct 2018 10:54:51 -0700 (PDT)
X-Received: by 2002:a9f:344d:: with SMTP id s13mr13387364uab.27.1539885291166;
 Thu, 18 Oct 2018 10:54:51 -0700 (PDT)
MIME-Version: 1.0
References: <20181013005504.46399-1-briannorris@chromium.org> <20181013005504.46399-2-briannorris@chromium.org>
In-Reply-To: <20181013005504.46399-2-briannorris@chromium.org>
From:   Doug Anderson <dianders@chromium.org>
Date:   Thu, 18 Oct 2018 10:54:39 -0700
X-Gmail-Original-Message-ID: <CAD=FV=U0uK25mL9_d1nVB7uBV+vR9YTqGm1iTQgzdNuZO5O5_A@mail.gmail.com>
Message-ID: <CAD=FV=U0uK25mL9_d1nVB7uBV+vR9YTqGm1iTQgzdNuZO5O5_A@mail.gmail.com>
Subject: Re: [PATCH 2/4] ath10k: snoc: fix unabalanced regulator error handling
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
> +       if (vreg_info->settle_delay)
> +               udelay(vreg_info->settle_delay);

Not new to your patch, but this seems like a duplication of what the
regulator framework is doing for you.  There are plenty of regulator
properties describing lots of different types delays and that would be
the place to put it.  Doing so makes it automatically easy for boards
to specify a different delay if they have different ramp
characteristics (like someone put a bigger capacitor on the line or
somesuch).

At the moment it would be easy for someone to submit a patch to kill
the settle delay in this driver this since the entire vreg_cfg table
has 0 for the settle delay.


> +static int __ath10k_snoc_vreg_off(struct ath10k *ar,
> +                                 struct ath10k_vreg_info *vreg_info)
> +{
> +       int ret;
> +
> +       ath10k_dbg(ar, ATH10K_DBG_SNOC, "snoc regulator %s being disabled\n",
> +                  vreg_info->name);
> +
> +       ret = regulator_disable(vreg_info->reg);
> +       if (ret)
> +               ath10k_err(ar, "failed to disable regulator %s\n",
> +                          vreg_info->name);
> +
> +       ret = regulator_set_load(vreg_info->reg, 0);
> +       if (ret < 0)
> +               ath10k_err(ar, "failed to set load %s\n", vreg_info->name);
> +
> +       ret = regulator_set_voltage(vreg_info->reg, 0, vreg_info->max_v);
> +       if (ret)
> +               ath10k_err(ar, "failed to set voltage %s\n", vreg_info->name);

Not new to your patch, but ick, forcing someone to manually set the
load / voltage of a regulator that they've turned off is silly.  It's
only list to try to send a patch to remedy this situation.  Let me try
to put that higher on my plate.


...just like with the clock patch I suspect that some of this is
duplicating the "regulator_bulk" APIs.  ...though I guess maybe we
can't use those too easily until we can avoid setting voltage and
current so much...  In any case, your patch overall looks good and an
improvement.


Reviewed-by: Douglas Anderson <dianders@chromium.org>
