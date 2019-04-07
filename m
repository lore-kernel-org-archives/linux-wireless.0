Return-Path: <SRS0=5Jnr=SJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,FROM_EXCESS_BASE64,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3324BC282DD
	for <linux-wireless@archiver.kernel.org>; Sun,  7 Apr 2019 13:35:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 04A3720896
	for <linux-wireless@archiver.kernel.org>; Sun,  7 Apr 2019 13:35:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XzQ+ICw5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726388AbfDGNfD (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 7 Apr 2019 09:35:03 -0400
Received: from mail-yw1-f65.google.com ([209.85.161.65]:32864 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726335AbfDGNfC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 7 Apr 2019 09:35:02 -0400
Received: by mail-yw1-f65.google.com with SMTP id l5so4019209ywa.0;
        Sun, 07 Apr 2019 06:35:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XSRfVY3jJ7/9POOLIfWZTVO1rTmhqVVH5ZX3GBLlPDg=;
        b=XzQ+ICw5RPvN6bpl9aupbO5qRSW33HB7EqxG91OQee4jWG6+5DvsMqKz4bq2bfg1CT
         A+Uetx5GIjHHvUBOEumvTKgIjvAeaH20T3x3QRZ+QUV19xCHKde391uBtHgrSQNc91Bi
         kjhxbqJfqwdwOooyIumh0lW3/BZ2TWwPKZ8fVG+E3PxXUW8QZeQyLvfpCTcKFP8rymZZ
         pQTUaV1GmZCDqyrc42SmSGotHeQiEr2YPEvHO5qfIP2YuKWtsCayrABG4gtIJJEG/05U
         adgTsLQTUVTS5NF+ieedt441nawoaGPnKXO/ouHeh/4C1sUg4Fo1PNaYD3XUc+pEAk7g
         8JGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XSRfVY3jJ7/9POOLIfWZTVO1rTmhqVVH5ZX3GBLlPDg=;
        b=aYzS9kgosVZNPUSrexc6SNzjSJ/hcleQ1isIpkyMJGvQxE8NNKOg2P5AAFz0OEepoq
         d8Hnx8illq2higSNpveVMoeu6f0+SgDmCBvFSJAbUth4SxQVnYSHPZZ8mcGKtfcdkc1v
         Vt8t7PPL2tBrhArN/liHW9EW1w5iRHXlJHZPExa1RPaoiX/F/tbQAeeCM/JTcuRQCuDl
         iramX6tbkBPbQLTF6Sq3YVwh5XK0mX5/DTuCatQjudWnksjIeeH3YTCbPjqXSReObZCk
         F9uf4ZXZ7OhPtzGd8SElrht8PTRPf7HLQTtRnYbv2Wyvx2F5pc4by27n6ajAiaxlLo57
         nKTg==
X-Gm-Message-State: APjAAAW4PfKDvacGoswSy54atyRwerhVLs445lLrymXppm56djP7Cy3f
        kqEPCALiVRYgqnwhwlIwpWXRoyWWojrhYWIb1to=
X-Google-Smtp-Source: APXvYqwU6SVRsVhqebJsACuJdIkWi/KWTr4feCDp9mPfvp1aUUp2OQMrDAp/pbqryVoEclz4piBrmWjIPGzmPnPANY8=
X-Received: by 2002:a0d:d645:: with SMTP id y66mr19457081ywd.459.1554644101356;
 Sun, 07 Apr 2019 06:35:01 -0700 (PDT)
MIME-Version: 1.0
References: <20190405234514.6183-1-megous@megous.com>
In-Reply-To: <20190405234514.6183-1-megous@megous.com>
From:   =?UTF-8?B?Q2zDqW1lbnQgUMOpcm9u?= <peron.clem@gmail.com>
Date:   Sun, 7 Apr 2019 15:36:21 +0200
Message-ID: <CAJiuCcew10Q3PUOk4VPoiyFc7ZhXwJzxXHQHNeVBUvVAQ3BkbQ@mail.gmail.com>
Subject: Re: [linux-sunxi] [PATCH 00/12] Add support for Orange Pi 3
To:     megous@megous.com
Cc:     linux-sunxi@googlegroups.com,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>, Rob Herring <robh+dt@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
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
        dri-devel@lists.freedesktop.org,
        devicetree <devicetree@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, linux-gpio@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

On Sat, 6 Apr 2019 at 01:45, megous via linux-sunxi
<linux-sunxi@googlegroups.com> wrote:
>
> From: Ondrej Jirman <megous@megous.com>
>
> This series implements support for Xunlong Orange Pi 3 board.

OrangePi 3 Lite2 and One Plus boards support has already been merged.
The support is not complete but you should rebase your patches on top
of sunxi/for-next

https://git.kernel.org/pub/scm/linux/kernel/git/sunxi/linux.git/tree/arch/arm64/boot/dts/allwinner/sun50i-h6-orangepi.dtsi?h=sunxi/for-next

Regards,
Clement

>
> Unfortunately, this board needs some small driver patches, so I have
> split the boards DT patch into chunks that require patches for drivers
> in various subsystems:
>
> - Basic DT for the board  (patch 1)
> - HDMI support            (patches 2, 3, 4)
> - Ethernet support        (patches 5, 6, 7)
> - WiFi support            (patches 8, 9, 10, 11, 12)
>
> This patch is also needed to not get segfault on boot:
>   https://lkml.org/lkml/2019/4/5/856
>
> Please take a look.
>
> regards,
>   Ondrej Jirman
>
> Icenowy Zheng (2):
>   net: stmmac: sun8i: add support for Allwinner H6 EMAC
>   net: stmmac: sun8i: force select external PHY when no internal one
>
> Ondrej Jirman (10):
>   arm64: dts: allwinner: h6: Add Orange Pi 3 DTS
>   drm: sun4i: Add support for enabling DDC I2C bus to dw_hdmi glue
>   dt-bindings: display: sun4i-drm: Add DDC power supply
>   arm64: dts: allwinner: orange-pi-3: Enable HDMI output
>   arm64: dts: allwinner: orange-pi-3: Enable ethernet
>   arm64: dts: allwinner: h6: Add MMC1 pins
>   pinctrl: sunxi: Prepare for alternative bias voltage setting methods
>   pinctrl: sunxi: Support I/O bias voltage setting on H6
>   brcmfmac: Loading the correct firmware for brcm43456
>   arm64: dts: allwinner: orange-pi-3: Enable WiFi
>
>  .../bindings/display/sunxi/sun4i-drm.txt      |   1 +
>  arch/arm64/boot/dts/allwinner/Makefile        |   1 +
>  .../dts/allwinner/sun50i-h6-orangepi-3.dts    | 339 ++++++++++++++++++
>  arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi  |   9 +
>  drivers/gpu/drm/sun4i/sun8i_dw_hdmi.c         |  17 +-
>  drivers/gpu/drm/sun4i/sun8i_dw_hdmi.h         |   1 +
>  .../net/ethernet/stmicro/stmmac/dwmac-sun8i.c |  22 ++
>  .../broadcom/brcm80211/brcmfmac/sdio.c        |   4 +-
>  drivers/pinctrl/sunxi/pinctrl-sun50i-h6.c     |   1 +
>  drivers/pinctrl/sunxi/pinctrl-sun9i-a80.c     |   2 +-
>  drivers/pinctrl/sunxi/pinctrl-sunxi.c         |  50 ++-
>  drivers/pinctrl/sunxi/pinctrl-sunxi.h         |   7 +-
>  12 files changed, 433 insertions(+), 21 deletions(-)
>  create mode 100644 arch/arm64/boot/dts/allwinner/sun50i-h6-orangepi-3.dts
>
> --
> 2.21.0
>
> --
> You received this message because you are subscribed to the Google Groups "linux-sunxi" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to linux-sunxi+unsubscribe@googlegroups.com.
> For more options, visit https://groups.google.com/d/optout.
