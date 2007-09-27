Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:31544 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752163AbXI0Deu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Sep 2007 23:34:50 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH] iwlwifi: clear station table in rxon unconditionally
Date: Thu, 27 Sep 2007 11:27:33 +0800
Message-Id: <119086367088-git-send-email-yi.zhu@intel.com>
In-Reply-To: <11908636692415-git-send-email-yi.zhu@intel.com>
References: <11908636643693-git-send-email-yi.zhu@intel.com>
 <11908636662994-git-send-email-yi.zhu@intel.com>
 <11908636683204-git-send-email-yi.zhu@intel.com>
 <11908636692415-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch clears stations table for every rxon command.
It removes iwl_rxon_add_station function in 3945.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   55 +++++++--------------------
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   24 +++--------
 2 files changed, 21 insertions(+), 58 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index c271418..6e46920 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -407,6 +407,7 @@ const u8 BROADCAST_ADDR[ETH_ALEN] = { 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF };
  */
 
 /**************************************************************/
+#if 0 /* temparary disable till we add real remove station */
 static u8 iwl_remove_station(struct iwl_priv *priv, const u8 *addr, int is_ap)
 {
 	int index = IWL_INVALID_STATION;
@@ -442,7 +443,7 @@ out:
 	spin_unlock_irqrestore(&priv->sta_lock, flags);
 	return 0;
 }
-
+#endif
 static void iwl_clear_stations_table(struct iwl_priv *priv)
 {
 	unsigned long flags;
@@ -835,25 +836,6 @@ int iwl_send_statistics_request(struct iwl_priv *priv)
 }
 
 /**
- * iwl_rxon_add_station - add station into station table.
- *
- * there is only one AP station with id= IWL_AP_ID
- * NOTE: mutex must be held before calling the this fnction
-*/
-static int iwl_rxon_add_station(struct iwl_priv *priv,
-				const u8 *addr, int is_ap)
-{
-	u8 rc;
-
-	/* Remove this station if it happens to already exist */
-	iwl_remove_station(priv, addr, is_ap);
-
-	rc = iwl_add_station(priv, addr, is_ap, 0);
-
-	return rc;
-}
-
-/**
  * iwl_set_rxon_channel - Set the phymode and channel values in staging RXON
  * @phymode: MODE_IEEE80211A sets to 5.2GHz; all else set to 2.4GHz
  * @channel: Any channel valid for the requested phymode
@@ -1123,16 +1105,6 @@ static int iwl_commit_rxon(struct iwl_priv *priv)
 				  "configuration (%d).\n", rc);
 			return rc;
 		}
-
-		/* The RXON bit toggling will have cleared out the
-		 * station table in the uCode, so blank it in the driver
-		 * as well */
-		iwl_clear_stations_table(priv);
-	} else if (priv->staging_rxon.filter_flags & RXON_FILTER_ASSOC_MSK) {
-		/* When switching from non-associated to associated, the
-		 * uCode clears out the station table; so clear it in the
-		 * driver as well */
-		iwl_clear_stations_table(priv);
 	}
 
 	IWL_DEBUG_INFO("Sending RXON\n"
@@ -1154,6 +1126,8 @@ static int iwl_commit_rxon(struct iwl_priv *priv)
 
 	memcpy(active_rxon, &priv->staging_rxon, sizeof(*active_rxon));
 
+	iwl_clear_stations_table(priv);
+
 	/* If we issue a new RXON command which required a tune then we must
 	 * send a new TXPOWER command or we won't be able to Tx any frames */
 	rc = iwl_hw_reg_send_txpower(priv);
@@ -1163,7 +1137,7 @@ static int iwl_commit_rxon(struct iwl_priv *priv)
 	}
 
 	/* Add the broadcast address so we can send broadcast frames */
-	if (iwl_rxon_add_station(priv, BROADCAST_ADDR, 0) ==
+	if (iwl_add_station(priv, BROADCAST_ADDR, 0, 0) ==
 	    IWL_INVALID_STATION) {
 		IWL_ERROR("Error adding BROADCAST address for transmit.\n");
 		return -EIO;
@@ -1173,7 +1147,7 @@ static int iwl_commit_rxon(struct iwl_priv *priv)
 	 * add the IWL_AP_ID to the station rate table */
 	if (iwl_is_associated(priv) &&
 	    (priv->iw_mode == IEEE80211_IF_TYPE_STA))
-		if (iwl_rxon_add_station(priv, priv->active_rxon.bssid_addr, 1)
+		if (iwl_add_station(priv, priv->active_rxon.bssid_addr, 1, 0)
 		    == IWL_INVALID_STATION) {
 			IWL_ERROR("Error adding AP address for transmit.\n");
 			return -EIO;
@@ -4658,7 +4632,7 @@ static void iwl_error_recovery(struct iwl_priv *priv)
 	priv->staging_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
 	iwl_commit_rxon(priv);
 
-	iwl_rxon_add_station(priv, priv->bssid, 1);
+	iwl_add_station(priv, priv->bssid, 1, 0);
 
 	spin_lock_irqsave(&priv->lock, flags);
 	priv->assoc_id = le16_to_cpu(priv->staging_rxon.assoc_id);
@@ -6804,8 +6778,8 @@ static void iwl_bg_post_associate(struct work_struct *data)
 		/* clear out the station table */
 		iwl_clear_stations_table(priv);
 
-		iwl_rxon_add_station(priv, BROADCAST_ADDR, 0);
-		iwl_rxon_add_station(priv, priv->bssid, 0);
+		iwl_add_station(priv, BROADCAST_ADDR, 0, 0);
+		iwl_add_station(priv, priv->bssid, 0, 0);
 		iwl3945_sync_sta(priv, IWL_STA_ID,
 				 (priv->phymode == MODE_IEEE80211A)?
 				 IWL_RATE_6M_PLCP : IWL_RATE_1M_PLCP,
@@ -7094,10 +7068,9 @@ static void iwl_config_ap(struct iwl_priv *priv)
 		/* restore RXON assoc */
 		priv->staging_rxon.filter_flags |= RXON_FILTER_ASSOC_MSK;
 		iwl_commit_rxon(priv);
-		iwl_rxon_add_station(priv, BROADCAST_ADDR, 0);
-		iwl_send_beacon_cmd(priv);
-	} else
-		iwl_send_beacon_cmd(priv);
+		iwl_add_station(priv, BROADCAST_ADDR, 0, 0);
+	}
+	iwl_send_beacon_cmd(priv);
 
 	/* FIXME - we need to add code here to detect a totally new
 	 * configuration, reset the AP, unassoc, rxon timing, assoc,
@@ -7181,8 +7154,8 @@ static int iwl_mac_config_interface(struct ieee80211_hw *hw, int if_id,
 						RXON_FILTER_ASSOC_MSK;
 			rc = iwl_commit_rxon(priv);
 			if ((priv->iw_mode == IEEE80211_IF_TYPE_STA) && rc)
-				iwl_rxon_add_station(
-					priv, priv->active_rxon.bssid_addr, 1);
+				iwl_add_station(priv,
+					priv->active_rxon.bssid_addr, 1, 0);
 		}
 
 	} else {
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index af261e6..283c6a3 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -407,6 +407,7 @@ const u8 BROADCAST_ADDR[ETH_ALEN] = { 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF };
 
 /**************************************************************/
 
+#if 0 /* temparary disable till we add real remove station */
 static u8 iwl_remove_station(struct iwl_priv *priv, const u8 *addr, int is_ap)
 {
 	int index = IWL_INVALID_STATION;
@@ -442,6 +443,7 @@ out:
 	spin_unlock_irqrestore(&priv->sta_lock, flags);
 	return 0;
 }
+#endif
 
 static void iwl_clear_stations_table(struct iwl_priv *priv)
 {
@@ -852,16 +854,12 @@ int iwl_send_statistics_request(struct iwl_priv *priv)
 static int iwl_rxon_add_station(struct iwl_priv *priv,
 				const u8 *addr, int is_ap)
 {
-	u8 rc;
-
-	/* Remove this station if it happens to already exist */
-	iwl_remove_station(priv, addr, is_ap);
-
-	rc = iwl_add_station(priv, addr, is_ap, 0);
+	u8 sta_id;
 
+	sta_id = iwl_add_station(priv, addr, is_ap, 0);
 	iwl4965_add_station(priv, addr, is_ap);
 
-	return rc;
+	return sta_id;
 }
 
 /**
@@ -1149,16 +1147,6 @@ static int iwl_commit_rxon(struct iwl_priv *priv)
 				  "configuration (%d).\n", rc);
 			return rc;
 		}
-
-		/* The RXON bit toggling will have cleared out the
-		 * station table in the uCode, so blank it in the driver
-		 * as well */
-		iwl_clear_stations_table(priv);
-	} else if (priv->staging_rxon.filter_flags & RXON_FILTER_ASSOC_MSK) {
-		/* When switching from non-associated to associated, the
-		 * uCode clears out the station table; so clear it in the
-		 * driver as well */
-		iwl_clear_stations_table(priv);
 	}
 
 	IWL_DEBUG_INFO("Sending RXON\n"
@@ -1178,6 +1166,8 @@ static int iwl_commit_rxon(struct iwl_priv *priv)
 		return rc;
 	}
 
+	iwl_clear_stations_table(priv);
+
 #ifdef CONFIG_IWLWIFI_SENSITIVITY
 	if (!priv->error_recovering)
 		priv->start_calib = 0;
-- 
1.5.1
