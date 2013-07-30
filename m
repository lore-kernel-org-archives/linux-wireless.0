Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:41839 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757358Ab3G3VQF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Jul 2013 17:16:05 -0400
From: Luciano Coelho <coelho@ti.com>
To: <tony@atomide.com>, <linux-omap@vger.kernel.org>
CC: <devicetree@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	<linux-wireless@vger.kernel.org>, <coelho@ti.com>,
	<luca@coelho.fi>, <balbi@ti.com>,
	<laurent.pinchart@ideasonboard.com>
Subject: [PATCH v2 4/4] arm: dts: omap4-sdp: add WiLink7 device tree node
Date: Wed, 31 Jul 2013 00:15:23 +0300
Message-ID: <1375218923-29876-5-git-send-email-coelho@ti.com> (sfid-20130730_231612_851169_0ED3F95F)
In-Reply-To: <1375218923-29876-1-git-send-email-coelho@ti.com>
References: <1375218923-29876-1-git-send-email-coelho@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add appropriate device tree node for Blaze's WiLink7 module.  It uses
a GPIO as interrupt, so configure the gpio2 node as interrupt parent
and assign the corresponding GPIO.  Additionally, add the clock
frequencies used by the module.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 arch/arm/boot/dts/omap4-sdp.dts | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/arch/arm/boot/dts/omap4-sdp.dts b/arch/arm/boot/dts/omap4-sdp.dts
index 3845615..63f1af1 100644
--- a/arch/arm/boot/dts/omap4-sdp.dts
+++ b/arch/arm/boot/dts/omap4-sdp.dts
@@ -7,6 +7,7 @@
  */
 /dts-v1/;
 
+#include <dt-bindings/interrupt-controller/irq.h>
 #include "omap443x.dtsi"
 #include "elpida_ecb240abacn.dtsi"
 
@@ -150,6 +151,26 @@
 		startup-delay-us = <70000>;
 		enable-active-high;
 	};
+
+	wlan {
+		compatible = "ti,wilink7";
+		interrupt-parent = <&gpio2>;
+		interrupts = <21 IRQ_TYPE_LEVEL_HIGH>;	/* gpio line 53 */
+		clocks = <&refclock &tcxoclock>;
+		clock-names = "refclock tcxoclock";
+
+		refclock: refclock {
+			compatible = "ti,wilink-clock";
+			#clock-cells = <0>;
+			clock-frequency = <26000000>;
+		};
+
+		tcxoclock: tcxoclock {
+			compatible = "ti,wilink-clock";
+			#clock-cells = <0>;
+			clock-frequency = <26000000>;
+		};
+	 };
 };
 
 &omap4_pmx_wkup {
-- 
1.8.3.2

