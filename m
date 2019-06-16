Return-Path: <SRS0=78ty=UP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC354C31E53
	for <linux-wireless@archiver.kernel.org>; Sun, 16 Jun 2019 07:34:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C928621473
	for <linux-wireless@archiver.kernel.org>; Sun, 16 Jun 2019 07:34:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726426AbfFPHeV (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 16 Jun 2019 03:34:21 -0400
Received: from alexa-out-ams-02.qualcomm.com ([185.23.61.163]:27491 "EHLO
        alexa-out-ams-02.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726155AbfFPHeU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 16 Jun 2019 03:34:20 -0400
Received: from ironmsg02-ams.qualcomm.com ([10.251.56.3])
  by alexa-out-ams-02.qualcomm.com with ESMTP; 16 Jun 2019 09:26:14 +0200
X-IronPort-AV: E=McAfee;i="6000,8403,9289"; a="8499835"
Received: from lx-merez1.mea.qualcomm.com ([10.18.173.103])
  by ironmsg02-ams.qualcomm.com with ESMTP; 16 Jun 2019 09:26:12 +0200
From:   Maya Erez <merez@codeaurora.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Dedy Lansky <dlansky@codeaurora.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        Maya Erez <merez@codeaurora.org>
Subject: [PATCH 05/11] wil6210: fix printout in wil_read_pmccfg
Date:   Sun, 16 Jun 2019 10:26:01 +0300
Message-Id: <1560669967-23706-6-git-send-email-merez@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1560669967-23706-1-git-send-email-merez@codeaurora.org>
References: <1560669967-23706-1-git-send-email-merez@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Dedy Lansky <dlansky@codeaurora.org>

Replace sprintf with snprintf which checks the destination buffer
size.

Signed-off-by: Dedy Lansky <dlansky@codeaurora.org>
Signed-off-by: Maya Erez <merez@codeaurora.org>
---
 drivers/net/wireless/ath/wil6210/debugfs.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index 14778a1c..8eb6d49 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -976,9 +976,8 @@ static ssize_t wil_read_pmccfg(struct file *file, char __user *user_buf,
 	" - \"alloc <num descriptors> <descriptor_size>\" to allocate pmc\n"
 	" - \"free\" to free memory allocated for pmc\n";
 
-	sprintf(text, "Last command status: %d\n\n%s",
-		wil_pmc_last_cmd_status(wil),
-		help);
+	snprintf(text, sizeof(text), "Last command status: %d\n\n%s",
+		 wil_pmc_last_cmd_status(wil), help);
 
 	return simple_read_from_buffer(user_buf, count, ppos, text,
 				       strlen(text) + 1);
-- 
1.9.1

