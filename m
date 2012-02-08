Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:40229 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107Ab2BHGDk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Feb 2012 01:03:40 -0500
Received: by pbcun15 with SMTP id un15so281553pbc.19
        for <linux-wireless@vger.kernel.org>; Tue, 07 Feb 2012 22:03:40 -0800 (PST)
From: John Li <john.li.mediatek@gmail.com>
To: users@rt2x00.serialmonkey.com
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	John Li <chen-yang.li@mediatek.com>
Subject: [PATCH] rt2x00:Add RT5372 chipset support
Date: Wed,  8 Feb 2012 14:02:49 +0800
Message-Id: <1328680969-5646-1-git-send-email-john.li.mediatek@gmail.com> (sfid-20120208_070409_220985_112FD97E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: John Li <chen-yang.li@mediatek.com>

---
 drivers/net/wireless/rt2x00/rt2800.h    |    1 +
 drivers/net/wireless/rt2x00/rt2800lib.c |  157 ++++++++++++++++++++++++++-----
 drivers/net/wireless/rt2x00/rt2800pci.c |    3 +-
 drivers/net/wireless/rt2x00/rt2800usb.c |   14 +++
 drivers/net/wireless/rt2x00/rt2x00.h    |    2 +
 5 files changed, 152 insertions(+), 25 deletions(-)

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
index 22a1a8f..852b57e 100644
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
@@ -2502,7 +2506,8 @@ static u8 rt2800_get_default_vgc(struct rt2x00_dev *rt2x00dev)
 		    rt2x00_rt(rt2x00dev, RT3071) ||
 		    rt2x00_rt(rt2x00dev, RT3090) ||
 		    rt2x00_rt(rt2x00dev, RT3390) ||
-		    rt2x00_rt(rt2x00dev, RT5390))
+		    rt2x00_rt(rt2x00dev, RT5390) ||
+		    rt2x00_rt(rt2x00dev, RT5392))
 			return 0x1c + (2 * rt2x00dev->lna_gain);
 		else
 			return 0x2e + rt2x00dev->lna_gain;
@@ -2637,7 +2642,8 @@ static int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
 	} else if (rt2x00_rt(rt2x00dev, RT3572)) {
 		rt2800_register_write(rt2x00dev, TX_SW_CFG0, 0x00000400);
 		rt2800_register_write(rt2x00dev, TX_SW_CFG1, 0x00080606);
-	} else if (rt2x00_rt(rt2x00dev, RT5390)) {
+	} else if (rt2x00_rt(rt2x00dev, RT5390) || 
+			   rt2x00_rt(rt2x00dev, RT5392)) {
 		rt2800_register_write(rt2x00dev, TX_SW_CFG0, 0x00000404);
 		rt2800_register_write(rt2x00dev, TX_SW_CFG1, 0x00080606);
 		rt2800_register_write(rt2x00dev, TX_SW_CFG2, 0x00000000);
@@ -3013,7 +3019,8 @@ static int rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
 		     rt2800_wait_bbp_ready(rt2x00dev)))
 		return -EACCES;
 
-	if (rt2x00_rt(rt2x00dev, RT5390)) {
+	if (rt2x00_rt(rt2x00dev, RT5390) || 
+		rt2x00_rt(rt2x00dev, RT5392)) {
 		rt2800_bbp_read(rt2x00dev, 4, &value);
 		rt2x00_set_field8(&value, BBP4_MAC_IF_CTRL, 1);
 		rt2800_bbp_write(rt2x00dev, 4, value);
@@ -3021,19 +3028,22 @@ static int rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
 
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
@@ -3051,7 +3061,8 @@ static int rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
 	    rt2x00_rt(rt2x00dev, RT3090) ||
 	    rt2x00_rt(rt2x00dev, RT3390) ||
 	    rt2x00_rt(rt2x00dev, RT3572) ||
-	    rt2x00_rt(rt2x00dev, RT5390)) {
+	    rt2x00_rt(rt2x00dev, RT5390) ||
+	    rt2x00_rt(rt2x00dev, RT5392)) {
 		rt2800_bbp_write(rt2x00dev, 79, 0x13);
 		rt2800_bbp_write(rt2x00dev, 80, 0x05);
 		rt2800_bbp_write(rt2x00dev, 81, 0x33);
@@ -3063,64 +3074,90 @@ static int rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
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
+		rt2x00_rt(rt2x00dev, RT5392))
 		rt2800_bbp_write(rt2x00dev, 86, 0x38);
 	else
 		rt2800_bbp_write(rt2x00dev, 86, 0x00);
 
+	if (rt2x00_rt(rt2x00dev, RT5392))
+		rt2800_bbp_write(rt2x00dev, 88, 0x90);
+
 	rt2800_bbp_write(rt2x00dev, 91, 0x04);
 
-	if (rt2x00_rt(rt2x00dev, RT5390))
+	if (rt2x00_rt(rt2x00dev, RT5390) || 
+		rt2x00_rt(rt2x00dev, RT5392))
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
@@ -3132,7 +3169,8 @@ static int rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
 		rt2800_bbp_write(rt2x00dev, 138, value);
 	}
 
-	if (rt2x00_rt(rt2x00dev, RT5390)) {
+	if (rt2x00_rt(rt2x00dev, RT5390) || 
+		rt2x00_rt(rt2x00dev, RT5392)) {
 		int ant, div_mode;
 
 		rt2x00_eeprom_read(rt2x00dev, EEPROM_NIC_CONF1, &eeprom);
@@ -3258,13 +3296,15 @@ static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
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
@@ -3482,6 +3522,67 @@ static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
 			rt2800_rfcsr_write(rt2x00dev, 61, 0xdd);
 		rt2800_rfcsr_write(rt2x00dev, 62, 0x00);
 		rt2800_rfcsr_write(rt2x00dev, 63, 0x00);
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
 	}
 
 	if (rt2x00_rt_rev_lt(rt2x00dev, RT3070, REV_RT3070F)) {
@@ -3549,7 +3650,8 @@ static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
 			rt2800_init_rx_filter(rt2x00dev, true, 0x27, 0x15);
 	}
 
-	if (!rt2x00_rt(rt2x00dev, RT5390)) {
+	if (!rt2x00_rt(rt2x00dev, RT5390) || 
+		!rt2x00_rt(rt2x00dev, RT5392)) {
 		/*
 		 * Set back to initial state
 		 */
@@ -3577,7 +3679,8 @@ static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
 	rt2x00_set_field32(&reg, OPT_14_CSR_BIT0, 1);
 	rt2800_register_write(rt2x00dev, OPT_14_CSR, reg);
 
-	if (!rt2x00_rt(rt2x00dev, RT5390)) {
+	if (!rt2x00_rt(rt2x00dev, RT5390) || 
+		!rt2x00_rt(rt2x00dev, RT5392)) {
 		rt2800_rfcsr_read(rt2x00dev, 17, &rfcsr);
 		rt2x00_set_field8(&rfcsr, RFCSR17_TX_LO1_EN, 0);
 		if (rt2x00_rt(rt2x00dev, RT3070) ||
@@ -3645,7 +3748,8 @@ static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
 		rt2800_rfcsr_write(rt2x00dev, 27, rfcsr);
 	}
 
-	if (rt2x00_rt(rt2x00dev, RT5390)) {
+	if (rt2x00_rt(rt2x00dev, RT5390) || 
+		rt2x00_rt(rt2x00dev, RT5392)) {
 		rt2800_rfcsr_read(rt2x00dev, 38, &rfcsr);
 		rt2x00_set_field8(&rfcsr, RFCSR38_RX_LO1_EN, 0);
 		rt2800_rfcsr_write(rt2x00dev, 38, rfcsr);
@@ -3929,7 +4033,8 @@ int rt2800_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	 * RT53xx: defined in "EEPROM_CHIP_ID" field
 	 */
 	rt2800_register_read(rt2x00dev, MAC_CSR0, &reg);
-	if (rt2x00_get_field32(reg, MAC_CSR0_CHIPSET) == RT5390)
+	if (rt2x00_get_field32(reg, MAC_CSR0_CHIPSET) == RT5390 || 
+		rt2x00_get_field32(reg, MAC_CSR0_CHIPSET) == RT5392)
 		rt2x00_eeprom_read(rt2x00dev, EEPROM_CHIP_ID, &value);
 	else
 		value = rt2x00_get_field16(eeprom, EEPROM_NIC_CONF0_RF_TYPE);
@@ -3947,6 +4052,8 @@ int rt2800_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	case RT3390:
 	case RT3572:
 	case RT5390:
+	case RT5392:
+	case RT5372:
 		break;
 	default:
 		ERROR(rt2x00dev, "Invalid RT chipset detected.\n");
@@ -3966,6 +4073,7 @@ int rt2800_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	case RF3320:
 	case RF5370:
 	case RF5390:
+	case RF5372:
 		break;
 	default:
 		ERROR(rt2x00dev, "Invalid RF chipset 0x%x detected.\n",
@@ -4271,6 +4379,7 @@ int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 		   rt2x00_rf(rt2x00dev, RF3022) ||
 		   rt2x00_rf(rt2x00dev, RF3320) ||
 		   rt2x00_rf(rt2x00dev, RF5370) ||
+		   rt2x00_rf(rt2x00dev, RF5372) ||
 		   rt2x00_rf(rt2x00dev, RF5390)) {
 		spec->num_channels = 14;
 		spec->channels = rf_vals_3x;
diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index 837b460..a3aa2b0 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -480,7 +480,8 @@ static int rt2800pci_init_registers(struct rt2x00_dev *rt2x00dev)
 
 	if (rt2x00_is_pcie(rt2x00dev) &&
 	    (rt2x00_rt(rt2x00dev, RT3572) ||
-	     rt2x00_rt(rt2x00dev, RT5390))) {
+	     rt2x00_rt(rt2x00dev, RT5390) || 
+	     rt2x00_rt(rt2x00dev, RT5392))) {
 		rt2x00pci_register_read(rt2x00dev, AUX_CTRL, &reg);
 		rt2x00_set_field32(&reg, AUX_CTRL_FORCE_PCIE_CLK, 1);
 		rt2x00_set_field32(&reg, AUX_CTRL_WAKE_PCIE_EN, 1);
diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 7f21005..c8619eb 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -1107,6 +1107,20 @@ static struct usb_device_id rt2800usb_device_table[] = {
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
index b03b22c..7bc5cee 100644
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
-- 
1.7.6.5

