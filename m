Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:45119 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757393AbXLTJse (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Dec 2007 04:48:34 -0500
From: Ron Rindjunsky <ron.rindjunsky@intel.com>
To: linville@tuxdriver.com
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com, yi.zhu@intel.com,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
Subject: [PATCH 3/8 v2] mac80211: A-MPDU Rx adding basic functionality
Date: Thu, 20 Dec 2007 11:39:07 +0200
Message-Id: <11981435612196-git-send-email-ron.rindjunsky@intel.com> (sfid-20071220_094843_704887_F4D3C0D6)
In-Reply-To: <11981435524069-git-send-email-ron.rindjunsky@intel.com>
References: <11981435524069-git-send-email-ron.rindjunsky@intel.com>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds the basic needed abilities and functions for A-MPDU Rx session
changed functions:
 - ieee80211_sta_process_addba_request - Rx A-MPDU initialization enabled
added functions:
 - ieee80211_send_delba - used for sending out Del BA in A-MPDU sessions
 - ieee80211_sta_stop_rx_BA_session - stopping Rx A-MPDU session
 - sta_rx_agg_session_timer_expired - stops A-MPDU Rx use if load is too low

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
---
 include/linux/ieee80211.h    |    7 ++
 net/mac80211/ieee80211_i.h   |    3 +
 net/mac80211/ieee80211_sta.c |  228 ++++++++++++++++++++++++++++++++++++++++--
 net/mac80211/sta_info.c      |    3 +
 4 files changed, 231 insertions(+), 10 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 3e64159..4d5a4c9 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -472,6 +472,13 @@ enum ieee80211_back_actioncode {
 	WLAN_ACTION_DELBA = 2,
 };
 
+/* BACK (block-ack) parties */
+enum ieee80211_back_parties {
+	WLAN_BACK_RECIPIENT = 0,
+	WLAN_BACK_INITIATOR = 1,
+	WLAN_BACK_TIMER = 2,
+};
+
 /* A-MSDU 802.11n */
 #define IEEE80211_QOS_CONTROL_A_MSDU_PRESENT 0x0080
 
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index b54ed5f..cf2256b 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -770,6 +770,9 @@ int ieee80211_ht_cap_ie_to_ht_info(struct ieee80211_ht_cap *ht_cap_ie,
 int ieee80211_ht_addt_info_ie_to_ht_bss_info(
 			struct ieee80211_ht_addt_info *ht_add_info_ie,
 			struct ieee80211_ht_bss_info *bss_info);
+void ieee80211_sta_stop_rx_BA_session(struct net_device *dev, u8 *da,
+				u16 tid, u16 initiator, u16 reason);
+void sta_rx_agg_session_timer_expired(unsigned long data);
 /* ieee80211_iface.c */
 int ieee80211_if_add(struct net_device *dev, const char *name,
 		     struct net_device **new_dev, int type);
diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
index 2e0f861..f696dbc 100644
--- a/net/mac80211/ieee80211_sta.c
+++ b/net/mac80211/ieee80211_sta.c
@@ -64,6 +64,11 @@
 #define IEEE80211_ADDBA_PARAM_TID_MASK 0x003C
 #define IEEE80211_ADDBA_PARAM_BUF_SIZE_MASK 0xFFA0
 
+/* next values represent the buffer size for A-MPDU frame.
+ * According to IEEE802.11n spec size varies from 8K to 64K (in powers of 2) */
+#define IEEE80211_MIN_AMPDU_BUF 0x8
+#define IEEE80211_MAX_AMPDU_BUF 0x40
+
 static void ieee80211_send_probe_req(struct net_device *dev, u8 *dst,
 				     u8 *ssid, size_t ssid_len);
 static struct ieee80211_sta_bss *
@@ -1051,9 +1056,14 @@ static void ieee80211_sta_process_addba_request(struct net_device *dev,
 						size_t len)
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_hw *hw = &local->hw;
+	struct ieee80211_conf *conf = &hw->conf;
 	struct sta_info *sta;
-	u16 capab, tid, timeout, ba_policy, buf_size, status;
+	struct tid_ampdu_rx *tid_agg_rx;
+	u16 capab, tid, timeout, ba_policy, buf_size, start_seq_num, status;
 	u8 dialog_token;
+	int ret = -EOPNOTSUPP;
+	DECLARE_MAC_BUF(mac);
 
 	sta = sta_info_get(local, mgmt->sa);
 	if (!sta)
@@ -1062,28 +1072,226 @@ static void ieee80211_sta_process_addba_request(struct net_device *dev,
 	/* extract session parameters from addba request frame */
 	dialog_token = mgmt->u.action.u.addba_req.dialog_token;
 	timeout = le16_to_cpu(mgmt->u.action.u.addba_req.timeout);
+	start_seq_num =
+		le16_to_cpu(mgmt->u.action.u.addba_req.start_seq_num) >> 4;
 
 	capab = le16_to_cpu(mgmt->u.action.u.addba_req.capab);
 	ba_policy = (capab & IEEE80211_ADDBA_PARAM_POLICY_MASK) >> 1;
 	tid = (capab & IEEE80211_ADDBA_PARAM_TID_MASK) >> 2;
 	buf_size = (capab & IEEE80211_ADDBA_PARAM_BUF_SIZE_MASK) >> 6;
 
-	/* TODO - currently aggregation is declined (A-MPDU add BA request
-	* acceptance is not obligatory by 802.11n draft), but here is
-	* the entry point for dealing with it */
-#ifdef MAC80211_HT_DEBUG
-	if (net_ratelimit())
-		printk(KERN_DEBUG "Add Block Ack request arrived,"
-				   " currently denying it\n");
-#endif /* MAC80211_HT_DEBUG */
-
 	status = WLAN_STATUS_REQUEST_DECLINED;
 
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
+			printk(KERN_DEBUG "Block Ack Req with bad params from "
+				"%s on tid %u. policy %d, buffer size %d\n",
+				print_mac(mac, mgmt->sa), tid, ba_policy,
+				buf_size);
+#endif /* CONFIG_MAC80211_HT_DEBUG */
+		goto end_no_lock;
+	}
+	/* determine default buffer size */
+	if (buf_size == 0) {
+		struct ieee80211_hw_mode *mode = conf->mode;
+		buf_size = IEEE80211_MIN_AMPDU_BUF;
+		buf_size = buf_size << mode->ht_info.ampdu_factor;
+	}
+
+	tid_agg_rx = &sta->ampdu_mlme.tid_rx[tid];
+
+	/* examine state machine */
+	spin_lock_bh(&sta->ampdu_mlme.ampdu_rx);
+
+	if (tid_agg_rx->state != HT_AGG_STATE_IDLE) {
+#ifdef CONFIG_MAC80211_HT_DEBUG
+		if (net_ratelimit())
+			printk(KERN_DEBUG "unexpected Block Ack Req from "
+				"%s on tid %u\n",
+				print_mac(mac, mgmt->sa), tid);
+#endif /* CONFIG_MAC80211_HT_DEBUG */
+		goto end;
+	}
+
+	/* prepare reordering buffer */
+	tid_agg_rx->reorder_buf =
+		kmalloc(buf_size * sizeof(struct sk_buf *), GFP_ATOMIC);
+	if (!tid_agg_rx->reorder_buf) {
+		printk(KERN_ERR "can not allocate reordering buffer "
+						"to tid %d\n", tid);
+		goto end;
+	}
+	memset(tid_agg_rx->reorder_buf, 0,
+		buf_size * sizeof(struct sk_buf *));
+
+	if (local->ops->ampdu_action)
+		ret = local->ops->ampdu_action(hw, IEEE80211_AMPDU_RX_START,
+					       sta->addr, tid, start_seq_num);
+#ifdef CONFIG_MAC80211_HT_DEBUG
+	printk(KERN_DEBUG "Rx A-MPDU on tid %d result %d", tid, ret);
+#endif /* CONFIG_MAC80211_HT_DEBUG */
+
+	if (ret) {
+		kfree(tid_agg_rx->reorder_buf);
+		goto end;
+	}
+
+	/* change state and send addba resp */
+	tid_agg_rx->state = HT_AGG_STATE_OPERATIONAL;
+	tid_agg_rx->dialog_token = dialog_token;
+	tid_agg_rx->ssn = start_seq_num;
+	tid_agg_rx->head_seq_num = start_seq_num;
+	tid_agg_rx->buf_size = buf_size;
+	tid_agg_rx->timeout = timeout;
+	tid_agg_rx->stored_mpdu_num = 0;
+	status = WLAN_STATUS_SUCCESS;
+end:
+	spin_unlock_bh(&sta->ampdu_mlme.ampdu_rx);
+
+end_no_lock:
 	ieee80211_send_addba_resp(sta->dev, sta->addr, tid, dialog_token,
 				status, 1, buf_size, timeout);
 	sta_info_put(sta);
 }
 
+void ieee80211_send_delba(struct net_device *dev, const u8 *da, u16 tid,
+				u16 initiator, u16 reason_code)
+{
+	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_if_sta *ifsta = &sdata->u.sta;
+	struct sk_buff *skb;
+	struct ieee80211_mgmt *mgmt;
+	u16 params;
+
+	skb = dev_alloc_skb(sizeof(*mgmt) + local->hw.extra_tx_headroom + 1 +
+					sizeof(mgmt->u.action.u.delba));
+
+	if (!skb) {
+		printk(KERN_ERR "%s: failed to allocate buffer "
+					"for delba frame\n", dev->name);
+		return;
+	}
+
+	skb_reserve(skb, local->hw.extra_tx_headroom);
+	mgmt = (struct ieee80211_mgmt *) skb_put(skb, 24);
+	memset(mgmt, 0, 24);
+	memcpy(mgmt->da, da, ETH_ALEN);
+	memcpy(mgmt->sa, dev->dev_addr, ETH_ALEN);
+	if (sdata->type == IEEE80211_IF_TYPE_AP)
+		memcpy(mgmt->bssid, dev->dev_addr, ETH_ALEN);
+	else
+		memcpy(mgmt->bssid, ifsta->bssid, ETH_ALEN);
+	mgmt->frame_control = IEEE80211_FC(IEEE80211_FTYPE_MGMT,
+					IEEE80211_STYPE_ACTION);
+
+	skb_put(skb, 1 + sizeof(mgmt->u.action.u.delba));
+
+	mgmt->u.action.category = WLAN_CATEGORY_BACK;
+	mgmt->u.action.u.delba.action_code = WLAN_ACTION_DELBA;
+	params = (u16)(initiator << 11); 	/* bit 11 initiator */
+	params |= (u16)(tid << 12); 		/* bit 15:12 TID number */
+
+	mgmt->u.action.u.delba.params = cpu_to_le16(params);
+	mgmt->u.action.u.delba.reason_code = cpu_to_le16(reason_code);
+
+	ieee80211_sta_tx(dev, skb, 0);
+}
+
+void ieee80211_sta_stop_rx_BA_session(struct net_device *dev, u8 *ra, u16 tid,
+					u16 initiator, u16 reason)
+{
+	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_hw *hw = &local->hw;
+	struct sta_info *sta;
+	int ret;
+
+	sta = sta_info_get(local, ra);
+	if (!sta)
+		return;
+
+	/* check if TID is in operational state */
+	spin_lock_bh(&sta->ampdu_mlme.ampdu_rx);
+	if (sta->ampdu_mlme.tid_rx[tid].state
+				!= HT_AGG_STATE_OPERATIONAL) {
+		spin_unlock_bh(&sta->ampdu_mlme.ampdu_rx);
+		if (net_ratelimit())
+			printk(KERN_DEBUG "rx BA session requested to stop on "
+				"unactive tid %d\n", tid);
+		sta_info_put(sta);
+		return;
+	}
+	sta->ampdu_mlme.tid_rx[tid].state =
+		HT_AGG_STATE_REQ_STOP_BA_MSK |
+		(initiator << HT_AGG_STATE_INITIATOR_SHIFT);
+		spin_unlock_bh(&sta->ampdu_mlme.ampdu_rx);
+
+	/* stop HW Rx aggregation. ampdu_action existence
+	 * already verified in session init so we add the BUG_ON */
+	BUG_ON(!local->ops->ampdu_action);
+
+	ret = local->ops->ampdu_action(hw, IEEE80211_AMPDU_RX_STOP,
+					ra, tid, EINVAL);
+	if (ret)
+		printk(KERN_DEBUG "HW problem - can not stop rx "
+				"aggergation for tid %d\n", tid);
+
+	/* shutdown timer has not expired */
+	if (initiator != WLAN_BACK_TIMER)
+		del_timer_sync(&sta->ampdu_mlme.tid_rx[tid].
+					session_timer);
+
+	/* check if this is a self generated aggregation halt */
+	if (initiator == WLAN_BACK_RECIPIENT || initiator == WLAN_BACK_TIMER)
+		ieee80211_send_delba(dev, ra, tid, 0, reason);
+
+	/* free the reordering buffer */
+	kfree(sta->ampdu_mlme.tid_rx[tid].reorder_buf);
+
+	sta->ampdu_mlme.tid_rx[tid].state = HT_AGG_STATE_IDLE;
+	sta_info_put(sta);
+}
+
+/*
+ * After receiving Block Ack Request (BAR) we activated a
+ * timer after each frame arrives from the originator.
+ * if this timer expires ieee80211_sta_stop_rx_BA_session will be executed.
+ */
+void sta_rx_agg_session_timer_expired(unsigned long data)
+{
+	/* not an elegant detour, but there is no choice as the timer passes
+	 * only one argument, and ieee80211_local is needed here, so init
+	 * flow in sta_info_add gives the TID as data, while the timer_to_id
+	 * array gives the sta through container_of */
+	u8 *ptid = (u8 *)data;
+	u8 *timer_to_id = ptid - *ptid;
+	struct sta_info *temp_sta = container_of(timer_to_id, struct sta_info,
+					 timer_to_tid[0]);
+	struct ieee80211_local *local = temp_sta->local;
+	struct sta_info *sta;
+	u16 tid = (u16)*ptid;
+
+	sta = sta_info_get(local, temp_sta->addr);
+
+	if (!sta)
+		return;
+
+	printk(KERN_DEBUG "rx session timer expired on tid %d\n", tid);
+	ieee80211_sta_stop_rx_BA_session(sta->dev, sta->addr, tid,
+					 WLAN_BACK_TIMER,
+					 WLAN_REASON_QSTA_TIMEOUT);
+	sta_info_put(sta);
+}
+
+
 static void ieee80211_rx_mgmt_auth(struct net_device *dev,
 				   struct ieee80211_if_sta *ifsta,
 				   struct ieee80211_mgmt *mgmt,
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index e849155..cc28e82 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -103,6 +103,7 @@ static void sta_info_release(struct kref *kref)
 	struct sta_info *sta = container_of(kref, struct sta_info, kref);
 	struct ieee80211_local *local = sta->local;
 	struct sk_buff *skb;
+	int i;
 
 	/* free sta structure; it has already been removed from
 	 * hash table etc. external structures. Make sure that all
@@ -115,6 +116,8 @@ static void sta_info_release(struct kref *kref)
 	while ((skb = skb_dequeue(&sta->tx_filtered)) != NULL) {
 		dev_kfree_skb_any(skb);
 	}
+	for (i = 0; i <  STA_TID_NUM; i++)
+		del_timer_sync(&sta->ampdu_mlme.tid_rx[i].session_timer);
 	rate_control_free_sta(sta->rate_ctrl, sta->rate_ctrl_priv);
 	rate_control_put(sta->rate_ctrl);
 	kfree(sta);
-- 
1.5.3.3

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

