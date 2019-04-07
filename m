Return-Path: <SRS0=5Jnr=SJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,FROM_EXCESS_BASE64,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC405C282DE
	for <linux-wireless@archiver.kernel.org>; Sun,  7 Apr 2019 15:04:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 95F12218D0
	for <linux-wireless@archiver.kernel.org>; Sun,  7 Apr 2019 15:04:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TEM5p9Np"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726462AbfDGPEw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 7 Apr 2019 11:04:52 -0400
Received: from mail-yb1-f195.google.com ([209.85.219.195]:39655 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726049AbfDGPEv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 7 Apr 2019 11:04:51 -0400
Received: by mail-yb1-f195.google.com with SMTP id b88so4212581ybi.6;
        Sun, 07 Apr 2019 08:04:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=eJRJtUCAWZAiA3xFeQa9NsMNwetrHisMPV4hhqvu/mA=;
        b=TEM5p9NpMEZOCJ9uqkU4km0TZQENEWDBzodgeiv1cLIOrw2xg/vHCmotlSHM/xv1fB
         dkv3ln8YtlSUO81YhfdM6Dt/tATrm7MkK0JvPz34+jnMryPmcT3eaJ9X9jw9zGjItB/b
         Jvr5PSut0mgYL5yIUiapnnM8/n2y07P7nvakQSct5WL/ikoXzLXBCiD4uT0fm43U2ByY
         Ek9187r8yxGFB3QH86gfKIIusrcJTg6j1Xf0+wJzmHIcpE7Ddz0Yz/Cqjrcg579K0Cjb
         3kqLAEJWaQ6tsxbnE4jabjPQwPsYKV0nB+VXUL+8WtvFq9jjMlTeaaMQlh4ns0Qyhw1f
         gFhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=eJRJtUCAWZAiA3xFeQa9NsMNwetrHisMPV4hhqvu/mA=;
        b=mElGc8dECXjHbKh/DM+i1zOpzkng5OkRWGcH8IDelF2I6z6e9/xuustn8m3ojNPxQB
         H9LVw0kc0c0lbVuBdX9hFDekJtSVpunAPghN68dxPPWRO8yxKb6hRWMZmxCrouaZKTaC
         tCmT0PWF/nsD1qO2hAZG3PuEK/G9THhWSRPfHqZWUJGgDnLnh0+sAfelw3cgI89Jn9ko
         GPo/XpXek6ak8lS+6sBPnWorPpC0m5fJMny7z9+r7W1kfJG0nUOCeUauc23yG+0PbTM1
         hoLK7E2/Mh/ALg31YGT/QDEiZMYJ5Ka2M82OuRbWtA2cDUR8t8PAMHim1Kvcf4iQMjQl
         DCnw==
X-Gm-Message-State: APjAAAV24wrS3rv8OsVaYJIGcikr6RPhuPa7EX6XwESxrLm6MkGLc6On
        7x22rdsTZevJBXRpaxAr1M9tembQPKOfcroyWdA=
X-Google-Smtp-Source: APXvYqx6yAOnBihW5TS0ZFZMXgfk1AS2vifm2k86itsc3Njf2gYI8QMd4YHzDnxdiAEIn5eEnCzXIcJNGKEzJ75iMjE=
X-Received: by 2002:a5b:144:: with SMTP id c4mr20531931ybp.328.1554649490318;
 Sun, 07 Apr 2019 08:04:50 -0700 (PDT)
MIME-Version: 1.0
References: <20190405234514.6183-1-megous@megous.com> <CAJiuCcew10Q3PUOk4VPoiyFc7ZhXwJzxXHQHNeVBUvVAQ3BkbQ@mail.gmail.com>
 <20190407143237.2qyoef4r5e3qvbmh@core.my.home>
In-Reply-To: <20190407143237.2qyoef4r5e3qvbmh@core.my.home>
From:   =?UTF-8?B?Q2zDqW1lbnQgUMOpcm9u?= <peron.clem@gmail.com>
Date:   Sun, 7 Apr 2019 17:08:23 +0200
Message-ID: <CAJiuCcd5OOyxU7rgy2HH2b6NvHQ1Hdh_Dwd5VL_PG=8uqRo+BQ@mail.gmail.com>
Subject: Re: [linux-sunxi] [PATCH 00/12] Add support for Orange Pi 3
To:     =?UTF-8?B?Q2zDqW1lbnQgUMOpcm9u?= <peron.clem@gmail.com>,
        linux-sunxi@googlegroups.com,
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
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

On Sun, 7 Apr 2019 at 16:32, Ond=C5=99ej Jirman <megous@megous.com> wrote:
>
> On Sun, Apr 07, 2019 at 03:36:21PM +0200, Cl=C3=A9ment P=C3=A9ron wrote:
> > Hi,
> >
> > On Sat, 6 Apr 2019 at 01:45, megous via linux-sunxi
> > <linux-sunxi@googlegroups.com> wrote:
> > >
> > > From: Ondrej Jirman <megous@megous.com>
> > >
> > > This series implements support for Xunlong Orange Pi 3 board.
> >
> > OrangePi 3 Lite2 and One Plus boards support has already been merged.
> > The support is not complete but you should rebase your patches on top
> > of sunxi/for-next
>
> Hi,
>
> OrangePi 3 is somewhat different from these two boards (mostly it has a d=
iffernt
> power tree). It doesn't use the AXP regulators that are defined in the
> sun50i-h6-orangepi.dtsi in the same way.
>
> For example:
>
> - bldo3 (is turned always on in sun50i-h6-orangepi.dtsi but unused for op=
i3)
> - cldo2 and cldo3 are unused on opi3 and have nothing to do with WiFi
> - aldo3 is not for dram
> - bldo1 on the other hand is for dram on opi3
> - some other regulators are used for different/more functions and thus
>   named differntly
> - USB id-det pin is differnt
> - ...
>
> OrangePi 3 is not a superset of what is defined in sun50i-h6-orangepi.dts=
i.
>
> So to base Orange Pi 3 dts on top of existing sun50i-h6-orangepi.dtsi I'd=
 have
> to first move some things out of the base dtsi to the OrangePi Lite2 and =
One
> Plus board dts files, in order to have sun50i-h6-orangepi.dtsi only descr=
ibe HW
> that is *really* shared by these 2 boards and Orange Pi 3.
>
> If I do that, I'd undefine all the axp805 regulator nodes and move the
> configurations to each of the 3 board files. That will probably end up be=
ing
> the least confusing and most maintainable. See axp81x.dtsi lines 86-144 f=
or
> what I mean.
>
> What do you think? Is this acceptable to everyone?

Indeed it seems to be a totally different board, not as much in common
as I thought with Lite2 and One Plus.

You should also add your board in Documentation
devicetree/bindings/arm/sunxi.yaml

Regards,
Clement



>
> regards,
>   o.
>
> > https://git.kernel.org/pub/scm/linux/kernel/git/sunxi/linux.git/tree/ar=
ch/arm64/boot/dts/allwinner/sun50i-h6-orangepi.dtsi?h=3Dsunxi/for-next
> >
> > Regards,
> > Clement
> >
> > >
> > > Unfortunately, this board needs some small driver patches, so I have
> > > split the boards DT patch into chunks that require patches for driver=
s
> > > in various subsystems:
> > >
> > > - Basic DT for the board  (patch 1)
> > > - HDMI support            (patches 2, 3, 4)
> > > - Ethernet support        (patches 5, 6, 7)
> > > - WiFi support            (patches 8, 9, 10, 11, 12)
> > >
> > > This patch is also needed to not get segfault on boot:
> > >   https://lkml.org/lkml/2019/4/5/856
> > >
> > > Please take a look.
> > >
> > > regards,
> > >   Ondrej Jirman
> > >
> > > Icenowy Zheng (2):
> > >   net: stmmac: sun8i: add support for Allwinner H6 EMAC
> > >   net: stmmac: sun8i: force select external PHY when no internal one
> > >
> > > Ondrej Jirman (10):
> > >   arm64: dts: allwinner: h6: Add Orange Pi 3 DTS
> > >   drm: sun4i: Add support for enabling DDC I2C bus to dw_hdmi glue
> > >   dt-bindings: display: sun4i-drm: Add DDC power supply
> > >   arm64: dts: allwinner: orange-pi-3: Enable HDMI output
> > >   arm64: dts: allwinner: orange-pi-3: Enable ethernet
> > >   arm64: dts: allwinner: h6: Add MMC1 pins
> > >   pinctrl: sunxi: Prepare for alternative bias voltage setting method=
s
> > >   pinctrl: sunxi: Support I/O bias voltage setting on H6
> > >   brcmfmac: Loading the correct firmware for brcm43456
> > >   arm64: dts: allwinner: orange-pi-3: Enable WiFi
> > >
> > >  .../bindings/display/sunxi/sun4i-drm.txt      |   1 +
> > >  arch/arm64/boot/dts/allwinner/Makefile        |   1 +
> > >  .../dts/allwinner/sun50i-h6-orangepi-3.dts    | 339 ++++++++++++++++=
++
> > >  arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi  |   9 +
> > >  drivers/gpu/drm/sun4i/sun8i_dw_hdmi.c         |  17 +-
> > >  drivers/gpu/drm/sun4i/sun8i_dw_hdmi.h         |   1 +
> > >  .../net/ethernet/stmicro/stmmac/dwmac-sun8i.c |  22 ++
> > >  .../broadcom/brcm80211/brcmfmac/sdio.c        |   4 +-
> > >  drivers/pinctrl/sunxi/pinctrl-sun50i-h6.c     |   1 +
> > >  drivers/pinctrl/sunxi/pinctrl-sun9i-a80.c     |   2 +-
> > >  drivers/pinctrl/sunxi/pinctrl-sunxi.c         |  50 ++-
> > >  drivers/pinctrl/sunxi/pinctrl-sunxi.h         |   7 +-
> > >  12 files changed, 433 insertions(+), 21 deletions(-)
> > >  create mode 100644 arch/arm64/boot/dts/allwinner/sun50i-h6-orangepi-=
3.dts
> > >
> > > --
> > > 2.21.0
> > >
> > > --
> > > You received this message because you are subscribed to the Google Gr=
oups "linux-sunxi" group.
> > > To unsubscribe from this group and stop receiving emails from it, sen=
d an email to linux-sunxi+unsubscribe@googlegroups.com.
> > > For more options, visit https://groups.google.com/d/optout.
