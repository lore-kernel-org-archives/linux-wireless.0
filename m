Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55040 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752994Ab1AJK24 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Jan 2011 05:28:56 -0500
Received: by mail-fx0-f46.google.com with SMTP id 20so18677090fxm.19
        for <linux-wireless@vger.kernel.org>; Mon, 10 Jan 2011 02:28:55 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 2/2] rt2x00: Fix and fine-tune rf registers for RT3070/RT3071/RT3090
Date: Mon, 10 Jan 2011 11:28:10 +0100
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201101101127.45155.IvDoorn@gmail.com>
In-Reply-To: <201101101127.45155.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201101101128.11757.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: RA-Jay Hung <jay_hung@ralinktech.com>

Basically fix and fine-tune RT3070/RT3071/RT3090 chip RF initial value
when call rt2800_init_rfcsr

Signed-off-by: RA-Jay Hung <jay_hung@ralinktech.com>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800.h    |    6 ++++++
 drivers/net/wireless/rt2x00/rt2800lib.c |   25 +++++++++++++++++--------
 2 files changed, 23 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
index 4c55e85..c7e615c 100644
--- a/drivers/net/wireless/rt2x00/rt2800.h
+++ b/drivers/net/wireless/rt2x00/rt2800.h
@@ -1805,6 +1805,12 @@ struct mac_iveiv_entry {
 #define RFCSR30_RF_CALIBRATION		FIELD8(0x80)
 
 /*
+ * RFCSR 31:
+ */
+#define RFCSR31_RX_AGC_FC		FIELD8(0x1f)
+#define RFCSR31_RX_H20M			FIELD8(0x20)
+
+/*
  * RF registers
  */
 
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index e2a528d..a25be62 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -2436,6 +2436,10 @@ static u8 rt2800_init_rx_filter(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field8(&bbp, BBP4_BANDWIDTH, 2 * bw40);
 	rt2800_bbp_write(rt2x00dev, 4, bbp);
 
+	rt2800_rfcsr_read(rt2x00dev, 31, &rfcsr);
+	rt2x00_set_field8(&rfcsr, RFCSR31_RX_H20M, bw40);
+	rt2800_rfcsr_write(rt2x00dev, 31, rfcsr);
+
 	rt2800_rfcsr_read(rt2x00dev, 22, &rfcsr);
 	rt2x00_set_field8(&rfcsr, RFCSR22_BASEBAND_LOOPBACK, 1);
 	rt2800_rfcsr_write(rt2x00dev, 22, rfcsr);
@@ -2510,7 +2514,7 @@ static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
 		rt2800_rfcsr_write(rt2x00dev, 4, 0x40);
 		rt2800_rfcsr_write(rt2x00dev, 5, 0x03);
 		rt2800_rfcsr_write(rt2x00dev, 6, 0x02);
-		rt2800_rfcsr_write(rt2x00dev, 7, 0x70);
+		rt2800_rfcsr_write(rt2x00dev, 7, 0x60);
 		rt2800_rfcsr_write(rt2x00dev, 9, 0x0f);
 		rt2800_rfcsr_write(rt2x00dev, 10, 0x41);
 		rt2800_rfcsr_write(rt2x00dev, 11, 0x21);
@@ -2602,12 +2606,12 @@ static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
 		rt2800_register_write(rt2x00dev, LDO_CFG0, reg);
 	} else if (rt2x00_rt(rt2x00dev, RT3071) ||
 		   rt2x00_rt(rt2x00dev, RT3090)) {
+		rt2800_rfcsr_write(rt2x00dev, 31, 0x14);
+
 		rt2800_rfcsr_read(rt2x00dev, 6, &rfcsr);
 		rt2x00_set_field8(&rfcsr, RFCSR6_R2, 1);
 		rt2800_rfcsr_write(rt2x00dev, 6, rfcsr);
 
-		rt2800_rfcsr_write(rt2x00dev, 31, 0x14);
-
 		rt2800_register_read(rt2x00dev, LDO_CFG0, &reg);
 		rt2x00_set_field32(&reg, LDO_CFG0_BGSEL, 1);
 		if (rt2x00_rt_rev_lt(rt2x00dev, RT3071, REV_RT3071E) ||
@@ -2619,6 +2623,10 @@ static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
 				rt2x00_set_field32(&reg, LDO_CFG0_LDO_CORE_VLEVEL, 0);
 		}
 		rt2800_register_write(rt2x00dev, LDO_CFG0, reg);
+
+		rt2800_register_read(rt2x00dev, GPIO_SWITCH, &reg);
+		rt2x00_set_field32(&reg, GPIO_SWITCH_5, 0);
+		rt2800_register_write(rt2x00dev, GPIO_SWITCH, reg);
 	} else if (rt2x00_rt(rt2x00dev, RT3390)) {
 		rt2800_register_read(rt2x00dev, GPIO_SWITCH, &reg);
 		rt2x00_set_field32(&reg, GPIO_SWITCH_5, 0);
@@ -2670,10 +2678,11 @@ static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
 
 	rt2800_rfcsr_read(rt2x00dev, 17, &rfcsr);
 	rt2x00_set_field8(&rfcsr, RFCSR17_TX_LO1_EN, 0);
-	if (rt2x00_rt_rev_lt(rt2x00dev, RT3071, REV_RT3071E) ||
+	if (rt2x00_rt(rt2x00dev, RT3070) ||
+	    rt2x00_rt_rev_lt(rt2x00dev, RT3071, REV_RT3071E) ||
 	    rt2x00_rt_rev_lt(rt2x00dev, RT3090, REV_RT3090E) ||
 	    rt2x00_rt_rev_lt(rt2x00dev, RT3390, REV_RT3390E)) {
-		if (test_bit(CONFIG_EXTERNAL_LNA_BG, &rt2x00dev->flags))
+		if (!test_bit(CONFIG_EXTERNAL_LNA_BG, &rt2x00dev->flags))
 			rt2x00_set_field8(&rfcsr, RFCSR17_R, 1);
 	}
 	rt2x00_eeprom_read(rt2x00dev, EEPROM_TXMIXER_GAIN_BG, &eeprom);
@@ -2686,6 +2695,7 @@ static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
 	if (rt2x00_rt(rt2x00dev, RT3090)) {
 		rt2800_bbp_read(rt2x00dev, 138, &bbp);
 
+		/*  Turn off unused DAC1 and ADC1 to reduce power consumption */
 		rt2x00_eeprom_read(rt2x00dev, EEPROM_NIC_CONF0, &eeprom);
 		if (rt2x00_get_field16(eeprom, EEPROM_NIC_CONF0_RXPATH) == 1)
 			rt2x00_set_field8(&bbp, BBP138_RX_ADC1, 0);
@@ -2719,10 +2729,9 @@ static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
 		rt2800_rfcsr_write(rt2x00dev, 21, rfcsr);
 	}
 
-	if (rt2x00_rt(rt2x00dev, RT3070) || rt2x00_rt(rt2x00dev, RT3071)) {
+	if (rt2x00_rt(rt2x00dev, RT3070)) {
 		rt2800_rfcsr_read(rt2x00dev, 27, &rfcsr);
-		if (rt2x00_rt_rev_lt(rt2x00dev, RT3070, REV_RT3070F) ||
-		    rt2x00_rt_rev_lt(rt2x00dev, RT3071, REV_RT3071E))
+		if (rt2x00_rt_rev_lt(rt2x00dev, RT3070, REV_RT3070F))
 			rt2x00_set_field8(&rfcsr, RFCSR27_R1, 3);
 		else
 			rt2x00_set_field8(&rfcsr, RFCSR27_R1, 0);
-- 
1.7.2.3

