Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:62948 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754647AbZJPVZ6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Oct 2009 17:25:58 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 05/10] iwlwifi: move iwl_setup_mac to iwlagn
Date: Fri, 16 Oct 2009 14:25:53 -0700
Message-Id: <1255728358-29976-6-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1255728358-29976-1-git-send-email-reinette.chatre@intel.com>
References: <1255728358-29976-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Reinette Chatre <reinette.chatre@intel.com>

This function is only used in iwlagn so there is no need to have it in
iwlcore.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c  |   62 +++++++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-core.c |   58 -----------------------------
 drivers/net/wireless/iwlwifi/iwl-core.h |    1 -
 3 files changed, 62 insertions(+), 59 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 401295c..c3e7101 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2285,6 +2285,68 @@ void iwl_post_associate(struct iwl_priv *priv)
 
 #define UCODE_READY_TIMEOUT	(4 * HZ)
 
+/*
+ * Not a mac80211 entry point function, but it fits in with all the
+ * other mac80211 functions grouped here.
+ */
+static int iwl_setup_mac(struct iwl_priv *priv)
+{
+	int ret;
+	struct ieee80211_hw *hw = priv->hw;
+	hw->rate_control_algorithm = "iwl-agn-rs";
+
+	/* Tell mac80211 our characteristics */
+	hw->flags = IEEE80211_HW_SIGNAL_DBM |
+		    IEEE80211_HW_NOISE_DBM |
+		    IEEE80211_HW_AMPDU_AGGREGATION |
+		    IEEE80211_HW_SPECTRUM_MGMT;
+
+	if (!priv->cfg->broken_powersave)
+		hw->flags |= IEEE80211_HW_SUPPORTS_PS |
+			     IEEE80211_HW_SUPPORTS_DYNAMIC_PS;
+
+	hw->wiphy->interface_modes =
+		BIT(NL80211_IFTYPE_STATION) |
+		BIT(NL80211_IFTYPE_ADHOC);
+
+	hw->wiphy->custom_regulatory = true;
+
+	/* Firmware does not support this */
+	hw->wiphy->disable_beacon_hints = true;
+
+	/*
+	 * For now, disable PS by default because it affects
+	 * RX performance significantly.
+	 */
+	hw->wiphy->ps_default = false;
+
+	hw->wiphy->max_scan_ssids = PROBE_OPTION_MAX;
+	/* we create the 802.11 header and a zero-length SSID element */
+	hw->wiphy->max_scan_ie_len = IWL_MAX_PROBE_REQUEST - 24 - 2;
+
+	/* Default value; 4 EDCA QOS priorities */
+	hw->queues = 4;
+
+	hw->max_listen_interval = IWL_CONN_MAX_LISTEN_INTERVAL;
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
+		IWL_ERR(priv, "Failed to register hw (error %d)\n", ret);
+		return ret;
+	}
+	priv->mac80211_registered = 1;
+
+	return 0;
+}
+
+
 static int iwl_mac_start(struct ieee80211_hw *hw)
 {
 	struct iwl_priv *priv = hw->priv;
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index ad62673..42c0496 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1430,64 +1430,6 @@ void iwl_configure_filter(struct ieee80211_hw *hw,
 }
 EXPORT_SYMBOL(iwl_configure_filter);
 
-int iwl_setup_mac(struct iwl_priv *priv)
-{
-	int ret;
-	struct ieee80211_hw *hw = priv->hw;
-	hw->rate_control_algorithm = "iwl-agn-rs";
-
-	/* Tell mac80211 our characteristics */
-	hw->flags = IEEE80211_HW_SIGNAL_DBM |
-		    IEEE80211_HW_NOISE_DBM |
-		    IEEE80211_HW_AMPDU_AGGREGATION |
-		    IEEE80211_HW_SPECTRUM_MGMT;
-
-	if (!priv->cfg->broken_powersave)
-		hw->flags |= IEEE80211_HW_SUPPORTS_PS |
-			     IEEE80211_HW_SUPPORTS_DYNAMIC_PS;
-
-	hw->wiphy->interface_modes =
-		BIT(NL80211_IFTYPE_STATION) |
-		BIT(NL80211_IFTYPE_ADHOC);
-
-	hw->wiphy->custom_regulatory = true;
-
-	/* Firmware does not support this */
-	hw->wiphy->disable_beacon_hints = true;
-
-	/*
-	 * For now, disable PS by default because it affects
-	 * RX performance significantly.
-	 */
-	hw->wiphy->ps_default = false;
-
-	hw->wiphy->max_scan_ssids = PROBE_OPTION_MAX;
-	/* we create the 802.11 header and a zero-length SSID element */
-	hw->wiphy->max_scan_ie_len = IWL_MAX_PROBE_REQUEST - 24 - 2;
-
-	/* Default value; 4 EDCA QOS priorities */
-	hw->queues = 4;
-
-	hw->max_listen_interval = IWL_CONN_MAX_LISTEN_INTERVAL;
-
-	if (priv->bands[IEEE80211_BAND_2GHZ].n_channels)
-		priv->hw->wiphy->bands[IEEE80211_BAND_2GHZ] =
-			&priv->bands[IEEE80211_BAND_2GHZ];
-	if (priv->bands[IEEE80211_BAND_5GHZ].n_channels)
-		priv->hw->wiphy->bands[IEEE80211_BAND_5GHZ] =
-			&priv->bands[IEEE80211_BAND_5GHZ];
-
-	ret = ieee80211_register_hw(priv->hw);
-	if (ret) {
-		IWL_ERR(priv, "Failed to register hw (error %d)\n", ret);
-		return ret;
-	}
-	priv->mac80211_registered = 1;
-
-	return 0;
-}
-EXPORT_SYMBOL(iwl_setup_mac);
-
 int iwl_set_hw_params(struct iwl_priv *priv)
 {
 	priv->hw_params.max_rxq_size = RX_QUEUE_SIZE;
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index b877f88..a2a580d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -305,7 +305,6 @@ void iwl_configure_filter(struct ieee80211_hw *hw,
 			  unsigned int changed_flags,
 			  unsigned int *total_flags, u64 multicast);
 int iwl_hw_nic_init(struct iwl_priv *priv);
-int iwl_setup_mac(struct iwl_priv *priv);
 int iwl_set_hw_params(struct iwl_priv *priv);
 int iwl_init_drv(struct iwl_priv *priv);
 void iwl_uninit_drv(struct iwl_priv *priv);
-- 
1.5.6.3

