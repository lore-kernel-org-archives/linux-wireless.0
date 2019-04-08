Return-Path: <SRS0=ZTn4=SK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB305C282CE
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Apr 2019 06:11:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A788020870
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Apr 2019 06:11:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amarulasolutions.com header.i=@amarulasolutions.com header.b="ew8p/kid"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725871AbfDHGLv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Apr 2019 02:11:51 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:34888 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726373AbfDHGLv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Apr 2019 02:11:51 -0400
Received: by mail-io1-f68.google.com with SMTP id p16so10043712iod.2
        for <linux-wireless@vger.kernel.org>; Sun, 07 Apr 2019 23:11:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HdEhrPVMOySwBIicdVl62OtyKXpznfnJczsThTDi/wk=;
        b=ew8p/kidwxo9FjLWe8l7YyWwxBAjtrLmmHtJa60h8PH1RyBH9zD+qCM+gug/JzCRNw
         m8sgM/VVYNRBB9IEprCWaN1ZyFscgHwBWYS4olziqdteXelseXVuUPGLaQqO8XPRvpln
         Ala6xafbpWxOw1n/35zauJ2gL6d3tveG0ruzk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HdEhrPVMOySwBIicdVl62OtyKXpznfnJczsThTDi/wk=;
        b=YY83HIYxU5c1yV66PC42NpwQyggRnthWn47xe9Toj03nlfQE0Ey8gvayBprmG9M2Tb
         fLHbTMOAaO9h1mJTaZphjjMfm3d8/cWpKKkcsn8lWBi0ulKCMCFo2N3B2wwLwI70gzgA
         bMotWgS3hn/GKRHj5ZluzUeWghJB3ZKoxcngXWbf4Fz6YHf9kkz7Ap77gq7BTKJ+S9mZ
         ei5DTr1CnJOV4CK1nVVxDWTtwNqACBg4bQpWvs2fzDZ7iUVurgZd3vehxCFPDQFSwIla
         aXkJEiVEWUsDJrK3Pal+VYveEO4K+17qGasACdoPh8FFvfqHlkhS956Vm8kD78TkgT+c
         C8pA==
X-Gm-Message-State: APjAAAXp8JUzhscozaztG3FPeVlFDs60B/8ocjF7eOCNpoSzB8mIZC+j
        pBV2CIxTE/ksoJ0qJo3Ux0HEm95s8ThvMhj0yrrfMQ==
X-Google-Smtp-Source: APXvYqzvfPRfGRKA0RPtSFucQomNgbQK6o8EiZp5KP37uXlZ7UvzeBJ+znm6EYmPQ7ieZpJbYb8znfOyFvF4u2Y3+zo=
X-Received: by 2002:a5e:9e02:: with SMTP id i2mr15996911ioq.238.1554703909935;
 Sun, 07 Apr 2019 23:11:49 -0700 (PDT)
MIME-Version: 1.0
References: <20190405234514.6183-1-megous@megous.com> <20190405234514.6183-8-megous@megous.com>
In-Reply-To: <20190405234514.6183-8-megous@megous.com>
From:   Jagan Teki <jagan@amarulasolutions.com>
Date:   Mon, 8 Apr 2019 11:41:38 +0530
Message-ID: <CAMty3ZCo53qHW4e+p=toWxLPrUua6XtaZX0YBuPfmDuW1V+e0w@mail.gmail.com>
Subject: Re: [PATCH 07/12] arm64: dts: allwinner: orange-pi-3: Enable ethernet
To:     megous@megous.com, Chen-Yu Tsai <wens@csie.org>
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
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, linux-gpio@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sat, Apr 6, 2019 at 5:15 AM <megous@megous.com> wrote:
>
> From: Ondrej Jirman <megous@megous.com>
>
> Orange Pi 3 has two regulators that power the Realtek RTL8211E.
> According to the phy datasheet, both regulators need to be enabled
> at the same time, but we can only specify a single phy-supply in
> the DT.
>
> This can be achieved by making one regulator depedning on the
> other via vin-supply. While it's not a technically correct
> description of the hardware, it achieves the purpose.
>
> All values of RX/TX delay were tested exhaustively and a middle
> one of the working values was chosen.
>
> Signed-off-by: Ondrej Jirman <megous@megous.com>
> ---
>  .../dts/allwinner/sun50i-h6-orangepi-3.dts    | 44 +++++++++++++++++++
>  1 file changed, 44 insertions(+)

This was in ML[1], I thought this change would already merged. I
remember Chen-Yu applied and revert due to emac node not mainlined at
that time.

[1] https://patchwork.kernel.org/patch/10558281/
