Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f53.google.com ([74.125.83.53]:53021 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971AbaB0HZC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Feb 2014 02:25:02 -0500
Received: by mail-ee0-f53.google.com with SMTP id e51so48418eek.12
        for <linux-wireless@vger.kernel.org>; Wed, 26 Feb 2014 23:24:59 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v3 1/8] ath10k: remove DMA mapping wrappers
Date: Thu, 27 Feb 2014 08:19:40 +0100
Message-Id: <1393485587-16879-2-git-send-email-michal.kazior@tieto.com> (sfid-20140227_082522_718800_B15BDE82)
In-Reply-To: <1393485587-16879-1-git-send-email-michal.kazior@tieto.com>
References: <1392629563-31046-1-git-send-email-michal.kazior@tieto.com>
 <1393485587-16879-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There's no real benefit from using them. DMA-API
already provides debugging. Some skbuffs are
already mapped directly with DMA-API since wrapper
arguments were insufficient and extending them
would be pointless.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
v2:
 * var naming fix: s/ret/err/

 drivers/net/wireless/ath/ath10k/core.h   | 27 ---------------------------
 drivers/net/wireless/ath/ath10k/htc.c    | 11 ++++++++---
 drivers/net/wireless/ath/ath10k/htt_tx.c | 12 ++++++++----
 drivers/net/wireless/ath/ath10k/mac.c    |  4 +++-
 drivers/net/wireless/ath/ath10k/txrx.c   |  5 +----
 drivers/net/wireless/ath/ath10k/wmi.c    | 17 ++++++++++++++---
 6 files changed, 34 insertions(+), 42 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 1fc26fe..082fa77 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -62,7 +62,6 @@ struct ath10k;
 
 struct ath10k_skb_cb {
 	dma_addr_t paddr;
-	bool is_mapped;
 	bool is_aborted;
 	u8 vdev_id;
 
@@ -87,32 +86,6 @@ static inline struct ath10k_skb_cb *ATH10K_SKB_CB(struct sk_buff *skb)
 	return (struct ath10k_skb_cb *)&IEEE80211_SKB_CB(skb)->driver_data;
 }
 
-static inline int ath10k_skb_map(struct device *dev, struct sk_buff *skb)
-{
-	if (ATH10K_SKB_CB(skb)->is_mapped)
-		return -EINVAL;
-
-	ATH10K_SKB_CB(skb)->paddr = dma_map_single(dev, skb->data, skb->len,
-						   DMA_TO_DEVICE);
-
-	if (unlikely(dma_mapping_error(dev, ATH10K_SKB_CB(skb)->paddr)))
-		return -EIO;
-
-	ATH10K_SKB_CB(skb)->is_mapped = true;
-	return 0;
-}
-
-static inline int ath10k_skb_unmap(struct device *dev, struct sk_buff *skb)
-{
-	if (!ATH10K_SKB_CB(skb)->is_mapped)
-		return -EINVAL;
-
-	dma_unmap_single(dev, ATH10K_SKB_CB(skb)->paddr, skb->len,
-			 DMA_TO_DEVICE);
-	ATH10K_SKB_CB(skb)->is_mapped = false;
-	return 0;
-}
-
 static inline u32 host_interest_item_address(u32 item_offset)
 {
 	return QCA988X_HOST_INTEREST_ADDRESS + item_offset;
diff --git a/drivers/net/wireless/ath/ath10k/htc.c b/drivers/net/wireless/ath/ath10k/htc.c
index edc57ab..69f1f46 100644
--- a/drivers/net/wireless/ath/ath10k/htc.c
+++ b/drivers/net/wireless/ath/ath10k/htc.c
@@ -63,7 +63,9 @@ static struct sk_buff *ath10k_htc_build_tx_ctrl_skb(void *ar)
 static inline void ath10k_htc_restore_tx_skb(struct ath10k_htc *htc,
 					     struct sk_buff *skb)
 {
-	ath10k_skb_unmap(htc->ar->dev, skb);
+	struct ath10k_skb_cb *skb_cb = ATH10K_SKB_CB(skb);
+
+	dma_unmap_single(htc->ar->dev, skb_cb->paddr, skb->len, DMA_TO_DEVICE);
 	skb_pull(skb, sizeof(struct ath10k_htc_hdr));
 }
 
@@ -122,6 +124,8 @@ int ath10k_htc_send(struct ath10k_htc *htc,
 		    struct sk_buff *skb)
 {
 	struct ath10k_htc_ep *ep = &htc->endpoint[eid];
+	struct ath10k_skb_cb *skb_cb = ATH10K_SKB_CB(skb);
+	struct device *dev = htc->ar->dev;
 	int credits = 0;
 	int ret;
 
@@ -157,7 +161,8 @@ int ath10k_htc_send(struct ath10k_htc *htc,
 
 	ath10k_htc_prepare_tx_skb(ep, skb);
 
-	ret = ath10k_skb_map(htc->ar->dev, skb);
+	skb_cb->paddr = dma_map_single(dev, skb->data, skb->len, DMA_TO_DEVICE);
+	ret = dma_mapping_error(dev, skb_cb->paddr);
 	if (ret)
 		goto err_credits;
 
@@ -169,7 +174,7 @@ int ath10k_htc_send(struct ath10k_htc *htc,
 	return 0;
 
 err_unmap:
-	ath10k_skb_unmap(htc->ar->dev, skb);
+	dma_unmap_single(dev, skb_cb->paddr, skb->len, DMA_TO_DEVICE);
 err_credits:
 	if (ep->tx_credit_flow_enabled) {
 		spin_lock_bh(&htc->tx_lock);
diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c b/drivers/net/wireless/ath/ath10k/htt_tx.c
index acaa046..f5960c5 100644
--- a/drivers/net/wireless/ath/ath10k/htt_tx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
@@ -334,7 +334,9 @@ int ath10k_htt_mgmt_tx(struct ath10k_htt *htt, struct sk_buff *msdu)
 		goto err_free_msdu_id;
 	}
 
-	res = ath10k_skb_map(dev, msdu);
+	skb_cb->paddr = dma_map_single(dev, msdu->data, msdu->len,
+				       DMA_TO_DEVICE);
+	res = dma_mapping_error(dev, skb_cb->paddr);
 	if (res)
 		goto err_free_txdesc;
 
@@ -358,7 +360,7 @@ int ath10k_htt_mgmt_tx(struct ath10k_htt *htt, struct sk_buff *msdu)
 	return 0;
 
 err_unmap_msdu:
-	ath10k_skb_unmap(dev, msdu);
+	dma_unmap_single(dev, skb_cb->paddr, msdu->len, DMA_TO_DEVICE);
 err_free_txdesc:
 	dev_kfree_skb_any(txdesc);
 err_free_msdu_id:
@@ -437,7 +439,9 @@ int ath10k_htt_tx(struct ath10k_htt *htt, struct sk_buff *msdu)
 		skb_cb->htt.pad_len = 0;
 	}
 
-	res = ath10k_skb_map(dev, msdu);
+	skb_cb->paddr = dma_map_single(dev, msdu->data, msdu->len,
+				       DMA_TO_DEVICE);
+	res = dma_mapping_error(dev, skb_cb->paddr);
 	if (res)
 		goto err_pull_txfrag;
 
@@ -509,7 +513,7 @@ int ath10k_htt_tx(struct ath10k_htt *htt, struct sk_buff *msdu)
 	return 0;
 
 err_unmap_msdu:
-	ath10k_skb_unmap(dev, msdu);
+	dma_unmap_single(dev, skb_cb->paddr, msdu->len, DMA_TO_DEVICE);
 err_pull_txfrag:
 	skb_pull(msdu, skb_cb->htt.frag_len + skb_cb->htt.pad_len);
 err_free_txdesc:
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 0321da0..9d682ed 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -855,7 +855,9 @@ static void ath10k_control_beaconing(struct ath10k_vif *arvif,
 
 		spin_lock_bh(&arvif->ar->data_lock);
 		if (arvif->beacon) {
-			ath10k_skb_unmap(arvif->ar->dev, arvif->beacon);
+			dma_unmap_single(arvif->ar->dev,
+					 ATH10K_SKB_CB(arvif->beacon)->paddr,
+					 arvif->beacon->len, DMA_TO_DEVICE);
 			dev_kfree_skb_any(arvif->beacon);
 
 			arvif->beacon = NULL;
diff --git a/drivers/net/wireless/ath/ath10k/txrx.c b/drivers/net/wireless/ath/ath10k/txrx.c
index dcf7efd..fe69899 100644
--- a/drivers/net/wireless/ath/ath10k/txrx.c
+++ b/drivers/net/wireless/ath/ath10k/txrx.c
@@ -51,7 +51,6 @@ void ath10k_txrx_tx_unref(struct ath10k_htt *htt,
 	struct ieee80211_tx_info *info;
 	struct ath10k_skb_cb *skb_cb;
 	struct sk_buff *msdu;
-	int ret;
 
 	ath10k_dbg(ATH10K_DBG_HTT, "htt tx completion msdu_id %u discard %d no_ack %d\n",
 		   tx_done->msdu_id, !!tx_done->discard, !!tx_done->no_ack);
@@ -65,9 +64,7 @@ void ath10k_txrx_tx_unref(struct ath10k_htt *htt,
 	msdu = htt->pending_tx[tx_done->msdu_id];
 	skb_cb = ATH10K_SKB_CB(msdu);
 
-	ret = ath10k_skb_unmap(dev, msdu);
-	if (ret)
-		ath10k_warn("data skb unmap failed (%d)\n", ret);
+	dma_unmap_single(dev, skb_cb->paddr, msdu->len, DMA_TO_DEVICE);
 
 	if (skb_cb->htt.frag_len)
 		skb_pull(msdu, skb_cb->htt.frag_len + skb_cb->htt.pad_len);
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 91e501b..478e7f6 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -1360,7 +1360,7 @@ static void ath10k_wmi_event_host_swba(struct ath10k *ar, struct sk_buff *skb)
 	struct wmi_bcn_info *bcn_info;
 	struct ath10k_vif *arvif;
 	struct sk_buff *bcn;
-	int vdev_id = 0;
+	int ret, vdev_id = 0;
 
 	ath10k_dbg(ATH10K_DBG_MGMT, "WMI_HOST_SWBA_EVENTID\n");
 
@@ -1435,16 +1435,27 @@ static void ath10k_wmi_event_host_swba(struct ath10k *ar, struct sk_buff *skb)
 				ath10k_warn("SWBA overrun on vdev %d\n",
 					    arvif->vdev_id);
 
-			ath10k_skb_unmap(ar->dev, arvif->beacon);
+			dma_unmap_single(arvif->ar->dev,
+					 ATH10K_SKB_CB(arvif->beacon)->paddr,
+					 arvif->beacon->len, DMA_TO_DEVICE);
 			dev_kfree_skb_any(arvif->beacon);
 		}
 
-		ath10k_skb_map(ar->dev, bcn);
+		ATH10K_SKB_CB(bcn)->paddr = dma_map_single(arvif->ar->dev,
+							   bcn->data, bcn->len,
+							   DMA_TO_DEVICE);
+		ret = dma_mapping_error(arvif->ar->dev,
+					ATH10K_SKB_CB(bcn)->paddr);
+		if (ret) {
+			ath10k_warn("failed to map beacon: %d\n", ret);
+			goto skip;
+		}
 
 		arvif->beacon = bcn;
 		arvif->beacon_sent = false;
 
 		ath10k_wmi_tx_beacon_nowait(arvif);
+skip:
 		spin_unlock_bh(&ar->data_lock);
 	}
 }
-- 
1.8.5.3

