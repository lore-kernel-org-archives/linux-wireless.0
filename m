Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:37113 "EHLO
        sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751403AbdLUJBu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Dec 2017 04:01:50 -0500
From: Govind Singh <govinds@qti.qualcomm.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Govind Singh <govinds@qti.qualcomm.com>
Subject: [PATCH 03/10] ath10k: Add support for 64 bit HTT in-order indication msg
Date: Thu, 21 Dec 2017 14:30:52 +0530
Message-Id: <1513846859-23639-4-git-send-email-govinds@qti.qualcomm.com> (sfid-20171221_100202_516622_2F461A7F)
In-Reply-To: <1513846859-23639-1-git-send-email-govinds@qti.qualcomm.com>
References: <1513846859-23639-1-git-send-email-govinds@qti.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

WCN3990 target use 64bit msdu address in htt in-order
indication message. Add support for 64 bit msdu address in
HTT_T2H_MSG_TYPE_RX_IN_ORD_PADDR_IND message.

Signed-off-by: Govind Singh <govinds@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/htt.h    | 12 +++++-
 drivers/net/wireless/ath/ath10k/htt_rx.c | 67 +++++++++++++++++++++++++++++---
 2 files changed, 72 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt.h b/drivers/net/wireless/ath/ath10k/htt.h
index 6305308..f3d5883 100644
--- a/drivers/net/wireless/ath/ath10k/htt.h
+++ b/drivers/net/wireless/ath/ath10k/htt.h
@@ -855,13 +855,23 @@ struct htt_rx_in_ord_msdu_desc {
 	u8 reserved;
 } __packed;
 
+struct htt_rx_in_ord_msdu_desc_ext {
+	__le64 msdu_paddr;
+	__le16 msdu_len;
+	u8 fw_desc;
+	u8 reserved;
+} __packed;
+
 struct htt_rx_in_ord_ind {
 	u8 info;
 	__le16 peer_id;
 	u8 vdev_id;
 	u8 reserved;
 	__le16 msdu_count;
-	struct htt_rx_in_ord_msdu_desc msdu_descs[0];
+	union {
+		struct htt_rx_in_ord_msdu_desc msdu_descs32[0];
+		struct htt_rx_in_ord_msdu_desc_ext msdu_descs64[0];
+	} __packed;
 } __packed;
 
 #define HTT_RX_IN_ORD_IND_INFO_TID_MASK		0x0000001f
diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 7d295ee..6402189 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -408,12 +408,12 @@ static struct sk_buff *ath10k_htt_rx_pop_paddr(struct ath10k_htt *htt,
 	return msdu;
 }
 
-static int ath10k_htt_rx_pop_paddr_list(struct ath10k_htt *htt,
-					struct htt_rx_in_ord_ind *ev,
-					struct sk_buff_head *list)
+static int ath10k_htt_rx_pop_paddr32_list(struct ath10k_htt *htt,
+					  struct htt_rx_in_ord_ind *ev,
+					  struct sk_buff_head *list)
 {
 	struct ath10k *ar = htt->ar;
-	struct htt_rx_in_ord_msdu_desc *msdu_desc = ev->msdu_descs;
+	struct htt_rx_in_ord_msdu_desc *msdu_desc = ev->msdu_descs32;
 	struct htt_rx_desc *rxd;
 	struct sk_buff *msdu;
 	int msdu_count;
@@ -458,6 +458,55 @@ static int ath10k_htt_rx_pop_paddr_list(struct ath10k_htt *htt,
 	return 0;
 }
 
+static int ath10k_htt_rx_pop_paddr64_list(struct ath10k_htt *htt,
+					  struct htt_rx_in_ord_ind *ev,
+					  struct sk_buff_head *list)
+{
+	struct ath10k *ar = htt->ar;
+	struct htt_rx_in_ord_msdu_desc_ext *msdu_desc = ev->msdu_descs64;
+	struct htt_rx_desc *rxd;
+	struct sk_buff *msdu;
+	int msdu_count;
+	bool is_offload;
+	u64 paddr;
+
+	lockdep_assert_held(&htt->rx_ring.lock);
+
+	msdu_count = __le16_to_cpu(ev->msdu_count);
+	is_offload = !!(ev->info & HTT_RX_IN_ORD_IND_INFO_OFFLOAD_MASK);
+
+	while (msdu_count--) {
+		paddr = __le64_to_cpu(msdu_desc->msdu_paddr);
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
@@ -1981,7 +2030,7 @@ static int ath10k_htt_rx_in_ord_ind(struct ath10k *ar, struct sk_buff *skb)
 		   "htt rx in ord vdev %i peer %i tid %i offload %i frag %i msdu count %i\n",
 		   vdev_id, peer_id, tid, offload, frag, msdu_count);
 
-	if (skb->len < msdu_count * sizeof(*resp->rx_in_ord_ind.msdu_descs)) {
+	if (skb->len < msdu_count * sizeof(*resp->rx_in_ord_ind.msdu_descs32)) {
 		ath10k_warn(ar, "dropping invalid in order rx indication\n");
 		return -EINVAL;
 	}
@@ -1990,7 +2039,13 @@ static int ath10k_htt_rx_in_ord_ind(struct ath10k *ar, struct sk_buff *skb)
 	 * extracted and processed.
 	 */
 	__skb_queue_head_init(&list);
-	ret = ath10k_htt_rx_pop_paddr_list(htt, &resp->rx_in_ord_ind, &list);
+	if (ar->hw_params.target_64bit)
+		ret = ath10k_htt_rx_pop_paddr64_list(htt, &resp->rx_in_ord_ind,
+						     &list);
+	else
+		ret = ath10k_htt_rx_pop_paddr32_list(htt, &resp->rx_in_ord_ind,
+						     &list);
+
 	if (ret < 0) {
 		ath10k_warn(ar, "failed to pop paddr list: %d\n", ret);
 		htt->rx_confused = true;
-- 
1.9.1
