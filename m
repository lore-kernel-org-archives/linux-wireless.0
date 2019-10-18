Return-Path: <SRS0=fVU0=YL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA1BCCA9EA0
	for <linux-wireless@archiver.kernel.org>; Fri, 18 Oct 2019 22:23:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8DA3F205C9
	for <linux-wireless@archiver.kernel.org>; Fri, 18 Oct 2019 22:23:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1571437391;
	bh=atw4UZaQccT3eKFCQyThccWL3IxyuknKXsMHVAawv3s=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=FX91Oa8EdW2jTMi9M6esTlkgqbvfMl5MgfsTZm48SXnzI/bULNZbCg6cnv626U5cT
	 rbg8+cCodRx6fXcINTYwwyeDrClXZd2If6xj0gT2BNdMvN+oqHttYtRPZRne67IrI5
	 BBiF30l4sjh0a0NzpjluT+MjT9BqQsTbbUhX4rvg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405090AbfJRWXK (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 18 Oct 2019 18:23:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:37340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729482AbfJRWF2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Oct 2019 18:05:28 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E98A222C2;
        Fri, 18 Oct 2019 22:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571436327;
        bh=atw4UZaQccT3eKFCQyThccWL3IxyuknKXsMHVAawv3s=;
        h=From:To:Cc:Subject:Date:From;
        b=lTMh4D0/HdLF9jI+3lfVdMWmbzThp3AiXxBxqp/ZJ3Uj7lCAhqDdJR4s//oIyXkY6
         vPSnwpqVBnrV/4KzwG1ZXF787SsJcy0h2C+d7PPYcqE+gY5xD23Ht7S4zU/WO4IZWd
         pjEGUQyjGRoHPLfUi7SlWOyUr9jsF9MJYAapcoY8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ahmad Masri <amasri@codeaurora.org>,
        Maya Erez <merez@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 001/100] wil6210: fix freeing of rx buffers in EDMA mode
Date:   Fri, 18 Oct 2019 18:03:46 -0400
Message-Id: <20191018220525.9042-1-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ahmad Masri <amasri@codeaurora.org>

[ Upstream commit 6470f31927b46846d957628b719dcfda05446664 ]

After being associated with some EDMA rx traffic, upon "down" driver
doesn't free all skbs in the rx ring.
Modify wil_move_all_rx_buff_to_free_list to loop on active list of rx
buffers, unmap the physical memory and free the skb.

Signed-off-by: Ahmad Masri <amasri@codeaurora.org>
Signed-off-by: Maya Erez <merez@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/wil6210/txrx_edma.c | 44 +++++++-------------
 1 file changed, 14 insertions(+), 30 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/txrx_edma.c b/drivers/net/wireless/ath/wil6210/txrx_edma.c
index 3e7fc2983cbb3..409a6fa8b6c8f 100644
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
2.20.1

