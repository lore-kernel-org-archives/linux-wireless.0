Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:15110 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932098AbZJ3VgQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Oct 2009 17:36:16 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 09/15] iwlwifi: split adding broadcast station from others
Date: Fri, 30 Oct 2009 14:36:12 -0700
Message-Id: <1256938578-9638-10-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1256938578-9638-1-git-send-email-reinette.chatre@intel.com>
References: <1256938578-9638-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Reinette Chatre <reinette.chatre@intel.com>

In preparation for some station management changes we split the addition of
a broadcast station from the other stations. Later we will rely on mac80211
to direct all management (addition/removal) of all stations except the
broadcast station.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |    8 +---
 drivers/net/wireless/iwlwifi/iwl-sta.c |   62 ++++++++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-sta.h |    1 +
 3 files changed, 65 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 76355cd..e99b753 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -191,11 +191,7 @@ int iwl_commit_rxon(struct iwl_priv *priv)
 	priv->start_calib = 0;
 
 	/* Add the broadcast address so we can send broadcast frames */
-	if (iwl_rxon_add_station(priv, iwl_bcast_addr, 0) ==
-						IWL_INVALID_STATION) {
-		IWL_ERR(priv, "Error adding BROADCAST address for transmit.\n");
-		return -EIO;
-	}
+	iwl_add_bcast_station(priv);
 
 	/* If we have set the ASSOC_MSK and we are in BSS mode then
 	 * add the IWL_AP_ID to the station rate table */
@@ -2525,7 +2521,7 @@ void iwl_config_ap(struct iwl_priv *priv)
 		spin_lock_irqsave(&priv->lock, flags);
 		iwl_activate_qos(priv, 1);
 		spin_unlock_irqrestore(&priv->lock, flags);
-		iwl_rxon_add_station(priv, iwl_bcast_addr, 0);
+		iwl_add_bcast_station(priv);
 	}
 	iwl_send_beacon_cmd(priv);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index dc74c16..ce1ceac 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -1030,6 +1030,68 @@ int iwl_rxon_add_station(struct iwl_priv *priv, const u8 *addr, bool is_ap)
 EXPORT_SYMBOL(iwl_rxon_add_station);
 
 /**
+ * iwl_sta_init_bcast_lq - Initialize a bcast station's hardware rate table
+ *
+ * NOTE: Run REPLY_ADD_STA command to set up station table entry, before
+ *       calling this function (which runs REPLY_TX_LINK_QUALITY_CMD,
+ *       which requires station table entry to exist).
+ */
+static void iwl_sta_init_bcast_lq(struct iwl_priv *priv)
+{
+	int i, r;
+	struct iwl_link_quality_cmd link_cmd = {
+		.reserved1 = 0,
+	};
+	u32 rate_flags;
+
+	/* Set up the rate scaling to start at selected rate, fall back
+	 * all the way down to 1M in IEEE order, and then spin on 1M */
+	if (priv->band == IEEE80211_BAND_5GHZ)
+		r = IWL_RATE_6M_INDEX;
+	else
+		r = IWL_RATE_1M_INDEX;
+
+	for (i = 0; i < LINK_QUAL_MAX_RETRY_NUM; i++) {
+		rate_flags = 0;
+		if (r >= IWL_FIRST_CCK_RATE && r <= IWL_LAST_CCK_RATE)
+			rate_flags |= RATE_MCS_CCK_MSK;
+
+		rate_flags |= first_antenna(priv->hw_params.valid_tx_ant) <<
+				RATE_MCS_ANT_POS;
+
+		link_cmd.rs_table[i].rate_n_flags =
+			iwl_hw_set_rate_n_flags(iwl_rates[r].plcp, rate_flags);
+		r = iwl_get_prev_ieee_rate(r);
+	}
+
+	link_cmd.general_params.single_stream_ant_msk =
+				first_antenna(priv->hw_params.valid_tx_ant);
+	link_cmd.general_params.dual_stream_ant_msk = 3;
+	link_cmd.agg_params.agg_dis_start_th = LINK_QUAL_AGG_DISABLE_START_DEF;
+	link_cmd.agg_params.agg_time_limit =
+		cpu_to_le16(LINK_QUAL_AGG_TIME_LIMIT_DEF);
+
+	/* Update the rate scaling for control frame Tx to AP */
+	link_cmd.sta_id = priv->hw_params.bcast_sta_id;
+
+	iwl_send_cmd_pdu_async(priv, REPLY_TX_LINK_QUALITY_CMD,
+			       sizeof(link_cmd), &link_cmd, NULL);
+}
+
+
+/**
+ * iwl_add_bcast_station - add broadcast station into station table.
+ */
+void iwl_add_bcast_station(struct iwl_priv *priv)
+{
+	iwl_add_station(priv, iwl_bcast_addr, false, CMD_SYNC, NULL);
+
+	/* Set up default rate scaling table in device's station table */
+	iwl_sta_init_bcast_lq(priv);
+}
+EXPORT_SYMBOL(iwl_add_bcast_station);
+
+/**
  * iwl_get_sta_id - Find station's index within station table
  *
  * If new IBSS station, create new entry in station table
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.h b/drivers/net/wireless/iwlwifi/iwl-sta.h
index 6deebad..1c382de 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.h
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.h
@@ -52,6 +52,7 @@ void iwl_update_tkip_key(struct iwl_priv *priv,
 			const u8 *addr, u32 iv32, u16 *phase1key);
 
 int iwl_rxon_add_station(struct iwl_priv *priv, const u8 *addr, bool is_ap);
+void iwl_add_bcast_station(struct iwl_priv *priv);
 int iwl_remove_station(struct iwl_priv *priv, const u8 *addr, bool is_ap);
 void iwl_clear_stations_table(struct iwl_priv *priv);
 int iwl_get_free_ucode_key_index(struct iwl_priv *priv);
-- 
1.5.6.3

