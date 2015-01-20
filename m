Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:61432 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754724AbbATMgu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Jan 2015 07:36:50 -0500
Received: by mail-wi0-f176.google.com with SMTP id em10so5104592wid.3
        for <linux-wireless@vger.kernel.org>; Tue, 20 Jan 2015 04:36:49 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [RFCv3 4/4] mac80211: add VHT support for IBSS
Date: Tue, 20 Jan 2015 13:35:18 +0100
Message-Id: <1421757318-8343-4-git-send-email-janusz.dziedzic@tieto.com> (sfid-20150120_133656_107473_3C15A6DE)
In-Reply-To: <1421757318-8343-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1421757318-8343-1-git-send-email-janusz.dziedzic@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add VHT80/VHT160 support for IBSS.
Drivers could activate this feature by
setting NL80211_FEATURE_VHT_IBSS flag.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 net/mac80211/ibss.c        | 41 +++++++++++++++++++++++++++--------------
 net/mac80211/ieee80211_i.h |  2 ++
 net/mac80211/util.c        | 35 +++++++++++++++++++++++++++++++++++
 3 files changed, 64 insertions(+), 14 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index fda5e2f..e041bde 100644
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
@@ -1047,27 +1061,26 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 		    sdata->u.ibss.chandef.width != NL80211_CHAN_WIDTH_10) {
 			/* we both use HT */
 			struct ieee80211_ht_cap htcap_ie;
-			struct cfg80211_chan_def chandef;
 			enum ieee80211_sta_rx_bandwidth bw = sta->sta.bandwidth;
 
-			ieee80211_ht_oper_to_chandef(channel,
-						     elems->ht_operation,
-						     &chandef);
-
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
 
+			if (elems->vht_operation && elems->vht_cap_elem &&
+			    sdata->u.ibss.chandef.width != NL80211_CHAN_WIDTH_20 &&
+			    sdata->u.ibss.chandef.width != NL80211_CHAN_WIDTH_40) {
+				/* we both use VHT */
+				struct ieee80211_vht_cap vhtcap_ie;
+				struct ieee80211_sta_vht_cap vht_cap = sta->sta.vht_cap;
+
+				memcpy(&vhtcap_ie, elems->vht_cap_elem, sizeof(vhtcap_ie));
+				ieee80211_vht_cap_ie_to_sta_vht_cap(sdata, sband, &vhtcap_ie, sta);
+				if (memcmp(&vht_cap, &sta->sta.vht_cap, sizeof(vht_cap)))
+						rates_updated |= true;
+			}
+
 			if (bw != sta->sta.bandwidth)
 				rates_updated |= true;
 		}
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 9254546..9d1967f 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1937,6 +1937,8 @@ u8 *ieee80211_ie_build_ht_oper(u8 *pos, struct ieee80211_sta_ht_cap *ht_cap,
 			       u16 prot_mode);
 u8 *ieee80211_ie_build_vht_cap(u8 *pos, struct ieee80211_sta_vht_cap *vht_cap,
 			       u32 cap);
+u8 *ieee80211_ie_build_vht_oper(u8 *pos, struct ieee80211_sta_vht_cap *vht_cap,
+				const struct cfg80211_chan_def *chandef);
 int ieee80211_parse_bitrates(struct cfg80211_chan_def *chandef,
 			     const struct ieee80211_supported_band *sband,
 			     const u8 *srates, int srates_len, u32 *rates);
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index bb9664c..3824de7 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -2317,6 +2317,41 @@ u8 *ieee80211_ie_build_ht_oper(u8 *pos, struct ieee80211_sta_ht_cap *ht_cap,
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
+	vht_oper->basic_mcs_set = vht_cap->vht_mcs.rx_mcs_map;
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
-- 
1.9.1

