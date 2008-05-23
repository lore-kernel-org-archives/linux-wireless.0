Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:42800 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759294AbYEWCLe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2008 22:11:34 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH] iwlwifi: refactor pci prob flow
Date: Fri, 23 May 2008 10:09:03 +0800
Message-Id: <1211508569-3163-26-git-send-email-yi.zhu@intel.com> (sfid-20080523_042833_018144_B01910CE)
In-Reply-To: <1211508569-3163-25-git-send-email-yi.zhu@intel.com>
References: <1211508569-3163-1-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-2-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-3-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-4-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-5-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-6-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-7-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-8-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-9-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-10-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-11-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-12-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-13-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-14-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-15-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-16-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-17-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-18-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-19-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-20-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-21-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-22-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-23-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-24-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-25-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch refactores pci prob flow. It moves mac80211 registration
to the end, otherwise there is a race between error path in pci_probe
and mac_start.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c     |   61 ++++++++++++++------------
 drivers/net/wireless/iwlwifi/iwl-core.h     |    6 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom.c   |    1 -
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   31 ++++++++------
 4 files changed, 54 insertions(+), 45 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 79e46c5..21f481e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -518,12 +518,6 @@ static int iwlcore_init_geos(struct iwl_priv *priv)
 	       priv->bands[IEEE80211_BAND_2GHZ].n_channels,
 	       priv->bands[IEEE80211_BAND_5GHZ].n_channels);
 
-	if (priv->bands[IEEE80211_BAND_2GHZ].n_channels)
-		priv->hw->wiphy->bands[IEEE80211_BAND_2GHZ] =
-			&priv->bands[IEEE80211_BAND_2GHZ];
-	if (priv->bands[IEEE80211_BAND_5GHZ].n_channels)
-		priv->hw->wiphy->bands[IEEE80211_BAND_5GHZ] =
-			&priv->bands[IEEE80211_BAND_5GHZ];
 
 	set_bit(STATUS_GEO_CONFIGURED, &priv->status);
 
@@ -533,13 +527,12 @@ static int iwlcore_init_geos(struct iwl_priv *priv)
 /*
  * iwlcore_free_geos - undo allocations in iwlcore_init_geos
  */
-void iwlcore_free_geos(struct iwl_priv *priv)
+static void iwlcore_free_geos(struct iwl_priv *priv)
 {
 	kfree(priv->ieee_channels);
 	kfree(priv->ieee_rates);
 	clear_bit(STATUS_GEO_CONFIGURED, &priv->status);
 }
-EXPORT_SYMBOL(iwlcore_free_geos);
 
 #ifdef CONFIG_IWL4965_HT
 static u8 is_single_rx_stream(struct iwl_priv *priv)
@@ -767,8 +760,9 @@ int iwl_set_rxon_channel(struct iwl_priv *priv,
 }
 EXPORT_SYMBOL(iwl_set_rxon_channel);
 
-static void iwlcore_init_hw(struct iwl_priv *priv)
+int iwl_setup_mac(struct iwl_priv *priv)
 {
+	int ret;
 	struct ieee80211_hw *hw = priv->hw;
 	hw->rate_control_algorithm = "iwl-4965-rs";
 
@@ -782,9 +776,29 @@ static void iwlcore_init_hw(struct iwl_priv *priv)
 	/* Enhanced value; more queues, to support 11n aggregation */
 	hw->ampdu_queues = 12;
 #endif /* CONFIG_IWL4965_HT */
+
+	hw->conf.beacon_int = 100;
+
+	if (priv->bands[IEEE80211_BAND_2GHZ].n_channels)
+		priv->hw->wiphy->bands[IEEE80211_BAND_2GHZ] =
+			&priv->bands[IEEE80211_BAND_2GHZ];
+	if (priv->bands[IEEE80211_BAND_5GHZ].n_channels)
+		priv->hw->wiphy->bands[IEEE80211_BAND_5GHZ] =
+			&priv->bands[IEEE80211_BAND_5GHZ];
+
+	ret = ieee80211_register_hw(priv->hw);
+	if (ret) {
+		IWL_ERROR("Failed to register hw (error %d)\n", ret);
+		return ret;
+	}
+	priv->mac80211_registered = 1;
+
+	return 0;
 }
+EXPORT_SYMBOL(iwl_setup_mac);
+
 
-static int iwlcore_init_drv(struct iwl_priv *priv)
+int iwl_init_drv(struct iwl_priv *priv)
 {
 	int ret;
 	int i;
@@ -821,6 +835,9 @@ static int iwlcore_init_drv(struct iwl_priv *priv)
 	/* Choose which receivers/antennas to use */
 	iwl_set_rxon_chain(priv);
 
+	if (priv->cfg->mod_params->enable_qos)
+		priv->qos_data.qos_enable = 1;
+
 	iwl_reset_qos(priv);
 
 	priv->qos_data.qos_active = 0;
@@ -845,34 +862,22 @@ static int iwlcore_init_drv(struct iwl_priv *priv)
 		goto err_free_channel_map;
 	}
 
-	ret = ieee80211_register_hw(priv->hw);
-	if (ret) {
-		IWL_ERROR("Failed to register network device (error %d)\n",
-				ret);
-		goto err_free_geos;
-	}
-
-	priv->hw->conf.beacon_int = 100;
-	priv->mac80211_registered = 1;
-
 	return 0;
 
-err_free_geos:
-	iwlcore_free_geos(priv);
 err_free_channel_map:
 	iwl_free_channel_map(priv);
 err:
 	return ret;
 }
+EXPORT_SYMBOL(iwl_init_drv);
+
 
-int iwl_setup(struct iwl_priv *priv)
+void iwl_uninit_drv(struct iwl_priv *priv)
 {
-	int ret = 0;
-	iwlcore_init_hw(priv);
-	ret = iwlcore_init_drv(priv);
-	return ret;
+	iwlcore_free_geos(priv);
+	iwl_free_channel_map(priv);
 }
-EXPORT_SYMBOL(iwl_setup);
+EXPORT_SYMBOL(iwl_uninit_drv);
 
 /* Low level driver call this function to update iwlcore with
  * driver status.
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index b159fd3..774aa7c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -175,13 +175,13 @@ void iwl_set_rxon_chain(struct iwl_priv *priv);
 int iwl_set_rxon_channel(struct iwl_priv *priv,
 				enum ieee80211_band band,
 				u16 channel);
-void iwlcore_free_geos(struct iwl_priv *priv);
-int iwl_setup(struct iwl_priv *priv);
 void iwl_set_rxon_ht(struct iwl_priv *priv, struct iwl_ht_info *ht_info);
 u8 iwl_is_fat_tx_allowed(struct iwl_priv *priv,
 			 struct ieee80211_ht_info *sta_ht_inf);
 int iwl_hw_nic_init(struct iwl_priv *priv);
-
+int iwl_setup_mac(struct iwl_priv *priv);
+int iwl_init_drv(struct iwl_priv *priv);
+void iwl_uninit_drv(struct iwl_priv *priv);
 /* "keep warm" functions */
 int iwl_kw_init(struct iwl_priv *priv);
 int iwl_kw_alloc(struct iwl_priv *priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
index 300ef8e..e559c19 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
@@ -567,7 +567,6 @@ void iwl_free_channel_map(struct iwl_priv *priv)
 	kfree(priv->channel_info);
 	priv->channel_count = 0;
 }
-EXPORT_SYMBOL(iwl_free_channel_map);
 
 /**
  * iwl_get_channel_info - Find driver's private channel info
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index e06142d..05edde1 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -5878,10 +5878,10 @@ static int iwl4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	}
 
 	/*******************
-	 * 6. Setup hw/priv
+	 * 6. Setup priv
 	 *******************/
 
-	err = iwl_setup(priv);
+	err = iwl_init_drv(priv);
 	if (err)
 		goto out_free_eeprom;
 	/* At this point both hw and priv are initialized. */
@@ -5896,9 +5896,6 @@ static int iwl4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 		IWL_DEBUG_INFO("Radio disabled.\n");
 	}
 
-	if (priv->cfg->mod_params->enable_qos)
-		priv->qos_data.qos_enable = 1;
-
 	/********************
 	 * 8. Setup services
 	 ********************/
@@ -5909,14 +5906,9 @@ static int iwl4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	err = sysfs_create_group(&pdev->dev.kobj, &iwl4965_attribute_group);
 	if (err) {
 		IWL_ERROR("failed to create sysfs device attributes\n");
-		goto out_free_eeprom;
+		goto out_uninit_drv;
 	}
 
-	err = iwl_dbgfs_register(priv, DRV_NAME);
-	if (err) {
-		IWL_ERROR("failed to create debugfs files\n");
-		goto out_remove_sysfs;
-	}
 
 	iwl4965_setup_deferred_work(priv);
 	iwl4965_setup_rx_handlers(priv);
@@ -5927,12 +5919,26 @@ static int iwl4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	pci_save_state(pdev);
 	pci_disable_device(pdev);
 
+	/**********************************
+	 * 10. Setup and register mac80211
+	 **********************************/
+
+	err = iwl_setup_mac(priv);
+	if (err)
+		goto out_remove_sysfs;
+
+	err = iwl_dbgfs_register(priv, DRV_NAME);
+	if (err)
+		IWL_ERROR("failed to create debugfs files\n");
+
 	/* notify iwlcore to init */
 	iwlcore_low_level_notify(priv, IWLCORE_INIT_EVT);
 	return 0;
 
  out_remove_sysfs:
 	sysfs_remove_group(&pdev->dev.kobj, &iwl4965_attribute_group);
+ out_uninit_drv:
+	iwl_uninit_drv(priv);
  out_free_eeprom:
 	iwl_eeprom_free(priv);
  out_iounmap:
@@ -6014,8 +6020,7 @@ static void __devexit iwl4965_pci_remove(struct pci_dev *pdev)
 	pci_disable_device(pdev);
 	pci_set_drvdata(pdev, NULL);
 
-	iwl_free_channel_map(priv);
-	iwlcore_free_geos(priv);
+	iwl_uninit_drv(priv);
 
 	if (priv->ibss_beacon)
 		dev_kfree_skb(priv->ibss_beacon);
-- 
1.5.3.6

