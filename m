Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f177.google.com ([209.85.215.177]:45654 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157AbaB0HZI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Feb 2014 02:25:08 -0500
Received: by mail-ea0-f177.google.com with SMTP id h10so1537820eak.8
        for <linux-wireless@vger.kernel.org>; Wed, 26 Feb 2014 23:25:07 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v3 8/8] ath10k: minimize coherent dma accesses
Date: Thu, 27 Feb 2014 08:19:47 +0100
Message-Id: <1393485587-16879-9-git-send-email-michal.kazior@tieto.com> (sfid-20140227_082530_196790_871707C2)
In-Reply-To: <1393485587-16879-1-git-send-email-michal.kazior@tieto.com>
References: <1392629563-31046-1-git-send-email-michal.kazior@tieto.com>
 <1393485587-16879-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It doesn't make much sense to calculate the ring
size fill count because it already is memoized in
a separate variable.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
v2:
 * fix unbalanced locking

 drivers/net/wireless/ath/ath10k/htt_rx.c | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 1cb88bf..2fe47d8 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -225,12 +225,6 @@ static void ath10k_htt_rx_ring_refill_retry(unsigned long arg)
 	ath10k_htt_rx_msdu_buff_replenish(htt);
 }
 
-static unsigned ath10k_htt_rx_ring_elems(struct ath10k_htt *htt)
-{
-	return (__le32_to_cpu(*htt->rx_ring.alloc_idx.vaddr) -
-		htt->rx_ring.sw_rd_idx.msdu_payld) & htt->rx_ring.size_mask;
-}
-
 void ath10k_htt_rx_detach(struct ath10k_htt *htt)
 {
 	int sw_rd_idx = htt->rx_ring.sw_rd_idx.msdu_payld;
@@ -276,8 +270,10 @@ static inline struct sk_buff *ath10k_htt_rx_netbuf_pop(struct ath10k_htt *htt)
 
 	lockdep_assert_held(&htt->rx_ring.lock);
 
-	if (ath10k_htt_rx_ring_elems(htt) == 0)
-		ath10k_warn("htt rx ring is empty!\n");
+	if (htt->rx_ring.fill_cnt == 0) {
+		ath10k_warn("tried to pop sk_buff from an empty rx ring\n");
+		return NULL;
+	}
 
 	idx = htt->rx_ring.sw_rd_idx.msdu_payld;
 	msdu = htt->rx_ring.netbufs_ring[idx];
@@ -312,9 +308,6 @@ static int ath10k_htt_rx_amsdu_pop(struct ath10k_htt *htt,
 
 	lockdep_assert_held(&htt->rx_ring.lock);
 
-	if (ath10k_htt_rx_ring_elems(htt) == 0)
-		ath10k_warn("htt rx ring is empty!\n");
-
 	if (htt->rx_confused) {
 		ath10k_warn("htt is confused. refusing rx\n");
 		return 0;
-- 
1.8.5.3

