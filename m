Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:6615 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754284Ab0H0Q4r (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Aug 2010 12:56:47 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 04/27] iwlwifi: contextify broadcast station
Date: Fri, 27 Aug 2010 09:59:32 -0700
Message-Id: <1282928395-32762-5-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1282928395-32762-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1282928395-32762-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The broadcast station ID is per context, so
add a variable for the ID in the context and
use it everywhere we previously hardcoded it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c     |    4 +-
 drivers/net/wireless/iwlwifi/iwl-3945-rs.c  |    2 +-
 drivers/net/wireless/iwlwifi/iwl-3945.c     |   11 ++-
 drivers/net/wireless/iwlwifi/iwl-4965.c     |    6 +-
 drivers/net/wireless/iwlwifi/iwl-5000.c     |    8 +-
 drivers/net/wireless/iwlwifi/iwl-6000.c     |    6 +-
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c  |    9 ++-
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c   |    9 ++-
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   32 +++++++---
 drivers/net/wireless/iwlwifi/iwl-core.c     |    4 +-
 drivers/net/wireless/iwlwifi/iwl-core.h     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    4 +-
 drivers/net/wireless/iwlwifi/iwl-sta.c      |   89 ++++++++++++++++-----------
 drivers/net/wireless/iwlwifi/iwl-sta.h      |   29 +++++----
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   20 ++++---
 15 files changed, 142 insertions(+), 93 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index 3bf5a30..674fb93 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -130,7 +130,7 @@ static int iwl1000_hw_set_hw_params(struct iwl_priv *priv)
 			sizeof(struct iwlagn_scd_bc_tbl);
 	priv->hw_params.tfd_size = sizeof(struct iwl_tfd);
 	priv->hw_params.max_stations = IWLAGN_STATION_COUNT;
-	priv->hw_params.bcast_sta_id = IWLAGN_BROADCAST_ID;
+	priv->contexts[IWL_RXON_CTX_BSS].bcast_sta_id = IWLAGN_BROADCAST_ID;
 
 	priv->hw_params.max_data_size = IWLAGN_RTC_DATA_SIZE;
 	priv->hw_params.max_inst_size = IWLAGN_RTC_INST_SIZE;
@@ -217,7 +217,7 @@ static struct iwl_lib_ops iwl1000_lib = {
 		.set_ct_kill = iwl1000_set_ct_threshold,
 	 },
 	.manage_ibss_station = iwlagn_manage_ibss_station,
-	.update_bcast_station = iwl_update_bcast_station,
+	.update_bcast_stations = iwl_update_bcast_stations,
 	.debugfs_ops = {
 		.rx_stats_read = iwl_ucode_rx_stats_read,
 		.tx_stats_read = iwl_ucode_tx_stats_read,
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-rs.c b/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
index 08f53f8..0cfc7a6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
@@ -343,7 +343,7 @@ void iwl3945_rs_rate_init(struct iwl_priv *priv, struct ieee80211_sta *sta, u8 s
 	int i;
 
 	IWL_DEBUG_INFO(priv, "enter\n");
-	if (sta_id == priv->hw_params.bcast_sta_id)
+	if (sta_id == priv->contexts[IWL_RXON_CTX_BSS].bcast_sta_id)
 		goto out;
 
 	psta = (struct iwl3945_sta_priv *) sta->drv_priv;
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index f059b1d..905575c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -2305,8 +2305,10 @@ static int iwl3945_manage_ibss_station(struct iwl_priv *priv,
 	int ret;
 
 	if (add) {
-		ret = iwl_add_bssid_station(priv, vif->bss_conf.bssid, false,
-					    &vif_priv->ibss_bssid_sta_id);
+		ret = iwl_add_bssid_station(
+				priv, &priv->contexts[IWL_RXON_CTX_BSS],
+				vif->bss_conf.bssid, false,
+				&vif_priv->ibss_bssid_sta_id);
 		if (ret)
 			return ret;
 
@@ -2424,7 +2426,7 @@ int iwl3945_hw_set_hw_params(struct iwl_priv *priv)
 	priv->hw_params.max_rxq_size = RX_QUEUE_SIZE;
 	priv->hw_params.max_rxq_log = RX_QUEUE_SIZE_LOG;
 	priv->hw_params.max_stations = IWL3945_STATION_COUNT;
-	priv->hw_params.bcast_sta_id = IWL3945_BROADCAST_ID;
+	priv->contexts[IWL_RXON_CTX_BSS].bcast_sta_id = IWL3945_BROADCAST_ID;
 
 	priv->hw_params.rx_wrt_ptr_reg = FH39_RSCSR_CHNL0_WPTR;
 	priv->hw_params.max_beacon_itrvl = IWL39_MAX_UCODE_BEACON_INTERVAL;
@@ -2442,7 +2444,8 @@ unsigned int iwl3945_hw_get_beacon_cmd(struct iwl_priv *priv,
 	tx_beacon_cmd = (struct iwl3945_tx_beacon_cmd *)&frame->u;
 	memset(tx_beacon_cmd, 0, sizeof(*tx_beacon_cmd));
 
-	tx_beacon_cmd->tx.sta_id = priv->hw_params.bcast_sta_id;
+	tx_beacon_cmd->tx.sta_id =
+		priv->contexts[IWL_RXON_CTX_BSS].bcast_sta_id;
 	tx_beacon_cmd->tx.stop_time.life_time = TX_CMD_LIFE_TIME_INFINITE;
 
 	frame_size = iwl3945_fill_beacon_frame(priv,
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index cda389c..c155816 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -657,7 +657,7 @@ static int iwl4965_hw_set_hw_params(struct iwl_priv *priv)
 			sizeof(struct iwl4965_scd_bc_tbl);
 	priv->hw_params.tfd_size = sizeof(struct iwl_tfd);
 	priv->hw_params.max_stations = IWL4965_STATION_COUNT;
-	priv->hw_params.bcast_sta_id = IWL4965_BROADCAST_ID;
+	priv->contexts[IWL_RXON_CTX_BSS].bcast_sta_id = IWL4965_BROADCAST_ID;
 	priv->hw_params.max_data_size = IWL49_RTC_DATA_SIZE;
 	priv->hw_params.max_inst_size = IWL49_RTC_INST_SIZE;
 	priv->hw_params.max_bsm_size = BSM_SRAM_SIZE;
@@ -2010,7 +2010,7 @@ static u8 iwl_find_station(struct iwl_priv *priv, const u8 *addr)
 		start = IWL_STA_ID;
 
 	if (is_broadcast_ether_addr(addr))
-		return priv->hw_params.bcast_sta_id;
+		return priv->contexts[IWL_RXON_CTX_BSS].bcast_sta_id;
 
 	spin_lock_irqsave(&priv->sta_lock, flags);
 	for (i = start; i < priv->hw_params.max_stations; i++)
@@ -2283,7 +2283,7 @@ static struct iwl_lib_ops iwl4965_lib = {
 		.set_ct_kill = iwl4965_set_ct_threshold,
 	},
 	.manage_ibss_station = iwlagn_manage_ibss_station,
-	.update_bcast_station = iwl_update_bcast_station,
+	.update_bcast_stations = iwl_update_bcast_stations,
 	.debugfs_ops = {
 		.rx_stats_read = iwl_ucode_rx_stats_read,
 		.tx_stats_read = iwl_ucode_tx_stats_read,
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 8536f19..d67031f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -180,7 +180,7 @@ static int iwl5000_hw_set_hw_params(struct iwl_priv *priv)
 			sizeof(struct iwlagn_scd_bc_tbl);
 	priv->hw_params.tfd_size = sizeof(struct iwl_tfd);
 	priv->hw_params.max_stations = IWLAGN_STATION_COUNT;
-	priv->hw_params.bcast_sta_id = IWLAGN_BROADCAST_ID;
+	priv->contexts[IWL_RXON_CTX_BSS].bcast_sta_id = IWLAGN_BROADCAST_ID;
 
 	priv->hw_params.max_data_size = IWLAGN_RTC_DATA_SIZE;
 	priv->hw_params.max_inst_size = IWLAGN_RTC_INST_SIZE;
@@ -227,7 +227,7 @@ static int iwl5150_hw_set_hw_params(struct iwl_priv *priv)
 			sizeof(struct iwlagn_scd_bc_tbl);
 	priv->hw_params.tfd_size = sizeof(struct iwl_tfd);
 	priv->hw_params.max_stations = IWLAGN_STATION_COUNT;
-	priv->hw_params.bcast_sta_id = IWLAGN_BROADCAST_ID;
+	priv->contexts[IWL_RXON_CTX_BSS].bcast_sta_id = IWLAGN_BROADCAST_ID;
 
 	priv->hw_params.max_data_size = IWLAGN_RTC_DATA_SIZE;
 	priv->hw_params.max_inst_size = IWLAGN_RTC_INST_SIZE;
@@ -398,7 +398,7 @@ static struct iwl_lib_ops iwl5000_lib = {
 		.set_ct_kill = iwl5000_set_ct_threshold,
 	 },
 	.manage_ibss_station = iwlagn_manage_ibss_station,
-	.update_bcast_station = iwl_update_bcast_station,
+	.update_bcast_stations = iwl_update_bcast_stations,
 	.debugfs_ops = {
 		.rx_stats_read = iwl_ucode_rx_stats_read,
 		.tx_stats_read = iwl_ucode_tx_stats_read,
@@ -469,7 +469,7 @@ static struct iwl_lib_ops iwl5150_lib = {
 		.set_ct_kill = iwl5150_set_ct_threshold,
 	 },
 	.manage_ibss_station = iwlagn_manage_ibss_station,
-	.update_bcast_station = iwl_update_bcast_station,
+	.update_bcast_stations = iwl_update_bcast_stations,
 	.debugfs_ops = {
 		.rx_stats_read = iwl_ucode_rx_stats_read,
 		.tx_stats_read = iwl_ucode_tx_stats_read,
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index bf1fe25..8c4a98b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -161,7 +161,7 @@ static int iwl6000_hw_set_hw_params(struct iwl_priv *priv)
 			sizeof(struct iwlagn_scd_bc_tbl);
 	priv->hw_params.tfd_size = sizeof(struct iwl_tfd);
 	priv->hw_params.max_stations = IWLAGN_STATION_COUNT;
-	priv->hw_params.bcast_sta_id = IWLAGN_BROADCAST_ID;
+	priv->contexts[IWL_RXON_CTX_BSS].bcast_sta_id = IWLAGN_BROADCAST_ID;
 
 	priv->hw_params.max_data_size = IWL60_RTC_DATA_SIZE;
 	priv->hw_params.max_inst_size = IWL60_RTC_INST_SIZE;
@@ -323,7 +323,7 @@ static struct iwl_lib_ops iwl6000_lib = {
 		.set_calib_version = iwl6000_set_calib_version,
 	 },
 	.manage_ibss_station = iwlagn_manage_ibss_station,
-	.update_bcast_station = iwl_update_bcast_station,
+	.update_bcast_stations = iwl_update_bcast_stations,
 	.debugfs_ops = {
 		.rx_stats_read = iwl_ucode_rx_stats_read,
 		.tx_stats_read = iwl_ucode_tx_stats_read,
@@ -398,7 +398,7 @@ static struct iwl_lib_ops iwl6000g2b_lib = {
 		.set_calib_version = iwl6000_set_calib_version,
 	 },
 	.manage_ibss_station = iwlagn_manage_ibss_station,
-	.update_bcast_station = iwl_update_bcast_station,
+	.update_bcast_stations = iwl_update_bcast_stations,
 	.debugfs_ops = {
 		.rx_stats_read = iwl_ucode_rx_stats_read,
 		.tx_stats_read = iwl_ucode_tx_stats_read,
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index f919977..cb3c173 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -1163,6 +1163,7 @@ void iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 	};
 	struct iwl_scan_cmd *scan;
 	struct ieee80211_conf *conf = NULL;
+	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_BSS];
 	u32 rate_flags = 0;
 	u16 cmd_len;
 	u16 rx_chain = 0;
@@ -1175,6 +1176,9 @@ void iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 	u8 active_chains;
 	u8 scan_tx_antennas = priv->hw_params.valid_tx_ant;
 
+	if (vif)
+		ctx = iwl_rxon_ctx_from_vif(vif);
+
 	conf = ieee80211_get_hw_conf(priv->hw);
 
 	cancel_delayed_work(&priv->scan_check);
@@ -1283,7 +1287,7 @@ void iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 		IWL_DEBUG_SCAN(priv, "Start passive scan.\n");
 
 	scan->tx_cmd.tx_flags = TX_CMD_FLG_SEQ_CTL_MSK;
-	scan->tx_cmd.sta_id = priv->hw_params.bcast_sta_id;
+	scan->tx_cmd.sta_id = ctx->bcast_sta_id;
 	scan->tx_cmd.stop_time.life_time = TX_CMD_LIFE_TIME_INFINITE;
 
 	switch (priv->scan_band) {
@@ -1446,7 +1450,8 @@ int iwlagn_manage_ibss_station(struct iwl_priv *priv,
 	struct iwl_vif_priv *vif_priv = (void *)vif->drv_priv;
 
 	if (add)
-		return iwl_add_bssid_station(priv, vif->bss_conf.bssid, true,
+		return iwl_add_bssid_station(priv, vif_priv->ctx,
+					     vif->bss_conf.bssid, true,
 					     &vif_priv->ibss_bssid_sta_id);
 	return iwl_remove_station(priv, vif_priv->ibss_bssid_sta_id,
 				  vif->bss_conf.bssid);
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index 88b7bbf..a2e4ca0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -531,6 +531,7 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	struct iwl_device_cmd *out_cmd;
 	struct iwl_cmd_meta *out_meta;
 	struct iwl_tx_cmd *tx_cmd;
+	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_BSS];
 	int swq_id, txq_id;
 	dma_addr_t phys_addr;
 	dma_addr_t txcmd_phys;
@@ -545,6 +546,9 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	u8 *qc = NULL;
 	unsigned long flags;
 
+	if (info->control.vif)
+		ctx = iwl_rxon_ctx_from_vif(info->control.vif);
+
 	spin_lock_irqsave(&priv->lock, flags);
 	if (iwl_is_rfkill(priv)) {
 		IWL_DEBUG_DROP(priv, "Dropping - RF KILL\n");
@@ -565,7 +569,7 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	hdr_len = ieee80211_hdrlen(fc);
 
 	/* Find index into station table for destination station */
-	sta_id = iwl_sta_id_or_broadcast(priv, info->control.sta);
+	sta_id = iwl_sta_id_or_broadcast(priv, ctx, info->control.sta);
 	if (sta_id == IWL_INVALID_STATION) {
 		IWL_DEBUG_DROP(priv, "Dropping - INVALID STATION: %pM\n",
 			       hdr->addr1);
@@ -577,8 +581,7 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	if (sta)
 		sta_priv = (void *)sta->drv_priv;
 
-	if (sta_priv && sta_id != priv->hw_params.bcast_sta_id &&
-	    sta_priv->asleep) {
+	if (sta_priv && sta_priv->asleep) {
 		WARN_ON(!(info->flags & IEEE80211_TX_CTL_PSPOLL_RESPONSE));
 		/*
 		 * This sends an asynchronous command to the device,
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 5f67955..d222278 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -357,7 +357,9 @@ static unsigned int iwl_hw_get_beacon_cmd(struct iwl_priv *priv,
 
 	/* Set up TX command fields */
 	tx_beacon_cmd->tx.len = cpu_to_le16((u16)frame_size);
-	tx_beacon_cmd->tx.sta_id = priv->hw_params.bcast_sta_id;
+#warning "Use proper STA ID"
+	tx_beacon_cmd->tx.sta_id =
+		priv->contexts[IWL_RXON_CTX_BSS].bcast_sta_id;
 	tx_beacon_cmd->tx.stop_time.life_time = TX_CMD_LIFE_TIME_INFINITE;
 	tx_beacon_cmd->tx.tx_flags = TX_CMD_FLG_SEQ_CTL_MSK |
 		TX_CMD_FLG_TSF_MSK | TX_CMD_FLG_STA_RATE_MSK;
@@ -2829,7 +2831,7 @@ static void __iwl_down(struct iwl_priv *priv)
 		del_timer_sync(&priv->monitor_recover);
 
 	iwl_clear_ucode_stations(priv);
-	iwl_dealloc_bcast_station(priv);
+	iwl_dealloc_bcast_stations(priv);
 	iwl_clear_driver_stations(priv);
 
 	/* reset BT coex data */
@@ -2971,6 +2973,7 @@ static int iwl_prepare_card_hw(struct iwl_priv *priv)
 
 static int __iwl_up(struct iwl_priv *priv)
 {
+	struct iwl_rxon_context *ctx;
 	int i;
 	int ret;
 
@@ -2984,9 +2987,13 @@ static int __iwl_up(struct iwl_priv *priv)
 		return -EIO;
 	}
 
-	ret = iwl_alloc_bcast_station(priv, true);
-	if (ret)
-		return ret;
+	for_each_context(priv, ctx) {
+		ret = iwl_alloc_bcast_station(priv, ctx, true);
+		if (ret) {
+			iwl_dealloc_bcast_stations(priv);
+			return ret;
+		}
+	}
 
 	iwl_prepare_card_hw(priv);
 
@@ -3520,9 +3527,11 @@ static void iwl_mac_update_tkip_key(struct ieee80211_hw *hw,
 {
 
 	struct iwl_priv *priv = hw->priv;
+	struct iwl_vif_priv *vif_priv = (void *)vif->drv_priv;
+
 	IWL_DEBUG_MAC80211(priv, "enter\n");
 
-	iwl_update_tkip_key(priv, keyconf, sta,
+	iwl_update_tkip_key(priv, vif_priv->ctx, keyconf, sta,
 			    iv32, phase1key);
 
 	IWL_DEBUG_MAC80211(priv, "leave\n");
@@ -3534,6 +3543,7 @@ static int iwl_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 			   struct ieee80211_key_conf *key)
 {
 	struct iwl_priv *priv = hw->priv;
+	struct iwl_vif_priv *vif_priv = (void *)vif->drv_priv;
 	int ret;
 	u8 sta_id;
 	bool is_default_wep_key = false;
@@ -3545,7 +3555,7 @@ static int iwl_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		return -EOPNOTSUPP;
 	}
 
-	sta_id = iwl_sta_id_or_broadcast(priv, sta);
+	sta_id = iwl_sta_id_or_broadcast(priv, vif_priv->ctx, sta);
 	if (sta_id == IWL_INVALID_STATION)
 		return -EINVAL;
 
@@ -3573,7 +3583,8 @@ static int iwl_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		if (is_default_wep_key)
 			ret = iwl_set_default_wep_key(priv, key);
 		else
-			ret = iwl_set_dynamic_key(priv, key, sta_id);
+			ret = iwl_set_dynamic_key(priv, vif_priv->ctx,
+						  key, sta_id);
 
 		IWL_DEBUG_MAC80211(priv, "enable hwcrypto key\n");
 		break;
@@ -3713,6 +3724,7 @@ static int iwlagn_mac_sta_add(struct ieee80211_hw *hw,
 {
 	struct iwl_priv *priv = hw->priv;
 	struct iwl_station_priv *sta_priv = (void *)sta->drv_priv;
+	struct iwl_vif_priv *vif_priv = (void *)vif->drv_priv;
 	bool is_ap = vif->type == NL80211_IFTYPE_STATION;
 	int ret;
 	u8 sta_id;
@@ -3728,8 +3740,8 @@ static int iwlagn_mac_sta_add(struct ieee80211_hw *hw,
 	if (vif->type == NL80211_IFTYPE_AP)
 		sta_priv->client = true;
 
-	ret = iwl_add_station_common(priv, sta->addr, is_ap, &sta->ht_cap,
-				     &sta_id);
+	ret = iwl_add_station_common(priv, vif_priv->ctx, sta->addr,
+				     is_ap, &sta->ht_cap, &sta_id);
 	if (ret) {
 		IWL_ERR(priv, "Unable to add station %pM (%d)\n",
 			sta->addr, ret);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index f6aa5ce..f7bfe59 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -2113,8 +2113,8 @@ int iwl_mac_config(struct ieee80211_hw *hw, u32 changed)
 
 		spin_unlock_irqrestore(&priv->lock, flags);
 
-		if (priv->cfg->ops->lib->update_bcast_station)
-			ret = priv->cfg->ops->lib->update_bcast_station(priv);
+		if (priv->cfg->ops->lib->update_bcast_stations)
+			ret = priv->cfg->ops->lib->update_bcast_stations(priv);
 
  set_ch_out:
 		/* The list of supported rates and rate mask can be different
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 80c2562..7aa9c6c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -206,7 +206,7 @@ struct iwl_lib_ops {
 	/* station management */
 	int (*manage_ibss_station)(struct iwl_priv *priv,
 				   struct ieee80211_vif *vif, bool add);
-	int (*update_bcast_station)(struct iwl_priv *priv);
+	int (*update_bcast_stations)(struct iwl_priv *priv);
 	/* recover from tx queue stall */
 	void (*recover_from_tx_stall)(unsigned long data);
 	/* check for plcp health */
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 8ec377d..f51c07c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -681,7 +681,6 @@ struct iwl_sensitivity_ranges {
  * @rx_page_order: Rx buffer page order
  * @rx_wrt_ptr_reg: FH{39}_RSCSR_CHNL0_WPTR
  * @max_stations:
- * @bcast_sta_id:
  * @ht40_channel: is 40MHz width possible in band 2.4
  * BIT(IEEE80211_BAND_5GHZ) BIT(IEEE80211_BAND_5GHZ)
  * @sw_crypto: 0 for hw, 1 for sw
@@ -705,7 +704,6 @@ struct iwl_hw_params {
 	u32 rx_page_order;
 	u32 rx_wrt_ptr_reg;
 	u8  max_stations;
-	u8  bcast_sta_id;
 	u8  ht40_channel;
 	u8  max_beacon_itrvl;	/* in 1024 ms */
 	u32 max_inst_size;
@@ -1126,6 +1124,8 @@ struct iwl_rxon_context {
 	struct iwl_rxon_cmd staging;
 
 	struct iwl_rxon_time_cmd timing;
+
+	u8 bcast_sta_id;
 };
 
 struct iwl_priv {
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index 43afb8f..b1275e3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -226,8 +226,8 @@ static void iwl_set_ht_add_station(struct iwl_priv *priv, u8 index,
  *
  * should be called with sta_lock held
  */
-static u8 iwl_prep_station(struct iwl_priv *priv, const u8 *addr,
-			   bool is_ap,
+static u8 iwl_prep_station(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
+			   const u8 *addr, bool is_ap,
 			   struct ieee80211_sta_ht_cap *ht_info)
 {
 	struct iwl_station_entry *station;
@@ -238,7 +238,7 @@ static u8 iwl_prep_station(struct iwl_priv *priv, const u8 *addr,
 	if (is_ap)
 		sta_id = IWL_AP_ID;
 	else if (is_broadcast_ether_addr(addr))
-		sta_id = priv->hw_params.bcast_sta_id;
+		sta_id = ctx->bcast_sta_id;
 	else
 		for (i = IWL_STA_ID; i < priv->hw_params.max_stations; i++) {
 			if (!compare_ether_addr(priv->stations[i].sta.sta.addr,
@@ -313,10 +313,9 @@ static u8 iwl_prep_station(struct iwl_priv *priv, const u8 *addr,
 /**
  * iwl_add_station_common -
  */
-int iwl_add_station_common(struct iwl_priv *priv, const u8 *addr,
-				  bool is_ap,
-				  struct ieee80211_sta_ht_cap *ht_info,
-				  u8 *sta_id_r)
+int iwl_add_station_common(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
+			   const u8 *addr, bool is_ap,
+			   struct ieee80211_sta_ht_cap *ht_info, u8 *sta_id_r)
 {
 	unsigned long flags_spin;
 	int ret = 0;
@@ -325,7 +324,7 @@ int iwl_add_station_common(struct iwl_priv *priv, const u8 *addr,
 
 	*sta_id_r = 0;
 	spin_lock_irqsave(&priv->sta_lock, flags_spin);
-	sta_id = iwl_prep_station(priv, addr, is_ap, ht_info);
+	sta_id = iwl_prep_station(priv, ctx, addr, is_ap, ht_info);
 	if (sta_id == IWL_INVALID_STATION) {
 		IWL_ERR(priv, "Unable to prepare station %pM for addition\n",
 			addr);
@@ -431,8 +430,8 @@ static struct iwl_link_quality_cmd *iwl_sta_alloc_lq(struct iwl_priv *priv,
  *
  * Function sleeps.
  */
-int iwl_add_bssid_station(struct iwl_priv *priv, const u8 *addr, bool init_rs,
-			  u8 *sta_id_r)
+int iwl_add_bssid_station(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
+			  const u8 *addr, bool init_rs, u8 *sta_id_r)
 {
 	int ret;
 	u8 sta_id;
@@ -442,7 +441,7 @@ int iwl_add_bssid_station(struct iwl_priv *priv, const u8 *addr, bool init_rs,
 	if (sta_id_r)
 		*sta_id_r = IWL_INVALID_STATION;
 
-	ret = iwl_add_station_common(priv, addr, 0, NULL, &sta_id);
+	ret = iwl_add_station_common(priv, ctx, addr, 0, NULL, &sta_id);
 	if (ret) {
 		IWL_ERR(priv, "Unable to add station %pM\n", addr);
 		return ret;
@@ -833,8 +832,9 @@ int iwl_set_default_wep_key(struct iwl_priv *priv,
 EXPORT_SYMBOL(iwl_set_default_wep_key);
 
 static int iwl_set_wep_dynamic_key_info(struct iwl_priv *priv,
-				struct ieee80211_key_conf *keyconf,
-				u8 sta_id)
+					struct iwl_rxon_context *ctx,
+					struct ieee80211_key_conf *keyconf,
+					u8 sta_id)
 {
 	unsigned long flags;
 	__le16 key_flags = 0;
@@ -851,7 +851,7 @@ static int iwl_set_wep_dynamic_key_info(struct iwl_priv *priv,
 	if (keyconf->keylen == WEP_KEY_LEN_128)
 		key_flags |= STA_KEY_FLG_KEY_SIZE_MSK;
 
-	if (sta_id == priv->hw_params.bcast_sta_id)
+	if (sta_id == ctx->bcast_sta_id)
 		key_flags |= STA_KEY_MULTICAST_MSK;
 
 	spin_lock_irqsave(&priv->sta_lock, flags);
@@ -887,8 +887,9 @@ static int iwl_set_wep_dynamic_key_info(struct iwl_priv *priv,
 }
 
 static int iwl_set_ccmp_dynamic_key_info(struct iwl_priv *priv,
-				   struct ieee80211_key_conf *keyconf,
-				   u8 sta_id)
+					 struct iwl_rxon_context *ctx,
+					 struct ieee80211_key_conf *keyconf,
+					 u8 sta_id)
 {
 	unsigned long flags;
 	__le16 key_flags = 0;
@@ -900,7 +901,7 @@ static int iwl_set_ccmp_dynamic_key_info(struct iwl_priv *priv,
 	key_flags |= cpu_to_le16(keyconf->keyidx << STA_KEY_FLG_KEYID_POS);
 	key_flags &= ~STA_KEY_FLG_INVALID;
 
-	if (sta_id == priv->hw_params.bcast_sta_id)
+	if (sta_id == ctx->bcast_sta_id)
 		key_flags |= STA_KEY_MULTICAST_MSK;
 
 	keyconf->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
@@ -936,8 +937,9 @@ static int iwl_set_ccmp_dynamic_key_info(struct iwl_priv *priv,
 }
 
 static int iwl_set_tkip_dynamic_key_info(struct iwl_priv *priv,
-				   struct ieee80211_key_conf *keyconf,
-				   u8 sta_id)
+					 struct iwl_rxon_context *ctx,
+					 struct ieee80211_key_conf *keyconf,
+					 u8 sta_id)
 {
 	unsigned long flags;
 	int ret = 0;
@@ -947,7 +949,7 @@ static int iwl_set_tkip_dynamic_key_info(struct iwl_priv *priv,
 	key_flags |= cpu_to_le16(keyconf->keyidx << STA_KEY_FLG_KEYID_POS);
 	key_flags &= ~STA_KEY_FLG_INVALID;
 
-	if (sta_id == priv->hw_params.bcast_sta_id)
+	if (sta_id == ctx->bcast_sta_id)
 		key_flags |= STA_KEY_MULTICAST_MSK;
 
 	keyconf->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
@@ -982,8 +984,9 @@ static int iwl_set_tkip_dynamic_key_info(struct iwl_priv *priv,
 }
 
 void iwl_update_tkip_key(struct iwl_priv *priv,
-			struct ieee80211_key_conf *keyconf,
-			struct ieee80211_sta *sta, u32 iv32, u16 *phase1key)
+			 struct iwl_rxon_context *ctx,
+			 struct ieee80211_key_conf *keyconf,
+			 struct ieee80211_sta *sta, u32 iv32, u16 *phase1key)
 {
 	u8 sta_id;
 	unsigned long flags;
@@ -995,7 +998,7 @@ void iwl_update_tkip_key(struct iwl_priv *priv,
 		return;
 	}
 
-	sta_id = iwl_sta_id_or_broadcast(priv, sta);
+	sta_id = iwl_sta_id_or_broadcast(priv, ctx, sta);
 	if (sta_id == IWL_INVALID_STATION)
 		return;
 
@@ -1080,8 +1083,8 @@ int iwl_remove_dynamic_key(struct iwl_priv *priv,
 }
 EXPORT_SYMBOL(iwl_remove_dynamic_key);
 
-int iwl_set_dynamic_key(struct iwl_priv *priv,
-				struct ieee80211_key_conf *keyconf, u8 sta_id)
+int iwl_set_dynamic_key(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
+			struct ieee80211_key_conf *keyconf, u8 sta_id)
 {
 	int ret;
 
@@ -1092,14 +1095,14 @@ int iwl_set_dynamic_key(struct iwl_priv *priv,
 
 	switch (keyconf->cipher) {
 	case WLAN_CIPHER_SUITE_CCMP:
-		ret = iwl_set_ccmp_dynamic_key_info(priv, keyconf, sta_id);
+		ret = iwl_set_ccmp_dynamic_key_info(priv, ctx, keyconf, sta_id);
 		break;
 	case WLAN_CIPHER_SUITE_TKIP:
-		ret = iwl_set_tkip_dynamic_key_info(priv, keyconf, sta_id);
+		ret = iwl_set_tkip_dynamic_key_info(priv, ctx, keyconf, sta_id);
 		break;
 	case WLAN_CIPHER_SUITE_WEP40:
 	case WLAN_CIPHER_SUITE_WEP104:
-		ret = iwl_set_wep_dynamic_key_info(priv, keyconf, sta_id);
+		ret = iwl_set_wep_dynamic_key_info(priv, ctx, keyconf, sta_id);
 		break;
 	default:
 		IWL_ERR(priv,
@@ -1229,14 +1232,15 @@ EXPORT_SYMBOL(iwl_send_lq_cmd);
  * and marks it driver active, so that it will be restored to the
  * device at the next best time.
  */
-int iwl_alloc_bcast_station(struct iwl_priv *priv, bool init_lq)
+int iwl_alloc_bcast_station(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
+			    bool init_lq)
 {
 	struct iwl_link_quality_cmd *link_cmd;
 	unsigned long flags;
 	u8 sta_id;
 
 	spin_lock_irqsave(&priv->sta_lock, flags);
-	sta_id = iwl_prep_station(priv, iwl_bcast_addr, false, NULL);
+	sta_id = iwl_prep_station(priv, ctx, iwl_bcast_addr, false, NULL);
 	if (sta_id == IWL_INVALID_STATION) {
 		IWL_ERR(priv, "Unable to prepare broadcast station\n");
 		spin_unlock_irqrestore(&priv->sta_lock, flags);
@@ -1271,11 +1275,12 @@ EXPORT_SYMBOL_GPL(iwl_alloc_bcast_station);
  * Only used by iwlagn. Placed here to have all bcast station management
  * code together.
  */
-int iwl_update_bcast_station(struct iwl_priv *priv)
+static int iwl_update_bcast_station(struct iwl_priv *priv,
+				    struct iwl_rxon_context *ctx)
 {
 	unsigned long flags;
 	struct iwl_link_quality_cmd *link_cmd;
-	u8 sta_id = priv->hw_params.bcast_sta_id;
+	u8 sta_id = ctx->bcast_sta_id;
 
 	link_cmd = iwl_sta_alloc_lq(priv, sta_id);
 	if (!link_cmd) {
@@ -1293,9 +1298,23 @@ int iwl_update_bcast_station(struct iwl_priv *priv)
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(iwl_update_bcast_station);
 
-void iwl_dealloc_bcast_station(struct iwl_priv *priv)
+int iwl_update_bcast_stations(struct iwl_priv *priv)
+{
+	struct iwl_rxon_context *ctx;
+	int ret = 0;
+
+	for_each_context(priv, ctx) {
+		ret = iwl_update_bcast_station(priv, ctx);
+		if (ret)
+			break;
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(iwl_update_bcast_stations);
+
+void iwl_dealloc_bcast_stations(struct iwl_priv *priv)
 {
 	unsigned long flags;
 	int i;
@@ -1313,7 +1332,7 @@ void iwl_dealloc_bcast_station(struct iwl_priv *priv)
 	}
 	spin_unlock_irqrestore(&priv->sta_lock, flags);
 }
-EXPORT_SYMBOL_GPL(iwl_dealloc_bcast_station);
+EXPORT_SYMBOL_GPL(iwl_dealloc_bcast_stations);
 
 /**
  * iwl_sta_tx_modify_enable_tid - Enable Tx for this TID in station table
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.h b/drivers/net/wireless/iwlwifi/iwl-sta.h
index d38a350..8a978c6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.h
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.h
@@ -48,28 +48,29 @@ int iwl_remove_default_wep_key(struct iwl_priv *priv,
 int iwl_set_default_wep_key(struct iwl_priv *priv,
 			    struct ieee80211_key_conf *key);
 int iwl_restore_default_wep_keys(struct iwl_priv *priv);
-int iwl_set_dynamic_key(struct iwl_priv *priv,
+int iwl_set_dynamic_key(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
 			struct ieee80211_key_conf *key, u8 sta_id);
 int iwl_remove_dynamic_key(struct iwl_priv *priv,
 			   struct ieee80211_key_conf *key, u8 sta_id);
 void iwl_update_tkip_key(struct iwl_priv *priv,
-			struct ieee80211_key_conf *keyconf,
-			struct ieee80211_sta *sta, u32 iv32, u16 *phase1key);
+			 struct iwl_rxon_context *ctx,
+			 struct ieee80211_key_conf *keyconf,
+			 struct ieee80211_sta *sta, u32 iv32, u16 *phase1key);
 
 void iwl_restore_stations(struct iwl_priv *priv);
 void iwl_clear_ucode_stations(struct iwl_priv *priv);
-int iwl_alloc_bcast_station(struct iwl_priv *priv, bool init_lq);
-void iwl_dealloc_bcast_station(struct iwl_priv *priv);
-int iwl_update_bcast_station(struct iwl_priv *priv);
+int iwl_alloc_bcast_station(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
+			    bool init_lq);
+void iwl_dealloc_bcast_stations(struct iwl_priv *priv);
+int iwl_update_bcast_stations(struct iwl_priv *priv);
 int iwl_get_free_ucode_key_index(struct iwl_priv *priv);
 int iwl_send_add_sta(struct iwl_priv *priv,
 		     struct iwl_addsta_cmd *sta, u8 flags);
-int iwl_add_bssid_station(struct iwl_priv *priv, const u8 *addr, bool init_rs,
-			  u8 *sta_id_r);
-int iwl_add_station_common(struct iwl_priv *priv, const u8 *addr,
-				  bool is_ap,
-				  struct ieee80211_sta_ht_cap *ht_info,
-				  u8 *sta_id_r);
+int iwl_add_bssid_station(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
+			  const u8 *addr, bool init_rs, u8 *sta_id_r);
+int iwl_add_station_common(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
+			   const u8 *addr, bool is_ap,
+			   struct ieee80211_sta_ht_cap *ht_info, u8 *sta_id_r);
 int iwl_remove_station(struct iwl_priv *priv, const u8 sta_id,
 		       const u8 *addr);
 int iwl_mac_sta_remove(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
@@ -123,6 +124,7 @@ static inline int iwl_sta_id(struct ieee80211_sta *sta)
 /**
  * iwl_sta_id_or_broadcast - return sta_id or broadcast sta
  * @priv: iwl priv
+ * @context: the current context
  * @sta: mac80211 station
  *
  * In certain circumstances mac80211 passes a station pointer
@@ -131,12 +133,13 @@ static inline int iwl_sta_id(struct ieee80211_sta *sta)
  * inline wraps that pattern.
  */
 static inline int iwl_sta_id_or_broadcast(struct iwl_priv *priv,
+					  struct iwl_rxon_context *context,
 					  struct ieee80211_sta *sta)
 {
 	int sta_id;
 
 	if (!sta)
-		return priv->hw_params.bcast_sta_id;
+		return context->bcast_sta_id;
 
 	sta_id = iwl_sta_id(sta);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 02e0a9b..8b07632 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -144,7 +144,7 @@ static int iwl3945_set_ccmp_dynamic_key_info(struct iwl_priv *priv,
 	key_flags |= (STA_KEY_FLG_CCMP | STA_KEY_FLG_MAP_KEY_MSK);
 	key_flags |= cpu_to_le16(keyconf->keyidx << STA_KEY_FLG_KEYID_POS);
 
-	if (sta_id == priv->hw_params.bcast_sta_id)
+	if (sta_id == priv->contexts[IWL_RXON_CTX_BSS].bcast_sta_id)
 		key_flags |= STA_KEY_MULTICAST_MSK;
 
 	keyconf->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
@@ -512,7 +512,9 @@ static int iwl3945_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	hdr_len = ieee80211_hdrlen(fc);
 
 	/* Find index into station table for destination station */
-	sta_id = iwl_sta_id_or_broadcast(priv, info->control.sta);
+	sta_id = iwl_sta_id_or_broadcast(
+			priv, &priv->contexts[IWL_RXON_CTX_BSS],
+			info->control.sta);
 	if (sta_id == IWL_INVALID_STATION) {
 		IWL_DEBUG_DROP(priv, "Dropping - INVALID STATION: %pM\n",
 			       hdr->addr1);
@@ -2580,7 +2582,7 @@ static void __iwl3945_down(struct iwl_priv *priv)
 
 	/* Station information will now be cleared in device */
 	iwl_clear_ucode_stations(priv);
-	iwl_dealloc_bcast_station(priv);
+	iwl_dealloc_bcast_stations(priv);
 	iwl_clear_driver_stations(priv);
 
 	/* Unblock any waiting calls */
@@ -2662,7 +2664,8 @@ static int __iwl3945_up(struct iwl_priv *priv)
 {
 	int rc, i;
 
-	rc = iwl_alloc_bcast_station(priv, false);
+	rc = iwl_alloc_bcast_station(priv, &priv->contexts[IWL_RXON_CTX_BSS],
+				     false);
 	if (rc)
 		return rc;
 
@@ -2946,7 +2949,7 @@ void iwl3945_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 	/* We don't build a direct scan probe request; the uCode will do
 	 * that based on the direct_mask added to each channel entry */
 	scan->tx_cmd.tx_flags = TX_CMD_FLG_SEQ_CTL_MSK;
-	scan->tx_cmd.sta_id = priv->hw_params.bcast_sta_id;
+	scan->tx_cmd.sta_id = priv->contexts[IWL_RXON_CTX_BSS].bcast_sta_id;
 	scan->tx_cmd.stop_time.life_time = TX_CMD_LIFE_TIME_INFINITE;
 
 	/* flags + rate selection */
@@ -3330,7 +3333,8 @@ static int iwl3945_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	static_key = !iwl_is_associated(priv, IWL_RXON_CTX_BSS);
 
 	if (!static_key) {
-		sta_id = iwl_sta_id_or_broadcast(priv, sta);
+		sta_id = iwl_sta_id_or_broadcast(
+				priv, &priv->contexts[IWL_RXON_CTX_BSS], sta);
 		if (sta_id == IWL_INVALID_STATION)
 			return -EINVAL;
 	}
@@ -3381,8 +3385,8 @@ static int iwl3945_mac_sta_add(struct ieee80211_hw *hw,
 	sta_priv->common.sta_id = IWL_INVALID_STATION;
 
 
-	ret = iwl_add_station_common(priv, sta->addr, is_ap, &sta->ht_cap,
-				     &sta_id);
+	ret = iwl_add_station_common(priv, &priv->contexts[IWL_RXON_CTX_BSS],
+				     sta->addr, is_ap, &sta->ht_cap, &sta_id);
 	if (ret) {
 		IWL_ERR(priv, "Unable to add station %pM (%d)\n",
 			sta->addr, ret);
-- 
1.7.0.4

