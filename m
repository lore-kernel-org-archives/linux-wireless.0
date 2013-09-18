Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:46192 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751612Ab3IRMne (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Sep 2013 08:43:34 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 5/5] ath10k: use msdu headroom to store txfrag
Date: Wed, 18 Sep 2013 14:43:22 +0200
Message-ID: <1379508202-9660-6-git-send-email-michal.kazior@tieto.com> (sfid-20130918_144339_534197_84983A23)
In-Reply-To: <1379508202-9660-1-git-send-email-michal.kazior@tieto.com>
References: <1379508202-9660-1-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Instead of allocating sk_buff for a mere 16-byte
tx fragment list buffer use headroom of the
original msdu sk_buff.

This decreases CPU cache pressure and improves
performance.

Measured improvement on AP135 is 560mbps ->
590mbps of UDP TX briding traffic.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.h   |    4 +-
 drivers/net/wireless/ath/ath10k/htt_tx.c |   82 +++++++++++++++---------------
 drivers/net/wireless/ath/ath10k/mac.c    |    4 ++
 drivers/net/wireless/ath/ath10k/txrx.c   |   16 +++---
 4 files changed, 53 insertions(+), 53 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 4563f80..292ad45 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -54,7 +54,9 @@ struct ath10k_skb_cb {
 		u8 vdev_id;
 		u8 tid;
 		bool is_offchan;
-		struct sk_buff *txfrag;
+
+		u8 frag_len;
+		u8 pad_len;
 	} __packed htt;
 } __packed;
 
diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c b/drivers/net/wireless/ath/ath10k/htt_tx.c
index 5e738d8..3b93c6a 100644
--- a/drivers/net/wireless/ath/ath10k/htt_tx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
@@ -307,7 +307,8 @@ int ath10k_htt_mgmt_tx(struct ath10k_htt *htt, struct sk_buff *msdu)
 	struct device *dev = htt->ar->dev;
 	struct sk_buff *txdesc = NULL;
 	struct htt_cmd *cmd;
-	u8 vdev_id = ATH10K_SKB_CB(msdu)->htt.vdev_id;
+	struct ath10k_skb_cb *skb_cb = ATH10K_SKB_CB(msdu);
+	u8 vdev_id = skb_cb->htt.vdev_id;
 	int len = 0;
 	int msdu_id = -1;
 	int res;
@@ -350,6 +351,9 @@ int ath10k_htt_mgmt_tx(struct ath10k_htt *htt, struct sk_buff *msdu)
 	memcpy(cmd->mgmt_tx.hdr, msdu->data,
 	       min_t(int, msdu->len, HTT_MGMT_FRM_HDR_DOWNLOAD_LEN));
 
+	skb_cb->htt.frag_len = 0;
+	skb_cb->htt.pad_len = 0;
+
 	res = ath10k_htc_send(&htt->ar->htc, htt->eid, txdesc);
 	if (res)
 		goto err_unmap_msdu;
@@ -377,13 +381,12 @@ int ath10k_htt_tx(struct ath10k_htt *htt, struct sk_buff *msdu)
 	struct htt_cmd *cmd;
 	struct htt_data_tx_desc_frag *tx_frags;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)msdu->data;
+	struct ath10k_skb_cb *skb_cb = ATH10K_SKB_CB(msdu);
 	struct sk_buff *txdesc = NULL;
-	struct sk_buff *txfrag = NULL;
 	bool use_frags;
 	u8 vdev_id = ATH10K_SKB_CB(msdu)->htt.vdev_id;
 	u8 tid;
-	int prefetch_len, desc_len, frag_len;
-	dma_addr_t frags_paddr;
+	int prefetch_len, desc_len;
 	int msdu_id = -1;
 	int res;
 	u8 flags0;
@@ -407,7 +410,6 @@ int ath10k_htt_tx(struct ath10k_htt *htt, struct sk_buff *msdu)
 	prefetch_len = roundup(prefetch_len, 4);
 
 	desc_len = sizeof(cmd->hdr) + sizeof(cmd->data_tx) + prefetch_len;
-	frag_len = sizeof(*tx_frags) * 2;
 
 	txdesc = ath10k_htc_alloc_skb(desc_len);
 	if (!txdesc) {
@@ -421,41 +423,44 @@ int ath10k_htt_tx(struct ath10k_htt *htt, struct sk_buff *msdu)
 	use_frags = htt->target_version_major < 3 ||
 		    !ieee80211_is_mgmt(hdr->frame_control);
 
-	if (use_frags) {
-		txfrag = dev_alloc_skb(frag_len);
-		if (!txfrag) {
-			res = -ENOMEM;
-			goto err_free_txdesc;
-		}
-	}
-
 	if (!IS_ALIGNED((unsigned long)txdesc->data, 4)) {
 		ath10k_warn("htt alignment check failed. dropping packet.\n");
 		res = -EIO;
-		goto err_free_txfrag;
+		goto err_free_txdesc;
+	}
+
+	if (use_frags) {
+		skb_cb->htt.frag_len = sizeof(*tx_frags) * 2;
+		skb_cb->htt.pad_len = (unsigned long)msdu->data -
+				      round_down((unsigned long)msdu->data, 4);
+
+		skb_push(msdu, skb_cb->htt.frag_len + skb_cb->htt.pad_len);
+	} else {
+		skb_cb->htt.frag_len = 0;
+		skb_cb->htt.pad_len = 0;
 	}
 
 	res = ath10k_skb_map(dev, msdu);
 	if (res)
-		goto err_free_txfrag;
+		goto err_pull_txfrag;
 
 	if (use_frags) {
+		dma_sync_single_for_cpu(dev, skb_cb->paddr, msdu->len,
+					DMA_TO_DEVICE);
+
 		/* tx fragment list must be terminated with zero-entry */
-		skb_put(txfrag, frag_len);
-		tx_frags = (struct htt_data_tx_desc_frag *)txfrag->data;
-		tx_frags[0].paddr = __cpu_to_le32(ATH10K_SKB_CB(msdu)->paddr);
-		tx_frags[0].len   = __cpu_to_le32(msdu->len);
+		tx_frags = (struct htt_data_tx_desc_frag *)msdu->data;
+		tx_frags[0].paddr = __cpu_to_le32(skb_cb->paddr +
+						  skb_cb->htt.frag_len +
+						  skb_cb->htt.pad_len);
+		tx_frags[0].len   = __cpu_to_le32(msdu->len -
+						  skb_cb->htt.frag_len -
+						  skb_cb->htt.pad_len);
 		tx_frags[1].paddr = __cpu_to_le32(0);
 		tx_frags[1].len   = __cpu_to_le32(0);
 
-		res = ath10k_skb_map(dev, txfrag);
-		if (res)
-			goto err_unmap_msdu;
-
-		ath10k_dbg(ATH10K_DBG_HTT, "txfrag 0x%llx\n",
-			   (unsigned long long) ATH10K_SKB_CB(txfrag)->paddr);
-		ath10k_dbg_dump(ATH10K_DBG_HTT_DUMP, NULL, "txfrag: ",
-				txfrag->data, frag_len);
+		dma_sync_single_for_device(dev, skb_cb->paddr, msdu->len,
+					   DMA_TO_DEVICE);
 	}
 
 	ath10k_dbg(ATH10K_DBG_HTT, "msdu 0x%llx\n",
@@ -488,35 +493,28 @@ int ath10k_htt_tx(struct ath10k_htt *htt, struct sk_buff *msdu)
 	flags1 |= HTT_DATA_TX_DESC_FLAGS1_CKSUM_L3_OFFLOAD;
 	flags1 |= HTT_DATA_TX_DESC_FLAGS1_CKSUM_L4_OFFLOAD;
 
-	if (use_frags)
-		frags_paddr = ATH10K_SKB_CB(txfrag)->paddr;
-	else
-		frags_paddr = ATH10K_SKB_CB(msdu)->paddr;
-
 	cmd->hdr.msg_type        = HTT_H2T_MSG_TYPE_TX_FRM;
 	cmd->data_tx.flags0      = flags0;
 	cmd->data_tx.flags1      = __cpu_to_le16(flags1);
-	cmd->data_tx.len         = __cpu_to_le16(msdu->len);
+	cmd->data_tx.len         = __cpu_to_le16(msdu->len -
+						 skb_cb->htt.frag_len -
+						 skb_cb->htt.pad_len);
 	cmd->data_tx.id          = __cpu_to_le16(msdu_id);
-	cmd->data_tx.frags_paddr = __cpu_to_le32(frags_paddr);
+	cmd->data_tx.frags_paddr = __cpu_to_le32(skb_cb->paddr);
 	cmd->data_tx.peerid      = __cpu_to_le32(HTT_INVALID_PEERID);
 
-	memcpy(cmd->data_tx.prefetch, msdu->data, prefetch_len);
+	memcpy(cmd->data_tx.prefetch, hdr, prefetch_len);
 
 	res = ath10k_htc_send(&htt->ar->htc, htt->eid, txdesc);
 	if (res)
-		goto err_restore;
+		goto err_unmap_msdu;
 
 	return 0;
 
-err_restore:
-	if (use_frags)
-		ath10k_skb_unmap(dev, txfrag);
 err_unmap_msdu:
 	ath10k_skb_unmap(dev, msdu);
-err_free_txfrag:
-	if (use_frags)
-		dev_kfree_skb_any(txfrag);
+err_pull_txfrag:
+	skb_pull(msdu, skb_cb->htt.frag_len + skb_cb->htt.pad_len);
 err_free_txdesc:
 	dev_kfree_skb_any(txdesc);
 err_free_msdu_id:
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 9112e6d6f..99a9bad 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -3342,6 +3342,10 @@ int ath10k_mac_register(struct ath10k *ar)
 			IEEE80211_HW_WANT_MONITOR_VIF |
 			IEEE80211_HW_AP_LINK_PS;
 
+	/* MSDU can have HTT TX fragment pushed in front. The additional 4
+	 * bytes is used for padding/alignment if necessary. */
+	ar->hw->extra_tx_headroom += sizeof(struct htt_data_tx_desc_frag)*2 + 4;
+
 	if (ar->ht_cap_info & WMI_HT_CAP_DYNAMIC_SMPS)
 		ar->hw->flags |= IEEE80211_HW_SUPPORTS_DYNAMIC_SMPS;
 
diff --git a/drivers/net/wireless/ath/ath10k/txrx.c b/drivers/net/wireless/ath/ath10k/txrx.c
index 15395af..57931d0 100644
--- a/drivers/net/wireless/ath/ath10k/txrx.c
+++ b/drivers/net/wireless/ath/ath10k/txrx.c
@@ -49,7 +49,8 @@ void ath10k_txrx_tx_unref(struct ath10k_htt *htt,
 {
 	struct device *dev = htt->ar->dev;
 	struct ieee80211_tx_info *info;
-	struct sk_buff *msdu, *txfrag;
+	struct ath10k_skb_cb *skb_cb;
+	struct sk_buff *msdu;
 	int ret;
 
 	ath10k_dbg(ATH10K_DBG_HTT, "htt tx completion msdu_id %u discard %d no_ack %d\n",
@@ -62,20 +63,15 @@ void ath10k_txrx_tx_unref(struct ath10k_htt *htt,
 	}
 
 	msdu = htt->pending_tx[tx_done->msdu_id];
-	txfrag = ATH10K_SKB_CB(msdu)->htt.txfrag;
-
-	if (txfrag) {
-		ret = ath10k_skb_unmap(dev, txfrag);
-		if (ret)
-			ath10k_warn("txfrag unmap failed (%d)\n", ret);
-
-		dev_kfree_skb_any(txfrag);
-	}
+	skb_cb = ATH10K_SKB_CB(msdu);
 
 	ret = ath10k_skb_unmap(dev, msdu);
 	if (ret)
 		ath10k_warn("data skb unmap failed (%d)\n", ret);
 
+	if (skb_cb->htt.frag_len)
+		skb_pull(msdu, skb_cb->htt.frag_len + skb_cb->htt.pad_len);
+
 	ath10k_report_offchan_tx(htt->ar, msdu);
 
 	info = IEEE80211_SKB_CB(msdu);
-- 
1.7.9.5

