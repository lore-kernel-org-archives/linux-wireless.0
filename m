Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56341 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761159AbYDRVAk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Apr 2008 17:00:40 -0400
Message-Id: <200804182059.m3IKxpkY015601@imap1.linux-foundation.org> (sfid-20080418_221701_041805_491D5F98)
Subject: [patch 5/7] mac80211: michael.c replace macro with function
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, akpm@linux-foundation.org,
	harvey.harrison@gmail.com, jbenc@suse.cz
From: akpm@linux-foundation.org
Date: Fri, 18 Apr 2008 13:59:51 -0700
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Harvey Harrison <harvey.harrison@gmail.com>

This series cuts the size of michael.o from 0x280 to 0x125 on X86_32
and cuts lines from michael.c.


This patch:

Make michael_block a function to avoid it being unrolled everywhere, cuts a
third off of the michael.o size.

Fold xswap into michael_block and remove xswap.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Jiri Benc <jbenc@suse.cz>
Cc: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/mac80211/michael.c |   37 ++++++++++++++++---------------------
 1 file changed, 16 insertions(+), 21 deletions(-)

diff -puN net/mac80211/michael.c~mac80211-michaelc-replace-macro-with-function net/mac80211/michael.c
--- a/net/mac80211/michael.c~mac80211-michaelc-replace-macro-with-function
+++ a/net/mac80211/michael.c
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
@@ -57,13 +52,13 @@ void michael_mic(u8 *key, u8 *da, u8 *sa
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
@@ -71,7 +66,7 @@ void michael_mic(u8 *key, u8 *da, u8 *sa
 
 	for (block = 0; block < blocks; block++) {
 		l ^= michael_get32(&data[block * 4]);
-		michael_block(l, r);
+		michael_block(&l, &r);
 	}
 
 	/* Partial block of 0..3 bytes and padding: 0x5a + 4..7 zeros to make
@@ -83,9 +78,9 @@ void michael_mic(u8 *key, u8 *da, u8 *sa
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
_
