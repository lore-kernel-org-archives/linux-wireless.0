Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48499 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762002AbYDRVDz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Apr 2008 17:03:55 -0400
Message-Id: <200804182059.m3IKxn5E015592@imap1.linux-foundation.org> (sfid-20080418_220857_491657_F3845634)
Subject: [patch 2/7] mac80211: tkip.c remove opencoded swab16 in tkip_S
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, akpm@linux-foundation.org,
	harvey.harrison@gmail.com, jbenc@suse.cz, joe@perches.com,
	johannes@sipsolutions.net
From: akpm@linux-foundation.org
Date: Fri, 18 Apr 2008 13:59:49 -0700
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Harvey Harrison <harvey.harrison@gmail.com>

Opencode the Hi8/Lo8 and eliminate the temporary variable in tkip_S().

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: John W. Linville <linville@tuxdriver.com>
Cc: Joe Perches <joe@perches.com>
Cc: Jiri Benc <jbenc@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/mac80211/tkip.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff -puN net/mac80211/tkip.c~mac80211-tkipc-remove-opencoded-swab16-in-tkip_s net/mac80211/tkip.c
--- a/net/mac80211/tkip.c~mac80211-tkipc-remove-opencoded-swab16-in-tkip_s
+++ a/net/mac80211/tkip.c
@@ -94,13 +94,9 @@ static inline u16 Lo16(u32 v)
 
 static inline u16 tkip_S(u16 val)
 {
-	u16 a = tkip_sbox[Hi8(val)];
-
-	return tkip_sbox[Lo8(val)] ^ Hi8(a) ^ (Lo8(a) << 8);
+	return tkip_sbox[val & 0xff] ^ swab16(tkip_sbox[val >> 8]);
 }
 
-
-
 /* P1K := Phase1(TA, TK, TSC)
  * TA = transmitter address (48 bits)
  * TK = dot11DefaultKeyValue or dot11KeyMappingValue (128 bits)
_
