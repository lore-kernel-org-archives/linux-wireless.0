Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from el-out-1112.google.com ([209.85.162.176]:36279 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752820AbYCCUU6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Mar 2008 15:20:58 -0500
Received: by el-out-1112.google.com with SMTP id v27so330530ele.17
        for <linux-wireless@vger.kernel.org>; Mon, 03 Mar 2008 12:20:57 -0800 (PST)
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	John Linville <linville@tuxdriver.com>
From: Luis Carlos Cobo <luisca@cozybit.com>
Date: Fri, 29 Feb 2008 17:07:54 -0800
Subject: [PATCH 09/10] mac80211: path IE fields macros, fix alignment problems and clean up
Message-ID: <47cc5da8.16be600a.6d4d.ffff80cb@mx.google.com> (sfid-20080303_202141_187204_91087C27)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Luis Carlos Cobo <luisca@cozybit.com>
---
 net/mac80211/mesh_hwmp.c |   68 +++++++++++++++++++++++----------------------
 1 files changed, 35 insertions(+), 33 deletions(-)

diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index 324ebea..576a6e5 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -7,6 +7,7 @@
  * published by the Free Software Foundation.
  */
 
+#include <asm/unaligned.h>
 #include "mesh.h"
 
 #define IEEE80211_FC(type, stype) cpu_to_le16(type | stype)
@@ -24,40 +25,41 @@
 /* Reply and forward */
 #define MP_F_RF	0x2
 
+static inline u32 u32_field_get(u8 *preq_elem, int offset, bool ae)
+{
+	if (ae)
+		offset += 6;
+	return le32_to_cpu(get_unaligned((__le32 *) (preq_elem + offset)));
+}
+
 /* HWMP IE processing macros */
-#define AE_F	(1<<6)
-#define AE_F_SET(x) (*x & AE_F)
-#define PREQ_IE_FLAGS(x) (*(x))
-#define PREQ_IE_HOPCOUNT(x) (*(x + 1))
-#define PREQ_IE_TTL(x) (*(x + 2))
-#define PREQ_IE_PREQ_ID(x) le32_to_cpu(*((__le32 *) (x + 3)))
-#define PREQ_IE_ORIG_ADDR(x) (x + 7)
-#define PREQ_IE_ORIG_DSN(x) le32_to_cpu(*((__le32 *) (x + 13)))
-#define PREQ_IE_LIFETIME(x) le32_to_cpu(*((__le32 *) \
-			(AE_F_SET(x) ? x + 23 : x + 17)))
-#define PREQ_IE_METRIC(x) le32_to_cpu(*((__le32 *) \
-			(AE_F_SET(x) ? x + 27 : x + 21)))
-#define PREQ_IE_DST_F(x) (*(AE_F_SET(x) ? x + 32 : x + 26))
-#define PREQ_IE_DST_ADDR(x) (AE_F_SET(x) ? x + 33 : x + 27)
-#define PREQ_IE_DST_DSN(x) le32_to_cpu(*((__le32 *) \
-			(AE_F_SET(x) ? x + 39 : x + 33)))
-
-
-#define PREP_IE_FLAGS(x) PREQ_IE_FLAGS(x)
-#define PREP_IE_HOPCOUNT(x) PREQ_IE_HOPCOUNT(x)
-#define PREP_IE_TTL(x) PREQ_IE_TTL(x)
-#define PREP_IE_ORIG_ADDR(x) (x + 3)
-#define PREP_IE_ORIG_DSN(x) le32_to_cpu(*((__le32 *) (x + 9)))
-#define PREP_IE_LIFETIME(x) le32_to_cpu(*((__le32 *) \
-			(AE_F_SET(x) ? x + 19 : x + 13)))
-#define PREP_IE_METRIC(x) le32_to_cpu(*((__le32 *) \
-			(AE_F_SET(x) ? x + 23 : x + 17)))
-#define PREP_IE_DST_ADDR(x) (AE_F_SET(x) ? x + 27 : x + 21)
-#define PREP_IE_DST_DSN(x) le32_to_cpu(*((__le32 *) \
-			(AE_F_SET(x) ? x + 33 : x + 27)))
-
-#define PERR_IE_DST_ADDR(x) (x + 2)
-#define PERR_IE_DST_DSN(x) le32_to_cpu(*((__le32 *) (x + 8)))
+#define AE_F			(1<<6)
+#define AE_F_SET(x)		(*x & AE_F)
+#define PREQ_IE_FLAGS(x)	(*(x))
+#define PREQ_IE_HOPCOUNT(x)	(*(x + 1))
+#define PREQ_IE_TTL(x)		(*(x + 2))
+#define PREQ_IE_PREQ_ID(x)	u32_field_get(x, 3, 0)
+#define PREQ_IE_ORIG_ADDR(x)	(x + 7)
+#define PREQ_IE_ORIG_DSN(x)	u32_field_get(x, 13, 0);
+#define PREQ_IE_LIFETIME(x)	u32_field_get(x, 17, AE_F_SET(x));
+#define PREQ_IE_METRIC(x) 	u32_field_get(x, 21, AE_F_SET(x));
+#define PREQ_IE_DST_F(x)	(*(AE_F_SET(x) ? x + 32 : x + 26))
+#define PREQ_IE_DST_ADDR(x) 	(AE_F_SET(x) ? x + 33 : x + 27)
+#define PREQ_IE_DST_DSN(x) 	u32_field_get(x, 33, AE_F_SET(x));
+
+
+#define PREP_IE_FLAGS(x)	PREQ_IE_FLAGS(x)
+#define PREP_IE_HOPCOUNT(x)	PREQ_IE_HOPCOUNT(x)
+#define PREP_IE_TTL(x)		PREQ_IE_TTL(x)
+#define PREP_IE_ORIG_ADDR(x)	(x + 3)
+#define PREP_IE_ORIG_DSN(x)	u32_field_get(x, 9, 0);
+#define PREP_IE_LIFETIME(x)	u32_field_get(x, 13, AE_F_SET(x));
+#define PREP_IE_METRIC(x)	u32_field_get(x, 17, AE_F_SET(x));
+#define PREP_IE_DST_ADDR(x)	(AE_F_SET(x) ? x + 27 : x + 21)
+#define PREP_IE_DST_DSN(x)	u32_field_get(x, 27, AE_F_SET(x));
+
+#define PERR_IE_DST_ADDR(x)	(x + 2)
+#define PERR_IE_DST_DSN(x)	u32_field_get(x, 8, 0);
 
 #define TU_TO_EXP_TIME(x) (jiffies + msecs_to_jiffies(x * 1024 / 1000))
 #define MSEC_TO_TU(x) (x*1000/1024)
-- 
1.5.2.5



