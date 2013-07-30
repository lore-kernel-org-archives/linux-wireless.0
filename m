Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:59434 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754889Ab3G3R2J (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Jul 2013 13:28:09 -0400
From: Luciano Coelho <coelho@ti.com>
To: <tony@atomide.com>, <linux-omap@vger.kernel.org>
CC: <devicetree@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	<linux-wireless@vger.kernel.org>, <coelho@ti.com>,
	<luca@coelho.fi>, <balbi@ti.com>
Subject: [PATCH 4/4] arm: dts: omap4-sdp: add WiLink7 device tree node
Date: Tue, 30 Jul 2013 20:27:28 +0300
Message-ID: <1375205248-25708-5-git-send-email-coelho@ti.com> (sfid-20130730_192818_738962_B5BD579A)
In-Reply-To: <1375205248-25708-1-git-send-email-coelho@ti.com>
References: <1375205248-25708-1-git-send-email-coelho@ti.com>
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
 arch/arm/boot/dts/omap4-sdp.dts | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/arch/arm/boot/dts/omap4-sdp.dts b/arch/arm/boot/dts/omap4-sdp.dts
index 3845615..2fecca1 100644
--- a/arch/arm/boot/dts/omap4-sdp.dts
+++ b/arch/arm/boot/dts/omap4-sdp.dts
@@ -150,6 +150,26 @@
 		startup-delay-us = <70000>;
 		enable-active-high;
 	};
+
+	wlan {
+		compatible = "ti,wilink7";
+		interrupt-parent = <&gpio2>;
+		interrupts = <21 0x4>;	/* gpio line 53, high level triggered */
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

