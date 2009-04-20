Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35814 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752250AbZDTXhd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Apr 2009 19:37:33 -0400
Subject: [PATCH 2.6.30] mac80211: fix alignment calculation bug
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 21 Apr 2009 01:36:59 +0200
Message-Id: <1240270619.17388.2.camel@johannes.local> (sfid-20090421_013736_637428_564412CA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When checking whether or not a given frame needs to be
moved to be properly aligned to a 4-byte boundary, we
use & 4 which wasn't intended, this code should check
the lowest two bits.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/rx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- wireless-testing.orig/net/mac80211/rx.c	2009-04-21 01:32:59.000000000 +0200
+++ wireless-testing/net/mac80211/rx.c	2009-04-21 01:33:22.000000000 +0200
@@ -1397,7 +1397,7 @@ ieee80211_deliver_skb(struct ieee80211_r
 		 * mac80211. That also explains the __skb_push()
 		 * below.
 		 */
-		align = (unsigned long)skb->data & 4;
+		align = (unsigned long)skb->data & 3;
 		if (align) {
 			if (WARN_ON(skb_headroom(skb) < 3)) {
 				dev_kfree_skb(skb);


