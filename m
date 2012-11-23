Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51671 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932907Ab2KWHme (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Nov 2012 02:42:34 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 2/3] mac80211: rename IEEE80211_STA_DISABLE_11N to HT
Date: Fri, 23 Nov 2012 08:42:59 +0100
Message-Id: <1353656580-12134-3-git-send-email-johannes@sipsolutions.net> (sfid-20121123_084239_880572_054C0951)
In-Reply-To: <1353656580-12134-1-git-send-email-johannes@sipsolutions.net>
References: <1353656580-12134-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Since the 11n spec amendment was rolled into the
2012 version, "11n" no longer makes sense. Use
"HT" instead.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ieee80211_i.h |  2 +-
 net/mac80211/mlme.c        | 16 ++++++++--------
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index bff82a8..d5da0fe 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -364,7 +364,7 @@ enum ieee80211_sta_flags {
 	IEEE80211_STA_BEACON_POLL	= BIT(0),
 	IEEE80211_STA_CONNECTION_POLL	= BIT(1),
 	IEEE80211_STA_CONTROL_PORT	= BIT(2),
-	IEEE80211_STA_DISABLE_11N	= BIT(4),
+	IEEE80211_STA_DISABLE_HT	= BIT(4),
 	IEEE80211_STA_CSA_RECEIVED	= BIT(5),
 	IEEE80211_STA_MFP_ENABLED	= BIT(6),
 	IEEE80211_STA_UAPSD_ENABLED	= BIT(7),
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 19969ec..42b2c3f 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -541,7 +541,7 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
 		offset = noffset;
 	}
 
-	if (!(ifmgd->flags & IEEE80211_STA_DISABLE_11N))
+	if (!(ifmgd->flags & IEEE80211_STA_DISABLE_HT))
 		ieee80211_add_ht_ie(sdata, skb, assoc_data->ap_ht_param,
 				    sband, chan, sdata->smps_mode);
 
@@ -2170,7 +2170,7 @@ static bool ieee80211_assoc_success(struct ieee80211_sub_if_data *sdata,
 
 	sband = local->hw.wiphy->bands[ieee80211_get_sdata_band(sdata)];
 
-	if (elems.ht_cap_elem && !(ifmgd->flags & IEEE80211_STA_DISABLE_11N))
+	if (elems.ht_cap_elem && !(ifmgd->flags & IEEE80211_STA_DISABLE_HT))
 		ieee80211_ht_cap_ie_to_sta_ht_cap(sdata, sband,
 				elems.ht_cap_elem, &sta->sta.ht_cap);
 
@@ -2222,7 +2222,7 @@ static bool ieee80211_assoc_success(struct ieee80211_sub_if_data *sdata,
 	changed |= BSS_CHANGED_QOS;
 
 	if (elems.ht_operation && elems.wmm_param &&
-	    !(ifmgd->flags & IEEE80211_STA_DISABLE_11N))
+	    !(ifmgd->flags & IEEE80211_STA_DISABLE_HT))
 		changed |= ieee80211_config_ht_tx(sdata, elems.ht_operation,
 						  cbss->bssid, false);
 
@@ -2658,7 +2658,7 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 
 
 	if (elems.ht_cap_elem && elems.ht_operation && elems.wmm_param &&
-	    !(ifmgd->flags & IEEE80211_STA_DISABLE_11N))
+	    !(ifmgd->flags & IEEE80211_STA_DISABLE_HT))
 		changed |= ieee80211_config_ht_tx(sdata, elems.ht_operation,
 						  bssid, true);
 
@@ -3555,7 +3555,7 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 		if (req->crypto.ciphers_pairwise[i] == WLAN_CIPHER_SUITE_WEP40 ||
 		    req->crypto.ciphers_pairwise[i] == WLAN_CIPHER_SUITE_TKIP ||
 		    req->crypto.ciphers_pairwise[i] == WLAN_CIPHER_SUITE_WEP104) {
-			ifmgd->flags |= IEEE80211_STA_DISABLE_11N;
+			ifmgd->flags |= IEEE80211_STA_DISABLE_HT;
 			ifmgd->flags |= IEEE80211_STA_DISABLE_VHT;
 			netdev_info(sdata->dev,
 				    "disabling HT/VHT due to WEP/TKIP use\n");
@@ -3563,7 +3563,7 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 	}
 
 	if (req->flags & ASSOC_REQ_DISABLE_HT) {
-		ifmgd->flags |= IEEE80211_STA_DISABLE_11N;
+		ifmgd->flags |= IEEE80211_STA_DISABLE_HT;
 		ifmgd->flags |= IEEE80211_STA_DISABLE_VHT;
 	}
 
@@ -3571,7 +3571,7 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 	sband = local->hw.wiphy->bands[req->bss->channel->band];
 	if (!sband->ht_cap.ht_supported ||
 	    local->hw.queues < IEEE80211_NUM_ACS || !bss->wmm_used) {
-		ifmgd->flags |= IEEE80211_STA_DISABLE_11N;
+		ifmgd->flags |= IEEE80211_STA_DISABLE_HT;
 		if (!bss->wmm_used)
 			netdev_info(sdata->dev,
 				    "disabling HT as WMM/QoS is not supported by the AP\n");
@@ -3616,7 +3616,7 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 		assoc_data->ap_ht_param =
 			((struct ieee80211_ht_operation *)(ht_ie + 2))->ht_param;
 	else
-		ifmgd->flags |= IEEE80211_STA_DISABLE_11N;
+		ifmgd->flags |= IEEE80211_STA_DISABLE_HT;
 
 	if (bss->wmm_used && bss->uapsd_supported &&
 	    (sdata->local->hw.flags & IEEE80211_HW_SUPPORTS_UAPSD)) {
-- 
1.8.0

