Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:1591 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754114Ab2HaRWW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Aug 2012 13:22:22 -0400
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: <users@rt2x00.serialmonkey.com>, Ivo van Doorn <IvDoorn@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH v2 5/6] rt2x00: Unify GPIO register field namings
Date: Fri, 31 Aug 2012 19:22:13 +0200
Message-Id: <1346433734-3337-6-git-send-email-gwingerde@gmail.com> (sfid-20120831_192228_539055_B0CDE4E2)
In-Reply-To: <1346433734-3337-5-git-send-email-gwingerde@gmail.com>
References: <1346433734-3337-1-git-send-email-gwingerde@gmail.com>
 <1346433734-3337-2-git-send-email-gwingerde@gmail.com>
 <1346433734-3337-3-git-send-email-gwingerde@gmail.com>
 <1346433734-3337-4-git-send-email-gwingerde@gmail.com>
 <1346433734-3337-5-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The various rt2x00 drivers use different methods to name the different
GPIO register fields indicating the GPIO pin value and the fields
indicating the direction.
Start using a unified naming scheme for the GPIO register fields:
	- <csr>_VAL<x> for fields indicating the GPIO pin value.
	- <csr>_DIR<x> for fields indicating the GPIO pin direction.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index 64328af..6458ab8 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -205,7 +205,7 @@ static int rt2400pci_rfkill_poll(struct rt2x00_dev *rt2x00dev)
 	u32 reg;
 
 	rt2x00pci_register_read(rt2x00dev, GPIOCSR, &reg);
-	return rt2x00_get_field32(reg, GPIOCSR_BIT0);
+	return rt2x00_get_field32(reg, GPIOCSR_VAL0);
 }
 
 #ifdef CONFIG_RT2X00_LIB_LEDS
@@ -1629,7 +1629,7 @@ static int rt2400pci_probe_hw(struct rt2x00_dev *rt2x00dev)
 	 * rfkill switch GPIO pin correctly.
 	 */
 	rt2x00pci_register_read(rt2x00dev, GPIOCSR, &reg);
-	rt2x00_set_field32(&reg, GPIOCSR_BIT8, 1);
+	rt2x00_set_field32(&reg, GPIOCSR_DIR0, 1);
 	rt2x00pci_register_write(rt2x00dev, GPIOCSR, reg);
 
 	/*
diff --git a/drivers/net/wireless/rt2x00/rt2400pci.h b/drivers/net/wireless/rt2x00/rt2400pci.h
index 9d78a53..e4b07f0 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.h
+++ b/drivers/net/wireless/rt2x00/rt2400pci.h
@@ -660,24 +660,26 @@
 
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
-#define GPIOCSR_BIT8			FIELD32(0x00000100)
-#define GPIOCSR_BIT9			FIELD32(0x00000200)
-#define GPIOCSR_BIT10			FIELD32(0x00000400)
-#define GPIOCSR_BIT11			FIELD32(0x00000800)
-#define GPIOCSR_BIT12			FIELD32(0x00001000)
-#define GPIOCSR_BIT13			FIELD32(0x00002000)
-#define GPIOCSR_BIT14			FIELD32(0x00004000)
-#define GPIOCSR_BIT15			FIELD32(0x00008000)
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
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index 3de0406..68bca14 100644
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
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 89fee31..f95b551 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -283,7 +283,7 @@ static int rt2500usb_rfkill_poll(struct rt2x00_dev *rt2x00dev)
 	u16 reg;
 
 	rt2500usb_register_read(rt2x00dev, MAC_CSR19, &reg);
-	return rt2x00_get_field16(reg, MAC_CSR19_BIT7);
+	return rt2x00_get_field16(reg, MAC_CSR19_VAL7);
 }
 
 #ifdef CONFIG_RT2X00_LIB_LEDS
@@ -1786,7 +1786,7 @@ static int rt2500usb_probe_hw(struct rt2x00_dev *rt2x00dev)
 	 * rfkill switch GPIO pin correctly.
 	 */
 	rt2500usb_register_read(rt2x00dev, MAC_CSR19, &reg);
-	rt2x00_set_field16(&reg, MAC_CSR19_BIT8, 0);
+	rt2x00_set_field16(&reg, MAC_CSR19_DIR0, 0);
 	rt2500usb_register_write(rt2x00dev, MAC_CSR19, reg);
 
 	/*
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.h b/drivers/net/wireless/rt2x00/rt2500usb.h
index 9652300..1b91a4c 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.h
+++ b/drivers/net/wireless/rt2x00/rt2500usb.h
@@ -187,24 +187,26 @@
 
 /*
  * MAC_CSR19: GPIO control register.
+ *	MAC_CSR19_VALx: GPIO value
+ *	MAC_CSR19_DIRx: GPIO direction: 0 = input; 1 = output
  */
 #define MAC_CSR19			0x0426
-#define MAC_CSR19_BIT0			FIELD16(0x0001)
-#define MAC_CSR19_BIT1			FIELD16(0x0002)
-#define MAC_CSR19_BIT2			FIELD16(0x0004)
-#define MAC_CSR19_BIT3			FIELD16(0x0008)
-#define MAC_CSR19_BIT4			FIELD16(0x0010)
-#define MAC_CSR19_BIT5			FIELD16(0x0020)
-#define MAC_CSR19_BIT6			FIELD16(0x0040)
-#define MAC_CSR19_BIT7			FIELD16(0x0080)
-#define MAC_CSR19_BIT8			FIELD16(0x0100)
-#define MAC_CSR19_BIT9			FIELD16(0x0200)
-#define MAC_CSR19_BIT10			FIELD16(0x0400)
-#define MAC_CSR19_BIT11			FIELD16(0x0800)
-#define MAC_CSR19_BIT12			FIELD16(0x1000)
-#define MAC_CSR19_BIT13			FIELD16(0x2000)
-#define MAC_CSR19_BIT14			FIELD16(0x4000)
-#define MAC_CSR19_BIT15			FIELD16(0x8000)
+#define MAC_CSR19_VAL0			FIELD16(0x0001)
+#define MAC_CSR19_VAL1			FIELD16(0x0002)
+#define MAC_CSR19_VAL2			FIELD16(0x0004)
+#define MAC_CSR19_VAL3			FIELD16(0x0008)
+#define MAC_CSR19_VAL4			FIELD16(0x0010)
+#define MAC_CSR19_VAL5			FIELD16(0x0020)
+#define MAC_CSR19_VAL6			FIELD16(0x0040)
+#define MAC_CSR19_VAL7			FIELD16(0x0080)
+#define MAC_CSR19_DIR0			FIELD16(0x0100)
+#define MAC_CSR19_DIR1			FIELD16(0x0200)
+#define MAC_CSR19_DIR2			FIELD16(0x0400)
+#define MAC_CSR19_DIR3			FIELD16(0x0800)
+#define MAC_CSR19_DIR4			FIELD16(0x1000)
+#define MAC_CSR19_DIR5			FIELD16(0x2000)
+#define MAC_CSR19_DIR6			FIELD16(0x4000)
+#define MAC_CSR19_DIR7			FIELD16(0x8000)
 
 /*
  * MAC_CSR20: LED control register.
diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
index a838e17..e13916f 100644
--- a/drivers/net/wireless/rt2x00/rt2800.h
+++ b/drivers/net/wireless/rt2x00/rt2800.h
@@ -439,32 +439,33 @@
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
-#define GPIO_CTRL_CFG_BIT8		FIELD32(0x00010000)
-#define GPIO_CTRL_CFG_BIT9		FIELD32(0x00020000)
-#define GPIO_CTRL_CFG_BIT10		FIELD32(0x00040000)
-#define GPIO_CTRL_CFG_GPIOD_BIT8	FIELD32(0x01000000)
-#define GPIO_CTRL_CFG_GPIOD_BIT9	FIELD32(0x02000000)
-#define GPIO_CTRL_CFG_GPIOD_BIT10	FIELD32(0x04000000)
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
diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index 4765bbd..0965540 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -1000,9 +1000,9 @@ static int rt2800pci_probe_hw(struct rt2x00_dev *rt2x00dev)
 	 * Enable rfkill polling by setting GPIO direction of the
 	 * rfkill switch GPIO pin correctly.
 	 */
-	rt2x00pci_register_read(rt2x00dev, GPIO_CTRL_CFG, &reg);
-	rt2x00_set_field32(&reg, GPIO_CTRL_CFG_GPIOD_BIT2, 1);
-	rt2x00pci_register_write(rt2x00dev, GPIO_CTRL_CFG, reg);
+	rt2x00pci_register_read(rt2x00dev, GPIO_CTRL, &reg);
+	rt2x00_set_field32(&reg, GPIO_CTRL_DIR2, 1);
+	rt2x00pci_register_write(rt2x00dev, GPIO_CTRL, reg);
 
 	/*
 	 * Initialize hw specifications.
diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 52a32b5..5390632 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -753,9 +753,9 @@ static int rt2800usb_probe_hw(struct rt2x00_dev *rt2x00dev)
 	 * Enable rfkill polling by setting GPIO direction of the
 	 * rfkill switch GPIO pin correctly.
 	 */
-	rt2x00usb_register_read(rt2x00dev, GPIO_CTRL_CFG, &reg);
-	rt2x00_set_field32(&reg, GPIO_CTRL_CFG_GPIOD_BIT2, 1);
-	rt2x00usb_register_write(rt2x00dev, GPIO_CTRL_CFG, reg);
+	rt2x00usb_register_read(rt2x00dev, GPIO_CTRL, &reg);
+	rt2x00_set_field32(&reg, GPIO_CTRL_DIR2, 1);
+	rt2x00usb_register_write(rt2x00dev, GPIO_CTRL, reg);
 
 	/*
 	 * Initialize hw specifications.
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index b8ec961..2673e05 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -243,7 +243,7 @@ static int rt61pci_rfkill_poll(struct rt2x00_dev *rt2x00dev)
 	u32 reg;
 
 	rt2x00pci_register_read(rt2x00dev, MAC_CSR13, &reg);
-	return rt2x00_get_field32(reg, MAC_CSR13_BIT5);
+	return rt2x00_get_field32(reg, MAC_CSR13_VAL5);
 }
 
 #ifdef CONFIG_RT2X00_LIB_LEDS
@@ -715,11 +715,11 @@ static void rt61pci_config_antenna_2529_rx(struct rt2x00_dev *rt2x00dev,
 
 	rt2x00pci_register_read(rt2x00dev, MAC_CSR13, &reg);
 
-	rt2x00_set_field32(&reg, MAC_CSR13_BIT4, p1);
-	rt2x00_set_field32(&reg, MAC_CSR13_BIT12, 0);
+	rt2x00_set_field32(&reg, MAC_CSR13_DIR4, 0);
+	rt2x00_set_field32(&reg, MAC_CSR13_VAL4, p1);
 
-	rt2x00_set_field32(&reg, MAC_CSR13_BIT3, !p2);
-	rt2x00_set_field32(&reg, MAC_CSR13_BIT11, 0);
+	rt2x00_set_field32(&reg, MAC_CSR13_DIR3, 0);
+	rt2x00_set_field32(&reg, MAC_CSR13_VAL3, !p2);
 
 	rt2x00pci_register_write(rt2x00dev, MAC_CSR13, reg);
 }
@@ -2855,7 +2855,7 @@ static int rt61pci_probe_hw(struct rt2x00_dev *rt2x00dev)
 	 * rfkill switch GPIO pin correctly.
 	 */
 	rt2x00pci_register_read(rt2x00dev, MAC_CSR13, &reg);
-	rt2x00_set_field32(&reg, MAC_CSR13_BIT13, 1);
+	rt2x00_set_field32(&reg, MAC_CSR13_DIR5, 1);
 	rt2x00pci_register_write(rt2x00dev, MAC_CSR13, reg);
 
 	/*
diff --git a/drivers/net/wireless/rt2x00/rt61pci.h b/drivers/net/wireless/rt2x00/rt61pci.h
index 9ee0c33..9bc6b60 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.h
+++ b/drivers/net/wireless/rt2x00/rt61pci.h
@@ -357,20 +357,22 @@ struct hw_pairwise_ta_entry {
 
 /*
  * MAC_CSR13: GPIO.
+ *	MAC_CSR13_VALx: GPIO value
+ *	MAC_CSR13_DIRx: GPIO direction: 0 = output; 1 = input
  */
 #define MAC_CSR13			0x3034
-#define MAC_CSR13_BIT0			FIELD32(0x00000001)
-#define MAC_CSR13_BIT1			FIELD32(0x00000002)
-#define MAC_CSR13_BIT2			FIELD32(0x00000004)
-#define MAC_CSR13_BIT3			FIELD32(0x00000008)
-#define MAC_CSR13_BIT4			FIELD32(0x00000010)
-#define MAC_CSR13_BIT5			FIELD32(0x00000020)
-#define MAC_CSR13_BIT8			FIELD32(0x00000100)
-#define MAC_CSR13_BIT9			FIELD32(0x00000200)
-#define MAC_CSR13_BIT10			FIELD32(0x00000400)
-#define MAC_CSR13_BIT11			FIELD32(0x00000800)
-#define MAC_CSR13_BIT12			FIELD32(0x00001000)
-#define MAC_CSR13_BIT13			FIELD32(0x00002000)
+#define MAC_CSR13_VAL0			FIELD32(0x00000001)
+#define MAC_CSR13_VAL1			FIELD32(0x00000002)
+#define MAC_CSR13_VAL2			FIELD32(0x00000004)
+#define MAC_CSR13_VAL3			FIELD32(0x00000008)
+#define MAC_CSR13_VAL4			FIELD32(0x00000010)
+#define MAC_CSR13_VAL5			FIELD32(0x00000020)
+#define MAC_CSR13_DIR0			FIELD32(0x00000100)
+#define MAC_CSR13_DIR1			FIELD32(0x00000200)
+#define MAC_CSR13_DIR2			FIELD32(0x00000400)
+#define MAC_CSR13_DIR3			FIELD32(0x00000800)
+#define MAC_CSR13_DIR4			FIELD32(0x00001000)
+#define MAC_CSR13_DIR5			FIELD32(0x00002000)
 
 /*
  * MAC_CSR14: LED control register.
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 248436c..cfa9f37 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -189,7 +189,7 @@ static int rt73usb_rfkill_poll(struct rt2x00_dev *rt2x00dev)
 	u32 reg;
 
 	rt2x00usb_register_read(rt2x00dev, MAC_CSR13, &reg);
-	return rt2x00_get_field32(reg, MAC_CSR13_BIT7);
+	return rt2x00_get_field32(reg, MAC_CSR13_VAL7);
 }
 
 #ifdef CONFIG_RT2X00_LIB_LEDS
@@ -2195,7 +2195,7 @@ static int rt73usb_probe_hw(struct rt2x00_dev *rt2x00dev)
 	 * rfkill switch GPIO pin correctly.
 	 */
 	rt2x00usb_register_read(rt2x00dev, MAC_CSR13, &reg);
-	rt2x00_set_field32(&reg, MAC_CSR13_BIT15, 0);
+	rt2x00_set_field32(&reg, MAC_CSR13_DIR7, 0);
 	rt2x00usb_register_write(rt2x00dev, MAC_CSR13, reg);
 
 	/*
diff --git a/drivers/net/wireless/rt2x00/rt73usb.h b/drivers/net/wireless/rt2x00/rt73usb.h
index df1cc11..7577e0b 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.h
+++ b/drivers/net/wireless/rt2x00/rt73usb.h
@@ -267,24 +267,26 @@ struct hw_pairwise_ta_entry {
 
 /*
  * MAC_CSR13: GPIO.
+ *	MAC_CSR13_VALx: GPIO value
+ *	MAC_CSR13_DIRx: GPIO direction: 0 = input; 1 = output
  */
 #define MAC_CSR13			0x3034
-#define MAC_CSR13_BIT0			FIELD32(0x00000001)
-#define MAC_CSR13_BIT1			FIELD32(0x00000002)
-#define MAC_CSR13_BIT2			FIELD32(0x00000004)
-#define MAC_CSR13_BIT3			FIELD32(0x00000008)
-#define MAC_CSR13_BIT4			FIELD32(0x00000010)
-#define MAC_CSR13_BIT5			FIELD32(0x00000020)
-#define MAC_CSR13_BIT6			FIELD32(0x00000040)
-#define MAC_CSR13_BIT7			FIELD32(0x00000080)
-#define MAC_CSR13_BIT8			FIELD32(0x00000100)
-#define MAC_CSR13_BIT9			FIELD32(0x00000200)
-#define MAC_CSR13_BIT10			FIELD32(0x00000400)
-#define MAC_CSR13_BIT11			FIELD32(0x00000800)
-#define MAC_CSR13_BIT12			FIELD32(0x00001000)
-#define MAC_CSR13_BIT13			FIELD32(0x00002000)
-#define MAC_CSR13_BIT14			FIELD32(0x00004000)
-#define MAC_CSR13_BIT15			FIELD32(0x00008000)
+#define MAC_CSR13_VAL0			FIELD32(0x00000001)
+#define MAC_CSR13_VAL1			FIELD32(0x00000002)
+#define MAC_CSR13_VAL2			FIELD32(0x00000004)
+#define MAC_CSR13_VAL3			FIELD32(0x00000008)
+#define MAC_CSR13_VAL4			FIELD32(0x00000010)
+#define MAC_CSR13_VAL5			FIELD32(0x00000020)
+#define MAC_CSR13_VAL6			FIELD32(0x00000040)
+#define MAC_CSR13_VAL7			FIELD32(0x00000080)
+#define MAC_CSR13_DIR0			FIELD32(0x00000100)
+#define MAC_CSR13_DIR1			FIELD32(0x00000200)
+#define MAC_CSR13_DIR2			FIELD32(0x00000400)
+#define MAC_CSR13_DIR3			FIELD32(0x00000800)
+#define MAC_CSR13_DIR4			FIELD32(0x00001000)
+#define MAC_CSR13_DIR5			FIELD32(0x00002000)
+#define MAC_CSR13_DIR6			FIELD32(0x00004000)
+#define MAC_CSR13_DIR7			FIELD32(0x00008000)
 
 /*
  * MAC_CSR14: LED control register.
-- 
1.7.11.1

