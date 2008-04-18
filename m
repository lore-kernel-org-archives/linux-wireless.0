Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52279 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763021AbYDRVD7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Apr 2008 17:03:59 -0400
Message-Id: <200804182059.m3IKxp3V015598@imap1.linux-foundation.org> (sfid-20080418_220904_482077_6EB2282D)
Subject: [patch 4/7] mac80211: tkip.c remove Mk16, Hi8, Lo8 helpers
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, akpm@linux-foundation.org,
	harvey.harrison@gmail.com, jbenc@suse.cz, joe@perches.com,
	johannes@sipsolutions.net
From: akpm@linux-foundation.org
Date: Fri, 18 Apr 2008 13:59:50 -0700
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Harvey Harrison <harvey.harrison@gmail.com>

Create a new getle16 helper to replace Mk16 that deals with unaligned access. 
Also, use put_unaligned when writing out the rc4key result.  Opencode the few
remaining Hi8/Lo8 calls and remove the helpers.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: John W. Linville <linville@tuxdriver.com>
Cc: Joe Perches <joe@perches.com>
Cc: Jiri Benc <jbenc@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/mac80211/tkip.c |   70 ++++++++++++++++++------------------------
 1 file changed, 31 insertions(+), 39 deletions(-)

diff -puN net/mac80211/tkip.c~mac80211-tkipc-remove-mk16-hi8-lo8-helpers net/mac80211/tkip.c
--- a/net/mac80211/tkip.c~mac80211-tkipc-remove-mk16-hi8-lo8-helpers
+++ a/net/mac80211/tkip.c
@@ -11,6 +11,7 @@
 #include <linux/bitops.h>
 #include <linux/types.h>
 #include <linux/netdevice.h>
+#include <asm/unaligned.h>
 
 #include <net/mac80211.h>
 #include "key.h"
@@ -63,21 +64,13 @@ static const u16 tkip_sbox[256] =
 };
 
 
-static inline u16 Mk16(u8 x, u8 y)
-{
-	return ((u16) x << 8) | (u16) y;
-}
-
-
-static inline u8 Hi8(u16 v)
-{
-	return v >> 8;
-}
-
-
-static inline u8 Lo8(u16 v)
+/*
+ * Get a cpu-byteorder u16 from a u8 pointer fixing up possible unaligned
+ * accesses.
+ */
+static inline u16 getle16(const u8 *x)
 {
-	return v & 0xff;
+	return le16_to_cpu(get_unaligned((__le16 *)x));
 }
 
 static inline u16 tkip_S(u16 val)
@@ -98,17 +91,17 @@ static void tkip_mixing_phase1(const u8 
 
 	p1k[0] = tsc_IV32 & 0xFFFF;
 	p1k[1] = tsc_IV32 >> 16;
-	p1k[2] = Mk16(ta[1], ta[0]);
-	p1k[3] = Mk16(ta[3], ta[2]);
-	p1k[4] = Mk16(ta[5], ta[4]);
+	p1k[2] = getle16(ta + 0);
+	p1k[3] = getle16(ta + 2);
+	p1k[4] = getle16(ta + 4);
 
 	for (i = 0; i < PHASE1_LOOP_COUNT; i++) {
 		j = 2 * (i & 1);
-		p1k[0] += tkip_S(p1k[4] ^ Mk16(tk[ 1 + j], tk[ 0 + j]));
-		p1k[1] += tkip_S(p1k[0] ^ Mk16(tk[ 5 + j], tk[ 4 + j]));
-		p1k[2] += tkip_S(p1k[1] ^ Mk16(tk[ 9 + j], tk[ 8 + j]));
-		p1k[3] += tkip_S(p1k[2] ^ Mk16(tk[13 + j], tk[12 + j]));
-		p1k[4] += tkip_S(p1k[3] ^ Mk16(tk[ 1 + j], tk[ 0 + j])) + i;
+		p1k[0] += tkip_S(p1k[4] ^ getle16(tk + 0 + j));
+		p1k[1] += tkip_S(p1k[0] ^ getle16(tk + 4 + j));
+		p1k[2] += tkip_S(p1k[1] ^ getle16(tk + 8 + j));
+		p1k[3] += tkip_S(p1k[2] ^ getle16(tk + 12 + j));
+		p1k[4] += tkip_S(p1k[3] ^ getle16(tk + 0 + j)) + i;
 	}
 }
 
@@ -126,28 +119,27 @@ static void tkip_mixing_phase2(const u16
 	ppk[4] = p1k[4];
 	ppk[5] = p1k[4] + tsc_IV16;
 
-	ppk[0] += tkip_S(ppk[5] ^ Mk16(tk[ 1], tk[ 0]));
-	ppk[1] += tkip_S(ppk[0] ^ Mk16(tk[ 3], tk[ 2]));
-	ppk[2] += tkip_S(ppk[1] ^ Mk16(tk[ 5], tk[ 4]));
-	ppk[3] += tkip_S(ppk[2] ^ Mk16(tk[ 7], tk[ 6]));
-	ppk[4] += tkip_S(ppk[3] ^ Mk16(tk[ 9], tk[ 8]));
-	ppk[5] += tkip_S(ppk[4] ^ Mk16(tk[11], tk[10]));
-	ppk[0] +=  ror16(ppk[5] ^ Mk16(tk[13], tk[12]), 1);
-	ppk[1] +=  ror16(ppk[0] ^ Mk16(tk[15], tk[14]), 1);
+	ppk[0] += tkip_S(ppk[5] ^ getle16(tk + 0));
+	ppk[1] += tkip_S(ppk[0] ^ getle16(tk + 2));
+	ppk[2] += tkip_S(ppk[1] ^ getle16(tk + 4));
+	ppk[3] += tkip_S(ppk[2] ^ getle16(tk + 6));
+	ppk[4] += tkip_S(ppk[3] ^ getle16(tk + 8));
+	ppk[5] += tkip_S(ppk[4] ^ getle16(tk + 10));
+	ppk[0] +=  ror16(ppk[5] ^ getle16(tk + 12), 1);
+	ppk[1] +=  ror16(ppk[0] ^ getle16(tk + 14), 1);
 	ppk[2] +=  ror16(ppk[1], 1);
 	ppk[3] +=  ror16(ppk[2], 1);
 	ppk[4] +=  ror16(ppk[3], 1);
 	ppk[5] +=  ror16(ppk[4], 1);
 
-	rc4key[0] = Hi8(tsc_IV16);
-	rc4key[1] = (Hi8(tsc_IV16) | 0x20) & 0x7f;
-	rc4key[2] = Lo8(tsc_IV16);
-	rc4key[3] = Lo8((ppk[5] ^ Mk16(tk[1], tk[0])) >> 1);
-
-	for (i = 0; i < 6; i++) {
-		rc4key[4 + 2 * i] = Lo8(ppk[i]);
-		rc4key[5 + 2 * i] = Hi8(ppk[i]);
-	}
+	rc4key[0] = tsc_IV16 >> 8;
+	rc4key[1] = ((tsc_IV16 >> 8) | 0x20) & 0x7f;
+	rc4key[2] = tsc_IV16 & 0xFF;
+	rc4key[3] = ((ppk[5] ^ getle16(tk)) >> 1) & 0xFF;
+
+	rc4key += 4;
+	for (i = 0; i < 6; i++)
+		put_unaligned(cpu_to_le16(ppk[i]), (__le16 *)rc4key + i);
 }
 
 
_
