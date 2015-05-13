Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f44.google.com ([209.85.215.44]:33919 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820AbbEMJRA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 May 2015 05:17:00 -0400
Received: by laat2 with SMTP id t2so24748035laa.1
        for <linux-wireless@vger.kernel.org>; Wed, 13 May 2015 02:16:58 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 1/2] mac80211: fix AP_VLAN crypto tailroom calculation
Date: Wed, 13 May 2015 09:16:48 +0000
Message-Id: <1431508609-9841-1-git-send-email-michal.kazior@tieto.com> (sfid-20150513_111710_239750_9DCA9270)
In-Reply-To: <1431349503-5461-1-git-send-email-michal.kazior@tieto.com>
References: <1431349503-5461-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some splats I was seeing:

 (a) WARNING: CPU: 1 PID: 0 at /devel/src/linux/net/mac80211/wep.c:102 ieee80211_wep_add_iv
 (b) WARNING: CPU: 1 PID: 0 at /devel/src/linux/net/mac80211/wpa.c:73 ieee80211_tx_h_michael_mic_add
 (c) WARNING: CPU: 3 PID: 0 at /devel/src/linux/net/mac80211/wpa.c:433 ieee80211_crypto_ccmp_encrypt

I've seen (a) and (b) with ath9k hw crypto and (c)
with ath9k sw crypto. All of them were related to
insufficient skb tailroom and I was able to
trigger these with ping6 program.

AP_VLANs may inherit crypto keys from parent AP.
This wasn't considered and yielded problems in
some setups resulting in inability to transmit
data because mac80211 wouldn't resize skbs when
necessary and subsequently drop some packets due
to insufficient tailroom.

For efficiency purposes don't inspect both AP_VLAN
and AP sdata looking for tailroom counter. Instead
update AP_VLAN tailroom counters whenever their
master AP tailroom counter changes.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---

Notes:
    v2:
     * update AP_VLAN tailroom counters on AP tailroom changes
       instead of checking both AP_VLAN and AP sdatas on Tx path
       for efficiency purposes [Johannes]
     * refactor commit log a bit

 net/mac80211/iface.c |  6 ++++
 net/mac80211/key.c   | 82 ++++++++++++++++++++++++++++++++++++++++++++++------
 net/mac80211/key.h   |  1 +
 net/mac80211/util.c  |  3 ++
 4 files changed, 83 insertions(+), 9 deletions(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index dc2d7133c4f6..3f58d37ea057 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -522,6 +522,12 @@ int ieee80211_do_open(struct wireless_dev *wdev, bool coming_up)
 		memcpy(sdata->vif.hw_queue, master->vif.hw_queue,
 		       sizeof(sdata->vif.hw_queue));
 		sdata->vif.bss_conf.chandef = master->vif.bss_conf.chandef;
+
+		mutex_lock(&local->key_mtx);
+		sdata->crypto_tx_tailroom_needed_cnt +=
+			master->crypto_tx_tailroom_needed_cnt;
+		mutex_unlock(&local->key_mtx);
+
 		break;
 		}
 	case NL80211_IFTYPE_AP:
diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index 2e677376c958..577a11a13cdf 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -58,6 +58,22 @@ static void assert_key_lock(struct ieee80211_local *local)
 	lockdep_assert_held(&local->key_mtx);
 }
 
+static void
+update_vlan_tailroom_need_count(struct ieee80211_sub_if_data *sdata, int delta)
+{
+	struct ieee80211_sub_if_data *vlan;
+
+	if (sdata->vif.type != NL80211_IFTYPE_AP)
+		return;
+
+	mutex_lock(&sdata->local->mtx);
+
+	list_for_each_entry(vlan, &sdata->u.ap.vlans, u.vlan.list)
+		vlan->crypto_tx_tailroom_needed_cnt += delta;
+
+	mutex_unlock(&sdata->local->mtx);
+}
+
 static void increment_tailroom_need_count(struct ieee80211_sub_if_data *sdata)
 {
 	/*
@@ -79,6 +95,8 @@ static void increment_tailroom_need_count(struct ieee80211_sub_if_data *sdata)
 	 * http://mid.gmane.org/1308590980.4322.19.camel@jlt3.sipsolutions.net
 	 */
 
+	update_vlan_tailroom_need_count(sdata, 1);
+
 	if (!sdata->crypto_tx_tailroom_needed_cnt++) {
 		/*
 		 * Flush all XMIT packets currently using HW encryption or no
@@ -88,6 +106,15 @@ static void increment_tailroom_need_count(struct ieee80211_sub_if_data *sdata)
 	}
 }
 
+static void decrease_tailroom_need_count(struct ieee80211_sub_if_data *sdata,
+					 int delta)
+{
+	WARN_ON_ONCE(sdata->crypto_tx_tailroom_needed_cnt < delta);
+
+	update_vlan_tailroom_need_count(sdata, -delta);
+	sdata->crypto_tx_tailroom_needed_cnt -= delta;
+}
+
 static int ieee80211_key_enable_hw_accel(struct ieee80211_key *key)
 {
 	struct ieee80211_sub_if_data *sdata;
@@ -144,7 +171,7 @@ static int ieee80211_key_enable_hw_accel(struct ieee80211_key *key)
 
 		if (!((key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_MMIC) ||
 		      (key->conf.flags & IEEE80211_KEY_FLAG_RESERVE_TAILROOM)))
-			sdata->crypto_tx_tailroom_needed_cnt--;
+			decrease_tailroom_need_count(sdata, 1);
 
 		WARN_ON((key->conf.flags & IEEE80211_KEY_FLAG_PUT_IV_SPACE) &&
 			(key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_IV));
@@ -545,7 +572,7 @@ static void __ieee80211_key_destroy(struct ieee80211_key *key,
 			schedule_delayed_work(&sdata->dec_tailroom_needed_wk,
 					      HZ/2);
 		} else {
-			sdata->crypto_tx_tailroom_needed_cnt--;
+			decrease_tailroom_need_count(sdata, 1);
 		}
 	}
 
@@ -635,6 +662,7 @@ void ieee80211_key_free(struct ieee80211_key *key, bool delay_tailroom)
 void ieee80211_enable_keys(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_key *key;
+	struct ieee80211_sub_if_data *vlan;
 
 	ASSERT_RTNL();
 
@@ -643,7 +671,14 @@ void ieee80211_enable_keys(struct ieee80211_sub_if_data *sdata)
 
 	mutex_lock(&sdata->local->key_mtx);
 
-	sdata->crypto_tx_tailroom_needed_cnt = 0;
+	WARN_ON_ONCE(sdata->crypto_tx_tailroom_needed_cnt ||
+		     sdata->crypto_tx_tailroom_pending_dec);
+
+	if (sdata->vif.type == NL80211_IFTYPE_AP) {
+		list_for_each_entry(vlan, &sdata->u.ap.vlans, u.vlan.list)
+			WARN_ON_ONCE(vlan->crypto_tx_tailroom_needed_cnt ||
+				     vlan->crypto_tx_tailroom_pending_dec);
+	}
 
 	list_for_each_entry(key, &sdata->key_list, list) {
 		increment_tailroom_need_count(sdata);
@@ -653,6 +688,22 @@ void ieee80211_enable_keys(struct ieee80211_sub_if_data *sdata)
 	mutex_unlock(&sdata->local->key_mtx);
 }
 
+void ieee80211_reset_crypto_tx_tailroom(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_sub_if_data *vlan;
+
+	mutex_lock(&sdata->local->key_mtx);
+
+	sdata->crypto_tx_tailroom_needed_cnt = 0;
+
+	if (sdata->vif.type == NL80211_IFTYPE_AP) {
+		list_for_each_entry(vlan, &sdata->u.ap.vlans, u.vlan.list)
+			vlan->crypto_tx_tailroom_needed_cnt = 0;
+	}
+
+	mutex_unlock(&sdata->local->key_mtx);
+}
+
 void ieee80211_iter_keys(struct ieee80211_hw *hw,
 			 struct ieee80211_vif *vif,
 			 void (*iter)(struct ieee80211_hw *hw,
@@ -692,8 +743,8 @@ static void ieee80211_free_keys_iface(struct ieee80211_sub_if_data *sdata,
 {
 	struct ieee80211_key *key, *tmp;
 
-	sdata->crypto_tx_tailroom_needed_cnt -=
-		sdata->crypto_tx_tailroom_pending_dec;
+	decrease_tailroom_need_count(sdata,
+				     sdata->crypto_tx_tailroom_pending_dec);
 	sdata->crypto_tx_tailroom_pending_dec = 0;
 
 	ieee80211_debugfs_key_remove_mgmt_default(sdata);
@@ -713,6 +764,7 @@ void ieee80211_free_keys(struct ieee80211_sub_if_data *sdata,
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_sub_if_data *vlan;
+	struct ieee80211_sub_if_data *master;
 	struct ieee80211_key *key, *tmp;
 	LIST_HEAD(keys);
 
@@ -732,8 +784,20 @@ void ieee80211_free_keys(struct ieee80211_sub_if_data *sdata,
 	list_for_each_entry_safe(key, tmp, &keys, list)
 		__ieee80211_key_destroy(key, false);
 
-	WARN_ON_ONCE(sdata->crypto_tx_tailroom_needed_cnt ||
-		     sdata->crypto_tx_tailroom_pending_dec);
+	if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN) {
+		if (sdata->bss) {
+			master = container_of(sdata->bss,
+					      struct ieee80211_sub_if_data,
+					      u.ap);
+
+			WARN_ON_ONCE(sdata->crypto_tx_tailroom_needed_cnt !=
+				     master->crypto_tx_tailroom_needed_cnt);
+		}
+	} else {
+		WARN_ON_ONCE(sdata->crypto_tx_tailroom_needed_cnt ||
+			     sdata->crypto_tx_tailroom_pending_dec);
+	}
+
 	if (sdata->vif.type == NL80211_IFTYPE_AP) {
 		list_for_each_entry(vlan, &sdata->u.ap.vlans, u.vlan.list)
 			WARN_ON_ONCE(vlan->crypto_tx_tailroom_needed_cnt ||
@@ -797,8 +861,8 @@ void ieee80211_delayed_tailroom_dec(struct work_struct *wk)
 	 */
 
 	mutex_lock(&sdata->local->key_mtx);
-	sdata->crypto_tx_tailroom_needed_cnt -=
-		sdata->crypto_tx_tailroom_pending_dec;
+	decrease_tailroom_need_count(sdata,
+				     sdata->crypto_tx_tailroom_pending_dec);
 	sdata->crypto_tx_tailroom_pending_dec = 0;
 	mutex_unlock(&sdata->local->key_mtx);
 }
diff --git a/net/mac80211/key.h b/net/mac80211/key.h
index df430a618764..2119526db2f4 100644
--- a/net/mac80211/key.h
+++ b/net/mac80211/key.h
@@ -160,6 +160,7 @@ void ieee80211_free_keys(struct ieee80211_sub_if_data *sdata,
 void ieee80211_free_sta_keys(struct ieee80211_local *local,
 			     struct sta_info *sta);
 void ieee80211_enable_keys(struct ieee80211_sub_if_data *sdata);
+void ieee80211_reset_crypto_tx_tailroom(struct ieee80211_sub_if_data *sdata);
 
 #define key_mtx_dereference(local, ref) \
 	rcu_dereference_protected(ref, lockdep_is_held(&((local)->key_mtx)))
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 79412f16b61d..b864ebc6ab8f 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -2023,6 +2023,9 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 
 	/* add back keys */
 	list_for_each_entry(sdata, &local->interfaces, list)
+		ieee80211_reset_crypto_tx_tailroom(sdata);
+
+	list_for_each_entry(sdata, &local->interfaces, list)
 		if (ieee80211_sdata_running(sdata))
 			ieee80211_enable_keys(sdata);
 
-- 
2.1.4

