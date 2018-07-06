Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60864 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753177AbeGFJAv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 6 Jul 2018 05:00:51 -0400
From: Govind Singh <govinds@codeaurora.org>
To: devicetree@vger.kernel.org, bjorn.andersson@linaro.org,
        david.brown@linaro.org, andy.gross@linaro.org,
        niklas.cassel@linaro.org, ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Govind Singh <govinds@codeaurora.org>
Subject: [PATCH v3 3/6] dt: bindings: add bindings for msa memory region
Date: Fri,  6 Jul 2018 14:30:43 +0530
Message-Id: <20180706090043.28363-1-govinds@codeaurora.org> (sfid-20180706_110055_468259_F02DF7CB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add device tree binding documentation details of msa
memory region for ath10k qmi client for SDM845/APQ8098
SoC into "qcom,ath10k.txt".

Signed-off-by: Govind Singh <govinds@codeaurora.org>
---
 .../bindings/net/wireless/qcom,ath10k.txt           | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
index 7fd4e8ce4149..87489054aea5 100644
--- a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
+++ b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
@@ -57,6 +57,16 @@ Optional properties:
 - <supply-name>-supply: handle to the regulator device tree node
 			   optional "supply-name" is "vdd-0.8-cx-mx".
 
+= SUBNODES:
+wcn3990-wifi node may contain one subnode, named "msa" representing
+the fixed msa memory regions used by the wifi firmware running in Q6.
+This sub-node must contain:
+
+- memory-region:
+	Usage: required
+	Value type: <phandle>
+	Definition: reference to the reserved-memory for the region
+
 Example (to supply the calibration data alone):
 
 In this example, the node is defined as child node of the PCI controller.
@@ -149,4 +159,7 @@ wifi@18000000 {
 			   <0 140 0 /* CE10 */ >,
 			   <0 141 0 /* CE11 */ >;
 		vdd-0.8-cx-mx-supply = <&pm8998_l5>;
+		msa {
+			memory-region = <&wifi_msa_mem>;
+		};
 };
-- 
2.17.0
