Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 16.mo5.mail-out.ovh.net ([87.98.174.144]:60959 "EHLO
        16.mo5.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751712AbeF3WLM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 30 Jun 2018 18:11:12 -0400
Received: from player793.ha.ovh.net (unknown [10.109.120.38])
        by mo5.mail-out.ovh.net (Postfix) with ESMTP id E121B1C6847
        for <linux-wireless@vger.kernel.org>; Sat, 30 Jun 2018 23:32:04 +0200 (CEST)
From: Alexander Wetzel <alexander.wetzel@web.de>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, greearb@candelatech.com,
        s.gottschall@dd-wrt.com, Alexander Wetzel <alexander.wetzel@web.de>
Subject: [PATCH v3] mac80211: Fix PTK rekey freezes and cleartext leaks
Date: Sat, 30 Jun 2018 23:27:35 +0200
Message-Id: <20180630212735.1964-1-alexander.wetzel@web.de> (sfid-20180701_001515_405750_6D622209)
In-Reply-To: <1530267147.3481.78.camel@sipsolutions.net>
References: <1530267147.3481.78.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rekeying a pairwise key with encryption offload and only keyid 0 has
multiple races. Two of them can can freeze the wlan connection till
rekeyed again and the third can send out packets in clear which should
have been encrypted.

 1) Freeze caused by incoming packets:
    If the local STA installs the key prior to the remote STA we still
    have the old key active in the hardware for a short time after
    mac80211 switched to the new key.
    The card can still hand over packets decoded with the old key to
    mac80211, bumping the new PN (IV) value to an incorrect high number
    and tricking the local replay detection to drop all packets really
    sent with the new key.

 2) Freeze caused by outgoing packets:
    If mac80211 is providing the PN (IV) and hands over the cleartext
    packets for encryption to the hardware immediately prior to a key
    change the driver/card may process the queued packets after
    switching to the new key.
    This will immediately bump the PN (IV) value on the remote STA to
    an incorrect high number, also freezing the connection.

 3) Clear text leak:
    Removing encryption offload from the card clears the encryption
    offload flag only after the card has removed the key.

All three issues can be prevented by making sure we do not send out any
packets while replacing the key, replace the key first in the HW and
only after that in mac80211 and stop running/block new aggregation
sessions during the rekey.

This changes the old unicast key install sequence from:
 - atomic switch over to the new key in mac80211 (TX still active!)
 - remove the old key in the HW (stop encryption offloading)
 - delete the now inactive old key in mac80211 (staring software
   encryption after a potential clear text packet leak)
 - add new key in the hw for encryption offloading (ending software
   encryption)

to:
 - mark the old key as tainted to drop TX packets with the outgoing key
 - replace the key in HW with the new one using the new driver callback
   "replace_key"
 - atomic switch over to the new key in mac80211 (allow TX again)
 - delete the now inactive old key in mac80211

For drivers not implementing the new callback "replace_key" it's
unknown if the driver can replace the key without leaking cleartext
packets. Mac80211 will therefore log an error message when trying to
update the PTK key and refuse cooperation. This will disconnect the STA.

With the new sequence the HW will be already unable to decode packets
still encrypted with the old key prior to switching to the new key in
mac80211. Locking down TX during the rekey makes sure that there are no
outgoing packets while the driver and card are switching to the new key.

The driver is allowed to hand over packets decrypted with either the new
or the old key till "replace_key" returns. But all packets queued prior
to calling the callback must be either still be send out encrypted with
the old key or be dropped.

A RX aggregation session started prior to the rekey and which completes
after can still dump frames received with the old key at mac80211 after
we switched over to the new key. This is currently avoided by stopping
all RX and TX aggregation sessions when we replace a PTK key and are
using key offloading.

Signed-off-by: Alexander Wetzel <alexander.wetzel@web.de>
---
 include/net/mac80211.h    |  12 +++++
 net/mac80211/driver-ops.h |  20 ++++++++
 net/mac80211/key.c        | 102 +++++++++++++++++++++++++++++++-------
 net/mac80211/trace.h      |  39 +++++++++++++++
 net/mac80211/tx.c         |   4 ++
 5 files changed, 159 insertions(+), 18 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 5790f55c241d..a8673d653e7d 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -3137,6 +3137,14 @@ enum ieee80211_reconfig_type {
  *	Returns a negative error code if the key can't be added.
  *	The callback can sleep.
  *
+ * @replace_key: Replace a PTK key in the HW for a running association with a
+ *      new one.
+ *      Implementing this callback confirms that the driver/card supports
+ *      replacing the key without leaking cleartext packets, will no longer hand
+ *      over packets decrypted with the old key and not send out any packet
+ *      queued prior to this call with the new key after the callback has
+ *      returned.
+ *
  * @update_tkip_key: See the section "Hardware crypto acceleration"
  * 	This callback will be called in the context of Rx. Called for drivers
  * 	which set IEEE80211_KEY_FLAG_TKIP_REQ_RX_P1_KEY.
@@ -3585,6 +3593,10 @@ struct ieee80211_ops {
 	int (*set_key)(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		       struct ieee80211_vif *vif, struct ieee80211_sta *sta,
 		       struct ieee80211_key_conf *key);
+	int (*replace_key)(struct ieee80211_hw *hw,
+		       struct ieee80211_vif *vif, struct ieee80211_sta *sta,
+		       struct ieee80211_key_conf *old,
+		       struct ieee80211_key_conf *new);
 	void (*update_tkip_key)(struct ieee80211_hw *hw,
 				struct ieee80211_vif *vif,
 				struct ieee80211_key_conf *conf,
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 8f6998091d26..ebd7f1463336 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -255,6 +255,26 @@ static inline int drv_set_key(struct ieee80211_local *local,
 	return ret;
 }
 
+static inline int drv_replace_key(struct ieee80211_local *local,
+			      struct ieee80211_sub_if_data *sdata,
+			      struct ieee80211_sta *sta,
+			      struct ieee80211_key_conf *old_key,
+			      struct ieee80211_key_conf *new_key)
+{
+	int ret;
+
+	might_sleep();
+
+	sdata = get_bss_sdata(sdata);
+	if (!check_sdata_in_driver(sdata))
+		return -EIO;
+
+	trace_drv_replace_key(local, sdata, sta, old_key, new_key);
+	ret = local->ops->replace_key(&local->hw, &sdata->vif, sta, old_key, new_key);
+	trace_drv_return_int(local, ret);
+	return ret;
+}
+
 static inline void drv_update_tkip_key(struct ieee80211_local *local,
 				       struct ieee80211_sub_if_data *sdata,
 				       struct ieee80211_key_conf *conf,
diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index ee0d0cc8dc3b..b148f90b209c 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -248,6 +248,7 @@ static void ieee80211_key_disable_hw_accel(struct ieee80211_key *key)
 	      (key->conf.flags & IEEE80211_KEY_FLAG_RESERVE_TAILROOM)))
 		increment_tailroom_need_count(sdata);
 
+	key->flags &= ~KEY_FLAG_UPLOADED_TO_HARDWARE;
 	ret = drv_set_key(key->local, DISABLE_KEY, sdata,
 			  sta ? &sta->sta : NULL, &key->conf);
 
@@ -257,7 +258,60 @@ static void ieee80211_key_disable_hw_accel(struct ieee80211_key *key)
 			  key->conf.keyidx,
 			  sta ? sta->sta.addr : bcast_addr, ret);
 
-	key->flags &= ~KEY_FLAG_UPLOADED_TO_HARDWARE;
+}
+
+static int ieee80211_hw_ptk_replace(struct ieee80211_key *old_key,
+				    struct ieee80211_key *new_key)
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
+	if (!old_key->local->ops->replace_key) {
+		sdata_err(sdata,
+			  "Driver is not supporting save PTK key replacement. "
+			  "Insecure rekey attempt for STA %pM denied.\n",
+			  sta->sta.addr);
+		return -EINVAL;
+	}
+
+	/* Stop TX till we are on the new key */
+	old_key->flags |= KEY_FLAG_TAINTED;
+	ieee80211_clear_fast_xmit(sta);
+
+	if (ieee80211_hw_check(&local->hw, AMPDU_AGGREGATION)) {
+		set_sta_flag(sta, WLAN_STA_BLOCK_BA);
+		ieee80211_sta_tear_down_BA_sessions(sta, AGG_STOP_LOCAL_REQUEST);
+	}
+	ret = drv_replace_key(old_key->local, sdata,
+			      &sta->sta, &old_key->conf, &new_key->conf);
+
+	if (!ret)
+		new_key->flags |= KEY_FLAG_UPLOADED_TO_HARDWARE;
+	else
+		sdata_err(sdata,
+			  "failed to replace key (%d) with key " \
+			  "(%d) for STA, %pM in hardware (%d)\n",
+			  old_key->conf.keyidx,
+			  new_key->conf.keyidx,
+			  sta ? sta->sta.addr : bcast_addr, ret);
+
+	old_key->flags &= ~KEY_FLAG_UPLOADED_TO_HARDWARE;
+	return (ret);
 }
 
 static void __ieee80211_set_default_key(struct ieee80211_sub_if_data *sdata,
@@ -316,38 +370,55 @@ void ieee80211_set_default_mgmt_key(struct ieee80211_sub_if_data *sdata,
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
+		if(new && sta && pairwise) {
+			ret = ieee80211_hw_ptk_replace(old, new);
+			if (ret)
+				return ret;
+		}
+	} else {
 		idx = new->conf.keyidx;
+	}
+
+	if (new && !new->local->wowlan && (!sta || !old )) {
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
@@ -380,6 +451,7 @@ static void ieee80211_key_replace(struct ieee80211_sub_if_data *sdata,
 
 	if (old)
 		list_del_rcu(&old->list);
+	return 0;
 }
 
 struct ieee80211_key *
@@ -654,7 +726,6 @@ int ieee80211_key_link(struct ieee80211_key *key,
 		       struct ieee80211_sub_if_data *sdata,
 		       struct sta_info *sta)
 {
-	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_key *old_key;
 	int idx, ret;
 	bool pairwise;
@@ -687,19 +758,14 @@ int ieee80211_key_link(struct ieee80211_key *key,
 
 	increment_tailroom_need_count(sdata);
 
-	ieee80211_key_replace(sdata, sta, pairwise, old_key, key);
-	ieee80211_key_destroy(old_key, true);
+	ret = ieee80211_key_replace(sdata, sta, pairwise, old_key, key);
 
-	ieee80211_debugfs_key_add(key);
-
-	if (!local->wowlan) {
-		ret = ieee80211_key_enable_hw_accel(key);
-		if (ret)
-			ieee80211_key_free(key, true);
+	if (!ret) {
+		ieee80211_debugfs_key_add(key);
+		ieee80211_key_destroy(old_key, true);
 	} else {
-		ret = 0;
+		ieee80211_key_free(key, true);
 	}
-
  out:
 	mutex_unlock(&sdata->local->key_mtx);
 
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index 0ab69a1964f8..f93e00f1ae4d 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -603,6 +603,45 @@ TRACE_EVENT(drv_set_key,
 	)
 );
 
+TRACE_EVENT(drv_replace_key,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_sub_if_data *sdata,
+		 struct ieee80211_sta *sta,
+		 struct ieee80211_key_conf *old_key,
+		 struct ieee80211_key_conf *new_key),
+
+	TP_ARGS(local, sdata, sta, old_key, new_key),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		VIF_ENTRY
+		STA_ENTRY
+		KEY_ENTRY
+		__field(u32, cipher2)
+		__field(u8, hw_key_idx2)
+		__field(u8, flags2)
+		__field(s8, keyidx2)
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		VIF_ASSIGN;
+		STA_ASSIGN;
+		KEY_ASSIGN(old_key);
+		__entry->cipher2 = new_key->cipher;
+		__entry->flags2 = new_key->flags;
+		__entry->keyidx2 = new_key->keyidx;
+		__entry->hw_key_idx2 = new_key->hw_key_idx;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT  VIF_PR_FMT  STA_PR_FMT KEY_PR_FMT
+		" cipher2:0x%x, flags2=%#x, keyidx2=%d, hw_key_idx2=%d",
+		LOCAL_PR_ARG, VIF_PR_ARG, STA_PR_ARG, KEY_PR_ARG,
+		__entry->cipher2, __entry->flags2, __entry->keyidx2, __entry->hw_key_idx2
+	)
+);
+
 TRACE_EVENT(drv_update_tkip_key,
 	TP_PROTO(struct ieee80211_local *local,
 		 struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 5b93bde248fd..f897de5dcf83 100644
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
2.17.1
