Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.181]:37229 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbYCHJXC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Mar 2008 04:23:02 -0500
Received: by wa-out-1112.google.com with SMTP id v27so1079716wah.23
        for <linux-wireless@vger.kernel.org>; Sat, 08 Mar 2008 01:23:02 -0800 (PST)
Subject: [PATCH 1/5] mac80211: use kernel-provided bit rotation/byteordering
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Jiri Benc <jbenc@suse.cz>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 08 Mar 2008 01:22:54 -0800
Message-Id: <1204968174.23455.36.camel@brick> (sfid-20080308_092337_530827_4C02EB9D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Perhaps a bit too fine-grained of a patch series, but each one should
be pretty easily reviewable.

 include/linux/bitops.h |   40 ++++++++++++++++++++++++++++++++++++++++
 net/mac80211/michael.c |   28 ++++++----------------------
 net/mac80211/tkip.c    |   20 ++++++--------------
 3 files changed, 52 insertions(+), 36 deletions(-)

diff --git a/include/linux/bitops.h b/include/linux/bitops.h
index 69c1edb..40d5473 100644
--- a/include/linux/bitops.h
+++ b/include/linux/bitops.h
@@ -65,6 +65,46 @@ static inline __u32 ror32(__u32 word, unsigned int shift)
 	return (word >> shift) | (word << (32 - shift));
 }
 
+/**
+ * rol16 - rotate a 16-bit value left
+ * @word: value to rotate
+ * @shift: bits to roll
+ */
+static inline __u16 rol16(__u16 word, unsigned int shift)
+{
+	return (word << shift) | (word >> (16 - shift));
+}
+
+/**
+ * ror16 - rotate a 16-bit value right
+ * @word: value to rotate
+ * @shift: bits to roll
+ */
+static inline __u16 ror16(__u16 word, unsigned int shift)
+{
+	return (word >> shift) | (word << (16 - shift));
+}
+
+/**
+ * rol8 - rotate an 8-bit value left
+ * @word: value to rotate
+ * @shift: bits to roll
+ */
+static inline __u8 rol8(__u8 word, unsigned int shift)
+{
+	return (word << shift) | (word >> (8 - shift));
+}
+
+/**
+ * ror8 - rotate an 8-bit value right
+ * @word: value to rotate
+ * @shift: bits to roll
+ */
+static inline __u8 ror8(__u8 word, unsigned int shift)
+{
+	return (word >> shift) | (word << (8 - shift));
+}
+
 static inline unsigned fls_long(unsigned long l)
 {
 	if (sizeof(l) == 4)
diff --git a/net/mac80211/michael.c b/net/mac80211/michael.c
index 0f844f7..1a1871f 100644
--- a/net/mac80211/michael.c
+++ b/net/mac80211/michael.c
@@ -7,53 +7,37 @@
  * published by the Free Software Foundation.
  */
 
-#include <linux/types.h>
+#include <linux/kernel.h>
 
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
 

 static inline u32 michael_get32(u8 *data)
 {
-	return data[0] | (data[1] << 8) | (data[2] << 16) | (data[3] << 24);
+	return le32_to_cpup((__le32 *)data);
 }
 

 static inline void michael_put32(u32 val, u8 *data)
 {
-	data[0] = val & 0xff;
-	data[1] = (val >> 8) & 0xff;
-	data[2] = (val >> 16) & 0xff;
-	data[3] = (val >> 24) & 0xff;
+	*((u32 *)data) = cpu_to_le32(val);
 }
 

diff --git a/net/mac80211/tkip.c b/net/mac80211/tkip.c
index 3abe194..229b4b4 100644
--- a/net/mac80211/tkip.c
+++ b/net/mac80211/tkip.c
@@ -8,7 +8,6 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/types.h>
 #include <linux/netdevice.h>
 
 #include <net/mac80211.h>
@@ -91,13 +90,6 @@ static inline u16 Lo16(u32 v)
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
@@ -154,12 +146,12 @@ static void tkip_mixing_phase2(const u16 *p1k, const u8 *tk, u16 tsc_IV16,
 	ppk[3] += tkip_S(ppk[2] ^ Mk16(tk[ 7], tk[ 6]));
 	ppk[4] += tkip_S(ppk[3] ^ Mk16(tk[ 9], tk[ 8]));
 	ppk[5] += tkip_S(ppk[4] ^ Mk16(tk[11], tk[10]));
-	ppk[0] +=  RotR1(ppk[5] ^ Mk16(tk[13], tk[12]));
-	ppk[1] +=  RotR1(ppk[0] ^ Mk16(tk[15], tk[14]));
-	ppk[2] +=  RotR1(ppk[1]);
-	ppk[3] +=  RotR1(ppk[2]);
-	ppk[4] +=  RotR1(ppk[3]);
-	ppk[5] +=  RotR1(ppk[4]);
+	ppk[0] += ror16(ppk[5] ^ Mk16(tk[13], tk[12]), 1);
+	ppk[1] += ror16(ppk[0] ^ Mk16(tk[15], tk[14]), 1);
+	ppk[2] += ror16(ppk[1], 1);
+	ppk[3] += ror16(ppk[2], 1);
+	ppk[4] += ror16(ppk[3], 1);
+	ppk[5] += ror16(ppk[4], 1);
 
 	rc4key[0] = Hi8(tsc_IV16);
 	rc4key[1] = (Hi8(tsc_IV16) | 0x20) & 0x7f;
-- 
1.5.4.GIT


