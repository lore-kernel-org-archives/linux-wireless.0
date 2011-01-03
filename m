Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34322 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940Ab1ACSvK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Jan 2011 13:51:10 -0500
Subject: [PATCH] mac80211: fix some key comments and code
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 03 Jan 2011 19:51:09 +0100
Message-ID: <1294080669.3436.8.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The key documentation is slightly out of date, fix
that. Also, the list entry in the key struct is no
longer used that way, so list_del_init() isn't
necessary any more there.

Finally, ieee80211_key_link() is no longer invoked
under RCU read lock, but rather with an appropriate
station lock held.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/key.c |   38 +++++++++++++++++---------------------
 1 file changed, 17 insertions(+), 21 deletions(-)

--- wireless-testing.orig/net/mac80211/key.c	2011-01-03 19:04:20.000000000 +0100
+++ wireless-testing/net/mac80211/key.c	2011-01-03 19:48:40.000000000 +0100
@@ -30,19 +30,20 @@
  * keys and per-station keys. Since each station belongs to an interface,
  * each station key also belongs to that interface.
  *
- * Hardware acceleration is done on a best-effort basis, for each key
- * that is eligible the hardware is asked to enable that key but if
- * it cannot do that they key is simply kept for software encryption.
- * There is currently no way of knowing this except by looking into
- * debugfs.
+ * Hardware acceleration is done on a best-effort basis for algorithms
+ * that are implemented in software,  for each key the hardware is asked
+ * to enable that key for offloading but if it cannot do that the key is
+ * simply kept for software encryption (unless it is for an algorithm
+ * that isn't implemented in software).
+ * There is currently no way of knowing whether a key is handled in SW
+ * or HW except by looking into debugfs.
  *
- * All key operations are protected internally.
- *
- * Within mac80211, key references are, just as STA structure references,
- * protected by RCU. Note, however, that some things are unprotected,
- * namely the key->sta dereferences within the hardware acceleration
- * functions. This means that sta_info_destroy() must remove the key
- * which waits for an RCU grace period.
+ * All key management is internally protected by a mutex. Within all
+ * other parts of mac80211, key references are, just as STA structure
+ * references, protected by RCU. Note, however, that some things are
+ * unprotected, namely the key->sta dereferences within the hardware
+ * acceleration functions. This means that sta_info_destroy() must
+ * remove the key which waits for an RCU grace period.
  */
 
 static const u8 bcast_addr[ETH_ALEN] = { 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF };
@@ -279,13 +280,8 @@ static void __ieee80211_key_replace(stru
 							 new->conf.keyidx);
 	}
 
-	if (old) {
-		/*
-		 * We'll use an empty list to indicate that the key
-		 * has already been removed.
-		 */
-		list_del_init(&old->list);
-	}
+	if (old)
+		list_del(&old->list);
 }
 
 struct ieee80211_key *ieee80211_key_alloc(u32 cipher, int idx, size_t key_len,
@@ -426,8 +422,8 @@ int ieee80211_key_link(struct ieee80211_
 			struct sta_info *ap;
 
 			/*
-			 * We're getting a sta pointer in,
-			 * so must be under RCU read lock.
+			 * We're getting a sta pointer in, so must be under
+			 * appropriate locking for sta_info_get().
 			 */
 
 			/* same here, the AP could be using QoS */


