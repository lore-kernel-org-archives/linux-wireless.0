Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:41840 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757491Ab3G3VQG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Jul 2013 17:16:06 -0400
From: Luciano Coelho <coelho@ti.com>
To: <tony@atomide.com>, <linux-omap@vger.kernel.org>
CC: <devicetree@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	<linux-wireless@vger.kernel.org>, <coelho@ti.com>,
	<luca@coelho.fi>, <balbi@ti.com>,
	<laurent.pinchart@ideasonboard.com>
Subject: [PATCH v2 3/4] ARM: dts: omap4-sdp: add MMC5 (WiLink WLAN) configuration
Date: Wed, 31 Jul 2013 00:15:22 +0300
Message-ID: <1375218923-29876-4-git-send-email-coelho@ti.com> (sfid-20130730_231622_565373_4566C62F)
In-Reply-To: <1375218923-29876-1-git-send-email-coelho@ti.com>
References: <1375218923-29876-1-git-send-email-coelho@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add regulator, pin muxing and MMC5 configuration to be used by the
on-board WiLink6 module.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 arch/arm/boot/dts/omap4-sdp.dts | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/arch/arm/boot/dts/omap4-sdp.dts b/arch/arm/boot/dts/omap4-sdp.dts
index 7951b4e..3845615 100644
--- a/arch/arm/boot/dts/omap4-sdp.dts
+++ b/arch/arm/boot/dts/omap4-sdp.dts
@@ -140,6 +140,16 @@
 			"DMic", "Digital Mic",
 			"Digital Mic", "Digital Mic1 Bias";
 	};
+
+	wilink_wl_en: fixedregulator@1 {
+		compatible = "regulator-fixed";
+		regulator-name = "wilink_wl_en";
+		regulator-min-microvolt = <1800000>;
+		regulator-max-microvolt = <1800000>;
+		gpio = <&gpio2 22 0>; /* gpio line 54 */
+		startup-delay-us = <70000>;
+		enable-active-high;
+	};
 };
 
 &omap4_pmx_wkup {
@@ -166,6 +176,7 @@
 			&mcbsp2_pins
 			&dss_hdmi_pins
 			&tpd12s015_pins
+			&wilink_pins
 	>;
 
 	uart2_pins: pinmux_uart2_pins {
@@ -295,6 +306,19 @@
 			0xf0 (PIN_INPUT_PULLUP | MUX_MODE0)	/* i2c4_sda */
 		>;
 	};
+
+	wilink_pins: pinmux_wilink_pins {
+		pinctrl-single,pins = <
+			0x7a 0x103      /* gpio_53  INPUT | MODE3 */
+			0x7c 0x3	/* gpio_54  OUTPUT | MODE3 */
+			0x148 0x118     /* clk	    INPUT PULLUP | MODE0 */
+			0x14a 0x118     /* cmd	    INPUT PULLUP | MODE0 */
+			0x14c 0x118     /* dat0	    INPUT PULLUP | MODE0 */
+			0x14e 0x118     /* dat1	    INPUT PULLUP | MODE0 */
+			0x150 0x118     /* dat2	    INPUT PULLUP | MODE0 */
+			0x152 0x118     /* dat3	    INPUT PULLUP | MODE0 */
+		>;
+	};
 };
 
 &i2c1 {
@@ -420,8 +444,13 @@
 };
 
 &mmc5 {
+	status = "okay";
+	vmmc-supply = <&wilink_wl_en>;
 	bus-width = <4>;
+	cap-power-off-card;
+	keep-power-in-suspend;
 	ti,non-removable;
+	ti,needs-special-hs-handling;
 };
 
 &emif1 {
-- 
1.8.3.2

