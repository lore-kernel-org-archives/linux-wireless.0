Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:35384 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727113AbeHYOTz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 25 Aug 2018 10:19:55 -0400
Received: by mail-wm0-f66.google.com with SMTP id o18-v6so3864788wmc.0
        for <linux-wireless@vger.kernel.org>; Sat, 25 Aug 2018 03:41:20 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: sgruszka@redhat.com, linux-wireless@vger.kernel.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH 16/16] mt76x0: remove unused routines for usb_buff alloc/free
Date: Sat, 25 Aug 2018 12:40:56 +0200
Message-Id: <20180825104056.9130-17-lorenzo.bianconi@redhat.com> (sfid-20180825_124131_609995_8E80BB7A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove the following unused routines for usb buffer
allocation/free/submit:
- mt76x0_usb_alloc_buf
- mt76x0_usb_free_buf
- mt76x0_usb_submit_buf

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../net/wireless/mediatek/mt76/mt76x0/usb.c   | 47 -------------------
 .../net/wireless/mediatek/mt76/mt76x0/usb.h   |  7 ---
 2 files changed, 54 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
index e2b55d0d31da..4e71a13ff54c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
@@ -46,53 +46,6 @@ static struct usb_device_id mt76x0_device_table[] = {
 	{ 0, }
 };
 
-bool mt76x0_usb_alloc_buf(struct mt76x0_dev *dev, size_t len,
-			   struct mt76x0_dma_buf *buf)
-{
-	struct usb_device *usb_dev = mt76x0_to_usb_dev(dev);
-
-	buf->len = len;
-	buf->urb = usb_alloc_urb(0, GFP_KERNEL);
-	buf->buf = usb_alloc_coherent(usb_dev, buf->len, GFP_KERNEL, &buf->dma);
-
-	return !buf->urb || !buf->buf;
-}
-
-void mt76x0_usb_free_buf(struct mt76x0_dev *dev, struct mt76x0_dma_buf *buf)
-{
-	struct usb_device *usb_dev = mt76x0_to_usb_dev(dev);
-
-	usb_free_coherent(usb_dev, buf->len, buf->buf, buf->dma);
-	usb_free_urb(buf->urb);
-}
-
-int mt76x0_usb_submit_buf(struct mt76x0_dev *dev, int dir, int ep_idx,
-			   struct mt76x0_dma_buf *buf, gfp_t gfp,
-			   usb_complete_t complete_fn, void *context)
-{
-	struct usb_device *usb_dev = mt76x0_to_usb_dev(dev);
-	struct mt76_usb *usb = &dev->mt76.usb;
-	unsigned pipe;
-	int ret;
-
-	if (dir == USB_DIR_IN)
-		pipe = usb_rcvbulkpipe(usb_dev, usb->in_ep[ep_idx]);
-	else
-		pipe = usb_sndbulkpipe(usb_dev, usb->out_ep[ep_idx]);
-
-	usb_fill_bulk_urb(buf->urb, usb_dev, pipe, buf->buf, buf->len,
-			  complete_fn, context);
-	buf->urb->transfer_dma = buf->dma;
-	buf->urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
-
-	trace_mt76x0_submit_urb(&dev->mt76, buf->urb);
-	ret = usb_submit_urb(buf->urb, gfp);
-	if (ret)
-		dev_err(dev->mt76.dev, "Error: submit URB dir:%d ep:%d failed:%d\n",
-			dir, ep_idx, ret);
-	return ret;
-}
-
 void mt76x0_addr_wr(struct mt76x0_dev *dev, const u32 offset, const u8 *addr)
 {
 	mt76_wr(dev, offset, get_unaligned_le32(addr));
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.h b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.h
index b4a5d98416ab..7bd075319f5b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.h
@@ -43,11 +43,4 @@ static inline bool mt76x0_urb_has_error(struct urb *urb)
 		urb->status != -ESHUTDOWN;
 }
 
-bool mt76x0_usb_alloc_buf(struct mt76x0_dev *dev, size_t len,
-			   struct mt76x0_dma_buf *buf);
-void mt76x0_usb_free_buf(struct mt76x0_dev *dev, struct mt76x0_dma_buf *buf);
-int mt76x0_usb_submit_buf(struct mt76x0_dev *dev, int dir, int ep_idx,
-			   struct mt76x0_dma_buf *buf, gfp_t gfp,
-			   usb_complete_t complete_fn, void *context);
-
 #endif
-- 
2.18.0
