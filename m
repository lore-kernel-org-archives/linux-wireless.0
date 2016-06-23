Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:33123 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054AbcFWPNj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jun 2016 11:13:39 -0400
Received: by mail-wm0-f68.google.com with SMTP id r201so11767327wme.0
        for <linux-wireless@vger.kernel.org>; Thu, 23 Jun 2016 08:13:38 -0700 (PDT)
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To: ath9k-devel@qca.qualcomm.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org
Cc: nbd@nbd.name,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH 2/2] Documentation: dt: net: add ath9k wireless device binding
Date: Thu, 23 Jun 2016 17:13:28 +0200
Message-Id: <20160623151328.24061-3-martin.blumenstingl@googlemail.com> (sfid-20160623_171343_465804_87387785)
In-Reply-To: <20160623151328.24061-1-martin.blumenstingl@googlemail.com>
References: <20160623151328.24061-1-martin.blumenstingl@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add documentation how devicetree can be used to configure ath9k based
devices.

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 .../devicetree/bindings/net/wireless/ath,ath9k.txt | 40 ++++++++++++++++++++++
 1 file changed, 40 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/wireless/ath,ath9k.txt

diff --git a/Documentation/devicetree/bindings/net/wireless/ath,ath9k.txt b/Documentation/devicetree/bindings/net/wireless/ath,ath9k.txt
new file mode 100644
index 0000000..d6f5471
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/wireless/ath,ath9k.txt
@@ -0,0 +1,40 @@
+* Atheros ath9k wireless devices
+
+This node provides properties for configuring the ath9k wireless device. The
+node is expected to be specified as a child node of the PCI controller to
+which the wireless chip is connected.
+
+Required properties:
+- compatible: Should be "ath,ath9k"
+
+Optional properties:
+- reg: Address and length of the register set for the device.
+- ath,gpio-mask: The GPIO mask
+- ath,gpio-val: The GPIO value
+- ath,led-pin: The GPIO number to which the LED is connected
+- ath,led-active-high: The LED is active when the GPIO is HIGH
+- ath,clk-25mhz: Defines that at 25MHz clock is used
+- ath,eeprom-name: The name of the file which contains the EEPROM data (which
+			will be loaded via request_firmware)
+- ath,check-eeprom-endianness: Allow checking the EEPROM endianness and
+				swapping of the EEPROM data if required
+- ath,disable-2ghz: Disables the 2.4GHz band, even if enabled in the EEPROM
+- ath,disable-5ghz: Disables the 5GHz band, even if enabled in the EEPROM
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
+			reg = <0 0 0 0 0>;
+			device_type = "pci";
+			ath,disable-5ghz;
+		};
+	};
+};
-- 
2.9.0

