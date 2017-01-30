Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:61833 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751711AbdA3GCb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 30 Jan 2017 01:02:31 -0500
From: <c_mkenna@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>, <mkenna@codeaurora.org>,
        "Maharaja Kennadyrajan" <c_mkenna@qti.qualcomm.com>
Subject: [PATCH] ath10k: Add debugfs support to get per peer tids log via tracing
Date: Mon, 30 Jan 2017 11:32:27 +0530
Message-ID: <1485756147-13762-1-git-send-email-c_mkenna@qti.qualcomm.com> (sfid-20170130_070237_005326_DE8EF11F)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Maharaja Kennadyrajan <c_mkenna@qti.qualcomm.com>

This patch provides support to get per peer tids log.

echo 1 > /sys/kernel/debug/ieee80211/phyX/netdev\:wlanX/stations/
XX:XX/peer_debug_trigger

These logs will be the part of FWLOGS which we collect the logs
via tracing interface. Here we will get the peer tigd logs only
once(not repeatedly) when we write 1 to the debugfs file.

Signed-off-by: Maharaja Kennadyrajan <c_mkenna@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/debugfs_sta.c |   65 +++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.h         |    1 +
 2 files changed, 66 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/debugfs_sta.c b/drivers/net/wireless/ath/ath10k/debugfs_sta.c
index fce6f81..7353e7e 100644
--- a/drivers/net/wireless/ath/ath10k/debugfs_sta.c
+++ b/drivers/net/wireless/ath/ath10k/debugfs_sta.c
@@ -306,6 +306,69 @@ static ssize_t ath10k_dbg_sta_write_delba(struct file *file,
 	.llseek = default_llseek,
 };
 
+static ssize_t ath10k_dbg_sta_read_peer_debug_trigger(struct file *file,
+						      char __user *user_buf,
+						      size_t count,
+						      loff_t *ppos)
+{
+	struct ieee80211_sta *sta = file->private_data;
+	struct ath10k_sta *arsta = (struct ath10k_sta *)sta->drv_priv;
+	struct ath10k *ar = arsta->arvif->ar;
+	char buf[8];
+	int len = 0;
+
+	mutex_lock(&ar->conf_mutex);
+	len = scnprintf(buf, sizeof(buf) - len,
+			"Write 1 to once trigger the debug logs\n");
+	mutex_unlock(&ar->conf_mutex);
+
+	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
+}
+
+static ssize_t
+ath10k_dbg_sta_write_peer_debug_trigger(struct file *file,
+					const char __user *user_buf,
+					size_t count, loff_t *ppos)
+{
+	struct ieee80211_sta *sta = file->private_data;
+	struct ath10k_sta *arsta = (struct ath10k_sta *)sta->drv_priv;
+	struct ath10k *ar = arsta->arvif->ar;
+	u8 peer_debug_trigger;
+	int ret;
+
+	if (kstrtou8_from_user(user_buf, count, 0, &peer_debug_trigger))
+		return -EINVAL;
+
+	if (peer_debug_trigger != 1)
+		return -EINVAL;
+
+	mutex_lock(&ar->conf_mutex);
+
+	if (ar->state != ATH10K_STATE_ON) {
+		ret = -ENETDOWN;
+		goto out;
+	}
+
+	ret = ath10k_wmi_peer_set_param(ar, arsta->arvif->vdev_id, sta->addr,
+					WMI_PEER_DEBUG, peer_debug_trigger);
+	if (ret) {
+		ath10k_warn(ar, "failed to set param to trigger peer tid logs for station ret: %d\n",
+			    ret);
+		goto out;
+	}
+out:
+	mutex_unlock(&ar->conf_mutex);
+	return count;
+}
+
+static const struct file_operations fops_peer_debug_trigger = {
+	.open = simple_open,
+	.read = ath10k_dbg_sta_read_peer_debug_trigger,
+	.write = ath10k_dbg_sta_write_peer_debug_trigger,
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,
+};
+
 void ath10k_sta_add_debugfs(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			    struct ieee80211_sta *sta, struct dentry *dir)
 {
@@ -314,4 +377,6 @@ void ath10k_sta_add_debugfs(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	debugfs_create_file("addba", S_IWUSR, dir, sta, &fops_addba);
 	debugfs_create_file("addba_resp", S_IWUSR, dir, sta, &fops_addba_resp);
 	debugfs_create_file("delba", S_IWUSR, dir, sta, &fops_delba);
+	debugfs_create_file("peer_debug_trigger", 0600, dir, sta,
+			    &fops_peer_debug_trigger);
 }
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 861c2d8..1b1c1ef 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -5811,6 +5811,7 @@ enum wmi_peer_param {
 	WMI_PEER_CHAN_WIDTH = 0x4,
 	WMI_PEER_NSS        = 0x5,
 	WMI_PEER_USE_4ADDR  = 0x6,
+	WMI_PEER_DEBUG      = 0xa,
 	WMI_PEER_DUMMY_VAR  = 0xff, /* dummy parameter for STA PS workaround */
 };
 
-- 
1.7.9.5
