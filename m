Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:2612 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750964Ab2H3Tkg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Aug 2012 15:40:36 -0400
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: <users@rt2x00.serialmonkey.com>, Ivo van Doorn <IvDoorn@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	<stable@vger.kernel.org>
Subject: [PATCH 04/14] rt2x00: Align rt2500pci GPIOCSR definition with datasheet.
Date: Thu, 30 Aug 2012 21:34:03 +0200
Message-Id: <1346355248-5331-5-git-send-email-gwingerde@gmail.com> (sfid-20120830_214105_332558_60C39C23)
In-Reply-To: <1346355248-5331-4-git-send-email-gwingerde@gmail.com>
References: <1346355248-5331-1-git-send-email-gwingerde@gmail.com>
 <1346355248-5331-2-git-send-email-gwingerde@gmail.com>
 <1346355248-5331-3-git-send-email-gwingerde@gmail.com>
 <1346355248-5331-4-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rename GPIOCSR_BIT<x> to GPIOCSR_VAL<x> to represent the actual
meaning better.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: <stable@vger.kernel.org>

diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index d2cf8a4..959d565 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -205,7 +205,7 @@ static int rt2500pci_rfkill_poll(struct rt2x00_dev *rt2x00dev)
 	u32 reg;
 
 	rt2x00pci_register_read(rt2x00dev, GPIOCSR, &reg);
-	return rt2x00_get_field32(reg, GPIOCSR_BIT0);
+	return rt2x00_get_field32(reg, GPIOCSR_VAL0);
 }
 
 #ifdef CONFIG_RT2X00_LIB_LEDS
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.h b/drivers/net/wireless/rt2x00/rt2500pci.h
index 2aad7ba..9c10068 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.h
+++ b/drivers/net/wireless/rt2x00/rt2500pci.h
@@ -789,16 +789,18 @@
 
 /*
  * GPIOCSR: GPIO control register.
+ *	GPIOCSR_VALx: GPIO value
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
 #define GPIOCSR_DIR0			FIELD32(0x00000100)
 #define GPIOCSR_DIR1			FIELD32(0x00000200)
 #define GPIOCSR_DIR2			FIELD32(0x00000400)
-- 
1.7.11.1

