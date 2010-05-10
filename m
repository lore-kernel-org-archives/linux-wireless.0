Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:50740 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756536Ab0EJW23 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 May 2010 18:28:29 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 28/47] iwlwifi: push virtual interface through
Date: Mon, 10 May 2010 15:27:59 -0700
Message-Id: <1273530498-11876-29-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1273530498-11876-1-git-send-email-reinette.chatre@intel.com>
References: <1273530498-11876-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Rather than keeping every bit of information
around in priv and the virtual interface, add
a virtual interface to many functions and use
the information directly from it.

This removes beacon_int, assoc_capability and
assoc_id from struct iwl_priv.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.h     |    8 ++-
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c  |   18 ++++---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   52 +++++++++++-----------
 drivers/net/wireless/iwlwifi/iwl-agn.h      |    2 +-
 drivers/net/wireless/iwlwifi/iwl-core.c     |   54 +++++++++++------------
 drivers/net/wireless/iwlwifi/iwl-core.h     |   25 ++++++-----
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    5 --
 drivers/net/wireless/iwlwifi/iwl-scan.c     |   13 +++---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   63 +++++++++++++--------------
 9 files changed, 118 insertions(+), 122 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index cea824c..8fe24ee 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -261,8 +261,10 @@ void iwl3945_reply_statistics(struct iwl_priv *priv,
 			      struct iwl_rx_mem_buffer *rxb);
 extern void iwl3945_disable_events(struct iwl_priv *priv);
 extern int iwl4965_get_temperature(const struct iwl_priv *priv);
-extern void iwl3945_post_associate(struct iwl_priv *priv);
-extern void iwl3945_config_ap(struct iwl_priv *priv);
+extern void iwl3945_post_associate(struct iwl_priv *priv,
+				   struct ieee80211_vif *vif);
+extern void iwl3945_config_ap(struct iwl_priv *priv,
+			      struct ieee80211_vif *vif);
 
 /**
  * iwl3945_hw_find_station - Find station id for a given BSSID
@@ -288,7 +290,7 @@ extern const struct iwl_channel_info *iwl3945_get_channel_info(
 extern int iwl3945_rs_next_rate(struct iwl_priv *priv, int rate);
 
 /* scanning */
-void iwl3945_request_scan(struct iwl_priv *priv);
+void iwl3945_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif);
 
 /* Requires full declaration of iwl_priv before including */
 #include "iwl-io.h"
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 50ff313..f05e600 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -1114,8 +1114,9 @@ void iwlagn_rx_reply_rx_phy(struct iwl_priv *priv,
 }
 
 static int iwl_get_single_channel_for_scan(struct iwl_priv *priv,
-				     enum ieee80211_band band,
-				     struct iwl_scan_channel *scan_ch)
+					   struct ieee80211_vif *vif,
+					   enum ieee80211_band band,
+					   struct iwl_scan_channel *scan_ch)
 {
 	const struct ieee80211_supported_band *sband;
 	const struct iwl_channel_info *ch_info;
@@ -1131,7 +1132,7 @@ static int iwl_get_single_channel_for_scan(struct iwl_priv *priv,
 	}
 
 	active_dwell = iwl_get_active_dwell_time(priv, band, 0);
-	passive_dwell = iwl_get_passive_dwell_time(priv, band);
+	passive_dwell = iwl_get_passive_dwell_time(priv, band, vif);
 
 	if (passive_dwell <= active_dwell)
 		passive_dwell = active_dwell + 1;
@@ -1180,6 +1181,7 @@ static int iwl_get_single_channel_for_scan(struct iwl_priv *priv,
 }
 
 static int iwl_get_channels_for_scan(struct iwl_priv *priv,
+				     struct ieee80211_vif *vif,
 				     enum ieee80211_band band,
 				     u8 is_active, u8 n_probes,
 				     struct iwl_scan_channel *scan_ch)
@@ -1197,7 +1199,7 @@ static int iwl_get_channels_for_scan(struct iwl_priv *priv,
 		return 0;
 
 	active_dwell = iwl_get_active_dwell_time(priv, band, n_probes);
-	passive_dwell = iwl_get_passive_dwell_time(priv, band);
+	passive_dwell = iwl_get_passive_dwell_time(priv, band, vif);
 
 	if (passive_dwell <= active_dwell)
 		passive_dwell = active_dwell + 1;
@@ -1257,7 +1259,7 @@ static int iwl_get_channels_for_scan(struct iwl_priv *priv,
 	return added;
 }
 
-void iwlagn_request_scan(struct iwl_priv *priv)
+void iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 {
 	struct iwl_host_cmd cmd = {
 		.id = REPLY_SCAN_CMD,
@@ -1343,7 +1345,7 @@ void iwlagn_request_scan(struct iwl_priv *priv)
 
 		IWL_DEBUG_INFO(priv, "Scanning while associated...\n");
 		spin_lock_irqsave(&priv->lock, flags);
-		interval = priv->beacon_int;
+		interval = vif ? vif->bss_conf.beacon_int : 0;
 		spin_unlock_irqrestore(&priv->lock, flags);
 
 		scan->suspend_time = 0;
@@ -1474,12 +1476,12 @@ void iwlagn_request_scan(struct iwl_priv *priv)
 
 	if (priv->is_internal_short_scan) {
 		scan->channel_count =
-			iwl_get_single_channel_for_scan(priv, band,
+			iwl_get_single_channel_for_scan(priv, vif, band,
 				(void *)&scan->data[le16_to_cpu(
 				scan->tx_cmd.len)]);
 	} else {
 		scan->channel_count =
-			iwl_get_channels_for_scan(priv, band,
+			iwl_get_channels_for_scan(priv, vif, band,
 				is_active, n_probes,
 				(void *)&scan->data[le16_to_cpu(
 				scan->tx_cmd.len)]);
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 7c3363a..270635e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2356,7 +2356,7 @@ static void iwl_alive_start(struct iwl_priv *priv)
 		active_rxon->filter_flags &= ~RXON_FILTER_ASSOC_MSK;
 	} else {
 		/* Initialize our rx_config data */
-		iwl_connection_init_rx_config(priv, priv->iw_mode);
+		iwl_connection_init_rx_config(priv, NULL);
 
 		if (priv->cfg->ops->hcmd->set_rxon_chain)
 			priv->cfg->ops->hcmd->set_rxon_chain(priv);
@@ -2729,12 +2729,15 @@ static void iwl_bg_rx_replenish(struct work_struct *data)
 
 #define IWL_DELAY_NEXT_SCAN (HZ*2)
 
-void iwl_post_associate(struct iwl_priv *priv)
+void iwl_post_associate(struct iwl_priv *priv, struct ieee80211_vif *vif)
 {
 	struct ieee80211_conf *conf = NULL;
 	int ret = 0;
 
-	if (priv->iw_mode == NL80211_IFTYPE_AP) {
+	if (!vif || !priv->is_open)
+		return;
+
+	if (vif->type == NL80211_IFTYPE_AP) {
 		IWL_ERR(priv, "%s Should not be called in AP mode\n", __func__);
 		return;
 	}
@@ -2742,10 +2745,6 @@ void iwl_post_associate(struct iwl_priv *priv)
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return;
 
-
-	if (!priv->vif || !priv->is_open)
-		return;
-
 	iwl_scan_cancel_timeout(priv, 200);
 
 	conf = ieee80211_get_hw_conf(priv->hw);
@@ -2753,7 +2752,7 @@ void iwl_post_associate(struct iwl_priv *priv)
 	priv->staging_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
 	iwlcore_commit_rxon(priv);
 
-	iwl_setup_rxon_timing(priv);
+	iwl_setup_rxon_timing(priv, vif);
 	ret = iwl_send_cmd_pdu(priv, REPLY_RXON_TIMING,
 			      sizeof(priv->rxon_timing), &priv->rxon_timing);
 	if (ret)
@@ -2767,43 +2766,41 @@ void iwl_post_associate(struct iwl_priv *priv)
 	if (priv->cfg->ops->hcmd->set_rxon_chain)
 		priv->cfg->ops->hcmd->set_rxon_chain(priv);
 
-	priv->staging_rxon.assoc_id = cpu_to_le16(priv->assoc_id);
+	priv->staging_rxon.assoc_id = cpu_to_le16(vif->bss_conf.aid);
 
 	IWL_DEBUG_ASSOC(priv, "assoc id %d beacon interval %d\n",
-			priv->assoc_id, priv->beacon_int);
+			vif->bss_conf.aid, vif->bss_conf.beacon_int);
 
-	if (priv->assoc_capability & WLAN_CAPABILITY_SHORT_PREAMBLE)
+	if (vif->bss_conf.assoc_capability & WLAN_CAPABILITY_SHORT_PREAMBLE)
 		priv->staging_rxon.flags |= RXON_FLG_SHORT_PREAMBLE_MSK;
 	else
 		priv->staging_rxon.flags &= ~RXON_FLG_SHORT_PREAMBLE_MSK;
 
 	if (priv->staging_rxon.flags & RXON_FLG_BAND_24G_MSK) {
-		if (priv->assoc_capability & WLAN_CAPABILITY_SHORT_SLOT_TIME)
+		if (vif->bss_conf.assoc_capability &
+					WLAN_CAPABILITY_SHORT_SLOT_TIME)
 			priv->staging_rxon.flags |= RXON_FLG_SHORT_SLOT_MSK;
 		else
 			priv->staging_rxon.flags &= ~RXON_FLG_SHORT_SLOT_MSK;
 
-		if (priv->iw_mode == NL80211_IFTYPE_ADHOC)
+		if (vif->type == NL80211_IFTYPE_ADHOC)
 			priv->staging_rxon.flags &= ~RXON_FLG_SHORT_SLOT_MSK;
-
 	}
 
 	iwlcore_commit_rxon(priv);
 
 	IWL_DEBUG_ASSOC(priv, "Associated as %d to: %pM\n",
-			priv->assoc_id, priv->active_rxon.bssid_addr);
+			vif->bss_conf.aid, priv->active_rxon.bssid_addr);
 
-	switch (priv->iw_mode) {
+	switch (vif->type) {
 	case NL80211_IFTYPE_STATION:
 		break;
 	case NL80211_IFTYPE_ADHOC:
-		/* assume default assoc id */
-		priv->assoc_id = 1;
 		iwl_send_beacon_cmd(priv);
 		break;
 	default:
 		IWL_ERR(priv, "%s Should not be called in %d mode\n",
-			  __func__, priv->iw_mode);
+			  __func__, vif->type);
 		break;
 	}
 
@@ -2980,7 +2977,7 @@ static int iwl_mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	return NETDEV_TX_OK;
 }
 
-void iwl_config_ap(struct iwl_priv *priv)
+void iwl_config_ap(struct iwl_priv *priv, struct ieee80211_vif *vif)
 {
 	int ret = 0;
 
@@ -2995,7 +2992,7 @@ void iwl_config_ap(struct iwl_priv *priv)
 		iwlcore_commit_rxon(priv);
 
 		/* RXON Timing */
-		iwl_setup_rxon_timing(priv);
+		iwl_setup_rxon_timing(priv, vif);
 		ret = iwl_send_cmd_pdu(priv, REPLY_RXON_TIMING,
 				sizeof(priv->rxon_timing), &priv->rxon_timing);
 		if (ret)
@@ -3009,9 +3006,10 @@ void iwl_config_ap(struct iwl_priv *priv)
 		if (priv->cfg->ops->hcmd->set_rxon_chain)
 			priv->cfg->ops->hcmd->set_rxon_chain(priv);
 
-		/* FIXME: what should be the assoc_id for AP? */
-		priv->staging_rxon.assoc_id = cpu_to_le16(priv->assoc_id);
-		if (priv->assoc_capability & WLAN_CAPABILITY_SHORT_PREAMBLE)
+		priv->staging_rxon.assoc_id = 0;
+
+		if (vif->bss_conf.assoc_capability &
+						WLAN_CAPABILITY_SHORT_PREAMBLE)
 			priv->staging_rxon.flags |=
 				RXON_FLG_SHORT_PREAMBLE_MSK;
 		else
@@ -3019,15 +3017,15 @@ void iwl_config_ap(struct iwl_priv *priv)
 				~RXON_FLG_SHORT_PREAMBLE_MSK;
 
 		if (priv->staging_rxon.flags & RXON_FLG_BAND_24G_MSK) {
-			if (priv->assoc_capability &
-				WLAN_CAPABILITY_SHORT_SLOT_TIME)
+			if (vif->bss_conf.assoc_capability &
+						WLAN_CAPABILITY_SHORT_SLOT_TIME)
 				priv->staging_rxon.flags |=
 					RXON_FLG_SHORT_SLOT_MSK;
 			else
 				priv->staging_rxon.flags &=
 					~RXON_FLG_SHORT_SLOT_MSK;
 
-			if (priv->iw_mode == NL80211_IFTYPE_ADHOC)
+			if (vif->type == NL80211_IFTYPE_ADHOC)
 				priv->staging_rxon.flags &=
 					~RXON_FLG_SHORT_SLOT_MSK;
 		}
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 4a1e7b2..f52bedb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -171,7 +171,7 @@ static inline bool iwl_is_tx_success(u32 status)
 }
 
 /* scan */
-void iwlagn_request_scan(struct iwl_priv *priv);
+void iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif);
 
 /* station mgmt */
 int iwlagn_manage_ibss_station(struct iwl_priv *priv,
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 246538a..68c3693 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -480,7 +480,7 @@ static u16 iwl_adjust_beacon_interval(u16 beacon_val, u16 max_beacon_val)
 	return new_val;
 }
 
-void iwl_setup_rxon_timing(struct iwl_priv *priv)
+void iwl_setup_rxon_timing(struct iwl_priv *priv, struct ieee80211_vif *vif)
 {
 	u64 tsf;
 	s32 interval_tm, rem;
@@ -494,15 +494,14 @@ void iwl_setup_rxon_timing(struct iwl_priv *priv)
 	priv->rxon_timing.timestamp = cpu_to_le64(priv->timestamp);
 	priv->rxon_timing.listen_interval = cpu_to_le16(conf->listen_interval);
 
-	if (priv->iw_mode == NL80211_IFTYPE_STATION) {
-		beacon_int = priv->beacon_int;
-		priv->rxon_timing.atim_window = 0;
-	} else {
-		beacon_int = priv->vif->bss_conf.beacon_int;
+	beacon_int = vif->bss_conf.beacon_int;
 
+	if (vif->type == NL80211_IFTYPE_ADHOC) {
 		/* TODO: we need to get atim_window from upper stack
 		 * for now we set to 0 */
 		priv->rxon_timing.atim_window = 0;
+	} else {
+		priv->rxon_timing.atim_window = 0;
 	}
 
 	beacon_int = iwl_adjust_beacon_interval(beacon_int,
@@ -894,8 +893,9 @@ int iwl_set_rxon_channel(struct iwl_priv *priv, struct ieee80211_channel *ch)
 }
 EXPORT_SYMBOL(iwl_set_rxon_channel);
 
-void iwl_set_flags_for_band(struct iwl_priv *priv,
-			    enum ieee80211_band band)
+static void iwl_set_flags_for_band(struct iwl_priv *priv,
+				   enum ieee80211_band band,
+				   struct ieee80211_vif *vif)
 {
 	if (band == IEEE80211_BAND_5GHZ) {
 		priv->staging_rxon.flags &=
@@ -904,12 +904,12 @@ void iwl_set_flags_for_band(struct iwl_priv *priv,
 		priv->staging_rxon.flags |= RXON_FLG_SHORT_SLOT_MSK;
 	} else {
 		/* Copied from iwl_post_associate() */
-		if (priv->assoc_capability & WLAN_CAPABILITY_SHORT_SLOT_TIME)
+		if (vif && vif->bss_conf.assoc_capability & WLAN_CAPABILITY_SHORT_SLOT_TIME)
 			priv->staging_rxon.flags |= RXON_FLG_SHORT_SLOT_MSK;
 		else
 			priv->staging_rxon.flags &= ~RXON_FLG_SHORT_SLOT_MSK;
 
-		if (priv->iw_mode == NL80211_IFTYPE_ADHOC)
+		if (vif && vif->type == NL80211_IFTYPE_ADHOC)
 			priv->staging_rxon.flags &= ~RXON_FLG_SHORT_SLOT_MSK;
 
 		priv->staging_rxon.flags |= RXON_FLG_BAND_24G_MSK;
@@ -921,13 +921,18 @@ void iwl_set_flags_for_band(struct iwl_priv *priv,
 /*
  * initialize rxon structure with default values from eeprom
  */
-void iwl_connection_init_rx_config(struct iwl_priv *priv, int mode)
+void iwl_connection_init_rx_config(struct iwl_priv *priv,
+				   struct ieee80211_vif *vif)
 {
 	const struct iwl_channel_info *ch_info;
+	enum nl80211_iftype type = NL80211_IFTYPE_STATION;
+
+	if (vif)
+		type = vif->type;
 
 	memset(&priv->staging_rxon, 0, sizeof(priv->staging_rxon));
 
-	switch (mode) {
+	switch (type) {
 	case NL80211_IFTYPE_AP:
 		priv->staging_rxon.dev_type = RXON_DEV_TYPE_AP;
 		break;
@@ -945,7 +950,7 @@ void iwl_connection_init_rx_config(struct iwl_priv *priv, int mode)
 		break;
 
 	default:
-		IWL_ERR(priv, "Unsupported interface type %d\n", mode);
+		IWL_ERR(priv, "Unsupported interface type %d\n", type);
 		break;
 	}
 
@@ -967,7 +972,7 @@ void iwl_connection_init_rx_config(struct iwl_priv *priv, int mode)
 	priv->staging_rxon.channel = cpu_to_le16(ch_info->channel);
 	priv->band = ch_info->band;
 
-	iwl_set_flags_for_band(priv, priv->band);
+	iwl_set_flags_for_band(priv, priv->band, vif);
 
 	priv->staging_rxon.ofdm_basic_rates =
 	    (IWL_OFDM_RATES_MASK >> IWL_FIRST_OFDM_RATE) & 0xFF;
@@ -1793,7 +1798,6 @@ static void iwl_ht_conf(struct iwl_priv *priv,
 
 static inline void iwl_set_no_assoc(struct iwl_priv *priv)
 {
-	priv->assoc_id = 0;
 	iwl_led_disassociate(priv);
 	/*
 	 * inform the ucode that there is no longer an
@@ -1827,7 +1831,6 @@ void iwl_bss_info_changed(struct ieee80211_hw *hw,
 	}
 
 	if (changes & BSS_CHANGED_BEACON_INT) {
-		priv->beacon_int = bss_conf->beacon_int;
 		/* TODO: in AP mode, do something to make this take effect */
 	}
 
@@ -1917,20 +1920,17 @@ void iwl_bss_info_changed(struct ieee80211_hw *hw,
 	if (changes & BSS_CHANGED_ASSOC) {
 		IWL_DEBUG_MAC80211(priv, "ASSOC %d\n", bss_conf->assoc);
 		if (bss_conf->assoc) {
-			priv->assoc_id = bss_conf->aid;
-			priv->beacon_int = bss_conf->beacon_int;
 			priv->timestamp = bss_conf->timestamp;
-			priv->assoc_capability = bss_conf->assoc_capability;
 
 			iwl_led_associate(priv);
 
 			if (!iwl_is_rfkill(priv))
-				priv->cfg->ops->lib->post_associate(priv);
+				priv->cfg->ops->lib->post_associate(priv, vif);
 		} else
 			iwl_set_no_assoc(priv);
 	}
 
-	if (changes && iwl_is_associated(priv) && priv->assoc_id) {
+	if (changes && iwl_is_associated(priv) && bss_conf->aid) {
 		IWL_DEBUG_MAC80211(priv, "Changes (%#x) while associated\n",
 				   changes);
 		ret = iwl_send_rxon_assoc(priv);
@@ -1947,7 +1947,7 @@ void iwl_bss_info_changed(struct ieee80211_hw *hw,
 			memcpy(priv->staging_rxon.bssid_addr,
 			       bss_conf->bssid, ETH_ALEN);
 			memcpy(priv->bssid, bss_conf->bssid, ETH_ALEN);
-			iwlcore_config_ap(priv);
+			iwlcore_config_ap(priv, vif);
 		} else
 			iwl_set_no_assoc(priv);
 	}
@@ -1987,14 +1987,13 @@ int iwl_mac_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb)
 
 	priv->ibss_beacon = skb;
 
-	priv->assoc_id = 0;
 	timestamp = ((struct ieee80211_mgmt *)skb->data)->u.beacon.timestamp;
 	priv->timestamp = le64_to_cpu(timestamp);
 
 	IWL_DEBUG_MAC80211(priv, "leave\n");
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-	priv->cfg->ops->lib->post_associate(priv);
+	priv->cfg->ops->lib->post_associate(priv, priv->vif);
 
 	return 0;
 }
@@ -2002,7 +2001,7 @@ EXPORT_SYMBOL(iwl_mac_beacon_update);
 
 static int iwl_set_mode(struct iwl_priv *priv, struct ieee80211_vif *vif)
 {
-	iwl_connection_init_rx_config(priv, vif->type);
+	iwl_connection_init_rx_config(priv, vif);
 
 	if (priv->cfg->ops->hcmd->set_rxon_chain)
 		priv->cfg->ops->hcmd->set_rxon_chain(priv);
@@ -2176,7 +2175,7 @@ int iwl_mac_config(struct ieee80211_hw *hw, u32 changed)
 		iwl_set_rxon_channel(priv, conf->channel);
 		iwl_set_rxon_ht(priv, ht_conf);
 
-		iwl_set_flags_for_band(priv, conf->channel->band);
+		iwl_set_flags_for_band(priv, conf->channel->band, priv->vif);
 		spin_unlock_irqrestore(&priv->lock, flags);
 		if (iwl_is_associated(priv) &&
 		    (le16_to_cpu(priv->active_rxon.channel) != ch) &&
@@ -2259,8 +2258,6 @@ void iwl_mac_reset_tsf(struct ieee80211_hw *hw)
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	spin_lock_irqsave(&priv->lock, flags);
-	priv->assoc_id = 0;
-	priv->assoc_capability = 0;
 
 	/* new association get rid of ibss beacon skb */
 	if (priv->ibss_beacon)
@@ -2268,7 +2265,6 @@ void iwl_mac_reset_tsf(struct ieee80211_hw *hw)
 
 	priv->ibss_beacon = NULL;
 
-	priv->beacon_int = priv->vif->bss_conf.beacon_int;
 	priv->timestamp = 0;
 
 	spin_unlock_irqrestore(&priv->lock, flags);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 7a3f949..1774ce9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -106,7 +106,7 @@ struct iwl_hcmd_utils_ops {
 			__le32 *tx_flags);
 	int  (*calc_rssi)(struct iwl_priv *priv,
 			  struct iwl_rx_phy_res *rx_resp);
-	void (*request_scan)(struct iwl_priv *priv);
+	void (*request_scan)(struct iwl_priv *priv, struct ieee80211_vif *vif);
 };
 
 struct iwl_apm_ops {
@@ -180,8 +180,9 @@ struct iwl_lib_ops {
 	/* power */
 	int (*send_tx_power) (struct iwl_priv *priv);
 	void (*update_chain_flags)(struct iwl_priv *priv);
-	void (*post_associate) (struct iwl_priv *priv);
-	void (*config_ap) (struct iwl_priv *priv);
+	void (*post_associate)(struct iwl_priv *priv,
+			       struct ieee80211_vif *vif);
+	void (*config_ap)(struct iwl_priv *priv, struct ieee80211_vif *vif);
 	irqreturn_t (*isr) (int irq, void *data);
 
 	/* eeprom operations (as defined in iwl-eeprom.h) */
@@ -334,8 +335,8 @@ int iwl_set_rxon_channel(struct iwl_priv *priv, struct ieee80211_channel *ch);
 void iwl_set_rxon_ht(struct iwl_priv *priv, struct iwl_ht_config *ht_conf);
 u8 iwl_is_ht40_tx_allowed(struct iwl_priv *priv,
 			 struct ieee80211_sta_ht_cap *sta_ht_inf);
-void iwl_set_flags_for_band(struct iwl_priv *priv, enum ieee80211_band band);
-void iwl_connection_init_rx_config(struct iwl_priv *priv, int mode);
+void iwl_connection_init_rx_config(struct iwl_priv *priv,
+				   struct ieee80211_vif *vif);
 int iwl_set_decrypted_flag(struct iwl_priv *priv,
 			   struct ieee80211_hdr *hdr,
 			   u32 decrypt_res,
@@ -345,7 +346,7 @@ void iwl_configure_filter(struct ieee80211_hw *hw,
 			  unsigned int changed_flags,
 			  unsigned int *total_flags, u64 multicast);
 int iwl_set_hw_params(struct iwl_priv *priv);
-void iwl_post_associate(struct iwl_priv *priv);
+void iwl_post_associate(struct iwl_priv *priv, struct ieee80211_vif *vif);
 void iwl_bss_info_changed(struct ieee80211_hw *hw,
 				     struct ieee80211_vif *vif,
 				     struct ieee80211_bss_conf *bss_conf,
@@ -357,7 +358,7 @@ int iwl_mac_add_interface(struct ieee80211_hw *hw,
 void iwl_mac_remove_interface(struct ieee80211_hw *hw,
 			      struct ieee80211_vif *vif);
 int iwl_mac_config(struct ieee80211_hw *hw, u32 changed);
-void iwl_config_ap(struct iwl_priv *priv);
+void iwl_config_ap(struct iwl_priv *priv, struct ieee80211_vif *vif);
 void iwl_mac_reset_tsf(struct ieee80211_hw *hw);
 int iwl_alloc_txq_mem(struct iwl_priv *priv);
 void iwl_free_txq_mem(struct iwl_priv *priv);
@@ -520,7 +521,8 @@ u16 iwl_get_active_dwell_time(struct iwl_priv *priv,
 			      enum ieee80211_band band,
 			      u8 n_probes);
 u16 iwl_get_passive_dwell_time(struct iwl_priv *priv,
-			       enum ieee80211_band band);
+			       enum ieee80211_band band,
+			       struct ieee80211_vif *vif);
 void iwl_bg_scan_check(struct work_struct *data);
 void iwl_bg_abort_scan(struct work_struct *work);
 void iwl_bg_scan_completed(struct work_struct *work);
@@ -684,7 +686,7 @@ extern int iwl_send_lq_cmd(struct iwl_priv *priv,
 void iwl_apm_stop(struct iwl_priv *priv);
 int iwl_apm_init(struct iwl_priv *priv);
 
-void iwl_setup_rxon_timing(struct iwl_priv *priv);
+void iwl_setup_rxon_timing(struct iwl_priv *priv, struct ieee80211_vif *vif);
 static inline int iwl_send_rxon_assoc(struct iwl_priv *priv)
 {
 	return priv->cfg->ops->hcmd->rxon_assoc(priv);
@@ -693,9 +695,10 @@ static inline int iwlcore_commit_rxon(struct iwl_priv *priv)
 {
 	return priv->cfg->ops->hcmd->commit_rxon(priv);
 }
-static inline void iwlcore_config_ap(struct iwl_priv *priv)
+static inline void iwlcore_config_ap(struct iwl_priv *priv,
+				     struct ieee80211_vif *vif)
 {
-	priv->cfg->ops->lib->config_ap(priv);
+	priv->cfg->ops->lib->config_ap(priv, vif);
 }
 static inline const struct ieee80211_supported_band *iwl_get_hw_mode(
 			struct iwl_priv *priv, enum ieee80211_band band)
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index d09c8bc..bcdb663 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1243,7 +1243,6 @@ struct iwl_priv {
 
 	/* Last Rx'd beacon timestamp */
 	u64 timestamp;
-	u16 beacon_int;
 	struct ieee80211_vif *vif;
 
 	union {
@@ -1305,10 +1304,6 @@ struct iwl_priv {
 	struct iwl_hw_params hw_params;
 
 	u32 inta_mask;
-	/* Current association information needed to configure the
-	 * hardware */
-	u16 assoc_id;
-	u16 assoc_capability;
 
 	struct iwl_qos_info qos_data;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index 28e2d86..32ca848 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -264,7 +264,8 @@ inline u16 iwl_get_active_dwell_time(struct iwl_priv *priv,
 EXPORT_SYMBOL(iwl_get_active_dwell_time);
 
 u16 iwl_get_passive_dwell_time(struct iwl_priv *priv,
-			       enum ieee80211_band band)
+			       enum ieee80211_band band,
+			       struct ieee80211_vif *vif)
 {
 	u16 passive = (band == IEEE80211_BAND_2GHZ) ?
 	    IWL_PASSIVE_DWELL_BASE + IWL_PASSIVE_DWELL_TIME_24 :
@@ -274,7 +275,7 @@ u16 iwl_get_passive_dwell_time(struct iwl_priv *priv,
 		/* If we're associated, we clamp the maximum passive
 		 * dwell time to be 98% of the beacon interval (minus
 		 * 2 * channel tune time) */
-		passive = priv->beacon_int;
+		passive = vif ? vif->bss_conf.beacon_int : 0;
 		if ((passive > IWL_PASSIVE_DWELL_BASE) || !passive)
 			passive = IWL_PASSIVE_DWELL_BASE;
 		passive = (passive * 98) / 100 - IWL_CHANNEL_TUNE_TIME * 2;
@@ -294,7 +295,7 @@ void iwl_init_scan_params(struct iwl_priv *priv)
 }
 EXPORT_SYMBOL(iwl_init_scan_params);
 
-static int iwl_scan_initiate(struct iwl_priv *priv)
+static int iwl_scan_initiate(struct iwl_priv *priv, struct ieee80211_vif *vif)
 {
 	WARN_ON(!mutex_is_locked(&priv->mutex));
 
@@ -306,7 +307,7 @@ static int iwl_scan_initiate(struct iwl_priv *priv)
 	if (WARN_ON(!priv->cfg->ops->utils->request_scan))
 		return -EOPNOTSUPP;
 
-	priv->cfg->ops->utils->request_scan(priv);
+	priv->cfg->ops->utils->request_scan(priv, vif);
 
 	return 0;
 }
@@ -347,7 +348,7 @@ int iwl_mac_hw_scan(struct ieee80211_hw *hw,
 	priv->scan_band = req->channels[0]->band;
 	priv->scan_request = req;
 
-	ret = iwl_scan_initiate(priv);
+	ret = iwl_scan_initiate(priv, vif);
 
 	IWL_DEBUG_MAC80211(priv, "leave\n");
 
@@ -398,7 +399,7 @@ void iwl_bg_start_internal_scan(struct work_struct *work)
 	if (WARN_ON(!priv->cfg->ops->utils->request_scan))
 		goto unlock;
 
-	priv->cfg->ops->utils->request_scan(priv);
+	priv->cfg->ops->utils->request_scan(priv, NULL);
  unlock:
 	mutex_unlock(&priv->mutex);
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 77ab00b..85a46ad 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -1847,7 +1847,8 @@ static void iwl3945_irq_tasklet(struct iwl_priv *priv)
 static int iwl3945_get_channels_for_scan(struct iwl_priv *priv,
 					 enum ieee80211_band band,
 				     u8 is_active, u8 n_probes,
-				     struct iwl3945_scan_channel *scan_ch)
+				     struct iwl3945_scan_channel *scan_ch,
+				     struct ieee80211_vif *vif)
 {
 	struct ieee80211_channel *chan;
 	const struct ieee80211_supported_band *sband;
@@ -1861,7 +1862,7 @@ static int iwl3945_get_channels_for_scan(struct iwl_priv *priv,
 		return 0;
 
 	active_dwell = iwl_get_active_dwell_time(priv, band, n_probes);
-	passive_dwell = iwl_get_passive_dwell_time(priv, band);
+	passive_dwell = iwl_get_passive_dwell_time(priv, band, vif);
 
 	if (passive_dwell <= active_dwell)
 		passive_dwell = active_dwell + 1;
@@ -2543,7 +2544,7 @@ static void iwl3945_alive_start(struct iwl_priv *priv)
 		active_rxon->filter_flags &= ~RXON_FILTER_ASSOC_MSK;
 	} else {
 		/* Initialize our rx_config data */
-		iwl_connection_init_rx_config(priv, priv->iw_mode);
+		iwl_connection_init_rx_config(priv, NULL);
 	}
 
 	/* Configure Bluetooth device coexistence support */
@@ -2811,7 +2812,7 @@ static void iwl3945_rfkill_poll(struct work_struct *data)
 
 }
 
-void iwl3945_request_scan(struct iwl_priv *priv)
+void iwl3945_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 {
 	struct iwl_host_cmd cmd = {
 		.id = REPLY_SCAN_CMD,
@@ -2892,7 +2893,7 @@ void iwl3945_request_scan(struct iwl_priv *priv)
 		IWL_DEBUG_INFO(priv, "Scanning while associated...\n");
 
 		spin_lock_irqsave(&priv->lock, flags);
-		interval = priv->beacon_int;
+		interval = vif ? vif->bss_conf.beacon_int : 0;
 		spin_unlock_irqrestore(&priv->lock, flags);
 
 		scan->suspend_time = 0;
@@ -2987,7 +2988,7 @@ void iwl3945_request_scan(struct iwl_priv *priv)
 
 	scan->channel_count =
 		iwl3945_get_channels_for_scan(priv, band, is_active, n_probes,
-			(void *)&scan->data[le16_to_cpu(scan->tx_cmd.len)]);
+			(void *)&scan->data[le16_to_cpu(scan->tx_cmd.len)], vif);
 
 	if (scan->channel_count == 0) {
 		IWL_DEBUG_SCAN(priv, "channel count %d\n", scan->channel_count);
@@ -3060,26 +3061,25 @@ static void iwl3945_bg_rx_replenish(struct work_struct *data)
 	mutex_unlock(&priv->mutex);
 }
 
-void iwl3945_post_associate(struct iwl_priv *priv)
+void iwl3945_post_associate(struct iwl_priv *priv, struct ieee80211_vif *vif)
 {
 	int rc = 0;
 	struct ieee80211_conf *conf = NULL;
 
-	if (priv->iw_mode == NL80211_IFTYPE_AP) {
+	if (!vif || !priv->is_open)
+		return;
+
+	if (vif->type == NL80211_IFTYPE_AP) {
 		IWL_ERR(priv, "%s Should not be called in AP mode\n", __func__);
 		return;
 	}
 
-
 	IWL_DEBUG_ASSOC(priv, "Associated as %d to: %pM\n",
-			priv->assoc_id, priv->active_rxon.bssid_addr);
+			vif->bss_conf.aid, priv->active_rxon.bssid_addr);
 
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return;
 
-	if (!priv->vif || !priv->is_open)
-		return;
-
 	iwl_scan_cancel_timeout(priv, 200);
 
 	conf = ieee80211_get_hw_conf(priv->hw);
@@ -3088,7 +3088,7 @@ void iwl3945_post_associate(struct iwl_priv *priv)
 	iwlcore_commit_rxon(priv);
 
 	memset(&priv->rxon_timing, 0, sizeof(struct iwl_rxon_time_cmd));
-	iwl_setup_rxon_timing(priv);
+	iwl_setup_rxon_timing(priv, vif);
 	rc = iwl_send_cmd_pdu(priv, REPLY_RXON_TIMING,
 			      sizeof(priv->rxon_timing), &priv->rxon_timing);
 	if (rc)
@@ -3097,40 +3097,38 @@ void iwl3945_post_associate(struct iwl_priv *priv)
 
 	priv->staging_rxon.filter_flags |= RXON_FILTER_ASSOC_MSK;
 
-	priv->staging_rxon.assoc_id = cpu_to_le16(priv->assoc_id);
+	priv->staging_rxon.assoc_id = cpu_to_le16(vif->bss_conf.aid);
 
 	IWL_DEBUG_ASSOC(priv, "assoc id %d beacon interval %d\n",
-			priv->assoc_id, priv->beacon_int);
+			vif->bss_conf.aid, vif->bss_conf.beacon_int);
 
-	if (priv->assoc_capability & WLAN_CAPABILITY_SHORT_PREAMBLE)
+	if (vif->bss_conf.assoc_capability & WLAN_CAPABILITY_SHORT_PREAMBLE)
 		priv->staging_rxon.flags |= RXON_FLG_SHORT_PREAMBLE_MSK;
 	else
 		priv->staging_rxon.flags &= ~RXON_FLG_SHORT_PREAMBLE_MSK;
 
 	if (priv->staging_rxon.flags & RXON_FLG_BAND_24G_MSK) {
-		if (priv->assoc_capability & WLAN_CAPABILITY_SHORT_SLOT_TIME)
+		if (vif->bss_conf.assoc_capability & WLAN_CAPABILITY_SHORT_SLOT_TIME)
 			priv->staging_rxon.flags |= RXON_FLG_SHORT_SLOT_MSK;
 		else
 			priv->staging_rxon.flags &= ~RXON_FLG_SHORT_SLOT_MSK;
 
-		if (priv->iw_mode == NL80211_IFTYPE_ADHOC)
+		if (vif->type == NL80211_IFTYPE_ADHOC)
 			priv->staging_rxon.flags &= ~RXON_FLG_SHORT_SLOT_MSK;
-
 	}
 
 	iwlcore_commit_rxon(priv);
 
-	switch (priv->iw_mode) {
+	switch (vif->type) {
 	case NL80211_IFTYPE_STATION:
 		iwl3945_rate_scale_init(priv->hw, IWL_AP_ID);
 		break;
 	case NL80211_IFTYPE_ADHOC:
-		priv->assoc_id = 1;
 		iwl3945_send_beacon_cmd(priv);
 		break;
 	default:
-		 IWL_ERR(priv, "%s Should not be called in %d mode\n",
-			   __func__, priv->iw_mode);
+		IWL_ERR(priv, "%s Should not be called in %d mode\n",
+			__func__, vif->type);
 		break;
 	}
 }
@@ -3254,7 +3252,7 @@ static int iwl3945_mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	return NETDEV_TX_OK;
 }
 
-void iwl3945_config_ap(struct iwl_priv *priv)
+void iwl3945_config_ap(struct iwl_priv *priv, struct ieee80211_vif *vif)
 {
 	int rc = 0;
 
@@ -3270,7 +3268,7 @@ void iwl3945_config_ap(struct iwl_priv *priv)
 
 		/* RXON Timing */
 		memset(&priv->rxon_timing, 0, sizeof(struct iwl_rxon_time_cmd));
-		iwl_setup_rxon_timing(priv);
+		iwl_setup_rxon_timing(priv, vif);
 		rc = iwl_send_cmd_pdu(priv, REPLY_RXON_TIMING,
 				      sizeof(priv->rxon_timing),
 				      &priv->rxon_timing);
@@ -3278,9 +3276,10 @@ void iwl3945_config_ap(struct iwl_priv *priv)
 			IWL_WARN(priv, "REPLY_RXON_TIMING failed - "
 					"Attempting to continue.\n");
 
-		/* FIXME: what should be the assoc_id for AP? */
-		priv->staging_rxon.assoc_id = cpu_to_le16(priv->assoc_id);
-		if (priv->assoc_capability & WLAN_CAPABILITY_SHORT_PREAMBLE)
+		priv->staging_rxon.assoc_id = 0;
+
+		if (vif->bss_conf.assoc_capability &
+					WLAN_CAPABILITY_SHORT_PREAMBLE)
 			priv->staging_rxon.flags |=
 				RXON_FLG_SHORT_PREAMBLE_MSK;
 		else
@@ -3288,15 +3287,15 @@ void iwl3945_config_ap(struct iwl_priv *priv)
 				~RXON_FLG_SHORT_PREAMBLE_MSK;
 
 		if (priv->staging_rxon.flags & RXON_FLG_BAND_24G_MSK) {
-			if (priv->assoc_capability &
-				WLAN_CAPABILITY_SHORT_SLOT_TIME)
+			if (vif->bss_conf.assoc_capability &
+					WLAN_CAPABILITY_SHORT_SLOT_TIME)
 				priv->staging_rxon.flags |=
 					RXON_FLG_SHORT_SLOT_MSK;
 			else
 				priv->staging_rxon.flags &=
 					~RXON_FLG_SHORT_SLOT_MSK;
 
-			if (priv->iw_mode == NL80211_IFTYPE_ADHOC)
+			if (vif->type == NL80211_IFTYPE_ADHOC)
 				priv->staging_rxon.flags &=
 					~RXON_FLG_SHORT_SLOT_MSK;
 		}
-- 
1.6.3.3

