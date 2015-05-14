Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:18268 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752884AbbENJPR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 May 2015 05:15:17 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH] ath10k: Add debugfs support to configure beacon tx mode
Date: Thu, 14 May 2015 14:44:45 +0530
Message-ID: <1431594885-32346-1-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20150514_111524_532983_40E4931D)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Introduce debugfs entry to select beacon tx mode to
staggered or bursted mode. In staggered mode, software beacon
alert will be evenly distributed for each beaconing interfaces
by (beacon intval / number of vif). In bursted mode, batch of
beacons will be sent out as batch at beacon interval.

By default, staggered mode is selected.

To select bursted mode

echo 1 > /sys/kernel/debug/ieee80211/phyX/ath10k/beacon_tx_mode

For staggered mode,

echo 0 > /sys/kernel/debug/ieee80211/phyX/ath10k/beacon_tx_mode

Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.h  |  1 +
 drivers/net/wireless/ath/ath10k/debug.c | 60 +++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/mac.c   |  9 ++---
 drivers/net/wireless/ath/ath10k/mac.h   |  1 +
 4 files changed, 67 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 827b3d7..be85b1f 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -394,6 +394,7 @@ struct ath10k_debug {
 	u8 htt_max_ampdu;
 
 	struct ath10k_fw_crash_data *fw_crash_data;
+	enum wmi_beacon_gen_mode beacon_tx_mode;
 };
 
 enum ath10k_state {
diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 8fa606a..de63465 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -24,6 +24,7 @@
 #include "debug.h"
 #include "hif.h"
 #include "wmi-ops.h"
+#include "mac.h"
 
 /* ms */
 #define ATH10K_DEBUG_HTT_STATS_INTERVAL 1000
@@ -1885,6 +1886,7 @@ int ath10k_debug_start(struct ath10k *ar)
 			ath10k_warn(ar, "cal period cfg failed from debug start: %d\n",
 				    ret);
 	}
+	ar->debug.beacon_tx_mode = WMI_BEACON_STAGGERED_MODE;
 
 	return ret;
 }
@@ -2092,6 +2094,61 @@ static const struct file_operations fops_quiet_period = {
 	.open = simple_open
 };
 
+static ssize_t ath10k_write_beacon_tx_mode(struct file *file,
+					   const char __user *ubuf,
+					   size_t count, loff_t *ppos)
+{
+	struct ath10k *ar = file->private_data;
+	u32 beacon_tx_mode;
+	int ret;
+
+	if (kstrtouint_from_user(ubuf, count, 0, &beacon_tx_mode))
+		return -EINVAL;
+
+	if (beacon_tx_mode > WMI_BEACON_BURST_MODE) {
+		ath10k_warn(ar, "Invalid beaconing mode configured: %d\n",
+			    beacon_tx_mode);
+		return -EINVAL;
+	}
+	mutex_lock(&ar->conf_mutex);
+	ret = ath10k_wmi_pdev_set_param(ar, ar->wmi.pdev_param->beacon_tx_mode,
+					beacon_tx_mode);
+	if (ret) {
+		ath10k_warn(ar, "failed to set beacon tx mode: %d\n", ret);
+		mutex_unlock(&ar->conf_mutex);
+		return ret;
+	}
+
+	ath10k_mac_chan_reconfigure(ar);
+	ar->debug.beacon_tx_mode = beacon_tx_mode;
+	mutex_unlock(&ar->conf_mutex);
+
+	return count;
+}
+
+static ssize_t ath10k_read_beacon_tx_mode(struct file *file, char __user *ubuf,
+					  size_t count, loff_t *ppos)
+{
+	char buf[100];
+	struct ath10k *ar = file->private_data;
+	int len = 0;
+
+	mutex_lock(&ar->conf_mutex);
+	len = scnprintf(buf + len, sizeof(buf) - len,
+			"available beaconing modes: 0 - staggered 1 - bursted\n");
+	len += scnprintf(buf + len, sizeof(buf) - len, "current mode: %s\n",
+			 (ar->debug.beacon_tx_mode) ? "bursted" : "staggered");
+	mutex_unlock(&ar->conf_mutex);
+
+	return simple_read_from_buffer(ubuf, count, ppos, buf, len);
+}
+
+static const struct file_operations fops_beacon_tx_mode = {
+	.read = ath10k_read_beacon_tx_mode,
+	.write = ath10k_write_beacon_tx_mode,
+	.open = simple_open
+};
+
 int ath10k_debug_create(struct ath10k *ar)
 {
 	ar->debug.fw_crash_data = vzalloc(sizeof(*ar->debug.fw_crash_data));
@@ -2195,6 +2252,9 @@ int ath10k_debug_register(struct ath10k *ar)
 	debugfs_create_file("quiet_period", S_IRUGO | S_IWUSR,
 			    ar->debug.debugfs_phy, ar, &fops_quiet_period);
 
+	debugfs_create_file("beacon_tx_mode", S_IRUGO | S_IWUSR,
+			    ar->debug.debugfs_phy, ar, &fops_beacon_tx_mode);
+
 	return 0;
 }
 
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 425dbe2..898b821 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -3969,7 +3969,7 @@ static int ath10k_config_ps(struct ath10k *ar)
 	return ret;
 }
 
-static void ath10k_mac_chan_reconfigure(struct ath10k *ar)
+void ath10k_mac_chan_reconfigure(struct ath10k *ar)
 {
 	struct ath10k_vif *arvif;
 	struct cfg80211_chan_def def;
@@ -4556,12 +4556,13 @@ static void ath10k_bss_info_changed(struct ieee80211_hw *hw,
 
 	if (changed & BSS_CHANGED_BEACON) {
 		ath10k_dbg(ar, ATH10K_DBG_MAC,
-			   "vdev %d set beacon tx mode to staggered\n",
-			   arvif->vdev_id);
+			   "vdev %d set beacon tx mode to %s\n",
+			   arvif->vdev_id,
+			   ar->debug.beacon_tx_mode ? "bursted" : "staggered");
 
 		pdev_param = ar->wmi.pdev_param->beacon_tx_mode;
 		ret = ath10k_wmi_pdev_set_param(ar, pdev_param,
-						WMI_BEACON_STAGGERED_MODE);
+						ar->debug.beacon_tx_mode);
 		if (ret)
 			ath10k_warn(ar, "failed to set beacon mode for vdev %d: %i\n",
 				    arvif->vdev_id, ret);
diff --git a/drivers/net/wireless/ath/ath10k/mac.h b/drivers/net/wireless/ath/ath10k/mac.h
index b291f06..a765ae8 100644
--- a/drivers/net/wireless/ath/ath10k/mac.h
+++ b/drivers/net/wireless/ath/ath10k/mac.h
@@ -74,6 +74,7 @@ void ath10k_mac_tx_lock(struct ath10k *ar, int reason);
 void ath10k_mac_tx_unlock(struct ath10k *ar, int reason);
 void ath10k_mac_vif_tx_lock(struct ath10k_vif *arvif, int reason);
 void ath10k_mac_vif_tx_unlock(struct ath10k_vif *arvif, int reason);
+void ath10k_mac_chan_reconfigure(struct ath10k *ar);
 
 static inline struct ath10k_vif *ath10k_vif_to_arvif(struct ieee80211_vif *vif)
 {
-- 
2.4.0

