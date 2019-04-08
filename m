Return-Path: <SRS0=ZTn4=SK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BFC3C10F13
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Apr 2019 22:59:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E8CCC20879
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Apr 2019 22:59:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=megous.com header.i=@megous.com header.b="o/1XRWZb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726562AbfDHW64 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Apr 2019 18:58:56 -0400
Received: from vps.xff.cz ([195.181.215.36]:35464 "EHLO vps.xff.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726471AbfDHW6z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Apr 2019 18:58:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=megous.com; s=mail;
        t=1554764331; bh=dbHjtoHCIFlldJVxUe3HRjLtgYw978AnPPZNs3RtKkY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=o/1XRWZbOPUMavRZUYhxBT3pvgB/xCBMtf6s2EbLk6xzLP2aR0wS/f4UKYDa1WLFf
         +dUfwPtYXOfJpu/nqKZQ0kAz8clQwvTl3eh11uwBINSgsUiYY741FuvR8M+0KiexYm
         eRj5NqW66GHhjR5ZB5Dg7rMRrURSyxI1uyR20+Gc=
Date:   Tue, 9 Apr 2019 00:58:51 +0200
From:   =?utf-8?Q?Ond=C5=99ej?= Jirman <megous@megous.com>
To:     Maxime Ripard <maxime.ripard@bootlin.com>
Cc:     linux-sunxi@googlegroups.com, Chen-Yu Tsai <wens@csie.org>,
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
        dri-devel@lists.freedesktop.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, linux-gpio@vger.kernel.org
Subject: Re: [PATCH 01/12] arm64: dts: allwinner: h6: Add Orange Pi 3 DTS
Message-ID: <20190408225851.svelyf7h3fiw4wjw@core.my.home>
Mail-Followup-To: Maxime Ripard <maxime.ripard@bootlin.com>,
        linux-sunxi@googlegroups.com, Chen-Yu Tsai <wens@csie.org>,
        Rob Herring <robh+dt@kernel.org>,
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
        dri-devel@lists.freedesktop.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, linux-gpio@vger.kernel.org
References: <20190405234514.6183-1-megous@megous.com>
 <20190405234514.6183-2-megous@megous.com>
 <20190408074628.e5ers4gzlqz4coyk@flea>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190408074628.e5ers4gzlqz4coyk@flea>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, Apr 08, 2019 at 09:46:28AM +0200, Maxime Ripard wrote:
> On Sat, Apr 06, 2019 at 01:45:03AM +0200, megous@megous.com wrote:
> > From: Ondrej Jirman <megous@megous.com>
> >
> > Orange Pi 3 is a H6 based SBC made by Xulong, released in
> > January 2019. It has the following features:
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
> >  .../dts/allwinner/sun50i-h6-orangepi-3.dts    | 212 ++++++++++++++++++
> >  2 files changed, 213 insertions(+)
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
> > index 000000000000..7a2424fcaed7
> > --- /dev/null
> > +++ b/arch/arm64/boot/dts/allwinner/sun50i-h6-orangepi-3.dts
> > @@ -0,0 +1,212 @@
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
> > +	model = "OrangePi 3";
> > +	compatible = "xunlong,orangepi-3", "allwinner,sun50i-h6";
> 
> As Clement pointed out, this should be documented in
> Documentation/devicetree/bindings/arm/sunxi.yaml
> 
> It's part of sunxi/for-next only at this point, and it will go through
> a different branch than the H6 DTS, so it would be great to have it in
> a separate patch.
> 
> > +	aliases {
> > +		serial0 = &uart0;
> > +	};
> > +
> > +	chosen {
> > +		stdout-path = "serial0:115200n8";
> > +	};
> > +
> > +	leds {
> > +		compatible = "gpio-leds";
> > +
> > +		power {
> > +			label = "orangepi:red:power";
> > +			gpios = <&r_pio 0 4 GPIO_ACTIVE_HIGH>; /* PL4 */
> > +			default-state = "on";
> > +		};
> > +
> > +		status {
> > +			label = "orangepi:green:status";
> > +			gpios = <&r_pio 0 7 GPIO_ACTIVE_HIGH>; /* PL7 */
> > +		};
> > +	};
> > +
> > +	reg_vcc5v: vcc5v {
> > +		/* board wide 5V supply directly from the DC jack */
> > +		compatible = "regulator-fixed";
> > +		regulator-name = "vcc-5v";
> > +		regulator-min-microvolt = <5000000>;
> > +		regulator-max-microvolt = <5000000>;
> > +		regulator-always-on;
> > +	};
> > +};
> > +
> > +&cpu0 {
> > +	cpu-supply = <&reg_dcdca>;
> > +};
> > +
> > +&ehci0 {
> > +	status = "okay";
> > +};
> > +
> > +&ehci3 {
> > +	status = "okay";
> > +};
> > +
> > +&mmc0 {
> > +	pinctrl-names = "default";
> > +	pinctrl-0 = <&mmc0_pins>;
> > +	vmmc-supply = <&reg_cldo1>;
> > +	cd-gpios = <&pio 5 6 GPIO_ACTIVE_LOW>; /* PF6 */
> > +	bus-width = <4>;
> > +	status = "okay";
> > +};
> > +
> > +&ohci0 {
> > +	status = "okay";
> > +};
> > +
> > +&ohci3 {
> > +	status = "okay";
> > +};
> > +
> > +&pio {
> > +	vcc-pc-supply = <&reg_bldo2>;
> > +	vcc-pd-supply = <&reg_cldo1>;
> > +};
> > +
> > +&r_i2c {
> > +	status = "okay";
> > +
> > +	axp805: pmic@36 {
> > +		compatible = "x-powers,axp805", "x-powers,axp806";
> > +		reg = <0x36>;
> > +		interrupt-parent = <&r_intc>;
> > +		interrupts = <0 IRQ_TYPE_LEVEL_LOW>;
> > +		interrupt-controller;
> > +		#interrupt-cells = <1>;
> > +		x-powers,self-working-mode;
> > +		vina-supply = <&reg_vcc5v>;
> > +		vinb-supply = <&reg_vcc5v>;
> > +		vinc-supply = <&reg_vcc5v>;
> > +		vind-supply = <&reg_vcc5v>;
> > +		vine-supply = <&reg_vcc5v>;
> > +		aldoin-supply = <&reg_vcc5v>;
> > +		bldoin-supply = <&reg_vcc5v>;
> > +		cldoin-supply = <&reg_vcc5v>;
> > +
> > +		regulators {
> > +			reg_aldo1: aldo1 {
> > +				regulator-always-on;
> > +				regulator-min-microvolt = <3300000>;
> > +				regulator-max-microvolt = <3300000>;
> > +				regulator-name = "vcc-pl-led-ir";
> > +			};
> > +
> > +			reg_aldo2: aldo2 {
> > +				regulator-min-microvolt = <3300000>;
> > +				regulator-max-microvolt = <3300000>;
> > +				regulator-name = "vcc33-audio-tv-ephy-mac";
> > +			};
> > +
> > +			/* ALDO3 is shorted to CLDO1 */
> > +			reg_aldo3: aldo3 {
> > +				regulator-always-on;
> > +				regulator-min-microvolt = <3300000>;
> > +				regulator-max-microvolt = <3300000>;
> > +				regulator-name = "vcc33-io-pd-emmc-sd-usb-uart-1";
> > +			};
> > +
> > +			reg_bldo1: bldo1 {
> > +				regulator-always-on;
> > +				regulator-min-microvolt = <1800000>;
> > +				regulator-max-microvolt = <1800000>;
> > +				regulator-name = "vcc18-dram-bias-pll";
> > +			};
> > +
> > +			reg_bldo2: bldo2 {
> > +				regulator-always-on;
> > +				regulator-min-microvolt = <1800000>;
> > +				regulator-max-microvolt = <1800000>;
> > +				regulator-name = "vcc-efuse-pcie-hdmi-pc";
> > +			};
> > +
> > +			bldo3 {
> > +				/* unused */
> > +			};
> > +
> > +			bldo4 {
> > +				/* unused */
> > +			};
> > +
> > +			reg_cldo1: cldo1 {
> > +				regulator-always-on;
> > +				regulator-min-microvolt = <3300000>;
> > +				regulator-max-microvolt = <3300000>;
> > +				regulator-name = "vcc33-io-pd-emmc-sd-usb-uart-2";
> > +			};
> > +
> > +			cldo2 {
> > +				/* unused */
> > +			};
> > +
> > +			cldo3 {
> > +				/* unused */
> > +			};
> > +
> > +			reg_dcdca: dcdca {
> > +				regulator-always-on;
> > +				regulator-min-microvolt = <800000>;
> > +				regulator-max-microvolt = <1160000>;
> > +				regulator-name = "vdd-cpu";
> > +			};
> > +
> > +			reg_dcdcc: dcdcc {
> > +				regulator-min-microvolt = <810000>;
> > +				regulator-max-microvolt = <1080000>;
> > +				regulator-name = "vdd-gpu";
> > +			};
> > +
> > +			reg_dcdcd: dcdcd {
> > +				regulator-always-on;
> > +				regulator-min-microvolt = <960000>;
> > +				regulator-max-microvolt = <960000>;
> > +				regulator-name = "vdd-sys";
> > +			};
> > +
> > +			reg_dcdce: dcdce {
> > +				regulator-always-on;
> > +				regulator-min-microvolt = <1200000>;
> > +				regulator-max-microvolt = <1200000>;
> > +				regulator-name = "vcc-dram";
> > +			};
> > +
> > +			sw {
> > +				/* unused */
> > +			};
> > +		};
> > +	};
> > +};
> > +
> > +&uart0 {
> > +	pinctrl-names = "default";
> > +	pinctrl-0 = <&uart0_ph_pins>;
> > +	status = "okay";
> > +};
> > +
> > +&usb2otg {
> > +	dr_mode = "host";
> > +	status = "okay";
> > +};
> > +
> > +&usb2phy {
> > +	usb0_id_det-gpios = <&pio 2 15 GPIO_ACTIVE_HIGH>; /* PC15 */
> > +	usb0_vbus-supply = <&reg_vcc5v>;
> > +	usb3_vbus-supply = <&reg_vcc5v>;
> > +	status = "okay";
> 
> If we have an ID pin, then why is the OTG controller set to host?

This board has fixed conenction between VBUS and DCIN, so if it is powered
from DCIN and someone will try to connect it to the PC as a peripheral,
they'll get PC's VBUS shorted to the power supply connected to DCIN.

Depending on voltage difference between DCIN and PC's VBUS, you can get
overcurrent condidion and PC's port shutdown.

The board is not entirely foolproof in this regard.

- It can be host powered when connected via microUSB
- It can be self-powered and host an device on microUSB
- It can be self-powered and serve as a peripheral if you modify
  a cable (cut VBUS) or the host is expecting this and has some
  VBUS detection logic (most hosts will not have this)

I just didn't want to encourage use as a peripheral, because it's not
very foolproof. But I guess, DTS file will not stop anyone anyway.

I'll change it to otg, and maybe leave a small note.

regards,
	o.

> Maxime
> 
> --
> Maxime Ripard, Bootlin
> Embedded Linux and Kernel engineering
> https://bootlin.com


