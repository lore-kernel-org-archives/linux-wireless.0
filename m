Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35578 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755961Ab0FGLDZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jun 2010 07:03:25 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.71)
	(envelope-from <johannes@sipsolutions.net>)
	id 1OLa72-0007Eq-Fx
	for linux-wireless@vger.kernel.org; Mon, 07 Jun 2010 13:03:24 +0200
Message-Id: <20100607110202.399119520@sipsolutions.net>
Date: Mon, 07 Jun 2010 13:01:51 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFC 18/21] mac80211: change RX aggregation locking
References: <20100607110133.472649120@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

To prepare for allowing drivers to sleep in
ampdu_action, change the locking in the RX
aggregation code to use a mutex, so that it
would already allow drivers to sleep. But
explicitly disable BHs around the callback
for now since the TX part cannot yet sleep,
and drivers' locking might require it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/agg-rx.c     |   10 +++++-----
 net/mac80211/driver-ops.h |    2 ++
 net/mac80211/ht.c         |    6 +++++-
 net/mac80211/iface.c      |    8 ++++----
 net/mac80211/sta_info.c   |    1 +
 net/mac80211/sta_info.h   |    3 +++
 6 files changed, 20 insertions(+), 10 deletions(-)

--- wireless-testing.orig/net/mac80211/iface.c	2010-06-06 15:43:50.000000000 +0200
+++ wireless-testing/net/mac80211/iface.c	2010-06-06 15:44:42.000000000 +0200
@@ -740,7 +740,7 @@ static void ieee80211_iface_work(struct
 			   mgmt->u.action.category == WLAN_CATEGORY_BACK) {
 			int len = skb->len;
 
-			rcu_read_lock();
+			mutex_lock(&local->sta_mtx);
 			sta = sta_info_get(sdata, mgmt->sa);
 			if (sta) {
 				switch (mgmt->u.action.u.addba_req.action_code) {
@@ -761,7 +761,7 @@ static void ieee80211_iface_work(struct
 					break;
 				}
 			}
-			rcu_read_unlock();
+			mutex_unlock(&local->sta_mtx);
 		} else if (ieee80211_is_data_qos(mgmt->frame_control)) {
 			struct ieee80211_hdr *hdr = (void *)mgmt;
 			/*
@@ -781,7 +781,7 @@ static void ieee80211_iface_work(struct
 			 * a block-ack session was active. That cannot be
 			 * right, so terminate the session.
 			 */
-			rcu_read_lock();
+			mutex_lock(&local->sta_mtx);
 			sta = sta_info_get(sdata, mgmt->sa);
 			if (sta) {
 				u16 tid = *ieee80211_get_qos_ctl(hdr) &
@@ -791,7 +791,7 @@ static void ieee80211_iface_work(struct
 					sta, tid, WLAN_BACK_RECIPIENT,
 					WLAN_REASON_QSTA_REQUIRE_SETUP);
 			}
-			rcu_read_unlock();
+			mutex_unlock(&local->sta_mtx);
 		} else switch (sdata->vif.type) {
 		case NL80211_IFTYPE_STATION:
 			ieee80211_sta_rx_queued_mgmt(sdata, skb);
--- wireless-testing.orig/net/mac80211/driver-ops.h	2010-06-06 15:43:50.000000000 +0200
+++ wireless-testing/net/mac80211/driver-ops.h	2010-06-06 15:44:42.000000000 +0200
@@ -349,9 +349,11 @@ static inline int drv_ampdu_action(struc
 				   u16 *ssn)
 {
 	int ret = -EOPNOTSUPP;
+	local_bh_disable();
 	if (local->ops->ampdu_action)
 		ret = local->ops->ampdu_action(&local->hw, &sdata->vif, action,
 					       sta, tid, ssn);
+	local_bh_enable();
 	trace_drv_ampdu_action(local, sdata, action, sta, tid, ssn, ret);
 	return ret;
 }
--- wireless-testing.orig/net/mac80211/sta_info.c	2010-06-06 15:43:50.000000000 +0200
+++ wireless-testing/net/mac80211/sta_info.c	2010-06-06 15:44:42.000000000 +0200
@@ -236,6 +236,7 @@ struct sta_info *sta_info_alloc(struct i
 	spin_lock_init(&sta->flaglock);
 	INIT_WORK(&sta->drv_unblock_wk, sta_unblock);
 	INIT_WORK(&sta->ampdu_mlme.work, ieee80211_ba_session_work);
+	mutex_init(&sta->ampdu_mlme.mtx);
 
 	memcpy(sta->sta.addr, addr, ETH_ALEN);
 	sta->local = local;
--- wireless-testing.orig/net/mac80211/sta_info.h	2010-06-06 15:44:11.000000000 +0200
+++ wireless-testing/net/mac80211/sta_info.h	2010-06-06 15:44:42.000000000 +0200
@@ -142,8 +142,11 @@ struct tid_ampdu_rx {
  * @work: work struct for starting/stopping aggregation
  * @tid_rx_timer_expired: bitmap indicating on which TIDs the
  *	RX timer expired until the work for it runs
+ * @mtx: mutex to protect all TX data (except non-NULL assignments
+ *	to tid_tx[idx], which are protected by the sta spinlock)
  */
 struct sta_ampdu_mlme {
+	struct mutex mtx;
 	/* rx */
 	struct tid_ampdu_rx *tid_rx[STA_TID_NUM];
 	unsigned long tid_rx_timer_expired[BITS_TO_LONGS(STA_TID_NUM)];
--- wireless-testing.orig/net/mac80211/agg-rx.c	2010-06-06 15:44:15.000000000 +0200
+++ wireless-testing/net/mac80211/agg-rx.c	2010-06-06 15:44:42.000000000 +0200
@@ -38,7 +38,7 @@ void ___ieee80211_stop_rx_ba_session(str
 	struct ieee80211_local *local = sta->local;
 	struct tid_ampdu_rx *tid_rx;
 
-	lockdep_assert_held(&sta->lock);
+	lockdep_assert_held(&sta->ampdu_mlme.mtx);
 
 	tid_rx = sta->ampdu_mlme.tid_rx[tid];
 
@@ -70,9 +70,9 @@ void ___ieee80211_stop_rx_ba_session(str
 void __ieee80211_stop_rx_ba_session(struct sta_info *sta, u16 tid,
 				    u16 initiator, u16 reason)
 {
-	spin_lock_bh(&sta->lock);
+	mutex_lock(&sta->ampdu_mlme.mtx);
 	___ieee80211_stop_rx_ba_session(sta, tid, initiator, reason);
-	spin_unlock_bh(&sta->lock);
+	mutex_unlock(&sta->ampdu_mlme.mtx);
 }
 
 /*
@@ -205,7 +205,7 @@ void ieee80211_process_addba_request(str
 
 
 	/* examine state machine */
-	spin_lock_bh(&sta->lock);
+	mutex_lock(&sta->ampdu_mlme.mtx);
 
 	if (sta->ampdu_mlme.tid_rx[tid]) {
 #ifdef CONFIG_MAC80211_HT_DEBUG
@@ -279,7 +279,7 @@ void ieee80211_process_addba_request(str
 		mod_timer(&tid_agg_rx->session_timer, TU_TO_EXP_TIME(timeout));
 
 end:
-	spin_unlock_bh(&sta->lock);
+	mutex_unlock(&sta->ampdu_mlme.mtx);
 
 end_no_lock:
 	ieee80211_send_addba_resp(sta->sdata, sta->sta.addr, tid,
--- wireless-testing.orig/net/mac80211/ht.c	2010-06-06 15:43:50.000000000 +0200
+++ wireless-testing/net/mac80211/ht.c	2010-06-06 15:44:42.000000000 +0200
@@ -130,13 +130,17 @@ void ieee80211_ba_session_work(struct wo
 	if (test_sta_flags(sta, WLAN_STA_BLOCK_BA))
 		return;
 
-	spin_lock_bh(&sta->lock);
+	mutex_lock(&sta->ampdu_mlme.mtx);
 	for (tid = 0; tid < STA_TID_NUM; tid++) {
 		if (test_and_clear_bit(tid, sta->ampdu_mlme.tid_rx_timer_expired))
 			___ieee80211_stop_rx_ba_session(
 				sta, tid, WLAN_BACK_RECIPIENT,
 				WLAN_REASON_QSTA_TIMEOUT);
+	}
+	mutex_unlock(&sta->ampdu_mlme.mtx);
 
+	spin_lock_bh(&sta->lock);
+	for (tid = 0; tid < STA_TID_NUM; tid++) {
 		tid_tx = sta->ampdu_mlme.tid_tx[tid];
 		if (!tid_tx)
 			continue;


