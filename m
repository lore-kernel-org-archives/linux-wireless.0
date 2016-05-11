Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:16209 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129AbcEKGXa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 May 2016 02:23:30 -0400
From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <mohammed@codeaurora.org>, <linux-wireless@vger.kernel.org>,
	"Mohammed Shafi Shajakhan" <mohammed@qti.qualcomm.com>
Subject: [PATCH v1] ath10k: Fix 10.4 extended peer stats update
Date: Wed, 11 May 2016 11:54:30 +0530
Message-ID: <1462947870-17196-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20160511_082334_866443_BCD8FD78)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>

10.4 'extended peer stats' will be not be appended with normal peer stats
data and they shall be coming in separate chunks. Fix this by maintaining
a separate linked list 'extender peer stats' for 10.4 and update
rx_duration for per station statistics. Also parse through beacon filter
(if enabled), to make sure we parse the extended peer stats properly.
This issue was exposed when more than one client is connected and
extended peer stats for 10.4 is enabled

The order for the stats is as below
S - standard peer stats, E- extended peer stats, B - beacon filter stats

{S1, S2, S3..} -> {B1, B2, B3..}(if available) -> {E1, E2, E3..}

Fixes: f9575793d44c ("ath10k: enable parsing per station rx duration for 10.4")
Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
---

[v1: Fixed line wrap around suggested by Kalle)

 drivers/net/wireless/ath/ath10k/core.h        |    8 ++++
 drivers/net/wireless/ath/ath10k/debug.c       |   18 ++++++++-
 drivers/net/wireless/ath/ath10k/debug.h       |    8 ++--
 drivers/net/wireless/ath/ath10k/debugfs_sta.c |   34 +++++++++++++++-
 drivers/net/wireless/ath/ath10k/wmi.c         |   53 ++++++++++++++++++-------
 drivers/net/wireless/ath/ath10k/wmi.h         |   14 ++++++-
 6 files changed, 115 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 1852e0e..7ea6bc4 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -165,6 +165,13 @@ struct ath10k_fw_stats_peer {
 	u32 rx_duration;
 };
 
+struct ath10k_fw_extd_stats_peer {
+	struct list_head list;
+
+	u8 peer_macaddr[ETH_ALEN];
+	u32 rx_duration;
+};
+
 struct ath10k_fw_stats_vdev {
 	struct list_head list;
 
@@ -259,6 +266,7 @@ struct ath10k_fw_stats {
 	struct list_head pdevs;
 	struct list_head vdevs;
 	struct list_head peers;
+	struct list_head peers_extd;
 };
 
 #define ATH10K_TPC_TABLE_TYPE_FLAG	1
diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index e251155..c07eb3f 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -313,6 +313,16 @@ static void ath10k_fw_stats_peers_free(struct list_head *head)
 	}
 }
 
+static void ath10k_fw_extd_stats_peers_free(struct list_head *head)
+{
+	struct ath10k_fw_extd_stats_peer *i, *tmp;
+
+	list_for_each_entry_safe(i, tmp, head, list) {
+		list_del(&i->list);
+		kfree(i);
+	}
+}
+
 static void ath10k_debug_fw_stats_reset(struct ath10k *ar)
 {
 	spin_lock_bh(&ar->data_lock);
@@ -320,6 +330,7 @@ static void ath10k_debug_fw_stats_reset(struct ath10k *ar)
 	ath10k_fw_stats_pdevs_free(&ar->debug.fw_stats.pdevs);
 	ath10k_fw_stats_vdevs_free(&ar->debug.fw_stats.vdevs);
 	ath10k_fw_stats_peers_free(&ar->debug.fw_stats.peers);
+	ath10k_fw_extd_stats_peers_free(&ar->debug.fw_stats.peers_extd);
 	spin_unlock_bh(&ar->data_lock);
 }
 
@@ -334,6 +345,7 @@ void ath10k_debug_fw_stats_process(struct ath10k *ar, struct sk_buff *skb)
 	INIT_LIST_HEAD(&stats.pdevs);
 	INIT_LIST_HEAD(&stats.vdevs);
 	INIT_LIST_HEAD(&stats.peers);
+	INIT_LIST_HEAD(&stats.peers_extd);
 
 	spin_lock_bh(&ar->data_lock);
 	ret = ath10k_wmi_pull_fw_stats(ar, skb, &stats);
@@ -354,7 +366,7 @@ void ath10k_debug_fw_stats_process(struct ath10k *ar, struct sk_buff *skb)
 	 *     delivered which is treated as end-of-data and is itself discarded
 	 */
 	if (ath10k_peer_stats_enabled(ar))
-		ath10k_sta_update_rx_duration(ar, &stats.peers);
+		ath10k_sta_update_rx_duration(ar, &stats);
 
 	if (ar->debug.fw_stats_done) {
 		if (!ath10k_peer_stats_enabled(ar))
@@ -396,6 +408,8 @@ void ath10k_debug_fw_stats_process(struct ath10k *ar, struct sk_buff *skb)
 
 		list_splice_tail_init(&stats.peers, &ar->debug.fw_stats.peers);
 		list_splice_tail_init(&stats.vdevs, &ar->debug.fw_stats.vdevs);
+		list_splice_tail_init(&stats.peers_extd,
+				      &ar->debug.fw_stats.peers_extd);
 	}
 
 	complete(&ar->debug.fw_stats_complete);
@@ -407,6 +421,7 @@ free:
 	ath10k_fw_stats_pdevs_free(&stats.pdevs);
 	ath10k_fw_stats_vdevs_free(&stats.vdevs);
 	ath10k_fw_stats_peers_free(&stats.peers);
+	ath10k_fw_extd_stats_peers_free(&stats.peers_extd);
 
 	spin_unlock_bh(&ar->data_lock);
 }
@@ -2320,6 +2335,7 @@ int ath10k_debug_create(struct ath10k *ar)
 	INIT_LIST_HEAD(&ar->debug.fw_stats.pdevs);
 	INIT_LIST_HEAD(&ar->debug.fw_stats.vdevs);
 	INIT_LIST_HEAD(&ar->debug.fw_stats.peers);
+	INIT_LIST_HEAD(&ar->debug.fw_stats.peers_extd);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/ath/ath10k/debug.h b/drivers/net/wireless/ath/ath10k/debug.h
index 75c89e3..1a722be 100644
--- a/drivers/net/wireless/ath/ath10k/debug.h
+++ b/drivers/net/wireless/ath/ath10k/debug.h
@@ -154,10 +154,12 @@ ath10k_debug_get_new_fw_crash_data(struct ath10k *ar)
 #ifdef CONFIG_MAC80211_DEBUGFS
 void ath10k_sta_add_debugfs(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			    struct ieee80211_sta *sta, struct dentry *dir);
-void ath10k_sta_update_rx_duration(struct ath10k *ar, struct list_head *peer);
+void ath10k_sta_update_rx_duration(struct ath10k *ar,
+				   struct ath10k_fw_stats *stats);
 #else
-static inline void ath10k_sta_update_rx_duration(struct ath10k *ar,
-						 struct list_head *peer)
+static inline
+void ath10k_sta_update_rx_duration(struct ath10k *ar,
+				   struct ath10k_fw_stats *stats);
 {
 }
 #endif /* CONFIG_MAC80211_DEBUGFS */
diff --git a/drivers/net/wireless/ath/ath10k/debugfs_sta.c b/drivers/net/wireless/ath/ath10k/debugfs_sta.c
index 67ef75b..735092a 100644
--- a/drivers/net/wireless/ath/ath10k/debugfs_sta.c
+++ b/drivers/net/wireless/ath/ath10k/debugfs_sta.c
@@ -18,7 +18,27 @@
 #include "wmi-ops.h"
 #include "debug.h"
 
-void ath10k_sta_update_rx_duration(struct ath10k *ar, struct list_head *head)
+static void ath10k_sta_update_extd_stats_rx_duration(struct ath10k *ar,
+						     struct list_head *head)
+{
+	struct ieee80211_sta *sta;
+	struct ath10k_fw_extd_stats_peer *peer;
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
+static void ath10k_sta_update_stats_rx_duration(struct ath10k *ar,
+						struct list_head *head)
 {	struct ieee80211_sta *sta;
 	struct ath10k_fw_stats_peer *peer;
 	struct ath10k_sta *arsta;
@@ -35,6 +55,18 @@ void ath10k_sta_update_rx_duration(struct ath10k *ar, struct list_head *head)
 	rcu_read_unlock();
 }
 
+void ath10k_sta_update_rx_duration(struct ath10k *ar,
+				   struct ath10k_fw_stats *stats)
+{
+	struct ath10k_fw_file *fw_file = &ar->normal_mode_fw.fw_file;
+
+	if (fw_file->wmi_op_version < ATH10K_FW_WMI_OP_VERSION_10_4)
+		ath10k_sta_update_stats_rx_duration(ar, &stats->peers);
+	else
+		ath10k_sta_update_extd_stats_rx_duration(ar,
+							 &stats->peers_extd);
+}
+
 static ssize_t ath10k_dbg_sta_read_aggr_mode(struct file *file,
 					     char __user *user_buf,
 					     size_t count, loff_t *ppos)
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index f71c1fb..07d82b9 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -2920,6 +2920,7 @@ static int ath10k_wmi_10_4_op_pull_fw_stats(struct ath10k *ar,
 	u32 num_pdev_ext_stats;
 	u32 num_vdev_stats;
 	u32 num_peer_stats;
+	u32 num_bcnflt_stats;
 	u32 stats_id;
 	int i;
 
@@ -2930,6 +2931,7 @@ static int ath10k_wmi_10_4_op_pull_fw_stats(struct ath10k *ar,
 	num_pdev_ext_stats = __le32_to_cpu(ev->num_pdev_ext_stats);
 	num_vdev_stats = __le32_to_cpu(ev->num_vdev_stats);
 	num_peer_stats = __le32_to_cpu(ev->num_peer_stats);
+	num_bcnflt_stats = __le32_to_cpu(ev->num_bcnflt_stats);
 	stats_id = __le32_to_cpu(ev->stats_id);
 
 	for (i = 0; i < num_pdev_stats; i++) {
@@ -2970,32 +2972,55 @@ static int ath10k_wmi_10_4_op_pull_fw_stats(struct ath10k *ar,
 	/* fw doesn't implement vdev stats */
 
 	for (i = 0; i < num_peer_stats; i++) {
-		const struct wmi_10_4_peer_extd_stats *src;
+		const struct wmi_10_4_peer_stats *src;
 		struct ath10k_fw_stats_peer *dst;
-		int stats_len;
-		bool extd_peer_stats = !!(stats_id & WMI_10_4_STAT_PEER_EXTD);
-
-		if (extd_peer_stats)
-			stats_len = sizeof(struct wmi_10_4_peer_extd_stats);
-		else
-			stats_len = sizeof(struct wmi_10_4_peer_stats);
 
 		src = (void *)skb->data;
-		if (!skb_pull(skb, stats_len))
+		if (!skb_pull(skb, sizeof(*src)))
 			return -EPROTO;
 
 		dst = kzalloc(sizeof(*dst), GFP_ATOMIC);
 		if (!dst)
 			continue;
 
-		ath10k_wmi_10_4_pull_peer_stats(&src->common, dst);
-		/* FIXME: expose 10.4 specific values */
-		if (extd_peer_stats)
-			dst->rx_duration = __le32_to_cpu(src->rx_duration);
-
+		ath10k_wmi_10_4_pull_peer_stats(src, dst);
 		list_add_tail(&dst->list, &stats->peers);
 	}
 
+	for (i = 0; i < num_bcnflt_stats; i++) {
+		const struct wmi_10_4_bss_bcn_filter_stats *src;
+
+		src = (void *)skb->data;
+		if (!skb_pull(skb, sizeof(*src)))
+			return -EPROTO;
+
+		/* FIXME: expose values to userspace
+		 *
+		 * Note: Even though this loop seems to do nothing it is
+		 * required to parse following sub-structures properly.
+		 */
+	}
+
+	if ((stats_id & WMI_10_4_STAT_PEER_EXTD) == 0)
+		return 0;
+
+	for (i = 0; i < num_peer_stats; i++) {
+		const struct wmi_10_4_peer_extd_stats *src;
+		struct ath10k_fw_extd_stats_peer *dst;
+
+		src = (void *)skb->data;
+		if (!skb_pull(skb, sizeof(*src)))
+			return -EPROTO;
+
+		dst = kzalloc(sizeof(*dst), GFP_ATOMIC);
+		if (!dst)
+			continue;
+
+		ether_addr_copy(dst->peer_macaddr, src->peer_macaddr.addr);
+		dst->rx_duration = __le32_to_cpu(src->rx_duration);
+		list_add_tail(&dst->list, &stats->peers_extd);
+	}
+
 	return 0;
 }
 
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 9fdf47e..3d010c6 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -4336,7 +4336,6 @@ struct wmi_10_4_peer_stats {
 } __packed;
 
 struct wmi_10_4_peer_extd_stats {
-	struct wmi_10_4_peer_stats common;
 	struct wmi_mac_addr peer_macaddr;
 	__le32 inactive_time;
 	__le32 peer_chain_rssi;
@@ -4344,6 +4343,19 @@ struct wmi_10_4_peer_extd_stats {
 	__le32 reserved[10];
 } __packed;
 
+struct wmi_10_4_bss_bcn_stats {
+	__le32 vdev_id;
+	__le32 bss_bcns_dropped;
+	__le32 bss_bcn_delivered;
+} __packed;
+
+struct wmi_10_4_bss_bcn_filter_stats {
+	__le32 bcns_dropped;
+	__le32 bcns_delivered;
+	__le32 active_filters;
+	struct wmi_10_4_bss_bcn_stats bss_stats;
+} __packed;
+
 struct wmi_10_2_pdev_ext_stats {
 	__le32 rx_rssi_comb;
 	__le32 rx_rssi[4];
-- 
1.7.9.5

