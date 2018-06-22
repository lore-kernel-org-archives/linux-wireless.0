Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hermes.aosc.io ([199.195.250.187]:35373 "EHLO hermes.aosc.io"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934203AbeFVQaG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Jun 2018 12:30:06 -0400
Message-ID: <a7011fe78d171658742406bf01d50b7e3d7eaf1d.camel@aosc.io> (sfid-20180622_183021_262039_FED75F80)
Subject: Re: [PATCHv2 5/5] arm64: allwinner: a64: Add support for TERES-I
 laptop
From: Icenowy Zheng <icenowy@aosc.io>
To: Harald Geyer <harald@ccbib.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>, Kalle Valo <kvalo@codeaurora.org>
Cc: Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andre Przywara <andre.przywara@arm.com>, info@olimex.com,
        linux-wireless@vger.kernel.org
Date: Sat, 23 Jun 2018 00:27:21 +0800
In-Reply-To: <20180315162510.11669-6-harald@ccbib.org>
References: <20180315162510.11669-1-harald@ccbib.org>
         <20180315162510.11669-6-harald@ccbib.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

在 2018-03-15四的 16:25 +0000，Harald Geyer写道：
> The TERES-I is an open hardware laptop built by Olimex using the
> Allwinner A64 SoC.
> 
> Add the board specific .dts file, which includes the A64 .dtsi and
> enables the peripherals that we support so far.
> 
> Signed-off-by: Harald Geyer <harald@ccbib.org>
> ---
> changes since v1:
>  * use SPDX header instead of license text
>  * change model string to match compatible string
>  * removed node labes from leds
>  * added label properties ot led nodes
>  * add a comment about the purpose of i2c0
> 
>  arch/arm64/boot/dts/allwinner/Makefile             |   1 +
>  .../boot/dts/allwinner/sun50i-a64-teres-i.dts      | 279
> +++++++++++++++++++++
>  2 files changed, 280 insertions(+)
>  create mode 100644 arch/arm64/boot/dts/allwinner/sun50i-a64-teres-
> i.dts
> 
> diff --git a/arch/arm64/boot/dts/allwinner/Makefile
> b/arch/arm64/boot/dts/allwinner/Makefile
> index f505227b0250..5f073f7423b7 100644
> --- a/arch/arm64/boot/dts/allwinner/Makefile
> +++ b/arch/arm64/boot/dts/allwinner/Makefile
> @@ -5,6 +5,7 @@ dtb-$(CONFIG_ARCH_SUNXI) += sun50i-a64-olinuxino.dtb
>  dtb-$(CONFIG_ARCH_SUNXI) += sun50i-a64-orangepi-win.dtb
>  dtb-$(CONFIG_ARCH_SUNXI) += sun50i-a64-pine64-plus.dtb sun50i-a64-
> pine64.dtb
>  dtb-$(CONFIG_ARCH_SUNXI) += sun50i-a64-sopine-baseboard.dtb
> +dtb-$(CONFIG_ARCH_SUNXI) += sun50i-a64-teres-i.dtb
>  dtb-$(CONFIG_ARCH_SUNXI) += sun50i-h5-orangepi-pc2.dtb
>  dtb-$(CONFIG_ARCH_SUNXI) += sun50i-h5-orangepi-prime.dtb
>  dtb-$(CONFIG_ARCH_SUNXI) += sun50i-h5-orangepi-zero-plus2.dtb
> diff --git a/arch/arm64/boot/dts/allwinner/sun50i-a64-teres-i.dts
> b/arch/arm64/boot/dts/allwinner/sun50i-a64-teres-i.dts
> new file mode 100644
> index 000000000000..b105430e0368
> --- /dev/null
> +++ b/arch/arm64/boot/dts/allwinner/sun50i-a64-teres-i.dts
> @@ -0,0 +1,279 @@
> +/*
> + * Copyright (C) Harald Geyer <harald@ccbib.org>
> + * based on sun50i-a64-olinuxino.dts by Jagan Teki <jteki@openedev.c
> om>
> + *
> + * SPDX-License-Identifier: (GPL-2.0 OR MIT)
> + */
> +
> +/dts-v1/;
> +
> +#include "sun50i-a64.dtsi"
> +
> +#include <dt-bindings/gpio/gpio.h>
> +#include <dt-bindings/input/input.h>
> +#include <dt-bindings/pwm/pwm.h>
> +
> +/ {
> +	model = "Olimex A64 Teres-I";
> +	compatible = "olimex,a64-teres-i", "allwinner,sun50i-a64";
> +
> +	aliases {
> +		serial0 = &uart0;
> +	};
> +
> +	backlight: backlight {
> +		compatible = "pwm-backlight";
> +		pwms = <&pwm 0 50000 0>;
> +		brightness-levels = <0 10 20 30 40 50 60 70 100>;
> +		default-brightness-level = <3>;
> +		enable-gpios = <&pio 3 23 GPIO_ACTIVE_HIGH>; /* PD23
> */
> +	};
> +
> +	chosen {
> +		stdout-path = "serial0:115200n8";
> +
> +		framebuffer-lcd {
> +			eDP25-supply = <&reg_dldo2>;
> +			eDP12-supply = <&reg_dldo3>;
> +		};
> +	};
> +
> +	gpio-keys {
> +		compatible = "gpio-keys";
> +
> +		lid-switch {
> +			label = "Lid Switch";
> +			gpios = <&r_pio 0 8 GPIO_ACTIVE_LOW>; /* PL8
> */
> +			linux,input-type = <EV_SW>;
> +			linux,code = <SW_LID>;
> +		};
> +	};
> +
> +	leds {
> +		compatible = "gpio-leds";
> +
> +		capslock {
> +			label = "leds:green:capslock";
> +			gpios = <&pio 2 7 GPIO_ACTIVE_HIGH>; /* PC7
> */
> +		};
> +
> +		numlock {
> +			label = "leds:green:numlock";
> +			gpios = <&pio 2 4 GPIO_ACTIVE_HIGH>; /* PC4
> */
> +		};
> +	};
> +
> +	reg_usb1_vbus: usb1-vbus {
> +		compatible = "regulator-fixed";
> +		regulator-name = "usb1-vbus";
> +		regulator-min-microvolt = <5000000>;
> +		regulator-max-microvolt = <5000000>;
> +		enable-active-high;
> +		gpio = <&r_pio 0 7 GPIO_ACTIVE_HIGH>; /* PL7 */
> +		status = "okay";
> +	};
> +
> +	wifi_pwrseq: wifi_pwrseq {
> +		compatible = "mmc-pwrseq-simple";
> +		reset-gpios = <&r_pio 0 2 GPIO_ACTIVE_LOW>; /* PL2
> */
> +	};
> +};
> +
> +&ehci1 {
> +	status = "okay";
> +};
> +
> +
> +/* The ANX6345 eDP-bridge is on i2c0. There is no linux (mainline)
> + * driver for this chip at the moment, the bootloader initializes
> it.
> + * However it can be accessed with the i2c-dev driver from user
> space.
> + */
> +&i2c0 {
> +	clock-frequency = <100000>;
> +	pinctrl-names = "default";
> +	pinctrl-0 = <&i2c0_pins>;
> +	status = "okay";
> +};
> +
> +&mmc0 {
> +	pinctrl-names = "default";
> +	pinctrl-0 = <&mmc0_pins>;
> +	vmmc-supply = <&reg_dcdc1>;
> +	cd-gpios = <&pio 5 6 GPIO_ACTIVE_LOW>;
> +	disable-wp;
> +	bus-width = <4>;
> +	status = "okay";
> +};
> +
> +&mmc1 {
> +	pinctrl-names = "default";
> +	pinctrl-0 = <&mmc1_pins>;
> +	vmmc-supply = <&reg_aldo2>;
> +	vqmmc-supply = <&reg_dldo4>;
> +	mmc-pwrseq = <&wifi_pwrseq>;
> +	bus-width = <4>;
> +	non-removable;
> +	status = "okay";
> +
> +	rtl8723bs: wifi@1 {
> +		reg = <1>;
> +		interrupt-parent = <&r_pio>;
> +		interrupts = <0 3 IRQ_TYPE_LEVEL_LOW>; /* PL3 */
> +		interrupt-names = "host-wake";
> +	};

I think this node has some problem:

- This device node has no binding. The "host-wake" interrupt is part of
 Broadcom SDIO Wi-Fi binding, rather than a generic one.
- Without the interrupt this device node isn't needed, as RTL8723BS has
MAC eFUSE and doesn't need a MAC in device tree.

In order to solve the problems. I suggest either drop this device node
or make a generic "sdio-wifi" device tree binding. Personally I prefer
the latter, as it's more accurate device representation.

If such a device tree binding is added, I think it should contain the
"host-wake" interrupt and a "local-mac-address" property. Both can be
ignored by the driver. (This interrupt can be needed if a more card-
ventor-neutral name is found.)

> +};
> +
> +&mmc2 {
> +	pinctrl-names = "default";
> +	pinctrl-0 = <&mmc2_pins>;
> +	vmmc-supply = <&reg_dcdc1>;
> +	vqmmc-supply = <&reg_dcdc1>;
> +	bus-width = <8>;
> +	non-removable;
> +	cap-mmc-hw-reset;
> +	status = "okay";
> +};
> +
> +&pwm {
> +	pinctrl-names = "default";
> +	pinctrl-0 = <&pwm_pin>;
> +	status = "okay";
> +};
> +
> +&ohci1 {
> +	status = "okay";
> +};
> +
> +&r_rsb {
> +	status = "okay";
> +
> +	axp803: pmic@3a3 {
> +		compatible = "x-powers,axp803";
> +		reg = <0x3a3>;
> +		interrupt-parent = <&r_intc>;
> +		interrupts = <0 IRQ_TYPE_LEVEL_LOW>;
> +		wakeup-source;
> +	};
> +};
> +
> +#include "axp803.dtsi"
> +
> +&reg_aldo1 {
> +	regulator-always-on;
> +	regulator-min-microvolt = <2800000>;
> +	regulator-max-microvolt = <2800000>;
> +	regulator-name = "vcc-pe";
> +};
> +
> +&reg_aldo2 {
> +	regulator-always-on;
> +	regulator-min-microvolt = <3300000>;
> +	regulator-max-microvolt = <3300000>;
> +	regulator-name = "vcc-pl";
> +};
> +
> +&reg_aldo3 {
> +	regulator-always-on;
> +	regulator-min-microvolt = <3000000>;
> +	regulator-max-microvolt = <3000000>;
> +	regulator-name = "vcc-pll-avcc";
> +};
> +
> +&reg_dcdc1 {
> +	regulator-always-on;
> +	regulator-min-microvolt = <3300000>;
> +	regulator-max-microvolt = <3300000>;
> +	regulator-name = "vcc-3v3";
> +};
> +
> +&reg_dcdc2 {
> +	regulator-always-on;
> +	regulator-min-microvolt = <1040000>;
> +	regulator-max-microvolt = <1300000>;
> +	regulator-name = "vdd-cpux";
> +};
> +
> +/* DCDC3 is polyphased with DCDC2 */
> +
> +&reg_dcdc5 {
> +	regulator-always-on;
> +	regulator-min-microvolt = <1500000>;
> +	regulator-max-microvolt = <1500000>;
> +	regulator-name = "vcc-ddr3";
> +};
> +
> +&reg_dcdc6 {
> +	regulator-always-on;
> +	regulator-min-microvolt = <1100000>;
> +	regulator-max-microvolt = <1100000>;
> +	regulator-name = "vdd-sys";
> +};
> +
> +&reg_dldo1 {
> +	regulator-min-microvolt = <3300000>;
> +	regulator-max-microvolt = <3300000>;
> +	regulator-name = "vcc-hdmi";
> +};
> +
> +&reg_dldo2 {
> +	regulator-min-microvolt = <2500000>;
> +	regulator-max-microvolt = <2500000>;
> +	regulator-name = "vcc-pd";
> +};
> +
> +&reg_dldo3 {
> +	regulator-min-microvolt = <1200000>;
> +	regulator-max-microvolt = <1200000>;
> +	regulator-name = "eDP12";
> +};
> +
> +&reg_dldo4 {
> +	regulator-min-microvolt = <3300000>;
> +	regulator-max-microvolt = <3300000>;
> +	regulator-name = "vcc-wifi-io";
> +};
> +
> +&reg_eldo1 {
> +	regulator-min-microvolt = <1800000>;
> +	regulator-max-microvolt = <1800000>;
> +	regulator-name = "cpvdd";
> +};
> +
> +&reg_eldo2 {
> +	regulator-min-microvolt = <1800000>;
> +	regulator-max-microvolt = <1800000>;
> +	regulator-name = "vcc-dvdd-csi";
> +};
> +
> +&reg_fldo1 {
> +	regulator-min-microvolt = <1200000>;
> +	regulator-max-microvolt = <1200000>;
> +	regulator-name = "vcc-1v2-hsic";
> +};
> +
> +/*
> + * The A64 chip cannot work without this regulator off, although
> + * it seems to be only driving the AR100 core.
> + * Maybe we don't still know well about CPUs domain.
> + */
> +&reg_fldo2 {
> +	regulator-always-on;
> +	regulator-min-microvolt = <1100000>;
> +	regulator-max-microvolt = <1100000>;
> +	regulator-name = "vdd-cpus";
> +};
> +
> +&reg_rtc_ldo {
> +	regulator-name = "vcc-rtc";
> +};
> +
> +&uart0 {
> +	pinctrl-names = "default";
> +	pinctrl-0 = <&uart0_pins_a>;
> +	status = "okay";
> +};
> +
> +&usbphy {
> +	usb1_vbus-supply = <&reg_usb1_vbus>;
> +	status = "okay";
> +};
