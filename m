Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f180.google.com ([209.85.215.180]:52196 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445AbaBQJiE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Feb 2014 04:38:04 -0500
Received: by mail-ea0-f180.google.com with SMTP id o10so7099720eaj.39
        for <linux-wireless@vger.kernel.org>; Mon, 17 Feb 2014 01:38:02 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [RFC/RFT 7/7] ath10k: minimize coherent dma accesses
Date: Mon, 17 Feb 2014 10:32:43 +0100
Message-Id: <1392629563-31046-8-git-send-email-michal.kazior@tieto.com> (sfid-20140217_103820_611095_E4B067F9)
In-Reply-To: <1392629563-31046-1-git-send-email-michal.kazior@tieto.com>
References: <1392629563-31046-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It doesn't make much sense to calculate the ring
size fill count because it already is memoized in
a separate variable.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index d3051e3..6fe5ecc 100644
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
@@ -276,8 +270,11 @@ static inline struct sk_buff *ath10k_htt_rx_netbuf_pop(struct ath10k_htt *htt)
 
 	lockdep_assert_held(&htt->rx_ring.lock);
 
-	if (ath10k_htt_rx_ring_elems(htt) == 0)
-		ath10k_warn("htt rx ring is empty!\n");
+	if (htt->rx_ring.fill_cnt == 0) {
+		ath10k_warn("tried to pop sk_buff from an empty rx ring\n");
+		spin_unlock_bh(&htt->rx_ring.lock);
+		return NULL;
+	}
 
 	idx = htt->rx_ring.sw_rd_idx.msdu_payld;
 	msdu = htt->rx_ring.netbufs_ring[idx];
@@ -312,9 +309,6 @@ static int ath10k_htt_rx_amsdu_pop(struct ath10k_htt *htt,
 
 	lockdep_assert_held(&htt->rx_ring.lock);
 
-	if (ath10k_htt_rx_ring_elems(htt) == 0)
-		ath10k_warn("htt rx ring is empty!\n");
-
 	if (htt->rx_confused) {
 		ath10k_warn("htt is confused. refusing rx\n");
 		return 0;
-- 
1.8.5.3

