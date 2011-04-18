Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53097 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754136Ab1DRNgU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2011 09:36:20 -0400
Received: by mail-fx0-f46.google.com with SMTP id 17so2833789fxm.19
        for <linux-wireless@vger.kernel.org>; Mon, 18 Apr 2011 06:36:19 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 21/23] rt2x00: Optimize register access in rt2800usb
Date: Mon, 18 Apr 2011 15:34:22 +0200
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201104181526.01722.IvDoorn@gmail.com> <201104181533.42494.IvDoorn@gmail.com> <201104181534.02553.IvDoorn@gmail.com>
In-Reply-To: <201104181534.02553.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201104181534.23133.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ivo van Doorn <IvDoorn@gmail.com>

All register reads/writes in rt2800usb were previously done with
rt2800_register_read/rt2800_register_write. These however indirectly
call rt2x00usb_register_read/rt2x00usb_register_write which adds an
additional overhead of at least one call and several move instructions
to each register access.

Replacing the calls to rt2800_register_read/rt2800_register_write with
direct calls to rt2x00usb_register_read/rt2x00usb_register_write gets
rid of quite a number of instructions in the drivers hotpaths (IRQ
handling and txdone handling).

For consistency replace all references to rt2800_register_read/write
with the rt2x00usb_register_read/write variants.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800usb.c |   56 +++++++++++++++---------------
 1 files changed, 28 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index fd8aa99..44ead75 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -59,16 +59,16 @@ static void rt2800usb_start_queue(struct data_queue *queue)
 
 	switch (queue->qid) {
 	case QID_RX:
-		rt2800_register_read(rt2x00dev, MAC_SYS_CTRL, &reg);
+		rt2x00usb_register_read(rt2x00dev, MAC_SYS_CTRL, &reg);
 		rt2x00_set_field32(&reg, MAC_SYS_CTRL_ENABLE_RX, 1);
-		rt2800_register_write(rt2x00dev, MAC_SYS_CTRL, reg);
+		rt2x00usb_register_write(rt2x00dev, MAC_SYS_CTRL, reg);
 		break;
 	case QID_BEACON:
-		rt2800_register_read(rt2x00dev, BCN_TIME_CFG, &reg);
+		rt2x00usb_register_read(rt2x00dev, BCN_TIME_CFG, &reg);
 		rt2x00_set_field32(&reg, BCN_TIME_CFG_TSF_TICKING, 1);
 		rt2x00_set_field32(&reg, BCN_TIME_CFG_TBTT_ENABLE, 1);
 		rt2x00_set_field32(&reg, BCN_TIME_CFG_BEACON_GEN, 1);
-		rt2800_register_write(rt2x00dev, BCN_TIME_CFG, reg);
+		rt2x00usb_register_write(rt2x00dev, BCN_TIME_CFG, reg);
 		break;
 	default:
 		break;
@@ -82,16 +82,16 @@ static void rt2800usb_stop_queue(struct data_queue *queue)
 
 	switch (queue->qid) {
 	case QID_RX:
-		rt2800_register_read(rt2x00dev, MAC_SYS_CTRL, &reg);
+		rt2x00usb_register_read(rt2x00dev, MAC_SYS_CTRL, &reg);
 		rt2x00_set_field32(&reg, MAC_SYS_CTRL_ENABLE_RX, 0);
-		rt2800_register_write(rt2x00dev, MAC_SYS_CTRL, reg);
+		rt2x00usb_register_write(rt2x00dev, MAC_SYS_CTRL, reg);
 		break;
 	case QID_BEACON:
-		rt2800_register_read(rt2x00dev, BCN_TIME_CFG, &reg);
+		rt2x00usb_register_read(rt2x00dev, BCN_TIME_CFG, &reg);
 		rt2x00_set_field32(&reg, BCN_TIME_CFG_TSF_TICKING, 0);
 		rt2x00_set_field32(&reg, BCN_TIME_CFG_TBTT_ENABLE, 0);
 		rt2x00_set_field32(&reg, BCN_TIME_CFG_BEACON_GEN, 0);
-		rt2800_register_write(rt2x00dev, BCN_TIME_CFG, reg);
+		rt2x00usb_register_write(rt2x00dev, BCN_TIME_CFG, reg);
 		break;
 	default:
 		break;
@@ -185,11 +185,11 @@ static int rt2800usb_write_firmware(struct rt2x00_dev *rt2x00dev,
 	/*
 	 * Write firmware to device.
 	 */
-	rt2800_register_multiwrite(rt2x00dev, FIRMWARE_IMAGE_BASE,
-				   data + offset, length);
+	rt2x00usb_register_multiwrite(rt2x00dev, FIRMWARE_IMAGE_BASE,
+				      data + offset, length);
 
-	rt2800_register_write(rt2x00dev, H2M_MAILBOX_CID, ~0);
-	rt2800_register_write(rt2x00dev, H2M_MAILBOX_STATUS, ~0);
+	rt2x00usb_register_write(rt2x00dev, H2M_MAILBOX_CID, ~0);
+	rt2x00usb_register_write(rt2x00dev, H2M_MAILBOX_STATUS, ~0);
 
 	/*
 	 * Send firmware request to device to load firmware,
@@ -204,7 +204,7 @@ static int rt2800usb_write_firmware(struct rt2x00_dev *rt2x00dev,
 	}
 
 	msleep(10);
-	rt2800_register_write(rt2x00dev, H2M_MAILBOX_CSR, 0);
+	rt2x00usb_register_write(rt2x00dev, H2M_MAILBOX_CSR, 0);
 
 	return 0;
 }
@@ -222,22 +222,22 @@ static int rt2800usb_init_registers(struct rt2x00_dev *rt2x00dev)
 	if (rt2800_wait_csr_ready(rt2x00dev))
 		return -EBUSY;
 
-	rt2800_register_read(rt2x00dev, PBF_SYS_CTRL, &reg);
-	rt2800_register_write(rt2x00dev, PBF_SYS_CTRL, reg & ~0x00002000);
+	rt2x00usb_register_read(rt2x00dev, PBF_SYS_CTRL, &reg);
+	rt2x00usb_register_write(rt2x00dev, PBF_SYS_CTRL, reg & ~0x00002000);
 
-	rt2800_register_write(rt2x00dev, PWR_PIN_CFG, 0x00000003);
+	rt2x00usb_register_write(rt2x00dev, PWR_PIN_CFG, 0x00000003);
 
-	rt2800_register_read(rt2x00dev, MAC_SYS_CTRL, &reg);
+	rt2x00usb_register_read(rt2x00dev, MAC_SYS_CTRL, &reg);
 	rt2x00_set_field32(&reg, MAC_SYS_CTRL_RESET_CSR, 1);
 	rt2x00_set_field32(&reg, MAC_SYS_CTRL_RESET_BBP, 1);
-	rt2800_register_write(rt2x00dev, MAC_SYS_CTRL, reg);
+	rt2x00usb_register_write(rt2x00dev, MAC_SYS_CTRL, reg);
 
-	rt2800_register_write(rt2x00dev, USB_DMA_CFG, 0x00000000);
+	rt2x00usb_register_write(rt2x00dev, USB_DMA_CFG, 0x00000000);
 
 	rt2x00usb_vendor_request_sw(rt2x00dev, USB_DEVICE_MODE, 0,
 				    USB_MODE_RESET, REGISTER_TIMEOUT);
 
-	rt2800_register_write(rt2x00dev, MAC_SYS_CTRL, 0x00000000);
+	rt2x00usb_register_write(rt2x00dev, MAC_SYS_CTRL, 0x00000000);
 
 	return 0;
 }
@@ -249,7 +249,7 @@ static int rt2800usb_enable_radio(struct rt2x00_dev *rt2x00dev)
 	if (unlikely(rt2800_wait_wpdma_ready(rt2x00dev)))
 		return -EIO;
 
-	rt2800_register_read(rt2x00dev, USB_DMA_CFG, &reg);
+	rt2x00usb_register_read(rt2x00dev, USB_DMA_CFG, &reg);
 	rt2x00_set_field32(&reg, USB_DMA_CFG_PHY_CLEAR, 0);
 	rt2x00_set_field32(&reg, USB_DMA_CFG_RX_BULK_AGG_EN, 0);
 	rt2x00_set_field32(&reg, USB_DMA_CFG_RX_BULK_AGG_TIMEOUT, 128);
@@ -262,7 +262,7 @@ static int rt2800usb_enable_radio(struct rt2x00_dev *rt2x00dev)
 			    / 1024) - 3);
 	rt2x00_set_field32(&reg, USB_DMA_CFG_RX_BULK_EN, 1);
 	rt2x00_set_field32(&reg, USB_DMA_CFG_TX_BULK_EN, 1);
-	rt2800_register_write(rt2x00dev, USB_DMA_CFG, reg);
+	rt2x00usb_register_write(rt2x00dev, USB_DMA_CFG, reg);
 
 	return rt2800_enable_radio(rt2x00dev);
 }
@@ -338,12 +338,12 @@ static void rt2800usb_watchdog(struct rt2x00_dev *rt2x00dev)
 	unsigned int i;
 	u32 reg;
 
-	rt2800_register_read(rt2x00dev, TXRXQ_PCNT, &reg);
+	rt2x00usb_register_read(rt2x00dev, TXRXQ_PCNT, &reg);
 	if (rt2x00_get_field32(reg, TXRXQ_PCNT_TX0Q)) {
 		WARNING(rt2x00dev, "TX HW queue 0 timed out,"
 			" invoke forced kick\n");
 
-		rt2800_register_write(rt2x00dev, PBF_CFG, 0xf40012);
+		rt2x00usb_register_write(rt2x00dev, PBF_CFG, 0xf40012);
 
 		for (i = 0; i < 10; i++) {
 			udelay(10);
@@ -351,15 +351,15 @@ static void rt2800usb_watchdog(struct rt2x00_dev *rt2x00dev)
 				break;
 		}
 
-		rt2800_register_write(rt2x00dev, PBF_CFG, 0xf40006);
+		rt2x00usb_register_write(rt2x00dev, PBF_CFG, 0xf40006);
 	}
 
-	rt2800_register_read(rt2x00dev, TXRXQ_PCNT, &reg);
+	rt2x00usb_register_read(rt2x00dev, TXRXQ_PCNT, &reg);
 	if (rt2x00_get_field32(reg, TXRXQ_PCNT_TX1Q)) {
 		WARNING(rt2x00dev, "TX HW queue 1 timed out,"
 			" invoke forced kick\n");
 
-		rt2800_register_write(rt2x00dev, PBF_CFG, 0xf4000a);
+		rt2x00usb_register_write(rt2x00dev, PBF_CFG, 0xf4000a);
 
 		for (i = 0; i < 10; i++) {
 			udelay(10);
@@ -367,7 +367,7 @@ static void rt2800usb_watchdog(struct rt2x00_dev *rt2x00dev)
 				break;
 		}
 
-		rt2800_register_write(rt2x00dev, PBF_CFG, 0xf40006);
+		rt2x00usb_register_write(rt2x00dev, PBF_CFG, 0xf40006);
 	}
 
 	rt2x00usb_watchdog(rt2x00dev);
-- 
1.7.2.3

