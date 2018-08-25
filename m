Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr1-f68.google.com ([209.85.221.68]:39682 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726624AbeHYOTn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 25 Aug 2018 10:19:43 -0400
Received: by mail-wr1-f68.google.com with SMTP id o37-v6so9448241wrf.6
        for <linux-wireless@vger.kernel.org>; Sat, 25 Aug 2018 03:41:09 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: sgruszka@redhat.com, linux-wireless@vger.kernel.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH 06/16] mt76x0: remove mt76x0_vendor_reset routine
Date: Sat, 25 Aug 2018 12:40:46 +0200
Message-Id: <20180825104056.9130-7-lorenzo.bianconi@redhat.com> (sfid-20180825_124114_048693_0C5D009B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove mt76x0_vendor_reset duplicated routine and use mt76u_mcu_fw_reset
utility function for mcu fw reset

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/mcu.c | 2 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/usb.c | 6 ------
 drivers/net/wireless/mediatek/mt76/mt76x0/usb.h | 1 -
 3 files changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mcu.c b/drivers/net/wireless/mediatek/mt76/mt76x0/mcu.c
index 75768ebf8b30..c8ea3126e7dc 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mcu.c
@@ -571,7 +571,7 @@ static int mt76x0_load_firmware(struct mt76x0_dev *dev)
 	mt76_set(dev, MT_USB_DMA_CFG, (MT_USB_DMA_CFG_RX_BULK_EN |
 				       MT_USB_DMA_CFG_TX_BULK_EN) |
 				       FIELD_PREP(MT_USB_DMA_CFG_RX_BULK_AGG_TOUT, 0x20));
-	mt76x0_vendor_reset(dev);
+	mt76u_mcu_fw_reset(&dev->mt76);
 	msleep(5);
 /*
 	mt76x0_rmw(dev, MT_PBF_CFG, 0, (MT_PBF_CFG_TX0Q_EN |
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
index 09e7f9590f01..fdb71b907419 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
@@ -131,12 +131,6 @@ int mt76x0_vendor_request(struct mt76x0_dev *dev, const u8 req,
 	return ret;
 }
 
-void mt76x0_vendor_reset(struct mt76x0_dev *dev)
-{
-	mt76x0_vendor_request(dev, MT_VEND_DEV_MODE, USB_DIR_OUT,
-			      MT_VEND_DEV_MODE_RESET, 0, NULL, 0);
-}
-
 int mt76x0_vendor_single_wr(struct mt76x0_dev *dev, const u8 req,
 			     const u16 offset, const u32 val)
 {
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.h b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.h
index 492e431390a8..d23ca45a294e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.h
@@ -54,7 +54,6 @@ void mt76x0_complete_urb(struct urb *urb);
 int mt76x0_vendor_request(struct mt76x0_dev *dev, const u8 req,
 			   const u8 direction, const u16 val, const u16 offset,
 			   void *buf, const size_t buflen);
-void mt76x0_vendor_reset(struct mt76x0_dev *dev);
 int mt76x0_vendor_single_wr(struct mt76x0_dev *dev, const u8 req,
 			     const u16 offset, const u32 val);
 
-- 
2.18.0
