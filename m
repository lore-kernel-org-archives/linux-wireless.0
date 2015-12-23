Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:36992 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932816AbbLWFgG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Dec 2015 00:36:06 -0500
From: Raja Mani <rmani@qti.qualcomm.com>
To: <agross@codeaurora.org>, <devicetree@vger.kernel.org>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>,
	<mmcclint@qca.qualcomm.com>, Raja Mani <rmani@qti.qualcomm.com>
Subject: [PATCH] dt: bindings: add bindings for ipq4019 wifi block
Date: Wed, 23 Dec 2015 11:05:15 +0530
Message-ID: <1450848915-9772-1-git-send-email-rmani@qti.qualcomm.com> (sfid-20151223_063638_947928_28063248)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add device tree binding documentation details for wifi block present
in Qualcomm IPQ4019 SoC into qcom,ath10k.txt.

Signed-off-by: Raja Mani <rmani@qti.qualcomm.com>
---
 .../bindings/net/wireless/qcom,ath10k.txt          | 87 ++++++++++++++++++++--
 1 file changed, 82 insertions(+), 5 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
index edefc26..ffd0742 100644
--- a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
+++ b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
@@ -1,17 +1,42 @@
 * Qualcomm Atheros ath10k wireless devices
 
-For ath10k devices the calibration data can be provided through Device
-Tree. The node is a child node of the PCI controller.
-
 Required properties:
--compatible : Should be "qcom,ath10k"
+- compatible: Should be one of the following:
+	* "qcom,ath10k"
+	* "qcom,ipq4019-wifi"
 
 Optional properties:
+- reg: Address and length of the register set for the device.
+- core-id: Core number associated to the device.
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
+- qca,msi_addr: MSI interrupt address.
+- qca,msi_base: Base value to add before writing MSI data into
+		MSI address register.
 - qcom,ath10k-calibration-data : calibration data as an array, the
 				 length can vary between hw versions
+- status: Either "disabled" or "ok".
+
 
+Example (to supply the calibration data alone):
 
-Example:
+In this example, the node is defined as child node of the PCI controller.
 
 pci {
 	pcie@0 {
@@ -28,3 +53,55 @@ pci {
 		};
 	};
 };
+
+Example (to supply ipq4019 SoC wifi block details):
+
+wifi0: wifi@a000000 {
+	compatible = "qcom,ipq4019-wifi";
+	reg = <0xa000000 0x200000>;
+	core-id = <0x0>;
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
+	status = "ok";
+	qca,msi_addr = <0x0b006040>;
+	qca,msi_base = <0x40>;
+	qcom,ath10k-calibration-data = [ 01 02 03 ... ];
+};
-- 
1.8.1.2

