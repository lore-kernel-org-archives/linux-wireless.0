Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 6.mo179.mail-out.ovh.net ([46.105.56.76]:51348 "EHLO
        6.mo179.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726509AbeHEVQO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 5 Aug 2018 17:16:14 -0400
Received: from player726.ha.ovh.net (unknown [10.109.146.168])
        by mo179.mail-out.ovh.net (Postfix) with ESMTP id C31ABDEC06
        for <linux-wireless@vger.kernel.org>; Sun,  5 Aug 2018 20:32:07 +0200 (CEST)
From: Alexander Wetzel <alexander@wetzel-home.de>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Alexander Wetzel <alexander@wetzel-home.de>
Subject: [PATCH v5 3/3] mac80211: Fix PTK rekey freezes and cleartext leaks
Date: Sun,  5 Aug 2018 20:31:24 +0200
Message-Id: <20180805183124.29921-4-alexander@wetzel-home.de> (sfid-20180805_211044_783608_A26BBA04)
In-Reply-To: <20180805183124.29921-1-alexander@wetzel-home.de>
References: <20180805183124.29921-1-alexander@wetzel-home.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rekeying PTK keys without "Extended Key ID for Individually Addressed
Frames" did use a procedure not suitable to replace in-use keys and
could caused the following issues:

 1) Freeze caused by incoming packets:
    If the local STA installed the key prior to the remote STA we still
    had the old key active in the hardware with mac80211 already
    operating on the new key.
    Therefore there was a window where the card could still hand over
    packets decoded with the old key to mac80211, bumping the new PN (IV)
    value to an incorrect high number and tricking the local replay
    detection to drop all packets sent with the new key.

 2) Freeze caused by outgoing packets:
    If mac80211 was providing the PN (IV) and handed over a cleartext
    packets for encryption to the hardware prior to a key change the
    driver/card could have processed the queued packets after switching
    to the new key. This immediately bumped the PN value on the remote
    STA to an incorrect high number, which then discarded all packets
    using correct PNs we sent after that.

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
    offload flag only after the card had removed the key. The
    driver/card could therefore get unencrypted packets from mac80211 while
    no longer be instructed to encrypt them.

To prevent those issues the key install logic has been overhauled.
We now stop queuing packets to the driver while replacing the key,
replace the key first in the HW and stop/block new aggregation sessions
during the rekey.

This will only work correctly with drivers implementing replace_key or
with a userspace honoring NL80211_EXT_FEATURE_ATOMIC_KEY_REPLACE.

If the driver is not implementing replace_key all three issues can still
occur and the userspace must not try to rekey the PTK key. If asked to
do that anyhow mac80211 will fall back to an best-we-can-do approach
which should avoid the issues for at least some drivers and inform the
user about the potential issues via a kernel message.

The core of the fix changes the key install procedure from:
 - atomic switch over to the new key in mac80211
 - remove the old key in the HW (stops encryption offloading, fall back
   to SW encryption with a potential clear text packet leak in between)
 - delete the inactive old key in mac80211
 - enable HW for encryption offloading (ending software encryption)
to:
 - if it's a PTK mark the old key as tainted to drop TX packets with the
   outgoing key
 - replace the key in HW with the new one, using the new driver callback
   "replace_key" if it's availabe or by simulating it with existing
   calls if not
 - atomic switch over to the new key in mac80211 (allow TX with the key
   again)
 - delete the inactive old key in mac80211

The logic behind the updated key install sequence:
With the new sequence the HW will be unable to decode packets encrypted
with the old key prior to switching to the new key in mac80211.
Locking down TX during the rekey makes sure that there are no outgoing
packets while the driver and card are switching to the new key.

The driver is allowed to hand over packets decrypted with either the new
or the old key till "replace_key" returns. But all packets queued prior
to calling the callback must be either still be send out encrypted with
the old key or be dropped.

Even with that a RX aggregation session started prior to the rekey and
completed after can still dump frames received with the old key at
mac80211 after it switched over to the new key. This is side stepped by
stopping all aggregation sessions when we replace a PTK key and are
using key offloading. (The only alternative seems be to discard all
frames of the aggregation session running during rekey. Due to
retransmits and reorder we can't differenciate between packets send with
the old or the new key without deploying extreme efforts.)

Stopping TX aggregation sessions - instead of only RX - also avoides the
need to get the PNs (IVs) updated in frames prepared for the old key
and retransmitted after the switch to the new key. And it improves the
combatibility when the remote STA is not handling rekeys as it should.

When using SW crypto aggregation sessions are not stopped. Mac80211
won't be able to decode the dangerous packets and discard them. At least
as long as the remote STA is not also messing up and indeed updating the
PN.

Signed-off-by: Alexander Wetzel <alexander@wetzel-home.de>
---
 net/mac80211/key.c | 131 ++++++++++++++++++++++++++++++++++++++-------
 net/mac80211/tx.c  |   4 ++
 2 files changed, 115 insertions(+), 20 deletions(-)

diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index c054ac85793c..c77f32fe0473 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -248,6 +248,7 @@ static void ieee80211_key_disable_hw_accel(struct ieee80211_key *key)
 	      (key->conf.flags & IEEE80211_KEY_FLAG_RESERVE_TAILROOM)))
 		increment_tailroom_need_count(sdata);
 
+	key->flags &= ~KEY_FLAG_UPLOADED_TO_HARDWARE;
 	ret = drv_set_key(key->local, DISABLE_KEY, sdata,
 			  sta ? &sta->sta : NULL, &key->conf);
 
@@ -256,8 +257,86 @@ static void ieee80211_key_disable_hw_accel(struct ieee80211_key *key)
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
+	/* Aggregation sessions are also ok when running on SW crypto.
+	 * A broken remote STA may have issues not observed with HW
+	 * crypto, though. Nevertheless bypass the complete procedure.
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
+		if (new_key->local->ops->replace_key) {
+			ret = drv_replace_key(old_key->local, sdata,
+					      &sta->sta, &old_key->conf,
+					      &new_key->conf);
+			if (!ret)
+				new_key->flags |= KEY_FLAG_UPLOADED_TO_HARDWARE;
+			else
+				sdata_err(sdata,
+					  "failed to replace key (%d) for " \
+					  "STA (%pM) in hardware: ret=(%d)\n",
+					  old_key->conf.keyidx,
+					  sta->sta.addr,
+					  ret);
+
+			old_key->flags &= ~KEY_FLAG_UPLOADED_TO_HARDWARE;
+		} else {
+			sdata_info(sdata,
+				   "Userspace requested a PTK rekey for STA " \
+				   "%pM while feature not supported! " \
+				   "This may leak clear text packets or " \
+				   "freeze the connection.",
+				   sta->sta.addr);
+			/* Flushing the driver queues *may* prevent cleartext
+			 * leaks and freezes if supported by the driver.
+			 */
+			ieee80211_flush_queues(old_key->local,
+					       old_key->sdata,
+					       false);
+			ieee80211_key_disable_hw_accel(old_key);
+			ret = ieee80211_key_enable_hw_accel(new_key);
+		}
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
@@ -316,38 +395,56 @@ void ieee80211_set_default_mgmt_key(struct ieee80211_sub_if_data *sdata,
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
@@ -380,6 +477,8 @@ static void ieee80211_key_replace(struct ieee80211_sub_if_data *sdata,
 
 	if (old)
 		list_del_rcu(&old->list);
+
+	return 0;
 }
 
 struct ieee80211_key *
@@ -575,9 +674,6 @@ static void ieee80211_key_free_common(struct ieee80211_key *key)
 static void __ieee80211_key_destroy(struct ieee80211_key *key,
 				    bool delay_tailroom)
 {
-	if (key->local)
-		ieee80211_key_disable_hw_accel(key);
-
 	if (key->local) {
 		struct ieee80211_sub_if_data *sdata = key->sdata;
 
@@ -654,7 +750,6 @@ int ieee80211_key_link(struct ieee80211_key *key,
 		       struct ieee80211_sub_if_data *sdata,
 		       struct sta_info *sta)
 {
-	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_key *old_key;
 	int idx = key->conf.keyidx;
 	bool pairwise = key->conf.flags & IEEE80211_KEY_FLAG_PAIRWISE;
@@ -691,17 +786,13 @@ int ieee80211_key_link(struct ieee80211_key *key,
 
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
index cd332e3e1134..13228693324c 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2951,6 +2951,10 @@ void ieee80211_check_fast_xmit(struct sta_info *sta)
 		if (!(build.key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE))
 			goto out;
 
+		/* Key is beeing removed */
+		if (build.key->flags & KEY_FLAG_TAINTED)
+			goto out;
+
 		switch (build.key->conf.cipher) {
 		case WLAN_CIPHER_SUITE_CCMP:
 		case WLAN_CIPHER_SUITE_CCMP_256:
-- 
2.18.0
