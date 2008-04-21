Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:36491 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753708AbYDUWmP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Apr 2008 18:42:15 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 10/11] iwlwifi: HT IE in probe request clean up
Date: Mon, 21 Apr 2008 15:42:00 -0700
Message-Id: <1208817721-11333-11-git-send-email-reinette.chatre@intel.com> (sfid-20080422_004344_284265_282F9ABB)
In-Reply-To: <1208817721-11333-10-git-send-email-reinette.chatre@intel.com>
References: <1208817721-11333-1-git-send-email-reinette.chatre@intel.com>
 <1208817721-11333-2-git-send-email-reinette.chatre@intel.com>
 <1208817721-11333-3-git-send-email-reinette.chatre@intel.com>
 <1208817721-11333-4-git-send-email-reinette.chatre@intel.com>
 <1208817721-11333-5-git-send-email-reinette.chatre@intel.com>
 <1208817721-11333-6-git-send-email-reinette.chatre@intel.com>
 <1208817721-11333-7-git-send-email-reinette.chatre@intel.com>
 <1208817721-11333-8-git-send-email-reinette.chatre@intel.com>
 <1208817721-11333-9-git-send-email-reinette.chatre@intel.com>
 <1208817721-11333-10-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This patch cleans up the scan flow. This patch cleans up the insertion of
the HT IE in the probe request.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl4965-base.c |  182 +++++++++++++++------------
 1 files changed, 101 insertions(+), 81 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 7932a67..7710460 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -99,7 +99,7 @@ __le16 *ieee80211_get_qos_ctrl(struct ieee80211_hdr *hdr)
 	return NULL;
 }
 
-static const struct ieee80211_supported_band *iwl4965_get_hw_mode(
+static const struct ieee80211_supported_band *iwl_get_hw_mode(
 		struct iwl_priv *priv, enum ieee80211_band band)
 {
 	return priv->hw->wiphy->bands[band];
@@ -1166,6 +1166,91 @@ static u16 iwl4965_supported_rate_to_ie(u8 *ie, u16 supported_rate,
 	return ret_rates;
 }
 
+#ifdef CONFIG_IWL4965_HT
+static void iwl4965_ht_conf(struct iwl_priv *priv,
+			    struct ieee80211_bss_conf *bss_conf)
+{
+	struct ieee80211_ht_info *ht_conf = bss_conf->ht_conf;
+	struct ieee80211_ht_bss_info *ht_bss_conf = bss_conf->ht_bss_conf;
+	struct iwl_ht_info *iwl_conf = &priv->current_ht_config;
+
+	IWL_DEBUG_MAC80211("enter: \n");
+
+	iwl_conf->is_ht = bss_conf->assoc_ht;
+
+	if (!iwl_conf->is_ht)
+		return;
+
+	priv->ps_mode = (u8)((ht_conf->cap & IEEE80211_HT_CAP_MIMO_PS) >> 2);
+
+	if (ht_conf->cap & IEEE80211_HT_CAP_SGI_20)
+		iwl_conf->sgf |= 0x1;
+	if (ht_conf->cap & IEEE80211_HT_CAP_SGI_40)
+		iwl_conf->sgf |= 0x2;
+
+	iwl_conf->is_green_field = !!(ht_conf->cap & IEEE80211_HT_CAP_GRN_FLD);
+	iwl_conf->max_amsdu_size =
+		!!(ht_conf->cap & IEEE80211_HT_CAP_MAX_AMSDU);
+
+	iwl_conf->supported_chan_width =
+		!!(ht_conf->cap & IEEE80211_HT_CAP_SUP_WIDTH);
+	iwl_conf->extension_chan_offset =
+		ht_bss_conf->bss_cap & IEEE80211_HT_IE_CHA_SEC_OFFSET;
+	/* If no above or below channel supplied disable FAT channel */
+	if (iwl_conf->extension_chan_offset != IWL_EXT_CHANNEL_OFFSET_ABOVE &&
+	    iwl_conf->extension_chan_offset != IWL_EXT_CHANNEL_OFFSET_BELOW)
+		iwl_conf->supported_chan_width = 0;
+
+	iwl_conf->tx_mimo_ps_mode =
+		(u8)((ht_conf->cap & IEEE80211_HT_CAP_MIMO_PS) >> 2);
+	memcpy(iwl_conf->supp_mcs_set, ht_conf->supp_mcs_set, 16);
+
+	iwl_conf->control_channel = ht_bss_conf->primary_channel;
+	iwl_conf->tx_chan_width =
+		!!(ht_bss_conf->bss_cap & IEEE80211_HT_IE_CHA_WIDTH);
+	iwl_conf->ht_protection =
+		ht_bss_conf->bss_op_mode & IEEE80211_HT_IE_HT_PROTECTION;
+	iwl_conf->non_GF_STA_present =
+		!!(ht_bss_conf->bss_op_mode & IEEE80211_HT_IE_NON_GF_STA_PRSNT);
+
+	IWL_DEBUG_MAC80211("control channel %d\n", iwl_conf->control_channel);
+	IWL_DEBUG_MAC80211("leave\n");
+}
+
+static void iwl_ht_cap_to_ie(const struct ieee80211_supported_band *sband,
+			u8 *pos, int *left)
+{
+	struct ieee80211_ht_cap *ht_cap;
+
+	if (!sband || !sband->ht_info.ht_supported)
+		return;
+
+	if (*left < sizeof(struct ieee80211_ht_cap))
+		return;
+
+	*pos++ = sizeof(struct ieee80211_ht_cap);
+	ht_cap = (struct ieee80211_ht_cap *) pos;
+
+	ht_cap->cap_info = cpu_to_le16(sband->ht_info.cap);
+	memcpy(ht_cap->supp_mcs_set, sband->ht_info.supp_mcs_set, 16);
+	ht_cap->ampdu_params_info =
+		(sband->ht_info.ampdu_factor & IEEE80211_HT_CAP_AMPDU_FACTOR) |
+		((sband->ht_info.ampdu_density << 2) &
+			IEEE80211_HT_CAP_AMPDU_DENSITY);
+	*left -= sizeof(struct ieee80211_ht_cap);
+}
+#else
+static inline void iwl4965_ht_conf(struct iwl_priv *priv,
+				   struct ieee80211_bss_conf *bss_conf)
+{
+}
+static void iwl_ht_cap_to_ie(const struct ieee80211_supported_band *sband,
+			u8 *pos, int *left)
+{
+}
+#endif
+
+
 /**
  * iwl4965_fill_probe_req - fill in all required fields and IE for probe request
  */
@@ -1177,10 +1262,8 @@ static u16 iwl4965_fill_probe_req(struct iwl_priv *priv,
 	int len = 0;
 	u8 *pos = NULL;
 	u16 active_rates, ret_rates, cck_rates, active_rate_basic;
-#ifdef CONFIG_IWL4965_HT
 	const struct ieee80211_supported_band *sband =
-						iwl4965_get_hw_mode(priv, band);
-#endif /* CONFIG_IWL4965_HT */
+						iwl_get_hw_mode(priv, band);
 
 	/* Make sure there is enough space for the probe request,
 	 * two mandatory IEs and the data */
@@ -1263,24 +1346,19 @@ static u16 iwl4965_fill_probe_req(struct iwl_priv *priv,
 	if (*pos > 0)
 		len += 2 + *pos;
 
-#ifdef CONFIG_IWL4965_HT
-	if (sband && sband->ht_info.ht_supported) {
-		struct ieee80211_ht_cap *ht_cap;
-		pos += (*pos) + 1;
-		*pos++ = WLAN_EID_HT_CAPABILITY;
-		*pos++ = sizeof(struct ieee80211_ht_cap);
-		ht_cap = (struct ieee80211_ht_cap *)pos;
-		ht_cap->cap_info = cpu_to_le16(sband->ht_info.cap);
-		memcpy(ht_cap->supp_mcs_set, sband->ht_info.supp_mcs_set, 16);
-		ht_cap->ampdu_params_info =(sband->ht_info.ampdu_factor &
-					    IEEE80211_HT_CAP_AMPDU_FACTOR) |
-					    ((sband->ht_info.ampdu_density << 2) &
-					    IEEE80211_HT_CAP_AMPDU_DENSITY);
-		len += 2 + sizeof(struct ieee80211_ht_cap);
-	}
-#endif  /*CONFIG_IWL4965_HT */
-
  fill_end:
+	/* fill in HT IE */
+	left -= 2;
+	if (left < 0)
+		return 0;
+
+	*pos++ = WLAN_EID_HT_CAPABILITY;
+	*pos = 0;
+
+	iwl_ht_cap_to_ie(sband, pos, &left);
+
+	if (*pos > 0)
+		len += 2 + *pos;
 	return (u16)len;
 }
 
@@ -2146,7 +2224,7 @@ static void iwl4965_set_rate(struct iwl_priv *priv)
 	struct ieee80211_rate *rate;
 	int i;
 
-	hw = iwl4965_get_hw_mode(priv, priv->band);
+	hw = iwl_get_hw_mode(priv, priv->band);
 	if (!hw) {
 		IWL_ERROR("Failed to set rate: unable to get hw mode\n");
 		return;
@@ -4360,7 +4438,7 @@ static int iwl4965_get_channels_for_scan(struct iwl_priv *priv,
 	u16 active_dwell = 0;
 	int added, i;
 
-	sband = iwl4965_get_hw_mode(priv, band);
+	sband = iwl_get_hw_mode(priv, band);
 	if (!sband)
 		return 0;
 
@@ -6329,64 +6407,6 @@ static void iwl4965_mac_remove_interface(struct ieee80211_hw *hw,
 
 }
 
-
-#ifdef CONFIG_IWL4965_HT
-static void iwl4965_ht_conf(struct iwl_priv *priv,
-			    struct ieee80211_bss_conf *bss_conf)
-{
-	struct ieee80211_ht_info *ht_conf = bss_conf->ht_conf;
-	struct ieee80211_ht_bss_info *ht_bss_conf = bss_conf->ht_bss_conf;
-	struct iwl_ht_info *iwl_conf = &priv->current_ht_config;
-
-	IWL_DEBUG_MAC80211("enter: \n");
-
-	iwl_conf->is_ht = bss_conf->assoc_ht;
-
-	if (!iwl_conf->is_ht)
-		return;
-
-	priv->ps_mode = (u8)((ht_conf->cap & IEEE80211_HT_CAP_MIMO_PS) >> 2);
-
-	if (ht_conf->cap & IEEE80211_HT_CAP_SGI_20)
-		iwl_conf->sgf |= 0x1;
-	if (ht_conf->cap & IEEE80211_HT_CAP_SGI_40)
-		iwl_conf->sgf |= 0x2;
-
-	iwl_conf->is_green_field = !!(ht_conf->cap & IEEE80211_HT_CAP_GRN_FLD);
-	iwl_conf->max_amsdu_size =
-		!!(ht_conf->cap & IEEE80211_HT_CAP_MAX_AMSDU);
-
-	iwl_conf->supported_chan_width =
-		!!(ht_conf->cap & IEEE80211_HT_CAP_SUP_WIDTH);
-	iwl_conf->extension_chan_offset =
-		ht_bss_conf->bss_cap & IEEE80211_HT_IE_CHA_SEC_OFFSET;
-	/* If no above or below channel supplied disable FAT channel */
-	if (iwl_conf->extension_chan_offset != IWL_EXT_CHANNEL_OFFSET_ABOVE &&
-	    iwl_conf->extension_chan_offset != IWL_EXT_CHANNEL_OFFSET_BELOW)
-		iwl_conf->supported_chan_width = 0;
-
-	iwl_conf->tx_mimo_ps_mode =
-		(u8)((ht_conf->cap & IEEE80211_HT_CAP_MIMO_PS) >> 2);
-	memcpy(iwl_conf->supp_mcs_set, ht_conf->supp_mcs_set, 16);
-
-	iwl_conf->control_channel = ht_bss_conf->primary_channel;
-	iwl_conf->tx_chan_width =
-		!!(ht_bss_conf->bss_cap & IEEE80211_HT_IE_CHA_WIDTH);
-	iwl_conf->ht_protection =
-		ht_bss_conf->bss_op_mode & IEEE80211_HT_IE_HT_PROTECTION;
-	iwl_conf->non_GF_STA_present =
-		!!(ht_bss_conf->bss_op_mode & IEEE80211_HT_IE_NON_GF_STA_PRSNT);
-
-	IWL_DEBUG_MAC80211("control channel %d\n", iwl_conf->control_channel);
-	IWL_DEBUG_MAC80211("leave\n");
-}
-#else
-static inline void iwl4965_ht_conf(struct iwl_priv *priv,
-				   struct ieee80211_bss_conf *bss_conf)
-{
-}
-#endif
-
 #define IWL_DELAY_NEXT_SCAN_AFTER_ASSOC (HZ*6)
 static void iwl4965_bss_info_changed(struct ieee80211_hw *hw,
 				     struct ieee80211_vif *vif,
-- 
1.5.3.4

