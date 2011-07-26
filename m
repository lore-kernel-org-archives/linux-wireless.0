Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:63551 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753693Ab1GZPmu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jul 2011 11:42:50 -0400
Received: by ewy4 with SMTP id 4so521107ewy.19
        for <linux-wireless@vger.kernel.org>; Tue, 26 Jul 2011 08:42:49 -0700 (PDT)
Subject: Re: [RFC v4 2/4] cfg80211: Add cfg80211_get_bss_ht to also match
 HT configuration
From: Alexander Simon <alexander.simon@saxnet.de>
To: linux-wireless@vger.kernel.org
In-Reply-To: <1311694819.2974.3.camel@alex-2>
References: <1311694819.2974.3.camel@alex-2>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 26 Jul 2011 17:42:47 +0200
Message-ID: <1311694967.2974.5.camel@alex-2> (sfid-20110726_174258_956828_67EE3CC4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Keep cfg80211_get_bss for compatibility but make use of this new function
by matching any HT configuration.

Signed-off-by: Alexander Simon <alexander.simon@saxnet.de>
---
 include/net/cfg80211.h |    6 ++++++
 net/wireless/chan.c    |    1 +
 net/wireless/scan.c    |   37 ++++++++++++++++++++++++++++++++++---
 3 files changed, 41 insertions(+), 3 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 738db17..8276b19 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2581,6 +2581,12 @@ struct cfg80211_bss *cfg80211_get_bss(struct
wiphy *wiphy,
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
diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index cd630e1..046b113 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -75,6 +75,7 @@ bool can_beacon_sec_chan(struct wiphy *wiphy,
 
 	return true;
 }
+EXPORT_SYMBOL(can_beacon_sec_chan);
 
 int cfg80211_set_freq(struct cfg80211_registered_device *rdev,
 		      struct wireless_dev *wdev, int freq,
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 2936cb8..ff5b736 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -364,6 +364,19 @@ struct cfg80211_bss *cfg80211_get_bss(struct wiphy
*wiphy,
 				      const u8 *ssid, size_t ssid_len,
 				      u16 capa_mask, u16 capa_val)
 {
+	/* call HT version with no HT requirements */
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
+				      enum nl80211_channel_type require_ht)
+{
 	struct cfg80211_registered_device *dev = wiphy_to_dev(wiphy);
 	struct cfg80211_internal_bss *bss, *res = NULL;
 	unsigned long now = jiffies;
@@ -373,8 +386,26 @@ struct cfg80211_bss *cfg80211_get_bss(struct wiphy
*wiphy,
 	list_for_each_entry(bss, &dev->bss_list, list) {
 		if ((bss->pub.capability & capa_mask) != capa_val)
 			continue;
-		if (channel && bss->pub.channel != channel)
-			continue;
+		if (channel) {
+			if (bss->pub.channel != channel)
+				continue;
+			if (require_ht != NL80211_CHAN_NO_HT) {
+				struct ieee80211_ht_info *ht_info;
+				ht_info = (struct ieee80211_ht_info *)
+					ieee80211_bss_get_ie(&bss->pub,
+						       WLAN_EID_HT_INFORMATION);
+				if (!ht_info)
+					continue;
+				if (require_ht == NL80211_CHAN_HT40MINUS &&
+					      !(ht_info->ht_param &
+					      IEEE80211_HT_PARAM_CHA_SEC_BELOW))
+					continue;
+				if (require_ht == NL80211_CHAN_HT40PLUS &&
+					      !(ht_info->ht_param &
+					      IEEE80211_HT_PARAM_CHA_SEC_ABOVE))
+					continue;
+			}
+		}
 		/* Don't get expired BSS structs */
 		if (time_after(now, bss->ts + IEEE80211_SCAN_RESULT_EXPIRE) &&
 		    !atomic_read(&bss->hold))
@@ -391,7 +422,7 @@ struct cfg80211_bss *cfg80211_get_bss(struct wiphy
*wiphy,
 		return NULL;
 	return &res->pub;
 }
-EXPORT_SYMBOL(cfg80211_get_bss);
+EXPORT_SYMBOL(cfg80211_get_bss_ht);
 
 struct cfg80211_bss *cfg80211_get_mesh(struct wiphy *wiphy,
 				       struct ieee80211_channel *channel,
-- 
1.7.3.4


