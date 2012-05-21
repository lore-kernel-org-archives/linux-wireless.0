Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37457 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505Ab2EUICR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 May 2012 04:02:17 -0400
Received: by pbbrp8 with SMTP id rp8so6604268pbb.19
        for <linux-wireless@vger.kernel.org>; Mon, 21 May 2012 01:02:17 -0700 (PDT)
From: Woody Hung <Woody.Hung@mediatek.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Woody Hung <Woody.Hung@mediatek.com>
Subject: [PATCH] rt2x00 : RT3290 chip support v1
Date: Mon, 21 May 2012 16:01:47 +0800
Message-Id: <1337587307-2740-1-git-send-email-Woody.Hung@mediatek.com> (sfid-20120521_100229_524806_0A85B982)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch support the new chipset rt3290 wifi implementation in rt2x00.
It initailize the related mac, bbp and rf register in startup phase.
And this patch modify the efuse read/write method for the different efuse data offset of rt3290.

Signed-off-by: Woody Hung <Woody.Hung@mediatek.com>
---
 drivers/net/wireless/rt2x00/Kconfig     |    8 +
 drivers/net/wireless/rt2x00/rt2800.h    |  153 ++++++++++++
 drivers/net/wireless/rt2x00/rt2800lib.c |  406 +++++++++++++++++++++++++++----
 drivers/net/wireless/rt2x00/rt2800lib.h |    1 +
 drivers/net/wireless/rt2x00/rt2800pci.c |   18 ++-
 drivers/net/wireless/rt2x00/rt2800pci.h |    1 +
 drivers/net/wireless/rt2x00/rt2x00.h    |    2 +
 drivers/net/wireless/rt2x00/rt2x00pci.c |    9 +
 8 files changed, 544 insertions(+), 54 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/Kconfig b/drivers/net/wireless/rt2x00/Kconfig
index 299c387..c7548da 100644
--- a/drivers/net/wireless/rt2x00/Kconfig
+++ b/drivers/net/wireless/rt2x00/Kconfig
@@ -99,6 +99,14 @@ config RT2800PCI_RT53XX
          rt2800pci driver.
          Supported chips: RT5390
 
+config RT2800PCI_RT3290
+       bool "rt2800pci - Include support for rt3290 devices (EXPERIMENTAL)"
+       depends on EXPERIMENTAL
+       default y
+       ---help---
+         This adds support for rt3290 wireless chipset family to the
+         rt2800pci driver.
+         Supported chips: RT3290
 endif
 
 config RT2500USB
diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
index 9348521..7a825b3 100644
--- a/drivers/net/wireless/rt2x00/rt2800.h
+++ b/drivers/net/wireless/rt2x00/rt2800.h
@@ -67,6 +67,7 @@
 #define RF3320				0x000b
 #define RF3322				0x000c
 #define RF3053				0x000d
+#define RF3290				0x3290
 #define RF5370				0x5370
 #define RF5372				0x5372
 #define RF5390				0x5390
@@ -114,6 +115,12 @@
  * Registers.
  */
 
+
+/*
+ * MAC_CSR0_3290: MAC_CSR0 for RT3290 to identity MAC version number.
+ */
+#define MAC_CSR0_3290				0x0000
+
 /*
  * E2PROM_CSR: PCI EEPROM control register.
  * RELOAD: Write 1 to reload eeprom content.
@@ -130,6 +137,147 @@
 #define E2PROM_CSR_RELOAD		FIELD32(0x00000080)
 
 /*
+ * CMB_CTRL_CFG
+ */
+#define CMB_CTRL		0x0020
+#define AUX_OPT_BIT0		FIELD32(0x00000001)
+#define AUX_OPT_BIT1		FIELD32(0x00000002)
+#define AUX_OPT_BIT2		FIELD32(0x00000004)
+#define AUX_OPT_BIT3		FIELD32(0x00000008)
+#define AUX_OPT_BIT4		FIELD32(0x00000010)
+#define AUX_OPT_BIT5		FIELD32(0x00000020)
+#define AUX_OPT_BIT6		FIELD32(0x00000040)
+#define AUX_OPT_BIT7		FIELD32(0x00000080)
+#define AUX_OPT_BIT8		FIELD32(0x00000100)
+#define AUX_OPT_BIT9		FIELD32(0x00000200)
+#define AUX_OPT_BIT10		FIELD32(0x00000400)
+#define AUX_OPT_BIT11		FIELD32(0x00000800)
+#define AUX_OPT_BIT12		FIELD32(0x00001000)
+#define AUX_OPT_BIT13		FIELD32(0x00002000)
+#define AUX_OPT_BIT14		FIELD32(0x00004000)
+#define AUX_OPT_BIT15		FIELD32(0x00008000)
+#define LDO25_LEVEL		FIELD32(0x00030000)
+#define LDO25_LARGEA		FIELD32(0x00040000)
+#define LDO25_FRC_ON		FIELD32(0x00080000)
+#define CMB_RSV			FIELD32(0x00300000)
+#define XTAL_RDY		FIELD32(0x00400000)
+#define PLL_LD			FIELD32(0x00800000)
+#define LDO_CORE_LEVEL		FIELD32(0x0F000000)
+#define LDO_BGSEL		FIELD32(0x30000000)
+#define LDO3_EN			FIELD32(0x40000000)
+#define LDO0_EN			FIELD32(0x80000000)
+
+/*
+ * EFUSE_CSR_3290: RT3290 EEPROM
+ */
+#define EFUSE_CTRL_3290			0x0024
+
+/*
+ * EFUSE_DATA3 of 3290
+ */
+#define EFUSE_DATA3_3290		0x0028
+
+/*
+ * EFUSE_DATA2 of 3290
+ */
+#define EFUSE_DATA2_3290		0x002c
+
+/*
+ * EFUSE_DATA1 of 3290
+ */
+#define EFUSE_DATA1_3290		0x0030
+
+/*
+ * EFUSE_DATA0 of 3290
+ */
+#define EFUSE_DATA0_3290		0x0034
+
+/*
+ * OSC_CTRL_CFG
+ * Ring oscillator configuration
+ */
+#define OSC_CTRL		0x0038
+#define OSC_REF_CYCLE		FIELD32(0x00001fff)
+#define OSC_RSV			FIELD32(0x0000e000)
+#define OSC_CAL_CNT		FIELD32(0x0fff0000)
+#define OSC_CAL_ACK		FIELD32(0x10000000)
+#define OSC_CLK_32K_VLD		FIELD32(0x20000000)
+#define OSC_CAL_REQ		FIELD32(0x40000000)
+#define OSC_ROSC_EN		FIELD32(0x80000000)
+
+/*
+ * COEX_CFG_0
+ */
+#define COEX_CFG0			0x0040
+#define COEX_CFG_ANT		FIELD32(0xff000000)
+/*
+ * COEX_CFG_1
+ */
+#define COEX_CFG1			0x0044
+
+/*
+ * COEX_CFG_2
+ */
+#define COEX_CFG2			0x0048
+
+/*
+ * PLL_CTRL_CFG
+ * PLL configuration register
+ */
+#define PLL_CTRL		0x0050
+#define PLL_RESERVED_INPUT1	FIELD32(0x000000ff)
+#define PLL_RESERVED_INPUT2	FIELD32(0x0000ff00)
+#define PLL_CONTROL		FIELD32(0x00070000)
+#define PLL_LPF_R1		FIELD32(0x00080000)
+#define PLL_LPF_C1_CTRL	FIELD32(0x00300000)
+#define PLL_LPF_C2_CTRL	FIELD32(0x00c00000)
+#define PLL_CP_CURRENT_CTRL	FIELD32(0x03000000)
+#define PLL_PFD_DELAY_CTRL	FIELD32(0x0c000000)
+#define PLL_LOCK_CTRL		FIELD32(0x70000000)
+#define PLL_VBGBK_EN		FIELD32(0x80000000)
+
+
+/*
+ * WLAN_CTRL_CFG
+ * RT3290 wlan configuration
+ */
+#define WLAN_FUN_CTRL			0x0080
+#define WLAN_EN				FIELD32(0x00000001)
+#define WLAN_CLK_EN			FIELD32(0x00000002)
+#define WLAN_RSV1			FIELD32(0x00000004)
+#define WLAN_RESET			FIELD32(0x00000008)
+#define PCIE_APP0_CLK_REQ		FIELD32(0x00000010)
+#define FRC_WL_ANT_SET			FIELD32(0x00000020)
+#define INV_TR_SW0			FIELD32(0x00000040)
+#define WLAN_GPIO_IN_BIT0		FIELD32(0x00000100)
+#define WLAN_GPIO_IN_BIT1		FIELD32(0x00000200)
+#define WLAN_GPIO_IN_BIT2		FIELD32(0x00000400)
+#define WLAN_GPIO_IN_BIT3		FIELD32(0x00000800)
+#define WLAN_GPIO_IN_BIT4		FIELD32(0x00001000)
+#define WLAN_GPIO_IN_BIT5		FIELD32(0x00002000)
+#define WLAN_GPIO_IN_BIT6		FIELD32(0x00004000)
+#define WLAN_GPIO_IN_BIT7		FIELD32(0x00008000)
+#define WLAN_GPIO_IN_BIT_ALL		FIELD32(0x0000ff00)
+#define WLAN_GPIO_OUT_BIT0		FIELD32(0x00010000)
+#define WLAN_GPIO_OUT_BIT1		FIELD32(0x00020000)
+#define WLAN_GPIO_OUT_BIT2		FIELD32(0x00040000)
+#define WLAN_GPIO_OUT_BIT3		FIELD32(0x00050000)
+#define WLAN_GPIO_OUT_BIT4		FIELD32(0x00100000)
+#define WLAN_GPIO_OUT_BIT5		FIELD32(0x00200000)
+#define WLAN_GPIO_OUT_BIT6		FIELD32(0x00400000)
+#define WLAN_GPIO_OUT_BIT7		FIELD32(0x00800000)
+#define WLAN_GPIO_OUT_BIT_ALL		FIELD32(0x00ff0000)
+#define WLAN_GPIO_OUT_OE_BIT0		FIELD32(0x01000000)
+#define WLAN_GPIO_OUT_OE_BIT1		FIELD32(0x02000000)
+#define WLAN_GPIO_OUT_OE_BIT2		FIELD32(0x04000000)
+#define WLAN_GPIO_OUT_OE_BIT3		FIELD32(0x08000000)
+#define WLAN_GPIO_OUT_OE_BIT4		FIELD32(0x10000000)
+#define WLAN_GPIO_OUT_OE_BIT5		FIELD32(0x20000000)
+#define WLAN_GPIO_OUT_OE_BIT6		FIELD32(0x40000000)
+#define WLAN_GPIO_OUT_OE_BIT7		FIELD32(0x80000000)
+#define WLAN_GPIO_OUT_OE_BIT_ALL	FIELD32(0xff000000)
+
+/*
  * AUX_CTRL: Aux/PCI-E related configuration
  */
 #define AUX_CTRL			0x10c
@@ -1914,6 +2062,11 @@ struct mac_iveiv_entry {
 #define RFCSR27_R4			FIELD8(0x40)
 
 /*
+ * RFCSR 29:
+ */
+#define RFCSR27_ADC			FIELD8(0xc0)
+
+/*
  * RFCSR 30:
  */
 #define RFCSR30_TX_H20M			FIELD8(0x02)
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index dfc90d3..2368cb2 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -354,16 +354,15 @@ int rt2800_check_firmware(struct rt2x00_dev *rt2x00dev,
 	 * of 4kb. Certain USB chipsets however require different firmware,
 	 * which Ralink only provides attached to the original firmware
 	 * file. Thus for USB devices, firmware files have a length
-	 * which is a multiple of 4kb.
+	 * which is a multiple of 4kb. The firmware for rt3290 chip also
+	 * have a length which is a multiple of 4kb.
 	 */
-	if (rt2x00_is_usb(rt2x00dev)) {
+	if (rt2x00_is_usb(rt2x00dev) || rt2x00_rt(rt2x00dev, RT3290))
 		fw_len = 4096;
-		multiple = true;
-	} else {
+	else
 		fw_len = 8192;
-		multiple = true;
-	}
 
+	multiple = true;
 	/*
 	 * Validate the firmware length
 	 */
@@ -415,7 +414,8 @@ int rt2800_load_firmware(struct rt2x00_dev *rt2x00dev,
 		return -EBUSY;
 
 	if (rt2x00_is_pci(rt2x00dev)) {
-		if (rt2x00_rt(rt2x00dev, RT3572) ||
+		if (rt2x00_rt(rt2x00dev, RT3290) ||
+		    rt2x00_rt(rt2x00dev, RT3572) ||
 		    rt2x00_rt(rt2x00dev, RT5390) ||
 		    rt2x00_rt(rt2x00dev, RT5392)) {
 			rt2800_register_read(rt2x00dev, AUX_CTRL, &reg);
@@ -851,8 +851,13 @@ int rt2800_rfkill_poll(struct rt2x00_dev *rt2x00dev)
 {
 	u32 reg;
 
-	rt2800_register_read(rt2x00dev, GPIO_CTRL_CFG, &reg);
-	return rt2x00_get_field32(reg, GPIO_CTRL_CFG_BIT2);
+	if (rt2x00_rt(rt2x00dev, RT3290)) {
+		rt2800_register_read(rt2x00dev, WLAN_FUN_CTRL, &reg);
+		return rt2x00_get_field32(reg, WLAN_GPIO_IN_BIT0);
+	} else {
+		rt2800_register_read(rt2x00dev, GPIO_CTRL_CFG, &reg);
+		return rt2x00_get_field32(reg, GPIO_CTRL_CFG_BIT2);
+	}
 }
 EXPORT_SYMBOL_GPL(rt2800_rfkill_poll);
 
@@ -1935,8 +1940,50 @@ static void rt2800_config_channel_rf3052(struct rt2x00_dev *rt2x00dev,
 	rt2800_rfcsr_write(rt2x00dev, 7, rfcsr);
 }
 
-#define RT5390_POWER_BOUND     0x27
-#define RT5390_FREQ_OFFSET_BOUND       0x5f
+#define POWER_BOUND     0x27
+#define FREQ_OFFSET_BOUND       0x5f
+
+static void rt2800_config_channel_rf3290(struct rt2x00_dev *rt2x00dev,
+					 struct ieee80211_conf *conf,
+					 struct rf_channel *rf,
+					 struct channel_info *info)
+{
+	u8 rfcsr;
+
+	rt2800_rfcsr_write(rt2x00dev, 8, rf->rf1);
+	rt2800_rfcsr_write(rt2x00dev, 9, rf->rf3);
+	rt2800_rfcsr_read(rt2x00dev, 11, &rfcsr);
+	rt2x00_set_field8(&rfcsr, RFCSR11_R, rf->rf2);
+	rt2800_rfcsr_write(rt2x00dev, 11, rfcsr);
+
+	rt2800_rfcsr_read(rt2x00dev, 49, &rfcsr);
+	if (info->default_power1 > POWER_BOUND)
+		rt2x00_set_field8(&rfcsr, RFCSR49_TX, POWER_BOUND);
+	else
+		rt2x00_set_field8(&rfcsr, RFCSR49_TX, info->default_power1);
+	rt2800_rfcsr_write(rt2x00dev, 49, rfcsr);
+
+	rt2800_rfcsr_read(rt2x00dev, 17, &rfcsr);
+	if (rt2x00dev->freq_offset > FREQ_OFFSET_BOUND)
+		rt2x00_set_field8(&rfcsr, RFCSR17_CODE, FREQ_OFFSET_BOUND);
+	else
+		rt2x00_set_field8(&rfcsr, RFCSR17_CODE, rt2x00dev->freq_offset);
+	rt2800_rfcsr_write(rt2x00dev, 17, rfcsr);
+
+	if (rf->channel <= 14) {
+		if (rf->channel == 6)
+			rt2800_bbp_write(rt2x00dev, 68, 0x0c);
+		else
+			rt2800_bbp_write(rt2x00dev, 68, 0x0b);
+
+		if (rf->channel >= 1 && rf->channel <= 6)
+			rt2800_bbp_write(rt2x00dev, 59, 0x0f);
+		else if (rf->channel >= 7 && rf->channel <= 11)
+			rt2800_bbp_write(rt2x00dev, 59, 0x0e);
+		else if (rf->channel >= 12 && rf->channel <= 14)
+			rt2800_bbp_write(rt2x00dev, 59, 0x0d);
+	}
+}
 
 static void rt2800_config_channel_rf53xx(struct rt2x00_dev *rt2x00dev,
 					 struct ieee80211_conf *conf,
@@ -1952,8 +1999,8 @@ static void rt2800_config_channel_rf53xx(struct rt2x00_dev *rt2x00dev,
 	rt2800_rfcsr_write(rt2x00dev, 11, rfcsr);
 
 	rt2800_rfcsr_read(rt2x00dev, 49, &rfcsr);
-	if (info->default_power1 > RT5390_POWER_BOUND)
-		rt2x00_set_field8(&rfcsr, RFCSR49_TX, RT5390_POWER_BOUND);
+	if (info->default_power1 > POWER_BOUND)
+		rt2x00_set_field8(&rfcsr, RFCSR49_TX, POWER_BOUND);
 	else
 		rt2x00_set_field8(&rfcsr, RFCSR49_TX, info->default_power1);
 	rt2800_rfcsr_write(rt2x00dev, 49, rfcsr);
@@ -1966,9 +2013,8 @@ static void rt2800_config_channel_rf53xx(struct rt2x00_dev *rt2x00dev,
 	rt2800_rfcsr_write(rt2x00dev, 1, rfcsr);
 
 	rt2800_rfcsr_read(rt2x00dev, 17, &rfcsr);
-	if (rt2x00dev->freq_offset > RT5390_FREQ_OFFSET_BOUND)
-		rt2x00_set_field8(&rfcsr, RFCSR17_CODE,
-				  RT5390_FREQ_OFFSET_BOUND);
+	if (rt2x00dev->freq_offset > FREQ_OFFSET_BOUND)
+		rt2x00_set_field8(&rfcsr, RFCSR17_CODE, FREQ_OFFSET_BOUND);
 	else
 		rt2x00_set_field8(&rfcsr, RFCSR17_CODE, rt2x00dev->freq_offset);
 	rt2800_rfcsr_write(rt2x00dev, 17, rfcsr);
@@ -2021,15 +2067,6 @@ static void rt2800_config_channel_rf53xx(struct rt2x00_dev *rt2x00dev,
 			}
 		}
 	}
-
-	rt2800_rfcsr_read(rt2x00dev, 30, &rfcsr);
-	rt2x00_set_field8(&rfcsr, RFCSR30_TX_H20M, 0);
-	rt2x00_set_field8(&rfcsr, RFCSR30_RX_H20M, 0);
-	rt2800_rfcsr_write(rt2x00dev, 30, rfcsr);
-
-	rt2800_rfcsr_read(rt2x00dev, 3, &rfcsr);
-	rt2x00_set_field8(&rfcsr, RFCSR30_RF_CALIBRATION, 1);
-	rt2800_rfcsr_write(rt2x00dev, 3, rfcsr);
 }
 
 static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
@@ -2039,7 +2076,7 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
 {
 	u32 reg;
 	unsigned int tx_pin;
-	u8 bbp;
+	u8 bbp, rfcsr;
 
 	if (rf->channel <= 14) {
 		info->default_power1 = TXPOWER_G_TO_DEV(info->default_power1);
@@ -2060,6 +2097,9 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
 	case RF3052:
 		rt2800_config_channel_rf3052(rt2x00dev, conf, rf, info);
 		break;
+	case RF3290:
+		rt2800_config_channel_rf3290(rt2x00dev, conf, rf, info);
+		break;
 	case RF5370:
 	case RF5372:
 	case RF5390:
@@ -2069,6 +2109,20 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
 		rt2800_config_channel_rf2xxx(rt2x00dev, conf, rf, info);
 	}
 
+	if (rt2x00dev->chip.rf == RF3290 ||
+		rt2x00dev->chip.rf == RF5370 ||
+		rt2x00dev->chip.rf == RF5372 ||
+		rt2x00dev->chip.rf == RF5390) {
+		rt2800_rfcsr_read(rt2x00dev, 30, &rfcsr);
+		rt2x00_set_field8(&rfcsr, RFCSR30_TX_H20M, 0);
+		rt2x00_set_field8(&rfcsr, RFCSR30_RX_H20M, 0);
+		rt2800_rfcsr_write(rt2x00dev, 30, rfcsr);
+
+		rt2800_rfcsr_read(rt2x00dev, 3, &rfcsr);
+		rt2x00_set_field8(&rfcsr, RFCSR30_RF_CALIBRATION, 1);
+		rt2800_rfcsr_write(rt2x00dev, 3, rfcsr);
+	}
+
 	/*
 	 * Change BBP settings
 	 */
@@ -2549,6 +2603,7 @@ void rt2800_vco_calibration(struct rt2x00_dev *rt2x00dev)
 		rt2x00_set_field8(&rfcsr, RFCSR7_RF_TUNING, 1);
 		rt2800_rfcsr_write(rt2x00dev, 7, rfcsr);
 		break;
+	case RF3290:
 	case RF5370:
 	case RF5372:
 	case RF5390:
@@ -2682,6 +2737,7 @@ static u8 rt2800_get_default_vgc(struct rt2x00_dev *rt2x00dev)
 		if (rt2x00_rt(rt2x00dev, RT3070) ||
 		    rt2x00_rt(rt2x00dev, RT3071) ||
 		    rt2x00_rt(rt2x00dev, RT3090) ||
+		    rt2x00_rt(rt2x00dev, RT3290) ||
 		    rt2x00_rt(rt2x00dev, RT3390) ||
 		    rt2x00_rt(rt2x00dev, RT5390) ||
 		    rt2x00_rt(rt2x00dev, RT5392))
@@ -2778,10 +2834,50 @@ static int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
 	rt2x00_set_field32(&reg, BKOFF_SLOT_CFG_CC_DELAY_TIME, 2);
 	rt2800_register_write(rt2x00dev, BKOFF_SLOT_CFG, reg);
 
+	if (rt2x00_rt(rt2x00dev, RT3290)) {
+		rt2800_enable_wlan_rt3290(rt2x00dev);
+		rt2800_register_read(rt2x00dev, WLAN_FUN_CTRL, &reg);
+		if (rt2x00_get_field32(reg, WLAN_EN) == 1) {
+			rt2x00_set_field32(&reg, PCIE_APP0_CLK_REQ, 1);
+			rt2800_register_write(rt2x00dev, WLAN_FUN_CTRL, reg);
+		}
+
+		rt2800_register_read(rt2x00dev, CMB_CTRL, &reg);
+		if (!(rt2x00_get_field32(reg, LDO0_EN) == 1)) {
+			rt2x00_set_field32(&reg, LDO0_EN, 1);
+			rt2x00_set_field32(&reg, LDO_BGSEL, 3);
+			rt2800_register_write(rt2x00dev, CMB_CTRL, reg);
+		}
+
+		rt2800_register_read(rt2x00dev, OSC_CTRL, &reg);
+		rt2x00_set_field32(&reg, OSC_ROSC_EN, 1);
+		rt2800_register_write(rt2x00dev, OSC_CTRL, reg);
+		rt2x00_set_field32(&reg, OSC_ROSC_EN, 1);
+		rt2x00_set_field32(&reg, OSC_CAL_REQ, 1);
+		rt2x00_set_field32(&reg, OSC_REF_CYCLE, 0x27);
+		rt2800_register_write(rt2x00dev, OSC_CTRL, reg);
+		rt2800_register_read(rt2x00dev, COEX_CFG0, &reg);
+		rt2x00_set_field32(&reg, COEX_CFG_ANT, 0);
+		rt2x00_set_field32(&reg, COEX_CFG_ANT, 0x5e);
+		rt2800_register_write(rt2x00dev, COEX_CFG0, reg);
+		rt2800_register_write(rt2x00dev, COEX_CFG2, 0x0017937F);
+		rt2800_register_read(rt2x00dev, PLL_CTRL, &reg);
+		rt2x00_set_field32(&reg, PLL_CONTROL, 1);
+		rt2800_register_write(rt2x00dev, PLL_CTRL, reg);
+	}
+
 	if (rt2x00_rt(rt2x00dev, RT3071) ||
 	    rt2x00_rt(rt2x00dev, RT3090) ||
-	    rt2x00_rt(rt2x00dev, RT3390)) {
-		rt2800_register_write(rt2x00dev, TX_SW_CFG0, 0x00000400);
+	    rt2x00_rt(rt2x00dev, RT3390) ||
+		rt2x00_rt(rt2x00dev, RT3290)) {
+
+		if (rt2x00_rt(rt2x00dev, RT3290))
+			rt2800_register_write(rt2x00dev, TX_SW_CFG0,
+				0x00000404);
+		else
+			rt2800_register_write(rt2x00dev, TX_SW_CFG0,
+				0x00000400);
+
 		rt2800_register_write(rt2x00dev, TX_SW_CFG1, 0x00000000);
 		if (rt2x00_rt_rev_lt(rt2x00dev, RT3071, REV_RT3071E) ||
 		    rt2x00_rt_rev_lt(rt2x00dev, RT3090, REV_RT3090E) ||
@@ -3190,7 +3286,8 @@ static int rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
 		     rt2800_wait_bbp_ready(rt2x00dev)))
 		return -EACCES;
 
-	if (rt2x00_rt(rt2x00dev, RT5390) ||
+	if (rt2x00_rt(rt2x00dev, RT3290) ||
+		rt2x00_rt(rt2x00dev, RT5390) ||
 		rt2x00_rt(rt2x00dev, RT5392)) {
 		rt2800_bbp_read(rt2x00dev, 4, &value);
 		rt2x00_set_field8(&value, BBP4_MAC_IF_CTRL, 1);
@@ -3198,6 +3295,7 @@ static int rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
 	}
 
 	if (rt2800_is_305x_soc(rt2x00dev) ||
+	    rt2x00_rt(rt2x00dev, RT3290) ||
 	    rt2x00_rt(rt2x00dev, RT3572) ||
 	    rt2x00_rt(rt2x00dev, RT5390) ||
 	    rt2x00_rt(rt2x00dev, RT5392))
@@ -3206,20 +3304,26 @@ static int rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
 	rt2800_bbp_write(rt2x00dev, 65, 0x2c);
 	rt2800_bbp_write(rt2x00dev, 66, 0x38);
 
-	if (rt2x00_rt(rt2x00dev, RT5390) ||
+	if (rt2x00_rt(rt2x00dev, RT3290) ||
+		rt2x00_rt(rt2x00dev, RT5390) ||
 		rt2x00_rt(rt2x00dev, RT5392))
 		rt2800_bbp_write(rt2x00dev, 68, 0x0b);
 
 	if (rt2x00_rt_rev(rt2x00dev, RT2860, REV_RT2860C)) {
 		rt2800_bbp_write(rt2x00dev, 69, 0x16);
 		rt2800_bbp_write(rt2x00dev, 73, 0x12);
-	} else if (rt2x00_rt(rt2x00dev, RT5390) ||
-			   rt2x00_rt(rt2x00dev, RT5392)) {
+	} else if (rt2x00_rt(rt2x00dev, RT3290) ||
+			rt2x00_rt(rt2x00dev, RT5390) ||
+			rt2x00_rt(rt2x00dev, RT5392)) {
 		rt2800_bbp_write(rt2x00dev, 69, 0x12);
 		rt2800_bbp_write(rt2x00dev, 73, 0x13);
 		rt2800_bbp_write(rt2x00dev, 75, 0x46);
 		rt2800_bbp_write(rt2x00dev, 76, 0x28);
-		rt2800_bbp_write(rt2x00dev, 77, 0x59);
+
+		if (rt2x00_rt(rt2x00dev, RT3290))
+			rt2800_bbp_write(rt2x00dev, 77, 0x58);
+		else
+			rt2800_bbp_write(rt2x00dev, 77, 0x59);
 	} else {
 		rt2800_bbp_write(rt2x00dev, 69, 0x12);
 		rt2800_bbp_write(rt2x00dev, 73, 0x10);
@@ -3244,8 +3348,16 @@ static int rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
 		rt2800_bbp_write(rt2x00dev, 81, 0x37);
 	}
 
+	if (rt2x00_rt(rt2x00dev, RT3290)) {
+		rt2800_bbp_write(rt2x00dev, 74, 0x0b);
+		rt2800_bbp_write(rt2x00dev, 79, 0x18);
+		rt2800_bbp_write(rt2x00dev, 80, 0x09);
+		rt2800_bbp_write(rt2x00dev, 81, 0x33);
+	}
+
 	rt2800_bbp_write(rt2x00dev, 82, 0x62);
-	if (rt2x00_rt(rt2x00dev, RT5390) ||
+	if (rt2x00_rt(rt2x00dev, RT3290) ||
+		rt2x00_rt(rt2x00dev, RT5390) ||
 		rt2x00_rt(rt2x00dev, RT5392))
 		rt2800_bbp_write(rt2x00dev, 83, 0x7a);
 	else
@@ -3253,13 +3365,15 @@ static int rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
 
 	if (rt2x00_rt_rev(rt2x00dev, RT2860, REV_RT2860D))
 		rt2800_bbp_write(rt2x00dev, 84, 0x19);
-	else if (rt2x00_rt(rt2x00dev, RT5390) ||
-			 rt2x00_rt(rt2x00dev, RT5392))
+	else if (rt2x00_rt(rt2x00dev, RT3290) ||
+			rt2x00_rt(rt2x00dev, RT5390) ||
+			rt2x00_rt(rt2x00dev, RT5392))
 		rt2800_bbp_write(rt2x00dev, 84, 0x9a);
 	else
 		rt2800_bbp_write(rt2x00dev, 84, 0x99);
 
-	if (rt2x00_rt(rt2x00dev, RT5390) ||
+	if (rt2x00_rt(rt2x00dev, RT3290) ||
+		rt2x00_rt(rt2x00dev, RT5390) ||
 		rt2x00_rt(rt2x00dev, RT5392))
 		rt2800_bbp_write(rt2x00dev, 86, 0x38);
 	else
@@ -3270,7 +3384,8 @@ static int rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
 
 	rt2800_bbp_write(rt2x00dev, 91, 0x04);
 
-	if (rt2x00_rt(rt2x00dev, RT5390) ||
+	if (rt2x00_rt(rt2x00dev, RT3290) ||
+		rt2x00_rt(rt2x00dev, RT5390) ||
 		rt2x00_rt(rt2x00dev, RT5392))
 		rt2800_bbp_write(rt2x00dev, 92, 0x02);
 	else
@@ -3285,6 +3400,7 @@ static int rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
 	    rt2x00_rt_rev_gte(rt2x00dev, RT3071, REV_RT3071E) ||
 	    rt2x00_rt_rev_gte(rt2x00dev, RT3090, REV_RT3090E) ||
 	    rt2x00_rt_rev_gte(rt2x00dev, RT3390, REV_RT3390E) ||
+	    rt2x00_rt(rt2x00dev, RT3290) ||
 	    rt2x00_rt(rt2x00dev, RT3572) ||
 	    rt2x00_rt(rt2x00dev, RT5390) ||
 	    rt2x00_rt(rt2x00dev, RT5392) ||
@@ -3293,26 +3409,31 @@ static int rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
 	else
 		rt2800_bbp_write(rt2x00dev, 103, 0x00);
 
-	if (rt2x00_rt(rt2x00dev, RT5390) ||
+	if (rt2x00_rt(rt2x00dev, RT3290) ||
+		rt2x00_rt(rt2x00dev, RT5390) ||
 		rt2x00_rt(rt2x00dev, RT5392))
 		rt2800_bbp_write(rt2x00dev, 104, 0x92);
 
 	if (rt2800_is_305x_soc(rt2x00dev))
 		rt2800_bbp_write(rt2x00dev, 105, 0x01);
+	else if (rt2x00_rt(rt2x00dev, RT3290))
+		rt2800_bbp_write(rt2x00dev, 105, 0x1c);
 	else if (rt2x00_rt(rt2x00dev, RT5390) ||
 			 rt2x00_rt(rt2x00dev, RT5392))
 		rt2800_bbp_write(rt2x00dev, 105, 0x3c);
 	else
 		rt2800_bbp_write(rt2x00dev, 105, 0x05);
 
-	if (rt2x00_rt(rt2x00dev, RT5390))
+	if (rt2x00_rt(rt2x00dev, RT3290) ||
+		rt2x00_rt(rt2x00dev, RT5390))
 		rt2800_bbp_write(rt2x00dev, 106, 0x03);
 	else if (rt2x00_rt(rt2x00dev, RT5392))
 		rt2800_bbp_write(rt2x00dev, 106, 0x12);
 	else
 		rt2800_bbp_write(rt2x00dev, 106, 0x35);
 
-	if (rt2x00_rt(rt2x00dev, RT5390) ||
+	if (rt2x00_rt(rt2x00dev, RT3290) ||
+		rt2x00_rt(rt2x00dev, RT5390) ||
 		rt2x00_rt(rt2x00dev, RT5392))
 		rt2800_bbp_write(rt2x00dev, 128, 0x12);
 
@@ -3338,6 +3459,27 @@ static int rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
 		rt2800_bbp_write(rt2x00dev, 138, value);
 	}
 
+	if (rt2x00_rt(rt2x00dev, RT3290)) {
+		rt2800_bbp_write(rt2x00dev, 67, 0x24);
+		rt2800_bbp_write(rt2x00dev, 143, 0x04);
+		rt2800_bbp_write(rt2x00dev, 142, 0x99);
+		rt2800_bbp_write(rt2x00dev, 150, 0x30);
+		rt2800_bbp_write(rt2x00dev, 151, 0x2e);
+		rt2800_bbp_write(rt2x00dev, 152, 0x20);
+		rt2800_bbp_write(rt2x00dev, 153, 0x34);
+		rt2800_bbp_write(rt2x00dev, 154, 0x40);
+		rt2800_bbp_write(rt2x00dev, 155, 0x3b);
+		rt2800_bbp_write(rt2x00dev, 253, 0x04);
+
+		rt2800_bbp_read(rt2x00dev, 47, &value);
+		rt2x00_set_field8(&value, RFCSR2_RESCAL_EN, 1);
+		rt2800_bbp_write(rt2x00dev, 47, value);
+
+		rt2800_bbp_read(rt2x00dev, 3, &value);
+		rt2x00_set_field8(&value, RFCSR7_BITS67, 1);
+		rt2800_bbp_write(rt2x00dev, 3, value);
+	}
+
 	if (rt2x00_rt(rt2x00dev, RT5390) ||
 		rt2x00_rt(rt2x00dev, RT5392)) {
 		int ant, div_mode;
@@ -3470,6 +3612,7 @@ static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
 	if (!rt2x00_rt(rt2x00dev, RT3070) &&
 	    !rt2x00_rt(rt2x00dev, RT3071) &&
 	    !rt2x00_rt(rt2x00dev, RT3090) &&
+	    !rt2x00_rt(rt2x00dev, RT3290) &&
 	    !rt2x00_rt(rt2x00dev, RT3390) &&
 	    !rt2x00_rt(rt2x00dev, RT3572) &&
 	    !rt2x00_rt(rt2x00dev, RT5390) &&
@@ -3480,7 +3623,8 @@ static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Init RF calibration.
 	 */
-	if (rt2x00_rt(rt2x00dev, RT5390) ||
+	if (rt2x00_rt(rt2x00dev, RT3290) ||
+		rt2x00_rt(rt2x00dev, RT5390) ||
 		rt2x00_rt(rt2x00dev, RT5392)) {
 		rt2800_rfcsr_read(rt2x00dev, 2, &rfcsr);
 		rt2x00_set_field8(&rfcsr, RFCSR2_RESCAL_EN, 1);
@@ -3519,6 +3663,53 @@ static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
 		rt2800_rfcsr_write(rt2x00dev, 24, 0x16);
 		rt2800_rfcsr_write(rt2x00dev, 25, 0x01);
 		rt2800_rfcsr_write(rt2x00dev, 29, 0x1f);
+	} else if (rt2x00_rt(rt2x00dev, RT3290)) {
+		rt2800_rfcsr_write(rt2x00dev, 1, 0x0f);
+		rt2800_rfcsr_write(rt2x00dev, 2, 0x80);
+		rt2800_rfcsr_write(rt2x00dev, 3, 0x08);
+		rt2800_rfcsr_write(rt2x00dev, 4, 0x00);
+		rt2800_rfcsr_write(rt2x00dev, 6, 0xa0);
+		rt2800_rfcsr_write(rt2x00dev, 8, 0xf3);
+		rt2800_rfcsr_write(rt2x00dev, 9, 0x02);
+		rt2800_rfcsr_write(rt2x00dev, 10, 0x53);
+		rt2800_rfcsr_write(rt2x00dev, 11, 0x4a);
+		rt2800_rfcsr_write(rt2x00dev, 12, 0x46);
+		rt2800_rfcsr_write(rt2x00dev, 13, 0x9f);
+		rt2800_rfcsr_write(rt2x00dev, 18, 0x02);
+		rt2800_rfcsr_write(rt2x00dev, 22, 0x20);
+		rt2800_rfcsr_write(rt2x00dev, 25, 0x83);
+		rt2800_rfcsr_write(rt2x00dev, 26, 0x82);
+		rt2800_rfcsr_write(rt2x00dev, 27, 0x09);
+		rt2800_rfcsr_write(rt2x00dev, 29, 0x10);
+		rt2800_rfcsr_write(rt2x00dev, 30, 0x10);
+		rt2800_rfcsr_write(rt2x00dev, 31, 0x80);
+		rt2800_rfcsr_write(rt2x00dev, 32, 0x80);
+		rt2800_rfcsr_write(rt2x00dev, 33, 0x00);
+		rt2800_rfcsr_write(rt2x00dev, 34, 0x05);
+		rt2800_rfcsr_write(rt2x00dev, 35, 0x12);
+		rt2800_rfcsr_write(rt2x00dev, 36, 0x00);
+		rt2800_rfcsr_write(rt2x00dev, 38, 0x85);
+		rt2800_rfcsr_write(rt2x00dev, 39, 0x1b);
+		rt2800_rfcsr_write(rt2x00dev, 40, 0x0b);
+		rt2800_rfcsr_write(rt2x00dev, 41, 0xbb);
+		rt2800_rfcsr_write(rt2x00dev, 42, 0xd5);
+		rt2800_rfcsr_write(rt2x00dev, 43, 0x7b);
+		rt2800_rfcsr_write(rt2x00dev, 44, 0x0e);
+		rt2800_rfcsr_write(rt2x00dev, 45, 0xa2);
+		rt2800_rfcsr_write(rt2x00dev, 46, 0x73);
+		rt2800_rfcsr_write(rt2x00dev, 47, 0x00);
+		rt2800_rfcsr_write(rt2x00dev, 48, 0x10);
+		rt2800_rfcsr_write(rt2x00dev, 49, 0x98);
+		rt2800_rfcsr_write(rt2x00dev, 52, 0x38);
+		rt2800_rfcsr_write(rt2x00dev, 53, 0x00);
+		rt2800_rfcsr_write(rt2x00dev, 54, 0x78);
+		rt2800_rfcsr_write(rt2x00dev, 55, 0x43);
+		rt2800_rfcsr_write(rt2x00dev, 56, 0x02);
+		rt2800_rfcsr_write(rt2x00dev, 57, 0x80);
+		rt2800_rfcsr_write(rt2x00dev, 58, 0x7f);
+		rt2800_rfcsr_write(rt2x00dev, 59, 0x09);
+		rt2800_rfcsr_write(rt2x00dev, 60, 0x45);
+		rt2800_rfcsr_write(rt2x00dev, 61, 0xc1);
 	} else if (rt2x00_rt(rt2x00dev, RT3390)) {
 		rt2800_rfcsr_write(rt2x00dev, 0, 0xa0);
 		rt2800_rfcsr_write(rt2x00dev, 1, 0xe1);
@@ -3927,6 +4118,12 @@ static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
 		rt2800_rfcsr_write(rt2x00dev, 27, rfcsr);
 	}
 
+	if (rt2x00_rt(rt2x00dev, RT3290)) {
+		rt2800_rfcsr_read(rt2x00dev, 29, &rfcsr);
+		rt2x00_set_field8(&rfcsr, RFCSR27_ADC, 0xc0);
+		rt2800_rfcsr_write(rt2x00dev, 29, rfcsr);
+	}
+
 	if (rt2x00_rt(rt2x00dev, RT5390) ||
 		rt2x00_rt(rt2x00dev, RT5392)) {
 		rt2800_rfcsr_read(rt2x00dev, 38, &rfcsr);
@@ -4033,9 +4230,18 @@ EXPORT_SYMBOL_GPL(rt2800_disable_radio);
 int rt2800_efuse_detect(struct rt2x00_dev *rt2x00dev)
 {
 	u32 reg;
+	u16 efuse_ctrl_reg;
 
-	rt2800_register_read(rt2x00dev, EFUSE_CTRL, &reg);
+	/*
+	 * Because rt2x00dev->chip.rt set in rt2800_init_eeprom.
+	 * So we can't use rt2x00_rt(rt2x00dev, RT3290) here.
+	 */
+	if (rt2x00dev->chip.device_id == 0x3290)
+		efuse_ctrl_reg = EFUSE_CTRL_3290;
+	else
+		efuse_ctrl_reg = EFUSE_CTRL;
 
+	rt2800_register_read(rt2x00dev, efuse_ctrl_reg, &reg);
 	return rt2x00_get_field32(reg, EFUSE_CTRL_PRESENT);
 }
 EXPORT_SYMBOL_GPL(rt2800_efuse_detect);
@@ -4043,27 +4249,48 @@ EXPORT_SYMBOL_GPL(rt2800_efuse_detect);
 static void rt2800_efuse_read(struct rt2x00_dev *rt2x00dev, unsigned int i)
 {
 	u32 reg;
+	u16 efuse_ctrl_reg;
+	u16 efuse_data0_reg;
+	u16 efuse_data1_reg;
+	u16 efuse_data2_reg;
+	u16 efuse_data3_reg;
 
+	/*
+	 * Because rt2x00dev->chip.rt set in rt2800_init_eeprom.
+	 * So we can't use rt2x00_rt(rt2x00dev, RT3290) here.
+	 */
+	if (rt2x00dev->chip.device_id == 0x3290) {
+		efuse_ctrl_reg = EFUSE_CTRL_3290;
+		efuse_data0_reg = EFUSE_DATA0_3290;
+		efuse_data1_reg = EFUSE_DATA1_3290;
+		efuse_data2_reg = EFUSE_DATA2_3290;
+		efuse_data3_reg = EFUSE_DATA3_3290;
+	} else {
+		efuse_ctrl_reg = EFUSE_CTRL;
+		efuse_data0_reg = EFUSE_DATA0;
+		efuse_data1_reg = EFUSE_DATA1;
+		efuse_data2_reg = EFUSE_DATA2;
+		efuse_data3_reg = EFUSE_DATA3;
+	}
 	mutex_lock(&rt2x00dev->csr_mutex);
 
-	rt2800_register_read_lock(rt2x00dev, EFUSE_CTRL, &reg);
+	rt2800_register_read_lock(rt2x00dev, efuse_ctrl_reg, &reg);
 	rt2x00_set_field32(&reg, EFUSE_CTRL_ADDRESS_IN, i);
 	rt2x00_set_field32(&reg, EFUSE_CTRL_MODE, 0);
 	rt2x00_set_field32(&reg, EFUSE_CTRL_KICK, 1);
-	rt2800_register_write_lock(rt2x00dev, EFUSE_CTRL, reg);
+	rt2800_register_write_lock(rt2x00dev, efuse_ctrl_reg, reg);
 
 	/* Wait until the EEPROM has been loaded */
-	rt2800_regbusy_read(rt2x00dev, EFUSE_CTRL, EFUSE_CTRL_KICK, &reg);
-
+	rt2800_regbusy_read(rt2x00dev, efuse_ctrl_reg, EFUSE_CTRL_KICK, &reg);
 	/* Apparently the data is read from end to start */
-	rt2800_register_read_lock(rt2x00dev, EFUSE_DATA3, &reg);
+	rt2800_register_read_lock(rt2x00dev, efuse_data3_reg, &reg);
 	/* The returned value is in CPU order, but eeprom is le */
 	*(u32 *)&rt2x00dev->eeprom[i] = cpu_to_le32(reg);
-	rt2800_register_read_lock(rt2x00dev, EFUSE_DATA2, &reg);
+	rt2800_register_read_lock(rt2x00dev, efuse_data2_reg, &reg);
 	*(u32 *)&rt2x00dev->eeprom[i + 2] = cpu_to_le32(reg);
-	rt2800_register_read_lock(rt2x00dev, EFUSE_DATA1, &reg);
+	rt2800_register_read_lock(rt2x00dev, efuse_data1_reg, &reg);
 	*(u32 *)&rt2x00dev->eeprom[i + 4] = cpu_to_le32(reg);
-	rt2800_register_read_lock(rt2x00dev, EFUSE_DATA0, &reg);
+	rt2800_register_read_lock(rt2x00dev, efuse_data0_reg, &reg);
 	*(u32 *)&rt2x00dev->eeprom[i + 6] = cpu_to_le32(reg);
 
 	mutex_unlock(&rt2x00dev->csr_mutex);
@@ -4225,8 +4452,13 @@ int rt2800_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	 * RT28xx/RT30xx: defined in "EEPROM_NIC_CONF0_RF_TYPE" field
 	 * RT53xx: defined in "EEPROM_CHIP_ID" field
 	 */
-	rt2800_register_read(rt2x00dev, MAC_CSR0, &reg);
-	if (rt2x00_get_field32(reg, MAC_CSR0_CHIPSET) == RT5390 ||
+	if (rt2x00dev->chip.device_id == 0x3290)
+		rt2800_register_read(rt2x00dev, MAC_CSR0_3290, &reg);
+	else
+		rt2800_register_read(rt2x00dev, MAC_CSR0, &reg);
+
+	if (rt2x00_get_field32(reg, MAC_CSR0_CHIPSET) == RT3290 ||
+		rt2x00_get_field32(reg, MAC_CSR0_CHIPSET) == RT5390 ||
 		rt2x00_get_field32(reg, MAC_CSR0_CHIPSET) == RT5392)
 		rt2x00_eeprom_read(rt2x00dev, EEPROM_CHIP_ID, &value);
 	else
@@ -4242,6 +4474,7 @@ int rt2800_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	case RT3070:
 	case RT3071:
 	case RT3090:
+	case RT3290:
 	case RT3390:
 	case RT3572:
 	case RT5390:
@@ -4262,6 +4495,7 @@ int rt2800_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	case RF3021:
 	case RF3022:
 	case RF3052:
+	case RF3290:
 	case RF3320:
 	case RF5370:
 	case RF5372:
@@ -4576,6 +4810,7 @@ int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 		   rt2x00_rf(rt2x00dev, RF2020) ||
 		   rt2x00_rf(rt2x00dev, RF3021) ||
 		   rt2x00_rf(rt2x00dev, RF3022) ||
+		   rt2x00_rf(rt2x00dev, RF3290) ||
 		   rt2x00_rf(rt2x00dev, RF3320) ||
 		   rt2x00_rf(rt2x00dev, RF5370) ||
 		   rt2x00_rf(rt2x00dev, RF5372) ||
@@ -4662,6 +4897,7 @@ int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	case RF3022:
 	case RF3320:
 	case RF3052:
+	case RF3290:
 	case RF5370:
 	case RF5372:
 	case RF5390:
@@ -4892,6 +5128,70 @@ int rt2800_get_survey(struct ieee80211_hw *hw, int idx,
 }
 EXPORT_SYMBOL_GPL(rt2800_get_survey);
 
+int rt2800_enable_wlan_rt3290(struct rt2x00_dev *rt2x00dev)
+{
+	u32 reg;
+	int i, count;
+
+	rt2800_register_read(rt2x00dev, WLAN_FUN_CTRL, &reg);
+	rt2x00_set_field32(&reg, WLAN_GPIO_OUT_OE_BIT_ALL, 0xff);
+	rt2x00_set_field32(&reg, FRC_WL_ANT_SET, 1);
+	if ((rt2x00_get_field32(reg, WLAN_EN) == 1))
+		return 0;
+
+	rt2x00_set_field32(&reg, WLAN_CLK_EN, 0);
+	rt2x00_set_field32(&reg, WLAN_EN, 1);
+	rt2800_register_write(rt2x00dev, WLAN_FUN_CTRL, reg);
+	udelay(REGISTER_BUSY_DELAY);
+
+	count = 0;
+	do {
+		reg = 0;
+		/*
+		 * Check PLL_LD & XTAL_RDY.
+		 */
+		for (i = 0; i < REGISTER_BUSY_COUNT; i++) {
+			rt2800_register_read(rt2x00dev, CMB_CTRL, &reg);
+			if ((rt2x00_get_field32(reg, PLL_LD) == 1) &&
+				(rt2x00_get_field32(reg, XTAL_RDY) == 1))
+				break;
+			udelay(REGISTER_BUSY_DELAY);
+		}
+
+		if (i >= REGISTER_BUSY_COUNT) {
+
+			if (count >= 10)
+				break;
+
+			rt2800_register_write(rt2x00dev, 0x58, 0x018);
+			udelay(REGISTER_BUSY_DELAY);
+			rt2800_register_write(rt2x00dev, 0x58, 0x418);
+			udelay(REGISTER_BUSY_DELAY);
+			rt2800_register_write(rt2x00dev, 0x58, 0x618);
+			udelay(REGISTER_BUSY_DELAY);
+			count++;
+		} else {
+			rt2800_register_read(rt2x00dev,
+				WPDMA_GLO_CFG, &reg);
+			count = 0;
+		}
+
+		rt2800_register_read(rt2x00dev, WLAN_FUN_CTRL, &reg);
+		rt2x00_set_field32(&reg, PCIE_APP0_CLK_REQ, 0);
+		rt2x00_set_field32(&reg, WLAN_CLK_EN, 1);
+		rt2x00_set_field32(&reg, WLAN_RESET, 1);
+		rt2800_register_write(rt2x00dev, WLAN_FUN_CTRL, reg);
+		udelay(10);
+		rt2x00_set_field32(&reg, WLAN_RESET, 0);
+		rt2800_register_write(rt2x00dev, WLAN_FUN_CTRL, reg);
+		udelay(10);
+		rt2800_register_write(rt2x00dev,
+			INT_SOURCE_CSR, 0x7fffffff);
+	} while (count != 0);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(rt2800_enable_wlan_rt3290);
 MODULE_AUTHOR(DRV_PROJECT ", Bartlomiej Zolnierkiewicz");
 MODULE_VERSION(DRV_VERSION);
 MODULE_DESCRIPTION("Ralink RT2800 library");
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.h b/drivers/net/wireless/rt2x00/rt2800lib.h
index 18a0b67..0321fd8 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.h
+++ b/drivers/net/wireless/rt2x00/rt2800lib.h
@@ -209,5 +209,6 @@ int rt2800_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 int rt2800_get_survey(struct ieee80211_hw *hw, int idx,
 		      struct survey_info *survey);
 void rt2800_disable_wpdma(struct rt2x00_dev *rt2x00dev);
+int rt2800_enable_wlan_rt3290(struct rt2x00_dev *rt2x00dev);
 
 #endif /* RT2800LIB_H */
diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index cad25bf..4edeb01 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -280,7 +280,13 @@ static void rt2800pci_stop_queue(struct data_queue *queue)
  */
 static char *rt2800pci_get_firmware_name(struct rt2x00_dev *rt2x00dev)
 {
-	return FIRMWARE_RT2860;
+	/*
+	 * Chip rt3290 use specific 4KB firmware named rt3290.bin.
+	 */
+	if (rt2x00_rt(rt2x00dev, RT3290))
+		return FIRMWARE_RT3290;
+	else
+		return FIRMWARE_RT2860;
 }
 
 static int rt2800pci_write_firmware(struct rt2x00_dev *rt2x00dev,
@@ -1028,6 +1034,13 @@ static int rt2800pci_probe_hw(struct rt2x00_dev *rt2x00dev)
 	 */
 	rt2x00dev->rssi_offset = DEFAULT_RSSI_OFFSET;
 
+	/*
+	 * In probe phase call rt2800_enable_wlan_rt3290 to enable wlan
+	 * clk for rt3290. That avoid the MCU fail in start phase.
+	 */
+	if (rt2x00_rf(rt2x00dev, RF3290))
+		rt2800_enable_wlan_rt3290(rt2x00dev);
+
 	return 0;
 }
 
@@ -1175,6 +1188,9 @@ static DEFINE_PCI_DEVICE_TABLE(rt2800pci_device_table) = {
 	{ PCI_DEVICE(0x1432, 0x7768) },
 	{ PCI_DEVICE(0x1462, 0x891a) },
 	{ PCI_DEVICE(0x1a3b, 0x1059) },
+#ifdef CONFIG_RT2800PCI_RT3290
+	{ PCI_DEVICE(0x1814, 0x3290) },
+#endif
 #ifdef CONFIG_RT2800PCI_RT33XX
 	{ PCI_DEVICE(0x1814, 0x3390) },
 #endif
diff --git a/drivers/net/wireless/rt2x00/rt2800pci.h b/drivers/net/wireless/rt2x00/rt2800pci.h
index 70e050d..ab22a08 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.h
+++ b/drivers/net/wireless/rt2x00/rt2800pci.h
@@ -47,6 +47,7 @@
  * 8051 firmware image.
  */
 #define FIRMWARE_RT2860			"rt2860.bin"
+#define FIRMWARE_RT3290			"rt3290.bin"
 #define FIRMWARE_IMAGE_BASE		0x2000
 
 /*
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index ca36ccc..f2d64cb 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -187,6 +187,7 @@ struct rt2x00_chip {
 #define RT3070		0x3070
 #define RT3071		0x3071
 #define RT3090		0x3090	/* 2.4GHz PCIe */
+#define RT3290		0x3290
 #define RT3390		0x3390
 #define RT3572		0x3572
 #define RT3593		0x3593
@@ -196,6 +197,7 @@ struct rt2x00_chip {
 
 	u16 rf;
 	u16 rev;
+	u16 device_id;
 
 	enum rt2x00_chip_intf intf;
 };
diff --git a/drivers/net/wireless/rt2x00/rt2x00pci.c b/drivers/net/wireless/rt2x00/rt2x00pci.c
index 0a4653a..a672f43 100644
--- a/drivers/net/wireless/rt2x00/rt2x00pci.c
+++ b/drivers/net/wireless/rt2x00/rt2x00pci.c
@@ -256,6 +256,7 @@ int rt2x00pci_probe(struct pci_dev *pci_dev, const struct rt2x00_ops *ops)
 	struct ieee80211_hw *hw;
 	struct rt2x00_dev *rt2x00dev;
 	int retval;
+	u16 device_id;
 
 	retval = pci_enable_device(pci_dev);
 	if (retval) {
@@ -305,6 +306,14 @@ int rt2x00pci_probe(struct pci_dev *pci_dev, const struct rt2x00_ops *ops)
 	if (retval)
 		goto exit_free_device;
 
+	/*
+	 * Because rt3290 chip use different efuse offset to read efuse data.
+	 * So before read efuse it need one parameter to indicate it is the
+	 * rt3290 or not.
+	 */
+	pci_read_config_word(pci_dev, PCI_DEVICE_ID, &device_id);
+	rt2x00dev->chip.device_id = device_id;
+
 	retval = rt2x00lib_probe_dev(rt2x00dev);
 	if (retval)
 		goto exit_free_reg;
-- 
1.7.5.4

