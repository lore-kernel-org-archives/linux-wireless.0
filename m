Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:43739 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754006AbbCLLxB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2015 07:53:01 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id t2CBoLVZ014929
	for <linux-wireless@vger.kernel.org>; Thu, 12 Mar 2015 04:53:00 -0700
Received: from sc-owa03.marvell.com ([199.233.58.149])
	by mx0b-0016f401.pphosted.com with ESMTP id 1t20qjf1mr-13
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 12 Mar 2015 04:53:00 -0700
From: Avinash Patil <patila@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: <akarwar@marvell.com>, <cluo@marvell.com>, <liuzy@marvell.com>,
	<crlo@marvell.com>, <pchen@marvell.com>, <szli@marvell.com>,
	<nishants@marvell.com>
Subject: [PATCH 5/9] mwifiex: get rid of BA setup helper functions
Date: Thu, 12 Mar 2015 22:51:56 +0530
Message-ID: <1426180920-10567-6-git-send-email-patila@marvell.com> (sfid-20150312_125309_757648_727B9B61)
In-Reply-To: <1426180920-10567-1-git-send-email-patila@marvell.com>
References: <1426180920-10567-1-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Zhaoyang Liu <liuzy@marvell.com>

This patch removes BA setup helper routines
mwifiex_is_bastream_setup and  mwifiex_is_amsdu_in_ampdu_allowed.

Current code will use two functions to check bastream setup and
amsdu in ampdu. This patch change these functions to flags, thus
avoiding redundant spin_lock check while dequeuing TX packets.

Signed-off-by: Zhaoyang Liu <liuzy@marvell.com>
Reviewed-by: Cathy Luo <cluo@marvell.com>
Reviewed-by: Avinash Patil <patila@marvell.com>
---
 drivers/net/wireless/mwifiex/11n.c           | 18 +++++++++++++++-
 drivers/net/wireless/mwifiex/11n.h           | 32 ----------------------------
 drivers/net/wireless/mwifiex/11n_rxreorder.c |  7 +++++-
 drivers/net/wireless/mwifiex/main.h          | 13 ++++++-----
 drivers/net/wireless/mwifiex/wmm.c           | 16 ++++++++------
 drivers/net/wireless/mwifiex/wmm.h           |  2 ++
 6 files changed, 42 insertions(+), 46 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11n.c b/drivers/net/wireless/mwifiex/11n.c
index 543148d..433bd68 100644
--- a/drivers/net/wireless/mwifiex/11n.c
+++ b/drivers/net/wireless/mwifiex/11n.c
@@ -159,6 +159,7 @@ int mwifiex_ret_11n_addba_req(struct mwifiex_private *priv,
 	int tid;
 	struct host_cmd_ds_11n_addba_rsp *add_ba_rsp = &resp->params.add_ba_rsp;
 	struct mwifiex_tx_ba_stream_tbl *tx_ba_tbl;
+	struct mwifiex_ra_list_tbl *ra_list;
 	u16 block_ack_param_set = le16_to_cpu(add_ba_rsp->block_ack_param_set);
 
 	add_ba_rsp->ssn = cpu_to_le16((le16_to_cpu(add_ba_rsp->ssn))
@@ -166,7 +167,13 @@ int mwifiex_ret_11n_addba_req(struct mwifiex_private *priv,
 
 	tid = (block_ack_param_set & IEEE80211_ADDBA_PARAM_TID_MASK)
 	       >> BLOCKACKPARAM_TID_POS;
+	ra_list = mwifiex_wmm_get_ralist_node(priv, tid, add_ba_rsp->
+		peer_mac_addr);
 	if (le16_to_cpu(add_ba_rsp->status_code) != BA_RESULT_SUCCESS) {
+		if (ra_list) {
+			ra_list->ba_status = BA_SETUP_NONE;
+			ra_list->amsdu_in_ampdu = false;
+		}
 		mwifiex_del_ba_tbl(priv, tid, add_ba_rsp->peer_mac_addr,
 				   TYPE_DELBA_SENT, true);
 		if (add_ba_rsp->add_rsp_result != BA_RESULT_TIMEOUT)
@@ -185,6 +192,10 @@ int mwifiex_ret_11n_addba_req(struct mwifiex_private *priv,
 			tx_ba_tbl->amsdu = true;
 		else
 			tx_ba_tbl->amsdu = false;
+		if (ra_list) {
+			ra_list->amsdu_in_ampdu = tx_ba_tbl->amsdu;
+			ra_list->ba_status = BA_SETUP_COMPLETE;
+		}
 	} else {
 		dev_err(priv->adapter->dev, "BA stream not created\n");
 	}
@@ -515,6 +526,7 @@ void mwifiex_create_ba_tbl(struct mwifiex_private *priv, u8 *ra, int tid,
 			   enum mwifiex_ba_status ba_status)
 {
 	struct mwifiex_tx_ba_stream_tbl *new_node;
+	struct mwifiex_ra_list_tbl *ra_list;
 	unsigned long flags;
 
 	if (!mwifiex_get_ba_tbl(priv, tid, ra)) {
@@ -522,7 +534,11 @@ void mwifiex_create_ba_tbl(struct mwifiex_private *priv, u8 *ra, int tid,
 				   GFP_ATOMIC);
 		if (!new_node)
 			return;
-
+		ra_list = mwifiex_wmm_get_ralist_node(priv, tid, ra);
+		if (ra_list) {
+			ra_list->ba_status = ba_status;
+			ra_list->amsdu_in_ampdu = false;
+		}
 		INIT_LIST_HEAD(&new_node->list);
 
 		new_node->tid = tid;
diff --git a/drivers/net/wireless/mwifiex/11n.h b/drivers/net/wireless/mwifiex/11n.h
index 8e2e394..afdd58a 100644
--- a/drivers/net/wireless/mwifiex/11n.h
+++ b/drivers/net/wireless/mwifiex/11n.h
@@ -77,22 +77,6 @@ mwifiex_is_station_ampdu_allowed(struct mwifiex_private *priv,
 	return (node->ampdu_sta[tid] != BA_STREAM_NOT_ALLOWED) ? true : false;
 }
 
-/* This function checks whether AMSDU is allowed for BA stream. */
-static inline u8
-mwifiex_is_amsdu_in_ampdu_allowed(struct mwifiex_private *priv,
-				  struct mwifiex_ra_list_tbl *ptr, int tid)
-{
-	struct mwifiex_tx_ba_stream_tbl *tx_tbl;
-
-	if (is_broadcast_ether_addr(ptr->ra))
-		return false;
-	tx_tbl = mwifiex_get_ba_tbl(priv, tid, ptr->ra);
-	if (tx_tbl)
-		return tx_tbl->amsdu;
-
-	return false;
-}
-
 /* This function checks whether AMPDU is allowed or not for a particular TID. */
 static inline u8
 mwifiex_is_ampdu_allowed(struct mwifiex_private *priv,
@@ -182,22 +166,6 @@ mwifiex_find_stream_to_delete(struct mwifiex_private *priv, int ptr_tid,
 }
 
 /*
- * This function checks whether BA stream is set up or not.
- */
-static inline int
-mwifiex_is_ba_stream_setup(struct mwifiex_private *priv,
-			   struct mwifiex_ra_list_tbl *ptr, int tid)
-{
-	struct mwifiex_tx_ba_stream_tbl *tx_tbl;
-
-	tx_tbl = mwifiex_get_ba_tbl(priv, tid, ptr->ra);
-	if (tx_tbl && IS_BASTREAM_SETUP(tx_tbl))
-		return true;
-
-	return false;
-}
-
-/*
  * This function checks whether associated station is 11n enabled
  */
 static inline int mwifiex_is_sta_11n_enabled(struct mwifiex_private *priv,
diff --git a/drivers/net/wireless/mwifiex/11n_rxreorder.c b/drivers/net/wireless/mwifiex/11n_rxreorder.c
index a2e8817..f75f8ac 100644
--- a/drivers/net/wireless/mwifiex/11n_rxreorder.c
+++ b/drivers/net/wireless/mwifiex/11n_rxreorder.c
@@ -659,6 +659,7 @@ mwifiex_del_ba_tbl(struct mwifiex_private *priv, int tid, u8 *peer_mac,
 {
 	struct mwifiex_rx_reorder_tbl *tbl;
 	struct mwifiex_tx_ba_stream_tbl *ptx_tbl;
+	struct mwifiex_ra_list_tbl *ra_list;
 	u8 cleanup_rx_reorder_tbl;
 	unsigned long flags;
 
@@ -686,7 +687,11 @@ mwifiex_del_ba_tbl(struct mwifiex_private *priv, int tid, u8 *peer_mac,
 				"event: TID, RA not found in table\n");
 			return;
 		}
-
+		ra_list = mwifiex_wmm_get_ralist_node(priv, tid, peer_mac);
+		if (ra_list) {
+			ra_list->amsdu_in_ampdu = false;
+			ra_list->ba_status = BA_SETUP_NONE;
+		}
 		spin_lock_irqsave(&priv->tx_ba_stream_tbl_lock, flags);
 		mwifiex_11n_delete_tx_ba_stream_tbl_entry(priv, ptx_tbl);
 		spin_unlock_irqrestore(&priv->tx_ba_stream_tbl_lock, flags);
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index a319abe..439db17 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -211,6 +211,12 @@ struct mwifiex_tx_aggr {
 	u8 amsdu;
 };
 
+enum mwifiex_ba_status {
+	BA_SETUP_NONE = 0,
+	BA_SETUP_INPROGRESS,
+	BA_SETUP_COMPLETE
+};
+
 struct mwifiex_ra_list_tbl {
 	struct list_head list;
 	struct sk_buff_head skb_head;
@@ -219,6 +225,8 @@ struct mwifiex_ra_list_tbl {
 	u16 max_amsdu;
 	u16 ba_pkt_count;
 	u8 ba_packet_thr;
+	enum mwifiex_ba_status ba_status;
+	u8 amsdu_in_ampdu;
 	u16 total_pkt_count;
 	bool tdls_link;
 };
@@ -602,11 +610,6 @@ struct mwifiex_private {
 	struct mwifiex_11h_intf_state state_11h;
 };
 
-enum mwifiex_ba_status {
-	BA_SETUP_NONE = 0,
-	BA_SETUP_INPROGRESS,
-	BA_SETUP_COMPLETE
-};
 
 struct mwifiex_tx_ba_stream_tbl {
 	struct list_head list;
diff --git a/drivers/net/wireless/mwifiex/wmm.c b/drivers/net/wireless/mwifiex/wmm.c
index 0cd4f6b..2d14dd5 100644
--- a/drivers/net/wireless/mwifiex/wmm.c
+++ b/drivers/net/wireless/mwifiex/wmm.c
@@ -157,6 +157,8 @@ void mwifiex_ralist_add(struct mwifiex_private *priv, const u8 *ra)
 
 		ra_list->is_11n_enabled = 0;
 		ra_list->tdls_link = false;
+		ra_list->ba_status = BA_SETUP_NONE;
+		ra_list->amsdu_in_ampdu = false;
 		if (!mwifiex_queuing_ra_based(priv)) {
 			if (mwifiex_get_tdls_link_status(priv, ra) ==
 			    TDLS_SETUP_COMPLETE) {
@@ -574,7 +576,7 @@ mwifiex_clean_txrx(struct mwifiex_private *priv)
  * This function retrieves a particular RA list node, matching with the
  * given TID and RA address.
  */
-static struct mwifiex_ra_list_tbl *
+struct mwifiex_ra_list_tbl *
 mwifiex_wmm_get_ralist_node(struct mwifiex_private *priv, u8 tid,
 			    const u8 *ra_addr)
 {
@@ -1276,13 +1278,13 @@ mwifiex_dequeue_tx_packet(struct mwifiex_adapter *adapter)
 	}
 
 	if (!ptr->is_11n_enabled ||
-	    mwifiex_is_ba_stream_setup(priv, ptr, tid) ||
-	    priv->wps.session_enable) {
+		ptr->ba_status ||
+		priv->wps.session_enable) {
 		if (ptr->is_11n_enabled &&
-		    mwifiex_is_ba_stream_setup(priv, ptr, tid) &&
-		    mwifiex_is_amsdu_in_ampdu_allowed(priv, ptr, tid) &&
-		    mwifiex_is_amsdu_allowed(priv, tid) &&
-		    mwifiex_is_11n_aggragation_possible(priv, ptr,
+			ptr->ba_status &&
+			ptr->amsdu_in_ampdu &&
+			mwifiex_is_amsdu_allowed(priv, tid) &&
+			mwifiex_is_11n_aggragation_possible(priv, ptr,
 							adapter->tx_buf_size))
 			mwifiex_11n_aggregate_pkt(priv, ptr, ptr_index, flags);
 			/* ra_list_spinlock has been freed in
diff --git a/drivers/net/wireless/mwifiex/wmm.h b/drivers/net/wireless/mwifiex/wmm.h
index 569bd73..48ece0b 100644
--- a/drivers/net/wireless/mwifiex/wmm.h
+++ b/drivers/net/wireless/mwifiex/wmm.h
@@ -127,4 +127,6 @@ mwifiex_wmm_get_queue_raptr(struct mwifiex_private *priv, u8 tid,
 			    const u8 *ra_addr);
 u8 mwifiex_wmm_downgrade_tid(struct mwifiex_private *priv, u32 tid);
 
+struct mwifiex_ra_list_tbl *mwifiex_wmm_get_ralist_node(struct mwifiex_private
+					*priv, u8 tid, const u8 *ra_addr);
 #endif /* !_MWIFIEX_WMM_H_ */
-- 
1.8.1.4

