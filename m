Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:34843 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756894AbZDHSVQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Apr 2009 14:21:16 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 07/18] iwlwifi: use station management ops
Date: Wed,  8 Apr 2009 11:26:41 -0700
Message-Id: <1239215212-1657-8-git-send-email-reinette.chatre@intel.com> (sfid-20090408_202124_180173_E06F5D38)
In-Reply-To: <1239215212-1657-7-git-send-email-reinette.chatre@intel.com>
References: <1239215212-1657-1-git-send-email-reinette.chatre@intel.com>
 <1239215212-1657-2-git-send-email-reinette.chatre@intel.com>
 <1239215212-1657-3-git-send-email-reinette.chatre@intel.com>
 <1239215212-1657-4-git-send-email-reinette.chatre@intel.com>
 <1239215212-1657-5-git-send-email-reinette.chatre@intel.com>
 <1239215212-1657-6-git-send-email-reinette.chatre@intel.com>
 <1239215212-1657-7-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>

Patch replaces station management functions with ops declared.

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-5000.c   |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c |   16 ++++++++++------
 drivers/net/wireless/iwlwifi/iwl-agn.c    |   14 +++++++-------
 drivers/net/wireless/iwlwifi/iwl-core.c   |    2 +-
 drivers/net/wireless/iwlwifi/iwl-sta.c    |   20 ++++++++++----------
 5 files changed, 29 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 1344943..26f30a7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -678,7 +678,7 @@ static void iwl5000_init_alive_start(struct iwl_priv *priv)
 		goto restart;
 	}
 
-	iwl_clear_stations_table(priv);
+	priv->cfg->ops->smgmt->clear_station_table(priv);
 	ret = priv->cfg->ops->lib->alive_notify(priv);
 	if (ret) {
 		IWL_WARN(priv,
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index 7cdbcfe..a995128 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -2453,13 +2453,15 @@ static void rs_get_rate(void *priv_r, struct ieee80211_sta *sta, void *priv_sta,
 
 	if ((priv->iw_mode == NL80211_IFTYPE_ADHOC) &&
 	    !lq_sta->ibss_sta_added) {
-		u8 sta_id = iwl_find_station(priv, hdr->addr1);
+		u8 sta_id = priv->cfg->ops->smgmt->find_station(priv,
+						   hdr->addr1);
 
 		if (sta_id == IWL_INVALID_STATION) {
 			IWL_DEBUG_RATE(priv, "LQ: ADD station %pM\n",
 				       hdr->addr1);
-			sta_id = iwl_add_station_flags(priv, hdr->addr1,
-							0, CMD_ASYNC, NULL);
+			sta_id = priv->cfg->ops->smgmt->add_station_ht(priv,
+						hdr->addr1, 0,
+						CMD_ASYNC, NULL);
 		}
 		if ((sta_id != IWL_INVALID_STATION)) {
 			lq_sta->lq.sta_id = sta_id;
@@ -2526,15 +2528,17 @@ static void rs_rate_init(void *priv_r, struct ieee80211_supported_band *sband,
 
 	lq_sta->ibss_sta_added = 0;
 	if (priv->iw_mode == NL80211_IFTYPE_AP) {
-		u8 sta_id = iwl_find_station(priv, sta->addr);
+		u8 sta_id = priv->cfg->ops->smgmt->find_station(priv,
+								sta->addr);
 
 		/* for IBSS the call are from tasklet */
 		IWL_DEBUG_RATE(priv, "LQ: ADD station %pM\n", sta->addr);
 
 		if (sta_id == IWL_INVALID_STATION) {
 			IWL_DEBUG_RATE(priv, "LQ: ADD station %pM\n", sta->addr);
-			sta_id = iwl_add_station_flags(priv, sta->addr,
-							0, CMD_ASYNC, NULL);
+			sta_id = priv->cfg->ops->smgmt->add_station_ht(priv,
+							sta->addr, 0,
+							CMD_ASYNC, NULL);
 		}
 		if ((sta_id != IWL_INVALID_STATION)) {
 			lq_sta->lq.sta_id = sta_id;
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 01ccc7a..5013c5a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -188,7 +188,7 @@ int iwl_commit_rxon(struct iwl_priv *priv)
 		memcpy(active_rxon, &priv->staging_rxon, sizeof(*active_rxon));
 	}
 
-	iwl_clear_stations_table(priv);
+	priv->cfg->ops->smgmt->clear_station_table(priv);
 
 	if (!priv->error_recovering)
 		priv->start_calib = 0;
@@ -593,7 +593,7 @@ static int iwl_set_mode(struct iwl_priv *priv, int mode)
 	iwl_set_rxon_chain(priv);
 	memcpy(priv->staging_rxon.node_addr, priv->mac_addr, ETH_ALEN);
 
-	iwl_clear_stations_table(priv);
+	priv->cfg->ops->smgmt->clear_station_table(priv);
 
 	/* dont commit rxon if rf-kill is on*/
 	if (!iwl_is_ready_rf(priv))
@@ -1471,7 +1471,7 @@ static void iwl_alive_start(struct iwl_priv *priv)
 		goto restart;
 	}
 
-	iwl_clear_stations_table(priv);
+	priv->cfg->ops->smgmt->clear_station_table(priv);
 	ret = priv->cfg->ops->lib->alive_notify(priv);
 	if (ret) {
 		IWL_WARN(priv,
@@ -1557,7 +1557,7 @@ static void __iwl_down(struct iwl_priv *priv)
 
 	iwl_leds_unregister(priv);
 
-	iwl_clear_stations_table(priv);
+	priv->cfg->ops->smgmt->clear_station_table(priv);
 
 	/* Unblock any waiting calls */
 	wake_up_interruptible_all(&priv->wait_command_queue);
@@ -1708,7 +1708,7 @@ static int __iwl_up(struct iwl_priv *priv)
 
 	for (i = 0; i < MAX_HW_RESTARTS; i++) {
 
-		iwl_clear_stations_table(priv);
+		priv->cfg->ops->smgmt->clear_station_table(priv);
 
 		/* load bootstrap state machine,
 		 * load bootstrap program into processor's memory,
@@ -2439,7 +2439,7 @@ static int iwl_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		return -EOPNOTSUPP;
 	}
 	addr = sta ? sta->addr : iwl_bcast_addr;
-	sta_id = iwl_find_station(priv, addr);
+	sta_id = priv->cfg->ops->smgmt->find_station(priv, addr);
 	if (sta_id == IWL_INVALID_STATION) {
 		IWL_DEBUG_MAC80211(priv, "leave - %pM not in station map.\n",
 				   addr);
@@ -3311,7 +3311,7 @@ static void __devexit iwl_pci_remove(struct pci_dev *pdev)
 		iwl_rx_queue_free(priv, &priv->rxq);
 	iwl_hw_txq_ctx_free(priv);
 
-	iwl_clear_stations_table(priv);
+	priv->cfg->ops->smgmt->clear_station_table(priv);
 	iwl_eeprom_free(priv);
 
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index cb78186..6e96dcf 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1367,7 +1367,7 @@ int iwl_init_drv(struct iwl_priv *priv)
 	mutex_init(&priv->mutex);
 
 	/* Clear the driver's (not device's) station table */
-	iwl_clear_stations_table(priv);
+	priv->cfg->ops->smgmt->clear_station_table(priv);
 
 	priv->data_retry_limit = -1;
 	priv->ieee_channels = NULL;
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index 5798fe4..5816368 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -75,7 +75,7 @@ int iwl_get_ra_sta_id(struct iwl_priv *priv, struct ieee80211_hdr *hdr)
 		return IWL_AP_ID;
 	} else {
 		u8 *da = ieee80211_get_DA(hdr);
-		return iwl_find_station(priv, da);
+		return priv->cfg->ops->smgmt->find_station(priv, da);
 	}
 }
 EXPORT_SYMBOL(iwl_get_ra_sta_id);
@@ -300,7 +300,7 @@ EXPORT_SYMBOL(iwl_add_station_flags);
 static void iwl_sta_ucode_deactivate(struct iwl_priv *priv, const char *addr)
 {
 	unsigned long flags;
-	u8 sta_id = iwl_find_station(priv, addr);
+	u8 sta_id = priv->cfg->ops->smgmt->find_station(priv, addr);
 
 	BUG_ON(sta_id == IWL_INVALID_STATION);
 
@@ -758,7 +758,7 @@ void iwl_update_tkip_key(struct iwl_priv *priv,
 	int i;
 	DECLARE_MAC_BUF(mac);
 
-	sta_id = iwl_find_station(priv, addr);
+	sta_id = priv->cfg->ops->smgmt->find_station(priv, addr);
 	if (sta_id == IWL_INVALID_STATION) {
 		IWL_DEBUG_MAC80211(priv, "leave - %pM not in station map.\n",
 				   addr);
@@ -1019,7 +1019,7 @@ int iwl_rxon_add_station(struct iwl_priv *priv, const u8 *addr, int is_ap)
 		rcu_read_unlock();
 	}
 
-	sta_id = iwl_add_station_flags(priv, addr, is_ap,
+	sta_id = priv->cfg->ops->smgmt->add_station_ht(priv, addr, is_ap,
 				       0, cur_ht_config);
 
 	/* Set up default rate scaling table in device's station table */
@@ -1053,7 +1053,7 @@ int iwl_get_sta_id(struct iwl_priv *priv, struct ieee80211_hdr *hdr)
 
 	/* If we are an AP, then find the station, or use BCAST */
 	case NL80211_IFTYPE_AP:
-		sta_id = iwl_find_station(priv, hdr->addr1);
+		sta_id = priv->cfg->ops->smgmt->find_station(priv, hdr->addr1);
 		if (sta_id != IWL_INVALID_STATION)
 			return sta_id;
 		return priv->hw_params.bcast_sta_id;
@@ -1061,12 +1061,12 @@ int iwl_get_sta_id(struct iwl_priv *priv, struct ieee80211_hdr *hdr)
 	/* If this frame is going out to an IBSS network, find the station,
 	 * or create a new station table entry */
 	case NL80211_IFTYPE_ADHOC:
-		sta_id = iwl_find_station(priv, hdr->addr1);
+		sta_id = priv->cfg->ops->smgmt->find_station(priv, hdr->addr1);
 		if (sta_id != IWL_INVALID_STATION)
 			return sta_id;
 
 		/* Create new station table entry */
-		sta_id = iwl_add_station_flags(priv, hdr->addr1,
+		sta_id = priv->cfg->ops->smgmt->add_station_ht(priv, hdr->addr1,
 						   0, CMD_ASYNC, NULL);
 
 		if (sta_id != IWL_INVALID_STATION)
@@ -1115,7 +1115,7 @@ int iwl_sta_rx_agg_start(struct iwl_priv *priv,
 	unsigned long flags;
 	int sta_id;
 
-	sta_id = iwl_find_station(priv, addr);
+	sta_id = priv->cfg->ops->smgmt->find_station(priv, addr);
 	if (sta_id == IWL_INVALID_STATION)
 		return -ENXIO;
 
@@ -1137,7 +1137,7 @@ int iwl_sta_rx_agg_stop(struct iwl_priv *priv, const u8 *addr, int tid)
 	unsigned long flags;
 	int sta_id;
 
-	sta_id = iwl_find_station(priv, addr);
+	sta_id = priv->cfg->ops->smgmt->find_station(priv, addr);
 	if (sta_id == IWL_INVALID_STATION) {
 		IWL_ERR(priv, "Invalid station for AGG tid %d\n", tid);
 		return -ENXIO;
@@ -1172,7 +1172,7 @@ static void iwl_sta_modify_ps_wake(struct iwl_priv *priv, int sta_id)
 void iwl_update_ps_mode(struct iwl_priv *priv, u16 ps_bit, u8 *addr)
 {
 	/* FIXME: need locking over ps_status ??? */
-	u8 sta_id = iwl_find_station(priv, addr);
+	u8 sta_id = priv->cfg->ops->smgmt->find_station(priv, addr);
 
 	if (sta_id != IWL_INVALID_STATION) {
 		u8 sta_awake = priv->stations[sta_id].
-- 
1.5.6.3

