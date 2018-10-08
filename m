Return-Path: <SRS0=RoeA=MU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A502DC677D4
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 19:45:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5B3492089D
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 19:45:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="eGQvzMza"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5B3492089D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726439AbeJIC6w (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Oct 2018 22:58:52 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:41217 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726636AbeJIC6w (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Oct 2018 22:58:52 -0400
Received: by mail-ed1-f66.google.com with SMTP id x31-v6so3917141edd.8
        for <linux-wireless@vger.kernel.org>; Mon, 08 Oct 2018 12:45:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=22eRZDpajz4KY1r350/m5G2dhrMfA1tey5st3B7X0IA=;
        b=eGQvzMza9eJGbOOVZX3xSWLUhdVAa5aBOprJw1/1gkXkEAkjFe1v0z7l0teT5bJxpB
         tqm9hO+Hi4vygT64+NMknkrU9FeBKhd7GAHTLMqjiTG9ST/5+Rd4D2rhrA3RNceeRRto
         3lyd+0uRqY3ns4CQaBTpVXZmUy7+JBga+lwVo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=22eRZDpajz4KY1r350/m5G2dhrMfA1tey5st3B7X0IA=;
        b=j0EOIiuA9o5kZBjDw08BOho6bqs6iNHS+AabbW+xl66yl6GpFSVmvK9cxqoqi6q55U
         HfmGsRS4ZGq8GWvRqRaIci3B3fnv+xzj1dEiGepyApkkqke0k52b1yXrflPbS+guNSZM
         g28/9rXoqkYKaG/EHmmG6R4ND7oYp0DIKuHTbcCXJPTmvEsThussBnoyMjfdWki95KOG
         mAMEfgFu1sP4d8a3mXWEnrDV1MNhLgs47wwzYhHKLcwacs3zbcFeD1emR4yjCKyGGZrK
         Ji4tNEgLDe7KU9qv7MXsm8tNHr/xjD+tXMkkzsrPlg2LyElk9y5Dtv4OS377zBjl9Z6Q
         ljwg==
X-Gm-Message-State: ABuFfohkOpP6G9o0m+eVbAkOhEYmSmGtfIzAb7SBJ4i6kyRlUg4Y+nTK
        /Zr/hdTW2wlZVzE+esKcmjOlEY4u51c=
X-Google-Smtp-Source: ACcGV61b5tAgUHUDCIqAlrFKwDhqTlA2Abi3wZF+n6P0QbwMuynav6z2xu86yLxfD6lXhxCuT5aEuQ==
X-Received: by 2002:a50:b64f:: with SMTP id c15-v6mr9014276ede.288.1539027928521;
        Mon, 08 Oct 2018 12:45:28 -0700 (PDT)
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com. [209.85.208.44])
        by smtp.gmail.com with ESMTPSA id f22-v6sm3862227eda.9.2018.10.08.12.45.26
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Oct 2018 12:45:27 -0700 (PDT)
Received: by mail-ed1-f44.google.com with SMTP id z21-v6so14220115edb.11
        for <linux-wireless@vger.kernel.org>; Mon, 08 Oct 2018 12:45:26 -0700 (PDT)
X-Received: by 2002:a50:998a:: with SMTP id m10-v6mr31580276edb.7.1539027926014;
 Mon, 08 Oct 2018 12:45:26 -0700 (PDT)
MIME-Version: 1.0
References: <20181001112636.31715-1-govinds@codeaurora.org>
In-Reply-To: <20181001112636.31715-1-govinds@codeaurora.org>
From:   Brian Norris <briannorris@chromium.org>
Date:   Mon, 8 Oct 2018 12:45:14 -0700
X-Gmail-Original-Message-ID: <CA+ASDXNvGG34eSsupr95p-O-CUUui2bU63LUjn6cbKiXwKhTYw@mail.gmail.com>
Message-ID: <CA+ASDXNvGG34eSsupr95p-O-CUUui2bU63LUjn6cbKiXwKhTYw@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] Enable ath10k wcn3990 wifi driver support on sdm845
To:     govinds@codeaurora.org
Cc:     Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        andy.gross@linaro.org, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-soc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

+ linux-arm-msm, linux-soc

The MSM list should definitely be included for updates to Qualcomm DTS
files. Probably linux-soc too, if I'm reading MAINTAINERS correctly.

Brian

On Mon, Oct 1, 2018 at 4:26 AM Govind Singh <govinds@codeaurora.org> wrote:
>
> This series enables ath10k wifi driver support for WCN3990 target
> on sdm845 SOC. This series also updates the missing dt binding documentation
> and adds optional iommu property.
>
> sdm845 dtsi changes in this series are based on top of
> https://patchwork.kernel.org/cover/10573121/ change.
>
> Changes since v1:
>         Listed no of interrupts/clocks for each set of compatible.
>         Added missing 'wifi' label to sdm845.dtsi.
>
> Govind Singh (4):
>   dt: bindings: add missing dt properties for WCN3990 wifi node
>   dts: arm64/sdm845: Add WCN3990 WLAN module device node
>   dt: bindings: add bindings for wifi iommu node
>   dts: arm64/sdm845: Enable iommu for WCN3990 wifi module device node
>
>  .../bindings/net/wireless/qcom,ath10k.txt     | 34 +++++++++++++++----
>  arch/arm64/boot/dts/qcom/sdm845-mtp.dts       |  7 ++++
>  arch/arm64/boot/dts/qcom/sdm845.dtsi          | 27 +++++++++++++++
>  3 files changed, 61 insertions(+), 7 deletions(-)
>
> --
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> a Linux Foundation Collaborative Project
>
