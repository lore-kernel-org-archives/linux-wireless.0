Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:35896 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751997AbdJaJqL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 31 Oct 2017 05:46:11 -0400
From: Ganapathi Bhat <gbhat@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Brian Norris <briannorris@chromium.org>,
        Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        James Cao <jcao@marvell.com>,
        Mangesh Malusare <mmangesh@marvell.com>,
        Douglas Anderson <dianders@chromium.org>,
        Karthik Ananthapadmanabha <karthida@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>
Subject: [PATCH 3/3] mwifiex: cleanup rx_reorder_tbl_lock usage
Date: Tue, 31 Oct 2017 15:12:47 +0530
Message-ID: <1509442967-14149-4-git-send-email-gbhat@marvell.com> (sfid-20171031_104616_199374_9DE2C02D)
In-Reply-To: <1509442967-14149-1-git-send-email-gbhat@marvell.com>
References: <1509442967-14149-1-git-send-email-gbhat@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Karthik Ananthapadmanabha <karthida@marvell.com>

Fix the incorrect usage of rx_reorder_tbl_lock spinlock:

1. We shouldn't access the fields of the elements returned by
mwifiex_11n_get_rx_reorder_tbl() after we have released spin
lock. To fix this, To fix this, aquire the spinlock before
calling this function and release the lock only after processing
the corresponding element is complete.

2. Realsing the spinlock during iteration of the list and holding
it back before next iteration is unsafe. Fix it by releasing the
lock only after iteration of the list is complete.

Signed-off-by: Karthik Ananthapadmanabha <karthida@marvell.com>
Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>
---
 .../net/wireless/marvell/mwifiex/11n_rxreorder.c   | 34 +++++++++++++++++-----
 drivers/net/wireless/marvell/mwifiex/uap_txrx.c    |  3 ++
 2 files changed, 29 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c b/drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c
index 4631bc2..b99ace8 100644
--- a/drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c
+++ b/drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c
@@ -234,23 +234,19 @@ static int mwifiex_11n_dispatch_pkt(struct mwifiex_private *priv, void *payload)
 
 /*
  * This function returns the pointer to an entry in Rx reordering
- * table which matches the given TA/TID pair.
+ * table which matches the given TA/TID pair. The caller must
+ * hold rx_reorder_tbl_lock, before calling this function.
  */
 struct mwifiex_rx_reorder_tbl *
 mwifiex_11n_get_rx_reorder_tbl(struct mwifiex_private *priv, int tid, u8 *ta)
 {
 	struct mwifiex_rx_reorder_tbl *tbl;
-	unsigned long flags;
 
-	spin_lock_irqsave(&priv->rx_reorder_tbl_lock, flags);
 	list_for_each_entry(tbl, &priv->rx_reorder_tbl_ptr, list) {
 		if (!memcmp(tbl->ta, ta, ETH_ALEN) && tbl->tid == tid) {
-			spin_unlock_irqrestore(&priv->rx_reorder_tbl_lock,
-					       flags);
 			return tbl;
 		}
 	}
-	spin_unlock_irqrestore(&priv->rx_reorder_tbl_lock, flags);
 
 	return NULL;
 }
@@ -355,11 +351,14 @@ void mwifiex_11n_del_rx_reorder_tbl_by_ta(struct mwifiex_private *priv, u8 *ta)
 	 * If we get a TID, ta pair which is already present dispatch all the
 	 * the packets and move the window size until the ssn
 	 */
+	spin_lock_irqsave(&priv->rx_reorder_tbl_lock, flags);
 	tbl = mwifiex_11n_get_rx_reorder_tbl(priv, tid, ta);
 	if (tbl) {
 		mwifiex_11n_dispatch_pkt_until_start_win(priv, tbl, seq_num);
+		spin_unlock_irqrestore(&priv->rx_reorder_tbl_lock, flags);
 		return;
 	}
+	spin_unlock_irqrestore(&priv->rx_reorder_tbl_lock, flags);
 	/* if !tbl then create one */
 	new_node = kzalloc(sizeof(struct mwifiex_rx_reorder_tbl), GFP_KERNEL);
 	if (!new_node)
@@ -571,15 +570,19 @@ int mwifiex_11n_rx_reorder_pkt(struct mwifiex_private *priv,
 	u16 pkt_index;
 	bool init_window_shift = false;
 	int ret = 0;
+	unsigned long flags;
 
+	spin_lock_irqsave(&priv->rx_reorder_tbl_lock, flags);
 	tbl = mwifiex_11n_get_rx_reorder_tbl(priv, tid, ta);
 	if (!tbl) {
+		spin_unlock_irqrestore(&priv->rx_reorder_tbl_lock, flags);
 		if (pkt_type != PKT_TYPE_BAR)
 			mwifiex_11n_dispatch_pkt(priv, payload);
 		return ret;
 	}
 
 	if ((pkt_type == PKT_TYPE_AMSDU) && !tbl->amsdu) {
+		spin_unlock_irqrestore(&priv->rx_reorder_tbl_lock, flags);
 		mwifiex_11n_dispatch_pkt(priv, payload);
 		return ret;
 	}
@@ -666,6 +669,8 @@ int mwifiex_11n_rx_reorder_pkt(struct mwifiex_private *priv,
 	if (!tbl->timer_context.timer_is_set ||
 	    prev_start_win != tbl->start_win)
 		mwifiex_11n_rxreorder_timer_restart(tbl);
+
+	spin_unlock_irqrestore(&priv->rx_reorder_tbl_lock, flags);
 	return ret;
 }
 
@@ -683,6 +688,7 @@ int mwifiex_11n_rx_reorder_pkt(struct mwifiex_private *priv,
 	struct mwifiex_ra_list_tbl *ra_list;
 	u8 cleanup_rx_reorder_tbl;
 	int tid_down;
+	unsigned long flags;
 
 	if (type == TYPE_DELBA_RECEIVE)
 		cleanup_rx_reorder_tbl = (initiator) ? true : false;
@@ -693,14 +699,18 @@ int mwifiex_11n_rx_reorder_pkt(struct mwifiex_private *priv,
 		    peer_mac, tid, initiator);
 
 	if (cleanup_rx_reorder_tbl) {
+		spin_lock_irqsave(&priv->rx_reorder_tbl_lock, flags);
 		tbl = mwifiex_11n_get_rx_reorder_tbl(priv, tid,
 								 peer_mac);
 		if (!tbl) {
+			spin_unlock_irqrestore(&priv->rx_reorder_tbl_lock,
+					       flags);
 			mwifiex_dbg(priv->adapter, EVENT,
 				    "event: TID, TA not found in table\n");
 			return;
 		}
 		mwifiex_del_rx_reorder_entry(priv, tbl);
+		spin_unlock_irqrestore(&priv->rx_reorder_tbl_lock, flags);
 	} else {
 		ptx_tbl = mwifiex_get_ba_tbl(priv, tid, peer_mac);
 		if (!ptx_tbl) {
@@ -732,6 +742,7 @@ int mwifiex_ret_11n_addba_resp(struct mwifiex_private *priv,
 	int tid, win_size;
 	struct mwifiex_rx_reorder_tbl *tbl;
 	uint16_t block_ack_param_set;
+	unsigned long flags;
 
 	block_ack_param_set = le16_to_cpu(add_ba_rsp->block_ack_param_set);
 
@@ -745,17 +756,20 @@ int mwifiex_ret_11n_addba_resp(struct mwifiex_private *priv,
 		mwifiex_dbg(priv->adapter, ERROR, "ADDBA RSP: failed %pM tid=%d)\n",
 			    add_ba_rsp->peer_mac_addr, tid);
 
+		spin_lock_irqsave(&priv->rx_reorder_tbl_lock, flags);
 		tbl = mwifiex_11n_get_rx_reorder_tbl(priv, tid,
 						     add_ba_rsp->peer_mac_addr);
 		if (tbl)
 			mwifiex_del_rx_reorder_entry(priv, tbl);
 
+		spin_unlock_irqrestore(&priv->rx_reorder_tbl_lock, flags);
 		return 0;
 	}
 
 	win_size = (block_ack_param_set & IEEE80211_ADDBA_PARAM_BUF_SIZE_MASK)
 		    >> BLOCKACKPARAM_WINSIZE_POS;
 
+	spin_lock_irqsave(&priv->rx_reorder_tbl_lock, flags);
 	tbl = mwifiex_11n_get_rx_reorder_tbl(priv, tid,
 					     add_ba_rsp->peer_mac_addr);
 	if (tbl) {
@@ -766,6 +780,7 @@ int mwifiex_ret_11n_addba_resp(struct mwifiex_private *priv,
 		else
 			tbl->amsdu = false;
 	}
+	spin_unlock_irqrestore(&priv->rx_reorder_tbl_lock, flags);
 
 	mwifiex_dbg(priv->adapter, CMD,
 		    "cmd: ADDBA RSP: %pM tid=%d ssn=%d win_size=%d\n",
@@ -806,9 +821,7 @@ void mwifiex_11n_cleanup_reorder_tbl(struct mwifiex_private *priv)
 	spin_lock_irqsave(&priv->rx_reorder_tbl_lock, flags);
 	list_for_each_entry_safe(del_tbl_ptr, tmp_node,
 				 &priv->rx_reorder_tbl_ptr, list) {
-		spin_unlock_irqrestore(&priv->rx_reorder_tbl_lock, flags);
 		mwifiex_del_rx_reorder_entry(priv, del_tbl_ptr);
-		spin_lock_irqsave(&priv->rx_reorder_tbl_lock, flags);
 	}
 	INIT_LIST_HEAD(&priv->rx_reorder_tbl_ptr);
 	spin_unlock_irqrestore(&priv->rx_reorder_tbl_lock, flags);
@@ -933,6 +946,7 @@ void mwifiex_11n_rxba_sync_event(struct mwifiex_private *priv,
 	int tlv_buf_left = len;
 	int ret;
 	u8 *tmp;
+	unsigned long flags;
 
 	mwifiex_dbg_dump(priv->adapter, EVT_D, "RXBA_SYNC event:",
 			 event_buf, len);
@@ -952,14 +966,18 @@ void mwifiex_11n_rxba_sync_event(struct mwifiex_private *priv,
 			    tlv_rxba->mac, tlv_rxba->tid, tlv_seq_num,
 			    tlv_bitmap_len);
 
+		spin_lock_irqsave(&priv->rx_reorder_tbl_lock, flags);
 		rx_reor_tbl_ptr =
 			mwifiex_11n_get_rx_reorder_tbl(priv, tlv_rxba->tid,
 						       tlv_rxba->mac);
 		if (!rx_reor_tbl_ptr) {
+			spin_unlock_irqrestore(&priv->rx_reorder_tbl_lock,
+					       flags);
 			mwifiex_dbg(priv->adapter, ERROR,
 				    "Can not find rx_reorder_tbl!");
 			return;
 		}
+		spin_unlock_irqrestore(&priv->rx_reorder_tbl_lock, flags);
 
 		for (i = 0; i < tlv_bitmap_len; i++) {
 			for (j = 0 ; j < 8; j++) {
diff --git a/drivers/net/wireless/marvell/mwifiex/uap_txrx.c b/drivers/net/wireless/marvell/mwifiex/uap_txrx.c
index 1e6a62c..21dc14f 100644
--- a/drivers/net/wireless/marvell/mwifiex/uap_txrx.c
+++ b/drivers/net/wireless/marvell/mwifiex/uap_txrx.c
@@ -421,12 +421,15 @@ int mwifiex_process_uap_rx_packet(struct mwifiex_private *priv,
 		spin_unlock_irqrestore(&priv->sta_list_spinlock, flags);
 	}
 
+	spin_lock_irqsave(&priv->rx_reorder_tbl_lock, flags);
 	if (!priv->ap_11n_enabled ||
 	    (!mwifiex_11n_get_rx_reorder_tbl(priv, uap_rx_pd->priority, ta) &&
 	    (le16_to_cpu(uap_rx_pd->rx_pkt_type) != PKT_TYPE_AMSDU))) {
+		spin_unlock_irqrestore(&priv->rx_reorder_tbl_lock, flags);
 		ret = mwifiex_handle_uap_rx_forward(priv, skb);
 		return ret;
 	}
+	spin_unlock_irqrestore(&priv->rx_reorder_tbl_lock, flags);
 
 	/* Reorder and send to kernel */
 	pkt_type = (u8)le16_to_cpu(uap_rx_pd->rx_pkt_type);
-- 
1.9.1
