Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:36726 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968972AbXFHREt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jun 2007 13:04:49 -0400
Date: Sat, 9 Jun 2007 01:04:06 +0800
From: Zhu Yi <yi.zhu@intel.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 4/6] mac80211: Fix TSINFO macros endian issue
Message-ID: <20070608170406.GA17271@mail.intel.com>
Reply-To: yi.zhu@intel.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The short1 defined in struct ieee80211_ts_info causes wrong values on big
endian systems. Fix this by replacing short with 2 bytes.

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 include/linux/ieee80211.h |   40 +++++++++++++++++++++++-----------------
 1 files changed, 23 insertions(+), 17 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 31368bc..27ecac9 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -124,28 +124,34 @@ struct ieee80211_ht_additional_info {
 }__attribute__ ((packed));
 
 
-#define IEEE80211_TSINFO_TYPE(a)	((a.short1 & 0x0001) >> 0)
-#define IEEE80211_TSINFO_TSID(a)	((a.short1 & 0x001E) >> 1)
-#define IEEE80211_TSINFO_DIR(a)		((a.short1 & 0x0060) >> 5)
-#define IEEE80211_TSINFO_POLICY(a)	((a.short1 & 0x0180) >> 7)
-#define IEEE80211_TSINFO_AGG(a)		((a.short1 & 0x0200) >> 9)
-#define IEEE80211_TSINFO_APSD(a)	((a.short1 & 0x0400) >> 10)
-#define IEEE80211_TSINFO_UP(a)		((a.short1 & 0x3800) >> 11)
-#define IEEE80211_TSINFO_ACK(a)		((a.short1 & 0xC000) >> 14)
+#define IEEE80211_TSINFO_TYPE(a)	((a.byte1 & 0x01) >> 0)
+#define IEEE80211_TSINFO_TSID(a)	((a.byte1 & 0x1E) >> 1)
+#define IEEE80211_TSINFO_DIR(a)		((a.byte1 & 0x60) >> 5)
+#define IEEE80211_TSINFO_POLICY(a)	((a.byte1 & 0x80) >> 7 + \
+					 (a.byte2 & 0x01) << 1)
+#define IEEE80211_TSINFO_AGG(a)		((a.byte2 & 0x02) >> 1)
+#define IEEE80211_TSINFO_APSD(a)	((a.byte2 & 0x04) >> 2)
+#define IEEE80211_TSINFO_UP(a)		((a.byte2 & 0x38) >> 3)
+#define IEEE80211_TSINFO_ACK(a)		((a.byte2 & 0xC0) >> 6)
 #define IEEE80211_TSINFO_SCHEDULE(a)	((a.byte3 & 0x01) >> 0)
 
-#define IEEE80211_SET_TSINFO_TYPE(i, d)		(i.short1 |= (d << 0) & 0x0001)
-#define IEEE80211_SET_TSINFO_TSID(i, d)		(i.short1 |= (d << 1) & 0x001E)
-#define IEEE80211_SET_TSINFO_DIR(i, d)		(i.short1 |= (d << 5) & 0x0060)
-#define IEEE80211_SET_TSINFO_POLICY(i, d)	(i.short1 |= (d << 7) & 0x0180)
-#define IEEE80211_SET_TSINFO_AGG(i, d)		(i.short1 |= (d << 9) & 0x0200)
-#define IEEE80211_SET_TSINFO_APSD(i, d)		(i.short1 |= (d << 10) & 0x0400)
-#define IEEE80211_SET_TSINFO_UP(i, d)		(i.short1 |= (d << 11) & 0x3800)
-#define IEEE80211_SET_TSINFO_ACK(i, d)		(i.short1 |= (d << 14) & 0xC000)
+#define IEEE80211_SET_TSINFO_TYPE(i, d)		(i.byte1 |= (d << 0) & 0x01)
+#define IEEE80211_SET_TSINFO_TSID(i, d)		(i.byte1 |= (d << 1) & 0x1E)
+#define IEEE80211_SET_TSINFO_DIR(i, d)		(i.byte1 |= (d << 5) & 0x60)
+#define IEEE80211_SET_TSINFO_POLICY(i, d)	\
+do {						\
+						i.byte1 |= (d & 0x01) << 7; \
+						i.byte2 |= (d & 0x02) >> 1; \
+} while(0)
+#define IEEE80211_SET_TSINFO_AGG(i, d)		(i.byte2 |= (d << 1) & 0x02)
+#define IEEE80211_SET_TSINFO_APSD(i, d)		(i.byte2 |= (d << 2) & 0x04)
+#define IEEE80211_SET_TSINFO_UP(i, d)		(i.byte2 |= (d << 3) & 0x38)
+#define IEEE80211_SET_TSINFO_ACK(i, d)		(i.byte2 |= (d << 6) & 0xC0)
 #define IEEE80211_SET_TSINFO_SCHEDULE(i, d)	(i.byte3 |= (d << 0) & 0x01)
 
 struct ieee80211_ts_info {
-	__le16 short1;
+	u8 byte1;
+	u8 byte2;
 	u8 byte3;
 } __attribute__ ((packed));
 
-- 
1.5.0.rc2.g73a2
