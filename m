Return-Path: <SRS0=gYL7=SO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7865FC282DA
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Apr 2019 12:10:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 44A7320652
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Apr 2019 12:10:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=megous.com header.i=@megous.com header.b="MQqHQRwt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727541AbfDLMKI (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Apr 2019 08:10:08 -0400
Received: from vps.xff.cz ([195.181.215.36]:36482 "EHLO vps.xff.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726244AbfDLMKH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Apr 2019 08:10:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=megous.com; s=mail;
        t=1555071003; bh=7wuELmmnMv/8ohB7Lnfan2M8a1f0hxi92UIulc+/3CU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MQqHQRwt/0Y/EHKPthB2rmZ79cFw4h8FUdcFLh1kqFfJx3IeTpVmsZHXf3lTj7VVU
         qDIn/JCTIw/jDLOYo8L134Ja1NVbCe2vmW/1a2kzoSQB+8aGQH0h/CY717G290aYPg
         DtG+6xur45NSo9BSGpsa+l9dxFDjuSDkzvqkRGlM=
Date:   Fri, 12 Apr 2019 14:10:03 +0200
From:   =?utf-8?Q?Ond=C5=99ej?= Jirman <megous@megous.com>
To:     Chen-Yu Tsai <wens@csie.org>
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        linux-sunxi <linux-sunxi@googlegroups.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        brcm80211-dev-list@cypress.com, David Airlie <airlied@linux.ie>,
        Jose Abreu <joabreu@synopsys.com>,
        Naveen Gupta <naveen.gupta@cypress.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        devicetree <devicetree@vger.kernel.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Wright Feng <wright.feng@cypress.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Franky Lin <franky.lin@broadcom.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        brcm80211-dev-list.pdl@broadcom.com,
        netdev <netdev@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Daniel Vetter <daniel@ffwll.ch>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [linux-sunxi] [PATCH v3 00/11] Add support for Orange Pi 3
Message-ID: <20190412121003.yhw7w5qspps5r5nf@core.my.home>
Mail-Followup-To: Chen-Yu Tsai <wens@csie.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        linux-sunxi <linux-sunxi@googlegroups.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        brcm80211-dev-list@cypress.com, David Airlie <airlied@linux.ie>,
        Jose Abreu <joabreu@synopsys.com>,
        Naveen Gupta <naveen.gupta@cypress.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        devicetree <devicetree@vger.kernel.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Wright Feng <wright.feng@cypress.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Franky Lin <franky.lin@broadcom.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        brcm80211-dev-list.pdl@broadcom.com,
        netdev <netdev@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>, Daniel Vetter <daniel@ffwll.ch>,
        "David S. Miller" <davem@davemloft.net>
References: <20190411101951.30223-1-megous@megous.com>
 <CAGb2v64HgPePM=rk_kSdS7yFx4S4TR=tpGC2yQ6ruDCvBnosiA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGb2v64HgPePM=rk_kSdS7yFx4S4TR=tpGC2yQ6ruDCvBnosiA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hello ChenYu,

On Fri, Apr 12, 2019 at 07:05:05PM +0800, Chen-Yu Tsai wrote:
> On Thu, Apr 11, 2019 at 6:19 PM megous via linux-sunxi
> <linux-sunxi@googlegroups.com> wrote:
> >
> > From: Ondrej Jirman <megous@megous.com>
> >
> > This series implements support for Xunlong Orange Pi 3 board.
> >
> > Unfortunately, this board needs some small driver patches, so I have
> > split the boards DT patch into chunks that require patches for drivers
> > in various subsystems.
> >
> > Suggested merging plan/dependencies:
> >
> > - Pinctrl and stmmac patches are needed for ethernet support.
> >   (patches 1-5)
> > - HDMI support was changed, please review. (patches 6-8)
> > - brcmfmac patch 9, fixing firmware file selection, can be merged
> >   now, after review, as it doesn't depend on anything (please
> >   review :))
> > - mmc1 pinconf (patch 10) can probably be merged now, too (it will
> >   certainly be used soon by all the other WiFi featuring boards
> >   based on H6)
> > - WiFi dts patch will have to wait for H6 RTC patches, which in turn
> >   depend on ChenYu's RTC series, to be merged. That will take a
> >   while yet. I'm just keeping it in the series for completness.
> >   (patch 11)
> 
> Unfortunately I will not have time to tackle this for the next release.
> Furthermore, I'd like to do this after the new clk parenting stuff lands.
> Otherwise it's going to be a mess, as the clock tree is a bit convoluted
> compared to previous SoCs.

I've sent out a patch series that addresses part of that for now.

So perhaps we can start with that and incrementally get to a full support,
of H6's complexities around clocks managed by RTC.

thanks,
	o.

> ChenYu
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
