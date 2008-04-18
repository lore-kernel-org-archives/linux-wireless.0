Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40514 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762631AbYDRVAk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Apr 2008 17:00:40 -0400
Message-Id: <200804182059.m3IKxriX015607@imap1.linux-foundation.org> (sfid-20080418_222701_548483_9B7505C7)
Subject: [patch 7/7] mac80211: michael.c fold initial xor into block helper
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, akpm@linux-foundation.org,
	harvey.harrison@gmail.com, jbenc@suse.cz
From: akpm@linux-foundation.org
Date: Fri, 18 Apr 2008 13:59:52 -0700
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Harvey Harrison <harvey.harrison@gmail.com>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Jiri Benc <jbenc@suse.cz>
Cc: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/mac80211/michael.c |   27 ++++++++++-----------------
 1 file changed, 10 insertions(+), 17 deletions(-)

diff -puN net/mac80211/michael.c~mac80211-michaelc-fold-initial-xor-into-block-helper net/mac80211/michael.c
--- a/net/mac80211/michael.c~mac80211-michaelc-fold-initial-xor-into-block-helper
+++ a/net/mac80211/michael.c
@@ -14,8 +14,9 @@
 
 #include "michael.h"
 
-static void michael_block(u32 *l, u32 *r)
+static void michael_block(u32 val, u32 *l, u32 *r)
 {
+	*l ^= val;
 	*r ^= rol32(*l, 17);
 	*l += *r;
 	*r ^= ((*l & 0xff00ff00) >> 8) | ((*l & 0x00ff00ff) << 8);
@@ -52,23 +53,17 @@ void michael_mic(u8 *key, u8 *da, u8 *sa
 
 	/* A pseudo header (DA, SA, Priority, 0, 0, 0) is used in Michael MIC
 	 * calculation, but it is _not_ transmitted */
-	l ^= michael_get32(da);
-	michael_block(&l, &r);
-	l ^= michael_get16(da) | (michael_get16(sa) << 16);
-	michael_block(&l, &r);
-	l ^= michael_get32(&sa[2]);
-	michael_block(&l, &r);
-	l ^= priority;
-	michael_block(&l, &r);
+	michael_block(michael_get32(da), &l, &r);
+	michael_block(michael_get16(da) | (michael_get16(sa) << 16), &l, &r);
+	michael_block(michael_get32(&sa[2]), &l, &r);
+	michael_block(priority, &l, &r);
 
 	/* Real data */
 	blocks = data_len / 4;
 	left = data_len % 4;
 
-	for (block = 0; block < blocks; block++) {
-		l ^= michael_get32(&data[block * 4]);
-		michael_block(&l, &r);
-	}
+	for (block = 0; block < blocks; block++)
+		michael_block(michael_get32(&data[block * 4]), &l, &r);
 
 	/* Partial block of 0..3 bytes and padding: 0x5a + 4..7 zeros to make
 	 * total length a multiple of 4. */
@@ -78,10 +73,8 @@ void michael_mic(u8 *key, u8 *da, u8 *sa
 		left--;
 		val |= data[blocks * 4 + left];
 	}
-	l ^= val;
-	michael_block(&l, &r);
-	/* last block is zero, so l ^ 0 = l */
-	michael_block(&l, &r);
+	michael_block(val, &l, &r);
+	michael_block(0, &l, &r);
 
 	michael_put32(l, mic);
 	michael_put32(r, mic + 4);
_
