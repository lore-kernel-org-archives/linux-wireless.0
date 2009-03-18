Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35271 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758214AbZCRNaN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Mar 2009 09:30:13 -0400
Subject: [PATCH] mac80211: kill IEEE80211_CONF_SHORT_SLOT_TIME
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 18 Mar 2009 14:29:38 +0100
Message-Id: <1237382979.5100.22.camel@johannes.local> (sfid-20090318_143033_611527_6AEFB6BF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

No drivers use it any more, so it can now be removed safely.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/net/mac80211.h |    6 ------
 1 file changed, 6 deletions(-)

--- wireless-testing.orig/include/net/mac80211.h	2009-03-18 14:28:46.000000000 +0100
+++ wireless-testing/include/net/mac80211.h	2009-03-18 14:28:51.000000000 +0100
@@ -521,12 +521,6 @@ enum ieee80211_conf_flags {
 	IEEE80211_CONF_PS		= (1<<1),
 };
 
-/* XXX: remove all this once drivers stop trying to use it */
-static inline int __deprecated __IEEE80211_CONF_SHORT_SLOT_TIME(void)
-{
-	return 0;
-}
-#define IEEE80211_CONF_SHORT_SLOT_TIME (__IEEE80211_CONF_SHORT_SLOT_TIME())
 
 /**
  * enum ieee80211_conf_changed - denotes which configuration changed


