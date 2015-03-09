Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f179.google.com ([209.85.217.179]:40429 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520AbbCIG7K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Mar 2015 02:59:10 -0400
Received: by lbiw7 with SMTP id w7so29606641lbi.7
        for <linux-wireless@vger.kernel.org>; Sun, 08 Mar 2015 23:59:08 -0700 (PDT)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCHv2 3/3] mac80211: add VHT support for IBSS
Date: Mon,  9 Mar 2015 07:58:16 +0100
Message-Id: <1425884296-7074-3-git-send-email-janusz.dziedzic@tieto.com> (sfid-20150309_075921_929330_E8740CBD)
In-Reply-To: <1425884296-7074-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1425884296-7074-1-git-send-email-janusz.dziedzic@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add VHT support for IBSS. Drivers could activate
this feature by setting NL80211_EXT_FEATURE_VHT_IBSS
flag.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 net/mac80211/ht.c          |  2 --
 net/mac80211/ibss.c        | 50 +++++++++++++++++++++++++++++++++++++---------
 net/mac80211/ieee80211_i.h |  3 +++
 net/mac80211/mesh_plink.c  |  4 ++++
 net/mac80211/util.c        | 33 ++++++++++++++++++++++++++++++
 5 files changed, 81 insertions(+), 11 deletions(-)

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
index 4299973..f415fff 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -188,6 +188,16 @@ ieee80211_ibss_build_presp(struct ieee80211_sub_if_data *sdata,
 		 */
 		pos = ieee80211_ie_build_ht_oper(pos, &sband->ht_cap,
 						 chandef, 0);
+
+		/* add VHT capability and information IEs */
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
@@ -417,6 +427,11 @@ static void ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 					NL80211_CHAN_WIDTH_20_NOHT);
 		chandef.width = sdata->u.ibss.chandef.width;
 		break;
+	case NL80211_CHAN_WIDTH_80:
+	case NL80211_CHAN_WIDTH_160:
+		chandef = sdata->u.ibss.chandef;
+		chandef.chan = cbss->channel;
+		break;
 	default:
 		/* fall back to 20 MHz for unsupported modes */
 		cfg80211_chandef_create(&chandef, cbss->channel,
@@ -1028,24 +1043,41 @@ static void ieee80211_update_sta_info(struct ieee80211_sub_if_data *sdata,
 		/* we both use HT */
 		struct ieee80211_ht_cap htcap_ie;
 		struct cfg80211_chan_def chandef;
+		enum ieee80211_sta_rx_bandwidth bw = sta->sta.bandwidth;
 
 		ieee80211_ht_oper_to_chandef(channel,
 					     elems->ht_operation,
 					     &chandef);
 
 		memcpy(&htcap_ie, elems->ht_cap_elem, sizeof(htcap_ie));
-
-		/*
-		 * fall back to HT20 if we don't use or use
-		 * the other extension channel
-		 */
-		if (chandef.center_freq1 != sdata->u.ibss.chandef.center_freq1)
-			htcap_ie.cap_info &=
-				cpu_to_le16(~IEEE80211_HT_CAP_SUP_WIDTH_20_40);
-
 		rates_updated |= ieee80211_ht_cap_ie_to_sta_ht_cap(sdata, sband,
 								   &htcap_ie,
 								   sta);
+
+		if (elems->vht_operation && elems->vht_cap_elem &&
+		    sdata->u.ibss.chandef.width != NL80211_CHAN_WIDTH_20 &&
+		    sdata->u.ibss.chandef.width != NL80211_CHAN_WIDTH_40) {
+			/* we both use VHT */
+			struct ieee80211_vht_cap cap_ie;
+			struct ieee80211_sta_vht_cap cap = sta->sta.vht_cap;
+
+			ieee80211_vht_oper_to_chandef(channel,
+						      elems->vht_operation,
+						      &chandef);
+			memcpy(&cap_ie, elems->vht_cap_elem, sizeof(cap_ie));
+			ieee80211_vht_cap_ie_to_sta_vht_cap(sdata, sband,
+							    &cap_ie, sta);
+			if (memcmp(&cap, &sta->sta.vht_cap, sizeof(cap)))
+				rates_updated |= true;
+		}
+
+		if (bw != sta->sta.bandwidth)
+			rates_updated |= true;
+
+		if (!cfg80211_chandef_compatible(&sdata->u.ibss.chandef,
+						 &chandef))
+			ibss_dbg(sdata, "%pM incompatible chandef\n",
+				 sta->sta.addr);
 	}
 
 	if (sta && rates_updated) {
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 856f88d..faddd1a 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1970,6 +1970,9 @@ u8 *ieee80211_add_wmm_info_ie(u8 *buf, u8 qosinfo);
 void ieee80211_ht_oper_to_chandef(struct ieee80211_channel *control_chan,
 				  const struct ieee80211_ht_operation *ht_oper,
 				  struct cfg80211_chan_def *chandef);
+void ieee80211_vht_oper_to_chandef(struct ieee80211_channel *control_chan,
+				   const struct ieee80211_vht_operation *oper,
+				   struct cfg80211_chan_def *chandef);
 u32 ieee80211_chandef_downgrade(struct cfg80211_chan_def *c);
 
 int __must_check
diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 8465c05..60d737f 100644
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
index 37d85d3..3ff6adf 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -2428,6 +2428,39 @@ void ieee80211_ht_oper_to_chandef(struct ieee80211_channel *control_chan,
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

