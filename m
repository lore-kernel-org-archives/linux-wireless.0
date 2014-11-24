Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:48640 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753443AbaKXN1n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2014 08:27:43 -0500
Received: by mail-wi0-f181.google.com with SMTP id r20so5769242wiv.8
        for <linux-wireless@vger.kernel.org>; Mon, 24 Nov 2014 05:27:42 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 3/3] ath10k: fix station count enforcement
Date: Mon, 24 Nov 2014 14:15:09 +0100
Message-Id: <1416834909-7130-3-git-send-email-michal.kazior@tieto.com> (sfid-20141124_142752_302013_4966A9F7)
In-Reply-To: <1416834909-7130-1-git-send-email-michal.kazior@tieto.com>
References: <1416834909-7130-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The number of peers isn't directly translatable to
the number of stations because ath10k needs to
reserve a few extra peers for special cases like
multi-vif concurrency.

The previous limit was 126 and 15 stations in AP
mode for 10.x and main firmware branches
respectively. The limit is now 128 and 16 which
was the original intention.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.c  | 13 +++++++
 drivers/net/wireless/ath/ath10k/core.h  |  3 ++
 drivers/net/wireless/ath/ath10k/debug.c |  5 +--
 drivers/net/wireless/ath/ath10k/hw.h    | 15 ++++++---
 drivers/net/wireless/ath/ath10k/mac.c   | 60 ++++++++++++++++++++++++++-------
 drivers/net/wireless/ath/ath10k/wmi.c   |  2 +-
 6 files changed, 77 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index f660553..fea63ac 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -799,6 +799,17 @@ static void ath10k_core_restart(struct work_struct *work)
 	mutex_unlock(&ar->conf_mutex);
 }
 
+static void ath10k_core_init_max_sta_count(struct ath10k *ar)
+{
+	if (test_bit(ATH10K_FW_FEATURE_WMI_10X, ar->fw_features)) {
+		ar->max_num_peers = TARGET_10X_NUM_PEERS;
+		ar->max_num_stations = TARGET_10X_NUM_STATIONS;
+	} else {
+		ar->max_num_peers = TARGET_NUM_PEERS;
+		ar->max_num_stations = TARGET_NUM_STATIONS;
+	}
+}
+
 int ath10k_core_start(struct ath10k *ar, enum ath10k_firmware_mode mode)
 {
 	int status;
@@ -939,6 +950,8 @@ int ath10k_core_start(struct ath10k *ar, enum ath10k_firmware_mode mode)
 	else
 		ar->free_vdev_map = (1LL << TARGET_NUM_VDEVS) - 1;
 
+	ath10k_core_init_max_sta_count(ar);
+
 	INIT_LIST_HEAD(&ar->arvifs);
 
 	return 0;
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index be7e50b6..0baaff4 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -562,6 +562,9 @@ struct ath10k {
 
 	/* protected by conf_mutex */
 	int num_peers;
+	int num_stations;
+	int max_num_peers;
+	int max_num_stations;
 
 	struct work_struct offchan_tx_work;
 	struct sk_buff_head offchan_tx_queue;
diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index a8f5a72..75f7c8c 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -124,7 +124,7 @@ EXPORT_SYMBOL(ath10k_info);
 
 void ath10k_print_driver_info(struct ath10k *ar)
 {
-	ath10k_info(ar, "%s (0x%08x, 0x%08x) fw %s api %d htt %d.%d wmi %d.%d.%d.%d cal %s\n",
+	ath10k_info(ar, "%s (0x%08x, 0x%08x) fw %s api %d htt %d.%d wmi %d.%d.%d.%d cal %s max_sta %d\n",
 		    ar->hw_params.name,
 		    ar->target_version,
 		    ar->chip_id,
@@ -136,7 +136,8 @@ void ath10k_print_driver_info(struct ath10k *ar)
 		    ar->fw_version_minor,
 		    ar->fw_version_release,
 		    ar->fw_version_build,
-		    ath10k_cal_mode_str(ar->cal_mode));
+		    ath10k_cal_mode_str(ar->cal_mode),
+		    ar->max_num_stations);
 	ath10k_info(ar, "debug %d debugfs %d tracing %d dfs %d testmode %d\n",
 		    config_enabled(CONFIG_ATH10K_DEBUG),
 		    config_enabled(CONFIG_ATH10K_DEBUGFS),
diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index 392c250..dfedfd0 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -97,11 +97,13 @@ struct ath10k_pktlog_hdr {
 #define TARGET_DMA_BURST_SIZE			0
 #define TARGET_MAC_AGGR_DELIM			0
 #define TARGET_AST_SKID_LIMIT			16
-#define TARGET_NUM_PEERS			16
+#define TARGET_NUM_STATIONS			16
+#define TARGET_NUM_PEERS			((TARGET_NUM_STATIONS) + \
+						 (TARGET_NUM_VDEVS))
 #define TARGET_NUM_OFFLOAD_PEERS		0
 #define TARGET_NUM_OFFLOAD_REORDER_BUFS         0
 #define TARGET_NUM_PEER_KEYS			2
-#define TARGET_NUM_TIDS		(2 * ((TARGET_NUM_PEERS) + (TARGET_NUM_VDEVS)))
+#define TARGET_NUM_TIDS				((TARGET_NUM_PEERS) * 2)
 #define TARGET_TX_CHAIN_MASK			(BIT(0) | BIT(1) | BIT(2))
 #define TARGET_RX_CHAIN_MASK			(BIT(0) | BIT(1) | BIT(2))
 #define TARGET_RX_TIMEOUT_LO_PRI		100
@@ -132,12 +134,15 @@ struct ath10k_pktlog_hdr {
 #define TARGET_10X_DMA_BURST_SIZE		0
 #define TARGET_10X_MAC_AGGR_DELIM		0
 #define TARGET_10X_AST_SKID_LIMIT		16
-#define TARGET_10X_NUM_PEERS			(128 + (TARGET_10X_NUM_VDEVS))
-#define TARGET_10X_NUM_PEERS_MAX		128
+#define TARGET_10X_NUM_STATIONS			128
+#define TARGET_10X_NUM_PEERS			((TARGET_10X_NUM_STATIONS) + \
+						 (TARGET_10X_NUM_VDEVS))
 #define TARGET_10X_NUM_OFFLOAD_PEERS		0
 #define TARGET_10X_NUM_OFFLOAD_REORDER_BUFS	0
 #define TARGET_10X_NUM_PEER_KEYS		2
-#define TARGET_10X_NUM_TIDS			256
+#define TARGET_10X_NUM_TIDS_MAX			256
+#define TARGET_10X_NUM_TIDS			min((TARGET_10X_NUM_TIDS_MAX), \
+						    (TARGET_10X_NUM_PEERS) * 2)
 #define TARGET_10X_TX_CHAIN_MASK		(BIT(0) | BIT(1) | BIT(2))
 #define TARGET_10X_RX_CHAIN_MASK		(BIT(0) | BIT(1) | BIT(2))
 #define TARGET_10X_RX_TIMEOUT_LO_PRI		100
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 3312e75..95d0f30 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -326,6 +326,9 @@ static int ath10k_peer_create(struct ath10k *ar, u32 vdev_id, const u8 *addr)
 
 	lockdep_assert_held(&ar->conf_mutex);
 
+	if (ar->num_peers >= ar->max_num_peers)
+		return -ENOBUFS;
+
 	ret = ath10k_wmi_peer_create(ar, vdev_id, addr);
 	if (ret) {
 		ath10k_warn(ar, "failed to create wmi peer %pM on vdev %i: %i\n",
@@ -471,6 +474,7 @@ static void ath10k_peer_cleanup_all(struct ath10k *ar)
 	spin_unlock_bh(&ar->data_lock);
 
 	ar->num_peers = 0;
+	ar->num_stations = 0;
 }
 
 /************************/
@@ -3509,6 +3513,37 @@ static void ath10k_sta_rc_update_wk(struct work_struct *wk)
 	mutex_unlock(&ar->conf_mutex);
 }
 
+static int ath10k_mac_inc_num_stations(struct ath10k_vif *arvif)
+{
+	struct ath10k *ar = arvif->ar;
+
+	lockdep_assert_held(&ar->conf_mutex);
+
+	if (arvif->vdev_type != WMI_VDEV_TYPE_AP &&
+	    arvif->vdev_type != WMI_VDEV_TYPE_IBSS)
+		return 0;
+
+	if (ar->num_stations >= ar->max_num_stations)
+		return -ENOBUFS;
+
+	ar->num_stations++;
+
+	return 0;
+}
+
+static void ath10k_mac_dec_num_stations(struct ath10k_vif *arvif)
+{
+	struct ath10k *ar = arvif->ar;
+
+	lockdep_assert_held(&ar->conf_mutex);
+
+	if (arvif->vdev_type != WMI_VDEV_TYPE_AP &&
+	    arvif->vdev_type != WMI_VDEV_TYPE_IBSS)
+		return;
+
+	ar->num_stations--;
+}
+
 static int ath10k_sta_state(struct ieee80211_hw *hw,
 			    struct ieee80211_vif *vif,
 			    struct ieee80211_sta *sta,
@@ -3518,7 +3553,6 @@ static int ath10k_sta_state(struct ieee80211_hw *hw,
 	struct ath10k *ar = hw->priv;
 	struct ath10k_vif *arvif = ath10k_vif_to_arvif(vif);
 	struct ath10k_sta *arsta = (struct ath10k_sta *)sta->drv_priv;
-	int max_num_peers;
 	int ret = 0;
 
 	if (old_state == IEEE80211_STA_NOTEXIST &&
@@ -3540,26 +3574,24 @@ static int ath10k_sta_state(struct ieee80211_hw *hw,
 		/*
 		 * New station addition.
 		 */
-		if (test_bit(ATH10K_FW_FEATURE_WMI_10X, ar->fw_features))
-			max_num_peers = TARGET_10X_NUM_PEERS_MAX - 1;
-		else
-			max_num_peers = TARGET_NUM_PEERS;
+		ath10k_dbg(ar, ATH10K_DBG_MAC,
+			   "mac vdev %d peer create %pM (new sta) sta %d / %d peer %d / %d\n",
+			   arvif->vdev_id, sta->addr,
+			   ar->num_stations + 1, ar->max_num_stations,
+			   ar->num_peers + 1, ar->max_num_peers);
 
-		if (ar->num_peers >= max_num_peers) {
-			ath10k_warn(ar, "number of peers exceeded: peers number %d (max peers %d)\n",
-				    ar->num_peers, max_num_peers);
-			ret = -ENOBUFS;
+		ret = ath10k_mac_inc_num_stations(arvif);
+		if (ret) {
+			ath10k_warn(ar, "refusing to associate station: too many connected already (%d)\n",
+				    ar->max_num_stations);
 			goto exit;
 		}
 
-		ath10k_dbg(ar, ATH10K_DBG_MAC,
-			   "mac vdev %d peer create %pM (new sta) num_peers %d\n",
-			   arvif->vdev_id, sta->addr, ar->num_peers);
-
 		ret = ath10k_peer_create(ar, arvif->vdev_id, sta->addr);
 		if (ret) {
 			ath10k_warn(ar, "failed to add peer %pM for vdev %d when adding a new sta: %i\n",
 				    sta->addr, arvif->vdev_id, ret);
+			ath10k_mac_dec_num_stations(arvif);
 			goto exit;
 		}
 
@@ -3572,6 +3604,7 @@ static int ath10k_sta_state(struct ieee80211_hw *hw,
 					    arvif->vdev_id, ret);
 				WARN_ON(ath10k_peer_delete(ar, arvif->vdev_id,
 							   sta->addr));
+				ath10k_mac_dec_num_stations(arvif);
 				goto exit;
 			}
 
@@ -3602,6 +3635,7 @@ static int ath10k_sta_state(struct ieee80211_hw *hw,
 			ath10k_warn(ar, "failed to delete peer %pM for vdev %d: %i\n",
 				    sta->addr, arvif->vdev_id, ret);
 
+		ath10k_mac_dec_num_stations(arvif);
 	} else if (old_state == IEEE80211_STA_AUTH &&
 		   new_state == IEEE80211_STA_ASSOC &&
 		   (vif->type == NL80211_IFTYPE_AP ||
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index c2bc828..84a1efa 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -3142,7 +3142,7 @@ static int ath10k_wmi_main_cmd_init(struct ath10k *ar)
 	u32 len, val;
 
 	config.num_vdevs = __cpu_to_le32(TARGET_NUM_VDEVS);
-	config.num_peers = __cpu_to_le32(TARGET_NUM_PEERS + TARGET_NUM_VDEVS);
+	config.num_peers = __cpu_to_le32(TARGET_NUM_PEERS);
 	config.num_offload_peers = __cpu_to_le32(TARGET_NUM_OFFLOAD_PEERS);
 
 	config.num_offload_reorder_bufs =
-- 
1.8.5.3

