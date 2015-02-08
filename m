Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:52777 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752892AbbBHNx0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Feb 2015 08:53:26 -0500
From: Dedy Lansky <dlansky@codeaurora.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Dedy Lansky <dlansky@codeaurora.org>,
	linux-wireless@vger.kernel.org,
	Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Subject: [PATCH v2 1/2] cfg80211: add bss_type and privacy arguments in cfg80211_get_bss()
Date: Sun,  8 Feb 2015 15:52:03 +0200
Message-Id: <1423403524-22540-2-git-send-email-dlansky@codeaurora.org> (sfid-20150208_145333_447715_A2FA1B7F)
In-Reply-To: <1423403524-22540-1-git-send-email-dlansky@codeaurora.org>
References: <1423403524-22540-1-git-send-email-dlansky@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Background: 802.11ad adds new network type (PBSS) and changes "capability"
field interpretation for the DMG (60G) band.
Same 2 bits that was interpreted as "ESS" and "IBSS", are re-used as
2-bit field with 3 valid values (and 1 reserved). Valid values are:
"IBSS", "PBSS" (new) and "AP".

New enum added into cfg80211.h - ieee80211_bss_type with valid network types.
When searching for particular network type in cfg80211_get_bss,
"capa_mask" and "capa_val" would not work due to difference described above.
Thus, need to decouple network type (bss_type) and handle it separately.

Remaining bits in "capa_mask" and "capa_val" are used only for PRIVACY matching
so replace those two with privacy enum.

Signed-off-by: Dedy Lansky <dlansky@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/mac.c       |  3 +-
 drivers/net/wireless/ath/ath6kl/cfg80211.c  |  9 +--
 drivers/net/wireless/ath/wil6210/cfg80211.c |  2 +-
 drivers/net/wireless/cw1200/sta.c           |  4 +-
 drivers/net/wireless/libertas/cfg.c         |  6 +-
 drivers/net/wireless/mwifiex/cfg80211.c     |  8 +--
 include/net/cfg80211.h                      | 40 +++++++++++++-
 net/mac80211/ibss.c                         | 43 ++++-----------
 net/wireless/ibss.c                         |  2 +-
 net/wireless/mlme.c                         |  6 +-
 net/wireless/scan.c                         | 86 ++++++++++++++++++++++++++---
 net/wireless/sme.c                          | 16 ++----
 net/wireless/trace.h                        | 24 ++++----
 13 files changed, 169 insertions(+), 80 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 60a524b..96f6306 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -1206,7 +1206,8 @@ static void ath10k_peer_assoc_h_crypto(struct ath10k *ar,
 	lockdep_assert_held(&ar->conf_mutex);
 
 	bss = cfg80211_get_bss(ar->hw->wiphy, ar->hw->conf.chandef.chan,
-			       info->bssid, NULL, 0, 0, 0);
+			       info->bssid, NULL, 0, IEEE80211_BSS_TYPE_ANY,
+			       IEEE80211_PRIVACY_ANY);
 	if (bss) {
 		const struct cfg80211_bss_ies *ies;
 
diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 85da63a..ff7ba5c 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -686,20 +686,21 @@ ath6kl_add_bss_if_needed(struct ath6kl_vif *vif,
 {
 	struct ath6kl *ar = vif->ar;
 	struct cfg80211_bss *bss;
-	u16 cap_mask, cap_val;
+	u16 cap_val;
+	enum ieee80211_bss_type bss_type;
 	u8 *ie;
 
 	if (nw_type & ADHOC_NETWORK) {
-		cap_mask = WLAN_CAPABILITY_IBSS;
 		cap_val = WLAN_CAPABILITY_IBSS;
+		bss_type = IEEE80211_BSS_TYPE_IBSS;
 	} else {
-		cap_mask = WLAN_CAPABILITY_ESS;
 		cap_val = WLAN_CAPABILITY_ESS;
+		bss_type = IEEE80211_BSS_TYPE_ESS;
 	}
 
 	bss = cfg80211_get_bss(ar->wiphy, chan, bssid,
 			       vif->ssid, vif->ssid_len,
-			       cap_mask, cap_val);
+			       bss_type, IEEE80211_PRIVACY_ANY);
 	if (bss == NULL) {
 		/*
 		 * Since cfg80211 may not yet know about the BSS,
diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index e758f43..c3d29a7 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -370,7 +370,7 @@ static int wil_cfg80211_connect(struct wiphy *wiphy,
 
 	bss = cfg80211_get_bss(wiphy, sme->channel, sme->bssid,
 			       sme->ssid, sme->ssid_len,
-			       WLAN_CAPABILITY_ESS, WLAN_CAPABILITY_ESS);
+			       IEEE80211_BSS_TYPE_ESS, IEEE80211_PRIVACY_ANY);
 	if (!bss) {
 		wil_err(wil, "Unable to find BSS\n");
 		return -ENOENT;
diff --git a/drivers/net/wireless/cw1200/sta.c b/drivers/net/wireless/cw1200/sta.c
index 4a47c7f..1b58b2e 100644
--- a/drivers/net/wireless/cw1200/sta.c
+++ b/drivers/net/wireless/cw1200/sta.c
@@ -1240,8 +1240,8 @@ static void cw1200_do_join(struct cw1200_common *priv)
 
 	bssid = priv->vif->bss_conf.bssid;
 
-	bss = cfg80211_get_bss(priv->hw->wiphy, priv->channel,
-			bssid, NULL, 0, 0, 0);
+	bss = cfg80211_get_bss(priv->hw->wiphy, priv->channel, bssid, NULL, 0,
+			       IEEE80211_BSS_TYPE_ANY, IEEE80211_PRIVACY_ANY);
 
 	if (!bss && !conf->ibss_joined) {
 		wsm_unlock_tx(priv);
diff --git a/drivers/net/wireless/libertas/cfg.c b/drivers/net/wireless/libertas/cfg.c
index a92985a..1a4d558 100644
--- a/drivers/net/wireless/libertas/cfg.c
+++ b/drivers/net/wireless/libertas/cfg.c
@@ -1356,8 +1356,8 @@ static int lbs_cfg_connect(struct wiphy *wiphy, struct net_device *dev,
 
 	/* Find the BSS we want using available scan results */
 	bss = cfg80211_get_bss(wiphy, sme->channel, sme->bssid,
-		sme->ssid, sme->ssid_len,
-		WLAN_CAPABILITY_ESS, WLAN_CAPABILITY_ESS);
+		sme->ssid, sme->ssid_len, IEEE80211_BSS_TYPE_ESS,
+		IEEE80211_PRIVACY_ANY);
 	if (!bss) {
 		wiphy_err(wiphy, "assoc: bss %pM not in scan results\n",
 			  sme->bssid);
@@ -2000,7 +2000,7 @@ static int lbs_join_ibss(struct wiphy *wiphy, struct net_device *dev,
 	 * bss list is populated already */
 	bss = cfg80211_get_bss(wiphy, params->chandef.chan, params->bssid,
 		params->ssid, params->ssid_len,
-		WLAN_CAPABILITY_IBSS, WLAN_CAPABILITY_IBSS);
+		IEEE80211_BSS_TYPE_IBSS, IEEE80211_PRIVACY_ANY);
 
 	if (bss) {
 		ret = lbs_ibss_join_existing(priv, params, bss);
diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 41c8e25..a47eb55 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -1954,13 +1954,13 @@ done:
 		if (mode == NL80211_IFTYPE_ADHOC)
 			bss = cfg80211_get_bss(priv->wdev.wiphy, channel,
 					       bssid, ssid, ssid_len,
-					       WLAN_CAPABILITY_IBSS,
-					       WLAN_CAPABILITY_IBSS);
+					       IEEE80211_BSS_TYPE_IBSS,
+					       IEEE80211_PRIVACY_ANY);
 		else
 			bss = cfg80211_get_bss(priv->wdev.wiphy, channel,
 					       bssid, ssid, ssid_len,
-					       WLAN_CAPABILITY_ESS,
-					       WLAN_CAPABILITY_ESS);
+					       IEEE80211_BSS_TYPE_ESS,
+					       IEEE80211_PRIVACY_ANY);
 
 		if (!bss) {
 			if (is_scanning_required) {
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 64e09e1..acf8f09 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -215,6 +215,40 @@ enum ieee80211_rate_flags {
 };
 
 /**
+ * enum ieee80211_bss_type - BSS type as defined in 80211ad #6.3.3.2
+ *
+ * @IEEE80211_BSS_TYPE_ESS: Infrastructure BSS
+ * @IEEE80211_BSS_TYPE_PBSS: Personal BSS
+ * @IEEE80211_BSS_TYPE_IBSS: Independent BSS
+ * @IEEE80211_BSS_TYPE_MBSS: Mesh BSS
+ * @IEEE80211_BSS_TYPE_ANY: Wildcard value for matching any BSS type
+ */
+enum ieee80211_bss_type {
+	IEEE80211_BSS_TYPE_ESS,
+	IEEE80211_BSS_TYPE_PBSS,
+	IEEE80211_BSS_TYPE_IBSS,
+	IEEE80211_BSS_TYPE_MBSS,
+	IEEE80211_BSS_TYPE_ANY
+};
+
+/**
+ * enum ieee80211_privacy - privacy settings
+ *
+ * Privacy bit in capability field as defined in 80211 #8.4.1.4
+ *
+ * @IEEE80211_PRIVACY_ON: privacy bit set
+ * @IEEE80211_PRIVACY_OFF: privacy bit clear
+ * @IEEE80211_PRIVACY_ANY: Wildcard value for matching any privacy setting
+ */
+enum ieee80211_privacy {
+	IEEE80211_PRIVACY_ON,
+	IEEE80211_PRIVACY_OFF,
+	IEEE80211_PRIVACY_ANY
+};
+
+#define IEEE80211_PRIVACY(x) (x ? IEEE80211_PRIVACY_ON : IEEE80211_PRIVACY_OFF)
+
+/**
  * struct ieee80211_rate - bitrate definition
  *
  * This structure describes a bitrate that an 802.11 PHY can
@@ -4012,14 +4046,16 @@ struct cfg80211_bss *cfg80211_get_bss(struct wiphy *wiphy,
 				      struct ieee80211_channel *channel,
 				      const u8 *bssid,
 				      const u8 *ssid, size_t ssid_len,
-				      u16 capa_mask, u16 capa_val);
+				      enum ieee80211_bss_type bss_type,
+				      enum ieee80211_privacy);
 static inline struct cfg80211_bss *
 cfg80211_get_ibss(struct wiphy *wiphy,
 		  struct ieee80211_channel *channel,
 		  const u8 *ssid, size_t ssid_len)
 {
 	return cfg80211_get_bss(wiphy, channel, NULL, ssid, ssid_len,
-				WLAN_CAPABILITY_IBSS, WLAN_CAPABILITY_IBSS);
+				IEEE80211_BSS_TYPE_IBSS,
+				IEEE80211_PRIVACY_ANY);
 }
 
 /**
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index b606b53..ee93d7d 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -470,22 +470,19 @@ int ieee80211_ibss_csa_beacon(struct ieee80211_sub_if_data *sdata,
 	struct beacon_data *presp, *old_presp;
 	struct cfg80211_bss *cbss;
 	const struct cfg80211_bss_ies *ies;
-	u16 capability;
+	u16 capability = 0;
 	u64 tsf;
 	int ret = 0;
 
 	sdata_assert_lock(sdata);
 
-	capability = WLAN_CAPABILITY_IBSS;
-
 	if (ifibss->privacy)
-		capability |= WLAN_CAPABILITY_PRIVACY;
+		capability = WLAN_CAPABILITY_PRIVACY;
 
 	cbss = cfg80211_get_bss(sdata->local->hw.wiphy, ifibss->chandef.chan,
 				ifibss->bssid, ifibss->ssid,
-				ifibss->ssid_len, WLAN_CAPABILITY_IBSS |
-				WLAN_CAPABILITY_PRIVACY,
-				capability);
+				ifibss->ssid_len, IEEE80211_BSS_TYPE_IBSS,
+				IEEE80211_PRIVACY(ifibss->privacy));
 
 	if (WARN_ON(!cbss)) {
 		ret = -EINVAL;
@@ -525,23 +522,17 @@ int ieee80211_ibss_finish_csa(struct ieee80211_sub_if_data *sdata)
 	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
 	struct cfg80211_bss *cbss;
 	int err, changed = 0;
-	u16 capability;
 
 	sdata_assert_lock(sdata);
 
 	/* update cfg80211 bss information with the new channel */
 	if (!is_zero_ether_addr(ifibss->bssid)) {
-		capability = WLAN_CAPABILITY_IBSS;
-
-		if (ifibss->privacy)
-			capability |= WLAN_CAPABILITY_PRIVACY;
-
 		cbss = cfg80211_get_bss(sdata->local->hw.wiphy,
 					ifibss->chandef.chan,
 					ifibss->bssid, ifibss->ssid,
-					ifibss->ssid_len, WLAN_CAPABILITY_IBSS |
-					WLAN_CAPABILITY_PRIVACY,
-					capability);
+					ifibss->ssid_len,
+					IEEE80211_BSS_TYPE_IBSS,
+					IEEE80211_PRIVACY(ifibss->privacy));
 		/* XXX: should not really modify cfg80211 data */
 		if (cbss) {
 			cbss->channel = sdata->csa_chandef.chan;
@@ -682,19 +673,13 @@ static void ieee80211_ibss_disconnect(struct ieee80211_sub_if_data *sdata)
 	struct cfg80211_bss *cbss;
 	struct beacon_data *presp;
 	struct sta_info *sta;
-	u16 capability;
 
 	if (!is_zero_ether_addr(ifibss->bssid)) {
-		capability = WLAN_CAPABILITY_IBSS;
-
-		if (ifibss->privacy)
-			capability |= WLAN_CAPABILITY_PRIVACY;
-
 		cbss = cfg80211_get_bss(local->hw.wiphy, ifibss->chandef.chan,
 					ifibss->bssid, ifibss->ssid,
-					ifibss->ssid_len, WLAN_CAPABILITY_IBSS |
-					WLAN_CAPABILITY_PRIVACY,
-					capability);
+					ifibss->ssid_len,
+					IEEE80211_BSS_TYPE_IBSS,
+					IEEE80211_PRIVACY(ifibss->privacy));
 
 		if (cbss) {
 			cfg80211_unlink_bss(local->hw.wiphy, cbss);
@@ -1325,7 +1310,6 @@ static void ieee80211_sta_find_ibss(struct ieee80211_sub_if_data *sdata)
 	const u8 *bssid = NULL;
 	enum nl80211_bss_scan_width scan_width;
 	int active_ibss;
-	u16 capability;
 
 	sdata_assert_lock(sdata);
 
@@ -1335,9 +1319,6 @@ static void ieee80211_sta_find_ibss(struct ieee80211_sub_if_data *sdata)
 	if (active_ibss)
 		return;
 
-	capability = WLAN_CAPABILITY_IBSS;
-	if (ifibss->privacy)
-		capability |= WLAN_CAPABILITY_PRIVACY;
 	if (ifibss->fixed_bssid)
 		bssid = ifibss->bssid;
 	if (ifibss->fixed_channel)
@@ -1346,8 +1327,8 @@ static void ieee80211_sta_find_ibss(struct ieee80211_sub_if_data *sdata)
 		bssid = ifibss->bssid;
 	cbss = cfg80211_get_bss(local->hw.wiphy, chan, bssid,
 				ifibss->ssid, ifibss->ssid_len,
-				WLAN_CAPABILITY_IBSS | WLAN_CAPABILITY_PRIVACY,
-				capability);
+				IEEE80211_BSS_TYPE_IBSS,
+				IEEE80211_PRIVACY(ifibss->privacy));
 
 	if (cbss) {
 		struct ieee80211_bss *bss;
diff --git a/net/wireless/ibss.c b/net/wireless/ibss.c
index e24fc58..1a65662 100644
--- a/net/wireless/ibss.c
+++ b/net/wireless/ibss.c
@@ -30,7 +30,7 @@ void __cfg80211_ibss_joined(struct net_device *dev, const u8 *bssid,
 		return;
 
 	bss = cfg80211_get_bss(wdev->wiphy, channel, bssid, NULL, 0,
-			       WLAN_CAPABILITY_IBSS, WLAN_CAPABILITY_IBSS);
+			       IEEE80211_BSS_TYPE_IBSS, IEEE80211_PRIVACY_ANY);
 
 	if (WARN_ON(!bss))
 		return;
diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index 2c52b59..7aae329 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -229,7 +229,8 @@ int cfg80211_mlme_auth(struct cfg80211_registered_device *rdev,
 		return -EALREADY;
 
 	req.bss = cfg80211_get_bss(&rdev->wiphy, chan, bssid, ssid, ssid_len,
-				   WLAN_CAPABILITY_ESS, WLAN_CAPABILITY_ESS);
+				   IEEE80211_BSS_TYPE_ESS,
+				   IEEE80211_PRIVACY_ANY);
 	if (!req.bss)
 		return -ENOENT;
 
@@ -296,7 +297,8 @@ int cfg80211_mlme_assoc(struct cfg80211_registered_device *rdev,
 				   rdev->wiphy.vht_capa_mod_mask);
 
 	req->bss = cfg80211_get_bss(&rdev->wiphy, chan, bssid, ssid, ssid_len,
-				    WLAN_CAPABILITY_ESS, WLAN_CAPABILITY_ESS);
+				    IEEE80211_BSS_TYPE_ESS,
+				    IEEE80211_PRIVACY_ANY);
 	if (!req->bss)
 		return -ENOENT;
 
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index c705c3e..dcfb4e7 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -531,24 +531,78 @@ static int cmp_bss(struct cfg80211_bss *a,
 	}
 }
 
+static bool cfg80211_bss_type_match(u16 capability,
+				    enum ieee80211_band band,
+				    enum ieee80211_bss_type bss_type)
+{
+	bool ret = true;
+	u16 mask, val;
+
+	if (bss_type == IEEE80211_BSS_TYPE_ANY)
+		return ret;
+
+	if (band == IEEE80211_BAND_60GHZ) {
+		mask = WLAN_CAPABILITY_DMG_TYPE_MASK;
+		switch (bss_type) {
+		case IEEE80211_BSS_TYPE_ESS:
+			val = WLAN_CAPABILITY_DMG_TYPE_AP;
+			break;
+		case IEEE80211_BSS_TYPE_PBSS:
+			val = WLAN_CAPABILITY_DMG_TYPE_PBSS;
+			break;
+		case IEEE80211_BSS_TYPE_IBSS:
+			val = WLAN_CAPABILITY_DMG_TYPE_IBSS;
+			break;
+		default:
+			return false;
+		}
+	} else {
+		mask = (WLAN_CAPABILITY_ESS | WLAN_CAPABILITY_IBSS);
+		switch (bss_type) {
+		case IEEE80211_BSS_TYPE_ESS:
+			val = WLAN_CAPABILITY_ESS;
+			break;
+		case IEEE80211_BSS_TYPE_IBSS:
+			val = WLAN_CAPABILITY_IBSS;
+			break;
+		case IEEE80211_BSS_TYPE_MBSS:
+			val = 0;
+			break;
+		default:
+			return false;
+		}
+	}
+
+	ret = ((capability & mask) == val);
+	return ret;
+}
+
 /* Returned bss is reference counted and must be cleaned up appropriately. */
 struct cfg80211_bss *cfg80211_get_bss(struct wiphy *wiphy,
 				      struct ieee80211_channel *channel,
 				      const u8 *bssid,
 				      const u8 *ssid, size_t ssid_len,
-				      u16 capa_mask, u16 capa_val)
+				      enum ieee80211_bss_type bss_type,
+				      enum ieee80211_privacy privacy)
 {
 	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
 	struct cfg80211_internal_bss *bss, *res = NULL;
 	unsigned long now = jiffies;
+	int bss_privacy;
 
-	trace_cfg80211_get_bss(wiphy, channel, bssid, ssid, ssid_len, capa_mask,
-			       capa_val);
+	trace_cfg80211_get_bss(wiphy, channel, bssid, ssid, ssid_len, bss_type,
+			       privacy);
 
 	spin_lock_bh(&rdev->bss_lock);
 
 	list_for_each_entry(bss, &rdev->bss_list, list) {
-		if ((bss->pub.capability & capa_mask) != capa_val)
+		if (!cfg80211_bss_type_match(bss->pub.capability,
+					     bss->pub.channel->band, bss_type))
+			continue;
+
+		bss_privacy = (bss->pub.capability & WLAN_CAPABILITY_PRIVACY);
+		if ((privacy == IEEE80211_PRIVACY_ON && !bss_privacy) ||
+		    (privacy == IEEE80211_PRIVACY_OFF && bss_privacy))
 			continue;
 		if (channel && bss->pub.channel != channel)
 			continue;
@@ -896,6 +950,7 @@ cfg80211_inform_bss_width(struct wiphy *wiphy,
 	struct cfg80211_bss_ies *ies;
 	struct ieee80211_channel *channel;
 	struct cfg80211_internal_bss tmp = {}, *res;
+	int bss_type;
 	bool signal_valid;
 
 	if (WARN_ON(!wiphy))
@@ -950,8 +1005,15 @@ cfg80211_inform_bss_width(struct wiphy *wiphy,
 	if (!res)
 		return NULL;
 
-	if (res->pub.capability & WLAN_CAPABILITY_ESS)
-		regulatory_hint_found_beacon(wiphy, channel, gfp);
+	if (channel->band == IEEE80211_BAND_60GHZ) {
+		bss_type = res->pub.capability & WLAN_CAPABILITY_DMG_TYPE_MASK;
+		if (bss_type == WLAN_CAPABILITY_DMG_TYPE_AP ||
+		    bss_type == WLAN_CAPABILITY_DMG_TYPE_PBSS)
+			regulatory_hint_found_beacon(wiphy, channel, gfp);
+	} else {
+		if (res->pub.capability & WLAN_CAPABILITY_ESS)
+			regulatory_hint_found_beacon(wiphy, channel, gfp);
+	}
 
 	trace_cfg80211_return_bss(&res->pub);
 	/* cfg80211_bss_update gives us a referenced result */
@@ -973,6 +1035,7 @@ cfg80211_inform_bss_width_frame(struct wiphy *wiphy,
 	bool signal_valid;
 	size_t ielen = len - offsetof(struct ieee80211_mgmt,
 				      u.probe_resp.variable);
+	int bss_type;
 
 	BUILD_BUG_ON(offsetof(struct ieee80211_mgmt, u.probe_resp.variable) !=
 			offsetof(struct ieee80211_mgmt, u.beacon.variable));
@@ -1025,8 +1088,15 @@ cfg80211_inform_bss_width_frame(struct wiphy *wiphy,
 	if (!res)
 		return NULL;
 
-	if (res->pub.capability & WLAN_CAPABILITY_ESS)
-		regulatory_hint_found_beacon(wiphy, channel, gfp);
+	if (channel->band == IEEE80211_BAND_60GHZ) {
+		bss_type = res->pub.capability & WLAN_CAPABILITY_DMG_TYPE_MASK;
+		if (bss_type == WLAN_CAPABILITY_DMG_TYPE_AP ||
+		    bss_type == WLAN_CAPABILITY_DMG_TYPE_PBSS)
+			regulatory_hint_found_beacon(wiphy, channel, gfp);
+	} else {
+		if (res->pub.capability & WLAN_CAPABILITY_ESS)
+			regulatory_hint_found_beacon(wiphy, channel, gfp);
+	}
 
 	trace_cfg80211_return_bss(&res->pub);
 	/* cfg80211_bss_update gives us a referenced result */
diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index 0ab3711..ea1da66 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -257,19 +257,15 @@ static struct cfg80211_bss *cfg80211_get_conn_bss(struct wireless_dev *wdev)
 {
 	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
 	struct cfg80211_bss *bss;
-	u16 capa = WLAN_CAPABILITY_ESS;
 
 	ASSERT_WDEV_LOCK(wdev);
 
-	if (wdev->conn->params.privacy)
-		capa |= WLAN_CAPABILITY_PRIVACY;
-
 	bss = cfg80211_get_bss(wdev->wiphy, wdev->conn->params.channel,
 			       wdev->conn->params.bssid,
 			       wdev->conn->params.ssid,
 			       wdev->conn->params.ssid_len,
-			       WLAN_CAPABILITY_ESS | WLAN_CAPABILITY_PRIVACY,
-			       capa);
+			       IEEE80211_BSS_TYPE_ESS,
+			       IEEE80211_PRIVACY(wdev->conn->params.privacy));
 	if (!bss)
 		return NULL;
 
@@ -637,8 +633,8 @@ void __cfg80211_connect_result(struct net_device *dev, const u8 *bssid,
 		WARN_ON_ONCE(!wiphy_to_rdev(wdev->wiphy)->ops->connect);
 		bss = cfg80211_get_bss(wdev->wiphy, NULL, bssid,
 				       wdev->ssid, wdev->ssid_len,
-				       WLAN_CAPABILITY_ESS,
-				       WLAN_CAPABILITY_ESS);
+				       IEEE80211_BSS_TYPE_ESS,
+				       IEEE80211_PRIVACY_ANY);
 		if (bss)
 			cfg80211_hold_bss(bss_from_pub(bss));
 	}
@@ -795,8 +791,8 @@ void cfg80211_roamed(struct net_device *dev,
 	struct cfg80211_bss *bss;
 
 	bss = cfg80211_get_bss(wdev->wiphy, channel, bssid, wdev->ssid,
-			       wdev->ssid_len, WLAN_CAPABILITY_ESS,
-			       WLAN_CAPABILITY_ESS);
+			       wdev->ssid_len,
+			       IEEE80211_BSS_TYPE_ESS, IEEE80211_PRIVACY_ANY);
 	if (WARN_ON(!bss))
 		return;
 
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index b17b369..b19773c 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -2636,28 +2636,30 @@ DEFINE_EVENT(wiphy_only_evt, cfg80211_sched_scan_stopped,
 TRACE_EVENT(cfg80211_get_bss,
 	TP_PROTO(struct wiphy *wiphy, struct ieee80211_channel *channel,
 		 const u8 *bssid, const u8 *ssid, size_t ssid_len,
-		 u16 capa_mask, u16 capa_val),
-	TP_ARGS(wiphy, channel, bssid, ssid, ssid_len, capa_mask, capa_val),
+		 enum ieee80211_bss_type bss_type,
+		 enum ieee80211_privacy privacy),
+	TP_ARGS(wiphy, channel, bssid, ssid, ssid_len, bss_type, privacy),
 	TP_STRUCT__entry(
 		WIPHY_ENTRY
 		CHAN_ENTRY
 		MAC_ENTRY(bssid)
 		__dynamic_array(u8, ssid, ssid_len)
-		__field(u16, capa_mask)
-		__field(u16, capa_val)
+		__field(enum ieee80211_bss_type, bss_type)
+		__field(enum ieee80211_privacy, privacy)
 	),
 	TP_fast_assign(
 		WIPHY_ASSIGN;
 		CHAN_ASSIGN(channel);
 		MAC_ASSIGN(bssid, bssid);
 		memcpy(__get_dynamic_array(ssid), ssid, ssid_len);
-		__entry->capa_mask = capa_mask;
-		__entry->capa_val = capa_val;
-	),
-	TP_printk(WIPHY_PR_FMT ", " CHAN_PR_FMT ", " MAC_PR_FMT ", buf: %#.2x, "
-		  "capa_mask: %d, capa_val: %u", WIPHY_PR_ARG, CHAN_PR_ARG,
-		  MAC_PR_ARG(bssid), ((u8 *)__get_dynamic_array(ssid))[0],
-		  __entry->capa_mask, __entry->capa_val)
+		__entry->bss_type = bss_type;
+		__entry->privacy = privacy;
+	),
+	TP_printk(WIPHY_PR_FMT ", " CHAN_PR_FMT ", " MAC_PR_FMT
+		  ", buf: %#.2x, bss_type: %d, privacy: %d",
+		  WIPHY_PR_ARG, CHAN_PR_ARG, MAC_PR_ARG(bssid),
+		  ((u8 *)__get_dynamic_array(ssid))[0], __entry->bss_type,
+		  __entry->privacy)
 );
 
 TRACE_EVENT(cfg80211_inform_bss_width_frame,
-- 
1.9.1

