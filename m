Return-Path: <SRS0=oU4Q=ZI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E13FDC43141
	for <linux-wireless@archiver.kernel.org>; Sat, 16 Nov 2019 16:18:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BAF03214DE
	for <linux-wireless@archiver.kernel.org>; Sat, 16 Nov 2019 16:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1573921109;
	bh=LeuDf/I7ZPQA6VJiMkvQSsm3CQHvloLielawHcYlLlc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=apHqIsj4spV7zG3H9QU+eSP38oIZi55L2A7JUBPmL2DXG0ZhJnrRTaSA28dTwQ/6K
	 z5mrRq2sprUfYAeu6FgQbBlgTy9c3Nn2Nj9Y0y/T0vwv1AkazxXFmMSB01Z98fEMYg
	 vsDdc6J9fT3bEzjdgmzEA8481SfTHRox5+SGp5P4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729410AbfKPPq3 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 16 Nov 2019 10:46:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:52804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729398AbfKPPq2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 16 Nov 2019 10:46:28 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A061220836;
        Sat, 16 Nov 2019 15:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919188;
        bh=LeuDf/I7ZPQA6VJiMkvQSsm3CQHvloLielawHcYlLlc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VgwZr/nWC7flsPOneMaoASDjPI+6hmiWW5VfWJJyD8v16YL1IKJ+BeLQ2D1iafctW
         Ht+XK4jv/HZO4qGbX50vAdkvJb7fGZ2BX1bRlo7zpto5Ks4oCUelszj4vDbvhNAajL
         osaHi8L1DDlrM0OlH49TfQyJeFwFlzSDVy6YgoWY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ahmad Masri <amasri@codeaurora.org>,
        Maya Erez <merez@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 196/237] wil6210: fix debugfs memory access alignment
Date:   Sat, 16 Nov 2019 10:40:31 -0500
Message-Id: <20191116154113.7417-196-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154113.7417-1-sashal@kernel.org>
References: <20191116154113.7417-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ahmad Masri <amasri@codeaurora.org>

[ Upstream commit 84ec040d0fb25197584d28a0dedc355503cd19b9 ]

All wil6210 device memory access should be 4 bytes aligned. In io
blob wil6210 did not force alignment for read function, this caused
alignment fault on some platforms.
Fixing that by accessing all 4 lower bytes and return to host the
requested data.

Signed-off-by: Ahmad Masri <amasri@codeaurora.org>
Signed-off-by: Maya Erez <merez@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/wil6210/debugfs.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index 51c3330bc316f..12b8cb698f64d 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -662,10 +662,10 @@ static ssize_t wil_read_file_ioblob(struct file *file, char __user *user_buf,
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
@@ -683,7 +683,12 @@ static ssize_t wil_read_file_ioblob(struct file *file, char __user *user_buf,
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
 
@@ -694,9 +699,9 @@ static ssize_t wil_read_file_ioblob(struct file *file, char __user *user_buf,
 	}
 
 	wil_memcpy_fromio_32(buf, (const void __iomem *)
-			     wil_blob->blob.data + pos, count);
+			     wil_blob->blob.data + aligned_pos, aligned_count);
 
-	ret = copy_to_user(user_buf, buf, count);
+	ret = copy_to_user(user_buf, buf + unaligned_bytes, count);
 
 	wil_pm_runtime_put(wil);
 
-- 
2.20.1

