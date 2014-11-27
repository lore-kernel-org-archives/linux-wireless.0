Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:64104 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753367AbaK0KW0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Nov 2014 05:22:26 -0500
Received: by mail-wg0-f45.google.com with SMTP id b13so6089420wgh.18
        for <linux-wireless@vger.kernel.org>; Thu, 27 Nov 2014 02:22:25 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 2/3] ath10k: remove callback argument
Date: Thu, 27 Nov 2014 11:09:37 +0100
Message-Id: <1417082978-1701-2-git-send-email-michal.kazior@tieto.com> (sfid-20141127_112232_019071_8CEA0589)
In-Reply-To: <1417082978-1701-1-git-send-email-michal.kazior@tieto.com>
References: <1417082978-1701-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pass the eid argument via skbuff control buffer.
This will make it possible to work with queues of
HTC event buffers.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.h |  1 +
 drivers/net/wireless/ath/ath10k/hif.h  |  3 +--
 drivers/net/wireless/ath/ath10k/htc.c  | 10 +++++++---
 drivers/net/wireless/ath/ath10k/pci.c  |  4 ++--
 4 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 4a29498..226b2d2 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -79,6 +79,7 @@ static inline const char *ath10k_bus_str(enum ath10k_bus bus)
 
 struct ath10k_skb_cb {
 	dma_addr_t paddr;
+	u8 eid;
 	u8 vdev_id;
 
 	struct {
diff --git a/drivers/net/wireless/ath/ath10k/hif.h b/drivers/net/wireless/ath/ath10k/hif.h
index 91d24a5..0c92e02 100644
--- a/drivers/net/wireless/ath/ath10k/hif.h
+++ b/drivers/net/wireless/ath/ath10k/hif.h
@@ -32,8 +32,7 @@ struct ath10k_hif_sg_item {
 
 struct ath10k_hif_cb {
 	int (*tx_completion)(struct ath10k *ar,
-			     struct sk_buff *wbuf,
-			     unsigned transfer_id);
+			     struct sk_buff *wbuf);
 	int (*rx_completion)(struct ath10k *ar,
 			     struct sk_buff *wbuf);
 };
diff --git a/drivers/net/wireless/ath/ath10k/htc.c b/drivers/net/wireless/ath/ath10k/htc.c
index e245e34..f1946a6 100644
--- a/drivers/net/wireless/ath/ath10k/htc.c
+++ b/drivers/net/wireless/ath/ath10k/htc.c
@@ -160,6 +160,7 @@ int ath10k_htc_send(struct ath10k_htc *htc,
 
 	ath10k_htc_prepare_tx_skb(ep, skb);
 
+	skb_cb->eid = eid;
 	skb_cb->paddr = dma_map_single(dev, skb->data, skb->len, DMA_TO_DEVICE);
 	ret = dma_mapping_error(dev, skb_cb->paddr);
 	if (ret)
@@ -197,15 +198,18 @@ err_pull:
 }
 
 static int ath10k_htc_tx_completion_handler(struct ath10k *ar,
-					    struct sk_buff *skb,
-					    unsigned int eid)
+					    struct sk_buff *skb)
 {
 	struct ath10k_htc *htc = &ar->htc;
-	struct ath10k_htc_ep *ep = &htc->endpoint[eid];
+	struct ath10k_skb_cb *skb_cb;
+	struct ath10k_htc_ep *ep;
 
 	if (WARN_ON_ONCE(!skb))
 		return 0;
 
+	skb_cb = ATH10K_SKB_CB(skb);
+	ep = &htc->endpoint[skb_cb->eid];
+
 	ath10k_htc_notify_tx_completion(ep, skb);
 	/* the skb now belongs to the completion handler */
 
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 541f3bc..95e9066 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -835,7 +835,7 @@ static void ath10k_pci_ce_send_done(struct ath10k_ce_pipe *ce_state)
 		if (transfer_context == NULL)
 			continue;
 
-		cb->tx_completion(ar, transfer_context, transfer_id);
+		cb->tx_completion(ar, transfer_context);
 	}
 }
 
@@ -1263,7 +1263,7 @@ static void ath10k_pci_tx_pipe_cleanup(struct ath10k_pci_pipe *pci_pipe)
 		id = MS(__le16_to_cpu(ce_desc[i].flags),
 			CE_DESC_FLAGS_META_DATA);
 
-		ar_pci->msg_callbacks_current.tx_completion(ar, skb, id);
+		ar_pci->msg_callbacks_current.tx_completion(ar, skb);
 	}
 }
 
-- 
1.8.5.3

