Return-Path: <SRS0=RVLw=S5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 798ADC43219
	for <linux-wireless@archiver.kernel.org>; Sat, 27 Apr 2019 16:56:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 460C82077B
	for <linux-wireless@archiver.kernel.org>; Sat, 27 Apr 2019 16:56:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oY1Z64Kc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726255AbfD0Q4w (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 27 Apr 2019 12:56:52 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:37276 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726152AbfD0Q4w (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 27 Apr 2019 12:56:52 -0400
Received: by mail-pl1-f194.google.com with SMTP id z8so3032903pln.4;
        Sat, 27 Apr 2019 09:56:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Hvtq7zNAnrPZFqg7B9biXnElsoCmOPrVGVZCJ5gJhp4=;
        b=oY1Z64KccFbyy0wq9QVwJe0jyd7/RsnZQ/RB8ENhLnlCZjeajuJNoHTIn7SX0vVdqi
         LrjUFiFbUCa4YxtQMvMdljRqdgTGgHHDLQHj1H0QA9OyD05A3DqADEj8/N1oJhoproXe
         y/9kGhYlwLp4EsGsStj0io0eywSB1DQAT/MNckNred9ws5HfIqcstfSMDAPbD8MvPnJX
         2J5O4rkODzSg+rHTATqNxgK3wELuL9CMGwJhxNvPTwUcOewrX3KyYIsv9M0jMOJs122I
         lwv9AJyObKXTquKg208AUDBouu50hh5Yb0ErQ0TMHegRiHTmh4VYhwlqWwTjE8E8Ev7q
         0hPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Hvtq7zNAnrPZFqg7B9biXnElsoCmOPrVGVZCJ5gJhp4=;
        b=VTTHxUtS91u7qhT5nKTNAZWnP3t8TOQeDrrkM8+flS9+O2uZjp+Q6ntuuIcUFXiN9I
         0yVw0pI+yPgLGfCbMVed7OfBdaT3qCnRp9gexI9OK7kAJbO84wXvEwU46ZOFDSqkaACn
         oXU58vwmR48vVF0s7Iffp03guoYIVf8ImMpF2U7ypPAIGHSHQdsT2p1GVc5rMBsiRTHA
         I1p4zBzB229dAqGFPX5JMHldAKhruqw7sNaPgeBDgXpP41gu+rYffcOwiGQTZHW3ujcM
         kmtlpW+/7HzZqrU81f4AMF9GLN4rOLGkqUrAgcscCVNKg/KzEauOyTNSGr6i4/egdYDQ
         6/jA==
X-Gm-Message-State: APjAAAXXr/vEG+HjX/41cI5e7/PVDWPsf4LiR56T+bxQYyLGdh6PV1rf
        IicFftlA9RJ3jcVYUGtwP/X+eDJz
X-Google-Smtp-Source: APXvYqwSU6ZbpDR62x+bxBE8Veh7kQjbUVRkiAHr91sHGmJIgIdCZpoTZH34EFyaTXPIL5o++jb2hg==
X-Received: by 2002:a17:902:2b87:: with SMTP id l7mr53015721plb.130.1556384211138;
        Sat, 27 Apr 2019 09:56:51 -0700 (PDT)
Received: from [10.230.28.107] ([192.19.223.250])
        by smtp.gmail.com with ESMTPSA id w65sm473514pfb.59.2019.04.27.09.56.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 27 Apr 2019 09:56:49 -0700 (PDT)
Subject: Re: [PATCH 2/4] dt-bindings: doc: Reflect new NVMEM
 of_get_mac_address behaviour
To:     =?UTF-8?Q?Petr_=c5=a0tetiar?= <ynezz@true.cz>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Fugang Duan <fugang.duan@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Li Yang <leoyang.li@nxp.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Frank Rowand <frowand.list@gmail.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Alban Bedel <albeu@free.fr>,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-oxnas@groups.io,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-wireless@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org
References: <1556320002-26213-1-git-send-email-ynezz@true.cz>
 <1556320002-26213-3-git-send-email-ynezz@true.cz>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <f335fb31-ed1b-efd1-9cd3-a88b4a7fadf0@gmail.com>
Date:   Sat, 27 Apr 2019 09:56:35 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <1556320002-26213-3-git-send-email-ynezz@true.cz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org



On 4/26/2019 4:06 PM, Petr Štetiar wrote:
> As of_get_mac_address now supports NVMEM under the hood, we should
> update the bindings documentation with the new nvmem-cell* properties.
> While at it, fix also other missing properties supported by
> of_get_mac_address.
> 
> Signed-off-by: Petr Štetiar <ynezz@true.cz>

While I appreciate your effort in making the bindings up to date and
consistent, this does really scale well and is an error prone exercise,
how about consolidating all MAC address related properties into the
ethernet.txt document like you just did and update all bindings to
indicate something along the lines of:

For all other standard Ethernet related properties, please refer to
ethernet.txt or something like that?
-- 
Florian
