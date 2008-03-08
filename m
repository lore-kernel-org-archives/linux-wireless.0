Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.188]:45056 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369AbYCHJXH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Mar 2008 04:23:07 -0500
Received: by rv-out-0910.google.com with SMTP id k20so492991rvb.1
        for <linux-wireless@vger.kernel.org>; Sat, 08 Mar 2008 01:23:06 -0800 (PST)
Subject: [PATCH 4/5] mac80211: remove Hi16, Lo16 helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Jiri Benc <jbenc@suse.cz>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 08 Mar 2008 01:23:08 -0800
Message-Id: <1204968188.23455.40.camel@brick> (sfid-20080308_092338_480606_A4DDBE10)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

They were only used in one place, just open-code it there.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 net/mac80211/tkip.c |   19 ++-----------------
 1 files changed, 2 insertions(+), 17 deletions(-)

diff --git a/net/mac80211/tkip.c b/net/mac80211/tkip.c
index 9a36e83..264e392 100644
--- a/net/mac80211/tkip.c
+++ b/net/mac80211/tkip.c
@@ -65,31 +65,16 @@ static inline u8 Hi8(u16 v)
 	return v >> 8;
 }
 
-
 static inline u8 Lo8(u16 v)
 {
 	return v & 0xff;
 }
 
-
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
 static u16 tkip_S(u16 val)
 {
 	return tkip_sbox[val & 0xff] ^ swab16(tkip_sbox[val >> 8]);
 }
 
-
-
 /* P1K := Phase1(TA, TK, TSC)
  * TA = transmitter address (48 bits)
  * TK = dot11DefaultKeyValue or dot11KeyMappingValue (128 bits)
@@ -102,8 +87,8 @@ static void tkip_mixing_phase1(const u8 *ta, const u8 *tk, u32 tsc_IV32,
 	int i, j;
 	__le16 *leptr = (__le16 *)ta;
 
-	p1k[0] = Lo16(tsc_IV32);
-	p1k[1] = Hi16(tsc_IV32);
+	p1k[0] = tsc_IV32 & 0xffff;
+	p1k[1] = tsc_IV32 >> 16;
 	p1k[2] = le16_to_cpup(leptr++);
 	p1k[3] = le16_to_cpup(leptr++);
 	p1k[4] = le16_to_cpup(leptr++);
-- 
1.5.4.GIT


