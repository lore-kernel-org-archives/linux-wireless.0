Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50438 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725898AbeIUO5g (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Sep 2018 10:57:36 -0400
From: Govind Singh <govinds@codeaurora.org>
To: ath10k@lists.infradead.org, robh+dt@kernel.org,
        andy.gross@linaro.org, devicetree@vger.kernel.org
Cc: linux-wireless@vger.kernel.org, briannorris@chromium.org,
        Govind Singh <govinds@codeaurora.org>
Subject: [PATCH 4/4] dts: arm64/sdm845: Enable iommu for WCN3990 wifi module device node
Date: Fri, 21 Sep 2018 14:39:07 +0530
Message-Id: <20180921090907.25937-5-govinds@codeaurora.org> (sfid-20180921_110944_044959_95C353D8)
In-Reply-To: <20180921090907.25937-1-govinds@codeaurora.org>
References: <20180921090907.25937-1-govinds@codeaurora.org>
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

WCN3990 wifi module can optionally make use of the IOMMU.
Add phandle to the iommu and stream id of wifi iommu block.

Signed-off-by: Govind Singh <govinds@codeaurora.org>
---
 arch/arm64/boot/dts/qcom/sdm845.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/qcom/sdm845.dtsi b/arch/arm64/boot/dts/qcom/sdm845.dtsi
index b0b107641e74..5f5848cb1699 100644
--- a/arch/arm64/boot/dts/qcom/sdm845.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845.dtsi
@@ -1224,6 +1224,7 @@
 				<0 423 0 /* CE9 */ >,
 				<0 424 0 /* CE10 */ >,
 				<0 425 0 /* CE11 */ >;
+			iommus = <&apps_smmu 0x0040 0x1>;
 		};
 	};
 };
-- 
2.17.0
