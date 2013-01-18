Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59347 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754482Ab3ARLpd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jan 2013 06:45:33 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC] mac80211: mark TX key for WoWLAN
Date: Fri, 18 Jan 2013 12:45:55 +0100
Message-Id: <1358509555-23577-1-git-send-email-johannes@sipsolutions.net> (sfid-20130118_124537_557993_F5482EFC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

For WoWLAN, the device may need to know the (WEP) TX
key so it can use that key if multiple are configured.
To achieve this, mark the key with the new key flag
IEEE80211_KEY_FLAG_TX_KEY_UCAST. As documented, this
flag is only valid when using ieee80211_iter_keys(),
which our WoWLAN code currently does. If there are
other drivers that need this during normal operation,
e.g. for ARP offloading, then a new callback would
be required.

Change-Id: Iaf7a08c7788e061a6563b0ba399506c4624c8e6e
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h |  9 +++++++++
 net/mac80211/key.c     | 17 ++++++++++++++---
 2 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index e4d57c4..260eabe 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1097,6 +1097,14 @@ static inline bool ieee80211_vif_is_mesh(struct ieee80211_vif *vif)
  *	fall back to software crypto. Note that this flag deals only with
  *	RX, if your crypto engine can't deal with TX you can also set the
  *	%IEEE80211_KEY_FLAG_SW_MGMT_TX flag to encrypt such frames in SW.
+ * @IEEE80211_KEY_FLAG_TX_KEY_UCAST: This is the default unicast TX key.
+ *	Normally, this flag isn't needed as mac80211 will give the key when
+ *	transmitting. However, for WoWLAN usage, the device may need to
+ *	transmit packets all by itself and select the key for that. Note
+ *	that this flag is only valid during key iteration, it isn't set
+ *	when a key is added. This is done to avoid bugs, since there's no
+ *	update callback for keys/this flag. Therefore, the use of this flag
+ *	is only valid when using ieee80211_iter_keys().
  */
 enum ieee80211_key_flags {
 	IEEE80211_KEY_FLAG_WMM_STA	= 1<<0,
@@ -1106,6 +1114,7 @@ enum ieee80211_key_flags {
 	IEEE80211_KEY_FLAG_SW_MGMT_TX	= 1<<4,
 	IEEE80211_KEY_FLAG_PUT_IV_SPACE = 1<<5,
 	IEEE80211_KEY_FLAG_RX_MGMT	= 1<<6,
+	IEEE80211_KEY_FLAG_TX_KEY_UCAST	= 1<<7,
 };
 
 /**
diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index 619c5d6..f53ef19 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -197,15 +197,26 @@ static void ieee80211_key_disable_hw_accel(struct ieee80211_key *key)
 static void __ieee80211_set_default_key(struct ieee80211_sub_if_data *sdata,
 					int idx, bool uni, bool multi)
 {
-	struct ieee80211_key *key = NULL;
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_key *key = NULL, *old;
 
-	assert_key_lock(sdata->local);
+	assert_key_lock(local);
+
+	if (uni) {
+		old = key_mtx_dereference(local, sdata->default_unicast_key);
+		if (old)
+			old->conf.flags &= ~IEEE80211_KEY_FLAG_TX_KEY_UCAST;
+	}
 
 	if (idx >= 0 && idx < NUM_DEFAULT_KEYS)
 		key = key_mtx_dereference(sdata->local, sdata->keys[idx]);
 
-	if (uni)
+	if (uni) {
 		rcu_assign_pointer(sdata->default_unicast_key, key);
+		if (key)
+			key->conf.flags |= IEEE80211_KEY_FLAG_TX_KEY_UCAST;
+	}
+
 	if (multi)
 		rcu_assign_pointer(sdata->default_multicast_key, key);
 
-- 
1.8.0

