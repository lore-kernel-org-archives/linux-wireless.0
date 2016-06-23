Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:35457 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751743AbcFWRpw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jun 2016 13:45:52 -0400
Received: by mail-wm0-f66.google.com with SMTP id a66so12814659wme.2
        for <linux-wireless@vger.kernel.org>; Thu, 23 Jun 2016 10:45:51 -0700 (PDT)
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To: ath9k-devel@qca.qualcomm.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org
Cc: nbd@nbd.name, chunkeey@googlemail.com, mark.rutland@arm.com,
	robh+dt@kernel.org,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH RFC v2 1/2] Documentation: dt: net: add ath9k wireless device binding
Date: Thu, 23 Jun 2016 19:45:35 +0200
Message-Id: <20160623174536.5967-2-martin.blumenstingl@googlemail.com> (sfid-20160623_194555_926658_B9C4E85C)
In-Reply-To: <20160623174536.5967-1-martin.blumenstingl@googlemail.com>
References: <20160623174536.5967-1-martin.blumenstingl@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add documentation how devicetree can be used to configure ath9k based
devices.

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
changes in v1 -> v2:
- use vendor prefix "qca" instead of "ath"
- extend the example so it includes the "compatible" property

 .../devicetree/bindings/net/wireless/qca,ath9k.txt | 41 ++++++++++++++++++++++
 1 file changed, 41 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/wireless/qca,ath9k.txt

diff --git a/Documentation/devicetree/bindings/net/wireless/qca,ath9k.txt b/Documentation/devicetree/bindings/net/wireless/qca,ath9k.txt
new file mode 100644
index 0000000..bb78f68
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/wireless/qca,ath9k.txt
@@ -0,0 +1,41 @@
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
+- qca,gpio-mask: The GPIO mask
+- qca,gpio-val: The GPIO value
+- qca,led-pin: The GPIO number to which the LED is connected
+- qca,led-active-high: The LED is active when the GPIO is HIGH
+- qca,clk-25mhz: Defines that at 25MHz clock is used
+- qca,eeprom-name: The name of the file which contains the EEPROM data (which
+			will be loaded via request_firmware)
+- qca,check-eeprom-endianness: Allow checking the EEPROM endianness and
+				swapping of the EEPROM data if required
+- qca,disable-2ghz: Disables the 2.4GHz band, even if enabled in the EEPROM
+- qca,disable-5ghz: Disables the 5GHz band, even if enabled in the EEPROM
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
+			device_type = "pci";
+			qca,disable-5ghz;
+		};
+	};
+};
-- 
2.9.0

