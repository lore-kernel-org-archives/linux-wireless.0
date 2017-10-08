Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:36064 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751241AbdJHV3Q (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 8 Oct 2017 17:29:16 -0400
From: Christos Gkekas <chris.gekas@gmail.com>
To: QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Christos Gkekas <chris.gekas@gmail.com>
Subject: [PATCH] ath9k: debug: Simplify error checking
Date: Sun,  8 Oct 2017 22:29:12 +0100
Message-Id: <1507498152-4058-1-git-send-email-chris.gekas@gmail.com> (sfid-20171008_232936_988493_D6037C8E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Variable val is unsigned so checking whether it is less than zero is
redundant.

Signed-off-by: Christos Gkekas <chris.gekas@gmail.com>
---
 drivers/net/wireless/ath/ath9k/debug.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 01fa301..3b93c23 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -1164,10 +1164,7 @@ static ssize_t write_file_tpc(struct file *file, const char __user *user_buf,
 		return -EFAULT;
 
 	buf[len] = '\0';
-	if (kstrtoul(buf, 0, &val))
-		return -EINVAL;
-
-	if (val < 0 || val > 1)
+	if (kstrtoul(buf, 0, &val) || val > 1)
 		return -EINVAL;
 
 	tpc_enabled = !!val;
-- 
2.7.4
