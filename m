Return-Path: <SRS0=pUCm=EG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F098C00A89
	for <linux-wireless@archiver.kernel.org>; Sat, 31 Oct 2020 02:47:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2CA7A2063A
	for <linux-wireless@archiver.kernel.org>; Sat, 31 Oct 2020 02:47:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="ILq/aDMI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725822AbgJaCrV (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 30 Oct 2020 22:47:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725536AbgJaCrV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 30 Oct 2020 22:47:21 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C1D6C0613D5
        for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2020 19:47:21 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id z1so3897482plo.12
        for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2020 19:47:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=e98FhQCbBFLStXhsPwRQARl8mlhgWix04TFsaLfXM94=;
        b=ILq/aDMIfhUW3zwy9UbPSoYCqiQqjgMdbje4fg6SEC0rpf2z8PiC1sjyDNKtRhTRqM
         2Dwj1Lpc/+IW4s1SVa/XTsDy9lJ/hAdH5l7sI7qZM2Nt2GqX129L39pbYasdS24mRl6F
         YLSAz47wM7YFkeb3c9Lyo/gClj2m0bocP5xI0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=e98FhQCbBFLStXhsPwRQARl8mlhgWix04TFsaLfXM94=;
        b=k6BbT/tFk78xJa/aK1Lhg/MiOt+9q1jFJhNcOSTXkobB6vHeHQAv2Prsfeb6fTTYUx
         CeJFtniTwmQrfQudY7Gbm/QKfifEP7nFFLwsiyHIgaqN8LjL5sLVVCKyJ1fv/rLHHW0J
         Qs79rx4q6UKNkHPBxnsLtKtpt7q+ccBBf+YIU/+/cl2c+noCuddFnhEZf67G3YyKEpg3
         5QyFwVywZdVyCf4Q/wSeecT6ae+WM5kt0e94Zld4mc8xc5EmsqPKN8I/0HxvUVvcUw/t
         aqNJ+cHcUTQjjcwjk50hGr3wMs/e4Ba6ruCW9WijH0huSW4/uQApGj1R3BdAT2xK4Ed+
         7Bgg==
X-Gm-Message-State: AOAM533aVRBRbUOCehNzQ/1c669/otYBiT2S012s6g2LO5jGH5b3fFX7
        KH3nkIrs6O8pqxt9wDD6XicGtQ==
X-Google-Smtp-Source: ABdhPJzpxiZ56yTdzo63V0FwL0O0Az/jHv4XaNs5YOuHPFqnwr7HaXvEKywaEVFJoqpC4d1UejjhiA==
X-Received: by 2002:a17:902:ba91:b029:d5:c5ce:9bab with SMTP id k17-20020a170902ba91b02900d5c5ce9babmr12005490pls.48.1604112440761;
        Fri, 30 Oct 2020 19:47:20 -0700 (PDT)
Received: from kuabhs-cdev.c.googlers.com.com (56.4.82.34.bc.googleusercontent.com. [34.82.4.56])
        by smtp.gmail.com with ESMTPSA id b2sm4711830pgg.2.2020.10.30.19.47.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2020 19:47:20 -0700 (PDT)
From:   Abhishek Kumar <kuabhs@chromium.org>
To:     kuabhs@chromium.org
Cc:     ath10k@lists.infradead.org, briannorris@chromium.org,
        cjhuang@codeaurora.org, dianders@chromium.org,
        johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Subject: Re: [RFC 1/2] nl80211: add common API to configure SAR power limitations.
Date:   Sat, 31 Oct 2020 02:46:31 +0000
Message-Id: <20201031024631.1528113-1-kuabhs@chromium.org>
X-Mailer: git-send-email 2.29.1.341.ge80a0c044ae-goog
In-Reply-To: <20201030205639.1452712-1-kuabhs@chromium.org>
References: <20201030205639.1452712-1-kuabhs@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=y
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: kuabhs@chromium.org

There are few more additional comments here.
> + * @NL80211_CMD_SET_SAR_SPECS: SAR power limitation configuration is
> + *     passed using %NL80211_ATTR_SAR_SPEC.
> + *

This command requires NL80211_ATTR_IFINDEX, probably should be better to add
this in the comment ?

> +static int
> +nl80211_put_sar_specs(struct cfg80211_registered_device *rdev,
> +                     struct sk_buff *msg)
> +{
> +       struct nlattr *sar_capa, *specs, *sub_freq_range;
> +       u8  num_freq_ranges;
> +       int i;
> +
> +       if (!rdev->wiphy.sar_capa)
> +               return 0;
> +
> +       num_freq_ranges = rdev->wiphy.sar_capa->num_freq_ranges;
> +
> +       sar_capa = nla_nest_start(msg, NL80211_ATTR_SAR_SPEC);
> +       if (!sar_capa)
> +               return -ENOSPC;

I see some places nla_nest_start_noflag being used and here nla_nest_start.
Whats the specific reason to do that ? In the newer Kernel versions, I believe
nla_nest_start is preferred.

> +               power = nla_get_u8(spec[NL80211_SAR_ATTR_SPECS_POWER]);
> +               sar_spec->sub_specs[specs].power = power;
> +
> +               /* if NL80211_SAR_ATTR_SPECS_FREQ_RANGE_INDEX isn't present,
> +                * then the power applies to all bands. But it's only valid
> +                * for the first entry.
> +                */
> +               if (!spec[NL80211_SAR_ATTR_SPECS_FREQ_RANGE_INDEX]) {
> +                       if (specs) {
> +                               err = -EINVAL;
> +                               goto error;
> +                       } else {
> +                               sar_spec->sub_specs[specs].freq_range_index =
> +                                       NL80211_SAR_ALL_FREQ_RNAGES;
> +                               specs++;
> +                               break;
> +                       }
> +               }

Here I see you are assigning same power to all freq band if for the first band
the freq index is not provided. Is there any specific reason to only check the first
here ? Probably this logic should move into specific drivers. Thoughts ?

-Abhishek
