Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:63540 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753736AbYJ2VF0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2008 17:05:26 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net, "Zhu, Yi" <yi.zhu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 3/7] iwlwifi: fix priv->iw_mode setting when multiple vif are configured
Date: Wed, 29 Oct 2008 14:05:45 -0700
Message-Id: <1225314349-11139-4-git-send-email-reinette.chatre@intel.com> (sfid-20081029_220536_053281_4C1C9A8E)
In-Reply-To: <1225314349-11139-3-git-send-email-reinette.chatre@intel.com>
References: <>
 <1225314349-11139-1-git-send-email-reinette.chatre@intel.com>
 <1225314349-11139-2-git-send-email-reinette.chatre@intel.com>
 <1225314349-11139-3-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Zhu, Yi <yi.zhu@intel.com>

mac80211 supports multiple virtual interfaces for a single device. For
example, a managed interface (wlan0) and a monitor interface (mon0) can
exist at the same time. Thus priv->iw_mode is not sufficient to track
the wireless mode any more. The patch redefines priv->iw_mode as the
first interface mode (the same as priv->vif->type if priv->vif != NULL).
If another monitor type interface is created later, we don't change
priv->iw_mode into monitor. This way, the original interface still
works. The patch also requests mac80211 to do reassociation after we
change the Rx filter flags.

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   15 +++++++--------
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   18 +++++++++---------
 2 files changed, 16 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 89450e3..3eb3fea 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -727,13 +727,13 @@ static void iwl_set_flags_for_band(struct iwl_priv *priv,
 /*
  * initialize rxon structure with default values from eeprom
  */
-static void iwl4965_connection_init_rx_config(struct iwl_priv *priv)
+static void iwl4965_connection_init_rx_config(struct iwl_priv *priv, int mode)
 {
 	const struct iwl_channel_info *ch_info;
 
 	memset(&priv->staging_rxon, 0, sizeof(priv->staging_rxon));
 
-	switch (priv->iw_mode) {
+	switch (mode) {
 	case NL80211_IFTYPE_AP:
 		priv->staging_rxon.dev_type = RXON_DEV_TYPE_AP;
 		break;
@@ -756,7 +756,7 @@ static void iwl4965_connection_init_rx_config(struct iwl_priv *priv)
 		    RXON_FILTER_CTL2HOST_MSK | RXON_FILTER_ACCEPT_GRP_MSK;
 		break;
 	default:
-		IWL_ERROR("Unsupported interface type %d\n", priv->iw_mode);
+		IWL_ERROR("Unsupported interface type %d\n", mode);
 		break;
 	}
 
@@ -804,9 +804,7 @@ static void iwl4965_connection_init_rx_config(struct iwl_priv *priv)
 
 static int iwl4965_set_mode(struct iwl_priv *priv, int mode)
 {
-	priv->iw_mode = mode;
-
-	iwl4965_connection_init_rx_config(priv);
+	iwl4965_connection_init_rx_config(priv, mode);
 	memcpy(priv->staging_rxon.node_addr, priv->mac_addr, ETH_ALEN);
 
 	iwl_clear_stations_table(priv);
@@ -2060,7 +2058,7 @@ static void iwl_alive_start(struct iwl_priv *priv)
 		active_rxon->filter_flags &= ~RXON_FILTER_ASSOC_MSK;
 	} else {
 		/* Initialize our rx_config data */
-		iwl4965_connection_init_rx_config(priv);
+		iwl4965_connection_init_rx_config(priv, priv->iw_mode);
 		memcpy(priv->staging_rxon.node_addr, priv->mac_addr, ETH_ALEN);
 	}
 
@@ -2384,7 +2382,6 @@ static void iwl4965_bg_set_monitor(struct work_struct *work)
 	mutex_lock(&priv->mutex);
 
 	ret = iwl4965_set_mode(priv, NL80211_IFTYPE_MONITOR);
-
 	if (ret) {
 		if (ret == -EAGAIN)
 			IWL_DEBUG(IWL_DL_STATE, "leave - not ready\n");
@@ -2393,6 +2390,7 @@ static void iwl4965_bg_set_monitor(struct work_struct *work)
 	}
 
 	mutex_unlock(&priv->mutex);
+	ieee80211_notify_mac(priv->hw, IEEE80211_NOTIFY_RE_ASSOC);
 }
 
 static void iwl_bg_run_time_calib_work(struct work_struct *work)
@@ -2727,6 +2725,7 @@ static int iwl4965_mac_add_interface(struct ieee80211_hw *hw,
 
 	spin_lock_irqsave(&priv->lock, flags);
 	priv->vif = conf->vif;
+	priv->iw_mode = conf->type;
 
 	spin_unlock_irqrestore(&priv->lock, flags);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 0758f8f..9c49416 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -2191,13 +2191,14 @@ static void iwl3945_set_flags_for_phymode(struct iwl3945_priv *priv,
 /*
  * initialize rxon structure with default values from eeprom
  */
-static void iwl3945_connection_init_rx_config(struct iwl3945_priv *priv)
+static void iwl3945_connection_init_rx_config(struct iwl3945_priv *priv,
+					      int mode)
 {
 	const struct iwl3945_channel_info *ch_info;
 
 	memset(&priv->staging_rxon, 0, sizeof(priv->staging_rxon));
 
-	switch (priv->iw_mode) {
+	switch (mode) {
 	case NL80211_IFTYPE_AP:
 		priv->staging_rxon.dev_type = RXON_DEV_TYPE_AP;
 		break;
@@ -2220,7 +2221,7 @@ static void iwl3945_connection_init_rx_config(struct iwl3945_priv *priv)
 		    RXON_FILTER_CTL2HOST_MSK | RXON_FILTER_ACCEPT_GRP_MSK;
 		break;
 	default:
-		IWL_ERROR("Unsupported interface type %d\n", priv->iw_mode);
+		IWL_ERROR("Unsupported interface type %d\n", mode);
 		break;
 	}
 
@@ -2243,8 +2244,7 @@ static void iwl3945_connection_init_rx_config(struct iwl3945_priv *priv)
 	 * in some case A channels are all non IBSS
 	 * in this case force B/G channel
 	 */
-	if ((priv->iw_mode == NL80211_IFTYPE_ADHOC) &&
-	    !(is_channel_ibss(ch_info)))
+	if ((mode == NL80211_IFTYPE_ADHOC) && !(is_channel_ibss(ch_info)))
 		ch_info = &priv->channel_info[0];
 
 	priv->staging_rxon.channel = cpu_to_le16(ch_info->channel);
@@ -2277,9 +2277,7 @@ static int iwl3945_set_mode(struct iwl3945_priv *priv, int mode)
 		}
 	}
 
-	priv->iw_mode = mode;
-
-	iwl3945_connection_init_rx_config(priv);
+	iwl3945_connection_init_rx_config(priv, mode);
 	memcpy(priv->staging_rxon.node_addr, priv->mac_addr, ETH_ALEN);
 
 	iwl3945_clear_stations_table(priv);
@@ -5709,7 +5707,7 @@ static void iwl3945_alive_start(struct iwl3945_priv *priv)
 		active_rxon->filter_flags &= ~RXON_FILTER_ASSOC_MSK;
 	} else {
 		/* Initialize our rx_config data */
-		iwl3945_connection_init_rx_config(priv);
+		iwl3945_connection_init_rx_config(priv, priv->iw_mode);
 		memcpy(priv->staging_rxon.node_addr, priv->mac_addr, ETH_ALEN);
 	}
 
@@ -6025,6 +6023,7 @@ static void iwl3945_bg_set_monitor(struct work_struct *work)
 			IWL_ERROR("iwl3945_set_mode() failed\n");
 
 	mutex_unlock(&priv->mutex);
+	ieee80211_notify_mac(priv->hw, IEEE80211_NOTIFY_RE_ASSOC);
 }
 
 #define IWL_SCAN_CHECK_WATCHDOG (7 * HZ)
@@ -6566,6 +6565,7 @@ static int iwl3945_mac_add_interface(struct ieee80211_hw *hw,
 
 	spin_lock_irqsave(&priv->lock, flags);
 	priv->vif = conf->vif;
+	priv->iw_mode = conf->type;
 
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-- 
1.5.4.3

