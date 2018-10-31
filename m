Return-Path: <SRS0=7415=NL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CCBFECDE44
	for <linux-wireless@archiver.kernel.org>; Wed, 31 Oct 2018 08:58:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0097A20840
	for <linux-wireless@archiver.kernel.org>; Wed, 31 Oct 2018 08:58:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0097A20840
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727752AbeJaR4A (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 31 Oct 2018 13:56:00 -0400
Received: from alexa-out-ams-01.qualcomm.com ([185.23.61.162]:23736 "EHLO
        alexa-out-ams-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727726AbeJaRz7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 31 Oct 2018 13:55:59 -0400
X-IronPort-AV: E=Sophos;i="5.54,447,1534802400"; 
   d="scan'208";a="1418130"
Received: from ironmsg01-ams.qualcomm.com ([10.251.56.2])
  by alexa-out-ams-01.qualcomm.com with ESMTP; 31 Oct 2018 09:52:33 +0100
X-IronPort-AV: E=McAfee;i="5900,7806,9062"; a="6147930"
Received: from lx-merez1.mea.qualcomm.com ([10.18.173.103])
  by ironmsg01-ams.qualcomm.com with ESMTP; 31 Oct 2018 09:52:33 +0100
From:   Maya Erez <merez@codeaurora.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Ahmad Masri <amasri@codeaurora.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        Maya Erez <merez@codeaurora.org>
Subject: [PATCH 10/16] wil6210: fix debugfs memory access alignment
Date:   Wed, 31 Oct 2018 10:52:18 +0200
Message-Id: <1540975944-30576-11-git-send-email-merez@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1540975944-30576-1-git-send-email-merez@codeaurora.org>
References: <1540975944-30576-1-git-send-email-merez@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ahmad Masri <amasri@codeaurora.org>

All wil6210 device memory access should be 4 bytes aligned. In io
blob wil6210 did not force alignment for read function, this caused
alignment fault on some platforms.
Fixing that by accessing all 4 lower bytes and return to host the
requested data.

Signed-off-by: Ahmad Masri <amasri@codeaurora.org>
Signed-off-by: Maya Erez <merez@codeaurora.org>
---
 drivers/net/wireless/ath/wil6210/debugfs.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index 099a04b..20dd4d0 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -664,10 +664,10 @@ static ssize_t wil_read_file_ioblob(struct file *file, char __user *user_buf,
 	enum { max_count = 4096 };
 	struct wil_blob_wrapper *wil_blob = file->private_data;
 	struct wil6210_priv *wil = wil_blob->wil;
-	loff_t pos = *ppos;
+	loff_t aligned_pos, pos = *ppos;
 	size_t available = wil_blob->blob.size;
 	void *buf;
-	size_t ret;
+	size_t unaligned_bytes, aligned_count, ret;
 	int rc;
 
 	if (test_bit(wil_status_suspending, wil_blob->wil->status) ||
@@ -685,7 +685,12 @@ static ssize_t wil_read_file_ioblob(struct file *file, char __user *user_buf,
 	if (count > max_count)
 		count = max_count;
 
-	buf = kmalloc(count, GFP_KERNEL);
+	/* set pos to 4 bytes aligned */
+	unaligned_bytes = pos % 4;
+	aligned_pos = pos - unaligned_bytes;
+	aligned_count = count + unaligned_bytes;
+
+	buf = kmalloc(aligned_count, GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
 
@@ -696,9 +701,9 @@ static ssize_t wil_read_file_ioblob(struct file *file, char __user *user_buf,
 	}
 
 	wil_memcpy_fromio_32(buf, (const void __iomem *)
-			     wil_blob->blob.data + pos, count);
+			     wil_blob->blob.data + aligned_pos, aligned_count);
 
-	ret = copy_to_user(user_buf, buf, count);
+	ret = copy_to_user(user_buf, buf + unaligned_bytes, count);
 
 	wil_pm_runtime_put(wil);
 
-- 
1.9.1

