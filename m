Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6208CC2D0E4
	for <linux-wireless@archiver.kernel.org>; Sat, 21 Nov 2020 00:26:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A73B22470
	for <linux-wireless@archiver.kernel.org>; Sat, 21 Nov 2020 00:26:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="GN1Usl6G"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728396AbgKUA0X (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 20 Nov 2020 19:26:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727943AbgKUA0W (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 20 Nov 2020 19:26:22 -0500
Received: from mail-vs1-xe43.google.com (mail-vs1-xe43.google.com [IPv6:2607:f8b0:4864:20::e43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 196A2C0613CF
        for <linux-wireless@vger.kernel.org>; Fri, 20 Nov 2020 16:26:21 -0800 (PST)
Received: by mail-vs1-xe43.google.com with SMTP id h185so6002914vsc.3
        for <linux-wireless@vger.kernel.org>; Fri, 20 Nov 2020 16:26:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CfMFlb3xymW8Ob4Z/F1bajpHVWYJZBqq9wH84ITKZlk=;
        b=GN1Usl6Gul1bW6FR8bPdtuR5b5vB8THabPBgrpNn+sudE+rfp39Ozbxau2J40mGbNa
         hBUfDbIsEjnRtOc4G8+zCxPdvZhP3ARgjvotfwQqM1Ah0RfrJqenlfngel4Jd+WV9JWQ
         JZ+ucyD1hv6a9JulKb05IJRnT8NWQ2lsA2MvY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CfMFlb3xymW8Ob4Z/F1bajpHVWYJZBqq9wH84ITKZlk=;
        b=X4GO2NVUKL/Xkf5Lk4betL0+cDAbyHTBpqy4KCRFzZNluOkY52QEre42rgwgq++2qw
         sby2MaAvg6R54HhPAiLtf/DYhkpbqZAQeRxklx4W0uuSv0z8X5gowlhR0BH7MxZF9lmF
         oMSlfs01x3Xogntx2mNKMpBTjbC0PDWW/YyETo0YY+4dMv9WqSU5oMDqphQ3Fky+xtjY
         eadcAZjTEVVuQozzucTKReWSkd2+1HY9l1XbT1LaW6zfnl0uMH5fG37bh9xeZrJHEQqj
         eSpShiGO5GicseB2VCFGtgyrpSRMwC+SS3zk05UVAu/vrx/mnpqm2Wz4g4SD3udgbqIV
         r7Zw==
X-Gm-Message-State: AOAM532phLNPnSSjceDQZYjT+Faux9RrfEg7qd4wxXk6p+tuflbHGPEX
        PMiEvKNShnQDsaIbSWyUsco3wCh2kvBrMQ==
X-Google-Smtp-Source: ABdhPJwK3bQDGaZ76XJANKMxoOu+45or71m8+Ys5mRR03NIjBPdC8Vwyurc+h7Dl9rU1FKzp0WyDkg==
X-Received: by 2002:a67:2ac1:: with SMTP id q184mr14681192vsq.57.1605918380055;
        Fri, 20 Nov 2020 16:26:20 -0800 (PST)
Received: from mail-vk1-f176.google.com (mail-vk1-f176.google.com. [209.85.221.176])
        by smtp.gmail.com with ESMTPSA id 70sm453128uaj.1.2020.11.20.16.26.19
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Nov 2020 16:26:19 -0800 (PST)
Received: by mail-vk1-f176.google.com with SMTP id w67so2631178vke.10
        for <linux-wireless@vger.kernel.org>; Fri, 20 Nov 2020 16:26:19 -0800 (PST)
X-Received: by 2002:ac5:cd58:: with SMTP id n24mr15307827vkm.17.1605918378764;
 Fri, 20 Nov 2020 16:26:18 -0800 (PST)
MIME-Version: 1.0
References: <1605501291-23040-1-git-send-email-pillair@codeaurora.org>
In-Reply-To: <1605501291-23040-1-git-send-email-pillair@codeaurora.org>
From:   Doug Anderson <dianders@chromium.org>
Date:   Fri, 20 Nov 2020 16:26:07 -0800
X-Gmail-Original-Message-ID: <CAD=FV=Xnk-VeZKy3vzr4VZNW+OogfwEAjU-QVHQRYD-yix8LPQ@mail.gmail.com>
Message-ID: <CAD=FV=Xnk-VeZKy3vzr4VZNW+OogfwEAjU-QVHQRYD-yix8LPQ@mail.gmail.com>
Subject: Re: [PATCH v3] ath10k: Fix the parsing error in service available event
To:     Rakesh Pillai <pillair@codeaurora.org>
Cc:     ath10k <ath10k@lists.infradead.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Abhishek Kumar <kuabhs@chromium.org>,
        Brian Norris <briannorris@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

On Sun, Nov 15, 2020 at 8:35 PM Rakesh Pillai <pillair@codeaurora.org> wrote:
>
> The wmi service available event has been
> extended to contain extra 128 bit for new services
> to be indicated by firmware.
>
> Currently the presence of any optional TLVs in
> the wmi service available event leads to a parsing
> error with the below error message:
> ath10k_snoc 18800000.wifi: failed to parse svc_avail tlv: -71
>
> The wmi service available event parsing should
> not return error for the newly added optional TLV.
> Fix this parsing for service available event message.
>
> Tested-on: WCN3990 hw1.0 SNOC WLAN.HL.3.2.2-00720-QCAHLSWMTPL-1
>
> Fixes: cea19a6ce8bf ("ath10k: add WMI_SERVICE_AVAILABLE_EVENT support")
> Signed-off-by: Rakesh Pillai <pillair@codeaurora.org>
> ---
> Changes from v2:
> - Add code documentation explaining the necessity of variable
>   initialization for the logic to work.
> ---
>  drivers/net/wireless/ath/ath10k/wmi-tlv.c | 4 +++-
>  drivers/net/wireless/ath/ath10k/wmi.c     | 9 +++++++--
>  drivers/net/wireless/ath/ath10k/wmi.h     | 1 +
>  3 files changed, 11 insertions(+), 3 deletions(-)

This looks nice to me now.  I will let Kalle decide what to do about
the checkpatch issue that Abhishek found (ignore, fix himself, or
request another spin).

Reviewed-by: Douglas Anderson <dianders@chromium.org>
