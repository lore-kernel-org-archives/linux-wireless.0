Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:57327 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757537AbZJ3VgQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Oct 2009 17:36:16 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 08/15] iwlwifi: move iwl_[un]init_drv to iwlagn
Date: Fri, 30 Oct 2009 14:36:11 -0700
Message-Id: <1256938578-9638-9-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1256938578-9638-1-git-send-email-reinette.chatre@intel.com>
References: <1256938578-9638-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Reinette Chatre <reinette.chatre@intel.com>

Since iwlagn is the only user of these functions, move it to this module.
This results in a bit more code moving than just these functions since the
functions only used by them are also moved and we need to export the
symbols previously available to them directly.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c   |   90 +++++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-calib.c |    1 +
 drivers/net/wireless/iwlwifi/iwl-core.c  |   93 ------------------------------
 drivers/net/wireless/iwlwifi/iwl-core.h  |    2 -
 drivers/net/wireless/iwlwifi/iwl-scan.c  |    1 +
 5 files changed, 92 insertions(+), 95 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 3eeffcb..76355cd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2973,6 +2973,96 @@ static void iwl_cancel_deferred_work(struct iwl_priv *priv)
 	del_timer_sync(&priv->statistics_periodic);
 }
 
+static void iwl_init_hw_rates(struct iwl_priv *priv,
+			      struct ieee80211_rate *rates)
+{
+	int i;
+
+	for (i = 0; i < IWL_RATE_COUNT_LEGACY; i++) {
+		rates[i].bitrate = iwl_rates[i].ieee * 5;
+		rates[i].hw_value = i; /* Rate scaling will work on indexes */
+		rates[i].hw_value_short = i;
+		rates[i].flags = 0;
+		if ((i >= IWL_FIRST_CCK_RATE) && (i <= IWL_LAST_CCK_RATE)) {
+			/*
+			 * If CCK != 1M then set short preamble rate flag.
+			 */
+			rates[i].flags |=
+				(iwl_rates[i].plcp == IWL_RATE_1M_PLCP) ?
+					0 : IEEE80211_RATE_SHORT_PREAMBLE;
+		}
+	}
+}
+
+static int iwl_init_drv(struct iwl_priv *priv)
+{
+	int ret;
+
+	priv->ibss_beacon = NULL;
+
+	spin_lock_init(&priv->lock);
+	spin_lock_init(&priv->sta_lock);
+	spin_lock_init(&priv->hcmd_lock);
+
+	INIT_LIST_HEAD(&priv->free_frames);
+
+	mutex_init(&priv->mutex);
+
+	/* Clear the driver's (not device's) station table */
+	iwl_clear_stations_table(priv);
+
+	priv->ieee_channels = NULL;
+	priv->ieee_rates = NULL;
+	priv->band = IEEE80211_BAND_2GHZ;
+
+	priv->iw_mode = NL80211_IFTYPE_STATION;
+
+	/* Choose which receivers/antennas to use */
+	if (priv->cfg->ops->hcmd->set_rxon_chain)
+		priv->cfg->ops->hcmd->set_rxon_chain(priv);
+
+	iwl_init_scan_params(priv);
+
+	iwl_reset_qos(priv);
+
+	priv->qos_data.qos_active = 0;
+	priv->qos_data.qos_cap.val = 0;
+
+	priv->rates_mask = IWL_RATES_MASK;
+	/* Set the tx_power_user_lmt to the lowest power level
+	 * this value will get overwritten by channel max power avg
+	 * from eeprom */
+	priv->tx_power_user_lmt = IWL_TX_POWER_TARGET_POWER_MIN;
+
+	ret = iwl_init_channel_map(priv);
+	if (ret) {
+		IWL_ERR(priv, "initializing regulatory failed: %d\n", ret);
+		goto err;
+	}
+
+	ret = iwlcore_init_geos(priv);
+	if (ret) {
+		IWL_ERR(priv, "initializing geos failed: %d\n", ret);
+		goto err_free_channel_map;
+	}
+	iwl_init_hw_rates(priv, priv->ieee_rates);
+
+	return 0;
+
+err_free_channel_map:
+	iwl_free_channel_map(priv);
+err:
+	return ret;
+}
+
+static void iwl_uninit_drv(struct iwl_priv *priv)
+{
+	iwl_calib_free_results(priv);
+	iwlcore_free_geos(priv);
+	iwl_free_channel_map(priv);
+	kfree(priv->scan);
+}
+
 static struct attribute *iwl_sysfs_entries[] = {
 	&dev_attr_flags.attr,
 	&dev_attr_filter_flags.attr,
diff --git a/drivers/net/wireless/iwlwifi/iwl-calib.c b/drivers/net/wireless/iwlwifi/iwl-calib.c
index 1f801eb..d994de7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-calib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-calib.c
@@ -132,6 +132,7 @@ void iwl_calib_free_results(struct iwl_priv *priv)
 		priv->calib_results[i].buf_len = 0;
 	}
 }
+EXPORT_SYMBOL(iwl_calib_free_results);
 
 /*****************************************************************************
  * RUNTIME calibrations framework
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 2952890..96eb476 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -452,28 +452,6 @@ static void iwlcore_init_ht_hw_capab(const struct iwl_priv *priv,
 	}
 }
 
-static void iwlcore_init_hw_rates(struct iwl_priv *priv,
-			      struct ieee80211_rate *rates)
-{
-	int i;
-
-	for (i = 0; i < IWL_RATE_COUNT_LEGACY; i++) {
-		rates[i].bitrate = iwl_rates[i].ieee * 5;
-		rates[i].hw_value = i; /* Rate scaling will work on indexes */
-		rates[i].hw_value_short = i;
-		rates[i].flags = 0;
-		if ((i >= IWL_FIRST_CCK_RATE) && (i <= IWL_LAST_CCK_RATE)) {
-			/*
-			 * If CCK != 1M then set short preamble rate flag.
-			 */
-			rates[i].flags |=
-				(iwl_rates[i].plcp == IWL_RATE_1M_PLCP) ?
-					0 : IEEE80211_RATE_SHORT_PREAMBLE;
-		}
-	}
-}
-
-
 /**
  * iwlcore_init_geos - Initialize mac80211's geo/channel info based from eeprom
  */
@@ -1572,68 +1550,6 @@ int iwl_set_hw_params(struct iwl_priv *priv)
 }
 EXPORT_SYMBOL(iwl_set_hw_params);
 
-int iwl_init_drv(struct iwl_priv *priv)
-{
-	int ret;
-
-	priv->ibss_beacon = NULL;
-
-	spin_lock_init(&priv->lock);
-	spin_lock_init(&priv->sta_lock);
-	spin_lock_init(&priv->hcmd_lock);
-
-	INIT_LIST_HEAD(&priv->free_frames);
-
-	mutex_init(&priv->mutex);
-
-	/* Clear the driver's (not device's) station table */
-	iwl_clear_stations_table(priv);
-
-	priv->ieee_channels = NULL;
-	priv->ieee_rates = NULL;
-	priv->band = IEEE80211_BAND_2GHZ;
-
-	priv->iw_mode = NL80211_IFTYPE_STATION;
-
-	/* Choose which receivers/antennas to use */
-	if (priv->cfg->ops->hcmd->set_rxon_chain)
-		priv->cfg->ops->hcmd->set_rxon_chain(priv);
-
-	iwl_init_scan_params(priv);
-
-	iwl_reset_qos(priv);
-
-	priv->qos_data.qos_active = 0;
-	priv->qos_data.qos_cap.val = 0;
-
-	priv->rates_mask = IWL_RATES_MASK;
-	/* Set the tx_power_user_lmt to the lowest power level
-	 * this value will get overwritten by channel max power avg
-	 * from eeprom */
-	priv->tx_power_user_lmt = IWL_TX_POWER_TARGET_POWER_MIN;
-
-	ret = iwl_init_channel_map(priv);
-	if (ret) {
-		IWL_ERR(priv, "initializing regulatory failed: %d\n", ret);
-		goto err;
-	}
-
-	ret = iwlcore_init_geos(priv);
-	if (ret) {
-		IWL_ERR(priv, "initializing geos failed: %d\n", ret);
-		goto err_free_channel_map;
-	}
-	iwlcore_init_hw_rates(priv, priv->ieee_rates);
-
-	return 0;
-
-err_free_channel_map:
-	iwl_free_channel_map(priv);
-err:
-	return ret;
-}
-EXPORT_SYMBOL(iwl_init_drv);
-
 int iwl_set_tx_power(struct iwl_priv *priv, s8 tx_power, bool force)
 {
 	int ret = 0;
@@ -1681,15 +1597,6 @@ int iwl_set_tx_power(struct iwl_priv *priv, s8 tx_power, bool force)
 }
 EXPORT_SYMBOL(iwl_set_tx_power);
 
-void iwl_uninit_drv(struct iwl_priv *priv)
-{
-	iwl_calib_free_results(priv);
-	iwlcore_free_geos(priv);
-	iwl_free_channel_map(priv);
-	kfree(priv->scan);
-}
-EXPORT_SYMBOL(iwl_uninit_drv);
-
 #define ICT_COUNT (PAGE_SIZE/sizeof(u32))
 
 /* Free dram table */
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index b875dcf..ddf0998 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -316,8 +316,6 @@ void iwl_configure_filter(struct ieee80211_hw *hw,
 			  unsigned int *total_flags, u64 multicast);
 int iwl_hw_nic_init(struct iwl_priv *priv);
 int iwl_set_hw_params(struct iwl_priv *priv);
-int iwl_init_drv(struct iwl_priv *priv);
-void iwl_uninit_drv(struct iwl_priv *priv);
 bool iwl_is_monitor_mode(struct iwl_priv *priv);
 void iwl_post_associate(struct iwl_priv *priv);
 void iwl_bss_info_changed(struct ieee80211_hw *hw,
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index 4fca65a..1eb0d0b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -401,6 +401,7 @@ void iwl_init_scan_params(struct iwl_priv *priv)
 	if (!priv->scan_tx_ant[IEEE80211_BAND_2GHZ])
 		priv->scan_tx_ant[IEEE80211_BAND_2GHZ] = ant_idx;
 }
+EXPORT_SYMBOL(iwl_init_scan_params);
 
 static int iwl_scan_initiate(struct iwl_priv *priv)
 {
-- 
1.5.6.3

