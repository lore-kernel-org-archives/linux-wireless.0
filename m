Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40994 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388998AbeGWNfy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Jul 2018 09:35:54 -0400
From: Govind Singh <govinds@codeaurora.org>
To: niklas.cassel@linaro.org, bjorn.andersson@linaro.org,
        david.brown@linaro.org, andy.gross@linaro.org, robh@kernel.org,
        devicetree@vger.kernel.org, ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Govind Singh <govinds@codeaurora.org>
Subject: [PATCH v4 3/6] dt: bindings: add bindings for msa memory region
Date: Mon, 23 Jul 2018 18:04:25 +0530
Message-Id: <20180723123428.12993-4-govinds@codeaurora.org> (sfid-20180723_143532_739088_3379CF82)
In-Reply-To: <20180723123428.12993-1-govinds@codeaurora.org>
References: <20180723123428.12993-1-govinds@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add device tree binding documentation details of msa
memory region for ath10k qmi client for SDM845/APQ8098
SoC into "qcom,ath10k.txt".

Signed-off-by: Govind Singh <govinds@codeaurora.org>
---
 .../devicetree/bindings/net/wireless/qcom,ath10k.txt        | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
index 7fd4e8ce4149..2196d1ab3c8c 100644
--- a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
+++ b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
@@ -56,6 +56,11 @@ Optional properties:
 				     the length can vary between hw versions.
 - <supply-name>-supply: handle to the regulator device tree node
 			   optional "supply-name" is "vdd-0.8-cx-mx".
+- memory-region:
+	Usage: optional
+	Value type: <phandle>
+	Definition: reference to the reserved-memory for the msa region
+		    used by the wifi firmware running in Q6.
 
 Example (to supply the calibration data alone):
 
@@ -149,4 +154,5 @@ wifi@18000000 {
 			   <0 140 0 /* CE10 */ >,
 			   <0 141 0 /* CE11 */ >;
 		vdd-0.8-cx-mx-supply = <&pm8998_l5>;
+		memory-region = <&wifi_msa_mem>;
 };
-- 
2.17.0
