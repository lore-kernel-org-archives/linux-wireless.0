Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f53.google.com ([74.125.82.53]:39130 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754486AbbAPLRx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jan 2015 06:17:53 -0500
Received: by mail-wg0-f53.google.com with SMTP id x13so19918446wgg.12
        for <linux-wireless@vger.kernel.org>; Fri, 16 Jan 2015 03:17:52 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 2/2] ath10k: implement rx reorder support
Date: Fri, 16 Jan 2015 12:17:09 +0100
Message-Id: <1421407029-23967-2-git-send-email-michal.kazior@tieto.com> (sfid-20150116_121758_402222_BA0C56EB)
In-Reply-To: <1421407029-23967-1-git-send-email-michal.kazior@tieto.com>
References: <1421407029-23967-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

New firmware and firmware (qca6174 hw3.0+ and fw
266+) are capable of full aggregation rx
reordering. If it's enabled then Rx is handled via
a new, separate htt event.

The rx ring behaviour is changed a little to
support the new rx scheme. These changes shouldn't
affect qca988x performance.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.c    |  12 +
 drivers/net/wireless/ath/ath10k/core.h    |   4 +
 drivers/net/wireless/ath/ath10k/htt.h     |  79 ++++++
 drivers/net/wireless/ath/ath10k/htt_rx.c  | 393 +++++++++++++++++++++++++++---
 drivers/net/wireless/ath/ath10k/wmi-tlv.c |  11 +-
 5 files changed, 463 insertions(+), 36 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index a546575..6860afb 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -1061,6 +1061,18 @@ int ath10k_core_start(struct ath10k *ar, enum ath10k_firmware_mode mode)
 		goto err_hif_stop;
 	}
 
+	/* If firmware indicates Full Rx Reorder support it must be used in a
+	 * slightly different manner. Let HTT code know.
+	 */
+	ar->htt.rx_ring.in_ord_rx = !!(test_bit(WMI_SERVICE_RX_FULL_REORDER,
+						ar->wmi.svc_map));
+
+	status = ath10k_htt_rx_ring_refill(ar);
+	if (status) {
+		ath10k_err(ar, "failed to refill htt rx ring: %d\n", status);
+		goto err_hif_stop;
+	}
+
 	/* we don't care about HTT in UTF mode */
 	if (mode == ATH10K_FIRMWARE_MODE_NORMAL) {
 		status = ath10k_htt_setup(&ar->htt);
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 739d9d69..774d8ce 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -99,6 +99,7 @@ struct ath10k_skb_cb {
 
 struct ath10k_skb_rxcb {
 	dma_addr_t paddr;
+	struct hlist_node hlist;
 };
 
 static inline struct ath10k_skb_cb *ATH10K_SKB_CB(struct sk_buff *skb)
@@ -114,6 +115,9 @@ static inline struct ath10k_skb_rxcb *ATH10K_SKB_RXCB(struct sk_buff *skb)
 	return (struct ath10k_skb_rxcb *)skb->cb;
 }
 
+#define ATH10K_RXCB_SKB(rxcb) \
+		container_of((void *)rxcb, struct sk_buff, cb)
+
 static inline u32 host_interest_item_address(u32 item_offset)
 {
 	return QCA988X_HOST_INTEREST_ADDRESS + item_offset;
diff --git a/drivers/net/wireless/ath/ath10k/htt.h b/drivers/net/wireless/ath/ath10k/htt.h
index 8809b37..d1f6eb2 100644
--- a/drivers/net/wireless/ath/ath10k/htt.h
+++ b/drivers/net/wireless/ath/ath10k/htt.h
@@ -21,6 +21,7 @@
 #include <linux/bug.h>
 #include <linux/interrupt.h>
 #include <linux/dmapool.h>
+#include <linux/hashtable.h>
 #include <net/mac80211.h>
 
 #include "htc.h"
@@ -286,7 +287,19 @@ enum htt_t2h_msg_type {
 	HTT_T2H_MSG_TYPE_RC_UPDATE_IND		= 0xc,
 	HTT_T2H_MSG_TYPE_TX_INSPECT_IND		= 0xd,
 	HTT_T2H_MSG_TYPE_MGMT_TX_COMPLETION	= 0xe,
+	HTT_T2H_MSG_TYPE_TX_CREDIT_UPDATE_IND	= 0xf,
+	HTT_T2H_MSG_TYPE_RX_PN_IND		= 0x10,
+	HTT_T2H_MSG_TYPE_RX_OFFLOAD_DELIVER_IND = 0x11,
+	HTT_T2H_MSG_TYPE_RX_IN_ORD_PADDR_IND	= 0x12,
+	/* 0x13 reservd */
+	HTT_T2H_MSG_TYPE_WDI_IPA_OP_RESPONSE	= 0x14,
+
+	/* FIXME: Do not depend on this event id. Numbering of this event id is
+	 * broken across different firmware revisions and HTT version fails to
+	 * indicate this.
+	 */
 	HTT_T2H_MSG_TYPE_TEST,
+
 	/* keep this last */
 	HTT_T2H_NUM_MSGS
 };
@@ -655,6 +668,53 @@ struct htt_rx_fragment_indication {
 #define HTT_RX_FRAG_IND_INFO1_FLUSH_SEQ_NUM_END_MASK   0x00000FC0
 #define HTT_RX_FRAG_IND_INFO1_FLUSH_SEQ_NUM_END_LSB    6
 
+struct htt_rx_pn_ind {
+	__le16 peer_id;
+	u8 tid;
+	u8 seqno_start;
+	u8 seqno_end;
+	u8 pn_ie_count;
+	u8 reserved;
+	u8 pn_ies[0];
+} __packed;
+
+struct htt_rx_offload_msdu {
+	__le16 msdu_len;
+	__le16 peer_id;
+	u8 vdev_id;
+	u8 tid;
+	u8 fw_desc;
+	u8 payload[0];
+} __packed;
+
+struct htt_rx_offload_ind {
+	u8 reserved;
+	__le16 msdu_count;
+} __packed;
+
+struct htt_rx_in_ord_msdu_desc {
+	__le32 msdu_paddr;
+	__le16 msdu_len;
+	u8 fw_desc;
+	u8 reserved;
+} __packed;
+
+struct htt_rx_in_ord_ind {
+	u8 info;
+	__le16 peer_id;
+	u8 vdev_id;
+	u8 reserved;
+	__le16 msdu_count;
+	struct htt_rx_in_ord_msdu_desc msdu_descs[0];
+} __packed;
+
+#define HTT_RX_IN_ORD_IND_INFO_TID_MASK		0x0000001f
+#define HTT_RX_IN_ORD_IND_INFO_TID_LSB		0
+#define HTT_RX_IN_ORD_IND_INFO_OFFLOAD_MASK	0x00000020
+#define HTT_RX_IN_ORD_IND_INFO_OFFLOAD_LSB	5
+#define HTT_RX_IN_ORD_IND_INFO_FRAG_MASK	0x00000040
+#define HTT_RX_IN_ORD_IND_INFO_FRAG_LSB		6
+
 /*
  * target -> host test message definition
  *
@@ -1150,6 +1210,9 @@ struct htt_resp {
 		struct htt_rx_test rx_test;
 		struct htt_pktlog_msg pktlog_msg;
 		struct htt_stats_conf stats_conf;
+		struct htt_rx_pn_ind rx_pn_ind;
+		struct htt_rx_offload_ind rx_offload_ind;
+		struct htt_rx_in_ord_ind rx_in_ord_ind;
 	};
 } __packed;
 
@@ -1197,6 +1260,20 @@ struct ath10k_htt {
 		 * filled.
 		 */
 		struct sk_buff **netbufs_ring;
+
+		/* This is used only with firmware supporting IN_ORD_IND.
+		 *
+		 * With Full Rx Reorder the HTT Rx Ring is more of a temporary
+		 * buffer ring from which buffer addresses are copied by the
+		 * firmware to MAC Rx ring. Firmware then delivers IN_ORD_IND
+		 * pointing to specific (re-ordered) buffers.
+		 *
+		 * FIXME: With kernel generic hashing functions there's a lot
+		 * of hash collisions for sk_buffs.
+		 */
+		bool in_ord_rx;
+		DECLARE_HASHTABLE(skb_table, 4);
+
 		/*
 		 * Ring of buffer addresses -
 		 * This ring holds the "physical" device address of the
@@ -1270,6 +1347,7 @@ struct ath10k_htt {
 	struct tasklet_struct txrx_compl_task;
 	struct sk_buff_head tx_compl_q;
 	struct sk_buff_head rx_compl_q;
+	struct sk_buff_head rx_in_ord_compl_q;
 
 	/* rx_status template */
 	struct ieee80211_rx_status rx_status;
@@ -1333,6 +1411,7 @@ int ath10k_htt_tx_alloc(struct ath10k_htt *htt);
 void ath10k_htt_tx_free(struct ath10k_htt *htt);
 
 int ath10k_htt_rx_alloc(struct ath10k_htt *htt);
+int ath10k_htt_rx_ring_refill(struct ath10k *ar);
 void ath10k_htt_rx_free(struct ath10k_htt *htt);
 
 void ath10k_htt_htc_tx_complete(struct ath10k *ar, struct sk_buff *skb);
diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 2e55ed7..661785f 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -25,8 +25,8 @@
 
 #include <linux/log2.h>
 
-#define HTT_RX_RING_SIZE 1024
-#define HTT_RX_RING_FILL_LEVEL 1000
+#define HTT_RX_RING_SIZE HTT_RX_RING_SIZE_MAX
+#define HTT_RX_RING_FILL_LEVEL (((HTT_RX_RING_SIZE) / 2) - 1)
 
 /* when under memory pressure rx ring refill may fail and needs a retry */
 #define HTT_RX_RING_REFILL_RETRY_MS 50
@@ -34,31 +34,70 @@
 static int ath10k_htt_rx_get_csum_state(struct sk_buff *skb);
 static void ath10k_htt_txrx_compl_task(unsigned long ptr);
 
+static struct sk_buff *
+ath10k_htt_rx_find_skb_paddr(struct ath10k *ar, u32 paddr)
+{
+	struct ath10k_skb_rxcb *rxcb;
+
+	hash_for_each_possible(ar->htt.rx_ring.skb_table, rxcb, hlist, paddr)
+		if (rxcb->paddr == paddr)
+			return ATH10K_RXCB_SKB(rxcb);
+
+	WARN_ON_ONCE(1);
+	return NULL;
+}
+
 static void ath10k_htt_rx_ring_free(struct ath10k_htt *htt)
 {
 	struct sk_buff *skb;
-	struct ath10k_skb_rxcb *cb;
+	struct ath10k_skb_rxcb *rxcb;
+	struct hlist_node *n;
 	int i;
 
-	for (i = 0; i < htt->rx_ring.fill_cnt; i++) {
-		skb = htt->rx_ring.netbufs_ring[i];
-		cb = ATH10K_SKB_RXCB(skb);
-		dma_unmap_single(htt->ar->dev, cb->paddr,
-				 skb->len + skb_tailroom(skb),
-				 DMA_FROM_DEVICE);
-		dev_kfree_skb_any(skb);
+	if (htt->rx_ring.in_ord_rx) {
+		hash_for_each_safe(htt->rx_ring.skb_table, i, n, rxcb, hlist) {
+			skb = ATH10K_RXCB_SKB(rxcb);
+			dma_unmap_single(htt->ar->dev, rxcb->paddr,
+					 skb->len + skb_tailroom(skb),
+					 DMA_FROM_DEVICE);
+			hash_del(&rxcb->hlist);
+			dev_kfree_skb_any(skb);
+		}
+	} else {
+		for (i = 0; i < htt->rx_ring.size; i++) {
+			skb = htt->rx_ring.netbufs_ring[i];
+			if (!skb)
+				continue;
+
+			rxcb = ATH10K_SKB_RXCB(skb);
+			dma_unmap_single(htt->ar->dev, rxcb->paddr,
+					 skb->len + skb_tailroom(skb),
+					 DMA_FROM_DEVICE);
+			dev_kfree_skb_any(skb);
+		}
 	}
 
 	htt->rx_ring.fill_cnt = 0;
+	hash_init(htt->rx_ring.skb_table);
+	memset(htt->rx_ring.netbufs_ring, 0,
+	       htt->rx_ring.size * sizeof(htt->rx_ring.netbufs_ring[0]));
 }
 
 static int __ath10k_htt_rx_ring_fill_n(struct ath10k_htt *htt, int num)
 {
 	struct htt_rx_desc *rx_desc;
+	struct ath10k_skb_rxcb *rxcb;
 	struct sk_buff *skb;
 	dma_addr_t paddr;
 	int ret = 0, idx;
 
+	/* The Full Rx Reorder firmware has no way of telling the host
+	 * implicitly when it copied HTT Rx Ring buffers to MAC Rx Ring.
+	 * To keep things simple make sure ring is always half empty. This
+	 * guarantees there'll be no replenishment overruns possible.
+	 */
+	BUILD_BUG_ON(HTT_RX_RING_FILL_LEVEL >= HTT_RX_RING_SIZE / 2);
+
 	idx = __le32_to_cpu(*htt->rx_ring.alloc_idx.vaddr);
 	while (num > 0) {
 		skb = dev_alloc_skb(HTT_RX_BUF_SIZE + HTT_RX_DESC_ALIGN);
@@ -86,11 +125,18 @@ static int __ath10k_htt_rx_ring_fill_n(struct ath10k_htt *htt, int num)
 			goto fail;
 		}
 
-		ATH10K_SKB_RXCB(skb)->paddr = paddr;
+		rxcb = ATH10K_SKB_RXCB(skb);
+		rxcb->paddr = paddr;
 		htt->rx_ring.netbufs_ring[idx] = skb;
 		htt->rx_ring.paddrs_ring[idx] = __cpu_to_le32(paddr);
 		htt->rx_ring.fill_cnt++;
 
+		if (htt->rx_ring.in_ord_rx) {
+			hash_add(htt->rx_ring.skb_table,
+				 &ATH10K_SKB_RXCB(skb)->hlist,
+				 (u32)paddr);
+		}
+
 		num--;
 		idx++;
 		idx &= htt->rx_ring.size_mask;
@@ -158,22 +204,20 @@ static void ath10k_htt_rx_ring_refill_retry(unsigned long arg)
 	ath10k_htt_rx_msdu_buff_replenish(htt);
 }
 
-static void ath10k_htt_rx_ring_clean_up(struct ath10k_htt *htt)
+int ath10k_htt_rx_ring_refill(struct ath10k *ar)
 {
-	struct sk_buff *skb;
-	int i;
+	struct ath10k_htt *htt = &ar->htt;
+	int ret;
 
-	for (i = 0; i < htt->rx_ring.size; i++) {
-		skb = htt->rx_ring.netbufs_ring[i];
-		if (!skb)
-			continue;
+	spin_lock_bh(&htt->rx_ring.lock);
+	ret = ath10k_htt_rx_ring_fill_n(htt, (htt->rx_ring.fill_level -
+					      htt->rx_ring.fill_cnt));
+	spin_unlock_bh(&htt->rx_ring.lock);
 
-		dma_unmap_single(htt->ar->dev, ATH10K_SKB_RXCB(skb)->paddr,
-				 skb->len + skb_tailroom(skb),
-				 DMA_FROM_DEVICE);
-		dev_kfree_skb_any(skb);
-		htt->rx_ring.netbufs_ring[i] = NULL;
-	}
+	if (ret)
+		ath10k_htt_rx_ring_free(htt);
+
+	return ret;
 }
 
 void ath10k_htt_rx_free(struct ath10k_htt *htt)
@@ -184,8 +228,9 @@ void ath10k_htt_rx_free(struct ath10k_htt *htt)
 
 	skb_queue_purge(&htt->tx_compl_q);
 	skb_queue_purge(&htt->rx_compl_q);
+	skb_queue_purge(&htt->rx_in_ord_compl_q);
 
-	ath10k_htt_rx_ring_clean_up(htt);
+	ath10k_htt_rx_ring_free(htt);
 
 	dma_free_coherent(htt->ar->dev,
 			  (htt->rx_ring.size *
@@ -217,6 +262,7 @@ static inline struct sk_buff *ath10k_htt_rx_netbuf_pop(struct ath10k_htt *htt)
 	idx = htt->rx_ring.sw_rd_idx.msdu_payld;
 	msdu = htt->rx_ring.netbufs_ring[idx];
 	htt->rx_ring.netbufs_ring[idx] = NULL;
+	htt->rx_ring.paddrs_ring[idx] = 0;
 
 	idx++;
 	idx &= htt->rx_ring.size_mask;
@@ -384,6 +430,82 @@ static void ath10k_htt_rx_replenish_task(unsigned long ptr)
 	ath10k_htt_rx_msdu_buff_replenish(htt);
 }
 
+static struct sk_buff *ath10k_htt_rx_pop_paddr(struct ath10k_htt *htt,
+					       u32 paddr)
+{
+	struct ath10k *ar = htt->ar;
+	struct ath10k_skb_rxcb *rxcb;
+	struct sk_buff *msdu;
+
+	lockdep_assert_held(&htt->rx_ring.lock);
+
+	msdu = ath10k_htt_rx_find_skb_paddr(ar, paddr);
+	if (!msdu)
+		return NULL;
+
+	rxcb = ATH10K_SKB_RXCB(msdu);
+	hash_del(&rxcb->hlist);
+	htt->rx_ring.fill_cnt--;
+
+	dma_unmap_single(htt->ar->dev, rxcb->paddr,
+			 msdu->len + skb_tailroom(msdu),
+			 DMA_FROM_DEVICE);
+	ath10k_dbg_dump(ar, ATH10K_DBG_HTT_DUMP, NULL, "htt rx netbuf pop: ",
+			msdu->data, msdu->len + skb_tailroom(msdu));
+
+	return msdu;
+}
+
+static int ath10k_htt_rx_pop_paddr_list(struct ath10k_htt *htt,
+					struct htt_rx_in_ord_ind *ev,
+					struct sk_buff_head *list)
+{
+	struct ath10k *ar = htt->ar;
+	struct htt_rx_in_ord_msdu_desc *msdu_desc = ev->msdu_descs;
+	struct htt_rx_desc *rxd;
+	struct sk_buff *msdu;
+	int msdu_count;
+	bool is_offload;
+	u32 paddr;
+
+	lockdep_assert_held(&htt->rx_ring.lock);
+
+	msdu_count = __le16_to_cpu(ev->msdu_count);
+	is_offload = !!(ev->info & HTT_RX_IN_ORD_IND_INFO_OFFLOAD_MASK);
+
+	while (msdu_count--) {
+		paddr = __le32_to_cpu(msdu_desc->msdu_paddr);
+
+		msdu = ath10k_htt_rx_pop_paddr(htt, paddr);
+		if (!msdu) {
+			__skb_queue_purge(list);
+			return -ENOENT;
+		}
+
+		__skb_queue_tail(list, msdu);
+
+		if (!is_offload) {
+			rxd = (void *)msdu->data;
+
+			trace_ath10k_htt_rx_desc(ar, rxd, sizeof(*rxd));
+
+			skb_put(msdu, sizeof(*rxd));
+			skb_pull(msdu, sizeof(*rxd));
+			skb_put(msdu, __le16_to_cpu(msdu_desc->msdu_len));
+
+			if (!(__le32_to_cpu(rxd->attention.flags) &
+			      RX_ATTENTION_FLAGS_MSDU_DONE)) {
+				ath10k_warn(htt->ar, "tried to pop an incomplete frame, oops!\n");
+				return -EIO;
+			}
+		}
+
+		msdu_desc++;
+	}
+
+	return 0;
+}
+
 int ath10k_htt_rx_alloc(struct ath10k_htt *htt)
 {
 	struct ath10k *ar = htt->ar;
@@ -429,7 +551,7 @@ int ath10k_htt_rx_alloc(struct ath10k_htt *htt)
 
 	htt->rx_ring.alloc_idx.vaddr = vaddr;
 	htt->rx_ring.alloc_idx.paddr = paddr;
-	htt->rx_ring.sw_rd_idx.msdu_payld = 0;
+	htt->rx_ring.sw_rd_idx.msdu_payld = htt->rx_ring.size_mask;
 	*htt->rx_ring.alloc_idx.vaddr = 0;
 
 	/* Initialize the Rx refill retry timer */
@@ -438,14 +560,15 @@ int ath10k_htt_rx_alloc(struct ath10k_htt *htt)
 	spin_lock_init(&htt->rx_ring.lock);
 
 	htt->rx_ring.fill_cnt = 0;
-	if (__ath10k_htt_rx_ring_fill_n(htt, htt->rx_ring.fill_level))
-		goto err_fill_ring;
+	htt->rx_ring.sw_rd_idx.msdu_payld = 0;
+	hash_init(htt->rx_ring.skb_table);
 
 	tasklet_init(&htt->rx_replenish_task, ath10k_htt_rx_replenish_task,
 		     (unsigned long)htt);
 
 	skb_queue_head_init(&htt->tx_compl_q);
 	skb_queue_head_init(&htt->rx_compl_q);
+	skb_queue_head_init(&htt->rx_in_ord_compl_q);
 
 	tasklet_init(&htt->txrx_compl_task, ath10k_htt_txrx_compl_task,
 		     (unsigned long)htt);
@@ -454,12 +577,6 @@ int ath10k_htt_rx_alloc(struct ath10k_htt *htt)
 		   htt->rx_ring.size, htt->rx_ring.fill_level);
 	return 0;
 
-err_fill_ring:
-	ath10k_htt_rx_ring_free(htt);
-	dma_free_coherent(htt->ar->dev,
-			  sizeof(*htt->rx_ring.alloc_idx.vaddr),
-			  htt->rx_ring.alloc_idx.vaddr,
-			  htt->rx_ring.alloc_idx.paddr);
 err_dma_idx:
 	dma_free_coherent(htt->ar->dev,
 			  (htt->rx_ring.size *
@@ -1583,6 +1700,194 @@ static void ath10k_htt_rx_delba(struct ath10k *ar, struct htt_resp *resp)
 	spin_unlock_bh(&ar->data_lock);
 }
 
+static int ath10k_htt_rx_extract_amsdu(struct sk_buff_head *list,
+				       struct sk_buff_head *amsdu)
+{
+	struct sk_buff *msdu;
+	struct htt_rx_desc *rxd;
+
+	if (skb_queue_empty(list))
+		return -ENOBUFS;
+
+	if (WARN_ON(!skb_queue_empty(amsdu)))
+		return -EINVAL;
+
+	while ((msdu = __skb_dequeue(list))) {
+		__skb_queue_tail(amsdu, msdu);
+
+		rxd = (void *)msdu->data - sizeof(*rxd);
+		if (rxd->msdu_end.info0 &
+		    __cpu_to_le32(RX_MSDU_END_INFO0_LAST_MSDU))
+			break;
+	}
+
+	msdu = skb_peek_tail(amsdu);
+	rxd = (void *)msdu->data - sizeof(*rxd);
+	if (!(rxd->msdu_end.info0 &
+	      __cpu_to_le32(RX_MSDU_END_INFO0_LAST_MSDU))) {
+		skb_queue_splice_init(amsdu, list);
+		return -EAGAIN;
+	}
+
+	return 0;
+}
+
+static void ath10k_htt_rx_h_rx_offload_prot(struct ieee80211_rx_status *status,
+					    struct sk_buff *skb)
+{
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+
+	if (!ieee80211_has_protected(hdr->frame_control))
+		return;
+
+	/* Offloaded frames are already decrypted but firmware insists they are
+	 * protected in the 802.11 header. Strip the flag.  Otherwise mac80211
+	 * will drop the frame.
+	 */
+
+	hdr->frame_control &= ~__cpu_to_le16(IEEE80211_FCTL_PROTECTED);
+	status->flag |= RX_FLAG_DECRYPTED |
+			RX_FLAG_IV_STRIPPED |
+			RX_FLAG_MMIC_STRIPPED;
+}
+
+static void ath10k_htt_rx_h_rx_offload(struct ath10k *ar,
+				       struct sk_buff_head *list)
+{
+	struct ath10k_htt *htt = &ar->htt;
+	struct ieee80211_rx_status *status = &htt->rx_status;
+	struct htt_rx_offload_msdu *rx;
+	struct sk_buff *msdu;
+	size_t offset;
+
+	while ((msdu = __skb_dequeue(list))) {
+		/* Offloaded frames don't have Rx descriptor. Instead they have
+		 * a short meta information header.
+		 */
+
+		rx = (void *)msdu->data;
+
+		skb_put(msdu, sizeof(*rx));
+		skb_pull(msdu, sizeof(*rx));
+
+		if (skb_tailroom(msdu) < __le16_to_cpu(rx->msdu_len)) {
+			ath10k_warn(ar, "dropping frame: offloaded rx msdu is too long!\n");
+			dev_kfree_skb_any(msdu);
+			continue;
+		}
+
+		skb_put(msdu, __le16_to_cpu(rx->msdu_len));
+
+		/* Offloaded rx header length isn't multiple of 2 nor 4 so the
+		 * actual payload is unaligned. Align the frame.  Otherwise
+		 * mac80211 complains.  This shouldn't reduce performance much
+		 * because these offloaded frames are rare.
+		 */
+		offset = 4 - ((unsigned long)msdu->data & 3);
+		skb_put(msdu, offset);
+		memmove(msdu->data + offset, msdu->data, msdu->len);
+		skb_pull(msdu, offset);
+
+		/* FIXME: The frame is NWifi. Re-construct QoS Control
+		 * if possible later.
+		 */
+
+		memset(status, 0, sizeof(*status));
+		status->flag |= RX_FLAG_NO_SIGNAL_VAL;
+
+		ath10k_htt_rx_h_rx_offload_prot(status, msdu);
+		ath10k_htt_rx_h_channel(ar, status);
+		ath10k_process_rx(ar, status, msdu);
+	}
+}
+
+static void ath10k_htt_rx_in_ord_ind(struct ath10k *ar, struct sk_buff *skb)
+{
+	struct ath10k_htt *htt = &ar->htt;
+	struct htt_resp *resp = (void *)skb->data;
+	struct ieee80211_rx_status *status = &htt->rx_status;
+	struct sk_buff_head list;
+	struct sk_buff_head amsdu;
+	u16 peer_id;
+	u16 msdu_count;
+	u8 vdev_id;
+	u8 tid;
+	bool offload;
+	bool frag;
+	int ret;
+
+	lockdep_assert_held(&htt->rx_ring.lock);
+
+	if (htt->rx_confused)
+		return;
+
+	skb_pull(skb, sizeof(resp->hdr));
+	skb_pull(skb, sizeof(resp->rx_in_ord_ind));
+
+	peer_id = __le16_to_cpu(resp->rx_in_ord_ind.peer_id);
+	msdu_count = __le16_to_cpu(resp->rx_in_ord_ind.msdu_count);
+	vdev_id = resp->rx_in_ord_ind.vdev_id;
+	tid = SM(resp->rx_in_ord_ind.info, HTT_RX_IN_ORD_IND_INFO_TID);
+	offload = !!(resp->rx_in_ord_ind.info &
+			HTT_RX_IN_ORD_IND_INFO_OFFLOAD_MASK);
+	frag = !!(resp->rx_in_ord_ind.info & HTT_RX_IN_ORD_IND_INFO_FRAG_MASK);
+
+	ath10k_dbg(ar, ATH10K_DBG_HTT,
+		   "htt rx in ord vdev %i peer %i tid %i offload %i frag %i msdu count %i\n",
+		   vdev_id, peer_id, tid, offload, frag, msdu_count);
+
+	if (skb->len < msdu_count * sizeof(*resp->rx_in_ord_ind.msdu_descs)) {
+		ath10k_warn(ar, "dropping invalid in order rx indication\n");
+		return;
+	}
+
+	/* The event can deliver more than 1 A-MSDU. Each A-MSDU is later
+	 * extracted and processed.
+	 */
+	__skb_queue_head_init(&list);
+	ret = ath10k_htt_rx_pop_paddr_list(htt, &resp->rx_in_ord_ind, &list);
+	if (ret < 0) {
+		ath10k_warn(ar, "failed to pop paddr list: %d\n", ret);
+		htt->rx_confused = true;
+		return;
+	}
+
+	/* Offloaded frames are very different and need to be handled
+	 * separately.
+	 */
+	if (offload)
+		ath10k_htt_rx_h_rx_offload(ar, &list);
+
+	while (!skb_queue_empty(&list)) {
+		__skb_queue_head_init(&amsdu);
+		ret = ath10k_htt_rx_extract_amsdu(&list, &amsdu);
+		switch (ret) {
+		case 0:
+			/* Note: The in-order indication may report interleaved
+			 * frames from different PPDUs meaning reported rx rate
+			 * to mac80211 isn't accurate/reliable. It's still
+			 * better to report something than nothing though. This
+			 * should still give an idea about rx rate to the user.
+			 */
+			ath10k_htt_rx_h_ppdu(ar, &amsdu, status);
+			ath10k_htt_rx_h_filter(ar, &amsdu, status);
+			ath10k_htt_rx_h_mpdu(ar, &amsdu, status);
+			ath10k_htt_rx_h_deliver(ar, &amsdu, status);
+			break;
+		case -EAGAIN:
+			/* fall through */
+		default:
+			/* Should not happen. */
+			ath10k_warn(ar, "failed to extract amsdu: %d\n", ret);
+			htt->rx_confused = true;
+			__skb_queue_purge(&list);
+			return;
+		}
+	}
+
+	tasklet_schedule(&htt->rx_replenish_task);
+}
+
 void ath10k_htt_t2h_msg_handler(struct ath10k *ar, struct sk_buff *skb)
 {
 	struct ath10k_htt *htt = &ar->htt;
@@ -1705,6 +2010,20 @@ void ath10k_htt_t2h_msg_handler(struct ath10k *ar, struct sk_buff *skb)
 		 */
 		break;
 	}
+	case HTT_T2H_MSG_TYPE_RX_IN_ORD_PADDR_IND: {
+		spin_lock_bh(&htt->rx_ring.lock);
+		__skb_queue_tail(&htt->rx_in_ord_compl_q, skb);
+		spin_unlock_bh(&htt->rx_ring.lock);
+		tasklet_schedule(&htt->txrx_compl_task);
+		return;
+	}
+	case HTT_T2H_MSG_TYPE_TX_CREDIT_UPDATE_IND:
+		/* FIXME: This WMI-TLV event is overlapping with 10.2
+		 * CHAN_CHANGE - both being 0xF. Neither is being used in
+		 * practice so no immediate action is necessary. Nevertheless
+		 * HTT may need an abstraction layer like WMI has one day.
+		 */
+		break;
 	default:
 		ath10k_warn(ar, "htt event (%d) not handled\n",
 			    resp->hdr.msg_type);
@@ -1720,6 +2039,7 @@ void ath10k_htt_t2h_msg_handler(struct ath10k *ar, struct sk_buff *skb)
 static void ath10k_htt_txrx_compl_task(unsigned long ptr)
 {
 	struct ath10k_htt *htt = (struct ath10k_htt *)ptr;
+	struct ath10k *ar = htt->ar;
 	struct htt_resp *resp;
 	struct sk_buff *skb;
 
@@ -1736,5 +2056,10 @@ static void ath10k_htt_txrx_compl_task(unsigned long ptr)
 		ath10k_htt_rx_handler(htt, &resp->rx_ind);
 		dev_kfree_skb_any(skb);
 	}
+
+	while ((skb = __skb_dequeue(&htt->rx_in_ord_compl_q))) {
+		ath10k_htt_rx_in_ord_ind(ar, skb);
+		dev_kfree_skb_any(skb);
+	}
 	spin_unlock_bh(&htt->rx_ring.lock);
 }
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index 6f34fc7..9f54876 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -953,8 +953,15 @@ static struct sk_buff *ath10k_wmi_tlv_op_gen_init(struct ath10k *ar)
 
 	cfg->num_vdevs = __cpu_to_le32(TARGET_TLV_NUM_VDEVS);
 	cfg->num_peers = __cpu_to_le32(TARGET_TLV_NUM_PEERS);
-	cfg->num_offload_peers = __cpu_to_le32(0);
-	cfg->num_offload_reorder_bufs = __cpu_to_le32(0);
+
+	if (test_bit(WMI_SERVICE_RX_FULL_REORDER, ar->wmi.svc_map)) {
+		cfg->num_offload_peers = __cpu_to_le32(3);
+		cfg->num_offload_reorder_bufs = __cpu_to_le32(3);
+	} else {
+		cfg->num_offload_peers = __cpu_to_le32(0);
+		cfg->num_offload_reorder_bufs = __cpu_to_le32(0);
+	}
+
 	cfg->num_peer_keys = __cpu_to_le32(2);
 	cfg->num_tids = __cpu_to_le32(TARGET_TLV_NUM_TIDS);
 	cfg->ast_skid_limit = __cpu_to_le32(0x10);
-- 
1.8.5.3

