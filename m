Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58683 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753686Ab1H2Obm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Aug 2011 10:31:42 -0400
Received: by mail-fx0-f46.google.com with SMTP id 19so4466691fxh.19
        for <linux-wireless@vger.kernel.org>; Mon, 29 Aug 2011 07:31:42 -0700 (PDT)
From: Alexander Simon <an.alexsimon@googlemail.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH v2 2/4] cfg80211: Add cfg80211_get_bss_ht to also match HT configuration
Date: Mon, 29 Aug 2011 16:30:41 +0200
Message-ID: <5559682.keg4y6PyKd@alex-1> (sfid-20110829_163151_961847_63AD57DE)
In-Reply-To: <2053881.ENil2Dy3QM@alex-1>
References: <2053881.ENil2Dy3QM@alex-1>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Keep cfg80211_get_bss for compatibility but make use of this new function by
matching any HT configuration.

Signed-off-by: Alexander Simon <alexander.simon@saxnet.de>
---
 include/net/cfg80211.h |   35 ++++++++++++++++++++++++++++-------
 net/wireless/scan.c    |   39 ++++++++++++++++++++++++++++++++++++---
 2 files changed, 64 insertions(+), 10 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 6d6e4b1..a461b68 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2577,18 +2577,39 @@ cfg80211_inform_bss(struct wiphy *wiphy,
 		    const u8 *ie, size_t ielen,
 		    s32 signal, gfp_t gfp);
 
-struct cfg80211_bss *cfg80211_get_bss(struct wiphy *wiphy,
-				      struct ieee80211_channel *channel,
-				      const u8 *bssid,
-				      const u8 *ssid, size_t ssid_len,
-				      u16 capa_mask, u16 capa_val);
+/**
+ * cfg80211_get_bss_ht - search for an BSS in scan results
+ * @wiphy: the wiphy
+ * @bssid: BSSID to match, if set
+ * @ssid: SSID to match
+ * @ssid_len: length of the SSID
+ * @capa_mask: AND mask for capabilities comparison
+ * @capa_val: SSID capabilities to match
+ * @check_ht: if to match for an HT mode
+ * @ht_mode: HT mode to match
+ *
+ * Return the first BSS found in the last scan.
+ * No match return NULL.
+ */
+struct cfg80211_bss *
+cfg80211_get_bss_ht(struct wiphy *wiphy, struct ieee80211_channel *channel,
+		    const u8 *bssid, const u8 *ssid, size_t ssid_len,
+		    u16 capa_mask, u16 capa_val, bool check_ht,
+		    enum nl80211_channel_type ht_mode);
+
+struct cfg80211_bss *
+cfg80211_get_bss(struct wiphy *wiphy, struct ieee80211_channel *channel,
+		 const u8 *bssid, const u8 *ssid, size_t ssid_len,
+		 u16 capa_mask, u16 capa_val);
+
 static inline struct cfg80211_bss *
 cfg80211_get_ibss(struct wiphy *wiphy,
 		  struct ieee80211_channel *channel,
 		  const u8 *ssid, size_t ssid_len)
 {
-	return cfg80211_get_bss(wiphy, channel, NULL, ssid, ssid_len,
-				WLAN_CAPABILITY_IBSS, WLAN_CAPABILITY_IBSS);
+	return cfg80211_get_bss_ht(wiphy, channel, NULL, ssid, ssid_len,
+				   WLAN_CAPABILITY_IBSS, WLAN_CAPABILITY_IBSS,
+				   false, NL80211_CHAN_NO_HT);
 }
 
 struct cfg80211_bss *cfg80211_get_mesh(struct wiphy *wiphy,
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index b0f0039..dcc608b 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -365,6 +365,21 @@ struct cfg80211_bss *cfg80211_get_bss(struct wiphy 
*wiphy,
 				      const u8 *ssid, size_t ssid_len,
 				      u16 capa_mask, u16 capa_val)
 {
+	/* call HT version with no HT requirements */
+	return cfg80211_get_bss_ht(wiphy, channel, bssid, ssid, ssid_len,
+				   capa_mask, capa_val, false,
+				   NL80211_CHAN_NO_HT);
+}
+EXPORT_SYMBOL(cfg80211_get_bss);
+
+struct cfg80211_bss *cfg80211_get_bss_ht(struct wiphy *wiphy,
+				         struct ieee80211_channel *channel,
+				         const u8 *bssid,
+				         const u8 *ssid, size_t ssid_len,
+				         u16 capa_mask, u16 capa_val,
+				         bool check_ht,
+				         enum nl80211_channel_type ht_mode)
+{
 	struct cfg80211_registered_device *dev = wiphy_to_dev(wiphy);
 	struct cfg80211_internal_bss *bss, *res = NULL;
 	unsigned long now = jiffies;
@@ -374,8 +389,26 @@ struct cfg80211_bss *cfg80211_get_bss(struct wiphy 
*wiphy,
 	list_for_each_entry(bss, &dev->bss_list, list) {
 		if ((bss->pub.capability & capa_mask) != capa_val)
 			continue;
-		if (channel && bss->pub.channel != channel)
-			continue;
+		if (channel) {
+			if (bss->pub.channel != channel)
+				continue;
+			if (check_ht) {
+				struct ieee80211_ht_info *ht_info;
+				ht_info = (struct ieee80211_ht_info *)
+					ieee80211_bss_get_ie(&bss->pub,
+						       WLAN_EID_HT_INFORMATION);
+				if (!ht_info)
+					continue;
+				if (ht_mode == NL80211_CHAN_HT40MINUS &&
+					      !(ht_info->ht_param &
+					      IEEE80211_HT_PARAM_CHA_SEC_BELOW))
+					continue;
+				if (ht_mode == NL80211_CHAN_HT40PLUS &&
+					      !(ht_info->ht_param &
+					      IEEE80211_HT_PARAM_CHA_SEC_ABOVE))
+					continue;
+			}
+		}
 		/* Don't get expired BSS structs */
 		if (time_after(now, bss->ts + IEEE80211_SCAN_RESULT_EXPIRE) &&
 		    !atomic_read(&bss->hold))
@@ -392,7 +425,7 @@ struct cfg80211_bss *cfg80211_get_bss(struct wiphy *wiphy,
 		return NULL;
 	return &res->pub;
 }
-EXPORT_SYMBOL(cfg80211_get_bss);
+EXPORT_SYMBOL(cfg80211_get_bss_ht);
 
 struct cfg80211_bss *cfg80211_get_mesh(struct wiphy *wiphy,
 				       struct ieee80211_channel *channel,
-- 
1.7.3.4


