Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:36973 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726537AbeHYOTj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 25 Aug 2018 10:19:39 -0400
Received: by mail-wm0-f65.google.com with SMTP id n11-v6so3849615wmc.2
        for <linux-wireless@vger.kernel.org>; Sat, 25 Aug 2018 03:41:04 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: sgruszka@redhat.com, linux-wireless@vger.kernel.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH 02/16] mt76: split __mt76u_mcu_send_msg and mt76u_mcu_send_msg routines
Date: Sat, 25 Aug 2018 12:40:42 +0200
Message-Id: <20180825104056.9130-3-lorenzo.bianconi@redhat.com> (sfid-20180825_124111_630140_780FD5A4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Split __mt76u_mcu_send_msg and mt76u_mcu_send_msg in order to be reused
by mt76x0 driver in usb mcu layer unification between mt76x0 and
mt76x2u drivers

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76.h    |  2 ++
 drivers/net/wireless/mediatek/mt76/usb_mcu.c | 27 +++++++++++++-------
 2 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index fc27260080af..5579b90afee9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -623,6 +623,8 @@ int mt76u_mcu_fw_send_data(struct mt76_dev *dev, const void *data,
 			   int data_len, u32 max_payload, u32 offset);
 void mt76u_mcu_complete_urb(struct urb *urb);
 struct sk_buff *mt76u_mcu_msg_alloc(const void *data, int len);
+int __mt76u_mcu_send_msg(struct mt76_dev *dev, struct sk_buff *skb,
+			 int cmd, bool wait_resp);
 int mt76u_mcu_send_msg(struct mt76_dev *dev, struct sk_buff *skb,
 		       int cmd, bool wait_resp);
 void mt76u_mcu_fw_reset(struct mt76_dev *dev);
diff --git a/drivers/net/wireless/mediatek/mt76/usb_mcu.c b/drivers/net/wireless/mediatek/mt76/usb_mcu.c
index ebf3e7ffb26b..4039b0b709a0 100644
--- a/drivers/net/wireless/mediatek/mt76/usb_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/usb_mcu.c
@@ -86,8 +86,8 @@ static int mt76u_mcu_wait_resp(struct mt76_dev *dev, u8 seq)
 	return -ETIMEDOUT;
 }
 
-int mt76u_mcu_send_msg(struct mt76_dev *dev, struct sk_buff *skb,
-		       int cmd, bool wait_resp)
+int __mt76u_mcu_send_msg(struct mt76_dev *dev, struct sk_buff *skb,
+			 int cmd, bool wait_resp)
 {
 	struct usb_interface *intf = to_usb_interface(dev->dev);
 	struct usb_device *udev = interface_to_usbdev(intf);
@@ -100,8 +100,6 @@ int mt76u_mcu_send_msg(struct mt76_dev *dev, struct sk_buff *skb,
 	if (test_bit(MT76_REMOVED, &dev->state))
 		return 0;
 
-	mutex_lock(&usb->mcu.mutex);
-
 	pipe = usb_sndbulkpipe(udev, usb->out_ep[MT_EP_OUT_INBAND_CMD]);
 	if (wait_resp) {
 		seq = ++usb->mcu.msg_seq & 0xf;
@@ -114,22 +112,33 @@ int mt76u_mcu_send_msg(struct mt76_dev *dev, struct sk_buff *skb,
 	       MT_MCU_MSG_TYPE_CMD;
 	ret = mt76u_skb_dma_info(skb, CPU_TX_PORT, info);
 	if (ret)
-		goto out;
+		return ret;
 
 	ret = usb_bulk_msg(udev, pipe, skb->data, skb->len, &sent, 500);
 	if (ret)
-		goto out;
+		return ret;
 
 	if (wait_resp)
 		ret = mt76u_mcu_wait_resp(dev, seq);
 
-out:
-	mutex_unlock(&usb->mcu.mutex);
-
 	consume_skb(skb);
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(__mt76u_mcu_send_msg);
+
+int mt76u_mcu_send_msg(struct mt76_dev *dev, struct sk_buff *skb,
+		       int cmd, bool wait_resp)
+{
+	struct mt76_usb *usb = &dev->usb;
+	int err;
+
+	mutex_lock(&usb->mcu.mutex);
+	err = __mt76u_mcu_send_msg(dev, skb, cmd, wait_resp);
+	mutex_unlock(&usb->mcu.mutex);
+
+	return err;
+}
 EXPORT_SYMBOL_GPL(mt76u_mcu_send_msg);
 
 void mt76u_mcu_fw_reset(struct mt76_dev *dev)
-- 
2.18.0
