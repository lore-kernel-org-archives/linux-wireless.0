Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:26340 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752163AbZFCShQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jun 2009 14:37:16 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Tomas Winkler <tomas.winkler@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 1/6] iwlwifi: unify station management
Date: Wed,  3 Jun 2009 11:44:07 -0700
Message-Id: <1244054652-19451-2-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1244054652-19451-1-git-send-email-reinette.chatre@intel.com>
References: <1244054652-19451-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch unifies 3945 and AGN station management
It also removes useless struct iwl_station_mgmt ops
and cleanups a bit the interface

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Tested-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945-rs.c  |    9 +-
 drivers/net/wireless/iwlwifi/iwl-3945.c     |   73 +++-------
 drivers/net/wireless/iwlwifi/iwl-3945.h     |    6 -
 drivers/net/wireless/iwlwifi/iwl-4965.c     |    8 -
 drivers/net/wireless/iwlwifi/iwl-5000.c     |   16 +--
 drivers/net/wireless/iwlwifi/iwl-6000.c     |    1 -
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c   |   15 +--
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   12 +-
 drivers/net/wireless/iwlwifi/iwl-commands.h |    2 +-
 drivers/net/wireless/iwlwifi/iwl-core.c     |    4 +-
 drivers/net/wireless/iwlwifi/iwl-core.h     |   10 --
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    9 +-
 drivers/net/wireless/iwlwifi/iwl-sta.c      |   51 ++++---
 drivers/net/wireless/iwlwifi/iwl-sta.h      |    7 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |  196 ++++-----------------------
 15 files changed, 109 insertions(+), 310 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-rs.c b/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
index 814afaf..5eb538d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
@@ -38,6 +38,7 @@
 
 #include "iwl-commands.h"
 #include "iwl-3945.h"
+#include "iwl-sta.h"
 
 #define RS_NAME "iwl-3945-rs"
 
@@ -714,13 +715,13 @@ static void rs_get_rate(void *priv_r, struct ieee80211_sta *sta,
 
 	if ((priv->iw_mode == NL80211_IFTYPE_ADHOC) &&
 	    !rs_sta->ibss_sta_added) {
-		u8 sta_id = iwl3945_hw_find_station(priv, hdr->addr1);
+		u8 sta_id = iwl_find_station(priv, hdr->addr1);
 
 		if (sta_id == IWL_INVALID_STATION) {
 			IWL_DEBUG_RATE(priv, "LQ: ADD station %pm\n",
 				       hdr->addr1);
-			sta_id = iwl3945_add_station(priv,
-				    hdr->addr1, 0, CMD_ASYNC, NULL);
+			sta_id = iwl_add_station(priv, hdr->addr1, false,
+				CMD_ASYNC, NULL);
 		}
 		if (sta_id != IWL_INVALID_STATION)
 			rs_sta->ibss_sta_added = 1;
@@ -975,7 +976,7 @@ void iwl3945_rate_scale_init(struct ieee80211_hw *hw, s32 sta_id)
 
 	rcu_read_lock();
 
-	sta = ieee80211_find_sta(hw, priv->stations_39[sta_id].sta.sta.addr);
+	sta = ieee80211_find_sta(hw, priv->stations[sta_id].sta.sta.addr);
 	if (!sta) {
 		rcu_read_unlock();
 		return;
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index fd65e1c..46288e7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -769,35 +769,6 @@ void iwl3945_hw_txq_free_tfd(struct iwl_priv *priv, struct iwl_tx_queue *txq)
 	return ;
 }
 
-u8 iwl3945_hw_find_station(struct iwl_priv *priv, const u8 *addr)
-{
-	int i, start = IWL_AP_ID;
-	int ret = IWL_INVALID_STATION;
-	unsigned long flags;
-
-	if ((priv->iw_mode == NL80211_IFTYPE_ADHOC) ||
-	    (priv->iw_mode == NL80211_IFTYPE_AP))
-		start = IWL_STA_ID;
-
-	if (is_broadcast_ether_addr(addr))
-		return priv->hw_params.bcast_sta_id;
-
-	spin_lock_irqsave(&priv->sta_lock, flags);
-	for (i = start; i < priv->hw_params.max_stations; i++)
-		if ((priv->stations_39[i].used) &&
-		    (!compare_ether_addr
-		     (priv->stations_39[i].sta.sta.addr, addr))) {
-			ret = i;
-			goto out;
-		}
-
-	IWL_DEBUG_INFO(priv, "can not find STA %pM (total %d)\n",
-		       addr, priv->num_stations);
- out:
-	spin_unlock_irqrestore(&priv->sta_lock, flags);
-	return ret;
-}
-
 /**
  * iwl3945_hw_build_tx_cmd_rate - Add rate portion to TX_CMD:
  *
@@ -875,13 +846,13 @@ void iwl3945_hw_build_tx_cmd_rate(struct iwl_priv *priv, struct iwl_cmd *cmd,
 u8 iwl3945_sync_sta(struct iwl_priv *priv, int sta_id, u16 tx_rate, u8 flags)
 {
 	unsigned long flags_spin;
-	struct iwl3945_station_entry *station;
+	struct iwl_station_entry *station;
 
 	if (sta_id == IWL_INVALID_STATION)
 		return IWL_INVALID_STATION;
 
 	spin_lock_irqsave(&priv->sta_lock, flags_spin);
-	station = &priv->stations_39[sta_id];
+	station = &priv->stations[sta_id];
 
 	station->sta.sta.modify_mask = STA_MODIFY_TX_RATE_MSK;
 	station->sta.rate_n_flags = cpu_to_le16(tx_rate);
@@ -889,8 +860,7 @@ u8 iwl3945_sync_sta(struct iwl_priv *priv, int sta_id, u16 tx_rate, u8 flags)
 
 	spin_unlock_irqrestore(&priv->sta_lock, flags_spin);
 
-	iwl_send_add_sta(priv,
-			 (struct iwl_addsta_cmd *)&station->sta, flags);
+	iwl_send_add_sta(priv, &station->sta, flags);
 	IWL_DEBUG_RATE(priv, "SCALE sync station %d to rate %d\n",
 			sta_id, tx_rate);
 	return sta_id;
@@ -2029,7 +1999,7 @@ static int iwl3945_commit_rxon(struct iwl_priv *priv)
 
 	memcpy(active_rxon, staging_rxon, sizeof(*active_rxon));
 
-	priv->cfg->ops->smgmt->clear_station_table(priv);
+	iwl_clear_stations_table(priv);
 
 	/* If we issue a new RXON command which required a tune then we must
 	 * send a new TXPOWER command or we won't be able to Tx any frames */
@@ -2040,7 +2010,7 @@ static int iwl3945_commit_rxon(struct iwl_priv *priv)
 	}
 
 	/* Add the broadcast address so we can send broadcast frames */
-	if (priv->cfg->ops->smgmt->add_station(priv, iwl_bcast_addr, 0, 0, NULL) ==
+	if (iwl_add_station(priv, iwl_bcast_addr, false, CMD_SYNC, NULL) ==
 	    IWL_INVALID_STATION) {
 		IWL_ERR(priv, "Error adding BROADCAST address for transmit.\n");
 		return -EIO;
@@ -2050,9 +2020,8 @@ static int iwl3945_commit_rxon(struct iwl_priv *priv)
 	 * add the IWL_AP_ID to the station rate table */
 	if (iwl_is_associated(priv) &&
 	    (priv->iw_mode == NL80211_IFTYPE_STATION))
-		if (priv->cfg->ops->smgmt->add_station(priv,
-					priv->active_rxon.bssid_addr, 1, 0, NULL)
-		    == IWL_INVALID_STATION) {
+		if (iwl_add_station(priv, priv->active_rxon.bssid_addr,
+				true, CMD_SYNC, NULL) == IWL_INVALID_STATION) {
 			IWL_ERR(priv, "Error adding AP address for transmit\n");
 			return -EIO;
 		}
@@ -2466,13 +2435,25 @@ static u16 iwl3945_get_hcmd_size(u8 cmd_id, u16 len)
 	}
 }
 
+
 static u16 iwl3945_build_addsta_hcmd(const struct iwl_addsta_cmd *cmd, u8 *data)
 {
-	u16 size = (u16)sizeof(struct iwl3945_addsta_cmd);
-	memcpy(data, cmd, size);
-	return size;
+	struct iwl3945_addsta_cmd *addsta = (struct iwl3945_addsta_cmd *)data;
+	addsta->mode = cmd->mode;
+	memcpy(&addsta->sta, &cmd->sta, sizeof(struct sta_id_modify));
+	memcpy(&addsta->key, &cmd->key, sizeof(struct iwl4965_keyinfo));
+	addsta->station_flags = cmd->station_flags;
+	addsta->station_flags_msk = cmd->station_flags_msk;
+	addsta->tid_disable_tx = cpu_to_le16(0);
+	addsta->rate_n_flags = cmd->rate_n_flags;
+	addsta->add_immediate_ba_tid = cmd->add_immediate_ba_tid;
+	addsta->remove_immediate_ba_tid = cmd->remove_immediate_ba_tid;
+	addsta->add_immediate_ba_ssn = cmd->add_immediate_ba_ssn;
+
+	return (u16)sizeof(struct iwl3945_addsta_cmd);
 }
 
+
 /**
  * iwl3945_init_hw_rate_table - Initialize the hardware rate fallback table
  */
@@ -2842,15 +2823,6 @@ static struct iwl_lib_ops iwl3945_lib = {
 	.config_ap = iwl3945_config_ap,
 };
 
-static struct iwl_station_mgmt_ops iwl3945_station_mgmt = {
-	.add_station = iwl3945_add_station,
-#if 0
-	.remove_station = iwl3945_remove_station,
-#endif
-	.find_station = iwl3945_hw_find_station,
-	.clear_station_table = iwl3945_clear_stations_table,
-};
-
 static struct iwl_hcmd_utils_ops iwl3945_hcmd_utils = {
 	.get_hcmd_size = iwl3945_get_hcmd_size,
 	.build_addsta_hcmd = iwl3945_build_addsta_hcmd,
@@ -2860,7 +2832,6 @@ static struct iwl_ops iwl3945_ops = {
 	.lib = &iwl3945_lib,
 	.hcmd = &iwl3945_hcmd,
 	.utils = &iwl3945_hcmd_utils,
-	.smgmt = &iwl3945_station_mgmt,
 };
 
 static struct iwl_cfg iwl3945_bg_cfg = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index da87528..4d8a325 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -202,12 +202,6 @@ struct iwl3945_ibss_seq {
  * for use by iwl-*.c
  *
  *****************************************************************************/
-struct iwl3945_addsta_cmd;
-extern int iwl3945_send_add_station(struct iwl_priv *priv,
-				struct iwl3945_addsta_cmd *sta, u8 flags);
-extern u8 iwl3945_add_station(struct iwl_priv *priv, const u8 *bssid,
-			  int is_ap, u8 flags, struct ieee80211_sta_ht_cap *ht_info);
-extern void iwl3945_clear_stations_table(struct iwl_priv *priv);
 extern int iwl3945_power_init_handle(struct iwl_priv *priv);
 extern int iwl3945_eeprom_init(struct iwl_priv *priv);
 extern int iwl3945_calc_db_from_ratio(int sig_ratio);
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index a0b2941..8f3d4bc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -2221,13 +2221,6 @@ static void iwl4965_cancel_deferred_work(struct iwl_priv *priv)
 	cancel_work_sync(&priv->txpower_work);
 }
 
-static struct iwl_station_mgmt_ops iwl4965_station_mgmt = {
-	.add_station = iwl_add_station_flags,
-	.remove_station = iwl_remove_station,
-	.find_station = iwl_find_station,
-	.clear_station_table = iwl_clear_stations_table,
-};
-
 static struct iwl_hcmd_ops iwl4965_hcmd = {
 	.rxon_assoc = iwl4965_send_rxon_assoc,
 	.commit_rxon = iwl_commit_rxon,
@@ -2297,7 +2290,6 @@ static struct iwl_ops iwl4965_ops = {
 	.lib = &iwl4965_lib,
 	.hcmd = &iwl4965_hcmd,
 	.utils = &iwl4965_hcmd_utils,
-	.smgmt = &iwl4965_station_mgmt,
 };
 
 struct iwl_cfg iwl4965_agn_cfg = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index ab29aab..b3c648c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -651,7 +651,7 @@ static void iwl5000_init_alive_start(struct iwl_priv *priv)
 		goto restart;
 	}
 
-	priv->cfg->ops->smgmt->clear_station_table(priv);
+	iwl_clear_stations_table(priv);
 	ret = priv->cfg->ops->lib->alive_notify(priv);
 	if (ret) {
 		IWL_WARN(priv,
@@ -1049,7 +1049,10 @@ static int iwl5000_txq_agg_disable(struct iwl_priv *priv, u16 txq_id,
 u16 iwl5000_build_addsta_hcmd(const struct iwl_addsta_cmd *cmd, u8 *data)
 {
 	u16 size = (u16)sizeof(struct iwl_addsta_cmd);
-	memcpy(data, cmd, size);
+	struct iwl_addsta_cmd *addsta = (struct iwl_addsta_cmd *)data;
+	memcpy(addsta, cmd, size);
+	/* resrved in 5000 */
+	addsta->rate_n_flags = cpu_to_le16(0);
 	return size;
 }
 
@@ -1423,13 +1426,6 @@ int iwl5000_calc_rssi(struct iwl_priv *priv,
 	return max_rssi - agc - IWL49_RSSI_OFFSET;
 }
 
-struct iwl_station_mgmt_ops iwl5000_station_mgmt = {
-	.add_station = iwl_add_station_flags,
-	.remove_station = iwl_remove_station,
-	.find_station = iwl_find_station,
-	.clear_station_table = iwl_clear_stations_table,
-};
-
 struct iwl_hcmd_ops iwl5000_hcmd = {
 	.rxon_assoc = iwl5000_send_rxon_assoc,
 	.commit_rxon = iwl_commit_rxon,
@@ -1549,14 +1545,12 @@ struct iwl_ops iwl5000_ops = {
 	.lib = &iwl5000_lib,
 	.hcmd = &iwl5000_hcmd,
 	.utils = &iwl5000_hcmd_utils,
-	.smgmt = &iwl5000_station_mgmt,
 };
 
 static struct iwl_ops iwl5150_ops = {
 	.lib = &iwl5150_lib,
 	.hcmd = &iwl5000_hcmd,
 	.utils = &iwl5000_hcmd_utils,
-	.smgmt = &iwl5000_station_mgmt,
 };
 
 struct iwl_mod_params iwl50_mod_params = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 7236382..bd438d8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -72,7 +72,6 @@ static struct iwl_ops iwl6000_ops = {
 	.lib = &iwl5000_lib,
 	.hcmd = &iwl5000_hcmd,
 	.utils = &iwl6000_hcmd_utils,
-	.smgmt = &iwl5000_station_mgmt,
 };
 
 struct iwl_cfg iwl6000_2ag_cfg = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index 23a58b0..2cdd191 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -2502,15 +2502,13 @@ static void rs_get_rate(void *priv_r, struct ieee80211_sta *sta, void *priv_sta,
 
 	if ((priv->iw_mode == NL80211_IFTYPE_ADHOC) &&
 	    !lq_sta->ibss_sta_added) {
-		u8 sta_id = priv->cfg->ops->smgmt->find_station(priv,
-						   hdr->addr1);
+		u8 sta_id = iwl_find_station(priv, hdr->addr1);
 
 		if (sta_id == IWL_INVALID_STATION) {
 			IWL_DEBUG_RATE(priv, "LQ: ADD station %pM\n",
 				       hdr->addr1);
-			sta_id = priv->cfg->ops->smgmt->add_station(priv,
-						hdr->addr1, 0,
-						CMD_ASYNC, NULL);
+			sta_id = iwl_add_station(priv, hdr->addr1,
+						false, CMD_ASYNC, NULL);
 		}
 		if ((sta_id != IWL_INVALID_STATION)) {
 			lq_sta->lq.sta_id = sta_id;
@@ -2598,7 +2596,7 @@ static void rs_rate_init(void *priv_r, struct ieee80211_supported_band *sband,
 
 	lq_sta->ibss_sta_added = 0;
 	if (priv->iw_mode == NL80211_IFTYPE_AP) {
-		u8 sta_id = priv->cfg->ops->smgmt->find_station(priv,
+		u8 sta_id = iwl_find_station(priv,
 								sta->addr);
 
 		/* for IBSS the call are from tasklet */
@@ -2606,9 +2604,8 @@ static void rs_rate_init(void *priv_r, struct ieee80211_supported_band *sband,
 
 		if (sta_id == IWL_INVALID_STATION) {
 			IWL_DEBUG_RATE(priv, "LQ: ADD station %pM\n", sta->addr);
-			sta_id = priv->cfg->ops->smgmt->add_station(priv,
-							sta->addr, 0,
-							CMD_ASYNC, NULL);
+			sta_id = iwl_add_station(priv, sta->addr, false,
+						CMD_ASYNC, NULL);
 		}
 		if ((sta_id != IWL_INVALID_STATION)) {
 			lq_sta->lq.sta_id = sta_id;
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 0a5507c..e6ecb3f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -188,7 +188,7 @@ int iwl_commit_rxon(struct iwl_priv *priv)
 		memcpy(active_rxon, &priv->staging_rxon, sizeof(*active_rxon));
 	}
 
-	priv->cfg->ops->smgmt->clear_station_table(priv);
+	iwl_clear_stations_table(priv);
 
 	priv->start_calib = 0;
 
@@ -1617,7 +1617,7 @@ static void iwl_alive_start(struct iwl_priv *priv)
 		goto restart;
 	}
 
-	priv->cfg->ops->smgmt->clear_station_table(priv);
+	iwl_clear_stations_table(priv);
 	ret = priv->cfg->ops->lib->alive_notify(priv);
 	if (ret) {
 		IWL_WARN(priv,
@@ -1703,7 +1703,7 @@ static void __iwl_down(struct iwl_priv *priv)
 
 	iwl_leds_unregister(priv);
 
-	priv->cfg->ops->smgmt->clear_station_table(priv);
+	iwl_clear_stations_table(priv);
 
 	/* Unblock any waiting calls */
 	wake_up_interruptible_all(&priv->wait_command_queue);
@@ -1903,7 +1903,7 @@ static int __iwl_up(struct iwl_priv *priv)
 
 	for (i = 0; i < MAX_HW_RESTARTS; i++) {
 
-		priv->cfg->ops->smgmt->clear_station_table(priv);
+		iwl_clear_stations_table(priv);
 
 		/* load bootstrap state machine,
 		 * load bootstrap program into processor's memory,
@@ -2348,7 +2348,7 @@ static int iwl_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		return -EOPNOTSUPP;
 	}
 	addr = sta ? sta->addr : iwl_bcast_addr;
-	sta_id = priv->cfg->ops->smgmt->find_station(priv, addr);
+	sta_id = iwl_find_station(priv, addr);
 	if (sta_id == IWL_INVALID_STATION) {
 		IWL_DEBUG_MAC80211(priv, "leave - %pM not in station map.\n",
 				   addr);
@@ -3121,7 +3121,7 @@ static void __devexit iwl_pci_remove(struct pci_dev *pdev)
 		iwl_rx_queue_free(priv, &priv->rxq);
 	iwl_hw_txq_ctx_free(priv);
 
-	priv->cfg->ops->smgmt->clear_station_table(priv);
+	iwl_clear_stations_table(priv);
 	iwl_eeprom_free(priv);
 
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index e581dc3..b3229f2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -1067,7 +1067,7 @@ struct iwl_addsta_cmd {
 	 * Set modify_mask bit STA_MODIFY_TID_DISABLE_TX to use this field. */
 	__le16 tid_disable_tx;
 
-	__le16	reserved1;
+	__le16	rate_n_flags;		/* 3945 only */
 
 	/* TID for which to add block-ack support.
 	 * Set modify_mask bit STA_MODIFY_ADDBA_TID_MSK to use this field. */
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index ddd2219..51cae4e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1389,7 +1389,7 @@ int iwl_init_drv(struct iwl_priv *priv)
 	mutex_init(&priv->mutex);
 
 	/* Clear the driver's (not device's) station table */
-	priv->cfg->ops->smgmt->clear_station_table(priv);
+	iwl_clear_stations_table(priv);
 
 	priv->data_retry_limit = -1;
 	priv->ieee_channels = NULL;
@@ -2680,7 +2680,7 @@ int iwl_set_mode(struct iwl_priv *priv, int mode)
 
 	memcpy(priv->staging_rxon.node_addr, priv->mac_addr, ETH_ALEN);
 
-	priv->cfg->ops->smgmt->clear_station_table(priv);
+	iwl_clear_stations_table(priv);
 
 	/* dont commit rxon if rf-kill is on*/
 	if (!iwl_is_ready_rf(priv))
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 87df1b7..4173a40 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -83,15 +83,6 @@ struct iwl_cmd;
 #define IWL_SKU_A       0x2
 #define IWL_SKU_N       0x8
 
-struct iwl_station_mgmt_ops {
-	u8 (*add_station)(struct iwl_priv *priv, const u8 *addr,
-			int is_ap, u8 flags, struct ieee80211_sta_ht_cap *ht_info);
-	int (*remove_station)(struct iwl_priv *priv, const u8 *addr,
-			int is_ap);
-	u8 (*find_station)(struct iwl_priv *priv, const u8 *addr);
-	void (*clear_station_table)(struct iwl_priv *priv);
-};
-
 struct iwl_hcmd_ops {
 	int (*rxon_assoc)(struct iwl_priv *priv);
 	int (*commit_rxon)(struct iwl_priv *priv);
@@ -183,7 +174,6 @@ struct iwl_ops {
 	const struct iwl_lib_ops *lib;
 	const struct iwl_hcmd_ops *hcmd;
 	const struct iwl_hcmd_utils_ops *utils;
-	const struct iwl_station_mgmt_ops *smgmt;
 };
 
 struct iwl_mod_params {
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 2dafc26..28c39cf 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -70,7 +70,6 @@ extern struct iwl_ops iwl5000_ops;
 extern struct iwl_lib_ops iwl5000_lib;
 extern struct iwl_hcmd_ops iwl5000_hcmd;
 extern struct iwl_hcmd_utils_ops iwl5000_hcmd_utils;
-extern struct iwl_station_mgmt_ops iwl5000_station_mgmt;
 
 /* shared functions from iwl-5000.c */
 extern u16 iwl5000_get_hcmd_size(u8 cmd_id, u16 len);
@@ -290,11 +289,11 @@ struct iwl_frame {
 #define MAX_SN ((IEEE80211_SCTL_SEQ) >> 4)
 
 enum {
-	/* CMD_SIZE_NORMAL = 0, */
+	CMD_SYNC = 0,
+	CMD_SIZE_NORMAL = 0,
+	CMD_NO_SKB = 0,
 	CMD_SIZE_HUGE = (1 << 0),
-	/* CMD_SYNC = 0, */
 	CMD_ASYNC = (1 << 1),
-	/* CMD_NO_SKB = 0, */
 	CMD_WANT_SKB = (1 << 2),
 };
 
@@ -1119,8 +1118,6 @@ struct iwl_priv {
 
 	struct iwl3945_notif_statistics statistics_39;
 
-	struct iwl3945_station_entry stations_39[IWL_STATION_COUNT];
-
 	u32 sta_supp_rates;
 }; /*iwl_priv */
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index 0eb939c..5ea3bc7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -75,7 +75,7 @@ int iwl_get_ra_sta_id(struct iwl_priv *priv, struct ieee80211_hdr *hdr)
 		return IWL_AP_ID;
 	} else {
 		u8 *da = ieee80211_get_DA(hdr);
-		return priv->cfg->ops->smgmt->find_station(priv, da);
+		return iwl_find_station(priv, da);
 	}
 }
 EXPORT_SYMBOL(iwl_get_ra_sta_id);
@@ -86,8 +86,7 @@ static void iwl_sta_ucode_activate(struct iwl_priv *priv, u8 sta_id)
 
 	spin_lock_irqsave(&priv->sta_lock, flags);
 
-	if (!(priv->stations[sta_id].used & IWL_STA_DRIVER_ACTIVE) &&
-	    !(priv->stations_39[sta_id].used & IWL_STA_DRIVER_ACTIVE))
+	if (!(priv->stations[sta_id].used & IWL_STA_DRIVER_ACTIVE))
 		IWL_ERR(priv, "ACTIVATE a non DRIVER active station %d\n",
 			sta_id);
 
@@ -228,15 +227,16 @@ static void iwl_set_ht_add_station(struct iwl_priv *priv, u8 index,
 }
 
 /**
- * iwl_add_station_flags - Add station to tables in driver and device
+ * iwl_add_station - Add station to tables in driver and device
  */
-u8 iwl_add_station_flags(struct iwl_priv *priv, const u8 *addr, int is_ap,
-			 u8 flags, struct ieee80211_sta_ht_cap *ht_info)
+u8 iwl_add_station(struct iwl_priv *priv, const u8 *addr, bool is_ap, u8 flags,
+		struct ieee80211_sta_ht_cap *ht_info)
 {
-	int i;
-	int sta_id = IWL_INVALID_STATION;
 	struct iwl_station_entry *station;
 	unsigned long flags_spin;
+	int i;
+	int sta_id = IWL_INVALID_STATION;
+	u16 rate;
 
 	spin_lock_irqsave(&priv->sta_lock, flags_spin);
 	if (is_ap)
@@ -288,6 +288,12 @@ u8 iwl_add_station_flags(struct iwl_priv *priv, const u8 *addr, int is_ap,
 	    priv->iw_mode != NL80211_IFTYPE_ADHOC)
 		iwl_set_ht_add_station(priv, sta_id, ht_info);
 
+	/* 3945 only */
+	rate = (priv->band == IEEE80211_BAND_5GHZ) ?
+		IWL_RATE_6M_PLCP : IWL_RATE_1M_PLCP;
+	/* Turn on both antennas for the station... */
+	station->sta.rate_n_flags = cpu_to_le16(rate | RATE_MCS_ANT_AB_MSK);
+
 	spin_unlock_irqrestore(&priv->sta_lock, flags_spin);
 
 	/* Add station to device's station table */
@@ -295,12 +301,12 @@ u8 iwl_add_station_flags(struct iwl_priv *priv, const u8 *addr, int is_ap,
 	return sta_id;
 
 }
-EXPORT_SYMBOL(iwl_add_station_flags);
+EXPORT_SYMBOL(iwl_add_station);
 
 static void iwl_sta_ucode_deactivate(struct iwl_priv *priv, const char *addr)
 {
 	unsigned long flags;
-	u8 sta_id = priv->cfg->ops->smgmt->find_station(priv, addr);
+	u8 sta_id = iwl_find_station(priv, addr);
 
 	BUG_ON(sta_id == IWL_INVALID_STATION);
 
@@ -408,7 +414,7 @@ static int iwl_send_remove_station(struct iwl_priv *priv, const u8 *addr,
 /**
  * iwl_remove_station - Remove driver's knowledge of station.
  */
-int iwl_remove_station(struct iwl_priv *priv, const u8 *addr, int is_ap)
+int iwl_remove_station(struct iwl_priv *priv, const u8 *addr, bool is_ap)
 {
 	int sta_id = IWL_INVALID_STATION;
 	int i, ret = -EINVAL;
@@ -767,7 +773,7 @@ void iwl_update_tkip_key(struct iwl_priv *priv,
 	unsigned long flags;
 	int i;
 
-	sta_id = priv->cfg->ops->smgmt->find_station(priv, addr);
+	sta_id = iwl_find_station(priv, addr);
 	if (sta_id == IWL_INVALID_STATION) {
 		IWL_DEBUG_MAC80211(priv, "leave - %pM not in station map.\n",
 				   addr);
@@ -946,7 +952,7 @@ EXPORT_SYMBOL(iwl_send_lq_cmd);
  *       calling this function (which runs REPLY_TX_LINK_QUALITY_CMD,
  *       which requires station table entry to exist).
  */
-static void iwl_sta_init_lq(struct iwl_priv *priv, const u8 *addr, int is_ap)
+static void iwl_sta_init_lq(struct iwl_priv *priv, const u8 *addr, bool is_ap)
 {
 	int i, r;
 	struct iwl_link_quality_cmd link_cmd = {
@@ -995,7 +1001,7 @@ static void iwl_sta_init_lq(struct iwl_priv *priv, const u8 *addr, int is_ap)
  * there is only one AP station with id= IWL_AP_ID
  * NOTE: mutex must be held before calling this function
  */
-int iwl_rxon_add_station(struct iwl_priv *priv, const u8 *addr, int is_ap)
+int iwl_rxon_add_station(struct iwl_priv *priv, const u8 *addr, bool is_ap)
 {
 	struct ieee80211_sta *sta;
 	struct ieee80211_sta_ht_cap ht_config;
@@ -1020,8 +1026,7 @@ int iwl_rxon_add_station(struct iwl_priv *priv, const u8 *addr, int is_ap)
 		rcu_read_unlock();
 	}
 
-	sta_id = priv->cfg->ops->smgmt->add_station(priv, addr, is_ap,
-				       0, cur_ht_config);
+	sta_id = iwl_add_station(priv, addr, is_ap, CMD_SYNC, cur_ht_config);
 
 	/* Set up default rate scaling table in device's station table */
 	iwl_sta_init_lq(priv, addr, is_ap);
@@ -1054,7 +1059,7 @@ int iwl_get_sta_id(struct iwl_priv *priv, struct ieee80211_hdr *hdr)
 
 	/* If we are an AP, then find the station, or use BCAST */
 	case NL80211_IFTYPE_AP:
-		sta_id = priv->cfg->ops->smgmt->find_station(priv, hdr->addr1);
+		sta_id = iwl_find_station(priv, hdr->addr1);
 		if (sta_id != IWL_INVALID_STATION)
 			return sta_id;
 		return priv->hw_params.bcast_sta_id;
@@ -1062,13 +1067,13 @@ int iwl_get_sta_id(struct iwl_priv *priv, struct ieee80211_hdr *hdr)
 	/* If this frame is going out to an IBSS network, find the station,
 	 * or create a new station table entry */
 	case NL80211_IFTYPE_ADHOC:
-		sta_id = priv->cfg->ops->smgmt->find_station(priv, hdr->addr1);
+		sta_id = iwl_find_station(priv, hdr->addr1);
 		if (sta_id != IWL_INVALID_STATION)
 			return sta_id;
 
 		/* Create new station table entry */
-		sta_id = priv->cfg->ops->smgmt->add_station(priv, hdr->addr1,
-						   0, CMD_ASYNC, NULL);
+		sta_id = iwl_add_station(priv, hdr->addr1, false,
+					CMD_ASYNC, NULL);
 
 		if (sta_id != IWL_INVALID_STATION)
 			return sta_id;
@@ -1111,7 +1116,7 @@ int iwl_sta_rx_agg_start(struct iwl_priv *priv,
 	unsigned long flags;
 	int sta_id;
 
-	sta_id = priv->cfg->ops->smgmt->find_station(priv, addr);
+	sta_id = iwl_find_station(priv, addr);
 	if (sta_id == IWL_INVALID_STATION)
 		return -ENXIO;
 
@@ -1133,7 +1138,7 @@ int iwl_sta_rx_agg_stop(struct iwl_priv *priv, const u8 *addr, int tid)
 	unsigned long flags;
 	int sta_id;
 
-	sta_id = priv->cfg->ops->smgmt->find_station(priv, addr);
+	sta_id = iwl_find_station(priv, addr);
 	if (sta_id == IWL_INVALID_STATION) {
 		IWL_ERR(priv, "Invalid station for AGG tid %d\n", tid);
 		return -ENXIO;
@@ -1168,7 +1173,7 @@ static void iwl_sta_modify_ps_wake(struct iwl_priv *priv, int sta_id)
 void iwl_update_ps_mode(struct iwl_priv *priv, u16 ps_bit, u8 *addr)
 {
 	/* FIXME: need locking over ps_status ??? */
-	u8 sta_id = priv->cfg->ops->smgmt->find_station(priv, addr);
+	u8 sta_id = iwl_find_station(priv, addr);
 
 	if (sta_id != IWL_INVALID_STATION) {
 		u8 sta_awake = priv->stations[sta_id].
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.h b/drivers/net/wireless/iwlwifi/iwl-sta.h
index 59a586b..6deebad 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.h
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.h
@@ -51,16 +51,15 @@ void iwl_update_tkip_key(struct iwl_priv *priv,
 			struct ieee80211_key_conf *keyconf,
 			const u8 *addr, u32 iv32, u16 *phase1key);
 
-int iwl_rxon_add_station(struct iwl_priv *priv, const u8 *addr, int is_ap);
-int iwl_remove_station(struct iwl_priv *priv, const u8 *addr, int is_ap);
+int iwl_rxon_add_station(struct iwl_priv *priv, const u8 *addr, bool is_ap);
+int iwl_remove_station(struct iwl_priv *priv, const u8 *addr, bool is_ap);
 void iwl_clear_stations_table(struct iwl_priv *priv);
 int iwl_get_free_ucode_key_index(struct iwl_priv *priv);
 int iwl_get_sta_id(struct iwl_priv *priv, struct ieee80211_hdr *hdr);
 int iwl_get_ra_sta_id(struct iwl_priv *priv, struct ieee80211_hdr *hdr);
 int iwl_send_add_sta(struct iwl_priv *priv,
 		     struct iwl_addsta_cmd *sta, u8 flags);
-u8 iwl_add_station_flags(struct iwl_priv *priv, const u8 *addr,
-			int is_ap, u8 flags,
+u8 iwl_add_station(struct iwl_priv *priv, const u8 *addr, bool is_ap, u8 flags,
 			struct ieee80211_sta_ht_cap *ht_info);
 void iwl_sta_tx_modify_enable_tid(struct iwl_priv *priv, int sta_id, int tid);
 int iwl_sta_rx_agg_start(struct iwl_priv *priv,
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 5c10b87..745eaae 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -95,144 +95,6 @@ struct iwl_mod_params iwl3945_mod_params = {
 	/* the rest are 0 by default */
 };
 
-/*************** STATION TABLE MANAGEMENT ****
- * mac80211 should be examined to determine if sta_info is duplicating
- * the functionality provided here
- */
-
-/**************************************************************/
-#if 0 /* temporary disable till we add real remove station */
-/**
- * iwl3945_remove_station - Remove driver's knowledge of station.
- *
- * NOTE:  This does not remove station from device's station table.
- */
-static u8 iwl3945_remove_station(struct iwl_priv *priv, const u8 *addr, int is_ap)
-{
-	int index = IWL_INVALID_STATION;
-	int i;
-	unsigned long flags;
-
-	spin_lock_irqsave(&priv->sta_lock, flags);
-
-	if (is_ap)
-		index = IWL_AP_ID;
-	else if (is_broadcast_ether_addr(addr))
-		index = priv->hw_params.bcast_sta_id;
-	else
-		for (i = IWL_STA_ID; i < priv->hw_params.max_stations; i++)
-			if (priv->stations_39[i].used &&
-			    !compare_ether_addr(priv->stations_39[i].sta.sta.addr,
-						addr)) {
-				index = i;
-				break;
-			}
-
-	if (unlikely(index == IWL_INVALID_STATION))
-		goto out;
-
-	if (priv->stations_39[index].used) {
-		priv->stations_39[index].used = 0;
-		priv->num_stations--;
-	}
-
-	BUG_ON(priv->num_stations < 0);
-
-out:
-	spin_unlock_irqrestore(&priv->sta_lock, flags);
-	return 0;
-}
-#endif
-
-/**
- * iwl3945_clear_stations_table - Clear the driver's station table
- *
- * NOTE:  This does not clear or otherwise alter the device's station table.
- */
-void iwl3945_clear_stations_table(struct iwl_priv *priv)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&priv->sta_lock, flags);
-
-	priv->num_stations = 0;
-	memset(priv->stations_39, 0, sizeof(priv->stations_39));
-
-	spin_unlock_irqrestore(&priv->sta_lock, flags);
-}
-
-/**
- * iwl3945_add_station - Add station to station tables in driver and device
- */
-u8 iwl3945_add_station(struct iwl_priv *priv, const u8 *addr, int is_ap, u8 flags, struct ieee80211_sta_ht_cap *ht_info)
-{
-	int i;
-	int index = IWL_INVALID_STATION;
-	struct iwl3945_station_entry *station;
-	unsigned long flags_spin;
-	u8 rate;
-
-	spin_lock_irqsave(&priv->sta_lock, flags_spin);
-	if (is_ap)
-		index = IWL_AP_ID;
-	else if (is_broadcast_ether_addr(addr))
-		index = priv->hw_params.bcast_sta_id;
-	else
-		for (i = IWL_STA_ID; i < priv->hw_params.max_stations; i++) {
-			if (!compare_ether_addr(priv->stations_39[i].sta.sta.addr,
-						addr)) {
-				index = i;
-				break;
-			}
-
-			if (!priv->stations_39[i].used &&
-			    index == IWL_INVALID_STATION)
-				index = i;
-		}
-
-	/* These two conditions has the same outcome but keep them separate
-	  since they have different meaning */
-	if (unlikely(index == IWL_INVALID_STATION)) {
-		spin_unlock_irqrestore(&priv->sta_lock, flags_spin);
-		return index;
-	}
-
-	if (priv->stations_39[index].used &&
-	   !compare_ether_addr(priv->stations_39[index].sta.sta.addr, addr)) {
-		spin_unlock_irqrestore(&priv->sta_lock, flags_spin);
-		return index;
-	}
-
-	IWL_DEBUG_ASSOC(priv, "Add STA ID %d: %pM\n", index, addr);
-	station = &priv->stations_39[index];
-	station->used = 1;
-	priv->num_stations++;
-
-	/* Set up the REPLY_ADD_STA command to send to device */
-	memset(&station->sta, 0, sizeof(struct iwl3945_addsta_cmd));
-	memcpy(station->sta.sta.addr, addr, ETH_ALEN);
-	station->sta.mode = 0;
-	station->sta.sta.sta_id = index;
-	station->sta.station_flags = 0;
-
-	if (priv->band == IEEE80211_BAND_5GHZ)
-		rate = IWL_RATE_6M_PLCP;
-	else
-		rate =	IWL_RATE_1M_PLCP;
-
-	/* Turn on both antennas for the station... */
-	station->sta.rate_n_flags =
-			iwl3945_hw_set_rate_n_flags(rate, RATE_MCS_ANT_AB_MSK);
-
-	spin_unlock_irqrestore(&priv->sta_lock, flags_spin);
-
-	/* Add station to device's station table */
-	iwl_send_add_sta(priv,
-			 (struct iwl_addsta_cmd *)&station->sta, flags);
-	return index;
-
-}
-
 /**
  * iwl3945_get_antenna_flags - Get antenna flags for RXON command
  * @priv: eeprom and antenna fields are used to determine antenna flags
@@ -289,32 +151,31 @@ static int iwl3945_set_ccmp_dynamic_key_info(struct iwl_priv *priv,
 	key_flags &= ~STA_KEY_FLG_INVALID;
 
 	spin_lock_irqsave(&priv->sta_lock, flags);
-	priv->stations_39[sta_id].keyinfo.alg = keyconf->alg;
-	priv->stations_39[sta_id].keyinfo.keylen = keyconf->keylen;
-	memcpy(priv->stations_39[sta_id].keyinfo.key, keyconf->key,
+	priv->stations[sta_id].keyinfo.alg = keyconf->alg;
+	priv->stations[sta_id].keyinfo.keylen = keyconf->keylen;
+	memcpy(priv->stations[sta_id].keyinfo.key, keyconf->key,
 	       keyconf->keylen);
 
-	memcpy(priv->stations_39[sta_id].sta.key.key, keyconf->key,
+	memcpy(priv->stations[sta_id].sta.key.key, keyconf->key,
 	       keyconf->keylen);
 
-	if ((priv->stations_39[sta_id].sta.key.key_flags & STA_KEY_FLG_ENCRYPT_MSK)
+	if ((priv->stations[sta_id].sta.key.key_flags & STA_KEY_FLG_ENCRYPT_MSK)
 			== STA_KEY_FLG_NO_ENC)
-		priv->stations_39[sta_id].sta.key.key_offset =
+		priv->stations[sta_id].sta.key.key_offset =
 				 iwl_get_free_ucode_key_index(priv);
 	/* else, we are overriding an existing key => no need to allocated room
 	* in uCode. */
 
-	WARN(priv->stations_39[sta_id].sta.key.key_offset == WEP_INVALID_OFFSET,
+	WARN(priv->stations[sta_id].sta.key.key_offset == WEP_INVALID_OFFSET,
 		"no space for a new key");
 
-	priv->stations_39[sta_id].sta.key.key_flags = key_flags;
-	priv->stations_39[sta_id].sta.sta.modify_mask = STA_MODIFY_KEY_MASK;
-	priv->stations_39[sta_id].sta.mode = STA_CONTROL_MODIFY_MSK;
+	priv->stations[sta_id].sta.key.key_flags = key_flags;
+	priv->stations[sta_id].sta.sta.modify_mask = STA_MODIFY_KEY_MASK;
+	priv->stations[sta_id].sta.mode = STA_CONTROL_MODIFY_MSK;
 
 	IWL_DEBUG_INFO(priv, "hwcrypto: modify ucode station key info\n");
 
-	ret = iwl_send_add_sta(priv,
-		(struct iwl_addsta_cmd *)&priv->stations_39[sta_id].sta, CMD_ASYNC);
+	ret = iwl_send_add_sta(priv, &priv->stations[sta_id].sta, CMD_ASYNC);
 
 	spin_unlock_irqrestore(&priv->sta_lock, flags);
 
@@ -340,17 +201,16 @@ static int iwl3945_clear_sta_key_info(struct iwl_priv *priv, u8 sta_id)
 	unsigned long flags;
 
 	spin_lock_irqsave(&priv->sta_lock, flags);
-	memset(&priv->stations_39[sta_id].keyinfo, 0, sizeof(struct iwl_hw_key));
-	memset(&priv->stations_39[sta_id].sta.key, 0,
+	memset(&priv->stations[sta_id].keyinfo, 0, sizeof(struct iwl_hw_key));
+	memset(&priv->stations[sta_id].sta.key, 0,
 		sizeof(struct iwl4965_keyinfo));
-	priv->stations_39[sta_id].sta.key.key_flags = STA_KEY_FLG_NO_ENC;
-	priv->stations_39[sta_id].sta.sta.modify_mask = STA_MODIFY_KEY_MASK;
-	priv->stations_39[sta_id].sta.mode = STA_CONTROL_MODIFY_MSK;
+	priv->stations[sta_id].sta.key.key_flags = STA_KEY_FLG_NO_ENC;
+	priv->stations[sta_id].sta.sta.modify_mask = STA_MODIFY_KEY_MASK;
+	priv->stations[sta_id].sta.mode = STA_CONTROL_MODIFY_MSK;
 	spin_unlock_irqrestore(&priv->sta_lock, flags);
 
 	IWL_DEBUG_INFO(priv, "hwcrypto: clear ucode station key info\n");
-	iwl_send_add_sta(priv,
-		(struct iwl_addsta_cmd *)&priv->stations_39[sta_id].sta, 0);
+	iwl_send_add_sta(priv, &priv->stations[sta_id].sta, 0);
 	return 0;
 }
 
@@ -578,7 +438,7 @@ static void iwl3945_build_tx_cmd_hwcrypto(struct iwl_priv *priv,
 				      int sta_id)
 {
 	struct iwl3945_tx_cmd *tx = (struct iwl3945_tx_cmd *)cmd->cmd.payload;
-	struct iwl_hw_key *keyinfo = &priv->stations_39[sta_id].keyinfo;
+	struct iwl_hw_key *keyinfo = &priv->stations[sta_id].keyinfo;
 
 	switch (keyinfo->alg) {
 	case ALG_CCMP:
@@ -753,7 +613,7 @@ static int iwl3945_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	if (ieee80211_is_data_qos(fc)) {
 		qc = ieee80211_get_qos_ctl(hdr);
 		tid = qc[0] & IEEE80211_QOS_CTL_TID_MASK;
-		seq_number = priv->stations_39[sta_id].tid[tid].seq_number &
+		seq_number = priv->stations[sta_id].tid[tid].seq_number &
 				IEEE80211_SCTL_SEQ;
 		hdr->seq_ctrl = cpu_to_le16(seq_number) |
 			(hdr->seq_ctrl &
@@ -813,7 +673,7 @@ static int iwl3945_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	if (!ieee80211_has_morefrags(hdr->frame_control)) {
 		txq->need_update = 1;
 		if (qc)
-			priv->stations_39[sta_id].tid[tid].seq_number = seq_number;
+			priv->stations[sta_id].tid[tid].seq_number = seq_number;
 	} else {
 		wait_write_ptr = 1;
 		txq->need_update = 0;
@@ -2589,7 +2449,7 @@ static void iwl3945_alive_start(struct iwl_priv *priv)
 		goto restart;
 	}
 
-	priv->cfg->ops->smgmt->clear_station_table(priv);
+	iwl_clear_stations_table(priv);
 
 	rfkill = iwl_read_prph(priv, APMG_RFKILL_REG);
 	IWL_DEBUG_INFO(priv, "RFKILL status: 0x%x\n", rfkill);
@@ -2681,7 +2541,7 @@ static void __iwl3945_down(struct iwl_priv *priv)
 		set_bit(STATUS_EXIT_PENDING, &priv->status);
 
 	iwl3945_led_unregister(priv);
-	priv->cfg->ops->smgmt->clear_station_table(priv);
+	iwl_clear_stations_table(priv);
 
 	/* Unblock any waiting calls */
 	wake_up_interruptible_all(&priv->wait_command_queue);
@@ -2833,7 +2693,7 @@ static int __iwl3945_up(struct iwl_priv *priv)
 
 	for (i = 0; i < MAX_HW_RESTARTS; i++) {
 
-		priv->cfg->ops->smgmt->clear_station_table(priv);
+		iwl_clear_stations_table(priv);
 
 		/* load bootstrap state machine,
 		 * load bootstrap program into processor's memory,
@@ -3247,7 +3107,7 @@ void iwl3945_post_associate(struct iwl_priv *priv)
 	case NL80211_IFTYPE_ADHOC:
 
 		priv->assoc_id = 1;
-		priv->cfg->ops->smgmt->add_station(priv, priv->bssid, 0, 0, NULL);
+		iwl_add_station(priv, priv->bssid, 0, CMD_SYNC, NULL);
 		iwl3945_sync_sta(priv, IWL_STA_ID,
 				 (priv->band == IEEE80211_BAND_5GHZ) ?
 				 IWL_RATE_6M_PLCP : IWL_RATE_1M_PLCP,
@@ -3438,7 +3298,7 @@ void iwl3945_config_ap(struct iwl_priv *priv)
 		/* restore RXON assoc */
 		priv->staging_rxon.filter_flags |= RXON_FILTER_ASSOC_MSK;
 		iwlcore_commit_rxon(priv);
-		priv->cfg->ops->smgmt->add_station(priv, iwl_bcast_addr, 0, 0, NULL);
+		iwl_add_station(priv, iwl_bcast_addr, 0, CMD_SYNC, NULL);
 	}
 	iwl3945_send_beacon_cmd(priv);
 
@@ -3469,7 +3329,7 @@ static int iwl3945_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	static_key = !iwl_is_associated(priv);
 
 	if (!static_key) {
-		sta_id = priv->cfg->ops->smgmt->find_station(priv, addr);
+		sta_id = iwl_find_station(priv, addr);
 		if (sta_id == IWL_INVALID_STATION) {
 			IWL_DEBUG_MAC80211(priv, "leave - %pM not in station map.\n",
 					    addr);
@@ -4044,7 +3904,7 @@ static int iwl3945_init_drv(struct iwl_priv *priv)
 	mutex_init(&priv->mutex);
 
 	/* Clear the driver's (not device's) station table */
-	priv->cfg->ops->smgmt->clear_station_table(priv);
+	iwl_clear_stations_table(priv);
 
 	priv->data_retry_limit = -1;
 	priv->ieee_channels = NULL;
@@ -4407,7 +4267,7 @@ static void __devexit iwl3945_pci_remove(struct pci_dev *pdev)
 	iwl3945_hw_txq_ctx_free(priv);
 
 	iwl3945_unset_hw_params(priv);
-	priv->cfg->ops->smgmt->clear_station_table(priv);
+	iwl_clear_stations_table(priv);
 
 	/*netif_stop_queue(dev); */
 	flush_workqueue(priv->workqueue);
-- 
1.5.6.3

