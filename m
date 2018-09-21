Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50166 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725898AbeIUO52 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Sep 2018 10:57:28 -0400
From: Govind Singh <govinds@codeaurora.org>
To: ath10k@lists.infradead.org, robh+dt@kernel.org,
        andy.gross@linaro.org, devicetree@vger.kernel.org
Cc: linux-wireless@vger.kernel.org, briannorris@chromium.org,
        Govind Singh <govinds@codeaurora.org>
Subject: [PATCH 2/4] dts: arm64/sdm845: Add WCN3990 WLAN module device node
Date: Fri, 21 Sep 2018 14:39:05 +0530
Message-Id: <20180921090907.25937-3-govinds@codeaurora.org> (sfid-20180921_110936_260310_241D8902)
In-Reply-To: <20180921090907.25937-1-govinds@codeaurora.org>
References: <20180921090907.25937-1-govinds@codeaurora.org>
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add device node for the ath10k SNOC platform driver probe
and add resources required for WCN3990 on SDM845 soc.

Signed-off-by: Govind Singh <govinds@codeaurora.org>
---
 arch/arm64/boot/dts/qcom/sdm845-mtp.dts |  7 +++++++
 arch/arm64/boot/dts/qcom/sdm845.dtsi    | 25 +++++++++++++++++++++++++
 2 files changed, 32 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sdm845-mtp.dts b/arch/arm64/boot/dts/qcom/sdm845-mtp.dts
index eedfaf8922e2..4de57f7df93c 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-mtp.dts
+++ b/arch/arm64/boot/dts/qcom/sdm845-mtp.dts
@@ -440,3 +440,10 @@
 		bias-pull-up;
 	};
 };
+
+&wifi {
+	vdd-0.8-cx-mx-supply = <&vreg_l5a_0p8>;
+	vdd-1.8-xo-supply = <&vreg_l7a_1p8>;
+	vdd-1.3-rfa-supply = <&vreg_l17a_1p3>;
+	vdd-3.3-ch0-supply = <&vreg_l25a_3p3>;
+};
diff --git a/arch/arm64/boot/dts/qcom/sdm845.dtsi b/arch/arm64/boot/dts/qcom/sdm845.dtsi
index e080072cdfdb..b0b107641e74 100644
--- a/arch/arm64/boot/dts/qcom/sdm845.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845.dtsi
@@ -86,6 +86,11 @@
 			reg = <0 0x86200000 0 0x2d00000>;
 			no-map;
 		};
+
+		wlan_msa_mem: reserved-memory@96700000 {
+			no-map;
+			reg = <0 0x96700000 0 0x100000>;
+		};
 	};
 
 	cpus {
@@ -1200,5 +1205,25 @@
 				status = "disabled";
 			};
 		};
+
+		qcom,wifi {
+			compatible = "qcom,wcn3990-wifi";
+			reg = <0x18800000 0x800000>;
+			reg-names = "membase";
+			memory-region = <&wlan_msa_mem>;
+			interrupts =
+				<0 413 0 /* CE0 */ >,
+				<0 414 0 /* CE1 */ >,
+				<0 415 0 /* CE2 */ >,
+				<0 416 0 /* CE3 */ >,
+				<0 417 0 /* CE4 */ >,
+				<0 418 0 /* CE5 */ >,
+				<0 420 0 /* CE6 */ >,
+				<0 421 0 /* CE7 */ >,
+				<0 422 0 /* CE8 */ >,
+				<0 423 0 /* CE9 */ >,
+				<0 424 0 /* CE10 */ >,
+				<0 425 0 /* CE11 */ >;
+		};
 	};
 };
-- 
2.17.0
