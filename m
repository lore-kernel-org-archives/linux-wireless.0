Return-Path: <SRS0=yLyd=MW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8DCDC43441
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Oct 2018 11:53:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9C5202087A
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Oct 2018 11:53:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="AIfRoslR";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="c6iAbJii"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9C5202087A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726728AbeJJTPH (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 10 Oct 2018 15:15:07 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:49122 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726503AbeJJTPH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Oct 2018 15:15:07 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 6028560C7B; Wed, 10 Oct 2018 11:53:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539172398;
        bh=GD+z6ixks+DViOvtODI+xBI0pwT2Z6kHiAT5fNfuEyc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AIfRoslR6NIzJoy7vI7hv5Pnfg1eLE9Z8fJtpcyS+mLPD1p6wqq9GbQ+ieQGsiyiX
         BwFk6TQE/h6iWk1sxsfcKDe1Dcvafv8n9lMN/XuBombzs3xVfbO1LkplJ0IqxP/YON
         C3MNGgD54DwZg/BXFhJRL6u+Fx8iPXa9W2RLwsus=
Received: from svishnoi-linux.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: govinds@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A427F6021C;
        Wed, 10 Oct 2018 11:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539172397;
        bh=GD+z6ixks+DViOvtODI+xBI0pwT2Z6kHiAT5fNfuEyc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c6iAbJiihx3usknN+BrzsQl3dKDerD0SeygiBCWndqnhipLhjIWuTG9yHkc/o0tbS
         1PR/66V8AHJQxrtcuJ4t/pYwnREfxGyxqKRilgU/znBFg1dyFfiIr/35yQDqQDZ3tA
         OI631y143IMtYsIz+ipDgDEiuH9dpV0WVxxg3pB0=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org A427F6021C
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=govinds@codeaurora.org
From:   Govind Singh <govinds@codeaurora.org>
To:     devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        robh+dt@kernel.org, andy.gross@linaro.org,
        linux-soc@vger.kernel.org
Cc:     Govind Singh <govinds@codeaurora.org>
Subject: [PATCH v3 1/3] dt: bindings: add missing dt properties for WCN3990 wifi node
Date:   Wed, 10 Oct 2018 17:22:54 +0530
Message-Id: <1539172376-19269-2-git-send-email-govinds@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1539172376-19269-1-git-send-email-govinds@codeaurora.org>
References: <1539172376-19269-1-git-send-email-govinds@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Add missing optional properties in WCN3990 wifi node.

Signed-off-by: Govind Singh <govinds@codeaurora.org>
---
 .../bindings/net/wireless/qcom,ath10k.txt          | 28 ++++++++++++++++------
 1 file changed, 21 insertions(+), 7 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
index 7fd4e8c..f831bb1 100644
--- a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
+++ b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
@@ -37,12 +37,20 @@ Optional properties:
 - clocks: List of clock specifiers, must contain an entry for each required
           entry in clock-names.
 - clock-names: Should contain the clock names "wifi_wcss_cmd", "wifi_wcss_ref",
-               "wifi_wcss_rtc".
-- interrupts: List of interrupt lines. Must contain an entry
-	      for each entry in the interrupt-names property.
+	       "wifi_wcss_rtc" for "qcom,ipq4019-wifi" compatible target and
+	       "cxo_ref_clk_pin", "smmu_aggre2_noc_clk" for "qcom,wcn3990-wifi"
+	       compatible target.
+- interrupts: reference to the list of 17 interrupt no's for "qcom,ipq4019-wifi"
+	      compatible target.
+	      reference to the list of 12 interrupt no's for "qcom,wcn3990-wifi"
+	      compatible target.
+	      Must contain interrupt-names property per entry for
+	      "qcom,ath10k", "qcom,ipq4019-wifi" compatible targets.
+
 - interrupt-names: Must include the entries for MSI interrupt
 		   names ("msi0" to "msi15") and legacy interrupt
-		   name ("legacy"),
+		   name ("legacy") for "qcom,ath10k", "qcom,ipq4019-wifi"
+		   compatible targets.
 - qcom,msi_addr: MSI interrupt address.
 - qcom,msi_base: Base value to add before writing MSI data into
 		MSI address register.
@@ -55,7 +63,8 @@ Optional properties:
 - qcom,ath10k-pre-calibration-data : pre calibration data as an array,
 				     the length can vary between hw versions.
 - <supply-name>-supply: handle to the regulator device tree node
-			   optional "supply-name" is "vdd-0.8-cx-mx".
+			   optional "supply-name" are "vdd-0.8-cx-mx",
+			   "vdd-1.8-xo", "vdd-1.3-rfa" and "vdd-3.3-ch0".
 
 Example (to supply the calibration data alone):
 
@@ -133,8 +142,10 @@ wifi@18000000 {
 		compatible = "qcom,wcn3990-wifi";
 		reg = <0x18800000 0x800000>;
 		reg-names = "membase";
-		clocks = <&clock_gcc clk_aggre2_noc_clk>;
-		clock-names = "smmu_aggre2_noc_clk"
+		clocks = <&clock_gcc clk_aggre2_noc_clk>,
+			 <&clock_gcc clk_rf_clk2_pin>;
+		clock-names = "smmu_aggre2_noc_clk",
+			      "cxo_ref_clk_pin";
 		interrupts =
 			   <0 130 0 /* CE0 */ >,
 			   <0 131 0 /* CE1 */ >,
@@ -149,4 +160,7 @@ wifi@18000000 {
 			   <0 140 0 /* CE10 */ >,
 			   <0 141 0 /* CE11 */ >;
 		vdd-0.8-cx-mx-supply = <&pm8998_l5>;
+		vdd-1.8-xo-supply = <&vreg_l7a_1p8>;
+		vdd-1.3-rfa-supply = <&vreg_l17a_1p3>;
+		vdd-3.3-ch0-supply = <&vreg_l25a_3p3>;
 };
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

