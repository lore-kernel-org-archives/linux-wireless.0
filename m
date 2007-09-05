Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:42848 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756034AbXIFNqW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Sep 2007 09:46:22 -0400
Message-Id: <20070905234625.710099000@sipsolutions.net>
References: <20070905234209.108005000@sipsolutions.net>
Date: Thu, 06 Sep 2007 01:42:18 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 09/21] wireless networking: move frame inline functions to  generic header
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These inlines are generally useful, not just with mac80211.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 include/linux/ieee80211.h |   61 ++++++++++++++++++++++++++++++++++++++++++++++
 include/net/mac80211.h    |   60 ---------------------------------------------
 2 files changed, 61 insertions(+), 60 deletions(-)

--- wireless-dev.orig/include/linux/ieee80211.h	2007-09-06 01:34:56.734453431 +0200
+++ wireless-dev/include/linux/ieee80211.h	2007-09-06 01:35:18.784453431 +0200
@@ -16,6 +16,7 @@
 #define IEEE80211_H
 
 #include <linux/types.h>
+#include <asm/byteorder.h>
 
 #define FCS_LEN 4
 
@@ -581,4 +582,64 @@ enum wifi_oui_stype_wmm {
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
--- wireless-dev.orig/include/net/mac80211.h	2007-09-06 01:35:18.104453431 +0200
+++ wireless-dev/include/net/mac80211.h	2007-09-06 01:35:18.784453431 +0200
@@ -1334,66 +1334,6 @@ void ieee80211_wake_queues(struct ieee80
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

