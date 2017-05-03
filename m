Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:34388 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752844AbdECOWv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 May 2017 10:22:51 -0400
From: Sebastian Reichel <sebastian.reichel@collabora.co.uk>
To: Sebastian Reichel <sre@kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Rob Herring <robh+dt@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: linux-bluetooth@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sebastian Reichel <sebastian.reichel@collabora.co.uk>
Subject: [PATCHv2 4/4] ARM: dts: omap4-droid4: Add bluetooth
Date: Wed,  3 May 2017 16:22:26 +0200
Message-Id: <20170503142226.32380-5-sebastian.reichel@collabora.co.uk> (sfid-20170503_162331_437225_F9D36EFB)
In-Reply-To: <20170503142226.32380-1-sebastian.reichel@collabora.co.uk>
References: <20170503142226.32380-1-sebastian.reichel@collabora.co.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Droid 4 has WL 1285C connected to the OMAP's UART4 port, which is
used for Bluetooth and most likely can also be used for controlling
the FM radio and GPS receivers.

Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.co.uk>
---
 arch/arm/boot/dts/omap4-droid4-xt894.dts | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/arch/arm/boot/dts/omap4-droid4-xt894.dts b/arch/arm/boot/dts/omap4-droid4-xt894.dts
index c09b51d6ccf7..bd7f1cc55371 100644
--- a/arch/arm/boot/dts/omap4-droid4-xt894.dts
+++ b/arch/arm/boot/dts/omap4-droid4-xt894.dts
@@ -453,6 +453,15 @@
 		OMAP4_IOPAD(0x1c8, PIN_INPUT_PULLUP | MUX_MODE7)
 		>;
 	};
+
+	uart4_pins: pinmux_uart4_pins {
+		pinctrl-single,pins = <
+		OMAP4_IOPAD(0x15c, PIN_INPUT | MUX_MODE0)		/* uart4_rx */
+		OMAP4_IOPAD(0x15e, PIN_OUTPUT | MUX_MODE0)		/* uart4_tx */
+		OMAP4_IOPAD(0x110, PIN_INPUT_PULLUP | MUX_MODE5)	/* uart4_cts */
+		OMAP4_IOPAD(0x112, PIN_OUTPUT_PULLUP | MUX_MODE5)	/* uart4_rts */
+		>;
+	};
 };
 
 &omap4_pmx_wkup {
@@ -469,6 +478,17 @@
 			       &omap4_pmx_core 0x17c>;
 };
 
+&uart4 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&uart4_pins>;
+
+	bluetooth {
+		compatible = "ti,wl1285-st";
+		enable-gpios = <&gpio6 14 GPIO_ACTIVE_HIGH>; /* gpio 174 */
+		max-speed = <3686400>;
+	};
+};
+
 &usbhsehci {
 	phys = <&hsusb1_phy>;
 };
-- 
2.11.0
