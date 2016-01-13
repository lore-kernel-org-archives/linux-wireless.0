Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:41580 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037AbcAMGAh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jan 2016 01:00:37 -0500
From: Raja Mani <rmani@qti.qualcomm.com>
To: <agross@codeaurora.org>, <devicetree@vger.kernel.org>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>,
	Raja Mani <rmani@qti.qualcomm.com>
Subject: [PATCH v3] dt: bindings: add bindings for ipq4019 wifi block
Date: Wed, 13 Jan 2016 11:26:44 +0530
Message-ID: <1452664604-8014-1-git-send-email-rmani@qti.qualcomm.com> (sfid-20160113_070117_288562_E559F608)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add device tree binding documentation details for wifi block present
in Qualcomm IPQ4019 SoC into "qcom,ath10k.txt".

Right now, ath10k wireless driver has support for PCI based wlan devices.
There is a plan to extend ath10k driver to support wifi devices which are
connected over AHB as well (enumeration will happen via device tree node).
For AHB based devices (ie, ipq4019), all wifi properties are supplied via
device tree (including irq, reg addr, cal data,etc).

Signed-off-by: Raja Mani <rmani@qti.qualcomm.com>
---
v3 changes:
  - Removed core-id - [Rob]
  - Documented which compatible string corresponds to pci devices
    and which corresponds to ahb devices. - [Rob]

v2 changes:
 - Improved "core-id" description - [Rob]
 - Removed "status" documentation - [Rob]
 - Added description which properties are applicable
   for ahb and which are applicable for pci devices - [Rob]
 - Improved commit msg to explain the context.
 - Renamed "qca,msi_addr" to "qcom,msi_addr" and
   "qca,msi_base" to "qcom,msi_base" to follow uniformity.

 .../bindings/net/wireless/qcom,ath10k.txt          | 89 ++++++++++++++++++++--
 1 file changed, 84 insertions(+), 5 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
index edefc26..bf8c0f8c 100644
--- a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
+++ b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
@@ -1,17 +1,46 @@
 * Qualcomm Atheros ath10k wireless devices
 
-For ath10k devices the calibration data can be provided through Device
-Tree. The node is a child node of the PCI controller.
-
 Required properties:
--compatible : Should be "qcom,ath10k"
+- compatible: Should be one of the following:
+	* "qcom,ath10k"
+	* "qcom,ipq4019-wifi"
+
+PCI based devices uses compatible string "qcom,ath10k" and takes only
+calibration data via "qcom,ath10k-calibration-data". Reset of the properties
+are not applicable for PCI based devices.
+
+AHB based devices (ie, ipq4019) uses compatible string "qcom,ipq4019-wifi"
+and also uses most of the properties defined in this doc.
 
 Optional properties:
+- reg: Address and length of the register set for the device.
+- resets: Must contain an entry for each entry in reset-names.
+          See ../reset/reseti.txt for details.
+- reset-names: Must include the list of following reset names,
+	       "wifi_cpu_init"
+	       "wifi_radio_srif"
+	       "wifi_radio_warm"
+	       "wifi_radio_cold"
+	       "wifi_core_warm"
+	       "wifi_core_cold"
+- clocks: List of clock specifiers, must contain an entry for each required
+          entry in clock-names.
+- clock-names: Should contain the clock names "wifi_wcss_cmd", "wifi_wcss_ref",
+               "wifi_wcss_rtc".
+- interrupts: List of interrupt lines. Must contain an entry
+	      for each entry in the interrupt-names property.
+- interrupt-names: Must include the entries for MSI interrupt
+		   names ("msi0" to "msi15") and legacy interrupt
+		   name ("legacy"),
+- qcom,msi_addr: MSI interrupt address.
+- qcom,msi_base: Base value to add before writing MSI data into
+		MSI address register.
 - qcom,ath10k-calibration-data : calibration data as an array, the
 				 length can vary between hw versions
 
+Example (to supply the calibration data alone):
 
-Example:
+In this example, the node is defined as child node of the PCI controller.
 
 pci {
 	pcie@0 {
@@ -28,3 +57,53 @@ pci {
 		};
 	};
 };
+
+Example (to supply ipq4019 SoC wifi block details):
+
+wifi0: wifi@a000000 {
+	compatible = "qcom,ipq4019-wifi";
+	reg = <0xa000000 0x200000>;
+	resets = <&gcc WIFI0_CPU_INIT_RESET>,
+		 <&gcc WIFI0_RADIO_SRIF_RESET>,
+		 <&gcc WIFI0_RADIO_WARM_RESET>,
+		 <&gcc WIFI0_RADIO_COLD_RESET>,
+		 <&gcc WIFI0_CORE_WARM_RESET>,
+		 <&gcc WIFI0_CORE_COLD_RESET>;
+	reset-names = "wifi_cpu_init",
+		      "wifi_radio_srif",
+		      "wifi_radio_warm",
+		      "wifi_radio_cold",
+		      "wifi_core_warm",
+		      "wifi_core_cold";
+	clocks = <&gcc GCC_WCSS2G_CLK>,
+		 <&gcc GCC_WCSS2G_REF_CLK>,
+		 <&gcc GCC_WCSS2G_RTC_CLK>;
+	clock-names = "wifi_wcss_cmd",
+		      "wifi_wcss_ref",
+		      "wifi_wcss_rtc";
+	interrupts = <0 0x20 0x1>,
+		     <0 0x21 0x1>,
+		     <0 0x22 0x1>,
+		     <0 0x23 0x1>,
+		     <0 0x24 0x1>,
+		     <0 0x25 0x1>,
+		     <0 0x26 0x1>,
+		     <0 0x27 0x1>,
+		     <0 0x28 0x1>,
+		     <0 0x29 0x1>,
+		     <0 0x2a 0x1>,
+		     <0 0x2b 0x1>,
+		     <0 0x2c 0x1>,
+		     <0 0x2d 0x1>,
+		     <0 0x2e 0x1>,
+		     <0 0x2f 0x1>,
+		     <0 0xa8 0x0>;
+	interrupt-names = "msi0",  "msi1",  "msi2",  "msi3",
+			  "msi4",  "msi5",  "msi6",  "msi7",
+			  "msi8",  "msi9",  "msi10", "msi11",
+			  "msi12", "msi13", "msi14", "msi15",
+			  "legacy";
+	qcom,msi_addr = <0x0b006040>;
+	qcom,msi_base = <0x40>;
+	qcom,ath10k-calibration-data = [ 01 02 03 ... ];
+};
-- 
1.8.1.2

