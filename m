Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.191]:22950 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754560AbYCYXMo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Mar 2008 19:12:44 -0400
Received: by rv-out-0910.google.com with SMTP id k20so1897575rvb.1
        for <linux-wireless@vger.kernel.org>; Tue, 25 Mar 2008 16:12:44 -0700 (PDT)
Subject: [PATCH 1/3] mac80211: michael.c replace macro with function
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 25 Mar 2008 16:12:42 -0700
Message-Id: <1206486762.26294.8.camel@brick> (sfid-20080325_231248_288969_509A0D18)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make michael_block a function to avoid it being unrolled
everywhere, cuts a third off of the michael.o size.

Fold xswap into michael_block and remove xswap.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
This series cuts the size of michael.o from 0x280 to 0x125 on X86_32
and cuts lines from michael.c.

Applies on top of the patch in -mm that adds the use of kernel-provided
bit-rotation helpers to michael.c.

 net/mac80211/michael.c |   37 ++++++++++++++++---------------------
 1 files changed, 16 insertions(+), 21 deletions(-)

diff --git a/net/mac80211/michael.c b/net/mac80211/michael.c
index c2c10d3..e6085a3 100644
--- a/net/mac80211/michael.c
+++ b/net/mac80211/michael.c
@@ -12,23 +12,18 @@
 
 #include "michael.h"
 
-static inline u32 xswap(u32 val)
+static void michael_block(u32 *l, u32 *r)
 {
-	return ((val & 0xff00ff00) >> 8) | ((val & 0x00ff00ff) << 8);
+	*r ^= rol32(*l, 17);
+	*l += *r;
+	*r ^= ((*l & 0xff00ff00) >> 8) | ((*l & 0x00ff00ff) << 8);
+	*l += *r;
+	*r ^= rol32(*l, 3);
+	*l += *r;
+	*r ^= ror32(*l, 2);
+	*l += *r;
 }
 
-#define michael_block(l, r) \
-do { \
-	r ^= rol32(l, 17); \
-	l += r; \
-	r ^= xswap(l); \
-	l += r; \
-	r ^= rol32(l, 3); \
-	l += r; \
-	r ^= ror32(l, 2); \
-	l += r; \
-} while (0)
-
 
 static inline u32 michael_get32(u8 *data)
 {
@@ -57,13 +52,13 @@ void michael_mic(u8 *key, u8 *da, u8 *sa, u8 priority,
 	/* A pseudo header (DA, SA, Priority, 0, 0, 0) is used in Michael MIC
 	 * calculation, but it is _not_ transmitted */
 	l ^= michael_get32(da);
-	michael_block(l, r);
+	michael_block(&l, &r);
 	l ^= da[4] | (da[5] << 8) | (sa[0] << 16) | (sa[1] << 24);
-	michael_block(l, r);
+	michael_block(&l, &r);
 	l ^= michael_get32(&sa[2]);
-	michael_block(l, r);
+	michael_block(&l, &r);
 	l ^= priority;
-	michael_block(l, r);
+	michael_block(&l, &r);
 
 	/* Real data */
 	blocks = data_len / 4;
@@ -71,7 +66,7 @@ void michael_mic(u8 *key, u8 *da, u8 *sa, u8 priority,
 
 	for (block = 0; block < blocks; block++) {
 		l ^= michael_get32(&data[block * 4]);
-		michael_block(l, r);
+		michael_block(&l, &r);
 	}
 
 	/* Partial block of 0..3 bytes and padding: 0x5a + 4..7 zeros to make
@@ -83,9 +78,9 @@ void michael_mic(u8 *key, u8 *da, u8 *sa, u8 priority,
 		val |= data[blocks * 4 + left];
 	}
 	l ^= val;
-	michael_block(l, r);
+	michael_block(&l, &r);
 	/* last block is zero, so l ^ 0 = l */
-	michael_block(l, r);
+	michael_block(&l, &r);
 
 	michael_put32(l, mic);
 	michael_put32(r, mic + 4);
-- 
1.5.5.rc0.139.g9315d


