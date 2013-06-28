Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:49904 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752167Ab3F1TNP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Jun 2013 15:13:15 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 02/19] rt2x00: rt2800lib: add RFCSR register initialization for RT3593
Date: Fri, 28 Jun 2013 21:12:16 +0200
Message-Id: <1372446753-11408-3-git-send-email-juhosg@openwrt.org> (sfid-20130628_211357_072930_FAF4A533)
In-Reply-To: <1372446753-11408-1-git-send-email-juhosg@openwrt.org>
References: <1372446753-11408-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Based on the Ralink DPO_RT5572_LinuxSTA_2.6.0.1_20120629
driver.

References:
  NICInitRT3593RFRegisters in chips/rt3593.c
  RT3593LoadRFNormalModeSetup in chips/rt3593.c

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/rt2x00/rt2800.h    |   10 +++
 drivers/net/wireless/rt2x00/rt2800lib.c |  122 +++++++++++++++++++++++++++++++
 2 files changed, 132 insertions(+)

diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
index 02bc80d..47aceae 100644
--- a/drivers/net/wireless/rt2x00/rt2800.h
+++ b/drivers/net/wireless/rt2x00/rt2800.h
@@ -2093,6 +2093,10 @@ struct mac_iveiv_entry {
 #define RFCSR17_R			FIELD8(0x20)
 #define RFCSR17_CODE                   FIELD8(0x7f)
 
+/* RFCSR 18 */
+#define RFCSR18_XO_TUNE_BYPASS		FIELD8(0x40)
+
+
 /*
  * RFCSR 20:
  */
@@ -2174,6 +2178,12 @@ struct mac_iveiv_entry {
  */
 #define RFCSR50_TX			FIELD8(0x3f)
 #define RFCSR50_EP			FIELD8(0xc0)
+/* bits for RT3593*/
+#define RFCSR50_TX_LO2_EN		FIELD8(0x10)
+
+/* RFCSR 51 */
+/* bits for RT3593*/
+#define RFCSR51_BITS24			FIELD8(0x1c)
 
 /*
  * RF registers
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 32ecd1a..0041b2c 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -4964,6 +4964,42 @@ static void rt2800_normal_mode_setup_3xxx(struct rt2x00_dev *rt2x00dev)
 	}
 }
 
+static void rt2800_normal_mode_setup_3593(struct rt2x00_dev *rt2x00dev)
+{
+	struct rt2800_drv_data *drv_data = rt2x00dev->drv_data;
+	u8 rfcsr;
+	u8 tx_gain;
+
+	rt2800_rfcsr_read(rt2x00dev, 50, &rfcsr);
+	rt2x00_set_field8(&rfcsr, RFCSR50_TX_LO2_EN, 0);
+	rt2800_rfcsr_write(rt2x00dev, 50, rfcsr);
+
+	rt2800_rfcsr_read(rt2x00dev, 51, &rfcsr);
+	tx_gain = rt2x00_get_field8(drv_data->txmixer_gain_24g,
+				    RFCSR17_TXMIXER_GAIN);
+	rt2x00_set_field8(&rfcsr, RFCSR51_BITS24, tx_gain);
+	rt2800_rfcsr_write(rt2x00dev, 51, rfcsr);
+
+	rt2800_rfcsr_read(rt2x00dev, 38, &rfcsr);
+	rt2x00_set_field8(&rfcsr, RFCSR38_RX_LO1_EN, 0);
+	rt2800_rfcsr_write(rt2x00dev, 38, rfcsr);
+
+	rt2800_rfcsr_read(rt2x00dev, 39, &rfcsr);
+	rt2x00_set_field8(&rfcsr, RFCSR39_RX_LO2_EN, 0);
+	rt2800_rfcsr_write(rt2x00dev, 39, rfcsr);
+
+	rt2800_rfcsr_read(rt2x00dev, 1, &rfcsr);
+	rt2x00_set_field8(&rfcsr, RFCSR1_RF_BLOCK_EN, 1);
+	rt2x00_set_field8(&rfcsr, RFCSR1_PLL_PD, 1);
+	rt2800_rfcsr_write(rt2x00dev, 1, rfcsr);
+
+	rt2800_rfcsr_read(rt2x00dev, 30, &rfcsr);
+	rt2x00_set_field8(&rfcsr, RFCSR30_RX_VCM, 2);
+	rt2800_rfcsr_write(rt2x00dev, 30, rfcsr);
+
+	/* TODO: enable stream mode */
+}
+
 static void rt2800_normal_mode_setup_5xxx(struct rt2x00_dev *rt2x00dev)
 {
 	u8 reg;
@@ -5346,6 +5382,89 @@ static void rt2800_init_rfcsr_3572(struct rt2x00_dev *rt2x00dev)
 	rt2800_normal_mode_setup_3xxx(rt2x00dev);
 }
 
+static void rt2800_init_rfcsr_3593(struct rt2x00_dev *rt2x00dev)
+{
+	struct rt2800_drv_data *drv_data = rt2x00dev->drv_data;
+	u32 reg;
+	u8 rfcsr;
+
+	/* Disable GPIO #4 and #7 function for LAN PE control */
+	rt2800_register_read(rt2x00dev, GPIO_SWITCH, &reg);
+	rt2x00_set_field32(&reg, GPIO_SWITCH_4, 0);
+	rt2x00_set_field32(&reg, GPIO_SWITCH_7, 0);
+	rt2800_register_write(rt2x00dev, GPIO_SWITCH, reg);
+
+	/* Initialize default register values */
+	rt2800_rfcsr_write(rt2x00dev, 1, 0x03);
+	rt2800_rfcsr_write(rt2x00dev, 3, 0x80);
+	rt2800_rfcsr_write(rt2x00dev, 5, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 6, 0x40);
+	rt2800_rfcsr_write(rt2x00dev, 8, 0xf1);
+	rt2800_rfcsr_write(rt2x00dev, 9, 0x02);
+	rt2800_rfcsr_write(rt2x00dev, 10, 0xd3);
+	rt2800_rfcsr_write(rt2x00dev, 11, 0x40);
+	rt2800_rfcsr_write(rt2x00dev, 12, 0x4e);
+	rt2800_rfcsr_write(rt2x00dev, 13, 0x12);
+	rt2800_rfcsr_write(rt2x00dev, 18, 0x40);
+	rt2800_rfcsr_write(rt2x00dev, 22, 0x20);
+	rt2800_rfcsr_write(rt2x00dev, 30, 0x10);
+	rt2800_rfcsr_write(rt2x00dev, 31, 0x80);
+	rt2800_rfcsr_write(rt2x00dev, 32, 0x78);
+	rt2800_rfcsr_write(rt2x00dev, 33, 0x3b);
+	rt2800_rfcsr_write(rt2x00dev, 34, 0x3c);
+	rt2800_rfcsr_write(rt2x00dev, 35, 0xe0);
+	rt2800_rfcsr_write(rt2x00dev, 38, 0x86);
+	rt2800_rfcsr_write(rt2x00dev, 39, 0x23);
+	rt2800_rfcsr_write(rt2x00dev, 44, 0xd3);
+	rt2800_rfcsr_write(rt2x00dev, 45, 0xbb);
+	rt2800_rfcsr_write(rt2x00dev, 46, 0x60);
+	rt2800_rfcsr_write(rt2x00dev, 49, 0x8e);
+	rt2800_rfcsr_write(rt2x00dev, 50, 0x86);
+	rt2800_rfcsr_write(rt2x00dev, 51, 0x75);
+	rt2800_rfcsr_write(rt2x00dev, 52, 0x45);
+	rt2800_rfcsr_write(rt2x00dev, 53, 0x18);
+	rt2800_rfcsr_write(rt2x00dev, 54, 0x18);
+	rt2800_rfcsr_write(rt2x00dev, 55, 0x18);
+	rt2800_rfcsr_write(rt2x00dev, 56, 0xdb);
+	rt2800_rfcsr_write(rt2x00dev, 57, 0x6e);
+
+	/* Initiate calibration */
+	/* TODO: use rt2800_rf_init_calibration ? */
+	rt2800_rfcsr_read(rt2x00dev, 2, &rfcsr);
+	rt2x00_set_field8(&rfcsr, RFCSR2_RESCAL_EN, 1);
+	rt2800_rfcsr_write(rt2x00dev, 2, rfcsr);
+
+	rt2800_adjust_freq_offset(rt2x00dev);
+
+	rt2800_rfcsr_read(rt2x00dev, 18, &rfcsr);
+	rt2x00_set_field8(&rfcsr, RFCSR18_XO_TUNE_BYPASS, 1);
+	rt2800_rfcsr_write(rt2x00dev, 18, rfcsr);
+
+	rt2800_register_read(rt2x00dev, LDO_CFG0, &reg);
+	rt2x00_set_field32(&reg, LDO_CFG0_LDO_CORE_VLEVEL, 3);
+	rt2x00_set_field32(&reg, LDO_CFG0_BGSEL, 1);
+	rt2800_register_write(rt2x00dev, LDO_CFG0, reg);
+	usleep_range(1000, 1500);
+	rt2800_register_read(rt2x00dev, LDO_CFG0, &reg);
+	rt2x00_set_field32(&reg, LDO_CFG0_LDO_CORE_VLEVEL, 0);
+	rt2800_register_write(rt2x00dev, LDO_CFG0, reg);
+
+	/* Set initial values for RX filter calibration */
+	drv_data->calibration_bw20 = 0x1f;
+	drv_data->calibration_bw40 = 0x2f;
+
+	/* Save BBP 25 & 26 values for later use in channel switching */
+	rt2800_bbp_read(rt2x00dev, 25, &drv_data->bbp25);
+	rt2800_bbp_read(rt2x00dev, 26, &drv_data->bbp26);
+
+	rt2800_led_open_drain_enable(rt2x00dev);
+	rt2800_normal_mode_setup_3593(rt2x00dev);
+
+	/* TODO: post BBP initialization */
+
+	/* TODO: enable stream mode support */
+}
+
 static void rt2800_init_rfcsr_5390(struct rt2x00_dev *rt2x00dev)
 {
 	rt2800_rf_init_calibration(rt2x00dev, 2);
@@ -5571,6 +5690,9 @@ static void rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
 	case RT3390:
 		rt2800_init_rfcsr_3390(rt2x00dev);
 		break;
+	case RT3593:
+		rt2800_init_rfcsr_3593(rt2x00dev);
+		break;
 	case RT3572:
 		rt2800_init_rfcsr_3572(rt2x00dev);
 		break;
-- 
1.7.10

