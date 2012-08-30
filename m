Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews08.kpnxchange.com ([213.75.39.13]:3102 "EHLO
	cpsmtpb-ews08.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752541Ab2H3VEg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Aug 2012 17:04:36 -0400
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: <users@rt2x00.serialmonkey.com>, Ivo van Doorn <IvDoorn@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	<stable@vger.kernel.org>
Subject: [PATCH 12/14] rt2x00: Align rt2800 GPIO_CTRL definition with datasheet.
Date: Thu, 30 Aug 2012 23:04:22 +0200
Message-Id: <1346360670-6498-5-git-send-email-gwingerde@gmail.com> (sfid-20120830_230459_435764_93940BFA)
In-Reply-To: <1346360670-6498-4-git-send-email-gwingerde@gmail.com>
References: <1346355248-5331-10-git-send-email-gwingerde@gmail.com>
 <1346360670-6498-1-git-send-email-gwingerde@gmail.com>
 <1346360670-6498-2-git-send-email-gwingerde@gmail.com>
 <1346360670-6498-3-git-send-email-gwingerde@gmail.com>
 <1346360670-6498-4-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rename GPIO_CTRL_CFG to GPIO_CTRL as that is the name according to
the datasheet.
Rename GPIO_CTRL_CFG_BIT<x> to GPIO_CTRL_VAL<x> and
GPIO_CTRL_CFG_GPIOD_BIT<x> to GPIO_CTRL_DIR<x> to represent the actual
meanings better.
Clean up list to mention all the active GPIO pins, not just a subset.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: <stable@vger.kernel.org>

diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
index e252e9b..e13916f 100644
--- a/drivers/net/wireless/rt2x00/rt2800.h
+++ b/drivers/net/wireless/rt2x00/rt2800.h
@@ -439,26 +439,33 @@
 #define WMM_TXOP1_CFG_AC3TXOP		FIELD32(0xffff0000)
 
 /*
- * GPIO_CTRL_CFG:
- * GPIOD: GPIO direction, 0: Output, 1: Input
- */
-#define GPIO_CTRL_CFG			0x0228
-#define GPIO_CTRL_CFG_BIT0		FIELD32(0x00000001)
-#define GPIO_CTRL_CFG_BIT1		FIELD32(0x00000002)
-#define GPIO_CTRL_CFG_BIT2		FIELD32(0x00000004)
-#define GPIO_CTRL_CFG_BIT3		FIELD32(0x00000008)
-#define GPIO_CTRL_CFG_BIT4		FIELD32(0x00000010)
-#define GPIO_CTRL_CFG_BIT5		FIELD32(0x00000020)
-#define GPIO_CTRL_CFG_BIT6		FIELD32(0x00000040)
-#define GPIO_CTRL_CFG_BIT7		FIELD32(0x00000080)
-#define GPIO_CTRL_CFG_GPIOD_BIT0	FIELD32(0x00000100)
-#define GPIO_CTRL_CFG_GPIOD_BIT1	FIELD32(0x00000200)
-#define GPIO_CTRL_CFG_GPIOD_BIT2	FIELD32(0x00000400)
-#define GPIO_CTRL_CFG_GPIOD_BIT3	FIELD32(0x00000800)
-#define GPIO_CTRL_CFG_GPIOD_BIT4	FIELD32(0x00001000)
-#define GPIO_CTRL_CFG_GPIOD_BIT5	FIELD32(0x00002000)
-#define GPIO_CTRL_CFG_GPIOD_BIT6	FIELD32(0x00004000)
-#define GPIO_CTRL_CFG_GPIOD_BIT7	FIELD32(0x00008000)
+ * GPIO_CTRL:
+ *	GPIO_CTRL_VALx: GPIO value
+ *	GPIO_CTRL_DIRx: GPIO direction: 0 = output; 1 = input
+ */
+#define GPIO_CTRL			0x0228
+#define GPIO_CTRL_VAL0			FIELD32(0x00000001)
+#define GPIO_CTRL_VAL1			FIELD32(0x00000002)
+#define GPIO_CTRL_VAL2			FIELD32(0x00000004)
+#define GPIO_CTRL_VAL3			FIELD32(0x00000008)
+#define GPIO_CTRL_VAL4			FIELD32(0x00000010)
+#define GPIO_CTRL_VAL5			FIELD32(0x00000020)
+#define GPIO_CTRL_VAL6			FIELD32(0x00000040)
+#define GPIO_CTRL_VAL7			FIELD32(0x00000080)
+#define GPIO_CTRL_DIR0			FIELD32(0x00000100)
+#define GPIO_CTRL_DIR1			FIELD32(0x00000200)
+#define GPIO_CTRL_DIR2			FIELD32(0x00000400)
+#define GPIO_CTRL_DIR3			FIELD32(0x00000800)
+#define GPIO_CTRL_DIR4			FIELD32(0x00001000)
+#define GPIO_CTRL_DIR5			FIELD32(0x00002000)
+#define GPIO_CTRL_DIR6			FIELD32(0x00004000)
+#define GPIO_CTRL_DIR7			FIELD32(0x00008000)
+#define GPIO_CTRL_VAL8			FIELD32(0x00010000)
+#define GPIO_CTRL_VAL9			FIELD32(0x00020000)
+#define GPIO_CTRL_VAL10			FIELD32(0x00040000)
+#define GPIO_CTRL_DIR8			FIELD32(0x01000000)
+#define GPIO_CTRL_DIR9			FIELD32(0x02000000)
+#define GPIO_CTRL_DIR10			FIELD32(0x04000000)
 
 /*
  * MCU_CMD_CFG
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index cb8c2ac..c3cae1d 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -923,8 +923,8 @@ int rt2800_rfkill_poll(struct rt2x00_dev *rt2x00dev)
 		rt2800_register_read(rt2x00dev, WLAN_FUN_CTRL, &reg);
 		return rt2x00_get_field32(reg, WLAN_GPIO_IN_BIT0);
 	} else {
-		rt2800_register_read(rt2x00dev, GPIO_CTRL_CFG, &reg);
-		return rt2x00_get_field32(reg, GPIO_CTRL_CFG_BIT2);
+		rt2800_register_read(rt2x00dev, GPIO_CTRL, &reg);
+		return rt2x00_get_field32(reg, GPIO_CTRL_VAL2);
 	}
 }
 EXPORT_SYMBOL_GPL(rt2800_rfkill_poll);
@@ -1570,10 +1570,10 @@ static void rt2800_set_ant_diversity(struct rt2x00_dev *rt2x00dev,
 		rt2800_mcu_request(rt2x00dev, MCU_ANT_SELECT, 0xff,
 				   eesk_pin, 0);
 
-	rt2800_register_read(rt2x00dev, GPIO_CTRL_CFG, &reg);
-	rt2x00_set_field32(&reg, GPIO_CTRL_CFG_GPIOD_BIT3, 0);
-	rt2x00_set_field32(&reg, GPIO_CTRL_CFG_BIT3, gpio_bit3);
-	rt2800_register_write(rt2x00dev, GPIO_CTRL_CFG, reg);
+	rt2800_register_read(rt2x00dev, GPIO_CTRL, &reg);
+	rt2x00_set_field32(&reg, GPIO_CTRL_DIR3, 0);
+	rt2x00_set_field32(&reg, GPIO_CTRL_VAL3, gpio_bit3);
+	rt2800_register_write(rt2x00dev, GPIO_CTRL, reg);
 }
 
 void rt2800_config_ant(struct rt2x00_dev *rt2x00dev, struct antenna_setup *ant)
@@ -1995,13 +1995,13 @@ static void rt2800_config_channel_rf3052(struct rt2x00_dev *rt2x00dev,
 		rt2800_rfcsr_write(rt2x00dev, 29, 0x9f);
 	}
 
-	rt2800_register_read(rt2x00dev, GPIO_CTRL_CFG, &reg);
-	rt2x00_set_field32(&reg, GPIO_CTRL_CFG_GPIOD_BIT7, 0);
+	rt2800_register_read(rt2x00dev, GPIO_CTRL, &reg);
+	rt2x00_set_field32(&reg, GPIO_CTRL_DIR7, 0);
 	if (rf->channel <= 14)
-		rt2x00_set_field32(&reg, GPIO_CTRL_CFG_BIT7, 1);
+		rt2x00_set_field32(&reg, GPIO_CTRL_VAL7, 1);
 	else
-		rt2x00_set_field32(&reg, GPIO_CTRL_CFG_BIT7, 0);
-	rt2800_register_write(rt2x00dev, GPIO_CTRL_CFG, reg);
+		rt2x00_set_field32(&reg, GPIO_CTRL_VAL7, 0);
+	rt2800_register_write(rt2x00dev, GPIO_CTRL, reg);
 
 	rt2800_rfcsr_read(rt2x00dev, 7, &rfcsr);
 	rt2x00_set_field8(&rfcsr, RFCSR7_RF_TUNING, 1);
@@ -3587,16 +3587,16 @@ static int rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
 		if (test_bit(CAPABILITY_BT_COEXIST, &rt2x00dev->cap_flags)) {
 			u32 reg;
 
-			rt2800_register_read(rt2x00dev, GPIO_CTRL_CFG, &reg);
-			rt2x00_set_field32(&reg, GPIO_CTRL_CFG_GPIOD_BIT3, 0);
-			rt2x00_set_field32(&reg, GPIO_CTRL_CFG_GPIOD_BIT6, 0);
-			rt2x00_set_field32(&reg, GPIO_CTRL_CFG_BIT3, 0);
-			rt2x00_set_field32(&reg, GPIO_CTRL_CFG_BIT6, 0);
+			rt2800_register_read(rt2x00dev, GPIO_CTRL, &reg);
+			rt2x00_set_field32(&reg, GPIO_CTRL_DIR3, 0);
+			rt2x00_set_field32(&reg, GPIO_CTRL_DIR6, 0);
+			rt2x00_set_field32(&reg, GPIO_CTRL_VAL3, 0);
+			rt2x00_set_field32(&reg, GPIO_CTRL_VAL6, 0);
 			if (ant == 0)
-				rt2x00_set_field32(&reg, GPIO_CTRL_CFG_BIT3, 1);
+				rt2x00_set_field32(&reg, GPIO_CTRL_VAL3, 1);
 			else if (ant == 1)
-				rt2x00_set_field32(&reg, GPIO_CTRL_CFG_BIT6, 1);
-			rt2800_register_write(rt2x00dev, GPIO_CTRL_CFG, reg);
+				rt2x00_set_field32(&reg, GPIO_CTRL_VAL6, 1);
+			rt2800_register_write(rt2x00dev, GPIO_CTRL, reg);
 		}
 
 		/* This chip has hardware antenna diversity*/
-- 
1.7.11.1

