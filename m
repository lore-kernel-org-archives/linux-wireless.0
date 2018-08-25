Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:35375 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726624AbeHYOTm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 25 Aug 2018 10:19:42 -0400
Received: by mail-wm0-f66.google.com with SMTP id o18-v6so3864492wmc.0
        for <linux-wireless@vger.kernel.org>; Sat, 25 Aug 2018 03:41:06 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: sgruszka@redhat.com, linux-wireless@vger.kernel.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH 04/16] mt76: add multiple regs read support to usb_mcu layer
Date: Sat, 25 Aug 2018 12:40:44 +0200
Message-Id: <20180825104056.9130-5-lorenzo.bianconi@redhat.com> (sfid-20180825_124112_828435_8EB59983)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Introduce multiple regs read support to mcu layer in mt76-usb module.
Multiple regs read will be reused by mt76x0 driver in usb mcu layer
unification between mt76x0 and mt76x2u drivers

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76.h    |  6 +++
 drivers/net/wireless/mediatek/mt76/usb_mcu.c | 39 +++++++++++++++++++-
 2 files changed, 44 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index f84f35c2e37a..e9e46612c7f3 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -312,6 +312,12 @@ struct mt76_usb {
 		struct completion cmpl;
 		struct mt76u_buf res;
 		u32 msg_seq;
+
+		/* multiple reads */
+		struct mt76_reg_pair *rp;
+		int rp_len;
+		u32 base;
+		bool burst;
 	} mcu;
 };
 
diff --git a/drivers/net/wireless/mediatek/mt76/usb_mcu.c b/drivers/net/wireless/mediatek/mt76/usb_mcu.c
index 1edc5c3d637b..d80dbfafba6d 100644
--- a/drivers/net/wireless/mediatek/mt76/usb_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/usb_mcu.c
@@ -49,12 +49,44 @@ void mt76u_mcu_complete_urb(struct urb *urb)
 }
 EXPORT_SYMBOL_GPL(mt76u_mcu_complete_urb);
 
+static void
+mt76u_multiple_mcu_reads(struct mt76_dev *dev, u8 *data,
+			 int len)
+{
+	struct mt76_usb *usb = &dev->usb;
+	u32 reg, val;
+	int i;
+
+	if (usb->mcu.burst) {
+		WARN_ON_ONCE(len / 4 != usb->mcu.rp_len);
+
+		reg = usb->mcu.rp[0].reg - usb->mcu.base;
+		for (i = 0; i < usb->mcu.rp_len; i++) {
+			val = get_unaligned_le32(data + 4 * i);
+			usb->mcu.rp[i].reg = reg++;
+			usb->mcu.rp[i].value = val;
+		}
+	} else {
+		WARN_ON_ONCE(len / 8 != usb->mcu.rp_len);
+
+		for (i = 0; i < usb->mcu.rp_len; i++) {
+			reg = get_unaligned_le32(data + 8 * i) -
+			      usb->mcu.base;
+			val = get_unaligned_le32(data + 8 * i + 4);
+
+			WARN_ON_ONCE(usb->mcu.rp[i].reg != reg);
+			usb->mcu.rp[i].value = val;
+		}
+	}
+}
+
 static int mt76u_mcu_wait_resp(struct mt76_dev *dev, u8 seq)
 {
 	struct mt76_usb *usb = &dev->usb;
 	struct mt76u_buf *buf = &usb->mcu.res;
 	int i, ret;
 	u32 rxfce;
+	u8 *data;
 
 	for (i = 0; i < 5; i++) {
 		if (!wait_for_completion_timeout(&usb->mcu.cmpl,
@@ -64,7 +96,12 @@ static int mt76u_mcu_wait_resp(struct mt76_dev *dev, u8 seq)
 		if (buf->urb->status)
 			return -EIO;
 
-		rxfce = get_unaligned_le32(sg_virt(&buf->urb->sg[0]));
+		data = sg_virt(&buf->urb->sg[0]);
+		if (usb->mcu.rp)
+			mt76u_multiple_mcu_reads(dev, data + 4,
+						 buf->urb->actual_length - 8);
+
+		rxfce = get_unaligned_le32(data);
 		ret = mt76u_submit_buf(dev, USB_DIR_IN,
 				       MT_EP_IN_CMD_RESP,
 				       buf, GFP_KERNEL,
-- 
2.18.0
