Return-Path: <SRS0=yLyd=MW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EB87C43441
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Oct 2018 11:53:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E3D502087D
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Oct 2018 11:53:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="CaVnmw15";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="IgQNmAU0"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E3D502087D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726870AbeJJTPO (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 10 Oct 2018 15:15:14 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:49424 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726665AbeJJTPN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Oct 2018 15:15:13 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id BA5C660C89; Wed, 10 Oct 2018 11:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539172405;
        bh=vOq3vL1g8UKPpDFE5l8mDdYLUWyWDegaIqQXXdjGHeY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CaVnmw15WZHDXE/cekD5dE8myPsYUISuxZJfobbmQRABUe5kVZ3p/nS9tP7qlWMAi
         lDgr8r+9OdNN98U3iQNkuOBPccsT0+lJFlMwu6hO2OoFswU89gudf0qSFJwbYD2p/7
         BHefOXBS+E6J7J2T5FNFB8Ln0J9xnPvQSIXraR4A=
Received: from svishnoi-linux.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: govinds@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 9EDA5601A8;
        Wed, 10 Oct 2018 11:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539172404;
        bh=vOq3vL1g8UKPpDFE5l8mDdYLUWyWDegaIqQXXdjGHeY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IgQNmAU00s1elQLlEQnDOJs+NmzyzwSRDaGgbX80BTh2LgdVbbKe3gckYl2Uh9v/7
         5FqxlNWCG7qfNWo3detrLHdipGTdu5MfyJYXh63Rpo3wOFsx9dpewHltvnk5zU4pSw
         wxaOVm56rviqrNeJmcBduDwPFkcJ8qYncbYw2GeI=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 9EDA5601A8
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=govinds@codeaurora.org
From:   Govind Singh <govinds@codeaurora.org>
To:     devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        robh+dt@kernel.org, andy.gross@linaro.org,
        linux-soc@vger.kernel.org
Cc:     Govind Singh <govinds@codeaurora.org>
Subject: [PATCH v3 3/3] dt: bindings: add bindings for wifi iommu node
Date:   Wed, 10 Oct 2018 17:22:56 +0530
Message-Id: <1539172376-19269-4-git-send-email-govinds@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1539172376-19269-1-git-send-email-govinds@codeaurora.org>
References: <1539172376-19269-1-git-send-email-govinds@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

WCN3990 wifi module can optionally make use of the IOMMU.
Add binding documentation for phandle to the IOMMU and
the stream id of wifi iommu block.

Signed-off-by: Govind Singh <govinds@codeaurora.org>
---
 Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
index f831bb1..3118d99 100644
--- a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
+++ b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
@@ -65,6 +65,10 @@ Optional properties:
 - <supply-name>-supply: handle to the regulator device tree node
 			   optional "supply-name" are "vdd-0.8-cx-mx",
 			   "vdd-1.8-xo", "vdd-1.3-rfa" and "vdd-3.3-ch0".
+- iommus:
+	Usage: optional
+	Value type: <prop-encoded-array>
+	Definition: A list of phandle and IOMMU specifier pairs.
 
 Example (to supply the calibration data alone):
 
@@ -163,4 +167,5 @@ wifi@18000000 {
 		vdd-1.8-xo-supply = <&vreg_l7a_1p8>;
 		vdd-1.3-rfa-supply = <&vreg_l17a_1p3>;
 		vdd-3.3-ch0-supply = <&vreg_l25a_3p3>;
+		iommus = <&apps_smmu 0x0040 0x1>;
 };
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

