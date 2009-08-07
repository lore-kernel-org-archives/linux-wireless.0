Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:43452 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932431AbZHGPDo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Aug 2009 11:03:44 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <johannes@sipsolutions.net>)
	id 1MZQyu-0005Kf-4p
	for linux-wireless@vger.kernel.org; Fri, 07 Aug 2009 17:03:44 +0200
Subject: [PATCH/RFT] mac80211: try uploading key if a slot was freed
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 07 Aug 2009 17:03:41 +0200
Message-Id: <1249657421.7194.7.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When we remove a key from hwaccel, that may mean
that there's a new free item in the hwaccel, and
we could fill it with another station's key. By
keeping track of which keys the driver said it
could not support (-EOPNOTSUPP) and which it had
no space for (-ENOSPC) we can try uploading a
key that was previously rejected due to no space
after another key is removed.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
RFT because I really have no idea how to test this
properly. Maybe with a hacked driver that claims
to support only a single key in hwaccel?

 net/mac80211/key.c |   51 ++++++++++++++++++++++++++++++++++-----------------
 net/mac80211/key.h |    3 +++
 2 files changed, 37 insertions(+), 17 deletions(-)

--- wireless-testing.orig/net/mac80211/key.c	2009-08-07 16:48:46.000000000 +0200
+++ wireless-testing/net/mac80211/key.c	2009-08-07 16:59:01.000000000 +0200
@@ -141,20 +141,21 @@ static void ieee80211_key_enable_hw_acce
 
 	ret = drv_set_key(key->local, SET_KEY, &sdata->vif, sta, &key->conf);
 
-	if (!ret) {
-		spin_lock_bh(&todo_lock);
+	spin_lock_bh(&todo_lock);
+	if (!ret)
 		key->flags |= KEY_FLAG_UPLOADED_TO_HARDWARE;
-		spin_unlock_bh(&todo_lock);
-	}
+	else if (ret == -EOPNOTSUPP)
+		key->flags |= KEY_FLAG_HWACCEL_NOT_SUPPORTED;
+	spin_unlock_bh(&todo_lock);
 
-	if (ret && ret != -ENOSPC && ret != -EOPNOTSUPP)
-		printk(KERN_ERR "mac80211-%s: failed to set key "
-		       "(%d, %pM) to hardware (%d)\n",
-		       wiphy_name(key->local->hw.wiphy),
-		       key->conf.keyidx, sta ? sta->addr : bcast_addr, ret);
+	WARN(ret && ret != -ENOSPC && ret != -EOPNOTSUPP,
+	     "mac80211-%s: failed to set key (%d, %pM) to hardware (%d)\n",
+	     wiphy_name(key->local->hw.wiphy), key->conf.keyidx,
+	     sta ? sta->addr : bcast_addr, ret);
 }
 
-static void ieee80211_key_disable_hw_accel(struct ieee80211_key *key)
+static void ieee80211_key_disable_hw_accel(struct ieee80211_key *key,
+					   bool upload_another)
 {
 	struct ieee80211_sub_if_data *sdata;
 	struct ieee80211_sta *sta;
@@ -184,14 +185,30 @@ static void ieee80211_key_disable_hw_acc
 	ret = drv_set_key(key->local, DISABLE_KEY, &sdata->vif,
 			  sta, &key->conf);
 
-	if (ret)
-		printk(KERN_ERR "mac80211-%s: failed to remove key "
-		       "(%d, %pM) from hardware (%d)\n",
-		       wiphy_name(key->local->hw.wiphy),
-		       key->conf.keyidx, sta ? sta->addr : bcast_addr, ret);
+	WARN(ret,
+	     "mac80211-%s: failed to remove key (%d, %pM) from hardware (%d)\n",
+	     wiphy_name(key->local->hw.wiphy), key->conf.keyidx,
+	     sta ? sta->addr : bcast_addr, ret);
 
 	spin_lock_bh(&todo_lock);
 	key->flags &= ~KEY_FLAG_UPLOADED_TO_HARDWARE;
+
+	list_for_each_entry(key, &sdata->key_list, list) {
+		if (key->flags & KEY_FLAG_HWACCEL_NOT_SUPPORTED)
+			continue;
+		if (key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE)
+			continue;
+		if (key->flags & KEY_FLAG_TODO_DELETE)
+			continue;
+		if (key->flags & KEY_FLAG_TODO_HWACCEL_ADD)
+			continue;
+		if (key->flags & KEY_FLAG_TODO_HWACCEL_REMOVE)
+			continue;
+		spin_unlock_bh(&todo_lock);
+		ieee80211_key_enable_hw_accel(key);
+		spin_lock_bh(&todo_lock);
+	}
+
 	spin_unlock_bh(&todo_lock);
 }
 
@@ -527,7 +544,7 @@ static void __ieee80211_key_destroy(stru
 	if (!key)
 		return;
 
-	ieee80211_key_disable_hw_accel(key);
+	ieee80211_key_disable_hw_accel(key, true);
 
 	if (key->conf.alg == ALG_CCMP)
 		ieee80211_aes_key_free(key->u.ccmp.tfm);
@@ -583,7 +600,7 @@ static void __ieee80211_key_todo(void)
 			work_done = true;
 		}
 		if (todoflags & KEY_FLAG_TODO_HWACCEL_REMOVE) {
-			ieee80211_key_disable_hw_accel(key);
+			ieee80211_key_disable_hw_accel(key, false);
 			work_done = true;
 		}
 		if (todoflags & KEY_FLAG_TODO_DELETE) {
--- wireless-testing.orig/net/mac80211/key.h	2009-08-07 16:49:17.000000000 +0200
+++ wireless-testing/net/mac80211/key.h	2009-08-07 16:58:47.000000000 +0200
@@ -48,6 +48,8 @@ struct sta_info;
  * @KEY_FLAG_TODO_ADD_DEBUGFS: Key needs to be added to debugfs.
  * @KEY_FLAG_TODO_DEFMGMTKEY: Key is default management key and debugfs needs
  *	to be updated.
+ * @KEY_FLAG_HWACCEL_NOT_SUPPORTED: hardware acceleration not supported for
+ *	this key type (tried and driver returned -EOPNOTSUPP)
  */
 enum ieee80211_internal_key_flags {
 	KEY_FLAG_UPLOADED_TO_HARDWARE	= BIT(0),
@@ -57,6 +59,7 @@ enum ieee80211_internal_key_flags {
 	KEY_FLAG_TODO_DEFKEY		= BIT(4),
 	KEY_FLAG_TODO_ADD_DEBUGFS	= BIT(5),
 	KEY_FLAG_TODO_DEFMGMTKEY	= BIT(6),
+	KEY_FLAG_HWACCEL_NOT_SUPPORTED	= BIT(7),
 };
 
 struct tkip_ctx {


