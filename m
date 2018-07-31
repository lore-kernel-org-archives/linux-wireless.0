Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 10.mo178.mail-out.ovh.net ([46.105.76.150]:51973 "EHLO
        10.mo178.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727072AbeGaWcT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 31 Jul 2018 18:32:19 -0400
Received: from player735.ha.ovh.net (unknown [10.109.146.76])
        by mo178.mail-out.ovh.net (Postfix) with ESMTP id 3750A1FF43
        for <linux-wireless@vger.kernel.org>; Tue, 31 Jul 2018 22:11:00 +0200 (CEST)
From: Alexander Wetzel <alexander@wetzel-home.de>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, greearb@candelatech.com,
        s.gottschall@dd-wrt.com, denkenz@gmail.com,
        Alexander Wetzel <alexander@wetzel-home.de>
Subject: [PATCH v4 3/3] mac80211: Fix PTK rekey freezes and cleartext leaks
Date: Tue, 31 Jul 2018 22:10:30 +0200
Message-Id: <20180731201030.2619-4-alexander@wetzel-home.de> (sfid-20180731_225018_196712_275968D0)
In-Reply-To: <20180731201030.2619-1-alexander@wetzel-home.de>
References: <20180731201030.2619-1-alexander@wetzel-home.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rekeying a pairwise key with encryption offload and only keyid 0 had
multiple races. Two of them could freeze the wlan connection till
rekeyed again and the third could send out packets in clear which should
have been encrypted.

 1) Freeze caused by incoming packets:
    If the local STA installed the key prior to the remote STA we still
    had the old key active in the hardware while mac80211 was already
    operating on the new key.
    The card could still hand over packets decoded with the old key to
    mac80211, bumping the new PN (IV) value to an incorrect high number
    and tricking the local replay detection to later drop all packets
    really sent with the new key.

 2) Freeze caused by outgoing packets:
    If mac80211 was providing the PN (IV) and handed over a cleartext
    packets for encryption to the hardware prior to a key change the
    driver/card could have processed the queued packets after switching
    to the new key.
    This immediately bumped the PN (IV) value on the remote STA to
    an incorrect high number, which also froze the connection.

 3) Clear text leak:
    Removing encryption offload from the card cleared the encryption
    offload flag only after the card had removed the key. Packets handed
    over between that were send out unencrypted.

To prevent those issues we now stop queuing packets to the driver while
replacing the key, replace the key first in the HW and stop/block new
aggregation sessions during the rekey.

This will only work correctly with drivers implementing replace_key and
a userspace honoring NL80211_EXT_FEATURE_ATOMIC_KEY_REPLACE.
If the driver is not implementing replace_key all three issues can still
occur and the userspace must not rekey a running connection.

With drivers implementing replace_key this fixes the (for rekeys)
invalid unicast key install procedure from:
 - atomic switch over to the new key in mac80211 (TX still active!)
 - remove the old key in the HW (stops encryption offloading, switch
   to SW encryption and can leak clear text packets while doing that)
 - delete the inactive old key in mac80211
 - add new key in the HW for encryption offloading (ending software
   encryption)
to:
 - mark the old key as tainted to drop TX packets with the outgoing key
 - replace the key in HW with the new one using the new driver callback
   "replace_key" (driver still must guarantee it is not leaking
   cleartext itself)
 - atomic switch over to the new key in mac80211 (allow TX again)
 - delete the inactive old key in mac80211

For drivers not implementing the new callback "replace_key" it's
unknown if the driver can replace the key without leaking cleartext
packets. Mac80211 will therefore log an error message when trying to
update the PTK key but still replace the key as instructed. Refusing
cooperation is possible but considered to be the greater evil due to
user visible changes. The mac80211 cleartext packet leak is still fixed,
but potential cleartext packet leaks and the freezes - caused by the
undefined driver behavior - can't be ruled out.

The logic behind the updated rekey sequence:
With the new sequence the HW will be unable to decode packets encrypted
with the old key prior to switching to the new key in mac80211.
Locking down TX during the rekey makes sure that there are no outgoing
packets while the driver and card are switching to the new key.

The driver is allowed to hand over packets decrypted with either the new
or the old key till "replace_key" returns. But all packets queued prior
to calling the callback must be either still be send out encrypted with
the old key or be dropped.

A RX aggregation session started prior to the rekey and completed after
can still dump frames received with the old key at mac80211 after we
switched over to the new key. This is avoided by stopping all RX and
aggregation sessions when we replace a PTK key and are using key
offloading.

Signed-off-by: Alexander Wetzel <alexander@wetzel-home.de>
---
 net/mac80211/key.c | 123 ++++++++++++++++++++++++++++++++++++++-------
 net/mac80211/tx.c  |   4 ++
 2 files changed, 110 insertions(+), 17 deletions(-)

diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index c054ac85793c..5a5f9e0d276e 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -248,6 +248,7 @@ static void ieee80211_key_disable_hw_accel(struct ieee80211_key *key)
 	      (key->conf.flags & IEEE80211_KEY_FLAG_RESERVE_TAILROOM)))
 		increment_tailroom_need_count(sdata);
 
+	key->flags &= ~KEY_FLAG_UPLOADED_TO_HARDWARE;
 	ret = drv_set_key(key->local, DISABLE_KEY, sdata,
 			  sta ? &sta->sta : NULL, &key->conf);
 
@@ -257,7 +258,63 @@ static void ieee80211_key_disable_hw_accel(struct ieee80211_key *key)
 			  key->conf.keyidx,
 			  sta ? sta->sta.addr : bcast_addr, ret);
 
-	key->flags &= ~KEY_FLAG_UPLOADED_TO_HARDWARE;
+}
+
+static int ieee80211_hw_ptk_replace(struct ieee80211_key *old_key,
+				    struct ieee80211_key *new_key,
+				    bool canreplace)
+{
+	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_local *local;
+	struct sta_info *sta;
+	int ret;
+
+	if (!old_key || !new_key || !old_key->sta)
+		return -EINVAL;
+
+	/* Running on software encryption */
+	if (!(old_key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE))
+		return 0;
+
+	assert_key_lock(old_key->local);
+
+	sta = old_key->sta;
+	local = old_key->local;
+	sdata = old_key->sdata;
+
+	/* Stop TX till we are on the new key */
+	old_key->flags |= KEY_FLAG_TAINTED;
+	ieee80211_clear_fast_xmit(sta);
+
+	if (ieee80211_hw_check(&local->hw, AMPDU_AGGREGATION)) {
+		set_sta_flag(sta, WLAN_STA_BLOCK_BA);
+		ieee80211_sta_tear_down_BA_sessions(sta, AGG_STOP_LOCAL_REQUEST);
+	}
+
+	if (canreplace) {
+		ret = drv_replace_key(old_key->local, sdata,
+				      &sta->sta, &old_key->conf,
+				      &new_key->conf);
+		if (!ret)
+			new_key->flags |= KEY_FLAG_UPLOADED_TO_HARDWARE;
+		else
+			sdata_err(sdata,
+				  "failed to replace key (%d) with key " \
+				  "(%d) for STA, %pM in hardware (%d)\n",
+				  old_key->conf.keyidx,
+				  new_key->conf.keyidx,
+				  sta ? sta->sta.addr : bcast_addr, ret);
+
+		old_key->flags &= ~KEY_FLAG_UPLOADED_TO_HARDWARE;
+	} else {
+		sdata_err(sdata,
+			  "PTK rekey and old userspace software used. Some "
+			  "packets to STA %pM may be send out without "
+			  "encryption and the connection may also freeze!",
+			  sta->sta.addr);
+		ret = 0;
+	}
+	return (ret);
 }
 
 static void __ieee80211_set_default_key(struct ieee80211_sub_if_data *sdata,
@@ -316,38 +373,74 @@ void ieee80211_set_default_mgmt_key(struct ieee80211_sub_if_data *sdata,
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
+	bool canreplace = false;
 
 	/* caller must provide at least one old/new */
 	if (WARN_ON(!new && !old))
-		return;
+		return 0;
+
+	/* Drivers can provide and signal support for replacing in-use
+	 * keys by implementing the callback replace_key. If possible
+	 * use that for PTK key replaces. If not we stick to an improved
+	 * procedure with_set_key which may still leak clear text packets
+	 * and freeze RX and/or TX for compatibility.
+	 */
+	if (new && new->local->ops->replace_key)
+		canreplace = true;
 
 	if (new)
 		list_add_tail_rcu(&new->list, &sdata->key_list);
 
 	WARN_ON(new && old && new->conf.keyidx != old->conf.keyidx);
 
-	if (old)
+	if (old) {
 		idx = old->conf.keyidx;
-	else
+
+		if(new && sta && pairwise) {
+			ret = ieee80211_hw_ptk_replace(old, new, canreplace);
+			if (ret)
+				return ret;
+		}
+	} else {
 		idx = new->conf.keyidx;
+	}
+
+	if (new && !new->local->wowlan &&
+	    !(sta && old && canreplace)) {
+		/* Only safe to use for GTK keys!
+		 * Doing this for an in use PTK key can trick our replay
+		 * detection to kill RX and potentially also the TX of the
+		 * remote station. But it's still allowed for PTKs when the
+		 * driver is not implementing replace_key for backward
+		 * combatibility for now.
+		 */
+		ret = ieee80211_key_enable_hw_accel(new);
+		if (ret)
+			return ret;
+	}
 
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
@@ -380,6 +473,7 @@ static void ieee80211_key_replace(struct ieee80211_sub_if_data *sdata,
 
 	if (old)
 		list_del_rcu(&old->list);
+	return 0;
 }
 
 struct ieee80211_key *
@@ -654,7 +748,6 @@ int ieee80211_key_link(struct ieee80211_key *key,
 		       struct ieee80211_sub_if_data *sdata,
 		       struct sta_info *sta)
 {
-	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_key *old_key;
 	int idx = key->conf.keyidx;
 	bool pairwise = key->conf.flags & IEEE80211_KEY_FLAG_PAIRWISE;
@@ -691,17 +784,13 @@ int ieee80211_key_link(struct ieee80211_key *key,
 
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
+		ieee80211_key_destroy(old_key, true);
 	} else {
-		ret = 0;
+		ieee80211_key_free(key, true);
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
