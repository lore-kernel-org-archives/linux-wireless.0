Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55778 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934148AbYEBUsC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 May 2008 16:48:02 -0400
Message-Id: <200805022047.m42Klio0014208@imap1.linux-foundation.org> (sfid-20080502_224741_808657_A8329158)
Subject: [patch 1/9] mac80211: michael.c use kernel-provided infrastructure
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, akpm@linux-foundation.org,
	harvey.harrison@gmail.com
From: akpm@linux-foundation.org
Date: Fri, 02 May 2008 13:47:44 -0700
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Harvey Harrison <harvey.harrison@gmail.com>

Replace private implementation of bit rotation and unaligned access helpers
with kernel-provided implementation.

Fold xswap helper in its one usage in the michael_block macro.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/mac80211/michael.c |   60 +++++++++------------------------------
 1 file changed, 14 insertions(+), 46 deletions(-)

diff -puN net/mac80211/michael.c~mac80211-michaelc-use-kernel-provided-infrastructure net/mac80211/michael.c
--- a/net/mac80211/michael.c~mac80211-michaelc-use-kernel-provided-infrastructure
+++ a/net/mac80211/michael.c
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
@@ -82,7 +50,7 @@ void michael_mic(u8 *key, u8 *da, u8 *sa
 	left = data_len % 4;
 
 	for (block = 0; block < blocks; block++) {
-		l ^= michael_get32(&data[block * 4]);
+		l ^= get_unaligned_le32(&data[block * 4]);
 		michael_block(l, r);
 	}
 
@@ -99,6 +67,6 @@ void michael_mic(u8 *key, u8 *da, u8 *sa
 	/* last block is zero, so l ^ 0 = l */
 	michael_block(l, r);
 
-	michael_put32(l, mic);
-	michael_put32(r, mic + 4);
+	put_unaligned_le32(l, mic);
+	put_unaligned_le32(r, mic + 4);
 }
_
