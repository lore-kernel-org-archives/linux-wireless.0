Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:55748 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852Ab3HSPM1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Aug 2013 11:12:27 -0400
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCHv3 2/6] mac80211: split off channel switch parsing function
Date: Mon, 19 Aug 2013 17:12:16 +0200
Message-Id: <1376925141-15353-3-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20130819_171240_680676_0EAD5C73)
In-Reply-To: <1376925141-15353-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1376925141-15353-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The channel switch parsing function can be re-used for the IBSS code,
put the common part into an extra function.

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
---
Changes to PATCHv2:
 * move ieee80211_parse_ch_switch_ie() to mlme.c
 * document used sta_flags

Changes to PATCHv1:
 * keep reporting the BSSID, this is still important debug output
 * remove a function declaration which are added in a later patch
---
 net/mac80211/ieee80211_i.h |   24 +++++++
 net/mac80211/mlme.c        |  171 ++++----------------------------------------
 net/mac80211/spectmgmt.c   |  162 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 198 insertions(+), 159 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index b618651..63b7c9c 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1318,6 +1318,7 @@ void ieee80211_mgd_stop(struct ieee80211_sub_if_data *sdata);
 void ieee80211_mgd_conn_tx_status(struct ieee80211_sub_if_data *sdata,
 				  __le16 fc, bool acked);
 void ieee80211_sta_restart(struct ieee80211_sub_if_data *sdata);
+u32 chandef_downgrade(struct cfg80211_chan_def *c);
 
 /* IBSS code */
 void ieee80211_ibss_notify_scan_completed(struct ieee80211_local *local);
@@ -1481,6 +1482,29 @@ void ieee80211_apply_vhtcap_overrides(struct ieee80211_sub_if_data *sdata,
 void ieee80211_process_measurement_req(struct ieee80211_sub_if_data *sdata,
 				       struct ieee80211_mgmt *mgmt,
 				       size_t len);
+/**
+ * ieee80211_parse_ch_switch_ie - parses channel switch IEs
+ * @sdata: the sdata of the interface which has received the frame
+ * @elems: parsed 802.11 elements received with the frame
+ * @beacon: indicates if the frame was a beacon or probe response
+ * @current_band: indicates the current band
+ * @sta_flags: contains information about own capabilities and restrictions
+ *	to decide which channel switch announcements can be accepted. Only the
+ *	following subset of &enum ieee80211_sta_flags are evaluated:
+ *	%IEEE80211_STA_DISABLE_HT, %IEEE80211_STA_DISABLE_VHT,
+ *	%IEEE80211_STA_DISABLE_40MHZ, %IEEE80211_STA_DISABLE_80P80MHZ,
+ *	%IEEE80211_STA_DISABLE_160MHZ.
+ * @count: to be filled with the counter until the switch (on success only)
+ * @bssid: the currently connected bssid (for reporting)
+ * @mode: to be filled with CSA mode (on success only)
+ * @new_chandef: to be filled with destination chandef (on success only)
+ * Return: 0 on success, <0 on error and >0 if there is nothing to parse.
+ */
+int ieee80211_parse_ch_switch_ie(struct ieee80211_sub_if_data *sdata,
+				 struct ieee802_11_elems *elems, bool beacon,
+				 enum ieee80211_band current_band,
+				 u32 sta_flags, u8 *bssid, u8 *count, u8 *mode,
+				 struct cfg80211_chan_def *new_chandef);
 
 /* Suspend/resume and hw reconfiguration */
 int ieee80211_reconfig(struct ieee80211_local *local);
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 45a87ee..1d32413 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -143,7 +143,7 @@ static int ecw2cw(int ecw)
 	return (1 << ecw) - 1;
 }
 
-static u32 chandef_downgrade(struct cfg80211_chan_def *c)
+u32 chandef_downgrade(struct cfg80211_chan_def *c)
 {
 	u32 ret;
 	int tmp;
@@ -989,20 +989,12 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct cfg80211_bss *cbss = ifmgd->associated;
-	struct ieee80211_bss *bss;
 	struct ieee80211_chanctx *chanctx;
-	enum ieee80211_band new_band;
-	int new_freq;
-	u8 new_chan_no;
+	enum ieee80211_band current_band;
 	u8 count;
 	u8 mode;
-	struct ieee80211_channel *new_chan;
 	struct cfg80211_chan_def new_chandef = {};
-	struct cfg80211_chan_def new_vht_chandef = {};
-	const struct ieee80211_sec_chan_offs_ie *sec_chan_offs;
-	const struct ieee80211_wide_bw_chansw_ie *wide_bw_chansw_ie;
-	const struct ieee80211_ht_operation *ht_oper;
-	int secondary_channel_offset = -1;
+	int res;
 
 	sdata_assert_lock(sdata);
 
@@ -1016,162 +1008,23 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 	if (ifmgd->flags & IEEE80211_STA_CSA_RECEIVED)
 		return;
 
-	sec_chan_offs = elems->sec_chan_offs;
-	wide_bw_chansw_ie = elems->wide_bw_chansw_ie;
-	ht_oper = elems->ht_operation;
-
-	if (ifmgd->flags & (IEEE80211_STA_DISABLE_HT |
-			    IEEE80211_STA_DISABLE_40MHZ)) {
-		sec_chan_offs = NULL;
-		wide_bw_chansw_ie = NULL;
-		/* only used for bandwidth here */
-		ht_oper = NULL;
-	}
-
-	if (ifmgd->flags & IEEE80211_STA_DISABLE_VHT)
-		wide_bw_chansw_ie = NULL;
-
-	if (elems->ext_chansw_ie) {
-		if (!ieee80211_operating_class_to_band(
-				elems->ext_chansw_ie->new_operating_class,
-				&new_band)) {
-			sdata_info(sdata,
-				   "cannot understand ECSA IE operating class %d, disconnecting\n",
-				   elems->ext_chansw_ie->new_operating_class);
-			ieee80211_queue_work(&local->hw,
-					     &ifmgd->csa_connection_drop_work);
-		}
-		new_chan_no = elems->ext_chansw_ie->new_ch_num;
-		count = elems->ext_chansw_ie->count;
-		mode = elems->ext_chansw_ie->mode;
-	} else if (elems->ch_switch_ie) {
-		new_band = cbss->channel->band;
-		new_chan_no = elems->ch_switch_ie->new_ch_num;
-		count = elems->ch_switch_ie->count;
-		mode = elems->ch_switch_ie->mode;
-	} else {
-		/* nothing here we understand */
-		return;
-	}
-
-	bss = (void *)cbss->priv;
-
-	new_freq = ieee80211_channel_to_frequency(new_chan_no, new_band);
-	new_chan = ieee80211_get_channel(sdata->local->hw.wiphy, new_freq);
-	if (!new_chan || new_chan->flags & IEEE80211_CHAN_DISABLED) {
-		sdata_info(sdata,
-			   "AP %pM switches to unsupported channel (%d MHz), disconnecting\n",
-			   ifmgd->associated->bssid, new_freq);
+	current_band = cbss->channel->band;
+	res = ieee80211_parse_ch_switch_ie(sdata, elems, beacon, current_band,
+					   ifmgd->flags,
+					   ifmgd->associated->bssid, &count,
+					   &mode, &new_chandef);
+	if (res	< 0)
 		ieee80211_queue_work(&local->hw,
 				     &ifmgd->csa_connection_drop_work);
+	if (res)
 		return;
-	}
-
-	if (!beacon && sec_chan_offs) {
-		secondary_channel_offset = sec_chan_offs->sec_chan_offs;
-	} else if (beacon && ht_oper) {
-		secondary_channel_offset =
-			ht_oper->ht_param & IEEE80211_HT_PARAM_CHA_SEC_OFFSET;
-	} else if (!(ifmgd->flags & IEEE80211_STA_DISABLE_HT)) {
-		/*
-		 * If it's not a beacon, HT is enabled and the IE not present,
-		 * it's 20 MHz, 802.11-2012 8.5.2.6:
-		 *	This element [the Secondary Channel Offset Element] is
-		 *	present when switching to a 40 MHz channel. It may be
-		 *	present when switching to a 20 MHz channel (in which
-		 *	case the secondary channel offset is set to SCN).
-		 */
-		secondary_channel_offset = IEEE80211_HT_PARAM_CHA_SEC_NONE;
-	}
-
-	switch (secondary_channel_offset) {
-	default:
-		/* secondary_channel_offset was present but is invalid */
-	case IEEE80211_HT_PARAM_CHA_SEC_NONE:
-		cfg80211_chandef_create(&new_chandef, new_chan,
-					NL80211_CHAN_HT20);
-		break;
-	case IEEE80211_HT_PARAM_CHA_SEC_ABOVE:
-		cfg80211_chandef_create(&new_chandef, new_chan,
-					NL80211_CHAN_HT40PLUS);
-		break;
-	case IEEE80211_HT_PARAM_CHA_SEC_BELOW:
-		cfg80211_chandef_create(&new_chandef, new_chan,
-					NL80211_CHAN_HT40MINUS);
-		break;
-	case -1:
-		cfg80211_chandef_create(&new_chandef, new_chan,
-					NL80211_CHAN_NO_HT);
-		/* keep width for 5/10 MHz channels */
-		switch (sdata->vif.bss_conf.chandef.width) {
-		case NL80211_CHAN_WIDTH_5:
-		case NL80211_CHAN_WIDTH_10:
-			new_chandef.width = sdata->vif.bss_conf.chandef.width;
-			break;
-		default:
-			break;
-		}
-		break;
-	}
-
-	if (wide_bw_chansw_ie) {
-		new_vht_chandef.chan = new_chan;
-		new_vht_chandef.center_freq1 =
-			ieee80211_channel_to_frequency(
-				wide_bw_chansw_ie->new_center_freq_seg0,
-				new_band);
-
-		switch (wide_bw_chansw_ie->new_channel_width) {
-		default:
-			/* hmmm, ignore VHT and use HT if present */
-		case IEEE80211_VHT_CHANWIDTH_USE_HT:
-			new_vht_chandef.chan = NULL;
-			break;
-		case IEEE80211_VHT_CHANWIDTH_80MHZ:
-			new_vht_chandef.width = NL80211_CHAN_WIDTH_80;
-			break;
-		case IEEE80211_VHT_CHANWIDTH_160MHZ:
-			new_vht_chandef.width = NL80211_CHAN_WIDTH_160;
-			break;
-		case IEEE80211_VHT_CHANWIDTH_80P80MHZ:
-			/* field is otherwise reserved */
-			new_vht_chandef.center_freq2 =
-				ieee80211_channel_to_frequency(
-					wide_bw_chansw_ie->new_center_freq_seg1,
-					new_band);
-			new_vht_chandef.width = NL80211_CHAN_WIDTH_80P80;
-			break;
-		}
-		if (ifmgd->flags & IEEE80211_STA_DISABLE_80P80MHZ &&
-		    new_vht_chandef.width == NL80211_CHAN_WIDTH_80P80)
-			chandef_downgrade(&new_vht_chandef);
-		if (ifmgd->flags & IEEE80211_STA_DISABLE_160MHZ &&
-		    new_vht_chandef.width == NL80211_CHAN_WIDTH_160)
-			chandef_downgrade(&new_vht_chandef);
-		if (ifmgd->flags & IEEE80211_STA_DISABLE_40MHZ &&
-		    new_vht_chandef.width > NL80211_CHAN_WIDTH_20)
-			chandef_downgrade(&new_vht_chandef);
-	}
-
-	/* if VHT data is there validate & use it */
-	if (new_vht_chandef.chan) {
-		if (!cfg80211_chandef_compatible(&new_vht_chandef,
-						 &new_chandef)) {
-			sdata_info(sdata,
-				   "AP %pM CSA has inconsistent channel data, disconnecting\n",
-				   ifmgd->associated->bssid);
-			ieee80211_queue_work(&local->hw,
-					     &ifmgd->csa_connection_drop_work);
-			return;
-		}
-		new_chandef = new_vht_chandef;
-	}
 
 	if (!cfg80211_chandef_usable(local->hw.wiphy, &new_chandef,
 				     IEEE80211_CHAN_DISABLED)) {
 		sdata_info(sdata,
 			   "AP %pM switches to unsupported channel (%d MHz, width:%d, CF1/2: %d/%d MHz), disconnecting\n",
-			   ifmgd->associated->bssid, new_freq,
+			   ifmgd->associated->bssid,
+			   new_chandef.chan->center_freq,
 			   new_chandef.width, new_chandef.center_freq1,
 			   new_chandef.center_freq2);
 		ieee80211_queue_work(&local->hw,
diff --git a/net/mac80211/spectmgmt.c b/net/mac80211/spectmgmt.c
index 578eea3..4f2c873 100644
--- a/net/mac80211/spectmgmt.c
+++ b/net/mac80211/spectmgmt.c
@@ -21,6 +21,168 @@
 #include "sta_info.h"
 #include "wme.h"
 
+int ieee80211_parse_ch_switch_ie(struct ieee80211_sub_if_data *sdata,
+				 struct ieee802_11_elems *elems, bool beacon,
+				 enum ieee80211_band current_band,
+				 u32 sta_flags, u8 *bssid, u8 *count, u8 *mode,
+				 struct cfg80211_chan_def *new_chandef)
+{
+	enum ieee80211_band new_band;
+	int new_freq;
+	u8 new_chan_no;
+	struct ieee80211_channel *new_chan;
+	struct cfg80211_chan_def new_vht_chandef = {};
+	const struct ieee80211_sec_chan_offs_ie *sec_chan_offs;
+	const struct ieee80211_wide_bw_chansw_ie *wide_bw_chansw_ie;
+	const struct ieee80211_ht_operation *ht_oper;
+	int secondary_channel_offset = -1;
+
+	sec_chan_offs = elems->sec_chan_offs;
+	wide_bw_chansw_ie = elems->wide_bw_chansw_ie;
+	ht_oper = elems->ht_operation;
+
+	if (sta_flags & (IEEE80211_STA_DISABLE_HT |
+			 IEEE80211_STA_DISABLE_40MHZ)) {
+		sec_chan_offs = NULL;
+		wide_bw_chansw_ie = NULL;
+		/* only used for bandwidth here */
+		ht_oper = NULL;
+	}
+
+	if (sta_flags & IEEE80211_STA_DISABLE_VHT)
+		wide_bw_chansw_ie = NULL;
+
+	if (elems->ext_chansw_ie) {
+		if (!ieee80211_operating_class_to_band(
+				elems->ext_chansw_ie->new_operating_class,
+				&new_band)) {
+			sdata_info(sdata,
+				   "cannot understand ECSA IE operating class %d, disconnecting\n",
+				   elems->ext_chansw_ie->new_operating_class);
+			return -EINVAL;
+		}
+		new_chan_no = elems->ext_chansw_ie->new_ch_num;
+		*count = elems->ext_chansw_ie->count;
+		*mode = elems->ext_chansw_ie->mode;
+	} else if (elems->ch_switch_ie) {
+		new_band = current_band;
+		new_chan_no = elems->ch_switch_ie->new_ch_num;
+		*count = elems->ch_switch_ie->count;
+		*mode = elems->ch_switch_ie->mode;
+	} else {
+		/* nothing here we understand */
+		return 1;
+	}
+
+	new_freq = ieee80211_channel_to_frequency(new_chan_no, new_band);
+	new_chan = ieee80211_get_channel(sdata->local->hw.wiphy, new_freq);
+	if (!new_chan || new_chan->flags & IEEE80211_CHAN_DISABLED) {
+		sdata_info(sdata,
+			   "BSS %pM switches to unsupported channel (%d MHz), disconnecting\n",
+			   bssid, new_freq);
+		return -EINVAL;
+	}
+
+	if (!beacon && sec_chan_offs) {
+		secondary_channel_offset = sec_chan_offs->sec_chan_offs;
+	} else if (beacon && ht_oper) {
+		secondary_channel_offset =
+			ht_oper->ht_param & IEEE80211_HT_PARAM_CHA_SEC_OFFSET;
+	} else if (!(sta_flags & IEEE80211_STA_DISABLE_HT)) {
+		/* If it's not a beacon, HT is enabled and the IE not present,
+		 * it's 20 MHz, 802.11-2012 8.5.2.6:
+		 *	This element [the Secondary Channel Offset Element] is
+		 *	present when switching to a 40 MHz channel. It may be
+		 *	present when switching to a 20 MHz channel (in which
+		 *	case the secondary channel offset is set to SCN).
+		 */
+		secondary_channel_offset = IEEE80211_HT_PARAM_CHA_SEC_NONE;
+	}
+
+	switch (secondary_channel_offset) {
+	default:
+		/* secondary_channel_offset was present but is invalid */
+	case IEEE80211_HT_PARAM_CHA_SEC_NONE:
+		cfg80211_chandef_create(new_chandef, new_chan,
+					NL80211_CHAN_HT20);
+		break;
+	case IEEE80211_HT_PARAM_CHA_SEC_ABOVE:
+		cfg80211_chandef_create(new_chandef, new_chan,
+					NL80211_CHAN_HT40PLUS);
+		break;
+	case IEEE80211_HT_PARAM_CHA_SEC_BELOW:
+		cfg80211_chandef_create(new_chandef, new_chan,
+					NL80211_CHAN_HT40MINUS);
+		break;
+	case -1:
+		cfg80211_chandef_create(new_chandef, new_chan,
+					NL80211_CHAN_NO_HT);
+		/* keep width for 5/10 MHz channels */
+		switch (sdata->vif.bss_conf.chandef.width) {
+		case NL80211_CHAN_WIDTH_5:
+		case NL80211_CHAN_WIDTH_10:
+			new_chandef->width = sdata->vif.bss_conf.chandef.width;
+			break;
+		default:
+			break;
+		}
+		break;
+	}
+
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
+		if (sta_flags & IEEE80211_STA_DISABLE_80P80MHZ &&
+		    new_vht_chandef.width == NL80211_CHAN_WIDTH_80P80)
+			chandef_downgrade(&new_vht_chandef);
+		if (sta_flags & IEEE80211_STA_DISABLE_160MHZ &&
+		    new_vht_chandef.width == NL80211_CHAN_WIDTH_160)
+			chandef_downgrade(&new_vht_chandef);
+		if (sta_flags & IEEE80211_STA_DISABLE_40MHZ &&
+		    new_vht_chandef.width > NL80211_CHAN_WIDTH_20)
+			chandef_downgrade(&new_vht_chandef);
+	}
+
+	/* if VHT data is there validate & use it */
+	if (new_vht_chandef.chan) {
+		if (!cfg80211_chandef_compatible(&new_vht_chandef,
+						 new_chandef)) {
+			sdata_info(sdata,
+				   "BSS %pM: CSA has inconsistent channel data, disconnecting\n",
+				   bssid);
+			return -EINVAL;
+		}
+		*new_chandef = new_vht_chandef;
+	}
+
+	return 0;
+}
+
 static void ieee80211_send_refuse_measurement_request(struct ieee80211_sub_if_data *sdata,
 					struct ieee80211_msrment_ie *request_ie,
 					const u8 *da, const u8 *bssid,
-- 
1.7.10.4

