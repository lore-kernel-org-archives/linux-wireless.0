Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:49208 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756777Ab0EJW23 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 May 2010 18:28:29 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 13/47] iwlwifi: make bcast LQ command available for later restore actions
Date: Mon, 10 May 2010 15:27:44 -0700
Message-Id: <1273530498-11876-14-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1273530498-11876-1-git-send-email-reinette.chatre@intel.com>
References: <1273530498-11876-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Reinette Chatre <reinette.chatre@intel.com>

When adding the broadcast station the link quality command is
generated on demand, sent to device, and disappears. It is thus not
available for later cases when we need to restore stations and need
to send the link quality command afterwards. Now, when first adding the
broadcast station, also generate its link quality command to always be
available for later restoring.

Also fix an issue when adding local stations where the "in progress" state
is never cleared.

Reported-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c |    4 +-
 drivers/net/wireless/iwlwifi/iwl-core.h |    2 +-
 drivers/net/wireless/iwlwifi/iwl-sta.c  |   91 ++++++++++++++++++++++---------
 drivers/net/wireless/iwlwifi/iwl-sta.h  |    7 ++-
 4 files changed, 75 insertions(+), 29 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index d609414..e8c9bca 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -2042,7 +2042,9 @@ int iwl_mac_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 		goto out_err;
 
 	/* Add the broadcast address so we can send broadcast frames */
-	priv->cfg->ops->lib->add_bcast_station(priv);
+	err = priv->cfg->ops->lib->add_bcast_station(priv);
+	if (err)
+		goto out_err;
 
 	goto out;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index f66c1c1..8d53fc9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -201,7 +201,7 @@ struct iwl_lib_ops {
 	/* temperature */
 	struct iwl_temp_ops temp_ops;
 	/* station management */
-	void (*add_bcast_station)(struct iwl_priv *priv);
+	int (*add_bcast_station)(struct iwl_priv *priv);
 	/* recover from tx queue stall */
 	void (*recover_from_tx_stall)(unsigned long data);
 	/* check for plcp health */
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index db93447..5c6b326 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -418,15 +418,19 @@ int iwl_add_station_common(struct iwl_priv *priv, const u8 *addr,
 }
 EXPORT_SYMBOL(iwl_add_station_common);
 
-static void iwl_sta_init_lq(struct iwl_priv *priv, const u8 *addr, bool is_ap)
+static struct iwl_link_quality_cmd *iwl_sta_init_lq(struct iwl_priv *priv,
+						    const u8 *addr, bool is_ap)
 {
 	int i, r;
-	struct iwl_link_quality_cmd link_cmd = {
-		.reserved1 = 0,
-	};
+	struct iwl_link_quality_cmd *link_cmd;
 	u32 rate_flags;
 	int ret = 0;
 
+	link_cmd = kzalloc(sizeof(struct iwl_link_quality_cmd), GFP_KERNEL);
+	if (!link_cmd) {
+		IWL_ERR(priv, "Unable to allocate memory for LQ cmd.\n");
+		return NULL;
+	}
 	/* Set up the rate scaling to start at selected rate, fall back
 	 * all the way down to 1M in IEEE order, and then spin on 1M */
 	if (is_ap)
@@ -444,35 +448,36 @@ static void iwl_sta_init_lq(struct iwl_priv *priv, const u8 *addr, bool is_ap)
 		rate_flags |= first_antenna(priv->hw_params.valid_tx_ant) <<
 				RATE_MCS_ANT_POS;
 
-		link_cmd.rs_table[i].rate_n_flags =
+		link_cmd->rs_table[i].rate_n_flags =
 			iwl_hw_set_rate_n_flags(iwl_rates[r].plcp, rate_flags);
 		r = iwl_get_prev_ieee_rate(r);
 	}
 
-	link_cmd.general_params.single_stream_ant_msk =
+	link_cmd->general_params.single_stream_ant_msk =
 				first_antenna(priv->hw_params.valid_tx_ant);
 
-	link_cmd.general_params.dual_stream_ant_msk =
+	link_cmd->general_params.dual_stream_ant_msk =
 		priv->hw_params.valid_tx_ant &
 		~first_antenna(priv->hw_params.valid_tx_ant);
-	if (!link_cmd.general_params.dual_stream_ant_msk) {
-		link_cmd.general_params.dual_stream_ant_msk = ANT_AB;
+	if (!link_cmd->general_params.dual_stream_ant_msk) {
+		link_cmd->general_params.dual_stream_ant_msk = ANT_AB;
 	} else if (num_of_ant(priv->hw_params.valid_tx_ant) == 2) {
-		link_cmd.general_params.dual_stream_ant_msk =
+		link_cmd->general_params.dual_stream_ant_msk =
 			priv->hw_params.valid_tx_ant;
 	}
 
-	link_cmd.agg_params.agg_dis_start_th = LINK_QUAL_AGG_DISABLE_START_DEF;
-	link_cmd.agg_params.agg_time_limit =
+	link_cmd->agg_params.agg_dis_start_th = LINK_QUAL_AGG_DISABLE_START_DEF;
+	link_cmd->agg_params.agg_time_limit =
 		cpu_to_le16(LINK_QUAL_AGG_TIME_LIMIT_DEF);
 
 	/* Update the rate scaling for control frame Tx to AP */
-	link_cmd.sta_id = is_ap ? IWL_AP_ID : priv->hw_params.bcast_sta_id;
+	link_cmd->sta_id = is_ap ? IWL_AP_ID : priv->hw_params.bcast_sta_id;
 
-	ret = iwl_send_cmd_pdu(priv, REPLY_TX_LINK_QUALITY_CMD,
-			       sizeof(link_cmd), &link_cmd);
+	ret = iwl_send_lq_cmd(priv, link_cmd, CMD_SYNC, true);
 	if (ret)
-		IWL_ERR(priv, "REPLY_TX_LINK_QUALITY_CMD failed (%d)\n", ret);
+		IWL_ERR(priv, "Link quality command failed (%d)\n", ret);
+
+	return link_cmd;
 }
 
 /*
@@ -487,6 +492,8 @@ int iwl_add_local_station(struct iwl_priv *priv, const u8 *addr, bool init_rs)
 {
 	int ret;
 	u8 sta_id;
+	struct iwl_link_quality_cmd *link_cmd;
+	unsigned long flags;
 
 	ret = iwl_add_station_common(priv, addr, 0, NULL, &sta_id);
 	if (ret) {
@@ -494,9 +501,23 @@ int iwl_add_local_station(struct iwl_priv *priv, const u8 *addr, bool init_rs)
 		return ret;
 	}
 
-	if (init_rs)
+	spin_lock_irqsave(&priv->sta_lock, flags);
+	priv->stations[sta_id].used |= IWL_STA_LOCAL;
+	spin_unlock_irqrestore(&priv->sta_lock, flags);
+
+	if (init_rs) {
 		/* Set up default rate scaling table in device's station table */
-		iwl_sta_init_lq(priv, addr, false);
+		link_cmd = iwl_sta_init_lq(priv, addr, false);
+		if (!link_cmd) {
+			IWL_ERR(priv, "Unable to initialize rate scaling for station %pM.\n",
+				addr);
+			return -ENOMEM;
+		}
+		spin_lock_irqsave(&priv->sta_lock, flags);
+		priv->stations[sta_id].lq = link_cmd;
+		spin_unlock_irqrestore(&priv->sta_lock, flags);
+	}
+
 	return 0;
 }
 EXPORT_SYMBOL(iwl_add_local_station);
@@ -509,7 +530,8 @@ EXPORT_SYMBOL(iwl_add_local_station);
 static void iwl_sta_ucode_deactivate(struct iwl_priv *priv, u8 sta_id)
 {
 	/* Ucode must be active and driver must be non active */
-	if (priv->stations[sta_id].used != IWL_STA_UCODE_ACTIVE)
+	if ((priv->stations[sta_id].used &
+	     (IWL_STA_UCODE_ACTIVE | IWL_STA_DRIVER_ACTIVE)) != IWL_STA_UCODE_ACTIVE)
 		IWL_ERR(priv, "removed non active STA %u\n", sta_id);
 
 	priv->stations[sta_id].used &= ~IWL_STA_UCODE_ACTIVE;
@@ -676,8 +698,23 @@ void iwl_clear_ucode_stations(struct iwl_priv *priv, bool force)
 	spin_lock_irqsave(&priv->sta_lock, flags_spin);
 	if (force) {
 		IWL_DEBUG_INFO(priv, "Clearing all station information in driver\n");
+		/*
+		 * The station entry contains a link to the LQ command. For
+		 * all stations managed by mac80211 this memory will be
+		 * managed by it also. For local stations (broadcast and
+		 * bssid station when in adhoc mode) we need to maintain
+		 * this lq command separately. This memory is created when
+		 * these stations are added.
+		 */
+		for (i = 0; i < priv->hw_params.max_stations; i++) {
+			if (priv->stations[i].used & IWL_STA_LOCAL) {
+				kfree(priv->stations[i].lq);
+				priv->stations[i].lq = NULL;
+			}
+		}
 		priv->num_stations = 0;
 		memset(priv->stations, 0, sizeof(priv->stations));
+		cleared = true;
 	} else {
 		for (i = 0; i < priv->hw_params.max_stations; i++) {
 			if (priv->stations[i].used & IWL_STA_UCODE_ACTIVE) {
@@ -1207,7 +1244,8 @@ int iwl_send_lq_cmd(struct iwl_priv *priv,
 	BUG_ON(init && (cmd.flags & CMD_ASYNC));
 
 	ret = iwl_send_cmd(priv, &cmd);
-	if (ret || (cmd.flags & CMD_ASYNC))
+
+	if (cmd.flags & CMD_ASYNC)
 		return ret;
 
 	if (init) {
@@ -1217,33 +1255,36 @@ int iwl_send_lq_cmd(struct iwl_priv *priv,
 		priv->stations[lq->sta_id].used &= ~IWL_STA_UCODE_INPROGRESS;
 		spin_unlock_irqrestore(&priv->sta_lock, flags_spin);
 	}
-	return 0;
+	return ret;
 }
 EXPORT_SYMBOL(iwl_send_lq_cmd);
 
 /**
  * iwl_add_bcast_station - add broadcast station into station table.
  */
-void iwl_add_bcast_station(struct iwl_priv *priv)
+int iwl_add_bcast_station(struct iwl_priv *priv)
 {
 	IWL_DEBUG_INFO(priv, "Adding broadcast station to station table\n");
-	iwl_add_local_station(priv, iwl_bcast_addr, true);
+	return iwl_add_local_station(priv, iwl_bcast_addr, true);
 }
 EXPORT_SYMBOL(iwl_add_bcast_station);
 
 /**
  * iwl3945_add_bcast_station - add broadcast station into station table.
  */
-void iwl3945_add_bcast_station(struct iwl_priv *priv)
+int iwl3945_add_bcast_station(struct iwl_priv *priv)
 {
+	int ret;
+
 	IWL_DEBUG_INFO(priv, "Adding broadcast station to station table\n");
-	iwl_add_local_station(priv, iwl_bcast_addr, false);
+	ret = iwl_add_local_station(priv, iwl_bcast_addr, false);
 	/*
 	 * It is assumed that when station is added more initialization
 	 * needs to be done, but for 3945 it is not the case and we can
 	 * just release station table access right here.
 	 */
 	priv->stations[priv->hw_params.bcast_sta_id].used &= ~IWL_STA_UCODE_INPROGRESS;
+	return ret;
 
 }
 EXPORT_SYMBOL(iwl3945_add_bcast_station);
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.h b/drivers/net/wireless/iwlwifi/iwl-sta.h
index 42cd2f4..b0ed2eb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.h
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.h
@@ -36,6 +36,9 @@
 #define IWL_STA_UCODE_ACTIVE  BIT(1) /* ucode entry is active */
 #define IWL_STA_UCODE_INPROGRESS  BIT(2) /* ucode entry is in process of
 					    being activated */
+#define IWL_STA_LOCAL BIT(3) /* station state not directed by mac80211
+			     this is for bcast and bssid (when adhoc)
+			     stations */
 
 
 /**
@@ -57,8 +60,8 @@ void iwl_update_tkip_key(struct iwl_priv *priv,
 			struct ieee80211_key_conf *keyconf,
 			const u8 *addr, u32 iv32, u16 *phase1key);
 
-void iwl_add_bcast_station(struct iwl_priv *priv);
-void iwl3945_add_bcast_station(struct iwl_priv *priv);
+int iwl_add_bcast_station(struct iwl_priv *priv);
+int iwl3945_add_bcast_station(struct iwl_priv *priv);
 void iwl_restore_stations(struct iwl_priv *priv);
 void iwl_clear_ucode_stations(struct iwl_priv *priv, bool force);
 int iwl_get_free_ucode_key_index(struct iwl_priv *priv);
-- 
1.6.3.3

