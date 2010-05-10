Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:48051 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756838Ab0EJW2b (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 May 2010 18:28:31 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 35/47] iwlwifi: rework broadcast station management
Date: Mon, 10 May 2010 15:28:06 -0700
Message-Id: <1273530498-11876-36-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1273530498-11876-1-git-send-email-reinette.chatre@intel.com>
References: <1273530498-11876-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Currently, the broadcast station is managed along
with the interface type, rather than always being
present. That leads to a bug with injection -- it
is currently not possible to inject frames when
the only virtual interface is a monitor, because
in that the required broadcast station is missing.

Additionally, allocating and deallocating the
broadcast station's LQ all the time is wasteful,
and the code to support this is fairly complex.

So this changes completely the way we manage the
broadcast station. Rather than manage it along
with any interface, we now allocate it when we
bring the device up, and remove it again when we
bring the device down. When we bring the device
up, we don't immediately program the broadcast
station into it, instead we just mark it active
and rely on the next restore cycle to upload it
to the device. This works because an unassociated
RXON is always required at least once to set up
device parameters, which implies a reprogramming
of stations into the device.

As we now manage all stations properly, there no
longer is a need for forcing a clearing of them
via iwl_clear_ucode_stations(), which can become
a lot simpler.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c     |    1 -
 drivers/net/wireless/iwlwifi/iwl-3945.c     |    5 +-
 drivers/net/wireless/iwlwifi/iwl-4965.c     |    1 -
 drivers/net/wireless/iwlwifi/iwl-5000.c     |    2 -
 drivers/net/wireless/iwlwifi/iwl-6000.c     |    2 -
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   12 ++-
 drivers/net/wireless/iwlwifi/iwl-core.c     |    7 --
 drivers/net/wireless/iwlwifi/iwl-core.h     |    1 -
 drivers/net/wireless/iwlwifi/iwl-sta.c      |  137 +++++++++++++--------------
 drivers/net/wireless/iwlwifi/iwl-sta.h      |   12 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    8 +-
 11 files changed, 89 insertions(+), 99 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index a2f7cbc..6be2992 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -212,7 +212,6 @@ static struct iwl_lib_ops iwl1000_lib = {
 		.temperature = iwlagn_temperature,
 		.set_ct_kill = iwl1000_set_ct_threshold,
 	 },
-	.add_bcast_station = iwl_add_bcast_station,
 	.manage_ibss_station = iwlagn_manage_ibss_station,
 	.debugfs_ops = {
 		.rx_stats_read = iwl_ucode_rx_stats_read,
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 05d808b..7fb1595 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -1992,7 +1992,7 @@ static int iwl3945_commit_rxon(struct iwl_priv *priv)
 				  "configuration (%d).\n", rc);
 			return rc;
 		}
-		iwl_clear_ucode_stations(priv, false);
+		iwl_clear_ucode_stations(priv);
 		iwl_restore_stations(priv);
 	}
 
@@ -2025,7 +2025,7 @@ static int iwl3945_commit_rxon(struct iwl_priv *priv)
 	memcpy(active_rxon, staging_rxon, sizeof(*active_rxon));
 
 	if (!new_assoc) {
-		iwl_clear_ucode_stations(priv, false);
+		iwl_clear_ucode_stations(priv);
 		iwl_restore_stations(priv);
 	}
 
@@ -2853,7 +2853,6 @@ static struct iwl_lib_ops iwl3945_lib = {
 	.isr = iwl_isr_legacy,
 	.config_ap = iwl3945_config_ap,
 	.manage_ibss_station = iwl3945_manage_ibss_station,
-	.add_bcast_station = iwl3945_add_bcast_station,
 	.check_plcp_health = iwl3945_good_plcp_health,
 
 	.debugfs_ops = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index b8bf837..93893ae 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -2190,7 +2190,6 @@ static struct iwl_lib_ops iwl4965_lib = {
 		.temperature = iwl4965_temperature_calib,
 		.set_ct_kill = iwl4965_set_ct_threshold,
 	},
-	.add_bcast_station = iwl_add_bcast_station,
 	.manage_ibss_station = iwlagn_manage_ibss_station,
 	.debugfs_ops = {
 		.rx_stats_read = iwl_ucode_rx_stats_read,
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index efda0e8..a28af7e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -351,7 +351,6 @@ static struct iwl_lib_ops iwl5000_lib = {
 		.temperature = iwlagn_temperature,
 		.set_ct_kill = iwl5000_set_ct_threshold,
 	 },
-	.add_bcast_station = iwl_add_bcast_station,
 	.manage_ibss_station = iwlagn_manage_ibss_station,
 	.debugfs_ops = {
 		.rx_stats_read = iwl_ucode_rx_stats_read,
@@ -414,7 +413,6 @@ static struct iwl_lib_ops iwl5150_lib = {
 		.temperature = iwl5150_temperature,
 		.set_ct_kill = iwl5150_set_ct_threshold,
 	 },
-	.add_bcast_station = iwl_add_bcast_station,
 	.manage_ibss_station = iwlagn_manage_ibss_station,
 	.debugfs_ops = {
 		.rx_stats_read = iwl_ucode_rx_stats_read,
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 03c7324..9fbf54c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -317,7 +317,6 @@ static struct iwl_lib_ops iwl6000_lib = {
 		.temperature = iwlagn_temperature,
 		.set_ct_kill = iwl6000_set_ct_threshold,
 	 },
-	.add_bcast_station = iwl_add_bcast_station,
 	.manage_ibss_station = iwlagn_manage_ibss_station,
 	.debugfs_ops = {
 		.rx_stats_read = iwl_ucode_rx_stats_read,
@@ -390,7 +389,6 @@ static struct iwl_lib_ops iwl6050_lib = {
 		.set_ct_kill = iwl6000_set_ct_threshold,
 		.set_calib_version = iwl6050_set_calib_version,
 	 },
-	.add_bcast_station = iwl_add_bcast_station,
 	.manage_ibss_station = iwlagn_manage_ibss_station,
 	.debugfs_ops = {
 		.rx_stats_read = iwl_ucode_rx_stats_read,
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 85e045b..0c913ea 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -156,7 +156,7 @@ int iwl_commit_rxon(struct iwl_priv *priv)
 			IWL_ERR(priv, "Error clearing ASSOC_MSK (%d)\n", ret);
 			return ret;
 		}
-		iwl_clear_ucode_stations(priv, false);
+		iwl_clear_ucode_stations(priv);
 		iwl_restore_stations(priv);
 		ret = iwl_restore_default_wep_keys(priv);
 		if (ret) {
@@ -188,7 +188,7 @@ int iwl_commit_rxon(struct iwl_priv *priv)
 		}
 		IWL_DEBUG_INFO(priv, "Return from !new_assoc RXON.\n");
 		memcpy(active_rxon, &priv->staging_rxon, sizeof(*active_rxon));
-		iwl_clear_ucode_stations(priv, false);
+		iwl_clear_ucode_stations(priv);
 		iwl_restore_stations(priv);
 		ret = iwl_restore_default_wep_keys(priv);
 		if (ret) {
@@ -2403,7 +2403,8 @@ static void __iwl_down(struct iwl_priv *priv)
 	if (!exit_pending)
 		set_bit(STATUS_EXIT_PENDING, &priv->status);
 
-	iwl_clear_ucode_stations(priv, true);
+	iwl_clear_ucode_stations(priv);
+	iwl_dealloc_bcast_station(priv);
 
 	/* Unblock any waiting calls */
 	wake_up_interruptible_all(&priv->wait_command_queue);
@@ -2550,6 +2551,10 @@ static int __iwl_up(struct iwl_priv *priv)
 		return -EIO;
 	}
 
+	ret = iwl_alloc_bcast_station(priv, true);
+	if (ret)
+		return ret;
+
 	iwl_prepare_card_hw(priv);
 
 	if (!priv->hw_ready) {
@@ -3032,7 +3037,6 @@ void iwl_config_ap(struct iwl_priv *priv, struct ieee80211_vif *vif)
 		/* restore RXON assoc */
 		priv->staging_rxon.filter_flags |= RXON_FILTER_ASSOC_MSK;
 		iwlcore_commit_rxon(priv);
-		iwl_add_bcast_station(priv);
 	}
 	iwl_send_beacon_cmd(priv);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index d7a3620..f007b36 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -2042,11 +2042,6 @@ int iwl_mac_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 	if (err)
 		goto out_err;
 
-	/* Add the broadcast address so we can send broadcast frames */
-	err = priv->cfg->ops->lib->add_bcast_station(priv);
-	if (err)
-		goto out_err;
-
 	goto out;
 
  out_err:
@@ -2069,8 +2064,6 @@ void iwl_mac_remove_interface(struct ieee80211_hw *hw,
 
 	mutex_lock(&priv->mutex);
 
-	iwl_clear_ucode_stations(priv, true);
-
 	if (iwl_is_ready_rf(priv)) {
 		iwl_scan_cancel_timeout(priv, 100);
 		priv->staging_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 1774ce9..d80aa6c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -191,7 +191,6 @@ struct iwl_lib_ops {
 	/* temperature */
 	struct iwl_temp_ops temp_ops;
 	/* station management */
-	int (*add_bcast_station)(struct iwl_priv *priv);
 	int (*manage_ibss_station)(struct iwl_priv *priv,
 				   struct ieee80211_vif *vif, bool add);
 	/* recover from tx queue stall */
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index 5bf82b9..7e51647 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -656,63 +656,27 @@ out:
 EXPORT_SYMBOL_GPL(iwl_remove_station);
 
 /**
- * iwl_clear_ucode_stations() - clear entire station table driver and/or ucode
- * @priv:
- * @force: If set then the uCode station table needs to be cleared here. If
- *         not set then the uCode station table has already been cleared,
- *         for example after sending it a RXON command without ASSOC bit
- *         set, and we just need to change driver state here.
+ * iwl_clear_ucode_stations - clear ucode station table bits
+ *
+ * This function clears all the bits in the driver indicating
+ * which stations are active in the ucode. Call when something
+ * other than explicit station management would cause this in
+ * the ucode, e.g. unassociated RXON.
  */
-void iwl_clear_ucode_stations(struct iwl_priv *priv, bool force)
+void iwl_clear_ucode_stations(struct iwl_priv *priv)
 {
 	int i;
 	unsigned long flags_spin;
 	bool cleared = false;
 
-	IWL_DEBUG_INFO(priv, "Clearing ucode stations in driver%s\n",
-			force ? " and ucode" : "");
-
-	if (force) {
-		if (!iwl_is_ready(priv)) {
-			/*
-			 * If device is not ready at this point the station
-			 * table is likely already empty (uCode not ready
-			 * to receive station requests) or will soon be
-			 * due to interface going down.
-			 */
-			IWL_DEBUG_INFO(priv, "Unable to remove stations from device - device not ready\n");
-		} else {
-			iwl_send_cmd_pdu_async(priv, REPLY_REMOVE_ALL_STA, 0, NULL, NULL);
-		}
-	}
+	IWL_DEBUG_INFO(priv, "Clearing ucode stations in driver\n");
 
 	spin_lock_irqsave(&priv->sta_lock, flags_spin);
-	if (force) {
-		IWL_DEBUG_INFO(priv, "Clearing all station information in driver\n");
-		/*
-		 * The station entry contains a link to the LQ command. For
-		 * all stations managed by mac80211 this memory will be
-		 * managed by it also. For local stations (broadcast and
-		 * bssid station when in adhoc mode) we need to maintain
-		 * this lq command separately. This memory is created when
-		 * these stations are added.
-		 */
-		for (i = 0; i < priv->hw_params.max_stations; i++) {
-			if (priv->stations[i].used & IWL_STA_LOCAL) {
-				kfree(priv->stations[i].lq);
-				priv->stations[i].lq = NULL;
-			}
-		}
-		priv->num_stations = 0;
-		memset(priv->stations, 0, sizeof(priv->stations));
-		cleared = true;
-	} else {
-		for (i = 0; i < priv->hw_params.max_stations; i++) {
-			if (priv->stations[i].used & IWL_STA_UCODE_ACTIVE) {
-				IWL_DEBUG_INFO(priv, "Clearing ucode active for station %d\n", i);
-				priv->stations[i].used &= ~IWL_STA_UCODE_ACTIVE;
-				cleared = true;
-			}
+	for (i = 0; i < priv->hw_params.max_stations; i++) {
+		if (priv->stations[i].used & IWL_STA_UCODE_ACTIVE) {
+			IWL_DEBUG_INFO(priv, "Clearing ucode active for station %d\n", i);
+			priv->stations[i].used &= ~IWL_STA_UCODE_ACTIVE;
+			cleared = true;
 		}
 	}
 	spin_unlock_irqrestore(&priv->sta_lock, flags_spin);
@@ -1251,34 +1215,67 @@ int iwl_send_lq_cmd(struct iwl_priv *priv,
 EXPORT_SYMBOL(iwl_send_lq_cmd);
 
 /**
- * iwl_add_bcast_station - add broadcast station into station table.
+ * iwl_alloc_bcast_station - add broadcast station into driver's station table.
+ *
+ * This adds the broadcast station into the driver's station table
+ * and marks it driver active, so that it will be restored to the
+ * device at the next best time.
  */
-int iwl_add_bcast_station(struct iwl_priv *priv)
+int iwl_alloc_bcast_station(struct iwl_priv *priv, bool init_lq)
 {
-	IWL_DEBUG_INFO(priv, "Adding broadcast station to station table\n");
-	return iwl_add_local_station(priv, iwl_bcast_addr, true);
+	struct iwl_link_quality_cmd *link_cmd;
+	unsigned long flags;
+	u8 sta_id;
+
+	spin_lock_irqsave(&priv->sta_lock, flags);
+	sta_id = iwl_prep_station(priv, iwl_bcast_addr, false, NULL);
+	if (sta_id == IWL_INVALID_STATION) {
+		IWL_ERR(priv, "Unable to prepare broadcast station\n");
+		spin_unlock_irqrestore(&priv->sta_lock, flags);
+
+		return -EINVAL;
+	}
+
+	priv->stations[sta_id].used |= IWL_STA_DRIVER_ACTIVE;
+	priv->stations[sta_id].used |= IWL_STA_BCAST;
+	spin_unlock_irqrestore(&priv->sta_lock, flags);
+
+	if (init_lq) {
+		link_cmd = iwl_sta_alloc_lq(priv, sta_id);
+		if (!link_cmd) {
+			IWL_ERR(priv,
+				"Unable to initialize rate scaling for bcast station.\n");
+			return -ENOMEM;
+		}
+
+		spin_lock_irqsave(&priv->sta_lock, flags);
+		priv->stations[sta_id].lq = link_cmd;
+		spin_unlock_irqrestore(&priv->sta_lock, flags);
+	}
+
+	return 0;
 }
-EXPORT_SYMBOL(iwl_add_bcast_station);
+EXPORT_SYMBOL_GPL(iwl_alloc_bcast_station);
 
-/**
- * iwl3945_add_bcast_station - add broadcast station into station table.
- */
-int iwl3945_add_bcast_station(struct iwl_priv *priv)
+void iwl_dealloc_bcast_station(struct iwl_priv *priv)
 {
-	int ret;
-
-	IWL_DEBUG_INFO(priv, "Adding broadcast station to station table\n");
-	ret = iwl_add_local_station(priv, iwl_bcast_addr, false);
-	/*
-	 * It is assumed that when station is added more initialization
-	 * needs to be done, but for 3945 it is not the case and we can
-	 * just release station table access right here.
-	 */
-	priv->stations[priv->hw_params.bcast_sta_id].used &= ~IWL_STA_UCODE_INPROGRESS;
-	return ret;
+	unsigned long flags;
+	int i;
 
+	spin_lock_irqsave(&priv->sta_lock, flags);
+	for (i = 0; i < priv->hw_params.max_stations; i++) {
+		if (!(priv->stations[i].used & IWL_STA_BCAST))
+			continue;
+
+		priv->stations[i].used &= ~IWL_STA_UCODE_ACTIVE;
+		priv->num_stations--;
+		BUG_ON(priv->num_stations < 0);
+		kfree(priv->stations[i].lq);
+		priv->stations[i].lq = NULL;
+	}
+	spin_unlock_irqrestore(&priv->sta_lock, flags);
 }
-EXPORT_SYMBOL(iwl3945_add_bcast_station);
+EXPORT_SYMBOL_GPL(iwl_dealloc_bcast_station);
 
 /**
  * iwl_get_sta_id - Find station's index within station table
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.h b/drivers/net/wireless/iwlwifi/iwl-sta.h
index 1a0e590..50c9d51 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.h
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.h
@@ -36,9 +36,9 @@
 #define IWL_STA_UCODE_ACTIVE  BIT(1) /* ucode entry is active */
 #define IWL_STA_UCODE_INPROGRESS  BIT(2) /* ucode entry is in process of
 					    being activated */
-#define IWL_STA_LOCAL BIT(3) /* station state not directed by mac80211
-			     this is for bcast and bssid (when adhoc)
-			     stations */
+#define IWL_STA_LOCAL BIT(3) /* station state not directed by mac80211;
+				(this is for the IBSS BSSID stations) */
+#define IWL_STA_BCAST BIT(4) /* this station is the special bcast station */
 
 
 /**
@@ -60,10 +60,10 @@ void iwl_update_tkip_key(struct iwl_priv *priv,
 			struct ieee80211_key_conf *keyconf,
 			const u8 *addr, u32 iv32, u16 *phase1key);
 
-int iwl_add_bcast_station(struct iwl_priv *priv);
-int iwl3945_add_bcast_station(struct iwl_priv *priv);
 void iwl_restore_stations(struct iwl_priv *priv);
-void iwl_clear_ucode_stations(struct iwl_priv *priv, bool force);
+void iwl_clear_ucode_stations(struct iwl_priv *priv);
+int iwl_alloc_bcast_station(struct iwl_priv *priv, bool init_lq);
+void iwl_dealloc_bcast_station(struct iwl_priv *priv);
 int iwl_get_free_ucode_key_index(struct iwl_priv *priv);
 int iwl_get_sta_id(struct iwl_priv *priv, struct ieee80211_hdr *hdr);
 int iwl_send_add_sta(struct iwl_priv *priv,
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 85a46ad..1a44571 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -2583,7 +2583,8 @@ static void __iwl3945_down(struct iwl_priv *priv)
 		set_bit(STATUS_EXIT_PENDING, &priv->status);
 
 	/* Station information will now be cleared in device */
-	iwl_clear_ucode_stations(priv, true);
+	iwl_clear_ucode_stations(priv);
+	iwl_dealloc_bcast_station(priv);
 
 	/* Unblock any waiting calls */
 	wake_up_interruptible_all(&priv->wait_command_queue);
@@ -2664,6 +2665,10 @@ static int __iwl3945_up(struct iwl_priv *priv)
 {
 	int rc, i;
 
+	rc = iwl_alloc_bcast_station(priv, false);
+	if (rc)
+		return rc;
+
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status)) {
 		IWL_WARN(priv, "Exit pending; will not bring the NIC up\n");
 		return -EIO;
@@ -3302,7 +3307,6 @@ void iwl3945_config_ap(struct iwl_priv *priv, struct ieee80211_vif *vif)
 		/* restore RXON assoc */
 		priv->staging_rxon.filter_flags |= RXON_FILTER_ASSOC_MSK;
 		iwlcore_commit_rxon(priv);
-		iwl3945_add_bcast_station(priv);
 	}
 	iwl3945_send_beacon_cmd(priv);
 
-- 
1.6.3.3

