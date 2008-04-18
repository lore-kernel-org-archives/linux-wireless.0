Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39220 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757974AbYDRVDk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Apr 2008 17:03:40 -0400
Message-Id: <200804182059.m3IKxqcu015604@imap1.linux-foundation.org> (sfid-20080418_220915_541595_29B119CB)
Subject: [patch 6/7] mac80211: michael.c use unaligned/byteorder helpers
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, akpm@linux-foundation.org,
	harvey.harrison@gmail.com, jbenc@suse.cz
From: akpm@linux-foundation.org
Date: Fri, 18 Apr 2008 13:59:52 -0700
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Harvey Harrison <harvey.harrison@gmail.com>

Rather than open-coding the get/put of little endian values, use
get/put_unaligned and the byteorder helpers.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Jiri Benc <jbenc@suse.cz>
Cc: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/mac80211/michael.c |   21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff -puN net/mac80211/michael.c~mac80211-michaelc-use-unaligned-byteorder-helpers net/mac80211/michael.c
--- a/net/mac80211/michael.c~mac80211-michaelc-use-unaligned-byteorder-helpers
+++ a/net/mac80211/michael.c
@@ -9,6 +9,8 @@
 
 #include <linux/types.h>
 #include <linux/bitops.h>
+#include <asm/byteorder.h>
+#include <asm/unaligned.h>
 
 #include "michael.h"
 
@@ -24,21 +26,20 @@ static void michael_block(u32 *l, u32 *r
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
@@ -53,7 +54,7 @@ void michael_mic(u8 *key, u8 *da, u8 *sa
 	 * calculation, but it is _not_ transmitted */
 	l ^= michael_get32(da);
 	michael_block(&l, &r);
-	l ^= da[4] | (da[5] << 8) | (sa[0] << 16) | (sa[1] << 24);
+	l ^= michael_get16(da) | (michael_get16(sa) << 16);
 	michael_block(&l, &r);
 	l ^= michael_get32(&sa[2]);
 	michael_block(&l, &r);
_
