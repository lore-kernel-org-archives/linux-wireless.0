Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFF8DC63697
	for <linux-wireless@archiver.kernel.org>; Thu, 26 Nov 2020 17:16:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F99521D1A
	for <linux-wireless@archiver.kernel.org>; Thu, 26 Nov 2020 17:16:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391612AbgKZRQM (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 26 Nov 2020 12:16:12 -0500
Received: from alexa-out.qualcomm.com ([129.46.98.28]:44514 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391544AbgKZRQM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 26 Nov 2020 12:16:12 -0500
Received: from ironmsg08-lv.qualcomm.com ([10.47.202.152])
  by alexa-out.qualcomm.com with ESMTP; 26 Nov 2020 09:16:12 -0800
X-QCInternal: smtphost
Received: from ironmsg01-blr.qualcomm.com ([10.86.208.130])
  by ironmsg08-lv.qualcomm.com with ESMTP/TLS/AES256-SHA; 26 Nov 2020 09:16:09 -0800
X-QCInternal: smtphost
Received: from youghand-linux.qualcomm.com ([10.206.66.115])
  by ironmsg01-blr.qualcomm.com with ESMTP; 26 Nov 2020 22:45:57 +0530
Received: by youghand-linux.qualcomm.com (Postfix, from userid 2370257)
        id 3A2FC21B61; Thu, 26 Nov 2020 22:45:56 +0530 (IST)
From:   Youghandhar Chintala <youghand@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        pillair@codeaurora.org, dianders@chromium.org, kuabhs@chromium.org,
        briannorris@chromium.org,
        Youghandhar Chintala <youghand@codeaurora.org>
Subject: [PATCH v2] ath10k: skip the wait for completion to recovery in shutdown path
Date:   Thu, 26 Nov 2020 22:45:53 +0530
Message-Id: <20201126171553.2097-1-youghand@codeaurora.org>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Currently in the shutdown callback we wait for recovery to complete
before freeing up the resources. This can lead to unwanted delay
during the shutdown and thereby increase the shutdown time.

As an attempt to take less time during shutdown, remove the wait for
recovery completion in the shutdown callback.

Tested-on: WCN3990 hw1.0 SNOC WLAN.HL.3.1-01040-QCAHLSWMTPLZ-1

Signed-off-by: Youghandhar Chintala <youghand@codeaurora.org>
---
Changes from v1:
-Removed stray change-id text
---
 drivers/net/wireless/ath/ath10k/snoc.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/snoc.c b/drivers/net/wireless/ath/ath10k/snoc.c
index 84666f72bdfa..15580a91fe98 100644
--- a/drivers/net/wireless/ath/ath10k/snoc.c
+++ b/drivers/net/wireless/ath/ath10k/snoc.c
@@ -1790,9 +1790,6 @@ static int ath10k_snoc_remove(struct platform_device *pdev)
 
 	reinit_completion(&ar->driver_recovery);
 
-	if (test_bit(ATH10K_SNOC_FLAG_RECOVERY, &ar_snoc->flags))
-		wait_for_completion_timeout(&ar->driver_recovery, 3 * HZ);
-
 	set_bit(ATH10K_SNOC_FLAG_UNREGISTERING, &ar_snoc->flags);
 
 	ath10k_core_unregister(ar);
-- 
2.26.0

