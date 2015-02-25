Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:47874 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752706AbbBYLVl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Feb 2015 06:21:41 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id t1PBIZmx006407
	for <linux-wireless@vger.kernel.org>; Wed, 25 Feb 2015 03:21:40 -0800
Received: from sc-owa04.marvell.com ([199.233.58.150])
	by mx0a-0016f401.pphosted.com with ESMTP id 1spfpbvytm-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 25 Feb 2015 03:21:40 -0800
From: Avinash Patil <patila@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: <akarwar@marvell.com>, <cluo@marvell.com>, <liuzy@marvell.com>,
	<szli@marvell.com>, Marc Yang <yangyang@marvell.com>,
	Avinash Patil <patila@marvell.com>
Subject: [PATCH 4/4] mwifiex: preprocess packets from TX queue
Date: Wed, 25 Feb 2015 22:20:57 +0530
Message-ID: <1424883057-12102-5-git-send-email-patila@marvell.com> (sfid-20150225_122145_222046_D8C262FA)
In-Reply-To: <1424883057-12102-1-git-send-email-patila@marvell.com>
References: <1424883057-12102-1-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Zhaoyang Liu <liuzy@marvell.com>

During profiling, we discovered that driver remains idle for time
when pakcet is downloaded to FW but no TX_DONE has been received
i.e. while data_sent is true.

This patch adds enhancement to TX routine where we preprocess
packets from TX queue, make them ready for TX and add them to
separate TX queue.

Signed-off-by: Zhaoyang Liu <liuzy@marvell.com>
Signed-off-by: Marc Yang <yangyang@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Avinash Patil <patila@marvell.com>
---
 drivers/net/wireless/mwifiex/11n_aggr.c |  14 +++-
 drivers/net/wireless/mwifiex/decl.h     |   2 +
 drivers/net/wireless/mwifiex/init.c     |   5 ++
 drivers/net/wireless/mwifiex/main.c     |  31 ++++++--
 drivers/net/wireless/mwifiex/main.h     |   6 ++
 drivers/net/wireless/mwifiex/txrx.c     | 126 ++++++++++++++++++++++++++++++++
 drivers/net/wireless/mwifiex/wmm.c      |  20 ++++-
 7 files changed, 189 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11n_aggr.c b/drivers/net/wireless/mwifiex/11n_aggr.c
index 9b983b5..d8558a6 100644
--- a/drivers/net/wireless/mwifiex/11n_aggr.c
+++ b/drivers/net/wireless/mwifiex/11n_aggr.c
@@ -175,6 +175,7 @@ mwifiex_11n_aggregate_pkt(struct mwifiex_private *priv,
 	struct txpd *ptx_pd = NULL;
 	struct timeval tv;
 	int headroom = adapter->iface_type == MWIFIEX_USB ? 0 : INTF_HEADER_LEN;
+	int aggr_num = 0;
 
 	skb_src = skb_peek(&pra_list->skb_head);
 	if (!skb_src) {
@@ -200,7 +201,8 @@ mwifiex_11n_aggregate_pkt(struct mwifiex_private *priv,
 
 	if (tx_info_src->flags & MWIFIEX_BUF_FLAG_TDLS_PKT)
 		tx_info_aggr->flags |= MWIFIEX_BUF_FLAG_TDLS_PKT;
-	skb_aggr->priority = skb_src->priority;
+		tx_info_aggr->flags |= MWIFIEX_BUF_FLAG_AGGR_PKT;
+		skb_aggr->priority = skb_src->priority;
 
 	do_gettimeofday(&tv);
 	skb_aggr->tstamp = timeval_to_ktime(tv);
@@ -211,11 +213,9 @@ mwifiex_11n_aggregate_pkt(struct mwifiex_private *priv,
 			break;
 
 		skb_src = skb_dequeue(&pra_list->skb_head);
-
 		pra_list->total_pkt_count--;
-
 		atomic_dec(&priv->wmm.tx_pkts_queued);
-
+		aggr_num++;
 		spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock,
 				       ra_list_flags);
 		mwifiex_11n_form_amsdu_pkt(skb_aggr, skb_src, &pad);
@@ -251,6 +251,12 @@ mwifiex_11n_aggregate_pkt(struct mwifiex_private *priv,
 		ptx_pd = (struct txpd *)skb_aggr->data;
 
 	skb_push(skb_aggr, headroom);
+	tx_info_aggr->aggr_num = aggr_num;
+	if (adapter->data_sent || adapter->tx_lock_flag) {
+		atomic_add(aggr_num, &adapter->tx_queued);
+		skb_queue_tail(&adapter->tx_data_q, skb_aggr);
+		return 0;
+	}
 
 	if (adapter->iface_type == MWIFIEX_USB) {
 		adapter->data_sent = true;
diff --git a/drivers/net/wireless/mwifiex/decl.h b/drivers/net/wireless/mwifiex/decl.h
index cf2fa11..f530207 100644
--- a/drivers/net/wireless/mwifiex/decl.h
+++ b/drivers/net/wireless/mwifiex/decl.h
@@ -83,6 +83,7 @@
 #define MWIFIEX_BUF_FLAG_TDLS_PKT	   BIT(2)
 #define MWIFIEX_BUF_FLAG_EAPOL_TX_STATUS   BIT(3)
 #define MWIFIEX_BUF_FLAG_ACTION_TX_STATUS  BIT(4)
+#define MWIFIEX_BUF_FLAG_AGGR_PKT	   BIT(5)
 
 #define MWIFIEX_BRIDGED_PKTS_THR_HIGH      1024
 #define MWIFIEX_BRIDGED_PKTS_THR_LOW        128
@@ -179,6 +180,7 @@ struct mwifiex_txinfo {
 	u8 flags;
 	u8 bss_num;
 	u8 bss_type;
+	u8 aggr_num;
 	u32 pkt_len;
 	u8 ack_frame_id;
 	u64 cookie;
diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index 2e1df02..2f278a6 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -481,6 +481,7 @@ int mwifiex_init_lock_list(struct mwifiex_adapter *adapter)
 	spin_lock_init(&adapter->rx_proc_lock);
 
 	skb_queue_head_init(&adapter->rx_data_q);
+	skb_queue_head_init(&adapter->tx_data_q);
 
 	for (i = 0; i < adapter->priv_num; ++i) {
 		INIT_LIST_HEAD(&adapter->bss_prio_tbl[i].bss_prio_head);
@@ -688,6 +689,10 @@ mwifiex_shutdown_drv(struct mwifiex_adapter *adapter)
 		}
 	}
 
+	atomic_set(&adapter->tx_queued, 0);
+	while ((skb = skb_dequeue(&adapter->tx_data_q)))
+		mwifiex_write_data_complete(adapter, skb, 0, 0);
+
 	spin_lock_irqsave(&adapter->rx_proc_lock, flags);
 
 	while ((skb = skb_dequeue(&adapter->rx_data_q))) {
diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index 46e1789..dcc32c1 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -259,10 +259,11 @@ process_start:
 
 		/* Need to wake up the card ? */
 		if ((adapter->ps_state == PS_STATE_SLEEP) &&
-		    (adapter->pm_wakeup_card_req &&
-		     !adapter->pm_wakeup_fw_try) &&
-		    (is_command_pending(adapter) ||
-		     !mwifiex_wmm_lists_empty(adapter))) {
+			(adapter->pm_wakeup_card_req &&
+			!adapter->pm_wakeup_fw_try) &&
+			(is_command_pending(adapter) ||
+			!skb_queue_empty(&adapter->tx_data_q) ||
+			!mwifiex_wmm_lists_empty(adapter))) {
 			adapter->pm_wakeup_fw_try = true;
 			mod_timer(&adapter->wakeup_timer, jiffies + (HZ*3));
 			adapter->if_ops.wakeup(adapter);
@@ -286,7 +287,8 @@ process_start:
 
 			if ((!adapter->scan_chan_gap_enabled &&
 			     adapter->scan_processing) || adapter->data_sent ||
-			    mwifiex_wmm_lists_empty(adapter)) {
+			     (skb_queue_empty(&adapter->tx_data_q) &&
+			      mwifiex_wmm_lists_empty(adapter))) {
 				if (adapter->cmd_sent || adapter->curr_cmd ||
 				    (!is_command_pending(adapter)))
 					break;
@@ -335,6 +337,19 @@ process_start:
 				break;
 			}
 		}
+		if ((adapter->scan_chan_gap_enabled ||
+		     !adapter->scan_processing) &&
+		    !skb_queue_empty(&adapter->tx_data_q) &&
+		    !adapter->data_sent) {
+			mwifiex_process_tx_queue(adapter);
+			if (adapter->hs_activated) {
+				adapter->is_hs_configured = false;
+				mwifiex_hs_activated_event
+					(mwifiex_get_priv
+					 (adapter, MWIFIEX_BSS_ROLE_ANY),
+					 false);
+			}
+		}
 
 		if ((adapter->scan_chan_gap_enabled ||
 		     !adapter->scan_processing) &&
@@ -350,8 +365,10 @@ process_start:
 		}
 
 		if (adapter->delay_null_pkt && !adapter->cmd_sent &&
-		    !adapter->curr_cmd && !is_command_pending(adapter) &&
-		    mwifiex_wmm_lists_empty(adapter)) {
+			!adapter->curr_cmd && !is_command_pending(adapter) &&
+			(mwifiex_wmm_lists_empty(adapter) &&
+			skb_queue_empty(&adapter->tx_data_q))
+		) {
 			if (!mwifiex_send_null_packet
 			    (mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_STA),
 			     MWIFIEX_TxPD_POWER_MGMT_NULL_PACKET |
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index cc6a623..3da99e8 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -58,6 +58,8 @@ enum {
 
 #define MWIFIEX_MAX_AP				64
 
+#define MWIFIEX_MAX_PKTS_TXQ			16
+
 #define MWIFIEX_DEFAULT_WATCHDOG_TIMEOUT	(5 * HZ)
 
 #define MWIFIEX_TIMER_10S			10000
@@ -819,6 +821,8 @@ struct mwifiex_adapter {
 	/* spin lock for RX processing routine */
 	spinlock_t rx_proc_lock;
 	u32 scan_processing;
+	struct sk_buff_head tx_data_q;
+	atomic_t tx_queued;
 	u16 region_code;
 	struct mwifiex_802_11d_domain_reg domain_reg;
 	u16 scan_probes;
@@ -904,6 +908,8 @@ struct mwifiex_adapter {
 	bool auto_tdls;
 };
 
+void mwifiex_process_tx_queue(struct mwifiex_adapter *adapter);
+
 int mwifiex_init_lock_list(struct mwifiex_adapter *adapter);
 
 void mwifiex_set_trans_start(struct net_device *dev);
diff --git a/drivers/net/wireless/mwifiex/txrx.c b/drivers/net/wireless/mwifiex/txrx.c
index ea4549f..e55a7fa 100644
--- a/drivers/net/wireless/mwifiex/txrx.c
+++ b/drivers/net/wireless/mwifiex/txrx.c
@@ -92,6 +92,12 @@ int mwifiex_process_tx(struct mwifiex_private *priv, struct sk_buff *skb,
 	else
 		head_ptr = mwifiex_process_sta_txpd(priv, skb);
 
+	if ((adapter->data_sent || adapter->tx_lock_flag) && head_ptr) {
+		skb_queue_tail(&adapter->tx_data_q, skb);
+		atomic_inc(&adapter->tx_queued);
+		return 0;
+	}
+
 	if (head_ptr) {
 		if (GET_BSS_ROLE(priv) == MWIFIEX_BSS_ROLE_STA)
 			local_tx_pd = (struct txpd *)(head_ptr + hroom);
@@ -142,6 +148,124 @@ int mwifiex_process_tx(struct mwifiex_private *priv, struct sk_buff *skb,
 	return ret;
 }
 
+static int
+mwifiex_host_to_card(struct mwifiex_adapter *adapter, struct sk_buff *skb,
+		     struct mwifiex_tx_param *tx_param)
+{
+	struct txpd *local_tx_pd = NULL;
+	u8 *head_ptr = skb->data;
+	int ret = 0;
+	struct mwifiex_private *priv;
+	struct mwifiex_txinfo *tx_info;
+
+	tx_info = MWIFIEX_SKB_TXCB(skb);
+
+	priv = mwifiex_get_priv_by_id(adapter, tx_info->bss_num,
+				      tx_info->bss_type);
+	if (!priv) {
+		dev_err(adapter->dev, "data: priv not found. Drop TX packet\n");
+		adapter->dbg.num_tx_host_to_card_failure++;
+		mwifiex_write_data_complete(adapter, skb, 0, 0);
+		return ret;
+	}
+	if (GET_BSS_ROLE(priv) == MWIFIEX_BSS_ROLE_STA) {
+		if (adapter->iface_type == MWIFIEX_USB)
+			local_tx_pd = (struct txpd *)head_ptr;
+		else
+			local_tx_pd = (struct txpd *) (head_ptr +
+				INTF_HEADER_LEN);
+	}
+
+	if (adapter->iface_type == MWIFIEX_USB) {
+		adapter->data_sent = true;
+		ret = adapter->if_ops.host_to_card(adapter,
+						   MWIFIEX_USB_EP_DATA,
+						   skb, NULL);
+	} else {
+		ret = adapter->if_ops.host_to_card(adapter,
+						   MWIFIEX_TYPE_DATA,
+						   skb, tx_param);
+	}
+	switch (ret) {
+	case -ENOSR:
+		dev_err(adapter->dev, "data: -ENOSR is returned\n");
+		break;
+	case -EBUSY:
+		if ((GET_BSS_ROLE(priv) == MWIFIEX_BSS_ROLE_STA) &&
+		    (adapter->pps_uapsd_mode && adapter->tx_lock_flag)) {
+				priv->adapter->tx_lock_flag = false;
+			if (local_tx_pd)
+				local_tx_pd->flags = 0;
+		}
+		skb_queue_head(&adapter->tx_data_q, skb);
+
+		if (tx_info->flags & MWIFIEX_BUF_FLAG_AGGR_PKT)
+			atomic_add(tx_info->aggr_num, &adapter->tx_queued);
+		else
+			atomic_inc(&adapter->tx_queued);
+
+		dev_dbg(adapter->dev, "data: -EBUSY is returned\n");
+		break;
+	case -1:
+		if (adapter->iface_type != MWIFIEX_PCIE)
+			adapter->data_sent = false;
+		dev_err(adapter->dev, "mwifiex_write_data_async failed: 0x%X\n",
+			ret);
+		adapter->dbg.num_tx_host_to_card_failure++;
+		mwifiex_write_data_complete(adapter, skb, 0, ret);
+		break;
+	case -EINPROGRESS:
+		if (adapter->iface_type != MWIFIEX_PCIE)
+			adapter->data_sent = false;
+		break;
+	case 0:
+		mwifiex_write_data_complete(adapter, skb, 0, ret);
+		break;
+	default:
+		break;
+	}
+	return ret;
+}
+
+static int
+mwifiex_dequeue_tx_queue(struct mwifiex_adapter *adapter)
+{
+	struct sk_buff *skb, *skb_next;
+	struct mwifiex_txinfo *tx_info;
+	struct mwifiex_tx_param tx_param;
+
+	skb = skb_dequeue(&adapter->tx_data_q);
+
+	if (!skb)
+		return -1;
+
+	tx_info = MWIFIEX_SKB_TXCB(skb);
+	if (tx_info->flags & MWIFIEX_BUF_FLAG_AGGR_PKT)
+		atomic_sub(tx_info->aggr_num, &adapter->tx_queued);
+	else
+		atomic_dec(&adapter->tx_queued);
+
+	if (!skb_queue_empty(&adapter->tx_data_q))
+		skb_next = skb_peek(&adapter->tx_data_q);
+	else
+		skb_next = NULL;
+
+	tx_param.next_pkt_len = ((skb_next) ? skb_next->len : 0);
+
+	return mwifiex_host_to_card(adapter, skb, &tx_param);
+}
+
+void
+mwifiex_process_tx_queue(struct mwifiex_adapter *adapter)
+{
+	do {
+		if (adapter->data_sent || adapter->tx_lock_flag)
+			break;
+		if (mwifiex_dequeue_tx_queue(adapter))
+			break;
+	} while (!skb_queue_empty(&adapter->tx_data_q));
+}
+
 /*
  * Packet send completion callback handler.
  *
@@ -181,6 +305,8 @@ int mwifiex_write_data_complete(struct mwifiex_adapter *adapter,
 
 	if (tx_info->flags & MWIFIEX_BUF_FLAG_BRIDGED_PKT)
 		atomic_dec_return(&adapter->pending_bridged_pkts);
+	if (tx_info->flags & MWIFIEX_BUF_FLAG_AGGR_PKT)
+		goto done;
 
 	if (aggr)
 		/* For skb_aggr, do not wake up tx queue */
diff --git a/drivers/net/wireless/mwifiex/wmm.c b/drivers/net/wireless/mwifiex/wmm.c
index ce747f7..c53c769 100644
--- a/drivers/net/wireless/mwifiex/wmm.c
+++ b/drivers/net/wireless/mwifiex/wmm.c
@@ -1174,6 +1174,14 @@ mwifiex_send_processed_packet(struct mwifiex_private *priv,
 
 	skb = skb_dequeue(&ptr->skb_head);
 
+	if (adapter->data_sent || adapter->tx_lock_flag) {
+		spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock,
+				       ra_list_flags);
+		skb_queue_tail(&adapter->tx_data_q, skb);
+		atomic_inc(&adapter->tx_queued);
+		return;
+	}
+
 	if (!skb_queue_empty(&ptr->skb_head))
 		skb_next = skb_peek(&ptr->skb_head);
 	else
@@ -1324,11 +1332,15 @@ void
 mwifiex_wmm_process_tx(struct mwifiex_adapter *adapter)
 {
 	do {
-		/* Check if busy */
-		if (adapter->data_sent || adapter->tx_lock_flag)
-			break;
-
 		if (mwifiex_dequeue_tx_packet(adapter))
 			break;
+		if (adapter->iface_type != MWIFIEX_SDIO) {
+			if (adapter->data_sent || adapter->tx_lock_flag)
+				break;
+		} else {
+			if (atomic_read(&adapter->tx_queued) >=
+			    MWIFIEX_MAX_PKTS_TXQ)
+				break;
+		}
 	} while (!mwifiex_wmm_lists_empty(adapter));
 }
-- 
1.8.1.4

