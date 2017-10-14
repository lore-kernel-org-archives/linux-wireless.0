Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:38487 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751185AbdJNJqQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 14 Oct 2017 05:46:16 -0400
From: Christos Gkekas <chris.gekas@gmail.com>
To: QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Christos Gkekas <chris.gekas@gmail.com>
Subject: [PATCH] ath9k: debug: Remove redundant check
Date: Sat, 14 Oct 2017 10:46:11 +0100
Message-Id: <1507974371-7419-1-git-send-email-chris.gekas@gmail.com> (sfid-20171014_114633_424096_2927D742)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Variable val is unsigned, so checking whether it is less than zero is
redundant.

Signed-off-by: Christos Gkekas <chris.gekas@gmail.com>
---
 drivers/net/wireless/ath/ath9k/debug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 01fa301..4f5f141 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -1167,7 +1167,7 @@ static ssize_t write_file_tpc(struct file *file, const char __user *user_buf,
 	if (kstrtoul(buf, 0, &val))
 		return -EINVAL;
 
-	if (val < 0 || val > 1)
+	if (val > 1)
 		return -EINVAL;
 
 	tpc_enabled = !!val;
-- 
2.7.4
