Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [67.231.156.173] ([67.231.156.173]:36624 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752076AbaCHDmL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Mar 2014 22:42:11 -0500
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Xinming Hu <huxm@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 6/6] mwifiex: add AMSDU inside AMPDU support
Date: Fri, 7 Mar 2014 19:41:31 -0800
Message-ID: <1394250091-18477-6-git-send-email-bzhao@marvell.com> (sfid-20140308_044219_000085_8B4B387D)
In-Reply-To: <1394250091-18477-1-git-send-email-bzhao@marvell.com>
References: <1394250091-18477-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

Currently AMPDU aggregation is preferred over AMSDU. AMSDU
aggregation is performed only if AMPDU streams in firmware
are full.
This patch adds simultaneous AMSDU and AMPDU aggregation
support. This mechanism helps to improve throughput.
AMSDU is enabled only for 8897 chipsets which supports 4K
transmit buffer. User can disable AMSDU using
'disable_tx_amsdu' module parameter.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/11n.c           | 31 ++++++++++----
 drivers/net/wireless/mwifiex/11n.h           | 14 +++++++
 drivers/net/wireless/mwifiex/11n_rxreorder.c | 63 +++++++++++++++++++++++++++-
 drivers/net/wireless/mwifiex/ioctl.h         |  1 +
 drivers/net/wireless/mwifiex/main.h          |  4 ++
 drivers/net/wireless/mwifiex/sta_rx.c        | 21 +---------
 drivers/net/wireless/mwifiex/uap_txrx.c      | 22 +---------
 drivers/net/wireless/mwifiex/wmm.c           | 37 +++++++++++-----
 8 files changed, 132 insertions(+), 61 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11n.c b/drivers/net/wireless/mwifiex/11n.c
index 3606c88..d14ead8 100644
--- a/drivers/net/wireless/mwifiex/11n.c
+++ b/drivers/net/wireless/mwifiex/11n.c
@@ -159,13 +159,13 @@ int mwifiex_ret_11n_addba_req(struct mwifiex_private *priv,
 	int tid;
 	struct host_cmd_ds_11n_addba_rsp *add_ba_rsp = &resp->params.add_ba_rsp;
 	struct mwifiex_tx_ba_stream_tbl *tx_ba_tbl;
+	u16 block_ack_param_set = le16_to_cpu(add_ba_rsp->block_ack_param_set);
 
 	add_ba_rsp->ssn = cpu_to_le16((le16_to_cpu(add_ba_rsp->ssn))
 			& SSN_MASK);
 
-	tid = (le16_to_cpu(add_ba_rsp->block_ack_param_set)
-		& IEEE80211_ADDBA_PARAM_TID_MASK)
-		>> BLOCKACKPARAM_TID_POS;
+	tid = (block_ack_param_set & IEEE80211_ADDBA_PARAM_TID_MASK)
+	       >> BLOCKACKPARAM_TID_POS;
 	if (le16_to_cpu(add_ba_rsp->status_code) != BA_RESULT_SUCCESS) {
 		mwifiex_del_ba_tbl(priv, tid, add_ba_rsp->peer_mac_addr,
 				   TYPE_DELBA_SENT, true);
@@ -179,6 +179,12 @@ int mwifiex_ret_11n_addba_req(struct mwifiex_private *priv,
 	if (tx_ba_tbl) {
 		dev_dbg(priv->adapter->dev, "info: BA stream complete\n");
 		tx_ba_tbl->ba_status = BA_SETUP_COMPLETE;
+		if ((block_ack_param_set & BLOCKACKPARAM_AMSDU_SUPP_MASK) &&
+		    priv->add_ba_param.tx_amsdu &&
+		    (priv->aggr_prio_tbl[tid].amsdu != BA_STREAM_NOT_ALLOWED))
+			tx_ba_tbl->amsdu = true;
+		else
+			tx_ba_tbl->amsdu = false;
 	} else {
 		dev_err(priv->adapter->dev, "BA stream not created\n");
 	}
@@ -540,6 +546,7 @@ int mwifiex_send_addba(struct mwifiex_private *priv, int tid, u8 *peer_mac)
 	u32 tx_win_size = priv->add_ba_param.tx_win_size;
 	static u8 dialog_tok;
 	int ret;
+	u16 block_ack_param_set;
 
 	dev_dbg(priv->adapter->dev, "cmd: %s: tid %d\n", __func__, tid);
 
@@ -558,10 +565,16 @@ int mwifiex_send_addba(struct mwifiex_private *priv, int tid, u8 *peer_mac)
 			tx_win_size = MWIFIEX_11AC_STA_AMPDU_DEF_TXWINSIZE;
 	}
 
-	add_ba_req.block_ack_param_set = cpu_to_le16(
-		(u16) ((tid << BLOCKACKPARAM_TID_POS) |
-		       tx_win_size << BLOCKACKPARAM_WINSIZE_POS |
-		       IMMEDIATE_BLOCK_ACK));
+	block_ack_param_set = (u16)((tid << BLOCKACKPARAM_TID_POS) |
+				    tx_win_size << BLOCKACKPARAM_WINSIZE_POS |
+				    IMMEDIATE_BLOCK_ACK);
+
+	/* enable AMSDU inside AMPDU */
+	if (priv->add_ba_param.tx_amsdu &&
+	    (priv->aggr_prio_tbl[tid].amsdu != BA_STREAM_NOT_ALLOWED))
+		block_ack_param_set |= BLOCKACKPARAM_AMSDU_SUPP_MASK;
+
+	add_ba_req.block_ack_param_set = cpu_to_le16(block_ack_param_set);
 	add_ba_req.block_ack_tmo = cpu_to_le16((u16)priv->add_ba_param.timeout);
 
 	++dialog_tok;
@@ -676,6 +689,7 @@ int mwifiex_get_tx_ba_stream_tbl(struct mwifiex_private *priv,
 		dev_dbg(priv->adapter->dev, "data: %s tid=%d\n",
 			__func__, rx_reo_tbl->tid);
 		memcpy(rx_reo_tbl->ra, tx_ba_tsr_tbl->ra, ETH_ALEN);
+		rx_reo_tbl->amsdu = tx_ba_tsr_tbl->amsdu;
 		rx_reo_tbl++;
 		count++;
 		if (count >= MWIFIEX_MAX_TX_BASTREAM_SUPPORTED)
@@ -731,5 +745,8 @@ void mwifiex_set_ba_params(struct mwifiex_private *priv)
 						MWIFIEX_STA_AMPDU_DEF_RXWINSIZE;
 	}
 
+	priv->add_ba_param.tx_amsdu = true;
+	priv->add_ba_param.rx_amsdu = true;
+
 	return;
 }
diff --git a/drivers/net/wireless/mwifiex/11n.h b/drivers/net/wireless/mwifiex/11n.h
index 12bb6ac..40b007a 100644
--- a/drivers/net/wireless/mwifiex/11n.h
+++ b/drivers/net/wireless/mwifiex/11n.h
@@ -76,6 +76,20 @@ mwifiex_is_station_ampdu_allowed(struct mwifiex_private *priv,
 	return (node->ampdu_sta[tid] != BA_STREAM_NOT_ALLOWED) ? true : false;
 }
 
+/* This function checks whether AMSDU is allowed for BA stream. */
+static inline u8
+mwifiex_is_amsdu_in_ampdu_allowed(struct mwifiex_private *priv,
+				  struct mwifiex_ra_list_tbl *ptr, int tid)
+{
+	struct mwifiex_tx_ba_stream_tbl *tx_tbl;
+
+	tx_tbl = mwifiex_get_ba_tbl(priv, tid, ptr->ra);
+	if (tx_tbl)
+		return tx_tbl->amsdu;
+
+	return false;
+}
+
 /* This function checks whether AMPDU is allowed or not for a particular TID. */
 static inline u8
 mwifiex_is_ampdu_allowed(struct mwifiex_private *priv,
diff --git a/drivers/net/wireless/mwifiex/11n_rxreorder.c b/drivers/net/wireless/mwifiex/11n_rxreorder.c
index 2be015b..0c3571f 100644
--- a/drivers/net/wireless/mwifiex/11n_rxreorder.c
+++ b/drivers/net/wireless/mwifiex/11n_rxreorder.c
@@ -26,11 +26,50 @@
 #include "11n.h"
 #include "11n_rxreorder.h"
 
+/* This function will dispatch amsdu packet and forward it to kernel/upper
+ * layer.
+ */
+static int mwifiex_11n_dispatch_amsdu_pkt(struct mwifiex_private *priv,
+					  struct sk_buff *skb)
+{
+	struct rxpd *local_rx_pd = (struct rxpd *)(skb->data);
+	int ret;
+
+	if (le16_to_cpu(local_rx_pd->rx_pkt_type) == PKT_TYPE_AMSDU) {
+		struct sk_buff_head list;
+		struct sk_buff *rx_skb;
+
+		__skb_queue_head_init(&list);
+
+		skb_pull(skb, le16_to_cpu(local_rx_pd->rx_pkt_offset));
+		skb_trim(skb, le16_to_cpu(local_rx_pd->rx_pkt_length));
+
+		ieee80211_amsdu_to_8023s(skb, &list, priv->curr_addr,
+					 priv->wdev->iftype, 0, false);
+
+		while (!skb_queue_empty(&list)) {
+			rx_skb = __skb_dequeue(&list);
+			ret = mwifiex_recv_packet(priv, rx_skb);
+			if (ret == -1)
+				dev_err(priv->adapter->dev,
+					"Rx of A-MSDU failed");
+		}
+		return 0;
+	}
+
+	return -1;
+}
+
 /* This function will process the rx packet and forward it to kernel/upper
  * layer.
  */
 static int mwifiex_11n_dispatch_pkt(struct mwifiex_private *priv, void *payload)
 {
+	int ret = mwifiex_11n_dispatch_amsdu_pkt(priv, payload);
+
+	if (!ret)
+		return 0;
+
 	if (priv->bss_role == MWIFIEX_BSS_ROLE_UAP)
 		return mwifiex_handle_uap_rx_forward(priv, payload);
 
@@ -406,8 +445,11 @@ int mwifiex_cmd_11n_addba_rsp_gen(struct mwifiex_private *priv,
 		>> BLOCKACKPARAM_TID_POS;
 	add_ba_rsp->status_code = cpu_to_le16(ADDBA_RSP_STATUS_ACCEPT);
 	block_ack_param_set &= ~IEEE80211_ADDBA_PARAM_BUF_SIZE_MASK;
-	/* We donot support AMSDU inside AMPDU, hence reset the bit */
-	block_ack_param_set &= ~BLOCKACKPARAM_AMSDU_SUPP_MASK;
+
+	/* If we don't support AMSDU inside AMPDU, reset the bit */
+	if (!priv->add_ba_param.rx_amsdu ||
+	    (priv->aggr_prio_tbl[tid].amsdu == BA_STREAM_NOT_ALLOWED))
+		block_ack_param_set &= ~BLOCKACKPARAM_AMSDU_SUPP_MASK;
 	block_ack_param_set |= rx_win_size << BLOCKACKPARAM_WINSIZE_POS;
 	add_ba_rsp->block_ack_param_set = cpu_to_le16(block_ack_param_set);
 	win_size = (le16_to_cpu(add_ba_rsp->block_ack_param_set)
@@ -468,6 +510,12 @@ int mwifiex_11n_rx_reorder_pkt(struct mwifiex_private *priv,
 			mwifiex_11n_dispatch_pkt(priv, payload);
 		return 0;
 	}
+
+	if ((pkt_type == PKT_TYPE_AMSDU) && !tbl->amsdu) {
+		mwifiex_11n_dispatch_pkt(priv, payload);
+		return 0;
+	}
+
 	start_win = tbl->start_win;
 	win_size = tbl->win_size;
 	end_win = ((start_win + win_size) - 1) & (MAX_TID_VALUE - 1);
@@ -627,6 +675,17 @@ int mwifiex_ret_11n_addba_resp(struct mwifiex_private *priv,
 	win_size = (block_ack_param_set & IEEE80211_ADDBA_PARAM_BUF_SIZE_MASK)
 		    >> BLOCKACKPARAM_WINSIZE_POS;
 
+	tbl = mwifiex_11n_get_rx_reorder_tbl(priv, tid,
+					     add_ba_rsp->peer_mac_addr);
+	if (tbl) {
+		if ((block_ack_param_set & BLOCKACKPARAM_AMSDU_SUPP_MASK) &&
+		    priv->add_ba_param.rx_amsdu &&
+		    (priv->aggr_prio_tbl[tid].amsdu != BA_STREAM_NOT_ALLOWED))
+			tbl->amsdu = true;
+		else
+			tbl->amsdu = false;
+	}
+
 	dev_dbg(priv->adapter->dev,
 		"cmd: ADDBA RSP: %pM tid=%d ssn=%d win_size=%d\n",
 		add_ba_rsp->peer_mac_addr, tid, add_ba_rsp->ssn, win_size);
diff --git a/drivers/net/wireless/mwifiex/ioctl.h b/drivers/net/wireless/mwifiex/ioctl.h
index 1fb2212..ee494db 100644
--- a/drivers/net/wireless/mwifiex/ioctl.h
+++ b/drivers/net/wireless/mwifiex/ioctl.h
@@ -177,6 +177,7 @@ struct mwifiex_ds_rx_reorder_tbl {
 struct mwifiex_ds_tx_ba_stream_tbl {
 	u16 tid;
 	u8 ra[ETH_ALEN];
+	u8 amsdu;
 };
 
 #define DBG_CMD_NUM	5
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 713dd24..a67f7da 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -192,6 +192,8 @@ struct mwifiex_add_ba_param {
 	u32 tx_win_size;
 	u32 rx_win_size;
 	u32 timeout;
+	u8 tx_amsdu;
+	u8 rx_amsdu;
 };
 
 struct mwifiex_tx_aggr {
@@ -560,6 +562,7 @@ struct mwifiex_tx_ba_stream_tbl {
 	int tid;
 	u8 ra[ETH_ALEN];
 	enum mwifiex_ba_status ba_status;
+	u8 amsdu;
 };
 
 struct mwifiex_rx_reorder_tbl;
@@ -579,6 +582,7 @@ struct mwifiex_rx_reorder_tbl {
 	int win_size;
 	void **rx_reorder_ptr;
 	struct reorder_tmr_cnxt timer_context;
+	u8 amsdu;
 	u8 flags;
 };
 
diff --git a/drivers/net/wireless/mwifiex/sta_rx.c b/drivers/net/wireless/mwifiex/sta_rx.c
index b6aa958..ed26387 100644
--- a/drivers/net/wireless/mwifiex/sta_rx.c
+++ b/drivers/net/wireless/mwifiex/sta_rx.c
@@ -201,26 +201,7 @@ int mwifiex_process_sta_rx_packet(struct mwifiex_private *priv,
 		return ret;
 	}
 
-	if (rx_pkt_type == PKT_TYPE_AMSDU) {
-		struct sk_buff_head list;
-		struct sk_buff *rx_skb;
-
-		__skb_queue_head_init(&list);
-
-		skb_pull(skb, rx_pkt_offset);
-		skb_trim(skb, rx_pkt_length);
-
-		ieee80211_amsdu_to_8023s(skb, &list, priv->curr_addr,
-					 priv->wdev->iftype, 0, false);
-
-		while (!skb_queue_empty(&list)) {
-			rx_skb = __skb_dequeue(&list);
-			ret = mwifiex_recv_packet(priv, rx_skb);
-			if (ret == -1)
-				dev_err(adapter->dev, "Rx of A-MSDU failed");
-		}
-		return 0;
-	} else if (rx_pkt_type == PKT_TYPE_MGMT) {
+	if (rx_pkt_type == PKT_TYPE_MGMT) {
 		ret = mwifiex_process_mgmt_packet(priv, skb);
 		if (ret)
 			dev_err(adapter->dev, "Rx of mgmt packet failed");
diff --git a/drivers/net/wireless/mwifiex/uap_txrx.c b/drivers/net/wireless/mwifiex/uap_txrx.c
index 3c74eb2..9a56bc6 100644
--- a/drivers/net/wireless/mwifiex/uap_txrx.c
+++ b/drivers/net/wireless/mwifiex/uap_txrx.c
@@ -284,27 +284,7 @@ int mwifiex_process_uap_rx_packet(struct mwifiex_private *priv,
 		return 0;
 	}
 
-	if (le16_to_cpu(uap_rx_pd->rx_pkt_type) == PKT_TYPE_AMSDU) {
-		struct sk_buff_head list;
-		struct sk_buff *rx_skb;
-
-		__skb_queue_head_init(&list);
-		skb_pull(skb, le16_to_cpu(uap_rx_pd->rx_pkt_offset));
-		skb_trim(skb, le16_to_cpu(uap_rx_pd->rx_pkt_length));
-
-		ieee80211_amsdu_to_8023s(skb, &list, priv->curr_addr,
-					 priv->wdev->iftype, 0, false);
-
-		while (!skb_queue_empty(&list)) {
-			rx_skb = __skb_dequeue(&list);
-			ret = mwifiex_recv_packet(priv, rx_skb);
-			if (ret)
-				dev_err(adapter->dev,
-					"AP:Rx A-MSDU failed");
-		}
-
-		return 0;
-	} else if (rx_pkt_type == PKT_TYPE_MGMT) {
+	if (rx_pkt_type == PKT_TYPE_MGMT) {
 		ret = mwifiex_process_mgmt_packet(priv, skb);
 		if (ret)
 			dev_err(adapter->dev, "Rx of mgmt packet failed");
diff --git a/drivers/net/wireless/mwifiex/wmm.c b/drivers/net/wireless/mwifiex/wmm.c
index 1c5f2b6..0a7cc74 100644
--- a/drivers/net/wireless/mwifiex/wmm.c
+++ b/drivers/net/wireless/mwifiex/wmm.c
@@ -37,8 +37,8 @@
 /* Offset for TOS field in the IP header */
 #define IPTOS_OFFSET 5
 
-static bool enable_tx_amsdu;
-module_param(enable_tx_amsdu, bool, 0644);
+static bool disable_tx_amsdu;
+module_param(disable_tx_amsdu, bool, 0644);
 
 /* WMM information IE */
 static const u8 wmm_info_ie[] = { WLAN_EID_VENDOR_SPECIFIC, 0x07,
@@ -413,7 +413,13 @@ mwifiex_wmm_init(struct mwifiex_adapter *adapter)
 			continue;
 
 		for (i = 0; i < MAX_NUM_TID; ++i) {
-			priv->aggr_prio_tbl[i].amsdu = priv->tos_to_tid_inv[i];
+			if (!disable_tx_amsdu &&
+			    adapter->tx_buf_size > MWIFIEX_TX_DATA_BUF_SIZE_2K)
+				priv->aggr_prio_tbl[i].amsdu =
+							priv->tos_to_tid_inv[i];
+			else
+				priv->aggr_prio_tbl[i].amsdu =
+							BA_STREAM_NOT_ALLOWED;
 			priv->aggr_prio_tbl[i].ampdu_ap =
 							priv->tos_to_tid_inv[i];
 			priv->aggr_prio_tbl[i].ampdu_user =
@@ -1247,13 +1253,22 @@ mwifiex_dequeue_tx_packet(struct mwifiex_adapter *adapter)
 
 	if (!ptr->is_11n_enabled ||
 	    mwifiex_is_ba_stream_setup(priv, ptr, tid) ||
-	    priv->wps.session_enable ||
-	    ((priv->sec_info.wpa_enabled ||
-	      priv->sec_info.wpa2_enabled) &&
-	     !priv->wpa_is_gtk_set)) {
-		mwifiex_send_single_packet(priv, ptr, ptr_index, flags);
-		/* ra_list_spinlock has been freed in
-		   mwifiex_send_single_packet() */
+	    priv->wps.session_enable) {
+		if (ptr->is_11n_enabled &&
+		    mwifiex_is_ba_stream_setup(priv, ptr, tid) &&
+		    mwifiex_is_amsdu_in_ampdu_allowed(priv, ptr, tid) &&
+		    mwifiex_is_amsdu_allowed(priv, tid) &&
+		    mwifiex_is_11n_aggragation_possible(priv, ptr,
+							adapter->tx_buf_size))
+			mwifiex_11n_aggregate_pkt(priv, ptr, ptr_index, flags);
+			/* ra_list_spinlock has been freed in
+			 * mwifiex_11n_aggregate_pkt()
+			 */
+		else
+			mwifiex_send_single_packet(priv, ptr, ptr_index, flags);
+			/* ra_list_spinlock has been freed in
+			 * mwifiex_send_single_packet()
+			 */
 	} else {
 		if (mwifiex_is_ampdu_allowed(priv, ptr, tid) &&
 		    ptr->ba_pkt_count > ptr->ba_packet_thr) {
@@ -1268,7 +1283,7 @@ mwifiex_dequeue_tx_packet(struct mwifiex_adapter *adapter)
 				mwifiex_send_delba(priv, tid_del, ra, 1);
 			}
 		}
-		if (enable_tx_amsdu && mwifiex_is_amsdu_allowed(priv, tid) &&
+		if (mwifiex_is_amsdu_allowed(priv, tid) &&
 		    mwifiex_is_11n_aggragation_possible(priv, ptr,
 							adapter->tx_buf_size))
 			mwifiex_11n_aggregate_pkt(priv, ptr, ptr_index, flags);
-- 
1.8.2.3

