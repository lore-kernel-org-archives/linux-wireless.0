Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:51723 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751629AbbG3TvT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2015 15:51:19 -0400
From: Yaniv Machani <yanivma@ti.com>
To: <linux-wireless@vger.kernel.org>
CC: <yanivma@ti.com>, Eliad Peller <eliad@wizery.com>,
	Eyal Reizer <eyalr@ti.com>
Subject: [PATCH 2/2] ARM: dts: am335x-evm: add wilink8 bluetooth support
Date: Thu, 30 Jul 2015 22:39:29 +0300
Message-ID: <1438285169-338-2-git-send-email-yanivma@ti.com> (sfid-20150730_215122_129230_80660E9A)
In-Reply-To: <1438285169-338-1-git-send-email-yanivma@ti.com>
References: <1438285169-338-1-git-send-email-yanivma@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

uart1 is used for shared transport (used for multiplexing
bluetooth and nfc data). add the needed muxes and definitions.

Signed-off-by: Eliad Peller <eliad@wizery.com>
Signed-off-by: Eyal Reizer <eyalr@ti.com>
---
 arch/arm/boot/dts/am335x-evm.dts |   29 +++++++++++++++++++++++++++++
 1 files changed, 29 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/am335x-evm.dts b/arch/arm/boot/dts/am335x-evm.dts
index b690674..a0a3f72 100644
--- a/arch/arm/boot/dts/am335x-evm.dts
+++ b/arch/arm/boot/dts/am335x-evm.dts
@@ -135,6 +135,18 @@
 		};
 	};
 
+	kim {
+		compatible = "kim";
+		nshutdown_gpio = <117>; /* Bank3, pin21 */
+		dev_name = "/dev/ttyO1";
+		flow_cntrl = <1>;
+		baud_rate = <3000000>;
+	};
+
+	btwilink {
+		compatible = "btwilink";
+	};
+
 	sound {
 		compatible = "ti,da830-evm-audio";
 		ti,model = "AM335x-EVM";
@@ -191,6 +203,16 @@
 		>;
 	};
 
+	uart1_pins: pinmux_uart1_pins {
+		pinctrl-single,pins = <
+			0x178 (PIN_INPUT | MUX_MODE0)			/* uart1_ctsn.uart1_ctsn */
+			0x17C (PIN_OUTPUT_PULLDOWN | MUX_MODE0)	/* uart1_rtsn.uart1_rtsn */
+			0x180 (PIN_INPUT_PULLUP | MUX_MODE0)	/* uart1_rxd.uart1_rxd */
+			0x184 (PIN_OUTPUT_PULLDOWN | MUX_MODE0) 	/* uart1_txd.uart1_txd */
+		>;
+	};
+
+
 	clkout2_pin: pinmux_clkout2_pin {
 		pinctrl-single,pins = <
 			0x1b4 (PIN_OUTPUT_PULLDOWN | MUX_MODE3)	/* xdma_event_intr1.clkout2 */
@@ -359,6 +381,13 @@
 	status = "okay";
 };
 
+&uart1 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&uart1_pins>;
+
+	status = "okay";
+};
+
 &i2c0 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&i2c0_pins>;
-- 
1.7.9

