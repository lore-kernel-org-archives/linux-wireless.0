Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:32871 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756046AbbCRQiq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Mar 2015 12:38:46 -0400
Received: by weop45 with SMTP id p45so36859756weo.0
        for <linux-wireless@vger.kernel.org>; Wed, 18 Mar 2015 09:38:45 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: <linux-wireless@vger.kernel.org>, <devicetree@vger.kernel.org>,
	<linux-omap@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>,
	=?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>,
	Tony Lindgren <tony@atomide.com>,
	Enric Balletbo i Serra <eballetbo@gmail.com>,
	Javier Martinez Canillas <javier@dowhile0.org>,
	Sekhar Nori <nsekhar@ti.com>,
	Kevin Hilman <khilman@deeprootsystems.com>
Subject: [PATCH v7 3/6] dt: bindings: add TI's wilink wireless device
Date: Wed, 18 Mar 2015 18:38:27 +0200
Message-Id: <1426696710-6891-4-git-send-email-eliad@wizery.com> (sfid-20150318_173856_885891_C300B719)
In-Reply-To: <1426696710-6891-1-git-send-email-eliad@wizery.com>
References: <1426696710-6891-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add device tree binding documentation for TI's wilink
(wl12xx and wl18xx) wlan chip.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 .../devicetree/bindings/net/wireless/ti,wlcore.txt | 47 ++++++++++++++++++++++
 1 file changed, 47 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/wireless/ti,wlcore.txt

diff --git a/Documentation/devicetree/bindings/net/wireless/ti,wlcore.txt b/Documentation/devicetree/bindings/net/wireless/ti,wlcore.txt
new file mode 100644
index 0000000..2a3d90d
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/wireless/ti,wlcore.txt
@@ -0,0 +1,47 @@
+TI Wilink 6/7/8 (wl12xx/wl18xx) SDIO devices
+
+This node provides properties for controlling the wilink wireless device. The
+node is expected to be specified as a child node to the SDIO controller that
+connects the device to the system.
+
+Required properties:
+ - compatible: should be one of the following:
+    * "ti,wl1271"
+    * "ti,wl1273"
+    * "ti,wl1281"
+    * "ti,wl1283"
+    * "ti,wl1801"
+    * "ti,wl1805"
+    * "ti,wl1807"
+    * "ti,wl1831"
+    * "ti,wl1835"
+    * "ti,wl1837"
+ - interrupts : specifies attributes for the out-of-band interrupt.
+
+Optional properties:
+ - interrupt-parent : the phandle for the interrupt controller to which the
+	device interrupts are connected.
+ - ref-clock-frequency : ref clock frequency in Hz
+ - tcxo-clock-frequency : tcxo clock frequency in Hz
+
+Note: the *-clock-frequency properties assume internal clocks. In case of external
+clock, new bindings (for parsing the clock nodes) have to be added.
+
+Example:
+
+&mmc3 {
+	status = "okay";
+	vmmc-supply = <&wlan_en_reg>;
+	bus-width = <4>;
+	cap-power-off-card;
+	keep-power-in-suspend;
+
+	#address-cells = <1>;
+	#size-cells = <0>;
+	wlcore: wlcore@2 {
+		compatible = "ti,wl1835";
+		reg = <2>;
+		interrupt-parent = <&gpio0>;
+		interrupts = <19 IRQ_TYPE_LEVEL_HIGH>;
+	};
+};
-- 
1.8.5.2.229.g4448466.dirty

