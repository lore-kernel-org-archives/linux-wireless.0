Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr1-f65.google.com ([209.85.221.65]:41658 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728415AbeIXUPf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Sep 2018 16:15:35 -0400
Received: by mail-wr1-f65.google.com with SMTP id j15-v6so15766326wrt.8
        for <linux-wireless@vger.kernel.org>; Mon, 24 Sep 2018 07:13:14 -0700 (PDT)
Date: Mon, 24 Sep 2018 16:13:11 +0200
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Felix Fietkau <nbd@nbd.name>, Sid Hayn <sidhayn@gmail.com>,
        linux-wireless@vger.kernel.org
Subject: Re: mt76x0 random crashes after c12128ce44b0
Message-ID: <20180924141311.GI783@localhost.localdomain> (sfid-20180924_161320_114996_62AA5ACF)
References: <20180924140701.GA2089@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180924140701.GA2089@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sep 24, Stanislaw Gruszka wrote:
> Hi, after -next commit: 
> 
> commit c12128ce44b04a987c4eb0f733cc99c4dd50d45a
> Author: Felix Fietkau <nbd@nbd.name>
> Date:   Fri Jul 13 16:26:15 2018 +0200
> 
>     mt76: use a per rx queue page fragment cache
> 
> I have random crashes when load or unlod mt76x0u module.
> 

Hi Stanislaw,

could you please try following patch (I am not 100% sure it fixes the issue)

Regards,
Lorenzo

diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 15a5b0c89d86..8031360a6592 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -122,6 +122,7 @@ struct mt76_queue {
 	dma_addr_t desc_dma;
 	struct sk_buff *rx_head;
 	struct page_frag_cache rx_page;
+	spinlock_t rx_page_lock;
 };
 
 struct mt76_mcu_ops {
diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
index b3edd645b3c0..eaa10c814e39 100644
--- a/drivers/net/wireless/mediatek/mt76/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/usb.c
@@ -279,6 +279,7 @@ mt76u_fill_rx_sg(struct mt76_dev *dev, struct mt76u_buf *buf,
 	struct urb *urb = buf->urb;
 	int i;
 
+	spin_lock_bh(&q->rx_page_lock);
 	for (i = 0; i < nsgs; i++) {
 		struct page *page;
 		void *data;
@@ -292,6 +293,7 @@ mt76u_fill_rx_sg(struct mt76_dev *dev, struct mt76u_buf *buf,
 		offset = data - page_address(page);
 		sg_set_page(&urb->sg[i], page, sglen, offset);
 	}
+	spin_unlock_bh(&q->rx_page_lock);
 
 	if (i < nsgs) {
 		int j;
@@ -520,6 +522,7 @@ static int mt76u_alloc_rx(struct mt76_dev *dev)
 	struct mt76_queue *q = &dev->q_rx[MT_RXQ_MAIN];
 	int i, err, nsgs;
 
+	spin_lock_init(&q->rx_page_lock);
 	spin_lock_init(&q->lock);
 	q->entry = devm_kzalloc(dev->dev,
 				MT_NUM_RX_ENTRIES * sizeof(*q->entry),
@@ -557,12 +560,15 @@ static void mt76u_free_rx(struct mt76_dev *dev)
 	for (i = 0; i < q->ndesc; i++)
 		mt76u_buf_free(&q->entry[i].ubuf);
 
+	spin_lock_bh(&q->rx_page_lock);
 	if (!q->rx_page.va)
-		return;
+		goto out;
 
 	page = virt_to_page(q->rx_page.va);
 	__page_frag_cache_drain(page, q->rx_page.pagecnt_bias);
 	memset(&q->rx_page, 0, sizeof(q->rx_page));
+out:
+	spin_unlock_bh(&q->rx_page_lock);
 }
 
 static void mt76u_stop_rx(struct mt76_dev *dev)
-- 
2.17.1
