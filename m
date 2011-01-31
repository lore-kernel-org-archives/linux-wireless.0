Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:12564 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756237Ab1AaVxT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 16:53:19 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 05/11] iwlwifi: support RSN IBSS
Date: Mon, 31 Jan 2011 13:40:41 -0800
Message-Id: <1296510047-24576-6-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1296510047-24576-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1296510047-24576-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

In order to support RSN IBSS, we need to
(ok actually maybe it's just easiest to)
disable group key programming so that any
group-addressed frames will be decrypted
in software which handles the per-station
keys for this easily. We could keep the
encryption in the device, but that takes
more work and seems unnecessary.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   11 ++++++++++-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   11 ++++++++++-
 2 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 3e586d3..de84d1f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3207,7 +3207,8 @@ static int iwl_mac_setup_register(struct iwl_priv *priv,
 	hw->wiphy->max_remain_on_channel_duration = 1000;
 
 	hw->wiphy->flags |= WIPHY_FLAG_CUSTOM_REGULATORY |
-			    WIPHY_FLAG_DISABLE_BEACON_HINTS;
+			    WIPHY_FLAG_DISABLE_BEACON_HINTS |
+			    WIPHY_FLAG_IBSS_RSN;
 
 	/*
 	 * For now, disable PS by default because it affects
@@ -3359,6 +3360,14 @@ int iwlagn_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		return -EOPNOTSUPP;
 	}
 
+	/*
+	 * To support IBSS RSN, don't program group keys in IBSS, the
+	 * hardware will then not attempt to decrypt the frames.
+	 */
+	if (vif->type == NL80211_IFTYPE_ADHOC &&
+	    !(key->flags & IEEE80211_KEY_FLAG_PAIRWISE))
+		return -EOPNOTSUPP;
+
 	sta_id = iwl_sta_id_or_broadcast(priv, vif_priv->ctx, sta);
 	if (sta_id == IWL_INVALID_STATION)
 		return -EINVAL;
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 2945acd..76fae81 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -3286,6 +3286,14 @@ static int iwl3945_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		return -EOPNOTSUPP;
 	}
 
+	/*
+	 * To support IBSS RSN, don't program group keys in IBSS, the
+	 * hardware will then not attempt to decrypt the frames.
+	 */
+	if (vif->type == NL80211_IFTYPE_ADHOC &&
+	    !(key->flags & IEEE80211_KEY_FLAG_PAIRWISE))
+		return -EOPNOTSUPP;
+
 	static_key = !iwl_is_associated(priv, IWL_RXON_CTX_BSS);
 
 	if (!static_key) {
@@ -3915,7 +3923,8 @@ static int iwl3945_setup_mac(struct iwl_priv *priv)
 		priv->contexts[IWL_RXON_CTX_BSS].interface_modes;
 
 	hw->wiphy->flags |= WIPHY_FLAG_CUSTOM_REGULATORY |
-			    WIPHY_FLAG_DISABLE_BEACON_HINTS;
+			    WIPHY_FLAG_DISABLE_BEACON_HINTS |
+			    WIPHY_FLAG_IBSS_RSN;
 
 	hw->wiphy->max_scan_ssids = PROBE_OPTION_MAX_3945;
 	/* we create the 802.11 header and a zero-length SSID element */
-- 
1.7.0.4

