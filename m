Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:49965 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752416AbaINJmk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Sep 2014 05:42:40 -0400
Subject: [PATCH 01/10] ath10k: fix parenthesis alignment warning in
 ath10k_htt_rx_alloc()
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Sun, 14 Sep 2014 12:50:00 +0300
Message-ID: <20140914095000.9063.95112.stgit@x230> (sfid-20140914_114242_864586_849E540C)
In-Reply-To: <20140914094728.9063.32593.stgit@x230>
References: <20140914094728.9063.32593.stgit@x230>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixes checkpatch warning:

ath10k/htt_rx.c:519: CHECK: Alignment should match open parenthesis

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 57e1fe77602b..7313bd16a4b3 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -488,6 +488,7 @@ int ath10k_htt_rx_alloc(struct ath10k_htt *htt)
 	struct ath10k *ar = htt->ar;
 	dma_addr_t paddr;
 	void *vaddr;
+	size_t size;
 	struct timer_list *timer = &htt->rx_ring.refill_retry_timer;
 
 	htt->rx_ring.size = ath10k_htt_rx_ring_size(htt);
@@ -515,9 +516,9 @@ int ath10k_htt_rx_alloc(struct ath10k_htt *htt)
 	if (!htt->rx_ring.netbufs_ring)
 		goto err_netbuf;
 
-	vaddr = dma_alloc_coherent(htt->ar->dev,
-		   (htt->rx_ring.size * sizeof(htt->rx_ring.paddrs_ring)),
-		   &paddr, GFP_DMA);
+	size = htt->rx_ring.size * sizeof(htt->rx_ring.paddrs_ring);
+
+	vaddr = dma_alloc_coherent(htt->ar->dev, size, &paddr, GFP_DMA);
 	if (!vaddr)
 		goto err_dma_ring;
 

