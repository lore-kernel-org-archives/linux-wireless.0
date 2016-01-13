Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:34089 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675AbcAMPsq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jan 2016 10:48:46 -0500
From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: Kalle Valo <kvalo@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
Subject: [PATCH 7/7] ath10k: Add debugfs support for Per STA total rx duration
Date: Wed, 13 Jan 2016 21:16:34 +0530
Message-ID: <1452699994-5078-8-git-send-email-mohammed@qca.qualcomm.com> (sfid-20160113_164851_740473_26A3DAF6)
In-Reply-To: <1452699994-5078-1-git-send-email-mohammed@qca.qualcomm.com>
References: <1452699994-5078-1-git-send-email-mohammed@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>

Add debugfs support for per client total rx duration, track this
via the report of Peer stats rx duration reported for every 500ms

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.h        |    1 +
 drivers/net/wireless/ath/ath10k/debug.c       |    9 ++++--
 drivers/net/wireless/ath/ath10k/debug.h       |    6 ++++
 drivers/net/wireless/ath/ath10k/debugfs_sta.c |   41 +++++++++++++++++++++++++
 4 files changed, 54 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index d47a085..921b86a 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -316,6 +316,7 @@ struct ath10k_sta {
 #ifdef CONFIG_MAC80211_DEBUGFS
 	/* protected by conf_mutex */
 	bool aggr_mode;
+	u64 rx_duration;
 #endif
 };
 
diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 3b8da81..8d4148a 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -319,7 +319,7 @@ static void ath10k_debug_fw_stats_reset(struct ath10k *ar)
 void ath10k_debug_fw_stats_process(struct ath10k *ar, struct sk_buff *skb)
 {
 	struct ath10k_fw_stats stats = {};
-	bool is_start, is_started, is_end;
+	bool is_start, is_started, is_end, peer_stats_svc;
 	size_t num_peers;
 	size_t num_vdevs;
 	int ret;
@@ -347,8 +347,8 @@ void ath10k_debug_fw_stats_process(struct ath10k *ar, struct sk_buff *skb)
 	 *     delivered which is treated as end-of-data and is itself discarded
 	 */
 
-	if (ar->debug.fw_stats_done &&
-	    !test_bit(WMI_SERVICE_PEER_STATS, ar->wmi.svc_map)) {
+	peer_stats_svc = test_bit(WMI_SERVICE_PEER_STATS, ar->wmi.svc_map);
+	if (ar->debug.fw_stats_done && !peer_stats_svc) {
 		ath10k_warn(ar, "received unsolicited stats update event\n");
 		goto free;
 	}
@@ -384,6 +384,9 @@ void ath10k_debug_fw_stats_process(struct ath10k *ar, struct sk_buff *skb)
 			goto free;
 		}
 
+		if (peer_stats_svc)
+			ath10k_sta_update_rx_duration(ar, &stats.peers);
+
 		list_splice_tail_init(&stats.peers, &ar->debug.fw_stats.peers);
 		list_splice_tail_init(&stats.vdevs, &ar->debug.fw_stats.vdevs);
 	}
diff --git a/drivers/net/wireless/ath/ath10k/debug.h b/drivers/net/wireless/ath/ath10k/debug.h
index 814719c..f273478 100644
--- a/drivers/net/wireless/ath/ath10k/debug.h
+++ b/drivers/net/wireless/ath/ath10k/debug.h
@@ -153,6 +153,12 @@ ath10k_debug_get_new_fw_crash_data(struct ath10k *ar)
 #ifdef CONFIG_MAC80211_DEBUGFS
 void ath10k_sta_add_debugfs(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			    struct ieee80211_sta *sta, struct dentry *dir);
+void ath10k_sta_update_rx_duration(struct ath10k *ar, struct list_head *peer);
+#else
+static inline void ath10k_sta_update_rx_duration(struct ath10k *ar,
+						 struct list_head *peer)
+{
+}
 #endif /* CONFIG_MAC80211_DEBUGFS */
 
 #ifdef CONFIG_ATH10K_DEBUG
diff --git a/drivers/net/wireless/ath/ath10k/debugfs_sta.c b/drivers/net/wireless/ath/ath10k/debugfs_sta.c
index 95b5c49..67ef75b 100644
--- a/drivers/net/wireless/ath/ath10k/debugfs_sta.c
+++ b/drivers/net/wireless/ath/ath10k/debugfs_sta.c
@@ -18,6 +18,23 @@
 #include "wmi-ops.h"
 #include "debug.h"
 
+void ath10k_sta_update_rx_duration(struct ath10k *ar, struct list_head *head)
+{	struct ieee80211_sta *sta;
+	struct ath10k_fw_stats_peer *peer;
+	struct ath10k_sta *arsta;
+
+	rcu_read_lock();
+	list_for_each_entry(peer, head, list) {
+		sta = ieee80211_find_sta_by_ifaddr(ar->hw, peer->peer_macaddr,
+						   NULL);
+		if (!sta)
+			continue;
+		arsta = (struct ath10k_sta *)sta->drv_priv;
+		arsta->rx_duration += (u64)peer->rx_duration;
+	}
+	rcu_read_unlock();
+}
+
 static ssize_t ath10k_dbg_sta_read_aggr_mode(struct file *file,
 					     char __user *user_buf,
 					     size_t count, loff_t *ppos)
@@ -232,6 +249,28 @@ static const struct file_operations fops_delba = {
 	.llseek = default_llseek,
 };
 
+static ssize_t ath10k_dbg_sta_read_rx_duration(struct file *file,
+					       char __user *user_buf,
+					       size_t count, loff_t *ppos)
+{
+	struct ieee80211_sta *sta = file->private_data;
+	struct ath10k_sta *arsta = (struct ath10k_sta *)sta->drv_priv;
+	char buf[100];
+	int len = 0;
+
+	len = scnprintf(buf, sizeof(buf),
+			"%llu usecs\n", arsta->rx_duration);
+
+	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
+}
+
+static const struct file_operations fops_rx_duration = {
+	.read = ath10k_dbg_sta_read_rx_duration,
+	.open = simple_open,
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,
+};
+
 void ath10k_sta_add_debugfs(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			    struct ieee80211_sta *sta, struct dentry *dir)
 {
@@ -240,4 +279,6 @@ void ath10k_sta_add_debugfs(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	debugfs_create_file("addba", S_IWUSR, dir, sta, &fops_addba);
 	debugfs_create_file("addba_resp", S_IWUSR, dir, sta, &fops_addba_resp);
 	debugfs_create_file("delba", S_IWUSR, dir, sta, &fops_delba);
+	debugfs_create_file("rx_duration", S_IRUGO, dir, sta,
+			    &fops_rx_duration);
 }
-- 
1.7.9.5

