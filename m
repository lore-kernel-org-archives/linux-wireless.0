Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:57034 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751319AbdKUJu4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Nov 2017 04:50:56 -0500
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org
Subject: [PATCH v8 1/3] dt-bindings: net: add mt76 wireless device binding
Date: Tue, 21 Nov 2017 10:50:51 +0100
Message-Id: <20171121095053.82673-2-nbd@nbd.name> (sfid-20171121_105146_098103_C4287692)
In-Reply-To: <20171121095053.82673-1-nbd@nbd.name>
References: <20171121095053.82673-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add documentation describing how device tree can be used to configure
wireless chips supported by the mt76 driver.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 .../bindings/net/wireless/mediatek,mt76.txt        | 32 ++++++++++++++++++++++
 1 file changed, 32 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/wireless/mediatek,mt76.txt

diff --git a/Documentation/devicetree/bindings/net/wireless/mediatek,mt76.txt b/Documentation/devicetree/bindings/net/wireless/mediatek,mt76.txt
new file mode 100644
index 000000000000..0c17a0ec9b7b
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/wireless/mediatek,mt76.txt
@@ -0,0 +1,32 @@
+* MediaTek mt76xx devices
+
+This node provides properties for configuring the MediaTek mt76xx wireless
+device. The node is expected to be specified as a child node of the PCI
+controller to which the wireless chip is connected.
+
+Optional properties:
+
+- mac-address: See ethernet.txt in the parent directory
+- local-mac-address: See ethernet.txt in the parent directory
+- ieee80211-freq-limit: See ieee80211.txt
+- mediatek,mtd-eeprom: Specify a MTD partition + offset containing EEPROM data
+
+Optional nodes:
+- led: Properties for a connected LED
+  Optional properties:
+    - led-sources: See Documentation/devicetree/bindings/leds/common.txt
+
+&pcie {
+	pcie0 {
+		wifi@0,0 {
+			compatible = "mediatek,mt76";
+			reg = <0x0000 0 0 0 0>;
+			ieee80211-freq-limit = <5000000 6000000>;
+			mediatek,mtd-eeprom = <&factory 0x8000>;
+
+			led {
+				led-sources = <2>;
+			};
+		};
+	};
+};
-- 
2.14.2
