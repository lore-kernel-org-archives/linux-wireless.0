Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:55691 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957Ab3G3R2G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Jul 2013 13:28:06 -0400
From: Luciano Coelho <coelho@ti.com>
To: <tony@atomide.com>, <linux-omap@vger.kernel.org>
CC: <devicetree@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	<linux-wireless@vger.kernel.org>, <coelho@ti.com>,
	<luca@coelho.fi>, <balbi@ti.com>
Subject: [PATCH 2/4] arm: dts: omap4-panda-common: add WiLink6 device tree nodes
Date: Tue, 30 Jul 2013 20:27:26 +0300
Message-ID: <1375205248-25708-3-git-send-email-coelho@ti.com> (sfid-20130730_192811_295290_4E20BFAD)
In-Reply-To: <1375205248-25708-1-git-send-email-coelho@ti.com>
References: <1375205248-25708-1-git-send-email-coelho@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add the WiLink device tree nodes.  On omap4-panda, a WiLink6 module is
connected on MMC5 and a GPIO interrupt is used.  The refclock
frequency is 38.4MHz.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 arch/arm/boot/dts/omap4-panda-common.dtsi | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/arm/boot/dts/omap4-panda-common.dtsi b/arch/arm/boot/dts/omap4-panda-common.dtsi
index b3f6e1f..77e4a42 100644
--- a/arch/arm/boot/dts/omap4-panda-common.dtsi
+++ b/arch/arm/boot/dts/omap4-panda-common.dtsi
@@ -117,6 +117,20 @@
 		startup-delay-us = <70000>;
 		enable-active-high;
 	};
+
+	wlan {
+		compatible = "ti,wilink6";
+		interrupt-parent = <&gpio2>;
+		interrupts = <21 0x4>;	/* gpio line 53, high level triggered */
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

