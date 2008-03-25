Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.231]:6983 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756183AbYCYXMv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Mar 2008 19:12:51 -0400
Received: by wr-out-0506.google.com with SMTP id c48so2532917wra.1
        for <linux-wireless@vger.kernel.org>; Tue, 25 Mar 2008 16:12:51 -0700 (PDT)
Subject: [PATCH 3/3] mac80211: michael.c fold initial xor into block helper
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 25 Mar 2008 16:12:49 -0700
Message-Id: <1206486769.26294.11.camel@brick> (sfid-20080325_231256_689093_6F20215A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 net/mac80211/michael.c |   27 ++++++++++-----------------
 1 files changed, 10 insertions(+), 17 deletions(-)

diff --git a/net/mac80211/michael.c b/net/mac80211/michael.c
index 76940be..36bb3bb 100644
--- a/net/mac80211/michael.c
+++ b/net/mac80211/michael.c
@@ -14,8 +14,9 @@
 
 #include "michael.h"
 
-static void michael_block(u32 *l, u32 *r)
+static void michael_block(u32 val, u32 *l, u32 *r)
 {
+	*l ^= val;
 	*r ^= rol32(*l, 17);
 	*l += *r;
 	*r ^= ((*l & 0xff00ff00) >> 8) | ((*l & 0x00ff00ff) << 8);
@@ -52,23 +53,17 @@ void michael_mic(u8 *key, u8 *da, u8 *sa, u8 priority,
 
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
@@ -78,10 +73,8 @@ void michael_mic(u8 *key, u8 *da, u8 *sa, u8 priority,
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
-- 
1.5.5.rc0.139.g9315d

