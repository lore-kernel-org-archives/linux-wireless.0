Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.177]:33668 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161471AbYCSWEf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Mar 2008 18:04:35 -0400
Received: by wa-out-1112.google.com with SMTP id v27so661596wah.23
        for <linux-wireless@vger.kernel.org>; Wed, 19 Mar 2008 15:04:34 -0700 (PDT)
Subject: [PATCH-mm 1/5] mac80211: tkipc.c michael.c use kernel bit rotation
	helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 18 Mar 2008 14:28:33 -0700
Message-Id: <1205875713.17607.20.camel@brick> (sfid-20080319_220610_238682_18B7BABD)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use ror16, ror32, rol32 instead of a private helper.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Depends on patch submitted to -mm adding the 8 bit/16 bit
helpers.

 net/mac80211/michael.c |   20 ++++----------------
 net/mac80211/tkip.c    |   20 +++++++-------------
 2 files changed, 11 insertions(+), 29 deletions(-)

diff --git a/net/mac80211/michael.c b/net/mac80211/michael.c
index 0f844f7..c2c10d3 100644
--- a/net/mac80211/michael.c
+++ b/net/mac80211/michael.c
@@ -8,36 +8,24 @@
  */
 
 #include <linux/types.h>
+#include <linux/bitops.h>
 
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
 static inline u32 xswap(u32 val)
 {
 	return ((val & 0xff00ff00) >> 8) | ((val & 0x00ff00ff) << 8);
 }
 
-
 #define michael_block(l, r) \
 do { \
-	r ^= rotl(l, 17); \
+	r ^= rol32(l, 17); \
 	l += r; \
 	r ^= xswap(l); \
 	l += r; \
-	r ^= rotl(l, 3); \
+	r ^= rol32(l, 3); \
 	l += r; \
-	r ^= rotr(l, 2); \
+	r ^= ror32(l, 2); \
 	l += r; \
 } while (0)
 
diff --git a/net/mac80211/tkip.c b/net/mac80211/tkip.c
index 3abe194..a5745c1 100644
--- a/net/mac80211/tkip.c
+++ b/net/mac80211/tkip.c
@@ -8,6 +8,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/bitops.h>
 #include <linux/types.h>
 #include <linux/netdevice.h>
 
@@ -91,13 +92,6 @@ static inline u16 Lo16(u32 v)
 	return v & 0xffff;
 }
 
-
-static inline u16 RotR1(u16 v)
-{
-	return (v >> 1) | ((v & 0x0001) << 15);
-}
-
-
 static inline u16 tkip_S(u16 val)
 {
 	u16 a = tkip_sbox[Hi8(val)];
@@ -154,12 +148,12 @@ static void tkip_mixing_phase2(const u16 *p1k, const u8 *tk, u16 tsc_IV16,
 	ppk[3] += tkip_S(ppk[2] ^ Mk16(tk[ 7], tk[ 6]));
 	ppk[4] += tkip_S(ppk[3] ^ Mk16(tk[ 9], tk[ 8]));
 	ppk[5] += tkip_S(ppk[4] ^ Mk16(tk[11], tk[10]));
-	ppk[0] +=  RotR1(ppk[5] ^ Mk16(tk[13], tk[12]));
-	ppk[1] +=  RotR1(ppk[0] ^ Mk16(tk[15], tk[14]));
-	ppk[2] +=  RotR1(ppk[1]);
-	ppk[3] +=  RotR1(ppk[2]);
-	ppk[4] +=  RotR1(ppk[3]);
-	ppk[5] +=  RotR1(ppk[4]);
+	ppk[0] +=  ror16(ppk[5] ^ Mk16(tk[13], tk[12]), 1);
+	ppk[1] +=  ror16(ppk[0] ^ Mk16(tk[15], tk[14]), 1);
+	ppk[2] +=  ror16(ppk[1], 1);
+	ppk[3] +=  ror16(ppk[2], 1);
+	ppk[4] +=  ror16(ppk[3], 1);
+	ppk[5] +=  ror16(ppk[4], 1);
 
 	rc4key[0] = Hi8(tsc_IV16);
 	rc4key[1] = (Hi8(tsc_IV16) | 0x20) & 0x7f;
-- 
1.5.4.4.684.g0e08


