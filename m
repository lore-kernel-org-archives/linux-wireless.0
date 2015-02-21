Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f171.google.com ([209.85.217.171]:38579 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323AbbBUPxE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Feb 2015 10:53:04 -0500
Received: by lbiz11 with SMTP id z11so11527511lbi.5
        for <linux-wireless@vger.kernel.org>; Sat, 21 Feb 2015 07:53:02 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH 3/3] mac80211: add VHT support for IBSS
Date: Sat, 21 Feb 2015 16:52:41 +0100
Message-Id: <1424533961-3869-3-git-send-email-janusz.dziedzic@tieto.com> (sfid-20150221_165312_828717_BDF3981A)
In-Reply-To: <1424533961-3869-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1424533961-3869-1-git-send-email-janusz.dziedzic@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add VHT80/VHT160 support for IBSS.
Drivers could activate this feature by
setting NL80211_EXT_FEATURE_VHT_IBSS flag.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 net/mac80211/ht.c          |  2 --
 net/mac80211/ibss.c        | 62 ++++++++++++++++++++++++++++++++--------
 net/mac80211/ieee80211_i.h |  5 ++++
 net/mac80211/mesh_plink.c  |  4 +++
 net/mac80211/util.c        | 70 ++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 129 insertions(+), 14 deletions(-)

diff --git a/net/mac80211/ht.c b/net/mac80211/ht.c
index ff630be..7a76ce6 100644
--- a/net/mac80211/ht.c
+++ b/net/mac80211/ht.c
@@ -252,8 +252,6 @@ bool ieee80211_ht_cap_ie_to_sta_ht_cap(struct ieee80211_sub_if_data *sdata,
 		break;
 	}
 
-	if (bw != sta->sta.bandwidth)
-		changed = true;
 	sta->sta.bandwidth = bw;
 
 	sta->cur_max_bandwidth =
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 14acc21..cf8c05c 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -188,6 +188,15 @@ ieee80211_ibss_build_presp(struct ieee80211_sub_if_data *sdata,
 		 */
 		pos = ieee80211_ie_build_ht_oper(pos, &sband->ht_cap,
 						 chandef, 0);
+
+		if (chandef->width != NL80211_CHAN_WIDTH_20 &&
+		    chandef->width != NL80211_CHAN_WIDTH_40 &&
+		    sband->vht_cap.vht_supported) {
+			pos = ieee80211_ie_build_vht_cap(pos, &sband->vht_cap,
+							 sband->vht_cap.cap);
+			pos = ieee80211_ie_build_vht_oper(pos, &sband->vht_cap,
+							  chandef);
+		}
 	}
 
 	if (local->hw.queues >= IEEE80211_NUM_ACS)
@@ -411,6 +420,11 @@ static void ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 		chan_type = cfg80211_get_chandef_type(&sdata->u.ibss.chandef);
 		cfg80211_chandef_create(&chandef, cbss->channel, chan_type);
 		break;
+	case NL80211_CHAN_WIDTH_80:
+	case NL80211_CHAN_WIDTH_160:
+		chandef = sdata->u.ibss.chandef;
+		chandef.chan = cbss->channel;
+		break;
 	case NL80211_CHAN_WIDTH_5:
 	case NL80211_CHAN_WIDTH_10:
 		cfg80211_chandef_create(&chandef, cbss->channel,
@@ -995,6 +1009,7 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 	enum ieee80211_band band = rx_status->band;
 	enum nl80211_bss_scan_width scan_width;
 	struct ieee80211_supported_band *sband = local->hw.wiphy->bands[band];
+	enum nl80211_chan_width width = sdata->u.ibss.chandef.width;
 	bool rates_updated = false;
 
 	channel = ieee80211_get_channel(local->hw.wiphy, rx_status->freq);
@@ -1042,12 +1057,16 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 			sta->sta.wme = true;
 
 		if (sta && elems->ht_operation && elems->ht_cap_elem &&
-		    sdata->u.ibss.chandef.width != NL80211_CHAN_WIDTH_20_NOHT &&
-		    sdata->u.ibss.chandef.width != NL80211_CHAN_WIDTH_5 &&
-		    sdata->u.ibss.chandef.width != NL80211_CHAN_WIDTH_10) {
+		    width != NL80211_CHAN_WIDTH_20_NOHT &&
+		    width != NL80211_CHAN_WIDTH_5 &&
+		    width != NL80211_CHAN_WIDTH_10) {
 			/* we both use HT */
 			struct ieee80211_ht_cap htcap_ie;
 			struct cfg80211_chan_def chandef;
+			struct ieee80211_vht_cap vhtcap_ie;
+			struct ieee80211_sta_vht_cap vht_cap;
+			const struct ieee80211_vht_operation *vht_oper;
+			enum ieee80211_sta_rx_bandwidth bw = sta->sta.bandwidth;
 
 			ieee80211_ht_oper_to_chandef(channel,
 						     elems->ht_operation,
@@ -1055,17 +1074,36 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 
 			memcpy(&htcap_ie, elems->ht_cap_elem, sizeof(htcap_ie));
 
-			/*
-			 * fall back to HT20 if we don't use or use
-			 * the other extension channel
-			 */
-			if (chandef.center_freq1 !=
-			    sdata->u.ibss.chandef.center_freq1)
-				htcap_ie.cap_info &=
-					cpu_to_le16(~IEEE80211_HT_CAP_SUP_WIDTH_20_40);
-
 			rates_updated |= ieee80211_ht_cap_ie_to_sta_ht_cap(
 						sdata, sband, &htcap_ie, sta);
+
+			if (elems->vht_operation && elems->vht_cap_elem &&
+			    width != NL80211_CHAN_WIDTH_20 &&
+			    width != NL80211_CHAN_WIDTH_40) {
+				/* we both use VHT */
+				vht_cap = sta->sta.vht_cap;
+				vht_oper = elems->vht_operation;
+
+				ieee80211_vht_oper_to_chandef(channel, vht_oper,
+							      &chandef);
+				memcpy(&vhtcap_ie, elems->vht_cap_elem,
+				       sizeof(vhtcap_ie));
+				ieee80211_vht_cap_ie_to_sta_vht_cap(sdata,
+								    sband,
+								    &vhtcap_ie,
+								    sta);
+				if (memcmp(&vht_cap, &sta->sta.vht_cap,
+					   sizeof(vht_cap)))
+						rates_updated |= true;
+			}
+
+			if (bw != sta->sta.bandwidth)
+				rates_updated |= true;
+
+			if (!cfg80211_chandef_compatible(&sdata->u.ibss.chandef,
+							 &chandef))
+				/* TODO handle incompatible chandefs */
+				WARN_ON_ONCE(1);
 		}
 
 		if (sta && rates_updated) {
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index b1451b3..e71ed27 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1968,6 +1968,8 @@ u8 *ieee80211_ie_build_ht_oper(u8 *pos, struct ieee80211_sta_ht_cap *ht_cap,
 			       u16 prot_mode);
 u8 *ieee80211_ie_build_vht_cap(u8 *pos, struct ieee80211_sta_vht_cap *vht_cap,
 			       u32 cap);
+u8 *ieee80211_ie_build_vht_oper(u8 *pos, struct ieee80211_sta_vht_cap *vht_cap,
+				const struct cfg80211_chan_def *chandef);
 int ieee80211_parse_bitrates(struct cfg80211_chan_def *chandef,
 			     const struct ieee80211_supported_band *sband,
 			     const u8 *srates, int srates_len, u32 *rates);
@@ -1983,6 +1985,9 @@ u8 *ieee80211_add_wmm_info_ie(u8 *buf, u8 qosinfo);
 void ieee80211_ht_oper_to_chandef(struct ieee80211_channel *control_chan,
 				  const struct ieee80211_ht_operation *ht_oper,
 				  struct cfg80211_chan_def *chandef);
+void ieee80211_vht_oper_to_chandef(struct ieee80211_channel *control_chan,
+				   const struct ieee80211_vht_operation *oper,
+				   struct cfg80211_chan_def *chandef);
 u32 ieee80211_chandef_downgrade(struct cfg80211_chan_def *c);
 
 int __must_check
diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index b488e18..9875d82 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -382,6 +382,7 @@ static void mesh_sta_info_init(struct ieee80211_sub_if_data *sdata,
 	enum ieee80211_band band = ieee80211_get_sdata_band(sdata);
 	struct ieee80211_supported_band *sband;
 	u32 rates, basic_rates = 0, changed = 0;
+	enum ieee80211_sta_rx_bandwidth bw = sta->sta.bandwidth;
 
 	sband = local->hw.wiphy->bands[band];
 	rates = ieee80211_sta_get_rates(sdata, elems, band, &basic_rates);
@@ -401,6 +402,9 @@ static void mesh_sta_info_init(struct ieee80211_sub_if_data *sdata,
 					      elems->ht_cap_elem, sta))
 		changed |= IEEE80211_RC_BW_CHANGED;
 
+	if (bw != sta->sta.bandwidth)
+		changed |= IEEE80211_RC_BW_CHANGED;
+
 	/* HT peer is operating 20MHz-only */
 	if (elems->ht_operation &&
 	    !(elems->ht_operation->ht_param &
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 8428f4a..4522200 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -2344,6 +2344,43 @@ u8 *ieee80211_ie_build_ht_oper(u8 *pos, struct ieee80211_sta_ht_cap *ht_cap,
 	return pos + sizeof(struct ieee80211_ht_operation);
 }
 
+u8 *ieee80211_ie_build_vht_oper(u8 *pos, struct ieee80211_sta_vht_cap *vht_cap,
+				const struct cfg80211_chan_def *chandef)
+{
+	struct ieee80211_vht_operation *vht_oper;
+
+	/* Build VHT Operation */
+	*pos++ = WLAN_EID_VHT_OPERATION;
+	*pos++ = sizeof(struct ieee80211_vht_operation);
+
+	vht_oper = (struct ieee80211_vht_operation *)pos;
+
+	vht_oper->center_freq_seg1_idx =
+			ieee80211_frequency_to_channel(chandef->center_freq1);
+	vht_oper->center_freq_seg2_idx = 0;
+
+	/* 1 stream, MCS0-7 as a min Basic VHT MCS rates */
+	vht_oper->basic_mcs_set = cpu_to_le16(0xfffc);
+
+	switch (chandef->width) {
+	case NL80211_CHAN_WIDTH_80:
+		vht_oper->chan_width = IEEE80211_VHT_CHANWIDTH_80MHZ;
+		break;
+	case NL80211_CHAN_WIDTH_80P80:
+		vht_oper->chan_width = IEEE80211_VHT_CHANWIDTH_80P80MHZ;
+		vht_oper->center_freq_seg2_idx =
+			ieee80211_frequency_to_channel(chandef->center_freq2);
+		break;
+	case NL80211_CHAN_WIDTH_160:
+		vht_oper->chan_width = IEEE80211_VHT_CHANWIDTH_160MHZ;
+		break;
+	default:
+		return pos;
+	}
+
+	return pos + sizeof(struct ieee80211_vht_operation);
+}
+
 void ieee80211_ht_oper_to_chandef(struct ieee80211_channel *control_chan,
 				  const struct ieee80211_ht_operation *ht_oper,
 				  struct cfg80211_chan_def *chandef)
@@ -2373,6 +2410,39 @@ void ieee80211_ht_oper_to_chandef(struct ieee80211_channel *control_chan,
 	cfg80211_chandef_create(chandef, control_chan, channel_type);
 }
 
+void ieee80211_vht_oper_to_chandef(struct ieee80211_channel *control_chan,
+				   const struct ieee80211_vht_operation *oper,
+				   struct cfg80211_chan_def *chandef)
+{
+	if (!oper)
+		return;
+
+	chandef->chan = control_chan;
+
+	switch (oper->chan_width) {
+	case IEEE80211_VHT_CHANWIDTH_USE_HT:
+		break;
+	case IEEE80211_VHT_CHANWIDTH_80MHZ:
+		chandef->width = NL80211_CHAN_WIDTH_80;
+		break;
+	case IEEE80211_VHT_CHANWIDTH_160MHZ:
+		chandef->width = NL80211_CHAN_WIDTH_160;
+		break;
+	case IEEE80211_VHT_CHANWIDTH_80P80MHZ:
+		chandef->width = NL80211_CHAN_WIDTH_80P80;
+		break;
+	default:
+		break;
+	}
+
+	chandef->center_freq1 =
+		ieee80211_channel_to_frequency(oper->center_freq_seg1_idx,
+					       control_chan->band);
+	chandef->center_freq2 =
+		ieee80211_channel_to_frequency(oper->center_freq_seg2_idx,
+					       control_chan->band);
+}
+
 int ieee80211_parse_bitrates(struct cfg80211_chan_def *chandef,
 			     const struct ieee80211_supported_band *sband,
 			     const u8 *srates, int srates_len, u32 *rates)
-- 
1.9.1

