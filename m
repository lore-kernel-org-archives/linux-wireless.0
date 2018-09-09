Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr1-f66.google.com ([209.85.221.66]:46742 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726609AbeIJBXt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 9 Sep 2018 21:23:49 -0400
Received: by mail-wr1-f66.google.com with SMTP id a108-v6so19725685wrc.13
        for <linux-wireless@vger.kernel.org>; Sun, 09 Sep 2018 13:32:56 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 02/11] mt76: add mt76_mcu_ops data structure for mcu related pointers
Date: Sun,  9 Sep 2018 22:32:37 +0200
Message-Id: <20180909203246.21608-3-lorenzo.bianconi@redhat.com> (sfid-20180909_223259_661431_8349E95E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Introduce mt76_mcu_ops data structure to contain mcu related function
pointers. This is a preliminary patch to move mt76x02 usb mcu code in
mt76x02-usb module

Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76.h    | 11 +++++++++++
 drivers/net/wireless/mediatek/mt76/usb.c     |  1 +
 drivers/net/wireless/mediatek/mt76/usb_mcu.c | 10 ++++++++++
 3 files changed, 22 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 80390be041cb..d36ffc030b15 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -118,6 +118,12 @@ struct mt76_queue {
 	struct sk_buff *rx_head;
 };
 
+struct mt76_mcu_ops {
+	struct sk_buff *(*mcu_msg_alloc)(const void *data, int len);
+	int (*mcu_send_msg)(struct mt76_dev *dev, struct sk_buff *skb,
+			    int cmd, bool wait_resp);
+};
+
 struct mt76_queue_ops {
 	int (*init)(struct mt76_dev *dev);
 
@@ -335,6 +341,7 @@ struct mt76_dev {
 
 	const struct mt76_bus_ops *bus;
 	const struct mt76_driver_ops *drv;
+	const struct mt76_mcu_ops *mcu_ops;
 	void __iomem *regs;
 	struct device *dev;
 
@@ -435,6 +442,9 @@ struct mt76_rx_status {
 #define mt76_rmw(dev, ...)	(dev)->mt76.bus->rmw(&((dev)->mt76), __VA_ARGS__)
 #define mt76_wr_copy(dev, ...)	(dev)->mt76.bus->copy(&((dev)->mt76), __VA_ARGS__)
 
+#define mt76_mcu_msg_alloc(dev, ...)	(dev)->mt76.mcu_ops->mcu_msg_alloc(__VA_ARGS__)
+#define mt76_mcu_send_msg(dev, ...)	(dev)->mt76.mcu_ops->mcu_send_msg(&((dev)->mt76), __VA_ARGS__)
+
 #define mt76_set(dev, offset, val)	mt76_rmw(dev, offset, 0, val)
 #define mt76_clear(dev, offset, val)	mt76_rmw(dev, offset, val, 0)
 
@@ -642,5 +652,6 @@ int mt76u_mcu_send_msg(struct mt76_dev *dev, struct sk_buff *skb,
 void mt76u_mcu_fw_reset(struct mt76_dev *dev);
 int mt76u_mcu_init_rx(struct mt76_dev *dev);
 void mt76u_mcu_deinit(struct mt76_dev *dev);
+void mt76u_init_mcu_ops(struct mt76_dev *dev);
 
 #endif
diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
index 5785e54c32d0..5d568c910979 100644
--- a/drivers/net/wireless/mediatek/mt76/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/usb.c
@@ -836,6 +836,7 @@ int mt76u_init(struct mt76_dev *dev,
 	mutex_init(&usb->usb_ctrl_mtx);
 	dev->bus = &mt76u_ops;
 	dev->queue_ops = &usb_queue_ops;
+	mt76u_init_mcu_ops(dev);
 
 	return mt76u_set_endpoints(intf, usb);
 }
diff --git a/drivers/net/wireless/mediatek/mt76/usb_mcu.c b/drivers/net/wireless/mediatek/mt76/usb_mcu.c
index d80dbfafba6d..4cce807ec24e 100644
--- a/drivers/net/wireless/mediatek/mt76/usb_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/usb_mcu.c
@@ -296,3 +296,13 @@ void mt76u_mcu_deinit(struct mt76_dev *dev)
 	mt76u_buf_free(&usb->mcu.res);
 }
 EXPORT_SYMBOL_GPL(mt76u_mcu_deinit);
+
+void mt76u_init_mcu_ops(struct mt76_dev *dev)
+{
+	static const struct mt76_mcu_ops mt76u_mcu_ops = {
+		.mcu_msg_alloc = mt76u_mcu_msg_alloc,
+		.mcu_send_msg = mt76u_mcu_send_msg,
+	};
+
+	dev->mcu_ops = &mt76u_mcu_ops;
+}
-- 
2.18.0
