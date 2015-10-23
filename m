Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:52342 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923AbbJWXyy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Oct 2015 19:54:54 -0400
From: Yanbo Li <yanbol@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <dreamfly281@gmail.com>, <ath10k@lists.infradead.org>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH V4] ath10k: Debugfs entry to enable/disable WLAN&Blutooth Coexist feature
Date: Fri, 23 Oct 2015 16:54:24 -0700
Message-ID: <1445644464-8454-1-git-send-email-yanbol@qca.qualcomm.com> (sfid-20151024_015529_449996_CC8D1930)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As some radio have no connection with BT modules, enable the WLAN/Bluetooth
coexist(BTC) feature will has some side effect if the radio's GPIO connect
with any other HW modules. Add the control switcher "btc_feature" at
debugfs and set the feature as disable by default to avoid such case.

The FW support this feature since 10.2.4.54 on 2G-only board, dual band
or 5G boards don't support the feature

To enable this feature, execute:
echo 1 > /sys/kernel/debug/ieee80211/phyX/ath10k/btc_feature
To disable:
echo 0 > /sys/kernel/debug/ieee80211/phyX/ath10k/btc_feature

Signed-off-by: Yanbo Li <yanbol@qca.qualcomm.com>
---
Notes:
Resend cause the patch be missed from the mail list. 
No change compare with V3, just rebase on the newest ath tree.
The previous thread can be from:
https://www.mail-archive.com/ath10k@lists.infradead.org/msg02596.html

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 7cc7cdd56c95..6ce3cd28fa86 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -519,6 +519,9 @@ enum ath10k_dev_flags {
 
 	/* Disable HW crypto engine */
 	ATH10K_FLAG_HW_CRYPTO_DISABLED,
+
+	/* Flag for enable the BT/WLAN coexist */
+	ATH10K_FLAG_BTCOEX_ENABLE
 };
 
 enum ath10k_cal_mode {
diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 6cc1aa3449c8..1f27c066c571 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -2074,6 +2074,69 @@ static const struct file_operations fops_quiet_period = {
 	.open = simple_open
 };
 
+static ssize_t ath10k_write_btc_feature(struct file *file,
+					const char __user *ubuf,
+					size_t count, loff_t *ppos)
+{
+	struct ath10k *ar = file->private_data;
+	char buf[32];
+	size_t buf_size;
+	bool val;
+	int ret;
+
+	buf_size = min(count, (sizeof(buf) - 1));
+	if (copy_from_user(buf, ubuf, buf_size))
+		return -EFAULT;
+
+	buf[buf_size] = '\0';
+	if (strtobool(buf, &val) != 0) {
+		ath10k_warn(ar, "Wrong BTcoex feature setting\n");
+		return -EINVAL;
+	}
+
+	mutex_lock(&ar->conf_mutex);
+
+	if (ar->state != ATH10K_STATE_ON) {
+		ret = -ENETDOWN;
+		goto err_unlock;
+	}
+
+	if (val != test_bit(ATH10K_FLAG_BTCOEX_ENABLE, &ar->dev_flags)) {
+		if (val)
+			set_bit(ATH10K_FLAG_BTCOEX_ENABLE, &ar->dev_flags);
+		else
+			clear_bit(ATH10K_FLAG_BTCOEX_ENABLE, &ar->dev_flags);
+		queue_work(ar->workqueue, &ar->restart_work);
+	}
+
+	ret = count;
+
+err_unlock:
+	mutex_unlock(&ar->conf_mutex);
+	return ret;
+}
+
+static ssize_t ath10k_read_btc_feature(struct file *file, char __user *ubuf,
+				       size_t count, loff_t *ppos)
+{
+	char buf[32];
+	struct ath10k *ar = file->private_data;
+	int len = 0;
+
+	mutex_lock(&ar->conf_mutex);
+	len = scnprintf(buf, sizeof(buf) - len, "%d\n",
+			test_bit(ATH10K_FLAG_BTCOEX_ENABLE, &ar->dev_flags));
+	mutex_unlock(&ar->conf_mutex);
+
+	return simple_read_from_buffer(ubuf, count, ppos, buf, len);
+}
+
+static const struct file_operations fops_btc_feature = {
+	.read = ath10k_read_btc_feature,
+	.write = ath10k_write_btc_feature,
+	.open = simple_open
+};
+
 int ath10k_debug_create(struct ath10k *ar)
 {
 	ar->debug.fw_crash_data = vzalloc(sizeof(*ar->debug.fw_crash_data));
@@ -2183,6 +2246,8 @@ int ath10k_debug_register(struct ath10k *ar)
 	debugfs_create_file("tpc_stats", S_IRUSR,
 			    ar->debug.debugfs_phy, ar, &fops_tpc_stats);
 
+	debugfs_create_file("btc_feature", S_IRUGO | S_IWUSR,
+			    ar->debug.debugfs_phy, ar, &fops_btc_feature);
 	return 0;
 }
 
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 6e7d7a7f6a97..ef4b260beb63 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -5301,7 +5301,8 @@ static struct sk_buff *ath10k_wmi_10_2_op_gen_init(struct ath10k *ar)
 	cmd = (struct wmi_init_cmd_10_2 *)buf->data;
 
 	features = WMI_10_2_RX_BATCH_MODE;
-	if (test_bit(WMI_SERVICE_COEX_GPIO, ar->wmi.svc_map))
+	if (test_bit(ATH10K_FLAG_BTCOEX_ENABLE, &ar->dev_flags) &&
+	    test_bit(WMI_SERVICE_COEX_GPIO, ar->wmi.svc_map))
 		features |= WMI_10_2_COEX_GPIO;
 	cmd->resource_config.feature_mask = __cpu_to_le32(features);
 
-- 
1.9.1

