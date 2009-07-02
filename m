Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35858 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807AbZGBPSj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jul 2009 11:18:39 -0400
Subject: [PATCH] cfg80211: assimilate and export ieee80211_bss_get_ie
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 02 Jul 2009 17:18:40 +0200
Message-Id: <1246547920.16770.41.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This function from mac80211 seems generally useful, and
I will need it in cfg80211 soon.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/net/cfg80211.h |    9 +++++++++
 net/mac80211/mlme.c    |   25 +++----------------------
 net/wireless/util.c    |   21 +++++++++++++++++++++
 3 files changed, 33 insertions(+), 22 deletions(-)

--- wireless-testing.orig/include/net/cfg80211.h	2009-07-02 17:13:46.000000000 +0200
+++ wireless-testing/include/net/cfg80211.h	2009-07-02 17:13:49.000000000 +0200
@@ -605,6 +605,15 @@ struct cfg80211_bss {
 };
 
 /**
+ * ieee80211_bss_get_ie - find IE with given ID
+ * @bss: the bss to search
+ * @ie: the IE ID
+ * Returns %NULL if not found.
+ */
+const u8 *ieee80211_bss_get_ie(struct cfg80211_bss *bss, u8 ie);
+
+
+/**
  * struct cfg80211_crypto_settings - Crypto settings
  * @wpa_versions: indicates which, if any, WPA versions are enabled
  *	(from enum nl80211_wpa_versions)
--- wireless-testing.orig/net/mac80211/mlme.c	2009-07-02 17:13:46.000000000 +0200
+++ wireless-testing/net/mac80211/mlme.c	2009-07-02 17:16:57.000000000 +0200
@@ -46,26 +46,6 @@ static int ecw2cw(int ecw)
 	return (1 << ecw) - 1;
 }
 
-static u8 *ieee80211_bss_get_ie(struct ieee80211_bss *bss, u8 ie)
-{
-	u8 *end, *pos;
-
-	pos = bss->cbss.information_elements;
-	if (pos == NULL)
-		return NULL;
-	end = pos + bss->cbss.len_information_elements;
-
-	while (pos + 1 < end) {
-		if (pos + 2 + pos[1] > end)
-			break;
-		if (pos[0] == ie)
-			return pos;
-		pos += 2 + pos[1];
-	}
-
-	return NULL;
-}
-
 static int ieee80211_compatible_rates(struct ieee80211_bss *bss,
 				      struct ieee80211_supported_band *sband,
 				      u32 *rates)
@@ -181,7 +161,8 @@ static void ieee80211_send_assoc(struct 
 	struct ieee80211_local *local = sdata->local;
 	struct sk_buff *skb;
 	struct ieee80211_mgmt *mgmt;
-	u8 *pos, *ies, *ht_ie;
+	u8 *pos;
+	const u8 *ies, *ht_ie;
 	int i, len, count, rates_len, supp_rates_len;
 	u16 capab;
 	struct ieee80211_bss *bss;
@@ -345,7 +326,7 @@ static void ieee80211_send_assoc(struct 
 	 */
 	if (wmm && (ifmgd->flags & IEEE80211_STA_WMM_ENABLED) &&
 	    sband->ht_cap.ht_supported &&
-	    (ht_ie = ieee80211_bss_get_ie(bss, WLAN_EID_HT_INFORMATION)) &&
+	    (ht_ie = ieee80211_bss_get_ie(&bss->cbss, WLAN_EID_HT_INFORMATION)) &&
 	    ht_ie[1] >= sizeof(struct ieee80211_ht_info) &&
 	    (!(ifmgd->flags & IEEE80211_STA_DISABLE_11N))) {
 		struct ieee80211_ht_info *ht_info =
--- wireless-testing.orig/net/wireless/util.c	2009-07-02 17:13:46.000000000 +0200
+++ wireless-testing/net/wireless/util.c	2009-07-02 17:13:49.000000000 +0200
@@ -502,3 +502,24 @@ unsigned int cfg80211_classify8021d(stru
 	return dscp >> 5;
 }
 EXPORT_SYMBOL(cfg80211_classify8021d);
+
+const u8 *ieee80211_bss_get_ie(struct cfg80211_bss *bss, u8 ie)
+{
+	u8 *end, *pos;
+
+	pos = bss->information_elements;
+	if (pos == NULL)
+		return NULL;
+	end = pos + bss->len_information_elements;
+
+	while (pos + 1 < end) {
+		if (pos + 2 + pos[1] > end)
+			break;
+		if (pos[0] == ie)
+			return pos;
+		pos += 2 + pos[1];
+	}
+
+	return NULL;
+}
+EXPORT_SYMBOL(ieee80211_bss_get_ie);


