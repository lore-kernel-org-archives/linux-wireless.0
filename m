Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr1-f68.google.com ([209.85.221.68]:45398 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726688AbeIJBXv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 9 Sep 2018 21:23:51 -0400
Received: by mail-wr1-f68.google.com with SMTP id 20-v6so19732308wrb.12
        for <linux-wireless@vger.kernel.org>; Sun, 09 Sep 2018 13:32:57 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 03/11] mt76: add usb implementation of {wr,rd}_rp
Date: Sun,  9 Sep 2018 22:32:38 +0200
Message-Id: <20180909203246.21608-4-lorenzo.bianconi@redhat.com> (sfid-20180909_223302_482724_04CADFCB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Stanislaw Gruszka <sgruszka@redhat.com>

Add USB implementation for read and write reg pair routines.
The actual implementation can use mcu related routines according to
MCU state

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76.h     |  8 ++
 .../net/wireless/mediatek/mt76/mt76x0/init.c  |  5 +-
 .../net/wireless/mediatek/mt76/mt76x0/mcu.c   | 73 -----------------
 .../wireless/mediatek/mt76/mt76x0/mt76x0.h    |  4 -
 .../net/wireless/mediatek/mt76/mt76x0/phy.c   |  9 ++-
 drivers/net/wireless/mediatek/mt76/usb.c      | 54 +++++++++++++
 drivers/net/wireless/mediatek/mt76/usb_mcu.c  | 79 +++++++++++++++++++
 7 files changed, 149 insertions(+), 83 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index d36ffc030b15..0443edcdbeff 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -649,6 +649,14 @@ int __mt76u_mcu_send_msg(struct mt76_dev *dev, struct sk_buff *skb,
 			 int cmd, bool wait_resp);
 int mt76u_mcu_send_msg(struct mt76_dev *dev, struct sk_buff *skb,
 		       int cmd, bool wait_resp);
+int mt76u_mcu_wr_rp(struct mt76_dev *dev, u32 base,
+		    const struct mt76_reg_pair *data, int n);
+int mt76u_mcu_rd_rp(struct mt76_dev *dev, u32 base,
+		    struct mt76_reg_pair *data, int n);
+int mt76u_wr_rp(struct mt76_dev *dev, u32 base,
+		const struct mt76_reg_pair *data, int n);
+int mt76u_rd_rp(struct mt76_dev *dev, u32 base,
+		struct mt76_reg_pair *data, int n);
 void mt76u_mcu_fw_reset(struct mt76_dev *dev);
 int mt76u_mcu_init_rx(struct mt76_dev *dev);
 void mt76u_mcu_deinit(struct mt76_dev *dev);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
index 9c720906ea13..007036e35063 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
@@ -154,8 +154,9 @@ static void mt76x0_init_usb_dma(struct mt76x0_dev *dev)
 	mt76_wr(dev, MT_USB_DMA_CFG, val);
 }
 
-#define RANDOM_WRITE(dev, tab) \
-	mt76x0_write_reg_pairs(dev, MT_MCU_MEMMAP_WLAN, tab, ARRAY_SIZE(tab));
+#define RANDOM_WRITE(dev, tab)				\
+	mt76u_wr_rp(&(dev)->mt76, MT_MCU_MEMMAP_WLAN,	\
+		    tab, ARRAY_SIZE(tab))
 
 static int mt76x0_init_bbp(struct mt76x0_dev *dev)
 {
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mcu.c b/drivers/net/wireless/mediatek/mt76/mt76x0/mcu.c
index a9314753a2dc..b8f85668c447 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mcu.c
@@ -78,79 +78,6 @@ mt76x0_mcu_calibrate(struct mt76x0_dev *dev, enum mcu_calibrate cal, u32 val)
 				  true);
 }
 
-int mt76x0_write_reg_pairs(struct mt76x0_dev *dev, u32 base,
-			   const struct mt76_reg_pair *data, int n)
-{
-	const int max_vals_per_cmd = MT_INBAND_PACKET_MAX_LEN / 8;
-	struct sk_buff *skb;
-	int cnt, i, ret;
-
-	if (!n)
-		return 0;
-
-	cnt = min(max_vals_per_cmd, n);
-
-	skb = alloc_skb(cnt * 8 + MT_DMA_HDR_LEN + 4, GFP_KERNEL);
-	if (!skb)
-		return -ENOMEM;
-	skb_reserve(skb, MT_DMA_HDR_LEN);
-
-	for (i = 0; i < cnt; i++) {
-		skb_put_le32(skb, base + data[i].reg);
-		skb_put_le32(skb, data[i].value);
-	}
-
-	ret = mt76u_mcu_send_msg(&dev->mt76, skb, CMD_RANDOM_WRITE,
-				 cnt == n);
-	if (ret)
-		return ret;
-
-	return mt76x0_write_reg_pairs(dev, base, data + cnt, n - cnt);
-}
-
-int mt76x0_read_reg_pairs(struct mt76x0_dev *dev, u32 base,
-			  struct mt76_reg_pair *data, int n)
-{
-	const int max_vals_per_cmd = MT_INBAND_PACKET_MAX_LEN / 8;
-	struct mt76_usb *usb = &dev->mt76.usb;
-	struct sk_buff *skb;
-	int cnt, i, ret;
-
-	if (!n)
-		return 0;
-
-	cnt = min(max_vals_per_cmd, n);
-	if (cnt != n)
-		return -EINVAL;
-
-	skb = alloc_skb(cnt * 8 + MT_DMA_HDR_LEN + 4, GFP_KERNEL);
-	if (!skb)
-		return -ENOMEM;
-	skb_reserve(skb, MT_DMA_HDR_LEN);
-
-	for (i = 0; i < cnt; i++) {
-		skb_put_le32(skb, base + data[i].reg);
-		skb_put_le32(skb, data[i].value);
-	}
-
-	mutex_lock(&usb->mcu.mutex);
-
-	usb->mcu.rp = data;
-	usb->mcu.rp_len = n;
-	usb->mcu.base = base;
-	usb->mcu.burst = false;
-
-	ret = __mt76u_mcu_send_msg(&dev->mt76, skb, CMD_RANDOM_READ,
-				   true);
-
-	usb->mcu.rp = NULL;
-
-	mutex_unlock(&usb->mcu.mutex);
-
-	return ret;
-
-}
-
 int mt76x0_burst_write_regs(struct mt76x0_dev *dev, u32 offset,
 			     const u32 *data, int n)
 {
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
index 87eb084bd270..92ecf4e8bda1 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
@@ -126,10 +126,6 @@ void mt76x0_init_debugfs(struct mt76x0_dev *dev);
 #define mt76_rmw_field(_dev, _reg, _field, _val)	\
 	mt76_rmw(_dev, _reg, _field, FIELD_PREP(_field, _val))
 
-int mt76x0_write_reg_pairs(struct mt76x0_dev *dev, u32 base,
-			    const struct mt76_reg_pair *data, int len);
-int mt76x0_read_reg_pairs(struct mt76x0_dev *dev, u32 base,
-			  struct mt76_reg_pair *data, int len);
 int mt76x0_burst_write_regs(struct mt76x0_dev *dev, u32 offset,
 			     const u32 *data, int n);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
index 1176a288b2c6..27dd8388a6ae 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
@@ -117,7 +117,7 @@ rf_wr(struct mt76x0_dev *dev, u32 offset, u8 val)
 			.value = val,
 		};
 
-		return mt76x0_write_reg_pairs(dev, MT_MCU_MEMMAP_RF, &pair, 1);
+		return mt76u_wr_rp(&dev->mt76, MT_MCU_MEMMAP_RF, &pair, 1);
 	} else {
 		WARN_ON_ONCE(1);
 		return mt76x0_rf_csr_wr(dev, offset, val);
@@ -135,7 +135,7 @@ rf_rr(struct mt76x0_dev *dev, u32 offset)
 			.reg = offset,
 		};
 
-		ret = mt76x0_read_reg_pairs(dev, MT_MCU_MEMMAP_RF, &pair, 1);
+		ret = mt76u_rd_rp(&dev->mt76, MT_MCU_MEMMAP_RF, &pair, 1);
 		val = pair.value;
 	} else {
 		WARN_ON_ONCE(1);
@@ -175,8 +175,9 @@ rf_clear(struct mt76x0_dev *dev, u32 offset, u8 mask)
 }
 #endif
 
-#define RF_RANDOM_WRITE(dev, tab) \
-	mt76x0_write_reg_pairs(dev, MT_MCU_MEMMAP_RF, tab, ARRAY_SIZE(tab));
+#define RF_RANDOM_WRITE(dev, tab)			\
+	mt76u_wr_rp(&(dev)->mt76, MT_MCU_MEMMAP_RF,	\
+		    tab, ARRAY_SIZE(tab))
 
 int mt76x0_wait_bbp_ready(struct mt76x0_dev *dev)
 {
diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
index 5d568c910979..93cda21aa50c 100644
--- a/drivers/net/wireless/mediatek/mt76/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/usb.c
@@ -186,6 +186,60 @@ void mt76u_single_wr(struct mt76_dev *dev, const u8 req,
 }
 EXPORT_SYMBOL_GPL(mt76u_single_wr);
 
+static int
+mt76u_req_wr_rp(struct mt76_dev *dev, u32 base,
+		const struct mt76_reg_pair *data, int len)
+{
+	struct mt76_usb *usb = &dev->usb;
+
+	mutex_lock(&usb->usb_ctrl_mtx);
+	while (len > 0) {
+		__mt76u_wr(dev, base + data->reg, data->value);
+		len--;
+		data++;
+	}
+	mutex_unlock(&usb->usb_ctrl_mtx);
+
+	return 0;
+}
+
+int mt76u_wr_rp(struct mt76_dev *dev, u32 base,
+		const struct mt76_reg_pair *data, int n)
+{
+	if (test_bit(MT76_STATE_MCU_RUNNING, &dev->state))
+		return mt76u_mcu_wr_rp(dev, base, data, n);
+	else
+		return mt76u_req_wr_rp(dev, base, data, n);
+}
+EXPORT_SYMBOL_GPL(mt76u_wr_rp);
+
+static int
+mt76u_req_rd_rp(struct mt76_dev *dev, u32 base, struct mt76_reg_pair *data,
+		int len)
+{
+	struct mt76_usb *usb = &dev->usb;
+
+	mutex_lock(&usb->usb_ctrl_mtx);
+	while (len > 0) {
+		data->value = __mt76u_rr(dev, base + data->reg);
+		len--;
+		data++;
+	}
+	mutex_unlock(&usb->usb_ctrl_mtx);
+
+	return 0;
+}
+
+int mt76u_rd_rp(struct mt76_dev *dev, u32 base,
+		struct mt76_reg_pair *data, int n)
+{
+	if (test_bit(MT76_STATE_MCU_RUNNING, &dev->state))
+		return mt76u_mcu_rd_rp(dev, base, data, n);
+	else
+		return mt76u_req_rd_rp(dev, base, data, n);
+}
+EXPORT_SYMBOL_GPL(mt76u_rd_rp);
+
 static int
 mt76u_set_endpoints(struct usb_interface *intf,
 		    struct mt76_usb *usb)
diff --git a/drivers/net/wireless/mediatek/mt76/usb_mcu.c b/drivers/net/wireless/mediatek/mt76/usb_mcu.c
index 4cce807ec24e..622d7d6da32e 100644
--- a/drivers/net/wireless/mediatek/mt76/usb_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/usb_mcu.c
@@ -26,6 +26,8 @@
 
 #define MT_TX_CPU_FROM_FCE_CPU_DESC_IDX	0x09a8
 
+#define MT_INBAND_PACKET_MAX_LEN	192
+
 struct sk_buff *mt76u_mcu_msg_alloc(const void *data, int len)
 {
 	struct sk_buff *skb;
@@ -178,6 +180,83 @@ int mt76u_mcu_send_msg(struct mt76_dev *dev, struct sk_buff *skb,
 }
 EXPORT_SYMBOL_GPL(mt76u_mcu_send_msg);
 
+static inline void skb_put_le32(struct sk_buff *skb, u32 val)
+{
+	put_unaligned_le32(val, skb_put(skb, 4));
+}
+
+int mt76u_mcu_wr_rp(struct mt76_dev *dev, u32 base,
+		    const struct mt76_reg_pair *data, int n)
+{
+	const int CMD_RANDOM_WRITE = 12;
+	const int max_vals_per_cmd = MT_INBAND_PACKET_MAX_LEN / 8;
+	struct sk_buff *skb;
+	int cnt, i, ret;
+
+	if (!n)
+		return 0;
+
+	cnt = min(max_vals_per_cmd, n);
+
+	skb = alloc_skb(cnt * 8 + MT_DMA_HDR_LEN + 4, GFP_KERNEL);
+	if (!skb)
+		return -ENOMEM;
+	skb_reserve(skb, MT_DMA_HDR_LEN);
+
+	for (i = 0; i < cnt; i++) {
+		skb_put_le32(skb, base + data[i].reg);
+		skb_put_le32(skb, data[i].value);
+	}
+
+	ret = mt76u_mcu_send_msg(dev, skb, CMD_RANDOM_WRITE, cnt == n);
+	if (ret)
+		return ret;
+
+	return mt76u_mcu_wr_rp(dev, base, data + cnt, n - cnt);
+}
+
+int mt76u_mcu_rd_rp(struct mt76_dev *dev, u32 base,
+		    struct mt76_reg_pair *data, int n)
+{
+	const int CMD_RANDOM_READ = 10;
+	const int max_vals_per_cmd = MT_INBAND_PACKET_MAX_LEN / 8;
+	struct mt76_usb *usb = &dev->usb;
+	struct sk_buff *skb;
+	int cnt, i, ret;
+
+	if (!n)
+		return 0;
+
+	cnt = min(max_vals_per_cmd, n);
+	if (cnt != n)
+		return -EINVAL;
+
+	skb = alloc_skb(cnt * 8 + MT_DMA_HDR_LEN + 4, GFP_KERNEL);
+	if (!skb)
+		return -ENOMEM;
+	skb_reserve(skb, MT_DMA_HDR_LEN);
+
+	for (i = 0; i < cnt; i++) {
+		skb_put_le32(skb, base + data[i].reg);
+		skb_put_le32(skb, data[i].value);
+	}
+
+	mutex_lock(&usb->mcu.mutex);
+
+	usb->mcu.rp = data;
+	usb->mcu.rp_len = n;
+	usb->mcu.base = base;
+	usb->mcu.burst = false;
+
+	ret = __mt76u_mcu_send_msg(dev, skb, CMD_RANDOM_READ, true);
+
+	usb->mcu.rp = NULL;
+
+	mutex_unlock(&usb->mcu.mutex);
+
+	return ret;
+}
+
 void mt76u_mcu_fw_reset(struct mt76_dev *dev)
 {
 	mt76u_vendor_request(dev, MT_VEND_DEV_MODE,
-- 
2.18.0
