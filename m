Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.179]:63394 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753609AbYDUCgQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Apr 2008 22:36:16 -0400
Received: by wa-out-1112.google.com with SMTP id m16so2759706waf.23
        for <linux-wireless@vger.kernel.org>; Sun, 20 Apr 2008 19:36:15 -0700 (PDT)
Subject: [PATCH] mac80211: simplify code in util.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 20 Apr 2008 19:36:36 -0700
Message-Id: <1208745396.7941.14.camel@brick> (sfid-20080421_033634_222430_AF4A26F4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 net/mac80211/util.c |   11 ++++-------
 1 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index cc9f715..9960372 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -101,16 +101,13 @@ int ieee80211_get_hdrlen(u16 fc)
 	switch (fc & IEEE80211_FCTL_FTYPE) {
 	case IEEE80211_FTYPE_DATA:
 		if ((fc & IEEE80211_FCTL_FROMDS) && (fc & IEEE80211_FCTL_TODS))
-			hdrlen = 30; /* Addr4 */
+			hdrlen += ETH_ALEN; /* Addr4 */
 		/*
 		 * The QoS Control field is two bytes and its presence is
-		 * indicated by the IEEE80211_STYPE_QOS_DATA bit. Add 2 to
-		 * hdrlen if that bit is set.
-		 * This works by masking out the bit and shifting it to
-		 * bit position 1 so the result has the value 0 or 2.
+		 * indicated by the IEEE80211_STYPE_QOS_DATA bit.
 		 */
-		hdrlen += (fc & IEEE80211_STYPE_QOS_DATA)
-				>> (ilog2(IEEE80211_STYPE_QOS_DATA)-1);
+		if (fc & IEEE80211_STYPE_QOS_DATA)
+			hdrlen += 2;
 		break;
 	case IEEE80211_FTYPE_CTL:
 		/*
-- 
1.5.5.144.g3e42



