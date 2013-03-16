Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.7]:41890 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932544Ab3CPSUH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Mar 2013 14:20:07 -0400
From: stf_xl@wp.pl
To: "John W. Linville\"" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Stanislaw Gruszka <stf_xl@wp.pl>
Subject: [PATCH 18/25] rt2800: rearrange bbp/rfcsr initialization
Date: Sat, 16 Mar 2013 19:19:46 +0100
Message-Id: <1363457993-15541-19-git-send-email-stf_xl@wp.pl> (sfid-20130316_192040_737455_E2626C90)
In-Reply-To: <1363457993-15541-1-git-send-email-stf_xl@wp.pl>
References: <1363457993-15541-1-git-send-email-stf_xl@wp.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Stanislaw Gruszka <stf_xl@wp.pl>

This makes order of initialization of various registers similar like
on vendor driver.

Based on:
NICInitializeAsic()
RT5592LoadRFNormalModeSetup()

from:
DPO_RT5572_LinuxSTA_2.6.1.3_20121022/common/rtmp_init.c
DPO_RT5572_LinuxSTA_2.6.1.3_20121022/chip/rt5592.c

Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |   50 +++++++++++++++++++++++++++---
 1 files changed, 45 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index e96ea32..e36cf4a 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -4713,6 +4713,9 @@ static void rt2800_init_rfcsr_5392(struct rt2x00_dev *rt2x00dev)
 
 static void rt2800_init_rfcsr_5592(struct rt2x00_dev *rt2x00dev)
 {
+	u8 reg;
+	u16 eeprom;
+
 	rt2800_rfcsr_write(rt2x00dev, 1, 0x3F);
 	rt2800_rfcsr_write(rt2x00dev, 3, 0x08);
 	rt2800_rfcsr_write(rt2x00dev, 3, 0x08);
@@ -4740,6 +4743,35 @@ static void rt2800_init_rfcsr_5592(struct rt2x00_dev *rt2x00dev)
 	msleep(1);
 
 	rt2800_adjust_freq_offset(rt2x00dev);
+
+	rt2800_bbp_read(rt2x00dev, 138, &reg);
+
+	/*  Turn off unused DAC1 and ADC1 to reduce power consumption */
+	rt2x00_eeprom_read(rt2x00dev, EEPROM_NIC_CONF0, &eeprom);
+	if (rt2x00_get_field16(eeprom, EEPROM_NIC_CONF0_RXPATH) == 1)
+		rt2x00_set_field8(&reg, BBP138_RX_ADC1, 0);
+	if (rt2x00_get_field16(eeprom, EEPROM_NIC_CONF0_TXPATH) == 1)
+		rt2x00_set_field8(&reg, BBP138_TX_DAC1, 1);
+
+	rt2800_bbp_write(rt2x00dev, 138, reg);
+
+	/* Enable DC filter */
+	if (rt2x00_rt_rev_gte(rt2x00dev, RT5592, REV_RT5592C))
+		rt2800_bbp_write(rt2x00dev, 103, 0xc0);
+
+	rt2800_rfcsr_read(rt2x00dev, 38, &reg);
+	rt2x00_set_field8(&reg, RFCSR38_RX_LO1_EN, 0);
+	rt2800_rfcsr_write(rt2x00dev, 38, reg);
+
+	rt2800_rfcsr_read(rt2x00dev, 39, &reg);
+	rt2x00_set_field8(&reg, RFCSR39_RX_LO2_EN, 0);
+	rt2800_rfcsr_write(rt2x00dev, 39, reg);
+
+	rt2800_bbp4_mac_if_ctrl(rt2x00dev);
+
+	rt2800_rfcsr_read(rt2x00dev, 30, &reg);
+	rt2x00_set_field8(&reg, RFCSR30_RX_VCM, 2);
+	rt2800_rfcsr_write(rt2x00dev, 30, reg);
 }
 
 static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
@@ -4817,7 +4849,7 @@ static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
 		break;
 	case RT5592:
 		rt2800_init_rfcsr_5592(rt2x00dev);
-		break;
+		return 0;
 	}
 
 	if (rt2x00_rt_rev_lt(rt2x00dev, RT3070, REV_RT3070F)) {
@@ -5024,15 +5056,23 @@ int rt2800_enable_radio(struct rt2x00_dev *rt2x00dev)
 	 * Initialize all registers.
 	 */
 	if (unlikely(rt2800_wait_wpdma_ready(rt2x00dev) ||
-		     rt2800_init_registers(rt2x00dev) ||
-		     rt2800_init_bbp(rt2x00dev) ||
-		     rt2800_init_rfcsr(rt2x00dev)))
+		     rt2800_init_registers(rt2x00dev)))
 		return -EIO;
 
 	/*
 	 * Send signal to firmware during boot time.
 	 */
-	rt2800_mcu_request(rt2x00dev, MCU_BOOT_SIGNAL, 0, 0, 0);
+	rt2800_register_write(rt2x00dev, H2M_BBP_AGENT, 0);
+	rt2800_register_write(rt2x00dev, H2M_MAILBOX_CSR, 0);
+	if (rt2x00_is_usb(rt2x00dev)) {
+		rt2800_register_write(rt2x00dev, H2M_INT_SRC, 0);
+		rt2800_mcu_request(rt2x00dev, MCU_BOOT_SIGNAL, 0, 0, 0);
+	}
+	msleep(1);
+
+	if (unlikely(rt2800_init_bbp(rt2x00dev) ||
+		     rt2800_init_rfcsr(rt2x00dev)))
+		return -EIO;
 
 	if (rt2x00_is_usb(rt2x00dev) &&
 	    (rt2x00_rt(rt2x00dev, RT3070) ||
-- 
1.7.4.4

