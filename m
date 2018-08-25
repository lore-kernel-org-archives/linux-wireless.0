Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr1-f67.google.com ([209.85.221.67]:40682 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726624AbeHYOTs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 25 Aug 2018 10:19:48 -0400
Received: by mail-wr1-f67.google.com with SMTP id n2-v6so9429328wrw.7
        for <linux-wireless@vger.kernel.org>; Sat, 25 Aug 2018 03:41:13 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: sgruszka@redhat.com, linux-wireless@vger.kernel.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH 10/16] mt76x0: remove mt76x0_complete_urb routine
Date: Sat, 25 Aug 2018 12:40:50 +0200
Message-Id: <20180825104056.9130-11-lorenzo.bianconi@redhat.com> (sfid-20180825_130845_018964_DBA603DD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove mt76x0_complete_urb routine and use mt76u_mcu_complete_urb utility
function as usb mcu completion handler

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/mcu.c | 6 +++---
 drivers/net/wireless/mediatek/mt76/mt76x0/usb.c | 7 -------
 drivers/net/wireless/mediatek/mt76/mt76x0/usb.h | 1 -
 3 files changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mcu.c b/drivers/net/wireless/mediatek/mt76/mt76x0/mcu.c
index bfaabe018216..3f985c1d45f0 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mcu.c
@@ -113,7 +113,7 @@ static int mt76x0_mcu_wait_resp(struct mt76x0_dev *dev, u8 seq)
 
 		ret = mt76x0_usb_submit_buf(dev, USB_DIR_IN, MT_EP_IN_CMD_RESP,
 					     &dev->mcu.resp, GFP_KERNEL,
-					     mt76x0_complete_urb,
+					     mt76u_mcu_complete_urb,
 					     &usb->mcu.cmpl);
 		if (ret)
 			return ret;
@@ -412,7 +412,7 @@ static int __mt76x0_dma_fw(struct mt76x0_dev *dev,
 	buf.len = MT_DMA_HDR_LEN + len + 4;
 	ret = mt76x0_usb_submit_buf(dev, USB_DIR_OUT, MT_EP_OUT_INBAND_CMD,
 				     &buf, GFP_KERNEL,
-				     mt76x0_complete_urb, &cmpl);
+				     mt76u_mcu_complete_urb, &cmpl);
 	if (ret)
 		return ret;
 
@@ -624,7 +624,7 @@ int mt76x0_mcu_cmd_init(struct mt76x0_dev *dev)
 
 	ret = mt76x0_usb_submit_buf(dev, USB_DIR_IN, MT_EP_IN_CMD_RESP,
 				     &dev->mcu.resp, GFP_KERNEL,
-				     mt76x0_complete_urb, &usb->mcu.cmpl);
+				     mt76u_mcu_complete_urb, &usb->mcu.cmpl);
 	if (ret) {
 		mt76x0_usb_free_buf(dev, &dev->mcu.resp);
 		return ret;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
index a9835bb7b921..fcca1e990475 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
@@ -93,13 +93,6 @@ int mt76x0_usb_submit_buf(struct mt76x0_dev *dev, int dir, int ep_idx,
 	return ret;
 }
 
-void mt76x0_complete_urb(struct urb *urb)
-{
-	struct completion *cmpl = urb->context;
-
-	complete(cmpl);
-}
-
 int mt76x0_vendor_request(struct mt76x0_dev *dev, const u8 req,
 			   const u8 direction, const u16 val, const u16 offset,
 			   void *buf, const size_t buflen)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.h b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.h
index 931c36554ff4..0d1ba95dcf2e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.h
@@ -49,7 +49,6 @@ void mt76x0_usb_free_buf(struct mt76x0_dev *dev, struct mt76x0_dma_buf *buf);
 int mt76x0_usb_submit_buf(struct mt76x0_dev *dev, int dir, int ep_idx,
 			   struct mt76x0_dma_buf *buf, gfp_t gfp,
 			   usb_complete_t complete_fn, void *context);
-void mt76x0_complete_urb(struct urb *urb);
 
 int mt76x0_vendor_request(struct mt76x0_dev *dev, const u8 req,
 			   const u8 direction, const u16 val, const u16 offset,
-- 
2.18.0
