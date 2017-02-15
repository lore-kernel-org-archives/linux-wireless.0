Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:59836 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751267AbdBOODB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Feb 2017 09:03:01 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC v2 3/5] mac80211: add ability to parse CCFS2
Date: Wed, 15 Feb 2017 15:02:54 +0100
Message-Id: <20170215140256.19455-3-johannes@sipsolutions.net> (sfid-20170215_150306_762737_97DBD5F3)
In-Reply-To: <20170215140256.19455-1-johannes@sipsolutions.net>
References: <20170215140256.19455-1-johannes@sipsolutions.net>
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
 net/mac80211/mesh.c        |  4 +++-
 net/mac80211/mlme.c        |  3 ++-
 net/mac80211/spectmgmt.c   |  5 ++++-
 net/mac80211/util.c        | 48 ++++++++++++++++++++++++++++++----------------
 6 files changed, 47 insertions(+), 21 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 98999d3d5262..a5c0c5818da5 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -1065,7 +1065,9 @@ static void ieee80211_update_sta_info(struct ieee80211_sub_if_data *sdata,
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
index 4047fc528977..b0690c2d7f7d 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -2074,7 +2074,9 @@ u8 *ieee80211_add_wmm_info_ie(u8 *buf, u8 qosinfo);
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
index c28b0af9c1f2..1b60b4350517 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -92,7 +92,9 @@ bool mesh_matches_local(struct ieee80211_sub_if_data *sdata,
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
index 23986934d7af..2ff3040ebb09 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -213,7 +213,8 @@ ieee80211_determine_chantype(struct ieee80211_sub_if_data *sdata,
 	}
 
 	vht_chandef = *chandef;
-	if (!ieee80211_chandef_vht_oper(vht_oper, &vht_chandef)) {
+	if (!ieee80211_chandef_vht_oper(&sdata->local->hw,
+					vht_oper, ht_oper, &vht_chandef)) {
 		if (!(ifmgd->flags & IEEE80211_STA_DISABLE_VHT))
 			sdata_info(sdata,
 				   "AP VHT information is invalid, disable VHT\n");
diff --git a/net/mac80211/spectmgmt.c b/net/mac80211/spectmgmt.c
index 0782e486fe89..5a013b53b4f0 100644
--- a/net/mac80211/spectmgmt.c
+++ b/net/mac80211/spectmgmt.c
@@ -138,6 +138,7 @@ int ieee80211_parse_ch_switch_ie(struct ieee80211_sub_if_data *sdata,
 				wide_bw_chansw_ie->new_center_freq_seg1,
 			/* .basic_mcs_set doesn't matter */
 		};
+		struct ieee80211_ht_operation ht_oper = {};
 
 		/* default, for the case of IEEE80211_VHT_CHANWIDTH_USE_HT,
 		 * to the previously parsed chandef
@@ -145,7 +146,9 @@ int ieee80211_parse_ch_switch_ie(struct ieee80211_sub_if_data *sdata,
 		new_vht_chandef = csa_ie->chandef;
 
 		/* ignore if parsing fails */
-		if (!ieee80211_chandef_vht_oper(&vht_oper, &new_vht_chandef))
+		if (!ieee80211_chandef_vht_oper(&sdata->local->hw,
+						&vht_oper, &ht_oper,
+						&new_vht_chandef))
 			new_vht_chandef.chan = NULL;
 
 		if (sta_flags & IEEE80211_STA_DISABLE_80P80MHZ &&
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 7a37ce78bb38..152aae54b67f 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -2482,49 +2482,65 @@ bool ieee80211_chandef_ht_oper(const struct ieee80211_ht_operation *ht_oper,
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
2.9.3
