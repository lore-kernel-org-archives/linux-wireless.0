Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:38373 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757598AbbA0H4K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jan 2015 02:56:10 -0500
From: Dedy Lansky <dlansky@codeaurora.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Dedy Lansky <dlansky@codeaurora.org>,
	linux-wireless@vger.kernel.org,
	Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Subject: [PATCH] cfg80211: PBSS basic support
Date: Tue, 27 Jan 2015 09:55:12 +0200
Message-Id: <1422345312-2963-1-git-send-email-dlansky@codeaurora.org> (sfid-20150127_085615_851946_FBA10CB1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

add support for connecting to Personal BSS (PBSS) network type.

802.11ad adds new network type (PBSS) and changes "capability" field
interpretation for the DMG (60G) band.
Same 2 bits that was interpreted as "ESS" and "IBSS", are re-used as
2-bit field with 3 valid values (and 1 reserved). Valid values are:
"IBSS", "PBSS" (new) and "AP".

New enum added into ieee80211.h - ieee80211_bsstype with valid network types.
When searching for particular network type (e.g. in cfg80211_get_bss),
"capa_mask" and "capa_val" would not work due to difference described above.
Thus, need to decouple network type and handle it separately.
"capa_mask" and "capa_val" are kept for masking common capability bits
like PRIVACY.

Signed-off-by: Dedy Lansky <dlansky@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/mac.c       |  3 +-
 drivers/net/wireless/ath/ath6kl/cfg80211.c  |  9 ++--
 drivers/net/wireless/ath/wil6210/cfg80211.c |  2 +-
 drivers/net/wireless/cw1200/sta.c           |  2 +-
 drivers/net/wireless/libertas/cfg.c         |  6 +--
 drivers/net/wireless/mwifiex/cfg80211.c     |  8 +--
 include/linux/ieee80211.h                   |  9 ++++
 include/net/cfg80211.h                      |  5 +-
 net/mac80211/ibss.c                         | 44 +++++++---------
 net/wireless/ibss.c                         |  2 +-
 net/wireless/mlme.c                         |  4 +-
 net/wireless/scan.c                         | 81 ++++++++++++++++++++++++++---
 net/wireless/sme.c                          | 21 +++++---
 net/wireless/trace.h                        | 13 +++--
 14 files changed, 147 insertions(+), 62 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 08f2934..2efbd0c 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -1203,7 +1203,8 @@ static void ath10k_peer_assoc_h_crypto(struct ath10k *ar,
 	lockdep_assert_held(&ar->conf_mutex);
 
 	bss = cfg80211_get_bss(ar->hw->wiphy, ar->hw->conf.chandef.chan,
-			       info->bssid, NULL, 0, 0, 0);
+			       info->bssid, NULL, 0, IEEE80211_BSS_TYPE_ANY,
+			       0, 0);
 	if (bss) {
 		const struct cfg80211_bss_ies *ies;
 
diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 85da63a..9e6309a 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -686,20 +686,21 @@ ath6kl_add_bss_if_needed(struct ath6kl_vif *vif,
 {
 	struct ath6kl *ar = vif->ar;
 	struct cfg80211_bss *bss;
-	u16 cap_mask, cap_val;
+	u16 cap_val;
+	enum ieee80211_bsstype bss_type;
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
+			       bss_type, 0, 0);
 	if (bss == NULL) {
 		/*
 		 * Since cfg80211 may not yet know about the BSS,
diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index bd013fd..487e922 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -370,7 +370,7 @@ static int wil_cfg80211_connect(struct wiphy *wiphy,
 
 	bss = cfg80211_get_bss(wiphy, sme->channel, sme->bssid,
 			       sme->ssid, sme->ssid_len,
-			       WLAN_CAPABILITY_ESS, WLAN_CAPABILITY_ESS);
+			       IEEE80211_BSS_TYPE_ESS, 0, 0);
 	if (!bss) {
 		wil_err(wil, "Unable to find BSS\n");
 		return -ENOENT;
diff --git a/drivers/net/wireless/cw1200/sta.c b/drivers/net/wireless/cw1200/sta.c
index 4a47c7f..faa0598 100644
--- a/drivers/net/wireless/cw1200/sta.c
+++ b/drivers/net/wireless/cw1200/sta.c
@@ -1241,7 +1241,7 @@ static void cw1200_do_join(struct cw1200_common *priv)
 	bssid = priv->vif->bss_conf.bssid;
 
 	bss = cfg80211_get_bss(priv->hw->wiphy, priv->channel,
-			bssid, NULL, 0, 0, 0);
+			bssid, NULL, 0, IEEE80211_BSS_TYPE_ANY, 0, 0);
 
 	if (!bss && !conf->ibss_joined) {
 		wsm_unlock_tx(priv);
diff --git a/drivers/net/wireless/libertas/cfg.c b/drivers/net/wireless/libertas/cfg.c
index a92985a..eca58ef 100644
--- a/drivers/net/wireless/libertas/cfg.c
+++ b/drivers/net/wireless/libertas/cfg.c
@@ -1356,8 +1356,8 @@ static int lbs_cfg_connect(struct wiphy *wiphy, struct net_device *dev,
 
 	/* Find the BSS we want using available scan results */
 	bss = cfg80211_get_bss(wiphy, sme->channel, sme->bssid,
-		sme->ssid, sme->ssid_len,
-		WLAN_CAPABILITY_ESS, WLAN_CAPABILITY_ESS);
+		sme->ssid, sme->ssid_len, IEEE80211_BSS_TYPE_ESS,
+		0, 0);
 	if (!bss) {
 		wiphy_err(wiphy, "assoc: bss %pM not in scan results\n",
 			  sme->bssid);
@@ -2000,7 +2000,7 @@ static int lbs_join_ibss(struct wiphy *wiphy, struct net_device *dev,
 	 * bss list is populated already */
 	bss = cfg80211_get_bss(wiphy, params->chandef.chan, params->bssid,
 		params->ssid, params->ssid_len,
-		WLAN_CAPABILITY_IBSS, WLAN_CAPABILITY_IBSS);
+		IEEE80211_BSS_TYPE_IBSS, 0, 0);
 
 	if (bss) {
 		ret = lbs_ibss_join_existing(priv, params, bss);
diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index b3bf2cd..ffa42f3 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -1736,13 +1736,13 @@ done:
 		if (mode == NL80211_IFTYPE_ADHOC)
 			bss = cfg80211_get_bss(priv->wdev->wiphy, channel,
 					       bssid, ssid, ssid_len,
-					       WLAN_CAPABILITY_IBSS,
-					       WLAN_CAPABILITY_IBSS);
+					       IEEE80211_BSS_TYPE_IBSS,
+					       0, 0);
 		else
 			bss = cfg80211_get_bss(priv->wdev->wiphy, channel,
 					       bssid, ssid, ssid_len,
-					       WLAN_CAPABILITY_ESS,
-					       WLAN_CAPABILITY_ESS);
+					       IEEE80211_BSS_TYPE_ESS,
+					       0, 0);
 
 		if (!bss) {
 			if (is_scanning_required) {
diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 4f4eea8..4c4eead 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -1602,6 +1602,15 @@ enum {
 	IEEE80211_BANDID_60G   = 5, /* 60 GHz */
 };
 
+/* BSS Type, 802.11ad #6.3.3.2 */
+enum ieee80211_bsstype {
+	IEEE80211_BSS_TYPE_ESS,
+	IEEE80211_BSS_TYPE_PBSS,
+	IEEE80211_BSS_TYPE_IBSS,
+	IEEE80211_BSS_TYPE_MBSS,
+	IEEE80211_BSS_TYPE_ANY
+};
+
 /* Status codes */
 enum ieee80211_statuscode {
 	WLAN_STATUS_SUCCESS = 0,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 7b44ba0..11065d8 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -3387,6 +3387,7 @@ struct cfg80211_cached_keys;
  *	registered for unexpected class 3 frames (AP mode)
  * @conn: (private) cfg80211 software SME connection state machine data
  * @connect_keys: (private) keys to set after connection is established
+ * @bss_type: connecting/connected BSS type
  * @ibss_fixed: (private) IBSS is using fixed BSSID
  * @ibss_dfs_possible: (private) IBSS may change to a DFS channel
  * @event_list: (private) list for internal event processing
@@ -3417,6 +3418,7 @@ struct wireless_dev {
 	u8 ssid_len, mesh_id_len, mesh_id_up_len;
 	struct cfg80211_conn *conn;
 	struct cfg80211_cached_keys *connect_keys;
+	enum ieee80211_bsstype bss_type;
 
 	struct list_head event_list;
 	spinlock_t event_lock;
@@ -4007,6 +4009,7 @@ struct cfg80211_bss *cfg80211_get_bss(struct wiphy *wiphy,
 				      struct ieee80211_channel *channel,
 				      const u8 *bssid,
 				      const u8 *ssid, size_t ssid_len,
+				      enum ieee80211_bsstype bss_type,
 				      u16 capa_mask, u16 capa_val);
 static inline struct cfg80211_bss *
 cfg80211_get_ibss(struct wiphy *wiphy,
@@ -4014,7 +4017,7 @@ cfg80211_get_ibss(struct wiphy *wiphy,
 		  const u8 *ssid, size_t ssid_len)
 {
 	return cfg80211_get_bss(wiphy, channel, NULL, ssid, ssid_len,
-				WLAN_CAPABILITY_IBSS, WLAN_CAPABILITY_IBSS);
+				IEEE80211_BSS_TYPE_IBSS, 0, 0);
 }
 
 /**
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index b606b53..14bfea6 100644
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
+				WLAN_CAPABILITY_PRIVACY, capability);
 
 	if (WARN_ON(!cbss)) {
 		ret = -EINVAL;
@@ -525,23 +522,21 @@ int ieee80211_ibss_finish_csa(struct ieee80211_sub_if_data *sdata)
 	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
 	struct cfg80211_bss *cbss;
 	int err, changed = 0;
-	u16 capability;
+	u16 capability = 0;
 
 	sdata_assert_lock(sdata);
 
 	/* update cfg80211 bss information with the new channel */
 	if (!is_zero_ether_addr(ifibss->bssid)) {
-		capability = WLAN_CAPABILITY_IBSS;
-
 		if (ifibss->privacy)
-			capability |= WLAN_CAPABILITY_PRIVACY;
+			capability = WLAN_CAPABILITY_PRIVACY;
 
 		cbss = cfg80211_get_bss(sdata->local->hw.wiphy,
 					ifibss->chandef.chan,
 					ifibss->bssid, ifibss->ssid,
-					ifibss->ssid_len, WLAN_CAPABILITY_IBSS |
-					WLAN_CAPABILITY_PRIVACY,
-					capability);
+					ifibss->ssid_len,
+					IEEE80211_BSS_TYPE_IBSS,
+					WLAN_CAPABILITY_PRIVACY, capability);
 		/* XXX: should not really modify cfg80211 data */
 		if (cbss) {
 			cbss->channel = sdata->csa_chandef.chan;
@@ -682,19 +677,17 @@ static void ieee80211_ibss_disconnect(struct ieee80211_sub_if_data *sdata)
 	struct cfg80211_bss *cbss;
 	struct beacon_data *presp;
 	struct sta_info *sta;
-	u16 capability;
+	u16 capability = 0;
 
 	if (!is_zero_ether_addr(ifibss->bssid)) {
-		capability = WLAN_CAPABILITY_IBSS;
-
 		if (ifibss->privacy)
-			capability |= WLAN_CAPABILITY_PRIVACY;
+			capability = WLAN_CAPABILITY_PRIVACY;
 
 		cbss = cfg80211_get_bss(local->hw.wiphy, ifibss->chandef.chan,
 					ifibss->bssid, ifibss->ssid,
-					ifibss->ssid_len, WLAN_CAPABILITY_IBSS |
-					WLAN_CAPABILITY_PRIVACY,
-					capability);
+					ifibss->ssid_len,
+					IEEE80211_BSS_TYPE_IBSS,
+					WLAN_CAPABILITY_PRIVACY, capability);
 
 		if (cbss) {
 			cfg80211_unlink_bss(local->hw.wiphy, cbss);
@@ -1325,7 +1318,7 @@ static void ieee80211_sta_find_ibss(struct ieee80211_sub_if_data *sdata)
 	const u8 *bssid = NULL;
 	enum nl80211_bss_scan_width scan_width;
 	int active_ibss;
-	u16 capability;
+	u16 capability = 0;
 
 	sdata_assert_lock(sdata);
 
@@ -1335,9 +1328,8 @@ static void ieee80211_sta_find_ibss(struct ieee80211_sub_if_data *sdata)
 	if (active_ibss)
 		return;
 
-	capability = WLAN_CAPABILITY_IBSS;
 	if (ifibss->privacy)
-		capability |= WLAN_CAPABILITY_PRIVACY;
+		capability = WLAN_CAPABILITY_PRIVACY;
 	if (ifibss->fixed_bssid)
 		bssid = ifibss->bssid;
 	if (ifibss->fixed_channel)
@@ -1346,8 +1338,8 @@ static void ieee80211_sta_find_ibss(struct ieee80211_sub_if_data *sdata)
 		bssid = ifibss->bssid;
 	cbss = cfg80211_get_bss(local->hw.wiphy, chan, bssid,
 				ifibss->ssid, ifibss->ssid_len,
-				WLAN_CAPABILITY_IBSS | WLAN_CAPABILITY_PRIVACY,
-				capability);
+				IEEE80211_BSS_TYPE_IBSS,
+				WLAN_CAPABILITY_PRIVACY, capability);
 
 	if (cbss) {
 		struct ieee80211_bss *bss;
diff --git a/net/wireless/ibss.c b/net/wireless/ibss.c
index e24fc58..02fbbdf 100644
--- a/net/wireless/ibss.c
+++ b/net/wireless/ibss.c
@@ -30,7 +30,7 @@ void __cfg80211_ibss_joined(struct net_device *dev, const u8 *bssid,
 		return;
 
 	bss = cfg80211_get_bss(wdev->wiphy, channel, bssid, NULL, 0,
-			       WLAN_CAPABILITY_IBSS, WLAN_CAPABILITY_IBSS);
+			       IEEE80211_BSS_TYPE_IBSS, 0, 0);
 
 	if (WARN_ON(!bss))
 		return;
diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index 2c52b59..f8be652 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -229,7 +229,7 @@ int cfg80211_mlme_auth(struct cfg80211_registered_device *rdev,
 		return -EALREADY;
 
 	req.bss = cfg80211_get_bss(&rdev->wiphy, chan, bssid, ssid, ssid_len,
-				   WLAN_CAPABILITY_ESS, WLAN_CAPABILITY_ESS);
+				   IEEE80211_BSS_TYPE_ESS, 0, 0);
 	if (!req.bss)
 		return -ENOENT;
 
@@ -296,7 +296,7 @@ int cfg80211_mlme_assoc(struct cfg80211_registered_device *rdev,
 				   rdev->wiphy.vht_capa_mod_mask);
 
 	req->bss = cfg80211_get_bss(&rdev->wiphy, chan, bssid, ssid, ssid_len,
-				    WLAN_CAPABILITY_ESS, WLAN_CAPABILITY_ESS);
+				    IEEE80211_BSS_TYPE_ESS, 0, 0);
 	if (!req->bss)
 		return -ENOENT;
 
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index c705c3e..a482202 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -531,23 +531,76 @@ static int cmp_bss(struct cfg80211_bss *a,
 	}
 }
 
+static bool cfg80211_bss_type_to_capa(enum ieee80211_bsstype bss_type,
+				      enum ieee80211_band band,
+				      u16 *capa_mask, u16 *capa_val)
+{
+	bool ret = true;
+
+	if (bss_type == IEEE80211_BSS_TYPE_ANY)
+		return ret;
+
+	if (band == IEEE80211_BAND_60GHZ) {
+		*capa_val &= ~WLAN_CAPABILITY_DMG_TYPE_MASK;
+		*capa_mask |= WLAN_CAPABILITY_DMG_TYPE_MASK;
+		switch (bss_type) {
+		case IEEE80211_BSS_TYPE_ESS:
+			*capa_val |= WLAN_CAPABILITY_DMG_TYPE_AP;
+			break;
+		case IEEE80211_BSS_TYPE_PBSS:
+			*capa_val |= WLAN_CAPABILITY_DMG_TYPE_PBSS;
+			break;
+		case IEEE80211_BSS_TYPE_IBSS:
+			*capa_val |= WLAN_CAPABILITY_DMG_TYPE_IBSS;
+			break;
+		default:
+			ret = false;
+			break;
+		}
+	} else {
+		*capa_val &= ~(WLAN_CAPABILITY_ESS | WLAN_CAPABILITY_IBSS);
+		*capa_mask |= WLAN_CAPABILITY_ESS | WLAN_CAPABILITY_IBSS;
+		switch (bss_type) {
+		case IEEE80211_BSS_TYPE_ESS:
+			*capa_val |= WLAN_CAPABILITY_ESS;
+			break;
+		case IEEE80211_BSS_TYPE_IBSS:
+			*capa_val |= WLAN_CAPABILITY_IBSS;
+			break;
+		case IEEE80211_BSS_TYPE_MBSS:
+			break;
+		default:
+			ret = false;
+			break;
+		}
+	}
+
+	return ret;
+}
+
 /* Returned bss is reference counted and must be cleaned up appropriately. */
 struct cfg80211_bss *cfg80211_get_bss(struct wiphy *wiphy,
 				      struct ieee80211_channel *channel,
 				      const u8 *bssid,
 				      const u8 *ssid, size_t ssid_len,
+				      enum ieee80211_bsstype bss_type,
 				      u16 capa_mask, u16 capa_val)
 {
 	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
 	struct cfg80211_internal_bss *bss, *res = NULL;
 	unsigned long now = jiffies;
 
-	trace_cfg80211_get_bss(wiphy, channel, bssid, ssid, ssid_len, capa_mask,
-			       capa_val);
+	trace_cfg80211_get_bss(wiphy, channel, bssid, ssid, ssid_len, bss_type,
+			       capa_mask, capa_val);
 
 	spin_lock_bh(&rdev->bss_lock);
 
 	list_for_each_entry(bss, &rdev->bss_list, list) {
+		if (!cfg80211_bss_type_to_capa(bss_type,
+					       bss->pub.channel->band,
+					       &capa_val, &capa_mask))
+			continue;
+
 		if ((bss->pub.capability & capa_mask) != capa_val)
 			continue;
 		if (channel && bss->pub.channel != channel)
@@ -896,6 +949,7 @@ cfg80211_inform_bss_width(struct wiphy *wiphy,
 	struct cfg80211_bss_ies *ies;
 	struct ieee80211_channel *channel;
 	struct cfg80211_internal_bss tmp = {}, *res;
+	int bss_type;
 	bool signal_valid;
 
 	if (WARN_ON(!wiphy))
@@ -950,8 +1004,15 @@ cfg80211_inform_bss_width(struct wiphy *wiphy,
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
@@ -973,6 +1034,7 @@ cfg80211_inform_bss_width_frame(struct wiphy *wiphy,
 	bool signal_valid;
 	size_t ielen = len - offsetof(struct ieee80211_mgmt,
 				      u.probe_resp.variable);
+	int bss_type;
 
 	BUILD_BUG_ON(offsetof(struct ieee80211_mgmt, u.probe_resp.variable) !=
 			offsetof(struct ieee80211_mgmt, u.beacon.variable));
@@ -1025,8 +1087,15 @@ cfg80211_inform_bss_width_frame(struct wiphy *wiphy,
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
index 0ab3711..cf116fc 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -257,19 +257,19 @@ static struct cfg80211_bss *cfg80211_get_conn_bss(struct wireless_dev *wdev)
 {
 	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
 	struct cfg80211_bss *bss;
-	u16 capa = WLAN_CAPABILITY_ESS;
+	u16 capa = 0;
 
 	ASSERT_WDEV_LOCK(wdev);
 
 	if (wdev->conn->params.privacy)
-		capa |= WLAN_CAPABILITY_PRIVACY;
+		capa = WLAN_CAPABILITY_PRIVACY;
 
 	bss = cfg80211_get_bss(wdev->wiphy, wdev->conn->params.channel,
 			       wdev->conn->params.bssid,
 			       wdev->conn->params.ssid,
 			       wdev->conn->params.ssid_len,
-			       WLAN_CAPABILITY_ESS | WLAN_CAPABILITY_PRIVACY,
-			       capa);
+			       wdev->bss_type,
+			       WLAN_CAPABILITY_PRIVACY, capa);
 	if (!bss)
 		return NULL;
 
@@ -637,8 +637,7 @@ void __cfg80211_connect_result(struct net_device *dev, const u8 *bssid,
 		WARN_ON_ONCE(!wiphy_to_rdev(wdev->wiphy)->ops->connect);
 		bss = cfg80211_get_bss(wdev->wiphy, NULL, bssid,
 				       wdev->ssid, wdev->ssid_len,
-				       WLAN_CAPABILITY_ESS,
-				       WLAN_CAPABILITY_ESS);
+				       wdev->bss_type, 0, 0);
 		if (bss)
 			cfg80211_hold_bss(bss_from_pub(bss));
 	}
@@ -795,8 +794,8 @@ void cfg80211_roamed(struct net_device *dev,
 	struct cfg80211_bss *bss;
 
 	bss = cfg80211_get_bss(wdev->wiphy, channel, bssid, wdev->ssid,
-			       wdev->ssid_len, WLAN_CAPABILITY_ESS,
-			       WLAN_CAPABILITY_ESS);
+			       wdev->ssid_len,
+			       wdev->bss_type, 0, 0);
 	if (WARN_ON(!bss))
 		return;
 
@@ -965,6 +964,12 @@ int cfg80211_connect(struct cfg80211_registered_device *rdev,
 	memcpy(wdev->ssid, connect->ssid, connect->ssid_len);
 	wdev->ssid_len = connect->ssid_len;
 
+	wdev->bss_type = IEEE80211_BSS_TYPE_ESS;
+	if (connect->channel &&
+	    connect->channel->band == IEEE80211_BAND_60GHZ &&
+	    wdev->iftype == NL80211_IFTYPE_P2P_CLIENT)
+		wdev->bss_type = IEEE80211_BSS_TYPE_PBSS;
+
 	if (!rdev->ops->connect)
 		err = cfg80211_sme_connect(wdev, connect, prev_bssid);
 	else
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index b17b369..8b5fb05 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -2636,13 +2636,16 @@ DEFINE_EVENT(wiphy_only_evt, cfg80211_sched_scan_stopped,
 TRACE_EVENT(cfg80211_get_bss,
 	TP_PROTO(struct wiphy *wiphy, struct ieee80211_channel *channel,
 		 const u8 *bssid, const u8 *ssid, size_t ssid_len,
+		 enum ieee80211_bsstype bss_type,
 		 u16 capa_mask, u16 capa_val),
-	TP_ARGS(wiphy, channel, bssid, ssid, ssid_len, capa_mask, capa_val),
+	TP_ARGS(wiphy, channel, bssid, ssid, ssid_len, bss_type,
+		capa_mask, capa_val),
 	TP_STRUCT__entry(
 		WIPHY_ENTRY
 		CHAN_ENTRY
 		MAC_ENTRY(bssid)
 		__dynamic_array(u8, ssid, ssid_len)
+		__field(enum ieee80211_bsstype, bss_type)
 		__field(u16, capa_mask)
 		__field(u16, capa_val)
 	),
@@ -2651,12 +2654,14 @@ TRACE_EVENT(cfg80211_get_bss,
 		CHAN_ASSIGN(channel);
 		MAC_ASSIGN(bssid, bssid);
 		memcpy(__get_dynamic_array(ssid), ssid, ssid_len);
+		__entry->bss_type = bss_type;
 		__entry->capa_mask = capa_mask;
 		__entry->capa_val = capa_val;
 	),
-	TP_printk(WIPHY_PR_FMT ", " CHAN_PR_FMT ", " MAC_PR_FMT ", buf: %#.2x, "
-		  "capa_mask: %d, capa_val: %u", WIPHY_PR_ARG, CHAN_PR_ARG,
-		  MAC_PR_ARG(bssid), ((u8 *)__get_dynamic_array(ssid))[0],
+	TP_printk(WIPHY_PR_FMT ", " CHAN_PR_FMT ", " MAC_PR_FMT
+		  ", buf: %#.2x, bss_type: %d, capa_mask: %d, capa_val: %u",
+		  WIPHY_PR_ARG, CHAN_PR_ARG, MAC_PR_ARG(bssid),
+		  ((u8 *)__get_dynamic_array(ssid))[0], __entry->bss_type,
 		  __entry->capa_mask, __entry->capa_val)
 );
 
-- 
1.9.1

