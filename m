Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:49911 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755558Ab2BIBvm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Feb 2012 20:51:42 -0500
From: Naveen Gangadharan <ngangadh@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] ath6kl: Add unicast mgmt frame buffering
Date: Wed, 8 Feb 2012 17:51:36 -0800
Message-ID: <1328752296-3801-1-git-send-email-ngangadh@qca.qualcomm.com> (sfid-20120209_025148_060264_637DE15C)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

PS buffering of unicast Action frames that are sent in a context
of a BSS. In AP mode when the recepient station goes to powersave
and PS_POLL flag is not set, we would buffer the frames. Send out
unicast mgmt bufferred frame when PS_POLL is received.

This fixes a bug in P2P GO behavior when sending a GO Discoverability
Request to a client that is in sleep mode.

Signed-off-by: Thirumalai Pachamuthu <tpachamu@qca.qualcomm.com>
Signed-off-by: Naveen Gangadharan <ngangadh@qca.qualcomm.com>
Signed-off-by: Aarthi Thiruvengadam <athiruve@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   98 +++++++++++++++++++++++----
 drivers/net/wireless/ath/ath6kl/core.c     |    2 +
 drivers/net/wireless/ath/ath6kl/core.h     |   12 ++++
 drivers/net/wireless/ath/ath6kl/main.c     |   44 +++++++++++--
 drivers/net/wireless/ath/ath6kl/txrx.c     |   21 ++++++
 drivers/net/wireless/ath/ath6kl/wmi.c      |   35 +++++++++--
 drivers/net/wireless/ath/ath6kl/wmi.h      |    3 -
 7 files changed, 185 insertions(+), 30 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index d1922d8..c858d9f 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -2572,6 +2572,76 @@ static int ath6kl_send_go_probe_resp(struct ath6kl_vif *vif,
 	return ret;
 }
 
+static bool ath6kl_mgmt_powersave_ap(struct ath6kl_vif *vif,
+				u32 id,
+				u32 freq,
+				u32 wait,
+				const u8 *buf,
+				size_t len,
+				bool *more_data,
+				bool no_cck)
+{
+	struct ieee80211_mgmt *mgmt;
+	struct ath6kl_sta *conn;
+	bool is_psq_empty = false;
+	struct ath6kl_mgmt_buff *mgmt_buf;
+	size_t mgmt_buf_size;
+	struct ath6kl *ar = vif->ar;
+
+	mgmt = (struct ieee80211_mgmt *) buf;
+	if (is_multicast_ether_addr(mgmt->da))
+		return false;
+
+	conn = ath6kl_find_sta(vif, mgmt->da);
+	if (!conn)
+		return false;
+
+	if (conn->sta_flags & STA_PS_SLEEP) {
+		if (!(conn->sta_flags & STA_PS_POLLED)) {
+			/* Queue the frames if the STA is sleeping */
+			mgmt_buf_size = len + sizeof(struct ath6kl_mgmt_buff);
+			mgmt_buf = kmalloc(mgmt_buf_size, GFP_KERNEL);
+			if (!mgmt_buf)
+				return false;
+
+			INIT_LIST_HEAD(&mgmt_buf->list);
+			mgmt_buf->id = id;
+			mgmt_buf->freq = freq;
+			mgmt_buf->wait = wait;
+			mgmt_buf->len = len;
+			mgmt_buf->no_cck = no_cck;
+			memcpy(mgmt_buf->buf, buf, len);
+			spin_lock_bh(&conn->psq_lock);
+			is_psq_empty = skb_queue_empty(&conn->psq) &&
+					(conn->mgmt_psq_len == 0);
+			list_add_tail(&mgmt_buf->list, &conn->mgmt_psq);
+			conn->mgmt_psq_len++;
+			spin_unlock_bh(&conn->psq_lock);
+
+			/*
+			 * If this is the first pkt getting queued
+			 * for this STA, update the PVB for this
+			 * STA.
+			 */
+			if (is_psq_empty)
+				ath6kl_wmi_set_pvb_cmd(ar->wmi, vif->fw_vif_idx,
+						conn->aid, 1);
+			return true;
+		}
+
+		/*
+		 * This tx is because of a PsPoll.
+		 * Determine if MoreData bit has to be set.
+		 */
+		spin_lock_bh(&conn->psq_lock);
+		if (!skb_queue_empty(&conn->psq) || (conn->mgmt_psq_len != 0))
+			*more_data = true;
+		spin_unlock_bh(&conn->psq_lock);
+	}
+
+	return false;
+}
+
 static int ath6kl_mgmt_tx(struct wiphy *wiphy, struct net_device *dev,
 			  struct ieee80211_channel *chan, bool offchan,
 			  enum nl80211_channel_type channel_type,
@@ -2583,6 +2653,7 @@ static int ath6kl_mgmt_tx(struct wiphy *wiphy, struct net_device *dev,
 	struct ath6kl_vif *vif = netdev_priv(dev);
 	u32 id;
 	const struct ieee80211_mgmt *mgmt;
+	bool more_data, queued;
 
 	mgmt = (const struct ieee80211_mgmt *) buf;
 	if (buf + len >= mgmt->u.probe_resp.variable &&
@@ -2608,22 +2679,19 @@ static int ath6kl_mgmt_tx(struct wiphy *wiphy, struct net_device *dev,
 
 	*cookie = id;
 
-	if (test_bit(ATH6KL_FW_CAPABILITY_STA_P2PDEV_DUPLEX,
-		    ar->fw_capabilities)) {
-		/*
-		 * If capable of doing P2P mgmt operations using
-		 * station interface, send additional information like
-		 * supported rates to advertise and xmit rates for
-		 * probe requests
-		 */
-		return ath6kl_wmi_send_mgmt_cmd(ar->wmi, vif->fw_vif_idx, id,
-						chan->center_freq, wait,
-						buf, len, no_cck);
-	} else {
-		return ath6kl_wmi_send_action_cmd(ar->wmi, vif->fw_vif_idx, id,
-						  chan->center_freq, wait,
-						  buf, len);
+	/* AP mode Power saving processing */
+	if (vif->nw_type == AP_NETWORK) {
+		queued = ath6kl_mgmt_powersave_ap(vif,
+					id, chan->center_freq,
+					wait, buf,
+					len, &more_data, no_cck);
+		if (queued)
+			return 0;
 	}
+
+	return ath6kl_wmi_send_mgmt_cmd(ar->wmi, vif->fw_vif_idx, id,
+					chan->center_freq, wait,
+					buf, len, no_cck);
 }
 
 static void ath6kl_mgmt_frame_register(struct wiphy *wiphy,
diff --git a/drivers/net/wireless/ath/ath6kl/core.c b/drivers/net/wireless/ath/ath6kl/core.c
index 722ca59..101aa5d 100644
--- a/drivers/net/wireless/ath/ath6kl/core.c
+++ b/drivers/net/wireless/ath/ath6kl/core.c
@@ -261,6 +261,8 @@ struct ath6kl *ath6kl_core_create(struct device *dev)
 		spin_lock_init(&ar->sta_list[ctr].psq_lock);
 		skb_queue_head_init(&ar->sta_list[ctr].psq);
 		skb_queue_head_init(&ar->sta_list[ctr].apsdq);
+		ar->sta_list[ctr].mgmt_psq_len = 0;
+		INIT_LIST_HEAD(&ar->sta_list[ctr].mgmt_psq);
 		ar->sta_list[ctr].aggr_conn =
 			kzalloc(sizeof(struct aggr_info_conn), GFP_KERNEL);
 		if (!ar->sta_list[ctr].aggr_conn) {
diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index c4d66e0..ef6e44e 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -285,6 +285,16 @@ struct ath6kl_cookie {
 	struct ath6kl_cookie *arc_list_next;
 };
 
+struct ath6kl_mgmt_buff {
+	struct list_head list;
+	u32 freq;
+	u32 wait;
+	u32 id;
+	bool no_cck;
+	size_t len;
+	u8 buf[0];
+};
+
 struct ath6kl_sta {
 	u16 sta_flags;
 	u8 mac[ETH_ALEN];
@@ -295,6 +305,8 @@ struct ath6kl_sta {
 	u8 wpa_ie[ATH6KL_MAX_IE];
 	struct sk_buff_head psq;
 	spinlock_t psq_lock;
+	struct list_head mgmt_psq;
+	size_t mgmt_psq_len;
 	u8 apsd_info;
 	struct sk_buff_head apsdq;
 	struct aggr_info_conn *aggr_conn;
diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
index b96d01a..b7ed9ac 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -80,11 +80,21 @@ static void ath6kl_add_new_sta(struct ath6kl_vif *vif, u8 *mac, u16 aid,
 static void ath6kl_sta_cleanup(struct ath6kl *ar, u8 i)
 {
 	struct ath6kl_sta *sta = &ar->sta_list[i];
+	struct ath6kl_mgmt_buff *entry, *tmp;
 
 	/* empty the queued pkts in the PS queue if any */
 	spin_lock_bh(&sta->psq_lock);
 	skb_queue_purge(&sta->psq);
 	skb_queue_purge(&sta->apsdq);
+
+	if (sta->mgmt_psq_len != 0) {
+		list_for_each_entry_safe(entry, tmp, &sta->mgmt_psq, list) {
+			kfree(entry);
+		}
+		INIT_LIST_HEAD(&sta->mgmt_psq);
+		sta->mgmt_psq_len = 0;
+	}
+
 	spin_unlock_bh(&sta->psq_lock);
 
 	memset(&ar->ap_stats.sta[sta->aid - 1], 0,
@@ -810,6 +820,7 @@ void ath6kl_pspoll_event(struct ath6kl_vif *vif, u8 aid)
 	struct sk_buff *skb;
 	bool psq_empty = false;
 	struct ath6kl *ar = vif->ar;
+	struct ath6kl_mgmt_buff *mgmt_buf;
 
 	conn = ath6kl_find_sta_by_aid(ar, aid);
 
@@ -820,7 +831,7 @@ void ath6kl_pspoll_event(struct ath6kl_vif *vif, u8 aid)
 	 * becomes empty update the PVB for this station.
 	 */
 	spin_lock_bh(&conn->psq_lock);
-	psq_empty  = skb_queue_empty(&conn->psq);
+	psq_empty  = skb_queue_empty(&conn->psq) && (conn->mgmt_psq_len == 0);
 	spin_unlock_bh(&conn->psq_lock);
 
 	if (psq_empty)
@@ -828,15 +839,34 @@ void ath6kl_pspoll_event(struct ath6kl_vif *vif, u8 aid)
 		return;
 
 	spin_lock_bh(&conn->psq_lock);
-	skb = skb_dequeue(&conn->psq);
-	spin_unlock_bh(&conn->psq_lock);
+	if (conn->mgmt_psq_len > 0) {
+		mgmt_buf = list_first_entry(&conn->mgmt_psq,
+					struct ath6kl_mgmt_buff, list);
+		list_del(&mgmt_buf->list);
+		conn->mgmt_psq_len--;
+		spin_unlock_bh(&conn->psq_lock);
+
+		conn->sta_flags |= STA_PS_POLLED;
+		ath6kl_wmi_send_mgmt_cmd(ar->wmi, vif->fw_vif_idx,
+						mgmt_buf->id,
+						mgmt_buf->freq,
+						mgmt_buf->wait,
+						mgmt_buf->buf,
+						mgmt_buf->len,
+						mgmt_buf->no_cck);
+		conn->sta_flags &= ~STA_PS_POLLED;
+		kfree(mgmt_buf);
+	} else {
+		skb = skb_dequeue(&conn->psq);
+		spin_unlock_bh(&conn->psq_lock);
 
-	conn->sta_flags |= STA_PS_POLLED;
-	ath6kl_data_tx(skb, vif->ndev);
-	conn->sta_flags &= ~STA_PS_POLLED;
+		conn->sta_flags |= STA_PS_POLLED;
+		ath6kl_data_tx(skb, vif->ndev);
+		conn->sta_flags &= ~STA_PS_POLLED;
+	}
 
 	spin_lock_bh(&conn->psq_lock);
-	psq_empty  = skb_queue_empty(&conn->psq);
+	psq_empty  = skb_queue_empty(&conn->psq) && (conn->mgmt_psq_len == 0);
 	spin_unlock_bh(&conn->psq_lock);
 
 	if (psq_empty)
diff --git a/drivers/net/wireless/ath/ath6kl/txrx.c b/drivers/net/wireless/ath/ath6kl/txrx.c
index a3dc694..2ab7012 100644
--- a/drivers/net/wireless/ath/ath6kl/txrx.c
+++ b/drivers/net/wireless/ath/ath6kl/txrx.c
@@ -1416,8 +1416,29 @@ void ath6kl_rx(struct htc_target *target, struct htc_packet *packet)
 			if (!(conn->sta_flags & STA_PS_SLEEP)) {
 				struct sk_buff *skbuff = NULL;
 				bool is_apsdq_empty;
+				struct ath6kl_mgmt_buff *mgmt_buf;
 
 				spin_lock_bh(&conn->psq_lock);
+				while (conn->mgmt_psq_len > 0) {
+					mgmt_buf = list_first_entry(
+							&conn->mgmt_psq,
+							struct ath6kl_mgmt_buff,
+							list);
+					list_del(&mgmt_buf->list);
+					conn->mgmt_psq_len--;
+					spin_unlock_bh(&conn->psq_lock);
+					ath6kl_wmi_send_mgmt_cmd(ar->wmi,
+							vif->fw_vif_idx,
+							mgmt_buf->id,
+							mgmt_buf->freq,
+							mgmt_buf->wait,
+							mgmt_buf->buf,
+							mgmt_buf->len,
+							mgmt_buf->no_cck);
+					kfree(mgmt_buf);
+					spin_lock_bh(&conn->psq_lock);
+				}
+				conn->mgmt_psq_len = 0;
 				while ((skbuff = skb_dequeue(&conn->psq))) {
 					spin_unlock_bh(&conn->psq_lock);
 					ath6kl_data_tx(skbuff, vif->ndev);
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index 18fa9aa..21bb376 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -3181,8 +3181,8 @@ int ath6kl_wmi_remain_on_chnl_cmd(struct wmi *wmi, u8 if_idx, u32 freq, u32 dur)
  * ath6kl_wmi_send_mgmt_cmd instead. The new function supports P2P
  * mgmt operations using station interface.
  */
-int ath6kl_wmi_send_action_cmd(struct wmi *wmi, u8 if_idx, u32 id, u32 freq,
-			       u32 wait, const u8 *data, u16 data_len)
+static int ath6kl_wmi_send_action_cmd(struct wmi *wmi, u8 if_idx, u32 id,
+			u32 freq, u32 wait, const u8 *data, u16 data_len)
 {
 	struct sk_buff *skb;
 	struct wmi_send_action_cmd *p;
@@ -3218,9 +3218,9 @@ int ath6kl_wmi_send_action_cmd(struct wmi *wmi, u8 if_idx, u32 id, u32 freq,
 				   NO_SYNC_WMIFLAG);
 }
 
-int ath6kl_wmi_send_mgmt_cmd(struct wmi *wmi, u8 if_idx, u32 id, u32 freq,
-			       u32 wait, const u8 *data, u16 data_len,
-			       u32 no_cck)
+static int __ath6kl_wmi_send_mgmt_cmd(struct wmi *wmi, u8 if_idx, u32 id,
+				u32 freq, u32 wait, const u8 *data,
+				u16 data_len, u32 no_cck)
 {
 	struct sk_buff *skb;
 	struct wmi_send_mgmt_cmd *p;
@@ -3257,6 +3257,31 @@ int ath6kl_wmi_send_mgmt_cmd(struct wmi *wmi, u8 if_idx, u32 id, u32 freq,
 				   NO_SYNC_WMIFLAG);
 }
 
+int ath6kl_wmi_send_mgmt_cmd(struct wmi *wmi, u8 if_idx, u32 id, u32 freq,
+				u32 wait, const u8 *data, u16 data_len,
+				u32 no_cck)
+{
+	int status;
+	struct ath6kl *ar = wmi->parent_dev;
+
+	if (test_bit(ATH6KL_FW_CAPABILITY_STA_P2PDEV_DUPLEX,
+					ar->fw_capabilities)) {
+		/*
+		 * If capable of doing P2P mgmt operations using
+		 * station interface, send additional information like
+		 * supported rates to advertise and xmit rates for
+		 * probe requests
+		 */
+		status = __ath6kl_wmi_send_mgmt_cmd(ar->wmi, if_idx, id, freq,
+						wait, data, data_len, no_cck);
+	} else {
+		status = ath6kl_wmi_send_action_cmd(ar->wmi, if_idx, id, freq,
+						wait, data, data_len);
+	}
+
+	return status;
+}
+
 int ath6kl_wmi_send_probe_response_cmd(struct wmi *wmi, u8 if_idx, u32 freq,
 				       const u8 *dst, const u8 *data,
 				       u16 data_len)
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.h b/drivers/net/wireless/ath/ath6kl/wmi.h
index e791986..25654c3 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.h
+++ b/drivers/net/wireless/ath/ath6kl/wmi.h
@@ -2505,9 +2505,6 @@ int ath6kl_wmi_disable_11b_rates_cmd(struct wmi *wmi, bool disable);
 int ath6kl_wmi_remain_on_chnl_cmd(struct wmi *wmi, u8 if_idx, u32 freq,
 				  u32 dur);
 
-int ath6kl_wmi_send_action_cmd(struct wmi *wmi, u8 if_idx, u32 id, u32 freq,
-			       u32 wait, const u8 *data, u16 data_len);
-
 int ath6kl_wmi_send_mgmt_cmd(struct wmi *wmi, u8 if_idx, u32 id, u32 freq,
 			       u32 wait, const u8 *data, u16 data_len,
 			       u32 no_cck);
-- 
1.7.0.4

