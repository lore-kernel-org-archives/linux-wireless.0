Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr1-f67.google.com ([209.85.221.67]:32794 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726842AbeHYOTn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 25 Aug 2018 10:19:43 -0400
Received: by mail-wr1-f67.google.com with SMTP id v90-v6so9469960wrc.0
        for <linux-wireless@vger.kernel.org>; Sat, 25 Aug 2018 03:41:07 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: sgruszka@redhat.com, linux-wireless@vger.kernel.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH 05/16] mt76x0: use mt76u_init for bus initialization
Date: Sat, 25 Aug 2018 12:40:45 +0200
Message-Id: <20180825104056.9130-6-lorenzo.bianconi@redhat.com> (sfid-20180825_124113_444396_C9B763C1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use mt76u_init utility routine for usb initialization.
Moreover remove following unused routines:
- mt76x0_rr
- mt76x0_wr
- mt76x0_rmw
- mt76x0_wr_copy
- mt76x0_assign_pipes

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../net/wireless/mediatek/mt76/mt76x0/dma.c   |   6 +-
 .../net/wireless/mediatek/mt76/mt76x0/init.c  |   3 +-
 .../net/wireless/mediatek/mt76/mt76x0/mcu.c   |   3 +-
 .../net/wireless/mediatek/mt76/mt76x0/usb.c   | 109 +-----------------
 4 files changed, 12 insertions(+), 109 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/dma.c b/drivers/net/wireless/mediatek/mt76/mt76x0/dma.c
index e2efb430419b..715c3734a307 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/dma.c
@@ -279,7 +279,8 @@ static int mt76x0_dma_submit_tx(struct mt76x0_dev *dev,
 				 struct sk_buff *skb, u8 ep)
 {
 	struct usb_device *usb_dev = mt76x0_to_usb_dev(dev);
-	unsigned snd_pipe = usb_sndbulkpipe(usb_dev, dev->out_ep[ep]);
+	struct mt76_usb *usb = &dev->mt76.usb;
+	unsigned snd_pipe = usb_sndbulkpipe(usb_dev, usb->out_ep[ep]);
 	struct mt76x0_dma_buf_tx *e;
 	struct mt76x0_tx_queue *q = &dev->tx_q[ep];
 	unsigned long flags;
@@ -375,11 +376,12 @@ static int mt76x0_submit_rx_buf(struct mt76x0_dev *dev,
 				 struct mt76x0_dma_buf_rx *e, gfp_t gfp)
 {
 	struct usb_device *usb_dev = mt76x0_to_usb_dev(dev);
+	struct mt76_usb *usb = &dev->mt76.usb;
 	u8 *buf = page_address(e->p);
 	unsigned pipe;
 	int ret;
 
-	pipe = usb_rcvbulkpipe(usb_dev, dev->in_ep[MT_EP_IN_PKT_RX]);
+	pipe = usb_rcvbulkpipe(usb_dev, usb->in_ep[MT_EP_IN_PKT_RX]);
 
 	usb_fill_bulk_urb(e->urb, usb_dev, pipe, buf, MT_RX_URB_SIZE,
 			  mt76x0_complete_rx, dev);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
index d020df859e30..48d7eb1599d7 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
@@ -109,6 +109,7 @@ static void mt76x0_reset_csr_bbp(struct mt76x0_dev *dev)
 
 static void mt76x0_init_usb_dma(struct mt76x0_dev *dev)
 {
+	struct mt76_usb *usb = &dev->mt76.usb;
 	u32 val;
 
 	val = mt76_rr(dev, MT_USB_DMA_CFG);
@@ -117,7 +118,7 @@ static void mt76x0_init_usb_dma(struct mt76x0_dev *dev)
 	       FIELD_PREP(MT_USB_DMA_CFG_RX_BULK_AGG_LMT, MT_USB_AGGR_SIZE_LIMIT) |
 	       MT_USB_DMA_CFG_RX_BULK_EN |
 	       MT_USB_DMA_CFG_TX_BULK_EN;
-	if (dev->in_max_packet == 512)
+	if (usb->in_max_packet == 512)
 		val |= MT_USB_DMA_CFG_RX_BULK_AGG_EN;
 	mt76_wr(dev, MT_USB_DMA_CFG, val);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mcu.c b/drivers/net/wireless/mediatek/mt76/mt76x0/mcu.c
index 96e04afc73f4..75768ebf8b30 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mcu.c
@@ -154,8 +154,9 @@ __mt76x0_mcu_msg_send(struct mt76x0_dev *dev, struct sk_buff *skb,
 		      enum mcu_cmd cmd, bool wait_resp)
 {
 	struct usb_device *usb_dev = mt76x0_to_usb_dev(dev);
+	struct mt76_usb *usb = &dev->mt76.usb;
 	unsigned cmd_pipe = usb_sndbulkpipe(usb_dev,
-					    dev->out_ep[MT_EP_OUT_INBAND_CMD]);
+					    usb->out_ep[MT_EP_OUT_INBAND_CMD]);
 	int sent, ret;
 	u8 seq = 0;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
index d535012c506e..09e7f9590f01 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
@@ -71,13 +71,14 @@ int mt76x0_usb_submit_buf(struct mt76x0_dev *dev, int dir, int ep_idx,
 			   usb_complete_t complete_fn, void *context)
 {
 	struct usb_device *usb_dev = mt76x0_to_usb_dev(dev);
+	struct mt76_usb *usb = &dev->mt76.usb;
 	unsigned pipe;
 	int ret;
 
 	if (dir == USB_DIR_IN)
-		pipe = usb_rcvbulkpipe(usb_dev, dev->in_ep[ep_idx]);
+		pipe = usb_rcvbulkpipe(usb_dev, usb->in_ep[ep_idx]);
 	else
-		pipe = usb_sndbulkpipe(usb_dev, dev->out_ep[ep_idx]);
+		pipe = usb_sndbulkpipe(usb_dev, usb->out_ep[ep_idx]);
 
 	usb_fill_bulk_urb(buf->urb, usb_dev, pipe, buf->buf, buf->len,
 			  complete_fn, context);
@@ -136,30 +137,6 @@ void mt76x0_vendor_reset(struct mt76x0_dev *dev)
 			      MT_VEND_DEV_MODE_RESET, 0, NULL, 0);
 }
 
-static u32 mt76x0_rr(struct mt76_dev *dev, u32 offset)
-{
-	struct mt76x0_dev *mdev = (struct mt76x0_dev *) dev;
-	int ret;
-	u32 val = ~0;
-
-	WARN_ONCE(offset > USHRT_MAX, "read high off:%08x", offset);
-
-	mutex_lock(&mdev->usb_ctrl_mtx);
-
-	ret = mt76x0_vendor_request((struct mt76x0_dev *)dev, MT_VEND_MULTI_READ, USB_DIR_IN,
-				    0, offset, mdev->data, MT_VEND_BUF);
-	if (ret == MT_VEND_BUF)
-		val = get_unaligned_le32(mdev->data);
-	else if (ret > 0)
-		dev_err(dev->dev, "Error: wrong size read:%d off:%08x\n",
-			ret, offset);
-
-	mutex_unlock(&mdev->usb_ctrl_mtx);
-
-	trace_mt76x0_reg_read(dev, offset, val);
-	return val;
-}
-
 int mt76x0_vendor_single_wr(struct mt76x0_dev *dev, const u8 req,
 			     const u16 offset, const u32 val)
 {
@@ -179,82 +156,12 @@ int mt76x0_vendor_single_wr(struct mt76x0_dev *dev, const u8 req,
 	return ret;
 }
 
-static void mt76x0_wr(struct mt76_dev *dev, u32 offset, u32 val)
-{
-	struct mt76x0_dev *mdev = (struct mt76x0_dev *) dev;
-	int ret;
-
-	WARN_ONCE(offset > USHRT_MAX, "write high off:%08x", offset);
-
-	mutex_lock(&mdev->usb_ctrl_mtx);
-
-	put_unaligned_le32(val, mdev->data);
-	ret = mt76x0_vendor_request(mdev, MT_VEND_MULTI_WRITE, USB_DIR_OUT,
-				    0, offset, mdev->data, MT_VEND_BUF);
-	trace_mt76x0_reg_write(dev, offset, val);
-
-	mutex_unlock(&mdev->usb_ctrl_mtx);
-}
-
-static u32 mt76x0_rmw(struct mt76_dev *dev, u32 offset, u32 mask, u32 val)
-{
-	val |= mt76x0_rr(dev, offset) & ~mask;
-	mt76x0_wr(dev, offset, val);
-	return val;
-}
-
-static void mt76x0_wr_copy(struct mt76_dev *dev, u32 offset,
-			   const void *data, int len)
-{
-	WARN_ONCE(offset & 3, "unaligned write copy off:%08x", offset);
-	WARN_ONCE(len & 3, "short write copy off:%08x", offset);
-
-	mt76x0_burst_write_regs((struct mt76x0_dev *) dev, offset, data, len / 4);
-}
-
 void mt76x0_addr_wr(struct mt76x0_dev *dev, const u32 offset, const u8 *addr)
 {
 	mt76_wr(dev, offset, get_unaligned_le32(addr));
 	mt76_wr(dev, offset + 4, addr[4] | addr[5] << 8);
 }
 
-static int mt76x0_assign_pipes(struct usb_interface *usb_intf,
-				struct mt76x0_dev *dev)
-{
-	struct usb_endpoint_descriptor *ep_desc;
-	struct usb_host_interface *intf_desc = usb_intf->cur_altsetting;
-	unsigned i, ep_i = 0, ep_o = 0;
-
-	BUILD_BUG_ON(sizeof(dev->in_ep) < __MT_EP_IN_MAX);
-	BUILD_BUG_ON(sizeof(dev->out_ep) < __MT_EP_OUT_MAX);
-
-	for (i = 0; i < intf_desc->desc.bNumEndpoints; i++) {
-		ep_desc = &intf_desc->endpoint[i].desc;
-
-		if (usb_endpoint_is_bulk_in(ep_desc) &&
-		    ep_i++ < __MT_EP_IN_MAX) {
-			dev->in_ep[ep_i - 1] = usb_endpoint_num(ep_desc);
-			dev->in_max_packet = usb_endpoint_maxp(ep_desc);
-			/* Note: this is ignored by usb sub-system but vendor
-			 *	 code does it. We can drop this at some point.
-			 */
-			dev->in_ep[ep_i - 1] |= USB_DIR_IN;
-		} else if (usb_endpoint_is_bulk_out(ep_desc) &&
-			   ep_o++ < __MT_EP_OUT_MAX) {
-			dev->out_ep[ep_o - 1] = usb_endpoint_num(ep_desc);
-			dev->out_max_packet = usb_endpoint_maxp(ep_desc);
-		}
-	}
-
-	if (ep_i != __MT_EP_IN_MAX || ep_o != __MT_EP_OUT_MAX) {
-		dev_err(dev->mt76.dev, "Error: wrong pipe number in:%d out:%d\n",
-			ep_i, ep_o);
-		return -EINVAL;
-	}
-
-	return 0;
-}
-
 static int mt76x0_probe(struct usb_interface *usb_intf,
 			 const struct usb_device_id *id)
 {
@@ -262,12 +169,6 @@ static int mt76x0_probe(struct usb_interface *usb_intf,
 	struct mt76x0_dev *dev;
 	u32 asic_rev, mac_rev;
 	int ret;
-	static const struct mt76_bus_ops usb_ops = {
-		.rr = mt76x0_rr,
-		.wr = mt76x0_wr,
-		.rmw = mt76x0_rmw,
-		.copy = mt76x0_wr_copy,
-	};
 
 	dev = mt76x0_alloc_device(&usb_intf->dev);
 	if (!dev)
@@ -278,9 +179,7 @@ static int mt76x0_probe(struct usb_interface *usb_intf,
 
 	usb_set_intfdata(usb_intf, dev);
 
-	dev->mt76.bus = &usb_ops;
-
-	ret = mt76x0_assign_pipes(usb_intf, dev);
+	ret = mt76u_init(&dev->mt76, usb_intf);
 	if (ret)
 		goto err;
 
-- 
2.18.0
