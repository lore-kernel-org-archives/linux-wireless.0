Return-Path: <SRS0=7415=NL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1980ECDE47
	for <linux-wireless@archiver.kernel.org>; Wed, 31 Oct 2018 08:58:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 835A620685
	for <linux-wireless@archiver.kernel.org>; Wed, 31 Oct 2018 08:58:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 835A620685
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727791AbeJaR4D (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 31 Oct 2018 13:56:03 -0400
Received: from alexa-out-ams-01.qualcomm.com ([185.23.61.162]:23736 "EHLO
        alexa-out-ams-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727735AbeJaR4C (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 31 Oct 2018 13:56:02 -0400
X-IronPort-AV: E=Sophos;i="5.54,447,1534802400"; 
   d="scan'208";a="1418135"
Received: from ironmsg01-ams.qualcomm.com ([10.251.56.2])
  by alexa-out-ams-01.qualcomm.com with ESMTP; 31 Oct 2018 09:52:36 +0100
X-IronPort-AV: E=McAfee;i="5900,7806,9062"; a="6147935"
Received: from lx-merez1.mea.qualcomm.com ([10.18.173.103])
  by ironmsg01-ams.qualcomm.com with ESMTP; 31 Oct 2018 09:52:35 +0100
From:   Maya Erez <merez@codeaurora.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Ahmad Masri <amasri@codeaurora.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        Maya Erez <merez@codeaurora.org>
Subject: [PATCH 15/16] wil6210: fix freeing of rx buffers in EDMA mode
Date:   Wed, 31 Oct 2018 10:52:23 +0200
Message-Id: <1540975944-30576-16-git-send-email-merez@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1540975944-30576-1-git-send-email-merez@codeaurora.org>
References: <1540975944-30576-1-git-send-email-merez@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ahmad Masri <amasri@codeaurora.org>

After being associated with some EDMA rx traffic, upon "down" driver
doesn't free all skbs in the rx ring.
Modify wil_move_all_rx_buff_to_free_list to loop on active list of rx
buffers, unmap the physical memory and free the skb.

Signed-off-by: Ahmad Masri <amasri@codeaurora.org>
Signed-off-by: Maya Erez <merez@codeaurora.org>
---
 drivers/net/wireless/ath/wil6210/txrx_edma.c | 44 +++++++++-------------------
 1 file changed, 14 insertions(+), 30 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/txrx_edma.c b/drivers/net/wireless/ath/wil6210/txrx_edma.c
index 686ba34..05a8348 100644
--- a/drivers/net/wireless/ath/wil6210/txrx_edma.c
+++ b/drivers/net/wireless/ath/wil6210/txrx_edma.c
@@ -234,9 +234,10 @@ static int wil_rx_refill_edma(struct wil6210_priv *wil)
 	struct wil_ring *ring = &wil->ring_rx;
 	u32 next_head;
 	int rc = 0;
-	u32 swtail = *ring->edma_rx_swtail.va;
+	ring->swtail = *ring->edma_rx_swtail.va;
 
-	for (; next_head = wil_ring_next_head(ring), (next_head != swtail);
+	for (; next_head = wil_ring_next_head(ring),
+	     (next_head != ring->swtail);
 	     ring->swhead = next_head) {
 		rc = wil_ring_alloc_skb_edma(wil, ring, ring->swhead);
 		if (unlikely(rc)) {
@@ -264,43 +265,26 @@ static void wil_move_all_rx_buff_to_free_list(struct wil6210_priv *wil,
 					      struct wil_ring *ring)
 {
 	struct device *dev = wil_to_dev(wil);
-	u32 next_tail;
-	u32 swhead = (ring->swhead + 1) % ring->size;
+	struct list_head *active = &wil->rx_buff_mgmt.active;
 	dma_addr_t pa;
-	u16 dmalen;
 
-	for (; next_tail = wil_ring_next_tail(ring), (next_tail != swhead);
-	     ring->swtail = next_tail) {
-		struct wil_rx_enhanced_desc dd, *d = &dd;
-		struct wil_rx_enhanced_desc *_d =
-			(struct wil_rx_enhanced_desc *)
-			&ring->va[ring->swtail].rx.enhanced;
-		struct sk_buff *skb;
-		u16 buff_id;
+	while (!list_empty(active)) {
+		struct wil_rx_buff *rx_buff =
+			list_first_entry(active, struct wil_rx_buff, list);
+		struct sk_buff *skb = rx_buff->skb;
 
-		*d = *_d;
-
-		/* Extract the SKB from the rx_buff management array */
-		buff_id = __le16_to_cpu(d->mac.buff_id);
-		if (buff_id >= wil->rx_buff_mgmt.size) {
-			wil_err(wil, "invalid buff_id %d\n", buff_id);
-			continue;
-		}
-		skb = wil->rx_buff_mgmt.buff_arr[buff_id].skb;
-		wil->rx_buff_mgmt.buff_arr[buff_id].skb = NULL;
 		if (unlikely(!skb)) {
-			wil_err(wil, "No Rx skb at buff_id %d\n", buff_id);
+			wil_err(wil, "No Rx skb at buff_id %d\n", rx_buff->id);
 		} else {
-			pa = wil_rx_desc_get_addr_edma(&d->dma);
-			dmalen = le16_to_cpu(d->dma.length);
-			dma_unmap_single(dev, pa, dmalen, DMA_FROM_DEVICE);
-
+			rx_buff->skb = NULL;
+			memcpy(&pa, skb->cb, sizeof(pa));
+			dma_unmap_single(dev, pa, wil->rx_buf_len,
+					 DMA_FROM_DEVICE);
 			kfree_skb(skb);
 		}
 
 		/* Move the buffer from the active to the free list */
-		list_move(&wil->rx_buff_mgmt.buff_arr[buff_id].list,
-			  &wil->rx_buff_mgmt.free);
+		list_move(&rx_buff->list, &wil->rx_buff_mgmt.free);
 	}
 }
 
-- 
1.9.1

