Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:58850 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645AbbJaJHu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Oct 2015 05:07:50 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Yanbo Li <yanbol@qca.qualcomm.com>
Subject: [PATCH] ath10k: debugfs file to enable Bluetooth coexistence feature
Date: Sat, 31 Oct 2015 11:07:21 +0200
Message-ID: <1446282441-19368-1-git-send-email-kvalo@qca.qualcomm.com> (sfid-20151031_100756_377994_CD7B647C)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yanbo Li <yanbol@qca.qualcomm.com>

As not all QCA98XX radios are not connected to Bluetooth modules, enabling the
BT coex feature in firmware will have side effects if the radio's GPIO are
connected with other (non-BT) HW modules. Add debugfs file to control the
firmware BT coex logic and set the feature as disable by default to avoid that
btcoex is accidentally enabled.

To enable this feature, execute:

echo 1 > /sys/kernel/debug/ieee80211/phyX/ath10k/btcoex

To disable:

echo 0 > /sys/kernel/debug/ieee80211/phyX/ath10k/btcoex

The firmware support this feature since 10.2.4.54 on 2G-only board, dual band
or 5G boards don't support this. The feature's name is WMI_SERVICE_COEX_GPIO
and the btcoex file is not created if firmware doesn't support it.

Signed-off-by: Yanbo Li <yanbol@qca.qualcomm.com>
[kvalo@qca.qualcomm.com: use btcoex filename and other smaller fixes]
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---

v5:

* use filename btcoex to match with ath9k
* allow changing the value when interface is down
* print a reason why firmware is restarted
* only create the btcoex file if the WMI service is enabled

 drivers/net/wireless/ath/ath10k/core.h  |    3 ++
 drivers/net/wireless/ath/ath10k/debug.c |   66 +++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.c   |    5 ++-
 3 files changed, 73 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 4a2301589902..ea10dac7c811 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -534,6 +534,9 @@ enum ath10k_dev_flags {
 
 	/* Disable HW crypto engine */
 	ATH10K_FLAG_HW_CRYPTO_DISABLED,
+
+	/* Bluetooth coexistance enabled */
+	ATH10K_FLAG_BTCOEX,
 };
 
 enum ath10k_cal_mode {
diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 6cc1aa3449c8..145c066b5087 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -2074,6 +2074,68 @@ static const struct file_operations fops_quiet_period = {
 	.open = simple_open
 };
 
+static ssize_t ath10k_write_btcoex(struct file *file,
+				   const char __user *ubuf,
+				   size_t count, loff_t *ppos)
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
+
+	if (strtobool(buf, &val) != 0)
+		return -EINVAL;
+
+	mutex_lock(&ar->conf_mutex);
+
+	if (!(test_bit(ATH10K_FLAG_BTCOEX, &ar->dev_flags) ^ val))
+		goto exit;
+
+	if (val)
+		set_bit(ATH10K_FLAG_BTCOEX, &ar->dev_flags);
+	else
+		clear_bit(ATH10K_FLAG_BTCOEX, &ar->dev_flags);
+
+	if (ar->state != ATH10K_STATE_ON)
+		goto exit;
+
+	ath10k_info(ar, "restarting firmware due to btcoex change");
+
+	queue_work(ar->workqueue, &ar->restart_work);
+
+exit:
+	mutex_unlock(&ar->conf_mutex);
+
+	return count;
+}
+
+static ssize_t ath10k_read_btcoex(struct file *file, char __user *ubuf,
+				  size_t count, loff_t *ppos)
+{
+	char buf[32];
+	struct ath10k *ar = file->private_data;
+	int len = 0;
+
+	mutex_lock(&ar->conf_mutex);
+	len = scnprintf(buf, sizeof(buf) - len, "%d\n",
+			test_bit(ATH10K_FLAG_BTCOEX, &ar->dev_flags));
+	mutex_unlock(&ar->conf_mutex);
+
+	return simple_read_from_buffer(ubuf, count, ppos, buf, len);
+}
+
+static const struct file_operations fops_btcoex = {
+	.read = ath10k_read_btcoex,
+	.write = ath10k_write_btcoex,
+	.open = simple_open
+};
+
 int ath10k_debug_create(struct ath10k *ar)
 {
 	ar->debug.fw_crash_data = vzalloc(sizeof(*ar->debug.fw_crash_data));
@@ -2183,6 +2245,10 @@ int ath10k_debug_register(struct ath10k *ar)
 	debugfs_create_file("tpc_stats", S_IRUSR,
 			    ar->debug.debugfs_phy, ar, &fops_tpc_stats);
 
+	if (test_bit(WMI_SERVICE_COEX_GPIO, ar->wmi.svc_map))
+		debugfs_create_file("btcoex", S_IRUGO | S_IWUSR,
+				    ar->debug.debugfs_phy, ar, &fops_btcoex);
+
 	return 0;
 }
 
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 7569db0f69b5..5e402a24f8e7 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -5431,8 +5431,11 @@ static struct sk_buff *ath10k_wmi_10_2_op_gen_init(struct ath10k *ar)
 	cmd = (struct wmi_init_cmd_10_2 *)buf->data;
 
 	features = WMI_10_2_RX_BATCH_MODE;
-	if (test_bit(WMI_SERVICE_COEX_GPIO, ar->wmi.svc_map))
+
+	if (test_bit(ATH10K_FLAG_BTCOEX, &ar->dev_flags) &&
+	    test_bit(WMI_SERVICE_COEX_GPIO, ar->wmi.svc_map))
 		features |= WMI_10_2_COEX_GPIO;
+
 	cmd->resource_config.feature_mask = __cpu_to_le32(features);
 
 	memcpy(&cmd->resource_config.common, &config, sizeof(config));
-- 
1.7.9.5

