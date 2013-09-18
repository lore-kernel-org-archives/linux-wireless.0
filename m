Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:46192 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751887Ab3IRMnd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Sep 2013 08:43:33 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 3/5] ath10k: decouple HTT TX completions
Date: Wed, 18 Sep 2013 14:43:20 +0200
Message-ID: <1379508202-9660-4-git-send-email-michal.kazior@tieto.com> (sfid-20130918_144342_608704_87834569)
In-Reply-To: <1379508202-9660-1-git-send-email-michal.kazior@tieto.com>
References: <1379508202-9660-1-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Until now the all MSDU transfer related structures
were freed when all resources were unreferenced.

Now HTC transfer is freed independently and HTT
transfer is so too.

This yields a way more simpler ath10k_skb_cb and
should possibly enable parallel pipe processing
(which is now serialized in
ath10k_pci_process_ce routine).

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.h   |    8 ----
 drivers/net/wireless/ath/ath10k/htt_rx.c |    4 +-
 drivers/net/wireless/ath/ath10k/htt_tx.c |   64 ++++--------------------------
 drivers/net/wireless/ath/ath10k/mac.c    |    2 -
 drivers/net/wireless/ath/ath10k/txrx.c   |   52 ++++++++----------------
 drivers/net/wireless/ath/ath10k/txrx.h   |    5 +--
 6 files changed, 27 insertions(+), 108 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index fcf94ee..4563f80 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -52,18 +52,10 @@ struct ath10k_skb_cb {
 
 	struct {
 		u8 vdev_id;
-		u16 msdu_id;
 		u8 tid;
 		bool is_offchan;
-		bool is_conf;
-		bool discard;
-		bool no_ack;
-		u8 refcount;
 		struct sk_buff *txfrag;
-		struct sk_buff *msdu;
 	} __packed htt;
-
-	/* 4 bytes left on 64bit arch */
 } __packed;
 
 static inline struct ath10k_skb_cb *ATH10K_SKB_CB(struct sk_buff *skb)
diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index a39fbf4..62ea9c8 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -1140,7 +1140,7 @@ void ath10k_htt_t2h_msg_handler(struct ath10k *ar, struct sk_buff *skb)
 			break;
 		}
 
-		ath10k_txrx_tx_completed(htt, &tx_done);
+		ath10k_txrx_tx_unref(htt, &tx_done);
 		break;
 	}
 	case HTT_T2H_MSG_TYPE_TX_COMPL_IND: {
@@ -1174,7 +1174,7 @@ void ath10k_htt_t2h_msg_handler(struct ath10k *ar, struct sk_buff *skb)
 		for (i = 0; i < resp->data_tx_completion.num_msdus; i++) {
 			msdu_id = resp->data_tx_completion.msdus[i];
 			tx_done.msdu_id = __le16_to_cpu(msdu_id);
-			ath10k_txrx_tx_completed(htt, &tx_done);
+			ath10k_txrx_tx_unref(htt, &tx_done);
 		}
 		break;
 	}
diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c b/drivers/net/wireless/ath/ath10k/htt_tx.c
index c4bbf74..06946d2 100644
--- a/drivers/net/wireless/ath/ath10k/htt_tx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
@@ -117,7 +117,7 @@ int ath10k_htt_tx_attach(struct ath10k_htt *htt)
 
 static void ath10k_htt_tx_cleanup_pending(struct ath10k_htt *htt)
 {
-	struct sk_buff *txdesc;
+	struct htt_tx_done tx_done = {0};
 	int msdu_id;
 
 	/* No locks needed. Called after communication with the device has
@@ -127,18 +127,13 @@ static void ath10k_htt_tx_cleanup_pending(struct ath10k_htt *htt)
 		if (!test_bit(msdu_id, htt->used_msdu_ids))
 			continue;
 
-		txdesc = htt->pending_tx[msdu_id];
-		if (!txdesc)
-			continue;
-
 		ath10k_dbg(ATH10K_DBG_HTT, "force cleanup msdu_id %hu\n",
 			   msdu_id);
 
-		if (ATH10K_SKB_CB(txdesc)->htt.refcount > 0)
-			ATH10K_SKB_CB(txdesc)->htt.refcount = 1;
+		tx_done.discard = 1;
+		tx_done.msdu_id = msdu_id;
 
-		ATH10K_SKB_CB(txdesc)->htt.discard = true;
-		ath10k_txrx_tx_unref(htt, txdesc);
+		ath10k_txrx_tx_unref(htt, &tx_done);
 	}
 }
 
@@ -152,26 +147,7 @@ void ath10k_htt_tx_detach(struct ath10k_htt *htt)
 
 void ath10k_htt_htc_tx_complete(struct ath10k *ar, struct sk_buff *skb)
 {
-	struct ath10k_skb_cb *skb_cb = ATH10K_SKB_CB(skb);
-	struct ath10k_htt *htt = &ar->htt;
-
-	if (skb_cb->htt.is_conf) {
-		dev_kfree_skb_any(skb);
-		return;
-	}
-
-	if (skb_cb->is_aborted) {
-		skb_cb->htt.discard = true;
-
-		/* if the skbuff is aborted we need to make sure we'll free up
-		 * the tx resources, we can't simply run tx_unref() 2 times
-		 * because if htt tx completion came in earlier we'd access
-		 * unallocated memory */
-		if (skb_cb->htt.refcount > 1)
-			skb_cb->htt.refcount = 1;
-	}
-
-	ath10k_txrx_tx_unref(htt, skb);
+	dev_kfree_skb_any(skb);
 }
 
 int ath10k_htt_h2t_ver_req_msg(struct ath10k_htt *htt)
@@ -192,8 +168,6 @@ int ath10k_htt_h2t_ver_req_msg(struct ath10k_htt *htt)
 	cmd = (struct htt_cmd *)skb->data;
 	cmd->hdr.msg_type = HTT_H2T_MSG_TYPE_VERSION_REQ;
 
-	ATH10K_SKB_CB(skb)->htt.is_conf = true;
-
 	ret = ath10k_htc_send(&htt->ar->htc, htt->eid, skb);
 	if (ret) {
 		dev_kfree_skb_any(skb);
@@ -233,8 +207,6 @@ int ath10k_htt_h2t_stats_req(struct ath10k_htt *htt, u8 mask, u64 cookie)
 	req->cookie_lsb = cpu_to_le32(cookie & 0xffffffff);
 	req->cookie_msb = cpu_to_le32((cookie & 0xffffffff00000000ULL) >> 32);
 
-	ATH10K_SKB_CB(skb)->htt.is_conf = true;
-
 	ret = ath10k_htc_send(&htt->ar->htc, htt->eid, skb);
 	if (ret) {
 		ath10k_warn("failed to send htt type stats request: %d", ret);
@@ -321,8 +293,6 @@ int ath10k_htt_send_rx_ring_cfg_ll(struct ath10k_htt *htt)
 
 #undef desc_offset
 
-	ATH10K_SKB_CB(skb)->htt.is_conf = true;
-
 	ret = ath10k_htc_send(&htt->ar->htc, htt->eid, skb);
 	if (ret) {
 		dev_kfree_skb_any(skb);
@@ -335,7 +305,6 @@ int ath10k_htt_send_rx_ring_cfg_ll(struct ath10k_htt *htt)
 int ath10k_htt_mgmt_tx(struct ath10k_htt *htt, struct sk_buff *msdu)
 {
 	struct device *dev = htt->ar->dev;
-	struct ath10k_skb_cb *skb_cb;
 	struct sk_buff *txdesc = NULL;
 	struct htt_cmd *cmd;
 	u8 vdev_id = ATH10K_SKB_CB(msdu)->htt.vdev_id;
@@ -364,7 +333,7 @@ int ath10k_htt_mgmt_tx(struct ath10k_htt *htt, struct sk_buff *msdu)
 		res = msdu_id;
 		goto err;
 	}
-	htt->pending_tx[msdu_id] = txdesc;
+	htt->pending_tx[msdu_id] = msdu;
 	spin_unlock_bh(&htt->tx_lock);
 
 	res = ath10k_skb_map(dev, msdu);
@@ -381,15 +350,6 @@ int ath10k_htt_mgmt_tx(struct ath10k_htt *htt, struct sk_buff *msdu)
 	memcpy(cmd->mgmt_tx.hdr, msdu->data,
 	       min_t(int, msdu->len, HTT_MGMT_FRM_HDR_DOWNLOAD_LEN));
 
-	/* refcount is decremented by HTC and HTT completions until it reaches
-	 * zero and is freed */
-	skb_cb = ATH10K_SKB_CB(txdesc);
-	skb_cb->htt.is_conf = false;
-	skb_cb->htt.msdu_id = msdu_id;
-	skb_cb->htt.refcount = 2;
-	skb_cb->htt.msdu = msdu;
-	skb_cb->htt.txfrag = NULL;
-
 	res = ath10k_htc_send(&htt->ar->htc, htt->eid, txdesc);
 	if (res)
 		goto err;
@@ -417,7 +377,6 @@ int ath10k_htt_tx(struct ath10k_htt *htt, struct sk_buff *msdu)
 	struct htt_cmd *cmd;
 	struct htt_data_tx_desc_frag *tx_frags;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)msdu->data;
-	struct ath10k_skb_cb *skb_cb;
 	struct sk_buff *txdesc = NULL;
 	struct sk_buff *txfrag = NULL;
 	u8 vdev_id = ATH10K_SKB_CB(msdu)->htt.vdev_id;
@@ -470,7 +429,7 @@ int ath10k_htt_tx(struct ath10k_htt *htt, struct sk_buff *msdu)
 		res = msdu_id;
 		goto err;
 	}
-	htt->pending_tx[msdu_id] = txdesc;
+	htt->pending_tx[msdu_id] = msdu;
 	spin_unlock_bh(&htt->tx_lock);
 
 	res = ath10k_skb_map(dev, msdu);
@@ -553,15 +512,6 @@ int ath10k_htt_tx(struct ath10k_htt *htt, struct sk_buff *msdu)
 
 	memcpy(cmd->data_tx.prefetch, msdu->data, prefetch_len);
 
-	/* refcount is decremented by HTC and HTT completions until it reaches
-	 * zero and is freed */
-	skb_cb = ATH10K_SKB_CB(txdesc);
-	skb_cb->htt.is_conf = false;
-	skb_cb->htt.msdu_id = msdu_id;
-	skb_cb->htt.refcount = 2;
-	skb_cb->htt.txfrag = txfrag;
-	skb_cb->htt.msdu = msdu;
-
 	res = ath10k_htc_send(&htt->ar->htc, htt->eid, txdesc);
 	if (res)
 		goto err;
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 0d367e4..9112e6d6f 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -1757,8 +1757,6 @@ static void ath10k_tx(struct ieee80211_hw *hw,
 		ath10k_tx_h_seq_no(skb);
 	}
 
-	ATH10K_SKB_CB(skb)->is_mapped = false;
-	ATH10K_SKB_CB(skb)->is_aborted = false;
 	ATH10K_SKB_CB(skb)->htt.is_offchan = false;
 	ATH10K_SKB_CB(skb)->htt.vdev_id = vdev_id;
 	ATH10K_SKB_CB(skb)->htt.tid = tid;
diff --git a/drivers/net/wireless/ath/ath10k/txrx.c b/drivers/net/wireless/ath/ath10k/txrx.c
index f6fed31..15395af 100644
--- a/drivers/net/wireless/ath/ath10k/txrx.c
+++ b/drivers/net/wireless/ath/ath10k/txrx.c
@@ -44,21 +44,25 @@ out:
 	spin_unlock_bh(&ar->data_lock);
 }
 
-void ath10k_txrx_tx_unref(struct ath10k_htt *htt, struct sk_buff *txdesc)
+void ath10k_txrx_tx_unref(struct ath10k_htt *htt,
+			  const struct htt_tx_done *tx_done)
 {
 	struct device *dev = htt->ar->dev;
 	struct ieee80211_tx_info *info;
-	struct sk_buff *txfrag = ATH10K_SKB_CB(txdesc)->htt.txfrag;
-	struct sk_buff *msdu = ATH10K_SKB_CB(txdesc)->htt.msdu;
+	struct sk_buff *msdu, *txfrag;
 	int ret;
 
-	if (ATH10K_SKB_CB(txdesc)->htt.refcount == 0)
-		return;
-
-	ATH10K_SKB_CB(txdesc)->htt.refcount--;
+	ath10k_dbg(ATH10K_DBG_HTT, "htt tx completion msdu_id %u discard %d no_ack %d\n",
+		   tx_done->msdu_id, !!tx_done->discard, !!tx_done->no_ack);
 
-	if (ATH10K_SKB_CB(txdesc)->htt.refcount > 0)
+	if (tx_done->msdu_id >= htt->max_num_pending_tx) {
+		ath10k_warn("warning: msdu_id %d too big, ignoring\n",
+			    tx_done->msdu_id);
 		return;
+	}
+
+	msdu = htt->pending_tx[tx_done->msdu_id];
+	txfrag = ATH10K_SKB_CB(msdu)->htt.txfrag;
 
 	if (txfrag) {
 		ret = ath10k_skb_unmap(dev, txfrag);
@@ -76,7 +80,7 @@ void ath10k_txrx_tx_unref(struct ath10k_htt *htt, struct sk_buff *txdesc)
 
 	info = IEEE80211_SKB_CB(msdu);
 
-	if (ATH10K_SKB_CB(txdesc)->htt.discard) {
+	if (tx_done->discard) {
 		ieee80211_free_txskb(htt->ar->hw, msdu);
 		goto exit;
 	}
@@ -84,7 +88,7 @@ void ath10k_txrx_tx_unref(struct ath10k_htt *htt, struct sk_buff *txdesc)
 	if (!(info->flags & IEEE80211_TX_CTL_NO_ACK))
 		info->flags |= IEEE80211_TX_STAT_ACK;
 
-	if (ATH10K_SKB_CB(txdesc)->htt.no_ack)
+	if (tx_done->no_ack)
 		info->flags &= ~IEEE80211_TX_STAT_ACK;
 
 	ieee80211_tx_status(htt->ar->hw, msdu);
@@ -92,36 +96,12 @@ void ath10k_txrx_tx_unref(struct ath10k_htt *htt, struct sk_buff *txdesc)
 
 exit:
 	spin_lock_bh(&htt->tx_lock);
-	htt->pending_tx[ATH10K_SKB_CB(txdesc)->htt.msdu_id] = NULL;
-	ath10k_htt_tx_free_msdu_id(htt, ATH10K_SKB_CB(txdesc)->htt.msdu_id);
+	htt->pending_tx[tx_done->msdu_id] = NULL;
+	ath10k_htt_tx_free_msdu_id(htt, tx_done->msdu_id);
 	__ath10k_htt_tx_dec_pending(htt);
 	if (htt->num_pending_tx == 0)
 		wake_up(&htt->empty_tx_wq);
 	spin_unlock_bh(&htt->tx_lock);
-
-	dev_kfree_skb_any(txdesc);
-}
-
-void ath10k_txrx_tx_completed(struct ath10k_htt *htt,
-			      const struct htt_tx_done *tx_done)
-{
-	struct sk_buff *txdesc;
-
-	ath10k_dbg(ATH10K_DBG_HTT, "htt tx completion msdu_id %u discard %d no_ack %d\n",
-		   tx_done->msdu_id, !!tx_done->discard, !!tx_done->no_ack);
-
-	if (tx_done->msdu_id >= htt->max_num_pending_tx) {
-		ath10k_warn("warning: msdu_id %d too big, ignoring\n",
-			    tx_done->msdu_id);
-		return;
-	}
-
-	txdesc = htt->pending_tx[tx_done->msdu_id];
-
-	ATH10K_SKB_CB(txdesc)->htt.discard = tx_done->discard;
-	ATH10K_SKB_CB(txdesc)->htt.no_ack = tx_done->no_ack;
-
-	ath10k_txrx_tx_unref(htt, txdesc);
 }
 
 static const u8 rx_legacy_rate_idx[] = {
diff --git a/drivers/net/wireless/ath/ath10k/txrx.h b/drivers/net/wireless/ath/ath10k/txrx.h
index e78632a..356dc9c 100644
--- a/drivers/net/wireless/ath/ath10k/txrx.h
+++ b/drivers/net/wireless/ath/ath10k/txrx.h
@@ -19,9 +19,8 @@
 
 #include "htt.h"
 
-void ath10k_txrx_tx_unref(struct ath10k_htt *htt, struct sk_buff *txdesc);
-void ath10k_txrx_tx_completed(struct ath10k_htt *htt,
-			      const struct htt_tx_done *tx_done);
+void ath10k_txrx_tx_unref(struct ath10k_htt *htt,
+			  const struct htt_tx_done *tx_done);
 void ath10k_process_rx(struct ath10k *ar, struct htt_rx_info *info);
 
 struct ath10k_peer *ath10k_peer_find(struct ath10k *ar, int vdev_id,
-- 
1.7.9.5

