Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:52946 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751272Ab3GaNJT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Jul 2013 09:09:19 -0400
Message-ID: <51F90C5A.2000807@ti.com> (sfid-20130731_150924_707403_09AE340E)
Date: Wed, 31 Jul 2013 18:38:42 +0530
From: Balaji T K <balajitk@ti.com>
MIME-Version: 1.0
To: Luciano Coelho <coelho@ti.com>
CC: <tony@atomide.com>, <linux-omap@vger.kernel.org>,
	<devicetree@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	<linux-wireless@vger.kernel.org>, <luca@coelho.fi>, <balbi@ti.com>,
	<laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH v2 1/4] ARM: dts: omap4-panda: add MMC5 (WiLink WLAN)
 configuration
References: <1375218923-29876-1-git-send-email-coelho@ti.com> <1375218923-29876-2-git-send-email-coelho@ti.com>
In-Reply-To: <1375218923-29876-2-git-send-email-coelho@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 31 July 2013 02:45 AM, Luciano Coelho wrote:
> Add regulator, pin muxing and MMC5 configuration to be used by the
> on-board WiLink6 module.
>
> Signed-off-by: Luciano Coelho <coelho@ti.com>
> ---
>   arch/arm/boot/dts/omap4-panda-common.dtsi | 31 ++++++++++++++++++++++++++++++-
>   1 file changed, 30 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm/boot/dts/omap4-panda-common.dtsi b/arch/arm/boot/dts/omap4-panda-common.dtsi
> index faa95b5..b3f6e1f 100644
> --- a/arch/arm/boot/dts/omap4-panda-common.dtsi
> +++ b/arch/arm/boot/dts/omap4-panda-common.dtsi
> @@ -107,6 +107,16 @@
>   	 */
>   		clock-frequency = <19200000>;
>   	};
> +
> +	wilink_wl_en: fixedregulator@1 {
> +		compatible = "regulator-fixed";
> +		regulator-name = "wilink_wl_en";
> +		regulator-min-microvolt = <1800000>;
> +		regulator-max-microvolt = <1800000>;
> +		gpio = <&gpio2 11 0>; /* gpio line 43 */
> +		startup-delay-us = <70000>;
> +		enable-active-high;
> +	};
>   };
>
>   &omap4_pmx_wkup {
> @@ -132,6 +142,7 @@
>   			&dss_hdmi_pins
>   			&tpd12s015_pins
>   			&hsusbb1_pins
> +			&wilink_pins
>   	>;
>
>   	twl6030_pins: pinmux_twl6030_pins {
> @@ -235,6 +246,19 @@
>   			0x1c (PIN_OUTPUT | MUX_MODE3)	/* gpio_wk8 */
>   		>;
>   	};
> +
> +	wilink_pins: pinmux_wilink_pins {
> +		pinctrl-single,pins = <
> +			0x7a 0x103      /* gpio_53  INPUT | MODE3 */
> +			0x66 0x3	/* gpio_43  OUTPUT | MODE3 */
> +			0x148 0x118     /* clk	    INPUT PULLUP | MODE0 */
> +			0x14a 0x118     /* cmd	    INPUT PULLUP | MODE0 */
> +			0x14c 0x118     /* dat0	    INPUT PULLUP | MODE0 */
> +			0x14e 0x118     /* dat1	    INPUT PULLUP | MODE0 */
> +			0x150 0x118     /* dat2	    INPUT PULLUP | MODE0 */
> +			0x152 0x118     /* dat3	    INPUT PULLUP | MODE0 */
Hi,

Since the base for omap4_pmx_core is 0x4a100040, you need to offset 0x40 from
pad address :-)
and can you please use INPUT_EN / PIN_INPUT_PULLUP / MUX_MODEx macros
(from dt-bindings/pinctrl/omap.h)


