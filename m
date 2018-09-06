Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:33188 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728140AbeIFNzS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Sep 2018 09:55:18 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>,
        linux-mediatek@lists.infradead.org
Subject: [PATCH 42/42] mt76x0: make device allocation bus neutral
Date: Thu,  6 Sep 2018 11:18:58 +0200
Message-Id: <1536225538-16454-43-git-send-email-sgruszka@redhat.com> (sfid-20180906_112052_689427_6E26194F)
In-Reply-To: <1536225538-16454-1-git-send-email-sgruszka@redhat.com>
References: <1536225538-16454-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove some USB specific code form mt76x0_alloc_device.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/init.c   | 11 +++--------
 drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h |  3 ++-
 drivers/net/wireless/mediatek/mt76/mt76x0/pci.c    |  2 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/tx.c     |  3 ++-
 drivers/net/wireless/mediatek/mt76/mt76x0/usb.c    |  9 ++++++++-
 5 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
index 4a899904d518..9c720906ea13 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
@@ -482,14 +482,9 @@ void mt76x0_cleanup(struct mt76x0_dev *dev)
 }
 EXPORT_SYMBOL_GPL(mt76x0_cleanup);
 
-struct mt76x0_dev *mt76x0_alloc_device(struct device *pdev)
+struct mt76x0_dev *
+mt76x0_alloc_device(struct device *pdev, const struct mt76_driver_ops *drv_ops)
 {
-	static const struct mt76_driver_ops drv_ops = {
-		.tx_prepare_skb = mt76x0_tx_prepare_skb,
-		.tx_complete_skb = mt76x02_tx_complete_skb,
-		.tx_status_data = mt76x02_tx_status_data,
-		.rx_skb = mt76x0_queue_rx_skb,
-	};
 	struct mt76x0_dev *dev;
 	struct mt76_dev *mdev;
 
@@ -498,7 +493,7 @@ struct mt76x0_dev *mt76x0_alloc_device(struct device *pdev)
 		return NULL;
 
 	mdev->dev = pdev;
-	mdev->drv = &drv_ops;
+	mdev->drv = drv_ops;
 
 	dev = container_of(mdev, struct mt76x0_dev, mt76);
 	mutex_init(&dev->reg_atomic_mutex);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
index 31267a180573..87eb084bd270 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
@@ -134,7 +134,8 @@ int mt76x0_burst_write_regs(struct mt76x0_dev *dev, u32 offset,
 			     const u32 *data, int n);
 
 /* Init */
-struct mt76x0_dev *mt76x0_alloc_device(struct device *dev);
+struct mt76x0_dev *
+mt76x0_alloc_device(struct device *pdev, const struct mt76_driver_ops *drv_ops);
 int mt76x0_init_hardware(struct mt76x0_dev *dev);
 int mt76x0_register_device(struct mt76x0_dev *dev);
 void mt76x0_cleanup(struct mt76x0_dev *dev);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c b/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
index 244ab64560a6..eb383f96ec9a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
@@ -40,7 +40,7 @@ mt76x0e_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (ret)
 		return ret;
 
-	dev = mt76x0_alloc_device(&pdev->dev);
+	dev = mt76x0_alloc_device(&pdev->dev, NULL);
 	if (!dev)
 		return -ENOMEM;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c b/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c
index b59b16d374e1..5306fc3a90fb 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c
@@ -95,6 +95,7 @@ int mt76x0_tx_prepare_skb(struct mt76_dev *mdev, void *data,
 
 	return mt76x02_set_txinfo(skb, wcid, q2ep(*hwq_ptr));
 }
+EXPORT_SYMBOL_GPL(mt76x0_tx_prepare_skb);
 
 void mt76x0_queue_rx_skb(struct mt76_dev *mdev, enum mt76_rxq_id q,
 			 struct sk_buff *skb)
@@ -110,4 +111,4 @@ void mt76x0_queue_rx_skb(struct mt76_dev *mdev, enum mt76_rxq_id q,
 
 	mt76_rx(&dev->mt76, q, skb);
 }
-
+EXPORT_SYMBOL_GPL(mt76x0_queue_rx_skb);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
index 9a803fb0cd5d..89e856745fec 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
@@ -18,6 +18,7 @@
 #include "mt76x0.h"
 #include "usb.h"
 #include "trace.h"
+#include "../mt76x02_util.h"
 
 static struct usb_device_id mt76x0_device_table[] = {
 	{ USB_DEVICE(0x148F, 0x7610) },	/* MT7610U */
@@ -49,12 +50,18 @@ static struct usb_device_id mt76x0_device_table[] = {
 static int mt76x0u_probe(struct usb_interface *usb_intf,
 			 const struct usb_device_id *id)
 {
+	static const struct mt76_driver_ops drv_ops = {
+		.tx_prepare_skb = mt76x0_tx_prepare_skb,
+		.tx_complete_skb = mt76x02_tx_complete_skb,
+		.tx_status_data = mt76x02_tx_status_data,
+		.rx_skb = mt76x0_queue_rx_skb,
+	};
 	struct usb_device *usb_dev = interface_to_usbdev(usb_intf);
 	struct mt76x0_dev *dev;
 	u32 asic_rev, mac_rev;
 	int ret;
 
-	dev = mt76x0_alloc_device(&usb_intf->dev);
+	dev = mt76x0_alloc_device(&usb_intf->dev, &drv_ops);
 	if (!dev)
 		return -ENOMEM;
 
-- 
2.7.5
