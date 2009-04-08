Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:61547 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759157AbZDHSVP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Apr 2009 14:21:15 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 06/18] iwl3945: replace station function with station ops
Date: Wed,  8 Apr 2009 11:26:40 -0700
Message-Id: <1239215212-1657-7-git-send-email-reinette.chatre@intel.com> (sfid-20090408_202122_464783_FC7F9488)
In-Reply-To: <1239215212-1657-6-git-send-email-reinette.chatre@intel.com>
References: <1239215212-1657-1-git-send-email-reinette.chatre@intel.com>
 <1239215212-1657-2-git-send-email-reinette.chatre@intel.com>
 <1239215212-1657-3-git-send-email-reinette.chatre@intel.com>
 <1239215212-1657-4-git-send-email-reinette.chatre@intel.com>
 <1239215212-1657-5-git-send-email-reinette.chatre@intel.com>
 <1239215212-1657-6-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>

Patch replaces station function used in driver by station management ops
in 3945.

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c     |    8 +++---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   29 ++++++++++++++-------------
 2 files changed, 19 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index fb08295..7c0c799 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -2114,7 +2114,7 @@ static int iwl3945_commit_rxon(struct iwl_priv *priv)
 
 	memcpy(active_rxon, staging_rxon, sizeof(*active_rxon));
 
-	iwl3945_clear_stations_table(priv);
+	priv->cfg->ops->smgmt->clear_station_table(priv);
 
 	/* If we issue a new RXON command which required a tune then we must
 	 * send a new TXPOWER command or we won't be able to Tx any frames */
@@ -2125,7 +2125,7 @@ static int iwl3945_commit_rxon(struct iwl_priv *priv)
 	}
 
 	/* Add the broadcast address so we can send broadcast frames */
-	if (iwl3945_add_station(priv, iwl_bcast_addr, 0, 0) ==
+	if (priv->cfg->ops->smgmt->add_station(priv, iwl_bcast_addr, 0, 0) ==
 	    IWL_INVALID_STATION) {
 		IWL_ERR(priv, "Error adding BROADCAST address for transmit.\n");
 		return -EIO;
@@ -2135,8 +2135,8 @@ static int iwl3945_commit_rxon(struct iwl_priv *priv)
 	 * add the IWL_AP_ID to the station rate table */
 	if (iwl_is_associated(priv) &&
 	    (priv->iw_mode == NL80211_IFTYPE_STATION))
-		if (iwl3945_add_station(priv, priv->active_rxon.bssid_addr,
-					1, 0)
+		if (priv->cfg->ops->smgmt->add_station(priv,
+					priv->active_rxon.bssid_addr, 1, 0)
 		    == IWL_INVALID_STATION) {
 			IWL_ERR(priv, "Error adding AP address for transmit\n");
 			return -EIO;
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index d1aaf7e..6161abd 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -588,7 +588,7 @@ static int iwl3945_set_mode(struct iwl_priv *priv, int mode)
 
 	iwl_connection_init_rx_config(priv, mode);
 
-	iwl3945_clear_stations_table(priv);
+	priv->cfg->ops->smgmt->clear_station_table(priv);
 
 	/* don't commit rxon if rf-kill is on*/
 	if (!iwl_is_ready_rf(priv))
@@ -734,7 +734,7 @@ static int iwl3945_get_sta_id(struct iwl_priv *priv, struct ieee80211_hdr *hdr)
 
 	/* If we are an AP, then find the station, or use BCAST */
 	case NL80211_IFTYPE_AP:
-		sta_id = iwl3945_hw_find_station(priv, hdr->addr1);
+		sta_id = priv->cfg->ops->smgmt->find_station(priv, hdr->addr1);
 		if (sta_id != IWL_INVALID_STATION)
 			return sta_id;
 		return priv->hw_params.bcast_sta_id;
@@ -743,11 +743,12 @@ static int iwl3945_get_sta_id(struct iwl_priv *priv, struct ieee80211_hdr *hdr)
 	 * or create a new station table entry */
 	case NL80211_IFTYPE_ADHOC: {
 		/* Create new station table entry */
-		sta_id = iwl3945_hw_find_station(priv, hdr->addr1);
+		sta_id = priv->cfg->ops->smgmt->find_station(priv, hdr->addr1);
 		if (sta_id != IWL_INVALID_STATION)
 			return sta_id;
 
-		sta_id = iwl3945_add_station(priv, hdr->addr1, 0, CMD_ASYNC);
+		sta_id = priv->cfg->ops->smgmt->add_station(priv,
+				hdr->addr1, 0, CMD_ASYNC);
 
 		if (sta_id != IWL_INVALID_STATION)
 			return sta_id;
@@ -1883,7 +1884,7 @@ static void iwl3945_error_recovery(struct iwl_priv *priv)
 	priv->staging_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
 	iwlcore_commit_rxon(priv);
 
-	iwl3945_add_station(priv, priv->bssid, 1, 0);
+	priv->cfg->ops->smgmt->add_station(priv, priv->bssid, 1, 0);
 
 	spin_lock_irqsave(&priv->lock, flags);
 	priv->assoc_id = le16_to_cpu(priv->staging_rxon.assoc_id);
@@ -2678,7 +2679,7 @@ static void iwl3945_alive_start(struct iwl_priv *priv)
 		goto restart;
 	}
 
-	iwl3945_clear_stations_table(priv);
+	priv->cfg->ops->smgmt->clear_station_table(priv);
 
 	rc = iwl_grab_nic_access(priv);
 	if (rc) {
@@ -2783,7 +2784,7 @@ static void __iwl3945_down(struct iwl_priv *priv)
 		set_bit(STATUS_EXIT_PENDING, &priv->status);
 
 	iwl3945_led_unregister(priv);
-	iwl3945_clear_stations_table(priv);
+	priv->cfg->ops->smgmt->clear_station_table(priv);
 
 	/* Unblock any waiting calls */
 	wake_up_interruptible_all(&priv->wait_command_queue);
@@ -2940,7 +2941,7 @@ static int __iwl3945_up(struct iwl_priv *priv)
 
 	for (i = 0; i < MAX_HW_RESTARTS; i++) {
 
-		iwl3945_clear_stations_table(priv);
+		priv->cfg->ops->smgmt->clear_station_table(priv);
 
 		/* load bootstrap state machine,
 		 * load bootstrap program into processor's memory,
@@ -3332,7 +3333,7 @@ void iwl3945_post_associate(struct iwl_priv *priv)
 	case NL80211_IFTYPE_ADHOC:
 
 		priv->assoc_id = 1;
-		iwl3945_add_station(priv, priv->bssid, 0, 0);
+		priv->cfg->ops->smgmt->add_station(priv, priv->bssid, 0, 0);
 		iwl3945_sync_sta(priv, IWL_STA_ID,
 				 (priv->band == IEEE80211_BAND_5GHZ) ?
 				 IWL_RATE_6M_PLCP : IWL_RATE_1M_PLCP,
@@ -3660,7 +3661,7 @@ static void iwl3945_config_ap(struct iwl_priv *priv)
 		/* restore RXON assoc */
 		priv->staging_rxon.filter_flags |= RXON_FILTER_ASSOC_MSK;
 		iwlcore_commit_rxon(priv);
-		iwl3945_add_station(priv, iwl_bcast_addr, 0, 0);
+		priv->cfg->ops->smgmt->add_station(priv, iwl_bcast_addr, 0, 0);
 	}
 	iwl3945_send_beacon_cmd(priv);
 
@@ -3752,7 +3753,7 @@ static int iwl3945_mac_config_interface(struct ieee80211_hw *hw,
 		else {
 			rc = iwlcore_commit_rxon(priv);
 			if ((priv->iw_mode == NL80211_IFTYPE_STATION) && rc)
-				iwl3945_add_station(priv,
+				priv->cfg->ops->smgmt->add_station(priv,
 					priv->active_rxon.bssid_addr, 1, 0);
 		}
 
@@ -3814,7 +3815,7 @@ static int iwl3945_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	static_key = !iwl_is_associated(priv);
 
 	if (!static_key) {
-		sta_id = iwl3945_hw_find_station(priv, addr);
+		sta_id = priv->cfg->ops->smgmt->find_station(priv, addr);
 		if (sta_id == IWL_INVALID_STATION) {
 			IWL_DEBUG_MAC80211(priv, "leave - %pMnot in station map.\n",
 					    addr);
@@ -4497,7 +4498,7 @@ static int iwl3945_init_drv(struct iwl_priv *priv)
 	mutex_init(&priv->mutex);
 
 	/* Clear the driver's (not device's) station table */
-	iwl3945_clear_stations_table(priv);
+	priv->cfg->ops->smgmt->clear_station_table(priv);
 
 	priv->data_retry_limit = -1;
 	priv->ieee_channels = NULL;
@@ -4858,7 +4859,7 @@ static void __devexit iwl3945_pci_remove(struct pci_dev *pdev)
 	iwl3945_hw_txq_ctx_free(priv);
 
 	iwl3945_unset_hw_params(priv);
-	iwl3945_clear_stations_table(priv);
+	priv->cfg->ops->smgmt->clear_station_table(priv);
 
 	/*netif_stop_queue(dev); */
 	flush_workqueue(priv->workqueue);
-- 
1.5.6.3

