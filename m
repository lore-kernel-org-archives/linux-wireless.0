Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 1.mo7.mail-out.ovh.net ([178.33.45.51]:40655 "EHLO
        1.mo7.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752392AbeEOSjz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 May 2018 14:39:55 -0400
Received: from player696.ha.ovh.net (unknown [10.109.108.35])
        by mo7.mail-out.ovh.net (Postfix) with ESMTP id 69B49A8021
        for <linux-wireless@vger.kernel.org>; Tue, 15 May 2018 12:22:59 +0200 (CEST)
From: Alexander Wetzel <alexander.wetzel@web.de>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, greearb@candelatech.com,
        s.gottschall@dd-wrt.com, Alexander Wetzel <alexander.wetzel@web.de>
Subject: [PATCH v2] mac80211: Fix wlan freezes under load at rekey
Date: Tue, 15 May 2018 12:22:02 +0200
Message-Id: <20180515102202.2021-1-alexander.wetzel@web.de> (sfid-20180515_204001_215652_02257D78)
In-Reply-To: <1523258757.3076.5.camel@sipsolutions.net>
References: <1523258757.3076.5.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rekeying a pairwise key with encryption offload and only keyid 0 has two
potential races which can freeze the wlan conection till rekeyed again:

 1) For incomming packets:
    If the local STA installs the key prior to the remote STA we still
    have the old key active in the hardware for a short time after
    mac80211 switched to the new key.
    The card can still hand over packets decoded with the old key to
    mac80211, bumping the new PN (IV) value to an incorrect high number and
    tricking the local replay detection to drop all packets really sent
    with the new key.

 2) For outgoing packets:
    If mac80211 is providing the PN (IV) and hands over the cleartext
    packets for encryption to the hardware immediately prior to a key
    change the driver/card may process the queued packets after
    switching to the new key.
    This will immediatelly bump the PN (IV) value on the remote STA to
    an incorrect high number, also freezing the connection.

Both issues can be prevented by first replacing the key in the HW and
makeing sure no aggregation sessions are running during the rekey.

Signed-off-by: Alexander Wetzel <alexander.wetzel@web.de>
---
 net/mac80211/key.c | 54 ++++++++++++++++++++++++++++++++++------------
 1 file changed, 40 insertions(+), 14 deletions(-)

diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index ee0d0cc8dc3b..bb498f2b6c44 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -248,6 +248,7 @@ static void ieee80211_key_disable_hw_accel(struct ieee80211_key *key)
 	      (key->conf.flags & IEEE80211_KEY_FLAG_RESERVE_TAILROOM)))
 		increment_tailroom_need_count(sdata);
 
+	key->flags &= ~KEY_FLAG_UPLOADED_TO_HARDWARE;
 	ret = drv_set_key(key->local, DISABLE_KEY, sdata,
 			  sta ? &sta->sta : NULL, &key->conf);
 
@@ -257,7 +258,26 @@ static void ieee80211_key_disable_hw_accel(struct ieee80211_key *key)
 			  key->conf.keyidx,
 			  sta ? sta->sta.addr : bcast_addr, ret);
 
-	key->flags &= ~KEY_FLAG_UPLOADED_TO_HARDWARE;
+}
+
+static void ieee80211_key_retire(struct ieee80211_key *key)
+{
+	struct ieee80211_local *local = key->local;
+	struct sta_info *sta = key->sta;
+
+	assert_key_lock(key->local);
+
+	/* Stop TX till we are on the new key */
+	key->flags |= KEY_FLAG_TAINTED;
+	ieee80211_clear_fast_xmit(sta);
+
+	if (ieee80211_hw_check(&local->hw, AMPDU_AGGREGATION)) {
+		set_sta_flag(sta, WLAN_STA_BLOCK_BA);
+		ieee80211_sta_tear_down_BA_sessions(
+		    sta, AGG_STOP_LOCAL_REQUEST);
+	}
+	ieee80211_flush_queues(key->local, key->sdata, false);
+	ieee80211_key_disable_hw_accel(key);
 }
 
 static void __ieee80211_set_default_key(struct ieee80211_sub_if_data *sdata,
@@ -316,34 +336,45 @@ void ieee80211_set_default_mgmt_key(struct ieee80211_sub_if_data *sdata,
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
+		if(new && sta && pairwise)
+			ieee80211_key_retire(old);
+	} else {
 		idx = new->conf.keyidx;
+	}
+
+	if (new && !new->local->wowlan) {
+		ret = ieee80211_key_enable_hw_accel(new);
+		if (ret)
+			return ret;
+	}
 
 	if (sta) {
 		if (pairwise) {
 			rcu_assign_pointer(sta->ptk[idx], new);
 			sta->ptk_idx = idx;
 			ieee80211_check_fast_xmit(sta);
+			clear_sta_flag(sta, WLAN_STA_BLOCK_BA);
 		} else {
 			rcu_assign_pointer(sta->gtk[idx], new);
 		}
@@ -380,6 +411,7 @@ static void ieee80211_key_replace(struct ieee80211_sub_if_data *sdata,
 
 	if (old)
 		list_del_rcu(&old->list);
+	return 0;
 }
 
 struct ieee80211_key *
@@ -654,7 +686,6 @@ int ieee80211_key_link(struct ieee80211_key *key,
 		       struct ieee80211_sub_if_data *sdata,
 		       struct sta_info *sta)
 {
-	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_key *old_key;
 	int idx, ret;
 	bool pairwise;
@@ -687,18 +718,13 @@ int ieee80211_key_link(struct ieee80211_key *key,
 
 	increment_tailroom_need_count(sdata);
 
-	ieee80211_key_replace(sdata, sta, pairwise, old_key, key);
+	ret = ieee80211_key_replace(sdata, sta, pairwise, old_key, key);
 	ieee80211_key_destroy(old_key, true);
 
 	ieee80211_debugfs_key_add(key);
 
-	if (!local->wowlan) {
-		ret = ieee80211_key_enable_hw_accel(key);
-		if (ret)
-			ieee80211_key_free(key, true);
-	} else {
-		ret = 0;
-	}
+	if (ret)
+		ieee80211_key_free(key, true);
 
  out:
 	mutex_unlock(&sdata->local->key_mtx);
-- 
2.17.0
