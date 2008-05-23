Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:27647 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758514AbYEWCLP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2008 22:11:15 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH] iwlwifi: move more station managment into iwl-sta.c
Date: Fri, 23 May 2008 10:08:50 +0800
Message-Id: <1211508569-3163-13-git-send-email-yi.zhu@intel.com> (sfid-20080523_041126_955395_2C0B5250)
In-Reply-To: <1211508569-3163-12-git-send-email-yi.zhu@intel.com>
References: <1211508569-3163-1-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-2-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-3-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-4-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-5-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-6-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-7-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-8-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-9-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-10-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-11-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-12-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch moves station management functions into iwl-sta.c (iwlcore).

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965-rs.c  |    4 +-
 drivers/net/wireless/iwlwifi/iwl-4965.c     |  101 ----------
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    8 +-
 drivers/net/wireless/iwlwifi/iwl-sta.c      |  269 +++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-sta.h      |    2 +
 drivers/net/wireless/iwlwifi/iwl4965-base.c |  178 +-----------------
 6 files changed, 283 insertions(+), 279 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
index e2123ab..ce70f2b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
@@ -2150,7 +2150,7 @@ static void rs_get_rate(void *priv_rate, struct net_device *dev,
 		if (sta_id == IWL_INVALID_STATION) {
 			IWL_DEBUG_RATE("LQ: ADD station %s\n",
 				       print_mac(mac, hdr->addr1));
-			sta_id = iwl4965_add_station_flags(priv, hdr->addr1,
+			sta_id = iwl_add_station_flags(priv, hdr->addr1,
 							0, CMD_ASYNC, NULL);
 		}
 		if ((sta_id != IWL_INVALID_STATION)) {
@@ -2234,7 +2234,7 @@ static void rs_rate_init(void *priv_rate, void *priv_sta,
 		if (sta_id == IWL_INVALID_STATION) {
 			IWL_DEBUG_RATE("LQ: ADD station %s\n",
 				       print_mac(mac, sta->addr));
-			sta_id = iwl4965_add_station_flags(priv, sta->addr,
+			sta_id = iwl_add_station_flags(priv, sta->addr,
 							0, CMD_ASYNC, NULL);
 		}
 		if ((sta_id != IWL_INVALID_STATION)) {
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 44215a7..aeaf5f7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -3433,109 +3433,8 @@ static int iwl4965_tx_queue_agg_enable(struct iwl_priv *priv, int txq_id,
 
 #endif /* CONFIG_IWL4965_HT */
 
-/**
- * iwl4965_add_station - Initialize a station's hardware rate table
- *
- * The uCode's station table contains a table of fallback rates
- * for automatic fallback during transmission.
- *
- * NOTE: This sets up a default set of values.  These will be replaced later
- *       if the driver's iwl-4965-rs rate scaling algorithm is used, instead of
- *       rc80211_simple.
- *
- * NOTE: Run REPLY_ADD_STA command to set up station table entry, before
- *       calling this function (which runs REPLY_TX_LINK_QUALITY_CMD,
- *       which requires station table entry to exist).
- */
-void iwl4965_add_station(struct iwl_priv *priv, const u8 *addr, int is_ap)
-{
-	int i, r;
-	struct iwl_link_quality_cmd link_cmd = {
-		.reserved1 = 0,
-	};
-	u16 rate_flags;
-
-	/* Set up the rate scaling to start at selected rate, fall back
-	 * all the way down to 1M in IEEE order, and then spin on 1M */
-	if (is_ap)
-		r = IWL_RATE_54M_INDEX;
-	else if (priv->band == IEEE80211_BAND_5GHZ)
-		r = IWL_RATE_6M_INDEX;
-	else
-		r = IWL_RATE_1M_INDEX;
-
-	for (i = 0; i < LINK_QUAL_MAX_RETRY_NUM; i++) {
-		rate_flags = 0;
-		if (r >= IWL_FIRST_CCK_RATE && r <= IWL_LAST_CCK_RATE)
-			rate_flags |= RATE_MCS_CCK_MSK;
-
-		/* Use Tx antenna B only */
-		rate_flags |= RATE_MCS_ANT_B_MSK; /*FIXME:RS*/
-
-		link_cmd.rs_table[i].rate_n_flags =
-			iwl4965_hw_set_rate_n_flags(iwl_rates[r].plcp, rate_flags);
-		r = iwl4965_get_prev_ieee_rate(r);
-	}
-
-	link_cmd.general_params.single_stream_ant_msk = 2;
-	link_cmd.general_params.dual_stream_ant_msk = 3;
-	link_cmd.agg_params.agg_dis_start_th = 3;
-	link_cmd.agg_params.agg_time_limit = cpu_to_le16(4000);
-
-	/* Update the rate scaling for control frame Tx to AP */
-	link_cmd.sta_id = is_ap ? IWL_AP_ID : priv->hw_params.bcast_sta_id;
-
-	iwl_send_cmd_pdu_async(priv, REPLY_TX_LINK_QUALITY_CMD,
-			       sizeof(link_cmd), &link_cmd, NULL);
-}
 
 #ifdef CONFIG_IWL4965_HT
-
-void iwl4965_set_ht_add_station(struct iwl_priv *priv, u8 index,
-				struct ieee80211_ht_info *sta_ht_inf)
-{
-	__le32 sta_flags;
-	u8 mimo_ps_mode;
-
-	if (!sta_ht_inf || !sta_ht_inf->ht_supported)
-		goto done;
-
-	mimo_ps_mode = (sta_ht_inf->cap & IEEE80211_HT_CAP_MIMO_PS) >> 2;
-
-	sta_flags = priv->stations[index].sta.station_flags;
-
-	sta_flags &= ~(STA_FLG_RTS_MIMO_PROT_MSK | STA_FLG_MIMO_DIS_MSK);
-
-	switch (mimo_ps_mode) {
-	case WLAN_HT_CAP_MIMO_PS_STATIC:
-		sta_flags |= STA_FLG_MIMO_DIS_MSK;
-		break;
-	case WLAN_HT_CAP_MIMO_PS_DYNAMIC:
-		sta_flags |= STA_FLG_RTS_MIMO_PROT_MSK;
-		break;
-	case WLAN_HT_CAP_MIMO_PS_DISABLED:
-		break;
-	default:
-		IWL_WARNING("Invalid MIMO PS mode %d", mimo_ps_mode);
-		break;
-	}
-
-	sta_flags |= cpu_to_le32(
-	      (u32)sta_ht_inf->ampdu_factor << STA_FLG_MAX_AGG_SIZE_POS);
-
-	sta_flags |= cpu_to_le32(
-	      (u32)sta_ht_inf->ampdu_density << STA_FLG_AGG_MPDU_DENSITY_POS);
-
-	if (iwl_is_fat_tx_allowed(priv, sta_ht_inf))
-		sta_flags |= STA_FLG_FAT_EN_MSK;
-	else
-		sta_flags &= ~STA_FLG_FAT_EN_MSK;
-
-	priv->stations[index].sta.station_flags = sta_flags;
- done:
-	return;
-}
-
 static int iwl4965_rx_agg_start(struct iwl_priv *priv,
 				const u8 *addr, int tid, u16 ssn)
 {
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 8809fe3..565d7dc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -635,8 +635,8 @@ struct iwl_hw_params {
 struct iwl_addsta_cmd;
 extern int iwl_send_add_sta(struct iwl_priv *priv,
 			    struct iwl_addsta_cmd *sta, u8 flags);
-extern u8 iwl4965_add_station_flags(struct iwl_priv *priv, const u8 *addr,
-			  int is_ap, u8 flags, void *ht_data);
+u8 iwl_add_station_flags(struct iwl_priv *priv, const u8 *addr, int is_ap,
+			 u8 flags, struct ieee80211_ht_info *ht_info);
 extern int iwl4965_is_network_packet(struct iwl_priv *priv,
 				 struct ieee80211_hdr *header);
 extern int iwl4965_power_init_handle(struct iwl_priv *priv);
@@ -731,8 +731,6 @@ extern void iwl4965_radio_kill_sw(struct iwl_priv *priv, int disable_radio);
 extern int iwl4965_tx_queue_update_wr_ptr(struct iwl_priv *priv,
 					  struct iwl_tx_queue *txq,
 					  u16 byte_cnt);
-extern void iwl4965_add_station(struct iwl_priv *priv, const u8 *addr,
-				int is_ap);
 extern int iwl4965_alive_notify(struct iwl_priv *priv);
 extern void iwl4965_update_rate_scaling(struct iwl_priv *priv, u8 mode);
 extern void iwl4965_rf_kill_ct_config(struct iwl_priv *priv);
@@ -746,8 +744,6 @@ extern void iwl4965_init_ht_hw_capab(const struct iwl_priv *priv,
 				enum ieee80211_band band);
 void iwl4965_set_rxon_ht(struct iwl_priv *priv,
 			 struct iwl_ht_info *ht_info);
-void iwl4965_set_ht_add_station(struct iwl_priv *priv, u8 index,
-				struct ieee80211_ht_info *sta_ht_inf);
 int iwl4965_mac_ampdu_action(struct ieee80211_hw *hw,
 				    enum ieee80211_ampdu_mlme_action action,
 				    const u8 *addr, u16 tid, u16 *ssn);
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index f226704..c8e468f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -117,6 +117,130 @@ int iwl_send_add_sta(struct iwl_priv *priv,
 }
 EXPORT_SYMBOL(iwl_send_add_sta);
 
+#ifdef CONFIG_IWL4965_HT
+
+static void iwl_set_ht_add_station(struct iwl_priv *priv, u8 index,
+				   struct ieee80211_ht_info *sta_ht_inf)
+{
+	__le32 sta_flags;
+	u8 mimo_ps_mode;
+
+	if (!sta_ht_inf || !sta_ht_inf->ht_supported)
+		goto done;
+
+	mimo_ps_mode = (sta_ht_inf->cap & IEEE80211_HT_CAP_MIMO_PS) >> 2;
+
+	sta_flags = priv->stations[index].sta.station_flags;
+
+	sta_flags &= ~(STA_FLG_RTS_MIMO_PROT_MSK | STA_FLG_MIMO_DIS_MSK);
+
+	switch (mimo_ps_mode) {
+	case WLAN_HT_CAP_MIMO_PS_STATIC:
+		sta_flags |= STA_FLG_MIMO_DIS_MSK;
+		break;
+	case WLAN_HT_CAP_MIMO_PS_DYNAMIC:
+		sta_flags |= STA_FLG_RTS_MIMO_PROT_MSK;
+		break;
+	case WLAN_HT_CAP_MIMO_PS_DISABLED:
+		break;
+	default:
+		IWL_WARNING("Invalid MIMO PS mode %d", mimo_ps_mode);
+		break;
+	}
+
+	sta_flags |= cpu_to_le32(
+	      (u32)sta_ht_inf->ampdu_factor << STA_FLG_MAX_AGG_SIZE_POS);
+
+	sta_flags |= cpu_to_le32(
+	      (u32)sta_ht_inf->ampdu_density << STA_FLG_AGG_MPDU_DENSITY_POS);
+
+	if (iwl_is_fat_tx_allowed(priv, sta_ht_inf))
+		sta_flags |= STA_FLG_FAT_EN_MSK;
+	else
+		sta_flags &= ~STA_FLG_FAT_EN_MSK;
+
+	priv->stations[index].sta.station_flags = sta_flags;
+ done:
+	return;
+}
+#else
+static inline void iwl_set_ht_add_station(struct iwl_priv *priv, u8 index,
+					struct ieee80211_ht_info *sta_ht_info)
+{
+}
+#endif
+
+/**
+ * iwl_add_station_flags - Add station to tables in driver and device
+ */
+u8 iwl_add_station_flags(struct iwl_priv *priv, const u8 *addr, int is_ap,
+			 u8 flags, struct ieee80211_ht_info *ht_info)
+{
+	int i;
+	int index = IWL_INVALID_STATION;
+	struct iwl_station_entry *station;
+	unsigned long flags_spin;
+	DECLARE_MAC_BUF(mac);
+
+	spin_lock_irqsave(&priv->sta_lock, flags_spin);
+	if (is_ap)
+		index = IWL_AP_ID;
+	else if (is_broadcast_ether_addr(addr))
+		index = priv->hw_params.bcast_sta_id;
+	else
+		for (i = IWL_STA_ID; i < priv->hw_params.max_stations; i++) {
+			if (!compare_ether_addr(priv->stations[i].sta.sta.addr,
+						addr)) {
+				index = i;
+				break;
+			}
+
+			if (!priv->stations[i].used &&
+			    index == IWL_INVALID_STATION)
+				index = i;
+		}
+
+
+	/* These two conditions have the same outcome, but keep them separate
+	  since they have different meanings */
+	if (unlikely(index == IWL_INVALID_STATION)) {
+		spin_unlock_irqrestore(&priv->sta_lock, flags_spin);
+		return index;
+	}
+
+	if (priv->stations[index].used &&
+	    !compare_ether_addr(priv->stations[index].sta.sta.addr, addr)) {
+		spin_unlock_irqrestore(&priv->sta_lock, flags_spin);
+		return index;
+	}
+
+
+	IWL_DEBUG_ASSOC("Add STA ID %d: %s\n", index, print_mac(mac, addr));
+	station = &priv->stations[index];
+	station->used = 1;
+	priv->num_stations++;
+
+	/* Set up the REPLY_ADD_STA command to send to device */
+	memset(&station->sta, 0, sizeof(struct iwl_addsta_cmd));
+	memcpy(station->sta.sta.addr, addr, ETH_ALEN);
+	station->sta.mode = 0;
+	station->sta.sta.sta_id = index;
+	station->sta.station_flags = 0;
+
+	/* BCAST station and IBSS stations do not work in HT mode */
+	if (index != priv->hw_params.bcast_sta_id &&
+	    priv->iw_mode != IEEE80211_IF_TYPE_IBSS)
+		iwl_set_ht_add_station(priv, index, ht_info);
+
+	spin_unlock_irqrestore(&priv->sta_lock, flags_spin);
+
+	/* Add station to device's station table */
+	iwl_send_add_sta(priv, &station->sta, flags);
+	return index;
+
+}
+EXPORT_SYMBOL(iwl_add_station_flags);
+
 int iwl_get_free_ucode_key_index(struct iwl_priv *priv)
 {
 	int i;
@@ -470,3 +594,148 @@ int iwl_send_lq_cmd(struct iwl_priv *priv,
 }
 EXPORT_SYMBOL(iwl_send_lq_cmd);
 
+/**
+ * iwl_sta_init_lq - Initialize a station's hardware rate table
+ *
+ * The uCode's station table contains a table of fallback rates
+ * for automatic fallback during transmission.
+ *
+ * NOTE: This sets up a default set of values.  These will be replaced later
+ *       if the driver's iwl-4965-rs rate scaling algorithm is used, instead of
+ *       rc80211_simple.
+ *
+ * NOTE: Run REPLY_ADD_STA command to set up station table entry, before
+ *       calling this function (which runs REPLY_TX_LINK_QUALITY_CMD,
+ *       which requires station table entry to exist).
+ */
+static void iwl_sta_init_lq(struct iwl_priv *priv, const u8 *addr, int is_ap)
+{
+	int i, r;
+	struct iwl_link_quality_cmd link_cmd = {
+		.reserved1 = 0,
+	};
+	u16 rate_flags;
+
+	/* Set up the rate scaling to start at selected rate, fall back
+	 * all the way down to 1M in IEEE order, and then spin on 1M */
+	if (is_ap)
+		r = IWL_RATE_54M_INDEX;
+	else if (priv->band == IEEE80211_BAND_5GHZ)
+		r = IWL_RATE_6M_INDEX;
+	else
+		r = IWL_RATE_1M_INDEX;
+
+	for (i = 0; i < LINK_QUAL_MAX_RETRY_NUM; i++) {
+		rate_flags = 0;
+		if (r >= IWL_FIRST_CCK_RATE && r <= IWL_LAST_CCK_RATE)
+			rate_flags |= RATE_MCS_CCK_MSK;
+
+		/* Use Tx antenna B only */
+		rate_flags |= RATE_MCS_ANT_B_MSK; /*FIXME:RS*/
+
+		link_cmd.rs_table[i].rate_n_flags =
+			iwl4965_hw_set_rate_n_flags(iwl_rates[r].plcp, rate_flags);
+		r = iwl4965_get_prev_ieee_rate(r);
+	}
+
+	link_cmd.general_params.single_stream_ant_msk = 2;
+	link_cmd.general_params.dual_stream_ant_msk = 3;
+	link_cmd.agg_params.agg_dis_start_th = 3;
+	link_cmd.agg_params.agg_time_limit = cpu_to_le16(4000);
+
+	/* Update the rate scaling for control frame Tx to AP */
+	link_cmd.sta_id = is_ap ? IWL_AP_ID : priv->hw_params.bcast_sta_id;
+
+	iwl_send_cmd_pdu_async(priv, REPLY_TX_LINK_QUALITY_CMD,
+			       sizeof(link_cmd), &link_cmd, NULL);
+}
+/**
+ * iwl_rxon_add_station - add station into station table.
+ *
+ * there is only one AP station with id= IWL_AP_ID
+ * NOTE: mutex must be held before calling this fnction
+ */
+int iwl_rxon_add_station(struct iwl_priv *priv, const u8 *addr, int is_ap)
+{
+	u8 sta_id;
+
+	/* Add station to device's station table */
+#ifdef CONFIG_IWL4965_HT
+	struct ieee80211_conf *conf = &priv->hw->conf;
+	struct ieee80211_ht_info *cur_ht_config = &conf->ht_conf;
+
+	if ((is_ap) &&
+	    (conf->flags & IEEE80211_CONF_SUPPORT_HT_MODE) &&
+	    (priv->iw_mode == IEEE80211_IF_TYPE_STA))
+		sta_id = iwl_add_station_flags(priv, addr, is_ap,
+						   0, cur_ht_config);
+	else
+#endif /* CONFIG_IWL4965_HT */
+		sta_id = iwl_add_station_flags(priv, addr, is_ap,
+						   0, NULL);
+
+	/* Set up default rate scaling table in device's station table */
+	iwl_sta_init_lq(priv, addr, is_ap);
+
+	return sta_id;
+}
+EXPORT_SYMBOL(iwl_rxon_add_station);
+
+
+/**
+ * iwl_get_sta_id - Find station's index within station table
+ *
+ * If new IBSS station, create new entry in station table
+ */
+int iwl_get_sta_id(struct iwl_priv *priv, struct ieee80211_hdr *hdr)
+{
+	int sta_id;
+	u16 fc = le16_to_cpu(hdr->frame_control);
+	DECLARE_MAC_BUF(mac);
+
+	/* If this frame is broadcast or management, use broadcast station id */
+	if (((fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_DATA) ||
+	    is_multicast_ether_addr(hdr->addr1))
+		return priv->hw_params.bcast_sta_id;
+
+	switch (priv->iw_mode) {
+
+	/* If we are a client station in a BSS network, use the special
+	 * AP station entry (that's the only station we communicate with) */
+	case IEEE80211_IF_TYPE_STA:
+		return IWL_AP_ID;
+
+	/* If we are an AP, then find the station, or use BCAST */
+	case IEEE80211_IF_TYPE_AP:
+		sta_id = iwl_find_station(priv, hdr->addr1);
+		if (sta_id != IWL_INVALID_STATION)
+			return sta_id;
+		return priv->hw_params.bcast_sta_id;
+
+	/* If this frame is going out to an IBSS network, find the station,
+	 * or create a new station table entry */
+	case IEEE80211_IF_TYPE_IBSS:
+		sta_id = iwl_find_station(priv, hdr->addr1);
+		if (sta_id != IWL_INVALID_STATION)
+			return sta_id;
+
+		/* Create new station table entry */
+		sta_id = iwl_add_station_flags(priv, hdr->addr1,
+						   0, CMD_ASYNC, NULL);
+
+		if (sta_id != IWL_INVALID_STATION)
+			return sta_id;
+
+		IWL_DEBUG_DROP("Station %s not in station map. "
+			       "Defaulting to broadcast...\n",
+			       print_mac(mac, hdr->addr1));
+		iwl_print_hex_dump(priv, IWL_DL_DROP, (u8 *) hdr, sizeof(*hdr));
+		return priv->hw_params.bcast_sta_id;
+
+	default:
+		IWL_WARNING("Unknown mode of operation: %d", priv->iw_mode);
+		return priv->hw_params.bcast_sta_id;
+	}
+}
+EXPORT_SYMBOL(iwl_get_sta_id);
+
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.h b/drivers/net/wireless/iwlwifi/iwl-sta.h
index 38b1b0a..ee25643 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.h
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.h
@@ -39,4 +39,6 @@ int iwl_set_dynamic_key(struct iwl_priv *priv,
 				struct ieee80211_key_conf *key, u8 sta_id);
 int iwl_remove_dynamic_key(struct iwl_priv *priv,
 				struct ieee80211_key_conf *key, u8 sta_id);
+int iwl_rxon_add_station(struct iwl_priv *priv, const u8 *addr, int is_ap);
+int iwl_get_sta_id(struct iwl_priv *priv, struct ieee80211_hdr *hdr);
 #endif /* __iwl_sta_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index bb820f3..88032cc 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -258,79 +258,6 @@ out:
 }
 #endif
 
-/**
- * iwl4965_add_station_flags - Add station to tables in driver and device
- */
-u8 iwl4965_add_station_flags(struct iwl_priv *priv, const u8 *addr,
-				int is_ap, u8 flags, void *ht_data)
-{
-	int i;
-	int index = IWL_INVALID_STATION;
-	struct iwl_station_entry *station;
-	unsigned long flags_spin;
-	DECLARE_MAC_BUF(mac);
-
-	spin_lock_irqsave(&priv->sta_lock, flags_spin);
-	if (is_ap)
-		index = IWL_AP_ID;
-	else if (is_broadcast_ether_addr(addr))
-		index = priv->hw_params.bcast_sta_id;
-	else
-		for (i = IWL_STA_ID; i < priv->hw_params.max_stations; i++) {
-			if (!compare_ether_addr(priv->stations[i].sta.sta.addr,
-						addr)) {
-				index = i;
-				break;
-			}
-
-			if (!priv->stations[i].used &&
-			    index == IWL_INVALID_STATION)
-				index = i;
-		}
-
-
-	/* These two conditions have the same outcome, but keep them separate
-	  since they have different meanings */
-	if (unlikely(index == IWL_INVALID_STATION)) {
-		spin_unlock_irqrestore(&priv->sta_lock, flags_spin);
-		return index;
-	}
-
-	if (priv->stations[index].used &&
-	    !compare_ether_addr(priv->stations[index].sta.sta.addr, addr)) {
-		spin_unlock_irqrestore(&priv->sta_lock, flags_spin);
-		return index;
-	}
-
-
-	IWL_DEBUG_ASSOC("Add STA ID %d: %s\n", index, print_mac(mac, addr));
-	station = &priv->stations[index];
-	station->used = 1;
-	priv->num_stations++;
-
-	/* Set up the REPLY_ADD_STA command to send to device */
-	memset(&station->sta, 0, sizeof(struct iwl_addsta_cmd));
-	memcpy(station->sta.sta.addr, addr, ETH_ALEN);
-	station->sta.mode = 0;
-	station->sta.sta.sta_id = index;
-	station->sta.station_flags = 0;
-
-#ifdef CONFIG_IWL4965_HT
-	/* BCAST station and IBSS stations do not work in HT mode */
-	if (index != priv->hw_params.bcast_sta_id &&
-	    priv->iw_mode != IEEE80211_IF_TYPE_IBSS)
-		iwl4965_set_ht_add_station(priv, index,
-				 (struct ieee80211_ht_info *) ht_data);
-#endif /*CONFIG_IWL4965_HT*/
-
-	spin_unlock_irqrestore(&priv->sta_lock, flags_spin);
-
-	/* Add station to device's station table */
-	iwl_send_add_sta(priv, &station->sta, flags);
-	return index;
-
-}
-
 
 
 /*************** HOST COMMAND QUEUE FUNCTIONS   *****/
@@ -434,38 +361,6 @@ static void iwl4965_set_rxon_hwcrypto(struct iwl_priv *priv, int hw_decrypt)
 }
 
 /**
- * iwl4965_rxon_add_station - add station into station table.
- *
- * there is only one AP station with id= IWL_AP_ID
- * NOTE: mutex must be held before calling this fnction
- */
-static int iwl4965_rxon_add_station(struct iwl_priv *priv,
-				const u8 *addr, int is_ap)
-{
-	u8 sta_id;
-
-	/* Add station to device's station table */
-#ifdef CONFIG_IWL4965_HT
-	struct ieee80211_conf *conf = &priv->hw->conf;
-	struct ieee80211_ht_info *cur_ht_config = &conf->ht_conf;
-
-	if ((is_ap) &&
-	    (conf->flags & IEEE80211_CONF_SUPPORT_HT_MODE) &&
-	    (priv->iw_mode == IEEE80211_IF_TYPE_STA))
-		sta_id = iwl4965_add_station_flags(priv, addr, is_ap,
-						   0, cur_ht_config);
-	else
-#endif /* CONFIG_IWL4965_HT */
-		sta_id = iwl4965_add_station_flags(priv, addr, is_ap,
-						   0, NULL);
-
-	/* Set up default rate scaling table in device's station table */
-	iwl4965_add_station(priv, addr, is_ap);
-
-	return sta_id;
-}
-
-/**
  * iwl4965_check_rxon_cmd - validate RXON structure is valid
  *
  * NOTE:  This is really only useful during development and can eventually
@@ -691,7 +586,7 @@ static int iwl4965_commit_rxon(struct iwl_priv *priv)
 	}
 
 	/* Add the broadcast address so we can send broadcast frames */
-	if (iwl4965_rxon_add_station(priv, iwl_bcast_addr, 0) ==
+	if (iwl_rxon_add_station(priv, iwl_bcast_addr, 0) ==
 	    IWL_INVALID_STATION) {
 		IWL_ERROR("Error adding BROADCAST address for transmit.\n");
 		return -EIO;
@@ -701,7 +596,7 @@ static int iwl4965_commit_rxon(struct iwl_priv *priv)
 	 * add the IWL_AP_ID to the station rate table */
 	if (iwl_is_associated(priv) &&
 	    (priv->iw_mode == IEEE80211_IF_TYPE_STA)) {
-		if (iwl4965_rxon_add_station(priv, priv->active_rxon.bssid_addr, 1)
+		if (iwl_rxon_add_station(priv, priv->active_rxon.bssid_addr, 1)
 		    == IWL_INVALID_STATION) {
 			IWL_ERROR("Error adding AP address for transmit.\n");
 			return -EIO;
@@ -1702,63 +1597,6 @@ static void iwl_update_tx_stats(struct iwl_priv *priv, u16 fc, u16 len)
 	priv->tx_stats[idx].cnt++;
 	priv->tx_stats[idx].bytes += len;
 }
-/**
- * iwl4965_get_sta_id - Find station's index within station table
- *
- * If new IBSS station, create new entry in station table
- */
-static int iwl4965_get_sta_id(struct iwl_priv *priv,
-				struct ieee80211_hdr *hdr)
-{
-	int sta_id;
-	u16 fc = le16_to_cpu(hdr->frame_control);
-	DECLARE_MAC_BUF(mac);
-
-	/* If this frame is broadcast or management, use broadcast station id */
-	if (((fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_DATA) ||
-	    is_multicast_ether_addr(hdr->addr1))
-		return priv->hw_params.bcast_sta_id;
-
-	switch (priv->iw_mode) {
-
-	/* If we are a client station in a BSS network, use the special
-	 * AP station entry (that's the only station we communicate with) */
-	case IEEE80211_IF_TYPE_STA:
-		return IWL_AP_ID;
-
-	/* If we are an AP, then find the station, or use BCAST */
-	case IEEE80211_IF_TYPE_AP:
-		sta_id = iwl_find_station(priv, hdr->addr1);
-		if (sta_id != IWL_INVALID_STATION)
-			return sta_id;
-		return priv->hw_params.bcast_sta_id;
-
-	/* If this frame is going out to an IBSS network, find the station,
-	 * or create a new station table entry */
-	case IEEE80211_IF_TYPE_IBSS:
-		sta_id = iwl_find_station(priv, hdr->addr1);
-		if (sta_id != IWL_INVALID_STATION)
-			return sta_id;
-
-		/* Create new station table entry */
-		sta_id = iwl4965_add_station_flags(priv, hdr->addr1,
-						   0, CMD_ASYNC, NULL);
-
-		if (sta_id != IWL_INVALID_STATION)
-			return sta_id;
-
-		IWL_DEBUG_DROP("Station %s not in station map. "
-			       "Defaulting to broadcast...\n",
-			       print_mac(mac, hdr->addr1));
-		iwl_print_hex_dump(priv, IWL_DL_DROP, (u8 *) hdr, sizeof(*hdr));
-		return priv->hw_params.bcast_sta_id;
-
-	default:
-		IWL_WARNING("Unknown mode of operation: %d", priv->iw_mode);
-		return priv->hw_params.bcast_sta_id;
-	}
-}
-
 /*
  * start REPLY_TX command process
  */
@@ -1829,7 +1667,7 @@ static int iwl4965_tx_skb(struct iwl_priv *priv,
 	hdr_len = ieee80211_get_hdrlen(fc);
 
 	/* Find (or create) index into station table for destination station */
-	sta_id = iwl4965_get_sta_id(priv, hdr);
+	sta_id = iwl_get_sta_id(priv, hdr);
 	if (sta_id == IWL_INVALID_STATION) {
 		DECLARE_MAC_BUF(mac);
 
@@ -3585,7 +3423,7 @@ static void iwl4965_error_recovery(struct iwl_priv *priv)
 	priv->staging_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
 	iwl4965_commit_rxon(priv);
 
-	iwl4965_rxon_add_station(priv, priv->bssid, 1);
+	iwl_rxon_add_station(priv, priv->bssid, 1);
 
 	spin_lock_irqsave(&priv->lock, flags);
 	priv->assoc_id = le16_to_cpu(priv->staging_rxon.assoc_id);
@@ -4911,8 +4749,8 @@ static void iwl4965_post_associate(struct iwl_priv *priv)
 		/* clear out the station table */
 		iwlcore_clear_stations_table(priv);
 
-		iwl4965_rxon_add_station(priv, iwl_bcast_addr, 0);
-		iwl4965_rxon_add_station(priv, priv->bssid, 0);
+		iwl_rxon_add_station(priv, iwl_bcast_addr, 0);
+		iwl_rxon_add_station(priv, priv->bssid, 0);
 		iwl4965_rate_scale_init(priv->hw, IWL_STA_ID);
 		iwl4965_send_beacon_cmd(priv);
 
@@ -5323,7 +5161,7 @@ static void iwl4965_config_ap(struct iwl_priv *priv)
 		priv->staging_rxon.filter_flags |= RXON_FILTER_ASSOC_MSK;
 		iwl4965_commit_rxon(priv);
 		iwl4965_activate_qos(priv, 1);
-		iwl4965_rxon_add_station(priv, iwl_bcast_addr, 0);
+		iwl_rxon_add_station(priv, iwl_bcast_addr, 0);
 	}
 	iwl4965_send_beacon_cmd(priv);
 
@@ -5412,7 +5250,7 @@ static int iwl4965_mac_config_interface(struct ieee80211_hw *hw,
 		else {
 			rc = iwl4965_commit_rxon(priv);
 			if ((priv->iw_mode == IEEE80211_IF_TYPE_STA) && rc)
-				iwl4965_rxon_add_station(
+				iwl_rxon_add_station(
 					priv, priv->active_rxon.bssid_addr, 1);
 		}
 
-- 
1.5.3.6

