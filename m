Return-Path: <SRS0=gYL7=SO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19AE3C10F0E
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Apr 2019 11:05:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E78992083E
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Apr 2019 11:05:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726968AbfDLLF0 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Apr 2019 07:05:26 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:36797 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726753AbfDLLF0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Apr 2019 07:05:26 -0400
Received: by mail-ed1-f68.google.com with SMTP id u57so7331304edm.3;
        Fri, 12 Apr 2019 04:05:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zaKFhWGsxVpRdCCIz9fwH4TbtZfXGmrssA2IH/ersho=;
        b=CkRgVs6m7bDhVyvecNjAYCQRp2JIg829FboRALHzmSijr6OR83iim3TuhZKRFtNodK
         Wz5YyzzFtR4Z4KXLQMyq7CEXcgT++nWeknbOb/mT1+vPEi35eHg3ecdubvtxTua4ygfR
         HtcNLHwdsnmg+WjMTqr/wflfi49hvID72AjmroVkkui0bT9cPxtTAhnObzLhTdEciRi8
         xcxnOK5d8oCyhImD2MI8uKuJz0T+4EwfG4tAJEZ9J/YetwBMNYnWb1MV3L6T5evnm4cn
         IIoQJ3R1goZ17vXVBTs7XMWdvB7T3XxtuwqH6hDleLexMOjuzh27eyCHTKmgDzx4HCxd
         7rXw==
X-Gm-Message-State: APjAAAVnwcJNzxrZa1AHPu1VGwhteul4Va0hVmqhu0QE1gUG/uGBBCYn
        fYbvozVelLKMjEyJafkyt+a0fg+pqcs=
X-Google-Smtp-Source: APXvYqzNMpxDOwGpfXbr04b/Bpzdfx3IsaA63mUoM79+8UpNpsucE/GZ6U4KWP+IWfxKX82+IclWEw==
X-Received: by 2002:a17:906:b80e:: with SMTP id dv14mr30711410ejb.157.1555067122478;
        Fri, 12 Apr 2019 04:05:22 -0700 (PDT)
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com. [209.85.128.54])
        by smtp.gmail.com with ESMTPSA id c16sm10178301edc.75.2019.04.12.04.05.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 12 Apr 2019 04:05:19 -0700 (PDT)
Received: by mail-wm1-f54.google.com with SMTP id h18so10494530wml.1;
        Fri, 12 Apr 2019 04:05:19 -0700 (PDT)
X-Received: by 2002:a1c:ca07:: with SMTP id a7mr10487981wmg.104.1555067119122;
 Fri, 12 Apr 2019 04:05:19 -0700 (PDT)
MIME-Version: 1.0
References: <20190411101951.30223-1-megous@megous.com>
In-Reply-To: <20190411101951.30223-1-megous@megous.com>
From:   Chen-Yu Tsai <wens@csie.org>
Date:   Fri, 12 Apr 2019 19:05:05 +0800
X-Gmail-Original-Message-ID: <CAGb2v64HgPePM=rk_kSdS7yFx4S4TR=tpGC2yQ6ruDCvBnosiA@mail.gmail.com>
Message-ID: <CAGb2v64HgPePM=rk_kSdS7yFx4S4TR=tpGC2yQ6ruDCvBnosiA@mail.gmail.com>
Subject: Re: [linux-sunxi] [PATCH v3 00/11] Add support for Orange Pi 3
To:     =?UTF-8?Q?Ond=C5=99ej_Jirman?= <megous@megous.com>
Cc:     linux-sunxi <linux-sunxi@googlegroups.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Rob Herring <robh+dt@kernel.org>,
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
        dri-devel <dri-devel@lists.freedesktop.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
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

On Thu, Apr 11, 2019 at 6:19 PM megous via linux-sunxi
<linux-sunxi@googlegroups.com> wrote:
>
> From: Ondrej Jirman <megous@megous.com>
>
> This series implements support for Xunlong Orange Pi 3 board.
>
> Unfortunately, this board needs some small driver patches, so I have
> split the boards DT patch into chunks that require patches for drivers
> in various subsystems.
>
> Suggested merging plan/dependencies:
>
> - Pinctrl and stmmac patches are needed for ethernet support.
>   (patches 1-5)
> - HDMI support was changed, please review. (patches 6-8)
> - brcmfmac patch 9, fixing firmware file selection, can be merged
>   now, after review, as it doesn't depend on anything (please
>   review :))
> - mmc1 pinconf (patch 10) can probably be merged now, too (it will
>   certainly be used soon by all the other WiFi featuring boards
>   based on H6)
> - WiFi dts patch will have to wait for H6 RTC patches, which in turn
>   depend on ChenYu's RTC series, to be merged. That will take a
>   while yet. I'm just keeping it in the series for completness.
>   (patch 11)

Unfortunately I will not have time to tackle this for the next release.
Furthermore, I'd like to do this after the new clk parenting stuff lands.
Otherwise it's going to be a mess, as the clock tree is a bit convoluted
compared to previous SoCs.

ChenYu
