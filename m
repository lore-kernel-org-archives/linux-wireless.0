Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:43901 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754156Ab3HBPiT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Aug 2013 11:38:19 -0400
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCH 3/7] mac80211: split off channel switch parsing function
Date: Fri,  2 Aug 2013 17:38:02 +0200
Message-Id: <1375457886-7275-4-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20130802_173839_900471_6B71A9CF)
In-Reply-To: <1375457886-7275-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1375457886-7275-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The channel switch parsing function can be re-used for the IBSS code,
put the common part into an extra function.

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
---
 net/mac80211/ieee80211_i.h |   22 +++++++
 net/mac80211/mlme.c        |  136 ++++++++++++++++++++++++--------------------
 2 files changed, 97 insertions(+), 61 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index e94c840..1275bde 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1333,6 +1333,9 @@ int ieee80211_ibss_leave(struct ieee80211_sub_if_data *sdata);
 void ieee80211_ibss_work(struct ieee80211_sub_if_data *sdata);
 void ieee80211_ibss_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
 				   struct sk_buff *skb);
+int ieee80211_ibss_csa_beacon(struct ieee80211_sub_if_data *sdata,
+			      struct cfg80211_csa_settings *csa_settings);
+int ieee80211_ibss_finish_csa(struct ieee80211_sub_if_data *sdata);
 
 /* mesh code */
 void ieee80211_mesh_work(struct ieee80211_sub_if_data *sdata);
@@ -1560,6 +1563,25 @@ static inline void ieee80211_tx_skb(struct ieee80211_sub_if_data *sdata,
 u32 ieee802_11_parse_elems_crc(const u8 *start, size_t len, bool action,
 			       struct ieee802_11_elems *elems,
 			       u64 filter, u32 crc);
+
+/**
+ * ieee80211_parse_ch_switch_ie - parses channel switch IEs
+ * @sdata: the sdata of the interface which has received the frame
+ * @elems: parsed 802.11 elements received with the frame
+ * @beacon: indicates if the frame was a beacon or probe response
+ * @current_band: indicates the current band
+ * @sta_flags: contains information about own capabilities and restrictions
+ * @count: to be filled with the counter until the switch (on success only)
+ * @mode: to be filled with CSA mode (on success only)
+ * @new_chandef: to be filled with destination chandef (on success only)
+ * Return: 0 on success, <0 on error and >0 if there is nothing to parse.
+ */
+int ieee80211_parse_ch_switch_ie(struct ieee80211_sub_if_data *sdata,
+				 struct ieee802_11_elems *elems, bool beacon,
+				 enum ieee80211_band current_band,
+				 u32 sta_flags, u8 *count, u8 *mode,
+				 struct cfg80211_chan_def *new_chandef);
+
 static inline void ieee802_11_parse_elems(const u8 *start, size_t len,
 					  bool action,
 					  struct ieee802_11_elems *elems)
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 45a87ee..60554c8 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -981,54 +981,35 @@ static void ieee80211_chswitch_timer(unsigned long data)
 	ieee80211_queue_work(&sdata->local->hw, &sdata->u.mgd.chswitch_work);
 }
 
-static void
-ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
-				 u64 timestamp, struct ieee802_11_elems *elems,
-				 bool beacon)
+int ieee80211_parse_ch_switch_ie(struct ieee80211_sub_if_data *sdata,
+				 struct ieee802_11_elems *elems, bool beacon,
+				 enum ieee80211_band current_band,
+				 u32 sta_flags, u8 *count, u8 *mode,
+				 struct cfg80211_chan_def *new_chandef)
 {
-	struct ieee80211_local *local = sdata->local;
-	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
-	struct cfg80211_bss *cbss = ifmgd->associated;
-	struct ieee80211_bss *bss;
-	struct ieee80211_chanctx *chanctx;
 	enum ieee80211_band new_band;
 	int new_freq;
 	u8 new_chan_no;
-	u8 count;
-	u8 mode;
 	struct ieee80211_channel *new_chan;
-	struct cfg80211_chan_def new_chandef = {};
 	struct cfg80211_chan_def new_vht_chandef = {};
 	const struct ieee80211_sec_chan_offs_ie *sec_chan_offs;
 	const struct ieee80211_wide_bw_chansw_ie *wide_bw_chansw_ie;
 	const struct ieee80211_ht_operation *ht_oper;
 	int secondary_channel_offset = -1;
 
-	sdata_assert_lock(sdata);
-
-	if (!cbss)
-		return;
-
-	if (local->scanning)
-		return;
-
-	/* disregard subsequent announcements if we are already processing */
-	if (ifmgd->flags & IEEE80211_STA_CSA_RECEIVED)
-		return;
-
 	sec_chan_offs = elems->sec_chan_offs;
 	wide_bw_chansw_ie = elems->wide_bw_chansw_ie;
 	ht_oper = elems->ht_operation;
 
-	if (ifmgd->flags & (IEEE80211_STA_DISABLE_HT |
-			    IEEE80211_STA_DISABLE_40MHZ)) {
+	if (sta_flags & (IEEE80211_STA_DISABLE_HT |
+			 IEEE80211_STA_DISABLE_40MHZ)) {
 		sec_chan_offs = NULL;
 		wide_bw_chansw_ie = NULL;
 		/* only used for bandwidth here */
 		ht_oper = NULL;
 	}
 
-	if (ifmgd->flags & IEEE80211_STA_DISABLE_VHT)
+	if (sta_flags & IEEE80211_STA_DISABLE_VHT)
 		wide_bw_chansw_ie = NULL;
 
 	if (elems->ext_chansw_ie) {
@@ -1038,33 +1019,28 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 			sdata_info(sdata,
 				   "cannot understand ECSA IE operating class %d, disconnecting\n",
 				   elems->ext_chansw_ie->new_operating_class);
-			ieee80211_queue_work(&local->hw,
-					     &ifmgd->csa_connection_drop_work);
+			return -EINVAL;
 		}
 		new_chan_no = elems->ext_chansw_ie->new_ch_num;
-		count = elems->ext_chansw_ie->count;
-		mode = elems->ext_chansw_ie->mode;
+		*count = elems->ext_chansw_ie->count;
+		*mode = elems->ext_chansw_ie->mode;
 	} else if (elems->ch_switch_ie) {
-		new_band = cbss->channel->band;
+		new_band = current_band;
 		new_chan_no = elems->ch_switch_ie->new_ch_num;
-		count = elems->ch_switch_ie->count;
-		mode = elems->ch_switch_ie->mode;
+		*count = elems->ch_switch_ie->count;
+		*mode = elems->ch_switch_ie->mode;
 	} else {
 		/* nothing here we understand */
-		return;
+		return 1;
 	}
 
-	bss = (void *)cbss->priv;
-
 	new_freq = ieee80211_channel_to_frequency(new_chan_no, new_band);
 	new_chan = ieee80211_get_channel(sdata->local->hw.wiphy, new_freq);
 	if (!new_chan || new_chan->flags & IEEE80211_CHAN_DISABLED) {
 		sdata_info(sdata,
-			   "AP %pM switches to unsupported channel (%d MHz), disconnecting\n",
-			   ifmgd->associated->bssid, new_freq);
-		ieee80211_queue_work(&local->hw,
-				     &ifmgd->csa_connection_drop_work);
-		return;
+			   "network switches to unsupported channel (%d MHz), disconnecting\n",
+			   new_freq);
+		return -EINVAL;
 	}
 
 	if (!beacon && sec_chan_offs) {
@@ -1072,7 +1048,7 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 	} else if (beacon && ht_oper) {
 		secondary_channel_offset =
 			ht_oper->ht_param & IEEE80211_HT_PARAM_CHA_SEC_OFFSET;
-	} else if (!(ifmgd->flags & IEEE80211_STA_DISABLE_HT)) {
+	} else if (!(sta_flags & IEEE80211_STA_DISABLE_HT)) {
 		/*
 		 * If it's not a beacon, HT is enabled and the IE not present,
 		 * it's 20 MHz, 802.11-2012 8.5.2.6:
@@ -1088,25 +1064,25 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 	default:
 		/* secondary_channel_offset was present but is invalid */
 	case IEEE80211_HT_PARAM_CHA_SEC_NONE:
-		cfg80211_chandef_create(&new_chandef, new_chan,
+		cfg80211_chandef_create(new_chandef, new_chan,
 					NL80211_CHAN_HT20);
 		break;
 	case IEEE80211_HT_PARAM_CHA_SEC_ABOVE:
-		cfg80211_chandef_create(&new_chandef, new_chan,
+		cfg80211_chandef_create(new_chandef, new_chan,
 					NL80211_CHAN_HT40PLUS);
 		break;
 	case IEEE80211_HT_PARAM_CHA_SEC_BELOW:
-		cfg80211_chandef_create(&new_chandef, new_chan,
+		cfg80211_chandef_create(new_chandef, new_chan,
 					NL80211_CHAN_HT40MINUS);
 		break;
 	case -1:
-		cfg80211_chandef_create(&new_chandef, new_chan,
+		cfg80211_chandef_create(new_chandef, new_chan,
 					NL80211_CHAN_NO_HT);
 		/* keep width for 5/10 MHz channels */
 		switch (sdata->vif.bss_conf.chandef.width) {
 		case NL80211_CHAN_WIDTH_5:
 		case NL80211_CHAN_WIDTH_10:
-			new_chandef.width = sdata->vif.bss_conf.chandef.width;
+			new_chandef->width = sdata->vif.bss_conf.chandef.width;
 			break;
 		default:
 			break;
@@ -1142,13 +1118,13 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 			new_vht_chandef.width = NL80211_CHAN_WIDTH_80P80;
 			break;
 		}
-		if (ifmgd->flags & IEEE80211_STA_DISABLE_80P80MHZ &&
+		if (sta_flags & IEEE80211_STA_DISABLE_80P80MHZ &&
 		    new_vht_chandef.width == NL80211_CHAN_WIDTH_80P80)
 			chandef_downgrade(&new_vht_chandef);
-		if (ifmgd->flags & IEEE80211_STA_DISABLE_160MHZ &&
+		if (sta_flags & IEEE80211_STA_DISABLE_160MHZ &&
 		    new_vht_chandef.width == NL80211_CHAN_WIDTH_160)
 			chandef_downgrade(&new_vht_chandef);
-		if (ifmgd->flags & IEEE80211_STA_DISABLE_40MHZ &&
+		if (sta_flags & IEEE80211_STA_DISABLE_40MHZ &&
 		    new_vht_chandef.width > NL80211_CHAN_WIDTH_20)
 			chandef_downgrade(&new_vht_chandef);
 	}
@@ -1156,23 +1132,61 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 	/* if VHT data is there validate & use it */
 	if (new_vht_chandef.chan) {
 		if (!cfg80211_chandef_compatible(&new_vht_chandef,
-						 &new_chandef)) {
+						 new_chandef)) {
 			sdata_info(sdata,
-				   "AP %pM CSA has inconsistent channel data, disconnecting\n",
-				   ifmgd->associated->bssid);
-			ieee80211_queue_work(&local->hw,
-					     &ifmgd->csa_connection_drop_work);
-			return;
+				   "network CSA has inconsistent channel data, disconnecting\n");
+			return -EINVAL;
 		}
-		new_chandef = new_vht_chandef;
+		*new_chandef = new_vht_chandef;
 	}
 
+	return 0;
+}
+
+static void
+ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
+				 u64 timestamp, struct ieee802_11_elems *elems,
+				 bool beacon)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+	struct cfg80211_bss *cbss = ifmgd->associated;
+	struct ieee80211_chanctx *chanctx;
+	enum ieee80211_band current_band;
+	u8 count;
+	u8 mode;
+	struct cfg80211_chan_def new_chandef = {};
+	int res;
+
+	sdata_assert_lock(sdata);
+
+	if (!cbss)
+		return;
+
+	if (local->scanning)
+		return;
+
+	/* disregard subsequent announcements if we are already processing */
+	if (ifmgd->flags & IEEE80211_STA_CSA_RECEIVED)
+		return;
+
+	current_band = cbss->channel->band;
+	res = ieee80211_parse_ch_switch_ie(sdata, elems, beacon, current_band,
+					   ifmgd->flags, &count, &mode,
+					   &new_chandef);
+	if (res	< 0)
+		ieee80211_queue_work(&local->hw,
+				     &ifmgd->csa_connection_drop_work);
+	if (res)
+		return;
+
 	if (!cfg80211_chandef_usable(local->hw.wiphy, &new_chandef,
 				     IEEE80211_CHAN_DISABLED)) {
 		sdata_info(sdata,
-			   "AP %pM switches to unsupported channel (%d MHz, width:%d, CF1/2: %d/%d MHz), disconnecting\n",
-			   ifmgd->associated->bssid, new_freq,
-			   new_chandef.width, new_chandef.center_freq1,
+			   "network switches to unsupported channel (%d MHz, width:%d, CF1/2: %d/%d MHz), disconnecting\n",
+			   new_chandef.chan->center_freq,
+			   new_chandef.width,
+			   new_chandef.center_freq1,
 			   new_chandef.center_freq2);
 		ieee80211_queue_work(&local->hw,
 				     &ifmgd->csa_connection_drop_work);
-- 
1.7.10.4

