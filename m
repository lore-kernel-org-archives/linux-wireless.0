Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.8]:17787 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755759Ab3ERMDW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 May 2013 08:03:22 -0400
Received: from ip-94-112-188-135.net.upcbroadband.cz (HELO localhost) (stf_xl@wp.pl@[94.112.188.135])
          (envelope-sender <stf_xl@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with AES128-SHA encrypted SMTP
          for <linux-wireless@vger.kernel.org>; 18 May 2013 14:03:20 +0200
From: stf_xl@wp.pl
To: linux-wireless@vger.kernel.org
Cc: users@rt2x00.serialmonkey.com, Stanislaw Gruszka <stf_xl@wp.pl>
Subject: [PATCH 32/32] rt2800: move 53xx specific bbp initialization
Date: Sat, 18 May 2013 14:03:55 +0200
Message-Id: <1368878635-4455-33-git-send-email-stf_xl@wp.pl> (sfid-20130518_142938_322402_6D424B0B)
In-Reply-To: <1368878635-4455-1-git-send-email-stf_xl@wp.pl>
References: <1368878635-4455-1-git-send-email-stf_xl@wp.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Stanislaw Gruszka <stf_xl@wp.pl>

Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
Acked-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |   83 +++++++++++++++----------------
 1 files changed, 41 insertions(+), 42 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 1e58180..fc43c7d 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -4304,6 +4304,10 @@ static void rt2800_init_bbp_3572(struct rt2x00_dev *rt2x00dev)
 
 static void rt2800_init_bbp_53xx(struct rt2x00_dev *rt2x00dev)
 {
+	int ant, div_mode;
+	u16 eeprom;
+	u8 value;
+
 	rt2800_bbp4_mac_if_ctrl(rt2x00dev);
 
 	rt2800_bbp_write(rt2x00dev, 31, 0x08);
@@ -4367,6 +4371,43 @@ static void rt2800_init_bbp_53xx(struct rt2x00_dev *rt2x00dev)
 	}
 
 	rt2800_disable_unused_dac_adc(rt2x00dev);
+
+	rt2x00_eeprom_read(rt2x00dev, EEPROM_NIC_CONF1, &eeprom);
+	div_mode = rt2x00_get_field16(eeprom,
+				      EEPROM_NIC_CONF1_ANT_DIVERSITY);
+	ant = (div_mode == 3) ? 1 : 0;
+
+	/* check if this is a Bluetooth combo card */
+	if (test_bit(CAPABILITY_BT_COEXIST, &rt2x00dev->cap_flags)) {
+		u32 reg;
+
+		rt2800_register_read(rt2x00dev, GPIO_CTRL, &reg);
+		rt2x00_set_field32(&reg, GPIO_CTRL_DIR3, 0);
+		rt2x00_set_field32(&reg, GPIO_CTRL_DIR6, 0);
+		rt2x00_set_field32(&reg, GPIO_CTRL_VAL3, 0);
+		rt2x00_set_field32(&reg, GPIO_CTRL_VAL6, 0);
+		if (ant == 0)
+			rt2x00_set_field32(&reg, GPIO_CTRL_VAL3, 1);
+		else if (ant == 1)
+			rt2x00_set_field32(&reg, GPIO_CTRL_VAL6, 1);
+		rt2800_register_write(rt2x00dev, GPIO_CTRL, reg);
+	}
+
+	/* This chip has hardware antenna diversity*/
+	if (rt2x00_rt_rev_gte(rt2x00dev, RT5390, REV_RT5390R)) {
+		rt2800_bbp_write(rt2x00dev, 150, 0); /* Disable Antenna Software OFDM */
+		rt2800_bbp_write(rt2x00dev, 151, 0); /* Disable Antenna Software CCK */
+		rt2800_bbp_write(rt2x00dev, 154, 0); /* Clear previously selected antenna */
+	}
+
+	rt2800_bbp_read(rt2x00dev, 152, &value);
+	if (ant == 0)
+		rt2x00_set_field8(&value, BBP152_RX_DEFAULT_ANT, 1);
+	else
+		rt2x00_set_field8(&value, BBP152_RX_DEFAULT_ANT, 0);
+	rt2800_bbp_write(rt2x00dev, 152, value);
+
+	rt2800_init_freq_calibration(rt2x00dev);
 }
 
 static void rt2800_init_bbp_5592(struct rt2x00_dev *rt2x00dev)
@@ -4485,48 +4526,6 @@ static void rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
 		return;
 	}
 
-	if (rt2x00_rt(rt2x00dev, RT5390) ||
-	    rt2x00_rt(rt2x00dev, RT5392)) {
-		int ant, div_mode;
-
-		rt2x00_eeprom_read(rt2x00dev, EEPROM_NIC_CONF1, &eeprom);
-		div_mode = rt2x00_get_field16(eeprom,
-					      EEPROM_NIC_CONF1_ANT_DIVERSITY);
-		ant = (div_mode == 3) ? 1 : 0;
-
-		/* check if this is a Bluetooth combo card */
-		if (test_bit(CAPABILITY_BT_COEXIST, &rt2x00dev->cap_flags)) {
-			u32 reg;
-
-			rt2800_register_read(rt2x00dev, GPIO_CTRL, &reg);
-			rt2x00_set_field32(&reg, GPIO_CTRL_DIR3, 0);
-			rt2x00_set_field32(&reg, GPIO_CTRL_DIR6, 0);
-			rt2x00_set_field32(&reg, GPIO_CTRL_VAL3, 0);
-			rt2x00_set_field32(&reg, GPIO_CTRL_VAL6, 0);
-			if (ant == 0)
-				rt2x00_set_field32(&reg, GPIO_CTRL_VAL3, 1);
-			else if (ant == 1)
-				rt2x00_set_field32(&reg, GPIO_CTRL_VAL6, 1);
-			rt2800_register_write(rt2x00dev, GPIO_CTRL, reg);
-		}
-
-		/* This chip has hardware antenna diversity*/
-		if (rt2x00_rt_rev_gte(rt2x00dev, RT5390, REV_RT5390R)) {
-			rt2800_bbp_write(rt2x00dev, 150, 0); /* Disable Antenna Software OFDM */
-			rt2800_bbp_write(rt2x00dev, 151, 0); /* Disable Antenna Software CCK */
-			rt2800_bbp_write(rt2x00dev, 154, 0); /* Clear previously selected antenna */
-		}
-
-		rt2800_bbp_read(rt2x00dev, 152, &value);
-		if (ant == 0)
-			rt2x00_set_field8(&value, BBP152_RX_DEFAULT_ANT, 1);
-		else
-			rt2x00_set_field8(&value, BBP152_RX_DEFAULT_ANT, 0);
-		rt2800_bbp_write(rt2x00dev, 152, value);
-
-		rt2800_init_freq_calibration(rt2x00dev);
-	}
-
 	for (i = 0; i < EEPROM_BBP_SIZE; i++) {
 		rt2x00_eeprom_read(rt2x00dev, EEPROM_BBP_START + i, &eeprom);
 
-- 
1.7.4.4

