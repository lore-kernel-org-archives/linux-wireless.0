Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.178]:37398 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308AbYCHJXG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Mar 2008 04:23:06 -0500
Received: by wa-out-1112.google.com with SMTP id v27so1079741wah.23
        for <linux-wireless@vger.kernel.org>; Sat, 08 Mar 2008 01:23:05 -0800 (PST)
Subject: [PATCH 3/5] mac80211: replace Mk16 helper with le16_to_cpup
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Jiri Benc <jbenc@suse.cz>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 08 Mar 2008 01:23:07 -0800
Message-Id: <1204968187.23455.39.camel@brick> (sfid-20080308_092339_300656_E96B3B6F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Opencoded byte-swapping could just use the kernel helper.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 net/mac80211/tkip.c |   47 ++++++++++++++++++++++-------------------------
 1 files changed, 22 insertions(+), 25 deletions(-)

diff --git a/net/mac80211/tkip.c b/net/mac80211/tkip.c
index 90c11e7..9a36e83 100644
--- a/net/mac80211/tkip.c
+++ b/net/mac80211/tkip.c
@@ -60,13 +60,6 @@ static const u16 tkip_sbox[256] =
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
@@ -107,20 +100,22 @@ static void tkip_mixing_phase1(const u8 *ta, const u8 *tk, u32 tsc_IV32,
 			       u16 *p1k)
 {
 	int i, j;
+	__le16 *leptr = (__le16 *)ta;
 
 	p1k[0] = Lo16(tsc_IV32);
 	p1k[1] = Hi16(tsc_IV32);
-	p1k[2] = Mk16(ta[1], ta[0]);
-	p1k[3] = Mk16(ta[3], ta[2]);
-	p1k[4] = Mk16(ta[5], ta[4]);
+	p1k[2] = le16_to_cpup(leptr++);
+	p1k[3] = le16_to_cpup(leptr++);
+	p1k[4] = le16_to_cpup(leptr++);
 
+	leptr = (__le16 *)tk;
 	for (i = 0; i < PHASE1_LOOP_COUNT; i++) {
-		j = 2 * (i & 1);
-		p1k[0] += tkip_S(p1k[4] ^ Mk16(tk[ 1 + j], tk[ 0 + j]));
-		p1k[1] += tkip_S(p1k[0] ^ Mk16(tk[ 5 + j], tk[ 4 + j]));
-		p1k[2] += tkip_S(p1k[1] ^ Mk16(tk[ 9 + j], tk[ 8 + j]));
-		p1k[3] += tkip_S(p1k[2] ^ Mk16(tk[13 + j], tk[12 + j]));
-		p1k[4] += tkip_S(p1k[3] ^ Mk16(tk[ 1 + j], tk[ 0 + j])) + i;
+		j = (i & 1);
+		p1k[0] += tkip_S(p1k[4] ^ le16_to_cpup(leptr + 0 + j));
+		p1k[1] += tkip_S(p1k[0] ^ le16_to_cpup(leptr + 2 + j));
+		p1k[2] += tkip_S(p1k[1] ^ le16_to_cpup(leptr + 4 + j));
+		p1k[3] += tkip_S(p1k[2] ^ le16_to_cpup(leptr + 6 + j));
+		p1k[4] += tkip_S(p1k[3] ^ le16_to_cpup(leptr + 0 + j)) + i;
 	}
 }
 
@@ -130,6 +125,7 @@ static void tkip_mixing_phase2(const u16 *p1k, const u8 *tk, u16 tsc_IV16,
 {
 	u16 ppk[6];
 	int i;
+	__le16 *leptr = (__le16 *)tk;
 
 	ppk[0] = p1k[0];
 	ppk[1] = p1k[1];
@@ -138,23 +134,24 @@ static void tkip_mixing_phase2(const u16 *p1k, const u8 *tk, u16 tsc_IV16,
 	ppk[4] = p1k[4];
 	ppk[5] = p1k[4] + tsc_IV16;
 
-	ppk[0] += tkip_S(ppk[5] ^ Mk16(tk[ 1], tk[ 0]));
-	ppk[1] += tkip_S(ppk[0] ^ Mk16(tk[ 3], tk[ 2]));
-	ppk[2] += tkip_S(ppk[1] ^ Mk16(tk[ 5], tk[ 4]));
-	ppk[3] += tkip_S(ppk[2] ^ Mk16(tk[ 7], tk[ 6]));
-	ppk[4] += tkip_S(ppk[3] ^ Mk16(tk[ 9], tk[ 8]));
-	ppk[5] += tkip_S(ppk[4] ^ Mk16(tk[11], tk[10]));
-	ppk[0] += ror16(ppk[5] ^ Mk16(tk[13], tk[12]), 1);
-	ppk[1] += ror16(ppk[0] ^ Mk16(tk[15], tk[14]), 1);
+	ppk[0] += tkip_S(ppk[5] ^ le16_to_cpup(leptr++));
+	ppk[1] += tkip_S(ppk[0] ^ le16_to_cpup(leptr++));
+	ppk[2] += tkip_S(ppk[1] ^ le16_to_cpup(leptr++));
+	ppk[3] += tkip_S(ppk[2] ^ le16_to_cpup(leptr++));
+	ppk[4] += tkip_S(ppk[3] ^ le16_to_cpup(leptr++));
+	ppk[5] += tkip_S(ppk[4] ^ le16_to_cpup(leptr++));
+	ppk[0] += ror16(ppk[5] ^ le16_to_cpup(leptr++), 1);
+	ppk[1] += ror16(ppk[0] ^ le16_to_cpup(leptr++), 1);
 	ppk[2] += ror16(ppk[1], 1);
 	ppk[3] += ror16(ppk[2], 1);
 	ppk[4] += ror16(ppk[3], 1);
 	ppk[5] += ror16(ppk[4], 1);
 
+	leptr = (__le16 *)tk;
 	rc4key[0] = Hi8(tsc_IV16);
 	rc4key[1] = (Hi8(tsc_IV16) | 0x20) & 0x7f;
 	rc4key[2] = Lo8(tsc_IV16);
-	rc4key[3] = Lo8((ppk[5] ^ Mk16(tk[1], tk[0])) >> 1);
+	rc4key[3] = Lo8((ppk[5] ^ le16_to_cpup(leptr)) >> 1);
 
 	for (i = 0; i < 6; i++) {
 		rc4key[4 + 2 * i] = Lo8(ppk[i]);
-- 
1.5.4.GIT


