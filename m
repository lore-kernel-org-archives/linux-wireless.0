Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.genius.jabatus.fr ([109.234.163.61]:38224 "EHLO
        mail.genius.jabatus.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1165534AbdDXHMo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Apr 2017 03:12:44 -0400
From: Michael Mera <dev@michaelmera.com>
To: ath10k@lists.infradead.org
Cc: Michael Mera <dev@michaelmera.com>, linux-wireless@vger.kernel.org,
        Kalle Valo <kvalo@qca.qualcomm.com>
Subject: [PATCH RESEND] ath10k: fix out of bounds access to local buffer
Date: Mon, 24 Apr 2017 16:11:57 +0900
Message-Id: <20170424071157.6979-1-dev@michaelmera.com> (sfid-20170424_091314_793370_3D8AE6A1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

During write to debugfs file simulate_fw_crash, fixed-size local buffer
'buf' is accessed and modified at index 'count-1', where 'count' is the
size of the write (so potentially out of bounds).
This patch fixes this problem.

Signed-off-by: Michael Mera <dev@michaelmera.com>
---
 drivers/net/wireless/ath/ath10k/debug.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index fb0ade3adb07..7f3c17e55693 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -628,17 +628,21 @@ static ssize_t ath10k_write_simulate_fw_crash(struct file *file,
 					      size_t count, loff_t *ppos)
 {
 	struct ath10k *ar = file->private_data;
-	char buf[32];
+	char buf[32] = {0};
+	ssize_t rc;
 	int ret;
 
-	simple_write_to_buffer(buf, sizeof(buf) - 1, ppos, user_buf, count);
+	/* filter partial writes and invalid commands */
+	if (*ppos != 0 || count >= sizeof(buf) || count == 0)
+		return -EINVAL;
 
-	/* make sure that buf is null terminated */
-	buf[sizeof(buf) - 1] = 0;
+	rc = simple_write_to_buffer(buf, sizeof(buf)-1, ppos, user_buf, count);
+	if (rc < 0)
+		return rc;
 
 	/* drop the possible '\n' from the end */
-	if (buf[count - 1] == '\n')
-		buf[count - 1] = 0;
+	if (buf[*ppos - 1] == '\n')
+		buf[*ppos - 1] = '\0';
 
 	mutex_lock(&ar->conf_mutex);
 
-- 
2.9.3
