Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:39339 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757041Ab3G3VQE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Jul 2013 17:16:04 -0400
From: Luciano Coelho <coelho@ti.com>
To: <tony@atomide.com>, <linux-omap@vger.kernel.org>
CC: <devicetree@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	<linux-wireless@vger.kernel.org>, <coelho@ti.com>,
	<luca@coelho.fi>, <balbi@ti.com>,
	<laurent.pinchart@ideasonboard.com>
Subject: [PATCH v2 2/4] arm: dts: omap4-panda-common: add WiLink6 device tree nodes
Date: Wed, 31 Jul 2013 00:15:21 +0300
Message-ID: <1375218923-29876-3-git-send-email-coelho@ti.com> (sfid-20130730_231610_657471_DFF2045E)
In-Reply-To: <1375218923-29876-1-git-send-email-coelho@ti.com>
References: <1375218923-29876-1-git-send-email-coelho@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add the WiLink device tree nodes.  On omap4-panda, a WiLink6 module is
connected on MMC5 and a GPIO interrupt is used.  The refclock
frequency is 38.4MHz.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 arch/arm/boot/dts/omap4-panda-common.dtsi | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/arm/boot/dts/omap4-panda-common.dtsi b/arch/arm/boot/dts/omap4-panda-common.dtsi
index b3f6e1f..59a797d 100644
--- a/arch/arm/boot/dts/omap4-panda-common.dtsi
+++ b/arch/arm/boot/dts/omap4-panda-common.dtsi
@@ -5,6 +5,7 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  */
+#include <dt-bindings/interrupt-controller/irq.h>
 #include "elpida_ecb240abacn.dtsi"
 
 / {
@@ -117,6 +118,20 @@
 		startup-delay-us = <70000>;
 		enable-active-high;
 	};
+
+	wlan {
+		compatible = "ti,wilink6";
+		interrupt-parent = <&gpio2>;
+		interrupts = <21 IRQ_TYPE_LEVEL_HIGH>;	/* gpio line 53 */
+		clocks = <&refclock>;
+		clock-names = "refclock";
+
+		refclock: refclock {
+			compatible = "ti,wilink-clock";
+			#clock-cells = <0>;
+			clock-frequency = <38400000>;
+		};
+	 };
 };
 
 &omap4_pmx_wkup {
-- 
1.8.3.2

