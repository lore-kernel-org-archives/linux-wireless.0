Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:59387 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010AbbBSQN0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Feb 2015 11:13:26 -0500
Received: by mail-wg0-f47.google.com with SMTP id x12so8162671wgg.6
        for <linux-wireless@vger.kernel.org>; Thu, 19 Feb 2015 08:13:25 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: <linux-wireless@vger.kernel.org>, <devicetree@vger.kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH v3 1/2] dt: bindings: add wl18xx wireless device
Date: Thu, 19 Feb 2015 18:13:20 +0200
Message-Id: <1424362401-8228-1-git-send-email-eliad@wizery.com> (sfid-20150219_171329_730644_AFB82E1A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add device tree binding documentation for TI's wl18xx
wlan chip.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
v3:
 * make the bindings device-specific (wl18xx) (Arnd, Mark)
 * split bindings and driver changes (Arnd)
 * make interrupt-parent optional (Arnd)
 * make unit-address same as reg (Mark)

 .../devicetree/bindings/net/wireless/ti,wl18xx.txt | 32 ++++++++++++++++++++++
 1 file changed, 32 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/wireless/ti,wl18xx.txt

diff --git a/Documentation/devicetree/bindings/net/wireless/ti,wl18xx.txt b/Documentation/devicetree/bindings/net/wireless/ti,wl18xx.txt
new file mode 100644
index 0000000..8120a81
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/wireless/ti,wl18xx.txt
@@ -0,0 +1,32 @@
+TI Wilink8 (wl18xx) SDIO devices
+
+This node provides properties for controlling the wilink8 wireless device. The
+node is expected to be specified as a child node to the SDIO controller that
+connects the device to the system.
+
+Required properties:
+ - compatible : Should be "ti,wl18xx".
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
+		compatible = "ti,wl18xx";
+		reg = <2>;
+		interrupt-parent = <&gpio0>;
+		interrupts = <19 IRQ_TYPE_NONE>;
+	};
+};
-- 
1.8.5.1.109.g3d252a9

