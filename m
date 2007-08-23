Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:54772 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755849AbXHWQt1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Aug 2007 12:49:27 -0400
Received: from [131.234.79.133]
	by sipsolutions.net with esmtpsa (TLS-1.0:RSA_ARCFOUR_MD5:16)
	(Exim 4.67)
	(envelope-from <johannes@sipsolutions.net>)
	id 1IOFs4-0000zs-E7
	for linux-wireless@vger.kernel.org; Thu, 23 Aug 2007 17:49:25 +0100
Message-Id: <20070823164522.154615000@sipsolutions.net>
References: <20070823164500.998912000@sipsolutions.net>
Date: Thu, 23 Aug 2007 18:45:04 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFC 03/11] wireless networking: move frame inline functions to  generic header
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These inlines are generally useful, not just with mac80211.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 include/linux/ieee80211.h |   60 ++++++++++++++++++++++++++++++++++++++++++++++
 include/net/mac80211.h    |   60 ----------------------------------------------
 2 files changed, 60 insertions(+), 60 deletions(-)

--- wireless-dev.orig/include/linux/ieee80211.h	2007-08-23 18:22:33.251897709 +0200
+++ wireless-dev/include/linux/ieee80211.h	2007-08-23 18:23:22.721897709 +0200
@@ -581,4 +581,64 @@ enum wifi_oui_stype_wmm {
 	WIFI_OUI_STYPE_WMM_TSPEC = 2,
 };
 
+/**
+ * ieee80211_get_SA - get pointer to SA
+ *
+ * Given an 802.11 frame, this function returns the offset
+ * to the source address (SA). It does not verify that the
+ * header is long enough to contain the address, and the
+ * header must be long enough to contain the frame control
+ * field.
+ *
+ * @hdr: the frame
+ */
+static inline u8 *ieee80211_get_SA(struct ieee80211_hdr *hdr)
+{
+	u8 *raw = (u8 *) hdr;
+	u8 tofrom = (*(raw+1)) & 3; /* get the TODS and FROMDS bits */
+
+	switch (tofrom) {
+		case 2:
+			return hdr->addr3;
+		case 3:
+			return hdr->addr4;
+	}
+	return hdr->addr2;
+}
+
+/**
+ * ieee80211_get_DA - get pointer to DA
+ *
+ * Given an 802.11 frame, this function returns the offset
+ * to the destination address (DA). It does not verify that
+ * the header is long enough to contain the address, and the
+ * header must be long enough to contain the frame control
+ * field.
+ *
+ * @hdr: the frame
+ */
+static inline u8 *ieee80211_get_DA(struct ieee80211_hdr *hdr)
+{
+	u8 *raw = (u8 *) hdr;
+	u8 to_ds = (*(raw+1)) & 1; /* get the TODS bit */
+
+	if (to_ds)
+		return hdr->addr3;
+	return hdr->addr1;
+}
+
+/**
+ * ieee80211_get_morefrag - determine whether the MOREFRAGS bit is set
+ *
+ * This function determines whether the "more fragments" bit is set
+ * in the frame.
+ *
+ * @hdr: the frame
+ */
+static inline int ieee80211_get_morefrag(struct ieee80211_hdr *hdr)
+{
+	return (le16_to_cpu(hdr->frame_control) &
+		IEEE80211_FCTL_MOREFRAGS) != 0;
+}
+
 #endif /* IEEE80211_H */
--- wireless-dev.orig/include/net/mac80211.h	2007-08-23 18:22:33.281897709 +0200
+++ wireless-dev/include/net/mac80211.h	2007-08-23 18:23:22.731897709 +0200
@@ -1380,66 +1380,6 @@ void ieee80211_key_removed(struct ieee80
  */
 void ieee80211_scan_completed(struct ieee80211_hw *hw);
 
-/**
- * ieee80211_get_SA - get pointer to SA
- *
- * Given an 802.11 frame, this function returns the offset
- * to the source address (SA). It does not verify that the
- * header is long enough to contain the address, and the
- * header must be long enough to contain the frame control
- * field.
- *
- * @hdr: the frame
- */
-static inline u8 *ieee80211_get_SA(struct ieee80211_hdr *hdr)
-{
-	u8 *raw = (u8 *) hdr;
-	u8 tofrom = (*(raw+1)) & 3; /* get the TODS and FROMDS bits */
-
-	switch (tofrom) {
-		case 2:
-			return hdr->addr3;
-		case 3:
-			return hdr->addr4;
-	}
-	return hdr->addr2;
-}
-
-/**
- * ieee80211_get_DA - get pointer to DA
- *
- * Given an 802.11 frame, this function returns the offset
- * to the destination address (DA). It does not verify that
- * the header is long enough to contain the address, and the
- * header must be long enough to contain the frame control
- * field.
- *
- * @hdr: the frame
- */
-static inline u8 *ieee80211_get_DA(struct ieee80211_hdr *hdr)
-{
-	u8 *raw = (u8 *) hdr;
-	u8 to_ds = (*(raw+1)) & 1; /* get the TODS bit */
-
-	if (to_ds)
-		return hdr->addr3;
-	return hdr->addr1;
-}
-
-/**
- * ieee80211_get_morefrag - determine whether the MOREFRAGS bit is set
- *
- * This function determines whether the "more fragments" bit is set
- * in the frame.
- *
- * @hdr: the frame
- */
-static inline int ieee80211_get_morefrag(struct ieee80211_hdr *hdr)
-{
-	return (le16_to_cpu(hdr->frame_control) &
-		IEEE80211_FCTL_MOREFRAGS) != 0;
-}
-
 #define MAC_FMT "%02x:%02x:%02x:%02x:%02x:%02x"
 #define MAC_ARG(x) ((u8*)(x))[0], ((u8*)(x))[1], ((u8*)(x))[2], \
 		   ((u8*)(x))[3], ((u8*)(x))[4], ((u8*)(x))[5]

-- 

