Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51061 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753967AbZDPWSp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Apr 2009 18:18:45 -0400
Subject: [PATCH 2.6.30!] mac80211: validate TIM IE length
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Kalle Valo <kalle.valo@iki.fi>,
	Christian Lamparter <chunkeey@web.de>
Content-Type: text/plain
Date: Fri, 17 Apr 2009 00:18:11 +0200
Message-Id: <1239920291.26575.37.camel@johannes.local> (sfid-20090417_001849_051533_DC947D05)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The TIM IE must not be shorter than 4 bytes, so verify that
when parsing it and use the proper type. To ease that adjust
struct ieee80211_tim_ie to have a virtual bitmap of size
at least 1.

Also check that the TIM IE is actually present before trying
to parse it!

Because other people may need the function, make it a static
inline in ieee80211.h.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
I can provide a shorter fix for 2.6.30 if required.

Kalle!!

 include/linux/ieee80211.h  |   32 +++++++++++++++++++++++++++++++-
 net/mac80211/ieee80211_i.h |    2 +-
 net/mac80211/mlme.c        |   24 ++----------------------
 net/mac80211/util.c        |    6 ++++--
 4 files changed, 38 insertions(+), 26 deletions(-)

--- wireless-testing.orig/include/linux/ieee80211.h	2009-04-16 23:56:05.000000000 +0200
+++ wireless-testing/include/linux/ieee80211.h	2009-04-17 00:09:21.000000000 +0200
@@ -540,7 +540,7 @@ struct ieee80211_tim_ie {
 	u8 dtim_period;
 	u8 bitmap_ctrl;
 	/* variable size: 1 - 251 bytes */
-	u8 virtual_map[0];
+	u8 virtual_map[1];
 } __attribute__ ((packed));
 
 #define WLAN_SA_QUERY_TR_ID_LEN 16
@@ -1392,4 +1392,34 @@ static inline unsigned long ieee80211_tu
 	return 1024 * tu;
 }
 
+/**
+ * ieee80211_check_tim - check if AID bit is set in TIM
+ * @tim: the TIM IE
+ * @tim_len: length of the TIM IE
+ * @aid: the AID to look for
+ */
+static inline bool ieee80211_check_tim(struct ieee80211_tim_ie *tim,
+				       u8 tim_len, u16 aid)
+{
+	u8 mask;
+	u8 index, indexn1, indexn2;
+
+	if (unlikely(!tim || tim_len < sizeof(*tim)))
+		return false;
+
+	aid &= 0x3fff;
+	index = aid / 8;
+	mask  = 1 << (aid & 7);
+
+	indexn1 = tim->bitmap_ctrl & 0xfe;
+	indexn2 = tim_len + indexn1 - 4;
+
+	if (index < indexn1 || index > indexn2)
+		return false;
+
+	index -= indexn1;
+
+	return !!(tim->virtual_map[index] & mask);
+}
+
 #endif /* LINUX_IEEE80211_H */
--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2009-04-16 23:56:05.000000000 +0200
+++ wireless-testing/net/mac80211/ieee80211_i.h	2009-04-16 23:56:06.000000000 +0200
@@ -844,7 +844,7 @@ struct ieee802_11_elems {
 	u8 *fh_params;
 	u8 *ds_params;
 	u8 *cf_params;
-	u8 *tim;
+	struct ieee80211_tim_ie *tim;
 	u8 *ibss_params;
 	u8 *challenge;
 	u8 *wpa;
--- wireless-testing.orig/net/mac80211/util.c	2009-04-16 23:56:05.000000000 +0200
+++ wireless-testing/net/mac80211/util.c	2009-04-16 23:56:06.000000000 +0200
@@ -588,8 +588,10 @@ u32 ieee802_11_parse_elems_crc(u8 *start
 			elems->cf_params_len = elen;
 			break;
 		case WLAN_EID_TIM:
-			elems->tim = pos;
-			elems->tim_len = elen;
+			if (elen >= sizeof(struct ieee80211_tim_ie)) {
+				elems->tim = (void *)pos;
+				elems->tim_len = elen;
+			}
 			break;
 		case WLAN_EID_IBSS_PARAMS:
 			elems->ibss_params = pos;
--- wireless-testing.orig/net/mac80211/mlme.c	2009-04-16 23:56:05.000000000 +0200
+++ wireless-testing/net/mac80211/mlme.c	2009-04-17 00:07:53.000000000 +0200
@@ -677,27 +677,6 @@ static void ieee80211_sta_wmm_params(str
 	}
 }
 
-static bool ieee80211_check_tim(struct ieee802_11_elems *elems, u16 aid)
-{
-	u8 mask;
-	u8 index, indexn1, indexn2;
-	struct ieee80211_tim_ie *tim = (struct ieee80211_tim_ie *) elems->tim;
-
-	aid &= 0x3fff;
-	index = aid / 8;
-	mask  = 1 << (aid & 7);
-
-	indexn1 = tim->bitmap_ctrl & 0xfe;
-	indexn2 = elems->tim_len + indexn1 - 4;
-
-	if (index < indexn1 || index > indexn2)
-		return false;
-
-	index -= indexn1;
-
-	return !!(tim->virtual_map[index] & mask);
-}
-
 static u32 ieee80211_handle_bss_capability(struct ieee80211_sub_if_data *sdata,
 					   u16 capab, bool erp_valid, u8 erp)
 {
@@ -1805,7 +1784,8 @@ static void ieee80211_rx_mgmt_beacon(str
 					  care_about_ies, ncrc);
 
 	if (local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK)
-		directed_tim = ieee80211_check_tim(&elems, ifmgd->aid);
+		directed_tim = ieee80211_check_tim(elems.tim, elems.tim_len,
+						   ifmgd->aid);
 
 	ncrc = crc32_be(ncrc, (void *)&directed_tim, sizeof(directed_tim));
 


