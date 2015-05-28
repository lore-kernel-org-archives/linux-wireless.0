Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:10682 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271AbbE1TVp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 May 2015 15:21:45 -0400
From: Yanbo Li <yanbol@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <dreamfly281@gmail.com>, <ath10k@lists.infradead.org>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH v2] ath10k: Debugfs entry to enable/disable WLAN&Blutooth Coexist feature
Date: Thu, 28 May 2015 12:19:05 -0700
Message-ID: <1432840745-21725-1-git-send-email-yanbol@qca.qualcomm.com> (sfid-20150528_212149_292102_4617E340)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As some radio have no connection with BT modules, enable the WLAN/Bluetooth
coexist(BTC) feature will has some side effect if the radio's GPIO connect
with any other HW modules. Add the control switcher "btc_feature" at
debugfs and set the feature as disable by default to avoid such case.

To enable this feature, execute:
echo 1 > /sys/kernel/debug/ieee80211/phyX/ath10k/btc_feature
To disable:
echo 0 > /sys/kernel/debug/ieee80211/phyX/ath10k/btc_feature

Signed-off-by: Yanbo Li <yanbol@qca.qualcomm.com>

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 70fcdc9c2758..4a84e17016c9 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -728,6 +728,8 @@ struct ath10k {
 		u32 fw_cold_reset_counter;
 	} stats;
 
+	bool btc_feature;
+
 	struct ath10k_thermal thermal;
 	struct ath10k_wow wow;
 
diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 8fa606a9c4dd..820a12bc0dd8 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -2092,6 +2092,56 @@ static const struct file_operations fops_quiet_period = {
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
+
+	buf_size = min(count, (sizeof(buf) - 1));
+	if (copy_from_user(buf, ubuf, buf_size))
+		return -EFAULT;
+
+	buf[buf_size] = '\0';
+	if (strtobool(buf, &val) != 0) {
+		ath10k_warn(ar, "Wrong BTC feature setting\n");
+		return -EINVAL;
+	}
+
+	mutex_lock(&ar->conf_mutex);
+	if (val != ar->btc_feature) {
+		ar->btc_feature = val;
+		queue_work(ar->workqueue, &ar->restart_work);
+	}
+	mutex_unlock(&ar->conf_mutex);
+
+	return count;
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
+			ar->btc_feature);
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
@@ -2195,6 +2245,8 @@ int ath10k_debug_register(struct ath10k *ar)
 	debugfs_create_file("quiet_period", S_IRUGO | S_IWUSR,
 			    ar->debug.debugfs_phy, ar, &fops_quiet_period);
 
+	debugfs_create_file("btc_feature", S_IRUGO | S_IWUSR,
+			    ar->debug.debugfs_phy, ar, &fops_btc_feature);
 	return 0;
 }
 
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 0fabe689179c..e3c880230ee6 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -3933,7 +3933,8 @@ static struct sk_buff *ath10k_wmi_10_2_op_gen_init(struct ath10k *ar)
 	cmd = (struct wmi_init_cmd_10_2 *)buf->data;
 
 	features = WMI_10_2_RX_BATCH_MODE;
-	if (test_bit(WMI_SERVICE_COEX_GPIO, ar->wmi.svc_map))
+	if (ar->btc_feature &&
+	    test_bit(WMI_SERVICE_COEX_GPIO, ar->wmi.svc_map))
 		features |= WMI_10_2_COEX_GPIO;
 	cmd->resource_config.feature_mask = __cpu_to_le32(features);
 
-- 
1.9.1

