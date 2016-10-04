Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:35031 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752417AbcJDMkA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Oct 2016 08:40:00 -0400
From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <mohammed@codeaurora.org>, <linux-wireless@vger.kernel.org>,
        "Mohammed Shafi Shajakhan" <mohammed@qti.qualcomm.com>
Subject: [PATCH 1/2] ath10k: clean up HTT tx buffer allocation and free
Date: Tue, 4 Oct 2016 18:09:31 +0530
Message-ID: <1475584772-4091-2-git-send-email-mohammed@qca.qualcomm.com> (sfid-20161004_144002_626352_2061849F)
In-Reply-To: <1475584772-4091-1-git-send-email-mohammed@qca.qualcomm.com>
References: <1475584772-4091-1-git-send-email-mohammed@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>

cleanup 'ath10k_htt_tx_alloc' by introducing the API's
'ath10k_htt_tx_alloc/free_{cont_txbuf, txdone_fifo} and
re-use them whereever needed

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/htt_tx.c | 76 +++++++++++++++++++++-----------
 1 file changed, 51 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c b/drivers/net/wireless/ath/ath10k/htt_tx.c
index 7c072b6..786fbd7 100644
--- a/drivers/net/wireless/ath/ath10k/htt_tx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
@@ -229,6 +229,33 @@ void ath10k_htt_tx_free_msdu_id(struct ath10k_htt *htt, u16 msdu_id)
 	idr_remove(&htt->pending_tx, msdu_id);
 }
 
+static void ath10k_htt_tx_free_cont_txbuf(struct ath10k_htt *htt)
+{
+	size_t size;
+
+	if (!htt->txbuf.vaddr)
+		return;
+
+	size = htt->max_num_pending_tx * sizeof(struct ath10k_htt_txbuf);
+	dma_free_coherent(htt->ar->dev, size, htt->txbuf.vaddr,
+			  htt->txbuf.paddr);
+}
+
+static int ath10k_htt_tx_alloc_cont_txbuf(struct ath10k_htt *htt)
+{
+	struct ath10k *ar = htt->ar;
+	size_t size;
+
+	size = htt->max_num_pending_tx * sizeof(struct ath10k_htt_txbuf);
+	htt->txbuf.vaddr = dma_alloc_coherent(ar->dev, size,
+					      &htt->txbuf.paddr,
+					      GFP_KERNEL);
+	if (!htt->txbuf.vaddr)
+		return -ENOMEM;
+
+	return 0;
+}
+
 static void ath10k_htt_tx_free_cont_frag_desc(struct ath10k_htt *htt)
 {
 	size_t size;
@@ -310,10 +337,26 @@ static int ath10k_htt_tx_alloc_txq(struct ath10k_htt *htt)
 	return 0;
 }
 
+static void ath10k_htt_tx_free_txdone_fifo(struct ath10k_htt *htt)
+{
+	WARN_ON(!kfifo_is_empty(&htt->txdone_fifo));
+	kfifo_free(&htt->txdone_fifo);
+}
+
+static int ath10k_htt_tx_alloc_txdone_fifo(struct ath10k_htt *htt)
+{
+	int ret;
+	size_t size;
+
+	size = roundup_pow_of_two(htt->max_num_pending_tx);
+	ret = kfifo_alloc(&htt->txdone_fifo, size, GFP_KERNEL);
+	return ret;
+}
+
 int ath10k_htt_tx_alloc(struct ath10k_htt *htt)
 {
 	struct ath10k *ar = htt->ar;
-	int ret, size;
+	int ret;
 
 	ath10k_dbg(ar, ATH10K_DBG_BOOT, "htt tx max num pending tx %d\n",
 		   htt->max_num_pending_tx);
@@ -321,13 +364,9 @@ int ath10k_htt_tx_alloc(struct ath10k_htt *htt)
 	spin_lock_init(&htt->tx_lock);
 	idr_init(&htt->pending_tx);
 
-	size = htt->max_num_pending_tx * sizeof(struct ath10k_htt_txbuf);
-	htt->txbuf.vaddr = dma_alloc_coherent(ar->dev, size,
-						  &htt->txbuf.paddr,
-						  GFP_KERNEL);
-	if (!htt->txbuf.vaddr) {
-		ath10k_err(ar, "failed to alloc tx buffer\n");
-		ret = -ENOMEM;
+	ret = ath10k_htt_tx_alloc_cont_txbuf(htt);
+	if (ret) {
+		ath10k_err(ar, "failed to alloc cont tx buffer: %d\n", ret);
 		goto free_idr_pending_tx;
 	}
 
@@ -343,8 +382,7 @@ int ath10k_htt_tx_alloc(struct ath10k_htt *htt)
 		goto free_frag_desc;
 	}
 
-	size = roundup_pow_of_two(htt->max_num_pending_tx);
-	ret = kfifo_alloc(&htt->txdone_fifo, size, GFP_KERNEL);
+	ret = ath10k_htt_tx_alloc_txdone_fifo(htt);
 	if (ret) {
 		ath10k_err(ar, "failed to alloc txdone fifo: %d\n", ret);
 		goto free_txq;
@@ -359,10 +397,7 @@ free_frag_desc:
 	ath10k_htt_tx_free_cont_frag_desc(htt);
 
 free_txbuf:
-	size = htt->max_num_pending_tx *
-			  sizeof(struct ath10k_htt_txbuf);
-	dma_free_coherent(htt->ar->dev, size, htt->txbuf.vaddr,
-			  htt->txbuf.paddr);
+	ath10k_htt_tx_free_cont_txbuf(htt);
 
 free_idr_pending_tx:
 	idr_destroy(&htt->pending_tx);
@@ -388,24 +423,15 @@ static int ath10k_htt_tx_clean_up_pending(int msdu_id, void *skb, void *ctx)
 
 void ath10k_htt_tx_free(struct ath10k_htt *htt)
 {
-	int size;
-
 	tasklet_kill(&htt->txrx_compl_task);
 
 	idr_for_each(&htt->pending_tx, ath10k_htt_tx_clean_up_pending, htt->ar);
 	idr_destroy(&htt->pending_tx);
 
-	if (htt->txbuf.vaddr) {
-		size = htt->max_num_pending_tx *
-				  sizeof(struct ath10k_htt_txbuf);
-		dma_free_coherent(htt->ar->dev, size, htt->txbuf.vaddr,
-				  htt->txbuf.paddr);
-	}
-
+	ath10k_htt_tx_free_cont_txbuf(htt);
 	ath10k_htt_tx_free_txq(htt);
 	ath10k_htt_tx_free_cont_frag_desc(htt);
-	WARN_ON(!kfifo_is_empty(&htt->txdone_fifo));
-	kfifo_free(&htt->txdone_fifo);
+	ath10k_htt_tx_free_txdone_fifo(htt);
 }
 
 void ath10k_htt_htc_tx_complete(struct ath10k *ar, struct sk_buff *skb)
-- 
1.9.1
