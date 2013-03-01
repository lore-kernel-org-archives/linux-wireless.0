Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57809 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496Ab3CAK7Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Mar 2013 05:59:24 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: greearb@candelatech.com, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: fix HT capability overrides for AP station
Date: Fri,  1 Mar 2013 11:59:19 +0100
Message-Id: <1362135559-10295-1-git-send-email-johannes@sipsolutions.net> (sfid-20130301_115928_216136_186085DF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

HT capabilites are asymmetric -- e.g. beamforming is both a
TX and RX capability. If, for example, we support RX but not
TX, the RX capability of the AP station is masked out (if it
supports it). This works correctly if it's really the driver
capability.

If, on the other hand, the reason for not supporting TX BF
is that it was removed by HT capability overrides then the
wrong thing happens: the AP's TX capability will be removed
rather than its RX capability, because the override function
works on own capabilities, not remote ones, and doesn't take
the asymmetry into account.

To fix this make a copy of our own capabilities, apply the
overrides to them (where needed) and then use that to set up
the peer's capabilities.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ht.c | 48 +++++++++++++++++++++++++-----------------------
 1 file changed, 25 insertions(+), 23 deletions(-)

diff --git a/net/mac80211/ht.c b/net/mac80211/ht.c
index 4515fc3..af8cee0 100644
--- a/net/mac80211/ht.c
+++ b/net/mac80211/ht.c
@@ -90,7 +90,7 @@ bool ieee80211_ht_cap_ie_to_sta_ht_cap(struct ieee80211_sub_if_data *sdata,
 				       const struct ieee80211_ht_cap *ht_cap_ie,
 				       struct sta_info *sta)
 {
-	struct ieee80211_sta_ht_cap ht_cap;
+	struct ieee80211_sta_ht_cap ht_cap, own_cap;
 	u8 ampdu_info, tx_mcs_set_cap;
 	int i, max_tx_streams;
 	bool changed;
@@ -104,6 +104,18 @@ bool ieee80211_ht_cap_ie_to_sta_ht_cap(struct ieee80211_sub_if_data *sdata,
 
 	ht_cap.ht_supported = true;
 
+	own_cap = sband->ht_cap;
+
+	/*
+	 * If user has specified capability over-rides, take care
+	 * of that if the station we're setting up is the AP that
+	 * we advertised a restricted capability set to. Override
+	 * our own capabilities and then use those below.
+	 */
+	if (sdata->vif.type == NL80211_IFTYPE_STATION &&
+	    !test_sta_flag(sta, WLAN_STA_TDLS_PEER))
+		ieee80211_apply_htcap_overrides(sdata, &own_cap);
+
 	/*
 	 * The bits listed in this expression should be
 	 * the same for the peer and us, if the station
@@ -111,21 +123,20 @@ bool ieee80211_ht_cap_ie_to_sta_ht_cap(struct ieee80211_sub_if_data *sdata,
 	 * we mask them out.
 	 */
 	ht_cap.cap = le16_to_cpu(ht_cap_ie->cap_info) &
-		(sband->ht_cap.cap |
-		 ~(IEEE80211_HT_CAP_LDPC_CODING |
-		   IEEE80211_HT_CAP_SUP_WIDTH_20_40 |
-		   IEEE80211_HT_CAP_GRN_FLD |
-		   IEEE80211_HT_CAP_SGI_20 |
-		   IEEE80211_HT_CAP_SGI_40 |
-		   IEEE80211_HT_CAP_DSSSCCK40));
+		(own_cap.cap | ~(IEEE80211_HT_CAP_LDPC_CODING |
+				 IEEE80211_HT_CAP_SUP_WIDTH_20_40 |
+				 IEEE80211_HT_CAP_GRN_FLD |
+				 IEEE80211_HT_CAP_SGI_20 |
+				 IEEE80211_HT_CAP_SGI_40 |
+				 IEEE80211_HT_CAP_DSSSCCK40));
 
 	/*
 	 * The STBC bits are asymmetric -- if we don't have
 	 * TX then mask out the peer's RX and vice versa.
 	 */
-	if (!(sband->ht_cap.cap & IEEE80211_HT_CAP_TX_STBC))
+	if (!(own_cap.cap & IEEE80211_HT_CAP_TX_STBC))
 		ht_cap.cap &= ~IEEE80211_HT_CAP_RX_STBC;
-	if (!(sband->ht_cap.cap & IEEE80211_HT_CAP_RX_STBC))
+	if (!(own_cap.cap & IEEE80211_HT_CAP_RX_STBC))
 		ht_cap.cap &= ~IEEE80211_HT_CAP_TX_STBC;
 
 	ampdu_info = ht_cap_ie->ampdu_params_info;
@@ -135,7 +146,7 @@ bool ieee80211_ht_cap_ie_to_sta_ht_cap(struct ieee80211_sub_if_data *sdata,
 		(ampdu_info & IEEE80211_HT_AMPDU_PARM_DENSITY) >> 2;
 
 	/* own MCS TX capabilities */
-	tx_mcs_set_cap = sband->ht_cap.mcs.tx_params;
+	tx_mcs_set_cap = own_cap.mcs.tx_params;
 
 	/* Copy peer MCS TX capabilities, the driver might need them. */
 	ht_cap.mcs.tx_params = ht_cap_ie->mcs.tx_params;
@@ -161,29 +172,20 @@ bool ieee80211_ht_cap_ie_to_sta_ht_cap(struct ieee80211_sub_if_data *sdata,
 	 */
 	for (i = 0; i < max_tx_streams; i++)
 		ht_cap.mcs.rx_mask[i] =
-			sband->ht_cap.mcs.rx_mask[i] & ht_cap_ie->mcs.rx_mask[i];
+			own_cap.mcs.rx_mask[i] & ht_cap_ie->mcs.rx_mask[i];
 
 	if (tx_mcs_set_cap & IEEE80211_HT_MCS_TX_UNEQUAL_MODULATION)
 		for (i = IEEE80211_HT_MCS_UNEQUAL_MODULATION_START_BYTE;
 		     i < IEEE80211_HT_MCS_MASK_LEN; i++)
 			ht_cap.mcs.rx_mask[i] =
-				sband->ht_cap.mcs.rx_mask[i] &
+				own_cap.mcs.rx_mask[i] &
 					ht_cap_ie->mcs.rx_mask[i];
 
 	/* handle MCS rate 32 too */
-	if (sband->ht_cap.mcs.rx_mask[32/8] & ht_cap_ie->mcs.rx_mask[32/8] & 1)
+	if (own_cap.mcs.rx_mask[32/8] & ht_cap_ie->mcs.rx_mask[32/8] & 1)
 		ht_cap.mcs.rx_mask[32/8] |= 1;
 
  apply:
-	/*
-	 * If user has specified capability over-rides, take care
-	 * of that if the station we're setting up is the AP that
-	 * we advertised a restricted capability set to.
-	 */
-	if (sdata->vif.type == NL80211_IFTYPE_STATION &&
-	    !test_sta_flag(sta, WLAN_STA_TDLS_PEER))
-		ieee80211_apply_htcap_overrides(sdata, &ht_cap);
-
 	changed = memcmp(&sta->sta.ht_cap, &ht_cap, sizeof(ht_cap));
 
 	memcpy(&sta->sta.ht_cap, &ht_cap, sizeof(ht_cap));
-- 
1.8.0

