Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr1-f67.google.com ([209.85.221.67]:34990 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726609AbeIJBXy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 9 Sep 2018 21:23:54 -0400
Received: by mail-wr1-f67.google.com with SMTP id j26-v6so19794961wre.2
        for <linux-wireless@vger.kernel.org>; Sun, 09 Sep 2018 13:32:59 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 05/11] mt76: usb: use common helpers for mcu_alloc_msg()/mcu_send_msg()
Date: Sun,  9 Sep 2018 22:32:40 +0200
Message-Id: <20180909203246.21608-6-lorenzo.bianconi@redhat.com> (sfid-20180909_223304_477666_E8F7F725)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use mcu common helpers instead of usb specific routines.
Add static qualifier to the following functions:
- mt76u_mcu_msg_alloc
- __mt76u_mcu_send_msg
- mt76u_mcu_send_msg
- mt76u_mcu_wr_rp
- mt76u_mcu_rd_rp
- mt76u_wr_rp
- mt76u_rd_rp
This is a preliminary patch to move mt76x02 usb mcu code in
mt76x02-usb module

Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76.h     | 13 ------
 .../net/wireless/mediatek/mt76/mt76x0/init.c  |  6 +--
 .../net/wireless/mediatek/mt76/mt76x0/mcu.c   | 13 +++---
 .../net/wireless/mediatek/mt76/mt76x0/phy.c   | 10 ++---
 .../net/wireless/mediatek/mt76/mt76x2u_mcu.c  | 40 +++++++++----------
 drivers/net/wireless/mediatek/mt76/usb.c      | 16 ++++----
 drivers/net/wireless/mediatek/mt76/usb_mcu.c  | 26 ++++++------
 7 files changed, 55 insertions(+), 69 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index b0df3f85ccd1..9cf112778c05 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -654,19 +654,6 @@ int mt76u_skb_dma_info(struct sk_buff *skb, int port, u32 flags);
 int mt76u_mcu_fw_send_data(struct mt76_dev *dev, const void *data,
 			   int data_len, u32 max_payload, u32 offset);
 void mt76u_mcu_complete_urb(struct urb *urb);
-struct sk_buff *mt76u_mcu_msg_alloc(const void *data, int len);
-int __mt76u_mcu_send_msg(struct mt76_dev *dev, struct sk_buff *skb,
-			 int cmd, bool wait_resp);
-int mt76u_mcu_send_msg(struct mt76_dev *dev, struct sk_buff *skb,
-		       int cmd, bool wait_resp);
-int mt76u_mcu_wr_rp(struct mt76_dev *dev, u32 base,
-		    const struct mt76_reg_pair *data, int n);
-int mt76u_mcu_rd_rp(struct mt76_dev *dev, u32 base,
-		    struct mt76_reg_pair *data, int n);
-int mt76u_wr_rp(struct mt76_dev *dev, u32 base,
-		const struct mt76_reg_pair *data, int n);
-int mt76u_rd_rp(struct mt76_dev *dev, u32 base,
-		struct mt76_reg_pair *data, int n);
 void mt76u_mcu_fw_reset(struct mt76_dev *dev);
 int mt76u_mcu_init_rx(struct mt76_dev *dev);
 void mt76u_mcu_deinit(struct mt76_dev *dev);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
index 007036e35063..a68161e1a2bf 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
@@ -154,9 +154,9 @@ static void mt76x0_init_usb_dma(struct mt76x0_dev *dev)
 	mt76_wr(dev, MT_USB_DMA_CFG, val);
 }
 
-#define RANDOM_WRITE(dev, tab)				\
-	mt76u_wr_rp(&(dev)->mt76, MT_MCU_MEMMAP_WLAN,	\
-		    tab, ARRAY_SIZE(tab))
+#define RANDOM_WRITE(dev, tab)			\
+	mt76_wr_rp(dev, MT_MCU_MEMMAP_WLAN,	\
+		   tab, ARRAY_SIZE(tab))
 
 static int mt76x0_init_bbp(struct mt76x0_dev *dev)
 {
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mcu.c b/drivers/net/wireless/mediatek/mt76/mt76x0/mcu.c
index b8f85668c447..17ec9189ac50 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mcu.c
@@ -52,11 +52,10 @@ int mt76x0_mcu_function_select(struct mt76x0_dev *dev,
 		.value = cpu_to_le32(val),
 	};
 
-	skb = mt76u_mcu_msg_alloc(&msg, sizeof(msg));
+	skb = mt76_mcu_msg_alloc(dev, &msg, sizeof(msg));
 	if (!skb)
 		return -ENOMEM;
-	return mt76u_mcu_send_msg(&dev->mt76, skb, CMD_FUN_SET_OP,
-				  func == 5);
+	return mt76_mcu_send_msg(dev, skb, CMD_FUN_SET_OP, func == 5);
 }
 
 int
@@ -71,11 +70,10 @@ mt76x0_mcu_calibrate(struct mt76x0_dev *dev, enum mcu_calibrate cal, u32 val)
 		.value = cpu_to_le32(val),
 	};
 
-	skb = mt76u_mcu_msg_alloc(&msg, sizeof(msg));
+	skb = mt76_mcu_msg_alloc(dev, &msg, sizeof(msg));
 	if (!skb)
 		return -ENOMEM;
-	return mt76u_mcu_send_msg(&dev->mt76, skb, CMD_CALIBRATION_OP,
-				  true);
+	return mt76_mcu_send_msg(dev, skb, CMD_CALIBRATION_OP, true);
 }
 
 int mt76x0_burst_write_regs(struct mt76x0_dev *dev, u32 offset,
@@ -99,8 +97,7 @@ int mt76x0_burst_write_regs(struct mt76x0_dev *dev, u32 offset,
 	for (i = 0; i < cnt; i++)
 		skb_put_le32(skb, data[i]);
 
-	ret = mt76u_mcu_send_msg(&dev->mt76, skb, CMD_BURST_WRITE,
-				 cnt == n);
+	ret = mt76_mcu_send_msg(dev, skb, CMD_BURST_WRITE, cnt == n);
 	if (ret)
 		return ret;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
index 27dd8388a6ae..0e9cf354cbec 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
@@ -117,7 +117,7 @@ rf_wr(struct mt76x0_dev *dev, u32 offset, u8 val)
 			.value = val,
 		};
 
-		return mt76u_wr_rp(&dev->mt76, MT_MCU_MEMMAP_RF, &pair, 1);
+		return mt76_wr_rp(dev, MT_MCU_MEMMAP_RF, &pair, 1);
 	} else {
 		WARN_ON_ONCE(1);
 		return mt76x0_rf_csr_wr(dev, offset, val);
@@ -135,7 +135,7 @@ rf_rr(struct mt76x0_dev *dev, u32 offset)
 			.reg = offset,
 		};
 
-		ret = mt76u_rd_rp(&dev->mt76, MT_MCU_MEMMAP_RF, &pair, 1);
+		ret = mt76_rd_rp(dev, MT_MCU_MEMMAP_RF, &pair, 1);
 		val = pair.value;
 	} else {
 		WARN_ON_ONCE(1);
@@ -175,9 +175,9 @@ rf_clear(struct mt76x0_dev *dev, u32 offset, u8 mask)
 }
 #endif
 
-#define RF_RANDOM_WRITE(dev, tab)			\
-	mt76u_wr_rp(&(dev)->mt76, MT_MCU_MEMMAP_RF,	\
-		    tab, ARRAY_SIZE(tab))
+#define RF_RANDOM_WRITE(dev, tab)		\
+	mt76_wr_rp(dev, MT_MCU_MEMMAP_RF,	\
+		   tab, ARRAY_SIZE(tab))
 
 int mt76x0_wait_bbp_ready(struct mt76x0_dev *dev)
 {
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2u_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76x2u_mcu.c
index a4302457cf5c..9d73bdc785b2 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2u_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2u_mcu.c
@@ -41,11 +41,11 @@ mt76x2u_mcu_function_select(struct mt76x2_dev *dev, enum mcu_function func,
 	};
 	struct sk_buff *skb;
 
-	skb = mt76u_mcu_msg_alloc(&msg, sizeof(msg));
+	skb = mt76_mcu_msg_alloc(dev, &msg, sizeof(msg));
 	if (!skb)
 		return -ENOMEM;
-	return mt76u_mcu_send_msg(&dev->mt76, skb, CMD_FUN_SET_OP,
-				  func != Q_SELECT);
+	return mt76_mcu_send_msg(dev, skb, CMD_FUN_SET_OP,
+				 func != Q_SELECT);
 }
 
 int mt76x2u_mcu_set_radio_state(struct mt76x2_dev *dev, bool val)
@@ -59,11 +59,11 @@ int mt76x2u_mcu_set_radio_state(struct mt76x2_dev *dev, bool val)
 	};
 	struct sk_buff *skb;
 
-	skb = mt76u_mcu_msg_alloc(&msg, sizeof(msg));
+	skb = mt76_mcu_msg_alloc(dev, &msg, sizeof(msg));
 	if (!skb)
 		return -ENOMEM;
-	return mt76u_mcu_send_msg(&dev->mt76, skb, CMD_POWER_SAVING_OP,
-				  false);
+	return mt76_mcu_send_msg(dev, skb, CMD_POWER_SAVING_OP,
+				 false);
 }
 
 int mt76x2u_mcu_load_cr(struct mt76x2_dev *dev, u8 type, u8 temp_level,
@@ -89,10 +89,10 @@ int mt76x2u_mcu_load_cr(struct mt76x2_dev *dev, u8 type, u8 temp_level,
 	msg.cfg = cpu_to_le32(val);
 
 	/* first set the channel without the extension channel info */
-	skb = mt76u_mcu_msg_alloc(&msg, sizeof(msg));
+	skb = mt76_mcu_msg_alloc(dev, &msg, sizeof(msg));
 	if (!skb)
 		return -ENOMEM;
-	return mt76u_mcu_send_msg(&dev->mt76, skb, CMD_LOAD_CR, true);
+	return mt76_mcu_send_msg(dev, skb, CMD_LOAD_CR, true);
 }
 
 int mt76x2u_mcu_set_channel(struct mt76x2_dev *dev, u8 channel, u8 bw,
@@ -117,20 +117,20 @@ int mt76x2u_mcu_set_channel(struct mt76x2_dev *dev, u8 channel, u8 bw,
 	struct sk_buff *skb;
 
 	/* first set the channel without the extension channel info */
-	skb = mt76u_mcu_msg_alloc(&msg, sizeof(msg));
+	skb = mt76_mcu_msg_alloc(dev, &msg, sizeof(msg));
 	if (!skb)
 		return -ENOMEM;
 
-	mt76u_mcu_send_msg(&dev->mt76, skb, CMD_SWITCH_CHANNEL_OP, true);
+	mt76_mcu_send_msg(dev, skb, CMD_SWITCH_CHANNEL_OP, true);
 
 	usleep_range(5000, 10000);
 
 	msg.ext_chan = 0xe0 + bw_index;
-	skb = mt76u_mcu_msg_alloc(&msg, sizeof(msg));
+	skb = mt76_mcu_msg_alloc(dev, &msg, sizeof(msg));
 	if (!skb)
 		return -ENOMEM;
 
-	return mt76u_mcu_send_msg(&dev->mt76, skb, CMD_SWITCH_CHANNEL_OP, true);
+	return mt76_mcu_send_msg(dev, skb, CMD_SWITCH_CHANNEL_OP, true);
 }
 
 int mt76x2u_mcu_calibrate(struct mt76x2_dev *dev, enum mcu_calibration type,
@@ -145,10 +145,10 @@ int mt76x2u_mcu_calibrate(struct mt76x2_dev *dev, enum mcu_calibration type,
 	};
 	struct sk_buff *skb;
 
-	skb = mt76u_mcu_msg_alloc(&msg, sizeof(msg));
+	skb = mt76_mcu_msg_alloc(dev, &msg, sizeof(msg));
 	if (!skb)
 		return -ENOMEM;
-	return mt76u_mcu_send_msg(&dev->mt76, skb, CMD_CALIBRATION_OP, true);
+	return mt76_mcu_send_msg(dev, skb, CMD_CALIBRATION_OP, true);
 }
 
 int mt76x2u_mcu_init_gain(struct mt76x2_dev *dev, u8 channel, u32 gain,
@@ -166,10 +166,10 @@ int mt76x2u_mcu_init_gain(struct mt76x2_dev *dev, u8 channel, u32 gain,
 	if (force)
 		msg.channel |= cpu_to_le32(BIT(31));
 
-	skb = mt76u_mcu_msg_alloc(&msg, sizeof(msg));
+	skb = mt76_mcu_msg_alloc(dev, &msg, sizeof(msg));
 	if (!skb)
 		return -ENOMEM;
-	return mt76u_mcu_send_msg(&dev->mt76, skb, CMD_INIT_GAIN_OP, true);
+	return mt76_mcu_send_msg(dev, skb, CMD_INIT_GAIN_OP, true);
 }
 
 int mt76x2u_mcu_set_dynamic_vga(struct mt76x2_dev *dev, u8 channel, bool ap,
@@ -192,10 +192,10 @@ int mt76x2u_mcu_set_dynamic_vga(struct mt76x2_dev *dev, u8 channel, bool ap,
 		val |= BIT(30);
 	msg.channel = cpu_to_le32(val);
 
-	skb = mt76u_mcu_msg_alloc(&msg, sizeof(msg));
+	skb = mt76_mcu_msg_alloc(dev, &msg, sizeof(msg));
 	if (!skb)
 		return -ENOMEM;
-	return mt76u_mcu_send_msg(&dev->mt76, skb, CMD_DYNC_VGA_OP, true);
+	return mt76_mcu_send_msg(dev, skb, CMD_DYNC_VGA_OP, true);
 }
 
 int mt76x2u_mcu_tssi_comp(struct mt76x2_dev *dev,
@@ -210,10 +210,10 @@ int mt76x2u_mcu_tssi_comp(struct mt76x2_dev *dev,
 	};
 	struct sk_buff *skb;
 
-	skb = mt76u_mcu_msg_alloc(&msg, sizeof(msg));
+	skb = mt76_mcu_msg_alloc(dev, &msg, sizeof(msg));
 	if (!skb)
 		return -ENOMEM;
-	return mt76u_mcu_send_msg(&dev->mt76, skb, CMD_CALIBRATION_OP, true);
+	return mt76_mcu_send_msg(dev, skb, CMD_CALIBRATION_OP, true);
 }
 
 static void mt76x2u_mcu_load_ivb(struct mt76x2_dev *dev)
diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
index aca6dcfe7a98..17ad8a8f1c56 100644
--- a/drivers/net/wireless/mediatek/mt76/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/usb.c
@@ -203,15 +203,15 @@ mt76u_req_wr_rp(struct mt76_dev *dev, u32 base,
 	return 0;
 }
 
-int mt76u_wr_rp(struct mt76_dev *dev, u32 base,
-		const struct mt76_reg_pair *data, int n)
+static int
+mt76u_wr_rp(struct mt76_dev *dev, u32 base,
+	    const struct mt76_reg_pair *data, int n)
 {
 	if (test_bit(MT76_STATE_MCU_RUNNING, &dev->state))
-		return mt76u_mcu_wr_rp(dev, base, data, n);
+		return dev->mcu_ops->mcu_wr_rp(dev, base, data, n);
 	else
 		return mt76u_req_wr_rp(dev, base, data, n);
 }
-EXPORT_SYMBOL_GPL(mt76u_wr_rp);
 
 static int
 mt76u_req_rd_rp(struct mt76_dev *dev, u32 base, struct mt76_reg_pair *data,
@@ -230,15 +230,15 @@ mt76u_req_rd_rp(struct mt76_dev *dev, u32 base, struct mt76_reg_pair *data,
 	return 0;
 }
 
-int mt76u_rd_rp(struct mt76_dev *dev, u32 base,
-		struct mt76_reg_pair *data, int n)
+static int
+mt76u_rd_rp(struct mt76_dev *dev, u32 base,
+	    struct mt76_reg_pair *data, int n)
 {
 	if (test_bit(MT76_STATE_MCU_RUNNING, &dev->state))
-		return mt76u_mcu_rd_rp(dev, base, data, n);
+		return dev->mcu_ops->mcu_rd_rp(dev, base, data, n);
 	else
 		return mt76u_req_rd_rp(dev, base, data, n);
 }
-EXPORT_SYMBOL_GPL(mt76u_rd_rp);
 
 static int
 mt76u_set_endpoints(struct usb_interface *intf,
diff --git a/drivers/net/wireless/mediatek/mt76/usb_mcu.c b/drivers/net/wireless/mediatek/mt76/usb_mcu.c
index 7cbc02d8ec35..362a6de73fc1 100644
--- a/drivers/net/wireless/mediatek/mt76/usb_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/usb_mcu.c
@@ -28,7 +28,8 @@
 
 #define MT_INBAND_PACKET_MAX_LEN	192
 
-struct sk_buff *mt76u_mcu_msg_alloc(const void *data, int len)
+static struct sk_buff *
+mt76u_mcu_msg_alloc(const void *data, int len)
 {
 	struct sk_buff *skb;
 
@@ -41,7 +42,6 @@ struct sk_buff *mt76u_mcu_msg_alloc(const void *data, int len)
 
 	return skb;
 }
-EXPORT_SYMBOL_GPL(mt76u_mcu_msg_alloc);
 
 void mt76u_mcu_complete_urb(struct urb *urb)
 {
@@ -125,8 +125,9 @@ static int mt76u_mcu_wait_resp(struct mt76_dev *dev, u8 seq)
 	return -ETIMEDOUT;
 }
 
-int __mt76u_mcu_send_msg(struct mt76_dev *dev, struct sk_buff *skb,
-			 int cmd, bool wait_resp)
+static int
+__mt76u_mcu_send_msg(struct mt76_dev *dev, struct sk_buff *skb,
+		     int cmd, bool wait_resp)
 {
 	struct usb_interface *intf = to_usb_interface(dev->dev);
 	struct usb_device *udev = interface_to_usbdev(intf);
@@ -164,10 +165,10 @@ int __mt76u_mcu_send_msg(struct mt76_dev *dev, struct sk_buff *skb,
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(__mt76u_mcu_send_msg);
 
-int mt76u_mcu_send_msg(struct mt76_dev *dev, struct sk_buff *skb,
-		       int cmd, bool wait_resp)
+static int
+mt76u_mcu_send_msg(struct mt76_dev *dev, struct sk_buff *skb,
+		   int cmd, bool wait_resp)
 {
 	struct mt76_usb *usb = &dev->usb;
 	int err;
@@ -178,15 +179,15 @@ int mt76u_mcu_send_msg(struct mt76_dev *dev, struct sk_buff *skb,
 
 	return err;
 }
-EXPORT_SYMBOL_GPL(mt76u_mcu_send_msg);
 
 static inline void skb_put_le32(struct sk_buff *skb, u32 val)
 {
 	put_unaligned_le32(val, skb_put(skb, 4));
 }
 
-int mt76u_mcu_wr_rp(struct mt76_dev *dev, u32 base,
-		    const struct mt76_reg_pair *data, int n)
+static int
+mt76u_mcu_wr_rp(struct mt76_dev *dev, u32 base,
+		const struct mt76_reg_pair *data, int n)
 {
 	const int CMD_RANDOM_WRITE = 12;
 	const int max_vals_per_cmd = MT_INBAND_PACKET_MAX_LEN / 8;
@@ -215,8 +216,9 @@ int mt76u_mcu_wr_rp(struct mt76_dev *dev, u32 base,
 	return mt76u_mcu_wr_rp(dev, base, data + cnt, n - cnt);
 }
 
-int mt76u_mcu_rd_rp(struct mt76_dev *dev, u32 base,
-		    struct mt76_reg_pair *data, int n)
+static int
+mt76u_mcu_rd_rp(struct mt76_dev *dev, u32 base,
+		struct mt76_reg_pair *data, int n)
 {
 	const int CMD_RANDOM_READ = 10;
 	const int max_vals_per_cmd = MT_INBAND_PACKET_MAX_LEN / 8;
-- 
2.18.0
