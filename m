Return-Path: <SRS0=nRo4=MP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0D6FC00449
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 09:17:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6805E20684
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 09:17:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6805E20684
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727579AbeJCQEp (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Oct 2018 12:04:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53244 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727188AbeJCQEp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Oct 2018 12:04:45 -0400
Received: from smtp.corp.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.26])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 477ED3082128;
        Wed,  3 Oct 2018 09:17:14 +0000 (UTC)
Received: from localhost (ovpn-204-105.brq.redhat.com [10.40.204.105])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B956B30912F5;
        Wed,  3 Oct 2018 09:17:11 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        linux-wireless@vger.kernel.org
Subject: [RFC 1/2] mt76: remove rx_page_lock
Date:   Wed,  3 Oct 2018 11:17:09 +0200
Message-Id: <1538558230-16576-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.26
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Wed, 03 Oct 2018 09:17:14 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Extra serializaion for protecting q->rx_page is not needed,
we stop rx_tasklet before we nulify it in mt76u_free_rx().

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76.h | 1 -
 drivers/net/wireless/mediatek/mt76/usb.c  | 8 +-------
 2 files changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index f2dd4d87e355..2ab524c8f14f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -122,7 +122,6 @@ struct mt76_queue {
 	dma_addr_t desc_dma;
 	struct sk_buff *rx_head;
 	struct page_frag_cache rx_page;
-	spinlock_t rx_page_lock;
 };
 
 struct mt76_mcu_ops {
diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
index 6b643ea701e3..a103b77ae8c4 100644
--- a/drivers/net/wireless/mediatek/mt76/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/usb.c
@@ -280,7 +280,6 @@ mt76u_fill_rx_sg(struct mt76_dev *dev, struct mt76u_buf *buf,
 	struct urb *urb = buf->urb;
 	int i;
 
-	spin_lock_bh(&q->rx_page_lock);
 	for (i = 0; i < nsgs; i++) {
 		struct page *page;
 		void *data;
@@ -294,7 +293,6 @@ mt76u_fill_rx_sg(struct mt76_dev *dev, struct mt76u_buf *buf,
 		offset = data - page_address(page);
 		sg_set_page(&urb->sg[i], page, sglen, offset);
 	}
-	spin_unlock_bh(&q->rx_page_lock);
 
 	if (i < nsgs) {
 		int j;
@@ -523,7 +521,6 @@ static int mt76u_alloc_rx(struct mt76_dev *dev)
 	struct mt76_queue *q = &dev->q_rx[MT_RXQ_MAIN];
 	int i, err, nsgs;
 
-	spin_lock_init(&q->rx_page_lock);
 	spin_lock_init(&q->lock);
 	q->entry = devm_kzalloc(dev->dev,
 				MT_NUM_RX_ENTRIES * sizeof(*q->entry),
@@ -561,15 +558,12 @@ static void mt76u_free_rx(struct mt76_dev *dev)
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
2.7.5

