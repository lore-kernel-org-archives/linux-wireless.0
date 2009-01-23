Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:34241 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755785AbZAWVmv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 16:42:51 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Samuel Ortiz <samuel.ortiz@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 08/15] iwl3945: Use the iwlcore geos routines
Date: Fri, 23 Jan 2009 13:45:16 -0800
Message-Id: <1232747123-7261-9-git-send-email-reinette.chatre@intel.com> (sfid-20090123_224301_348911_E6AA6D15)
In-Reply-To: <1232747123-7261-8-git-send-email-reinette.chatre@intel.com>
References: <>
 <1232747123-7261-1-git-send-email-reinette.chatre@intel.com>
 <1232747123-7261-2-git-send-email-reinette.chatre@intel.com>
 <1232747123-7261-3-git-send-email-reinette.chatre@intel.com>
 <1232747123-7261-4-git-send-email-reinette.chatre@intel.com>
 <1232747123-7261-5-git-send-email-reinette.chatre@intel.com>
 <1232747123-7261-6-git-send-email-reinette.chatre@intel.com>
 <1232747123-7261-7-git-send-email-reinette.chatre@intel.com>
 <1232747123-7261-8-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Samuel Ortiz <samuel.ortiz@intel.com>

By removing the init_rates() routine outside of the init_geos() one, we can
share the geos routines between 3945 and agn.

Signed-off-by: Samuel Ortiz <samuel.ortiz@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c     |    9 +-
 drivers/net/wireless/iwlwifi/iwl-core.h     |    5 +
 drivers/net/wireless/iwlwifi/iwl3945-base.c |  145 ++-------------------------
 3 files changed, 21 insertions(+), 138 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index b64377e..902b75f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -406,7 +406,7 @@ static void iwlcore_init_hw_rates(struct iwl_priv *priv,
 /**
  * iwlcore_init_geos - Initialize mac80211's geo/channel info based from eeprom
  */
-static int iwlcore_init_geos(struct iwl_priv *priv)
+int iwlcore_init_geos(struct iwl_priv *priv)
 {
 	struct iwl_channel_info *ch;
 	struct ieee80211_supported_band *sband;
@@ -458,8 +458,6 @@ static int iwlcore_init_geos(struct iwl_priv *priv)
 	priv->ieee_channels = channels;
 	priv->ieee_rates = rates;
 
-	iwlcore_init_hw_rates(priv, rates);
-
 	for (i = 0;  i < priv->channel_count; i++) {
 		ch = &priv->channel_info[i];
 
@@ -526,16 +524,18 @@ static int iwlcore_init_geos(struct iwl_priv *priv)
 
 	return 0;
 }
+EXPORT_SYMBOL(iwlcore_init_geos);
 
 /*
  * iwlcore_free_geos - undo allocations in iwlcore_init_geos
  */
-static void iwlcore_free_geos(struct iwl_priv *priv)
+void iwlcore_free_geos(struct iwl_priv *priv)
 {
 	kfree(priv->ieee_channels);
 	kfree(priv->ieee_rates);
 	clear_bit(STATUS_GEO_CONFIGURED, &priv->status);
 }
+EXPORT_SYMBOL(iwlcore_free_geos);
 
 static bool is_single_rx_stream(struct iwl_priv *priv)
 {
@@ -936,6 +936,7 @@ int iwl_init_drv(struct iwl_priv *priv)
 		IWL_ERR(priv, "initializing geos failed: %d\n", ret);
 		goto err_free_channel_map;
 	}
+	iwlcore_init_hw_rates(priv, priv->ieee_rates);
 
 	return 0;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 9a35080..0c6250c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -395,6 +395,11 @@ void iwl_enable_interrupts(struct iwl_priv *priv);
 void iwl_dump_nic_error_log(struct iwl_priv *priv);
 void iwl_dump_nic_event_log(struct iwl_priv *priv);
 
+/*****************************************************
+*  GEOS
+******************************************************/
+int iwlcore_init_geos(struct iwl_priv *priv);
+void iwlcore_free_geos(struct iwl_priv *priv);
 
 /*************** DRIVER STATUS FUNCTIONS   *****/
 
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index b57c2b8..5fa5cb2 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -3383,137 +3383,6 @@ static void iwl3945_init_hw_rates(struct iwl_priv *priv,
 	}
 }
 
-/**
- * iwl3945_init_geos - Initialize mac80211's geo/channel info based from eeprom
- */
-#define IEEE80211_24GHZ_MAX_CHANNEL 14
-static int iwl3945_init_geos(struct iwl_priv *priv)
-{
-	struct iwl_channel_info *ch;
-	struct ieee80211_supported_band *sband;
-	struct ieee80211_channel *channels;
-	struct ieee80211_channel *geo_ch;
-	struct ieee80211_rate *rates;
-	int i = 0;
-
-	if (priv->bands[IEEE80211_BAND_2GHZ].n_bitrates ||
-	    priv->bands[IEEE80211_BAND_5GHZ].n_bitrates) {
-		IWL_DEBUG_INFO("Geography modes already initialized.\n");
-		set_bit(STATUS_GEO_CONFIGURED, &priv->status);
-		return 0;
-	}
-
-	channels = kzalloc(sizeof(struct ieee80211_channel) *
-			   priv->channel_count, GFP_KERNEL);
-	if (!channels)
-		return -ENOMEM;
-
-	rates = kzalloc((sizeof(struct ieee80211_rate) * (IWL_RATE_COUNT + 1)),
-			GFP_KERNEL);
-	if (!rates) {
-		kfree(channels);
-		return -ENOMEM;
-	}
-
-	/* 5.2GHz channels start after the 2.4GHz channels */
-	sband = &priv->bands[IEEE80211_BAND_5GHZ];
-	sband->channels = &channels[IEEE80211_24GHZ_MAX_CHANNEL];
-	/* just OFDM */
-	sband->bitrates = &rates[IWL_FIRST_OFDM_RATE];
-	sband->n_bitrates = IWL_RATE_COUNT - IWL_FIRST_OFDM_RATE;
-
-	sband = &priv->bands[IEEE80211_BAND_2GHZ];
-	sband->channels = channels;
-	/* OFDM & CCK */
-	sband->bitrates = rates;
-	sband->n_bitrates = IWL_RATE_COUNT;
-
-	priv->ieee_channels = channels;
-	priv->ieee_rates = rates;
-
-	iwl3945_init_hw_rates(priv, rates);
-
-	for (i = 0;  i < priv->channel_count; i++) {
-		ch = &priv->channel_info[i];
-
-		/* FIXME: might be removed if scan is OK*/
-		if (!is_channel_valid(ch))
-			continue;
-
-		if (is_channel_a_band(ch))
-			sband =  &priv->bands[IEEE80211_BAND_5GHZ];
-		else
-			sband =  &priv->bands[IEEE80211_BAND_2GHZ];
-
-		geo_ch = &sband->channels[sband->n_channels++];
-
-		geo_ch->center_freq = ieee80211_channel_to_frequency(ch->channel);
-		geo_ch->max_power = ch->max_power_avg;
-		geo_ch->max_antenna_gain = 0xff;
-		geo_ch->hw_value = ch->channel;
-
-		if (is_channel_valid(ch)) {
-			if (!(ch->flags & EEPROM_CHANNEL_IBSS))
-				geo_ch->flags |= IEEE80211_CHAN_NO_IBSS;
-
-			if (!(ch->flags & EEPROM_CHANNEL_ACTIVE))
-				geo_ch->flags |= IEEE80211_CHAN_PASSIVE_SCAN;
-
-			if (ch->flags & EEPROM_CHANNEL_RADAR)
-				geo_ch->flags |= IEEE80211_CHAN_RADAR;
-
-			if (ch->max_power_avg > priv->tx_power_channel_lmt)
-				priv->tx_power_channel_lmt =
-				    ch->max_power_avg;
-		} else {
-			geo_ch->flags |= IEEE80211_CHAN_DISABLED;
-		}
-
-		/* Save flags for reg domain usage */
-		geo_ch->orig_flags = geo_ch->flags;
-
-		IWL_DEBUG_INFO("Channel %d Freq=%d[%sGHz] %s flag=0%X\n",
-				ch->channel, geo_ch->center_freq,
-				is_channel_a_band(ch) ?  "5.2" : "2.4",
-				geo_ch->flags & IEEE80211_CHAN_DISABLED ?
-				"restricted" : "valid",
-				 geo_ch->flags);
-	}
-
-	if ((priv->bands[IEEE80211_BAND_5GHZ].n_channels == 0) &&
-	     priv->cfg->sku & IWL_SKU_A) {
-		IWL_INFO(priv, "Incorrectly detected BG card as ABG. "
-			"Please send your PCI ID 0x%04X:0x%04X to maintainer.\n",
-			priv->pci_dev->device, priv->pci_dev->subsystem_device);
-		 priv->cfg->sku &= ~IWL_SKU_A;
-	}
-
-	IWL_INFO(priv, "Tunable channels: %d 802.11bg, %d 802.11a channels\n",
-	       priv->bands[IEEE80211_BAND_2GHZ].n_channels,
-	       priv->bands[IEEE80211_BAND_5GHZ].n_channels);
-
-	if (priv->bands[IEEE80211_BAND_2GHZ].n_channels)
-		priv->hw->wiphy->bands[IEEE80211_BAND_2GHZ] =
-			&priv->bands[IEEE80211_BAND_2GHZ];
-	if (priv->bands[IEEE80211_BAND_5GHZ].n_channels)
-		priv->hw->wiphy->bands[IEEE80211_BAND_5GHZ] =
-			&priv->bands[IEEE80211_BAND_5GHZ];
-
-	set_bit(STATUS_GEO_CONFIGURED, &priv->status);
-
-	return 0;
-}
-
-/*
- * iwl3945_free_geos - undo allocations in iwl3945_init_geos
- */
-static void iwl3945_free_geos(struct iwl_priv *priv)
-{
-	kfree(priv->ieee_channels);
-	kfree(priv->ieee_rates);
-	clear_bit(STATUS_GEO_CONFIGURED, &priv->status);
-}
-
 /******************************************************************************
  *
  * uCode download functions
@@ -6144,11 +6013,19 @@ static int iwl3945_init_drv(struct iwl_priv *priv)
 		goto err_free_channel_map;
 	}
 
-	ret = iwl3945_init_geos(priv);
+	ret = iwlcore_init_geos(priv);
 	if (ret) {
 		IWL_ERR(priv, "initializing geos failed: %d\n", ret);
 		goto err_free_channel_map;
 	}
+	iwl3945_init_hw_rates(priv, priv->ieee_rates);
+
+	if (priv->bands[IEEE80211_BAND_2GHZ].n_channels)
+		priv->hw->wiphy->bands[IEEE80211_BAND_2GHZ] =
+			&priv->bands[IEEE80211_BAND_2GHZ];
+	if (priv->bands[IEEE80211_BAND_5GHZ].n_channels)
+		priv->hw->wiphy->bands[IEEE80211_BAND_5GHZ] =
+			&priv->bands[IEEE80211_BAND_5GHZ];
 
 	return 0;
 
@@ -6379,7 +6256,7 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
  out_remove_sysfs:
 	sysfs_remove_group(&pdev->dev.kobj, &iwl3945_attribute_group);
  out_free_geos:
-	iwl3945_free_geos(priv);
+	iwlcore_free_geos(priv);
 
  out_release_irq:
 	free_irq(priv->pci_dev->irq, priv);
@@ -6461,7 +6338,7 @@ static void __devexit iwl3945_pci_remove(struct pci_dev *pdev)
 	pci_set_drvdata(pdev, NULL);
 
 	iwl_free_channel_map(priv);
-	iwl3945_free_geos(priv);
+	iwlcore_free_geos(priv);
 	kfree(priv->scan);
 	if (priv->ibss_beacon)
 		dev_kfree_skb(priv->ibss_beacon);
-- 
1.5.4.3

