Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55014 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757951Ab3BGKyt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Feb 2013 05:54:49 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: track station's supports_40mhz properly
Date: Thu,  7 Feb 2013 11:55:11 +0100
Message-Id: <1360234511-21295-1-git-send-email-johannes@sipsolutions.net> (sfid-20130207_115453_315765_A7517F28)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The only place currently setting "supports_40mhz" is the managed
mode code (mlme.c), which is wrong because it means that all other
modes won't handle HT channel width notification action frames.

Set up the value in ieee80211_ht_cap_ie_to_sta_ht_cap, this means
passing the sta to it which makes IBSS a little more complicated
(and also requires a return value from the function.)

While at it, also fix ieee80211_ht_cap_ie_to_sta_ht_cap() to not
ignore HT cap overrides when MCS TX isn't supported (not that it
really happens...)

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c         |  3 +--
 net/mac80211/ht.c          | 50 +++++++++++++++++++++++++++-------------------
 net/mac80211/ibss.c        | 23 ++++++++-------------
 net/mac80211/ieee80211_i.h |  4 ++--
 net/mac80211/mesh_plink.c  |  3 +--
 net/mac80211/mlme.c        |  5 +----
 6 files changed, 43 insertions(+), 45 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index fb06d13..221db8d 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1249,8 +1249,7 @@ static int sta_apply_parameters(struct ieee80211_local *local,
 
 	if (params->ht_capa)
 		ieee80211_ht_cap_ie_to_sta_ht_cap(sdata, sband,
-						  params->ht_capa,
-						  &sta->sta.ht_cap);
+						  params->ht_capa, sta);
 
 	if (params->vht_capa)
 		ieee80211_vht_cap_ie_to_sta_vht_cap(sdata, sband,
diff --git a/net/mac80211/ht.c b/net/mac80211/ht.c
index 61ac7c4..ac40eb8 100644
--- a/net/mac80211/ht.c
+++ b/net/mac80211/ht.c
@@ -37,6 +37,9 @@ void ieee80211_apply_htcap_overrides(struct ieee80211_sub_if_data *sdata,
 	u8 *smask = (u8 *)(&sdata->u.mgd.ht_capa_mask.mcs.rx_mask);
 	int i;
 
+	if (!ht_cap->ht_supported)
+		return;
+
 	if (sdata->vif.type != NL80211_IFTYPE_STATION) {
 		/* AP interfaces call this code when adding new stations,
 		 * so just silently ignore non station interfaces.
@@ -89,22 +92,22 @@ void ieee80211_apply_htcap_overrides(struct ieee80211_sub_if_data *sdata,
 }
 
 
-void ieee80211_ht_cap_ie_to_sta_ht_cap(struct ieee80211_sub_if_data *sdata,
+bool ieee80211_ht_cap_ie_to_sta_ht_cap(struct ieee80211_sub_if_data *sdata,
 				       struct ieee80211_supported_band *sband,
 				       struct ieee80211_ht_cap *ht_cap_ie,
-				       struct ieee80211_sta_ht_cap *ht_cap)
+				       struct sta_info *sta)
 {
+	struct ieee80211_sta_ht_cap ht_cap;
 	u8 ampdu_info, tx_mcs_set_cap;
 	int i, max_tx_streams;
+	bool changed;
 
-	BUG_ON(!ht_cap);
-
-	memset(ht_cap, 0, sizeof(*ht_cap));
+	memset(&ht_cap, 0, sizeof(ht_cap));
 
 	if (!ht_cap_ie || !sband->ht_cap.ht_supported)
-		return;
+		goto apply;
 
-	ht_cap->ht_supported = true;
+	ht_cap.ht_supported = true;
 
 	/*
 	 * The bits listed in this expression should be
@@ -112,7 +115,7 @@ void ieee80211_ht_cap_ie_to_sta_ht_cap(struct ieee80211_sub_if_data *sdata,
 	 * advertises more then we can't use those thus
 	 * we mask them out.
 	 */
-	ht_cap->cap = le16_to_cpu(ht_cap_ie->cap_info) &
+	ht_cap.cap = le16_to_cpu(ht_cap_ie->cap_info) &
 		(sband->ht_cap.cap |
 		 ~(IEEE80211_HT_CAP_LDPC_CODING |
 		   IEEE80211_HT_CAP_SUP_WIDTH_20_40 |
@@ -125,8 +128,8 @@ void ieee80211_ht_cap_ie_to_sta_ht_cap(struct ieee80211_sub_if_data *sdata,
 	switch (sdata->vif.bss_conf.chandef.width) {
 	case NL80211_CHAN_WIDTH_20_NOHT:
 	case NL80211_CHAN_WIDTH_20:
-		ht_cap->cap &= ~IEEE80211_HT_CAP_SGI_40;
-		ht_cap->cap &= ~IEEE80211_HT_CAP_SUP_WIDTH_20_40;
+		ht_cap.cap &= ~IEEE80211_HT_CAP_SGI_40;
+		ht_cap.cap &= ~IEEE80211_HT_CAP_SUP_WIDTH_20_40;
 		break;
 	case NL80211_CHAN_WIDTH_40:
 	case NL80211_CHAN_WIDTH_80:
@@ -140,25 +143,25 @@ void ieee80211_ht_cap_ie_to_sta_ht_cap(struct ieee80211_sub_if_data *sdata,
 	 * TX then mask out the peer's RX and vice versa.
 	 */
 	if (!(sband->ht_cap.cap & IEEE80211_HT_CAP_TX_STBC))
-		ht_cap->cap &= ~IEEE80211_HT_CAP_RX_STBC;
+		ht_cap.cap &= ~IEEE80211_HT_CAP_RX_STBC;
 	if (!(sband->ht_cap.cap & IEEE80211_HT_CAP_RX_STBC))
-		ht_cap->cap &= ~IEEE80211_HT_CAP_TX_STBC;
+		ht_cap.cap &= ~IEEE80211_HT_CAP_TX_STBC;
 
 	ampdu_info = ht_cap_ie->ampdu_params_info;
-	ht_cap->ampdu_factor =
+	ht_cap.ampdu_factor =
 		ampdu_info & IEEE80211_HT_AMPDU_PARM_FACTOR;
-	ht_cap->ampdu_density =
+	ht_cap.ampdu_density =
 		(ampdu_info & IEEE80211_HT_AMPDU_PARM_DENSITY) >> 2;
 
 	/* own MCS TX capabilities */
 	tx_mcs_set_cap = sband->ht_cap.mcs.tx_params;
 
 	/* Copy peer MCS TX capabilities, the driver might need them. */
-	ht_cap->mcs.tx_params = ht_cap_ie->mcs.tx_params;
+	ht_cap.mcs.tx_params = ht_cap_ie->mcs.tx_params;
 
 	/* can we TX with MCS rates? */
 	if (!(tx_mcs_set_cap & IEEE80211_HT_MCS_TX_DEFINED))
-		return;
+		goto apply;
 
 	/* Counting from 0, therefore +1 */
 	if (tx_mcs_set_cap & IEEE80211_HT_MCS_TX_RX_DIFF)
@@ -176,25 +179,32 @@ void ieee80211_ht_cap_ie_to_sta_ht_cap(struct ieee80211_sub_if_data *sdata,
 	 * - remainder are multiple spatial streams using unequal modulation
 	 */
 	for (i = 0; i < max_tx_streams; i++)
-		ht_cap->mcs.rx_mask[i] =
+		ht_cap.mcs.rx_mask[i] =
 			sband->ht_cap.mcs.rx_mask[i] & ht_cap_ie->mcs.rx_mask[i];
 
 	if (tx_mcs_set_cap & IEEE80211_HT_MCS_TX_UNEQUAL_MODULATION)
 		for (i = IEEE80211_HT_MCS_UNEQUAL_MODULATION_START_BYTE;
 		     i < IEEE80211_HT_MCS_MASK_LEN; i++)
-			ht_cap->mcs.rx_mask[i] =
+			ht_cap.mcs.rx_mask[i] =
 				sband->ht_cap.mcs.rx_mask[i] &
 					ht_cap_ie->mcs.rx_mask[i];
 
 	/* handle MCS rate 32 too */
 	if (sband->ht_cap.mcs.rx_mask[32/8] & ht_cap_ie->mcs.rx_mask[32/8] & 1)
-		ht_cap->mcs.rx_mask[32/8] |= 1;
+		ht_cap.mcs.rx_mask[32/8] |= 1;
 
+ apply:
 	/*
 	 * If user has specified capability over-rides, take care
 	 * of that here.
 	 */
-	ieee80211_apply_htcap_overrides(sdata, ht_cap);
+	ieee80211_apply_htcap_overrides(sdata, &ht_cap);
+
+	changed = memcmp(&sta->sta.ht_cap, &ht_cap, sizeof(ht_cap));
+
+	memcpy(&sta->sta.ht_cap, &ht_cap, sizeof(ht_cap));
+	sta->supports_40mhz = ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40;
+	return changed;
 }
 
 void ieee80211_sta_tear_down_BA_sessions(struct sta_info *sta,
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 2db1f2b..40b71df 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -496,33 +496,26 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 		if (sta && elems->ht_operation && elems->ht_cap_elem &&
 		    sdata->u.ibss.channel_type != NL80211_CHAN_NO_HT) {
 			/* we both use HT */
-			struct ieee80211_sta_ht_cap sta_ht_cap_new;
+			struct ieee80211_ht_cap htcap_ie;
 			struct cfg80211_chan_def chandef;
 
 			ieee80211_ht_oper_to_chandef(channel,
 						     elems->ht_operation,
 						     &chandef);
 
-			ieee80211_ht_cap_ie_to_sta_ht_cap(sdata, sband,
-							  elems->ht_cap_elem,
-							  &sta_ht_cap_new);
+			memcpy(&htcap_ie, elems->ht_cap_elem, sizeof(htcap_ie));
 
 			/*
 			 * fall back to HT20 if we don't use or use
 			 * the other extension channel
 			 */
-			if (chandef.width != NL80211_CHAN_WIDTH_40 ||
-			    cfg80211_get_chandef_type(&chandef) !=
+			if (cfg80211_get_chandef_type(&chandef) !=
 						sdata->u.ibss.channel_type)
-				sta_ht_cap_new.cap &=
-					~IEEE80211_HT_CAP_SUP_WIDTH_20_40;
-
-			if (memcmp(&sta->sta.ht_cap, &sta_ht_cap_new,
-				   sizeof(sta_ht_cap_new))) {
-				memcpy(&sta->sta.ht_cap, &sta_ht_cap_new,
-				       sizeof(sta_ht_cap_new));
-				rates_updated = true;
-			}
+				htcap_ie.cap_info &=
+					cpu_to_le16(~IEEE80211_HT_CAP_SUP_WIDTH_20_40);
+
+			rates_updated |= ieee80211_ht_cap_ie_to_sta_ht_cap(
+						sdata, sband, &htcap_ie, sta);
 		}
 
 		if (sta && rates_updated) {
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 35f5805..f107f4e 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1380,10 +1380,10 @@ void ieee80211_purge_tx_queue(struct ieee80211_hw *hw,
 /* HT */
 void ieee80211_apply_htcap_overrides(struct ieee80211_sub_if_data *sdata,
 				     struct ieee80211_sta_ht_cap *ht_cap);
-void ieee80211_ht_cap_ie_to_sta_ht_cap(struct ieee80211_sub_if_data *sdata,
+bool ieee80211_ht_cap_ie_to_sta_ht_cap(struct ieee80211_sub_if_data *sdata,
 				       struct ieee80211_supported_band *sband,
 				       struct ieee80211_ht_cap *ht_cap_ie,
-				       struct ieee80211_sta_ht_cap *ht_cap);
+				       struct sta_info *sta);
 void ieee80211_send_delba(struct ieee80211_sub_if_data *sdata,
 			  const u8 *da, u16 tid,
 			  u16 initiator, u16 reason_code);
diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 67524e7..df85487 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -373,8 +373,7 @@ static void mesh_sta_info_init(struct ieee80211_sub_if_data *sdata,
 	if (elems->ht_cap_elem &&
 	    sdata->vif.bss_conf.chandef.width != NL80211_CHAN_WIDTH_20_NOHT)
 		ieee80211_ht_cap_ie_to_sta_ht_cap(sdata, sband,
-						  elems->ht_cap_elem,
-						  &sta->sta.ht_cap);
+						  elems->ht_cap_elem, sta);
 	else
 		memset(&sta->sta.ht_cap, 0, sizeof(sta->sta.ht_cap));
 
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 66a392c..4faf785 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2193,10 +2193,7 @@ static bool ieee80211_assoc_success(struct ieee80211_sub_if_data *sdata,
 
 	if (elems.ht_cap_elem && !(ifmgd->flags & IEEE80211_STA_DISABLE_HT))
 		ieee80211_ht_cap_ie_to_sta_ht_cap(sdata, sband,
-				elems.ht_cap_elem, &sta->sta.ht_cap);
-
-	sta->supports_40mhz =
-		sta->sta.ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40;
+						  elems.ht_cap_elem, sta);
 
 	if (elems.vht_cap_elem && !(ifmgd->flags & IEEE80211_STA_DISABLE_VHT))
 		ieee80211_vht_cap_ie_to_sta_vht_cap(sdata, sband,
-- 
1.8.0

