Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57693 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756046AbYENX1K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 May 2008 19:27:10 -0400
Message-Id: <200805142326.m4ENQHJJ027085@imap1.linux-foundation.org> (sfid-20080515_012713_569140_216A8E43)
Subject: [patch 03/12] mac80211: introduce struct michael_mic_ctx and static helpers
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, akpm@linux-foundation.org,
	harvey.harrison@gmail.com
From: akpm@linux-foundation.org
Date: Wed, 14 May 2008 16:26:17 -0700
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Harvey Harrison <harvey.harrison@gmail.com>

Replace the existing macro with a static function, significantly shrinks the
size of the produced object file.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/mac80211/michael.c |   75 ++++++++++++++++++++-------------------
 net/mac80211/michael.h |    4 ++
 2 files changed, 44 insertions(+), 35 deletions(-)

diff -puN net/mac80211/michael.c~mac80211-introduce-struct-michael_mic_ctx-and-static-helpers net/mac80211/michael.c
--- a/net/mac80211/michael.c~mac80211-introduce-struct-michael_mic_ctx-and-static-helpers
+++ a/net/mac80211/michael.c
@@ -13,46 +13,52 @@
 
 #include "michael.h"
 
-#define michael_block(l, r) \
-do { \
-	r ^= rol32(l, 17); \
-	l += r; \
-	r ^= ((l & 0xff00ff00) >> 8) | ((l & 0x00ff00ff) << 8); \
-	l += r; \
-	r ^= rol32(l, 3); \
-	l += r; \
-	r ^= ror32(l, 2); \
-	l += r; \
-} while (0)
+static void michael_block(struct michael_mic_ctx *mctx, u32 val)
+{
+	mctx->l ^= val;
+	mctx->r ^= rol32(mctx->l, 17);
+	mctx->l += mctx->r;
+	mctx->r ^= ((mctx->l & 0xff00ff00) >> 8) |
+		   ((mctx->l & 0x00ff00ff) << 8);
+	mctx->l += mctx->r;
+	mctx->r ^= rol32(mctx->l, 3);
+	mctx->l += mctx->r;
+	mctx->r ^= ror32(mctx->l, 2);
+	mctx->l += mctx->r;
+}
+
+static void michael_mic_hdr(struct michael_mic_ctx *mctx,
+			    u8 *key, u8 *da, u8 *sa, u8 priority)
+{
+	mctx->l = get_unaligned_le32(key);
+	mctx->r = get_unaligned_le32(key + 4);
+
+	/*
+	 * A pseudo header (DA, SA, Priority, 0, 0, 0) is used in Michael MIC
+	 * calculation, but it is _not_ transmitted
+	 */
+	michael_block(mctx, get_unaligned_le32(da));
+	michael_block(mctx, get_unaligned_le16(&da[4]) |
+			    (get_unaligned_le16(sa) << 16));
+	michael_block(mctx, get_unaligned_le32(&sa[2]));
+	michael_block(mctx, priority);
+}
 
 void michael_mic(u8 *key, u8 *da, u8 *sa, u8 priority,
 		 u8 *data, size_t data_len, u8 *mic)
 {
-	u32 l, r, val;
+	u32 val;
 	size_t block, blocks, left;
+	struct michael_mic_ctx mctx;
 
-	l = get_unaligned_le32(key);
-	r = get_unaligned_le32(key + 4);
-
-	/* A pseudo header (DA, SA, Priority, 0, 0, 0) is used in Michael MIC
-	 * calculation, but it is _not_ transmitted */
-	l ^= get_unaligned_le32(da);
-	michael_block(l, r);
-	l ^= get_unaligned_le16(&da[4]) | (get_unaligned_le16(sa) << 16);
-	michael_block(l, r);
-	l ^= get_unaligned_le32(&sa[2]);
-	michael_block(l, r);
-	l ^= priority;
-	michael_block(l, r);
+	michael_mic_hdr(&mctx, key, da, sa, priority);
 
 	/* Real data */
 	blocks = data_len / 4;
 	left = data_len % 4;
 
-	for (block = 0; block < blocks; block++) {
-		l ^= get_unaligned_le32(&data[block * 4]);
-		michael_block(l, r);
-	}
+	for (block = 0; block < blocks; block++)
+		michael_block(&mctx, get_unaligned_le32(&data[block * 4]));
 
 	/* Partial block of 0..3 bytes and padding: 0x5a + 4..7 zeros to make
 	 * total length a multiple of 4. */
@@ -62,11 +68,10 @@ void michael_mic(u8 *key, u8 *da, u8 *sa
 		left--;
 		val |= data[blocks * 4 + left];
 	}
-	l ^= val;
-	michael_block(l, r);
-	/* last block is zero, so l ^ 0 = l */
-	michael_block(l, r);
 
-	put_unaligned_le32(l, mic);
-	put_unaligned_le32(r, mic + 4);
+	michael_block(&mctx, val);
+	michael_block(&mctx, 0);
+
+	put_unaligned_le32(mctx.l, mic);
+	put_unaligned_le32(mctx.r, mic + 4);
 }
diff -puN net/mac80211/michael.h~mac80211-introduce-struct-michael_mic_ctx-and-static-helpers net/mac80211/michael.h
--- a/net/mac80211/michael.h~mac80211-introduce-struct-michael_mic_ctx-and-static-helpers
+++ a/net/mac80211/michael.h
@@ -14,6 +14,10 @@
 
 #define MICHAEL_MIC_LEN 8
 
+struct michael_mic_ctx {
+	u32 l, r;
+};
+
 void michael_mic(u8 *key, u8 *da, u8 *sa, u8 priority,
 		 u8 *data, size_t data_len, u8 *mic);
 
_
