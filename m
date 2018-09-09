Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr1-f67.google.com ([209.85.221.67]:37206 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726609AbeIJBXv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 9 Sep 2018 21:23:51 -0400
Received: by mail-wr1-f67.google.com with SMTP id u12-v6so19720040wrr.4
        for <linux-wireless@vger.kernel.org>; Sun, 09 Sep 2018 13:32:58 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 04/11] mt76: add rd_rp and wr_rp to bus_ops/mcu_ops
Date: Sun,  9 Sep 2018 22:32:39 +0200
Message-Id: <20180909203246.21608-5-lorenzo.bianconi@redhat.com> (sfid-20180909_223301_488355_4742E5AE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Stanislaw Gruszka <sgruszka@redhat.com>

Add callbacks for reading and writing reg pairs tables.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76.h    | 20 +++++++++++++++-----
 drivers/net/wireless/mediatek/mt76/usb.c     |  2 ++
 drivers/net/wireless/mediatek/mt76/usb_mcu.c |  2 ++
 3 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 0443edcdbeff..b0df3f85ccd1 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -33,12 +33,21 @@
 struct mt76_dev;
 struct mt76_wcid;
 
+struct mt76_reg_pair {
+	u32 reg;
+	u32 value;
+};
+
 struct mt76_bus_ops {
 	u32 (*rr)(struct mt76_dev *dev, u32 offset);
 	void (*wr)(struct mt76_dev *dev, u32 offset, u32 val);
 	u32 (*rmw)(struct mt76_dev *dev, u32 offset, u32 mask, u32 val);
 	void (*copy)(struct mt76_dev *dev, u32 offset, const void *data,
 		     int len);
+	int (*wr_rp)(struct mt76_dev *dev, u32 base,
+		     const struct mt76_reg_pair *rp, int len);
+	int (*rd_rp)(struct mt76_dev *dev, u32 base,
+		     struct mt76_reg_pair *rp, int len);
 };
 
 enum mt76_txq_id {
@@ -53,11 +62,6 @@ enum mt76_txq_id {
 	__MT_TXQ_MAX
 };
 
-struct mt76_reg_pair {
-	u32 reg;
-	u32 value;
-};
-
 enum mt76_rxq_id {
 	MT_RXQ_MAIN,
 	MT_RXQ_MCU,
@@ -122,6 +126,10 @@ struct mt76_mcu_ops {
 	struct sk_buff *(*mcu_msg_alloc)(const void *data, int len);
 	int (*mcu_send_msg)(struct mt76_dev *dev, struct sk_buff *skb,
 			    int cmd, bool wait_resp);
+	int (*mcu_wr_rp)(struct mt76_dev *dev, u32 base,
+			 const struct mt76_reg_pair *rp, int len);
+	int (*mcu_rd_rp)(struct mt76_dev *dev, u32 base,
+			 struct mt76_reg_pair *rp, int len);
 };
 
 struct mt76_queue_ops {
@@ -441,6 +449,8 @@ struct mt76_rx_status {
 #define mt76_wr(dev, ...)	(dev)->mt76.bus->wr(&((dev)->mt76), __VA_ARGS__)
 #define mt76_rmw(dev, ...)	(dev)->mt76.bus->rmw(&((dev)->mt76), __VA_ARGS__)
 #define mt76_wr_copy(dev, ...)	(dev)->mt76.bus->copy(&((dev)->mt76), __VA_ARGS__)
+#define mt76_wr_rp(dev, ...)	(dev)->mt76.bus->wr_rp(&((dev)->mt76), __VA_ARGS__)
+#define mt76_rd_rp(dev, ...)	(dev)->mt76.bus->rd_rp(&((dev)->mt76), __VA_ARGS__)
 
 #define mt76_mcu_msg_alloc(dev, ...)	(dev)->mt76.mcu_ops->mcu_msg_alloc(__VA_ARGS__)
 #define mt76_mcu_send_msg(dev, ...)	(dev)->mt76.mcu_ops->mcu_send_msg(&((dev)->mt76), __VA_ARGS__)
diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
index 93cda21aa50c..aca6dcfe7a98 100644
--- a/drivers/net/wireless/mediatek/mt76/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/usb.c
@@ -876,6 +876,8 @@ int mt76u_init(struct mt76_dev *dev,
 		.wr = mt76u_wr,
 		.rmw = mt76u_rmw,
 		.copy = mt76u_copy,
+		.wr_rp = mt76u_wr_rp,
+		.rd_rp = mt76u_rd_rp,
 	};
 	struct mt76_usb *usb = &dev->usb;
 
diff --git a/drivers/net/wireless/mediatek/mt76/usb_mcu.c b/drivers/net/wireless/mediatek/mt76/usb_mcu.c
index 622d7d6da32e..7cbc02d8ec35 100644
--- a/drivers/net/wireless/mediatek/mt76/usb_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/usb_mcu.c
@@ -381,6 +381,8 @@ void mt76u_init_mcu_ops(struct mt76_dev *dev)
 	static const struct mt76_mcu_ops mt76u_mcu_ops = {
 		.mcu_msg_alloc = mt76u_mcu_msg_alloc,
 		.mcu_send_msg = mt76u_mcu_send_msg,
+		.mcu_wr_rp = mt76u_mcu_wr_rp,
+		.mcu_rd_rp = mt76u_mcu_rd_rp,
 	};
 
 	dev->mcu_ops = &mt76u_mcu_ops;
-- 
2.18.0
