Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.231]:6983 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756165AbYCYXMu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Mar 2008 19:12:50 -0400
Received: by wr-out-0506.google.com with SMTP id c48so2532917wra.1
        for <linux-wireless@vger.kernel.org>; Tue, 25 Mar 2008 16:12:49 -0700 (PDT)
Subject: [PATCH 2/3] mac80211: michael.c use unaligned/byteorder helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 25 Mar 2008 16:12:48 -0700
Message-Id: <1206486768.26294.10.camel@brick> (sfid-20080325_231254_389021_01FE4BB6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rather than open-coding the get/put of little endian values,
use get/put_unaligned and the byteorder helpers.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 net/mac80211/michael.c |   21 +++++++++++----------
 1 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/net/mac80211/michael.c b/net/mac80211/michael.c
index e6085a3..76940be 100644
--- a/net/mac80211/michael.c
+++ b/net/mac80211/michael.c
@@ -9,6 +9,8 @@
 
 #include <linux/types.h>
 #include <linux/bitops.h>
+#include <asm/byteorder.h>
+#include <asm/unaligned.h>
 
 #include "michael.h"
 
@@ -24,21 +26,20 @@ static void michael_block(u32 *l, u32 *r)
 	*l += *r;
 }
 
-
-static inline u32 michael_get32(u8 *data)
+static u32 michael_get16(u8 *data)
 {
-	return data[0] | (data[1] << 8) | (data[2] << 16) | (data[3] << 24);
+	return le16_to_cpu(get_unaligned((__le16 *)data));
 }
 
-
-static inline void michael_put32(u32 val, u8 *data)
+static u32 michael_get32(u8 *data)
 {
-	data[0] = val & 0xff;
-	data[1] = (val >> 8) & 0xff;
-	data[2] = (val >> 16) & 0xff;
-	data[3] = (val >> 24) & 0xff;
+	return le32_to_cpu(get_unaligned((__le32 *)data));
 }
 
+static void michael_put32(u32 val, u8 *data)
+{
+	put_unaligned(cpu_to_le32(val), (__le32 *)data);
+}
 
 void michael_mic(u8 *key, u8 *da, u8 *sa, u8 priority,
 		 u8 *data, size_t data_len, u8 *mic)
@@ -53,7 +54,7 @@ void michael_mic(u8 *key, u8 *da, u8 *sa, u8 priority,
 	 * calculation, but it is _not_ transmitted */
 	l ^= michael_get32(da);
 	michael_block(&l, &r);
-	l ^= da[4] | (da[5] << 8) | (sa[0] << 16) | (sa[1] << 24);
+	l ^= michael_get16(da) | (michael_get16(sa) << 16);
 	michael_block(&l, &r);
 	l ^= michael_get32(&sa[2]);
 	michael_block(&l, &r);
-- 
1.5.5.rc0.139.g9315d


