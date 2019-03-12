Return-Path: <SRS0=9Upc=RP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2268C43381
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 15:06:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7B7B62147C
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 15:06:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726910AbfCLPGZ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Mar 2019 11:06:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35678 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726556AbfCLPGY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Mar 2019 11:06:24 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C8D43307CB3B;
        Tue, 12 Mar 2019 15:06:24 +0000 (UTC)
Received: from localhost (unknown [10.43.2.83])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8252127C46;
        Tue, 12 Mar 2019 15:06:21 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     linux-wireless@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [RFC 02/12] mt76: remove rx_page_lock
Date:   Tue, 12 Mar 2019 16:05:56 +0100
Message-Id: <1552403166-3821-3-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1552403166-3821-1-git-send-email-sgruszka@redhat.com>
References: <1552403166-3821-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Tue, 12 Mar 2019 15:06:24 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

We can not run mt76u_alloc_buf() concurently, rx_tasklet is stooped
when mt76u_submit_rx_buffers(). We can remove rx_page_lock.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76.h | 1 -
 drivers/net/wireless/mediatek/mt76/usb.c  | 8 +-------
 2 files changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 3d3f0a5fc426..424f9090680d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -132,7 +132,6 @@ struct mt76_queue {
 	dma_addr_t desc_dma;
 	struct sk_buff *rx_head;
 	struct page_frag_cache rx_page;
-	spinlock_t rx_page_lock;
 };
 
 struct mt76_sw_queue {
diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
index 661a65cb9c35..883e8a2b519f 100644
--- a/drivers/net/wireless/mediatek/mt76/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/usb.c
@@ -292,7 +292,6 @@ static bool mt76u_check_sg(struct mt76_dev *dev)
 	struct urb *urb = buf->urb;
 	int i;
 
-	spin_lock_bh(&q->rx_page_lock);
 	for (i = 0; i < nsgs; i++) {
 		struct page *page;
 		void *data;
@@ -306,7 +305,6 @@ static bool mt76u_check_sg(struct mt76_dev *dev)
 		offset = data - page_address(page);
 		sg_set_page(&urb->sg[i], page, sglen, offset);
 	}
-	spin_unlock_bh(&q->rx_page_lock);
 
 	if (i < nsgs) {
 		int j;
@@ -569,7 +567,6 @@ static int mt76u_alloc_rx(struct mt76_dev *dev)
 	if (!usb->mcu.data)
 		return -ENOMEM;
 
-	spin_lock_init(&q->rx_page_lock);
 	spin_lock_init(&q->lock);
 	q->entry = devm_kcalloc(dev->dev,
 				MT_NUM_RX_ENTRIES, sizeof(*q->entry),
@@ -597,15 +594,12 @@ static void mt76u_free_rx(struct mt76_dev *dev)
 	for (i = 0; i < q->ndesc; i++)
 		mt76u_buf_free(&q->entry[i].ubuf);
 
-	spin_lock_bh(&q->rx_page_lock);
 	if (!q->rx_page.va)
-		goto out;
+		return;
 
 	page = virt_to_page(q->rx_page.va);
 	__page_frag_cache_drain(page, q->rx_page.pagecnt_bias);
 	memset(&q->rx_page, 0, sizeof(q->rx_page));
-out:
-	spin_unlock_bh(&q->rx_page_lock);
 }
 
 static void mt76u_stop_rx(struct mt76_dev *dev)
-- 
1.9.3

