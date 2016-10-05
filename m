Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f171.google.com ([209.85.220.171]:36126 "EHLO
        mail-qk0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754868AbcJEUYW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Oct 2016 16:24:22 -0400
Received: by mail-qk0-f171.google.com with SMTP id o68so88336976qkf.3
        for <linux-wireless@vger.kernel.org>; Wed, 05 Oct 2016 13:24:21 -0700 (PDT)
From: Marty Faltesek <mfaltesek@google.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Marty Faltesek <mfaltesek@google.com>
Subject: [PATCH v2] ath10k: cache calibration data when the core is stopped
Date: Wed,  5 Oct 2016 16:23:57 -0400
Message-Id: <1475699037-136212-1-git-send-email-mfaltesek@google.com> (sfid-20161005_222425_712051_148F064A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Caching calibration data allows it to be accessed when the
device is not active.

---
 drivers/net/wireless/ath/ath10k/core.h  |  1 +
 drivers/net/wireless/ath/ath10k/debug.c | 72 ++++++++++++++-------------------
 2 files changed, 31 insertions(+), 42 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 6e5aa2d..7274ebe 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -452,6 +452,7 @@ struct ath10k_debug {
 	u32 nf_cal_period;
 
 	struct ath10k_fw_crash_data *fw_crash_data;
+	void *cal_data;
 };
 
 enum ath10k_state {
diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 832da6e..668074c 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -1451,75 +1451,58 @@ static const struct file_operations fops_fw_dbglog = {
 	.llseek = default_llseek,
 };
 
-static int ath10k_debug_cal_data_open(struct inode *inode, struct file *file)
+static int ath10k_debug_cal_data_fetch(struct ath10k *ar)
 {
-	struct ath10k *ar = inode->i_private;
-	void *buf;
 	u32 hi_addr;
 	__le32 addr;
 	int ret;
 
-	mutex_lock(&ar->conf_mutex);
-
-	if (ar->state != ATH10K_STATE_ON &&
-	    ar->state != ATH10K_STATE_UTF) {
-		ret = -ENETDOWN;
-		goto err;
-	}
-
-	buf = vmalloc(ar->hw_params.cal_data_len);
-	if (!buf) {
-		ret = -ENOMEM;
-		goto err;
-	}
-
 	hi_addr = host_interest_item_address(HI_ITEM(hi_board_data));
 
 	ret = ath10k_hif_diag_read(ar, hi_addr, &addr, sizeof(addr));
+
 	if (ret) {
-		ath10k_warn(ar, "failed to read hi_board_data address: %d\n", ret);
-		goto err_vfree;
+		ath10k_warn(ar, "failed to read hi_board_data address: %d\n",
+		            ret);
+		return ret;
 	}
 
-	ret = ath10k_hif_diag_read(ar, le32_to_cpu(addr), buf,
+	ret = ath10k_hif_diag_read(ar, le32_to_cpu(addr), ar->debug.cal_data,
 				   ar->hw_params.cal_data_len);
 	if (ret) {
 		ath10k_warn(ar, "failed to read calibration data: %d\n", ret);
-		goto err_vfree;
+		return ret;
 	}
 
-	file->private_data = buf;
+	return 0;
+}
 
-	mutex_unlock(&ar->conf_mutex);
+static int ath10k_debug_cal_data_open(struct inode *inode, struct file *file)
+{
+	struct ath10k *ar = inode->i_private;
 
-	return 0;
+	mutex_lock(&ar->conf_mutex);
 
-err_vfree:
-	vfree(buf);
+	if (ar->state == ATH10K_STATE_ON ||
+	    ar->state == ATH10K_STATE_UTF) {
+		ath10k_debug_cal_data_fetch(ar);
+	}
 
-err:
+	file->private_data = ar;
 	mutex_unlock(&ar->conf_mutex);
 
-	return ret;
+	return 0;
 }
 
 static ssize_t ath10k_debug_cal_data_read(struct file *file,
-					  char __user *user_buf,
-					  size_t count, loff_t *ppos)
+                                          char __user *user_buf,
+                                          size_t count, loff_t *ppos)
 {
 	struct ath10k *ar = file->private_data;
-	void *buf = file->private_data;
 
 	return simple_read_from_buffer(user_buf, count, ppos,
-				       buf, ar->hw_params.cal_data_len);
-}
-
-static int ath10k_debug_cal_data_release(struct inode *inode,
-					 struct file *file)
-{
-	vfree(file->private_data);
-
-	return 0;
+				       ar->debug.cal_data,
+				       ar->hw_params.cal_data_len);
 }
 
 static ssize_t ath10k_write_ani_enable(struct file *file,
@@ -1580,7 +1563,6 @@ static const struct file_operations fops_ani_enable = {
 static const struct file_operations fops_cal_data = {
 	.open = ath10k_debug_cal_data_open,
 	.read = ath10k_debug_cal_data_read,
-	.release = ath10k_debug_cal_data_release,
 	.owner = THIS_MODULE,
 	.llseek = default_llseek,
 };
@@ -1932,6 +1914,8 @@ void ath10k_debug_stop(struct ath10k *ar)
 {
 	lockdep_assert_held(&ar->conf_mutex);
 
+	ath10k_debug_cal_data_fetch(ar);
+
 	/* Must not use _sync to avoid deadlock, we do that in
 	 * ath10k_debug_destroy(). The check for htt_stats_mask is to avoid
 	 * warning from del_timer(). */
@@ -2343,7 +2327,9 @@ int ath10k_debug_create(struct ath10k *ar)
 	ar->debug.fw_crash_data = vzalloc(sizeof(*ar->debug.fw_crash_data));
 	if (!ar->debug.fw_crash_data)
 		return -ENOMEM;
-
+	ar->debug.cal_data = vzalloc(ar->hw_params.cal_data_len);
+	if (!ar->debug.cal_data)
+		return -ENOMEM;
 	INIT_LIST_HEAD(&ar->debug.fw_stats.pdevs);
 	INIT_LIST_HEAD(&ar->debug.fw_stats.vdevs);
 	INIT_LIST_HEAD(&ar->debug.fw_stats.peers);
@@ -2355,7 +2341,9 @@ int ath10k_debug_create(struct ath10k *ar)
 void ath10k_debug_destroy(struct ath10k *ar)
 {
 	vfree(ar->debug.fw_crash_data);
+	vfree(ar->debug.cal_data);
 	ar->debug.fw_crash_data = NULL;
+	ar->debug.cal_data = NULL;
 
 	ath10k_debug_fw_stats_reset(ar);
 
-- 
2.8.0.rc3.226.g39d4020
