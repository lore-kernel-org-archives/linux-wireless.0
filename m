Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53692 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758014AbYDRVDh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Apr 2008 17:03:37 -0400
Message-Id: <200804182059.m3IKxmv4015589@imap1.linux-foundation.org> (sfid-20080418_220856_391614_0253667B)
Subject: [patch 1/7] mac80211: tkipc.c michael.c use kernel bit rotation helpers
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, akpm@linux-foundation.org,
	harvey.harrison@gmail.com, jbenc@suse.cz, joe@perches.com,
	johannes@sipsolutions.net
From: akpm@linux-foundation.org
Date: Fri, 18 Apr 2008 13:59:48 -0700
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Harvey Harrison <harvey.harrison@gmail.com>

Use ror16, ror32, rol32 instead of a private helper.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: John W. Linville <linville@tuxdriver.com>
Cc: Joe Perches <joe@perches.com>
Cc: Jiri Benc <jbenc@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/mac80211/michael.c |   20 ++++----------------
 net/mac80211/tkip.c    |   20 +++++++-------------
 2 files changed, 11 insertions(+), 29 deletions(-)

diff -puN net/mac80211/michael.c~mac80211-tkipcc-michaelc-use-kernel-bit-rotation-helpers net/mac80211/michael.c
--- a/net/mac80211/michael.c~mac80211-tkipcc-michaelc-use-kernel-bit-rotation-helpers
+++ a/net/mac80211/michael.c
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
 
diff -puN net/mac80211/tkip.c~mac80211-tkipcc-michaelc-use-kernel-bit-rotation-helpers net/mac80211/tkip.c
--- a/net/mac80211/tkip.c~mac80211-tkipcc-michaelc-use-kernel-bit-rotation-helpers
+++ a/net/mac80211/tkip.c
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
@@ -154,12 +148,12 @@ static void tkip_mixing_phase2(const u16
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
_
