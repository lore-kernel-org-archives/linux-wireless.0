Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:38000 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753598AbeDJNya (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 10 Apr 2018 09:54:30 -0400
From: Jia-Ju Bai <baijiaju1990@gmail.com>
To: Larry.Finger@lwfinger.net, kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] net: wireless: b43legacy: Replace GFP_ATOMIC with GFP_KERNEL in dma_tx_fragment
Date: Tue, 10 Apr 2018 21:54:19 +0800
Message-Id: <1523368459-32128-1-git-send-email-baijiaju1990@gmail.com> (sfid-20180410_155516_697681_9CCB3A9C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

dma_tx_fragment() is never called in atomic context.

dma_tx_fragment() is only called by b43legacy_dma_tx(), which is 
only called by b43legacy_tx_work().
b43legacy_tx_work() is only set a parameter of INIT_WORK() in 
b43legacy_wireless_init().

Despite never getting called from atomic context,
dma_tx_fragment() calls alloc_skb() with GFP_ATOMIC,
which does not sleep for allocation.
GFP_ATOMIC is not necessary and can be replaced with GFP_KERNEL,
which can sleep and improve the possibility of sucessful allocation.

This is found by a static analysis tool named DCNS written by myself.
And I also manually check it.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 drivers/net/wireless/broadcom/b43legacy/dma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/b43legacy/dma.c b/drivers/net/wireless/broadcom/b43legacy/dma.c
index cfa617d..2f0c64c 100644
--- a/drivers/net/wireless/broadcom/b43legacy/dma.c
+++ b/drivers/net/wireless/broadcom/b43legacy/dma.c
@@ -1064,7 +1064,7 @@ static int dma_tx_fragment(struct b43legacy_dmaring *ring,
 	meta->dmaaddr = map_descbuffer(ring, skb->data, skb->len, 1);
 	/* create a bounce buffer in zone_dma on mapping failure. */
 	if (b43legacy_dma_mapping_error(ring, meta->dmaaddr, skb->len, 1)) {
-		bounce_skb = alloc_skb(skb->len, GFP_ATOMIC | GFP_DMA);
+		bounce_skb = alloc_skb(skb->len, GFP_KERNEL | GFP_DMA);
 		if (!bounce_skb) {
 			ring->current_slot = old_top_slot;
 			ring->used_slots = old_used_slots;
-- 
1.9.1
