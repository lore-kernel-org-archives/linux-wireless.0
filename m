Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F9B1C433DB
	for <linux-wireless@archiver.kernel.org>; Mon, 21 Dec 2020 18:24:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BDBE8207CF
	for <linux-wireless@archiver.kernel.org>; Mon, 21 Dec 2020 18:24:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbgLUSYF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 21 Dec 2020 13:24:05 -0500
Received: from so254-31.mailgun.net ([198.61.254.31]:56335 "EHLO
        so254-31.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725946AbgLUSYE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 Dec 2020 13:24:04 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1608575024; h=Message-Id: Date: Subject: Cc: To: From:
 Sender; bh=S2DakKA1vosTrjIsbsXVh8dT8o3okJMOJDQvOtHEYhk=; b=HTv8iH7bU2vT/4jvP2u7nqawtMzo5boFL9VEOm5xA257wWrWMnH7avrtdQxA6LU4mZCF8BSz
 ovNMe89KRmFt28aa6Dfyll4RKl4unjcKa4zpsGpz/9GihFCm2PwS+V8izQU6v7Me+3nFYmO4
 oVmbgAsVVmAqGXaUntENhfxzd1s=
X-Mailgun-Sending-Ip: 198.61.254.31
X-Mailgun-Sid: WyI3YTAwOSIsICJsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmciLCAiYmU5ZTRhIl0=
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-east-1.postgun.com with SMTP id
 5fe0e817120d248bb569f139 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 21 Dec 2020 18:23:19
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 2B597C43461; Mon, 21 Dec 2020 18:23:18 +0000 (UTC)
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id E94B7C433CA;
        Mon, 21 Dec 2020 18:23:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org E94B7C433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org
Subject: [PATCH] ath10k: remove unused struct ath10k::dev_type
Date:   Mon, 21 Dec 2020 20:23:14 +0200
Message-Id: <1608574994-30706-1-git-send-email-kvalo@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

It's unused so let's get rid of it. Compile tested only, no functional changes.

Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/core.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index f4be6bfb2539..cd206b16d68f 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -1019,7 +1019,6 @@ struct ath10k {
 	enum ath10k_hw_rev hw_rev;
 	u16 dev_id;
 	u32 chip_id;
-	enum ath10k_dev_type dev_type;
 	u32 target_version;
 	u8 fw_version_major;
 	u32 fw_version_minor;
-- 
2.7.4

