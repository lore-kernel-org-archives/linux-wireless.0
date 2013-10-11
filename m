Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:52768 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754780Ab3JKSaH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Oct 2013 14:30:07 -0400
Received: by mail-pa0-f44.google.com with SMTP id lf10so4775650pab.3
        for <linux-wireless@vger.kernel.org>; Fri, 11 Oct 2013 11:30:07 -0700 (PDT)
From: Chun-Yeow Yeoh <yeohchunyeow@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, linville@tuxdriver.com,
	devel@lists.open80211s.org, distro11s@cozybit.com,
	Chun-Yeow Yeoh <yeohchunyeow@cozybit.com>
Subject: [PATCH v4 4/6] mac80211: refactor the parsing of chan switch ie
Date: Fri, 11 Oct 2013 11:29:48 -0700
Message-Id: <1381516190-23918-5-git-send-email-yeohchunyeow@cozybit.com> (sfid-20131011_203023_347843_D3C28D34)
In-Reply-To: <1381516190-23918-1-git-send-email-yeohchunyeow@cozybit.com>
References: <1381516190-23918-1-git-send-email-yeohchunyeow@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Refactor the channel switch IE parsing to reduce the number
of function parameters.

Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@cozybit.com>
---
v3: refactor ieee80211_parse_ch_switch_ie to have less function
    parameters (Johannes Berg)

 net/mac80211/ibss.c        |   13 +++++++------
 net/mac80211/ieee80211_i.h |   17 ++++++++++++-----
 net/mac80211/mlme.c        |   32 +++++++++++++++-----------------
 net/mac80211/spectmgmt.c   |   27 ++++++++++++++-------------
 4 files changed, 48 insertions(+), 41 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 017e206..d6b80ef 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -730,13 +730,13 @@ ieee80211_ibss_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 				  bool beacon)
 {
 	struct cfg80211_csa_settings params;
+	struct ieee80211_csa_ie csa_ie;
 	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
 	struct ieee80211_chanctx_conf *chanctx_conf;
 	struct ieee80211_chanctx *chanctx;
 	enum nl80211_channel_type ch_type;
 	int err, num_chanctx;
 	u32 sta_flags;
-	u8 mode;
 
 	if (sdata->vif.csa_active)
 		return true;
@@ -759,12 +759,10 @@ ieee80211_ibss_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 	}
 
 	memset(&params, 0, sizeof(params));
+	memset(&csa_ie, 0, sizeof(csa_ie));
 	err = ieee80211_parse_ch_switch_ie(sdata, elems, beacon,
 					   ifibss->chandef.chan->band,
-					   sta_flags, ifibss->bssid,
-					   &params.count, &mode,
-					   &params.chandef);
-
+					   sta_flags, ifibss->bssid, &csa_ie);
 	/* can't switch to destination channel, fail */
 	if (err < 0)
 		goto disconnect;
@@ -773,6 +771,9 @@ ieee80211_ibss_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 	if (err)
 		return false;
 
+	params.count = csa_ie.count;
+	params.chandef = csa_ie.chandef;
+
 	if (ifibss->chandef.chan->band != params.chandef.chan->band)
 		goto disconnect;
 
@@ -859,7 +860,7 @@ ieee80211_ibss_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 		 "received channel switch announcement to go to channel %d MHz\n",
 		 params.chandef.chan->center_freq);
 
-	params.block_tx = !!mode;
+	params.block_tx = !!csa_ie.mode;
 
 	ieee80211_ibss_csa_beacon(sdata, &params);
 	sdata->csa_radar_required = params.radar_required;
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index f10907f..963a592 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1208,6 +1208,14 @@ struct ieee80211_ra_tid {
 	u16 tid;
 };
 
+/* this struct holds the value parsing from channel switch IE  */
+struct ieee80211_csa_ie {
+	struct cfg80211_chan_def chandef;
+	u8 mode;
+	u8 count;
+	u8 ttl;
+};
+
 /* Parsed Information Elements */
 struct ieee802_11_elems {
 	const u8 *ie_start;
@@ -1503,17 +1511,16 @@ void ieee80211_process_measurement_req(struct ieee80211_sub_if_data *sdata,
  *	%IEEE80211_STA_DISABLE_HT, %IEEE80211_STA_DISABLE_VHT,
  *	%IEEE80211_STA_DISABLE_40MHZ, %IEEE80211_STA_DISABLE_80P80MHZ,
  *	%IEEE80211_STA_DISABLE_160MHZ.
- * @count: to be filled with the counter until the switch (on success only)
  * @bssid: the currently connected bssid (for reporting)
- * @mode: to be filled with CSA mode (on success only)
- * @new_chandef: to be filled with destination chandef (on success only)
+ * @csa_ie: parsed 802.11 csa elements on count, mode, chandef and mesh ttl.
+	All of them will be filled with if success only.
  * Return: 0 on success, <0 on error and >0 if there is nothing to parse.
  */
 int ieee80211_parse_ch_switch_ie(struct ieee80211_sub_if_data *sdata,
 				 struct ieee802_11_elems *elems, bool beacon,
 				 enum ieee80211_band current_band,
-				 u32 sta_flags, u8 *bssid, u8 *count, u8 *mode,
-				 struct cfg80211_chan_def *new_chandef);
+				 u32 sta_flags, u8 *bssid,
+				 struct ieee80211_csa_ie *csa_ie);
 
 /* Suspend/resume and hw reconfiguration */
 int ieee80211_reconfig(struct ieee80211_local *local);
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 9fce0f4..16e4238 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -941,9 +941,7 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 	struct cfg80211_bss *cbss = ifmgd->associated;
 	struct ieee80211_chanctx *chanctx;
 	enum ieee80211_band current_band;
-	u8 count;
-	u8 mode;
-	struct cfg80211_chan_def new_chandef = {};
+	struct ieee80211_csa_ie csa_ie;
 	int res;
 
 	sdata_assert_lock(sdata);
@@ -959,24 +957,24 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 		return;
 
 	current_band = cbss->channel->band;
+	memset(&csa_ie, 0, sizeof(csa_ie));
 	res = ieee80211_parse_ch_switch_ie(sdata, elems, beacon, current_band,
 					   ifmgd->flags,
-					   ifmgd->associated->bssid, &count,
-					   &mode, &new_chandef);
+					   ifmgd->associated->bssid, &csa_ie);
 	if (res	< 0)
 		ieee80211_queue_work(&local->hw,
 				     &ifmgd->csa_connection_drop_work);
 	if (res)
 		return;
 
-	if (!cfg80211_chandef_usable(local->hw.wiphy, &new_chandef,
+	if (!cfg80211_chandef_usable(local->hw.wiphy, &csa_ie.chandef,
 				     IEEE80211_CHAN_DISABLED)) {
 		sdata_info(sdata,
 			   "AP %pM switches to unsupported channel (%d MHz, width:%d, CF1/2: %d/%d MHz), disconnecting\n",
 			   ifmgd->associated->bssid,
-			   new_chandef.chan->center_freq,
-			   new_chandef.width, new_chandef.center_freq1,
-			   new_chandef.center_freq2);
+			   csa_ie.chandef.chan->center_freq,
+			   csa_ie.chandef.width, csa_ie.chandef.center_freq1,
+			   csa_ie.chandef.center_freq2);
 		ieee80211_queue_work(&local->hw,
 				     &ifmgd->csa_connection_drop_work);
 		return;
@@ -1009,9 +1007,9 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 	}
 	mutex_unlock(&local->chanctx_mtx);
 
-	local->csa_chandef = new_chandef;
+	local->csa_chandef = csa_ie.chandef;
 
-	if (mode)
+	if (csa_ie.mode)
 		ieee80211_stop_queues_by_reason(&local->hw,
 				IEEE80211_MAX_QUEUE_MAP,
 				IEEE80211_QUEUE_STOP_REASON_CSA);
@@ -1020,9 +1018,9 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 		/* use driver's channel switch callback */
 		struct ieee80211_channel_switch ch_switch = {
 			.timestamp = timestamp,
-			.block_tx = mode,
-			.chandef = new_chandef,
-			.count = count,
+			.block_tx = csa_ie.mode,
+			.chandef = csa_ie.chandef,
+			.count = csa_ie.count,
 		};
 
 		drv_channel_switch(local, &ch_switch);
@@ -1030,11 +1028,11 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 	}
 
 	/* channel switch handled in software */
-	if (count <= 1)
+	if (csa_ie.count <= 1)
 		ieee80211_queue_work(&local->hw, &ifmgd->chswitch_work);
 	else
 		mod_timer(&ifmgd->chswitch_timer,
-			  TU_TO_EXP_TIME(count * cbss->beacon_interval));
+			  TU_TO_EXP_TIME(csa_ie.count * cbss->beacon_interval));
 }
 
 static u32 ieee80211_handle_pwr_constr(struct ieee80211_sub_if_data *sdata,
@@ -3965,7 +3963,7 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 	}
 
 	/* prepare assoc data */
-	
+
 	ifmgd->beacon_crc_valid = false;
 
 	/*
diff --git a/net/mac80211/spectmgmt.c b/net/mac80211/spectmgmt.c
index 921597e..a298e12 100644
--- a/net/mac80211/spectmgmt.c
+++ b/net/mac80211/spectmgmt.c
@@ -24,8 +24,8 @@
 int ieee80211_parse_ch_switch_ie(struct ieee80211_sub_if_data *sdata,
 				 struct ieee802_11_elems *elems, bool beacon,
 				 enum ieee80211_band current_band,
-				 u32 sta_flags, u8 *bssid, u8 *count, u8 *mode,
-				 struct cfg80211_chan_def *new_chandef)
+				 u32 sta_flags, u8 *bssid,
+				 struct ieee80211_csa_ie *csa_ie)
 {
 	enum ieee80211_band new_band;
 	int new_freq;
@@ -62,13 +62,13 @@ int ieee80211_parse_ch_switch_ie(struct ieee80211_sub_if_data *sdata,
 			return -EINVAL;
 		}
 		new_chan_no = elems->ext_chansw_ie->new_ch_num;
-		*count = elems->ext_chansw_ie->count;
-		*mode = elems->ext_chansw_ie->mode;
+		csa_ie->count = elems->ext_chansw_ie->count;
+		csa_ie->mode = elems->ext_chansw_ie->mode;
 	} else if (elems->ch_switch_ie) {
 		new_band = current_band;
 		new_chan_no = elems->ch_switch_ie->new_ch_num;
-		*count = elems->ch_switch_ie->count;
-		*mode = elems->ch_switch_ie->mode;
+		csa_ie->count = elems->ch_switch_ie->count;
+		csa_ie->mode = elems->ch_switch_ie->mode;
 	} else {
 		/* nothing here we understand */
 		return 1;
@@ -103,25 +103,26 @@ int ieee80211_parse_ch_switch_ie(struct ieee80211_sub_if_data *sdata,
 	default:
 		/* secondary_channel_offset was present but is invalid */
 	case IEEE80211_HT_PARAM_CHA_SEC_NONE:
-		cfg80211_chandef_create(new_chandef, new_chan,
+		cfg80211_chandef_create(&csa_ie->chandef, new_chan,
 					NL80211_CHAN_HT20);
 		break;
 	case IEEE80211_HT_PARAM_CHA_SEC_ABOVE:
-		cfg80211_chandef_create(new_chandef, new_chan,
+		cfg80211_chandef_create(&csa_ie->chandef, new_chan,
 					NL80211_CHAN_HT40PLUS);
 		break;
 	case IEEE80211_HT_PARAM_CHA_SEC_BELOW:
-		cfg80211_chandef_create(new_chandef, new_chan,
+		cfg80211_chandef_create(&csa_ie->chandef, new_chan,
 					NL80211_CHAN_HT40MINUS);
 		break;
 	case -1:
-		cfg80211_chandef_create(new_chandef, new_chan,
+		cfg80211_chandef_create(&csa_ie->chandef, new_chan,
 					NL80211_CHAN_NO_HT);
 		/* keep width for 5/10 MHz channels */
 		switch (sdata->vif.bss_conf.chandef.width) {
 		case NL80211_CHAN_WIDTH_5:
 		case NL80211_CHAN_WIDTH_10:
-			new_chandef->width = sdata->vif.bss_conf.chandef.width;
+			csa_ie->chandef.width =
+				sdata->vif.bss_conf.chandef.width;
 			break;
 		default:
 			break;
@@ -171,13 +172,13 @@ int ieee80211_parse_ch_switch_ie(struct ieee80211_sub_if_data *sdata,
 	/* if VHT data is there validate & use it */
 	if (new_vht_chandef.chan) {
 		if (!cfg80211_chandef_compatible(&new_vht_chandef,
-						 new_chandef)) {
+						 &csa_ie->chandef)) {
 			sdata_info(sdata,
 				   "BSS %pM: CSA has inconsistent channel data, disconnecting\n",
 				   bssid);
 			return -EINVAL;
 		}
-		*new_chandef = new_vht_chandef;
+		csa_ie->chandef = new_vht_chandef;
 	}
 
 	return 0;
-- 
1.7.9.5

