Return-Path: <SRS0=oBLS=NQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B014AC0044C
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 13:09:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 79CD720819
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 13:09:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="nsuOEswK";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="cVldJ2Jn"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 79CD720819
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729957AbeKEW2n (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 5 Nov 2018 17:28:43 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:40894 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729228AbeKEW2m (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Nov 2018 17:28:42 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id A04796149D; Mon,  5 Nov 2018 13:08:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541423340;
        bh=8W6e1wuTPzIOLy2jXkqxvCLb1nFN33D/z9pXvTcJFqg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nsuOEswK1IRKTGJUFDDjXbWjzKyJpcHTUr3d5f5X5KwmMxZpqmEg2ewbLMjazG64m
         oXbiMjlLLXzNJ6VO0d27T6jcC/DjMc915LHr8OyEPeaGHlIjQVZfoOW5KtNS5ONjKq
         qA4F7nhso4RgaJFzztvxw4eI10R/xcew4FRx1zGY=
Received: from svishnoi-linux.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: govinds@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C61F3614BA;
        Mon,  5 Nov 2018 13:08:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541423338;
        bh=8W6e1wuTPzIOLy2jXkqxvCLb1nFN33D/z9pXvTcJFqg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cVldJ2JnEbXB4lpSgLR/BLrzc2CXuF1uGNhDDNV3Z7hyggWgkbhCI96i+4nNPZKWj
         4Ga3ky6abag9/UevTBoZ4SD8RXT/VEN04wGdUNDuKXV8uncwvCqo37DnBDA1r1h4nm
         DnPX3Yk7LMdG/R6i70z/zqz081wetHZ3/akPXt/Q=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org C61F3614BA
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
Subject: [PATCH v4 3/3] dt: bindings: add bindings for wifi iommu node
Date:   Mon,  5 Nov 2018 18:38:38 +0530
Message-Id: <1541423318-19312-4-git-send-email-govinds@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1541423318-19312-1-git-send-email-govinds@codeaurora.org>
References: <1541423318-19312-1-git-send-email-govinds@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

WCN3990 wifi module can optionally make use of the IOMMU.
Add binding documentation for phandle to the IOMMU and
the stream id of wifi iommu block.

Signed-off-by: Govind Singh <govinds@codeaurora.org>
Reviewed-by: Rob Herring <robh@kernel.org>
Reviewed-by: Brian Norris <briannorris@chromium.org>
Tested-by: Brian Norris <briannorris@chromium.org>
---
 Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
index 55d255c..78fb56a 100644
--- a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
+++ b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
@@ -66,6 +66,10 @@ Optional properties:
 - <supply-name>-supply: handle to the regulator device tree node
 			   optional "supply-name" are "vdd-0.8-cx-mx",
 			   "vdd-1.8-xo", "vdd-1.3-rfa" and "vdd-3.3-ch0".
+- iommus:
+	Usage: optional
+	Value type: <prop-encoded-array>
+	Definition: A list of phandle and IOMMU specifier pairs.
 
 Example (to supply the calibration data alone):
 
@@ -162,4 +166,5 @@ wifi@18000000 {
 		vdd-1.8-xo-supply = <&vreg_l7a_1p8>;
 		vdd-1.3-rfa-supply = <&vreg_l17a_1p3>;
 		vdd-3.3-ch0-supply = <&vreg_l25a_3p3>;
+		iommus = <&apps_smmu 0x0040 0x1>;
 };
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

