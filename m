Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:42316 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753345AbdBNL2d (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Feb 2017 06:28:33 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: j@w1.fi, greearb@candelatech.com,
        Johannes Berg <johannes.berg@intel.com>
Subject: [RFC 1/4] ieee80211: rename CCFS1/CCFS2 to CCFS0/CCFS1
Date: Tue, 14 Feb 2017 12:28:24 +0100
Message-Id: <20170214112827.28216-1-johannes@sipsolutions.net> (sfid-20170214_123002_675314_DA191B21)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This matches the spec, and otherwise things are really
confusing with the next patch adding CCFS2.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/marvell/mwifiex/tdls.c |  2 +-
 include/linux/ieee80211.h                   |  4 ++--
 net/mac80211/spectmgmt.c                    |  4 ++--
 net/mac80211/util.c                         | 22 +++++++++++-----------
 4 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/tdls.c b/drivers/net/wireless/marvell/mwifiex/tdls.c
index df9704de0715..5fc8319ed302 100644
--- a/drivers/net/wireless/marvell/mwifiex/tdls.c
+++ b/drivers/net/wireless/marvell/mwifiex/tdls.c
@@ -349,7 +349,7 @@ static int mwifiex_tdls_add_vht_oper(struct mwifiex_private *priv,
 		chan_bw = IEEE80211_VHT_CHANWIDTH_USE_HT;
 		break;
 	}
-	vht_oper->center_freq_seg1_idx =
+	vht_oper->center_freq_seg0_idx =
 			mwifiex_get_center_freq_index(priv, BAND_AAC,
 						      bss_desc->channel,
 						      chan_bw);
diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 0dd9498c694f..4a15e77d9d66 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -1525,14 +1525,14 @@ enum ieee80211_vht_chanwidth {
  * This structure is the "VHT operation element" as
  * described in 802.11ac D3.0 8.4.2.161
  * @chan_width: Operating channel width
+ * @center_freq_seg0_idx: center freq segment 0 index
  * @center_freq_seg1_idx: center freq segment 1 index
- * @center_freq_seg2_idx: center freq segment 2 index
  * @basic_mcs_set: VHT Basic MCS rate set
  */
 struct ieee80211_vht_operation {
 	u8 chan_width;
+	u8 center_freq_seg0_idx;
 	u8 center_freq_seg1_idx;
-	u8 center_freq_seg2_idx;
 	__le16 basic_mcs_set;
 } __packed;
 
diff --git a/net/mac80211/spectmgmt.c b/net/mac80211/spectmgmt.c
index 97f4c9d6b54c..0782e486fe89 100644
--- a/net/mac80211/spectmgmt.c
+++ b/net/mac80211/spectmgmt.c
@@ -132,9 +132,9 @@ int ieee80211_parse_ch_switch_ie(struct ieee80211_sub_if_data *sdata,
 		struct ieee80211_vht_operation vht_oper = {
 			.chan_width =
 				wide_bw_chansw_ie->new_channel_width,
-			.center_freq_seg1_idx =
+			.center_freq_seg0_idx =
 				wide_bw_chansw_ie->new_center_freq_seg0,
-			.center_freq_seg2_idx =
+			.center_freq_seg1_idx =
 				wide_bw_chansw_ie->new_center_freq_seg1,
 			/* .basic_mcs_set doesn't matter */
 		};
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index ac59fbd280df..7a37ce78bb38 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -2413,13 +2413,13 @@ u8 *ieee80211_ie_build_vht_oper(u8 *pos, struct ieee80211_sta_vht_cap *vht_cap,
 	*pos++ = WLAN_EID_VHT_OPERATION;
 	*pos++ = sizeof(struct ieee80211_vht_operation);
 	vht_oper = (struct ieee80211_vht_operation *)pos;
-	vht_oper->center_freq_seg1_idx = ieee80211_frequency_to_channel(
+	vht_oper->center_freq_seg0_idx = ieee80211_frequency_to_channel(
 							chandef->center_freq1);
 	if (chandef->center_freq2)
-		vht_oper->center_freq_seg2_idx =
+		vht_oper->center_freq_seg1_idx =
 			ieee80211_frequency_to_channel(chandef->center_freq2);
 	else
-		vht_oper->center_freq_seg2_idx = 0x00;
+		vht_oper->center_freq_seg1_idx = 0x00;
 
 	switch (chandef->width) {
 	case NL80211_CHAN_WIDTH_160:
@@ -2428,11 +2428,11 @@ u8 *ieee80211_ie_build_vht_oper(u8 *pos, struct ieee80211_sta_vht_cap *vht_cap,
 		 * workaround.
 		 */
 		vht_oper->chan_width = IEEE80211_VHT_CHANWIDTH_80MHZ;
-		vht_oper->center_freq_seg2_idx = vht_oper->center_freq_seg1_idx;
+		vht_oper->center_freq_seg1_idx = vht_oper->center_freq_seg0_idx;
 		if (chandef->chan->center_freq < chandef->center_freq1)
-			vht_oper->center_freq_seg1_idx -= 8;
+			vht_oper->center_freq_seg0_idx -= 8;
 		else
-			vht_oper->center_freq_seg1_idx += 8;
+			vht_oper->center_freq_seg0_idx += 8;
 		break;
 	case NL80211_CHAN_WIDTH_80P80:
 		/*
@@ -2491,9 +2491,9 @@ bool ieee80211_chandef_vht_oper(const struct ieee80211_vht_operation *oper,
 	if (!oper)
 		return false;
 
-	cf1 = ieee80211_channel_to_frequency(oper->center_freq_seg1_idx,
+	cf1 = ieee80211_channel_to_frequency(oper->center_freq_seg0_idx,
 					     chandef->chan->band);
-	cf2 = ieee80211_channel_to_frequency(oper->center_freq_seg2_idx,
+	cf2 = ieee80211_channel_to_frequency(oper->center_freq_seg1_idx,
 					     chandef->chan->band);
 
 	switch (oper->chan_width) {
@@ -2503,11 +2503,11 @@ bool ieee80211_chandef_vht_oper(const struct ieee80211_vht_operation *oper,
 		new.width = NL80211_CHAN_WIDTH_80;
 		new.center_freq1 = cf1;
 		/* If needed, adjust based on the newer interop workaround. */
-		if (oper->center_freq_seg2_idx) {
+		if (oper->center_freq_seg1_idx) {
 			unsigned int diff;
 
-			diff = abs(oper->center_freq_seg2_idx -
-				   oper->center_freq_seg1_idx);
+			diff = abs(oper->center_freq_seg1_idx -
+				   oper->center_freq_seg0_idx);
 			if (diff == 8) {
 				new.width = NL80211_CHAN_WIDTH_160;
 				new.center_freq1 = cf2;
-- 
2.9.3
