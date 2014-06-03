Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:58535 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752355AbaFCJS5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jun 2014 05:18:57 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: fix station/driver powersave race
Date: Tue,  3 Jun 2014 11:18:47 +0200
Message-Id: <1401787127-8566-1-git-send-email-johannes@sipsolutions.net> (sfid-20140603_111911_926294_F48B6E13)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

It is currently possible to have a race due to the station PS
unblock work like this:
 * station goes to sleep with frames buffered in the driver
 * driver blocks wakeup
 * station wakes up again
 * driver flushes/returns frames, and unblocks, which schedules
   the unblock work
 * unblock work starts to run, and checks that the station is
   awake (i.e. that the WLAN_STA_PS_STA flag isn't set)
 * we process a received frame with PM=1, setting the flag again
 * ieee80211_sta_ps_deliver_wakeup() runs, delivering all frames
   to the driver, and then clearing the WLAN_STA_PS_DRIVER and
   WLAN_STA_PS_STA flags

In this scenario, mac80211 will think that the station is awake,
while it really is asleep, and any TX'ed frames should be filtered
by the device (it will know that the station is sleeping) but then
passed to mac80211 again, which will not buffer it either as it
thinks the station is awake, and eventually the packets will be
dropped.

Fix this by moving the clearing of the flags to exactly where we
learn about the situation. This creates a problem of reordering,
so introduce another flag indicating that delivery is being done,
this new flag also queues frames and is cleared only while the
spinlock is held (which the queuing code also holds) so that any
concurrent delivery/TX is handled correctly.

Reported-by: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/rx.c       |  2 ++
 net/mac80211/sta_info.c | 65 ++++++++++++++++++++++++++++++-------------------
 net/mac80211/sta_info.h |  5 ++--
 net/mac80211/tx.c       |  6 +++--
 4 files changed, 49 insertions(+), 29 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 0e5b67015650..fb44f48340c2 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1107,6 +1107,8 @@ static void sta_ps_end(struct sta_info *sta)
 		return;
 	}
 
+	set_sta_flag(sta, WLAN_STA_PS_DELIVER);
+	clear_sta_flag(sta, WLAN_STA_PS_STA);
 	ieee80211_sta_ps_deliver_wakeup(sta);
 }
 
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index be9120fb8448..c682e3c95f94 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -100,7 +100,8 @@ static void __cleanup_single_sta(struct sta_info *sta)
 	struct ps_data *ps;
 
 	if (test_sta_flag(sta, WLAN_STA_PS_STA) ||
-	    test_sta_flag(sta, WLAN_STA_PS_DRIVER)) {
+	    test_sta_flag(sta, WLAN_STA_PS_DRIVER) ||
+	    test_sta_flag(sta, WLAN_STA_PS_DELIVER)) {
 		if (sta->sdata->vif.type == NL80211_IFTYPE_AP ||
 		    sta->sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
 			ps = &sdata->bss->ps;
@@ -111,6 +112,7 @@ static void __cleanup_single_sta(struct sta_info *sta)
 
 		clear_sta_flag(sta, WLAN_STA_PS_STA);
 		clear_sta_flag(sta, WLAN_STA_PS_DRIVER);
+		clear_sta_flag(sta, WLAN_STA_PS_DELIVER);
 
 		atomic_dec(&ps->num_sta_ps);
 		sta_info_recalc_tim(sta);
@@ -125,7 +127,7 @@ static void __cleanup_single_sta(struct sta_info *sta)
 	if (ieee80211_vif_is_mesh(&sdata->vif))
 		mesh_sta_cleanup(sta);
 
-	cancel_work_sync(&sta->drv_unblock_wk);
+	cancel_work_sync(&sta->drv_deliver_wk);
 
 	/*
 	 * Destroy aggregation state here. It would be nice to wait for the
@@ -253,33 +255,23 @@ static void sta_info_hash_add(struct ieee80211_local *local,
 	rcu_assign_pointer(local->sta_hash[STA_HASH(sta->sta.addr)], sta);
 }
 
-static void sta_unblock(struct work_struct *wk)
+static void sta_deliver_ps_frames(struct work_struct *wk)
 {
 	struct sta_info *sta;
 
-	sta = container_of(wk, struct sta_info, drv_unblock_wk);
+	sta = container_of(wk, struct sta_info, drv_deliver_wk);
 
 	if (sta->dead)
 		return;
 
-	if (!test_sta_flag(sta, WLAN_STA_PS_STA)) {
-		local_bh_disable();
+	local_bh_disable();
+	if (!test_sta_flag(sta, WLAN_STA_PS_STA))
 		ieee80211_sta_ps_deliver_wakeup(sta);
-		local_bh_enable();
-	} else if (test_and_clear_sta_flag(sta, WLAN_STA_PSPOLL)) {
-		clear_sta_flag(sta, WLAN_STA_PS_DRIVER);
-
-		local_bh_disable();
+	else if (test_and_clear_sta_flag(sta, WLAN_STA_PSPOLL))
 		ieee80211_sta_ps_deliver_poll_response(sta);
-		local_bh_enable();
-	} else if (test_and_clear_sta_flag(sta, WLAN_STA_UAPSD)) {
-		clear_sta_flag(sta, WLAN_STA_PS_DRIVER);
-
-		local_bh_disable();
+	else if (test_and_clear_sta_flag(sta, WLAN_STA_UAPSD))
 		ieee80211_sta_ps_deliver_uapsd(sta);
-		local_bh_enable();
-	} else
-		clear_sta_flag(sta, WLAN_STA_PS_DRIVER);
+	local_bh_enable();
 }
 
 static int sta_prepare_rate_control(struct ieee80211_local *local,
@@ -341,7 +333,7 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
 
 	spin_lock_init(&sta->lock);
 	spin_lock_init(&sta->ps_lock);
-	INIT_WORK(&sta->drv_unblock_wk, sta_unblock);
+	INIT_WORK(&sta->drv_deliver_wk, sta_deliver_ps_frames);
 	INIT_WORK(&sta->ampdu_mlme.work, ieee80211_ba_session_work);
 	mutex_init(&sta->ampdu_mlme.mtx);
 #ifdef CONFIG_MAC80211_MESH
@@ -1141,8 +1133,15 @@ void ieee80211_sta_ps_deliver_wakeup(struct sta_info *sta)
 	}
 
 	ieee80211_add_pending_skbs(local, &pending);
-	clear_sta_flag(sta, WLAN_STA_PS_DRIVER);
-	clear_sta_flag(sta, WLAN_STA_PS_STA);
+
+	/* now we're no longer in the deliver code */
+	clear_sta_flag(sta, WLAN_STA_PS_DELIVER);
+
+	/* The station might have polled and then woken up before we responded,
+	 * so clear these flags now to avoid them sticking around.
+	 */
+	clear_sta_flag(sta, WLAN_STA_PSPOLL);
+	clear_sta_flag(sta, WLAN_STA_UAPSD);
 	spin_unlock(&sta->ps_lock);
 
 	atomic_dec(&ps->num_sta_ps);
@@ -1542,10 +1541,26 @@ void ieee80211_sta_block_awake(struct ieee80211_hw *hw,
 
 	trace_api_sta_block_awake(sta->local, pubsta, block);
 
-	if (block)
+	if (block) {
 		set_sta_flag(sta, WLAN_STA_PS_DRIVER);
-	else if (test_sta_flag(sta, WLAN_STA_PS_DRIVER))
-		ieee80211_queue_work(hw, &sta->drv_unblock_wk);
+		return;
+	}
+
+	if (!test_sta_flag(sta, WLAN_STA_PS_DRIVER))
+		return;
+
+	if (!test_sta_flag(sta, WLAN_STA_PS_STA)) {
+		set_sta_flag(sta, WLAN_STA_PS_DELIVER);
+		clear_sta_flag(sta, WLAN_STA_PS_DRIVER);
+		ieee80211_queue_work(hw, &sta->drv_deliver_wk);
+	} else if (test_sta_flag(sta, WLAN_STA_PSPOLL) ||
+		   test_sta_flag(sta, WLAN_STA_UAPSD)) {
+		/* must be asleep in this case */
+		clear_sta_flag(sta, WLAN_STA_PS_DRIVER);
+		ieee80211_queue_work(hw, &sta->drv_deliver_wk);
+	} else {
+		clear_sta_flag(sta, WLAN_STA_PS_DRIVER);
+	}
 }
 EXPORT_SYMBOL(ieee80211_sta_block_awake);
 
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 4acc5fc402fa..97152c946a7c 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -82,6 +82,7 @@ enum ieee80211_sta_info_flags {
 	WLAN_STA_TOFFSET_KNOWN,
 	WLAN_STA_MPSP_OWNER,
 	WLAN_STA_MPSP_RECIPIENT,
+	WLAN_STA_PS_DELIVER,
 };
 
 #define ADDBA_RESP_INTERVAL HZ
@@ -265,7 +266,7 @@ struct ieee80211_tx_latency_stat {
  * @last_rx_rate_vht_nss: rx status nss of last data packet
  * @lock: used for locking all fields that require locking, see comments
  *	in the header file.
- * @drv_unblock_wk: used for driver PS unblocking
+ * @drv_deliver_wk: used for delivering frames after driver PS unblocking
  * @listen_interval: listen interval of this station, when we're acting as AP
  * @_flags: STA flags, see &enum ieee80211_sta_info_flags, do not use directly
  * @ps_lock: used for powersave (when mac80211 is the AP) related locking
@@ -345,7 +346,7 @@ struct sta_info {
 	void *rate_ctrl_priv;
 	spinlock_t lock;
 
-	struct work_struct drv_unblock_wk;
+	struct work_struct drv_deliver_wk;
 
 	u16 listen_interval;
 
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 5214686d9fd1..8170d9945d6d 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -469,7 +469,8 @@ ieee80211_tx_h_unicast_ps_buf(struct ieee80211_tx_data *tx)
 		return TX_CONTINUE;
 
 	if (unlikely((test_sta_flag(sta, WLAN_STA_PS_STA) ||
-		      test_sta_flag(sta, WLAN_STA_PS_DRIVER)) &&
+		      test_sta_flag(sta, WLAN_STA_PS_DRIVER) ||
+		      test_sta_flag(sta, WLAN_STA_PS_DELIVER)) &&
 		     !(info->flags & IEEE80211_TX_CTL_NO_PS_BUFFER))) {
 		int ac = skb_get_queue_mapping(tx->skb);
 
@@ -486,7 +487,8 @@ ieee80211_tx_h_unicast_ps_buf(struct ieee80211_tx_data *tx)
 		 * ahead and Tx the packet.
 		 */
 		if (!test_sta_flag(sta, WLAN_STA_PS_STA) &&
-		    !test_sta_flag(sta, WLAN_STA_PS_DRIVER)) {
+		    !test_sta_flag(sta, WLAN_STA_PS_DRIVER) &&
+		    !test_sta_flag(sta, WLAN_STA_PS_DELIVER)) {
 			spin_unlock(&sta->ps_lock);
 			return TX_CONTINUE;
 		}
-- 
2.0.0.rc0

