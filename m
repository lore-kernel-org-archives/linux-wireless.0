Return-Path: <SRS0=txZa=MN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD869C43143
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 11:26:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 92D20208AE
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 11:26:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="OPnzSkTP";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="XuwNP3UB"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 92D20208AE
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729172AbeJASEH (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 1 Oct 2018 14:04:07 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:41624 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729147AbeJASEH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 1 Oct 2018 14:04:07 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 51F9C60C54; Mon,  1 Oct 2018 11:26:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538393207;
        bh=f+J1+Wq+OsubYjB9yIAHDq6uVEcTe8qZA73G9O1ZPlw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OPnzSkTPk+iTBTUezzaIzbXwXOfkkVWkKJCY1gEVA5SF9Wz6lUvgGkQg93THznH+2
         3z2VH07q/iZWWeQ5vHxkD7uFhndYCcoJRgqAzWEejkQSuEvGwL2uztgUGc0SA4Jin8
         +3cLt0uAaRp1LRno+Jsne7tHEJDCMbGNdbclOq14=
Received: from govinds-linux.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: govinds@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 396A460C1B;
        Mon,  1 Oct 2018 11:26:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538393206;
        bh=f+J1+Wq+OsubYjB9yIAHDq6uVEcTe8qZA73G9O1ZPlw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XuwNP3UBcNlWx+s/AhBY4Swh8BWDfIomr4N80cMKWYC0W5jCjmrI8p0LoJXQqgQ6X
         IO2Gfag1whuRGHPMZ3eV5W2eA97IfsBlKclK9Bq+EYTmpignFWcXZdWzMK8bUwVu0Y
         JfBZ0eB8E5lWI5DcriWpXOTZkyagowSt8EdFjN64=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 396A460C1B
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=govinds@codeaurora.org
From:   Govind Singh <govinds@codeaurora.org>
To:     robh+dt@kernel.org, devicetree@vger.kernel.org,
        andy.gross@linaro.org, briannorris@chromium.org
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Govind Singh <govinds@codeaurora.org>
Subject: [PATCH v2 1/4] dt: bindings: add missing dt properties for WCN3990 wifi node
Date:   Mon,  1 Oct 2018 16:56:33 +0530
Message-Id: <20181001112636.31715-2-govinds@codeaurora.org>
X-Mailer: git-send-email 2.19.0
In-Reply-To: <20181001112636.31715-1-govinds@codeaurora.org>
References: <20181001112636.31715-1-govinds@codeaurora.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Add missing optional properties in WCN3990 wifi node.

Signed-off-by: Govind Singh <govinds@codeaurora.org>
---
 .../bindings/net/wireless/qcom,ath10k.txt     | 28 ++++++++++++++-----
 1 file changed, 21 insertions(+), 7 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
index 7fd4e8ce4149..f831bb1c5952 100644
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

