Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59942 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964864Ab3DJMnv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Apr 2013 08:43:51 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 8/8] mac80211: handle wide bandwidth channel switch
Date: Wed, 10 Apr 2013 14:43:42 +0200
Message-Id: <1365597822-27660-9-git-send-email-johannes@sipsolutions.net> (sfid-20130410_144357_572708_2ACD0C03)
In-Reply-To: <1365597822-27660-1-git-send-email-johannes@sipsolutions.net>
References: <1365597822-27660-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Parse and react to the wide bandwidth channel switch element
in beacons/action frames. Finding the element was done in a
previous patch (it has different positions in beacons/action
frames), now handle it. If there's something wrong with it
simply disconnect.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mlme.c | 96 +++++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 79 insertions(+), 17 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index bfe70de..2172daa 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1028,7 +1028,11 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 	u8 new_chan_no;
 	u8 count;
 	u8 mode;
+	struct ieee80211_channel *new_chan;
 	struct cfg80211_chan_def new_chandef = {};
+	struct cfg80211_chan_def new_vht_chandef = {};
+	const struct ieee80211_sec_chan_offs_ie *sec_chan_offs;
+	const struct ieee80211_wide_bw_chansw_ie *wide_bw_chansw_ie;
 	int secondary_channel_offset = -1;
 
 	ASSERT_MGD_MTX(ifmgd);
@@ -1043,18 +1047,17 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 	if (ifmgd->flags & IEEE80211_STA_CSA_RECEIVED)
 		return;
 
-	if (!(ifmgd->flags & IEEE80211_STA_DISABLE_HT)) {
-		/* if HT is enabled and the IE not present, it's still HT */
-		secondary_channel_offset = IEEE80211_HT_PARAM_CHA_SEC_NONE;
-		if (elems->sec_chan_offs)
-			secondary_channel_offset =
-				elems->sec_chan_offs->sec_chan_offs;
+	sec_chan_offs = elems->sec_chan_offs;
+	wide_bw_chansw_ie = elems->wide_bw_chansw_ie;
+
+	if (ifmgd->flags & (IEEE80211_STA_DISABLE_HT |
+			    IEEE80211_STA_DISABLE_40MHZ)) {
+		sec_chan_offs = NULL;
+		wide_bw_chansw_ie = NULL;
 	}
 
-	if (ifmgd->flags & IEEE80211_STA_DISABLE_40MHZ &&
-	    (secondary_channel_offset == IEEE80211_HT_PARAM_CHA_SEC_ABOVE ||
-	     secondary_channel_offset == IEEE80211_HT_PARAM_CHA_SEC_BELOW))
-		secondary_channel_offset = IEEE80211_HT_PARAM_CHA_SEC_NONE;
+	if (ifmgd->flags & IEEE80211_STA_DISABLE_VHT)
+		wide_bw_chansw_ie = NULL;
 
 	if (elems->ext_chansw_ie) {
 		if (!ieee80211_operating_class_to_band(
@@ -1082,9 +1085,8 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 	bss = (void *)cbss->priv;
 
 	new_freq = ieee80211_channel_to_frequency(new_chan_no, new_band);
-	new_chandef.chan = ieee80211_get_channel(sdata->local->hw.wiphy, new_freq);
-	if (!new_chandef.chan ||
-	    new_chandef.chan->flags & IEEE80211_CHAN_DISABLED) {
+	new_chan = ieee80211_get_channel(sdata->local->hw.wiphy, new_freq);
+	if (!new_chan || new_chan->flags & IEEE80211_CHAN_DISABLED) {
 		sdata_info(sdata,
 			   "AP %pM switches to unsupported channel (%d MHz), disconnecting\n",
 			   ifmgd->associated->bssid, new_freq);
@@ -1093,27 +1095,87 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 		return;
 	}
 
+	if (sec_chan_offs) {
+		secondary_channel_offset = sec_chan_offs->sec_chan_offs;
+	} else if (!(ifmgd->flags & IEEE80211_STA_DISABLE_HT)) {
+		/* if HT is enabled and the IE not present, it's still HT */
+		secondary_channel_offset = IEEE80211_HT_PARAM_CHA_SEC_NONE;
+	}
+
 	switch (secondary_channel_offset) {
 	default:
 		/* secondary_channel_offset was present but is invalid */
 	case IEEE80211_HT_PARAM_CHA_SEC_NONE:
-		cfg80211_chandef_create(&new_chandef, new_chandef.chan,
+		cfg80211_chandef_create(&new_chandef, new_chan,
 					NL80211_CHAN_HT20);
 		break;
 	case IEEE80211_HT_PARAM_CHA_SEC_ABOVE:
-		cfg80211_chandef_create(&new_chandef, new_chandef.chan,
+		cfg80211_chandef_create(&new_chandef, new_chan,
 					NL80211_CHAN_HT40PLUS);
 		break;
 	case IEEE80211_HT_PARAM_CHA_SEC_BELOW:
-		cfg80211_chandef_create(&new_chandef, new_chandef.chan,
+		cfg80211_chandef_create(&new_chandef, new_chan,
 					NL80211_CHAN_HT40MINUS);
 		break;
 	case -1:
-		cfg80211_chandef_create(&new_chandef, new_chandef.chan,
+		cfg80211_chandef_create(&new_chandef, new_chan,
 					NL80211_CHAN_NO_HT);
 		break;
 	}
 
+	if (wide_bw_chansw_ie) {
+		new_vht_chandef.chan = new_chan;
+		new_vht_chandef.center_freq1 =
+			ieee80211_channel_to_frequency(
+				wide_bw_chansw_ie->new_center_freq_seg0,
+				new_band);
+
+		switch (wide_bw_chansw_ie->new_channel_width) {
+		default:
+			/* hmmm, ignore VHT and use HT if present */
+		case IEEE80211_VHT_CHANWIDTH_USE_HT:
+			new_vht_chandef.chan = NULL;
+			break;
+		case IEEE80211_VHT_CHANWIDTH_80MHZ:
+			new_vht_chandef.width = NL80211_CHAN_WIDTH_80;
+			break;
+		case IEEE80211_VHT_CHANWIDTH_160MHZ:
+			new_vht_chandef.width = NL80211_CHAN_WIDTH_160;
+			break;
+		case IEEE80211_VHT_CHANWIDTH_80P80MHZ:
+			/* field is otherwise reserved */
+			new_vht_chandef.center_freq2 =
+				ieee80211_channel_to_frequency(
+					wide_bw_chansw_ie->new_center_freq_seg1,
+					new_band);
+			new_vht_chandef.width = NL80211_CHAN_WIDTH_80P80;
+			break;
+		}
+		if (ifmgd->flags & IEEE80211_STA_DISABLE_80P80MHZ &&
+		    new_vht_chandef.width == NL80211_CHAN_WIDTH_80P80)
+			chandef_downgrade(&new_vht_chandef);
+		if (ifmgd->flags & IEEE80211_STA_DISABLE_160MHZ &&
+		    new_vht_chandef.width == NL80211_CHAN_WIDTH_160)
+			chandef_downgrade(&new_vht_chandef);
+		if (ifmgd->flags & IEEE80211_STA_DISABLE_40MHZ &&
+		    new_vht_chandef.width > NL80211_CHAN_WIDTH_20)
+			chandef_downgrade(&new_vht_chandef);
+	}
+
+	/* if VHT data is there validate & use it */
+	if (new_vht_chandef.chan) {
+		if (!cfg80211_chandef_compatible(&new_vht_chandef,
+						 &new_chandef)) {
+			sdata_info(sdata,
+				   "AP %pM CSA has inconsistent channel data, disconnecting\n",
+				   ifmgd->associated->bssid);
+			ieee80211_queue_work(&local->hw,
+					     &ifmgd->csa_connection_drop_work);
+			return;
+		}
+		new_chandef = new_vht_chandef;
+	}
+
 	if (!cfg80211_chandef_usable(local->hw.wiphy, &new_chandef,
 				     IEEE80211_CHAN_DISABLED)) {
 		sdata_info(sdata,
-- 
1.8.0

