Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:52401 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752185Ab2CLLXL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Mar 2012 07:23:11 -0400
Subject: [PATCH 2/4] ath6kl: replace strict_strtoul() with kstrtoul()
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath6kl-devel@qualcomm.com, linux-wireless@vger.kernel.org
Date: Mon, 12 Mar 2012 13:23:03 +0200
Message-ID: <20120312112303.23253.54065.stgit@x201> (sfid-20120312_122314_903372_EC32E5B8)
In-Reply-To: <20120312112131.23253.74137.stgit@x201>
References: <20120312112131.23253.74137.stgit@x201>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Recommended by checkpatch.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/debug.c |   19 ++-----------------
 1 files changed, 2 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/debug.c b/drivers/net/wireless/ath/ath6kl/debug.c
index 9170b05..552adb3 100755
--- a/drivers/net/wireless/ath/ath6kl/debug.c
+++ b/drivers/net/wireless/ath/ath6kl/debug.c
@@ -856,17 +856,9 @@ static ssize_t ath6kl_regread_write(struct file *file,
 				    size_t count, loff_t *ppos)
 {
 	struct ath6kl *ar = file->private_data;
-	u8 buf[50];
-	unsigned int len;
 	unsigned long reg_addr;
 
-	len = min(count, sizeof(buf) - 1);
-	if (copy_from_user(buf, user_buf, len))
-		return -EFAULT;
-
-	buf[len] = '\0';
-
-	if (strict_strtoul(buf, 0, &reg_addr))
+	if (kstrtoul_from_user(user_buf, count, 0, &reg_addr))
 		return -EINVAL;
 
 	if ((reg_addr % 4) != 0)
@@ -980,15 +972,8 @@ static ssize_t ath6kl_lrssi_roam_write(struct file *file,
 {
 	struct ath6kl *ar = file->private_data;
 	unsigned long lrssi_roam_threshold;
-	char buf[32];
-	ssize_t len;
 
-	len = min(count, sizeof(buf) - 1);
-	if (copy_from_user(buf, user_buf, len))
-		return -EFAULT;
-
-	buf[len] = '\0';
-	if (strict_strtoul(buf, 0, &lrssi_roam_threshold))
+	if (kstrtoul_from_user(user_buf, count, 0, &lrssi_roam_threshold))
 		return -EINVAL;
 
 	ar->lrssi_roam_threshold = lrssi_roam_threshold;

