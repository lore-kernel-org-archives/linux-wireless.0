Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:47406 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751173AbXKIICS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Nov 2007 03:02:18 -0500
From: Ron Rindjunsky <ron.rindjunsky@intel.com>
To: linville@tuxdriver.com
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	tomas.winkler@intel.com, flamingice@sourmilk.net,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
Subject: [PATCH 10/14] iwlwifi: 802.11n handling probe request HT IE
Date: Fri,  9 Nov 2007 10:02:02 +0200
Message-Id: <1194595332620-git-send-email-ron.rindjunsky@intel.com> (sfid-20071109_080227_016266_D5ECD62C)
In-Reply-To: <1194595331715-git-send-email-ron.rindjunsky@intel.com>
References: <1194595326527-git-send-email-ron.rindjunsky@intel.com>
 <11945953311871-git-send-email-ron.rindjunsky@intel.com>
 <11945953312850-git-send-email-ron.rindjunsky@intel.com>
 <11945953312367-git-send-email-ron.rindjunsky@intel.com>
 <1194595331658-git-send-email-ron.rindjunsky@intel.com>
 <11945953312456-git-send-email-ron.rindjunsky@intel.com>
 <11945953313491-git-send-email-ron.rindjunsky@intel.com>
 <11945953313626-git-send-email-ron.rindjunsky@intel.com>
 <11945953311042-git-send-email-ron.rindjunsky@intel.com>
 <1194595331715-git-send-email-ron.rindjunsky@intel.com>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch conforms the probe request's HT IE with the
new structures used in iwlwifi HT.

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   64 ++++++++++++---------------
 1 files changed, 29 insertions(+), 35 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 1d0946f..c0852ae 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -1821,9 +1821,9 @@ static u16 iwl_supported_rate_to_ie(u8 *ie, u16 supported_rate,
 
 #ifdef CONFIG_IWL4965_HT
 void static iwl_set_ht_capab(struct ieee80211_hw *hw,
-			     struct ieee80211_ht_capability *ht_cap,
-			     u8 use_wide_chan);
-#endif
+			     struct ieee80211_ht_cap *ht_cap,
+			     u8 use_current_config);
+#endif /* CONFIG_IWL4965_HT */
 
 /**
  * iwl_fill_probe_req - fill in all required fields and IE for probe request
@@ -1835,6 +1835,9 @@ static u16 iwl_fill_probe_req(struct iwl_priv *priv,
 	int len = 0;
 	u8 *pos = NULL;
 	u16 active_rates, ret_rates, cck_rates, active_rate_basic;
+#ifdef CONFIG_IWL4965_HT
+	struct ieee80211_hw_mode *mode;
+#endif /* CONFIG_IWL4965_HT */
 
 	/* Make sure there is enough space for the probe request,
 	 * two mandatory IEs and the data */
@@ -1918,17 +1921,14 @@ static u16 iwl_fill_probe_req(struct iwl_priv *priv,
 		len += 2 + *pos;
 
 #ifdef CONFIG_IWL4965_HT
-	if (is_direct && priv->is_ht_enabled) {
-		u8 use_wide_chan = 1;
-
-		if (priv->channel_width != IWL_CHANNEL_WIDTH_40MHZ)
-			use_wide_chan = 0;
+	mode = priv->hw->conf.mode;
+	if (mode->ht_info.ht_supported) {
 		pos += (*pos) + 1;
 		*pos++ = WLAN_EID_HT_CAPABILITY;
-		*pos++ = sizeof(struct ieee80211_ht_capability);
-		iwl_set_ht_capab(NULL, (struct ieee80211_ht_capability *)pos,
-				 use_wide_chan);
-		len += 2 + sizeof(struct ieee80211_ht_capability);
+		*pos++ = sizeof(struct ieee80211_ht_cap);
+		iwl_set_ht_capab(priv->hw,
+				(struct ieee80211_ht_cap *)pos, 0);
+		len += 2 + sizeof(struct ieee80211_ht_cap);
 	}
 #endif  /*CONFIG_IWL4965_HT */
 
@@ -8160,31 +8160,25 @@ static int iwl_mac_conf_ht(struct ieee80211_hw *hw,
 }
 
 static void iwl_set_ht_capab(struct ieee80211_hw *hw,
-			     struct ieee80211_ht_capability *ht_cap,
-			     u8 use_wide_chan)
+		struct ieee80211_ht_cap *ht_cap,
+		u8 use_current_config)
 {
-	union ht_cap_info cap;
-	union ht_param_info param_info;
+	struct ieee80211_conf *conf = &hw->conf;
+	struct ieee80211_hw_mode *mode = conf->mode;
 
-	memset(&cap, 0, sizeof(union ht_cap_info));
-	memset(&param_info, 0, sizeof(union ht_param_info));
-
-	cap.maximal_amsdu_size = HT_IE_MAX_AMSDU_SIZE_4K;
-	cap.green_field = 1;
-	cap.short_GI20 = 1;
-	cap.short_GI40 = 1;
-	cap.supported_chan_width_set = use_wide_chan;
-	cap.mimo_power_save_mode = 0x3;
-
-	param_info.max_rx_ampdu_factor = CFG_HT_RX_AMPDU_FACTOR_DEF;
-	param_info.mpdu_density = CFG_HT_MPDU_DENSITY_DEF;
-	ht_cap->capabilities_info = (__le16) cpu_to_le16(cap.val);
-	ht_cap->mac_ht_params_info = (u8) param_info.val;
-
-	ht_cap->supported_mcs_set[0] = 0xff;
-	ht_cap->supported_mcs_set[1] = 0xff;
-	ht_cap->supported_mcs_set[4] =
-	    (cap.supported_chan_width_set) ? 0x1: 0x0;
+	if (use_current_config) {
+		ht_cap->cap_info = cpu_to_le16(conf->ht_conf.cap);
+		memcpy(ht_cap->supp_mcs_set,
+				conf->ht_conf.supp_mcs_set, 16);
+	} else {
+		ht_cap->cap_info = cpu_to_le16(mode->ht_info.cap);
+		memcpy(ht_cap->supp_mcs_set,
+				mode->ht_info.supp_mcs_set, 16);
+	}
+	ht_cap->ampdu_params_info =
+		(mode->ht_info.ampdu_factor & IEEE80211_HT_CAP_AMPDU_FACTOR) |
+		((mode->ht_info.ampdu_density << 2) &
+					IEEE80211_HT_CAP_AMPDU_DENSITY);
 }
 
 static void iwl_mac_get_ht_capab(struct ieee80211_hw *hw,
-- 
1.5.3.3
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
