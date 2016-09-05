Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:57526 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932301AbcIEJvd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Sep 2016 05:51:33 -0400
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org
Subject: [PATCH v3 1/3] Documentation: dt: net: add mt76 wireless device binding
Date: Mon,  5 Sep 2016 11:51:26 +0200
Message-Id: <20160905095128.80560-2-nbd@nbd.name> (sfid-20160905_115141_952345_2697D471)
In-Reply-To: <20160905095128.80560-1-nbd@nbd.name>
References: <20160905095128.80560-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 .../bindings/net/wireless/mediatek,mt76.txt        | 26 ++++++++++++++++++++++
 1 file changed, 26 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/wireless/mediatek,mt76.txt

diff --git a/Documentation/devicetree/bindings/net/wireless/mediatek,mt76.txt b/Documentation/devicetree/bindings/net/wireless/mediatek,mt76.txt
new file mode 100644
index 0000000..d51c35f
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/wireless/mediatek,mt76.txt
@@ -0,0 +1,26 @@
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
+- mediatek,2ghz: Override the 2.4 GHz band capability from EEPROM
+- mediatek,5ghz: Override the 5 GHz band capability from EEPROM
+- mediatek,mtd-eeprom: Specify a MTD partition + offset containing EEPROM data
+
+&pcie {
+	status = "okay";
+
+	pcie0 {
+		mt76@0,0 {
+			reg = <0x0000 0 0 0 0>;
+			device_type = "pci";
+			mediatek,mtd-eeprom = <&factory 0x8000>;
+			mediatek,2ghz = <0>;
+		};
+	};
+};
-- 
2.8.4
