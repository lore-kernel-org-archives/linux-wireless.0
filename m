Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr1-f68.google.com ([209.85.221.68]:40668 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726624AbeHYOTk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 25 Aug 2018 10:19:40 -0400
Received: by mail-wr1-f68.google.com with SMTP id n2-v6so9429073wrw.7
        for <linux-wireless@vger.kernel.org>; Sat, 25 Aug 2018 03:41:05 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: sgruszka@redhat.com, linux-wireless@vger.kernel.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH 03/16] mt76: move mt76x2u_mcu_deinit routine in mt76-usb module
Date: Sat, 25 Aug 2018 12:40:43 +0200
Message-Id: <20180825104056.9130-4-lorenzo.bianconi@redhat.com> (sfid-20180825_124112_216819_37E2D693)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move mt76x2u_mcu_deinit routine in usb_mcu layer in order to
be reused by mt76x0 driver in usb mcu layer unification between
mt76x0 and mt76x2u drivers

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76.h         | 1 +
 drivers/net/wireless/mediatek/mt76/mt76x2u.h      | 1 -
 drivers/net/wireless/mediatek/mt76/mt76x2u_init.c | 2 +-
 drivers/net/wireless/mediatek/mt76/mt76x2u_mcu.c  | 8 --------
 drivers/net/wireless/mediatek/mt76/usb_mcu.c      | 9 +++++++++
 5 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 5579b90afee9..f84f35c2e37a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -629,5 +629,6 @@ int mt76u_mcu_send_msg(struct mt76_dev *dev, struct sk_buff *skb,
 		       int cmd, bool wait_resp);
 void mt76u_mcu_fw_reset(struct mt76_dev *dev);
 int mt76u_mcu_init_rx(struct mt76_dev *dev);
+void mt76u_mcu_deinit(struct mt76_dev *dev);
 
 #endif
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2u.h b/drivers/net/wireless/mediatek/mt76/mt76x2u.h
index 008092f0cd8a..a83c17cb6be5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2u.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2u.h
@@ -65,7 +65,6 @@ int mt76x2u_mcu_load_cr(struct mt76x2_dev *dev, u8 type,
 			u8 temp_level, u8 channel);
 int mt76x2u_mcu_init(struct mt76x2_dev *dev);
 int mt76x2u_mcu_fw_init(struct mt76x2_dev *dev);
-void mt76x2u_mcu_deinit(struct mt76x2_dev *dev);
 
 int mt76x2u_alloc_queues(struct mt76x2_dev *dev);
 void mt76x2u_queues_deinit(struct mt76x2_dev *dev);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2u_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2u_init.c
index 4986f5388222..48b0b941c0fe 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2u_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2u_init.c
@@ -312,5 +312,5 @@ void mt76x2u_cleanup(struct mt76x2_dev *dev)
 	mt76x2u_mcu_set_radio_state(dev, false);
 	mt76x2u_stop_hw(dev);
 	mt76u_queues_deinit(&dev->mt76);
-	mt76x2u_mcu_deinit(dev);
+	mt76u_mcu_deinit(&dev->mt76);
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2u_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76x2u_mcu.c
index 22c16d638baa..31677e898427 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2u_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2u_mcu.c
@@ -453,11 +453,3 @@ int mt76x2u_mcu_init(struct mt76x2_dev *dev)
 
 	return mt76x2u_mcu_set_radio_state(dev, true);
 }
-
-void mt76x2u_mcu_deinit(struct mt76x2_dev *dev)
-{
-	struct mt76_usb *usb = &dev->mt76.usb;
-
-	usb_kill_urb(usb->mcu.res.urb);
-	mt76u_buf_free(&usb->mcu.res);
-}
diff --git a/drivers/net/wireless/mediatek/mt76/usb_mcu.c b/drivers/net/wireless/mediatek/mt76/usb_mcu.c
index 4039b0b709a0..1edc5c3d637b 100644
--- a/drivers/net/wireless/mediatek/mt76/usb_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/usb_mcu.c
@@ -250,3 +250,12 @@ int mt76u_mcu_init_rx(struct mt76_dev *dev)
 	return err;
 }
 EXPORT_SYMBOL_GPL(mt76u_mcu_init_rx);
+
+void mt76u_mcu_deinit(struct mt76_dev *dev)
+{
+	struct mt76_usb *usb = &dev->usb;
+
+	usb_kill_urb(usb->mcu.res.urb);
+	mt76u_buf_free(&usb->mcu.res);
+}
+EXPORT_SYMBOL_GPL(mt76u_mcu_deinit);
-- 
2.18.0
