Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from p3plsmtpa06-10.prod.phx3.secureserver.net ([173.201.192.111]:40291
	"EHLO p3plsmtpa06-10.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932636AbaAaWR2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jan 2014 17:17:28 -0500
From: "Mark A. Greer" <mgreer@animalcreek.com>
To: Samuel Ortiz <sameo@linux.intel.com>,
	Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>
Cc: Felipe Balbi <balbi@ti.com>, Erick Macias <emacias@ti.com>,
	Thierry Escande <thierry.escande@linux.intel.com>,
	linux-wireless@vger.kernel.org, linux-nfc@lists.01.org,
	devicetree@vger.kernel.org,
	"Mark A. Greer" <mgreer@animalcreek.com>
Subject: [PATCH 3/3] NFC: trf7970a: Add DTS Documentation
Date: Fri, 31 Jan 2014 15:17:11 -0700
Message-Id: <1391206631-9862-4-git-send-email-mgreer@animalcreek.com> (sfid-20140131_231734_377661_B9216D11)
In-Reply-To: <1391206631-9862-1-git-send-email-mgreer@animalcreek.com>
References: <1391206631-9862-1-git-send-email-mgreer@animalcreek.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Describe the properies used by the trf7970a
RFID/NFC/15693 transceiver driver.

Signed-off-by: Mark A. Greer <mgreer@animalcreek.com>
---
 .../devicetree/bindings/net/nfc/trf7970a.txt       | 37 ++++++++++++++++++++++
 1 file changed, 37 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/nfc/trf7970a.txt

diff --git a/Documentation/devicetree/bindings/net/nfc/trf7970a.txt b/Documentation/devicetree/bindings/net/nfc/trf7970a.txt
new file mode 100644
index 0000000..4256893
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/nfc/trf7970a.txt
@@ -0,0 +1,37 @@
+* Texas Instruments TRF7970A RFID/NFC/15693 Transceiver
+
+Required properties:
+- compatible: Should be "ti,trf7970a".
+- spi-max-frequency: Maximum SPI frequency (<= 2000000).
+- interrupt-parent: phandle of parent interrupt handler.
+- interrupts: A single interrupt specifier.
+- ti,enable-gpios: Two GPIO entries used for 'EN' and 'EN2' pins on the
+  TRF7970A.
+
+Optional properties:
+- ti,ss-gpio: GPIO used for Slave Select pin on TRF7970A.  Its presence
+  indicates that "SPI with SS mode" is used by the TRF7970A.
+
+Optional SoC Specific Properties:
+- pinctrl-names: Contains only one value - "default".
+- pintctrl-0: Specifies the pin control groups used for this controller.
+
+Example (for ARM-based BeagleBone with TRF7970A on SPI1):
+
+&spi1 {
+        status = "okay";
+
+        nfc@0 {
+                compatible = "ti,trf7970a";
+                reg = <0>;
+                pinctrl-names = "default";
+                pinctrl-0 = <&trf7970a_default>;
+                spi-max-frequency = <2000000>;
+                interrupt-parent = <&gpio2>;
+                interrupts = <14 0>;
+                ti,enable-gpios = <&gpio2 2 GPIO_ACTIVE_LOW>,
+                                <&gpio2 5 GPIO_ACTIVE_LOW>;
+                ti,ss-gpio = <&gpio1 30 GPIO_ACTIVE_LOW>;
+                status = "okay";
+        };
+};
-- 
1.8.3.4

