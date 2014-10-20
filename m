Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f43.google.com ([209.85.215.43]:48629 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752629AbaJTNyW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2014 09:54:22 -0400
Received: by mail-la0-f43.google.com with SMTP id mc6so3968164lab.2
        for <linux-wireless@vger.kernel.org>; Mon, 20 Oct 2014 06:54:20 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 5/9] ath10k: deduplicate htt rx dma unmapping
Date: Mon, 20 Oct 2014 15:40:34 +0200
Message-Id: <1413812438-14640-6-git-send-email-michal.kazior@tieto.com> (sfid-20141020_155429_929979_7A923693)
In-Reply-To: <1413812438-14640-1-git-send-email-michal.kazior@tieto.com>
References: <1413812438-14640-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Treat non-chained and chained popping the same
way. Also this makes netbuf pop fully symmetrical
to (re)filling.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c | 30 +++++++++---------------------
 1 file changed, 9 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index a7d29c8..41a2803 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -291,6 +291,15 @@ static inline struct sk_buff *ath10k_htt_rx_netbuf_pop(struct ath10k_htt *htt)
 	htt->rx_ring.sw_rd_idx.msdu_payld = idx;
 	htt->rx_ring.fill_cnt--;
 
+	dma_unmap_single(htt->ar->dev,
+			 ATH10K_SKB_CB(msdu)->paddr,
+			 msdu->len + skb_tailroom(msdu),
+			 DMA_FROM_DEVICE);
+	ath10k_dbg_dump(ar, ATH10K_DBG_HTT_DUMP, NULL, "htt rx netbuf pop: ",
+			msdu->data, msdu->len + skb_tailroom(msdu));
+	trace_ath10k_htt_rx_pop_msdu(ar, msdu->data, msdu->len +
+				     skb_tailroom(msdu));
+
 	return msdu;
 }
 
@@ -329,16 +338,6 @@ static int ath10k_htt_rx_amsdu_pop(struct ath10k_htt *htt,
 	while (msdu) {
 		int last_msdu, msdu_len_invalid, msdu_chained;
 
-		dma_unmap_single(htt->ar->dev,
-				 ATH10K_SKB_CB(msdu)->paddr,
-				 msdu->len + skb_tailroom(msdu),
-				 DMA_FROM_DEVICE);
-
-		ath10k_dbg_dump(ar, ATH10K_DBG_HTT_DUMP, NULL, "htt rx pop: ",
-				msdu->data, msdu->len + skb_tailroom(msdu));
-		trace_ath10k_htt_rx_pop_msdu(ar, msdu->data, msdu->len +
-					     skb_tailroom(msdu));
-
 		rx_desc = (struct htt_rx_desc *)msdu->data;
 
 		/* FIXME: we must report msdu payload since this is what caller
@@ -429,17 +428,6 @@ static int ath10k_htt_rx_amsdu_pop(struct ath10k_htt *htt,
 		while (msdu_chained--) {
 			struct sk_buff *next = ath10k_htt_rx_netbuf_pop(htt);
 
-			dma_unmap_single(htt->ar->dev,
-					 ATH10K_SKB_CB(next)->paddr,
-					 next->len + skb_tailroom(next),
-					 DMA_FROM_DEVICE);
-
-			ath10k_dbg_dump(ar, ATH10K_DBG_HTT_DUMP, NULL,
-					"htt rx chained: ", next->data,
-					next->len + skb_tailroom(next));
-			trace_ath10k_htt_rx_pop_msdu(ar, msdu->data, msdu->len +
-						     skb_tailroom(msdu));
-
 			skb_trim(next, 0);
 			skb_put(next, min(msdu_len, HTT_RX_BUF_SIZE));
 			msdu_len -= next->len;
-- 
1.8.5.3

