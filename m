Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:34823 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933099AbcGIX2w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Jul 2016 19:28:52 -0400
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To: ath9k-devel@lists.ath9k.org, devicetree@vger.kernel.org,
	linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Cc: mcgrof@do-not-panic.com, galak@codeaurora.org,
	ijc+devicetree@hellion.org.uk, mark.rutland@arm.com,
	pawel.moll@arm.com, robh+dt@kernel.org, kvalo@codeaurora.org,
	chunkeey@googlemail.com, arend.vanspriel@broadcom.com,
	julian.calaby@gmail.com,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH v4 1/3] Documentation: dt: net: add ath9k wireless device binding
Date: Sun, 10 Jul 2016 01:28:32 +0200
Message-Id: <20160709232834.31654-2-martin.blumenstingl@googlemail.com> (sfid-20160710_012856_876612_BA5EFB05)
In-Reply-To: <20160709232834.31654-1-martin.blumenstingl@googlemail.com>
References: <20160624123430.4097-1-martin.blumenstingl@googlemail.com>
 <20160709232834.31654-1-martin.blumenstingl@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add documentation how devicetree can be used to configure ath9k based
devices.

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 .../devicetree/bindings/net/wireless/qca,ath9k.txt | 59 ++++++++++++++++++++++
 1 file changed, 59 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/wireless/qca,ath9k.txt

diff --git a/Documentation/devicetree/bindings/net/wireless/qca,ath9k.txt b/Documentation/devicetree/bindings/net/wireless/qca,ath9k.txt
new file mode 100644
index 0000000..7c62c59
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/wireless/qca,ath9k.txt
@@ -0,0 +1,59 @@
+* Qualcomm Atheros ath9k wireless devices
+
+This node provides properties for configuring the ath9k wireless device. The
+node is expected to be specified as a child node of the PCI controller to
+which the wireless chip is connected.
+
+Required properties:
+- compatible: Should be "qca,ath9k"
+
+Optional properties:
+- reg: Address and length of the register set for the device.
+- qca,clk-25mhz: Defines that a 25MHz clock is used
+- qca,no-eeprom: Indicates that there is no physical EEPROM connected to the
+			ath9k wireless chip (in this case the calibration /
+			EEPROM data will be loaded from userspace using the
+			kernel firmware loader).
+- qca,check-eeprom-endianness: When enabled, the driver checks if the
+				endianness of the EEPROM (based on the two
+				magic bytes at the start of the EEPROM)
+				matches the host system's native endianness.
+				The data will be swapped accordingly if there
+				is a mismatch.
+				Leaving this disabled means that the EEPROM
+				data will be interpreted in the system's
+				native endianness, regardless of the magic
+				bytes.
+				Enable this option only when the magic bytes
+				are known to indicate the correct endianness
+				of the EEPROM data, because otherwise the
+				EEPROM data may be swapped and thus may be
+				parsed incorrectly.
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
+			compatible = "qca,ath9k";
+			reg = <0 0 0 0 0>;
+			qca,disable-5ghz;
+		};
+	};
+};
-- 
2.9.0

