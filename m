Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.176]:7999 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754868AbYCHDRl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Mar 2008 22:17:41 -0500
Received: by wa-out-1112.google.com with SMTP id v27so949343wah.23
        for <linux-wireless@vger.kernel.org>; Fri, 07 Mar 2008 19:17:40 -0800 (PST)
Subject: [PATCH 2/2] tkip: remove inlines duplicating byteorder macros
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Jiri Benc <jbenc@suse.cz>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 07 Mar 2008 19:17:30 -0800
Message-Id: <1204946250.23455.21.camel@brick> (sfid-20080308_031804_956918_5BE9DD31)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Also remove Hi16/Lo16 and open code them in the one place they
are used.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 net/mac80211/tkip.c |   63 +++++++++++++++++++-------------------------------
 1 files changed, 24 insertions(+), 39 deletions(-)

diff --git a/net/mac80211/tkip.c b/net/mac80211/tkip.c
index d08a6d8..eac8a9c 100644
--- a/net/mac80211/tkip.c
+++ b/net/mac80211/tkip.c
@@ -61,13 +61,6 @@ static const u16 tkip_sbox[256] =
 	0x82C3, 0x29B0, 0x5A77, 0x1E11, 0x7BCB, 0xA8FC, 0x6DD6, 0x2C3A,
 };
 
-
-static inline u16 Mk16(u8 x, u8 y)
-{
-	return ((u16) x << 8) | (u16) y;
-}
-
-
 static inline u8 Hi8(u16 v)
 {
 	return v >> 8;
@@ -80,18 +73,6 @@ static inline u8 Lo8(u16 v)
 }
 

-static inline u16 Hi16(u32 v)
-{
-	return v >> 16;
-}
-
-
-static inline u16 Lo16(u32 v)
-{
-	return v & 0xffff;
-}
-
-
 static inline u16 RotR1(u16 v)
 {
 	return (v >> 1) | ((v & 0x0001) << 15);
@@ -113,20 +94,23 @@ static void tkip_mixing_phase1(const u8 *ta, const u8 *tk, u32 tsc_IV32,
 			       u16 *p1k)
 {
 	int i, j;
+	__le16 *ptr = (__le16 *)ta; /* address is held in LE byteorder */
+
+	p1k[0] = tsc_IV32 & 0xffff;
+	p1k[1] = tsc_IV32 >> 16;
+	p1k[2] = __le16_to_cpup(ptr++);
+	p1k[3] = __le16_to_cpup(ptr++);
+	p1k[4] = __le16_to_cpup(ptr);
 
-	p1k[0] = Lo16(tsc_IV32);
-	p1k[1] = Hi16(tsc_IV32);
-	p1k[2] = Mk16(ta[1], ta[0]);
-	p1k[3] = Mk16(ta[3], ta[2]);
-	p1k[4] = Mk16(ta[5], ta[4]);
 
+	ptr = (__le16 *)tk;
 	for (i = 0; i < PHASE1_LOOP_COUNT; i++) {
-		j = 2 * (i & 1);
-		p1k[0] += tkip_S(p1k[4] ^ Mk16(tk[ 1 + j], tk[ 0 + j]));
-		p1k[1] += tkip_S(p1k[0] ^ Mk16(tk[ 5 + j], tk[ 4 + j]));
-		p1k[2] += tkip_S(p1k[1] ^ Mk16(tk[ 9 + j], tk[ 8 + j]));
-		p1k[3] += tkip_S(p1k[2] ^ Mk16(tk[13 + j], tk[12 + j]));
-		p1k[4] += tkip_S(p1k[3] ^ Mk16(tk[ 1 + j], tk[ 0 + j])) + i;
+		j = (i & 1);
+		p1k[0] += tkip_S(p1k[4] ^ __le16_to_cpup(ptr + 0 + j));
+		p1k[1] += tkip_S(p1k[0] ^ __le16_to_cpup(ptr + 2 + j));
+		p1k[2] += tkip_S(p1k[1] ^ __le16_to_cpup(ptr + 4 + j));
+		p1k[3] += tkip_S(p1k[2] ^ __le16_to_cpup(ptr + 6 + j));
+		p1k[4] += tkip_S(p1k[3] ^ __le16_to_cpup(ptr + 0 + j)) + i;
 	}
 }
 
@@ -135,6 +119,7 @@ static void tkip_mixing_phase2(const u16 *p1k, const u8 *tk, u16 tsc_IV16,
 			       u8 *rc4key)
 {
 	u16 ppk[6];
+	const __le16 *ptr = (__le16 *)tk;
 	int i;
 
 	ppk[0] = p1k[0];
@@ -144,14 +129,14 @@ static void tkip_mixing_phase2(const u16 *p1k, const u8 *tk, u16 tsc_IV16,
 	ppk[4] = p1k[4];
 	ppk[5] = p1k[4] + tsc_IV16;
 
-	ppk[0] += tkip_S(ppk[5] ^ Mk16(tk[ 1], tk[ 0]));
-	ppk[1] += tkip_S(ppk[0] ^ Mk16(tk[ 3], tk[ 2]));
-	ppk[2] += tkip_S(ppk[1] ^ Mk16(tk[ 5], tk[ 4]));
-	ppk[3] += tkip_S(ppk[2] ^ Mk16(tk[ 7], tk[ 6]));
-	ppk[4] += tkip_S(ppk[3] ^ Mk16(tk[ 9], tk[ 8]));
-	ppk[5] += tkip_S(ppk[4] ^ Mk16(tk[11], tk[10]));
-	ppk[0] +=  RotR1(ppk[5] ^ Mk16(tk[13], tk[12]));
-	ppk[1] +=  RotR1(ppk[0] ^ Mk16(tk[15], tk[14]));
+	ppk[0] += tkip_S(ppk[5] ^ __le16_to_cpup(ptr++));
+	ppk[1] += tkip_S(ppk[0] ^ __le16_to_cpup(ptr++));
+	ppk[2] += tkip_S(ppk[1] ^ __le16_to_cpup(ptr++));
+	ppk[3] += tkip_S(ppk[2] ^ __le16_to_cpup(ptr++));
+	ppk[4] += tkip_S(ppk[3] ^ __le16_to_cpup(ptr++));
+	ppk[5] += tkip_S(ppk[4] ^ __le16_to_cpup(ptr++));
+	ppk[0] +=  RotR1(ppk[5] ^ __le16_to_cpup(ptr++));
+	ppk[1] +=  RotR1(ppk[0] ^ __le16_to_cpup(ptr));
 	ppk[2] +=  RotR1(ppk[1]);
 	ppk[3] +=  RotR1(ppk[2]);
 	ppk[4] +=  RotR1(ppk[3]);
@@ -160,7 +145,7 @@ static void tkip_mixing_phase2(const u16 *p1k, const u8 *tk, u16 tsc_IV16,
 	rc4key[0] = Hi8(tsc_IV16);
 	rc4key[1] = (Hi8(tsc_IV16) | 0x20) & 0x7f;
 	rc4key[2] = Lo8(tsc_IV16);
-	rc4key[3] = Lo8((ppk[5] ^ Mk16(tk[1], tk[0])) >> 1);
+	rc4key[3] = Lo8((ppk[5] ^ __le16_to_cpup((__le16 *)tk)) >> 1);
 
 	for (i = 0; i < 6; i++) {
 		rc4key[4 + 2 * i] = Lo8(ppk[i]);
-- 
1.5.4.GIT

