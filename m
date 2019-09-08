Return-Path: <SRS0=wUyo=XD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00036C433EF
	for <linux-wireless@archiver.kernel.org>; Sun,  8 Sep 2019 08:39:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D7E0621479
	for <linux-wireless@archiver.kernel.org>; Sun,  8 Sep 2019 08:39:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727497AbfIHIjZ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 8 Sep 2019 04:39:25 -0400
Received: from alexa-out-ams-02.qualcomm.com ([185.23.61.163]:7549 "EHLO
        alexa-out-ams-02.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727422AbfIHIjS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 8 Sep 2019 04:39:18 -0400
Received: from ironmsg03-ams.qualcomm.com ([10.251.56.4])
  by alexa-out-ams-02.qualcomm.com with ESMTP; 08 Sep 2019 10:33:05 +0200
Received: from lx-merez1.mea.qualcomm.com ([10.18.173.103])
  by ironmsg03-ams.qualcomm.com with ESMTP; 08 Sep 2019 10:33:04 +0200
From:   Maya Erez <merez@codeaurora.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Lior David <liord@codeaurora.org>, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, Maya Erez <merez@codeaurora.org>
Subject: [PATCH 09/11] wil6210: use writel_relaxed in wil_debugfs_iomem_x32_set
Date:   Sun,  8 Sep 2019 11:32:53 +0300
Message-Id: <1567931575-27984-10-git-send-email-merez@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1567931575-27984-1-git-send-email-merez@codeaurora.org>
References: <1567931575-27984-1-git-send-email-merez@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Lior David <liord@codeaurora.org>

writel_relaxed can be used in wil_debugfs_iomem_x32_set
since there is a wmb call immediately after.

Signed-off-by: Lior David <liord@codeaurora.org>
Signed-off-by: Maya Erez <merez@codeaurora.org>
---
 drivers/net/wireless/ath/wil6210/debugfs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index 50dc30e..304b4d4 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -393,7 +393,8 @@ static int wil_debugfs_iomem_x32_set(void *data, u64 val)
 	if (ret < 0)
 		return ret;
 
-	writel(val, (void __iomem *)d->offset);
+	writel_relaxed(val, (void __iomem *)d->offset);
+
 	wmb(); /* make sure write propagated to HW */
 
 	wil_pm_runtime_put(wil);
-- 
1.9.1

