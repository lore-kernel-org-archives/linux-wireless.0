Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:39903 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753113AbaIYKoh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Sep 2014 06:44:37 -0400
Received: by mail-wg0-f52.google.com with SMTP id n12so5860984wgh.11
        for <linux-wireless@vger.kernel.org>; Thu, 25 Sep 2014 03:44:35 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 3/4] ath10k: request fw_stats once on open
Date: Thu, 25 Sep 2014 12:33:49 +0200
Message-Id: <1411641230-18785-4-git-send-email-michal.kazior@tieto.com> (sfid-20140925_124441_678235_D953DD42)
In-Reply-To: <1411641230-18785-1-git-send-email-michal.kazior@tieto.com>
References: <1411641230-18785-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stats were requested and processed for each read
call. This caused inconsistent readings.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/debug.c | 110 +++++++++++++++++++++++---------
 1 file changed, 79 insertions(+), 31 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 97b5c16..1ab0f10 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -260,38 +260,35 @@ unlock:
 	spin_unlock_bh(&ar->data_lock);
 }
 
-static ssize_t ath10k_fw_stats_read(struct file *file, char __user *user_buf,
-				    size_t count, loff_t *ppos)
+static int ath10k_fw_stats_request(struct ath10k *ar)
 {
-	struct ath10k *ar = file->private_data;
-	struct ath10k_fw_stats *fw_stats;
-	char *buf = NULL;
-	unsigned int len = 0, buf_len = 8000;
-	ssize_t ret_cnt = 0;
-	long left;
-	int i;
 	int ret;
 
-	fw_stats = &ar->debug.fw_stats;
-
-	mutex_lock(&ar->conf_mutex);
-
-	if (ar->state != ATH10K_STATE_ON)
-		goto exit;
-
-	buf = kzalloc(buf_len, GFP_KERNEL);
-	if (!buf)
-		goto exit;
+	lockdep_assert_held(&ar->conf_mutex);
 
 	ret = ath10k_wmi_request_stats(ar, WMI_REQUEST_PEER_STAT);
 	if (ret) {
-		ath10k_warn(ar, "could not request stats (%d)\n", ret);
-		goto exit;
+		ath10k_warn(ar, "failed to fw stat request command: %d\n", ret);
+		return ret;
 	}
 
-	left = wait_for_completion_timeout(&ar->debug.fw_stats_complete, 1*HZ);
-	if (left <= 0)
-		goto exit;
+	ret = wait_for_completion_timeout(&ar->debug.fw_stats_complete, 1*HZ);
+	if (ret <= 0)
+		return -ETIMEDOUT;
+
+	return 0;
+}
+
+/* FIXME: How to calculate the buffer size sanely? */
+#define ATH10K_FW_STATS_BUF_SIZE (1024*1024)
+
+static void ath10k_fw_stats_fill(struct ath10k *ar,
+				 struct ath10k_fw_stats *fw_stats,
+				 char *buf)
+{
+	unsigned int len = 0;
+	unsigned int buf_len = ATH10K_FW_STATS_BUF_SIZE;
+	int i;
 
 	spin_lock_bh(&ar->data_lock);
 	len += scnprintf(buf + len, buf_len - len, "\n");
@@ -436,20 +433,71 @@ static ssize_t ath10k_fw_stats_read(struct file *file, char __user *user_buf,
 	}
 	spin_unlock_bh(&ar->data_lock);
 
-	if (len > buf_len)
-		len = buf_len;
+	if (len >= buf_len)
+		buf[len - 1] = 0;
+	else
+		buf[len] = 0;
+}
 
-	ret_cnt = simple_read_from_buffer(user_buf, count, ppos, buf, len);
+static int ath10k_fw_stats_open(struct inode *inode, struct file *file)
+{
+	struct ath10k *ar = inode->i_private;
+	void *buf = NULL;
+	int ret;
+
+	mutex_lock(&ar->conf_mutex);
+
+	if (ar->state != ATH10K_STATE_ON) {
+		ret = -ENETDOWN;
+		goto err_unlock;
+	}
+
+	buf = vmalloc(ATH10K_FW_STATS_BUF_SIZE);
+	if (!buf) {
+		ret = -ENOMEM;
+		goto err_unlock;
+	}
+
+	ret = ath10k_fw_stats_request(ar);
+	if (ret) {
+		ath10k_warn(ar, "failed to request fw stats: %d\n", ret);
+		goto err_free;
+	}
+
+	ath10k_fw_stats_fill(ar, &ar->debug.fw_stats, buf);
+	file->private_data = buf;
 
-exit:
 	mutex_unlock(&ar->conf_mutex);
-	kfree(buf);
-	return ret_cnt;
+	return 0;
+
+err_free:
+	vfree(buf);
+
+err_unlock:
+	mutex_unlock(&ar->conf_mutex);
+	return ret;
+}
+
+static int ath10k_fw_stats_release(struct inode *inode, struct file *file)
+{
+	vfree(file->private_data);
+
+	return 0;
+}
+
+static ssize_t ath10k_fw_stats_read(struct file *file, char __user *user_buf,
+				    size_t count, loff_t *ppos)
+{
+	const char *buf = file->private_data;
+	unsigned int len = strlen(buf);
+
+	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
 }
 
 static const struct file_operations fops_fw_stats = {
+	.open = ath10k_fw_stats_open,
+	.release = ath10k_fw_stats_release,
 	.read = ath10k_fw_stats_read,
-	.open = simple_open,
 	.owner = THIS_MODULE,
 	.llseek = default_llseek,
 };
-- 
1.8.5.3

