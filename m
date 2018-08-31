Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:45428 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727568AbeHaMmF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 31 Aug 2018 08:42:05 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>
Date: Fri, 31 Aug 2018 11:31:18 +0300
Message-Id: <20180831083130.15525-17-luca@coelho.fi> (sfid-20180831_103654_399489_110D6A28)
In-Reply-To: <20180831083130.15525-1-luca@coelho.fi>
References: <20180831083130.15525-1-luca@coelho.fi>
Subject: [PATCH 16/28] mac80211: add ability to parse CCFS2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

With newer VHT implementations, it's necessary to look at the
HT operation's CCFS2 field to identify the actual bandwidth
used.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ibss.c        |  4 +++-
 net/mac80211/ieee80211_i.h |  4 +++-
 net/mac80211/mesh.c        |  5 +++-
 net/mac80211/mlme.c        |  6 +++--
 net/mac80211/spectmgmt.c   |  5 +++-
 net/mac80211/util.c        | 48 +++++++++++++++++++++++++-------------
 6 files changed, 50 insertions(+), 22 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index f0f5fedb8caa..0d704e8d7078 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -1070,7 +1070,9 @@ static void ieee80211_update_sta_info(struct ieee80211_sub_if_data *sdata,
 			struct ieee80211_vht_cap cap_ie;
 			struct ieee80211_sta_vht_cap cap = sta->sta.vht_cap;
 
-			ieee80211_chandef_vht_oper(elems->vht_operation,
+			ieee80211_chandef_vht_oper(&local->hw,
+						   elems->vht_operation,
+						   elems->ht_operation,
 						   &chandef);
 			memcpy(&cap_ie, elems->vht_cap_elem, sizeof(cap_ie));
 			ieee80211_vht_cap_ie_to_sta_vht_cap(sdata, sband,
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 08da90adeaea..f40a2167935f 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -2112,7 +2112,9 @@ u8 *ieee80211_add_wmm_info_ie(u8 *buf, u8 qosinfo);
 /* channel management */
 bool ieee80211_chandef_ht_oper(const struct ieee80211_ht_operation *ht_oper,
 			       struct cfg80211_chan_def *chandef);
-bool ieee80211_chandef_vht_oper(const struct ieee80211_vht_operation *oper,
+bool ieee80211_chandef_vht_oper(struct ieee80211_hw *hw,
+				const struct ieee80211_vht_operation *oper,
+				const struct ieee80211_ht_operation *htop,
 				struct cfg80211_chan_def *chandef);
 u32 ieee80211_chandef_downgrade(struct cfg80211_chan_def *c);
 
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index d51da26e9c18..8bad414c52ad 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -1,5 +1,6 @@
 /*
  * Copyright (c) 2008, 2009 open80211s Ltd.
+ * Copyright (C) 2018 Intel Corporation
  * Authors:    Luis Carlos Cobo <luisca@cozybit.com>
  * 	       Javier Cardona <javier@cozybit.com>
  *
@@ -98,7 +99,9 @@ bool mesh_matches_local(struct ieee80211_sub_if_data *sdata,
 	cfg80211_chandef_create(&sta_chan_def, sdata->vif.bss_conf.chandef.chan,
 				NL80211_CHAN_NO_HT);
 	ieee80211_chandef_ht_oper(ie->ht_operation, &sta_chan_def);
-	ieee80211_chandef_vht_oper(ie->vht_operation, &sta_chan_def);
+	ieee80211_chandef_vht_oper(&sdata->local->hw,
+				   ie->vht_operation, ie->ht_operation,
+				   &sta_chan_def);
 
 	if (!cfg80211_chandef_compatible(&sdata->vif.bss_conf.chandef,
 					 &sta_chan_def))
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 3dbecae4be73..764a0f8e1dd1 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -220,7 +220,8 @@ ieee80211_determine_chantype(struct ieee80211_sub_if_data *sdata,
 		memcpy(&he_oper_vht_cap, he_oper->optional, 3);
 		he_oper_vht_cap.basic_mcs_set = cpu_to_le16(0);
 
-		if (!ieee80211_chandef_vht_oper(&he_oper_vht_cap,
+		if (!ieee80211_chandef_vht_oper(&sdata->local->hw,
+						&he_oper_vht_cap, ht_oper,
 						&vht_chandef)) {
 			if (!(ifmgd->flags & IEEE80211_STA_DISABLE_HE))
 				sdata_info(sdata,
@@ -228,7 +229,8 @@ ieee80211_determine_chantype(struct ieee80211_sub_if_data *sdata,
 			ret = IEEE80211_STA_DISABLE_HE;
 			goto out;
 		}
-	} else if (!ieee80211_chandef_vht_oper(vht_oper, &vht_chandef)) {
+	} else if (!ieee80211_chandef_vht_oper(&sdata->local->hw, vht_oper,
+					       ht_oper, &vht_chandef)) {
 		if (!(ifmgd->flags & IEEE80211_STA_DISABLE_VHT))
 			sdata_info(sdata,
 				   "AP VHT information is invalid, disable VHT\n");
diff --git a/net/mac80211/spectmgmt.c b/net/mac80211/spectmgmt.c
index 029334835747..4e4902bdbef8 100644
--- a/net/mac80211/spectmgmt.c
+++ b/net/mac80211/spectmgmt.c
@@ -144,6 +144,7 @@ int ieee80211_parse_ch_switch_ie(struct ieee80211_sub_if_data *sdata,
 				wide_bw_chansw_ie->new_center_freq_seg1,
 			/* .basic_mcs_set doesn't matter */
 		};
+		struct ieee80211_ht_operation ht_oper = {};
 
 		/* default, for the case of IEEE80211_VHT_CHANWIDTH_USE_HT,
 		 * to the previously parsed chandef
@@ -151,7 +152,9 @@ int ieee80211_parse_ch_switch_ie(struct ieee80211_sub_if_data *sdata,
 		new_vht_chandef = csa_ie->chandef;
 
 		/* ignore if parsing fails */
-		if (!ieee80211_chandef_vht_oper(&vht_oper, &new_vht_chandef))
+		if (!ieee80211_chandef_vht_oper(&sdata->local->hw,
+						&vht_oper, &ht_oper,
+						&new_vht_chandef))
 			new_vht_chandef.chan = NULL;
 
 		if (sta_flags & IEEE80211_STA_DISABLE_80P80MHZ &&
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index c03362f34bf4..a2d2c9fb7918 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -2757,49 +2757,65 @@ bool ieee80211_chandef_ht_oper(const struct ieee80211_ht_operation *ht_oper,
 	return true;
 }
 
-bool ieee80211_chandef_vht_oper(const struct ieee80211_vht_operation *oper,
+bool ieee80211_chandef_vht_oper(struct ieee80211_hw *hw,
+				const struct ieee80211_vht_operation *oper,
+				const struct ieee80211_ht_operation *htop,
 				struct cfg80211_chan_def *chandef)
 {
 	struct cfg80211_chan_def new = *chandef;
-	int cf1, cf2;
+	int cf0, cf1;
+	int ccfs0, ccfs1, ccfs2;
+	int ccf0, ccf1;
 
-	if (!oper)
+	if (!oper || !htop)
 		return false;
 
-	cf1 = ieee80211_channel_to_frequency(oper->center_freq_seg0_idx,
-					     chandef->chan->band);
-	cf2 = ieee80211_channel_to_frequency(oper->center_freq_seg1_idx,
-					     chandef->chan->band);
+	ccfs0 = oper->center_freq_seg0_idx;
+	ccfs1 = oper->center_freq_seg1_idx;
+	ccfs2 = (le16_to_cpu(htop->operation_mode) &
+				IEEE80211_HT_OP_MODE_CCFS2_MASK)
+			>> IEEE80211_HT_OP_MODE_CCFS2_SHIFT;
+
+	/* when parsing (and we know how to) CCFS1 and CCFS2 are equivalent */
+	ccf0 = ccfs0;
+	ccf1 = ccfs1;
+	if (!ccfs1 && ieee80211_hw_check(hw, SUPPORTS_VHT_EXT_NSS_BW))
+		ccf1 = ccfs2;
+
+	cf0 = ieee80211_channel_to_frequency(ccf0, chandef->chan->band);
+	cf1 = ieee80211_channel_to_frequency(ccf1, chandef->chan->band);
 
 	switch (oper->chan_width) {
 	case IEEE80211_VHT_CHANWIDTH_USE_HT:
+		/* just use HT information directly */
 		break;
 	case IEEE80211_VHT_CHANWIDTH_80MHZ:
 		new.width = NL80211_CHAN_WIDTH_80;
-		new.center_freq1 = cf1;
+		new.center_freq1 = cf0;
 		/* If needed, adjust based on the newer interop workaround. */
-		if (oper->center_freq_seg1_idx) {
+		if (ccf1) {
 			unsigned int diff;
 
-			diff = abs(oper->center_freq_seg1_idx -
-				   oper->center_freq_seg0_idx);
+			diff = abs(ccf1 - ccf0);
 			if (diff == 8) {
 				new.width = NL80211_CHAN_WIDTH_160;
-				new.center_freq1 = cf2;
+				new.center_freq1 = cf1;
 			} else if (diff > 8) {
 				new.width = NL80211_CHAN_WIDTH_80P80;
-				new.center_freq2 = cf2;
+				new.center_freq2 = cf1;
 			}
 		}
 		break;
 	case IEEE80211_VHT_CHANWIDTH_160MHZ:
+		/* deprecated encoding */
 		new.width = NL80211_CHAN_WIDTH_160;
-		new.center_freq1 = cf1;
+		new.center_freq1 = cf0;
 		break;
 	case IEEE80211_VHT_CHANWIDTH_80P80MHZ:
+		/* deprecated encoding */
 		new.width = NL80211_CHAN_WIDTH_80P80;
-		new.center_freq1 = cf1;
-		new.center_freq2 = cf2;
+		new.center_freq1 = cf0;
+		new.center_freq2 = cf1;
 		break;
 	default:
 		return false;
-- 
2.18.0
