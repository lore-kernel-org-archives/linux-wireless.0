Return-Path: <SRS0=oBLS=NQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5814BC0044C
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 13:08:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 15C292081D
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 13:08:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="loDNsaRA";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Jp/tSRfd"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 15C292081D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729689AbeKEW2d (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 5 Nov 2018 17:28:33 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:39626 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729228AbeKEW2d (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Nov 2018 17:28:33 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 3371061374; Mon,  5 Nov 2018 13:08:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541423331;
        bh=v/yCb6KJRhz5JTPTuGjIacBs0I1J8aW3YqhhGZNAjeA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=loDNsaRAejyigYp9z3MGhX5Www/Gj2eK0kpqocz59ZRWluHp5I4XAbSce0CY1q3kG
         QbBMOTAwfgNzZzmDnYRHOjt/9w4irv//jdXEegFx8RBEOGh5y+53BYQxNYv6Dn43qJ
         GIclMsE31Vq8Jsyyo8Ly2IGCWesnjTrxI/+OKzJI=
Received: from svishnoi-linux.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: govinds@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 9589A61317;
        Mon,  5 Nov 2018 13:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541423330;
        bh=v/yCb6KJRhz5JTPTuGjIacBs0I1J8aW3YqhhGZNAjeA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jp/tSRfd0XzBejazKIca12xkrKzjG1flm3BknXcwukpBhj/cAwMXRqAwXpWgmxezT
         uyd1YWZoOgA4QOMxvC24sUu+fJnYPWiO+GHoK5MACVF/jrZ6GRhc/L4Luj9eZvElVu
         k9c1e5PCPHjeV3lfQ3X1dR5x1xb7MRnNG4lupu1U=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 9589A61317
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=govinds@codeaurora.org
From:   Govind Singh <govinds@codeaurora.org>
To:     briannorris@chromium.org, andy.gross@linaro.org,
        ath10k@lists.infradead.org, devicetree@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-soc@vger.kernel.org,
        linux-wireless@vger.kernel.org, robh+dt@kernel.org,
        sboyd@kernel.org, dianders@chromium.org,
        linux-kernel@vger.kernel.org
Cc:     Govind Singh <govinds@codeaurora.org>
Subject: [PATCH v4 1/3] dt: bindings: add missing dt properties for WCN3990 wifi node
Date:   Mon,  5 Nov 2018 18:38:36 +0530
Message-Id: <1541423318-19312-2-git-send-email-govinds@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1541423318-19312-1-git-send-email-govinds@codeaurora.org>
References: <1541423318-19312-1-git-send-email-govinds@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Add missing optional properties in WCN3990 wifi node.

Signed-off-by: Govind Singh <govinds@codeaurora.org>
Reviewed-by: Rob Herring <robh@kernel.org>
Reviewed-by: Brian Norris <briannorris@chromium.org>
Tested-by: Brian Norris <briannorris@chromium.org>
---
 .../bindings/net/wireless/qcom,ath10k.txt          | 57 +++++++++++++---------
 1 file changed, 35 insertions(+), 22 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
index 7fd4e8c..55d255c 100644
--- a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
+++ b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
@@ -21,10 +21,22 @@ can be provided per device.
 
 SNOC based devices (i.e. wcn3990) uses compatible string "qcom,wcn3990-wifi".
 
-Optional properties:
 - reg: Address and length of the register set for the device.
 - reg-names: Must include the list of following reg names,
 	     "membase"
+- interrupts: reference to the list of 17 interrupt numbers for "qcom,ipq4019-wifi"
+	      compatible target.
+	      reference to the list of 12 interrupt numbers for "qcom,wcn3990-wifi"
+	      compatible target.
+	      Must contain interrupt-names property per entry for
+	      "qcom,ath10k", "qcom,ipq4019-wifi" compatible targets.
+
+- interrupt-names: Must include the entries for MSI interrupt
+		   names ("msi0" to "msi15") and legacy interrupt
+		   name ("legacy") for "qcom,ath10k", "qcom,ipq4019-wifi"
+		   compatible targets.
+
+Optional properties:
 - resets: Must contain an entry for each entry in reset-names.
           See ../reset/reseti.txt for details.
 - reset-names: Must include the list of following reset names,
@@ -37,12 +49,9 @@ Optional properties:
 - clocks: List of clock specifiers, must contain an entry for each required
           entry in clock-names.
 - clock-names: Should contain the clock names "wifi_wcss_cmd", "wifi_wcss_ref",
-               "wifi_wcss_rtc".
-- interrupts: List of interrupt lines. Must contain an entry
-	      for each entry in the interrupt-names property.
-- interrupt-names: Must include the entries for MSI interrupt
-		   names ("msi0" to "msi15") and legacy interrupt
-		   name ("legacy"),
+	       "wifi_wcss_rtc" for "qcom,ipq4019-wifi" compatible target and
+	       "cxo_ref_clk_pin" for "qcom,wcn3990-wifi"
+	       compatible target.
 - qcom,msi_addr: MSI interrupt address.
 - qcom,msi_base: Base value to add before writing MSI data into
 		MSI address register.
@@ -55,7 +64,8 @@ Optional properties:
 - qcom,ath10k-pre-calibration-data : pre calibration data as an array,
 				     the length can vary between hw versions.
 - <supply-name>-supply: handle to the regulator device tree node
-			   optional "supply-name" is "vdd-0.8-cx-mx".
+			   optional "supply-name" are "vdd-0.8-cx-mx",
+			   "vdd-1.8-xo", "vdd-1.3-rfa" and "vdd-3.3-ch0".
 
 Example (to supply the calibration data alone):
 
@@ -133,20 +143,23 @@ wifi@18000000 {
 		compatible = "qcom,wcn3990-wifi";
 		reg = <0x18800000 0x800000>;
 		reg-names = "membase";
-		clocks = <&clock_gcc clk_aggre2_noc_clk>;
-		clock-names = "smmu_aggre2_noc_clk"
+		clocks = <&clock_gcc clk_rf_clk2_pin>;
+		clock-names = "cxo_ref_clk_pin";
 		interrupts =
-			   <0 130 0 /* CE0 */ >,
-			   <0 131 0 /* CE1 */ >,
-			   <0 132 0 /* CE2 */ >,
-			   <0 133 0 /* CE3 */ >,
-			   <0 134 0 /* CE4 */ >,
-			   <0 135 0 /* CE5 */ >,
-			   <0 136 0 /* CE6 */ >,
-			   <0 137 0 /* CE7 */ >,
-			   <0 138 0 /* CE8 */ >,
-			   <0 139 0 /* CE9 */ >,
-			   <0 140 0 /* CE10 */ >,
-			   <0 141 0 /* CE11 */ >;
+			<GIC_SPI 414 IRQ_TYPE_LEVEL_HIGH>,
+			<GIC_SPI 415 IRQ_TYPE_LEVEL_HIGH>,
+			<GIC_SPI 416 IRQ_TYPE_LEVEL_HIGH>,
+			<GIC_SPI 417 IRQ_TYPE_LEVEL_HIGH>,
+			<GIC_SPI 418 IRQ_TYPE_LEVEL_HIGH>,
+			<GIC_SPI 419 IRQ_TYPE_LEVEL_HIGH>,
+			<GIC_SPI 420 IRQ_TYPE_LEVEL_HIGH>,
+			<GIC_SPI 421 IRQ_TYPE_LEVEL_HIGH>,
+			<GIC_SPI 422 IRQ_TYPE_LEVEL_HIGH>,
+			<GIC_SPI 423 IRQ_TYPE_LEVEL_HIGH>,
+			<GIC_SPI 424 IRQ_TYPE_LEVEL_HIGH>,
+			<GIC_SPI 425 IRQ_TYPE_LEVEL_HIGH>;
 		vdd-0.8-cx-mx-supply = <&pm8998_l5>;
+		vdd-1.8-xo-supply = <&vreg_l7a_1p8>;
+		vdd-1.3-rfa-supply = <&vreg_l17a_1p3>;
+		vdd-3.3-ch0-supply = <&vreg_l25a_3p3>;
 };
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

