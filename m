Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:56232 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751629AbbG3TvR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2015 15:51:17 -0400
From: Yaniv Machani <yanivma@ti.com>
To: <linux-wireless@vger.kernel.org>
CC: <yanivma@ti.com>, Eliad Peller <eliad@wizery.com>
Subject: [PATCH 1/2] ARM: dts: am335x-evm: add wilink8 wlan support
Date: Thu, 30 Jul 2015 22:39:28 +0300
Message-ID: <1438285169-338-1-git-send-email-yanivma@ti.com> (sfid-20150730_215120_436815_3D4EC1F8)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

   * enable mmc3 used for wlan
   * configure the gpios used for wlan
   * add fixed voltage regulator used for wlan power control

Signed-off-by: Eliad Peller <eliad@wizery.com>
Signed-off-by: Yaniv Machani <yanivma@ti.com>
---
 arch/arm/boot/dts/am335x-evm.dts |   68 ++++++++++++++++++++++++++++++++++++++
 1 files changed, 68 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/am335x-evm.dts b/arch/arm/boot/dts/am335x-evm.dts
index dd03a2b..b690674 100644
--- a/arch/arm/boot/dts/am335x-evm.dts
+++ b/arch/arm/boot/dts/am335x-evm.dts
@@ -8,6 +8,7 @@
 /dts-v1/;
 
 #include "am33xx.dtsi"
+#include <dt-bindings/interrupt-controller/irq.h>
 
 / {
 	model = "TI AM335x EVM";
@@ -38,6 +39,20 @@
 		regulator-boot-on;
 	};
 
+	wlan_en_reg: fixedregulator@2 {
+		compatible = "regulator-fixed";
+		regulator-name = "wlan-en-regulator";
+		regulator-min-microvolt = <1800000>;
+		regulator-max-microvolt = <1800000>;
+
+		/* WLAN_EN GPIO for this board - Bank3, pin16 */
+		gpio = <&gpio1 16 0>;
+
+		/* WLAN card specific delay */
+		startup-delay-us = <70000>;
+		enable-active-high;
+	};
+
 	matrix_keypad: matrix_keypad@0 {
 		compatible = "gpio-matrix-keypad";
 		debounce-delay-ms = <5>;
@@ -266,6 +281,27 @@
 		>;
 	};
 
+	/* wl12xx/wl18xx card on mmc3 */
+	mmc3_pins: pinmux_mmc3_pins {
+		pinctrl-single,pins = <
+			0x44 (PIN_INPUT_PULLUP | MUX_MODE3)	/* gpmc_a1.mmc2_dat0, INPUT_PULLUP | MODE3 */
+			0x48 (PIN_INPUT_PULLUP | MUX_MODE3)	/* gpmc_a2.mmc2_dat1, INPUT_PULLUP | MODE3 */
+			0x4C (PIN_INPUT_PULLUP | MUX_MODE3)	/* gpmc_a3.mmc2_dat2, INPUT_PULLUP | MODE3 */
+			0x78 (PIN_INPUT_PULLUP | MUX_MODE3)	/* gpmc_ben1.mmc2_dat3, INPUT_PULLUP | MODE3 */
+			0x88 (PIN_INPUT_PULLUP | MUX_MODE3)	/* gpmc_csn3.mmc2_cmd, INPUT_PULLUP | MODE3 */
+			0x8C (PIN_INPUT_PULLUP | MUX_MODE3)	/* gpmc_clk.mmc2_clk, INPUT_PULLUP | MODE3 */
+		>;
+	};
+
+	/* wl12xx/wl18xx card enable/irq GPIOs. */
+	wlan_pins: pinmux_wlan_pins {
+		pinctrl-single,pins = <
+			0x40 (PIN_OUTPUT_PULLDOWN | MUX_MODE7)	/* gpmc_a0.gpio1_16 */
+			0x19C (PIN_INPUT | MUX_MODE7)		/* mcasp0_ahclkr.gpio3_17 */
+			0x1AC (PIN_OUTPUT_PULLDOWN | MUX_MODE7)	/* mcasp0_ahclkx.gpio3_21 */
+		>;
+	};
+
 	lcd_pins_s0: lcd_pins_s0 {
 		pinctrl-single,pins = <
 			0x20 (PIN_OUTPUT | MUX_MODE1)		/* gpmc_ad8.lcd_data23 */
@@ -665,6 +701,38 @@
 	cd-gpios = <&gpio0 6 GPIO_ACTIVE_HIGH>;
 };
 
+&mmc3 {
+	/* these are on the crossbar and are outlined in the
+	   xbar-event-map element */
+	dmas = <&edma 12
+		&edma 13>;
+	dma-names = "tx", "rx";
+	status = "okay";
+	vmmc-supply = <&wlan_en_reg>;
+	bus-width = <4>;
+	pinctrl-names = "default";
+	pinctrl-0 = <&mmc3_pins &wlan_pins>;
+	ti,non-removable;
+	ti,needs-special-hs-handling;
+	cap-power-off-card;
+	keep-power-in-suspend;
+
+	#address-cells = <1>;
+	#size-cells = <0>;
+	wlcore: wlcore@2 {
+		compatible = "ti,wl1835";
+		reg = <2>;
+		interrupt-parent = <&gpio3>;
+		interrupts = <17 IRQ_TYPE_LEVEL_HIGH>;
+		ref-clock-frequency = <38400000>;
+	};
+};
+
+&edma {
+	ti,edma-xbar-event-map = /bits/ 16 <1 12
+					    2 13>;
+};
+
 &sham {
 	status = "okay";
 };
-- 
1.7.9

