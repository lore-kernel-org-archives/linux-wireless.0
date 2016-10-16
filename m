Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:35646 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755640AbcJPU7p (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 16 Oct 2016 16:59:45 -0400
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To: ath9k-devel@lists.ath9k.org, devicetree@vger.kernel.org,
        linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
        robh+dt@kernel.org
Cc: mcgrof@do-not-panic.com, mark.rutland@arm.com,
        kvalo@codeaurora.org, chunkeey@googlemail.com,
        arend.vanspriel@broadcom.com, julian.calaby@gmail.com,
        bjorn@mork.no, linux@rempel-privat.de, nbd@nbd.name,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH v8 1/3] Documentation: dt: net: add ath9k wireless device binding
Date: Sun, 16 Oct 2016 22:59:05 +0200
Message-Id: <20161016205907.19927-2-martin.blumenstingl@googlemail.com> (sfid-20161016_225957_480323_FC8C1E52)
In-Reply-To: <20161016205907.19927-1-martin.blumenstingl@googlemail.com>
References: <20161002214743.2263-1-martin.blumenstingl@googlemail.com>
 <20161016205907.19927-1-martin.blumenstingl@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add documentation how devicetree can be used to configure ath9k based
devices.

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 .../devicetree/bindings/net/wireless/qca,ath9k.txt | 48 ++++++++++++++++++++++
 1 file changed, 48 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/wireless/qca,ath9k.txt

diff --git a/Documentation/devicetree/bindings/net/wireless/qca,ath9k.txt b/Documentation/devicetree/bindings/net/wireless/qca,ath9k.txt
new file mode 100644
index 0000000..b7396c8
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/wireless/qca,ath9k.txt
@@ -0,0 +1,48 @@
+* Qualcomm Atheros ath9k wireless devices
+
+This node provides properties for configuring the ath9k wireless device. The
+node is expected to be specified as a child node of the PCI controller to
+which the wireless chip is connected.
+
+Required properties:
+- compatible: For PCI and PCIe devices this should be an identifier following
+		the format as defined in "PCI Bus Binding to Open Firmware"
+		Revision 2.1. One of the possible formats is "pciVVVV,DDDD"
+		where VVVV is the PCI vendor ID and DDDD is PCI device ID.
+		Typically QCA's PCI vendor ID 168c is used while the PCI device
+		ID depends on the chipset - see the following (possibly
+		incomplete) list:
+			- 0023 for AR5416
+			- 0024 for AR5418
+			- 0027 for AR9160
+			- 0029 for AR9220 and AR9223
+			- 002a for AR9280 and AR9283
+			- 002b for AR9285
+			- 002c for AR2427
+			- 002d for AR9227
+			- 002e for AR9287
+			- 0030 for AR9380, AR9381 and AR9382
+			- 0032 for AR9485
+			- 0033 for AR9580 and AR9590
+			- 0034 for AR9462
+			- 0036 for AR9565
+			- 0037 for AR9485
+- reg: Address and length of the register set for the device.
+
+Optional properties:
+- qca,no-eeprom: Indicates that there is no physical EEPROM connected to the
+			ath9k wireless chip (in this case the calibration /
+			EEPROM data will be loaded from userspace using the
+			kernel firmware loader).
+- mac-address: See ethernet.txt in the parent directory
+- local-mac-address: See ethernet.txt in the parent directory
+
+
+In this example, the node is defined as child node of the PCI controller:
+&pci0 {
+	wifi@168c,002d {
+		compatible = "pci168c,002d";
+		reg = <0x7000 0 0 0 0x1000>;
+		qca,no-eeprom;
+	};
+};
-- 
2.10.0
