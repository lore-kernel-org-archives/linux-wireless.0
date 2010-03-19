Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:55370 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752701Ab0CSVOO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Mar 2010 17:14:14 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 2/9] iwlwifi: only add broadcast station once
Date: Fri, 19 Mar 2010 14:14:04 -0700
Message-Id: <1269033251-17545-3-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1269033251-17545-1-git-send-email-reinette.chatre@intel.com>
References: <1269033251-17545-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Reinette Chatre <reinette.chatre@intel.com>

Currently the broadcast station is added after every RXON command. Change
this to only add the broadcast station when interface is added by mac80211.
With this we need some extra work to ensure broadcast station is always
present since station table is cleared when RXON without ASSOC bit set is
sent. To deal with this we re-add all driver known stations to uCode after
such an RXON command is sent.

We also do some cleanup and remove the various calls to clear the station
table. We now only clear the station table in two scenarios:
- only clear uCode portion of station table when RXON command without ASSOC
bit is sent
- clear uCode and driver portion when interface goes down or is removed.

We need to do this clearing when interface goes down to deal with the
device restart/reconfigure routines which do not remove the interface, but
do add the interface during reconfiguration.

Previously the keys were also cleared when station table in driver is
cleared, this is not done anymore since mac80211 will take care that keys
are set and cleared correctly.

There is a known issue with this change. Associating with different AP
without bringing interface down fails with a firmware error. This is
because of the lack of full station notification support and the later
patches in this series that complete the station notification support will
fix this.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c     |   10 ++-
 drivers/net/wireless/iwlwifi/iwl-5000.c     |    1 -
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   27 +++----
 drivers/net/wireless/iwlwifi/iwl-core.c     |    8 ++-
 drivers/net/wireless/iwlwifi/iwl-sta.c      |  108 +++++++++++++++++++++------
 drivers/net/wireless/iwlwifi/iwl-sta.h      |    9 ++-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   11 +--
 7 files changed, 117 insertions(+), 57 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index ed59e27..7f95f90 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -1911,6 +1911,8 @@ static int iwl3945_commit_rxon(struct iwl_priv *priv)
 				  "configuration (%d).\n", rc);
 			return rc;
 		}
+		iwl_clear_ucode_stations(priv, false);
+		iwl_restore_stations(priv);
 	}
 
 	IWL_DEBUG_INFO(priv, "Sending RXON\n"
@@ -1941,7 +1943,10 @@ static int iwl3945_commit_rxon(struct iwl_priv *priv)
 
 	memcpy(active_rxon, staging_rxon, sizeof(*active_rxon));
 
-	iwl_clear_stations_table(priv);
+	if (!new_assoc) {
+		iwl_clear_ucode_stations(priv, false);
+		iwl_restore_stations(priv);
+	}
 
 	/* If we issue a new RXON command which required a tune then we must
 	 * send a new TXPOWER command or we won't be able to Tx any frames */
@@ -1951,9 +1956,6 @@ static int iwl3945_commit_rxon(struct iwl_priv *priv)
 		return rc;
 	}
 
-	/* Add the broadcast address so we can send broadcast frames */
-	priv->cfg->ops->lib->add_bcast_station(priv);
-
 	/* If we have set the ASSOC_MSK and we are in BSS mode then
 	 * add the IWL_AP_ID to the station rate table */
 	if (iwl_is_associated(priv) &&
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 37e1e77..046bdd9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -544,7 +544,6 @@ void iwl5000_init_alive_start(struct iwl_priv *priv)
 		goto restart;
 	}
 
-	iwl_clear_stations_table(priv);
 	ret = priv->cfg->ops->lib->alive_notify(priv);
 	if (ret) {
 		IWL_WARN(priv,
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index d6e1a05..85ff155 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -166,6 +166,8 @@ int iwl_commit_rxon(struct iwl_priv *priv)
 			IWL_ERR(priv, "Error clearing ASSOC_MSK (%d)\n", ret);
 			return ret;
 		}
+		iwl_clear_ucode_stations(priv, false);
+		iwl_restore_stations(priv);
 	}
 
 	IWL_DEBUG_INFO(priv, "Sending RXON\n"
@@ -179,9 +181,8 @@ int iwl_commit_rxon(struct iwl_priv *priv)
 	iwl_set_rxon_hwcrypto(priv, !priv->cfg->mod_params->sw_crypto);
 
 	/* Apply the new configuration
-	 * RXON unassoc clears the station table in uCode, send it before
-	 * we add the bcast station. If assoc bit is set, we will send RXON
-	 * after having added the bcast and bssid station.
+	 * RXON unassoc clears the station table in uCode so restoration of
+	 * stations is needed after it (the RXON command) completes
 	 */
 	if (!new_assoc) {
 		ret = iwl_send_cmd_pdu(priv, REPLY_RXON,
@@ -190,17 +191,14 @@ int iwl_commit_rxon(struct iwl_priv *priv)
 			IWL_ERR(priv, "Error setting new RXON (%d)\n", ret);
 			return ret;
 		}
+		IWL_DEBUG_INFO(priv, "Return from !new_assoc RXON. \n");
 		memcpy(active_rxon, &priv->staging_rxon, sizeof(*active_rxon));
+		iwl_clear_ucode_stations(priv, false);
+		iwl_restore_stations(priv);
 	}
 
-	iwl_clear_stations_table(priv);
-
 	priv->start_calib = 0;
 
-	/* Add the broadcast address so we can send broadcast frames */
-	priv->cfg->ops->lib->add_bcast_station(priv);
-
-
 	/* If we have set the ASSOC_MSK and we are in BSS mode then
 	 * add the IWL_AP_ID to the station rate table */
 	if (new_assoc) {
@@ -2087,7 +2085,6 @@ static void iwl_alive_start(struct iwl_priv *priv)
 		goto restart;
 	}
 
-	iwl_clear_stations_table(priv);
 	ret = priv->cfg->ops->lib->alive_notify(priv);
 	if (ret) {
 		IWL_WARN(priv,
@@ -2143,6 +2140,8 @@ static void iwl_alive_start(struct iwl_priv *priv)
 	wake_up_interruptible(&priv->wait_command_queue);
 
 	iwl_power_update_mode(priv, true);
+	IWL_DEBUG_INFO(priv, "Updated power mode\n");
+
 
 	return;
 
@@ -2162,7 +2161,7 @@ static void __iwl_down(struct iwl_priv *priv)
 	if (!exit_pending)
 		set_bit(STATUS_EXIT_PENDING, &priv->status);
 
-	iwl_clear_stations_table(priv);
+	iwl_clear_ucode_stations(priv, true);
 
 	/* Unblock any waiting calls */
 	wake_up_interruptible_all(&priv->wait_command_queue);
@@ -2359,8 +2358,6 @@ static int __iwl_up(struct iwl_priv *priv)
 
 	for (i = 0; i < MAX_HW_RESTARTS; i++) {
 
-		iwl_clear_stations_table(priv);
-
 		/* load bootstrap state machine,
 		 * load bootstrap program into processor's memory,
 		 * prepare to load the "initialize" uCode */
@@ -3270,9 +3267,6 @@ static int iwl_init_drv(struct iwl_priv *priv)
 	mutex_init(&priv->mutex);
 	mutex_init(&priv->sync_cmd_mutex);
 
-	/* Clear the driver's (not device's) station table */
-	iwl_clear_stations_table(priv);
-
 	priv->ieee_channels = NULL;
 	priv->ieee_rates = NULL;
 	priv->band = IEEE80211_BAND_2GHZ;
@@ -3649,7 +3643,6 @@ static void __devexit iwl_pci_remove(struct pci_dev *pdev)
 		iwl_rx_queue_free(priv, &priv->rxq);
 	iwl_hw_txq_ctx_free(priv);
 
-	iwl_clear_stations_table(priv);
 	iwl_eeprom_free(priv);
 
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index ec435e5..a33e453 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -2283,8 +2283,6 @@ static int iwl_set_mode(struct iwl_priv *priv, struct ieee80211_vif *vif)
 
 	memcpy(priv->staging_rxon.node_addr, priv->mac_addr, ETH_ALEN);
 
-	iwl_clear_stations_table(priv);
-
 	return iwlcore_commit_rxon(priv);
 }
 
@@ -2317,6 +2315,10 @@ int iwl_mac_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 	err = iwl_set_mode(priv, vif);
 	if (err)
 		goto out_err;
+
+	/* Add the broadcast address so we can send broadcast frames */
+	priv->cfg->ops->lib->add_bcast_station(priv);
+
 	goto out;
 
  out_err:
@@ -2339,6 +2341,8 @@ void iwl_mac_remove_interface(struct ieee80211_hw *hw,
 
 	mutex_lock(&priv->mutex);
 
+	iwl_clear_ucode_stations(priv, true);
+
 	if (iwl_is_ready_rf(priv)) {
 		iwl_scan_cancel_timeout(priv, 100);
 		priv->staging_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index b1aad30..3120990 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -34,9 +34,6 @@
 #include "iwl-core.h"
 #include "iwl-sta.h"
 
-#define IWL_STA_DRIVER_ACTIVE BIT(0) /* driver entry is active */
-#define IWL_STA_UCODE_ACTIVE  BIT(1) /* ucode entry is active */
-
 u8 iwl_find_station(struct iwl_priv *priv, const u8 *addr)
 {
 	int i;
@@ -495,37 +492,102 @@ out:
 }
 
 /**
- * iwl_clear_stations_table - Clear the driver's station table
- *
- * NOTE:  This does not clear or otherwise alter the device's station table.
+ * iwl_clear_ucode_stations() - clear entire station table driver and/or ucode
+ * @priv:
+ * @force: If set then the uCode station table needs to be cleared here. If
+ *         not set then the uCode station table has already been cleared,
+ *         for example after sending it a RXON command without ASSOC bit
+ *         set, and we just need to change driver state here.
  */
-void iwl_clear_stations_table(struct iwl_priv *priv)
+void iwl_clear_ucode_stations(struct iwl_priv *priv, bool force)
 {
-	unsigned long flags;
 	int i;
+	unsigned long flags_spin;
+	bool cleared = false;
+
+	IWL_DEBUG_INFO(priv, "Clearing ucode stations in driver%s\n",
+			force ? " and ucode" : "");
+
+	if (force) {
+		if (!iwl_is_ready(priv)) {
+			/*
+			 * If device is not ready at this point the station
+			 * table is likely already empty (uCode not ready
+			 * to receive station requests) or will soon be
+			 * due to interface going down.
+			 */
+			IWL_DEBUG_INFO(priv, "Unable to remove stations from device - device not ready\n");
+		} else {
+			iwl_send_cmd_pdu_async(priv, REPLY_REMOVE_ALL_STA, 0, NULL, NULL);
+		}
+	}
 
-	spin_lock_irqsave(&priv->sta_lock, flags);
+	spin_lock_irqsave(&priv->sta_lock, flags_spin);
+	if (force) {
+		IWL_DEBUG_INFO(priv, "Clearing all station information in driver\n");
+		priv->num_stations = 0;
+		memset(priv->stations, 0, sizeof(priv->stations));
+	} else {
+		for (i = 0; i < priv->hw_params.max_stations; i++) {
+			if (priv->stations[i].used & IWL_STA_UCODE_ACTIVE) {
+				IWL_DEBUG_INFO(priv, "Clearing ucode active for station %d \n", i);
+				priv->stations[i].used &= ~IWL_STA_UCODE_ACTIVE;
+				cleared = true;
+			}
+		}
+	}
+	spin_unlock_irqrestore(&priv->sta_lock, flags_spin);
+
+	if (!cleared)
+		IWL_DEBUG_INFO(priv, "No active stations found to be cleared\n");
+}
+EXPORT_SYMBOL(iwl_clear_ucode_stations);
 
-	if (iwl_is_alive(priv) &&
-	   !test_bit(STATUS_EXIT_PENDING, &priv->status) &&
-	   iwl_send_cmd_pdu_async(priv, REPLY_REMOVE_ALL_STA, 0, NULL, NULL))
-		IWL_ERR(priv, "Couldn't clear the station table\n");
+/**
+ * iwl_restore_stations() - Restore driver known stations to device
+ *
+ * All stations considered active by driver, but not present in ucode, is
+ * restored.
+ */
+void iwl_restore_stations(struct iwl_priv *priv)
+{
+	unsigned long flags_spin;
+	int i;
+	bool found = false;
 
-	priv->num_stations = 0;
-	memset(priv->stations, 0, sizeof(priv->stations));
+	if (!iwl_is_ready(priv)) {
+		IWL_DEBUG_INFO(priv, "Not ready yet, not restoring any stations.\n");
+		return;
+	}
 
-	/* clean ucode key table bit map */
-	priv->ucode_key_table = 0;
+	IWL_DEBUG_ASSOC(priv, "Restoring all known stations ... start.\n");
+	spin_lock_irqsave(&priv->sta_lock, flags_spin);
+	for (i = 0; i < priv->hw_params.max_stations; i++) {
+		if ((priv->stations[i].used & IWL_STA_DRIVER_ACTIVE) &&
+			    !(priv->stations[i].used & IWL_STA_UCODE_ACTIVE)) {
+			IWL_DEBUG_ASSOC(priv, "Restoring sta %pM\n",
+					priv->stations[i].sta.sta.addr);
+			priv->stations[i].sta.mode = 0;
+			priv->stations[i].used |= IWL_STA_UCODE_INPROGRESS;
+			found = true;
+		}
+	}
 
-	/* keep track of static keys */
-	for (i = 0; i < WEP_KEYS_MAX ; i++) {
-		if (priv->wep_keys[i].key_size)
-			set_bit(i, &priv->ucode_key_table);
+	for (i = 0; i < priv->hw_params.max_stations; i++) {
+		if ((priv->stations[i].used & IWL_STA_UCODE_INPROGRESS)) {
+			iwl_send_add_sta(priv, &priv->stations[i].sta,
+					 CMD_ASYNC);
+			priv->stations[i].used &= ~IWL_STA_UCODE_INPROGRESS;
+		}
 	}
 
-	spin_unlock_irqrestore(&priv->sta_lock, flags);
+	spin_unlock_irqrestore(&priv->sta_lock, flags_spin);
+	if (!found)
+		IWL_DEBUG_INFO(priv, "Restoring all known stations .... no stations to be restored.\n");
+	else
+		IWL_DEBUG_INFO(priv, "Restoring all known stations .... in progress.\n");
 }
-EXPORT_SYMBOL(iwl_clear_stations_table);
+EXPORT_SYMBOL(iwl_restore_stations);
 
 int iwl_get_free_ucode_key_index(struct iwl_priv *priv)
 {
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.h b/drivers/net/wireless/iwlwifi/iwl-sta.h
index 2dc35fe..50367e8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.h
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.h
@@ -32,6 +32,12 @@
 #define HW_KEY_DYNAMIC 0
 #define HW_KEY_DEFAULT 1
 
+#define IWL_STA_DRIVER_ACTIVE BIT(0) /* driver entry is active */
+#define IWL_STA_UCODE_ACTIVE  BIT(1) /* ucode entry is active */
+#define IWL_STA_UCODE_INPROGRESS  BIT(2) /* ucode entry is in process of
+					    being activated */
+
+
 /**
  * iwl_find_station - Find station id for a given BSSID
  * @bssid: MAC address of station ID to find
@@ -55,7 +61,8 @@ int iwl_rxon_add_station(struct iwl_priv *priv, const u8 *addr, bool is_ap);
 void iwl_add_bcast_station(struct iwl_priv *priv);
 void iwl3945_add_bcast_station(struct iwl_priv *priv);
 int iwl_remove_station(struct iwl_priv *priv, const u8 *addr, bool is_ap);
-void iwl_clear_stations_table(struct iwl_priv *priv);
+void iwl_restore_stations(struct iwl_priv *priv);
+void iwl_clear_ucode_stations(struct iwl_priv *priv, bool force);
 int iwl_get_free_ucode_key_index(struct iwl_priv *priv);
 int iwl_get_sta_id(struct iwl_priv *priv, struct ieee80211_hdr *hdr);
 int iwl_get_ra_sta_id(struct iwl_priv *priv, struct ieee80211_hdr *hdr);
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 2579bbc..6d3e6a8 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -2480,8 +2480,6 @@ static void iwl3945_alive_start(struct iwl_priv *priv)
 		goto restart;
 	}
 
-	iwl_clear_stations_table(priv);
-
 	rfkill = iwl_read_prph(priv, APMG_RFKILL_REG);
 	IWL_DEBUG_INFO(priv, "RFKILL status: 0x%x\n", rfkill);
 
@@ -2558,7 +2556,8 @@ static void __iwl3945_down(struct iwl_priv *priv)
 	if (!exit_pending)
 		set_bit(STATUS_EXIT_PENDING, &priv->status);
 
-	iwl_clear_stations_table(priv);
+	/* Station information will now be cleared in device */
+	iwl_clear_ucode_stations(priv, true);
 
 	/* Unblock any waiting calls */
 	wake_up_interruptible_all(&priv->wait_command_queue);
@@ -2692,8 +2691,6 @@ static int __iwl3945_up(struct iwl_priv *priv)
 
 	for (i = 0; i < MAX_HW_RESTARTS; i++) {
 
-		iwl_clear_stations_table(priv);
-
 		/* load bootstrap state machine,
 		 * load bootstrap program into processor's memory,
 		 * prepare to load the "initialize" uCode */
@@ -3834,9 +3831,6 @@ static int iwl3945_init_drv(struct iwl_priv *priv)
 	mutex_init(&priv->mutex);
 	mutex_init(&priv->sync_cmd_mutex);
 
-	/* Clear the driver's (not device's) station table */
-	iwl_clear_stations_table(priv);
-
 	priv->ieee_channels = NULL;
 	priv->ieee_rates = NULL;
 	priv->band = IEEE80211_BAND_2GHZ;
@@ -4196,7 +4190,6 @@ static void __devexit iwl3945_pci_remove(struct pci_dev *pdev)
 	iwl3945_hw_txq_ctx_free(priv);
 
 	iwl3945_unset_hw_params(priv);
-	iwl_clear_stations_table(priv);
 
 	/*netif_stop_queue(dev); */
 	flush_workqueue(priv->workqueue);
-- 
1.6.3.3

