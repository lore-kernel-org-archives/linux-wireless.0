Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:40138 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569AbYDMIMy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Apr 2008 04:12:54 -0400
Subject: [PATCH] mac80211: remove message on receiving unexpected
	unencrypted frames
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Miles Lane <miles.lane@gmail.com>
Content-Type: text/plain
Date: Sun, 13 Apr 2008 10:12:47 +0200
Message-Id: <1208074367.4111.19.camel@johannes.berg> (sfid-20080413_091257_937840_AF6FF650)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some people are getting this message a lot, and we have traced it to
broken access points that much too often send completely empty frames
(all bytes zeroed, which they shouldn't do at all.)

Since we cannot do anything about such frames in any case except the
special case where we're debugging an AP, just remove the message.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
2.6.25 or -stable candidate.

 net/mac80211/rx.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- everything.orig/net/mac80211/rx.c	2008-04-13 10:07:47.000000000 +0200
+++ everything/net/mac80211/rx.c	2008-04-13 10:09:50.000000000 +0200
@@ -1078,12 +1078,9 @@ ieee80211_drop_unencrypted(struct ieee80
 	if (unlikely(!(rx->fc & IEEE80211_FCTL_PROTECTED) &&
 		     (rx->fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_DATA &&
 		     (rx->fc & IEEE80211_FCTL_STYPE) != IEEE80211_STYPE_NULLFUNC &&
-		     (rx->key || rx->sdata->drop_unencrypted))) {
-		if (net_ratelimit())
-			printk(KERN_DEBUG "%s: RX non-WEP frame, but expected "
-			       "encryption\n", rx->dev->name);
+		     (rx->key || rx->sdata->drop_unencrypted)))
 		return -EACCES;
-	}
+
 	return 0;
 }
 


