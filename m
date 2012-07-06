Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51636 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757555Ab2GFSXR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jul 2012 14:23:17 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: remove ieee80211_key_removed
Date: Fri,  6 Jul 2012 20:23:14 +0200
Message-Id: <1341598994-13627-1-git-send-email-johannes@sipsolutions.net> (sfid-20120706_202321_385845_853D8C8E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This API call was intended to be used by drivers
if they want to optimize key handling by removing
one key when another is added. Remove it since no
driver is using it. If needed, it can always be
added back.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 Documentation/DocBook/80211.tmpl |    1 -
 include/net/mac80211.h           |   16 ----------------
 net/mac80211/key.c               |   20 --------------------
 3 files changed, 37 deletions(-)

diff --git a/Documentation/DocBook/80211.tmpl b/Documentation/DocBook/80211.tmpl
index f3e214f..42e7f03 100644
--- a/Documentation/DocBook/80211.tmpl
+++ b/Documentation/DocBook/80211.tmpl
@@ -404,7 +404,6 @@
 !Finclude/net/mac80211.h ieee80211_get_tkip_p1k
 !Finclude/net/mac80211.h ieee80211_get_tkip_p1k_iv
 !Finclude/net/mac80211.h ieee80211_get_tkip_p2k
-!Finclude/net/mac80211.h ieee80211_key_removed
       </chapter>
 
       <chapter id="powersave">
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 114d22b..c609b9d 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -3628,22 +3628,6 @@ void ieee80211_request_smps(struct ieee80211_vif *vif,
 			    enum ieee80211_smps_mode smps_mode);
 
 /**
- * ieee80211_key_removed - disable hw acceleration for key
- * @key_conf: The key hw acceleration should be disabled for
- *
- * This allows drivers to indicate that the given key has been
- * removed from hardware acceleration, due to a new key that
- * was added. Don't use this if the key can continue to be used
- * for TX, if the key restriction is on RX only it is permitted
- * to keep the key for TX only and not call this function.
- *
- * Due to locking constraints, it may only be called during
- * @set_key. This function must be allowed to sleep, and the
- * key it tries to disable may still be used until it returns.
- */
-void ieee80211_key_removed(struct ieee80211_key_conf *key_conf);
-
-/**
  * ieee80211_ready_on_channel - notification of remain-on-channel start
  * @hw: pointer as obtained from ieee80211_alloc_hw()
  */
diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index b3b7e52..7ae678b 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -194,26 +194,6 @@ static void ieee80211_key_disable_hw_accel(struct ieee80211_key *key)
 	key->flags &= ~KEY_FLAG_UPLOADED_TO_HARDWARE;
 }
 
-void ieee80211_key_removed(struct ieee80211_key_conf *key_conf)
-{
-	struct ieee80211_key *key;
-
-	key = container_of(key_conf, struct ieee80211_key, conf);
-
-	might_sleep();
-	assert_key_lock(key->local);
-
-	key->flags &= ~KEY_FLAG_UPLOADED_TO_HARDWARE;
-
-	/*
-	 * Flush TX path to avoid attempts to use this key
-	 * after this function returns. Until then, drivers
-	 * must be prepared to handle the key.
-	 */
-	synchronize_rcu();
-}
-EXPORT_SYMBOL_GPL(ieee80211_key_removed);
-
 static void __ieee80211_set_default_key(struct ieee80211_sub_if_data *sdata,
 					int idx, bool uni, bool multi)
 {
-- 
1.7.10.4

