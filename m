Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.181]:55560 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753540AbYDUCdL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Apr 2008 22:33:11 -0400
Received: by wa-out-1112.google.com with SMTP id m16so2758154waf.23
        for <linux-wireless@vger.kernel.org>; Sun, 20 Apr 2008 19:33:11 -0700 (PDT)
Subject: [PATCH] mac80211: remove unnecessary byteshifts in frame control
	testing
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 20 Apr 2008 19:33:29 -0700
Message-Id: <1208745209.7941.11.camel@brick> (sfid-20080421_033403_701359_8B23624F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Byteshift the constants rather than the data.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 include/linux/ieee80211.h |   32 +++++++++++++++++---------------
 1 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index f27d11a..1068965 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -546,16 +546,17 @@ enum ieee80211_back_parties {
  */
 static inline u8 *ieee80211_get_SA(struct ieee80211_hdr *hdr)
 {
-	u8 *raw = (u8 *) hdr;
-	u8 tofrom = (*(raw+1)) & 3; /* get the TODS and FROMDS bits */
-
-	switch (tofrom) {
-		case 2:
-			return hdr->addr3;
-		case 3:
-			return hdr->addr4;
+	__le16 fc = hdr->frame_control;
+	fc &= __constant_cpu_to_le16(IEEE80211_FCTL_TODS|IEEE80211_FCTL_FROMDS);
+
+	switch (fc) {
+	case __constant_cpu_to_le16(IEEE80211_FCTL_FROMDS):
+		return hdr->addr3;
+	case __constant_cpu_to_le16(IEEE80211_FCTL_TODS|IEEE80211_FCTL_FROMDS):
+		return hdr->addr4;
+	default:
+		return hdr->addr2;
 	}
-	return hdr->addr2;
 }
 
 /**
@@ -571,12 +572,13 @@ static inline u8 *ieee80211_get_SA(struct ieee80211_hdr *hdr)
  */
 static inline u8 *ieee80211_get_DA(struct ieee80211_hdr *hdr)
 {
-	u8 *raw = (u8 *) hdr;
-	u8 to_ds = (*(raw+1)) & 1; /* get the TODS bit */
+	__le16 fc = hdr->frame_control;
+	fc &= __constant_cpu_to_le16(IEEE80211_FCTL_TODS);
 
-	if (to_ds)
+	if (fc)
 		return hdr->addr3;
-	return hdr->addr1;
+	else
+		return hdr->addr1;
 }
 
 /**
@@ -589,8 +591,8 @@ static inline u8 *ieee80211_get_DA(struct ieee80211_hdr *hdr)
  */
 static inline int ieee80211_get_morefrag(struct ieee80211_hdr *hdr)
 {
-	return (le16_to_cpu(hdr->frame_control) &
-		IEEE80211_FCTL_MOREFRAGS) != 0;
+	__le16 fc = hdr->frame_control;
+	return !!(fc & __constant_cpu_to_le16(IEEE80211_FCTL_MOREFRAGS));
 }
 
 #endif /* IEEE80211_H */
-- 
1.5.5.144.g3e42



