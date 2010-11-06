Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:33441 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755391Ab0KFOuF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Nov 2010 10:50:05 -0400
Received: by mail-ey0-f174.google.com with SMTP id 27so2216256eye.19
        for <linux-wireless@vger.kernel.org>; Sat, 06 Nov 2010 07:50:05 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 18/18] rt2x00: Add watchdog functions for HW queue
Date: Sat, 6 Nov 2010 15:49:01 +0100
Cc: linux-wireless@vger.kernel.org
References: <201011061544.00876.IvDoorn@gmail.com> <201011061548.24450.IvDoorn@gmail.com> <201011061548.43949.IvDoorn@gmail.com>
In-Reply-To: <201011061548.43949.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201011061549.02510.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ivo van Doorn <IvDoorn@gmail.com>

Add watchdog functions for managing the Queues inside the hardware.
Normally the driver doesn't have much to do with these queues
directly, but the Ralink drivers did implement watchdog functions
for these. These watchdog functions are not triggered that often,
compared to the other watchdog functions, but I have at least
seen them trigger once or twice during a long stresstest run.

v2: Add extra documentation for register fields

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800.h    |   16 +++++++++-
 drivers/net/wireless/rt2x00/rt2800usb.c |   45 ++++++++++++++++++++++++++++++-
 2 files changed, 58 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
index c2cc126..002224c 100644
--- a/drivers/net/wireless/rt2x00/rt2800.h
+++ b/drivers/net/wireless/rt2x00/rt2800.h
@@ -412,10 +412,22 @@
 #define BCN_OFFSET1_BCN7		FIELD32(0xff000000)
 
 /*
- * PBF registers
- * Most are for debug. Driver doesn't touch PBF register.
+ * TXRXQ_PCNT: PBF register
+ * PCNT_TX0Q: Page count for TX hardware queue 0
+ * PCNT_TX1Q: Page count for TX hardware queue 1
+ * PCNT_TX2Q: Page count for TX hardware queue 2
+ * PCNT_RX0Q: Page count for RX hardware queue
  */
 #define TXRXQ_PCNT			0x0438
+#define TXRXQ_PCNT_TX0Q			FIELD32(0x000000ff)
+#define TXRXQ_PCNT_TX1Q			FIELD32(0x0000ff00)
+#define TXRXQ_PCNT_TX2Q			FIELD32(0x00ff0000)
+#define TXRXQ_PCNT_RX0Q			FIELD32(0xff000000)
+
+/*
+ * PBF register
+ * Debug. Driver doesn't touch PBF register.
+ */
 #define PBF_DBG				0x043c
 
 /*
diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index f933371..389ecba 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -243,6 +243,49 @@ static int rt2800usb_set_device_state(struct rt2x00_dev *rt2x00dev,
 }
 
 /*
+ * Watchdog handlers
+ */
+static void rt2800usb_watchdog(struct rt2x00_dev *rt2x00dev)
+{
+	unsigned int i;
+	u32 reg;
+
+	rt2800_register_read(rt2x00dev, TXRXQ_PCNT, &reg);
+	if (rt2x00_get_field32(reg, TXRXQ_PCNT_TX0Q)) {
+		WARNING(rt2x00dev, "TX HW queue 0 timed out,"
+			" invoke forced kick");
+
+		rt2800_register_write(rt2x00dev, PBF_CFG, 0xf40012);
+
+		for (i = 0; i < 10; i++) {
+			udelay(10);
+			if (!rt2x00_get_field32(reg, TXRXQ_PCNT_TX0Q))
+				break;
+		}
+
+		rt2800_register_write(rt2x00dev, PBF_CFG, 0xf40006);
+	}
+
+	rt2800_register_read(rt2x00dev, TXRXQ_PCNT, &reg);
+	if (rt2x00_get_field32(reg, TXRXQ_PCNT_TX1Q)) {
+		WARNING(rt2x00dev, "TX HW queue 1 timed out,"
+			" invoke forced kick");
+
+		rt2800_register_write(rt2x00dev, PBF_CFG, 0xf4000a);
+
+		for (i = 0; i < 10; i++) {
+			udelay(10);
+			if (!rt2x00_get_field32(reg, TXRXQ_PCNT_TX1Q))
+				break;
+		}
+
+		rt2800_register_write(rt2x00dev, PBF_CFG, 0xf40006);
+	}
+
+	rt2x00usb_watchdog(rt2x00dev);
+}
+
+/*
  * TX descriptor initialization
  */
 static __le32 *rt2800usb_get_txwi(struct queue_entry *entry)
@@ -534,7 +577,7 @@ static const struct rt2x00lib_ops rt2800usb_rt2x00_ops = {
 	.link_stats		= rt2800_link_stats,
 	.reset_tuner		= rt2800_reset_tuner,
 	.link_tuner		= rt2800_link_tuner,
-	.watchdog		= rt2x00usb_watchdog,
+	.watchdog		= rt2800usb_watchdog,
 	.write_tx_desc		= rt2800usb_write_tx_desc,
 	.write_tx_data		= rt2800_write_tx_data,
 	.write_beacon		= rt2800_write_beacon,
-- 
1.7.2.3

