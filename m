Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50302 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725898AbeIUO5b (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Sep 2018 10:57:31 -0400
From: Govind Singh <govinds@codeaurora.org>
To: ath10k@lists.infradead.org, robh+dt@kernel.org,
        andy.gross@linaro.org, devicetree@vger.kernel.org
Cc: linux-wireless@vger.kernel.org, briannorris@chromium.org,
        Govind Singh <govinds@codeaurora.org>
Subject: [PATCH 3/4] dt: bindings: add bindings for wifi iommu node
Date: Fri, 21 Sep 2018 14:39:06 +0530
Message-Id: <20180921090907.25937-4-govinds@codeaurora.org> (sfid-20180921_110939_123639_EF2C7ED9)
In-Reply-To: <20180921090907.25937-1-govinds@codeaurora.org>
References: <20180921090907.25937-1-govinds@codeaurora.org>
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

WCN3990 wifi module can optionally make use of the IOMMU.
Add binding documentation for phandle to the IOMMU and
the stream id of wifi iommu block.

Signed-off-by: Govind Singh <govinds@codeaurora.org>
---
 .../devicetree/bindings/net/wireless/qcom,ath10k.txt         | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
index 22dea7d83ee8..07e58008c665 100644
--- a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
+++ b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
@@ -59,6 +59,10 @@ Optional properties:
 - <supply-name>-supply: handle to the regulator device tree node
 			   optional "supply-name" are "vdd-0.8-cx-mx",
 			   "vdd-1.8-xo", "vdd-1.3-rfa" and "vdd-3.3-ch0".
+- iommus:
+	Usage: optional
+	Value type: <prop-encoded-array>
+	Definition: A list of phandle and IOMMU specifier pairs.
 
 Example (to supply the calibration data alone):
 
@@ -157,4 +161,5 @@ wifi@18000000 {
 		vdd-1.8-xo-supply = <&vreg_l7a_1p8>;
 		vdd-1.3-rfa-supply = <&vreg_l17a_1p3>;
 		vdd-3.3-ch0-supply = <&vreg_l25a_3p3>;
+		iommus = <&apps_smmu 0x0040 0x1>;
 };
-- 
2.17.0
