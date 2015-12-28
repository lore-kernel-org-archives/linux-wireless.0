Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from softlayer.compulab.co.il ([50.23.254.55]:42034 "EHLO
	compulab.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751719AbbL1MDT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Dec 2015 07:03:19 -0500
From: Uri Mashiach <uri.mashiach@compulab.co.il>
To: Kalle Valo <kvalo@codeaurora.org>,
	Rob Herring <robh+dt@kernel.org>,
	Tony Lindgren <tony@atomide.com>
Cc: Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>, bcousson@baylibre.com,
	Igor Grinberg <grinberg@compulab.co.il>,
	Eliad Peller <eliad@wizery.com>, devicetree@vger.kernel.org,
	linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	Uri Mashiach <uri.mashiach@compulab.co.il>
Subject: [PATCH v3 3/3] wlcore/wl12xx: spi: add wifi support to cm-t335
Date: Mon, 28 Dec 2015 14:02:19 +0200
Message-Id: <1451304139-10899-4-git-send-email-uri.mashiach@compulab.co.il> (sfid-20151228_130324_542201_9FA2C55C)
In-Reply-To: <1451304139-10899-1-git-send-email-uri.mashiach@compulab.co.il>
References: <1451304139-10899-1-git-send-email-uri.mashiach@compulab.co.il>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Device tree modifications:
- Pinmux for SPI0 and WiFi GPIOs.
- SPI0 node with wlcore as a child node.

Cc: Tony Lindgren <tony@atomide.com>
Signed-off-by: Uri Mashiach <uri.mashiach@compulab.co.il>
Acked-by: Igor Grinberg <grinberg@complab.co.il>
---
v1 -> v2: Replace interrupts and interrupt-parent with interrupts-extended.
v2 -> v3: Move the pinctrl-0 = <&wifi_pins> to the wlcore node.

arch/arm/boot/dts/am335x-cm-t335.dts | 54 ++++++++++++++++++++++++++++++++++++
 1 file changed, 54 insertions(+)

diff --git a/arch/arm/boot/dts/am335x-cm-t335.dts b/arch/arm/boot/dts/am335x-cm-t335.dts
index 42e9b66..b700940 100644
--- a/arch/arm/boot/dts/am335x-cm-t335.dts
+++ b/arch/arm/boot/dts/am335x-cm-t335.dts
@@ -11,6 +11,7 @@
 /dts-v1/;
 
 #include "am33xx.dtsi"
+#include <dt-bindings/interrupt-controller/irq.h>
 
 / {
 	model = "CompuLab CM-T335";
@@ -40,6 +41,15 @@
 		regulator-max-microvolt = <3300000>;
 	};
 
+	/* Regulator for WiFi */
+	vwlan_fixed: fixedregulator@2 {
+		compatible = "regulator-fixed";
+		regulator-name = "vwlan_fixed";
+		gpio = <&gpio0 20 GPIO_ACTIVE_HIGH>; /* gpio0_20 */
+		enable-active-high;
+		regulator-boot-off;
+	};
+
 	backlight {
 		compatible = "pwm-backlight";
 		pwms = <&ecap0 0 50000 0>;
@@ -223,6 +233,21 @@
 		>;
 	};
 
+	spi0_pins: pinmux_spi0_pins {
+		pinctrl-single,pins = <
+			/* spi0_sclk.spi0_sclk */
+			AM33XX_IOPAD(0x950, PIN_INPUT | MUX_MODE0)
+			/* spi0_d0.spi0_d0 */
+			AM33XX_IOPAD(0x954, PIN_OUTPUT_PULLUP | MUX_MODE0)
+			/* spi0_d1.spi0_d1 */
+			AM33XX_IOPAD(0x958, PIN_INPUT | MUX_MODE0)
+			/* spi0_cs0.spi0_cs0 */
+			AM33XX_IOPAD(0x95C, PIN_OUTPUT | MUX_MODE0)
+			/* spi0_cs1.spi0_cs1 */
+			AM33XX_IOPAD(0x960, PIN_OUTPUT | MUX_MODE0)
+		>;
+	};
+
 	/* wl1271 bluetooth */
 	bluetooth_pins: pinmux_bluetooth_pins {
 		pinctrl-single,pins = <
@@ -230,6 +255,16 @@
 			AM33XX_IOPAD(0x9b0, PIN_OUTPUT_PULLUP | MUX_MODE7)
 		>;
 	};
+
+	/* wl1271 WiFi */
+	wifi_pins: pinmux_wifi_pins {
+		pinctrl-single,pins = <
+			/* EMU1.gpio3_8 - WiFi IRQ */
+			AM33XX_IOPAD(0x9e8, PIN_INPUT_PULLUP | MUX_MODE7)
+			/* XDMA_EVENT_INTR1.gpio0_20 - WiFi enable */
+			AM33XX_IOPAD(0x9b4, PIN_OUTPUT | MUX_MODE7)
+		>;
+	};
 };
 
 &uart0 {
@@ -394,3 +429,22 @@ status = "okay";
 	pinctrl-names = "default";
 	pinctrl-0 = <&mmc1_pins>;
 };
+
+&spi0 {
+	status = "okay";
+	pinctrl-names = "default";
+	pinctrl-0 = <&spi0_pins>;
+	ti,pindir-d0-out-d1-in = <1>;
+	/* WLS1271 WiFi */
+	wlcore: wlcore@1 {
+		compatible = "ti,wl1271";
+		pinctrl-names = "default";
+		pinctrl-0 = <&wifi_pins>;
+		reg = <1>;
+		spi-max-frequency = <48000000>;
+		clock-xtal;
+		ref-clock-frequency = <38400000>;
+		interrupts-extended = <&gpio3 8 IRQ_TYPE_LEVEL_HIGH>;
+		vwlan-supply = <&vwlan_fixed>;
+	};
+};
-- 
2.5.0

