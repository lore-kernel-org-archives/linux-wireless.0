Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:23899 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753475AbZB1AQt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Feb 2009 19:16:49 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 5/6] iwl3945: add iwl3945_setup_mac
Date: Fri, 27 Feb 2009 16:21:23 -0800
Message-Id: <1235780484-27979-6-git-send-email-reinette.chatre@intel.com> (sfid-20090228_011656_478775_2C32ABEF)
In-Reply-To: <1235780484-27979-5-git-send-email-reinette.chatre@intel.com>
References: <1235780484-27979-1-git-send-email-reinette.chatre@intel.com>
 <1235780484-27979-2-git-send-email-reinette.chatre@intel.com>
 <1235780484-27979-3-git-send-email-reinette.chatre@intel.com>
 <1235780484-27979-4-git-send-email-reinette.chatre@intel.com>
 <1235780484-27979-5-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>

Patch does following,
1) mac80211's shared data is now initialized in iwl3945_setup_mac.
2) Set the rfkill to right state after initialization

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   74 ++++++++++++++++----------
 1 files changed, 45 insertions(+), 29 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 913d1a5..b667f27 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -5008,19 +5008,53 @@ static int iwl3945_init_drv(struct iwl_priv *priv)
 	}
 	iwl3945_init_hw_rates(priv, priv->ieee_rates);
 
+	return 0;
+
+err_free_channel_map:
+	iwl_free_channel_map(priv);
+err:
+	return ret;
+}
+
+static int iwl3945_setup_mac(struct iwl_priv *priv)
+{
+	int ret;
+	struct ieee80211_hw *hw = priv->hw;
+
+	hw->rate_control_algorithm = "iwl-3945-rs";
+	hw->sta_data_size = sizeof(struct iwl3945_sta_priv);
+
+	/* Tell mac80211 our characteristics */
+	hw->flags = IEEE80211_HW_SIGNAL_DBM |
+		    IEEE80211_HW_NOISE_DBM;
+
+	hw->wiphy->interface_modes =
+		BIT(NL80211_IFTYPE_STATION) |
+		BIT(NL80211_IFTYPE_ADHOC);
+
+	hw->wiphy->custom_regulatory = true;
+
+	/* Default value; 4 EDCA QOS priorities */
+	hw->queues = 4;
+
+	hw->conf.beacon_int = 100;
+
 	if (priv->bands[IEEE80211_BAND_2GHZ].n_channels)
 		priv->hw->wiphy->bands[IEEE80211_BAND_2GHZ] =
 			&priv->bands[IEEE80211_BAND_2GHZ];
+
 	if (priv->bands[IEEE80211_BAND_5GHZ].n_channels)
 		priv->hw->wiphy->bands[IEEE80211_BAND_5GHZ] =
 			&priv->bands[IEEE80211_BAND_5GHZ];
 
-	return 0;
+	ret = ieee80211_register_hw(priv->hw);
+	if (ret) {
+		IWL_ERR(priv, "Failed to register hw (error %d)\n", ret);
+		return ret;
+	}
+	priv->mac80211_registered = 1;
 
-err_free_channel_map:
-	iwl_free_channel_map(priv);
-err:
-	return ret;
+	return 0;
 }
 
 static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
@@ -5074,23 +5108,6 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	priv->debug_level = iwl3945_mod_params.debug;
 	atomic_set(&priv->restrict_refcnt, 0);
 #endif
-	hw->rate_control_algorithm = "iwl-3945-rs";
-	hw->sta_data_size = sizeof(struct iwl3945_sta_priv);
-
-	/* Tell mac80211 our characteristics */
-	hw->flags = IEEE80211_HW_SIGNAL_DBM |
-		    IEEE80211_HW_NOISE_DBM;
-
-	hw->wiphy->interface_modes =
-		BIT(NL80211_IFTYPE_STATION) |
-		BIT(NL80211_IFTYPE_ADHOC);
-
-	hw->wiphy->custom_regulatory = true;
-
-	hw->wiphy->max_scan_ssids = 1;
-
-	/* 4 EDCA QOS priorities */
-	hw->queues = 4;
 
 	/***************************
 	 * 2. Initializing PCI bus
@@ -5221,19 +5238,18 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	 * 9. Setup and Register mac80211
 	 * *******************************/
 
-	err = ieee80211_register_hw(priv->hw);
-	if (err) {
-		IWL_ERR(priv, "Failed to register network device: %d\n", err);
-		goto  out_remove_sysfs;
-	}
+	iwl_enable_interrupts(priv);
 
-	priv->hw->conf.beacon_int = 100;
-	priv->mac80211_registered = 1;
+	err = iwl3945_setup_mac(priv);
+	if (err)
+		goto  out_remove_sysfs;
 
 	err = iwl_rfkill_init(priv);
 	if (err)
 		IWL_ERR(priv, "Unable to initialize RFKILL system. "
 				  "Ignoring error: %d\n", err);
+	else
+		iwl_rfkill_set_hw_state(priv);
 
 	/* Start monitoring the killswitch */
 	queue_delayed_work(priv->workqueue, &priv->rfkill_poll,
-- 
1.5.6.3

