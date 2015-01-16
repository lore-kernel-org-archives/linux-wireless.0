Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:54524 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754211AbbAPKji (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jan 2015 05:39:38 -0500
Received: by mail-wi0-f171.google.com with SMTP id ho1so3112071wib.4
        for <linux-wireless@vger.kernel.org>; Fri, 16 Jan 2015 02:39:37 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [RFCv2 3/6] mac80211: add VHT support for IBSS
Date: Fri, 16 Jan 2015 11:38:41 +0100
Message-Id: <1421404724-32326-3-git-send-email-janusz.dziedzic@tieto.com> (sfid-20150116_113945_760789_8442D845)
In-Reply-To: <1421404724-32326-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1421404724-32326-1-git-send-email-janusz.dziedzic@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add VHT80/VHT160 support for IBSS.
Drivers could activate this feature by
setting NL80211_FEATURE_VHT_IBSS flag.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 net/mac80211/ibss.c        | 11 +++++++++++
 net/mac80211/ieee80211_i.h |  2 ++
 net/mac80211/util.c        | 35 +++++++++++++++++++++++++++++++++++
 3 files changed, 48 insertions(+)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 13b8105..1ffcfab 100644
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
@@ -411,6 +420,8 @@ static void ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 		cfg80211_chandef_create(&chandef, cbss->channel, chan_type);
 		break;
 	case NL80211_CHAN_WIDTH_40:
+	case NL80211_CHAN_WIDTH_80:
+	case NL80211_CHAN_WIDTH_160:
 		cfg80211_chandef_create(&chandef, cbss->channel,
 					NL80211_CHAN_WIDTH_20_NOHT);
 		chandef.width = sdata->u.ibss.chandef.width;
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 156ea79..95ce152 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1935,6 +1935,8 @@ u8 *ieee80211_ie_build_ht_oper(u8 *pos, struct ieee80211_sta_ht_cap *ht_cap,
 			       u16 prot_mode);
 u8 *ieee80211_ie_build_vht_cap(u8 *pos, struct ieee80211_sta_vht_cap *vht_cap,
 			       u32 cap);
+u8 *ieee80211_ie_build_vht_oper(u8 *pos, struct ieee80211_sta_vht_cap *vht_cap,
+				const struct cfg80211_chan_def *chandef);
 int ieee80211_parse_bitrates(struct cfg80211_chan_def *chandef,
 			     const struct ieee80211_supported_band *sband,
 			     const u8 *srates, int srates_len, u32 *rates);
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 83ba6cd..ee6a601 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -2329,6 +2329,41 @@ u8 *ieee80211_ie_build_ht_oper(u8 *pos, struct ieee80211_sta_ht_cap *ht_cap,
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

