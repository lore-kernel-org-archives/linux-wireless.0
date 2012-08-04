Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na6sys009bog027.obsmtp.com ([74.125.150.94]:50655 "EHLO
	na6sys009bog027.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753085Ab2HDBT4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Aug 2012 21:19:56 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Stone Piao <piaoyun@marvell.com>, Ying Luo <luoy@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 12/16] mwifiex: add 11n Block Ack support for uAP
Date: Fri,  3 Aug 2012 18:06:10 -0700
Message-Id: <1344042374-6892-13-git-send-email-bzhao@marvell.com> (sfid-20120804_031959_446637_77CCEE93)
In-Reply-To: <1344042374-6892-1-git-send-email-bzhao@marvell.com>
References: <1344042374-6892-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

This patch adds support for handling BA request and BA setup
events for AP interface.

RA list is marked as either 11n enabled or disabled from station's
capabilities in association request. BA setup is initiated only
after some specific number of packets for particular RA list are
transmitted.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Kiran Divekar <dkiran@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/11n.h           |   14 ++++++
 drivers/net/wireless/mwifiex/11n_rxreorder.c |   15 +++++--
 drivers/net/wireless/mwifiex/11n_rxreorder.h |    2 +
 drivers/net/wireless/mwifiex/main.h          |    3 +
 drivers/net/wireless/mwifiex/uap_event.c     |   21 +++++++++
 drivers/net/wireless/mwifiex/wmm.c           |   59 +++++++++++++++++++++++--
 6 files changed, 105 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11n.h b/drivers/net/wireless/mwifiex/11n.h
index 28366e9..6d2edb4 100644
--- a/drivers/net/wireless/mwifiex/11n.h
+++ b/drivers/net/wireless/mwifiex/11n.h
@@ -157,4 +157,18 @@ mwifiex_is_ba_stream_setup(struct mwifiex_private *priv,
 
 	return false;
 }
+
+/*
+ * This function checks whether associated station is 11n enabled
+ */
+static inline int mwifiex_is_sta_11n_enabled(struct mwifiex_private *priv,
+					     struct mwifiex_sta_node *node)
+{
+
+	if (!node || (priv->bss_role != MWIFIEX_BSS_ROLE_UAP) ||
+	    !priv->ap_11n_enabled)
+		return 0;
+
+	return node->is_11n_enabled;
+}
 #endif /* !_MWIFIEX_11N_H_ */
diff --git a/drivers/net/wireless/mwifiex/11n_rxreorder.c b/drivers/net/wireless/mwifiex/11n_rxreorder.c
index 20367fe..e43d27d 100644
--- a/drivers/net/wireless/mwifiex/11n_rxreorder.c
+++ b/drivers/net/wireless/mwifiex/11n_rxreorder.c
@@ -235,6 +235,7 @@ mwifiex_11n_create_rx_reorder_tbl(struct mwifiex_private *priv, u8 *ta,
 	struct mwifiex_rx_reorder_tbl *tbl, *new_node;
 	u16 last_seq = 0;
 	unsigned long flags;
+	struct mwifiex_sta_node *node;
 
 	/*
 	 * If we get a TID, ta pair which is already present dispatch all the
@@ -257,13 +258,19 @@ mwifiex_11n_create_rx_reorder_tbl(struct mwifiex_private *priv, u8 *ta,
 	new_node->tid = tid;
 	memcpy(new_node->ta, ta, ETH_ALEN);
 	new_node->start_win = seq_num;
-	if (mwifiex_queuing_ra_based(priv))
-		/* TODO for adhoc */
+
+	if (mwifiex_queuing_ra_based(priv)) {
 		dev_dbg(priv->adapter->dev,
-			"info: ADHOC:last_seq=%d start_win=%d\n",
+			"info: AP/ADHOC:last_seq=%d start_win=%d\n",
 			last_seq, new_node->start_win);
-	else
+		if (priv->bss_role == MWIFIEX_BSS_ROLE_UAP) {
+			node = mwifiex_get_sta_entry(priv, ta);
+			if (node)
+				last_seq = node->rx_seq[tid];
+		}
+	} else {
 		last_seq = priv->rx_seq[tid];
+	}
 
 	if (last_seq != MWIFIEX_DEF_11N_RX_SEQ_NUM &&
 	    last_seq >= new_node->start_win)
diff --git a/drivers/net/wireless/mwifiex/11n_rxreorder.h b/drivers/net/wireless/mwifiex/11n_rxreorder.h
index 1cd51d8..13ecb61 100644
--- a/drivers/net/wireless/mwifiex/11n_rxreorder.h
+++ b/drivers/net/wireless/mwifiex/11n_rxreorder.h
@@ -38,6 +38,8 @@
 #define ADDBA_RSP_STATUS_ACCEPT 0
 
 #define MWIFIEX_DEF_11N_RX_SEQ_NUM	0xffff
+#define BA_SETUP_MAX_PACKET_THRESHOLD	16
+#define BA_SETUP_PACKET_OFFSET		16
 
 static inline void mwifiex_reset_11n_rx_seq_num(struct mwifiex_private *priv)
 {
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 014fe9a..c39cd8e 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -200,6 +200,9 @@ struct mwifiex_ra_list_tbl {
 	u8 ra[ETH_ALEN];
 	u32 total_pkts_size;
 	u32 is_11n_enabled;
+	u16 max_amsdu;
+	u16 pkt_count;
+	u8 ba_packet_thr;
 };
 
 struct mwifiex_tid_tbl {
diff --git a/drivers/net/wireless/mwifiex/uap_event.c b/drivers/net/wireless/mwifiex/uap_event.c
index 6270c80..a10bd95 100644
--- a/drivers/net/wireless/mwifiex/uap_event.c
+++ b/drivers/net/wireless/mwifiex/uap_event.c
@@ -19,6 +19,7 @@
 
 #include "decl.h"
 #include "main.h"
+#include "11n.h"
 
 /*
  * This function will return the pointer to station entry in station list
@@ -168,6 +169,7 @@ int mwifiex_process_uap_event(struct mwifiex_private *priv)
 	struct mwifiex_assoc_event *event;
 	struct mwifiex_sta_node *node;
 	u8 *deauth_mac;
+	struct host_cmd_ds_11n_batimeout *ba_timeout;
 
 	switch (eventcause) {
 	case EVENT_UAP_STA_ASSOC:
@@ -255,6 +257,25 @@ int mwifiex_process_uap_event(struct mwifiex_private *priv)
 				adapter->tx_buf_size);
 		}
 		break;
+	case EVENT_ADDBA:
+		dev_dbg(adapter->dev, "event: ADDBA Request\n");
+		if (priv->media_connected)
+			mwifiex_send_cmd_async(priv, HostCmd_CMD_11N_ADDBA_RSP,
+					       HostCmd_ACT_GEN_SET, 0,
+					       adapter->event_body);
+		break;
+	case EVENT_DELBA:
+		dev_dbg(adapter->dev, "event: DELBA Request\n");
+		if (priv->media_connected)
+			mwifiex_11n_delete_ba_stream(priv, adapter->event_body);
+		break;
+	case EVENT_BA_STREAM_TIEMOUT:
+		dev_dbg(adapter->dev, "event:  BA Stream timeout\n");
+		if (priv->media_connected) {
+			ba_timeout = (void *)adapter->event_body;
+			mwifiex_11n_ba_stream_timeout(priv, ba_timeout);
+		}
+		break;
 	default:
 		dev_dbg(adapter->dev, "event: unknown event id: %#x\n",
 			eventcause);
diff --git a/drivers/net/wireless/mwifiex/wmm.c b/drivers/net/wireless/mwifiex/wmm.c
index 3fa4d41..8ccd699 100644
--- a/drivers/net/wireless/mwifiex/wmm.c
+++ b/drivers/net/wireless/mwifiex/wmm.c
@@ -127,6 +127,29 @@ mwifiex_wmm_allocate_ralist_node(struct mwifiex_adapter *adapter, u8 *ra)
 	return ra_list;
 }
 
+/* This function returns random no between 16 and 32 to be used as threshold
+ * for no of packets after which BA setup is initiated.
+ */
+static u8 mwifiex_get_random_ba_threshold(void)
+{
+	u32 sec, usec;
+	struct timeval ba_tstamp;
+	u8 ba_threshold;
+
+	/* setup ba_packet_threshold here random number between
+	 * [BA_SETUP_PACKET_OFFSET,
+	 * BA_SETUP_PACKET_OFFSET+BA_SETUP_MAX_PACKET_THRESHOLD-1]
+	 */
+
+	do_gettimeofday(&ba_tstamp);
+	sec = (ba_tstamp.tv_sec & 0xFFFF) + (ba_tstamp.tv_sec >> 16);
+	usec = (ba_tstamp.tv_usec & 0xFFFF) + (ba_tstamp.tv_usec >> 16);
+	ba_threshold = (((sec << 16) + usec) % BA_SETUP_MAX_PACKET_THRESHOLD)
+						      + BA_SETUP_PACKET_OFFSET;
+
+	return ba_threshold;
+}
+
 /*
  * This function allocates and adds a RA list for all TIDs
  * with the given RA.
@@ -137,6 +160,12 @@ mwifiex_ralist_add(struct mwifiex_private *priv, u8 *ra)
 	int i;
 	struct mwifiex_ra_list_tbl *ra_list;
 	struct mwifiex_adapter *adapter = priv->adapter;
+	struct mwifiex_sta_node *node;
+	unsigned long flags;
+
+	spin_lock_irqsave(&priv->sta_list_spinlock, flags);
+	node = mwifiex_get_sta_entry(priv, ra);
+	spin_unlock_irqrestore(&priv->sta_list_spinlock, flags);
 
 	for (i = 0; i < MAX_NUM_TID; ++i) {
 		ra_list = mwifiex_wmm_allocate_ralist_node(adapter, ra);
@@ -145,14 +174,24 @@ mwifiex_ralist_add(struct mwifiex_private *priv, u8 *ra)
 		if (!ra_list)
 			break;
 
-		if (!mwifiex_queuing_ra_based(priv))
+		ra_list->is_11n_enabled = 0;
+		if (!mwifiex_queuing_ra_based(priv)) {
 			ra_list->is_11n_enabled = IS_11N_ENABLED(priv);
-		else
-			ra_list->is_11n_enabled = false;
+		} else {
+			ra_list->is_11n_enabled =
+				      mwifiex_is_sta_11n_enabled(priv, node);
+			if (ra_list->is_11n_enabled)
+				ra_list->max_amsdu = node->max_amsdu;
+		}
 
 		dev_dbg(adapter->dev, "data: ralist %p: is_11n_enabled=%d\n",
 			ra_list, ra_list->is_11n_enabled);
 
+		if (ra_list->is_11n_enabled) {
+			ra_list->pkt_count = 0;
+			ra_list->ba_packet_thr =
+					      mwifiex_get_random_ba_threshold();
+		}
 		list_add_tail(&ra_list->list,
 			      &priv->wmm.tid_tbl_ptr[i].ra_list);
 
@@ -647,6 +686,7 @@ mwifiex_wmm_add_buf_txqueue(struct mwifiex_private *priv,
 	skb_queue_tail(&ra_list->skb_head, skb);
 
 	ra_list->total_pkts_size += skb->len;
+	ra_list->pkt_count++;
 
 	atomic_inc(&priv->wmm.tx_pkts_queued);
 
@@ -986,10 +1026,17 @@ mwifiex_is_11n_aggragation_possible(struct mwifiex_private *priv,
 {
 	int count = 0, total_size = 0;
 	struct sk_buff *skb, *tmp;
+	int max_amsdu_size;
+
+	if (priv->bss_role == MWIFIEX_BSS_ROLE_UAP && priv->ap_11n_enabled &&
+	    ptr->is_11n_enabled)
+		max_amsdu_size = min_t(int, ptr->max_amsdu, max_buf_size);
+	else
+		max_amsdu_size = max_buf_size;
 
 	skb_queue_walk_safe(&ptr->skb_head, skb, tmp) {
 		total_size += skb->len;
-		if (total_size >= max_buf_size)
+		if (total_size >= max_amsdu_size)
 			break;
 		if (++count >= MIN_NUM_AMSDU)
 			return true;
@@ -1050,6 +1097,7 @@ mwifiex_send_single_packet(struct mwifiex_private *priv,
 		skb_queue_tail(&ptr->skb_head, skb);
 
 		ptr->total_pkts_size += skb->len;
+		ptr->pkt_count++;
 		tx_info->flags |= MWIFIEX_BUF_FLAG_REQUEUED_PKT;
 		spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock,
 				       ra_list_flags);
@@ -1231,7 +1279,8 @@ mwifiex_dequeue_tx_packet(struct mwifiex_adapter *adapter)
 		/* ra_list_spinlock has been freed in
 		   mwifiex_send_single_packet() */
 	} else {
-		if (mwifiex_is_ampdu_allowed(priv, tid)) {
+		if (mwifiex_is_ampdu_allowed(priv, tid) &&
+		    ptr->pkt_count > ptr->ba_packet_thr) {
 			if (mwifiex_space_avail_for_new_ba_stream(adapter)) {
 				mwifiex_create_ba_tbl(priv, ptr->ra, tid,
 						      BA_SETUP_INPROGRESS);
-- 
1.7.0.2

