Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews09.kpnxchange.com ([213.75.39.14]:4270 "EHLO
	cpsmtpb-ews09.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750913Ab2H3Tkg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Aug 2012 15:40:36 -0400
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: <users@rt2x00.serialmonkey.com>, Ivo van Doorn <IvDoorn@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	<stable@vger.kernel.org>
Subject: [PATCH 02/14] rt2x00: Align rt2400pci GPIOCSR definition with datasheet.
Date: Thu, 30 Aug 2012 21:34:01 +0200
Message-Id: <1346355248-5331-3-git-send-email-gwingerde@gmail.com> (sfid-20120830_214047_079637_4F07B6B3)
In-Reply-To: <1346355248-5331-2-git-send-email-gwingerde@gmail.com>
References: <1346355248-5331-1-git-send-email-gwingerde@gmail.com>
 <1346355248-5331-2-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Datasheet indicates additional fields to set the GPIO direction.
At the same time rename GPIOCSR_BIT<x> to GPIOCSR_VAL<x> to represent the
actual meaning better.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: <stable@vger.kernel.org>

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index 8b9dbd7..94f9aa2 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -205,7 +205,7 @@ static int rt2400pci_rfkill_poll(struct rt2x00_dev *rt2x00dev)
 	u32 reg;
 
 	rt2x00pci_register_read(rt2x00dev, GPIOCSR, &reg);
-	return rt2x00_get_field32(reg, GPIOCSR_BIT0);
+	return rt2x00_get_field32(reg, GPIOCSR_VAL0);
 }
 
 #ifdef CONFIG_RT2X00_LIB_LEDS
diff --git a/drivers/net/wireless/rt2x00/rt2400pci.h b/drivers/net/wireless/rt2x00/rt2400pci.h
index d3a4a68..e4b07f0 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.h
+++ b/drivers/net/wireless/rt2x00/rt2400pci.h
@@ -660,16 +660,26 @@
 
 /*
  * GPIOCSR: GPIO control register.
+ *	GPIOCSR_VALx: Actual GPIO pin x value
+ *	GPIOCSR_DIRx: GPIO direction: 0 = output; 1 = input
  */
 #define GPIOCSR				0x0120
-#define GPIOCSR_BIT0			FIELD32(0x00000001)
-#define GPIOCSR_BIT1			FIELD32(0x00000002)
-#define GPIOCSR_BIT2			FIELD32(0x00000004)
-#define GPIOCSR_BIT3			FIELD32(0x00000008)
-#define GPIOCSR_BIT4			FIELD32(0x00000010)
-#define GPIOCSR_BIT5			FIELD32(0x00000020)
-#define GPIOCSR_BIT6			FIELD32(0x00000040)
-#define GPIOCSR_BIT7			FIELD32(0x00000080)
+#define GPIOCSR_VAL0			FIELD32(0x00000001)
+#define GPIOCSR_VAL1			FIELD32(0x00000002)
+#define GPIOCSR_VAL2			FIELD32(0x00000004)
+#define GPIOCSR_VAL3			FIELD32(0x00000008)
+#define GPIOCSR_VAL4			FIELD32(0x00000010)
+#define GPIOCSR_VAL5			FIELD32(0x00000020)
+#define GPIOCSR_VAL6			FIELD32(0x00000040)
+#define GPIOCSR_VAL7			FIELD32(0x00000080)
+#define GPIOCSR_DIR0			FIELD32(0x00000100)
+#define GPIOCSR_DIR1			FIELD32(0x00000200)
+#define GPIOCSR_DIR2			FIELD32(0x00000400)
+#define GPIOCSR_DIR3			FIELD32(0x00000800)
+#define GPIOCSR_DIR4			FIELD32(0x00001000)
+#define GPIOCSR_DIR5			FIELD32(0x00002000)
+#define GPIOCSR_DIR6			FIELD32(0x00004000)
+#define GPIOCSR_DIR7			FIELD32(0x00008000)
 
 /*
  * BBPPCSR: BBP Pin control register.
-- 
1.7.11.1

