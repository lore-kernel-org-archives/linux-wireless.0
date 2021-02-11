Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75D94C433E0
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Feb 2021 10:55:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3F64964E2D
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Feb 2021 10:55:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231171AbhBKKzL (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 11 Feb 2021 05:55:11 -0500
Received: from mail29.static.mailgun.info ([104.130.122.29]:44053 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230400AbhBKKws (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 Feb 2021 05:52:48 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1613040730; h=Message-Id: Date: Subject: Cc: To: From:
 Sender; bh=5nBs8GymhtNvefApGFXNXO8pOMGpQcTR3XMiXbf9eQM=; b=bGUiIwWUMHFGNXca62DM3knMKxAfwkulg+xu8FJGZhfmSqMXK8fQ+Ynyjf7BK/ql8uVrwJdG
 G2OKFGRGAhpjAIMhE2Di2EkfJKGi5IeDC5ixU863rKH/3dqKOOhb5//vDKIDqyzmYqCA8Vdb
 XEUm2ct91wrJgfYJJs7c2xwEku8=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyI3YTAwOSIsICJsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmciLCAiYmU5ZTRhIl0=
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-west-2.postgun.com with SMTP id
 60250c3ef112b7872c6a2883 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 11 Feb 2021 10:51:42
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id D2D51C433C6; Thu, 11 Feb 2021 10:51:41 +0000 (UTC)
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 9DF3FC433ED;
        Thu, 11 Feb 2021 10:51:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 9DF3FC433ED
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     ath11k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org
Subject: [PATCH] ath11k: pci: remove experimental warning
Date:   Thu, 11 Feb 2021 12:51:37 +0200
Message-Id: <1613040697-20289-1-git-send-email-kvalo@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

I have received feedback that QCA6390 PCI support is working for many, and I'm
also using QCA6390 on my daily driver^Hlaptop. While there are issues still
to be resolved it's not really experimental anymore, so remove the experimental
warning from driver initialisation.

Tested-on: QCA6390 hw2.0 PCI WLAN.HST.1.0.1-01740-QCAHSTSWPLZ_V2_TO_X86-1

Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
---
 drivers/net/wireless/ath/ath11k/pci.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/pci.c b/drivers/net/wireless/ath/ath11k/pci.c
index 78478b2b3ba5..d14416816acc 100644
--- a/drivers/net/wireless/ath/ath11k/pci.c
+++ b/drivers/net/wireless/ath/ath11k/pci.c
@@ -1086,8 +1086,6 @@ static int ath11k_pci_probe(struct pci_dev *pdev,
 	u32 soc_hw_version, soc_hw_version_major, soc_hw_version_minor;
 	int ret;
 
-	dev_warn(&pdev->dev, "WARNING: ath11k PCI support is experimental!\n");
-
 	ab = ath11k_core_alloc(&pdev->dev, sizeof(*ab_pci), ATH11K_BUS_PCI,
 			       &ath11k_pci_bus_params);
 	if (!ab) {
-- 
2.7.4

