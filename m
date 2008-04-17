Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.234]:19135 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752847AbYDQUNl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Apr 2008 16:13:41 -0400
Received: by wx-out-0506.google.com with SMTP id h31so221112wxd.4
        for <linux-wireless@vger.kernel.org>; Thu, 17 Apr 2008 13:13:37 -0700 (PDT)
Subject: [PATCH 1/7] mac80211: michael.c use kernel-provided infrastructure
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>,
	Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 17 Apr 2008 13:13:47 -0700
Message-Id: <1208463227.17196.23.camel@brick> (sfid-20080417_211403_499331_1B535DF3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replace private implementation of bit rotation and unaligned access
helpers with kernel-provided implementation.

Fold xswap helper in its one usage in the michael_block macro.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
John, this depends on the unaligned access helpers going in through the -mm
tree, and will not compile without it.  This is a collapsed patchset of all
pending cleanups I have for mac80211 and supercedes the patches I have in -mm

Patches against current wireless-test.

 net/mac80211/michael.c |   60 +++++++++++------------------------------------
 1 files changed, 14 insertions(+), 46 deletions(-)

diff --git a/net/mac80211/michael.c b/net/mac80211/michael.c
index 0f844f7..c1e5897 100644
--- a/net/mac80211/michael.c
+++ b/net/mac80211/michael.c
@@ -8,71 +8,39 @@
  */
 
 #include <linux/types.h>
+#include <linux/bitops.h>
+#include <asm/unaligned.h>
 
 #include "michael.h"
 
-static inline u32 rotr(u32 val, int bits)
-{
-	return (val >> bits) | (val << (32 - bits));
-}
-
-
-static inline u32 rotl(u32 val, int bits)
-{
-	return (val << bits) | (val >> (32 - bits));
-}
-
-
-static inline u32 xswap(u32 val)
-{
-	return ((val & 0xff00ff00) >> 8) | ((val & 0x00ff00ff) << 8);
-}
-
-
 #define michael_block(l, r) \
 do { \
-	r ^= rotl(l, 17); \
+	r ^= rol32(l, 17); \
 	l += r; \
-	r ^= xswap(l); \
+	r ^= ((l & 0xff00ff00) >> 8) | ((l & 0x00ff00ff) << 8); \
 	l += r; \
-	r ^= rotl(l, 3); \
+	r ^= rol32(l, 3); \
 	l += r; \
-	r ^= rotr(l, 2); \
+	r ^= ror32(l, 2); \
 	l += r; \
 } while (0)
 
-
-static inline u32 michael_get32(u8 *data)
-{
-	return data[0] | (data[1] << 8) | (data[2] << 16) | (data[3] << 24);
-}
-
-
-static inline void michael_put32(u32 val, u8 *data)
-{
-	data[0] = val & 0xff;
-	data[1] = (val >> 8) & 0xff;
-	data[2] = (val >> 16) & 0xff;
-	data[3] = (val >> 24) & 0xff;
-}
-
-
 void michael_mic(u8 *key, u8 *da, u8 *sa, u8 priority,
 		 u8 *data, size_t data_len, u8 *mic)
 {
 	u32 l, r, val;
 	size_t block, blocks, left;
 
-	l = michael_get32(key);
-	r = michael_get32(key + 4);
+	l = get_unaligned_le32(key);
+	r = get_unaligned_le32(key + 4);
 
 	/* A pseudo header (DA, SA, Priority, 0, 0, 0) is used in Michael MIC
 	 * calculation, but it is _not_ transmitted */
-	l ^= michael_get32(da);
+	l ^= get_unaligned_le32(da);
 	michael_block(l, r);
-	l ^= da[4] | (da[5] << 8) | (sa[0] << 16) | (sa[1] << 24);
+	l ^= get_unaligned_le16(&da[4]) | (get_unaligned_le16(sa) << 16);
 	michael_block(l, r);
-	l ^= michael_get32(&sa[2]);
+	l ^= get_unaligned_le32(&sa[2]);
 	michael_block(l, r);
 	l ^= priority;
 	michael_block(l, r);
@@ -82,7 +50,7 @@ void michael_mic(u8 *key, u8 *da, u8 *sa, u8 priority,
 	left = data_len % 4;
 
 	for (block = 0; block < blocks; block++) {
-		l ^= michael_get32(&data[block * 4]);
+		l ^= get_unaligned_le32(&data[block * 4]);
 		michael_block(l, r);
 	}
 
@@ -99,6 +67,6 @@ void michael_mic(u8 *key, u8 *da, u8 *sa, u8 priority,
 	/* last block is zero, so l ^ 0 = l */
 	michael_block(l, r);
 
-	michael_put32(l, mic);
-	michael_put32(r, mic + 4);
+	put_unaligned_le32(l, mic);
+	put_unaligned_le32(r, mic + 4);
 }
-- 
1.5.5.144.g3e42


