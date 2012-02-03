Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:60729 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752848Ab2BCGTR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Feb 2012 01:19:17 -0500
Received: by pbdu11 with SMTP id u11so2652564pbd.19
        for <linux-wireless@vger.kernel.org>; Thu, 02 Feb 2012 22:19:16 -0800 (PST)
From: John Li <john.li.mediatek@gmail.com>
To: users@rt2x00.serialmonkey.com
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	John Li <chen-yang.li@mediatek.com>
Subject: [PATCH] rt2x00:Add RT5372 chipset support and VCO recalibration
Date: Fri,  3 Feb 2012 14:18:44 +0800
Message-Id: <1328249924-1766-1-git-send-email-john.li.mediatek@gmail.com> (sfid-20120203_071942_663873_303E4062)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: John Li <chen-yang.li@mediatek.com>

---
 drivers/net/wireless/rt2x00/Kconfig        |    2 +-
 drivers/net/wireless/rt2x00/rt2800.h       |    1 +
 drivers/net/wireless/rt2x00/rt2800lib.c    |  217 ++++++++++++++++++++++++----
 drivers/net/wireless/rt2x00/rt2800lib.h    |    1 +
 drivers/net/wireless/rt2x00/rt2800pci.c    |    2 +
 drivers/net/wireless/rt2x00/rt2800usb.c    |   15 ++
 drivers/net/wireless/rt2x00/rt2x00.h       |   13 ++
 drivers/net/wireless/rt2x00/rt2x00config.c |    3 +
 drivers/net/wireless/rt2x00/rt2x00dev.c    |    2 +
 drivers/net/wireless/rt2x00/rt2x00lib.h    |   13 ++
 drivers/net/wireless/rt2x00/rt2x00link.c   |   38 +++++
 11 files changed, 279 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/Kconfig b/drivers/net/wireless/rt2x00/Kconfig
index a0a7854..299c387 100644
--- a/drivers/net/wireless/rt2x00/Kconfig
+++ b/drivers/net/wireless/rt2x00/Kconfig
@@ -163,7 +163,7 @@ config RT2800USB_RT53XX
        depends on EXPERIMENTAL
        ---help---
          This adds support for rt53xx wireless chipset family to the
-         rt2800pci driver.
+         rt2800usb driver.
          Supported chips: RT5370
 
 config RT2800USB_UNKNOWN
diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
index 2571a2f..56b78c8 100644
--- a/drivers/net/wireless/rt2x00/rt2800.h
+++ b/drivers/net/wireless/rt2x00/rt2800.h
@@ -68,6 +68,7 @@
 #define RF3322				0x000c
 #define RF3053				0x000d
 #define RF5370				0x5370
+#define RF5372				0x5372
 #define RF5390				0x5390
 
 /*
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 22a1a8f..8778e22 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -402,7 +402,8 @@ int rt2800_load_firmware(struct rt2x00_dev *rt2x00dev,
 
 	if (rt2x00_is_pci(rt2x00dev)) {
 		if (rt2x00_rt(rt2x00dev, RT3572) ||
-		    rt2x00_rt(rt2x00dev, RT5390)) {
+		    rt2x00_rt(rt2x00dev, RT5390) ||
+		    rt2x00_rt(rt2x00dev, RT5392)) {
 			rt2800_register_read(rt2x00dev, AUX_CTRL, &reg);
 			rt2x00_set_field32(&reg, AUX_CTRL_FORCE_PCIE_CLK, 1);
 			rt2x00_set_field32(&reg, AUX_CTRL_WAKE_PCIE_EN, 1);
@@ -1906,7 +1907,8 @@ static void rt2800_config_channel_rf53xx(struct rt2x00_dev *rt2x00dev,
 						   r55_nonbt_rev[idx]);
 				rt2800_rfcsr_write(rt2x00dev, 59,
 						   r59_nonbt_rev[idx]);
-			} else if (rt2x00_rt(rt2x00dev, RT5390)) {
+			} else if (rt2x00_rt(rt2x00dev, RT5390) || 
+					   rt2x00_rt(rt2x00dev, RT5392)) {
 				static const char r59_non_bt[] = {0x8f, 0x8f,
 					0x8f, 0x8f, 0x8f, 0x8f, 0x8f, 0x8d,
 					0x8a, 0x88, 0x88, 0x87, 0x87, 0x86};
@@ -1956,6 +1958,7 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
 		rt2800_config_channel_rf3052(rt2x00dev, conf, rf, info);
 		break;
 	case RF5370:
+	case RF5372:
 	case RF5390:
 		rt2800_config_channel_rf53xx(rt2x00dev, conf, rf, info);
 		break;
@@ -1972,7 +1975,8 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
 	rt2800_bbp_write(rt2x00dev, 86, 0);
 
 	if (rf->channel <= 14) {
-		if (!rt2x00_rt(rt2x00dev, RT5390)) {
+		if (!rt2x00_rt(rt2x00dev, RT5390) || 
+			!rt2x00_rt(rt2x00dev, RT5392)) {
 			if (test_bit(CAPABILITY_EXTERNAL_LNA_BG,
 				     &rt2x00dev->cap_flags)) {
 				rt2800_bbp_write(rt2x00dev, 82, 0x62);
@@ -2414,6 +2418,59 @@ void rt2800_gain_calibration(struct rt2x00_dev *rt2x00dev)
 }
 EXPORT_SYMBOL_GPL(rt2800_gain_calibration);
 
+void rt2800_vco_calibration(struct rt2x00_dev *rt2x00dev)
+{
+	u32	tx_pin;
+	u8	rfcsr;
+
+	switch (rt2x00dev->chip.rf) {
+	case RF2020:
+	case RF3020:
+	case RF3021:
+	case RF3022:
+	case RF3320:
+	case RF3052:
+		rt2800_rfcsr_read(rt2x00dev, 7, &rfcsr);
+		rt2x00_set_field8(&rfcsr, RFCSR7_RF_TUNING, 1);
+		rt2800_rfcsr_write(rt2x00dev, 7, rfcsr);
+		break;
+	case RF5370:
+	case RF5372:
+	case RF5390:
+		rt2800_rfcsr_read(rt2x00dev, 3, &rfcsr);
+		rt2x00_set_field8(&rfcsr, RFCSR30_RF_CALIBRATION, 1);
+		rt2800_rfcsr_write(rt2x00dev, 3, rfcsr);
+		break;
+	default:
+		return;
+	}
+
+	mdelay(1);
+		
+	rt2800_register_read(rt2x00dev, TX_PIN_CFG, &tx_pin);
+	if (rt2x00dev->rf_channel <= 14)
+	{
+		if (rt2x00dev->default_ant.tx_chain_num == 1)
+			tx_pin |= 0x2;
+		else if (rt2x00dev->default_ant.tx_chain_num == 2)
+			tx_pin |= 0xA;
+		else if (rt2x00dev->default_ant.tx_chain_num == 3)
+			tx_pin |= 0x0200000A;
+	}
+	else
+	{
+		if (rt2x00dev->default_ant.tx_chain_num == 1)
+			tx_pin |= 0x1;
+		else if (rt2x00dev->default_ant.tx_chain_num == 2)
+			tx_pin |= 0x5;
+		else if (rt2x00dev->default_ant.tx_chain_num == 3)
+			tx_pin |= 0x01000005;
+	}
+	rt2800_register_write(rt2x00dev, TX_PIN_CFG, tx_pin);
+
+}
+EXPORT_SYMBOL_GPL(rt2800_vco_calibration);
+
 static void rt2800_config_retry_limit(struct rt2x00_dev *rt2x00dev,
 				      struct rt2x00lib_conf *libconf)
 {
@@ -2502,7 +2559,8 @@ static u8 rt2800_get_default_vgc(struct rt2x00_dev *rt2x00dev)
 		    rt2x00_rt(rt2x00dev, RT3071) ||
 		    rt2x00_rt(rt2x00dev, RT3090) ||
 		    rt2x00_rt(rt2x00dev, RT3390) ||
-		    rt2x00_rt(rt2x00dev, RT5390))
+		    rt2x00_rt(rt2x00dev, RT5390) ||
+		    rt2x00_rt(rt2x00dev, RT5392))
 			return 0x1c + (2 * rt2x00dev->lna_gain);
 		else
 			return 0x2e + rt2x00dev->lna_gain;
@@ -2637,7 +2695,8 @@ static int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
 	} else if (rt2x00_rt(rt2x00dev, RT3572)) {
 		rt2800_register_write(rt2x00dev, TX_SW_CFG0, 0x00000400);
 		rt2800_register_write(rt2x00dev, TX_SW_CFG1, 0x00080606);
-	} else if (rt2x00_rt(rt2x00dev, RT5390)) {
+	} else if (rt2x00_rt(rt2x00dev, RT5390) || 
+			   rt2x00_rt(rt2x00dev, RT5392)) {
 		rt2800_register_write(rt2x00dev, TX_SW_CFG0, 0x00000404);
 		rt2800_register_write(rt2x00dev, TX_SW_CFG1, 0x00080606);
 		rt2800_register_write(rt2x00dev, TX_SW_CFG2, 0x00000000);
@@ -3013,7 +3072,8 @@ static int rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
 		     rt2800_wait_bbp_ready(rt2x00dev)))
 		return -EACCES;
 
-	if (rt2x00_rt(rt2x00dev, RT5390)) {
+	if (rt2x00_rt(rt2x00dev, RT5390) || 
+		rt2x00_rt(rt2x00dev, RT5392)) {
 		rt2800_bbp_read(rt2x00dev, 4, &value);
 		rt2x00_set_field8(&value, BBP4_MAC_IF_CTRL, 1);
 		rt2800_bbp_write(rt2x00dev, 4, value);
@@ -3021,19 +3081,22 @@ static int rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
 
 	if (rt2800_is_305x_soc(rt2x00dev) ||
 	    rt2x00_rt(rt2x00dev, RT3572) ||
-	    rt2x00_rt(rt2x00dev, RT5390))
+	    rt2x00_rt(rt2x00dev, RT5390) || 
+	    rt2x00_rt(rt2x00dev, RT5392))
 		rt2800_bbp_write(rt2x00dev, 31, 0x08);
 
 	rt2800_bbp_write(rt2x00dev, 65, 0x2c);
 	rt2800_bbp_write(rt2x00dev, 66, 0x38);
 
-	if (rt2x00_rt(rt2x00dev, RT5390))
+	if (rt2x00_rt(rt2x00dev, RT5390) || 
+		rt2x00_rt(rt2x00dev, RT5392))
 		rt2800_bbp_write(rt2x00dev, 68, 0x0b);
 
 	if (rt2x00_rt_rev(rt2x00dev, RT2860, REV_RT2860C)) {
 		rt2800_bbp_write(rt2x00dev, 69, 0x16);
 		rt2800_bbp_write(rt2x00dev, 73, 0x12);
-	} else if (rt2x00_rt(rt2x00dev, RT5390)) {
+	} else if (rt2x00_rt(rt2x00dev, RT5390) || 
+			   rt2x00_rt(rt2x00dev, RT5392)) {
 		rt2800_bbp_write(rt2x00dev, 69, 0x12);
 		rt2800_bbp_write(rt2x00dev, 73, 0x13);
 		rt2800_bbp_write(rt2x00dev, 75, 0x46);
@@ -3051,7 +3114,8 @@ static int rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
 	    rt2x00_rt(rt2x00dev, RT3090) ||
 	    rt2x00_rt(rt2x00dev, RT3390) ||
 	    rt2x00_rt(rt2x00dev, RT3572) ||
-	    rt2x00_rt(rt2x00dev, RT5390)) {
+	    rt2x00_rt(rt2x00dev, RT5390) ||
+	    rt2x00_rt(rt2x00dev, RT5392)) {
 		rt2800_bbp_write(rt2x00dev, 79, 0x13);
 		rt2800_bbp_write(rt2x00dev, 80, 0x05);
 		rt2800_bbp_write(rt2x00dev, 81, 0x33);
@@ -3063,64 +3127,91 @@ static int rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
 	}
 
 	rt2800_bbp_write(rt2x00dev, 82, 0x62);
-	if (rt2x00_rt(rt2x00dev, RT5390))
+	if (rt2x00_rt(rt2x00dev, RT5390) || 
+		rt2x00_rt(rt2x00dev, RT5392))
 		rt2800_bbp_write(rt2x00dev, 83, 0x7a);
 	else
 		rt2800_bbp_write(rt2x00dev, 83, 0x6a);
 
 	if (rt2x00_rt_rev(rt2x00dev, RT2860, REV_RT2860D))
 		rt2800_bbp_write(rt2x00dev, 84, 0x19);
-	else if (rt2x00_rt(rt2x00dev, RT5390))
+	else if (rt2x00_rt(rt2x00dev, RT5390) || 
+			 rt2x00_rt(rt2x00dev, RT5392))
 		rt2800_bbp_write(rt2x00dev, 84, 0x9a);
 	else
 		rt2800_bbp_write(rt2x00dev, 84, 0x99);
 
-	if (rt2x00_rt(rt2x00dev, RT5390))
+	if (rt2x00_rt(rt2x00dev, RT5390) || 
+		rt2x00_rt(rt2x00dev, RT5390) || 
+		rt2x00_rt(rt2x00dev, RT5392))
 		rt2800_bbp_write(rt2x00dev, 86, 0x38);
 	else
 		rt2800_bbp_write(rt2x00dev, 86, 0x00);
+	
+	if (rt2x00_rt(rt2x00dev, RT5392))
+		rt2800_bbp_write(rt2x00dev, 88, 0x90);
 
 	rt2800_bbp_write(rt2x00dev, 91, 0x04);
 
-	if (rt2x00_rt(rt2x00dev, RT5390))
+	if (rt2x00_rt(rt2x00dev, RT5390) || 
+		rt2x00_rt(rt2x00dev, RT5390))
 		rt2800_bbp_write(rt2x00dev, 92, 0x02);
 	else
 		rt2800_bbp_write(rt2x00dev, 92, 0x00);
 
+	if (rt2x00_rt(rt2x00dev, RT5392))
+	{
+		rt2800_bbp_write(rt2x00dev, 95, 0x9a);
+		rt2800_bbp_write(rt2x00dev, 98, 0x12);
+	}
+
 	if (rt2x00_rt_rev_gte(rt2x00dev, RT3070, REV_RT3070F) ||
 	    rt2x00_rt_rev_gte(rt2x00dev, RT3071, REV_RT3071E) ||
 	    rt2x00_rt_rev_gte(rt2x00dev, RT3090, REV_RT3090E) ||
 	    rt2x00_rt_rev_gte(rt2x00dev, RT3390, REV_RT3390E) ||
 	    rt2x00_rt(rt2x00dev, RT3572) ||
 	    rt2x00_rt(rt2x00dev, RT5390) ||
+	    rt2x00_rt(rt2x00dev, RT5392) ||
 	    rt2800_is_305x_soc(rt2x00dev))
 		rt2800_bbp_write(rt2x00dev, 103, 0xc0);
 	else
 		rt2800_bbp_write(rt2x00dev, 103, 0x00);
 
-	if (rt2x00_rt(rt2x00dev, RT5390))
+	if (rt2x00_rt(rt2x00dev, RT5390) || 
+		rt2x00_rt(rt2x00dev, RT5392))
 		rt2800_bbp_write(rt2x00dev, 104, 0x92);
 
 	if (rt2800_is_305x_soc(rt2x00dev))
 		rt2800_bbp_write(rt2x00dev, 105, 0x01);
-	else if (rt2x00_rt(rt2x00dev, RT5390))
+	else if (rt2x00_rt(rt2x00dev, RT5390) || 
+			 rt2x00_rt(rt2x00dev, RT5392))
 		rt2800_bbp_write(rt2x00dev, 105, 0x3c);
 	else
 		rt2800_bbp_write(rt2x00dev, 105, 0x05);
 
 	if (rt2x00_rt(rt2x00dev, RT5390))
 		rt2800_bbp_write(rt2x00dev, 106, 0x03);
+	else if (rt2x00_rt(rt2x00dev, RT5392))
+		rt2800_bbp_write(rt2x00dev, 106, 0x12);
 	else
 		rt2800_bbp_write(rt2x00dev, 106, 0x35);
 
-	if (rt2x00_rt(rt2x00dev, RT5390))
+	if (rt2x00_rt(rt2x00dev, RT5390) || 
+		rt2x00_rt(rt2x00dev, RT5392))
 		rt2800_bbp_write(rt2x00dev, 128, 0x12);
 
+	if (rt2x00_rt(rt2x00dev, RT5392))
+	{
+		rt2800_bbp_write(rt2x00dev, 134, 0xd0);
+		rt2800_bbp_write(rt2x00dev, 135, 0xf6);
+	}
+
 	if (rt2x00_rt(rt2x00dev, RT3071) ||
 	    rt2x00_rt(rt2x00dev, RT3090) ||
 	    rt2x00_rt(rt2x00dev, RT3390) ||
 	    rt2x00_rt(rt2x00dev, RT3572) ||
-	    rt2x00_rt(rt2x00dev, RT5390)) {
+	    rt2x00_rt(rt2x00dev, RT5390) || 
+	    rt2x00_rt(rt2x00dev, RT5392)) {
 		rt2800_bbp_read(rt2x00dev, 138, &value);
 
 		rt2x00_eeprom_read(rt2x00dev, EEPROM_NIC_CONF0, &eeprom);
@@ -3132,7 +3223,8 @@ static int rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
 		rt2800_bbp_write(rt2x00dev, 138, value);
 	}
 
-	if (rt2x00_rt(rt2x00dev, RT5390)) {
+	if (rt2x00_rt(rt2x00dev, RT5390) || 
+		rt2x00_rt(rt2x00dev, RT5392)) {
 		int ant, div_mode;
 
 		rt2x00_eeprom_read(rt2x00dev, EEPROM_NIC_CONF1, &eeprom);
@@ -3258,13 +3350,15 @@ static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
 	    !rt2x00_rt(rt2x00dev, RT3390) &&
 	    !rt2x00_rt(rt2x00dev, RT3572) &&
 	    !rt2x00_rt(rt2x00dev, RT5390) &&
+	    !rt2x00_rt(rt2x00dev, RT5392) &&
 	    !rt2800_is_305x_soc(rt2x00dev))
 		return 0;
 
 	/*
 	 * Init RF calibration.
 	 */
-	if (rt2x00_rt(rt2x00dev, RT5390)) {
+	if (rt2x00_rt(rt2x00dev, RT5390) || 
+		rt2x00_rt(rt2x00dev, RT5392)) {
 		rt2800_rfcsr_read(rt2x00dev, 2, &rfcsr);
 		rt2x00_set_field8(&rfcsr, RFCSR2_RESCAL_EN, 1);
 		rt2800_rfcsr_write(rt2x00dev, 2, rfcsr);
@@ -3482,7 +3576,68 @@ static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
 			rt2800_rfcsr_write(rt2x00dev, 61, 0xdd);
 		rt2800_rfcsr_write(rt2x00dev, 62, 0x00);
 		rt2800_rfcsr_write(rt2x00dev, 63, 0x00);
-	}
+	}	else if (rt2x00_rt(rt2x00dev, RT5392) || 
+			rt2x00_rt(rt2x00dev, RT5372)) {
+			rt2800_rfcsr_write(rt2x00dev, 1, 0x17);
+			rt2800_rfcsr_write(rt2x00dev, 2, 0x80);
+			rt2800_rfcsr_write(rt2x00dev, 3, 0x88);
+			rt2800_rfcsr_write(rt2x00dev, 5, 0x10);
+			rt2800_rfcsr_write(rt2x00dev, 6, 0xe0);
+			rt2800_rfcsr_write(rt2x00dev, 7, 0x00);
+			rt2800_rfcsr_write(rt2x00dev, 10, 0x53);
+			rt2800_rfcsr_write(rt2x00dev, 11, 0x4a);
+			rt2800_rfcsr_write(rt2x00dev, 12, 0x46);
+			rt2800_rfcsr_write(rt2x00dev, 13, 0x9f);
+			rt2800_rfcsr_write(rt2x00dev, 14, 0x00);
+			rt2800_rfcsr_write(rt2x00dev, 15, 0x00);
+			rt2800_rfcsr_write(rt2x00dev, 16, 0x00);
+			rt2800_rfcsr_write(rt2x00dev, 18, 0x03);
+			rt2800_rfcsr_write(rt2x00dev, 19, 0x4d);
+			rt2800_rfcsr_write(rt2x00dev, 20, 0x00);
+			rt2800_rfcsr_write(rt2x00dev, 21, 0x8d);
+			rt2800_rfcsr_write(rt2x00dev, 22, 0x20);
+			rt2800_rfcsr_write(rt2x00dev, 23, 0x0b);
+			rt2800_rfcsr_write(rt2x00dev, 24, 0x44);
+			rt2800_rfcsr_write(rt2x00dev, 25, 0x80);
+			rt2800_rfcsr_write(rt2x00dev, 26, 0x82);
+			rt2800_rfcsr_write(rt2x00dev, 27, 0x09);
+			rt2800_rfcsr_write(rt2x00dev, 28, 0x00);
+			rt2800_rfcsr_write(rt2x00dev, 29, 0x10);
+			rt2800_rfcsr_write(rt2x00dev, 30, 0x10);
+			rt2800_rfcsr_write(rt2x00dev, 31, 0x80);
+			rt2800_rfcsr_write(rt2x00dev, 32, 0x20);
+			rt2800_rfcsr_write(rt2x00dev, 33, 0xC0);
+			rt2800_rfcsr_write(rt2x00dev, 34, 0x07);
+			rt2800_rfcsr_write(rt2x00dev, 35, 0x12);
+			rt2800_rfcsr_write(rt2x00dev, 36, 0x00);
+			rt2800_rfcsr_write(rt2x00dev, 37, 0x08);
+			rt2800_rfcsr_write(rt2x00dev, 38, 0x89);
+			rt2800_rfcsr_write(rt2x00dev, 39, 0x1b);
+			rt2800_rfcsr_write(rt2x00dev, 40, 0x0f);
+			rt2800_rfcsr_write(rt2x00dev, 41, 0xbb);
+			rt2800_rfcsr_write(rt2x00dev, 42, 0xd5);
+			rt2800_rfcsr_write(rt2x00dev, 43, 0x9b);
+			rt2800_rfcsr_write(rt2x00dev, 44, 0x0e);
+			rt2800_rfcsr_write(rt2x00dev, 45, 0xa2);
+			rt2800_rfcsr_write(rt2x00dev, 46, 0x73);
+			rt2800_rfcsr_write(rt2x00dev, 47, 0x0c);
+			rt2800_rfcsr_write(rt2x00dev, 48, 0x10);
+			rt2800_rfcsr_write(rt2x00dev, 49, 0x94);
+			rt2800_rfcsr_write(rt2x00dev, 50, 0x94);
+			rt2800_rfcsr_write(rt2x00dev, 51, 0x3a);
+			rt2800_rfcsr_write(rt2x00dev, 52, 0x48);
+			rt2800_rfcsr_write(rt2x00dev, 53, 0x44);
+			rt2800_rfcsr_write(rt2x00dev, 54, 0x38);
+			rt2800_rfcsr_write(rt2x00dev, 55, 0x43);
+			rt2800_rfcsr_write(rt2x00dev, 56, 0xa1);
+			rt2800_rfcsr_write(rt2x00dev, 57, 0x00);
+			rt2800_rfcsr_write(rt2x00dev, 58, 0x39);
+			rt2800_rfcsr_write(rt2x00dev, 59, 0x07);
+			rt2800_rfcsr_write(rt2x00dev, 60, 0x45);
+			rt2800_rfcsr_write(rt2x00dev, 61, 0x91);
+			rt2800_rfcsr_write(rt2x00dev, 62, 0x39);
+			rt2800_rfcsr_write(rt2x00dev, 63, 0x07);
+		}
 
 	if (rt2x00_rt_rev_lt(rt2x00dev, RT3070, REV_RT3070F)) {
 		rt2800_register_read(rt2x00dev, LDO_CFG0, &reg);
@@ -3549,7 +3704,8 @@ static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
 			rt2800_init_rx_filter(rt2x00dev, true, 0x27, 0x15);
 	}
 
-	if (!rt2x00_rt(rt2x00dev, RT5390)) {
+	if (!rt2x00_rt(rt2x00dev, RT5390) || 
+		!rt2x00_rt(rt2x00dev, RT5392)) {
 		/*
 		 * Set back to initial state
 		 */
@@ -3577,7 +3733,8 @@ static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
 	rt2x00_set_field32(&reg, OPT_14_CSR_BIT0, 1);
 	rt2800_register_write(rt2x00dev, OPT_14_CSR, reg);
 
-	if (!rt2x00_rt(rt2x00dev, RT5390)) {
+	if (!rt2x00_rt(rt2x00dev, RT5390) || 
+		!rt2x00_rt(rt2x00dev, RT5392)) {
 		rt2800_rfcsr_read(rt2x00dev, 17, &rfcsr);
 		rt2x00_set_field8(&rfcsr, RFCSR17_TX_LO1_EN, 0);
 		if (rt2x00_rt(rt2x00dev, RT3070) ||
@@ -3645,7 +3802,8 @@ static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
 		rt2800_rfcsr_write(rt2x00dev, 27, rfcsr);
 	}
 
-	if (rt2x00_rt(rt2x00dev, RT5390)) {
+	if (rt2x00_rt(rt2x00dev, RT5390) || 
+		rt2x00_rt(rt2x00dev, RT5392)) {
 		rt2800_rfcsr_read(rt2x00dev, 38, &rfcsr);
 		rt2x00_set_field8(&rfcsr, RFCSR38_RX_LO1_EN, 0);
 		rt2800_rfcsr_write(rt2x00dev, 38, rfcsr);
@@ -3929,7 +4087,8 @@ int rt2800_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	 * RT53xx: defined in "EEPROM_CHIP_ID" field
 	 */
 	rt2800_register_read(rt2x00dev, MAC_CSR0, &reg);
-	if (rt2x00_get_field32(reg, MAC_CSR0_CHIPSET) == RT5390)
+	if (rt2x00_get_field32(reg, MAC_CSR0_CHIPSET) == RT5390 || 
+		rt2x00_get_field32(reg, MAC_CSR0_CHIPSET) == RT5392)
 		rt2x00_eeprom_read(rt2x00dev, EEPROM_CHIP_ID, &value);
 	else
 		value = rt2x00_get_field16(eeprom, EEPROM_NIC_CONF0_RF_TYPE);
@@ -3947,9 +4106,11 @@ int rt2800_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	case RT3390:
 	case RT3572:
 	case RT5390:
+	case RT5392:
+	case RT5372:
 		break;
 	default:
-		ERROR(rt2x00dev, "Invalid RT chipset detected.\n");
+		ERROR(rt2x00dev, "Invalid RT chipset 0x%04x detected.\n", rt2x00dev->chip.rt);
 		return -ENODEV;
 	}
 
@@ -3966,9 +4127,10 @@ int rt2800_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	case RF3320:
 	case RF5370:
 	case RF5390:
+	case RF5372:
 		break;
 	default:
-		ERROR(rt2x00dev, "Invalid RF chipset 0x%x detected.\n",
+		ERROR(rt2x00dev, "Invalid RF chipset 0x%04x detected.\n",
 		      rt2x00dev->chip.rf);
 		return -ENODEV;
 	}
@@ -4271,6 +4433,7 @@ int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 		   rt2x00_rf(rt2x00dev, RF3022) ||
 		   rt2x00_rf(rt2x00dev, RF3320) ||
 		   rt2x00_rf(rt2x00dev, RF5370) ||
+		   rt2x00_rf(rt2x00dev, RF5372) ||
 		   rt2x00_rf(rt2x00dev, RF5390)) {
 		spec->num_channels = 14;
 		spec->channels = rf_vals_3x;
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.h b/drivers/net/wireless/rt2x00/rt2800lib.h
index 8c3c281..419e36c 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.h
+++ b/drivers/net/wireless/rt2x00/rt2800lib.h
@@ -184,6 +184,7 @@ void rt2800_reset_tuner(struct rt2x00_dev *rt2x00dev, struct link_qual *qual);
 void rt2800_link_tuner(struct rt2x00_dev *rt2x00dev, struct link_qual *qual,
 		       const u32 count);
 void rt2800_gain_calibration(struct rt2x00_dev *rt2x00dev);
+void rt2800_vco_calibration(struct rt2x00_dev *rt2x00dev);
 
 int rt2800_enable_radio(struct rt2x00_dev *rt2x00dev);
 void rt2800_disable_radio(struct rt2x00_dev *rt2x00dev);
diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index 837b460..2a3fec6 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -480,6 +480,7 @@ static int rt2800pci_init_registers(struct rt2x00_dev *rt2x00dev)
 
 	if (rt2x00_is_pcie(rt2x00dev) &&
 	    (rt2x00_rt(rt2x00dev, RT3572) ||
+	     rt2x00_rt(rt2x00dev, RT5390) || 
 	     rt2x00_rt(rt2x00dev, RT5390))) {
 		rt2x00pci_register_read(rt2x00dev, AUX_CTRL, &reg);
 		rt2x00_set_field32(&reg, AUX_CTRL_FORCE_PCIE_CLK, 1);
@@ -1050,6 +1051,7 @@ static const struct rt2x00lib_ops rt2800pci_rt2x00_ops = {
 	.reset_tuner		= rt2800_reset_tuner,
 	.link_tuner		= rt2800_link_tuner,
 	.gain_calibration	= rt2800_gain_calibration,
+	.vco_calibration	= rt2800_vco_calibration,
 	.start_queue		= rt2800pci_start_queue,
 	.kick_queue		= rt2800pci_kick_queue,
 	.stop_queue		= rt2800pci_stop_queue,
diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 7f21005..f6f1724 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -783,6 +783,7 @@ static const struct rt2x00lib_ops rt2800usb_rt2x00_ops = {
 	.reset_tuner		= rt2800_reset_tuner,
 	.link_tuner		= rt2800_link_tuner,
 	.gain_calibration	= rt2800_gain_calibration,
+	.vco_calibration	= rt2800_vco_calibration,
 	.watchdog		= rt2800usb_watchdog,
 	.start_queue		= rt2800usb_start_queue,
 	.kick_queue		= rt2x00usb_kick_queue,
@@ -1107,6 +1108,20 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	/* Ralink */
 	{ USB_DEVICE(0x148f, 0x5370) },
 	{ USB_DEVICE(0x148f, 0x5372) },
+	/* Alpha */
+	{ USB_DEVICE(0x2001, 0x3c15) },
+	{ USB_DEVICE(0x2001, 0x3c19) },
+	/* Arcadyan */
+	{ USB_DEVICE(0x043e, 0x7a12) },
+	/* LG innotek */
+	{ USB_DEVICE(0x043e, 0x7a22) },
+	/* Panasonic */
+	{ USB_DEVICE(0x04da, 0x1801) },
+	{ USB_DEVICE(0x04da, 0x1800) },
+	/* Unknown */
+	{ USB_DEVICE(0x04da, 0x23f6) },
+	/* Philips */
+	{ USB_DEVICE(0x0471, 0x2104) },
 #endif
 #ifdef CONFIG_RT2800USB_UNKNOWN
 	/*
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index b03b22c..38b2090 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -192,6 +192,8 @@ struct rt2x00_chip {
 #define RT3593		0x3593
 #define RT3883		0x3883	/* WSOC */
 #define RT5390		0x5390  /* 2.4GHz */
+#define RT5392		0x5392  /* 2.4GHz */
+#define RT5372		0x5372  /* 2.4GHz */
 
 	u16 rf;
 	u16 rev;
@@ -355,6 +357,11 @@ struct link {
 	 * Work structure for scheduling periodic AGC adjustments.
 	 */
 	struct delayed_work agc_work;
+
+	/*
+	 * Work structure for scheduling periodic VCO recalibration.
+	 */
+	struct delayed_work vco_work;
 };
 
 enum rt2x00_delayed_flags {
@@ -579,6 +586,7 @@ struct rt2x00lib_ops {
 	void (*link_tuner) (struct rt2x00_dev *rt2x00dev,
 			    struct link_qual *qual, const u32 count);
 	void (*gain_calibration) (struct rt2x00_dev *rt2x00dev);
+	void (*vco_calibration) (struct rt2x00_dev *rt2x00dev);
 
 	/*
 	 * Data queue handlers.
@@ -979,6 +987,11 @@ struct rt2x00_dev {
 	struct tasklet_struct autowake_tasklet;
 
 	/*
+	 * Used for VCO recalibration.
+	 */
+	int rf_channel;
+
+	/*
 	 * Protect the interrupt mask register.
 	 */
 	spinlock_t irqmask_lock;
diff --git a/drivers/net/wireless/rt2x00/rt2x00config.c b/drivers/net/wireless/rt2x00/rt2x00config.c
index b704e5b..f64b55a 100644
--- a/drivers/net/wireless/rt2x00/rt2x00config.c
+++ b/drivers/net/wireless/rt2x00/rt2x00config.c
@@ -232,6 +232,9 @@ void rt2x00lib_config(struct rt2x00_dev *rt2x00dev,
 		memcpy(&libconf.channel,
 		       &rt2x00dev->spec.channels_info[hw_value],
 		       sizeof(libconf.channel));
+		
+ 		/* Used for VCO recalibration */
+		rt2x00dev->rf_channel = libconf.rf.channel;
 	}
 
 	if (test_bit(REQUIRE_PS_AUTOWAKE, &rt2x00dev->cap_flags) &&
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index c3e1aa7..f78266e 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -88,6 +88,7 @@ int rt2x00lib_enable_radio(struct rt2x00_dev *rt2x00dev)
 	rt2x00queue_start_queues(rt2x00dev);
 	rt2x00link_start_tuner(rt2x00dev);
 	rt2x00link_start_agc(rt2x00dev);
+	rt2x00link_start_vcocal(rt2x00dev);
 
 	/*
 	 * Start watchdog monitoring.
@@ -111,6 +112,7 @@ void rt2x00lib_disable_radio(struct rt2x00_dev *rt2x00dev)
 	 * Stop all queues
 	 */
 	rt2x00link_stop_agc(rt2x00dev);
+	rt2x00link_stop_vcocal(rt2x00dev);
 	rt2x00link_stop_tuner(rt2x00dev);
 	rt2x00queue_stop_queues(rt2x00dev);
 	rt2x00queue_flush_queues(rt2x00dev, true);
diff --git a/drivers/net/wireless/rt2x00/rt2x00lib.h b/drivers/net/wireless/rt2x00/rt2x00lib.h
index 4cdf247..78bd43b 100644
--- a/drivers/net/wireless/rt2x00/rt2x00lib.h
+++ b/drivers/net/wireless/rt2x00/rt2x00lib.h
@@ -33,6 +33,7 @@
 #define WATCHDOG_INTERVAL	round_jiffies_relative(HZ)
 #define LINK_TUNE_INTERVAL	round_jiffies_relative(HZ)
 #define AGC_INTERVAL		round_jiffies_relative(4 * HZ)
+#define VCO_INTERVAL		round_jiffies_relative(10 * HZ) /* 10 sec */
 
 /*
  * rt2x00_rate: Per rate device information
@@ -278,12 +279,24 @@ void rt2x00link_stop_watchdog(struct rt2x00_dev *rt2x00dev);
 void rt2x00link_start_agc(struct rt2x00_dev *rt2x00dev);
 
 /**
+ * rt2x00link_start_vcocal - Start periodic VCO calibration
+ * @rt2x00dev: Pointer to &struct rt2x00_dev.
+ */
+void rt2x00link_start_vcocal(struct rt2x00_dev *rt2x00dev);
+
+/**
  * rt2x00link_stop_agc - Stop periodic gain calibration
  * @rt2x00dev: Pointer to &struct rt2x00_dev.
  */
 void rt2x00link_stop_agc(struct rt2x00_dev *rt2x00dev);
 
 /**
+ * rt2x00link_stop_vcocal - Stop periodic VCO calibration
+ * @rt2x00dev: Pointer to &struct rt2x00_dev.
+ */
+void rt2x00link_stop_vcocal(struct rt2x00_dev *rt2x00dev);
+
+/**
  * rt2x00link_register - Initialize link tuning & watchdog functionality
  * @rt2x00dev: Pointer to &struct rt2x00_dev.
  *
diff --git a/drivers/net/wireless/rt2x00/rt2x00link.c b/drivers/net/wireless/rt2x00/rt2x00link.c
index ea10b00..f6f4267 100644
--- a/drivers/net/wireless/rt2x00/rt2x00link.c
+++ b/drivers/net/wireless/rt2x00/rt2x00link.c
@@ -447,11 +447,27 @@ void rt2x00link_start_agc(struct rt2x00_dev *rt2x00dev)
 					     AGC_INTERVAL);
 }
 
+void rt2x00link_start_vcocal(struct rt2x00_dev *rt2x00dev)
+{
+	struct link *link = &rt2x00dev->link;
+
+	if (test_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags) &&
+	    rt2x00dev->ops->lib->vco_calibration)
+		ieee80211_queue_delayed_work(rt2x00dev->hw,
+					     &link->vco_work,
+					     VCO_INTERVAL);
+}
+
 void rt2x00link_stop_agc(struct rt2x00_dev *rt2x00dev)
 {
 	cancel_delayed_work_sync(&rt2x00dev->link.agc_work);
 }
 
+void rt2x00link_stop_vcocal(struct rt2x00_dev *rt2x00dev)
+{
+	cancel_delayed_work_sync(&rt2x00dev->link.vco_work);
+}
+
 static void rt2x00link_agc(struct work_struct *work)
 {
 	struct rt2x00_dev *rt2x00dev =
@@ -473,9 +489,31 @@ static void rt2x00link_agc(struct work_struct *work)
 					     AGC_INTERVAL);
 }
 
+static void rt2x00link_vcocal(struct work_struct *work)
+{
+	struct rt2x00_dev *rt2x00dev =
+	    container_of(work, struct rt2x00_dev, link.vco_work.work);
+	struct link *link = &rt2x00dev->link;
+
+	/*
+	 * When the radio is shutting down we should
+	 * immediately cease the watchdog monitoring.
+	 */
+	if (!test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags))
+		return;
+
+	rt2x00dev->ops->lib->vco_calibration(rt2x00dev);
+
+	if (test_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags))
+		ieee80211_queue_delayed_work(rt2x00dev->hw,
+					     &link->vco_work,
+					     VCO_INTERVAL);
+}
+
 void rt2x00link_register(struct rt2x00_dev *rt2x00dev)
 {
 	INIT_DELAYED_WORK(&rt2x00dev->link.agc_work, rt2x00link_agc);
+	INIT_DELAYED_WORK(&rt2x00dev->link.vco_work, rt2x00link_vcocal);
 	INIT_DELAYED_WORK(&rt2x00dev->link.watchdog_work, rt2x00link_watchdog);
 	INIT_DELAYED_WORK(&rt2x00dev->link.work, rt2x00link_tuner);
 }
-- 
1.7.5.1

