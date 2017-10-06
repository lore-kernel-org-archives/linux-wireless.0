Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:51141 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750849AbdJFLCy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 6 Oct 2017 07:02:54 -0400
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, devicetree@vger.kernel.org,
        Rob Herring <robh@kernel.org>
Subject: [PATCH v6 1/3] dt-bindings: net: add mt76 wireless device binding
Date: Fri,  6 Oct 2017 13:02:47 +0200
Message-Id: <20171006110249.31013-2-nbd@nbd.name> (sfid-20171006_130303_868789_4124CA70)
In-Reply-To: <20171006110249.31013-1-nbd@nbd.name>
References: <20171006110249.31013-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add documentation describing how device tree can be used to configure
wireless chips supported by the mt76 driver.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 .../bindings/net/wireless/mediatek,mt76.txt        | 24 ++++++++++++++++++++++
 1 file changed, 24 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/wireless/mediatek,mt76.txt

diff --git a/Documentation/devicetree/bindings/net/wireless/mediatek,mt76.txt b/Documentation/devicetree/bindings/net/wireless/mediatek,mt76.txt
new file mode 100644
index 000000000000..19522ab97d62
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/wireless/mediatek,mt76.txt
@@ -0,0 +1,24 @@
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
+&pcie {
+	status = "okay";
+
+	pcie0 {
+		wifi@0,0 {
+			reg = <0x0000 0 0 0 0>;
+			ieee80211-freq-limit = <5000000 6000000>;
+			mediatek,mtd-eeprom = <&factory 0x8000>;
+		};
+	};
+};
-- 
2.14.2
