Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:2471 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752933AbZDHSVG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Apr 2009 14:21:06 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 03/18] iwlwifi: add commit_rxon lib
Date: Wed,  8 Apr 2009 11:26:37 -0700
Message-Id: <1239215212-1657-4-git-send-email-reinette.chatre@intel.com> (sfid-20090408_202117_650255_B8792853)
In-Reply-To: <1239215212-1657-3-git-send-email-reinette.chatre@intel.com>
References: <1239215212-1657-1-git-send-email-reinette.chatre@intel.com>
 <1239215212-1657-2-git-send-email-reinette.chatre@intel.com>
 <1239215212-1657-3-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>

Patch adds commit_rxon lib operation to iwlwifi and iwl3945 drivers.

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c     |  145 ++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-3945.h     |    1 +
 drivers/net/wireless/iwlwifi/iwl-4965.c     |    1 +
 drivers/net/wireless/iwlwifi/iwl-5000.c     |    1 +
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   32 +++---
 drivers/net/wireless/iwlwifi/iwl-core.h     |    6 +
 drivers/net/wireless/iwlwifi/iwl3945-base.c |  174 +++------------------------
 7 files changed, 185 insertions(+), 175 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 519e892..9a0fb80 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -2008,6 +2008,150 @@ static int iwl3945_send_rxon_assoc(struct iwl_priv *priv)
 	return rc;
 }
 
+/**
+ * iwl3945_commit_rxon - commit staging_rxon to hardware
+ *
+ * The RXON command in staging_rxon is committed to the hardware and
+ * the active_rxon structure is updated with the new data.  This
+ * function correctly transitions out of the RXON_ASSOC_MSK state if
+ * a HW tune is required based on the RXON structure changes.
+ */
+static int iwl3945_commit_rxon(struct iwl_priv *priv)
+{
+	/* cast away the const for active_rxon in this function */
+	struct iwl3945_rxon_cmd *active_rxon = (void *)&priv->active_rxon;
+	struct iwl3945_rxon_cmd *staging_rxon = (void *)&priv->staging_rxon;
+	int rc = 0;
+	bool new_assoc =
+		!!(priv->staging_rxon.filter_flags & RXON_FILTER_ASSOC_MSK);
+
+	if (!iwl_is_alive(priv))
+		return -1;
+
+	/* always get timestamp with Rx frame */
+	staging_rxon->flags |= RXON_FLG_TSF2HOST_MSK;
+
+	/* select antenna */
+	staging_rxon->flags &=
+	    ~(RXON_FLG_DIS_DIV_MSK | RXON_FLG_ANT_SEL_MSK);
+	staging_rxon->flags |= iwl3945_get_antenna_flags(priv);
+
+	rc = iwl_check_rxon_cmd(priv);
+	if (rc) {
+		IWL_ERR(priv, "Invalid RXON configuration.  Not committing.\n");
+		return -EINVAL;
+	}
+
+	/* If we don't need to send a full RXON, we can use
+	 * iwl3945_rxon_assoc_cmd which is used to reconfigure filter
+	 * and other flags for the current radio configuration. */
+	if (!iwl_full_rxon_required(priv)) {
+		rc = iwl_send_rxon_assoc(priv);
+		if (rc) {
+			IWL_ERR(priv, "Error setting RXON_ASSOC "
+				  "configuration (%d).\n", rc);
+			return rc;
+		}
+
+		memcpy(active_rxon, staging_rxon, sizeof(*active_rxon));
+
+		return 0;
+	}
+
+	/* If we are currently associated and the new config requires
+	 * an RXON_ASSOC and the new config wants the associated mask enabled,
+	 * we must clear the associated from the active configuration
+	 * before we apply the new config */
+	if (iwl_is_associated(priv) && new_assoc) {
+		IWL_DEBUG_INFO(priv, "Toggling associated bit on current RXON\n");
+		active_rxon->filter_flags &= ~RXON_FILTER_ASSOC_MSK;
+
+		/*
+		 * reserved4 and 5 could have been filled by the iwlcore code.
+		 * Let's clear them before pushing to the 3945.
+		 */
+		active_rxon->reserved4 = 0;
+		active_rxon->reserved5 = 0;
+		rc = iwl_send_cmd_pdu(priv, REPLY_RXON,
+				      sizeof(struct iwl3945_rxon_cmd),
+				      &priv->active_rxon);
+
+		/* If the mask clearing failed then we set
+		 * active_rxon back to what it was previously */
+		if (rc) {
+			active_rxon->filter_flags |= RXON_FILTER_ASSOC_MSK;
+			IWL_ERR(priv, "Error clearing ASSOC_MSK on current "
+				  "configuration (%d).\n", rc);
+			return rc;
+		}
+	}
+
+	IWL_DEBUG_INFO(priv, "Sending RXON\n"
+		       "* with%s RXON_FILTER_ASSOC_MSK\n"
+		       "* channel = %d\n"
+		       "* bssid = %pM\n",
+		       (new_assoc ? "" : "out"),
+		       le16_to_cpu(staging_rxon->channel),
+		       staging_rxon->bssid_addr);
+
+	/*
+	 * reserved4 and 5 could have been filled by the iwlcore code.
+	 * Let's clear them before pushing to the 3945.
+	 */
+	staging_rxon->reserved4 = 0;
+	staging_rxon->reserved5 = 0;
+
+	iwl_set_rxon_hwcrypto(priv, !priv->hw_params.sw_crypto);
+
+	/* Apply the new configuration */
+	rc = iwl_send_cmd_pdu(priv, REPLY_RXON,
+			      sizeof(struct iwl3945_rxon_cmd),
+			      staging_rxon);
+	if (rc) {
+		IWL_ERR(priv, "Error setting new configuration (%d).\n", rc);
+		return rc;
+	}
+
+	memcpy(active_rxon, staging_rxon, sizeof(*active_rxon));
+
+	iwl3945_clear_stations_table(priv);
+
+	/* If we issue a new RXON command which required a tune then we must
+	 * send a new TXPOWER command or we won't be able to Tx any frames */
+	rc = priv->cfg->ops->lib->send_tx_power(priv);
+	if (rc) {
+		IWL_ERR(priv, "Error setting Tx power (%d).\n", rc);
+		return rc;
+	}
+
+	/* Add the broadcast address so we can send broadcast frames */
+	if (iwl3945_add_station(priv, iwl_bcast_addr, 0, 0) ==
+	    IWL_INVALID_STATION) {
+		IWL_ERR(priv, "Error adding BROADCAST address for transmit.\n");
+		return -EIO;
+	}
+
+	/* If we have set the ASSOC_MSK and we are in BSS mode then
+	 * add the IWL_AP_ID to the station rate table */
+	if (iwl_is_associated(priv) &&
+	    (priv->iw_mode == NL80211_IFTYPE_STATION))
+		if (iwl3945_add_station(priv, priv->active_rxon.bssid_addr,
+					1, 0)
+		    == IWL_INVALID_STATION) {
+			IWL_ERR(priv, "Error adding AP address for transmit\n");
+			return -EIO;
+		}
+
+	/* Init the hardware's rate fallback order based on the band */
+	rc = iwl3945_init_hw_rate_table(priv);
+	if (rc) {
+		IWL_ERR(priv, "Error setting HW rate table: %02X\n", rc);
+		return -EIO;
+	}
+
+	return 0;
+}
+
 /* will add 3945 channel switch cmd handling later */
 int iwl3945_hw_channel_switch(struct iwl_priv *priv, u16 channel)
 {
@@ -2775,6 +2919,7 @@ static int iwl3945_load_bsm(struct iwl_priv *priv)
 
 static struct iwl_hcmd_ops iwl3945_hcmd = {
 	.rxon_assoc = iwl3945_send_rxon_assoc,
+	.commit_rxon = iwl3945_commit_rxon,
 };
 
 static struct iwl_lib_ops iwl3945_lib = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index 13b191f..8e3e816 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -207,6 +207,7 @@ extern int iwl3945_send_add_station(struct iwl_priv *priv,
 				struct iwl3945_addsta_cmd *sta, u8 flags);
 extern u8 iwl3945_add_station(struct iwl_priv *priv, const u8 *bssid,
 			  int is_ap, u8 flags);
+extern void iwl3945_clear_stations_table(struct iwl_priv *priv);
 extern int iwl3945_power_init_handle(struct iwl_priv *priv);
 extern int iwl3945_eeprom_init(struct iwl_priv *priv);
 extern int iwl3945_calc_db_from_ratio(int sig_ratio);
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 37544af..053e420 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -2271,6 +2271,7 @@ static void iwl4965_cancel_deferred_work(struct iwl_priv *priv)
 
 static struct iwl_hcmd_ops iwl4965_hcmd = {
 	.rxon_assoc = iwl4965_send_rxon_assoc,
+	.commit_rxon = iwl_commit_rxon,
 };
 
 static struct iwl_hcmd_utils_ops iwl4965_hcmd_utils = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 837dbad..410cba2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -1474,6 +1474,7 @@ int iwl5000_calc_rssi(struct iwl_priv *priv,
 
 struct iwl_hcmd_ops iwl5000_hcmd = {
 	.rxon_assoc = iwl5000_send_rxon_assoc,
+	.commit_rxon = iwl_commit_rxon,
 };
 
 struct iwl_hcmd_utils_ops iwl5000_hcmd_utils = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index ea4f65e..01ccc7a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -102,7 +102,7 @@ MODULE_ALIAS("iwl4965");
  * function correctly transitions out of the RXON_ASSOC_MSK state if
  * a HW tune is required based on the RXON structure changes.
  */
-static int iwl_commit_rxon(struct iwl_priv *priv)
+int iwl_commit_rxon(struct iwl_priv *priv)
 {
 	/* cast away the const for active_rxon in this function */
 	struct iwl_rxon_cmd *active_rxon = (void *)&priv->active_rxon;
@@ -247,7 +247,7 @@ void iwl_update_chain_flags(struct iwl_priv *priv)
 {
 
 	iwl_set_rxon_chain(priv);
-	iwl_commit_rxon(priv);
+	iwlcore_commit_rxon(priv);
 }
 
 static void iwl_clear_free_frames(struct iwl_priv *priv)
@@ -606,7 +606,7 @@ static int iwl_set_mode(struct iwl_priv *priv, int mode)
 		return -EAGAIN;
 	}
 
-	iwl_commit_rxon(priv);
+	iwlcore_commit_rxon(priv);
 
 	return 0;
 }
@@ -1000,7 +1000,7 @@ static void iwl_error_recovery(struct iwl_priv *priv)
 	memcpy(&priv->staging_rxon, &priv->recovery_rxon,
 	       sizeof(priv->staging_rxon));
 	priv->staging_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
-	iwl_commit_rxon(priv);
+	iwlcore_commit_rxon(priv);
 
 	iwl_rxon_add_station(priv, priv->bssid, 1);
 
@@ -1509,7 +1509,7 @@ static void iwl_alive_start(struct iwl_priv *priv)
 	iwl_reset_run_time_calib(priv);
 
 	/* Configure the adapter for unassociated operation */
-	iwl_commit_rxon(priv);
+	iwlcore_commit_rxon(priv);
 
 	/* At this point, the NIC is initialized and operational */
 	iwl_rf_kill_ct_config(priv);
@@ -1865,7 +1865,7 @@ void iwl_post_associate(struct iwl_priv *priv)
 	conf = ieee80211_get_hw_conf(priv->hw);
 
 	priv->staging_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
-	iwl_commit_rxon(priv);
+	iwlcore_commit_rxon(priv);
 
 	iwl_setup_rxon_timing(priv);
 	ret = iwl_send_cmd_pdu(priv, REPLY_RXON_TIMING,
@@ -1900,7 +1900,7 @@ void iwl_post_associate(struct iwl_priv *priv)
 
 	}
 
-	iwl_commit_rxon(priv);
+	iwlcore_commit_rxon(priv);
 
 	switch (priv->iw_mode) {
 	case NL80211_IFTYPE_STATION:
@@ -2211,7 +2211,7 @@ static int iwl_mac_config(struct ieee80211_hw *hw, u32 changed)
 
 	if (memcmp(&priv->active_rxon,
 		   &priv->staging_rxon, sizeof(priv->staging_rxon)))
-		iwl_commit_rxon(priv);
+		iwlcore_commit_rxon(priv);
 	else
 		IWL_DEBUG_INFO(priv, "No re-sending same RXON configuration.\n");
 
@@ -2235,7 +2235,7 @@ static void iwl_config_ap(struct iwl_priv *priv)
 
 		/* RXON - unassoc (to set timing command) */
 		priv->staging_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
-		iwl_commit_rxon(priv);
+		iwlcore_commit_rxon(priv);
 
 		/* RXON Timing */
 		iwl_setup_rxon_timing(priv);
@@ -2271,7 +2271,7 @@ static void iwl_config_ap(struct iwl_priv *priv)
 		}
 		/* restore RXON assoc */
 		priv->staging_rxon.filter_flags |= RXON_FILTER_ASSOC_MSK;
-		iwl_commit_rxon(priv);
+		iwlcore_commit_rxon(priv);
 		spin_lock_irqsave(&priv->lock, flags);
 		iwl_activate_qos(priv, 1);
 		spin_unlock_irqrestore(&priv->lock, flags);
@@ -2365,7 +2365,7 @@ static int iwl_mac_config_interface(struct ieee80211_hw *hw,
 		if (priv->iw_mode == NL80211_IFTYPE_AP)
 			iwl_config_ap(priv);
 		else {
-			rc = iwl_commit_rxon(priv);
+			rc = iwlcore_commit_rxon(priv);
 			if ((priv->iw_mode == NL80211_IFTYPE_STATION) && rc)
 				iwl_rxon_add_station(
 					priv, priv->active_rxon.bssid_addr, 1);
@@ -2374,7 +2374,7 @@ static int iwl_mac_config_interface(struct ieee80211_hw *hw,
 	} else {
 		iwl_scan_cancel_timeout(priv, 100);
 		priv->staging_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
-		iwl_commit_rxon(priv);
+		iwlcore_commit_rxon(priv);
 	}
 
  done:
@@ -2396,7 +2396,7 @@ static void iwl_mac_remove_interface(struct ieee80211_hw *hw,
 	if (iwl_is_ready_rf(priv)) {
 		iwl_scan_cancel_timeout(priv, 100);
 		priv->staging_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
-		iwl_commit_rxon(priv);
+		iwlcore_commit_rxon(priv);
 	}
 	if (priv->vif == conf->vif) {
 		priv->vif = NULL;
@@ -2623,7 +2623,7 @@ static void iwl_mac_reset_tsf(struct ieee80211_hw *hw)
 	if (priv->iw_mode != NL80211_IFTYPE_AP) {
 		iwl_scan_cancel_timeout(priv, 100);
 		priv->staging_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
-		iwl_commit_rxon(priv);
+		iwlcore_commit_rxon(priv);
 	}
 
 	iwl_power_update_mode(priv, 0);
@@ -2803,7 +2803,7 @@ static ssize_t store_flags(struct device *d,
 		else {
 			IWL_DEBUG_INFO(priv, "Commit rxon.flags = 0x%04X\n", flags);
 			priv->staging_rxon.flags = cpu_to_le32(flags);
-			iwl_commit_rxon(priv);
+			iwlcore_commit_rxon(priv);
 		}
 	}
 	mutex_unlock(&priv->mutex);
@@ -2844,7 +2844,7 @@ static ssize_t store_filter_flags(struct device *d,
 				       "0x%04X\n", filter_flags);
 			priv->staging_rxon.filter_flags =
 				cpu_to_le32(filter_flags);
-			iwl_commit_rxon(priv);
+			iwlcore_commit_rxon(priv);
 		}
 	}
 	mutex_unlock(&priv->mutex);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 0447385..c7e0595 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -85,6 +85,7 @@ struct iwl_cmd;
 
 struct iwl_hcmd_ops {
 	int (*rxon_assoc)(struct iwl_priv *priv);
+	int (*commit_rxon)(struct iwl_priv *priv);
 };
 struct iwl_hcmd_utils_ops {
 	u16 (*get_hcmd_size)(u8 cmd_id, u16 len);
@@ -259,6 +260,7 @@ void iwl_bss_info_changed(struct ieee80211_hw *hw,
 				     struct ieee80211_bss_conf *bss_conf,
 				     u32 changes);
 int iwl_mac_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb);
+int iwl_commit_rxon(struct iwl_priv *priv);
 
 /*****************************************************
  * RX handlers.
@@ -541,6 +543,10 @@ static inline int iwl_send_rxon_assoc(struct iwl_priv *priv)
 {
 	return priv->cfg->ops->hcmd->rxon_assoc(priv);
 }
+static inline int iwlcore_commit_rxon(struct iwl_priv *priv)
+{
+	return priv->cfg->ops->hcmd->commit_rxon(priv);
+}
 
 static inline const struct ieee80211_supported_band *iwl_get_hw_mode(
 			struct iwl_priv *priv, enum ieee80211_band band)
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 4ac272b..6c11c8a 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -149,7 +149,7 @@ out:
  *
  * NOTE:  This does not clear or otherwise alter the device's station table.
  */
-static void iwl3945_clear_stations_table(struct iwl_priv *priv)
+void iwl3945_clear_stations_table(struct iwl_priv *priv)
 {
 	unsigned long flags;
 
@@ -270,150 +270,6 @@ __le32 iwl3945_get_antenna_flags(const struct iwl_priv *priv)
 	return 0;		/* "diversity" is default if error */
 }
 
-/**
- * iwl3945_commit_rxon - commit staging_rxon to hardware
- *
- * The RXON command in staging_rxon is committed to the hardware and
- * the active_rxon structure is updated with the new data.  This
- * function correctly transitions out of the RXON_ASSOC_MSK state if
- * a HW tune is required based on the RXON structure changes.
- */
-static int iwl3945_commit_rxon(struct iwl_priv *priv)
-{
-	/* cast away the const for active_rxon in this function */
-	struct iwl3945_rxon_cmd *active_rxon = (void *)&priv->active_rxon;
-	struct iwl3945_rxon_cmd *staging_rxon = (void *)&priv->staging_rxon;
-	int rc = 0;
-	bool new_assoc =
-		!!(priv->staging_rxon.filter_flags & RXON_FILTER_ASSOC_MSK);
-
-	if (!iwl_is_alive(priv))
-		return -1;
-
-	/* always get timestamp with Rx frame */
-	staging_rxon->flags |= RXON_FLG_TSF2HOST_MSK;
-
-	/* select antenna */
-	staging_rxon->flags &=
-	    ~(RXON_FLG_DIS_DIV_MSK | RXON_FLG_ANT_SEL_MSK);
-	staging_rxon->flags |= iwl3945_get_antenna_flags(priv);
-
-	rc = iwl_check_rxon_cmd(priv);
-	if (rc) {
-		IWL_ERR(priv, "Invalid RXON configuration.  Not committing.\n");
-		return -EINVAL;
-	}
-
-	/* If we don't need to send a full RXON, we can use
-	 * iwl3945_rxon_assoc_cmd which is used to reconfigure filter
-	 * and other flags for the current radio configuration. */
-	if (!iwl_full_rxon_required(priv)) {
-		rc = iwl_send_rxon_assoc(priv);
-		if (rc) {
-			IWL_ERR(priv, "Error setting RXON_ASSOC "
-				  "configuration (%d).\n", rc);
-			return rc;
-		}
-
-		memcpy(active_rxon, staging_rxon, sizeof(*active_rxon));
-
-		return 0;
-	}
-
-	/* If we are currently associated and the new config requires
-	 * an RXON_ASSOC and the new config wants the associated mask enabled,
-	 * we must clear the associated from the active configuration
-	 * before we apply the new config */
-	if (iwl_is_associated(priv) && new_assoc) {
-		IWL_DEBUG_INFO(priv, "Toggling associated bit on current RXON\n");
-		active_rxon->filter_flags &= ~RXON_FILTER_ASSOC_MSK;
-
-		/*
-		 * reserved4 and 5 could have been filled by the iwlcore code.
-		 * Let's clear them before pushing to the 3945.
-		 */
-		active_rxon->reserved4 = 0;
-		active_rxon->reserved5 = 0;
-		rc = iwl_send_cmd_pdu(priv, REPLY_RXON,
-				      sizeof(struct iwl3945_rxon_cmd),
-				      &priv->active_rxon);
-
-		/* If the mask clearing failed then we set
-		 * active_rxon back to what it was previously */
-		if (rc) {
-			active_rxon->filter_flags |= RXON_FILTER_ASSOC_MSK;
-			IWL_ERR(priv, "Error clearing ASSOC_MSK on current "
-				  "configuration (%d).\n", rc);
-			return rc;
-		}
-	}
-
-	IWL_DEBUG_INFO(priv, "Sending RXON\n"
-		       "* with%s RXON_FILTER_ASSOC_MSK\n"
-		       "* channel = %d\n"
-		       "* bssid = %pM\n",
-		       (new_assoc ? "" : "out"),
-		       le16_to_cpu(staging_rxon->channel),
-		       staging_rxon->bssid_addr);
-
-	/*
-	 * reserved4 and 5 could have been filled by the iwlcore code.
-	 * Let's clear them before pushing to the 3945.
-	 */
-	staging_rxon->reserved4 = 0;
-	staging_rxon->reserved5 = 0;
-
-	iwl_set_rxon_hwcrypto(priv, !priv->hw_params.sw_crypto);
-
-	/* Apply the new configuration */
-	rc = iwl_send_cmd_pdu(priv, REPLY_RXON,
-			      sizeof(struct iwl3945_rxon_cmd),
-			      staging_rxon);
-	if (rc) {
-		IWL_ERR(priv, "Error setting new configuration (%d).\n", rc);
-		return rc;
-	}
-
-	memcpy(active_rxon, staging_rxon, sizeof(*active_rxon));
-
-	iwl3945_clear_stations_table(priv);
-
-	/* If we issue a new RXON command which required a tune then we must
-	 * send a new TXPOWER command or we won't be able to Tx any frames */
-	rc = priv->cfg->ops->lib->send_tx_power(priv);
-	if (rc) {
-		IWL_ERR(priv, "Error setting Tx power (%d).\n", rc);
-		return rc;
-	}
-
-	/* Add the broadcast address so we can send broadcast frames */
-	if (iwl3945_add_station(priv, iwl_bcast_addr, 0, 0) ==
-	    IWL_INVALID_STATION) {
-		IWL_ERR(priv, "Error adding BROADCAST address for transmit.\n");
-		return -EIO;
-	}
-
-	/* If we have set the ASSOC_MSK and we are in BSS mode then
-	 * add the IWL_AP_ID to the station rate table */
-	if (iwl_is_associated(priv) &&
-	    (priv->iw_mode == NL80211_IFTYPE_STATION))
-		if (iwl3945_add_station(priv, priv->active_rxon.bssid_addr,
-					1, 0)
-		    == IWL_INVALID_STATION) {
-			IWL_ERR(priv, "Error adding AP address for transmit\n");
-			return -EIO;
-		}
-
-	/* Init the hardware's rate fallback order based on the band */
-	rc = iwl3945_init_hw_rate_table(priv);
-	if (rc) {
-		IWL_ERR(priv, "Error setting HW rate table: %02X\n", rc);
-		return -EIO;
-	}
-
-	return 0;
-}
-
 static int iwl3945_set_ccmp_dynamic_key_info(struct iwl_priv *priv,
 				   struct ieee80211_key_conf *keyconf,
 				   u8 sta_id)
@@ -745,7 +601,7 @@ static int iwl3945_set_mode(struct iwl_priv *priv, int mode)
 		return -EAGAIN;
 	}
 
-	iwl3945_commit_rxon(priv);
+	iwlcore_commit_rxon(priv);
 
 	return 0;
 }
@@ -2025,7 +1881,7 @@ static void iwl3945_error_recovery(struct iwl_priv *priv)
 	memcpy(&priv->staging_rxon, &priv->recovery_rxon,
 	       sizeof(priv->staging_rxon));
 	priv->staging_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
-	iwl3945_commit_rxon(priv);
+	iwlcore_commit_rxon(priv);
 
 	iwl3945_add_station(priv, priv->bssid, 1, 0);
 
@@ -2881,7 +2737,7 @@ static void iwl3945_alive_start(struct iwl_priv *priv)
 	iwl_send_bt_config(priv);
 
 	/* Configure the adapter for unassociated operation */
-	iwl3945_commit_rxon(priv);
+	iwlcore_commit_rxon(priv);
 
 	iwl3945_reg_txpower_periodic(priv);
 
@@ -3430,7 +3286,7 @@ void iwl3945_post_associate(struct iwl_priv *priv)
 	conf = ieee80211_get_hw_conf(priv->hw);
 
 	priv->staging_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
-	iwl3945_commit_rxon(priv);
+	iwlcore_commit_rxon(priv);
 
 	memset(&priv->rxon_timing, 0, sizeof(struct iwl_rxon_time_cmd));
 	iwl3945_setup_rxon_timing(priv);
@@ -3463,7 +3319,7 @@ void iwl3945_post_associate(struct iwl_priv *priv)
 
 	}
 
-	iwl3945_commit_rxon(priv);
+	iwlcore_commit_rxon(priv);
 
 	switch (priv->iw_mode) {
 	case NL80211_IFTYPE_STATION:
@@ -3740,7 +3596,7 @@ static int iwl3945_mac_config(struct ieee80211_hw *hw, u32 changed)
 
 	if (memcmp(&priv->active_rxon,
 		   &priv->staging_rxon, sizeof(priv->staging_rxon)))
-		iwl3945_commit_rxon(priv);
+		iwlcore_commit_rxon(priv);
 	else
 		IWL_DEBUG_INFO(priv, "Not re-sending same RXON configuration\n");
 
@@ -3764,7 +3620,7 @@ static void iwl3945_config_ap(struct iwl_priv *priv)
 
 		/* RXON - unassoc (to set timing command) */
 		priv->staging_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
-		iwl3945_commit_rxon(priv);
+		iwlcore_commit_rxon(priv);
 
 		/* RXON Timing */
 		memset(&priv->rxon_timing, 0, sizeof(struct iwl_rxon_time_cmd));
@@ -3800,7 +3656,7 @@ static void iwl3945_config_ap(struct iwl_priv *priv)
 		}
 		/* restore RXON assoc */
 		priv->staging_rxon.filter_flags |= RXON_FILTER_ASSOC_MSK;
-		iwl3945_commit_rxon(priv);
+		iwlcore_commit_rxon(priv);
 		iwl3945_add_station(priv, iwl_bcast_addr, 0, 0);
 	}
 	iwl3945_send_beacon_cmd(priv);
@@ -3891,7 +3747,7 @@ static int iwl3945_mac_config_interface(struct ieee80211_hw *hw,
 		if (priv->iw_mode == NL80211_IFTYPE_AP)
 			iwl3945_config_ap(priv);
 		else {
-			rc = iwl3945_commit_rxon(priv);
+			rc = iwlcore_commit_rxon(priv);
 			if ((priv->iw_mode == NL80211_IFTYPE_STATION) && rc)
 				iwl3945_add_station(priv,
 					priv->active_rxon.bssid_addr, 1, 0);
@@ -3900,7 +3756,7 @@ static int iwl3945_mac_config_interface(struct ieee80211_hw *hw,
 	} else {
 		iwl_scan_cancel_timeout(priv, 100);
 		priv->staging_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
-		iwl3945_commit_rxon(priv);
+		iwlcore_commit_rxon(priv);
 	}
 
  done:
@@ -3922,7 +3778,7 @@ static void iwl3945_mac_remove_interface(struct ieee80211_hw *hw,
 	if (iwl_is_ready_rf(priv)) {
 		iwl_scan_cancel_timeout(priv, 100);
 		priv->staging_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
-		iwl3945_commit_rxon(priv);
+		iwlcore_commit_rxon(priv);
 	}
 	if (priv->vif == conf->vif) {
 		priv->vif = NULL;
@@ -4065,7 +3921,7 @@ static void iwl3945_mac_reset_tsf(struct ieee80211_hw *hw)
 	if (priv->iw_mode != NL80211_IFTYPE_AP) {
 		iwl_scan_cancel_timeout(priv, 100);
 		priv->staging_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
-		iwl3945_commit_rxon(priv);
+		iwlcore_commit_rxon(priv);
 	}
 
 	/* Per mac80211.h: This is only used in IBSS mode... */
@@ -4191,7 +4047,7 @@ static ssize_t store_flags(struct device *d,
 			IWL_DEBUG_INFO(priv, "Committing rxon.flags = 0x%04X\n",
 				       flags);
 			priv->staging_rxon.flags = cpu_to_le32(flags);
-			iwl3945_commit_rxon(priv);
+			iwlcore_commit_rxon(priv);
 		}
 	}
 	mutex_unlock(&priv->mutex);
@@ -4227,7 +4083,7 @@ static ssize_t store_filter_flags(struct device *d,
 				       "0x%04X\n", filter_flags);
 			priv->staging_rxon.filter_flags =
 				cpu_to_le32(filter_flags);
-			iwl3945_commit_rxon(priv);
+			iwlcore_commit_rxon(priv);
 		}
 	}
 	mutex_unlock(&priv->mutex);
-- 
1.5.6.3

