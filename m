Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr1-f66.google.com ([209.85.221.66]:46185 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726842AbeHYOTt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 25 Aug 2018 10:19:49 -0400
Received: by mail-wr1-f66.google.com with SMTP id a108-v6so9421970wrc.13
        for <linux-wireless@vger.kernel.org>; Sat, 25 Aug 2018 03:41:14 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: sgruszka@redhat.com, linux-wireless@vger.kernel.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH 11/16] mt76x0: remove mt76x0_vendor_request routine
Date: Sat, 25 Aug 2018 12:40:51 +0200
Message-Id: <20180825104056.9130-12-lorenzo.bianconi@redhat.com> (sfid-20180825_124118_703280_63BBCF40)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove mt76x0_vendor_request routine and use
mt76u_vendor_request utility function from mt76-usb
layer in mt76x0_upload_firmware

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../net/wireless/mediatek/mt76/mt76x0/mcu.c   |  5 +--
 .../net/wireless/mediatek/mt76/mt76x0/usb.c   | 31 -------------------
 .../net/wireless/mediatek/mt76/mt76x0/usb.h   |  4 ---
 3 files changed, 3 insertions(+), 37 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mcu.c b/drivers/net/wireless/mediatek/mt76/mt76x0/mcu.c
index 3f985c1d45f0..7c2217307828 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mcu.c
@@ -488,8 +488,9 @@ mt76x0_upload_firmware(struct mt76x0_dev *dev, const struct mt76_fw *fw)
 	if (ret)
 		goto error;
 
-	ret = mt76x0_vendor_request(dev, MT_VEND_DEV_MODE, USB_DIR_OUT,
-				     0x12, 0, ivb, sizeof(fw->ivb));
+	ret = mt76u_vendor_request(&dev->mt76, MT_VEND_DEV_MODE,
+				   USB_DIR_OUT | USB_TYPE_VENDOR,
+				   0x12, 0, ivb, sizeof(fw->ivb));
 	if (ret < 0)
 		goto error;
 	ret = 0;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
index fcca1e990475..e2b55d0d31da 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
@@ -93,37 +93,6 @@ int mt76x0_usb_submit_buf(struct mt76x0_dev *dev, int dir, int ep_idx,
 	return ret;
 }
 
-int mt76x0_vendor_request(struct mt76x0_dev *dev, const u8 req,
-			   const u8 direction, const u16 val, const u16 offset,
-			   void *buf, const size_t buflen)
-{
-	int i, ret;
-	struct usb_device *usb_dev = mt76x0_to_usb_dev(dev);
-	const u8 req_type = direction | USB_TYPE_VENDOR | USB_RECIP_DEVICE;
-	const unsigned int pipe = (direction == USB_DIR_IN) ?
-		usb_rcvctrlpipe(usb_dev, 0) : usb_sndctrlpipe(usb_dev, 0);
-
-	for (i = 0; i < MT_VEND_REQ_MAX_RETRY; i++) {
-		ret = usb_control_msg(usb_dev, pipe, req, req_type,
-				      val, offset, buf, buflen,
-				      MT_VEND_REQ_TOUT_MS);
-		trace_mt76x0_vend_req(&dev->mt76, pipe, req, req_type, val, offset,
-				  buf, buflen, ret);
-
-		if (ret == -ENODEV)
-			set_bit(MT76_REMOVED, &dev->mt76.state);
-		if (ret >= 0 || ret == -ENODEV)
-			return ret;
-
-		msleep(5);
-	}
-
-	dev_err(dev->mt76.dev, "Vendor request req:%02x off:%04x failed:%d\n",
-		req, offset, ret);
-
-	return ret;
-}
-
 void mt76x0_addr_wr(struct mt76x0_dev *dev, const u32 offset, const u8 *addr)
 {
 	mt76_wr(dev, offset, get_unaligned_le32(addr));
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.h b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.h
index 0d1ba95dcf2e..b4a5d98416ab 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.h
@@ -50,8 +50,4 @@ int mt76x0_usb_submit_buf(struct mt76x0_dev *dev, int dir, int ep_idx,
 			   struct mt76x0_dma_buf *buf, gfp_t gfp,
 			   usb_complete_t complete_fn, void *context);
 
-int mt76x0_vendor_request(struct mt76x0_dev *dev, const u8 req,
-			   const u8 direction, const u16 val, const u16 offset,
-			   void *buf, const size_t buflen);
-
 #endif
-- 
2.18.0
