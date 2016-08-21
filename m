Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:33221 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752877AbcHUObZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 21 Aug 2016 10:31:25 -0400
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To: ath9k-devel@lists.ath9k.org, devicetree@vger.kernel.org,
        linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Cc: mcgrof@do-not-panic.com, mark.rutland@arm.com, robh+dt@kernel.org,
        kvalo@codeaurora.org, chunkeey@googlemail.com,
        arend.vanspriel@broadcom.com, julian.calaby@gmail.com,
        bjorn@mork.no, linux@rempel-privat.de,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH v5 1/3] Documentation: dt: net: add ath9k wireless device binding
Date: Sun, 21 Aug 2016 16:31:03 +0200
Message-Id: <20160821143105.27487-2-martin.blumenstingl@googlemail.com> (sfid-20160821_163130_555149_93CF6974)
In-Reply-To: <20160821143105.27487-1-martin.blumenstingl@googlemail.com>
References: <20160709232834.31654-1-martin.blumenstingl@googlemail.com>
 <20160821143105.27487-1-martin.blumenstingl@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add documentation how devicetree can be used to configure ath9k based
devices.

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 .../devicetree/bindings/net/wireless/qca,ath9k.txt | 47 ++++++++++++++++++++++
 1 file changed, 47 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/wireless/qca,ath9k.txt

diff --git a/Documentation/devicetree/bindings/net/wireless/qca,ath9k.txt b/Documentation/devicetree/bindings/net/wireless/qca,ath9k.txt
new file mode 100644
index 0000000..98065ad
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/wireless/qca,ath9k.txt
@@ -0,0 +1,47 @@
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
+
+Optional properties:
+- reg: Address and length of the register set for the device.
+- qca,clk-25mhz: Defines that a 25MHz clock is used
+- qca,no-eeprom: Indicates that there is no physical EEPROM connected to the
+			ath9k wireless chip (in this case the calibration /
+			EEPROM data will be loaded from userspace using the
+			kernel firmware loader).
+- qca,disable-2ghz: Overrides the settings from the EEPROM and disables the
+			2.4GHz band. Setting this property is only needed
+			when the RF circuit does not support the 2.4GHz band
+			while it is enabled nevertheless in the EEPROM.
+- qca,disable-5ghz: Overrides the settings from the EEPROM and disables the
+			5GHz band. Setting this property is only needed when
+			the RF circuit does not support the 5GHz band while
+			it is enabled nevertheless in the EEPROM.
+- mac-address: See ethernet.txt in the parent directory
+- local-mac-address: See ethernet.txt in the parent directory
+
+In this example, the node is defined as child node of the PCI controller.
+
+pci {
+	pcie@0 {
+		reg = <0 0 0 0 0>;
+		#interrupt-cells = <1>;
+		#size-cells = <2>;
+		#address-cells = <3>;
+		device_type = "pci";
+
+		ath9k@0,0 {
+			compatible = "pci168c,0030";
+			reg = <0 0 0 0 0>;
+			qca,disable-5ghz;
+		};
+	};
+};
-- 
2.9.3
