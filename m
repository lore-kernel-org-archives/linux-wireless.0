Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:49387 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752805Ab1BTM6P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Feb 2011 07:58:15 -0500
Received: by mail-ey0-f174.google.com with SMTP id 27so2477447eye.19
        for <linux-wireless@vger.kernel.org>; Sun, 20 Feb 2011 04:58:14 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 8/8] rt2x00: Add support for RT5390 chip
Date: Sun, 20 Feb 2011 13:57:46 +0100
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
References: <201102201354.53379.IvDoorn@gmail.com> <201102201356.55216.IvDoorn@gmail.com> <201102201357.23078.IvDoorn@gmail.com>
In-Reply-To: <201102201357.23078.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201102201357.47277.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: RA-Shiang Tu <Shiang_Tu@ralinktech.com>

Add new RT5390 chip support

Signed-off-by: Shiang Tu <shiang_tu@ralinktech.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/Kconfig     |   12 +
 drivers/net/wireless/rt2x00/rt2800.h    |   59 +++++-
 drivers/net/wireless/rt2x00/rt2800lib.c |  413 +++++++++++++++++++++++++++----
 drivers/net/wireless/rt2x00/rt2800pci.c |   10 +
 drivers/net/wireless/rt2x00/rt2x00.h    |    1 +
 5 files changed, 440 insertions(+), 55 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/Kconfig b/drivers/net/wireless/rt2x00/Kconfig
index 6f383cd..f630552 100644
--- a/drivers/net/wireless/rt2x00/Kconfig
+++ b/drivers/net/wireless/rt2x00/Kconfig
@@ -97,6 +97,18 @@ config RT2800PCI_RT35XX
 	  Support for these devices is non-functional at the moment and is
 	  intended for testers and developers.
 
+config RT2800PCI_RT53XX
+       bool "rt2800-pci - Include support for rt53xx devices (EXPERIMENTAL)"
+       depends on EXPERIMENTAL
+       default n
+       ---help---
+         This adds support for rt53xx wireless chipset family to the
+         rt2800pci driver.
+         Supported chips: RT5390
+
+         Support for these devices is non-functional at the moment and is
+         intended for testers and developers.
+
 endif
 
 config RT2500USB
diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
index 591ac32..6f4a243 100644
--- a/drivers/net/wireless/rt2x00/rt2800.h
+++ b/drivers/net/wireless/rt2x00/rt2800.h
@@ -51,6 +51,7 @@
  * RF3320 2.4G 1T1R(RT3350/RT3370/RT3390)
  * RF3322 2.4G 2T2R(RT3352/RT3371/RT3372/RT3391/RT3392)
  * RF3853 2.4G/5G 3T3R(RT3883/RT3563/RT3573/RT3593/RT3662)
+ * RF5390 2.4G 1T1R
  */
 #define RF2820				0x0001
 #define RF2850				0x0002
@@ -65,6 +66,7 @@
 #define RF3320				0x000b
 #define RF3322				0x000c
 #define RF3853				0x000d
+#define RF5390                         0x5390
 
 /*
  * Chipset revisions.
@@ -77,6 +79,7 @@
 #define REV_RT3071E			0x0211
 #define REV_RT3090E			0x0211
 #define REV_RT3390E			0x0211
+#define REV_RT5390F                    0x0502
 
 /*
  * Signal information.
@@ -121,6 +124,13 @@
 #define E2PROM_CSR_RELOAD		FIELD32(0x00000080)
 
 /*
+ * AUX_CTRL: Aux/PCI-E related configuration
+ */
+#define AUX_CTRL               0x10c
+#define AUX_CTRL_WAKE_PCIE_EN          FIELD32(0x00000002)
+#define AUX_CTRL_FORCE_PCIE_CLK        FIELD32(0x00000400)
+
+/*
  * OPT_14: Unknown register used by rt3xxx devices.
  */
 #define OPT_14_CSR			0x0114
@@ -454,7 +464,7 @@
  */
 #define	RF_CSR_CFG			0x0500
 #define RF_CSR_CFG_DATA			FIELD32(0x000000ff)
-#define RF_CSR_CFG_REGNUM		FIELD32(0x00001f00)
+#define RF_CSR_CFG_REGNUM              FIELD32(0x00003f00)
 #define RF_CSR_CFG_WRITE		FIELD32(0x00010000)
 #define RF_CSR_CFG_BUSY			FIELD32(0x00020000)
 
@@ -1736,6 +1746,13 @@ struct mac_iveiv_entry {
  */
 #define BBP4_TX_BF			FIELD8(0x01)
 #define BBP4_BANDWIDTH			FIELD8(0x18)
+#define BBP4_MAC_IF_CTRL               FIELD8(0x40)
+
+/*
+ * BBP 109
+ */
+#define BBP109_TX0_POWER       FIELD8(0x0f)
+#define BBP109_TX1_POWER       FIELD8(0xf0)
 
 /*
  * BBP 138: Unknown
@@ -1746,6 +1763,11 @@ struct mac_iveiv_entry {
 #define BBP138_TX_DAC2			FIELD8(0x40)
 
 /*
+ * BBP 152: Rx Ant
+ */
+#define BBP152_RX_DEFAULT_ANT  FIELD8(0x80)
+
+/*
  * RFCSR registers
  * The wordsize of the RFCSR is 8 bits.
  */
@@ -1754,12 +1776,18 @@ struct mac_iveiv_entry {
  * RFCSR 1:
  */
 #define RFCSR1_RF_BLOCK_EN		FIELD8(0x01)
+#define RFCSR1_PLL_PD                  FIELD8(0x02)
 #define RFCSR1_RX0_PD			FIELD8(0x04)
 #define RFCSR1_TX0_PD			FIELD8(0x08)
 #define RFCSR1_RX1_PD			FIELD8(0x10)
 #define RFCSR1_TX1_PD			FIELD8(0x20)
 
 /*
+ * RFCSR 2:
+ */
+#define RFCSR2_RESCAL_EN               FIELD8(0x80)
+
+/*
  * RFCSR 6:
  */
 #define RFCSR6_R1			FIELD8(0x03)
@@ -1771,6 +1799,11 @@ struct mac_iveiv_entry {
 #define RFCSR7_RF_TUNING		FIELD8(0x01)
 
 /*
+ * RFCSR 11:
+ */
+#define RFCSR11_R                      FIELD8(0x03)
+
+/*
  * RFCSR 12:
  */
 #define RFCSR12_TX_POWER		FIELD8(0x1f)
@@ -1791,6 +1824,7 @@ struct mac_iveiv_entry {
 #define RFCSR17_TXMIXER_GAIN		FIELD8(0x07)
 #define RFCSR17_TX_LO1_EN		FIELD8(0x08)
 #define RFCSR17_R			FIELD8(0x20)
+#define RFCSR17_CODE                   FIELD8(0x7f)
 
 /*
  * RFCSR 20:
@@ -1823,6 +1857,9 @@ struct mac_iveiv_entry {
 /*
  * RFCSR 30:
  */
+#define RFCSR30_TX_H20M                FIELD8(0x02)
+#define RFCSR30_RX_H20M                FIELD8(0x04)
+#define RFCSR30_RX_VCM         FIELD8(0x18)
 #define RFCSR30_RF_CALIBRATION		FIELD8(0x80)
 
 /*
@@ -1832,6 +1869,21 @@ struct mac_iveiv_entry {
 #define RFCSR31_RX_H20M			FIELD8(0x20)
 
 /*
+ * RFCSR 38:
+ */
+#define RFCSR38_RX_LO1_EN      FIELD8(0x20)
+
+/*
+ * RFCSR 39:
+ */
+#define RFCSR39_RX_LO2_EN      FIELD8(0x80)
+
+/*
+ * RFCSR 49:
+ */
+#define RFCSR49_TX                     FIELD8(0x3f)
+
+/*
  * RF registers
  */
 
@@ -1864,6 +1916,11 @@ struct mac_iveiv_entry {
  */
 
 /*
+ * Chip ID
+ */
+#define EEPROM_CHIP_ID         0x0000
+
+/*
  * EEPROM Version
  */
 #define EEPROM_VERSION			0x0001
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index bed97eb..af9cef0 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -400,8 +400,15 @@ int rt2800_load_firmware(struct rt2x00_dev *rt2x00dev,
 	if (rt2800_wait_csr_ready(rt2x00dev))
 		return -EBUSY;
 
-	if (rt2x00_is_pci(rt2x00dev))
+       if (rt2x00_is_pci(rt2x00dev)) {
+               if (rt2x00_rt(rt2x00dev, RT5390)) {
+                       rt2800_register_read(rt2x00dev, AUX_CTRL, &reg);
+                       rt2x00_set_field32(&reg, AUX_CTRL_FORCE_PCIE_CLK, 1);
+                       rt2x00_set_field32(&reg, AUX_CTRL_WAKE_PCIE_EN, 1);
+                       rt2800_register_write(rt2x00dev, AUX_CTRL, reg);
+               }
 		rt2800_register_write(rt2x00dev, PWR_PIN_CFG, 0x00000002);
+       }
 
 	/*
 	 * Disable DMA, will be reenabled later when enabling
@@ -1565,6 +1572,99 @@ static void rt2800_config_channel_rf3xxx(struct rt2x00_dev *rt2x00dev,
 	rt2800_rfcsr_write(rt2x00dev, 7, rfcsr);
 }
 
+
+#define RT5390_POWER_BOUND     0x27
+#define RT5390_FREQ_OFFSET_BOUND       0x5f
+
+static void rt2800_config_channel_rf53xx(struct rt2x00_dev *rt2x00dev,
+                                        struct ieee80211_conf *conf,
+                                        struct rf_channel *rf,
+                                        struct channel_info *info)
+{
+       u8 rfcsr;
+       u16 eeprom;
+
+       rt2800_rfcsr_write(rt2x00dev, 8, rf->rf1);
+       rt2800_rfcsr_write(rt2x00dev, 9, rf->rf3);
+       rt2800_rfcsr_read(rt2x00dev, 11, &rfcsr);
+       rt2x00_set_field8(&rfcsr, RFCSR11_R, rf->rf2);
+       rt2800_rfcsr_write(rt2x00dev, 11, rfcsr);
+
+       rt2800_rfcsr_read(rt2x00dev, 49, &rfcsr);
+       if (info->default_power1 > RT5390_POWER_BOUND)
+               rt2x00_set_field8(&rfcsr, RFCSR49_TX, RT5390_POWER_BOUND);
+       else
+               rt2x00_set_field8(&rfcsr, RFCSR49_TX, info->default_power1);
+       rt2800_rfcsr_write(rt2x00dev, 49, rfcsr);
+
+       rt2800_rfcsr_read(rt2x00dev, 1, &rfcsr);
+       rt2x00_set_field8(&rfcsr, RFCSR1_RF_BLOCK_EN, 1);
+       rt2x00_set_field8(&rfcsr, RFCSR1_PLL_PD, 1);
+       rt2x00_set_field8(&rfcsr, RFCSR1_RX0_PD, 1);
+       rt2x00_set_field8(&rfcsr, RFCSR1_TX0_PD, 1);
+       rt2800_rfcsr_write(rt2x00dev, 1, rfcsr);
+
+       rt2800_rfcsr_read(rt2x00dev, 17, &rfcsr);
+       if (rt2x00dev->freq_offset > RT5390_FREQ_OFFSET_BOUND)
+               rt2x00_set_field8(&rfcsr, RFCSR17_CODE, RT5390_FREQ_OFFSET_BOUND);
+       else
+               rt2x00_set_field8(&rfcsr, RFCSR17_CODE, rt2x00dev->freq_offset);
+       rt2800_rfcsr_write(rt2x00dev, 17, rfcsr);
+
+       rt2x00_eeprom_read(rt2x00dev, EEPROM_NIC_CONF1, &eeprom);
+       if (rf->channel <= 14) {
+               int idx = rf->channel-1;
+
+               if (rt2x00_get_field16(eeprom, EEPROM_NIC_CONF1_BT_COEXIST)) {
+                       if (rt2x00_rt_rev_gte(rt2x00dev, RT5390, REV_RT5390F)) {
+                               /* r55/r59 value array of channel 1~14 */
+                               static const char r55_bt_rev[] = {0x83, 0x83,
+                                       0x83, 0x73, 0x73, 0x63, 0x53, 0x53,
+                                       0x53, 0x43, 0x43, 0x43, 0x43, 0x43};
+                               static const char r59_bt_rev[] = {0x0e, 0x0e,
+                                       0x0e, 0x0e, 0x0e, 0x0b, 0x0a, 0x09,
+                                       0x07, 0x07, 0x07, 0x07, 0x07, 0x07};
+
+                               rt2800_rfcsr_write(rt2x00dev, 55, r55_bt_rev[idx]);
+                               rt2800_rfcsr_write(rt2x00dev, 59, r59_bt_rev[idx]);
+                       } else {
+                               static const char r59_bt[] = {0x8b, 0x8b, 0x8b,
+                                       0x8b, 0x8b, 0x8b, 0x8b, 0x8a, 0x89,
+                                       0x88, 0x88, 0x86, 0x85, 0x84};
+
+                               rt2800_rfcsr_write(rt2x00dev, 59, r59_bt[idx]);
+                       }
+               } else {
+                       if (rt2x00_rt_rev_gte(rt2x00dev, RT5390, REV_RT5390F)) {
+                               static const char r55_nonbt_rev[] = {0x23, 0x23,
+                                       0x23, 0x23, 0x13, 0x13, 0x03, 0x03,
+                                       0x03, 0x03, 0x03, 0x03, 0x03, 0x03};
+                               static const char r59_nonbt_rev[] = {0x07, 0x07,
+                                       0x07, 0x07, 0x07, 0x07, 0x07, 0x07,
+                                       0x07, 0x07, 0x06, 0x05, 0x04, 0x04};
+
+                               rt2800_rfcsr_write(rt2x00dev, 55, r55_nonbt_rev[idx]);
+                               rt2800_rfcsr_write(rt2x00dev, 59, r59_nonbt_rev[idx]);
+                       } else if (rt2x00_rt(rt2x00dev, RT5390)) {
+                               static const char r59_non_bt[] = {0x8f, 0x8f,
+                                       0x8f, 0x8f, 0x8f, 0x8f, 0x8f, 0x8d,
+                                       0x8a, 0x88, 0x88, 0x87, 0x87, 0x86};
+
+                               rt2800_rfcsr_write(rt2x00dev, 59, r59_non_bt[idx]);
+                       }
+               }
+       }
+
+       rt2800_rfcsr_read(rt2x00dev, 30, &rfcsr);
+       rt2x00_set_field8(&rfcsr, RFCSR30_TX_H20M, 0);
+       rt2x00_set_field8(&rfcsr, RFCSR30_RX_H20M, 0);
+       rt2800_rfcsr_write(rt2x00dev, 30, rfcsr);
+
+       rt2800_rfcsr_read(rt2x00dev, 3, &rfcsr);
+       rt2x00_set_field8(&rfcsr, RFCSR30_RF_CALIBRATION, 1);
+       rt2800_rfcsr_write(rt2x00dev, 3, rfcsr);
+}
+
 static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
 				  struct ieee80211_conf *conf,
 				  struct rf_channel *rf,
@@ -1589,6 +1689,8 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
 	    rt2x00_rf(rt2x00dev, RF3052) ||
 	    rt2x00_rf(rt2x00dev, RF3320))
 		rt2800_config_channel_rf3xxx(rt2x00dev, conf, rf, info);
+       else if (rt2x00_rf(rt2x00dev, RF5390))
+               rt2800_config_channel_rf53xx(rt2x00dev, conf, rf, info);
 	else
 		rt2800_config_channel_rf2xxx(rt2x00dev, conf, rf, info);
 
@@ -1601,12 +1703,14 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
 	rt2800_bbp_write(rt2x00dev, 86, 0);
 
 	if (rf->channel <= 14) {
-		if (test_bit(CONFIG_EXTERNAL_LNA_BG, &rt2x00dev->flags)) {
-			rt2800_bbp_write(rt2x00dev, 82, 0x62);
-			rt2800_bbp_write(rt2x00dev, 75, 0x46);
-		} else {
-			rt2800_bbp_write(rt2x00dev, 82, 0x84);
-			rt2800_bbp_write(rt2x00dev, 75, 0x50);
+               if (!rt2x00_rt(rt2x00dev, RT5390)) {
+                       if (test_bit(CONFIG_EXTERNAL_LNA_BG, &rt2x00dev->flags)) {
+                               rt2800_bbp_write(rt2x00dev, 82, 0x62);
+                               rt2800_bbp_write(rt2x00dev, 75, 0x46);
+                       } else {
+                               rt2800_bbp_write(rt2x00dev, 82, 0x84);
+                               rt2800_bbp_write(rt2x00dev, 75, 0x50);
+                       }
 		}
 	} else {
 		rt2800_bbp_write(rt2x00dev, 82, 0xf2);
@@ -1985,7 +2089,8 @@ static u8 rt2800_get_default_vgc(struct rt2x00_dev *rt2x00dev)
 		if (rt2x00_rt(rt2x00dev, RT3070) ||
 		    rt2x00_rt(rt2x00dev, RT3071) ||
 		    rt2x00_rt(rt2x00dev, RT3090) ||
-		    rt2x00_rt(rt2x00dev, RT3390))
+                   rt2x00_rt(rt2x00dev, RT3390) ||
+                   rt2x00_rt(rt2x00dev, RT5390))
 			return 0x1c + (2 * rt2x00dev->lna_gain);
 		else
 			return 0x2e + rt2x00dev->lna_gain;
@@ -2117,6 +2222,10 @@ static int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
 		rt2800_register_write(rt2x00dev, TX_SW_CFG0, 0x00000400);
 		rt2800_register_write(rt2x00dev, TX_SW_CFG1, 0x00000000);
 		rt2800_register_write(rt2x00dev, TX_SW_CFG2, 0x0000001f);
+       } else if (rt2x00_rt(rt2x00dev, RT5390)) {
+               rt2800_register_write(rt2x00dev, TX_SW_CFG0, 0x00000404);
+               rt2800_register_write(rt2x00dev, TX_SW_CFG1, 0x00080606);
+               rt2800_register_write(rt2x00dev, TX_SW_CFG2, 0x00000000);
 	} else {
 		rt2800_register_write(rt2x00dev, TX_SW_CFG0, 0x00000000);
 		rt2800_register_write(rt2x00dev, TX_SW_CFG1, 0x00080606);
@@ -2492,15 +2601,31 @@ static int rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
 		     rt2800_wait_bbp_ready(rt2x00dev)))
 		return -EACCES;
 
-	if (rt2800_is_305x_soc(rt2x00dev))
+       if (rt2x00_rt(rt2x00dev, RT5390)) {
+               rt2800_bbp_read(rt2x00dev, 4, &value);
+               rt2x00_set_field8(&value, BBP4_MAC_IF_CTRL, 1);
+               rt2800_bbp_write(rt2x00dev, 4, value);
+       }
+
+       if (rt2800_is_305x_soc(rt2x00dev) ||
+           rt2x00_rt(rt2x00dev, RT5390))
 		rt2800_bbp_write(rt2x00dev, 31, 0x08);
 
 	rt2800_bbp_write(rt2x00dev, 65, 0x2c);
 	rt2800_bbp_write(rt2x00dev, 66, 0x38);
 
+       if (rt2x00_rt(rt2x00dev, RT5390))
+               rt2800_bbp_write(rt2x00dev, 68, 0x0b);
+
 	if (rt2x00_rt_rev(rt2x00dev, RT2860, REV_RT2860C)) {
 		rt2800_bbp_write(rt2x00dev, 69, 0x16);
 		rt2800_bbp_write(rt2x00dev, 73, 0x12);
+       } else if (rt2x00_rt(rt2x00dev, RT5390)) {
+               rt2800_bbp_write(rt2x00dev, 69, 0x12);
+               rt2800_bbp_write(rt2x00dev, 73, 0x13);
+               rt2800_bbp_write(rt2x00dev, 75, 0x46);
+               rt2800_bbp_write(rt2x00dev, 76, 0x28);
+               rt2800_bbp_write(rt2x00dev, 77, 0x59);
 	} else {
 		rt2800_bbp_write(rt2x00dev, 69, 0x12);
 		rt2800_bbp_write(rt2x00dev, 73, 0x10);
@@ -2511,7 +2636,8 @@ static int rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
 	if (rt2x00_rt(rt2x00dev, RT3070) ||
 	    rt2x00_rt(rt2x00dev, RT3071) ||
 	    rt2x00_rt(rt2x00dev, RT3090) ||
-	    rt2x00_rt(rt2x00dev, RT3390)) {
+           rt2x00_rt(rt2x00dev, RT3390) ||
+           rt2x00_rt(rt2x00dev, RT5390)) {
 		rt2800_bbp_write(rt2x00dev, 79, 0x13);
 		rt2800_bbp_write(rt2x00dev, 80, 0x05);
 		rt2800_bbp_write(rt2x00dev, 81, 0x33);
@@ -2523,35 +2649,62 @@ static int rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
 	}
 
 	rt2800_bbp_write(rt2x00dev, 82, 0x62);
-	rt2800_bbp_write(rt2x00dev, 83, 0x6a);
+       if (rt2x00_rt(rt2x00dev, RT5390))
+               rt2800_bbp_write(rt2x00dev, 83, 0x7a);
+       else
+               rt2800_bbp_write(rt2x00dev, 83, 0x6a);
 
 	if (rt2x00_rt_rev(rt2x00dev, RT2860, REV_RT2860D))
 		rt2800_bbp_write(rt2x00dev, 84, 0x19);
+       else if (rt2x00_rt(rt2x00dev, RT5390))
+               rt2800_bbp_write(rt2x00dev, 84, 0x9a);
 	else
 		rt2800_bbp_write(rt2x00dev, 84, 0x99);
 
-	rt2800_bbp_write(rt2x00dev, 86, 0x00);
+       if (rt2x00_rt(rt2x00dev, RT5390))
+               rt2800_bbp_write(rt2x00dev, 86, 0x38);
+       else
+               rt2800_bbp_write(rt2x00dev, 86, 0x00);
+
 	rt2800_bbp_write(rt2x00dev, 91, 0x04);
-	rt2800_bbp_write(rt2x00dev, 92, 0x00);
+
+       if (rt2x00_rt(rt2x00dev, RT5390))
+               rt2800_bbp_write(rt2x00dev, 92, 0x02);
+       else
+               rt2800_bbp_write(rt2x00dev, 92, 0x00);
 
 	if (rt2x00_rt_rev_gte(rt2x00dev, RT3070, REV_RT3070F) ||
 	    rt2x00_rt_rev_gte(rt2x00dev, RT3071, REV_RT3071E) ||
 	    rt2x00_rt_rev_gte(rt2x00dev, RT3090, REV_RT3090E) ||
 	    rt2x00_rt_rev_gte(rt2x00dev, RT3390, REV_RT3390E) ||
+           rt2x00_rt(rt2x00dev, RT5390) ||
 	    rt2800_is_305x_soc(rt2x00dev))
 		rt2800_bbp_write(rt2x00dev, 103, 0xc0);
 	else
 		rt2800_bbp_write(rt2x00dev, 103, 0x00);
 
+       if (rt2x00_rt(rt2x00dev, RT5390))
+               rt2800_bbp_write(rt2x00dev, 104, 0x92);
+
 	if (rt2800_is_305x_soc(rt2x00dev))
 		rt2800_bbp_write(rt2x00dev, 105, 0x01);
+       else if (rt2x00_rt(rt2x00dev, RT5390))
+               rt2800_bbp_write(rt2x00dev, 105, 0x3c);
 	else
 		rt2800_bbp_write(rt2x00dev, 105, 0x05);
-	rt2800_bbp_write(rt2x00dev, 106, 0x35);
+
+       if (rt2x00_rt(rt2x00dev, RT5390))
+               rt2800_bbp_write(rt2x00dev, 106, 0x03);
+       else
+               rt2800_bbp_write(rt2x00dev, 106, 0x35);
+
+       if (rt2x00_rt(rt2x00dev, RT5390))
+               rt2800_bbp_write(rt2x00dev, 128, 0x12);
 
 	if (rt2x00_rt(rt2x00dev, RT3071) ||
 	    rt2x00_rt(rt2x00dev, RT3090) ||
-	    rt2x00_rt(rt2x00dev, RT3390)) {
+           rt2x00_rt(rt2x00dev, RT3390) ||
+           rt2x00_rt(rt2x00dev, RT5390)) {
 		rt2800_bbp_read(rt2x00dev, 138, &value);
 
 		rt2x00_eeprom_read(rt2x00dev, EEPROM_NIC_CONF0, &eeprom);
@@ -2563,6 +2716,41 @@ static int rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
 		rt2800_bbp_write(rt2x00dev, 138, value);
 	}
 
+       if (rt2x00_rt(rt2x00dev, RT5390)) {
+               int ant, div_mode;
+
+               rt2x00_eeprom_read(rt2x00dev, EEPROM_NIC_CONF1, &eeprom);
+               div_mode = rt2x00_get_field16(eeprom, EEPROM_NIC_CONF1_ANT_DIVERSITY);
+               ant = (div_mode == 3) ? 1 : 0;
+
+               /* check if this is a Bluetooth combo card */
+               rt2x00_eeprom_read(rt2x00dev, EEPROM_NIC_CONF1, &eeprom);
+               if (rt2x00_get_field16(eeprom, EEPROM_NIC_CONF1_BT_COEXIST)) {
+                       u32 reg;
+
+                       rt2800_register_read(rt2x00dev, GPIO_CTRL_CFG, &reg);
+                       rt2x00_set_field32(&reg, GPIO_CTRL_CFG_GPIOD_BIT3, 0);
+                       rt2x00_set_field32(&reg, GPIO_CTRL_CFG_GPIOD_BIT6, 0);
+                       rt2x00_set_field32(&reg, GPIO_CTRL_CFG_BIT3, 0);
+                       rt2x00_set_field32(&reg, GPIO_CTRL_CFG_BIT6, 0);
+                       if (ant == 0)
+                               rt2x00_set_field32(&reg, GPIO_CTRL_CFG_BIT3, 1);
+                       else if (ant == 1)
+                               rt2x00_set_field32(&reg, GPIO_CTRL_CFG_BIT6, 1);
+                       rt2800_register_write(rt2x00dev, GPIO_CTRL_CFG, reg);
+               }
+
+               rt2800_bbp_read(rt2x00dev, 152, &value);
+               if (ant == 0)
+                       rt2x00_set_field8(&value, BBP152_RX_DEFAULT_ANT, 1);
+               else
+                       rt2x00_set_field8(&value, BBP152_RX_DEFAULT_ANT, 0);
+               rt2800_bbp_write(rt2x00dev, 152, value);
+
+               /* Init frequency calibration */
+               rt2800_bbp_write(rt2x00dev, 142, 1);
+               rt2800_bbp_write(rt2x00dev, 143, 57);
+       }
 
 	for (i = 0; i < EEPROM_BBP_SIZE; i++) {
 		rt2x00_eeprom_read(rt2x00dev, EEPROM_BBP_START + i, &eeprom);
@@ -2652,18 +2840,28 @@ static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
 	    !rt2x00_rt(rt2x00dev, RT3071) &&
 	    !rt2x00_rt(rt2x00dev, RT3090) &&
 	    !rt2x00_rt(rt2x00dev, RT3390) &&
+           !rt2x00_rt(rt2x00dev, RT5390) &&
 	    !rt2800_is_305x_soc(rt2x00dev))
 		return 0;
 
 	/*
 	 * Init RF calibration.
 	 */
-	rt2800_rfcsr_read(rt2x00dev, 30, &rfcsr);
-	rt2x00_set_field8(&rfcsr, RFCSR30_RF_CALIBRATION, 1);
-	rt2800_rfcsr_write(rt2x00dev, 30, rfcsr);
-	msleep(1);
-	rt2x00_set_field8(&rfcsr, RFCSR30_RF_CALIBRATION, 0);
-	rt2800_rfcsr_write(rt2x00dev, 30, rfcsr);
+       if (rt2x00_rt(rt2x00dev, RT5390)) {
+               rt2800_rfcsr_read(rt2x00dev, 2, &rfcsr);
+               rt2x00_set_field8(&rfcsr, RFCSR2_RESCAL_EN, 1);
+               rt2800_rfcsr_write(rt2x00dev, 2, rfcsr);
+               msleep(1);
+               rt2x00_set_field8(&rfcsr, RFCSR2_RESCAL_EN, 0);
+               rt2800_rfcsr_write(rt2x00dev, 2, rfcsr);
+       } else {
+               rt2800_rfcsr_read(rt2x00dev, 30, &rfcsr);
+               rt2x00_set_field8(&rfcsr, RFCSR30_RF_CALIBRATION, 1);
+               rt2800_rfcsr_write(rt2x00dev, 30, rfcsr);
+               msleep(1);
+               rt2x00_set_field8(&rfcsr, RFCSR30_RF_CALIBRATION, 0);
+               rt2800_rfcsr_write(rt2x00dev, 30, rfcsr);
+       }
 
 	if (rt2x00_rt(rt2x00dev, RT3070) ||
 	    rt2x00_rt(rt2x00dev, RT3071) ||
@@ -2754,6 +2952,87 @@ static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
 		rt2800_rfcsr_write(rt2x00dev, 30, 0x00);
 		rt2800_rfcsr_write(rt2x00dev, 31, 0x00);
 		return 0;
+       } else if (rt2x00_rt(rt2x00dev, RT5390)) {
+               rt2800_rfcsr_write(rt2x00dev, 1, 0x0f);
+               rt2800_rfcsr_write(rt2x00dev, 2, 0x80);
+               rt2800_rfcsr_write(rt2x00dev, 3, 0x88);
+               rt2800_rfcsr_write(rt2x00dev, 5, 0x10);
+               if (rt2x00_rt_rev_gte(rt2x00dev, RT5390, REV_RT5390F))
+                       rt2800_rfcsr_write(rt2x00dev, 6, 0xe0);
+               else
+                       rt2800_rfcsr_write(rt2x00dev, 6, 0xa0);
+               rt2800_rfcsr_write(rt2x00dev, 7, 0x00);
+               rt2800_rfcsr_write(rt2x00dev, 10, 0x53);
+               rt2800_rfcsr_write(rt2x00dev, 11, 0x4a);
+               rt2800_rfcsr_write(rt2x00dev, 12, 0xc6);
+               rt2800_rfcsr_write(rt2x00dev, 13, 0x9f);
+               rt2800_rfcsr_write(rt2x00dev, 14, 0x00);
+               rt2800_rfcsr_write(rt2x00dev, 15, 0x00);
+               rt2800_rfcsr_write(rt2x00dev, 16, 0x00);
+               rt2800_rfcsr_write(rt2x00dev, 18, 0x03);
+               rt2800_rfcsr_write(rt2x00dev, 19, 0x00);
+
+               rt2800_rfcsr_write(rt2x00dev, 20, 0x00);
+               rt2800_rfcsr_write(rt2x00dev, 21, 0x00);
+               rt2800_rfcsr_write(rt2x00dev, 22, 0x20);
+               rt2800_rfcsr_write(rt2x00dev, 23, 0x00);
+               rt2800_rfcsr_write(rt2x00dev, 24, 0x00);
+               if (rt2x00_rt_rev_gte(rt2x00dev, RT5390, REV_RT5390F))
+                       rt2800_rfcsr_write(rt2x00dev, 25, 0x80);
+               else
+                       rt2800_rfcsr_write(rt2x00dev, 25, 0xc0);
+               rt2800_rfcsr_write(rt2x00dev, 26, 0x00);
+               rt2800_rfcsr_write(rt2x00dev, 27, 0x09);
+               rt2800_rfcsr_write(rt2x00dev, 28, 0x00);
+               rt2800_rfcsr_write(rt2x00dev, 29, 0x10);
+
+               rt2800_rfcsr_write(rt2x00dev, 30, 0x00);
+               rt2800_rfcsr_write(rt2x00dev, 31, 0x80);
+               rt2800_rfcsr_write(rt2x00dev, 32, 0x80);
+               rt2800_rfcsr_write(rt2x00dev, 33, 0x00);
+               rt2800_rfcsr_write(rt2x00dev, 34, 0x07);
+               rt2800_rfcsr_write(rt2x00dev, 35, 0x12);
+               rt2800_rfcsr_write(rt2x00dev, 36, 0x00);
+               rt2800_rfcsr_write(rt2x00dev, 37, 0x08);
+               rt2800_rfcsr_write(rt2x00dev, 38, 0x85);
+               rt2800_rfcsr_write(rt2x00dev, 39, 0x1b);
+
+               if (rt2x00_rt_rev_gte(rt2x00dev, RT5390, REV_RT5390F))
+                       rt2800_rfcsr_write(rt2x00dev, 40, 0x0b);
+               else
+                       rt2800_rfcsr_write(rt2x00dev, 40, 0x4b);
+               rt2800_rfcsr_write(rt2x00dev, 41, 0xbb);
+               rt2800_rfcsr_write(rt2x00dev, 42, 0xd2);
+               rt2800_rfcsr_write(rt2x00dev, 43, 0x9a);
+               rt2800_rfcsr_write(rt2x00dev, 44, 0x0e);
+               rt2800_rfcsr_write(rt2x00dev, 45, 0xa2);
+               if (rt2x00_rt_rev_gte(rt2x00dev, RT5390, REV_RT5390F))
+                       rt2800_rfcsr_write(rt2x00dev, 46, 0x73);
+               else
+                       rt2800_rfcsr_write(rt2x00dev, 46, 0x7b);
+               rt2800_rfcsr_write(rt2x00dev, 47, 0x00);
+               rt2800_rfcsr_write(rt2x00dev, 48, 0x10);
+               rt2800_rfcsr_write(rt2x00dev, 49, 0x94);
+
+               rt2800_rfcsr_write(rt2x00dev, 52, 0x38);
+               if (rt2x00_rt_rev_gte(rt2x00dev, RT5390, REV_RT5390F))
+                       rt2800_rfcsr_write(rt2x00dev, 53, 0x00);
+               else
+                       rt2800_rfcsr_write(rt2x00dev, 53, 0x84);
+               rt2800_rfcsr_write(rt2x00dev, 54, 0x78);
+               rt2800_rfcsr_write(rt2x00dev, 55, 0x44);
+               rt2800_rfcsr_write(rt2x00dev, 56, 0x22);
+               rt2800_rfcsr_write(rt2x00dev, 57, 0x80);
+               rt2800_rfcsr_write(rt2x00dev, 58, 0x7f);
+               rt2800_rfcsr_write(rt2x00dev, 59, 0x63);
+
+               rt2800_rfcsr_write(rt2x00dev, 60, 0x45);
+               if (rt2x00_rt_rev_gte(rt2x00dev, RT5390, REV_RT5390F))
+                       rt2800_rfcsr_write(rt2x00dev, 61, 0xd1);
+               else
+                       rt2800_rfcsr_write(rt2x00dev, 61, 0xdd);
+               rt2800_rfcsr_write(rt2x00dev, 62, 0x00);
+               rt2800_rfcsr_write(rt2x00dev, 63, 0x00);
 	}
 
 	if (rt2x00_rt_rev_lt(rt2x00dev, RT3070, REV_RT3070F)) {
@@ -2807,21 +3086,23 @@ static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
 			rt2800_init_rx_filter(rt2x00dev, true, 0x27, 0x15);
 	}
 
-	/*
-	 * Set back to initial state
-	 */
-	rt2800_bbp_write(rt2x00dev, 24, 0);
+       if (!rt2x00_rt(rt2x00dev, RT5390)) {
+               /*
+                * Set back to initial state
+                */
+               rt2800_bbp_write(rt2x00dev, 24, 0);
 
-	rt2800_rfcsr_read(rt2x00dev, 22, &rfcsr);
-	rt2x00_set_field8(&rfcsr, RFCSR22_BASEBAND_LOOPBACK, 0);
-	rt2800_rfcsr_write(rt2x00dev, 22, rfcsr);
+               rt2800_rfcsr_read(rt2x00dev, 22, &rfcsr);
+               rt2x00_set_field8(&rfcsr, RFCSR22_BASEBAND_LOOPBACK, 0);
+               rt2800_rfcsr_write(rt2x00dev, 22, rfcsr);
 
-	/*
-	 * set BBP back to BW20
-	 */
-	rt2800_bbp_read(rt2x00dev, 4, &bbp);
-	rt2x00_set_field8(&bbp, BBP4_BANDWIDTH, 0);
-	rt2800_bbp_write(rt2x00dev, 4, bbp);
+               /*
+                * Set BBP back to BW20
+                */
+               rt2800_bbp_read(rt2x00dev, 4, &bbp);
+               rt2x00_set_field8(&bbp, BBP4_BANDWIDTH, 0);
+               rt2800_bbp_write(rt2x00dev, 4, bbp);
+       }
 
 	if (rt2x00_rt_rev_lt(rt2x00dev, RT3070, REV_RT3070F) ||
 	    rt2x00_rt_rev_lt(rt2x00dev, RT3071, REV_RT3071E) ||
@@ -2833,21 +3114,23 @@ static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
 	rt2x00_set_field32(&reg, OPT_14_CSR_BIT0, 1);
 	rt2800_register_write(rt2x00dev, OPT_14_CSR, reg);
 
-	rt2800_rfcsr_read(rt2x00dev, 17, &rfcsr);
-	rt2x00_set_field8(&rfcsr, RFCSR17_TX_LO1_EN, 0);
-	if (rt2x00_rt(rt2x00dev, RT3070) ||
-	    rt2x00_rt_rev_lt(rt2x00dev, RT3071, REV_RT3071E) ||
-	    rt2x00_rt_rev_lt(rt2x00dev, RT3090, REV_RT3090E) ||
-	    rt2x00_rt_rev_lt(rt2x00dev, RT3390, REV_RT3390E)) {
-		if (!test_bit(CONFIG_EXTERNAL_LNA_BG, &rt2x00dev->flags))
-			rt2x00_set_field8(&rfcsr, RFCSR17_R, 1);
-	}
-	rt2x00_eeprom_read(rt2x00dev, EEPROM_TXMIXER_GAIN_BG, &eeprom);
-	if (rt2x00_get_field16(eeprom, EEPROM_TXMIXER_GAIN_BG_VAL) >= 1)
-		rt2x00_set_field8(&rfcsr, RFCSR17_TXMIXER_GAIN,
-				  rt2x00_get_field16(eeprom,
-						   EEPROM_TXMIXER_GAIN_BG_VAL));
-	rt2800_rfcsr_write(rt2x00dev, 17, rfcsr);
+       if (!rt2x00_rt(rt2x00dev, RT5390)) {
+               rt2800_rfcsr_read(rt2x00dev, 17, &rfcsr);
+               rt2x00_set_field8(&rfcsr, RFCSR17_TX_LO1_EN, 0);
+               if (rt2x00_rt(rt2x00dev, RT3070) ||
+                   rt2x00_rt_rev_lt(rt2x00dev, RT3071, REV_RT3071E) ||
+                   rt2x00_rt_rev_lt(rt2x00dev, RT3090, REV_RT3090E) ||
+                   rt2x00_rt_rev_lt(rt2x00dev, RT3390, REV_RT3390E)) {
+                       if (!test_bit(CONFIG_EXTERNAL_LNA_BG, &rt2x00dev->flags))
+                               rt2x00_set_field8(&rfcsr, RFCSR17_R, 1);
+               }
+               rt2x00_eeprom_read(rt2x00dev, EEPROM_TXMIXER_GAIN_BG, &eeprom);
+               if (rt2x00_get_field16(eeprom, EEPROM_TXMIXER_GAIN_BG_VAL) >= 1)
+                       rt2x00_set_field8(&rfcsr, RFCSR17_TXMIXER_GAIN,
+                                       rt2x00_get_field16(eeprom,
+                                               EEPROM_TXMIXER_GAIN_BG_VAL));
+               rt2800_rfcsr_write(rt2x00dev, 17, rfcsr);
+       }
 
 	if (rt2x00_rt(rt2x00dev, RT3090)) {
 		rt2800_bbp_read(rt2x00dev, 138, &bbp);
@@ -2898,6 +3181,20 @@ static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
 		rt2800_rfcsr_write(rt2x00dev, 27, rfcsr);
 	}
 
+       if (rt2x00_rt(rt2x00dev, RT5390)) {
+               rt2800_rfcsr_read(rt2x00dev, 38, &rfcsr);
+               rt2x00_set_field8(&rfcsr, RFCSR38_RX_LO1_EN, 0);
+               rt2800_rfcsr_write(rt2x00dev, 38, rfcsr);
+
+               rt2800_rfcsr_read(rt2x00dev, 39, &rfcsr);
+               rt2x00_set_field8(&rfcsr, RFCSR39_RX_LO2_EN, 0);
+               rt2800_rfcsr_write(rt2x00dev, 39, rfcsr);
+
+               rt2800_rfcsr_read(rt2x00dev, 30, &rfcsr);
+               rt2x00_set_field8(&rfcsr, RFCSR30_RX_VCM, 2);
+               rt2800_rfcsr_write(rt2x00dev, 30, rfcsr);
+       }
+
 	return 0;
 }
 
@@ -3162,10 +3459,15 @@ int rt2800_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	rt2x00_eeprom_read(rt2x00dev, EEPROM_NIC_CONF0, &eeprom);
 
 	/*
-	 * Identify RF chipset.
+        * Identify RF chipset by EEPROM value
+        * RT28xx/RT30xx: defined in "EEPROM_NIC_CONF0_RF_TYPE" field
+        * RT53xx: defined in "EEPROM_CHIP_ID" field
 	 */
-	value = rt2x00_get_field16(eeprom, EEPROM_NIC_CONF0_RF_TYPE);
 	rt2800_register_read(rt2x00dev, MAC_CSR0, &reg);
+       if (rt2x00_get_field32(reg, MAC_CSR0_CHIPSET) == RT5390)
+               rt2x00_eeprom_read(rt2x00dev, EEPROM_CHIP_ID, &value);
+       else
+               value = rt2x00_get_field16(eeprom, EEPROM_NIC_CONF0_RF_TYPE);
 
 	rt2x00_set_chip(rt2x00dev, rt2x00_get_field32(reg, MAC_CSR0_CHIPSET),
 			value, rt2x00_get_field32(reg, MAC_CSR0_REVISION));
@@ -3177,7 +3479,8 @@ int rt2800_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	    !rt2x00_rt(rt2x00dev, RT3071) &&
 	    !rt2x00_rt(rt2x00dev, RT3090) &&
 	    !rt2x00_rt(rt2x00dev, RT3390) &&
-	    !rt2x00_rt(rt2x00dev, RT3572)) {
+           !rt2x00_rt(rt2x00dev, RT3572) &&
+           !rt2x00_rt(rt2x00dev, RT5390)) {
 		ERROR(rt2x00dev, "Invalid RT chipset detected.\n");
 		return -ENODEV;
 	}
@@ -3191,7 +3494,8 @@ int rt2800_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	    !rt2x00_rf(rt2x00dev, RF3021) &&
 	    !rt2x00_rf(rt2x00dev, RF3022) &&
 	    !rt2x00_rf(rt2x00dev, RF3052) &&
-	    !rt2x00_rf(rt2x00dev, RF3320)) {
+           !rt2x00_rf(rt2x00dev, RF3320) &&
+           !rt2x00_rf(rt2x00dev, RF5390)) {
 		ERROR(rt2x00dev, "Invalid RF chipset detected.\n");
 		return -ENODEV;
 	}
@@ -3488,7 +3792,8 @@ int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 		   rt2x00_rf(rt2x00dev, RF2020) ||
 		   rt2x00_rf(rt2x00dev, RF3021) ||
 		   rt2x00_rf(rt2x00dev, RF3022) ||
-		   rt2x00_rf(rt2x00dev, RF3320)) {
+                  rt2x00_rf(rt2x00dev, RF3320) ||
+                  rt2x00_rf(rt2x00dev, RF5390)) {
 		spec->num_channels = 14;
 		spec->channels = rf_vals_3x;
 	} else if (rt2x00_rf(rt2x00dev, RF3052)) {
diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index 8f4dfc3..cc7c90c 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -493,6 +493,13 @@ static int rt2800pci_init_registers(struct rt2x00_dev *rt2x00dev)
 	rt2800_register_write(rt2x00dev, PBF_SYS_CTRL, 0x00000e1f);
 	rt2800_register_write(rt2x00dev, PBF_SYS_CTRL, 0x00000e00);
 
+       if (rt2x00_rt(rt2x00dev, RT5390)) {
+               rt2800_register_read(rt2x00dev, AUX_CTRL, &reg);
+               rt2x00_set_field32(&reg, AUX_CTRL_FORCE_PCIE_CLK, 1);
+               rt2x00_set_field32(&reg, AUX_CTRL_WAKE_PCIE_EN, 1);
+               rt2800_register_write(rt2x00dev, AUX_CTRL, reg);
+       }
+
 	rt2800_register_write(rt2x00dev, PWR_PIN_CFG, 0x00000003);
 
 	rt2800_register_read(rt2x00dev, MAC_SYS_CTRL, &reg);
@@ -1125,6 +1132,9 @@ static DEFINE_PCI_DEVICE_TABLE(rt2800pci_device_table) = {
 	{ PCI_DEVICE(0x1814, 0x3592), PCI_DEVICE_DATA(&rt2800pci_ops) },
 	{ PCI_DEVICE(0x1814, 0x3593), PCI_DEVICE_DATA(&rt2800pci_ops) },
 #endif
+#ifdef CONFIG_RT2800PCI_RT53XX
+       { PCI_DEVICE(0x1814, 0x5390), PCI_DEVICE_DATA(&rt2800pci_ops) },
+#endif
 	{ 0, }
 };
 #endif /* CONFIG_PCI */
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 64c6ef5..1df432c 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -189,6 +189,7 @@ struct rt2x00_chip {
 #define RT3572		0x3572
 #define RT3593		0x3593	/* PCIe */
 #define RT3883		0x3883	/* WSOC */
+#define RT5390         0x5390  /* 2.4GHz */
 
 	u16 rf;
 	u16 rev;
-- 
1.7.2.3

