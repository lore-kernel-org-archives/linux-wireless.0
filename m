Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:43247 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933822AbaGQOOT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jul 2014 10:14:19 -0400
Received: by mail-wg0-f47.google.com with SMTP id b13so2029499wgh.18
        for <linux-wireless@vger.kernel.org>; Thu, 17 Jul 2014 07:14:17 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 10/15] mac80211: support HT for TDLS stations
Date: Thu, 17 Jul 2014 17:14:26 +0300
Message-Id: <1405606471-30128-11-git-send-email-arik@wizery.com> (sfid-20140717_161451_783117_E31A4C50)
In-Reply-To: <1405606471-30128-1-git-send-email-arik@wizery.com>
References: <1405606471-30128-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add the HT capabilities and HT operation information elements to TDLS
setup packets where appropriate.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/ht.c   |  7 ++---
 net/mac80211/tdls.c | 88 ++++++++++++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 87 insertions(+), 8 deletions(-)

diff --git a/net/mac80211/ht.c b/net/mac80211/ht.c
index 15702ff..568055c 100644
--- a/net/mac80211/ht.c
+++ b/net/mac80211/ht.c
@@ -150,13 +150,12 @@ bool ieee80211_ht_cap_ie_to_sta_ht_cap(struct ieee80211_sub_if_data *sdata,
 
 	/*
 	 * If user has specified capability over-rides, take care
-	 * of that if the station we're setting up is the AP that
+	 * of that if the station we're setting up is the AP or TDLS peer that
 	 * we advertised a restricted capability set to. Override
 	 * our own capabilities and then use those below.
 	 */
-	if ((sdata->vif.type == NL80211_IFTYPE_STATION ||
-	     sdata->vif.type == NL80211_IFTYPE_ADHOC) &&
-	    !test_sta_flag(sta, WLAN_STA_TDLS_PEER))
+	if (sdata->vif.type == NL80211_IFTYPE_STATION ||
+	    sdata->vif.type == NL80211_IFTYPE_ADHOC)
 		ieee80211_apply_htcap_overrides(sdata, &own_cap);
 
 	/*
diff --git a/net/mac80211/tdls.c b/net/mac80211/tdls.c
index c59b8f4..50d0e06 100644
--- a/net/mac80211/tdls.c
+++ b/net/mac80211/tdls.c
@@ -170,9 +170,23 @@ ieee80211_tdls_add_setup_start_ies(struct ieee80211_sub_if_data *sdata,
 {
 	enum ieee80211_band band = ieee80211_get_sdata_band(sdata);
 	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_supported_band *sband;
+	struct ieee80211_sta_ht_cap ht_cap;
+	struct sta_info *sta = NULL;
 	size_t offset = 0, noffset;
 	u8 *pos;
 
+	rcu_read_lock();
+
+	/* we should have the peer STA if we're already responding */
+	if (action_code == WLAN_TDLS_SETUP_RESPONSE) {
+		sta = sta_info_get(sdata, peer);
+		if (WARN_ON_ONCE(!sta)) {
+			rcu_read_unlock();
+			return;
+		}
+	}
+
 	ieee80211_add_srates_ie(sdata, skb, false, band);
 	ieee80211_add_ext_srates_ie(sdata, skb, false, band);
 
@@ -224,6 +238,38 @@ ieee80211_tdls_add_setup_start_ies(struct ieee80211_sub_if_data *sdata,
 		offset = noffset;
 	}
 
+	/*
+	 * with TDLS we can switch channels, and HT-caps are not necessarily
+	 * the same on all bands. The specification limits the setup to a
+	 * single HT-cap, so use the current band for now.
+	 */
+	sband = local->hw.wiphy->bands[band];
+	memcpy(&ht_cap, &sband->ht_cap, sizeof(ht_cap));
+	if ((action_code == WLAN_TDLS_SETUP_REQUEST ||
+	     action_code == WLAN_TDLS_SETUP_RESPONSE) &&
+	    ht_cap.ht_supported && (!sta || sta->sta.ht_cap.ht_supported)) {
+		if (action_code == WLAN_TDLS_SETUP_REQUEST) {
+			ieee80211_apply_htcap_overrides(sdata, &ht_cap);
+
+			/* disable SMPS in TDLS initiator */
+			ht_cap.cap |= (WLAN_HT_CAP_SM_PS_DISABLED
+				       << IEEE80211_HT_CAP_SM_PS_SHIFT);
+		} else {
+			/* disable SMPS in TDLS responder */
+			sta->sta.ht_cap.cap |=
+				(WLAN_HT_CAP_SM_PS_DISABLED
+				 << IEEE80211_HT_CAP_SM_PS_SHIFT);
+
+			/* the peer caps are already intersected with our own */
+			memcpy(&ht_cap, &sta->sta.ht_cap, sizeof(ht_cap));
+		}
+
+		pos = skb_put(skb, sizeof(struct ieee80211_ht_cap) + 2);
+		ieee80211_ie_build_ht_cap(pos, &ht_cap, ht_cap.cap);
+	}
+
+	rcu_read_unlock();
+
 	/* add any remaining IEs */
 	if (extra_ies_len) {
 		noffset = extra_ies_len;
@@ -241,14 +287,16 @@ ieee80211_tdls_add_setup_cfm_ies(struct ieee80211_sub_if_data *sdata,
 				 size_t extra_ies_len)
 {
 	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	size_t offset = 0, noffset;
-	struct sta_info *sta;
+	struct sta_info *sta, *ap_sta;
 	u8 *pos;
 
 	rcu_read_lock();
 
 	sta = sta_info_get(sdata, peer);
-	if (WARN_ON_ONCE(!sta)) {
+	ap_sta = sta_info_get(sdata, ifmgd->bssid);
+	if (WARN_ON_ONCE(!sta || !ap_sta)) {
 		rcu_read_unlock();
 		return;
 	}
@@ -272,6 +320,38 @@ ieee80211_tdls_add_setup_cfm_ies(struct ieee80211_sub_if_data *sdata,
 	    test_sta_flag(sta, WLAN_STA_WME))
 		ieee80211_tdls_add_wmm_param_ie(sdata, skb);
 
+	/* add any custom IEs that go before HT operation */
+	if (extra_ies_len) {
+		static const u8 before_ht_op[] = {
+			WLAN_EID_RSN,
+			WLAN_EID_QOS_CAPA,
+			WLAN_EID_FAST_BSS_TRANSITION,
+			WLAN_EID_TIMEOUT_INTERVAL,
+		};
+		noffset = ieee80211_ie_split(extra_ies, extra_ies_len,
+					     before_ht_op,
+					     ARRAY_SIZE(before_ht_op),
+					     offset);
+		pos = skb_put(skb, noffset - offset);
+		memcpy(pos, extra_ies + offset, noffset - offset);
+		offset = noffset;
+	}
+
+	/* if HT support is only added in TDLS, we need an HT-operation IE */
+	if (!ap_sta->sta.ht_cap.ht_supported && sta->sta.ht_cap.ht_supported) {
+		struct ieee80211_chanctx_conf *chanctx_conf =
+				rcu_dereference(sdata->vif.chanctx_conf);
+		if (!WARN_ON(!chanctx_conf)) {
+			pos = skb_put(skb, 2 +
+				      sizeof(struct ieee80211_ht_operation));
+			/* send an empty HT operation IE */
+			ieee80211_ie_build_ht_oper(pos, &sta->sta.ht_cap,
+						   &chanctx_conf->def, 0);
+		}
+	}
+
+	rcu_read_unlock();
+
 	/* add any remaining IEs */
 	if (extra_ies_len) {
 		noffset = extra_ies_len;
@@ -280,8 +360,6 @@ ieee80211_tdls_add_setup_cfm_ies(struct ieee80211_sub_if_data *sdata,
 	}
 
 	ieee80211_tdls_add_link_ie(sdata, skb, peer, initiator);
-
-	rcu_read_unlock();
 }
 
 static void ieee80211_tdls_add_ies(struct ieee80211_sub_if_data *sdata,
@@ -441,6 +519,8 @@ ieee80211_tdls_prep_mgmt_packet(struct wiphy *wiphy, struct net_device *dev,
 			    50 + /* supported rates */
 			    7 + /* ext capab */
 			    26 + /* max(WMM-info, WMM-param) */
+			    2 + max(sizeof(struct ieee80211_ht_cap),
+				    sizeof(struct ieee80211_ht_operation)) +
 			    extra_ies_len +
 			    sizeof(struct ieee80211_tdls_lnkie));
 	if (!skb)
-- 
1.9.1

