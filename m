Return-Path: <SRS0=txZa=MN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6A05C43143
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 11:26:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7DF43208AE
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 11:26:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="eoHq/16C";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Lj5edn3J"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7DF43208AE
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729211AbeJASER (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 1 Oct 2018 14:04:17 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:41954 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729147AbeJASER (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 1 Oct 2018 14:04:17 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id B96B960C1D; Mon,  1 Oct 2018 11:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538393218;
        bh=KhZIF3OEWxgnSNtRbp2Vp8evAqUZfrfcDXk5w2fQ/9w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eoHq/16CuF72yJ2dBUNIbFMt5gSCprBLtlax/IxJ69mSnGNQJgAXNpsvyISzKXT0p
         tK1xcryhU+CZn4dHINn8e5xQu/cXl/PMzLJiv2hi7BQNId4+lfxyOQjF3QjgTge+bh
         bAwnO/bXoe5QUcnaXogISIYQWIPrl3FcXGsKv0sg=
Received: from govinds-linux.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: govinds@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 7758860C7D;
        Mon,  1 Oct 2018 11:26:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538393216;
        bh=KhZIF3OEWxgnSNtRbp2Vp8evAqUZfrfcDXk5w2fQ/9w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lj5edn3JYkKrAhPVOE3OdyY7dfhLrdBxAlQRwUIpzvhvax+D66SDQa3mbqe1OBCB+
         hPpcCN/FCNcceH/jYNQs7nUkeyW9AXwWYYtU0c+pjykqgahDLMq9htw0YPpnCW1StQ
         PZJVzS+PEmpxjhd8ofYuqQ7zrF0R0UU0VAL4O5wc=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 7758860C7D
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=govinds@codeaurora.org
From:   Govind Singh <govinds@codeaurora.org>
To:     robh+dt@kernel.org, devicetree@vger.kernel.org,
        andy.gross@linaro.org, briannorris@chromium.org
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Govind Singh <govinds@codeaurora.org>
Subject: [PATCH v2 4/4] dts: arm64/sdm845: Enable iommu for WCN3990 wifi module device node
Date:   Mon,  1 Oct 2018 16:56:36 +0530
Message-Id: <20181001112636.31715-5-govinds@codeaurora.org>
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
Add phandle to the iommu and stream id of wifi iommu block.

Signed-off-by: Govind Singh <govinds@codeaurora.org>
---
 arch/arm64/boot/dts/qcom/sdm845.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/qcom/sdm845.dtsi b/arch/arm64/boot/dts/qcom/sdm845.dtsi
index 36c716cf3a0c..f02da46542cc 100644
--- a/arch/arm64/boot/dts/qcom/sdm845.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845.dtsi
@@ -1225,6 +1225,7 @@
 				<0 423 0 /* CE9 */ >,
 				<0 424 0 /* CE10 */ >,
 				<0 425 0 /* CE11 */ >;
+			iommus = <&apps_smmu 0x0040 0x1>;
 		};
 	};
 };
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

