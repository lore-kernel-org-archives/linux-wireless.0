Return-Path: <SRS0=TYOj=SL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3375C282DA
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 11:32:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8E17E20857
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 11:32:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=megous.com header.i=@megous.com header.b="VPX1viL1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726875AbfDILcC (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 9 Apr 2019 07:32:02 -0400
Received: from vps.xff.cz ([195.181.215.36]:42984 "EHLO vps.xff.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726066AbfDILcC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Apr 2019 07:32:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=megous.com; s=mail;
        t=1554809517; bh=1mees+S2L7FCDxo7RyLjgEgMFJ3PRBmTyqr3l3rMb0w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VPX1viL1iy0MXteXhepHJZDpd/pbGT6QnlgW+WBv3VkfA0rn0YjpU5nzIDvQcgsfy
         nhlsbrBm6qmJJjiR+hxK25khE6kTp9n1szU61Ax8mY+rxGQNvMH72nHw3Kgq9I42No
         nIfl773vmnGglVtEkoUFje9g7sdtPuli44kVftcE=
Date:   Tue, 9 Apr 2019 13:31:57 +0200
From:   =?utf-8?Q?Ond=C5=99ej?= Jirman <megous@megous.com>
To:     Jagan Teki <jagan@amarulasolutions.com>
Cc:     linux-sunxi <linux-sunxi@googlegroups.com>,
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
        dri-devel <dri-devel@lists.freedesktop.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, linux-gpio@vger.kernel.org
Subject: Re: [linux-sunxi] [PATCH v2 02/13] arm64: dts: allwinner: h6: Add
 Orange Pi 3 DTS
Message-ID: <20190409113157.e4vrzesbgmyslomb@core.my.home>
Mail-Followup-To: Jagan Teki <jagan@amarulasolutions.com>,
        linux-sunxi <linux-sunxi@googlegroups.com>,
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
        dri-devel <dri-devel@lists.freedesktop.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, linux-gpio@vger.kernel.org
References: <20190409002452.14551-1-megous@megous.com>
 <20190409002452.14551-3-megous@megous.com>
 <CAMty3ZBK2jPHTP4Y+hiy8Gq+Nx9iWYoUgke+BvopyzR8T6=0Xw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMty3ZBK2jPHTP4Y+hiy8Gq+Nx9iWYoUgke+BvopyzR8T6=0Xw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Jagan,

On Tue, Apr 09, 2019 at 02:08:18PM +0530, Jagan Teki wrote:
> Based on the conversation about using common dtsi from this thread[1],
> I'm commenting here to make show the diff directly on the nodes,
> giving comments on each node so-that we can see the diff globally.

Thanks for the suggestions below. It mostly repeats the differences and
commonalities I already stated in the previous discussion.

I don't have much to add to what I already said previously, though, because you
didn't address my concerns there. But I can restate and expand on those
concerns.

Previously I already agreed it's possible to base orangepi-3.dts on
orangepi.dtsi, and proposed a maintainable way forward, and why to follow it (to
quote myself):

  Schematics allow for high amount of variability in the power tree (see all the
  NC (not connected) / 0R resistors) in the schematic around AXP805. Every board
  based on this Xunlong design can be subtly different.

  I already suggested a maintainable solution, below. Where base dtsi has empty
  config for regulators and every board based on that just defines it completely
  for itself.

  A few regulators (for CPU/GPU) will most probably have the same meaning on
  every derived board, so these can probably be kept in dtsi without causing too
  much annoyance.

  It's unpleasant to have wrong regulator setup defined in an underlying dtsi,
  and then trying to override it by removing/adding random properties in the
  board dts for the new boards based on that, so that it fits.

  The rest of the current HW descriptions in the sun50i-h6-orangepi.dtsi can be
  shared (as of now).

My suggestion was this:

  So to base Orange Pi 3 dts on top of existing sun50i-h6-orangepi.dtsi I'd have
  to first move some things out of the base dtsi to the OrangePi Lite2 and One
  Plus board dts files, in order to have sun50i-h6-orangepi.dtsi only describe
  HW that is *really* shared by these 2 boards and Orange Pi 3.

  If I do that, I'd undefine all the axp805 regulator nodes and move the
  configurations to each of the 3 board files. That will probably end up being
  the least confusing and most maintainable. See axp81x.dtsi lines 86-144 for
  what I mean.

You seem to be suggesting a solution where every time we add an OrangePi H6
based board, the person adding it will have to go through the base dtsi and all
the other boards based on it, status disable or otherwise change regulators in
the base dtsi, patch all the other boards to re-enable it.

It would be already unpleasant just adding a third board based on this approach.
And when the fourth board is added, with another small differences in the
regulator use/meanings, the person will be looking at patching 4 dts files
+ adding one for his own board. For what benefit, to save some bytes right now?

I think maintainability, ease of adding new boards is more important, than
having a dtsi that tries to maximally cover all the commonalities between the
existing boards right now, without regards for the future. That's why
I suggested an approach like in axp81x.dtsi lines 86-144.

thank you and regards,
  o.

> On Tue, Apr 9, 2019 at 5:55 AM megous via linux-sunxi
> <linux-sunxi@googlegroups.com> wrote:
> >
> > From: Ondrej Jirman <megous@megous.com>
> >
> > Orange Pi 3 is a H6 based SBC made by Xulong, released in January 2019. It
> > has the following features:
> >
> > - Allwinner H6 quad-core 64-bit ARM Cortex-A53
> > - GPU Mali-T720
> > - 1GB or 2GB LPDDR3 RAM
> > - AXP805 PMIC
> > - AP6256 Wifi/BT 5.0
> > - USB 2.0 host port (A)
> > - USB 2.0 micro usb, OTG
> > - USB 3.0 Host + 4 port USB hub (GL3510)
> > - Gigabit Ethernet (Realtek RTL8211E phy)
> > - HDMI 2.0 port
> > - soldered eMMC (optional)
> > - 3x LED (one is on the bottom)
> > - microphone
> > - audio jack
> > - PCIe
> >
> > Add basic support for the board.
> >
> > Signed-off-by: Ondrej Jirman <megous@megous.com>
> > ---
> >  arch/arm64/boot/dts/allwinner/Makefile        |   1 +
> >  .../dts/allwinner/sun50i-h6-orangepi-3.dts    | 216 ++++++++++++++++++
> >  2 files changed, 217 insertions(+)
> >  create mode 100644 arch/arm64/boot/dts/allwinner/sun50i-h6-orangepi-3.dts
> >
> > diff --git a/arch/arm64/boot/dts/allwinner/Makefile b/arch/arm64/boot/dts/allwinner/Makefile
> > index e4dce2f6fa3a..285a7cb5135b 100644
> > --- a/arch/arm64/boot/dts/allwinner/Makefile
> > +++ b/arch/arm64/boot/dts/allwinner/Makefile
> > @@ -20,6 +20,7 @@ dtb-$(CONFIG_ARCH_SUNXI) += sun50i-h5-orangepi-pc2.dtb
> >  dtb-$(CONFIG_ARCH_SUNXI) += sun50i-h5-orangepi-prime.dtb
> >  dtb-$(CONFIG_ARCH_SUNXI) += sun50i-h5-orangepi-zero-plus.dtb
> >  dtb-$(CONFIG_ARCH_SUNXI) += sun50i-h5-orangepi-zero-plus2.dtb
> > +dtb-$(CONFIG_ARCH_SUNXI) += sun50i-h6-orangepi-3.dtb
> >  dtb-$(CONFIG_ARCH_SUNXI) += sun50i-h6-orangepi-lite2.dtb
> >  dtb-$(CONFIG_ARCH_SUNXI) += sun50i-h6-orangepi-one-plus.dtb
> >  dtb-$(CONFIG_ARCH_SUNXI) += sun50i-h6-pine-h64.dtb
> > diff --git a/arch/arm64/boot/dts/allwinner/sun50i-h6-orangepi-3.dts b/arch/arm64/boot/dts/allwinner/sun50i-h6-orangepi-3.dts
> > new file mode 100644
> > index 000000000000..5fbc5e410883
> > --- /dev/null
> > +++ b/arch/arm64/boot/dts/allwinner/sun50i-h6-orangepi-3.dts
> > @@ -0,0 +1,216 @@
> > +// SPDX-License-Identifier: (GPL-2.0+ or MIT)
> > +/*
> > + * Copyright (C) 2019 Ondřej Jirman <megous@megous.com>
> > + */
> > +
> > +/dts-v1/;
> > +
> > +#include "sun50i-h6.dtsi"
> > +
> > +#include <dt-bindings/gpio/gpio.h>
> > +
> > +/ {
> > +       model = "OrangePi 3";
> > +       compatible = "xunlong,orangepi-3", "allwinner,sun50i-h6";
> > +
> > +       aliases {
> > +               serial0 = &uart0;
> > +       };
> > +
> > +       chosen {
> > +               stdout-path = "serial0:115200n8";
> > +       };
> > +
> > +       leds {
> > +               compatible = "gpio-leds";
> > +
> > +               power {
> > +                       label = "orangepi:red:power";
> > +                       gpios = <&r_pio 0 4 GPIO_ACTIVE_HIGH>; /* PL4 */
> > +                       default-state = "on";
> > +               };
> > +
> > +               status {
> > +                       label = "orangepi:green:status";
> > +                       gpios = <&r_pio 0 7 GPIO_ACTIVE_HIGH>; /* PL7 */
> > +               };
> > +       };
> > +
> > +       reg_vcc5v: vcc5v {
> > +               /* board wide 5V supply directly from the DC jack */
> > +               compatible = "regulator-fixed";
> > +               regulator-name = "vcc-5v";
> > +               regulator-min-microvolt = <5000000>;
> > +               regulator-max-microvolt = <5000000>;
> > +               regulator-always-on;
> > +       };
> > +};
> 
> all above nodes are common to all h6 opi boards.
> 
> > +
> > +&cpu0 {
> > +       cpu-supply = <&reg_dcdca>;
> > +};
> > +
> > +&ehci0 {
> > +       status = "okay";
> > +};
> > +
> > +&ehci3 {
> > +       status = "okay";
> > +};
> 
> common to all h6 opi boards.
> 
> > +
> > +&mmc0 {
> > +       pinctrl-names = "default";
> > +       pinctrl-0 = <&mmc0_pins>;
> > +       vmmc-supply = <&reg_cldo1>;
> > +       cd-gpios = <&pio 5 6 GPIO_ACTIVE_LOW>; /* PF6 */
> > +       bus-width = <4>;
> > +       status = "okay";
> > +};
> 
> common to all h6 opi boards.
> 
> > +
> > +&ohci0 {
> > +       status = "okay";
> > +};
> > +
> > +&ohci3 {
> > +       status = "okay";
> > +};
> 
> common to all h6 opi boards.
> 
> > +
> > +&pio {
> > +       vcc-pc-supply = <&reg_bldo2>;
> > +       vcc-pd-supply = <&reg_cldo1>;
> > +};
> > +
> > +&r_i2c {
> > +       status = "okay";
> > +
> > +       axp805: pmic@36 {
> > +               compatible = "x-powers,axp805", "x-powers,axp806";
> > +               reg = <0x36>;
> > +               interrupt-parent = <&r_intc>;
> > +               interrupts = <0 IRQ_TYPE_LEVEL_LOW>;
> > +               interrupt-controller;
> > +               #interrupt-cells = <1>;
> > +               x-powers,self-working-mode;
> > +               vina-supply = <&reg_vcc5v>;
> > +               vinb-supply = <&reg_vcc5v>;
> > +               vinc-supply = <&reg_vcc5v>;
> > +               vind-supply = <&reg_vcc5v>;
> > +               vine-supply = <&reg_vcc5v>;
> > +               aldoin-supply = <&reg_vcc5v>;
> > +               bldoin-supply = <&reg_vcc5v>;
> > +               cldoin-supply = <&reg_vcc5v>;
> 
> all these supply voltage regulators are common to h6 opi boards.
> 
> > +
> > +               regulators {
> > +                       reg_aldo1: aldo1 {
> > +                               regulator-always-on;
> > +                               regulator-min-microvolt = <3300000>;
> > +                               regulator-max-microvolt = <3300000>;
> > +                               regulator-name = "vcc-pl-led-ir";
> > +                       };
> 
> same like other h6 boards.
> 
> > +
> > +                       reg_aldo2: aldo2 {
> > +                               regulator-min-microvolt = <3300000>;
> > +                               regulator-max-microvolt = <3300000>;
> > +                               regulator-name = "vcc33-audio-tv-ephy-mac";
> > +                       };
> 
> rest of h6 opi boards used it for vcc-ac200, we may append ac200 and
> make it common since the voltage is same.
> 
> > +
> > +                       /* ALDO3 is shorted to CLDO1 */
> > +                       reg_aldo3: aldo3 {
> > +                               regulator-always-on;
> > +                               regulator-min-microvolt = <3300000>;
> > +                               regulator-max-microvolt = <3300000>;
> > +                               regulator-name = "vcc33-io-pd-emmc-sd-usb-uart-1";
> > +                       };
> 
> same like above regulator.
> 
> > +
> > +                       reg_bldo1: bldo1 {
> > +                               regulator-always-on;
> > +                               regulator-min-microvolt = <1800000>;
> > +                               regulator-max-microvolt = <1800000>;
> > +                               regulator-name = "vcc18-dram-bias-pll";
> 
> same like other h6 boards.
> 
> > +                       };
> > +
> > +                       reg_bldo2: bldo2 {
> > +                               regulator-always-on;
> > +                               regulator-min-microvolt = <1800000>;
> > +                               regulator-max-microvolt = <1800000>;
> > +                               regulator-name = "vcc-efuse-pcie-hdmi-pc";
> > +                       };
> 
> same like other h6 boards.
> 
> > +
> > +                       bldo3 {
> > +                               /* unused */
> > +                       };
> 
> This is used in other h6 opi boards so we may attach status or
> re-enable it on board dts file.
> 
> > +
> > +                       bldo4 {
> > +                               /* unused */
> > +                       };
> 
> same like other h6 boards.
> 
> > +
> > +                       reg_cldo1: cldo1 {
> > +                               regulator-always-on;
> > +                               regulator-min-microvolt = <3300000>;
> > +                               regulator-max-microvolt = <3300000>;
> > +                               regulator-name = "vcc33-io-pd-emmc-sd-usb-uart-2";
> > +                       };
> 
> same like other h6 boards.
> 
> > +
> > +                       cldo2 {
> > +                               /* unused */
> > +                       };
> > +
> > +                       cldo3 {
> > +                               /* unused */
> > +                       };
> 
> These two used for wifi, so we may define on board dts or attach
> status property.
> 
> > +
> > +                       reg_dcdca: dcdca {
> > +                               regulator-always-on;
> > +                               regulator-min-microvolt = <800000>;
> > +                               regulator-max-microvolt = <1160000>;
> > +                               regulator-name = "vdd-cpu";
> > +                       };
> > +
> > +                       reg_dcdcc: dcdcc {
> > +                               regulator-min-microvolt = <810000>;
> > +                               regulator-max-microvolt = <1080000>;
> > +                               regulator-name = "vdd-gpu";
> > +                       };
> > +
> > +                       reg_dcdcd: dcdcd {
> > +                               regulator-always-on;
> > +                               regulator-min-microvolt = <960000>;
> > +                               regulator-max-microvolt = <960000>;
> > +                               regulator-name = "vdd-sys";
> > +                       };
> > +
> > +                       reg_dcdce: dcdce {
> > +                               regulator-always-on;
> > +                               regulator-min-microvolt = <1200000>;
> > +                               regulator-max-microvolt = <1200000>;
> > +                               regulator-name = "vcc-dram";
> > +                       };
> > +
> > +                       sw {
> > +                               /* unused */
> > +                       };
> 
> all above regulators are common to h6 boards.
> 
> > +               };
> > +       };
> > +};
> > +
> > +&uart0 {
> > +       pinctrl-names = "default";
> > +       pinctrl-0 = <&uart0_ph_pins>;
> > +       status = "okay";
> > +};
> > +
> > +&usb2otg {
> > +       /*
> > +        * Beware that this board will not automatically disconnect
> > +        * VBUS from DCIN, when self-powered and used as a peripheral.
> > +        */
> > +       dr_mode = "otg";
> > +       status = "okay";
> > +};
> 
> above nodes uart0, usb2otg are common to h6 opi boards.
> 
> > +
> > +&usb2phy {
> > +       usb0_id_det-gpios = <&pio 2 15 GPIO_ACTIVE_HIGH>; /* PC15 */
> > +       usb0_vbus-supply = <&reg_vcc5v>;
> > +       usb3_vbus-supply = <&reg_vcc5v>;
> > +       status = "okay";
> > +};
> > --
> 
> id detect pin can be differ, so we may move this on board specific dts.
> 
> Note: the emac node is also common between h6 opi boards.
> 
> [1] https://lkml.org/lkml/2019/4/5/857
