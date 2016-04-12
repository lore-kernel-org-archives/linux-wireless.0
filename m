Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47903 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753237AbcDLD6k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Apr 2016 23:58:40 -0400
From: tamizhchelvam@codeaurora.org
To: agross@codeaurora.org, devicetree@vger.kernel.org
Cc: linux-arm-msm@vger.kernel.org, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org, ath10k@lists.infradead.org,
	c_traja@qti.qualcomm.com, Raja Mani <rmani@codeaurora.org>,
	Tamizh chelvam <tamizhchelvam@codeaurora.org>
Subject: [PATCH] qcom: ipq4019: add wifi nodes to ipq4019 SoC device tree
Date: Tue, 12 Apr 2016 09:31:46 +0530
Message-Id: <1460433706-21248-1-git-send-email-tamizhchelvam@codeaurora.org> (sfid-20160412_055855_559417_1B27F606)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Raja Mani <rmani@codeaurora.org>

Include dts support for two wifi block present on ipq4019 SoC.
Corresponding dt binding documentation has been added in below commit id
a47aaa69.

Signed-off-by: Tamizh chelvam <tamizhchelvam@codeaurora.org>
---
 arch/arm/boot/dts/qcom-ipq4019.dtsi |   98 +++++++++++++++++++++++++++++++++++
 1 file changed, 98 insertions(+)

diff --git a/arch/arm/boot/dts/qcom-ipq4019.dtsi b/arch/arm/boot/dts/qcom-ipq4019.dtsi
index b486859..80bbe02 100644
--- a/arch/arm/boot/dts/qcom-ipq4019.dtsi
+++ b/arch/arm/boot/dts/qcom-ipq4019.dtsi
@@ -379,5 +379,103 @@
 			compatible = "qcom,pshold";
 			reg = <0x4ab000 0x4>;
 		};
+
+		wifi0: wifi@a000000 {
+			compatible = "qcom,ipq4019-wifi";
+			reg = <0xa000000 0x200000>;
+			resets = <&gcc WIFI0_CPU_INIT_RESET>,
+				 <&gcc WIFI0_RADIO_SRIF_RESET>,
+				 <&gcc WIFI0_RADIO_WARM_RESET>,
+				 <&gcc WIFI0_RADIO_COLD_RESET>,
+				 <&gcc WIFI0_CORE_WARM_RESET>,
+				 <&gcc WIFI0_CORE_COLD_RESET>;
+			reset-names = "wifi_cpu_init",
+				      "wifi_radio_srif",
+				      "wifi_radio_warm",
+				      "wifi_radio_cold",
+				      "wifi_core_warm",
+				      "wifi_core_cold";
+			clocks = <&gcc GCC_WCSS2G_CLK>,
+				 <&gcc GCC_WCSS2G_REF_CLK>,
+				 <&gcc GCC_WCSS2G_RTC_CLK>;
+			clock-names = "wifi_wcss_cmd",
+				      "wifi_wcss_ref",
+				      "wifi_wcss_rtc";
+			interrupts = <0 0x20 0x1>,
+				     <0 0x21 0x1>,
+				     <0 0x22 0x1>,
+				     <0 0x23 0x1>,
+				     <0 0x24 0x1>,
+				     <0 0x25 0x1>,
+				     <0 0x26 0x1>,
+				     <0 0x27 0x1>,
+				     <0 0x28 0x1>,
+				     <0 0x29 0x1>,
+				     <0 0x2a 0x1>,
+				     <0 0x2b 0x1>,
+				     <0 0x2c 0x1>,
+				     <0 0x2d 0x1>,
+				     <0 0x2e 0x1>,
+				     <0 0x2f 0x1>,
+				     <0 0xa8 0x0>;
+			interrupt-names = "msi0",  "msi1",  "msi2",  "msi3",
+					  "msi4",  "msi5",  "msi6",  "msi7",
+					  "msi8",  "msi9",  "msi10", "msi11",
+					  "msi12", "msi13", "msi14", "msi15",
+					  "legacy";
+			status = "disabled";
+			qcom,msi_addr = <0x0b006040>;
+			qcom,msi_base = <0x40>;
+			qcom,ath10k-pre-calibration-data = [00];
+		};
+
+		wifi1: wifi@a800000 {
+			compatible = "qcom,ipq4019-wifi";
+			reg = <0xa800000 0x200000>;
+			resets = <&gcc WIFI1_CPU_INIT_RESET>,
+				 <&gcc WIFI1_RADIO_SRIF_RESET>,
+				 <&gcc WIFI1_RADIO_WARM_RESET>,
+				 <&gcc WIFI1_RADIO_COLD_RESET>,
+				 <&gcc WIFI1_CORE_WARM_RESET>,
+				 <&gcc WIFI1_CORE_COLD_RESET>;
+			reset-names = "wifi_cpu_init",
+				      "wifi_radio_srif",
+				      "wifi_radio_warm",
+				      "wifi_radio_cold",
+				      "wifi_core_warm",
+				      "wifi_core_cold";
+			clocks = <&gcc GCC_WCSS5G_CLK>,
+				 <&gcc GCC_WCSS5G_REF_CLK>,
+				 <&gcc GCC_WCSS5G_RTC_CLK>;
+			clock-names = "wifi_wcss_cmd",
+				      "wifi_wcss_ref",
+				      "wifi_wcss_rtc";
+			interrupts = <0 0x30 0x1>,
+				     <0 0x31 0x1>,
+				     <0 0x32 0x1>,
+				     <0 0x33 0x1>,
+				     <0 0x34 0x1>,
+				     <0 0x35 0x1>,
+				     <0 0x36 0x1>,
+				     <0 0x37 0x1>,
+				     <0 0x38 0x1>,
+				     <0 0x39 0x1>,
+				     <0 0x3a 0x1>,
+				     <0 0x3b 0x1>,
+				     <0 0x3c 0x1>,
+				     <0 0x3d 0x1>,
+				     <0 0x3e 0x1>,
+				     <0 0x3f 0x1>,
+				     <0 0xa9 0x0>;
+			interrupt-names = "msi0",  "msi1",  "msi2",  "msi3",
+					  "msi4",  "msi5",  "msi6",  "msi7",
+					  "msi8",  "msi9",  "msi10", "msi11",
+					  "msi12", "msi13", "msi14", "msi15",
+					  "legacy";
+			status = "disabled";
+			qcom,msi_addr = <0x0b006040>;
+			qcom,msi_base = <0x50>;
+			qcom,ath10k-pre-calibration-data = [00];
+		};
 	};
 };
-- 
1.7.9.5

