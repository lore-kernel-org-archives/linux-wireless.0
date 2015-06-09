Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:44633 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753804AbbFIUc7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jun 2015 16:32:59 -0400
From: Yanbo Li <yanbol@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <dreamfly281@gmail.com>, <ath10k@lists.infradead.org>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH v3] ath10k: Debugfs entry to enable/disable WLAN&Blutooth Coexist feature
Date: Tue, 9 Jun 2015 13:29:46 -0700
Message-ID: <1433881786-30354-1-git-send-email-yanbol@qca.qualcomm.com> (sfid-20150609_223302_799737_3AE2ED80)
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
 V3:
 * using dev_flags
 * check state on before restart
 * Add the FW version and limitation support this feature

 drivers/net/wireless/ath/ath10k/core.h  |  2 +
 drivers/net/wireless/ath/ath10k/debug.c | 65 +++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.c   |  3 +-
 3 files changed, 69 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 87376b3283f5..7fc2034ce53d 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -481,6 +481,8 @@ enum ath10k_dev_flags {
 	 * waiters should immediately cancel instead of waiting for a time out.
 	 */
 	ATH10K_FLAG_CRASH_FLUSH,
+	/* Flag for enable the BT/WLAN coexist */
+	ATH10K_FLAG_BTCOEX_ENABLE
 };
 
 enum ath10k_cal_mode {
diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 8fa606a9c4dd..a5da7c96d81a 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -2092,6 +2092,69 @@ static const struct file_operations fops_quiet_period = {
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
@@ -2195,6 +2258,8 @@ int ath10k_debug_register(struct ath10k *ar)
 	debugfs_create_file("quiet_period", S_IRUGO | S_IWUSR,
 			    ar->debug.debugfs_phy, ar, &fops_quiet_period);
 
+	debugfs_create_file("btc_feature", S_IRUGO | S_IWUSR,
+			    ar->debug.debugfs_phy, ar, &fops_btc_feature);
 	return 0;
 }
 
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 77220b0f0e89..98e0b087d080 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -3936,7 +3936,8 @@ static struct sk_buff *ath10k_wmi_10_2_op_gen_init(struct ath10k *ar)
 	cmd = (struct wmi_init_cmd_10_2 *)buf->data;
 
 	features = WMI_10_2_RX_BATCH_MODE;
-	if (test_bit(WMI_SERVICE_COEX_GPIO, ar->wmi.svc_map))
+	if (test_bit(ATH10K_FLAG_BTCOEX_ENABLE, &ar->dev_flags) &&
+	    test_bit(WMI_SERVICE_COEX_GPIO, ar->wmi.svc_map))
 		features |= WMI_10_2_COEX_GPIO;
 	cmd->resource_config.feature_mask = __cpu_to_le32(features);
 
-- 
1.9.1

