Return-Path: <SRS0=5Jnr=SJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8722DC282DD
	for <linux-wireless@archiver.kernel.org>; Sun,  7 Apr 2019 16:15:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4BA1621902
	for <linux-wireless@archiver.kernel.org>; Sun,  7 Apr 2019 16:15:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=megous.com header.i=@megous.com header.b="qgAnFFPl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726606AbfDGQPa (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 7 Apr 2019 12:15:30 -0400
Received: from vps.xff.cz ([195.181.215.36]:45624 "EHLO vps.xff.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726574AbfDGQP3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 7 Apr 2019 12:15:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=megous.com; s=mail;
        t=1554653725; bh=g8ddbVj2qfu6nrJLY3FO6r2PmexgoejDLoPP3m2CnE0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qgAnFFPl4jGe3/iz/3dKGU3Jia6pCnAK73yWLDP0LuUViUYTclpiw1tefGtjvaaD4
         YynYJfJIhWa4CJ6cBDg9FUg2pWT7KPcfxPQHCx/tTyUE2oFOAh+qWHsuj1dXYKjOSr
         /YGtfZxhP7n+jSSC/AipoBapi804Zf5etqKLKswk=
Date:   Sun, 7 Apr 2019 18:15:25 +0200
From:   =?utf-8?Q?Ond=C5=99ej?= Jirman <megous@megous.com>
To:     =?utf-8?B?Q2zDqW1lbnQgUMOpcm9u?= <peron.clem@gmail.com>
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
Subject: Re: [linux-sunxi] [PATCH 12/12] arm64: dts: allwinner: orange-pi-3:
 Enable WiFi
Message-ID: <20190407161525.mbvxcien76ydsmha@core.my.home>
Mail-Followup-To: =?utf-8?B?Q2zDqW1lbnQgUMOpcm9u?= <peron.clem@gmail.com>,
        linux-sunxi@googlegroups.com,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>, Rob Herring <robh+dt@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>,
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
        linux-kernel <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, linux-gpio@vger.kernel.org
References: <20190405234514.6183-1-megous@megous.com>
 <20190405234514.6183-13-megous@megous.com>
 <CAJiuCcdRHj56p_KFRhK8H9xO+M3ycNp1Jpzw_QWcKQZorcKGpA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJiuCcdRHj56p_KFRhK8H9xO+M3ycNp1Jpzw_QWcKQZorcKGpA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sun, Apr 07, 2019 at 05:31:52PM +0200, Clément Péron wrote:
> Hi,
> 
> On Sat, 6 Apr 2019 at 01:45, megous via linux-sunxi
> <linux-sunxi@googlegroups.com> wrote:
> >
> > From: Ondrej Jirman <megous@megous.com>
> >
> > Orange Pi 3 has AP6256 WiFi/BT module. WiFi part of the module is
> > called bcm43356 and can be used with the brcmfmac driver. The module
> > is powered by the two always on regulators (not AXP805).
> >
> > WiFi uses a PG port with 1.8V voltage level signals. SoC needs to be
> > configured so that it sets up an 1.8V input bias on this port. This is
> > done by the pio driver by reading the vcc-pg-supply voltage.
> >
> > You'll need a fw_bcm43456c5_ag.bin firmware file and nvram.txt
> > configuration that can be found in the Xulongs's repository for H6:
> >
> > https://github.com/orangepi-xunlong/OrangePiH6_external/tree/master/ap6256
> >
> > Mainline brcmfmac driver expects the firmware and nvram at the
> > following paths relative to the firmware directory:
> >
> >   brcm/brcmfmac43456-sdio.bin
> >   brcm/brcmfmac43456-sdio.txt
> >
> > Signed-off-by: Ondrej Jirman <megous@megous.com>
> > ---
> >  .../dts/allwinner/sun50i-h6-orangepi-3.dts    | 48 +++++++++++++++++++
> >  1 file changed, 48 insertions(+)
> >
> > diff --git a/arch/arm64/boot/dts/allwinner/sun50i-h6-orangepi-3.dts b/arch/arm64/boot/dts/allwinner/sun50i-h6-orangepi-3.dts
> > index 5270142527f5..6a201829bb62 100644
> > --- a/arch/arm64/boot/dts/allwinner/sun50i-h6-orangepi-3.dts
> > +++ b/arch/arm64/boot/dts/allwinner/sun50i-h6-orangepi-3.dts
> > @@ -66,6 +66,26 @@
> >                 regulator-always-on;
> >         };
> >
> > +       reg_vcc33_wifi: vcc33-wifi {
> > +               /* Always on 3.3V regulator for WiFi and BT */
> > +               compatible = "regulator-fixed";
> > +               regulator-name = "vcc33-wifi";
> > +               regulator-min-microvolt = <3300000>;
> > +               regulator-max-microvolt = <3300000>;
> > +               regulator-always-on;
> > +                vin-supply = <&reg_vcc5v>;
> > +       };
> > +
> > +       reg_vcc_wifi_io: vcc-wifi-io {
> > +               /* Always on 1.8V/300mA regulator for WiFi and BT IO */
> > +               compatible = "regulator-fixed";
> > +               regulator-name = "vcc-wifi-io";
> > +               regulator-min-microvolt = <1800000>;
> > +               regulator-max-microvolt = <1800000>;
> > +               regulator-always-on;
> > +                vin-supply = <&reg_vcc33_wifi>;
> > +       };
> > +
> >         /*
> >          * The board uses 2.5V RGMII signalling. Power sequence
> >          * to enable the phy is to enable GMAC-2V5 and GMAC-3V3 (aldo2)
> > @@ -86,6 +106,14 @@
> >                   */
> >                  vin-supply = <&reg_aldo2>; /* GMAC-3V3 */
> >          };
> > +
> > +       wifi_pwrseq: wifi_pwrseq {
> > +               compatible = "mmc-pwrseq-simple";
> > +               clocks = <&rtc 1>;
> 
> Maybe I missed something, but the RTC in H6 is not yet available :
> https://lkml.org/lkml/2018/10/31/822

You're right. I'm using an out-of-tree patch for that and didn't notice the
dependency. I guess, WiFi DTS patch can be ignored for now.

thanks,
	o.

> Regards,
> Clement
> 
> > +               clock-names = "ext_clock";
> > +               reset-gpios = <&r_pio 1 3 GPIO_ACTIVE_LOW>; /* PM3 */
> > +               post-power-on-delay-ms = <200>;
> > +       };
> >  };
> >
> >  &cpu0 {
> > @@ -146,6 +174,25 @@
> >         status = "okay";
> >  };
> >
> > +&mmc1 {
> > +       pinctrl-names = "default";
> > +       pinctrl-0 = <&mmc1_pins>;
> > +       vmmc-supply = <&reg_vcc33_wifi>;
> > +       vqmmc-supply = <&reg_vcc_wifi_io>;
> > +       mmc-pwrseq = <&wifi_pwrseq>;
> > +       bus-width = <4>;
> > +       non-removable;
> > +       status = "okay";
> > +
> > +       brcm: sdio-wifi@1 {
> > +               reg = <1>;
> > +               compatible = "brcm,bcm4329-fmac";
> > +               interrupt-parent = <&r_pio>;
> > +               interrupts = <1 0 IRQ_TYPE_LEVEL_LOW>; /* PM0 */
> > +               interrupt-names = "host-wake";
> > +       };
> > +};
> > +
> >  &ohci0 {
> >         status = "okay";
> >  };
> > @@ -157,6 +204,7 @@
> >  &pio {
> >         vcc-pc-supply = <&reg_bldo2>;
> >         vcc-pd-supply = <&reg_cldo1>;
> > +       vcc-pg-supply = <&reg_vcc_wifi_io>;
> >  };
> >
> >  &r_i2c {
> > --
> > 2.21.0
> >
> > --
> > You received this message because you are subscribed to the Google Groups "linux-sunxi" group.
> > To unsubscribe from this group and stop receiving emails from it, send an email to linux-sunxi+unsubscribe@googlegroups.com.
> > For more options, visit https://groups.google.com/d/optout.
