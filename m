Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:32840 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355AbcFXMe7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jun 2016 08:34:59 -0400
Received: by mail-wm0-f65.google.com with SMTP id r201so4641488wme.0
        for <linux-wireless@vger.kernel.org>; Fri, 24 Jun 2016 05:34:59 -0700 (PDT)
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To: ath9k-devel@qca.qualcomm.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org
Cc: nbd@nbd.name, chunkeey@googlemail.com, mark.rutland@arm.com,
	robh+dt@kernel.org, arend.vanspriel@broadcom.com,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH RFC v3 1/3] Documentation: dt: net: add ath9k wireless device binding
Date: Fri, 24 Jun 2016 14:34:28 +0200
Message-Id: <20160624123430.4097-2-martin.blumenstingl@googlemail.com> (sfid-20160624_143504_890300_FF9B036B)
In-Reply-To: <20160624123430.4097-1-martin.blumenstingl@googlemail.com>
References: <20160624123430.4097-1-martin.blumenstingl@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add documentation how devicetree can be used to configure ath9k based
devices.

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
changes in v2 -> v3:
- improved wording of the qca,disable-2ghz and qca,disable-5ghz properties
- replaced qca,eeprom-name with qca,no-eeprom (the eeprom name is now
  built automatically within ath9k). The naming was chosen to stay
  consistent with other drivers (such as davicom-dm9000 and via-velocity)
- added reference to the mac-address and local-mac-address properties
- removed invalid device_type property from the example

 .../devicetree/bindings/net/wireless/qca,ath9k.txt | 46 ++++++++++++++++++++++
 1 file changed, 46 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/wireless/qca,ath9k.txt

diff --git a/Documentation/devicetree/bindings/net/wireless/qca,ath9k.txt b/Documentation/devicetree/bindings/net/wireless/qca,ath9k.txt
new file mode 100644
index 0000000..ff83fd4
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/wireless/qca,ath9k.txt
@@ -0,0 +1,46 @@
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
+- qca,no-eeprom: Indicates that there is on physical EEPROM connected
+			to the ath9k wireless chip (in this case the
+			calibration / EEPROM data will be loaded from
+			userspace using the firmware mechanism)
+- qca,check-eeprom-endianness: Allow checking the EEPROM endianness and
+				swapping of the EEPROM data if required
+- qca,disable-2ghz: Overrides the settings from the EEPROM and disables
+			the 2.4GHz band, even if enabled in the EEPROM
+- qca,disable-5ghz: Overrides the settings from the EEPROM and disables
+			the 5GHz band, even if enabled in the EEPROM
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

