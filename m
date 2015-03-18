Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:61884 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756162AbbCRSCS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Mar 2015 14:02:18 -0400
From: Ashok Raj Nagarajan <arnagara@qti.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	Ashok Raj Nagarajan <arnagara@qti.qualcomm.com>
Subject: [PATCH 2/2] ath10k: allow user to toggle ani_enable via debugfs
Date: Wed, 18 Mar 2015 23:31:40 +0530
Message-ID: <1426701700-21974-2-git-send-email-arnagara@qti.qualcomm.com> (sfid-20150318_190222_209970_BAF3A20D)
In-Reply-To: <1426701700-21974-1-git-send-email-arnagara@qti.qualcomm.com>
References: <1426701700-21974-1-git-send-email-arnagara@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Now that ANI is enabled by default, allow user to disable or enable ANI feature
from debugfs

Signed-off-by: Ashok Raj Nagarajan <arnagara@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.h  |  1 +
 drivers/net/wireless/ath/ath10k/debug.c | 58 +++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/mac.c   |  1 +
 3 files changed, 60 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 7cba781..1359d2c 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -510,6 +510,7 @@ struct ath10k {
 	u32 ht_cap_info;
 	u32 vht_cap_info;
 	u32 num_rf_chains;
+	bool ani_enabled;
 
 	DECLARE_BITMAP(fw_features, ATH10K_FW_FEATURE_COUNT);
 
diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 301081d..95f2a29 100644
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
+	if (ar->ani_enabled == enable)
+		return count;
+
+	mutex_lock(&ar->conf_mutex);
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
+	ath10k_dbg(ar, ATH10K_DBG_WMI, "ANI is %s\n",
+		   enable ? "enabled" : "disabled");
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
index 380d4b1..456aa3c 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -2903,6 +2903,7 @@ static int ath10k_start(struct ieee80211_hw *hw)
 			    ret);
 		goto err_core_stop;
 	}
+	ar->ani_enabled = 1;
 
 	ar->num_started_vdevs = 0;
 	ath10k_regd_update(ar);
-- 
1.9.1

