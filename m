Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f169.google.com ([209.85.220.169]:34783 "EHLO
        mail-qk0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750940AbcIMVMU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Sep 2016 17:12:20 -0400
Received: by mail-qk0-f169.google.com with SMTP id h8so101535846qka.1
        for <linux-wireless@vger.kernel.org>; Tue, 13 Sep 2016 14:12:19 -0700 (PDT)
From: Marty Faltesek <mfaltesek@google.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] ath10k: cache calibration data when the core is stopped.
Date: Tue, 13 Sep 2016 17:11:58 -0400
Message-Id: <1473801118-103112-1-git-send-email-mfaltesek@google.com> (sfid-20160913_231224_043606_CE865EF5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Caching calibration data allows it to be accessed when the
device is not active.

Signed-off-by: Marty Faltesek <mfaltesek@google.com>
---
 drivers/net/wireless/ath/ath10k/core.c  | 47 ++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/core.h  |  2 ++
 drivers/net/wireless/ath/ath10k/debug.c | 51 +++++++++------------------------
 drivers/net/wireless/ath/ath10k/debug.h |  1 +
 drivers/net/wireless/ath/ath10k/mac.c   |  1 +
 5 files changed, 65 insertions(+), 37 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index c0b9797..c99ad9e 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -1227,6 +1227,42 @@ success:
 	return 0;
 }
 
+int
+ath10k_cal_data_alloc(struct ath10k *ar, void **buf)
+{
+	u32 hi_addr;
+	__le32 addr;
+	int ret;
+
+	vfree(*buf);
+	*buf = vmalloc(QCA988X_CAL_DATA_LEN);
+	if (!*buf) {
+		return -EAGAIN;
+	}
+
+	hi_addr = host_interest_item_address(HI_ITEM(hi_board_data));
+
+	ret = ath10k_hif_diag_read(ar, hi_addr, &addr, sizeof(addr));
+
+	if (ret) {
+		ath10k_warn(ar, "failed to read hi_board_data address: %d\n", ret);
+	} else {
+		ret = ath10k_hif_diag_read(ar, le32_to_cpu(addr), *buf,
+					   QCA988X_CAL_DATA_LEN);
+		if (ret) {
+			ath10k_warn(ar, "failed to read calibration data: %d\n", ret);
+		}
+	}
+
+	if (ret) {
+		vfree(*buf);
+		*buf = NULL;
+	}
+
+	return ret;
+}
+
+
 static int ath10k_download_cal_data(struct ath10k *ar)
 {
 	int ret;
@@ -1714,6 +1750,12 @@ int ath10k_core_start(struct ath10k *ar, enum ath10k_firmware_mode mode)
 
 	INIT_LIST_HEAD(&ar->arvifs);
 
+	/*
+	 * We are up now, so no need to cache calibration data.
+	 */
+	vfree(ar->cal_data);
+        ar->cal_data = NULL;
+
 	return 0;
 
 err_hif_stop:
@@ -1757,6 +1799,11 @@ void ath10k_core_stop(struct ath10k *ar)
 	lockdep_assert_held(&ar->conf_mutex);
 	ath10k_debug_stop(ar);
 
+	/*
+	 * Cache caclibration data while stopped.
+	 */
+	ath10k_cal_data_alloc(ar, &ar->cal_data);
+
 	/* try to suspend target */
 	if (ar->state != ATH10K_STATE_RESTARTING &&
 	    ar->state != ATH10K_STATE_UTF)
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 4d3f002..cce61c1 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -635,6 +635,8 @@ struct ath10k {
 	struct ath10k_htc htc;
 	struct ath10k_htt htt;
 
+	void *cal_data;
+
 	struct ath10k_hw_params {
 		u32 id;
 		u16 dev_id;
diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 8b01e3e..7de0eb4 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -1427,53 +1427,26 @@ static const struct file_operations fops_fw_dbglog = {
 static int ath10k_debug_cal_data_open(struct inode *inode, struct file *file)
 {
 	struct ath10k *ar = inode->i_private;
-	void *buf;
-	u32 hi_addr;
-	__le32 addr;
 	int ret;
 
 	mutex_lock(&ar->conf_mutex);
 
 	if (ar->state != ATH10K_STATE_ON &&
-	    ar->state != ATH10K_STATE_UTF) {
-		ret = -ENETDOWN;
-		goto err;
-	}
-
-	buf = vmalloc(QCA988X_CAL_DATA_LEN);
-	if (!buf) {
-		ret = -ENOMEM;
-		goto err;
+	    ar->state != ATH10K_STATE_UTF && ! ar->cal_data) {
+		mutex_unlock(&ar->conf_mutex);
+		return (-ENETDOWN);
 	}
 
-	hi_addr = host_interest_item_address(HI_ITEM(hi_board_data));
-
-	ret = ath10k_hif_diag_read(ar, hi_addr, &addr, sizeof(addr));
-	if (ret) {
-		ath10k_warn(ar, "failed to read hi_board_data address: %d\n", ret);
-		goto err_vfree;
-	}
-
-	ret = ath10k_hif_diag_read(ar, le32_to_cpu(addr), buf,
-				   QCA988X_CAL_DATA_LEN);
-	if (ret) {
-		ath10k_warn(ar, "failed to read calibration data: %d\n", ret);
-		goto err_vfree;
+	if (ar->cal_data) {
+		file->private_data = ar->cal_data;
+		mutex_unlock(&ar->conf_mutex);
+		return 0;
 	}
 
-	file->private_data = buf;
-
-	mutex_unlock(&ar->conf_mutex);
-
-	return 0;
-
-err_vfree:
-	vfree(buf);
-
-err:
+	ret = ath10k_cal_data_alloc(ar, &file->private_data);
 	mutex_unlock(&ar->conf_mutex);
 
-	return ret;
+	return (ret);
 }
 
 static ssize_t ath10k_debug_cal_data_read(struct file *file,
@@ -1489,7 +1462,11 @@ static ssize_t ath10k_debug_cal_data_read(struct file *file,
 static int ath10k_debug_cal_data_release(struct inode *inode,
 					 struct file *file)
 {
-	vfree(file->private_data);
+	struct ath10k *ar = inode->i_private;
+
+	/* Free if it's not the cached version */
+	if (ar->cal_data != file->private_data)
+		vfree(file->private_data);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/ath/ath10k/debug.h b/drivers/net/wireless/ath/ath10k/debug.h
index 3900934..1ae757c 100644
--- a/drivers/net/wireless/ath/ath10k/debug.h
+++ b/drivers/net/wireless/ath/ath10k/debug.h
@@ -59,6 +59,7 @@ enum ath10k_dbg_aggr_mode {
 #define ATH10K_FW_STATS_BUF_SIZE (1024*1024)
 
 extern unsigned int ath10k_debug_mask;
+extern int ath10k_cal_data_alloc(struct ath10k *ar, void **buf);
 
 __printf(2, 3) void ath10k_info(struct ath10k *ar, const char *fmt, ...);
 __printf(2, 3) void ath10k_err(struct ath10k *ar, const char *fmt, ...);
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index eb36859..88fb27f 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -6924,6 +6924,7 @@ struct ath10k *ath10k_mac_create(size_t priv_size)
 
 void ath10k_mac_destroy(struct ath10k *ar)
 {
+	vfree(ar->cal_data);
 	ieee80211_free_hw(ar->hw);
 }
 
-- 
2.8.0.rc3.226.g39d4020
