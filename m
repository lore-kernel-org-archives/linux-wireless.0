Return-Path: <SRS0=txZa=MN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07EE2C43143
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 11:26:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C5462208AE
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 11:26:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="baRyYAnV";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="W5C3RiWu"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C5462208AE
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729198AbeJASEM (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 1 Oct 2018 14:04:12 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:41842 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729147AbeJASEM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 1 Oct 2018 14:04:12 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id AEAD960C64; Mon,  1 Oct 2018 11:26:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538393213;
        bh=/i4uaP62q1S8q9xzztzDt9803Sa2OPclHO7vMMF21JY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=baRyYAnV5wYE74i2hiDYwmsz8LrnqohAuh58eao5wVUsEXo28P9hMxOvXtpXH6Zc9
         xY1+8K55OgEXqckNSzoNod7y9M1BdVf1xIZYgV15yUZ98gvOp8QEz/LS08oMass7/e
         6LN/27UGkxeOTyCXFbB2O5jJEM2gfRj56YC1/3ow=
Received: from govinds-linux.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: govinds@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 62DE960C61;
        Mon,  1 Oct 2018 11:26:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538393212;
        bh=/i4uaP62q1S8q9xzztzDt9803Sa2OPclHO7vMMF21JY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W5C3RiWuvpaRXWfXT/vl06s6K33Dd5G1yrGCTkFTkdTT/VBbrToTV5YIsEDxWemvY
         s7KUYdSMOExUE40bMCq2ekLVcCI4JFfwA523l3Fzf3InQnuOk3s0iTjbW+GnVSNL5b
         K3qLIRSHC4vO4g8tw5zk8n8AnPG9xt4sm1FiNhhU=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 62DE960C61
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=govinds@codeaurora.org
From:   Govind Singh <govinds@codeaurora.org>
To:     robh+dt@kernel.org, devicetree@vger.kernel.org,
        andy.gross@linaro.org, briannorris@chromium.org
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Govind Singh <govinds@codeaurora.org>
Subject: [PATCH v2 3/4] dt: bindings: add bindings for wifi iommu node
Date:   Mon,  1 Oct 2018 16:56:35 +0530
Message-Id: <20181001112636.31715-4-govinds@codeaurora.org>
X-Mailer: git-send-email 2.19.0
In-Reply-To: <20181001112636.31715-1-govinds@codeaurora.org>
References: <20181001112636.31715-1-govinds@codeaurora.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

WCN3990 wifi module can optionally make use of the IOMMU.
Add binding documentation for phandle to the IOMMU and
the stream id of wifi iommu block.

Signed-off-by: Govind Singh <govinds@codeaurora.org>
---
 .../devicetree/bindings/net/wireless/qcom,ath10k.txt        | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
index f831bb1c5952..2a2f44c461f7 100644
--- a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
+++ b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
@@ -65,6 +65,11 @@ Optional properties:
 - <supply-name>-supply: handle to the regulator device tree node
 			   optional "supply-name" are "vdd-0.8-cx-mx",
 			   "vdd-1.8-xo", "vdd-1.3-rfa" and "vdd-3.3-ch0".
+- iommus:
+	Usage: optional
+	Value type: <prop-encoded-array>
+	Definition: A list of phandle and IOMMU specifier pairs
+	            for "qcom,wcn3990-wifi" compatible target.
 
 Example (to supply the calibration data alone):
 
@@ -163,4 +168,5 @@ wifi@18000000 {
 		vdd-1.8-xo-supply = <&vreg_l7a_1p8>;
 		vdd-1.3-rfa-supply = <&vreg_l17a_1p3>;
 		vdd-3.3-ch0-supply = <&vreg_l25a_3p3>;
+		iommus = <&apps_smmu 0x0040 0x1>;
 };
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

