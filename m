Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:36983 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726842AbeHYOTw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 25 Aug 2018 10:19:52 -0400
Received: by mail-wm0-f66.google.com with SMTP id n11-v6so3849870wmc.2
        for <linux-wireless@vger.kernel.org>; Sat, 25 Aug 2018 03:41:16 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: sgruszka@redhat.com, linux-wireless@vger.kernel.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH 13/16] mt76x0: use mt76u_mcu_send_msg utility routine to send fw cmds
Date: Sat, 25 Aug 2018 12:40:53 +0200
Message-Id: <20180825104056.9130-14-lorenzo.bianconi@redhat.com> (sfid-20180825_124130_291150_28347134)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use mt76u_mcu_send_msg/__mt76u_mcu_send_msg utility routines to
send commands to usb mcu. Remove following unused routines:
- mt76x0_mcu_wait_resp
- __mt76x0_mcu_msg_send
- mt76x0_mcu_msg_send
- mt76x0_dma_skb_wrap_cmd
- trace_mt_mcu_msg_send_cs
- mt76x0_mcu_cmd_deinit

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../net/wireless/mediatek/mt76/mt76x0/init.c  |   4 +-
 .../net/wireless/mediatek/mt76/mt76x0/mcu.c   | 226 +++---------------
 .../net/wireless/mediatek/mt76/mt76x0/mcu.h   |   1 -
 3 files changed, 31 insertions(+), 200 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
index 48d7eb1599d7..d3bb173a9474 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
@@ -465,7 +465,7 @@ int mt76x0_init_hardware(struct mt76x0_dev *dev)
 err_rx:
 	mt76x0_dma_cleanup(dev);
 err_mcu:
-	mt76x0_mcu_cmd_deinit(dev);
+	mt76u_mcu_deinit(&dev->mt76);
 err:
 	mt76x0_chip_onoff(dev, false, false);
 	return ret;
@@ -478,7 +478,7 @@ void mt76x0_cleanup(struct mt76x0_dev *dev)
 
 	mt76x0_stop_hardware(dev);
 	mt76x0_dma_cleanup(dev);
-	mt76x0_mcu_cmd_deinit(dev);
+	mt76u_mcu_deinit(&dev->mt76);
 }
 
 struct mt76x0_dev *mt76x0_alloc_device(struct device *pdev)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mcu.c b/drivers/net/wireless/mediatek/mt76/mt76x0/mcu.c
index 7c2217307828..39b2ec0c1ee0 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mcu.c
@@ -40,157 +40,6 @@ static inline void skb_put_le32(struct sk_buff *skb, u32 val)
 	put_unaligned_le32(val, skb_put(skb, 4));
 }
 
-static inline void mt76x0_dma_skb_wrap_cmd(struct sk_buff *skb,
-					    u8 seq, enum mcu_cmd cmd)
-{
-	WARN_ON(mt76x0_dma_skb_wrap(skb, CPU_TX_PORT, DMA_COMMAND,
-				     FIELD_PREP(MT_TXD_CMD_SEQ, seq) |
-				     FIELD_PREP(MT_TXD_CMD_TYPE, cmd)));
-}
-
-static inline void trace_mt76x0_mcu_msg_send_cs(struct mt76_dev *dev,
-					    struct sk_buff *skb, bool need_resp)
-{
-	u32 i, csum = 0;
-
-	for (i = 0; i < skb->len / 4; i++)
-		csum ^= get_unaligned_le32(skb->data + i * 4);
-
-	trace_mt76x0_mcu_msg_send(dev, skb, csum, need_resp);
-}
-
-static void mt76x0_read_resp_regs(struct mt76x0_dev *dev, int len)
-{
-	int i;
-	int n = dev->mcu.reg_pairs_len;
-	u8 *buf = dev->mcu.resp.buf;
-
-	buf += 4;
-	len -= 8;
-
-	if (dev->mcu.burst_read) {
-		u32 reg = dev->mcu.reg_pairs[0].reg - dev->mcu.reg_base;
-
-		WARN_ON_ONCE(len/4 != n);
-		for (i = 0; i < n; i++) {
-			u32 val = get_unaligned_le32(buf + 4*i);
-
-			dev->mcu.reg_pairs[i].reg = reg++;
-			dev->mcu.reg_pairs[i].value = val;
-		}
-	} else {
-		WARN_ON_ONCE(len/8 != n);
-		for (i = 0; i < n; i++) {
-			u32 reg = get_unaligned_le32(buf + 8*i) - dev->mcu.reg_base;
-			u32 val = get_unaligned_le32(buf + 8*i + 4);
-
-			WARN_ON_ONCE(dev->mcu.reg_pairs[i].reg != reg);
-			dev->mcu.reg_pairs[i].value = val;
-		}
-	}
-}
-
-static int mt76x0_mcu_wait_resp(struct mt76x0_dev *dev, u8 seq)
-{
-	struct urb *urb = dev->mcu.resp.urb;
-	struct mt76_usb *usb = &dev->mt76.usb;
-	u32 rxfce;
-	int urb_status, ret, try = 5;
-
-	while (try--) {
-		if (!wait_for_completion_timeout(&usb->mcu.cmpl,
-						 msecs_to_jiffies(300))) {
-			dev_warn(dev->mt76.dev, "Warning: %s retrying\n", __func__);
-			continue;
-		}
-
-		/* Make copies of important data before reusing the urb */
-		rxfce = get_unaligned_le32(dev->mcu.resp.buf);
-		urb_status = urb->status * mt76x0_urb_has_error(urb);
-
-		if (urb_status == 0 && dev->mcu.reg_pairs)
-			mt76x0_read_resp_regs(dev, urb->actual_length);
-
-		ret = mt76x0_usb_submit_buf(dev, USB_DIR_IN, MT_EP_IN_CMD_RESP,
-					     &dev->mcu.resp, GFP_KERNEL,
-					     mt76u_mcu_complete_urb,
-					     &usb->mcu.cmpl);
-		if (ret)
-			return ret;
-
-		if (urb_status)
-			dev_err(dev->mt76.dev, "Error: MCU resp urb failed:%d\n",
-				urb_status);
-
-		if (FIELD_GET(MT_RXD_CMD_INFO_CMD_SEQ, rxfce) == seq &&
-		    FIELD_GET(MT_RXD_CMD_INFO_EVT_TYPE, rxfce) == CMD_DONE)
-			return 0;
-
-		dev_err(dev->mt76.dev, "Error: MCU resp evt:%lx seq:%hhx-%lx!\n",
-			FIELD_GET(MT_RXD_CMD_INFO_EVT_TYPE, rxfce),
-			seq, FIELD_GET(MT_RXD_CMD_INFO_CMD_SEQ, rxfce));
-	}
-
-	dev_err(dev->mt76.dev, "Error: %s timed out\n", __func__);
-	return -ETIMEDOUT;
-}
-
-static int
-__mt76x0_mcu_msg_send(struct mt76x0_dev *dev, struct sk_buff *skb,
-		      enum mcu_cmd cmd, bool wait_resp)
-{
-	struct usb_device *usb_dev = mt76x0_to_usb_dev(dev);
-	struct mt76_usb *usb = &dev->mt76.usb;
-	unsigned cmd_pipe = usb_sndbulkpipe(usb_dev,
-					    usb->out_ep[MT_EP_OUT_INBAND_CMD]);
-	int sent, ret;
-	u8 seq = 0;
-
-	if (wait_resp)
-		while (!seq)
-			seq = ++dev->mcu.msg_seq & 0xf;
-
-	mt76x0_dma_skb_wrap_cmd(skb, seq, cmd);
-
-	if (&usb->mcu.cmpl.done)
-		dev_err(dev->mt76.dev, "Error: MCU response pre-completed!\n");
-
-	trace_mt76x0_mcu_msg_send_cs(&dev->mt76, skb, wait_resp);
-	trace_mt76x0_submit_urb_sync(&dev->mt76, cmd_pipe, skb->len);
-
-	ret = usb_bulk_msg(usb_dev, cmd_pipe, skb->data, skb->len, &sent, 500);
-	if (ret) {
-		dev_err(dev->mt76.dev, "Error: send MCU cmd failed:%d\n", ret);
-		goto out;
-	}
-	if (sent != skb->len)
-		dev_err(dev->mt76.dev, "Error: %s sent != skb->len\n", __func__);
-
-	if (wait_resp)
-		ret = mt76x0_mcu_wait_resp(dev, seq);
-
-out:
-	return ret;
-}
-
-static int
-mt76x0_mcu_msg_send(struct mt76x0_dev *dev, struct sk_buff *skb,
-		     enum mcu_cmd cmd, bool wait_resp)
-{
-	int ret;
-
-	if (test_bit(MT76_REMOVED, &dev->mt76.state))
-		return 0;
-
-	mutex_lock(&dev->mcu.mutex);
-	ret = __mt76x0_mcu_msg_send(dev, skb, cmd, wait_resp);
-	mutex_unlock(&dev->mcu.mutex);
-
-	consume_skb(skb);
-
-	return ret;
-}
-
 int mt76x0_mcu_function_select(struct mt76x0_dev *dev,
 			       enum mcu_function func, u32 val)
 {
@@ -206,7 +55,8 @@ int mt76x0_mcu_function_select(struct mt76x0_dev *dev,
 	skb = mt76u_mcu_msg_alloc(&msg, sizeof(msg));
 	if (!skb)
 		return -ENOMEM;
-	return mt76x0_mcu_msg_send(dev, skb, CMD_FUN_SET_OP, func == 5);
+	return mt76u_mcu_send_msg(&dev->mt76, skb, CMD_FUN_SET_OP,
+				  func == 5);
 }
 
 int
@@ -224,7 +74,8 @@ mt76x0_mcu_calibrate(struct mt76x0_dev *dev, enum mcu_calibrate cal, u32 val)
 	skb = mt76u_mcu_msg_alloc(&msg, sizeof(msg));
 	if (!skb)
 		return -ENOMEM;
-	return mt76x0_mcu_msg_send(dev, skb, CMD_CALIBRATION_OP, true);
+	return mt76u_mcu_send_msg(&dev->mt76, skb, CMD_CALIBRATION_OP,
+				  true);
 }
 
 int mt76x0_write_reg_pairs(struct mt76x0_dev *dev, u32 base,
@@ -249,7 +100,8 @@ int mt76x0_write_reg_pairs(struct mt76x0_dev *dev, u32 base,
 		skb_put_le32(skb, data[i].value);
 	}
 
-	ret = mt76x0_mcu_msg_send(dev, skb, CMD_RANDOM_WRITE, cnt == n);
+	ret = mt76u_mcu_send_msg(&dev->mt76, skb, CMD_RANDOM_WRITE,
+				 cnt == n);
 	if (ret)
 		return ret;
 
@@ -260,6 +112,7 @@ int mt76x0_read_reg_pairs(struct mt76x0_dev *dev, u32 base,
 			  struct mt76_reg_pair *data, int n)
 {
 	const int max_vals_per_cmd = INBAND_PACKET_MAX_LEN / 8;
+	struct mt76_usb *usb = &dev->mt76.usb;
 	struct sk_buff *skb;
 	int cnt, i, ret;
 
@@ -280,20 +133,19 @@ int mt76x0_read_reg_pairs(struct mt76x0_dev *dev, u32 base,
 		skb_put_le32(skb, data[i].value);
 	}
 
-	mutex_lock(&dev->mcu.mutex);
-
-	dev->mcu.reg_pairs = data;
-	dev->mcu.reg_pairs_len = n;
-	dev->mcu.reg_base = base;
-	dev->mcu.burst_read = false;
+	mutex_lock(&usb->mcu.mutex);
 
-	ret = __mt76x0_mcu_msg_send(dev, skb, CMD_RANDOM_READ, true);
+	usb->mcu.rp = data;
+	usb->mcu.rp_len = n;
+	usb->mcu.base = base;
+	usb->mcu.burst = false;
 
-	dev->mcu.reg_pairs = NULL;
+	ret = __mt76u_mcu_send_msg(&dev->mt76, skb, CMD_RANDOM_READ,
+				   true);
 
-	mutex_unlock(&dev->mcu.mutex);
+	usb->mcu.rp = NULL;
 
-	consume_skb(skb);
+	mutex_unlock(&usb->mcu.mutex);
 
 	return ret;
 
@@ -320,7 +172,8 @@ int mt76x0_burst_write_regs(struct mt76x0_dev *dev, u32 offset,
 	for (i = 0; i < cnt; i++)
 		skb_put_le32(skb, data[i]);
 
-	ret = mt76x0_mcu_msg_send(dev, skb, CMD_BURST_WRITE, cnt == n);
+	ret = mt76u_mcu_send_msg(&dev->mt76, skb, CMD_BURST_WRITE,
+				 cnt == n);
 	if (ret)
 		return ret;
 
@@ -333,6 +186,7 @@ static int mt76x0_burst_read_regs(struct mt76x0_dev *dev, u32 base,
 				  struct mt76_reg_pair *data, int n)
 {
 	const int max_vals_per_cmd = INBAND_PACKET_MAX_LEN / 4 - 1;
+	struct mt76_usb *usb = &dev->mt76.usb;
 	struct sk_buff *skb;
 	int cnt, ret;
 
@@ -351,18 +205,18 @@ static int mt76x0_burst_read_regs(struct mt76x0_dev *dev, u32 base,
 	skb_put_le32(skb, base + data[0].reg);
 	skb_put_le32(skb, n);
 
-	mutex_lock(&dev->mcu.mutex);
+	mutex_lock(&usb->mcu.mutex);
 
-	dev->mcu.reg_pairs = data;
-	dev->mcu.reg_pairs_len = n;
-	dev->mcu.reg_base = base;
-	dev->mcu.burst_read = true;
+	usb->mcu.rp = data;
+	usb->mcu.rp_len = n;
+	usb->mcu.base = base;
+	usb->mcu.burst = false;
 
-	ret = __mt76x0_mcu_msg_send(dev, skb, CMD_BURST_READ, true);
+	ret = __mt76u_mcu_send_msg(&dev->mt76, skb, CMD_BURST_READ, true);
 
-	dev->mcu.reg_pairs = NULL;
+	usb->mcu.rp = NULL;
 
-	mutex_unlock(&dev->mcu.mutex);
+	mutex_unlock(&usb->mcu.mutex);
 
 	consume_skb(skb);
 
@@ -611,31 +465,9 @@ int mt76x0_mcu_init(struct mt76x0_dev *dev)
 
 int mt76x0_mcu_cmd_init(struct mt76x0_dev *dev)
 {
-	struct mt76_usb *usb = &dev->mt76.usb;
-	int ret;
-
-	ret = mt76x0_mcu_function_select(dev, Q_SELECT, 1);
+	int ret = mt76x0_mcu_function_select(dev, Q_SELECT, 1);
 	if (ret)
 		return ret;
 
-	if (mt76x0_usb_alloc_buf(dev, MCU_RESP_URB_SIZE, &dev->mcu.resp)) {
-		mt76x0_usb_free_buf(dev, &dev->mcu.resp);
-		return -ENOMEM;
-	}
-
-	ret = mt76x0_usb_submit_buf(dev, USB_DIR_IN, MT_EP_IN_CMD_RESP,
-				     &dev->mcu.resp, GFP_KERNEL,
-				     mt76u_mcu_complete_urb, &usb->mcu.cmpl);
-	if (ret) {
-		mt76x0_usb_free_buf(dev, &dev->mcu.resp);
-		return ret;
-	}
-
-	return 0;
-}
-
-void mt76x0_mcu_cmd_deinit(struct mt76x0_dev *dev)
-{
-	usb_kill_urb(dev->mcu.resp.urb);
-	mt76x0_usb_free_buf(dev, &dev->mcu.resp);
+	return mt76u_mcu_init_rx(&dev->mt76);
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mcu.h b/drivers/net/wireless/mediatek/mt76/mt76x0/mcu.h
index 8c2f77f4c3f5..010a7f2bbae9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mcu.h
@@ -90,7 +90,6 @@ enum mcu_calibrate {
 
 int mt76x0_mcu_init(struct mt76x0_dev *dev);
 int mt76x0_mcu_cmd_init(struct mt76x0_dev *dev);
-void mt76x0_mcu_cmd_deinit(struct mt76x0_dev *dev);
 
 int
 mt76x0_mcu_calibrate(struct mt76x0_dev *dev, enum mcu_calibrate cal, u32 val);
-- 
2.18.0
