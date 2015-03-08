Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:33233 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752431AbbCHN2Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Mar 2015 09:28:25 -0400
Received: by widfb4 with SMTP id fb4so3366027wid.0
        for <linux-wireless@vger.kernel.org>; Sun, 08 Mar 2015 06:28:24 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: <linux-wireless@vger.kernel.org>, <devicetree@vger.kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v4 1/2] dt: bindings: add wl18xx wireless device
Date: Sun,  8 Mar 2015 15:28:16 +0200
Message-Id: <1425821297-3134-1-git-send-email-eliad@wizery.com> (sfid-20150308_142836_811750_F8450847)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add device tree binding documentation for TI's wl18xx
wlan chip.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
v4: use specific wl18xx model numbers (Arnd)

 .../devicetree/bindings/net/wireless/ti,wl18xx.txt | 39 ++++++++++++++++++++++
 1 file changed, 39 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/wireless/ti,wl18xx.txt

diff --git a/Documentation/devicetree/bindings/net/wireless/ti,wl18xx.txt b/Documentation/devicetree/bindings/net/wireless/ti,wl18xx.txt
new file mode 100644
index 0000000..9dcf535
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/wireless/ti,wl18xx.txt
@@ -0,0 +1,39 @@
+TI Wilink8 (wl18xx) SDIO devices
+
+This node provides properties for controlling the wilink8 wireless device. The
+node is expected to be specified as a child node to the SDIO controller that
+connects the device to the system.
+
+Required properties:
+ - compatible : Should be "ti,wl18xx".
+ - compatible: should be one of the following:
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
+		interrupts = <19 IRQ_TYPE_NONE>;
+	};
+};
-- 
1.8.5.2.229.g4448466.dirty

