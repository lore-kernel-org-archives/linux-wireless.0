Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from el-out-1112.google.com ([209.85.162.176]:54019 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764694AbYCSVLo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Mar 2008 17:11:44 -0400
Received: by el-out-1112.google.com with SMTP id v27so495729ele.17
        for <linux-wireless@vger.kernel.org>; Wed, 19 Mar 2008 14:11:43 -0700 (PDT)
Subject: [PATCH 3/5] mac80211: tkip.c remove opencoded swab16 in tkip_S
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 18 Mar 2008 14:28:36 -0700
Message-Id: <1205875716.17607.22.camel@brick> (sfid-20080319_211155_812370_9C7DE112)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Opencode the Hi8/Lo8 and eliminate the temporary variable in
tkip_S().

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 net/mac80211/tkip.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/tkip.c b/net/mac80211/tkip.c
index f4b0c85..d5f8d11 100644
--- a/net/mac80211/tkip.c
+++ b/net/mac80211/tkip.c
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
-- 
1.5.4.4.684.g0e08


