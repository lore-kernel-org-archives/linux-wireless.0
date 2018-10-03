Return-Path: <SRS0=nRo4=MP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 738E9C00449
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 09:17:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 42C9120684
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 09:17:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 42C9120684
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727587AbeJCQEt (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Oct 2018 12:04:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42536 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727188AbeJCQEt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Oct 2018 12:04:49 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 26FCF3002710;
        Wed,  3 Oct 2018 09:17:18 +0000 (UTC)
Received: from localhost (ovpn-204-105.brq.redhat.com [10.40.204.105])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9F12A60C46;
        Wed,  3 Oct 2018 09:17:15 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        linux-wireless@vger.kernel.org
Subject: [RFC 2/2] mt76: make frag_cache global per cpu structure
Date:   Wed,  3 Oct 2018 11:17:10 +0200
Message-Id: <1538558230-16576-2-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1538558230-16576-1-git-send-email-sgruszka@redhat.com>
References: <1538558230-16576-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Wed, 03 Oct 2018 09:17:18 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Make mt76 frag cache similar to netdev frag cache. This should
make frag allocation safe regarding concurrent access and also
be more efficient since we will use pages that most likely are
hot on particular cpu.

And we don't need to clean up the cache up during device removal.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/dma.c  |  2 +-
 drivers/net/wireless/mediatek/mt76/usb.c  | 10 +---------
 drivers/net/wireless/mediatek/mt76/util.c | 16 ++++++++++++++++
 drivers/net/wireless/mediatek/mt76/util.h |  1 +
 4 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/dma.c b/drivers/net/wireless/mediatek/mt76/dma.c
index f7fbd7016403..59453a7781c5 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/dma.c
@@ -328,7 +328,7 @@ mt76_dma_rx_fill(struct mt76_dev *dev, struct mt76_queue *q, bool napi)
 	while (q->queued < q->ndesc - 1) {
 		struct mt76_queue_buf qbuf;
 
-		buf = page_frag_alloc(&q->rx_page, q->buf_size, GFP_ATOMIC);
+		buf = mt76_alloc_frag(q->buf_size);
 		if (!buf)
 			break;
 
diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
index a103b77ae8c4..a892f59a32d8 100644
--- a/drivers/net/wireless/mediatek/mt76/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/usb.c
@@ -276,7 +276,6 @@ static int
 mt76u_fill_rx_sg(struct mt76_dev *dev, struct mt76u_buf *buf,
 		 int nsgs, int len, int sglen)
 {
-	struct mt76_queue *q = &dev->q_rx[MT_RXQ_MAIN];
 	struct urb *urb = buf->urb;
 	int i;
 
@@ -285,7 +284,7 @@ mt76u_fill_rx_sg(struct mt76_dev *dev, struct mt76u_buf *buf,
 		void *data;
 		int offset;
 
-		data = page_frag_alloc(&q->rx_page, len, GFP_ATOMIC);
+		data = mt76_alloc_frag(len);
 		if (!data)
 			break;
 
@@ -557,13 +556,6 @@ static void mt76u_free_rx(struct mt76_dev *dev)
 
 	for (i = 0; i < q->ndesc; i++)
 		mt76u_buf_free(&q->entry[i].ubuf);
-
-	if (!q->rx_page.va)
-		return;
-
-	page = virt_to_page(q->rx_page.va);
-	__page_frag_cache_drain(page, q->rx_page.pagecnt_bias);
-	memset(&q->rx_page, 0, sizeof(q->rx_page));
 }
 
 static void mt76u_stop_rx(struct mt76_dev *dev)
diff --git a/drivers/net/wireless/mediatek/mt76/util.c b/drivers/net/wireless/mediatek/mt76/util.c
index 0c35b8db58cd..def2a1b841b9 100644
--- a/drivers/net/wireless/mediatek/mt76/util.c
+++ b/drivers/net/wireless/mediatek/mt76/util.c
@@ -75,4 +75,20 @@ int mt76_wcid_alloc(unsigned long *mask, int size)
 }
 EXPORT_SYMBOL_GPL(mt76_wcid_alloc);
 
+static DEFINE_PER_CPU(struct page_frag_cache, mt76_frag_cache);
+
+void *mt76_alloc_frag(unsigned int fragsz)
+{
+	struct page_frag_cache *fc;
+	unsigned long flags;
+	void *data;
+
+	local_irq_save(flags);
+	fc = this_cpu_ptr(&mt76_frag_cache);
+	data = page_frag_alloc(fc, fragsz, GFP_ATOMIC);
+	local_irq_restore(flags);
+	return data;
+}
+EXPORT_SYMBOL_GPL(mt76_alloc_frag);
+
 MODULE_LICENSE("Dual BSD/GPL");
diff --git a/drivers/net/wireless/mediatek/mt76/util.h b/drivers/net/wireless/mediatek/mt76/util.h
index 018d475504a2..6cb6c0e993c4 100644
--- a/drivers/net/wireless/mediatek/mt76/util.h
+++ b/drivers/net/wireless/mediatek/mt76/util.h
@@ -41,4 +41,5 @@ mt76_skb_set_moredata(struct sk_buff *skb, bool enable)
 		hdr->frame_control &= ~cpu_to_le16(IEEE80211_FCTL_MOREDATA);
 }
 
+void *mt76_alloc_frag(unsigned int fragsz);
 #endif
-- 
2.7.5

