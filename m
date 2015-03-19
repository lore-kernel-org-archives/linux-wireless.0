Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:4637 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753667AbbCSLIm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Mar 2015 07:08:42 -0400
From: Ashok Raj Nagarajan <arnagara@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Ashok Raj Nagarajan <arnagara@qti.qualcomm.com>
Subject: [PATCH v2 2/2] ath10k: allow user to toggle ani_enable via debugfs
Date: Thu, 19 Mar 2015 16:38:00 +0530
Message-ID: <1426763280-11284-2-git-send-email-arnagara@qti.qualcomm.com> (sfid-20150319_120859_218880_C94CBEDE)
In-Reply-To: <1426763280-11284-1-git-send-email-arnagara@qti.qualcomm.com>
References: <1426763280-11284-1-git-send-email-arnagara@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Now that ANI is enabled by default, allow user to disable or enable ANI feature
from debugfs

echo 0|1 > /sys/kernel/debug/ieee80211/phyX/ath10k/ani_enable

Signed-off-by: Ashok Raj Nagarajan <arnagara@qti.qualcomm.com>
---
v2:
Updated commit log
Lock ar->ani_enabled (Kalle Valo)
remove reduntant debug message (Kalle Valo)

 drivers/net/wireless/ath/ath10k/core.h  |  2 ++
 drivers/net/wireless/ath/ath10k/debug.c | 58 +++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/mac.c   |  2 ++
 3 files changed, 62 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 7cba781..29e0a8b 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -510,6 +510,8 @@ struct ath10k {
 	u32 ht_cap_info;
 	u32 vht_cap_info;
 	u32 num_rf_chains;
+	/* protected by conf_mutex */
+	bool ani_enabled;
 
 	DECLARE_BITMAP(fw_features, ATH10K_FW_FEATURE_COUNT);
 
diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 301081d..481e1cc 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -1708,6 +1708,61 @@ static int ath10k_debug_cal_data_release(struct inode *inode,
 	return 0;
 }
 
+static ssize_t ath10k_write_ani_enable(struct file *file,
+				       const char __user *user_buf,
+				       size_t count, loff_t *ppos)
+{
+	struct ath10k *ar = file->private_data;
+	int ret;
+	u8 enable;
+
+	if (kstrtou8_from_user(user_buf, count, 0, &enable))
+		return -EINVAL;
+
+	mutex_lock(&ar->conf_mutex);
+
+	if (ar->ani_enabled == enable) {
+		ret = count;
+		goto exit;
+	}
+
+	ret = ath10k_wmi_pdev_set_param(ar, ar->wmi.pdev_param->ani_enable,
+					enable);
+	if (ret) {
+		ath10k_warn(ar, "ani_enable failed from debugfs: %d\n", ret);
+		goto exit;
+	}
+	ar->ani_enabled = enable;
+
+	ret = count;
+
+exit:
+	mutex_unlock(&ar->conf_mutex);
+
+	return ret;
+}
+
+static ssize_t ath10k_read_ani_enable(struct file *file, char __user *user_buf,
+				      size_t count, loff_t *ppos)
+{
+	struct ath10k *ar = file->private_data;
+	int len = 0;
+	char buf[32];
+
+	len = scnprintf(buf, sizeof(buf) - len, "%d\n",
+			ar->ani_enabled);
+
+	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
+}
+
+static const struct file_operations fops_ani_enable = {
+	.read = ath10k_read_ani_enable,
+	.write = ath10k_write_ani_enable,
+	.open = simple_open,
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,
+};
+
 static const struct file_operations fops_cal_data = {
 	.open = ath10k_debug_cal_data_open,
 	.read = ath10k_debug_cal_data_read,
@@ -2068,6 +2123,9 @@ int ath10k_debug_register(struct ath10k *ar)
 	debugfs_create_file("cal_data", S_IRUSR, ar->debug.debugfs_phy,
 			    ar, &fops_cal_data);
 
+	debugfs_create_file("ani_enable", S_IRUSR | S_IWUSR,
+			    ar->debug.debugfs_phy, ar, &fops_ani_enable);
+
 	debugfs_create_file("nf_cal_period", S_IRUSR | S_IWUSR,
 			    ar->debug.debugfs_phy, ar, &fops_nf_cal_period);
 
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 380d4b1..366c96f 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -2904,6 +2904,8 @@ static int ath10k_start(struct ieee80211_hw *hw)
 		goto err_core_stop;
 	}
 
+	ar->ani_enabled = true;
+
 	ar->num_started_vdevs = 0;
 	ath10k_regd_update(ar);
 
-- 
1.9.1

