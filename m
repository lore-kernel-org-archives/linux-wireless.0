Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:49592 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130AbcEYOF6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 May 2016 10:05:58 -0400
From: tamizhchelvam@codeaurora.org
To: agross@codeaurora.org, devicetree@vger.kernel.org
Cc: linux-arm-msm@vger.kernel.org, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org, ath10k@lists.infradead.org,
	c_traja@qti.qualcomm.com, linux-soc@vger.kernel.org,
	Raja Mani <rmani@codeaurora.org>,
	Tamizh chelvam <tamizhchelvam@codeaurora.org>
Subject: [PATCH v3] qcom: ipq4019: add wifi nodes to ipq4019 SoC device tree
Date: Wed, 25 May 2016 19:40:22 +0530
Message-Id: <1464185422-10760-1-git-send-email-tamizhchelvam@codeaurora.org> (sfid-20160525_160618_580861_942060D5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Raja Mani <rmani@codeaurora.org>

Include dts support for two wifi block present on ipq4019 SoC.
Corresponding dt binding documentation has been added in ath.git as below
commit id a47aaa69 and the commit message is
"dt: bindings: add new dt entry for pre calibration in qcom, ath10k.txt".

Signed-off-by: Raja Mani <rmani@codeaurora.org>
Signed-off-by: Tamizh chelvam <tamizhchelvam@codeaurora.org>
---
v3:

 - Removed msi properties(qcom,msi_addr, qcom,msi_base)

v2:

 - Fixed Commit log
 - Added new Signed off

 arch/arm/boot/dts/qcom-ipq4019.dtsi |   94 +++++++++++++++++++++++++++++++++++
 1 file changed, 94 insertions(+)

diff --git a/arch/arm/boot/dts/qcom-ipq4019.dtsi b/arch/arm/boot/dts/qcom-ipq4019.dtsi
index bfc0b57..ea7a787 100644
--- a/arch/arm/boot/dts/qcom-ipq4019.dtsi
+++ b/arch/arm/boot/dts/qcom-ipq4019.dtsi
@@ -393,5 +393,99 @@
 			clock-names = "core", "iface";
 			status = "disabled";
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
+				     <0 0xa9 0x1>;
+			interrupt-names = "msi0",  "msi1",  "msi2",  "msi3",
+					  "msi4",  "msi5",  "msi6",  "msi7",
+					  "msi8",  "msi9",  "msi10", "msi11",
+					  "msi12", "msi13", "msi14", "msi15",
+					  "legacy";
+			status = "disabled";
+			qcom,ath10k-pre-calibration-data = [00];
+		};
 	};
 };
-- 
1.7.9.5

