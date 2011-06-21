Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57874 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466Ab1FUPrt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jun 2011 11:47:49 -0400
Received: by fxm17 with SMTP id 17so31190fxm.19
        for <linux-wireless@vger.kernel.org>; Tue, 21 Jun 2011 08:47:48 -0700 (PDT)
Subject: [RFC v3 1/3] mac80211: add some helper functions
From: Alexander Simon <alexander.simon@saxnet.de>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 21 Jun 2011 17:45:29 +0200
Message-ID: <1308671129.2656.4.camel@alex-2> (sfid-20110621_174753_258660_B2E3ED7C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add helper functions cfg80211_get_bss_ht, ieee80211_ie_build_ht_cap
and ieee80211_ie_build_ht_info.
These are needed for my IBSS HT patch but are also used to clean up some
multiple code.

Signed-off-by: Alexander Simon <alexander.simon@saxnet.de>
---
 include/net/cfg80211.h     |    6 ++
 net/mac80211/ieee80211_i.h |    8 +++
 net/mac80211/util.c        |  116 ++++++++++++++++++++++++++++++++++++++-------
 net/mac80211/work.c        |   29 -----------
 net/wireless/scan.c        |   36 +++++++++++++
 5 files changed, 148 insertions(+), 47 deletions(-)

diff -Nrup a/include/net/cfg80211.h b/include/net/cfg80211.h
--- a/include/net/cfg80211.h	2011-06-01 21:04:33.000000000 +0200
+++ b/include/net/cfg80211.h	2011-06-21 13:21:38.000000000 +0200
@@ -2530,6 +2531,12 @@ struct cfg80211_bss *cfg80211_get_bss(st
 				      const u8 *bssid,
 				      const u8 *ssid, size_t ssid_len,
 				      u16 capa_mask, u16 capa_val);
+struct cfg80211_bss *cfg80211_get_bss_ht(struct wiphy *wiphy,
+					  struct ieee80211_channel *channel,
+					  const u8 *bssid,
+					  const u8 *ssid, size_t ssid_len,
+					  u16 capa_mask, u16 capa_val,
+				       enum nl80211_channel_type channel_type);
 static inline struct cfg80211_bss *
 cfg80211_get_ibss(struct wiphy *wiphy,
 		  struct ieee80211_channel *channel,
diff -Nrup a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
--- a/net/mac80211/ieee80211_i.h	2011-06-01 21:04:32.000000000 +0200
+++ b/net/mac80211/ieee80211_i.h	2011-06-21 13:21:38.000000000 +0200
@@ -1376,6 +1378,12 @@ void ieee80211_recalc_smps(struct ieee80
 size_t ieee80211_ie_split(const u8 *ies, size_t ielen,
 			  const u8 *ids, int n_ids, size_t offset);
 size_t ieee80211_ie_split_vendor(const u8 *ies, size_t ielen, size_t offset);
+u8 *ieee80211_ie_build_ht_cap(u8 *pos, struct ieee80211_supported_band *sband,
+			       u16 cap);
+u8 *ieee80211_ie_build_ht_info(u8 *pos,
+				struct ieee80211_sta_ht_cap *ht_cap,
+				struct ieee80211_channel *channel,
+				enum nl80211_channel_type channel_type);
 
 /* internal work items */
 void ieee80211_work_init(struct ieee80211_local *local);
@@ -1404,6 +1412,8 @@ ieee80211_get_channel_mode(struct ieee80
 bool ieee80211_set_channel_type(struct ieee80211_local *local,
 				struct ieee80211_sub_if_data *sdata,
 				enum nl80211_channel_type chantype);
+enum nl80211_channel_type ieee80211_ht_info_to_channel_type(
+					struct ieee80211_ht_info *ht_info);
 
 #ifdef CONFIG_MAC80211_NOINLINE
 #define debug_noinline noinline
diff -Nrup a/net/mac80211/util.c b/net/mac80211/util.c
--- a/net/mac80211/util.c	2011-06-01 21:04:32.000000000 +0200
+++ b/net/mac80211/util.c	2011-06-21 13:21:38.000000000 +0200
@@ -1007,23 +1007,8 @@ int ieee80211_build_preq_ies(struct ieee
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
@@ -1462,3 +1447,100 @@ size_t ieee80211_ie_split_vendor(const u
 
 	return pos;
 }
+
+u8 *ieee80211_ie_build_ht_cap(u8 *pos, struct ieee80211_supported_band *sband,
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
+
+enum nl80211_channel_type ieee80211_ht_info_to_channel_type(
+					struct ieee80211_ht_info *ht_info)
+{
+	enum nl80211_channel_type channel_type;
+
+	if (!ht_info)
+		return NL80211_CHAN_NO_HT;
+
+	switch (ht_info->ht_param & IEEE80211_HT_PARAM_CHA_SEC_OFFSET) {
+	case IEEE80211_HT_PARAM_CHA_SEC_NONE:
+		channel_type = NL80211_CHAN_HT20;
+		break;
+	case IEEE80211_HT_PARAM_CHA_SEC_ABOVE:
+		channel_type = NL80211_CHAN_HT40PLUS;
+		break;
+	case IEEE80211_HT_PARAM_CHA_SEC_BELOW:
+		channel_type = NL80211_CHAN_HT40MINUS;
+		break;
+	default:
+		channel_type = NL80211_CHAN_NO_HT;
+	}
+
+	return channel_type;
+}
diff -Nrup a/net/mac80211/work.c b/net/mac80211/work.c
--- a/net/mac80211/work.c	2011-06-01 21:04:33.000000000 +0200
+++ b/net/mac80211/work.c	2011-06-21 13:21:38.000000000 +0200
@@ -117,7 +117,6 @@ static void ieee80211_add_ht_ie(struct s
 	u8 *pos;
 	u32 flags = channel->flags;
 	u16 cap = sband->ht_cap.cap;
-	__le16 tmp;
 
 	if (!sband->ht_cap.ht_supported)
 		return;
@@ -168,34 +167,8 @@ static void ieee80211_add_ht_ie(struct s
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
diff -Nrup a/net/wireless/scan.c b/net/wireless/scan.c
--- a/net/wireless/scan.c	2011-06-01 21:04:32.000000000 +0200
+++ b/net/wireless/scan.c	2011-06-21 13:21:38.000000000 +0200
@@ -343,6 +343,18 @@ struct cfg80211_bss *cfg80211_get_bss(st
 				      const u8 *ssid, size_t ssid_len,
 				      u16 capa_mask, u16 capa_val)
 {
+	return cfg80211_get_bss_ht(wiphy, channel, bssid, ssid, ssid_len,
+				   capa_mask, capa_val, NL80211_CHAN_NO_HT);
+}
+EXPORT_SYMBOL(cfg80211_get_bss);
+
+struct cfg80211_bss *cfg80211_get_bss_ht(struct wiphy *wiphy,
+				      struct ieee80211_channel *channel,
+				      const u8 *bssid,
+				      const u8 *ssid, size_t ssid_len,
+				      u16 capa_mask, u16 capa_val,
+				      enum nl80211_channel_type channel_type)
+{
 	struct cfg80211_registered_device *dev = wiphy_to_dev(wiphy);
 	struct cfg80211_internal_bss *bss, *res = NULL;
 	unsigned long now = jiffies;
@@ -352,8 +364,27 @@ struct cfg80211_bss *cfg80211_get_bss(st
 	list_for_each_entry(bss, &dev->bss_list, list) {
 		if ((bss->pub.capability & capa_mask) != capa_val)
 			continue;
-		if (channel && bss->pub.channel != channel)
-			continue;
+		if (channel) {
+			if (bss->pub.channel != channel)
+				continue;
+			if (channel_type == NL80211_CHAN_HT40MINUS ||
+			    channel_type == NL80211_CHAN_HT40PLUS) {
+				struct ieee80211_ht_info *ht_info;
+				ht_info = (struct ieee80211_ht_info *)
+					ieee80211_bss_get_ie(&bss->pub,
+						       WLAN_EID_HT_INFORMATION);
+				if (!ht_info)
+					continue;
+				if (channel_type == NL80211_CHAN_HT40MINUS &&
+					      !(ht_info->ht_param &
+					      IEEE80211_HT_PARAM_CHA_SEC_BELOW))
+					continue;
+				if (channel_type == NL80211_CHAN_HT40PLUS &&
+					      !(ht_info->ht_param &
+					      IEEE80211_HT_PARAM_CHA_SEC_ABOVE))
+					continue;
+			}
+		}
 		/* Don't get expired BSS structs */
 		if (time_after(now, bss->ts + IEEE80211_SCAN_RESULT_EXPIRE) &&
 		    !atomic_read(&bss->hold))
@@ -370,7 +401,8 @@ struct cfg80211_bss *cfg80211_get_bss(st
 		return NULL;
 	return &res->pub;
 }
 EXPORT_SYMBOL(cfg80211_get_bss);
+EXPORT_SYMBOL(cfg80211_get_bss_ht);
 
 struct cfg80211_bss *cfg80211_get_mesh(struct wiphy *wiphy,
 				       struct ieee80211_channel *channel,


