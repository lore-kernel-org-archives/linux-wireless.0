Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rn-out-0910.google.com ([64.233.170.184]:53720 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753537AbYCSUCh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Mar 2008 16:02:37 -0400
Received: by rn-out-0910.google.com with SMTP id v46so531765rnb.15
        for <linux-wireless@vger.kernel.org>; Wed, 19 Mar 2008 13:02:35 -0700 (PDT)
Subject: [PATCH 4/5] mac80211: tkip.c eliminate the Hi16, Lo16 functions
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 18 Mar 2008 14:28:36 -0700
Message-Id: <1205875716.17607.23.camel@brick> (sfid-20080319_200348_745228_D481C5CD)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Opencode them at their one callsite.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 net/mac80211/tkip.c |   16 ++--------------
 1 files changed, 2 insertions(+), 14 deletions(-)

diff --git a/net/mac80211/tkip.c b/net/mac80211/tkip.c
index d5f8d11..a3dfa67 100644
--- a/net/mac80211/tkip.c
+++ b/net/mac80211/tkip.c
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
@@ -108,8 +96,8 @@ static void tkip_mixing_phase1(const u8 *ta, const u8 *tk, u32 tsc_IV32,
 {
 	int i, j;
 
-	p1k[0] = Lo16(tsc_IV32);
-	p1k[1] = Hi16(tsc_IV32);
+	p1k[0] = tsc_IV32 & 0xFFFF;
+	p1k[1] = tsc_IV32 >> 16;
 	p1k[2] = Mk16(ta[1], ta[0]);
 	p1k[3] = Mk16(ta[3], ta[2]);
 	p1k[4] = Mk16(ta[5], ta[4]);
-- 
1.5.4.4.684.g0e08


