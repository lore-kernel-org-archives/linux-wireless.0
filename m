Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:36016 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754823AbeBOI4v (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Feb 2018 03:56:51 -0500
From: Govind Singh <govinds@codeaurora.org>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
        Govind Singh <govinds@codeaurora.org>
Subject: [PATCH 13/13] dt: bindings: add bindings for wcn3990 wifi block
Date: Thu, 15 Feb 2018 14:26:17 +0530
Message-Id: <1518684977-14607-1-git-send-email-govinds@codeaurora.org> (sfid-20180215_095655_476540_20C3438C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add device tree binding documentation details for wcn3990
wifi block present in Qualcomm SDM845/APQ8098 SoC into
"qcom,ath10k.txt".

Signed-off-by: Govind Singh <govinds@codeaurora.org>
---
 .../bindings/net/wireless/qcom,ath10k.txt          | 35 ++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
index 3d2a031..07b0f13 100644
--- a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
+++ b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
@@ -4,6 +4,7 @@ Required properties:
 - compatible: Should be one of the following:
 	* "qcom,ath10k"
 	* "qcom,ipq4019-wifi"
+	* "qcom,wcn3990-wifi"
 
 PCI based devices uses compatible string "qcom,ath10k" and takes calibration
 data along with board specific data via "qcom,ath10k-calibration-data".
@@ -18,8 +19,11 @@ In general, entry "qcom,ath10k-pre-calibration-data" and
 "qcom,ath10k-calibration-data" conflict with each other and only one
 can be provided per device.
 
+SNOC based devices (i.e. wcn3990) uses compatible string "qcom,wcn3990-wifi".
+
 Optional properties:
 - reg: Address and length of the register set for the device.
+- reg-names: Names of the memory regions defined in reg entry.
 - resets: Must contain an entry for each entry in reset-names.
           See ../reset/reseti.txt for details.
 - reset-names: Must include the list of following reset names,
@@ -49,6 +53,12 @@ Optional properties:
 				 hw versions.
 - qcom,ath10k-pre-calibration-data : pre calibration data as an array,
 				     the length can vary between hw versions.
+- qcom,<supply-name>-supply: handle to the regulator device tree node
+			   optional "supply-name" is "vdd-0.8-cx-mx".
+- qcom,<supply>-config: Specifies voltage levels for supply. Should be
+			  specified in pairs (min, max), units uV.  There can
+			   be optional load in uA and Regulator settle delay in
+			   uS.
 
 Example (to supply the calibration data alone):
 
@@ -119,3 +129,28 @@ wifi0: wifi@a000000 {
 	qcom,msi_base = <0x40>;
 	qcom,ath10k-pre-calibration-data = [ 01 02 03 ... ];
 };
+
+Example (to supply wcn3990 SoC wifi block details):
+
+qcom,msm_ath10k@18000000 {
+		compatible = "qcom,wcn3990-wifi";
+		reg = <0x18800000 0x800000>;
+		reg-names = "membase";
+		clocks = <&clock_gcc clk_aggre2_noc_clk>;
+		clock-names = "smmu_aggre2_noc_clk"
+		interrupts =
+			   <0 130 0 /* CE0 */ >,
+			   <0 131 0 /* CE1 */ >,
+			   <0 132 0 /* CE2 */ >,
+			   <0 133 0 /* CE3 */ >,
+			   <0 134 0 /* CE4 */ >,
+			   <0 135 0 /* CE5 */ >,
+			   <0 136 0 /* CE6 */ >,
+			   <0 137 0 /* CE7 */ >,
+			   <0 138 0 /* CE8 */ >,
+			   <0 139 0 /* CE9 */ >,
+			   <0 140 0 /* CE10 */ >,
+			   <0 141 0 /* CE11 */ >;
+		vdd-0.8-cx-mx-supply = <&pm8998_l5>;
+		qcom,vdd-0.8-cx-mx-config = <800000 800000 2400 1000>;
+};
-- 
1.9.1
