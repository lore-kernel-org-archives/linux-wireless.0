Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58683 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753512Ab1H2ObT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Aug 2011 10:31:19 -0400
Received: by fxh19 with SMTP id 19so4466691fxh.19
        for <linux-wireless@vger.kernel.org>; Mon, 29 Aug 2011 07:31:18 -0700 (PDT)
From: Alexander Simon <an.alexsimon@googlemail.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH v2 3/4] mac80211: Add HT helper functions
Date: Mon, 29 Aug 2011 16:31:15 +0200
Message-ID: <8895351.7r3DmOHRZj@alex-1> (sfid-20110829_163123_144378_4CFEDC30)
In-Reply-To: <2053881.ENil2Dy3QM@alex-1>
References: <2053881.ENil2Dy3QM@alex-1>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some refactoring for IBSS HT.

Move HT info and capability IEs building code into separate functions.
---
 net/mac80211/ieee80211_i.h |    6 +++
 net/mac80211/util.c        |   91 +++++++++++++++++++++++++++++++++++--------
 net/mac80211/work.c        |   29 +-------------
 3 files changed, 81 insertions(+), 45 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index c204cee..ad94e59 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1338,6 +1338,12 @@ void ieee80211_recalc_smps(struct ieee80211_local 
*local);
 size_t ieee80211_ie_split(const u8 *ies, size_t ielen,
 			  const u8 *ids, int n_ids, size_t offset);
 size_t ieee80211_ie_split_vendor(const u8 *ies, size_t ielen, size_t offset);
+u8 *ieee80211_ie_build_ht_cap(u8 *pos, struct ieee80211_supported_band 
*sband,
+			       u16 cap);
+u8 *ieee80211_ie_build_ht_info(u8 *pos,
+				struct ieee80211_sta_ht_cap *ht_cap,
+				struct ieee80211_channel *channel,
+				enum nl80211_channel_type channel_type);
 
 /* internal work items */
 void ieee80211_work_init(struct ieee80211_local *local);
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index ce916ff..a7697d8 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -816,23 +816,8 @@ int ieee80211_build_preq_ies(struct ieee80211_local 
*local, u8 *buffer,
 		offset = noffset;
 	}
 
-	if (sband->ht_cap.ht_supported) {
-		u16 cap = sband->ht_cap.cap;
-		__le16 tmp;
-
-		*pos++ = WLAN_EID_HT_CAPABILITY;
-		*pos++ = sizeof(struct ieee80211_ht_cap);
-		memset(pos, 0, sizeof(struct ieee80211_ht_cap));
-		tmp = cpu_to_le16(cap);
-		memcpy(pos, &tmp, sizeof(u16));
-		pos += sizeof(u16);
-		*pos++ = sband->ht_cap.ampdu_factor |
-			 (sband->ht_cap.ampdu_density <<
-				IEEE80211_HT_AMPDU_PARM_DENSITY_SHIFT);
-		memcpy(pos, &sband->ht_cap.mcs, sizeof(sband->ht_cap.mcs));
-		pos += sizeof(sband->ht_cap.mcs);
-		pos += 2 + 4 + 1; /* ext info, BF cap, antsel */
-	}
+	if (sband->ht_cap.ht_supported)
+		pos = ieee80211_ie_build_ht_cap(pos, sband, sband->ht_cap.cap);
 
 	/*
 	 * If adding more here, adjust code in main.c
@@ -1356,3 +1341,75 @@ void ieee80211_disable_rssi_reports(struct 
ieee80211_vif *vif)
 	_ieee80211_enable_rssi_reports(sdata, 0, 0);
 }
 EXPORT_SYMBOL(ieee80211_disable_rssi_reports);
+
+u8 *ieee80211_ie_build_ht_cap(u8 *pos, struct ieee80211_supported_band 
*sband,
+			       u16 cap)
+{
+	__le16 tmp;
+
+	*pos++ = WLAN_EID_HT_CAPABILITY;
+	*pos++ = sizeof(struct ieee80211_ht_cap);
+	memset(pos, 0, sizeof(struct ieee80211_ht_cap));
+
+	/* capability flags */
+	tmp = cpu_to_le16(cap);
+	memcpy(pos, &tmp, sizeof(u16));
+	pos += sizeof(u16);
+
+	/* AMPDU parameters */
+	*pos++ = sband->ht_cap.ampdu_factor |
+		 (sband->ht_cap.ampdu_density <<
+			IEEE80211_HT_AMPDU_PARM_DENSITY_SHIFT);
+
+	/* MCS set */
+	memcpy(pos, &sband->ht_cap.mcs, sizeof(sband->ht_cap.mcs));
+	pos += sizeof(sband->ht_cap.mcs);
+
+	/* extended capabilities */
+	pos += sizeof(__le16);
+
+	/* BF capabilities */
+	pos += sizeof(__le32);
+
+	/* antenna selection */
+	pos += sizeof(u8);
+
+	return pos;
+}
+
+u8 *ieee80211_ie_build_ht_info(u8 *pos,
+				struct ieee80211_sta_ht_cap *ht_cap,
+				struct ieee80211_channel *channel,
+				enum nl80211_channel_type channel_type)
+{
+	struct ieee80211_ht_info *ht_info;
+	/* Build HT Information */
+	*pos++ = WLAN_EID_HT_INFORMATION;
+	*pos++ = sizeof(struct ieee80211_ht_info);
+	ht_info = (struct ieee80211_ht_info *)pos;
+	ht_info->control_chan =
+			ieee80211_frequency_to_channel(channel->center_freq);
+	switch (channel_type) {
+	case NL80211_CHAN_HT40MINUS:
+		ht_info->ht_param = IEEE80211_HT_PARAM_CHA_SEC_BELOW;
+		break;
+	case NL80211_CHAN_HT40PLUS:
+		ht_info->ht_param = IEEE80211_HT_PARAM_CHA_SEC_ABOVE;
+		break;
+	case NL80211_CHAN_HT20:
+	default:
+		ht_info->ht_param = IEEE80211_HT_PARAM_CHA_SEC_NONE;
+		break;
+	}
+	if (ht_cap->cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40)
+		ht_info->ht_param |= IEEE80211_HT_PARAM_CHAN_WIDTH_ANY;
+	ht_info->operation_mode = 0x0000;
+	ht_info->stbc_param = 0x0000;
+
+	/* It seems that Basic MCS set and Supported MCS set
+	   are identical for the first 10 bytes */
+	memset(&ht_info->basic_set, 0, 16);
+	memcpy(&ht_info->basic_set, &ht_cap->mcs, 10);
+
+	return pos + sizeof(struct ieee80211_ht_info);
+}
diff --git a/net/mac80211/work.c b/net/mac80211/work.c
index 380b9a7..8d9251c 100644
--- a/net/mac80211/work.c
+++ b/net/mac80211/work.c
@@ -103,7 +103,6 @@ static void ieee80211_add_ht_ie(struct sk_buff *skb, const 
u8 *ht_info_ie,
 	u8 *pos;
 	u32 flags = channel->flags;
 	u16 cap = sband->ht_cap.cap;
-	__le16 tmp;
 
 	if (!sband->ht_cap.ht_supported)
 		return;
@@ -154,34 +153,8 @@ static void ieee80211_add_ht_ie(struct sk_buff *skb, 
const u8 *ht_info_ie,
 	}
 
 	/* reserve and fill IE */
-
 	pos = skb_put(skb, sizeof(struct ieee80211_ht_cap) + 2);
-	*pos++ = WLAN_EID_HT_CAPABILITY;
-	*pos++ = sizeof(struct ieee80211_ht_cap);
-	memset(pos, 0, sizeof(struct ieee80211_ht_cap));
-
-	/* capability flags */
-	tmp = cpu_to_le16(cap);
-	memcpy(pos, &tmp, sizeof(u16));
-	pos += sizeof(u16);
-
-	/* AMPDU parameters */
-	*pos++ = sband->ht_cap.ampdu_factor |
-		 (sband->ht_cap.ampdu_density <<
-			IEEE80211_HT_AMPDU_PARM_DENSITY_SHIFT);
-
-	/* MCS set */
-	memcpy(pos, &sband->ht_cap.mcs, sizeof(sband->ht_cap.mcs));
-	pos += sizeof(sband->ht_cap.mcs);
-
-	/* extended capabilities */
-	pos += sizeof(__le16);
-
-	/* BF capabilities */
-	pos += sizeof(__le32);
-
-	/* antenna selection */
-	pos += sizeof(u8);
+	ieee80211_ie_build_ht_cap(pos, sband, cap);
 }
 
 static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata,
-- 
1.7.3.4


