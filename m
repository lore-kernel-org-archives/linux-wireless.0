Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45784 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398Ab0JFTSG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Oct 2010 15:18:06 -0400
Subject: [PATCH] cfg80211: fix BSS double-unlinking
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Ben Greear <greearb@candelatech.com>,
	Hun-Kyi Wynn <hkwynn@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Oct 2010 21:18:04 +0200
Message-ID: <1286392684.3655.409.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When multiple interfaces are actively trying
to associate with the same BSS, they may both
find that the BSS isn't there and then try to
unlink it. This can cause errors since the
unlinking code can't currently deal with items
that have already been unlinked.

Normally this doesn't happen as most people
don't try to use multiple station interfaces
that associate at the same time too.

Fix this by using the list entry as a flag to
see if the item is still on a list.

Cc: stable@kernel.org
Reported-by: Ben Greear <greearb@candelatech.com>
Tested-by: Hun-Kyi Wynn <hkwynn@candelatech.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/scan.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- wireless-testing.orig/net/wireless/scan.c	2010-10-06 20:41:16.000000000 +0200
+++ wireless-testing/net/wireless/scan.c	2010-10-06 20:41:38.000000000 +0200
@@ -650,14 +650,14 @@ void cfg80211_unlink_bss(struct wiphy *w
 	bss = container_of(pub, struct cfg80211_internal_bss, pub);
 
 	spin_lock_bh(&dev->bss_lock);
+	if (!list_empty(&bss->list)) {
+		list_del_init(&bss->list);
+		dev->bss_generation++;
+		rb_erase(&bss->rbn, &dev->bss_tree);
 
-	list_del(&bss->list);
-	dev->bss_generation++;
-	rb_erase(&bss->rbn, &dev->bss_tree);
-
+		kref_put(&bss->ref, bss_release);
+	}
 	spin_unlock_bh(&dev->bss_lock);
-
-	kref_put(&bss->ref, bss_release);
 }
 EXPORT_SYMBOL(cfg80211_unlink_bss);
 


