Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:39523 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933042AbbFVIHr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jun 2015 04:07:47 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.15.0.59/8.15.0.59) with SMTP id t5M7xp0l015532
	for <linux-wireless@vger.kernel.org>; Mon, 22 Jun 2015 01:07:47 -0700
Received: from sc-owa.marvell.com ([199.233.58.135])
	by mx0a-0016f401.pphosted.com with ESMTP id 1v55hgut8q-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 22 Jun 2015 01:07:47 -0700
From: Avinash Patil <patila@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: <akarwar@marvell.com>, <cluo@marvell.com>, <huxm@marvell.com>,
	Avinash Patil <patila@marvell.com>
Subject: [PATCH 11/17] mwifiex: support for bypass tx queue
Date: Mon, 22 Jun 2015 19:06:17 +0530
Message-ID: <1434980183-2901-12-git-send-email-patila@marvell.com> (sfid-20150622_103352_311824_D14D4706)
In-Reply-To: <1434980183-2901-1-git-send-email-patila@marvell.com>
References: <1434980183-2901-1-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds support for another TX queue in driver- bypass
TX queue. This queue is used for sending data/mgmt packets while
in disconnected state i.e. when port is yet not unblocked.
TDLS setup packets would also be queued in this queue.

Signed-off-by: Avinash Patil <patila@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c |  4 +++
 drivers/net/wireless/mwifiex/init.c     |  1 +
 drivers/net/wireless/mwifiex/main.c     | 49 ++++++++++++++++++++++++++++--
 drivers/net/wireless/mwifiex/main.h     |  2 ++
 drivers/net/wireless/mwifiex/wmm.c      | 53 +++++++++++++++++++++++++++++++++
 drivers/net/wireless/mwifiex/wmm.h      |  4 +++
 6 files changed, 111 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 1d445cb..46f9dc2 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -2789,6 +2789,7 @@ int mwifiex_del_virtual_intf(struct wiphy *wiphy, struct wireless_dev *wdev)
 {
 	struct mwifiex_private *priv = mwifiex_netdev_get_priv(wdev->netdev);
 	struct mwifiex_adapter *adapter = priv->adapter;
+	struct sk_buff *skb, *tmp;
 
 #ifdef CONFIG_DEBUG_FS
 	mwifiex_dev_debugfs_remove(priv);
@@ -2796,6 +2797,9 @@ int mwifiex_del_virtual_intf(struct wiphy *wiphy, struct wireless_dev *wdev)
 
 	mwifiex_stop_net_dev_queue(priv->netdev, adapter);
 
+	skb_queue_walk_safe(&priv->bypass_txq, skb, tmp)
+		mwifiex_write_data_complete(priv->adapter, skb, 0, -1);
+
 	if (netif_carrier_ok(priv->netdev))
 		netif_carrier_off(priv->netdev);
 
diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index df7fdc0..e1b62bf 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -499,6 +499,7 @@ int mwifiex_init_lock_list(struct mwifiex_adapter *adapter)
 		INIT_LIST_HEAD(&priv->sta_list);
 		INIT_LIST_HEAD(&priv->auto_tdls_list);
 		skb_queue_head_init(&priv->tdls_txq);
+		skb_queue_head_init(&priv->bypass_txq);
 
 		spin_lock_init(&priv->tx_ba_stream_tbl_lock);
 		spin_lock_init(&priv->rx_reorder_tbl_lock);
diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index 2a2e5db..278dc94 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -276,6 +276,7 @@ process_start:
 		     !adapter->pm_wakeup_fw_try) &&
 		    (is_command_pending(adapter) ||
 		     !skb_queue_empty(&adapter->tx_data_q) ||
+		     !mwifiex_bypass_txlist_empty(adapter) ||
 		     !mwifiex_wmm_lists_empty(adapter))) {
 			adapter->pm_wakeup_fw_try = true;
 			mod_timer(&adapter->wakeup_timer, jiffies + (HZ*3));
@@ -303,6 +304,7 @@ process_start:
 			     (mwifiex_get_priv(adapter,
 					       MWIFIEX_BSS_ROLE_STA)) ||
 			    (mwifiex_wmm_lists_empty(adapter) &&
+			     mwifiex_bypass_txlist_empty(adapter) &&
 			     skb_queue_empty(&adapter->tx_data_q))) {
 				if (adapter->cmd_sent || adapter->curr_cmd ||
 					!mwifiex_is_send_cmd_allowed
@@ -373,6 +375,22 @@ process_start:
 
 		if ((adapter->scan_chan_gap_enabled ||
 		     !adapter->scan_processing) &&
+		    !adapter->data_sent &&
+		    !mwifiex_bypass_txlist_empty(adapter) &&
+		    !mwifiex_is_tdls_chan_switching
+			(mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_STA))) {
+			mwifiex_process_bypass_tx(adapter);
+			if (adapter->hs_activated) {
+				adapter->is_hs_configured = false;
+				mwifiex_hs_activated_event
+					(mwifiex_get_priv
+					 (adapter, MWIFIEX_BSS_ROLE_ANY),
+					 false);
+			}
+		}
+
+		if ((adapter->scan_chan_gap_enabled ||
+		     !adapter->scan_processing) &&
 		    !adapter->data_sent && !mwifiex_wmm_lists_empty(adapter) &&
 		    !mwifiex_is_tdls_chan_switching
 			(mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_STA))) {
@@ -389,6 +407,7 @@ process_start:
 		if (adapter->delay_null_pkt && !adapter->cmd_sent &&
 		    !adapter->curr_cmd && !is_command_pending(adapter) &&
 		    (mwifiex_wmm_lists_empty(adapter) &&
+		     mwifiex_bypass_txlist_empty(adapter) &&
 		     skb_queue_empty(&adapter->tx_data_q))) {
 			if (!mwifiex_send_null_packet
 			    (mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_STA),
@@ -659,6 +678,26 @@ mwifiex_close(struct net_device *dev)
 	return 0;
 }
 
+static bool
+mwifiex_bypass_tx_queue(struct mwifiex_private *priv,
+			struct sk_buff *skb)
+{
+	struct ethhdr *eth_hdr = (struct ethhdr *)skb->data;
+
+	if (ntohs(eth_hdr->h_proto) == ETH_P_PAE ||
+	    mwifiex_is_skb_mgmt_frame(skb) ||
+	    (GET_BSS_ROLE(priv) == MWIFIEX_BSS_ROLE_STA &&
+	     ISSUPP_TDLS_ENABLED(priv->adapter->fw_cap_info) &&
+	     (ntohs(eth_hdr->h_proto) == ETH_P_TDLS))) {
+		mwifiex_dbg(priv->adapter, DATA,
+			    "bypass txqueue; eth type %#x, mgmt %d\n",
+			     ntohs(eth_hdr->h_proto),
+			     mwifiex_is_skb_mgmt_frame(skb));
+		return true;
+	}
+
+	return false;
+}
 /*
  * Add buffer into wmm tx queue and queue work to transmit it.
  */
@@ -676,8 +715,14 @@ int mwifiex_queue_tx_pkt(struct mwifiex_private *priv, struct sk_buff *skb)
 		}
 	}
 
-	atomic_inc(&priv->adapter->tx_pending);
-	mwifiex_wmm_add_buf_txqueue(priv, skb);
+	if (mwifiex_bypass_tx_queue(priv, skb)) {
+		atomic_inc(&priv->adapter->tx_pending);
+		atomic_inc(&priv->adapter->bypass_tx_pending);
+		mwifiex_wmm_add_buf_bypass_txqueue(priv, skb);
+	 } else {
+		atomic_inc(&priv->adapter->tx_pending);
+		mwifiex_wmm_add_buf_txqueue(priv, skb);
+	 }
 
 	mwifiex_queue_main_work(priv->adapter);
 
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index d74ef2d..c59430e 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -664,6 +664,7 @@ struct mwifiex_private {
 	struct cfg80211_beacon_data beacon_after;
 	struct mwifiex_11h_intf_state state_11h;
 	struct mwifiex_ds_mem_rw mem_rw;
+	struct sk_buff_head bypass_txq;
 };
 
 
@@ -834,6 +835,7 @@ struct mwifiex_adapter {
 	wait_queue_head_t init_wait_q;
 	void *card;
 	struct mwifiex_if_ops if_ops;
+	atomic_t bypass_tx_pending;
 	atomic_t rx_pending;
 	atomic_t tx_pending;
 	atomic_t cmd_pending;
diff --git a/drivers/net/wireless/mwifiex/wmm.c b/drivers/net/wireless/mwifiex/wmm.c
index 6196daa..7995f92 100644
--- a/drivers/net/wireless/mwifiex/wmm.c
+++ b/drivers/net/wireless/mwifiex/wmm.c
@@ -449,6 +449,11 @@ mwifiex_wmm_init(struct mwifiex_adapter *adapter)
 	}
 }
 
+int mwifiex_bypass_txlist_empty(struct mwifiex_adapter *adapter)
+{
+	return atomic_read(&adapter->bypass_tx_pending) ? false : true;
+}
+
 /*
  * This function checks if WMM Tx queue is empty.
  */
@@ -581,6 +586,10 @@ mwifiex_clean_txrx(struct mwifiex_private *priv)
 	skb_queue_walk_safe(&priv->tdls_txq, skb, tmp)
 		mwifiex_write_data_complete(priv->adapter, skb, 0, -1);
 
+	skb_queue_walk_safe(&priv->bypass_txq, skb, tmp)
+		mwifiex_write_data_complete(priv->adapter, skb, 0, -1);
+	atomic_set(&priv->adapter->bypass_tx_pending, 0);
+
 	idr_for_each(&priv->ack_status_frames, mwifiex_free_ack_frame, NULL);
 	idr_destroy(&priv->ack_status_frames);
 }
@@ -753,6 +762,18 @@ mwifiex_is_ralist_valid(struct mwifiex_private *priv,
 }
 
 /*
+ * This function adds a packet to bypass TX queue.
+ * This is special TX queue for packets which can be sent even when port_open
+ * is false.
+ */
+void
+mwifiex_wmm_add_buf_bypass_txqueue(struct mwifiex_private *priv,
+				   struct sk_buff *skb)
+{
+	skb_queue_tail(&priv->bypass_txq, skb);
+}
+
+/*
  * This function adds a packet to WMM queue.
  *
  * In disconnected state the packet is immediately dropped and the
@@ -1429,6 +1450,38 @@ mwifiex_dequeue_tx_packet(struct mwifiex_adapter *adapter)
 	return 0;
 }
 
+void mwifiex_process_bypass_tx(struct mwifiex_adapter *adapter)
+{
+	struct mwifiex_tx_param tx_param;
+	struct sk_buff *skb;
+	struct mwifiex_txinfo *tx_info;
+	struct mwifiex_private *priv;
+	int i;
+
+	if (adapter->data_sent || adapter->tx_lock_flag)
+		return;
+
+	for (i = 0; i < adapter->priv_num; ++i) {
+		priv = adapter->priv[i];
+
+		if (skb_queue_empty(&priv->bypass_txq))
+			continue;
+
+		skb = skb_dequeue(&priv->bypass_txq);
+		tx_info = MWIFIEX_SKB_TXCB(skb);
+
+		/* no aggregation for bypass packets */
+		tx_param.next_pkt_len = 0;
+
+		if (mwifiex_process_tx(priv, skb, &tx_param) == -EBUSY) {
+			skb_queue_head(&priv->bypass_txq, skb);
+			tx_info->flags |= MWIFIEX_BUF_FLAG_REQUEUED_PKT;
+		} else {
+			atomic_dec(&adapter->bypass_tx_pending);
+		}
+	}
+}
+
 /*
  * This function transmits the highest priority packet awaiting in the
  * WMM Queues.
diff --git a/drivers/net/wireless/mwifiex/wmm.h b/drivers/net/wireless/mwifiex/wmm.h
index c12dd0e..38f0976 100644
--- a/drivers/net/wireless/mwifiex/wmm.h
+++ b/drivers/net/wireless/mwifiex/wmm.h
@@ -99,12 +99,16 @@ mwifiex_wmm_is_ra_list_empty(struct list_head *ra_list_hhead)
 
 void mwifiex_wmm_add_buf_txqueue(struct mwifiex_private *priv,
 				 struct sk_buff *skb);
+void mwifiex_wmm_add_buf_bypass_txqueue(struct mwifiex_private *priv,
+					struct sk_buff *skb);
 void mwifiex_ralist_add(struct mwifiex_private *priv, const u8 *ra);
 void mwifiex_rotate_priolists(struct mwifiex_private *priv,
 			      struct mwifiex_ra_list_tbl *ra, int tid);
 
 int mwifiex_wmm_lists_empty(struct mwifiex_adapter *adapter);
+int mwifiex_bypass_txlist_empty(struct mwifiex_adapter *adapter);
 void mwifiex_wmm_process_tx(struct mwifiex_adapter *adapter);
+void mwifiex_process_bypass_tx(struct mwifiex_adapter *adapter);
 int mwifiex_is_ralist_valid(struct mwifiex_private *priv,
 			    struct mwifiex_ra_list_tbl *ra_list, int tid);
 
-- 
1.8.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
