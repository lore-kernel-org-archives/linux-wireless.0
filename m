Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:61665 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754211AbbAPKjn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jan 2015 05:39:43 -0500
Received: by mail-wi0-f175.google.com with SMTP id l15so3114273wiw.2
        for <linux-wireless@vger.kernel.org>; Fri, 16 Jan 2015 02:39:42 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [RFCv2 6/6] mac80211: IBSS setup correctly BW for VHT
Date: Fri, 16 Jan 2015 11:38:44 +0100
Message-Id: <1421404724-32326-6-git-send-email-janusz.dziedzic@tieto.com> (sfid-20150116_113950_393658_F86E269F)
In-Reply-To: <1421404724-32326-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1421404724-32326-1-git-send-email-janusz.dziedzic@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Setup correctly BW in case of STA using VHT.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 net/mac80211/ibss.c        | 25 ++++++++++++++++---------
 net/mac80211/ieee80211_i.h |  3 +++
 net/mac80211/util.c        | 31 +++++++++++++++++++++++++++++++
 3 files changed, 50 insertions(+), 9 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 3c6df2b..b4263b5 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -1072,18 +1072,25 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 
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
+				ieee80211_vht_oper_to_chandef(channel,
+							      elems->vht_operation,
+							      &chandef);
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
index 05d3af5..a3e93ad 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1953,6 +1953,9 @@ u8 *ieee80211_add_wmm_info_ie(u8 *buf, u8 qosinfo);
 void ieee80211_ht_oper_to_chandef(struct ieee80211_channel *control_chan,
 				  const struct ieee80211_ht_operation *ht_oper,
 				  struct cfg80211_chan_def *chandef);
+void ieee80211_vht_oper_to_chandef(struct ieee80211_channel *control_chan,
+				   const struct ieee80211_vht_operation *oper,
+				   struct cfg80211_chan_def *chandef);
 u32 ieee80211_chandef_downgrade(struct cfg80211_chan_def *c);
 
 int __must_check
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index ee6a601..f5599ac 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -2393,6 +2393,37 @@ void ieee80211_ht_oper_to_chandef(struct ieee80211_channel *control_chan,
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
+	}
+
+	chandef->center_freq1 = ieee80211_channel_to_frequency(
+						oper->center_freq_seg1_idx,
+						control_chan->band);
+	chandef->center_freq2 = ieee80211_channel_to_frequency(
+						oper->center_freq_seg2_idx,
+						control_chan->band);
+}
+
 int ieee80211_parse_bitrates(struct cfg80211_chan_def *chandef,
 			     const struct ieee80211_supported_band *sband,
 			     const u8 *srates, int srates_len, u32 *rates)
-- 
1.9.1

