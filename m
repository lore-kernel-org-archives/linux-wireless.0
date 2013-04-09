Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.8]:55392 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765454Ab3DIPEt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Apr 2013 11:04:49 -0400
From: stf_xl@wp.pl
To: "John W. Linville\"" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Stanislaw Gruszka <stf_xl@wp.pl>
Subject: [PATCH 04/11] rt2800: move 30xx common rf init code
Date: Tue,  9 Apr 2013 17:05:23 +0200
Message-Id: <1365519930-3230-5-git-send-email-stf_xl@wp.pl> (sfid-20130409_170455_871792_8004687D)
In-Reply-To: <1365519930-3230-1-git-send-email-stf_xl@wp.pl>
References: <1365519930-3230-1-git-send-email-stf_xl@wp.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Stanislaw Gruszka <stf_xl@wp.pl>

Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |   62 ++++++++++++++++--------------
 1 files changed, 33 insertions(+), 29 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 085b60c..216ceb6 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -4476,6 +4476,8 @@ static void rt2800_init_rfcsr_305x_soc(struct rt2x00_dev *rt2x00dev)
 static void rt2800_init_rfcsr_30xx(struct rt2x00_dev *rt2x00dev)
 {
 	u8 rfcsr;
+	u16 eeprom;
+	u32 reg;
 
 	/*
 	 * Init RF calibration.
@@ -4507,6 +4509,36 @@ static void rt2800_init_rfcsr_30xx(struct rt2x00_dev *rt2x00dev)
 	rt2800_rfcsr_write(rt2x00dev, 24, 0x16);
 	rt2800_rfcsr_write(rt2x00dev, 25, 0x01);
 	rt2800_rfcsr_write(rt2x00dev, 29, 0x1f);
+
+	if (rt2x00_rt_rev_lt(rt2x00dev, RT3070, REV_RT3070F)) {
+		rt2800_register_read(rt2x00dev, LDO_CFG0, &reg);
+		rt2x00_set_field32(&reg, LDO_CFG0_BGSEL, 1);
+		rt2x00_set_field32(&reg, LDO_CFG0_LDO_CORE_VLEVEL, 3);
+		rt2800_register_write(rt2x00dev, LDO_CFG0, reg);
+	} else if (rt2x00_rt(rt2x00dev, RT3071) ||
+		   rt2x00_rt(rt2x00dev, RT3090)) {
+		rt2800_rfcsr_write(rt2x00dev, 31, 0x14);
+
+		rt2800_rfcsr_read(rt2x00dev, 6, &rfcsr);
+		rt2x00_set_field8(&rfcsr, RFCSR6_R2, 1);
+		rt2800_rfcsr_write(rt2x00dev, 6, rfcsr);
+
+		rt2800_register_read(rt2x00dev, LDO_CFG0, &reg);
+		rt2x00_set_field32(&reg, LDO_CFG0_BGSEL, 1);
+		if (rt2x00_rt_rev_lt(rt2x00dev, RT3071, REV_RT3071E) ||
+		    rt2x00_rt_rev_lt(rt2x00dev, RT3090, REV_RT3090E)) {
+			rt2x00_eeprom_read(rt2x00dev, EEPROM_NIC_CONF1, &eeprom);
+			if (rt2x00_get_field16(eeprom, EEPROM_NIC_CONF1_DAC_TEST))
+				rt2x00_set_field32(&reg, LDO_CFG0_LDO_CORE_VLEVEL, 3);
+			else
+				rt2x00_set_field32(&reg, LDO_CFG0_LDO_CORE_VLEVEL, 0);
+		}
+		rt2800_register_write(rt2x00dev, LDO_CFG0, reg);
+
+		rt2800_register_read(rt2x00dev, GPIO_SWITCH, &reg);
+		rt2x00_set_field32(&reg, GPIO_SWITCH_5, 0);
+		rt2800_register_write(rt2x00dev, GPIO_SWITCH, reg);
+	}
 }
 
 static void rt2800_init_rfcsr_3290(struct rt2x00_dev *rt2x00dev)
@@ -4903,7 +4935,6 @@ static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
 	u8 rfcsr;
 	u8 bbp;
 	u32 reg;
-	u16 eeprom;
 
 	if (!rt2x00_rt(rt2x00dev, RT3070) &&
 	    !rt2x00_rt(rt2x00dev, RT3071) &&
@@ -4953,35 +4984,8 @@ static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
 		return 0;
 	}
 
-	if (rt2x00_rt_rev_lt(rt2x00dev, RT3070, REV_RT3070F)) {
-		rt2800_register_read(rt2x00dev, LDO_CFG0, &reg);
-		rt2x00_set_field32(&reg, LDO_CFG0_BGSEL, 1);
-		rt2x00_set_field32(&reg, LDO_CFG0_LDO_CORE_VLEVEL, 3);
-		rt2800_register_write(rt2x00dev, LDO_CFG0, reg);
-	} else if (rt2x00_rt(rt2x00dev, RT3071) ||
-		   rt2x00_rt(rt2x00dev, RT3090)) {
-		rt2800_rfcsr_write(rt2x00dev, 31, 0x14);
-
-		rt2800_rfcsr_read(rt2x00dev, 6, &rfcsr);
-		rt2x00_set_field8(&rfcsr, RFCSR6_R2, 1);
-		rt2800_rfcsr_write(rt2x00dev, 6, rfcsr);
-
-		rt2800_register_read(rt2x00dev, LDO_CFG0, &reg);
-		rt2x00_set_field32(&reg, LDO_CFG0_BGSEL, 1);
-		if (rt2x00_rt_rev_lt(rt2x00dev, RT3071, REV_RT3071E) ||
-		    rt2x00_rt_rev_lt(rt2x00dev, RT3090, REV_RT3090E)) {
-			rt2x00_eeprom_read(rt2x00dev, EEPROM_NIC_CONF1, &eeprom);
-			if (rt2x00_get_field16(eeprom, EEPROM_NIC_CONF1_DAC_TEST))
-				rt2x00_set_field32(&reg, LDO_CFG0_LDO_CORE_VLEVEL, 3);
-			else
-				rt2x00_set_field32(&reg, LDO_CFG0_LDO_CORE_VLEVEL, 0);
-		}
-		rt2800_register_write(rt2x00dev, LDO_CFG0, reg);
 
-		rt2800_register_read(rt2x00dev, GPIO_SWITCH, &reg);
-		rt2x00_set_field32(&reg, GPIO_SWITCH_5, 0);
-		rt2800_register_write(rt2x00dev, GPIO_SWITCH, reg);
-	} else if (rt2x00_rt(rt2x00dev, RT3390)) {
+	if (rt2x00_rt(rt2x00dev, RT3390)) {
 		rt2800_register_read(rt2x00dev, GPIO_SWITCH, &reg);
 		rt2x00_set_field32(&reg, GPIO_SWITCH_5, 0);
 		rt2800_register_write(rt2x00dev, GPIO_SWITCH, reg);
-- 
1.7.4.4

