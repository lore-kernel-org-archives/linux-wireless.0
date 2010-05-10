Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:48051 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756339Ab0EJW2Z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 May 2010 18:28:25 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 16/47] iwlwifi: manage IBSS station properly
Date: Mon, 10 May 2010 15:27:47 -0700
Message-Id: <1273530498-11876-17-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1273530498-11876-1-git-send-email-reinette.chatre@intel.com>
References: <1273530498-11876-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Currently iwlwifi will eventually exhaust the station
table when adding the BSSID station for IBSS mode,
unless the interface is set down.

The new mac80211 ibss joined/left notification allows
us to fix that easily by moving the code to add the
IBSS station to the notification, and also adding
code to remove it again when we leave the IBSS.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c     |    1 +
 drivers/net/wireless/iwlwifi/iwl-3945.c     |   30 ++++++++++++++++++++++++++-
 drivers/net/wireless/iwlwifi/iwl-3945.h     |    9 --------
 drivers/net/wireless/iwlwifi/iwl-4965.c     |    1 +
 drivers/net/wireless/iwlwifi/iwl-5000.c     |    2 +
 drivers/net/wireless/iwlwifi/iwl-6000.c     |    2 +
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c  |    9 ++++++++
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    6 -----
 drivers/net/wireless/iwlwifi/iwl-agn.h      |    4 +++
 drivers/net/wireless/iwlwifi/iwl-core.c     |    9 ++++++++
 drivers/net/wireless/iwlwifi/iwl-core.h     |    2 +
 drivers/net/wireless/iwlwifi/iwl-sta.c      |    7 +++++-
 drivers/net/wireless/iwlwifi/iwl-sta.h      |    1 +
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   11 ---------
 14 files changed, 66 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index 4d360d7..ebaf02d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -213,6 +213,7 @@ static struct iwl_lib_ops iwl1000_lib = {
 		.set_ct_kill = iwl1000_set_ct_threshold,
 	 },
 	.add_bcast_station = iwl_add_bcast_station,
+	.manage_ibss_station = iwlagn_manage_ibss_station,
 	.debugfs_ops = {
 		.rx_stats_read = iwl_ucode_rx_stats_read,
 		.tx_stats_read = iwl_ucode_tx_stats_read,
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 3607813..1e95939 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -884,7 +884,8 @@ void iwl3945_hw_build_tx_cmd_rate(struct iwl_priv *priv,
 		       tx_cmd->supp_rates[1], tx_cmd->supp_rates[0]);
 }
 
-u8 iwl3945_sync_sta(struct iwl_priv *priv, int sta_id, u16 tx_rate, u8 flags)
+static u8 iwl3945_sync_sta(struct iwl_priv *priv, int sta_id,
+			   u16 tx_rate, u8 flags)
 {
 	unsigned long flags_spin;
 	struct iwl_station_entry *station;
@@ -2395,6 +2396,32 @@ static u16 iwl3945_build_addsta_hcmd(const struct iwl_addsta_cmd *cmd, u8 *data)
 	return (u16)sizeof(struct iwl3945_addsta_cmd);
 }
 
+static int iwl3945_manage_ibss_station(struct iwl_priv *priv,
+				       struct ieee80211_vif *vif, bool add)
+{
+	int ret;
+
+	/*
+	 * NB: this assumes that the station it gets will be
+	 *     IWL_STA_ID, which will happen but isn't obvious.
+	 */
+
+	if (add) {
+		ret = iwl_add_local_station(priv, vif->bss_conf.bssid, false);
+		if (ret)
+			return ret;
+
+		iwl3945_sync_sta(priv, IWL_STA_ID,
+				 (priv->band == IEEE80211_BAND_5GHZ) ?
+				 IWL_RATE_6M_PLCP : IWL_RATE_1M_PLCP,
+				 CMD_ASYNC);
+		iwl3945_rate_scale_init(priv->hw, IWL_STA_ID);
+
+		return 0;
+	}
+
+	return iwl_remove_station(priv, vif->bss_conf.bssid);
+}
 
 /**
  * iwl3945_init_hw_rate_table - Initialize the hardware rate fallback table
@@ -2802,6 +2829,7 @@ static struct iwl_lib_ops iwl3945_lib = {
 	.post_associate = iwl3945_post_associate,
 	.isr = iwl_isr_legacy,
 	.config_ap = iwl3945_config_ap,
+	.manage_ibss_station = iwl3945_manage_ibss_station,
 	.add_bcast_station = iwl3945_add_bcast_station,
 
 	.debugfs_ops = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index 643adb6..cea824c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -211,13 +211,6 @@ extern int iwl3945_dump_nic_event_log(struct iwl_priv *priv, bool full_log,
 				       char **buf, bool display);
 extern void iwl3945_dump_nic_error_log(struct iwl_priv *priv);
 
-/*
- * Currently used by iwl-3945-rs... look at restructuring so that it doesn't
- * call this... todo... fix that.
-*/
-extern u8 iwl3945_sync_station(struct iwl_priv *priv, int sta_id,
-			   u16 tx_rate, u8 flags);
-
 /******************************************************************************
  *
  * Functions implemented in iwl-[34]*.c which are forward declared here
@@ -288,8 +281,6 @@ extern __le32 iwl3945_get_antenna_flags(const struct iwl_priv *priv);
 extern int iwl3945_init_hw_rate_table(struct iwl_priv *priv);
 extern void iwl3945_reg_txpower_periodic(struct iwl_priv *priv);
 extern int iwl3945_txpower_set_from_eeprom(struct iwl_priv *priv);
-extern u8 iwl3945_sync_sta(struct iwl_priv *priv, int sta_id,
-		 u16 tx_rate, u8 flags);
 
 extern const struct iwl_channel_info *iwl3945_get_channel_info(
 	const struct iwl_priv *priv, enum ieee80211_band band, u16 channel);
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 6b0ae74..5904a1b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -2219,6 +2219,7 @@ static struct iwl_lib_ops iwl4965_lib = {
 		.set_ct_kill = iwl4965_set_ct_threshold,
 	},
 	.add_bcast_station = iwl_add_bcast_station,
+	.manage_ibss_station = iwlagn_manage_ibss_station,
 	.debugfs_ops = {
 		.rx_stats_read = iwl_ucode_rx_stats_read,
 		.tx_stats_read = iwl_ucode_tx_stats_read,
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 8ed616e..bde0f18 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -352,6 +352,7 @@ static struct iwl_lib_ops iwl5000_lib = {
 		.set_ct_kill = iwl5000_set_ct_threshold,
 	 },
 	.add_bcast_station = iwl_add_bcast_station,
+	.manage_ibss_station = iwlagn_manage_ibss_station,
 	.debugfs_ops = {
 		.rx_stats_read = iwl_ucode_rx_stats_read,
 		.tx_stats_read = iwl_ucode_tx_stats_read,
@@ -414,6 +415,7 @@ static struct iwl_lib_ops iwl5150_lib = {
 		.set_ct_kill = iwl5150_set_ct_threshold,
 	 },
 	.add_bcast_station = iwl_add_bcast_station,
+	.manage_ibss_station = iwlagn_manage_ibss_station,
 	.debugfs_ops = {
 		.rx_stats_read = iwl_ucode_rx_stats_read,
 		.tx_stats_read = iwl_ucode_tx_stats_read,
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index b69fa36..5f0f586 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -318,6 +318,7 @@ static struct iwl_lib_ops iwl6000_lib = {
 		.set_ct_kill = iwl6000_set_ct_threshold,
 	 },
 	.add_bcast_station = iwl_add_bcast_station,
+	.manage_ibss_station = iwlagn_manage_ibss_station,
 	.debugfs_ops = {
 		.rx_stats_read = iwl_ucode_rx_stats_read,
 		.tx_stats_read = iwl_ucode_tx_stats_read,
@@ -391,6 +392,7 @@ static struct iwl_lib_ops iwl6050_lib = {
 		.set_calib_version = iwl6050_set_calib_version,
 	 },
 	.add_bcast_station = iwl_add_bcast_station,
+	.manage_ibss_station = iwlagn_manage_ibss_station,
 	.debugfs_ops = {
 		.rx_stats_read = iwl_ucode_rx_stats_read,
 		.tx_stats_read = iwl_ucode_tx_stats_read,
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index a273474..50ff313 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -38,6 +38,7 @@
 #include "iwl-helpers.h"
 #include "iwl-agn-hw.h"
 #include "iwl-agn.h"
+#include "iwl-sta.h"
 
 static inline u32 iwlagn_get_scd_ssn(struct iwl5000_tx_resp *tx_resp)
 {
@@ -1513,3 +1514,11 @@ void iwlagn_request_scan(struct iwl_priv *priv)
 	/* inform mac80211 scan aborted */
 	queue_work(priv->workqueue, &priv->scan_completed);
 }
+
+int iwlagn_manage_ibss_station(struct iwl_priv *priv,
+			       struct ieee80211_vif *vif, bool add)
+{
+	if (add)
+		return iwl_add_local_station(priv, vif->bss_conf.bssid, true);
+	return iwl_remove_station(priv, vif->bss_conf.bssid);
+}
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 5cf3822..dd1324d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2606,17 +2606,11 @@ void iwl_post_associate(struct iwl_priv *priv)
 	switch (priv->iw_mode) {
 	case NL80211_IFTYPE_STATION:
 		break;
-
 	case NL80211_IFTYPE_ADHOC:
-
 		/* assume default assoc id */
 		priv->assoc_id = 1;
-
-		iwl_add_local_station(priv, priv->bssid, true);
 		iwl_send_beacon_cmd(priv);
-
 		break;
-
 	default:
 		IWL_ERR(priv, "%s Should not be called in %d mode\n",
 			  __func__, priv->iw_mode);
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index cfee999..a9ba9fc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -174,4 +174,8 @@ static inline bool iwl_is_tx_success(u32 status)
 /* scan */
 void iwlagn_request_scan(struct iwl_priv *priv);
 
+/* station mgmt */
+int iwlagn_manage_ibss_station(struct iwl_priv *priv,
+			       struct ieee80211_vif *vif, bool add);
+
 #endif /* __iwl_agn_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index e8c9bca..5c6f254 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1960,6 +1960,15 @@ void iwl_bss_info_changed(struct ieee80211_hw *hw,
 			iwl_set_no_assoc(priv);
 	}
 
+	if (changes & BSS_CHANGED_IBSS) {
+		ret = priv->cfg->ops->lib->manage_ibss_station(priv, vif,
+							bss_conf->ibss_joined);
+		if (ret)
+			IWL_ERR(priv, "failed to %s IBSS station %pM\n",
+				bss_conf->ibss_joined ? "add" : "remove",
+				bss_conf->bssid);
+	}
+
 	mutex_unlock(&priv->mutex);
 
 	IWL_DEBUG_MAC80211(priv, "leave\n");
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 8d53fc9..0fa9965 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -202,6 +202,8 @@ struct iwl_lib_ops {
 	struct iwl_temp_ops temp_ops;
 	/* station management */
 	int (*add_bcast_station)(struct iwl_priv *priv);
+	int (*manage_ibss_station)(struct iwl_priv *priv,
+				   struct ieee80211_vif *vif, bool add);
 	/* recover from tx queue stall */
 	void (*recover_from_tx_stall)(unsigned long data);
 	/* check for plcp health */
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index 354eb13..7da8ede 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -596,7 +596,7 @@ static int iwl_send_remove_station(struct iwl_priv *priv,
 /**
  * iwl_remove_station - Remove driver's knowledge of station.
  */
-static int iwl_remove_station(struct iwl_priv *priv, const u8 *addr)
+int iwl_remove_station(struct iwl_priv *priv, const u8 *addr)
 {
 	int sta_id = IWL_INVALID_STATION;
 	int i, ret = -EINVAL;
@@ -647,6 +647,10 @@ static int iwl_remove_station(struct iwl_priv *priv, const u8 *addr)
 		goto out;
 	}
 
+	if (priv->stations[sta_id].used & IWL_STA_LOCAL) {
+		kfree(priv->stations[sta_id].lq);
+		priv->stations[sta_id].lq = NULL;
+	}
 
 	priv->stations[sta_id].used &= ~IWL_STA_DRIVER_ACTIVE;
 
@@ -663,6 +667,7 @@ out:
 	spin_unlock_irqrestore(&priv->sta_lock, flags);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(iwl_remove_station);
 
 /**
  * iwl_clear_ucode_stations() - clear entire station table driver and/or ucode
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.h b/drivers/net/wireless/iwlwifi/iwl-sta.h
index b0ed2eb..9a869f1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.h
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.h
@@ -74,6 +74,7 @@ int iwl_add_station_common(struct iwl_priv *priv, const u8 *addr,
 				  bool is_ap,
 				  struct ieee80211_sta_ht_cap *ht_info,
 				  u8 *sta_id_r);
+int iwl_remove_station(struct iwl_priv *priv, const u8 *addr);
 int iwl_mac_sta_remove(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		       struct ieee80211_sta *sta);
 void iwl_sta_tx_modify_enable_tid(struct iwl_priv *priv, int sta_id, int tid);
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 4f20cca..9486b32 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -3103,21 +3103,10 @@ void iwl3945_post_associate(struct iwl_priv *priv)
 	case NL80211_IFTYPE_STATION:
 		iwl3945_rate_scale_init(priv->hw, IWL_AP_ID);
 		break;
-
 	case NL80211_IFTYPE_ADHOC:
-
 		priv->assoc_id = 1;
-		iwl_add_local_station(priv, priv->bssid, false);
-		iwl3945_sync_sta(priv, IWL_STA_ID,
-				(priv->band == IEEE80211_BAND_5GHZ) ?
-				IWL_RATE_6M_PLCP : IWL_RATE_1M_PLCP,
-				 CMD_ASYNC);
-		iwl3945_rate_scale_init(priv->hw, IWL_STA_ID);
-
 		iwl3945_send_beacon_cmd(priv);
-
 		break;
-
 	default:
 		 IWL_ERR(priv, "%s Should not be called in %d mode\n",
 			   __func__, priv->iw_mode);
-- 
1.6.3.3

