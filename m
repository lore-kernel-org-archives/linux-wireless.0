Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:41981 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751844AbbCARuM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Mar 2015 12:50:12 -0500
From: Colin King <colin.king@canonical.com>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
	netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] wil6210: increase cmd buffer size to avoid sscanf buffer overflow
Date: Sun,  1 Mar 2015 17:48:33 +0000
Message-Id: <1425232113-5010-1-git-send-email-colin.king@canonical.com> (sfid-20150301_185037_411623_9E1565FC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

cppcheck detected a buffer overflow:

[drivers/net/wireless/ath/wil6210/debugfs.c:634]: (error) Width 8
  given in format string (no. 1) is larger than destination buffer
  'cmd[8]', use %7s to prevent overflowing it.

For the current %8s sscanf we require cmd to be 9 chars long
so increase it by 1 byte to prevent the sscan overflow (rather
than reduce the %8s specifier to %7s as cppcheck recommends).

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/ath/wil6210/debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index 45c3558e..29aab12 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -618,7 +618,7 @@ static ssize_t wil_write_back(struct file *file, const char __user *buf,
 	struct wil6210_priv *wil = file->private_data;
 	int rc;
 	char *kbuf = kmalloc(len + 1, GFP_KERNEL);
-	char cmd[8];
+	char cmd[9];
 	int p1, p2, p3;
 
 	if (!kbuf)
-- 
2.1.4

