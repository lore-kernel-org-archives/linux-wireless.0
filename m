Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:43278 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358AbbAMIgV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jan 2015 03:36:21 -0500
Received: by mail-we0-f170.google.com with SMTP id w61so1479107wes.1
        for <linux-wireless@vger.kernel.org>; Tue, 13 Jan 2015 00:36:20 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [RFC 2/2] mac80211: add VHT support for IBSS
Date: Tue, 13 Jan 2015 09:35:24 +0100
Message-Id: <1421138124-7661-2-git-send-email-janusz.dziedzic@tieto.com> (sfid-20150113_093625_324562_495C5A59)
In-Reply-To: <1421138124-7661-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1421138124-7661-1-git-send-email-janusz.dziedzic@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add VHT support for IBSS.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 net/mac80211/ibss.c        | 29 +++++++++++++++++++++++++++++
 net/mac80211/ieee80211_i.h | 11 +++++++++++
 net/mac80211/main.c        |  1 +
 net/mac80211/util.c        | 35 +++++++++++++++++++++++++++++++++++
 4 files changed, 76 insertions(+)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index b606b53..c3811f5 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -174,6 +174,7 @@ ieee80211_ibss_build_presp(struct ieee80211_sub_if_data *sdata,
 	if (chandef->width != NL80211_CHAN_WIDTH_20_NOHT &&
 	    chandef->width != NL80211_CHAN_WIDTH_5 &&
 	    chandef->width != NL80211_CHAN_WIDTH_10 &&
+	    !(sdata->u.ibss.flags & IEEE80211_IBSS_DISABLE_HT) &&
 	    sband->ht_cap.ht_supported) {
 		struct ieee80211_sta_ht_cap ht_cap;
 
@@ -188,6 +189,21 @@ ieee80211_ibss_build_presp(struct ieee80211_sub_if_data *sdata,
 		 */
 		pos = ieee80211_ie_build_ht_oper(pos, &sband->ht_cap,
 						 chandef, 0);
+
+		if (chandef->width != NL80211_CHAN_WIDTH_20 &&
+		    chandef->width != NL80211_CHAN_WIDTH_40 &&
+		    !(sdata->u.ibss.flags & IEEE80211_IBSS_DISABLE_VHT) &&
+		    sband->vht_cap.vht_supported) {
+			struct ieee80211_sta_vht_cap vht_cap;
+
+			memcpy(&vht_cap, &sband->vht_cap, sizeof(vht_cap));
+			ieee80211_apply_vhtcap_overrides(sdata, &vht_cap);
+
+			pos = ieee80211_ie_build_vht_cap(pos, &vht_cap,
+							 vht_cap.cap);
+			pos = ieee80211_ie_build_vht_oper(pos, &sband->vht_cap,
+							  chandef);
+		}
 	}
 
 	if (local->hw.queues >= IEEE80211_NUM_ACS)
@@ -1711,6 +1727,19 @@ int ieee80211_ibss_join(struct ieee80211_sub_if_data *sdata,
 	memcpy(&sdata->u.ibss.ht_capa_mask, &params->ht_capa_mask,
 	       sizeof(sdata->u.ibss.ht_capa_mask));
 
+	memcpy(&sdata->u.ibss.vht_capa, &params->vht_capa,
+	       sizeof(sdata->u.ibss.vht_capa));
+	memcpy(&sdata->u.ibss.vht_capa_mask, &params->vht_capa_mask,
+	       sizeof(sdata->u.ibss.vht_capa_mask));
+
+	if (params->flags & IBSS_PARAMS_DISABLE_HT) {
+		sdata->u.ibss.flags |= IEEE80211_IBSS_DISABLE_HT;
+		sdata->u.ibss.flags |= IEEE80211_IBSS_DISABLE_VHT;
+	}
+
+	if (params->flags & IBSS_PARAMS_DISABLE_VHT)
+		sdata->u.ibss.flags |= IEEE80211_IBSS_DISABLE_VHT;
+
 	/*
 	 * 802.11n-2009 9.13.3.1: In an IBSS, the HT Protection field is
 	 * reserved, but an HT STA shall protect HT transmissions as though
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 4f45cab..beac103 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -544,6 +544,11 @@ struct ieee80211_if_managed {
 	struct delayed_work tx_tspec_wk;
 };
 
+enum ieee80211_ibss_flags {
+	IEEE80211_IBSS_DISABLE_HT	= BIT(0),
+	IEEE80211_IBSS_DISABLE_VHT	= BIT(1),
+};
+
 struct ieee80211_if_ibss {
 	struct timer_list timer;
 	struct work_struct csa_connection_drop_work;
@@ -569,8 +574,12 @@ struct ieee80211_if_ibss {
 	/* probe response/beacon for IBSS */
 	struct beacon_data __rcu *presp;
 
+	unsigned int flags;
+
 	struct ieee80211_ht_cap ht_capa; /* configured ht-cap over-rides */
 	struct ieee80211_ht_cap ht_capa_mask; /* Valid parts of ht_capa */
+	struct ieee80211_vht_cap vht_capa; /* configured VHT overrides */
+	struct ieee80211_vht_cap vht_capa_mask; /* Valid parts of vht_capa */
 
 	spinlock_t incomplete_lock;
 	struct list_head incomplete_stations;
@@ -1937,6 +1946,8 @@ u8 *ieee80211_ie_build_ht_oper(u8 *pos, struct ieee80211_sta_ht_cap *ht_cap,
 			       u16 prot_mode);
 u8 *ieee80211_ie_build_vht_cap(u8 *pos, struct ieee80211_sta_vht_cap *vht_cap,
 			       u32 cap);
+u8 *ieee80211_ie_build_vht_oper(u8 *pos, struct ieee80211_sta_vht_cap *vht_cap,
+				const struct cfg80211_chan_def *chandef);
 int ieee80211_parse_bitrates(struct cfg80211_chan_def *chandef,
 			     const struct ieee80211_supported_band *sband,
 			     const u8 *srates, int srates_len, u32 *rates);
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index d9ce336..1f7457b 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -549,6 +549,7 @@ struct ieee80211_hw *ieee80211_alloc_hw_nm(size_t priv_data_len,
 		wiphy->features |= NL80211_FEATURE_LOW_PRIORITY_SCAN |
 				   NL80211_FEATURE_AP_SCAN;
 
+	wiphy_ext_feature_set(wiphy, NL80211_FEATURE_VHT_IBSS);
 
 	if (!ops->set_key)
 		wiphy->flags |= WIPHY_FLAG_IBSS_RSN;
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index ad8cb4f..89ca38c 100644
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

