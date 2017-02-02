Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:57101 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751377AbdBBLwL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 2 Feb 2017 06:52:11 -0500
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, devicetree@vger.kernel.org
Subject: [PATCH v4 1/3] Documentation: dt: net: add mt76 wireless device binding
Date: Thu,  2 Feb 2017 12:52:06 +0100
Message-Id: <20170202115208.8614-2-nbd@nbd.name> (sfid-20170202_125215_676631_DCC7FF9B)
In-Reply-To: <20170202115208.8614-1-nbd@nbd.name>
References: <20170202115208.8614-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 .../bindings/net/wireless/mediatek,mt76.txt        | 25 ++++++++++++++++++++++
 1 file changed, 25 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/wireless/mediatek,mt76.txt

diff --git a/Documentation/devicetree/bindings/net/wireless/mediatek,mt76.txt b/Documentation/devicetree/bindings/net/wireless/mediatek,mt76.txt
new file mode 100644
index 000000000000..2be480c0eab8
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/wireless/mediatek,mt76.txt
@@ -0,0 +1,25 @@
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
+		mt76@0,0 {
+			reg = <0x0000 0 0 0 0>;
+			device_type = "pci";
+			ieee80211-freq-limit = <5000000 6000000>;
+			mediatek,mtd-eeprom = <&factory 0x8000>;
+		};
+	};
+};
-- 
2.11.0
