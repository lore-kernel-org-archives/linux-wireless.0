Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 7.mo68.mail-out.ovh.net ([46.105.63.230]:40425 "EHLO
        7.mo68.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727392AbeH2UdU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 29 Aug 2018 16:33:20 -0400
Received: from player774.ha.ovh.net (unknown [10.109.160.253])
        by mo68.mail-out.ovh.net (Postfix) with ESMTP id A3E60F57FA
        for <linux-wireless@vger.kernel.org>; Wed, 29 Aug 2018 18:35:30 +0200 (CEST)
From: Alexander Wetzel <alexander@wetzel-home.de>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, denkenz@gmail.com,
        Alexander Wetzel <alexander@wetzel-home.de>
Subject: [PATCH v7 2/2] mac80211: Fix PTK rekey freezes and clear text leak
Date: Wed, 29 Aug 2018 18:34:52 +0200
Message-Id: <20180829163452.32666-3-alexander@wetzel-home.de> (sfid-20180829_183540_285971_7ED6D0A3)
In-Reply-To: <20180829163452.32666-1-alexander@wetzel-home.de>
References: <20180829163452.32666-1-alexander@wetzel-home.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rekeying PTK keys without "Extended Key ID for Individually Addressed
Frames" did use a procedure not suitable to replace in-use keys and
could caused the following issues:

 1) Freeze caused by incoming frames:
    If the local STA installed the key prior to the remote STA we still
    had the old key active in the hardware when mac80211 switched over
    to the new key.
    Therefore there was a window where the card could hand over frames
    decoded with the old key to mac80211 and bump the new PN (IV) value
    to an incorrect high number. When it happened the local replay
    detection silently started to drop all frames sent with the new key.

 2) Freeze caused by outgoing frames:
    If mac80211 was providing the PN (IV) and handed over a clear text
    frame for encryption to the hardware prior to a key change the
    driver/card could have processed the queued frame after switching
    to the new key. This bumped the PN value on the remote STA to an
    incorrect high number, tricking the remote STA to discard all frames
    we sent later.

 3) Freeze caused by RX aggregation reorder buffer:
    An aggregation session started with the old key and ending after the
    switch to the new key also bumped the PN to an incorrect high number,
    freezing the connection quite similar to 1).

 4) Freeze caused by repeating lost frames in an aggregation session:
    A driver could repeat a lost frame and encrypt it with the new key
    while in a TX aggregation session without updating the PN for the
    new key. This also could freeze connections similar to 2).

 5) Clear text leak:
    Removing encryption offload from the card cleared the encryption
    offload flag only after the card had deleted the key and we did not
    stop TX during the rekey. The driver/card could therefore get
    unencrypted frames from mac80211 while no longer be instructed to
    encrypt them.

To prevent those issues the key install logic has been changed:
 - We now flag drivers known to be able to rekey PTK0 keys with
   NL80211_EXT_FEATURE_CAN_REPLACE_PTK0,
 - stop queuing frames depending on the key while replacing it
 - replace the key first in the hardware and only after that in mac80211
 - and stop/block new aggregation sessions during the rekey.

For drivers not setting
NL80211_EXT_FEATURE_CAN_REPLACE_PTK0 the user space must avoid PTK
rekeys if "Extended Key ID for Individually Addressed Frames" is not
being used. Rekeys for mac80211 drivers without this flag will generate a
warning and use an extra call to ieee80211_flush_queues() to both
highlight and try to prevent the issues with not updated drivers.

The core of the fix changes the key install procedure from:
 - atomic switch over to the new key in mac80211
 - remove the old key in the hardware (stops encryption offloading, fall
   back to software encryption with a potential clear text packet leak
   in between)
 - delete the inactive old key in mac80211
 - enable hardware encryption offloading for the new key
to:
 - if it's a PTK mark the old key as tainted to drop TX frames with the
   outgoing key
 - replace the key in hardware with the new one
 - atomic switch over to the new (not marked as tainted) key in
   mac80211 (which also resumes TX)
 - delete the inactive old key in mac80211

With the new sequence the hardware will be unable to decrypt frames
encrypted with the old key prior to switching to the new key in mac80211
and thus prevent PNs from packets decrypted with the old key to be
accounted against the new key.

For that to work the drivers have to provide a clear boundary.
Mac80211 drivers setting @NL80211_EXT_FEATURE_CAN_REPLACE_PTK0 confirm
to provide it and mac80211 will then be able to correctly rekey in-use
PTK keys with those drivers.

The mac80211 requirements for drivers to set the flag have been added to
the "Hardware crypto acceleration" documentation section. It drills down
to:
The drivers must not hand over frames decrypted with the old key to
mac80211 once the call to set_key() with %DISABLE_KEY has been
completed. It's allowed to either drop or continue to use the old key
for any outgoing frames which are already in the queues, but it must not
send out any of them unencrypted or encrypted with the new key.

Even with the new boundary in place aggregation sessions with the
reorder buffer are a problem:
RX aggregation session started prior and completed after the rekey could
still dump frames received with the old key at mac80211 after it
switched over to the new key. This is side stepped by stopping all (RX
and TX) aggregation sessions when replacing a PTK key and hardware key
offloading.
Stopping TX aggregation sessions avoids the need to get
the PNs (IVs) updated in frames prepared for the old key and
(re)transmitted after the switch to the new key. As a bonus it improves
the compatibility when the remote STA is not handling rekeys as it
should.

When using software crypto aggregation sessions are not stopped.
Mac80211 won't be able to decode the dangerous frames and discard them
without special handling.

Signed-off-by: Alexander Wetzel <alexander@wetzel-home.de>
---
 include/net/mac80211.h |  13 +++++
 net/mac80211/key.c     | 118 ++++++++++++++++++++++++++++++++++-------
 net/mac80211/tx.c      |   4 ++
 3 files changed, 115 insertions(+), 20 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 5790f55c241d..4b5df94c4cea 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2506,6 +2506,19 @@ void ieee80211_free_txskb(struct ieee80211_hw *hw, struct sk_buff *skb);
  * The set_default_unicast_key() call updates the default WEP key index
  * configured to the hardware for WEP encryption type. This is required
  * for devices that support offload of data packets (e.g. ARP responses).
+ *
+ * Mac80211 drivers should set the @NL80211_EXT_FEATURE_CAN_REPLACE_PTK0 flag
+ * when they are able to replace in-use PTK keys according to to following
+ * requirements:
+ * 1) They do not hand over frames decrypted with the old key to
+      mac80211 once the call to set_key() with command %DISABLE_KEY has been
+      completed when also setting @IEEE80211_KEY_FLAG_GENERATE_IV for any key
+   2) either drop or continue to use the old key for any outgoing frames queued
+      at the time of the key deletion (especially re-transmits),
+   3) never send out a frame queued prior to the set_key() %SET_KEY command
+      encrypted with the new key and
+   4) never send out a frame unencrypted when it should be encrypted.
+   Mac80211 will not queue any new frames for a deleted key to the driver.
  */
 
 /**
diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index c054ac85793c..8dc33c29f653 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -248,6 +248,7 @@ static void ieee80211_key_disable_hw_accel(struct ieee80211_key *key)
 	      (key->conf.flags & IEEE80211_KEY_FLAG_RESERVE_TAILROOM)))
 		increment_tailroom_need_count(sdata);
 
+	key->flags &= ~KEY_FLAG_UPLOADED_TO_HARDWARE;
 	ret = drv_set_key(key->local, DISABLE_KEY, sdata,
 			  sta ? &sta->sta : NULL, &key->conf);
 
@@ -256,8 +257,73 @@ static void ieee80211_key_disable_hw_accel(struct ieee80211_key *key)
 			  "failed to remove key (%d, %pM) from hardware (%d)\n",
 			  key->conf.keyidx,
 			  sta ? sta->sta.addr : bcast_addr, ret);
+}
 
-	key->flags &= ~KEY_FLAG_UPLOADED_TO_HARDWARE;
+static int ieee80211_hw_key_replace(struct ieee80211_key *old_key,
+				    struct ieee80211_key *new_key,
+				    bool ptk0rekey)
+{
+	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_local *local;
+	struct sta_info *sta;
+	int ret;
+
+	/* Aggregation sessions are ok when running on SW crypto.
+	 * A broken remote STA may cause issues not observed with HW
+	 * crypto, though.
+	 */
+	if (!(old_key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE))
+		return 0;
+
+	assert_key_lock(old_key->local);
+	sta = old_key->sta;
+
+	/* PTK only using key ID 0 needs special handling on rekey */
+	if (new_key && sta && ptk0rekey) {
+		local = old_key->local;
+		sdata = old_key->sdata;
+
+		/* Stop TX till we are on the new key */
+		old_key->flags |= KEY_FLAG_TAINTED;
+		ieee80211_clear_fast_xmit(sta);
+
+		/* Aggregation sessions during rekey are complicated due to
+		 * the reorder buffer. Side step that by blocking aggregation
+		 * and tear down running connections.
+		 */
+		if (ieee80211_hw_check(&local->hw, AMPDU_AGGREGATION)) {
+			set_sta_flag(sta, WLAN_STA_BLOCK_BA);
+			ieee80211_sta_tear_down_BA_sessions(sta,
+							    AGG_STOP_LOCAL_REQUEST);
+		}
+
+		if (!wiphy_ext_feature_isset(new_key->local->hw.wiphy,
+					     NL80211_EXT_FEATURE_CAN_REPLACE_PTK0)) {
+			pr_warn_ratelimited("Userspace is rekeying PTK for " \
+					    "STA %pM with a driver not " \
+					    "setting NL80211_EXT_FEATURE_" \
+					    "CAN_REPLACE_PTK0. This may leak " \
+					    "clear text packets or randomly " \
+					    "freeze the connection.",
+					    sta->sta.addr);
+			/* Flushing the driver queues *may* help prevent
+			 * the cleartext leaks and freezes.
+			 */
+			ieee80211_flush_queues(old_key->local,
+					       old_key->sdata,
+					       false);
+		}
+		ieee80211_key_disable_hw_accel(old_key);
+		ret = ieee80211_key_enable_hw_accel(new_key);
+	} else {
+		ieee80211_key_disable_hw_accel(old_key);
+		if (new_key)
+			ret = ieee80211_key_enable_hw_accel(new_key);
+		else
+			ret = 0;
+	}
+
+	return ret;
 }
 
 static void __ieee80211_set_default_key(struct ieee80211_sub_if_data *sdata,
@@ -316,38 +382,56 @@ void ieee80211_set_default_mgmt_key(struct ieee80211_sub_if_data *sdata,
 }
 
 
-static void ieee80211_key_replace(struct ieee80211_sub_if_data *sdata,
+static int ieee80211_key_replace(struct ieee80211_sub_if_data *sdata,
 				  struct sta_info *sta,
 				  bool pairwise,
 				  struct ieee80211_key *old,
 				  struct ieee80211_key *new)
 {
 	int idx;
+	int ret;
 	bool defunikey, defmultikey, defmgmtkey;
 
 	/* caller must provide at least one old/new */
 	if (WARN_ON(!new && !old))
-		return;
+		return 0;
 
 	if (new)
 		list_add_tail_rcu(&new->list, &sdata->key_list);
 
 	WARN_ON(new && old && new->conf.keyidx != old->conf.keyidx);
 
-	if (old)
+	if (old) {
 		idx = old->conf.keyidx;
-	else
+		/* TODO: proper implement and test "Extended Key ID for
+		 * Individually Addressed Frames" from IEEE 802.11-2016.
+		 * Till then always assume only key ID 0 is used for
+		 * pairwise keys.*/
+		ret = ieee80211_hw_key_replace(old, new, pairwise);
+	} else {
 		idx = new->conf.keyidx;
+		if (new && !new->local->wowlan)
+			ret = ieee80211_key_enable_hw_accel(new);
+		else
+			ret = 0;
+	}
+
+	if (ret)
+		return ret;
 
 	if (sta) {
 		if (pairwise) {
 			rcu_assign_pointer(sta->ptk[idx], new);
 			sta->ptk_idx = idx;
-			ieee80211_check_fast_xmit(sta);
+			if (new) {
+				clear_sta_flag(sta, WLAN_STA_BLOCK_BA);
+				ieee80211_check_fast_xmit(sta);
+			}
 		} else {
 			rcu_assign_pointer(sta->gtk[idx], new);
 		}
-		ieee80211_check_fast_rx(sta);
+		if (new)
+			ieee80211_check_fast_rx(sta);
 	} else {
 		defunikey = old &&
 			old == key_mtx_dereference(sdata->local,
@@ -380,6 +464,8 @@ static void ieee80211_key_replace(struct ieee80211_sub_if_data *sdata,
 
 	if (old)
 		list_del_rcu(&old->list);
+
+	return 0;
 }
 
 struct ieee80211_key *
@@ -575,9 +661,6 @@ static void ieee80211_key_free_common(struct ieee80211_key *key)
 static void __ieee80211_key_destroy(struct ieee80211_key *key,
 				    bool delay_tailroom)
 {
-	if (key->local)
-		ieee80211_key_disable_hw_accel(key);
-
 	if (key->local) {
 		struct ieee80211_sub_if_data *sdata = key->sdata;
 
@@ -654,7 +737,6 @@ int ieee80211_key_link(struct ieee80211_key *key,
 		       struct ieee80211_sub_if_data *sdata,
 		       struct sta_info *sta)
 {
-	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_key *old_key;
 	int idx = key->conf.keyidx;
 	bool pairwise = key->conf.flags & IEEE80211_KEY_FLAG_PAIRWISE;
@@ -691,17 +773,13 @@ int ieee80211_key_link(struct ieee80211_key *key,
 
 	increment_tailroom_need_count(sdata);
 
-	ieee80211_key_replace(sdata, sta, pairwise, old_key, key);
-	ieee80211_key_destroy(old_key, delay_tailroom);
-
-	ieee80211_debugfs_key_add(key);
+	ret = ieee80211_key_replace(sdata, sta, pairwise, old_key, key);
 
-	if (!local->wowlan) {
-		ret = ieee80211_key_enable_hw_accel(key);
-		if (ret)
-			ieee80211_key_free(key, delay_tailroom);
+	if (!ret) {
+		ieee80211_debugfs_key_add(key);
+		ieee80211_key_destroy(old_key, delay_tailroom);
 	} else {
-		ret = 0;
+		ieee80211_key_free(key, delay_tailroom);
 	}
 
  out:
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index cd332e3e1134..5c79b3c2a7e1 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2951,6 +2951,10 @@ void ieee80211_check_fast_xmit(struct sta_info *sta)
 		if (!(build.key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE))
 			goto out;
 
+		/* Key is being removed */
+		if (build.key->flags & KEY_FLAG_TAINTED)
+			goto out;
+
 		switch (build.key->conf.cipher) {
 		case WLAN_CIPHER_SUITE_CCMP:
 		case WLAN_CIPHER_SUITE_CCMP_256:
-- 
2.18.0
