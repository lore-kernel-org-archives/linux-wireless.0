Return-Path: <SRS0=ZTn4=SK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F6D7C10F13
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Apr 2019 12:54:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1CD6521473
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Apr 2019 12:54:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="BCp7MYmj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726630AbfDHMyS (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Apr 2019 08:54:18 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:33148 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726373AbfDHMyL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Apr 2019 08:54:11 -0400
Received: by mail-lf1-f68.google.com with SMTP id v14so9448416lfi.0
        for <linux-wireless@vger.kernel.org>; Mon, 08 Apr 2019 05:54:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nXrNLau4jzYolEjIyjWqN0Ii33iGgL5TkNiIMQjR8E0=;
        b=BCp7MYmjzqKsxpjpRfui22RI+dj38/+eZpKMZjKSVTsoiABg/LL1DXGP5ZWshQt7Pz
         VslIvC9Q5FCDdl22mhMMrNGKGOlFKzt/a51hsO10kgEOWB79sEamIgVctLacE1SdxlJ7
         KahiKPMouTExOmRvN0yHUlHlCBYdbCgPc1/vCvMwaj32C7wAtWzLBgeHGpGPNi/TjeMA
         9hHHsX4h7hMy+BlSK9QfyDhtP7SvHG3b/qnH56fqQ97S15PK8XsifGbJ0XVFFxKr9S+p
         /ODeHzr5vTZxdwbS3cXxj6Ldq3b0APe/yO0ZuV9OCQDhucwnwbP/XgT9VNA4bNnBn5tY
         XKCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nXrNLau4jzYolEjIyjWqN0Ii33iGgL5TkNiIMQjR8E0=;
        b=b9S28b74BesPU8qbmvBJguPcaqftB9gO6c8VDDHJUHEqdMzJm9FVNeZsKF2+QjVFGK
         UBrOeFApRuAPDo+Na57RoVVxDc0w7s3zs4BDI5/TyDA6aehFeqEeZ5DBcd/mUiFCWf5R
         t1OFYzoTgLKPBPs18PUwT+Bq+EHzzzj36miB7w9y9wh1MasJd5CZ6D5/KV80q4GXr4OO
         nsBXaSAGeSP2XOpWPTexBZV3KgVTzvYK/ANRCSiAl3xI1kZF9VwHpuB2qqCgIJbUzuIL
         +efG0s8g0un+cCoJy0EseQgfYfRnePemb0q98We0klr+9o4wEB8d+MjwyQKoPhSx4Vd5
         Z6Jg==
X-Gm-Message-State: APjAAAUpzqy7W21tPmotNUbM7WI3+M2QpC7BB68ct5vjUzwSBjczhZL+
        gSJ2VAN1EVai+qrPaG+qLsXQmY7WKA8Va7LHFEbFPA==
X-Google-Smtp-Source: APXvYqxfMB/eilL6r3Dt4yX0a6WuXtBKkH6JLvwhrN0CySOTh8e6NnyyDkI6jj3mpQC6L7vLb8Azsg8rXJqNieg2M/o=
X-Received: by 2002:ac2:485a:: with SMTP id 26mr15436847lfy.128.1554728049625;
 Mon, 08 Apr 2019 05:54:09 -0700 (PDT)
MIME-Version: 1.0
References: <20190405234514.6183-1-megous@megous.com> <20190405234514.6183-10-megous@megous.com>
In-Reply-To: <20190405234514.6183-10-megous@megous.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Mon, 8 Apr 2019 14:53:58 +0200
Message-ID: <CACRpkdY=G0rpxVZL8TKJOQcf+Na8o5_FwG0EyBfb-ZCYXi=_oA@mail.gmail.com>
Subject: Re: [PATCH 09/12] pinctrl: sunxi: Prepare for alternative bias
 voltage setting methods
To:     megous@megous.com
Cc:     linux-sunxi <linux-sunxi@googlegroups.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>, Rob Herring <robh+dt@kernel.org>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Mark Rutland <mark.rutland@arm.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Naveen Gupta <naveen.gupta@cypress.com>,
        "open list:DRM PANEL DRIVERS" <dri-devel@lists.freedesktop.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-wireless <linux-wireless@vger.kernel.org>,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sat, Apr 6, 2019 at 1:45 AM <megous@megous.com> wrote:

> From: Ondrej Jirman <megous@megous.com>
>
> H6 has a different I/O voltage bias setting method than A80. Prepare
> existing code for using alternative bias voltage setting methods.
>
> Signed-off-by: Ondrej Jirman <megous@megous.com>
> ---
>  drivers/pinctrl/sunxi/pinctrl-sun9i-a80.c |  2 +-
>  drivers/pinctrl/sunxi/pinctrl-sunxi.c     | 38 ++++++++++++-----------
>  drivers/pinctrl/sunxi/pinctrl-sunxi.h     |  4 ++-

I need Maxime's ACK on these patches to merge.

Can the pinctrl parts be applied independently of the rest
of the changes when Maxime is happy with the patches?

Yours,
Linus Walleij
