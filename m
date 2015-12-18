Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:57575 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753120AbbLROIi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Dec 2015 09:08:38 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: refactor HT/VHT to chandef code
Date: Fri, 18 Dec 2015 15:08:34 +0100
Message-Id: <1450447714-11987-1-git-send-email-johannes@sipsolutions.net> (sfid-20151218_150844_915025_7647097D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The station MLME and IBSS/mesh ones use entirely different
code for interpreting HT and VHT operation elements. Change
the code that interprets them a bit - it now modifies an
existing chandef - and use it also in the MLME code.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ibss.c        | 10 ++++-----
 net/mac80211/ieee80211_i.h | 10 ++++-----
 net/mac80211/mesh.c        |  9 ++++----
 net/mac80211/mlme.c        | 41 ++++-------------------------------
 net/mac80211/util.c        | 54 +++++++++++++++++++++++++---------------------
 5 files changed, 46 insertions(+), 78 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index f7fc0e00497f..e5e8a317b865 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -1050,9 +1050,8 @@ static void ieee80211_update_sta_info(struct ieee80211_sub_if_data *sdata,
 		struct cfg80211_chan_def chandef;
 		enum ieee80211_sta_rx_bandwidth bw = sta->sta.bandwidth;
 
-		ieee80211_ht_oper_to_chandef(channel,
-					     elems->ht_operation,
-					     &chandef);
+		cfg80211_chandef_create(&chandef, channel, NL80211_CHAN_NO_HT);
+		ieee80211_chandef_ht_oper(elems->ht_operation, &chandef);
 
 		memcpy(&htcap_ie, elems->ht_cap_elem, sizeof(htcap_ie));
 		rates_updated |= ieee80211_ht_cap_ie_to_sta_ht_cap(sdata, sband,
@@ -1066,9 +1065,8 @@ static void ieee80211_update_sta_info(struct ieee80211_sub_if_data *sdata,
 			struct ieee80211_vht_cap cap_ie;
 			struct ieee80211_sta_vht_cap cap = sta->sta.vht_cap;
 
-			ieee80211_vht_oper_to_chandef(channel,
-						      elems->vht_operation,
-						      &chandef);
+			ieee80211_chandef_vht_oper(elems->vht_operation,
+						   &chandef);
 			memcpy(&cap_ie, elems->vht_cap_elem, sizeof(cap_ie));
 			ieee80211_vht_cap_ie_to_sta_vht_cap(sdata, sband,
 							    &cap_ie, sta);
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index c30b6842ed9f..2094e07ce9ae 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1986,12 +1986,10 @@ int ieee80211_add_ext_srates_ie(struct ieee80211_sub_if_data *sdata,
 u8 *ieee80211_add_wmm_info_ie(u8 *buf, u8 qosinfo);
 
 /* channel management */
-void ieee80211_ht_oper_to_chandef(struct ieee80211_channel *control_chan,
-				  const struct ieee80211_ht_operation *ht_oper,
-				  struct cfg80211_chan_def *chandef);
-void ieee80211_vht_oper_to_chandef(struct ieee80211_channel *control_chan,
-				   const struct ieee80211_vht_operation *oper,
-				   struct cfg80211_chan_def *chandef);
+bool ieee80211_chandef_ht_oper(const struct ieee80211_ht_operation *ht_oper,
+			       struct cfg80211_chan_def *chandef);
+bool ieee80211_chandef_vht_oper(const struct ieee80211_vht_operation *oper,
+				struct cfg80211_chan_def *chandef);
 u32 ieee80211_chandef_downgrade(struct cfg80211_chan_def *c);
 
 int __must_check
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index fa28500f28fd..9a8e7b57c86e 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -91,11 +91,10 @@ bool mesh_matches_local(struct ieee80211_sub_if_data *sdata,
 	if (sdata->vif.bss_conf.basic_rates != basic_rates)
 		return false;
 
-	ieee80211_ht_oper_to_chandef(sdata->vif.bss_conf.chandef.chan,
-				     ie->ht_operation, &sta_chan_def);
-
-	ieee80211_vht_oper_to_chandef(sdata->vif.bss_conf.chandef.chan,
-				      ie->vht_operation, &sta_chan_def);
+	cfg80211_chandef_create(&sta_chan_def, sdata->vif.bss_conf.chandef.chan,
+				NL80211_CHAN_NO_HT);
+	ieee80211_chandef_ht_oper(ie->ht_operation, &sta_chan_def);
+	ieee80211_chandef_vht_oper(ie->vht_operation, &sta_chan_def);
 
 	if (!cfg80211_chandef_compatible(&sdata->vif.bss_conf.chandef,
 					 &sta_chan_def))
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 123b26d177e8..ebc9b997529d 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -196,16 +196,7 @@ ieee80211_determine_chantype(struct ieee80211_sub_if_data *sdata,
 
 	/* check 40 MHz support, if we have it */
 	if (sta_ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40) {
-		switch (ht_oper->ht_param & IEEE80211_HT_PARAM_CHA_SEC_OFFSET) {
-		case IEEE80211_HT_PARAM_CHA_SEC_ABOVE:
-			chandef->width = NL80211_CHAN_WIDTH_40;
-			chandef->center_freq1 += 10;
-			break;
-		case IEEE80211_HT_PARAM_CHA_SEC_BELOW:
-			chandef->width = NL80211_CHAN_WIDTH_40;
-			chandef->center_freq1 -= 10;
-			break;
-		}
+		ieee80211_chandef_ht_oper(ht_oper, chandef);
 	} else {
 		/* 40 MHz (and 80 MHz) must be supported for VHT */
 		ret = IEEE80211_STA_DISABLE_VHT;
@@ -219,35 +210,11 @@ ieee80211_determine_chantype(struct ieee80211_sub_if_data *sdata,
 		goto out;
 	}
 
-	vht_chandef.chan = channel;
-	vht_chandef.center_freq1 =
-		ieee80211_channel_to_frequency(vht_oper->center_freq_seg1_idx,
-					       channel->band);
-	vht_chandef.center_freq2 = 0;
-
-	switch (vht_oper->chan_width) {
-	case IEEE80211_VHT_CHANWIDTH_USE_HT:
-		vht_chandef.width = chandef->width;
-		vht_chandef.center_freq1 = chandef->center_freq1;
-		break;
-	case IEEE80211_VHT_CHANWIDTH_80MHZ:
-		vht_chandef.width = NL80211_CHAN_WIDTH_80;
-		break;
-	case IEEE80211_VHT_CHANWIDTH_160MHZ:
-		vht_chandef.width = NL80211_CHAN_WIDTH_160;
-		break;
-	case IEEE80211_VHT_CHANWIDTH_80P80MHZ:
-		vht_chandef.width = NL80211_CHAN_WIDTH_80P80;
-		vht_chandef.center_freq2 =
-			ieee80211_channel_to_frequency(
-				vht_oper->center_freq_seg2_idx,
-				channel->band);
-		break;
-	default:
+	vht_chandef = *chandef;
+	if (!ieee80211_chandef_vht_oper(vht_oper, &vht_chandef)) {
 		if (!(ifmgd->flags & IEEE80211_STA_DISABLE_VHT))
 			sdata_info(sdata,
-				   "AP VHT operation IE has invalid channel width (%d), disable VHT\n",
-				   vht_oper->chan_width);
+				   "AP VHT information is invalid, disable VHT\n");
 		ret = IEEE80211_STA_DISABLE_VHT;
 		goto out;
 	}
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 08af2b307945..80d8db9eb43c 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -2367,17 +2367,13 @@ u8 *ieee80211_ie_build_vht_oper(u8 *pos, struct ieee80211_sta_vht_cap *vht_cap,
 	return pos + sizeof(struct ieee80211_vht_operation);
 }
 
-void ieee80211_ht_oper_to_chandef(struct ieee80211_channel *control_chan,
-				  const struct ieee80211_ht_operation *ht_oper,
-				  struct cfg80211_chan_def *chandef)
+bool ieee80211_chandef_ht_oper(const struct ieee80211_ht_operation *ht_oper,
+			       struct cfg80211_chan_def *chandef)
 {
 	enum nl80211_channel_type channel_type;
 
-	if (!ht_oper) {
-		cfg80211_chandef_create(chandef, control_chan,
-					NL80211_CHAN_NO_HT);
-		return;
-	}
+	if (!ht_oper)
+		return false;
 
 	switch (ht_oper->ht_param & IEEE80211_HT_PARAM_CHA_SEC_OFFSET) {
 	case IEEE80211_HT_PARAM_CHA_SEC_NONE:
@@ -2391,42 +2387,52 @@ void ieee80211_ht_oper_to_chandef(struct ieee80211_channel *control_chan,
 		break;
 	default:
 		channel_type = NL80211_CHAN_NO_HT;
+		return false;
 	}
 
-	cfg80211_chandef_create(chandef, control_chan, channel_type);
+	cfg80211_chandef_create(chandef, chandef->chan, channel_type);
+	return true;
 }
 
-void ieee80211_vht_oper_to_chandef(struct ieee80211_channel *control_chan,
-				   const struct ieee80211_vht_operation *oper,
-				   struct cfg80211_chan_def *chandef)
+bool ieee80211_chandef_vht_oper(const struct ieee80211_vht_operation *oper,
+				struct cfg80211_chan_def *chandef)
 {
+	struct cfg80211_chan_def new = *chandef;
+	int cf1, cf2;
+
 	if (!oper)
-		return;
+		return false;
 
-	chandef->chan = control_chan;
+	cf1 = ieee80211_channel_to_frequency(oper->center_freq_seg1_idx,
+					     chandef->chan->band);
+	cf2 = ieee80211_channel_to_frequency(oper->center_freq_seg2_idx,
+					     chandef->chan->band);
 
 	switch (oper->chan_width) {
 	case IEEE80211_VHT_CHANWIDTH_USE_HT:
 		break;
 	case IEEE80211_VHT_CHANWIDTH_80MHZ:
-		chandef->width = NL80211_CHAN_WIDTH_80;
+		new.width = NL80211_CHAN_WIDTH_80;
+		new.center_freq1 = cf1;
 		break;
 	case IEEE80211_VHT_CHANWIDTH_160MHZ:
-		chandef->width = NL80211_CHAN_WIDTH_160;
+		new.width = NL80211_CHAN_WIDTH_160;
+		new.center_freq1 = cf1;
 		break;
 	case IEEE80211_VHT_CHANWIDTH_80P80MHZ:
-		chandef->width = NL80211_CHAN_WIDTH_80P80;
+		new.width = NL80211_CHAN_WIDTH_80P80;
+		new.center_freq1 = cf1;
+		new.center_freq2 = cf2;
 		break;
 	default:
-		break;
+		return false;
 	}
 
-	chandef->center_freq1 =
-		ieee80211_channel_to_frequency(oper->center_freq_seg1_idx,
-					       control_chan->band);
-	chandef->center_freq2 =
-		ieee80211_channel_to_frequency(oper->center_freq_seg2_idx,
-					       control_chan->band);
+	if (!cfg80211_chandef_valid(&new))
+		return false;
+
+	*chandef = new;
+	return true;
 }
 
 int ieee80211_parse_bitrates(struct cfg80211_chan_def *chandef,
-- 
2.6.2

