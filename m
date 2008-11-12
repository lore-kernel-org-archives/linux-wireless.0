Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:26494 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751422AbYKLVNs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Nov 2008 16:13:48 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Tomas Winkler <tomas.winkler@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 2/8] iwlwifi: consolidate station management code
Date: Wed, 12 Nov 2008 13:14:05 -0800
Message-Id: <1226524451-3417-3-git-send-email-reinette.chatre@intel.com> (sfid-20081112_221354_768336_6C31CF66)
In-Reply-To: <1226524451-3417-2-git-send-email-reinette.chatre@intel.com>
References: <>
 <1226524451-3417-1-git-send-email-reinette.chatre@intel.com>
 <1226524451-3417-2-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch moves code around and group most of the station
management code into iwl-sta.c

No functional changes (yet)

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-5000.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c  |   48 +----------
 drivers/net/wireless/iwlwifi/iwl-core.h |    2 -
 drivers/net/wireless/iwlwifi/iwl-dev.h  |    5 -
 drivers/net/wireless/iwlwifi/iwl-rx.c   |   75 -----------------
 drivers/net/wireless/iwlwifi/iwl-sta.c  |  134 +++++++++++++++++++++++++++++-
 drivers/net/wireless/iwlwifi/iwl-sta.h  |   13 +++-
 8 files changed, 148 insertions(+), 133 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index c43cf2f..17f4098 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -1909,7 +1909,7 @@ static int iwl4965_txq_agg_enable(struct iwl_priv *priv, int txq_id,
 	ra_tid = BUILD_RAxTID(sta_id, tid);
 
 	/* Modify device's station table to Tx this TID */
-	iwl_sta_modify_enable_tid_tx(priv, sta_id, tid);
+	iwl_sta_tx_modify_enable_tid(priv, sta_id, tid);
 
 	spin_lock_irqsave(&priv->lock, flags);
 	ret = iwl_grab_nic_access(priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index ee3613d..b6d7e91 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -969,7 +969,7 @@ static int iwl5000_txq_agg_enable(struct iwl_priv *priv, int txq_id,
 	ra_tid = BUILD_RAxTID(sta_id, tid);
 
 	/* Modify device's station table to Tx this TID */
-	iwl_sta_modify_enable_tid_tx(priv, sta_id, tid);
+	iwl_sta_tx_modify_enable_tid(priv, sta_id, tid);
 
 	spin_lock_irqsave(&priv->lock, flags);
 	ret = iwl_grab_nic_access(priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 996ed5b..b69d77d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3069,50 +3069,11 @@ static void iwl_mac_update_tkip_key(struct ieee80211_hw *hw,
 			struct ieee80211_key_conf *keyconf, const u8 *addr,
 			u32 iv32, u16 *phase1key)
 {
-	struct iwl_priv *priv = hw->priv;
-	u8 sta_id = IWL_INVALID_STATION;
-	unsigned long flags;
-	__le16 key_flags = 0;
-	int i;
-	DECLARE_MAC_BUF(mac);
 
+	struct iwl_priv *priv = hw->priv;
 	IWL_DEBUG_MAC80211("enter\n");
 
-	sta_id = iwl_find_station(priv, addr);
-	if (sta_id == IWL_INVALID_STATION) {
-		IWL_DEBUG_MAC80211("leave - %s not in station map.\n",
-				   print_mac(mac, addr));
-		return;
-	}
-
-	if (iwl_scan_cancel(priv)) {
-		/* cancel scan failed, just live w/ bad key and rely
-		   briefly on SW decryption */
-		return;
-	}
-
-	key_flags |= (STA_KEY_FLG_TKIP | STA_KEY_FLG_MAP_KEY_MSK);
-	key_flags |= cpu_to_le16(keyconf->keyidx << STA_KEY_FLG_KEYID_POS);
-	key_flags &= ~STA_KEY_FLG_INVALID;
-
-	if (sta_id == priv->hw_params.bcast_sta_id)
-		key_flags |= STA_KEY_MULTICAST_MSK;
-
-	spin_lock_irqsave(&priv->sta_lock, flags);
-
-	priv->stations[sta_id].sta.key.key_flags = key_flags;
-	priv->stations[sta_id].sta.key.tkip_rx_tsc_byte2 = (u8) iv32;
-
-	for (i = 0; i < 5; i++)
-		priv->stations[sta_id].sta.key.tkip_rx_ttak[i] =
-			cpu_to_le16(phase1key[i]);
-
-	priv->stations[sta_id].sta.sta.modify_mask = STA_MODIFY_KEY_MASK;
-	priv->stations[sta_id].sta.mode = STA_CONTROL_MODIFY_MSK;
-
-	iwl_send_add_sta(priv, &priv->stations[sta_id].sta, CMD_ASYNC);
-
-	spin_unlock_irqrestore(&priv->sta_lock, flags);
+	iwl_update_tkip_key(priv, keyconf, addr, iv32, phase1key);
 
 	IWL_DEBUG_MAC80211("leave\n");
 }
@@ -3253,10 +3214,10 @@ static int iwl_mac_ampdu_action(struct ieee80211_hw *hw,
 	switch (action) {
 	case IEEE80211_AMPDU_RX_START:
 		IWL_DEBUG_HT("start Rx\n");
-		return iwl_rx_agg_start(priv, sta->addr, tid, *ssn);
+		return iwl_sta_rx_agg_start(priv, sta->addr, tid, *ssn);
 	case IEEE80211_AMPDU_RX_STOP:
 		IWL_DEBUG_HT("stop Rx\n");
-		return iwl_rx_agg_stop(priv, sta->addr, tid);
+		return iwl_sta_rx_agg_stop(priv, sta->addr, tid);
 	case IEEE80211_AMPDU_TX_START:
 		IWL_DEBUG_HT("start Tx\n");
 		return iwl_tx_agg_start(priv, sta->addr, tid, ssn);
@@ -3270,6 +3231,7 @@ static int iwl_mac_ampdu_action(struct ieee80211_hw *hw,
 	}
 	return 0;
 }
+
 static int iwl_mac_get_tx_stats(struct ieee80211_hw *hw,
 				struct ieee80211_tx_queue_stats *stats)
 {
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index ff966b8..5d4e2e2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -206,8 +206,6 @@ int iwl_rx_queue_update_write_ptr(struct iwl_priv *priv,
 void iwl_rx_queue_reset(struct iwl_priv *priv, struct iwl_rx_queue *rxq);
 void iwl_rx_replenish(struct iwl_priv *priv);
 int iwl_rx_init(struct iwl_priv *priv, struct iwl_rx_queue *rxq);
-int iwl_rx_agg_start(struct iwl_priv *priv, const u8 *addr, int tid, u16 ssn);
-int iwl_rx_agg_stop(struct iwl_priv *priv, const u8 *addr, int tid);
 int iwl_rx_queue_restock(struct iwl_priv *priv);
 int iwl_rx_queue_space(const struct iwl_rx_queue *q);
 void iwl_rx_allocate(struct iwl_priv *priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 7b51dd9..7c58d21 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -573,11 +573,6 @@ struct iwl_hw_params {
  * iwl4965_mac_     <-- mac80211 callback
  *
  ****************************************************************************/
-struct iwl_addsta_cmd;
-extern int iwl_send_add_sta(struct iwl_priv *priv,
-			    struct iwl_addsta_cmd *sta, u8 flags);
-extern u8 iwl_add_station_flags(struct iwl_priv *priv, const u8 *addr,
-			int is_ap, u8 flags, struct ieee80211_sta_ht_cap *ht_info);
 extern void iwl_update_chain_flags(struct iwl_priv *priv);
 extern int iwl_set_pwr_src(struct iwl_priv *priv, enum iwl_pwr_src src);
 extern const u8 iwl_bcast_addr[ETH_ALEN];
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index 90e6648..6e51cb2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -494,49 +494,6 @@ void iwl_rx_missed_beacon_notif(struct iwl_priv *priv,
 }
 EXPORT_SYMBOL(iwl_rx_missed_beacon_notif);
 
-int iwl_rx_agg_start(struct iwl_priv *priv, const u8 *addr, int tid, u16 ssn)
-{
-	unsigned long flags;
-	int sta_id;
-
-	sta_id = iwl_find_station(priv, addr);
-	if (sta_id == IWL_INVALID_STATION)
-		return -ENXIO;
-
-	spin_lock_irqsave(&priv->sta_lock, flags);
-	priv->stations[sta_id].sta.station_flags_msk = 0;
-	priv->stations[sta_id].sta.sta.modify_mask = STA_MODIFY_ADDBA_TID_MSK;
-	priv->stations[sta_id].sta.add_immediate_ba_tid = (u8)tid;
-	priv->stations[sta_id].sta.add_immediate_ba_ssn = cpu_to_le16(ssn);
-	priv->stations[sta_id].sta.mode = STA_CONTROL_MODIFY_MSK;
-	spin_unlock_irqrestore(&priv->sta_lock, flags);
-
-	return iwl_send_add_sta(priv, &priv->stations[sta_id].sta,
-					CMD_ASYNC);
-}
-EXPORT_SYMBOL(iwl_rx_agg_start);
-
-int iwl_rx_agg_stop(struct iwl_priv *priv, const u8 *addr, int tid)
-{
-	unsigned long flags;
-	int sta_id;
-
-	sta_id = iwl_find_station(priv, addr);
-	if (sta_id == IWL_INVALID_STATION)
-		return -ENXIO;
-
-	spin_lock_irqsave(&priv->sta_lock, flags);
-	priv->stations[sta_id].sta.station_flags_msk = 0;
-	priv->stations[sta_id].sta.sta.modify_mask = STA_MODIFY_DELBA_TID_MSK;
-	priv->stations[sta_id].sta.remove_immediate_ba_tid = (u8)tid;
-	priv->stations[sta_id].sta.mode = STA_CONTROL_MODIFY_MSK;
-	spin_unlock_irqrestore(&priv->sta_lock, flags);
-
-	return iwl_send_add_sta(priv, &priv->stations[sta_id].sta,
-					CMD_ASYNC);
-}
-EXPORT_SYMBOL(iwl_rx_agg_stop);
-
 
 /* Calculate noise level, based on measurements during network silence just
  *   before arriving beacon.  This measurement can be done only if we know
@@ -1012,38 +969,6 @@ static inline int iwl_calc_rssi(struct iwl_priv *priv,
 }
 
 
-static void iwl_sta_modify_ps_wake(struct iwl_priv *priv, int sta_id)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&priv->sta_lock, flags);
-	priv->stations[sta_id].sta.station_flags &= ~STA_FLG_PWR_SAVE_MSK;
-	priv->stations[sta_id].sta.station_flags_msk = STA_FLG_PWR_SAVE_MSK;
-	priv->stations[sta_id].sta.sta.modify_mask = 0;
-	priv->stations[sta_id].sta.mode = STA_CONTROL_MODIFY_MSK;
-	spin_unlock_irqrestore(&priv->sta_lock, flags);
-
-	iwl_send_add_sta(priv, &priv->stations[sta_id].sta, CMD_ASYNC);
-}
-
-static void iwl_update_ps_mode(struct iwl_priv *priv, u16 ps_bit, u8 *addr)
-{
-	/* FIXME: need locking over ps_status ??? */
-	u8 sta_id = iwl_find_station(priv, addr);
-
-	if (sta_id != IWL_INVALID_STATION) {
-		u8 sta_awake = priv->stations[sta_id].
-				ps_status == STA_PS_STATUS_WAKE;
-
-		if (sta_awake && ps_bit)
-			priv->stations[sta_id].ps_status = STA_PS_STATUS_SLEEP;
-		else if (!sta_awake && !ps_bit) {
-			iwl_sta_modify_ps_wake(priv, sta_id);
-			priv->stations[sta_id].ps_status = STA_PS_STATUS_WAKE;
-		}
-	}
-}
-
 /* This is necessary only for a number of statistics, see the caller. */
 static int iwl_is_network_packet(struct iwl_priv *priv,
 		struct ieee80211_hdr *header)
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index bc7d5c4..2529c23 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -134,7 +134,7 @@ static int iwl_add_sta_callback(struct iwl_priv *priv,
 	return 1;
 }
 
-int iwl_send_add_sta(struct iwl_priv *priv,
+static int iwl_send_add_sta(struct iwl_priv *priv,
 		     struct iwl_addsta_cmd *sta, u8 flags)
 {
 	struct iwl_rx_packet *res = NULL;
@@ -182,7 +182,6 @@ int iwl_send_add_sta(struct iwl_priv *priv,
 
 	return ret;
 }
-EXPORT_SYMBOL(iwl_send_add_sta);
 
 static void iwl_set_ht_add_station(struct iwl_priv *priv, u8 index,
 				   struct ieee80211_sta_ht_cap *sta_ht_inf)
@@ -710,6 +709,55 @@ static int iwl_set_tkip_dynamic_key_info(struct iwl_priv *priv,
 	return ret;
 }
 
+void iwl_update_tkip_key(struct iwl_priv *priv,
+			struct ieee80211_key_conf *keyconf,
+			const u8 *addr, u32 iv32, u16 *phase1key)
+{
+	u8 sta_id = IWL_INVALID_STATION;
+	unsigned long flags;
+	__le16 key_flags = 0;
+	int i;
+	DECLARE_MAC_BUF(mac);
+
+	sta_id = iwl_find_station(priv, addr);
+	if (sta_id == IWL_INVALID_STATION) {
+		IWL_DEBUG_MAC80211("leave - %s not in station map.\n",
+				   print_mac(mac, addr));
+		return;
+	}
+
+	if (iwl_scan_cancel(priv)) {
+		/* cancel scan failed, just live w/ bad key and rely
+		   briefly on SW decryption */
+		return;
+	}
+
+	key_flags |= (STA_KEY_FLG_TKIP | STA_KEY_FLG_MAP_KEY_MSK);
+	key_flags |= cpu_to_le16(keyconf->keyidx << STA_KEY_FLG_KEYID_POS);
+	key_flags &= ~STA_KEY_FLG_INVALID;
+
+	if (sta_id == priv->hw_params.bcast_sta_id)
+		key_flags |= STA_KEY_MULTICAST_MSK;
+
+	spin_lock_irqsave(&priv->sta_lock, flags);
+
+	priv->stations[sta_id].sta.key.key_flags = key_flags;
+	priv->stations[sta_id].sta.key.tkip_rx_tsc_byte2 = (u8) iv32;
+
+	for (i = 0; i < 5; i++)
+		priv->stations[sta_id].sta.key.tkip_rx_ttak[i] =
+			cpu_to_le16(phase1key[i]);
+
+	priv->stations[sta_id].sta.sta.modify_mask = STA_MODIFY_KEY_MASK;
+	priv->stations[sta_id].sta.mode = STA_CONTROL_MODIFY_MSK;
+
+	iwl_send_add_sta(priv, &priv->stations[sta_id].sta, CMD_ASYNC);
+
+	spin_unlock_irqrestore(&priv->sta_lock, flags);
+
+}
+EXPORT_SYMBOL(iwl_update_tkip_key);
+
 int iwl_remove_dynamic_key(struct iwl_priv *priv,
 				struct ieee80211_key_conf *keyconf,
 				u8 sta_id)
@@ -997,9 +1045,9 @@ int iwl_get_sta_id(struct iwl_priv *priv, struct ieee80211_hdr *hdr)
 EXPORT_SYMBOL(iwl_get_sta_id);
 
 /**
- * iwl_sta_modify_enable_tid_tx - Enable Tx for this TID in station table
+ * iwl_sta_tx_modify_enable_tid - Enable Tx for this TID in station table
  */
-void iwl_sta_modify_enable_tid_tx(struct iwl_priv *priv, int sta_id, int tid)
+void iwl_sta_tx_modify_enable_tid(struct iwl_priv *priv, int sta_id, int tid)
 {
 	unsigned long flags;
 
@@ -1012,5 +1060,81 @@ void iwl_sta_modify_enable_tid_tx(struct iwl_priv *priv, int sta_id, int tid)
 
 	iwl_send_add_sta(priv, &priv->stations[sta_id].sta, CMD_ASYNC);
 }
-EXPORT_SYMBOL(iwl_sta_modify_enable_tid_tx);
+EXPORT_SYMBOL(iwl_sta_tx_modify_enable_tid);
+
+int iwl_sta_rx_agg_start(struct iwl_priv *priv,
+			 const u8 *addr, int tid, u16 ssn)
+{
+	unsigned long flags;
+	int sta_id;
+
+	sta_id = iwl_find_station(priv, addr);
+	if (sta_id == IWL_INVALID_STATION)
+		return -ENXIO;
+
+	spin_lock_irqsave(&priv->sta_lock, flags);
+	priv->stations[sta_id].sta.station_flags_msk = 0;
+	priv->stations[sta_id].sta.sta.modify_mask = STA_MODIFY_ADDBA_TID_MSK;
+	priv->stations[sta_id].sta.add_immediate_ba_tid = (u8)tid;
+	priv->stations[sta_id].sta.add_immediate_ba_ssn = cpu_to_le16(ssn);
+	priv->stations[sta_id].sta.mode = STA_CONTROL_MODIFY_MSK;
+	spin_unlock_irqrestore(&priv->sta_lock, flags);
+
+	return iwl_send_add_sta(priv, &priv->stations[sta_id].sta,
+					CMD_ASYNC);
+}
+EXPORT_SYMBOL(iwl_sta_rx_agg_start);
+
+int iwl_sta_rx_agg_stop(struct iwl_priv *priv, const u8 *addr, int tid)
+{
+	unsigned long flags;
+	int sta_id;
+
+	sta_id = iwl_find_station(priv, addr);
+	if (sta_id == IWL_INVALID_STATION)
+		return -ENXIO;
+
+	spin_lock_irqsave(&priv->sta_lock, flags);
+	priv->stations[sta_id].sta.station_flags_msk = 0;
+	priv->stations[sta_id].sta.sta.modify_mask = STA_MODIFY_DELBA_TID_MSK;
+	priv->stations[sta_id].sta.remove_immediate_ba_tid = (u8)tid;
+	priv->stations[sta_id].sta.mode = STA_CONTROL_MODIFY_MSK;
+	spin_unlock_irqrestore(&priv->sta_lock, flags);
+
+	return iwl_send_add_sta(priv, &priv->stations[sta_id].sta,
+					CMD_ASYNC);
+}
+EXPORT_SYMBOL(iwl_sta_rx_agg_stop);
+
+static void iwl_sta_modify_ps_wake(struct iwl_priv *priv, int sta_id)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&priv->sta_lock, flags);
+	priv->stations[sta_id].sta.station_flags &= ~STA_FLG_PWR_SAVE_MSK;
+	priv->stations[sta_id].sta.station_flags_msk = STA_FLG_PWR_SAVE_MSK;
+	priv->stations[sta_id].sta.sta.modify_mask = 0;
+	priv->stations[sta_id].sta.mode = STA_CONTROL_MODIFY_MSK;
+	spin_unlock_irqrestore(&priv->sta_lock, flags);
+
+	iwl_send_add_sta(priv, &priv->stations[sta_id].sta, CMD_ASYNC);
+}
+
+void iwl_update_ps_mode(struct iwl_priv *priv, u16 ps_bit, u8 *addr)
+{
+	/* FIXME: need locking over ps_status ??? */
+	u8 sta_id = iwl_find_station(priv, addr);
+
+	if (sta_id != IWL_INVALID_STATION) {
+		u8 sta_awake = priv->stations[sta_id].
+				ps_status == STA_PS_STATUS_WAKE;
+
+		if (sta_awake && ps_bit)
+			priv->stations[sta_id].ps_status = STA_PS_STATUS_SLEEP;
+		else if (!sta_awake && !ps_bit) {
+			iwl_sta_modify_ps_wake(priv, sta_id);
+			priv->stations[sta_id].ps_status = STA_PS_STATUS_WAKE;
+		}
+	}
+}
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.h b/drivers/net/wireless/iwlwifi/iwl-sta.h
index 221b93e..61eede5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.h
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.h
@@ -47,9 +47,20 @@ int iwl_set_dynamic_key(struct iwl_priv *priv,
 			struct ieee80211_key_conf *key, u8 sta_id);
 int iwl_remove_dynamic_key(struct iwl_priv *priv,
 			   struct ieee80211_key_conf *key, u8 sta_id);
+void iwl_update_tkip_key(struct iwl_priv *priv,
+			struct ieee80211_key_conf *keyconf,
+			const u8 *addr, u32 iv32, u16 *phase1key);
+
 int iwl_rxon_add_station(struct iwl_priv *priv, const u8 *addr, int is_ap);
 int iwl_remove_station(struct iwl_priv *priv, const u8 *addr, int is_ap);
 int iwl_get_sta_id(struct iwl_priv *priv, struct ieee80211_hdr *hdr);
-void iwl_sta_modify_enable_tid_tx(struct iwl_priv *priv, int sta_id, int tid);
 int iwl_get_ra_sta_id(struct iwl_priv *priv, struct ieee80211_hdr *hdr);
+u8 iwl_add_station_flags(struct iwl_priv *priv, const u8 *addr,
+			int is_ap, u8 flags,
+			struct ieee80211_sta_ht_cap *ht_info);
+void iwl_sta_tx_modify_enable_tid(struct iwl_priv *priv, int sta_id, int tid);
+int iwl_sta_rx_agg_start(struct iwl_priv *priv,
+			 const u8 *addr, int tid, u16 ssn);
+int iwl_sta_rx_agg_stop(struct iwl_priv *priv, const u8 *addr, int tid);
+void iwl_update_ps_mode(struct iwl_priv *priv, u16 ps_bit, u8 *addr);
 #endif /* __iwl_sta_h__ */
-- 
1.5.4.3

