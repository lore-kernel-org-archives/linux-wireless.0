Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43998 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762987AbYDRVDr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Apr 2008 17:03:47 -0400
Message-Id: <200804182059.m3IKxo5P015595@imap1.linux-foundation.org> (sfid-20080418_220849_051754_212957D5)
Subject: [patch 3/7] mac80211: tkip.c eliminate the Hi16, Lo16 functions
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, akpm@linux-foundation.org,
	harvey.harrison@gmail.com, jbenc@suse.cz, joe@perches.com,
	johannes@sipsolutions.net
From: akpm@linux-foundation.org
Date: Fri, 18 Apr 2008 13:59:49 -0700
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Harvey Harrison <harvey.harrison@gmail.com>

Opencode them at their one callsite.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: John W. Linville <linville@tuxdriver.com>
Cc: Joe Perches <joe@perches.com>
Cc: Jiri Benc <jbenc@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/mac80211/tkip.c |   16 ++--------------
 1 file changed, 2 insertions(+), 14 deletions(-)

diff -puN net/mac80211/tkip.c~mac80211-tkipc-eliminate-the-hi16-lo16-functions net/mac80211/tkip.c
--- a/net/mac80211/tkip.c~mac80211-tkipc-eliminate-the-hi16-lo16-functions
+++ a/net/mac80211/tkip.c
@@ -80,18 +80,6 @@ static inline u8 Lo8(u16 v)
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
 static inline u16 tkip_S(u16 val)
 {
 	return tkip_sbox[val & 0xff] ^ swab16(tkip_sbox[val >> 8]);
@@ -108,8 +96,8 @@ static void tkip_mixing_phase1(const u8 
 {
 	int i, j;
 
-	p1k[0] = Lo16(tsc_IV32);
-	p1k[1] = Hi16(tsc_IV32);
+	p1k[0] = tsc_IV32 & 0xFFFF;
+	p1k[1] = tsc_IV32 >> 16;
 	p1k[2] = Mk16(ta[1], ta[0]);
 	p1k[3] = Mk16(ta[3], ta[2]);
 	p1k[4] = Mk16(ta[5], ta[4]);
_
