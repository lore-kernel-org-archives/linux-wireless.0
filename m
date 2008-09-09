Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49331 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751606AbYIIMa6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Sep 2008 08:30:58 -0400
Subject: [PATCH] mac80211: make BA session handling independent of STA mode
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 09 Sep 2008 14:30:49 +0200
Message-Id: <1220963449.31304.163.camel@johannes.berg> (sfid-20080909_143102_093986_2FDC2B9E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The aggregation handling isn't dependent on anything related to our
STA-mode implementation, and doesn't need to depend on it for frame
processing. This patch moves the relevant code to ht.c and adds a
hook in rx.c. For now, the relevant action frames are only processed
in STA/IBSS modes, but that's now something we can easily change.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/ht.c          |  303 +++++++++++++++++++++++++++++++++++++++-
 net/mac80211/ieee80211_i.h |   39 +++--
 net/mac80211/mlme.c        |  340 ---------------------------------------------
 net/mac80211/rx.c          |   60 +++++++
 4 files changed, 380 insertions(+), 362 deletions(-)

--- everything.orig/net/mac80211/ht.c	2008-09-09 13:02:21.000000000 +0200
+++ everything/net/mac80211/ht.c	2008-09-09 13:23:53.000000000 +0200
@@ -66,9 +66,10 @@ int ieee80211_ht_addt_info_ie_to_ht_bss_
 	return 0;
 }
 
-void ieee80211_send_addba_request(struct ieee80211_sub_if_data *sdata, const u8 *da,
-				u16 tid, u8 dialog_token, u16 start_seq_num,
-				u16 agg_size, u16 timeout)
+static void ieee80211_send_addba_request(struct ieee80211_sub_if_data *sdata,
+					 const u8 *da, u16 tid,
+					 u8 dialog_token, u16 start_seq_num,
+					 u16 agg_size, u16 timeout)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_if_sta *ifsta = &sdata->u.sta;
@@ -115,8 +116,55 @@ void ieee80211_send_addba_request(struct
 	ieee80211_sta_tx(sdata, skb, 0);
 }
 
-void ieee80211_send_delba(struct ieee80211_sub_if_data *sdata, const u8 *da, u16 tid,
-			  u16 initiator, u16 reason_code)
+static void ieee80211_send_addba_resp(struct ieee80211_sub_if_data *sdata, u8 *da, u16 tid,
+				      u8 dialog_token, u16 status, u16 policy,
+				      u16 buf_size, u16 timeout)
+{
+	struct ieee80211_if_sta *ifsta = &sdata->u.sta;
+	struct ieee80211_local *local = sdata->local;
+	struct sk_buff *skb;
+	struct ieee80211_mgmt *mgmt;
+	u16 capab;
+
+	skb = dev_alloc_skb(sizeof(*mgmt) + local->hw.extra_tx_headroom);
+
+	if (!skb) {
+		printk(KERN_DEBUG "%s: failed to allocate buffer "
+		       "for addba resp frame\n", sdata->dev->name);
+		return;
+	}
+
+	skb_reserve(skb, local->hw.extra_tx_headroom);
+	mgmt = (struct ieee80211_mgmt *) skb_put(skb, 24);
+	memset(mgmt, 0, 24);
+	memcpy(mgmt->da, da, ETH_ALEN);
+	memcpy(mgmt->sa, sdata->dev->dev_addr, ETH_ALEN);
+	if (sdata->vif.type == IEEE80211_IF_TYPE_AP)
+		memcpy(mgmt->bssid, sdata->dev->dev_addr, ETH_ALEN);
+	else
+		memcpy(mgmt->bssid, ifsta->bssid, ETH_ALEN);
+	mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
+					  IEEE80211_STYPE_ACTION);
+
+	skb_put(skb, 1 + sizeof(mgmt->u.action.u.addba_resp));
+	mgmt->u.action.category = WLAN_CATEGORY_BACK;
+	mgmt->u.action.u.addba_resp.action_code = WLAN_ACTION_ADDBA_RESP;
+	mgmt->u.action.u.addba_resp.dialog_token = dialog_token;
+
+	capab = (u16)(policy << 1);	/* bit 1 aggregation policy */
+	capab |= (u16)(tid << 2); 	/* bit 5:2 TID number */
+	capab |= (u16)(buf_size << 6);	/* bit 15:6 max size of aggregation */
+
+	mgmt->u.action.u.addba_resp.capab = cpu_to_le16(capab);
+	mgmt->u.action.u.addba_resp.timeout = cpu_to_le16(timeout);
+	mgmt->u.action.u.addba_resp.status = cpu_to_le16(status);
+
+	ieee80211_sta_tx(sdata, skb, 0);
+}
+
+static void ieee80211_send_delba(struct ieee80211_sub_if_data *sdata,
+				 const u8 *da, u16 tid,
+				 u16 initiator, u16 reason_code)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_if_sta *ifsta = &sdata->u.sta;
@@ -263,7 +311,7 @@ void ieee80211_sta_stop_rx_ba_session(st
  * add Block Ack response will arrive from the recipient.
  * If this timer expires sta_addba_resp_timer_expired will be executed.
  */
-void sta_addba_resp_timer_expired(unsigned long data)
+static void sta_addba_resp_timer_expired(unsigned long data)
 {
 	/* not an elegant detour, but there is no choice as the timer passes
 	 * only one argument, and both sta_info and TID are needed, so init
@@ -699,3 +747,246 @@ void ieee80211_stop_tx_ba_cb_irqsafe(str
 	tasklet_schedule(&local->tasklet);
 }
 EXPORT_SYMBOL(ieee80211_stop_tx_ba_cb_irqsafe);
+
+/*
+ * After accepting the AddBA Request we activated a timer,
+ * resetting it after each frame that arrives from the originator.
+ * if this timer expires ieee80211_sta_stop_rx_ba_session will be executed.
+ */
+static void sta_rx_agg_session_timer_expired(unsigned long data)
+{
+	/* not an elegant detour, but there is no choice as the timer passes
+	 * only one argument, and various sta_info are needed here, so init
+	 * flow in sta_info_create gives the TID as data, while the timer_to_id
+	 * array gives the sta through container_of */
+	u8 *ptid = (u8 *)data;
+	u8 *timer_to_id = ptid - *ptid;
+	struct sta_info *sta = container_of(timer_to_id, struct sta_info,
+					 timer_to_tid[0]);
+
+#ifdef CONFIG_MAC80211_HT_DEBUG
+	printk(KERN_DEBUG "rx session timer expired on tid %d\n", (u16)*ptid);
+#endif
+	ieee80211_sta_stop_rx_ba_session(sta->sdata, sta->addr,
+					 (u16)*ptid, WLAN_BACK_TIMER,
+					 WLAN_REASON_QSTA_TIMEOUT);
+}
+
+void ieee80211_process_addba_request(struct ieee80211_local *local,
+				     struct sta_info *sta,
+				     struct ieee80211_mgmt *mgmt,
+				     size_t len)
+{
+	struct ieee80211_hw *hw = &local->hw;
+	struct ieee80211_conf *conf = &hw->conf;
+	struct tid_ampdu_rx *tid_agg_rx;
+	u16 capab, tid, timeout, ba_policy, buf_size, start_seq_num, status;
+	u8 dialog_token;
+	int ret = -EOPNOTSUPP;
+	DECLARE_MAC_BUF(mac);
+
+	/* extract session parameters from addba request frame */
+	dialog_token = mgmt->u.action.u.addba_req.dialog_token;
+	timeout = le16_to_cpu(mgmt->u.action.u.addba_req.timeout);
+	start_seq_num =
+		le16_to_cpu(mgmt->u.action.u.addba_req.start_seq_num) >> 4;
+
+	capab = le16_to_cpu(mgmt->u.action.u.addba_req.capab);
+	ba_policy = (capab & IEEE80211_ADDBA_PARAM_POLICY_MASK) >> 1;
+	tid = (capab & IEEE80211_ADDBA_PARAM_TID_MASK) >> 2;
+	buf_size = (capab & IEEE80211_ADDBA_PARAM_BUF_SIZE_MASK) >> 6;
+
+	status = WLAN_STATUS_REQUEST_DECLINED;
+
+	/* sanity check for incoming parameters:
+	 * check if configuration can support the BA policy
+	 * and if buffer size does not exceeds max value */
+	if (((ba_policy != 1)
+		&& (!(conf->ht_conf.cap & IEEE80211_HT_CAP_DELAY_BA)))
+		|| (buf_size > IEEE80211_MAX_AMPDU_BUF)) {
+		status = WLAN_STATUS_INVALID_QOS_PARAM;
+#ifdef CONFIG_MAC80211_HT_DEBUG
+		if (net_ratelimit())
+			printk(KERN_DEBUG "AddBA Req with bad params from "
+				"%s on tid %u. policy %d, buffer size %d\n",
+				print_mac(mac, mgmt->sa), tid, ba_policy,
+				buf_size);
+#endif /* CONFIG_MAC80211_HT_DEBUG */
+		goto end_no_lock;
+	}
+	/* determine default buffer size */
+	if (buf_size == 0) {
+		struct ieee80211_supported_band *sband;
+
+		sband = local->hw.wiphy->bands[conf->channel->band];
+		buf_size = IEEE80211_MIN_AMPDU_BUF;
+		buf_size = buf_size << sband->ht_info.ampdu_factor;
+	}
+
+
+	/* examine state machine */
+	spin_lock_bh(&sta->lock);
+
+	if (sta->ampdu_mlme.tid_state_rx[tid] != HT_AGG_STATE_IDLE) {
+#ifdef CONFIG_MAC80211_HT_DEBUG
+		if (net_ratelimit())
+			printk(KERN_DEBUG "unexpected AddBA Req from "
+				"%s on tid %u\n",
+				print_mac(mac, mgmt->sa), tid);
+#endif /* CONFIG_MAC80211_HT_DEBUG */
+		goto end;
+	}
+
+	/* prepare A-MPDU MLME for Rx aggregation */
+	sta->ampdu_mlme.tid_rx[tid] =
+			kmalloc(sizeof(struct tid_ampdu_rx), GFP_ATOMIC);
+	if (!sta->ampdu_mlme.tid_rx[tid]) {
+#ifdef CONFIG_MAC80211_HT_DEBUG
+		if (net_ratelimit())
+			printk(KERN_ERR "allocate rx mlme to tid %d failed\n",
+					tid);
+#endif
+		goto end;
+	}
+	/* rx timer */
+	sta->ampdu_mlme.tid_rx[tid]->session_timer.function =
+				sta_rx_agg_session_timer_expired;
+	sta->ampdu_mlme.tid_rx[tid]->session_timer.data =
+				(unsigned long)&sta->timer_to_tid[tid];
+	init_timer(&sta->ampdu_mlme.tid_rx[tid]->session_timer);
+
+	tid_agg_rx = sta->ampdu_mlme.tid_rx[tid];
+
+	/* prepare reordering buffer */
+	tid_agg_rx->reorder_buf =
+		kmalloc(buf_size * sizeof(struct sk_buff *), GFP_ATOMIC);
+	if (!tid_agg_rx->reorder_buf) {
+#ifdef CONFIG_MAC80211_HT_DEBUG
+		if (net_ratelimit())
+			printk(KERN_ERR "can not allocate reordering buffer "
+			       "to tid %d\n", tid);
+#endif
+		kfree(sta->ampdu_mlme.tid_rx[tid]);
+		goto end;
+	}
+	memset(tid_agg_rx->reorder_buf, 0,
+		buf_size * sizeof(struct sk_buff *));
+
+	if (local->ops->ampdu_action)
+		ret = local->ops->ampdu_action(hw, IEEE80211_AMPDU_RX_START,
+					       sta->addr, tid, &start_seq_num);
+#ifdef CONFIG_MAC80211_HT_DEBUG
+	printk(KERN_DEBUG "Rx A-MPDU request on tid %d result %d\n", tid, ret);
+#endif /* CONFIG_MAC80211_HT_DEBUG */
+
+	if (ret) {
+		kfree(tid_agg_rx->reorder_buf);
+		kfree(tid_agg_rx);
+		sta->ampdu_mlme.tid_rx[tid] = NULL;
+		goto end;
+	}
+
+	/* change state and send addba resp */
+	sta->ampdu_mlme.tid_state_rx[tid] = HT_AGG_STATE_OPERATIONAL;
+	tid_agg_rx->dialog_token = dialog_token;
+	tid_agg_rx->ssn = start_seq_num;
+	tid_agg_rx->head_seq_num = start_seq_num;
+	tid_agg_rx->buf_size = buf_size;
+	tid_agg_rx->timeout = timeout;
+	tid_agg_rx->stored_mpdu_num = 0;
+	status = WLAN_STATUS_SUCCESS;
+end:
+	spin_unlock_bh(&sta->lock);
+
+end_no_lock:
+	ieee80211_send_addba_resp(sta->sdata, sta->addr, tid,
+				  dialog_token, status, 1, buf_size, timeout);
+}
+
+void ieee80211_process_addba_resp(struct ieee80211_local *local,
+				  struct sta_info *sta,
+				  struct ieee80211_mgmt *mgmt,
+				  size_t len)
+{
+	struct ieee80211_hw *hw = &local->hw;
+	u16 capab;
+	u16 tid;
+	u8 *state;
+
+	capab = le16_to_cpu(mgmt->u.action.u.addba_resp.capab);
+	tid = (capab & IEEE80211_ADDBA_PARAM_TID_MASK) >> 2;
+
+	state = &sta->ampdu_mlme.tid_state_tx[tid];
+
+	spin_lock_bh(&sta->lock);
+
+	if (!(*state & HT_ADDBA_REQUESTED_MSK)) {
+		spin_unlock_bh(&sta->lock);
+		return;
+	}
+
+	if (mgmt->u.action.u.addba_resp.dialog_token !=
+		sta->ampdu_mlme.tid_tx[tid]->dialog_token) {
+		spin_unlock_bh(&sta->lock);
+#ifdef CONFIG_MAC80211_HT_DEBUG
+		printk(KERN_DEBUG "wrong addBA response token, tid %d\n", tid);
+#endif /* CONFIG_MAC80211_HT_DEBUG */
+		return;
+	}
+
+	del_timer_sync(&sta->ampdu_mlme.tid_tx[tid]->addba_resp_timer);
+#ifdef CONFIG_MAC80211_HT_DEBUG
+	printk(KERN_DEBUG "switched off addBA timer for tid %d \n", tid);
+#endif /* CONFIG_MAC80211_HT_DEBUG */
+	if (le16_to_cpu(mgmt->u.action.u.addba_resp.status)
+			== WLAN_STATUS_SUCCESS) {
+		*state |= HT_ADDBA_RECEIVED_MSK;
+		sta->ampdu_mlme.addba_req_num[tid] = 0;
+
+		if (*state == HT_AGG_STATE_OPERATIONAL)
+			ieee80211_wake_queue(hw, sta->tid_to_tx_q[tid]);
+
+		spin_unlock_bh(&sta->lock);
+	} else {
+		sta->ampdu_mlme.addba_req_num[tid]++;
+		/* this will allow the state check in stop_BA_session */
+		*state = HT_AGG_STATE_OPERATIONAL;
+		spin_unlock_bh(&sta->lock);
+		ieee80211_stop_tx_ba_session(hw, sta->addr, tid,
+					     WLAN_BACK_INITIATOR);
+	}
+}
+
+void ieee80211_process_delba(struct ieee80211_sub_if_data *sdata,
+			     struct sta_info *sta,
+			     struct ieee80211_mgmt *mgmt, size_t len)
+{
+	struct ieee80211_local *local = sdata->local;
+	u16 tid, params;
+	u16 initiator;
+	DECLARE_MAC_BUF(mac);
+
+	params = le16_to_cpu(mgmt->u.action.u.delba.params);
+	tid = (params & IEEE80211_DELBA_PARAM_TID_MASK) >> 12;
+	initiator = (params & IEEE80211_DELBA_PARAM_INITIATOR_MASK) >> 11;
+
+#ifdef CONFIG_MAC80211_HT_DEBUG
+	if (net_ratelimit())
+		printk(KERN_DEBUG "delba from %s (%s) tid %d reason code %d\n",
+			print_mac(mac, mgmt->sa),
+			initiator ? "initiator" : "recipient", tid,
+			mgmt->u.action.u.delba.reason_code);
+#endif /* CONFIG_MAC80211_HT_DEBUG */
+
+	if (initiator == WLAN_BACK_INITIATOR)
+		ieee80211_sta_stop_rx_ba_session(sdata, sta->addr, tid,
+						 WLAN_BACK_INITIATOR, 0);
+	else { /* WLAN_BACK_RECIPIENT */
+		spin_lock_bh(&sta->lock);
+		sta->ampdu_mlme.tid_state_tx[tid] =
+				HT_AGG_STATE_OPERATIONAL;
+		spin_unlock_bh(&sta->lock);
+		ieee80211_stop_tx_ba_session(&local->hw, sta->addr, tid,
+					     WLAN_BACK_RECIPIENT);
+	}
+}
--- everything.orig/net/mac80211/ieee80211_i.h	2008-09-09 13:02:46.000000000 +0200
+++ everything/net/mac80211/ieee80211_i.h	2008-09-09 13:55:03.000000000 +0200
@@ -909,22 +909,6 @@ int ieee80211_sta_disassociate(struct ie
 void ieee80211_bss_info_change_notify(struct ieee80211_sub_if_data *sdata,
 				      u32 changed);
 u32 ieee80211_reset_erp_info(struct ieee80211_sub_if_data *sdata);
-int ieee80211_ht_cap_ie_to_ht_info(struct ieee80211_ht_cap *ht_cap_ie,
-				   struct ieee80211_ht_info *ht_info);
-int ieee80211_ht_addt_info_ie_to_ht_bss_info(
-			struct ieee80211_ht_addt_info *ht_add_info_ie,
-			struct ieee80211_ht_bss_info *bss_info);
-void ieee80211_send_addba_request(struct ieee80211_sub_if_data *sdata, const u8 *da,
-				  u16 tid, u8 dialog_token, u16 start_seq_num,
-				  u16 agg_size, u16 timeout);
-void ieee80211_send_delba(struct ieee80211_sub_if_data *sdata, const u8 *da, u16 tid,
-				u16 initiator, u16 reason_code);
-void ieee80211_send_bar(struct ieee80211_sub_if_data *sdata, u8 *ra, u16 tid, u16 ssn);
-
-void ieee80211_sta_stop_rx_ba_session(struct ieee80211_sub_if_data *sdata, u8 *da,
-				u16 tid, u16 initiator, u16 reason);
-void sta_addba_resp_timer_expired(unsigned long data);
-void ieee80211_sta_tear_down_BA_sessions(struct ieee80211_sub_if_data *sdata, u8 *addr);
 u64 ieee80211_sta_get_rates(struct ieee80211_local *local,
 			    struct ieee802_11_elems *elems,
 			    enum ieee80211_band band);
@@ -977,6 +961,29 @@ int ieee80211_master_start_xmit(struct s
 int ieee80211_monitor_start_xmit(struct sk_buff *skb, struct net_device *dev);
 int ieee80211_subif_start_xmit(struct sk_buff *skb, struct net_device *dev);
 
+/* HT */
+int ieee80211_ht_cap_ie_to_ht_info(struct ieee80211_ht_cap *ht_cap_ie,
+				   struct ieee80211_ht_info *ht_info);
+int ieee80211_ht_addt_info_ie_to_ht_bss_info(
+			struct ieee80211_ht_addt_info *ht_add_info_ie,
+			struct ieee80211_ht_bss_info *bss_info);
+void ieee80211_send_bar(struct ieee80211_sub_if_data *sdata, u8 *ra, u16 tid, u16 ssn);
+
+void ieee80211_sta_stop_rx_ba_session(struct ieee80211_sub_if_data *sdata, u8 *da,
+				u16 tid, u16 initiator, u16 reason);
+void ieee80211_sta_tear_down_BA_sessions(struct ieee80211_sub_if_data *sdata, u8 *addr);
+void ieee80211_process_delba(struct ieee80211_sub_if_data *sdata,
+			     struct sta_info *sta,
+			     struct ieee80211_mgmt *mgmt, size_t len);
+void ieee80211_process_addba_resp(struct ieee80211_local *local,
+				  struct sta_info *sta,
+				  struct ieee80211_mgmt *mgmt,
+				  size_t len);
+void ieee80211_process_addba_request(struct ieee80211_local *local,
+				     struct sta_info *sta,
+				     struct ieee80211_mgmt *mgmt,
+				     size_t len);
+
 /* utility functions/constants */
 extern void *mac80211_wiphy_privid; /* for wiphy privid */
 extern const unsigned char rfc1042_header[6];
--- everything.orig/net/mac80211/mlme.c	2008-09-09 13:02:12.000000000 +0200
+++ everything/net/mac80211/mlme.c	2008-09-09 13:55:03.000000000 +0200
@@ -445,52 +445,6 @@ static void ieee80211_send_deauth_disass
 	ieee80211_sta_tx(sdata, skb, 0);
 }
 
-static void ieee80211_send_addba_resp(struct ieee80211_sub_if_data *sdata, u8 *da, u16 tid,
-					u8 dialog_token, u16 status, u16 policy,
-					u16 buf_size, u16 timeout)
-{
-	struct ieee80211_if_sta *ifsta = &sdata->u.sta;
-	struct ieee80211_local *local = sdata->local;
-	struct sk_buff *skb;
-	struct ieee80211_mgmt *mgmt;
-	u16 capab;
-
-	skb = dev_alloc_skb(sizeof(*mgmt) + local->hw.extra_tx_headroom);
-
-	if (!skb) {
-		printk(KERN_DEBUG "%s: failed to allocate buffer "
-		       "for addba resp frame\n", sdata->dev->name);
-		return;
-	}
-
-	skb_reserve(skb, local->hw.extra_tx_headroom);
-	mgmt = (struct ieee80211_mgmt *) skb_put(skb, 24);
-	memset(mgmt, 0, 24);
-	memcpy(mgmt->da, da, ETH_ALEN);
-	memcpy(mgmt->sa, sdata->dev->dev_addr, ETH_ALEN);
-	if (sdata->vif.type == IEEE80211_IF_TYPE_AP)
-		memcpy(mgmt->bssid, sdata->dev->dev_addr, ETH_ALEN);
-	else
-		memcpy(mgmt->bssid, ifsta->bssid, ETH_ALEN);
-	mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
-					  IEEE80211_STYPE_ACTION);
-
-	skb_put(skb, 1 + sizeof(mgmt->u.action.u.addba_resp));
-	mgmt->u.action.category = WLAN_CATEGORY_BACK;
-	mgmt->u.action.u.addba_resp.action_code = WLAN_ACTION_ADDBA_RESP;
-	mgmt->u.action.u.addba_resp.dialog_token = dialog_token;
-
-	capab = (u16)(policy << 1);	/* bit 1 aggregation policy */
-	capab |= (u16)(tid << 2); 	/* bit 5:2 TID number */
-	capab |= (u16)(buf_size << 6);	/* bit 15:6 max size of aggregation */
-
-	mgmt->u.action.u.addba_resp.capab = cpu_to_le16(capab);
-	mgmt->u.action.u.addba_resp.timeout = cpu_to_le16(timeout);
-	mgmt->u.action.u.addba_resp.status = cpu_to_le16(status);
-
-	ieee80211_sta_tx(sdata, skb, 0);
-}
-
 static void ieee80211_send_refuse_measurement_request(struct ieee80211_sub_if_data *sdata,
 					struct ieee80211_msrment_ie *request_ie,
 					const u8 *da, const u8 *bssid,
@@ -1058,278 +1012,6 @@ static void ieee80211_auth_challenge(str
 			    elems.challenge_len + 2, 1);
 }
 
-/*
- * After accepting the AddBA Request we activated a timer,
- * resetting it after each frame that arrives from the originator.
- * if this timer expires ieee80211_sta_stop_rx_ba_session will be executed.
- */
-static void sta_rx_agg_session_timer_expired(unsigned long data)
-{
-	/* not an elegant detour, but there is no choice as the timer passes
-	 * only one argument, and various sta_info are needed here, so init
-	 * flow in sta_info_create gives the TID as data, while the timer_to_id
-	 * array gives the sta through container_of */
-	u8 *ptid = (u8 *)data;
-	u8 *timer_to_id = ptid - *ptid;
-	struct sta_info *sta = container_of(timer_to_id, struct sta_info,
-					 timer_to_tid[0]);
-
-#ifdef CONFIG_MAC80211_HT_DEBUG
-	printk(KERN_DEBUG "rx session timer expired on tid %d\n", (u16)*ptid);
-#endif
-	ieee80211_sta_stop_rx_ba_session(sta->sdata, sta->addr,
-					 (u16)*ptid, WLAN_BACK_TIMER,
-					 WLAN_REASON_QSTA_TIMEOUT);
-}
-
-static void ieee80211_sta_process_addba_request(struct ieee80211_local *local,
-						struct ieee80211_mgmt *mgmt,
-						size_t len)
-{
-	struct ieee80211_hw *hw = &local->hw;
-	struct ieee80211_conf *conf = &hw->conf;
-	struct sta_info *sta;
-	struct tid_ampdu_rx *tid_agg_rx;
-	u16 capab, tid, timeout, ba_policy, buf_size, start_seq_num, status;
-	u8 dialog_token;
-	int ret = -EOPNOTSUPP;
-	DECLARE_MAC_BUF(mac);
-
-	rcu_read_lock();
-
-	sta = sta_info_get(local, mgmt->sa);
-	if (!sta) {
-		rcu_read_unlock();
-		return;
-	}
-
-	/* extract session parameters from addba request frame */
-	dialog_token = mgmt->u.action.u.addba_req.dialog_token;
-	timeout = le16_to_cpu(mgmt->u.action.u.addba_req.timeout);
-	start_seq_num =
-		le16_to_cpu(mgmt->u.action.u.addba_req.start_seq_num) >> 4;
-
-	capab = le16_to_cpu(mgmt->u.action.u.addba_req.capab);
-	ba_policy = (capab & IEEE80211_ADDBA_PARAM_POLICY_MASK) >> 1;
-	tid = (capab & IEEE80211_ADDBA_PARAM_TID_MASK) >> 2;
-	buf_size = (capab & IEEE80211_ADDBA_PARAM_BUF_SIZE_MASK) >> 6;
-
-	status = WLAN_STATUS_REQUEST_DECLINED;
-
-	/* sanity check for incoming parameters:
-	 * check if configuration can support the BA policy
-	 * and if buffer size does not exceeds max value */
-	if (((ba_policy != 1)
-		&& (!(conf->ht_conf.cap & IEEE80211_HT_CAP_DELAY_BA)))
-		|| (buf_size > IEEE80211_MAX_AMPDU_BUF)) {
-		status = WLAN_STATUS_INVALID_QOS_PARAM;
-#ifdef CONFIG_MAC80211_HT_DEBUG
-		if (net_ratelimit())
-			printk(KERN_DEBUG "AddBA Req with bad params from "
-				"%s on tid %u. policy %d, buffer size %d\n",
-				print_mac(mac, mgmt->sa), tid, ba_policy,
-				buf_size);
-#endif /* CONFIG_MAC80211_HT_DEBUG */
-		goto end_no_lock;
-	}
-	/* determine default buffer size */
-	if (buf_size == 0) {
-		struct ieee80211_supported_band *sband;
-
-		sband = local->hw.wiphy->bands[conf->channel->band];
-		buf_size = IEEE80211_MIN_AMPDU_BUF;
-		buf_size = buf_size << sband->ht_info.ampdu_factor;
-	}
-
-
-	/* examine state machine */
-	spin_lock_bh(&sta->lock);
-
-	if (sta->ampdu_mlme.tid_state_rx[tid] != HT_AGG_STATE_IDLE) {
-#ifdef CONFIG_MAC80211_HT_DEBUG
-		if (net_ratelimit())
-			printk(KERN_DEBUG "unexpected AddBA Req from "
-				"%s on tid %u\n",
-				print_mac(mac, mgmt->sa), tid);
-#endif /* CONFIG_MAC80211_HT_DEBUG */
-		goto end;
-	}
-
-	/* prepare A-MPDU MLME for Rx aggregation */
-	sta->ampdu_mlme.tid_rx[tid] =
-			kmalloc(sizeof(struct tid_ampdu_rx), GFP_ATOMIC);
-	if (!sta->ampdu_mlme.tid_rx[tid]) {
-#ifdef CONFIG_MAC80211_HT_DEBUG
-		if (net_ratelimit())
-			printk(KERN_ERR "allocate rx mlme to tid %d failed\n",
-					tid);
-#endif
-		goto end;
-	}
-	/* rx timer */
-	sta->ampdu_mlme.tid_rx[tid]->session_timer.function =
-				sta_rx_agg_session_timer_expired;
-	sta->ampdu_mlme.tid_rx[tid]->session_timer.data =
-				(unsigned long)&sta->timer_to_tid[tid];
-	init_timer(&sta->ampdu_mlme.tid_rx[tid]->session_timer);
-
-	tid_agg_rx = sta->ampdu_mlme.tid_rx[tid];
-
-	/* prepare reordering buffer */
-	tid_agg_rx->reorder_buf =
-		kmalloc(buf_size * sizeof(struct sk_buff *), GFP_ATOMIC);
-	if (!tid_agg_rx->reorder_buf) {
-#ifdef CONFIG_MAC80211_HT_DEBUG
-		if (net_ratelimit())
-			printk(KERN_ERR "can not allocate reordering buffer "
-			       "to tid %d\n", tid);
-#endif
-		kfree(sta->ampdu_mlme.tid_rx[tid]);
-		goto end;
-	}
-	memset(tid_agg_rx->reorder_buf, 0,
-		buf_size * sizeof(struct sk_buff *));
-
-	if (local->ops->ampdu_action)
-		ret = local->ops->ampdu_action(hw, IEEE80211_AMPDU_RX_START,
-					       sta->addr, tid, &start_seq_num);
-#ifdef CONFIG_MAC80211_HT_DEBUG
-	printk(KERN_DEBUG "Rx A-MPDU request on tid %d result %d\n", tid, ret);
-#endif /* CONFIG_MAC80211_HT_DEBUG */
-
-	if (ret) {
-		kfree(tid_agg_rx->reorder_buf);
-		kfree(tid_agg_rx);
-		sta->ampdu_mlme.tid_rx[tid] = NULL;
-		goto end;
-	}
-
-	/* change state and send addba resp */
-	sta->ampdu_mlme.tid_state_rx[tid] = HT_AGG_STATE_OPERATIONAL;
-	tid_agg_rx->dialog_token = dialog_token;
-	tid_agg_rx->ssn = start_seq_num;
-	tid_agg_rx->head_seq_num = start_seq_num;
-	tid_agg_rx->buf_size = buf_size;
-	tid_agg_rx->timeout = timeout;
-	tid_agg_rx->stored_mpdu_num = 0;
-	status = WLAN_STATUS_SUCCESS;
-end:
-	spin_unlock_bh(&sta->lock);
-
-end_no_lock:
-	ieee80211_send_addba_resp(sta->sdata, sta->addr, tid,
-				  dialog_token, status, 1, buf_size, timeout);
-	rcu_read_unlock();
-}
-
-static void ieee80211_sta_process_addba_resp(struct ieee80211_local *local,
-					     struct ieee80211_mgmt *mgmt,
-					     size_t len)
-{
-	struct ieee80211_hw *hw = &local->hw;
-	struct sta_info *sta;
-	u16 capab;
-	u16 tid;
-	u8 *state;
-
-	rcu_read_lock();
-
-	sta = sta_info_get(local, mgmt->sa);
-	if (!sta) {
-		rcu_read_unlock();
-		return;
-	}
-
-	capab = le16_to_cpu(mgmt->u.action.u.addba_resp.capab);
-	tid = (capab & IEEE80211_ADDBA_PARAM_TID_MASK) >> 2;
-
-	state = &sta->ampdu_mlme.tid_state_tx[tid];
-
-	spin_lock_bh(&sta->lock);
-
-	if (!(*state & HT_ADDBA_REQUESTED_MSK)) {
-		spin_unlock_bh(&sta->lock);
-		goto addba_resp_exit;
-	}
-
-	if (mgmt->u.action.u.addba_resp.dialog_token !=
-		sta->ampdu_mlme.tid_tx[tid]->dialog_token) {
-		spin_unlock_bh(&sta->lock);
-#ifdef CONFIG_MAC80211_HT_DEBUG
-		printk(KERN_DEBUG "wrong addBA response token, tid %d\n", tid);
-#endif /* CONFIG_MAC80211_HT_DEBUG */
-		goto addba_resp_exit;
-	}
-
-	del_timer_sync(&sta->ampdu_mlme.tid_tx[tid]->addba_resp_timer);
-#ifdef CONFIG_MAC80211_HT_DEBUG
-	printk(KERN_DEBUG "switched off addBA timer for tid %d \n", tid);
-#endif /* CONFIG_MAC80211_HT_DEBUG */
-	if (le16_to_cpu(mgmt->u.action.u.addba_resp.status)
-			== WLAN_STATUS_SUCCESS) {
-		*state |= HT_ADDBA_RECEIVED_MSK;
-		sta->ampdu_mlme.addba_req_num[tid] = 0;
-
-		if (*state == HT_AGG_STATE_OPERATIONAL)
-			ieee80211_wake_queue(hw, sta->tid_to_tx_q[tid]);
-
-		spin_unlock_bh(&sta->lock);
-	} else {
-		sta->ampdu_mlme.addba_req_num[tid]++;
-		/* this will allow the state check in stop_BA_session */
-		*state = HT_AGG_STATE_OPERATIONAL;
-		spin_unlock_bh(&sta->lock);
-		ieee80211_stop_tx_ba_session(hw, sta->addr, tid,
-					     WLAN_BACK_INITIATOR);
-	}
-
-addba_resp_exit:
-	rcu_read_unlock();
-}
-
-static void ieee80211_sta_process_delba(struct ieee80211_sub_if_data *sdata,
-			struct ieee80211_mgmt *mgmt, size_t len)
-{
-	struct ieee80211_local *local = sdata->local;
-	struct sta_info *sta;
-	u16 tid, params;
-	u16 initiator;
-	DECLARE_MAC_BUF(mac);
-
-	rcu_read_lock();
-
-	sta = sta_info_get(local, mgmt->sa);
-	if (!sta) {
-		rcu_read_unlock();
-		return;
-	}
-
-	params = le16_to_cpu(mgmt->u.action.u.delba.params);
-	tid = (params & IEEE80211_DELBA_PARAM_TID_MASK) >> 12;
-	initiator = (params & IEEE80211_DELBA_PARAM_INITIATOR_MASK) >> 11;
-
-#ifdef CONFIG_MAC80211_HT_DEBUG
-	if (net_ratelimit())
-		printk(KERN_DEBUG "delba from %s (%s) tid %d reason code %d\n",
-			print_mac(mac, mgmt->sa),
-			initiator ? "initiator" : "recipient", tid,
-			mgmt->u.action.u.delba.reason_code);
-#endif /* CONFIG_MAC80211_HT_DEBUG */
-
-	if (initiator == WLAN_BACK_INITIATOR)
-		ieee80211_sta_stop_rx_ba_session(sdata, sta->addr, tid,
-						 WLAN_BACK_INITIATOR, 0);
-	else { /* WLAN_BACK_RECIPIENT */
-		spin_lock_bh(&sta->lock);
-		sta->ampdu_mlme.tid_state_tx[tid] =
-				HT_AGG_STATE_OPERATIONAL;
-		spin_unlock_bh(&sta->lock);
-		ieee80211_stop_tx_ba_session(&local->hw, sta->addr, tid,
-					     WLAN_BACK_RECIPIENT);
-	}
-	rcu_read_unlock();
-}
-
 static void ieee80211_sta_process_measurement_req(struct ieee80211_sub_if_data *sdata,
 						struct ieee80211_mgmt *mgmt,
 						size_t len)
@@ -2208,28 +1890,6 @@ static void ieee80211_rx_mgmt_action(str
 			break;
 		}
 		break;
-	case WLAN_CATEGORY_BACK:
-		switch (mgmt->u.action.u.addba_req.action_code) {
-		case WLAN_ACTION_ADDBA_REQ:
-			if (len < (IEEE80211_MIN_ACTION_SIZE +
-				   sizeof(mgmt->u.action.u.addba_req)))
-				break;
-			ieee80211_sta_process_addba_request(local, mgmt, len);
-			break;
-		case WLAN_ACTION_ADDBA_RESP:
-			if (len < (IEEE80211_MIN_ACTION_SIZE +
-				   sizeof(mgmt->u.action.u.addba_resp)))
-				break;
-			ieee80211_sta_process_addba_resp(local, mgmt, len);
-			break;
-		case WLAN_ACTION_DELBA:
-			if (len < (IEEE80211_MIN_ACTION_SIZE +
-				   sizeof(mgmt->u.action.u.delba)))
-				break;
-			ieee80211_sta_process_delba(sdata, mgmt, len);
-			break;
-		}
-		break;
 	case PLINK_CATEGORY:
 		if (ieee80211_vif_is_mesh(&sdata->vif))
 			mesh_rx_plink_frame(sdata, mgmt, len, rx_status);
--- everything.orig/net/mac80211/rx.c	2008-09-09 13:02:21.000000000 +0200
+++ everything/net/mac80211/rx.c	2008-09-09 14:29:47.000000000 +0200
@@ -1511,6 +1511,65 @@ ieee80211_rx_h_ctrl(struct ieee80211_rx_
 }
 
 static ieee80211_rx_result debug_noinline
+ieee80211_rx_h_action(struct ieee80211_rx_data *rx)
+{
+	struct ieee80211_local *local = rx->local;
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(rx->dev);
+	struct ieee80211_mgmt *mgmt = (struct ieee80211_mgmt *) rx->skb->data;
+	int len = rx->skb->len;
+
+	if (!ieee80211_is_action(mgmt->frame_control))
+		return RX_CONTINUE;
+
+	if (!rx->sta)
+		return RX_DROP_MONITOR;
+
+	if (!(rx->flags & IEEE80211_RX_RA_MATCH))
+		return RX_DROP_MONITOR;
+
+	/* all categories we currently handle have action_code */
+	if (len < IEEE80211_MIN_ACTION_SIZE + 1)
+		return RX_DROP_MONITOR;
+
+	/*
+	 * FIXME: revisit this, I'm sure we should handle most
+	 *	  of these frames in other modes as well!
+	 */
+	if (sdata->vif.type != IEEE80211_IF_TYPE_STA &&
+	    sdata->vif.type != IEEE80211_IF_TYPE_IBSS)
+		return RX_DROP_MONITOR;
+
+	switch (mgmt->u.action.category) {
+	case WLAN_CATEGORY_BACK:
+		switch (mgmt->u.action.u.addba_req.action_code) {
+		case WLAN_ACTION_ADDBA_REQ:
+			if (len < (IEEE80211_MIN_ACTION_SIZE +
+				   sizeof(mgmt->u.action.u.addba_req)))
+				break;
+			ieee80211_process_addba_request(local, rx->sta, mgmt, len);
+			break;
+		case WLAN_ACTION_ADDBA_RESP:
+			if (len < (IEEE80211_MIN_ACTION_SIZE +
+				   sizeof(mgmt->u.action.u.addba_resp)))
+				break;
+			ieee80211_process_addba_resp(local, rx->sta, mgmt, len);
+			break;
+		case WLAN_ACTION_DELBA:
+			if (len < (IEEE80211_MIN_ACTION_SIZE +
+				   sizeof(mgmt->u.action.u.delba)))
+				break;
+			ieee80211_process_delba(sdata, rx->sta, mgmt, len);
+			break;
+		}
+		rx->sta->rx_packets++;
+		dev_kfree_skb(rx->skb);
+		return RX_QUEUED;
+	}
+
+	return RX_CONTINUE;
+}
+
+static ieee80211_rx_result debug_noinline
 ieee80211_rx_h_mgmt(struct ieee80211_rx_data *rx)
 {
 	struct ieee80211_sub_if_data *sdata;
@@ -1689,6 +1748,7 @@ static void ieee80211_invoke_rx_handlers
 		CALL_RXH(ieee80211_rx_h_mesh_fwding);
 	CALL_RXH(ieee80211_rx_h_data)
 	CALL_RXH(ieee80211_rx_h_ctrl)
+	CALL_RXH(ieee80211_rx_h_action)
 	CALL_RXH(ieee80211_rx_h_mgmt)
 
 #undef CALL_RXH


