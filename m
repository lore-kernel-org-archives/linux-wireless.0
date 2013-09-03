Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f169.google.com ([74.125.82.169]:54933 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755569Ab3ICOeU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Sep 2013 10:34:20 -0400
Received: by mail-we0-f169.google.com with SMTP id t60so1767818wes.28
        for <linux-wireless@vger.kernel.org>; Tue, 03 Sep 2013 07:34:19 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <luca@coelho.fi>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 01/12] wlcore: ROC on AP channel before auth reply
Date: Tue,  3 Sep 2013 17:33:57 +0300
Message-Id: <1378218848-7853-1-git-send-email-eliad@wizery.com> (sfid-20130903_163430_825614_44746F09)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

Start a ROC on the AP channel beforing sending the authentication reply
to a connecting STA. This ROC is held up to 1 second via a timer. If the
station is authorized and added by mac80211, the ROC is extended until
the station is fully authorized.
We make sure not to ROC twice when several stations are connecting in
parallel and to only release the ROC when both the pending-reply timer
and the STA-state callbacks do not require it.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/ti/wlcore/main.c     | 101 +++++++++++++++++++++++++-----
 drivers/net/wireless/ti/wlcore/tx.c       |  25 ++++++--
 drivers/net/wireless/ti/wlcore/tx.h       |   3 +
 drivers/net/wireless/ti/wlcore/wlcore.h   |   2 +
 drivers/net/wireless/ti/wlcore/wlcore_i.h |   9 +++
 5 files changed, 120 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 38995f9..b64b465 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -2008,6 +2008,47 @@ out:
 	mutex_unlock(&wl->mutex);
 }
 
+static void wlcore_pending_auth_complete_work(struct work_struct *work)
+{
+	struct delayed_work *dwork;
+	struct wl1271 *wl;
+	struct wl12xx_vif *wlvif;
+	unsigned long time_spare;
+	int ret;
+
+	dwork = container_of(work, struct delayed_work, work);
+	wlvif = container_of(dwork, struct wl12xx_vif,
+			     pending_auth_complete_work);
+	wl = wlvif->wl;
+
+	mutex_lock(&wl->mutex);
+
+	if (unlikely(wl->state != WLCORE_STATE_ON))
+		goto out;
+
+	/*
+	 * Make sure a second really passed since the last auth reply. Maybe
+	 * a second auth reply arrived while we were stuck on the mutex.
+	 * Check for a little less than the timeout to protect from scheduler
+	 * irregularities.
+	 */
+	time_spare = jiffies +
+			msecs_to_jiffies(WLCORE_PEND_AUTH_ROC_TIMEOUT - 50);
+	if (!time_after(time_spare, wlvif->pending_auth_reply_time))
+		goto out;
+
+	ret = wl1271_ps_elp_wakeup(wl);
+	if (ret < 0)
+		goto out;
+
+	/* cancel the ROC if active */
+	wlcore_update_inconn_sta(wl, wlvif, NULL, false);
+
+	wl1271_ps_elp_sleep(wl);
+out:
+	mutex_unlock(&wl->mutex);
+}
+
 static int wl12xx_allocate_rate_policy(struct wl1271 *wl, u8 *idx)
 {
 	u8 policy = find_first_zero_bit(wl->rate_policies_map,
@@ -2159,6 +2200,8 @@ static int wl12xx_init_vif_data(struct wl1271 *wl, struct ieee80211_vif *vif)
 			  wlcore_channel_switch_work);
 	INIT_DELAYED_WORK(&wlvif->connection_loss_work,
 			  wlcore_connection_loss_work);
+	INIT_DELAYED_WORK(&wlvif->pending_auth_complete_work,
+			  wlcore_pending_auth_complete_work);
 	INIT_LIST_HEAD(&wlvif->list);
 
 	setup_timer(&wlvif->rx_streaming_timer, wl1271_rx_streaming_timer,
@@ -2590,6 +2633,7 @@ unlock:
 	cancel_work_sync(&wlvif->rx_streaming_disable_work);
 	cancel_delayed_work_sync(&wlvif->connection_loss_work);
 	cancel_delayed_work_sync(&wlvif->channel_switch_work);
+	cancel_delayed_work_sync(&wlvif->pending_auth_complete_work);
 
 	mutex_lock(&wl->mutex);
 }
@@ -3969,6 +4013,13 @@ static void wl1271_bss_info_changed_ap(struct wl1271 *wl,
 			}
 		} else {
 			if (test_bit(WLVIF_FLAG_AP_STARTED, &wlvif->flags)) {
+				/*
+				 * AP might be in ROC in case we have just
+				 * sent auth reply. handle it.
+				 */
+				if (test_bit(wlvif->role_id, wl->roc_map))
+					wl12xx_croc(wl, wlvif->role_id);
+
 				ret = wl12xx_cmd_role_stop_ap(wl, wlvif);
 				if (ret < 0)
 					goto out;
@@ -4656,29 +4707,49 @@ static void wlcore_roc_if_possible(struct wl1271 *wl,
 	wl12xx_roc(wl, wlvif, wlvif->role_id, wlvif->band, wlvif->channel);
 }
 
-static void wlcore_update_inconn_sta(struct wl1271 *wl,
-				     struct wl12xx_vif *wlvif,
-				     struct wl1271_station *wl_sta,
-				     bool in_connection)
+/*
+ * when wl_sta is NULL, we treat this call as if coming from a
+ * pending auth reply.
+ * wl->mutex must be taken and the FW must be awake when the call
+ * takes place.
+ */
+void wlcore_update_inconn_sta(struct wl1271 *wl, struct wl12xx_vif *wlvif,
+			      struct wl1271_station *wl_sta, bool in_conn)
 {
-	if (in_connection) {
-		if (WARN_ON(wl_sta->in_connection))
+	if (in_conn) {
+		if (WARN_ON(wl_sta && wl_sta->in_connection))
 			return;
-		wl_sta->in_connection = true;
-		if (!wlvif->inconn_count++)
+
+		if (!wlvif->ap_pending_auth_reply &&
+		    !wlvif->inconn_count)
 			wlcore_roc_if_possible(wl, wlvif);
+
+		if (wl_sta) {
+			wl_sta->in_connection = true;
+			wlvif->inconn_count++;
+		} else {
+			wlvif->ap_pending_auth_reply = true;
+		}
 	} else {
-		if (!wl_sta->in_connection)
+		if (wl_sta && !wl_sta->in_connection)
+			return;
+
+		if (WARN_ON(!wl_sta && !wlvif->ap_pending_auth_reply))
 			return;
 
-		wl_sta->in_connection = false;
-		wlvif->inconn_count--;
-		if (WARN_ON(wlvif->inconn_count < 0))
+		if (WARN_ON(wl_sta && !wlvif->inconn_count))
 			return;
 
-		if (!wlvif->inconn_count)
-			if (test_bit(wlvif->role_id, wl->roc_map))
-				wl12xx_croc(wl, wlvif->role_id);
+		if (wl_sta) {
+			wl_sta->in_connection = false;
+			wlvif->inconn_count--;
+		} else {
+			wlvif->ap_pending_auth_reply = false;
+		}
+
+		if (!wlvif->inconn_count && !wlvif->ap_pending_auth_reply &&
+		    test_bit(wlvif->role_id, wl->roc_map))
+			wl12xx_croc(wl, wlvif->role_id);
 	}
 }
 
diff --git a/drivers/net/wireless/ti/wlcore/tx.c b/drivers/net/wireless/ti/wlcore/tx.c
index 7e93fe6..03249da 100644
--- a/drivers/net/wireless/ti/wlcore/tx.c
+++ b/drivers/net/wireless/ti/wlcore/tx.c
@@ -86,19 +86,34 @@ void wl1271_free_tx_id(struct wl1271 *wl, int id)
 EXPORT_SYMBOL(wl1271_free_tx_id);
 
 static void wl1271_tx_ap_update_inconnection_sta(struct wl1271 *wl,
+						 struct wl12xx_vif *wlvif,
 						 struct sk_buff *skb)
 {
 	struct ieee80211_hdr *hdr;
 
+	hdr = (struct ieee80211_hdr *)(skb->data +
+				       sizeof(struct wl1271_tx_hw_descr));
+	if (!ieee80211_is_auth(hdr->frame_control))
+		return;
+
 	/*
 	 * add the station to the known list before transmitting the
 	 * authentication response. this way it won't get de-authed by FW
 	 * when transmitting too soon.
 	 */
-	hdr = (struct ieee80211_hdr *)(skb->data +
-				       sizeof(struct wl1271_tx_hw_descr));
-	if (ieee80211_is_auth(hdr->frame_control))
-		wl1271_acx_set_inconnection_sta(wl, hdr->addr1);
+	wl1271_acx_set_inconnection_sta(wl, hdr->addr1);
+
+	/*
+	 * ROC for 1 second on the AP channel for completing the connection.
+	 * Note the ROC will be continued by the update_sta_state callbacks
+	 * once the station reaches the associated state.
+	 */
+	wlcore_update_inconn_sta(wl, wlvif, NULL, true);
+	wlvif->pending_auth_reply_time = jiffies;
+	cancel_delayed_work(&wlvif->pending_auth_complete_work);
+	ieee80211_queue_delayed_work(wl->hw,
+				&wlvif->pending_auth_complete_work,
+				msecs_to_jiffies(WLCORE_PEND_AUTH_ROC_TIMEOUT));
 }
 
 static void wl1271_tx_regulate_link(struct wl1271 *wl,
@@ -404,7 +419,7 @@ static int wl1271_prepare_tx_frame(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 	wl1271_tx_fill_hdr(wl, wlvif, skb, extra, info, hlid);
 
 	if (!is_dummy && wlvif && wlvif->bss_type == BSS_TYPE_AP_BSS) {
-		wl1271_tx_ap_update_inconnection_sta(wl, skb);
+		wl1271_tx_ap_update_inconnection_sta(wl, wlvif, skb);
 		wl1271_tx_regulate_link(wl, wlvif, hlid);
 	}
 
diff --git a/drivers/net/wireless/ti/wlcore/tx.h b/drivers/net/wireless/ti/wlcore/tx.h
index 55aa4ac..35489c3 100644
--- a/drivers/net/wireless/ti/wlcore/tx.h
+++ b/drivers/net/wireless/ti/wlcore/tx.h
@@ -56,6 +56,9 @@
 /* Used for management frames and dummy packets */
 #define WL1271_TID_MGMT 7
 
+/* stop a ROC for pending authentication reply after this time (ms) */
+#define WLCORE_PEND_AUTH_ROC_TIMEOUT     1000
+
 struct wl127x_tx_mem {
 	/*
 	 * Number of extra memory blocks to allocate for this packet
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index 0034979..54ce5d5 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -481,6 +481,8 @@ int wlcore_set_key(struct wl1271 *wl, enum set_key_cmd cmd,
 		   struct ieee80211_sta *sta,
 		   struct ieee80211_key_conf *key_conf);
 void wlcore_regdomain_config(struct wl1271 *wl);
+void wlcore_update_inconn_sta(struct wl1271 *wl, struct wl12xx_vif *wlvif,
+			      struct wl1271_station *wl_sta, bool in_conn);
 
 static inline void
 wlcore_set_ht_cap(struct wl1271 *wl, enum ieee80211_band band,
diff --git a/drivers/net/wireless/ti/wlcore/wlcore_i.h b/drivers/net/wireless/ti/wlcore/wlcore_i.h
index e5e1464..14fd111 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore_i.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore_i.h
@@ -456,6 +456,15 @@ struct wl12xx_vif {
 	 */
 	int hw_queue_base;
 
+	/* do we have a pending auth reply? (and ROC) */
+	bool ap_pending_auth_reply;
+
+	/* time when we sent the pending auth reply */
+	unsigned long pending_auth_reply_time;
+
+	/* work for canceling ROC after pending auth reply */
+	struct delayed_work pending_auth_complete_work;
+
 	/*
 	 * This struct must be last!
 	 * data that has to be saved acrossed reconfigs (e.g. recovery)
-- 
1.8.3.rc1.35.g9b79519

