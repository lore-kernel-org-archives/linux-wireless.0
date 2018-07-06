Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:46762 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932328AbeGFLEG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 6 Jul 2018 07:04:06 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Jakub Kicinski <kubakici@wp.pl>,
        Michal Schmidt <mschmidt@redhat.com>,
        linux-mediatek@lists.infradead.org,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH v2 06/12] mt76x0: phy files
Date: Fri,  6 Jul 2018 13:03:43 +0200
Message-Id: <1530875029-26274-7-git-send-email-sgruszka@redhat.com> (sfid-20180706_130416_524869_89FC2074)
In-Reply-To: <1530875029-26274-1-git-send-email-sgruszka@redhat.com>
References: <1530875029-26274-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add phy files of mt76x0 driver.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 .../wireless/mediatek/mt76/mt76x0/initvals_phy.h   |  772 +++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76x0/phy.c    | 1008 ++++++++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76x0/phy.h    |   81 ++
 3 files changed, 1861 insertions(+)
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/initvals_phy.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/phy.h

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/initvals_phy.h b/drivers/net/wireless/mediatek/mt76/mt76x0/initvals_phy.h
new file mode 100644
index 000000000000..95d43efc1f3d
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/initvals_phy.h
@@ -0,0 +1,772 @@
+/*
+ * (c) Copyright 2002-2010, Ralink Technology, Inc.
+ * Copyright (C) 2015 Jakub Kicinski <kubakici@wp.pl>
+ * Copyright (C) 2018 Stanislaw Gruszka <stf_xl@wp.pl>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2
+ * as published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef __MT76X0U_PHY_INITVALS_H
+#define __MT76X0U_PHY_INITVALS_H
+
+#define RF_REG_PAIR(bank, reg, value)				\
+	{ (bank) << 16 | (reg), value }
+
+
+static const struct mt76_reg_pair mt76x0_rf_central_tab[] = {
+/*
+	Bank 0 - For central blocks: BG, PLL, XTAL, LO, ADC/DAC
+*/
+	{ MT_RF(0, 1), 0x01},
+	{ MT_RF(0, 2), 0x11},
+
+	/*
+		R3 ~ R7: VCO Cal.
+	*/
+	{ MT_RF(0, 3), 0x73}, /* VCO Freq Cal - No Bypass, VCO Amp Cal - No Bypass */
+	{ MT_RF(0, 4), 0x30}, /* R4 b<7>=1, VCO cal */
+	{ MT_RF(0, 5), 0x00},
+	{ MT_RF(0, 6), 0x41}, /* Set the open loop amplitude to middle since bypassing amplitude calibration */
+	{ MT_RF(0, 7), 0x00},
+
+	/*
+		XO
+	*/
+	{ MT_RF(0,  8), 0x00},
+	{ MT_RF(0,  9), 0x00},
+	{ MT_RF(0, 10), 0x0C},
+	{ MT_RF(0, 11), 0x00},
+	{ MT_RF(0, 12), 0x00},
+
+	/*
+		BG
+	*/
+	{ MT_RF(0, 13), 0x00},
+	{ MT_RF(0, 14), 0x00},
+	{ MT_RF(0, 15), 0x00},
+
+	/*
+		LDO
+	*/
+	{ MT_RF(0, 19), 0x20},
+	/*
+		XO
+	*/
+	{ MT_RF(0, 20), 0x22},
+	{ MT_RF(0, 21), 0x12},
+	{ MT_RF(0, 23), 0x00},
+	{ MT_RF(0, 24), 0x33}, /* See band selection for R24<1:0> */
+	{ MT_RF(0, 25), 0x00},
+
+	/*
+		PLL, See Freq Selection
+	*/
+	{ MT_RF(0, 26), 0x00},
+	{ MT_RF(0, 27), 0x00},
+	{ MT_RF(0, 28), 0x00},
+	{ MT_RF(0, 29), 0x00},
+	{ MT_RF(0, 30), 0x00},
+	{ MT_RF(0, 31), 0x00},
+	{ MT_RF(0, 32), 0x00},
+	{ MT_RF(0, 33), 0x00},
+	{ MT_RF(0, 34), 0x00},
+	{ MT_RF(0, 35), 0x00},
+	{ MT_RF(0, 36), 0x00},
+	{ MT_RF(0, 37), 0x00},
+
+	/*
+		LO Buffer
+	*/
+	{ MT_RF(0, 38), 0x2F},
+
+	/*
+		Test Ports
+	*/
+	{ MT_RF(0, 64), 0x00},
+	{ MT_RF(0, 65), 0x80},
+	{ MT_RF(0, 66), 0x01},
+	{ MT_RF(0, 67), 0x04},
+
+	/*
+		ADC/DAC
+	*/
+	{ MT_RF(0, 68), 0x00},
+	{ MT_RF(0, 69), 0x08},
+	{ MT_RF(0, 70), 0x08},
+	{ MT_RF(0, 71), 0x40},
+	{ MT_RF(0, 72), 0xD0},
+	{ MT_RF(0, 73), 0x93},
+};
+
+static const struct mt76_reg_pair mt76x0_rf_2g_channel_0_tab[] = {
+/*
+	Bank 5 - Channel 0 2G RF registers
+*/
+	/*
+		RX logic operation
+	*/
+	/* RF_R00 Change in SelectBand6590 */
+
+	{ MT_RF(5, 2), 0x0C}, /* 5G+2G (MT7610U) */
+	{ MT_RF(5, 3), 0x00},
+
+	/*
+		TX logic operation
+	*/
+	{ MT_RF(5, 4), 0x00},
+	{ MT_RF(5, 5), 0x84},
+	{ MT_RF(5, 6), 0x02},
+
+	/*
+		LDO
+	*/
+	{ MT_RF(5, 7), 0x00},
+	{ MT_RF(5, 8), 0x00},
+	{ MT_RF(5, 9), 0x00},
+
+	/*
+		RX
+	*/
+	{ MT_RF(5, 10), 0x51},
+	{ MT_RF(5, 11), 0x22},
+	{ MT_RF(5, 12), 0x22},
+	{ MT_RF(5, 13), 0x0F},
+	{ MT_RF(5, 14), 0x47}, /* Increase mixer current for more gain */
+	{ MT_RF(5, 15), 0x25},
+	{ MT_RF(5, 16), 0xC7}, /* Tune LNA2 tank */
+	{ MT_RF(5, 17), 0x00},
+	{ MT_RF(5, 18), 0x00},
+	{ MT_RF(5, 19), 0x30}, /* Improve max Pin */
+	{ MT_RF(5, 20), 0x33},
+	{ MT_RF(5, 21), 0x02},
+	{ MT_RF(5, 22), 0x32}, /* Tune LNA1 tank */
+	{ MT_RF(5, 23), 0x00},
+	{ MT_RF(5, 24), 0x25},
+	{ MT_RF(5, 26), 0x00},
+	{ MT_RF(5, 27), 0x12},
+	{ MT_RF(5, 28), 0x0F},
+	{ MT_RF(5, 29), 0x00},
+
+	/*
+		LOGEN
+	*/
+	{ MT_RF(5, 30), 0x51}, /* Tune LOGEN tank */
+	{ MT_RF(5, 31), 0x35},
+	{ MT_RF(5, 32), 0x31},
+	{ MT_RF(5, 33), 0x31},
+	{ MT_RF(5, 34), 0x34},
+	{ MT_RF(5, 35), 0x03},
+	{ MT_RF(5, 36), 0x00},
+
+	/*
+		TX
+	*/
+	{ MT_RF(5, 37), 0xDD}, /* Improve 3.2GHz spur */
+	{ MT_RF(5, 38), 0xB3},
+	{ MT_RF(5, 39), 0x33},
+	{ MT_RF(5, 40), 0xB1},
+	{ MT_RF(5, 41), 0x71},
+	{ MT_RF(5, 42), 0xF2},
+	{ MT_RF(5, 43), 0x47},
+	{ MT_RF(5, 44), 0x77},
+	{ MT_RF(5, 45), 0x0E},
+	{ MT_RF(5, 46), 0x10},
+	{ MT_RF(5, 47), 0x00},
+	{ MT_RF(5, 48), 0x53},
+	{ MT_RF(5, 49), 0x03},
+	{ MT_RF(5, 50), 0xEF},
+	{ MT_RF(5, 51), 0xC7},
+	{ MT_RF(5, 52), 0x62},
+	{ MT_RF(5, 53), 0x62},
+	{ MT_RF(5, 54), 0x00},
+	{ MT_RF(5, 55), 0x00},
+	{ MT_RF(5, 56), 0x0F},
+	{ MT_RF(5, 57), 0x0F},
+	{ MT_RF(5, 58), 0x16},
+	{ MT_RF(5, 59), 0x16},
+	{ MT_RF(5, 60), 0x10},
+	{ MT_RF(5, 61), 0x10},
+	{ MT_RF(5, 62), 0xD0},
+	{ MT_RF(5, 63), 0x6C},
+	{ MT_RF(5, 64), 0x58},
+	{ MT_RF(5, 65), 0x58},
+	{ MT_RF(5, 66), 0xF2},
+	{ MT_RF(5, 67), 0xE8},
+	{ MT_RF(5, 68), 0xF0},
+	{ MT_RF(5, 69), 0xF0},
+	{ MT_RF(5, 127), 0x04},
+};
+
+static const struct mt76_reg_pair mt76x0_rf_5g_channel_0_tab[] = {
+/*
+	Bank 6 - Channel 0 5G RF registers
+*/
+	/*
+		RX logic operation
+	*/
+	/* RF_R00 Change in SelectBandmt76x0 */
+
+	{ MT_RF(6, 2), 0x0C},
+	{ MT_RF(6, 3), 0x00},
+
+	/*
+		TX logic operation
+	*/
+	{ MT_RF(6, 4), 0x00},
+	{ MT_RF(6, 5), 0x84},
+	{ MT_RF(6, 6), 0x02},
+
+	/*
+		LDO
+	*/
+	{ MT_RF(6, 7), 0x00},
+	{ MT_RF(6, 8), 0x00},
+	{ MT_RF(6, 9), 0x00},
+
+	/*
+		RX
+	*/
+	{ MT_RF(6, 10), 0x00},
+	{ MT_RF(6, 11), 0x01},
+
+	{ MT_RF(6, 13), 0x23},
+	{ MT_RF(6, 14), 0x00},
+	{ MT_RF(6, 15), 0x04},
+	{ MT_RF(6, 16), 0x22},
+
+	{ MT_RF(6, 18), 0x08},
+	{ MT_RF(6, 19), 0x00},
+	{ MT_RF(6, 20), 0x00},
+	{ MT_RF(6, 21), 0x00},
+	{ MT_RF(6, 22), 0xFB},
+
+	/*
+		LOGEN5G
+	*/
+	{ MT_RF(6, 25), 0x76},
+	{ MT_RF(6, 26), 0x24},
+	{ MT_RF(6, 27), 0x04},
+	{ MT_RF(6, 28), 0x00},
+	{ MT_RF(6, 29), 0x00},
+
+	/*
+		TX
+	*/
+	{ MT_RF(6, 37), 0xBB},
+	{ MT_RF(6, 38), 0xB3},
+
+	{ MT_RF(6, 40), 0x33},
+	{ MT_RF(6, 41), 0x33},
+
+	{ MT_RF(6, 43), 0x03},
+	{ MT_RF(6, 44), 0xB3},
+
+	{ MT_RF(6, 46), 0x17},
+	{ MT_RF(6, 47), 0x0E},
+	{ MT_RF(6, 48), 0x10},
+	{ MT_RF(6, 49), 0x07},
+
+	{ MT_RF(6, 62), 0x00},
+	{ MT_RF(6, 63), 0x00},
+	{ MT_RF(6, 64), 0xF1},
+	{ MT_RF(6, 65), 0x0F},
+};
+
+static const struct mt76_reg_pair mt76x0_rf_vga_channel_0_tab[] = {
+/*
+	Bank 7 - Channel 0 VGA RF registers
+*/
+	/* E3 CR */
+	{ MT_RF(7, 0), 0x47}, /* Allow BBP/MAC to do calibration */
+	{ MT_RF(7, 1), 0x00},
+	{ MT_RF(7, 2), 0x00},
+	{ MT_RF(7, 3), 0x00},
+	{ MT_RF(7, 4), 0x00},
+
+	{ MT_RF(7, 10), 0x13},
+	{ MT_RF(7, 11), 0x0F},
+	{ MT_RF(7, 12), 0x13}, /* For dcoc */
+	{ MT_RF(7, 13), 0x13}, /* For dcoc */
+	{ MT_RF(7, 14), 0x13}, /* For dcoc */
+	{ MT_RF(7, 15), 0x20}, /* For dcoc */
+	{ MT_RF(7, 16), 0x22}, /* For dcoc */
+
+	{ MT_RF(7, 17), 0x7C},
+
+	{ MT_RF(7, 18), 0x00},
+	{ MT_RF(7, 19), 0x00},
+	{ MT_RF(7, 20), 0x00},
+	{ MT_RF(7, 21), 0xF1},
+	{ MT_RF(7, 22), 0x11},
+	{ MT_RF(7, 23), 0xC2},
+	{ MT_RF(7, 24), 0x41},
+	{ MT_RF(7, 25), 0x20},
+	{ MT_RF(7, 26), 0x40},
+	{ MT_RF(7, 27), 0xD7},
+	{ MT_RF(7, 28), 0xA2},
+	{ MT_RF(7, 29), 0x60},
+	{ MT_RF(7, 30), 0x49},
+	{ MT_RF(7, 31), 0x20},
+	{ MT_RF(7, 32), 0x44},
+	{ MT_RF(7, 33), 0xC1},
+	{ MT_RF(7, 34), 0x60},
+	{ MT_RF(7, 35), 0xC0},
+
+	{ MT_RF(7, 61), 0x01},
+
+	{ MT_RF(7, 72), 0x3C},
+	{ MT_RF(7, 73), 0x34},
+	{ MT_RF(7, 74), 0x00},
+};
+
+static const struct mt76x0_rf_switch_item mt76x0_rf_bw_switch_tab[] = {
+	/*   Bank, 		Register,	Bw/Band, 	Value */
+	{ MT_RF(0, 17),		RF_G_BAND | RF_BW_20,	0x00},
+	{ MT_RF(0, 17),		RF_G_BAND | RF_BW_40,	0x00},
+	{ MT_RF(0, 17),		RF_A_BAND | RF_BW_20,	0x00},
+	{ MT_RF(0, 17),		RF_A_BAND | RF_BW_40,	0x00},
+	{ MT_RF(0, 17),		RF_A_BAND | RF_BW_80,	0x00},
+
+	/* TODO: need to check B7.R6 & B7.R7 setting for 2.4G again @20121112 */
+	{ MT_RF(7,  6),		RF_G_BAND | RF_BW_20,	0x40},
+	{ MT_RF(7,  6),		RF_G_BAND | RF_BW_40,	0x1C},
+	{ MT_RF(7,  6),		RF_A_BAND | RF_BW_20,	0x40},
+	{ MT_RF(7,  6),		RF_A_BAND | RF_BW_40,	0x20},
+	{ MT_RF(7,  6),		RF_A_BAND | RF_BW_80,	0x10},
+
+	{ MT_RF(7,  7),		RF_G_BAND | RF_BW_20,	0x40},
+	{ MT_RF(7,  7),		RF_G_BAND | RF_BW_40,	0x20},
+	{ MT_RF(7,  7),		RF_A_BAND | RF_BW_20,	0x40},
+	{ MT_RF(7,  7),		RF_A_BAND | RF_BW_40,	0x20},
+	{ MT_RF(7,  7),		RF_A_BAND | RF_BW_80,	0x10},
+
+	{ MT_RF(7,  8),		RF_G_BAND | RF_BW_20,	0x03},
+	{ MT_RF(7,  8),		RF_G_BAND | RF_BW_40,	0x01},
+	{ MT_RF(7,  8),		RF_A_BAND | RF_BW_20,	0x03},
+	{ MT_RF(7,  8),		RF_A_BAND | RF_BW_40,	0x01},
+	{ MT_RF(7,  8),		RF_A_BAND | RF_BW_80,	0x00},
+
+	/* TODO: need to check B7.R58 & B7.R59 setting for 2.4G again @20121112 */
+	{ MT_RF(7, 58),		RF_G_BAND | RF_BW_20,	0x40},
+	{ MT_RF(7, 58),		RF_G_BAND | RF_BW_40,	0x40},
+	{ MT_RF(7, 58),		RF_A_BAND | RF_BW_20,	0x40},
+	{ MT_RF(7, 58),		RF_A_BAND | RF_BW_40,	0x40},
+	{ MT_RF(7, 58),		RF_A_BAND | RF_BW_80,	0x10},
+
+	{ MT_RF(7, 59),		RF_G_BAND | RF_BW_20,	0x40},
+	{ MT_RF(7, 59),		RF_G_BAND | RF_BW_40,	0x40},
+	{ MT_RF(7, 59),		RF_A_BAND | RF_BW_20,	0x40},
+	{ MT_RF(7, 59),		RF_A_BAND | RF_BW_40,	0x40},
+	{ MT_RF(7, 59),		RF_A_BAND | RF_BW_80,	0x10},
+
+	{ MT_RF(7, 60),		RF_G_BAND | RF_BW_20,	0xAA},
+	{ MT_RF(7, 60),		RF_G_BAND | RF_BW_40,	0xAA},
+	{ MT_RF(7, 60),		RF_A_BAND | RF_BW_20,	0xAA},
+	{ MT_RF(7, 60),		RF_A_BAND | RF_BW_40,	0xAA},
+	{ MT_RF(7, 60),		RF_A_BAND | RF_BW_80,	0xAA},
+
+	{ MT_RF(7, 76),		RF_BW_20,	0x40},
+	{ MT_RF(7, 76),		RF_BW_40,	0x40},
+	{ MT_RF(7, 76),		RF_BW_80,	0x10},
+
+	{ MT_RF(7, 77),		RF_BW_20,	0x40},
+	{ MT_RF(7, 77),		RF_BW_40,	0x40},
+	{ MT_RF(7, 77),		RF_BW_80,	0x10},
+};
+
+static const struct mt76x0_rf_switch_item mt76x0_rf_band_switch_tab[] = {
+	/*   Bank, 		Register,	Bw/Band, 		Value */
+	{ MT_RF(0, 16),		RF_G_BAND,		0x20},
+	{ MT_RF(0, 16),		RF_A_BAND,		0x20},
+
+	{ MT_RF(0, 18),		RF_G_BAND,		0x00},
+	{ MT_RF(0, 18),		RF_A_BAND,		0x00},
+
+	{ MT_RF(0, 39),		RF_G_BAND,		0x36},
+	{ MT_RF(0, 39),		RF_A_BAND_LB,	0x34},
+	{ MT_RF(0, 39),		RF_A_BAND_MB,	0x33},
+	{ MT_RF(0, 39),		RF_A_BAND_HB,	0x31},
+	{ MT_RF(0, 39),		RF_A_BAND_11J,	0x36},
+
+	{ MT_RF(6, 12),		RF_A_BAND_LB,	0x44},
+	{ MT_RF(6, 12),		RF_A_BAND_MB,	0x44},
+	{ MT_RF(6, 12),		RF_A_BAND_HB,	0x55},
+	{ MT_RF(6, 12),		RF_A_BAND_11J,	0x44},
+
+	{ MT_RF(6, 17),		RF_A_BAND_LB,	0x02},
+	{ MT_RF(6, 17),		RF_A_BAND_MB,	0x00},
+	{ MT_RF(6, 17),		RF_A_BAND_HB,	0x00},
+	{ MT_RF(6, 17),		RF_A_BAND_11J,	0x05},
+
+	{ MT_RF(6, 24),		RF_A_BAND_LB,	0xA1},
+	{ MT_RF(6, 24),		RF_A_BAND_MB,	0x41},
+	{ MT_RF(6, 24),		RF_A_BAND_HB,	0x21},
+	{ MT_RF(6, 24),		RF_A_BAND_11J,	0xE1},
+
+	{ MT_RF(6, 39),		RF_A_BAND_LB,	0x36},
+	{ MT_RF(6, 39),		RF_A_BAND_MB,	0x34},
+	{ MT_RF(6, 39),		RF_A_BAND_HB,	0x32},
+	{ MT_RF(6, 39),		RF_A_BAND_11J,	0x37},
+
+	{ MT_RF(6, 42),		RF_A_BAND_LB,	0xFB},
+	{ MT_RF(6, 42),		RF_A_BAND_MB,	0xF3},
+	{ MT_RF(6, 42),		RF_A_BAND_HB,	0xEB},
+	{ MT_RF(6, 42),		RF_A_BAND_11J,	0xEB},
+
+	/* Move R6-R45, R50~R59 to mt76x0_RF_INT_PA_5G_Channel_0_RegTb/mt76x0_RF_EXT_PA_5G_Channel_0_RegTb */
+
+	{ MT_RF(6, 127),	RF_G_BAND,		0x84},
+	{ MT_RF(6, 127),	RF_A_BAND,		0x04},
+
+	{ MT_RF(7, 5),		RF_G_BAND,		0x40},
+	{ MT_RF(7, 5),		RF_A_BAND,		0x00},
+
+	{ MT_RF(7, 9),		RF_G_BAND,		0x00},
+	{ MT_RF(7, 9),		RF_A_BAND,		0x00},
+
+	{ MT_RF(7, 70),		RF_G_BAND,		0x00},
+	{ MT_RF(7, 70),		RF_A_BAND,		0x6D},
+
+	{ MT_RF(7, 71),		RF_G_BAND,		0x00},
+	{ MT_RF(7, 71),		RF_A_BAND,		0xB0},
+
+	{ MT_RF(7, 78),		RF_G_BAND,		0x00},
+	{ MT_RF(7, 78),		RF_A_BAND,		0x55},
+
+	{ MT_RF(7, 79),		RF_G_BAND,		0x00},
+	{ MT_RF(7, 79),		RF_A_BAND,		0x55},
+};
+
+static const struct mt76x0_freq_item mt76x0_frequency_plan[] = {
+	{1,	RF_G_BAND,	0x02, 0x3F, 0x28, 0xDD, 0xE2, 0x40, 0x02, 0x40, 0x02, 0, 0, 1, 0x28, 0, 0x30, 0, 0, 0x3}, /* Freq 2412 */
+	{2, 	RF_G_BAND,	0x02, 0x3F, 0x3C, 0xDD, 0xE4, 0x40, 0x07, 0x40, 0x02, 0, 0, 1, 0xA1, 0, 0x30, 0, 0, 0x1}, /* Freq 2417 */
+	{3, 	RF_G_BAND,	0x02, 0x3F, 0x3C, 0xDD, 0xE2, 0x40, 0x07, 0x40, 0x0B, 0, 0, 1, 0x50, 0, 0x30, 0, 0, 0x0}, /* Freq 2422 */
+	{4, 	RF_G_BAND,	0x02, 0x3F, 0x28, 0xDD, 0xD4, 0x40, 0x02, 0x40, 0x09, 0, 0, 1, 0x50, 0, 0x30, 0, 0, 0x0}, /* Freq 2427 */
+	{5, 	RF_G_BAND,	0x02, 0x3F, 0x3C, 0xDD, 0xD4, 0x40, 0x07, 0x40, 0x02, 0, 0, 1, 0xA2, 0, 0x30, 0, 0, 0x1}, /* Freq 2432 */
+	{6, 	RF_G_BAND,	0x02, 0x3F, 0x3C, 0xDD, 0xD4, 0x40, 0x07, 0x40, 0x07, 0, 0, 1, 0xA2, 0, 0x30, 0, 0, 0x1}, /* Freq 2437 */
+	{7, 	RF_G_BAND,	0x02, 0x3F, 0x28, 0xDD, 0xE2, 0x40, 0x02, 0x40, 0x07, 0, 0, 1, 0x28, 0, 0x30, 0, 0, 0x3}, /* Freq 2442 */
+	{8, 	RF_G_BAND,	0x02, 0x3F, 0x3C, 0xDD, 0xD4, 0x40, 0x07, 0x40, 0x02, 0, 0, 1, 0xA3, 0, 0x30, 0, 0, 0x1}, /* Freq 2447 */
+	{9, 	RF_G_BAND,	0x02, 0x3F, 0x3C, 0xDD, 0xF2, 0x40, 0x07, 0x40, 0x0D, 0, 0, 1, 0x28, 0, 0x30, 0, 0, 0x3}, /* Freq 2452 */
+	{10, 	RF_G_BAND,	0x02, 0x3F, 0x28, 0xDD, 0xD4, 0x40, 0x02, 0x40, 0x09, 0, 0, 1, 0x51, 0, 0x30, 0, 0, 0x0}, /* Freq 2457 */
+	{11, 	RF_G_BAND,	0x02, 0x3F, 0x3C, 0xDD, 0xD4, 0x40, 0x07, 0x40, 0x02, 0, 0, 1, 0xA4, 0, 0x30, 0, 0, 0x1}, /* Freq 2462 */
+	{12, 	RF_G_BAND,	0x02, 0x3F, 0x3C, 0xDD, 0xD4, 0x40, 0x07, 0x40, 0x07, 0, 0, 1, 0xA4, 0, 0x30, 0, 0, 0x1}, /* Freq 2467 */
+	{13, 	RF_G_BAND,	0x02, 0x3F, 0x28, 0xDD, 0xF2, 0x40, 0x02, 0x40, 0x02, 0, 0, 1, 0x29, 0, 0x30, 0, 0, 0x3}, /* Freq 2472 */
+	{14, 	RF_G_BAND,	0x02, 0x3F, 0x28, 0xDD, 0xF2, 0x40, 0x02, 0x40, 0x04, 0, 0, 1, 0x29, 0, 0x30, 0, 0, 0x3}, /* Freq 2484 */
+
+	{183, 	(RF_A_BAND | RF_A_BAND_11J), 0x02, 0x3F, 0x70, 0xDD, 0xD2, 0x40, 0x10, 0x40, 0x17, 0, 0, 1, 0x28, 0, 0x30, 0, 0, 0x3}, /* Freq 4915 */
+	{184, 	(RF_A_BAND | RF_A_BAND_11J), 0x02, 0x3F, 0x68, 0xDD, 0xD2, 0x40, 0x10, 0x40, 0x00, 0, 0, 1, 0x29, 0, 0x30, 0, 0, 0x3}, /* Freq 4920 */
+	{185, 	(RF_A_BAND | RF_A_BAND_11J), 0x02, 0x3F, 0x68, 0xDD, 0xD2, 0x40, 0x10, 0x40, 0x01, 0, 0, 1, 0x29, 0, 0x30, 0, 0, 0x3}, /* Freq 4925 */
+	{187, 	(RF_A_BAND | RF_A_BAND_11J), 0x02, 0x3F, 0x68, 0xDD, 0xD2, 0x40, 0x10, 0x40, 0x03, 0, 0, 1, 0x29, 0, 0x30, 0, 0, 0x3}, /* Freq 4935 */
+	{188, 	(RF_A_BAND | RF_A_BAND_11J), 0x02, 0x3F, 0x30, 0x97, 0xD2, 0x40, 0x04, 0x40, 0x02, 0, 0, 1, 0x29, 0, 0x30, 0, 0, 0x3}, /* Freq 4940 */
+	{189, 	(RF_A_BAND | RF_A_BAND_11J), 0x02, 0x3F, 0x68, 0xDD, 0xD2, 0x40, 0x10, 0x40, 0x05, 0, 0, 1, 0x29, 0, 0x30, 0, 0, 0x3}, /* Freq 4945 */
+	{192, 	(RF_A_BAND | RF_A_BAND_11J), 0x02, 0x3F, 0x30, 0x97, 0xD2, 0x40, 0x04, 0x40, 0x04, 0, 0, 1, 0x29, 0, 0x30, 0, 0, 0x3}, /* Freq 4960 */
+	{196, 	(RF_A_BAND | RF_A_BAND_11J), 0x02, 0x3F, 0x30, 0x97, 0xD2, 0x40, 0x04, 0x40, 0x06, 0, 0, 1, 0x29, 0, 0x30, 0, 0, 0x3}, /* Freq 4980 */
+
+	{36, 	(RF_A_BAND | RF_A_BAND_LB),	 0x02, 0x3F, 0x30, 0x97, 0xD2, 0x40, 0x04, 0x40, 0x02, 0, 0, 1, 0x2B, 0, 0x30, 0, 0, 0x3}, /* Freq 5180 */
+	{37, 	(RF_A_BAND | RF_A_BAND_LB),	 0x02, 0x3F, 0x68, 0xDD, 0xD2, 0x40, 0x10, 0x40, 0x05, 0, 0, 1, 0x2B, 0, 0x30, 0, 0, 0x3}, /* Freq 5185 */
+	{38, 	(RF_A_BAND | RF_A_BAND_LB),	 0x02, 0x3F, 0x30, 0x97, 0xD2, 0x40, 0x04, 0x40, 0x03, 0, 0, 1, 0x2B, 0, 0x30, 0, 0, 0x3}, /* Freq 5190 */
+	{39, 	(RF_A_BAND | RF_A_BAND_LB),	 0x02, 0x3F, 0x68, 0xDD, 0xD2, 0x40, 0x10, 0x40, 0x07, 0, 0, 1, 0x2B, 0, 0x30, 0, 0, 0x3}, /* Freq 5195 */
+	{40, 	(RF_A_BAND | RF_A_BAND_LB),	 0x02, 0x3F, 0x30, 0x97, 0xD2, 0x40, 0x04, 0x40, 0x04, 0, 0, 1, 0x2B, 0, 0x30, 0, 0, 0x3}, /* Freq 5200 */
+	{41, 	(RF_A_BAND | RF_A_BAND_LB),	 0x02, 0x3F, 0x68, 0xDD, 0xD2, 0x40, 0x10, 0x40, 0x09, 0, 0, 1, 0x2B, 0, 0x30, 0, 0, 0x3}, /* Freq 5205 */
+	{42, 	(RF_A_BAND | RF_A_BAND_LB),	 0x02, 0x3F, 0x30, 0xDD, 0xD2, 0x40, 0x04, 0x40, 0x05, 0, 0, 1, 0x2B, 0, 0x30, 0, 0, 0x3}, /* Freq 5210 */
+	{43, 	(RF_A_BAND | RF_A_BAND_LB),	 0x02, 0x3F, 0x68, 0xDD, 0xD2, 0x40, 0x10, 0x40, 0x0B, 0, 0, 1, 0x2B, 0, 0x30, 0, 0, 0x3}, /* Freq 5215 */
+	{44, 	(RF_A_BAND | RF_A_BAND_LB),	 0x02, 0x3F, 0x30, 0x97, 0xD2, 0x40, 0x04, 0x40, 0x06, 0, 0, 1, 0x2B, 0, 0x30, 0, 0, 0x3}, /* Freq 5220 */
+	{45, 	(RF_A_BAND | RF_A_BAND_LB),	 0x02, 0x3F, 0x68, 0xDD, 0xD2, 0x40, 0x10, 0x40, 0x0D, 0, 0, 1, 0x2B, 0, 0x30, 0, 0, 0x3}, /* Freq 5225 */
+	{46, 	(RF_A_BAND | RF_A_BAND_LB),	 0x02, 0x3F, 0x30, 0xDD, 0xD2, 0x40, 0x04, 0x40, 0x07, 0, 0, 1, 0x2B, 0, 0x30, 0, 0, 0x3}, /* Freq 5230 */
+	{47, 	(RF_A_BAND | RF_A_BAND_LB),	 0x02, 0x3F, 0x68, 0xDD, 0xD2, 0x40, 0x10, 0x40, 0x0F, 0, 0, 1, 0x2B, 0, 0x30, 0, 0, 0x3}, /* Freq 5235 */
+	{48, 	(RF_A_BAND | RF_A_BAND_LB),	 0x02, 0x3F, 0x30, 0x97, 0xD2, 0x40, 0x04, 0x40, 0x08, 0, 0, 1, 0x2B, 0, 0x30, 0, 0, 0x3}, /* Freq 5240 */
+	{49, 	(RF_A_BAND | RF_A_BAND_LB),	 0x02, 0x3F, 0x68, 0xDD, 0xD2, 0x40, 0x10, 0x40, 0x11, 0, 0, 1, 0x2B, 0, 0x30, 0, 0, 0x3}, /* Freq 5245 */
+	{50, 	(RF_A_BAND | RF_A_BAND_LB),	 0x02, 0x3F, 0x30, 0x97, 0xD2, 0x40, 0x04, 0x40, 0x09, 0, 0, 1, 0x2B, 0, 0x30, 0, 0, 0x3}, /* Freq 5250 */
+	{51, 	(RF_A_BAND | RF_A_BAND_LB),	 0x02, 0x3F, 0x68, 0xDD, 0xD2, 0x40, 0x10, 0x40, 0x13, 0, 0, 1, 0x2B, 0, 0x30, 0, 0, 0x3}, /* Freq 5255 */
+	{52, 	(RF_A_BAND | RF_A_BAND_LB),	 0x02, 0x3F, 0x30, 0x97, 0xD2, 0x40, 0x04, 0x40, 0x0A, 0, 0, 1, 0x2B, 0, 0x30, 0, 0, 0x3}, /* Freq 5260 */
+	{53, 	(RF_A_BAND | RF_A_BAND_LB),	 0x02, 0x3F, 0x68, 0xDD, 0xD2, 0x40, 0x10, 0x40, 0x15, 0, 0, 1, 0x2B, 0, 0x30, 0, 0, 0x3}, /* Freq 5265 */
+	{54, 	(RF_A_BAND | RF_A_BAND_LB),	 0x02, 0x3F, 0x30, 0xDD, 0xD2, 0x40, 0x04, 0x40, 0x0B, 0, 0, 1, 0x2B, 0, 0x30, 0, 0, 0x3}, /* Freq 5270 */
+	{55, 	(RF_A_BAND | RF_A_BAND_LB),	 0x02, 0x3F, 0x70, 0xDD, 0xD2, 0x40, 0x10, 0x40, 0x17, 0, 0, 1, 0x2B, 0, 0x30, 0, 0, 0x3}, /* Freq 5275 */
+	{56, 	(RF_A_BAND | RF_A_BAND_LB),	 0x02, 0x3F, 0x30, 0x97, 0xD2, 0x40, 0x04, 0x40, 0x00, 0, 0, 1, 0x2C, 0, 0x30, 0, 0, 0x3}, /* Freq 5280 */
+	{57, 	(RF_A_BAND | RF_A_BAND_LB),	 0x02, 0x3F, 0x68, 0xDD, 0xD2, 0x40, 0x10, 0x40, 0x01, 0, 0, 1, 0x2C, 0, 0x30, 0, 0, 0x3}, /* Freq 5285 */
+	{58, 	(RF_A_BAND | RF_A_BAND_LB),	 0x02, 0x3F, 0x30, 0xDD, 0xD2, 0x40, 0x04, 0x40, 0x01, 0, 0, 1, 0x2C, 0, 0x30, 0, 0, 0x3}, /* Freq 5290 */
+	{59, 	(RF_A_BAND | RF_A_BAND_LB),	 0x02, 0x3F, 0x68, 0xDD, 0xD2, 0x40, 0x10, 0x40, 0x03, 0, 0, 1, 0x2C, 0, 0x30, 0, 0, 0x3}, /* Freq 5295 */
+	{60, 	(RF_A_BAND | RF_A_BAND_LB),	 0x02, 0x3F, 0x30, 0x97, 0xD2, 0x40, 0x04, 0x40, 0x02, 0, 0, 1, 0x2C, 0, 0x30, 0, 0, 0x3}, /* Freq 5300 */
+	{61, 	(RF_A_BAND | RF_A_BAND_LB),	 0x02, 0x3F, 0x68, 0xDD, 0xD2, 0x40, 0x10, 0x40, 0x05, 0, 0, 1, 0x2C, 0, 0x30, 0, 0, 0x3}, /* Freq 5305 */
+	{62, 	(RF_A_BAND | RF_A_BAND_LB),	 0x02, 0x3F, 0x30, 0x97, 0xD2, 0x40, 0x04, 0x40, 0x03, 0, 0, 1, 0x2C, 0, 0x30, 0, 0, 0x3}, /* Freq 5310 */
+	{63, 	(RF_A_BAND | RF_A_BAND_LB),	 0x02, 0x3F, 0x68, 0xDD, 0xD2, 0x40, 0x10, 0x40, 0x07, 0, 0, 1, 0x2C, 0, 0x30, 0, 0, 0x3}, /* Freq 5315 */
+	{64, 	(RF_A_BAND | RF_A_BAND_LB),	 0x02, 0x3F, 0x30, 0x97, 0xD2, 0x40, 0x04, 0x40, 0x04, 0, 0, 1, 0x2C, 0, 0x30, 0, 0, 0x3}, /* Freq 5320 */
+
+	{100, 	(RF_A_BAND | RF_A_BAND_MB),	 0x02, 0x3F, 0x30, 0x97, 0xD2, 0x40, 0x04, 0x40, 0x0A, 0, 0, 1, 0x2D, 0, 0x30, 0, 0, 0x3}, /* Freq 5500 */
+	{101, 	(RF_A_BAND | RF_A_BAND_MB),	 0x02, 0x3F, 0x68, 0xDD, 0xD2, 0x40, 0x10, 0x40, 0x15, 0, 0, 1, 0x2D, 0, 0x30, 0, 0, 0x3}, /* Freq 5505 */
+	{102, 	(RF_A_BAND | RF_A_BAND_MB),	 0x02, 0x3F, 0x30, 0xDD, 0xD2, 0x40, 0x04, 0x40, 0x0B, 0, 0, 1, 0x2D, 0, 0x30, 0, 0, 0x3}, /* Freq 5510 */
+	{103, 	(RF_A_BAND | RF_A_BAND_MB),	 0x02, 0x3F, 0x70, 0xDD, 0xD2, 0x40, 0x10, 0x40, 0x17, 0, 0, 1, 0x2D, 0, 0x30, 0, 0, 0x3}, /* Freq 5515 */
+	{104, 	(RF_A_BAND | RF_A_BAND_MB),	 0x02, 0x3F, 0x30, 0x97, 0xD2, 0x40, 0x04, 0x40, 0x00, 0, 0, 1, 0x2E, 0, 0x30, 0, 0, 0x3}, /* Freq 5520 */
+	{105, 	(RF_A_BAND | RF_A_BAND_MB),	 0x02, 0x3F, 0x68, 0xDD, 0xD2, 0x40, 0x10, 0x40, 0x01, 0, 0, 1, 0x2E, 0, 0x30, 0, 0, 0x3}, /* Freq 5525 */
+	{106, 	(RF_A_BAND | RF_A_BAND_MB),	 0x02, 0x3F, 0x30, 0xDD, 0xD2, 0x40, 0x04, 0x40, 0x01, 0, 0, 1, 0x2E, 0, 0x30, 0, 0, 0x3}, /* Freq 5530 */
+	{107, 	(RF_A_BAND | RF_A_BAND_MB),	 0x02, 0x3F, 0x68, 0xDD, 0xD2, 0x40, 0x10, 0x40, 0x03, 0, 0, 1, 0x2E, 0, 0x30, 0, 0, 0x3}, /* Freq 5535 */
+	{108, 	(RF_A_BAND | RF_A_BAND_MB),	 0x02, 0x3F, 0x30, 0x97, 0xD2, 0x40, 0x04, 0x40, 0x02, 0, 0, 1, 0x2E, 0, 0x30, 0, 0, 0x3}, /* Freq 5540 */
+	{109, 	(RF_A_BAND | RF_A_BAND_MB),	 0x02, 0x3F, 0x68, 0xDD, 0xD2, 0x40, 0x10, 0x40, 0x05, 0, 0, 1, 0x2E, 0, 0x30, 0, 0, 0x3}, /* Freq 5545 */
+	{110, 	(RF_A_BAND | RF_A_BAND_MB),	 0x02, 0x3F, 0x30, 0x97, 0xD2, 0x40, 0x04, 0x40, 0x03, 0, 0, 1, 0x2E, 0, 0x30, 0, 0, 0x3}, /* Freq 5550 */
+	{111, 	(RF_A_BAND | RF_A_BAND_MB),	 0x02, 0x3F, 0x68, 0xDD, 0xD2, 0x40, 0x10, 0x40, 0x07, 0, 0, 1, 0x2E, 0, 0x30, 0, 0, 0x3}, /* Freq 5555 */
+	{112, 	(RF_A_BAND | RF_A_BAND_MB),	 0x02, 0x3F, 0x30, 0x97, 0xD2, 0x40, 0x04, 0x40, 0x04, 0, 0, 1, 0x2E, 0, 0x30, 0, 0, 0x3}, /* Freq 5560 */
+	{113, 	(RF_A_BAND | RF_A_BAND_MB),	 0x02, 0x3F, 0x68, 0xDD, 0xD2, 0x40, 0x10, 0x40, 0x09, 0, 0, 1, 0x2E, 0, 0x30, 0, 0, 0x3}, /* Freq 5565 */
+	{114, 	(RF_A_BAND | RF_A_BAND_MB),	 0x02, 0x3F, 0x30, 0xDD, 0xD2, 0x40, 0x04, 0x40, 0x05, 0, 0, 1, 0x2E, 0, 0x30, 0, 0, 0x3}, /* Freq 5570 */
+	{115, 	(RF_A_BAND | RF_A_BAND_MB),	 0x02, 0x3F, 0x68, 0xDD, 0xD2, 0x40, 0x10, 0x40, 0x0B, 0, 0, 1, 0x2E, 0, 0x30, 0, 0, 0x3}, /* Freq 5575 */
+	{116, 	(RF_A_BAND | RF_A_BAND_MB),	 0x02, 0x3F, 0x30, 0x97, 0xD2, 0x40, 0x04, 0x40, 0x06, 0, 0, 1, 0x2E, 0, 0x30, 0, 0, 0x3}, /* Freq 5580 */
+	{117, 	(RF_A_BAND | RF_A_BAND_MB),	 0x02, 0x3F, 0x68, 0xDD, 0xD2, 0x40, 0x10, 0x40, 0x0D, 0, 0, 1, 0x2E, 0, 0x30, 0, 0, 0x3}, /* Freq 5585 */
+	{118, 	(RF_A_BAND | RF_A_BAND_MB),	 0x02, 0x3F, 0x30, 0xDD, 0xD2, 0x40, 0x04, 0x40, 0x07, 0, 0, 1, 0x2E, 0, 0x30, 0, 0, 0x3}, /* Freq 5590 */
+	{119, 	(RF_A_BAND | RF_A_BAND_MB),	 0x02, 0x3F, 0x68, 0xDD, 0xD2, 0x40, 0x10, 0x40, 0x0F, 0, 0, 1, 0x2E, 0, 0x30, 0, 0, 0x3}, /* Freq 5595 */
+	{120, 	(RF_A_BAND | RF_A_BAND_MB),	 0x02, 0x3F, 0x30, 0x97, 0xD2, 0x40, 0x04, 0x40, 0x08, 0, 0, 1, 0x2E, 0, 0x30, 0, 0, 0x3}, /* Freq 5600 */
+	{121, 	(RF_A_BAND | RF_A_BAND_MB),	 0x02, 0x3F, 0x68, 0xDD, 0xD2, 0x40, 0x10, 0x40, 0x11, 0, 0, 1, 0x2E, 0, 0x30, 0, 0, 0x3}, /* Freq 5605 */
+	{122, 	(RF_A_BAND | RF_A_BAND_MB),	 0x02, 0x3F, 0x30, 0x97, 0xD2, 0x40, 0x04, 0x40, 0x09, 0, 0, 1, 0x2E, 0, 0x30, 0, 0, 0x3}, /* Freq 5610 */
+	{123, 	(RF_A_BAND | RF_A_BAND_MB),	 0x02, 0x3F, 0x68, 0xDD, 0xD2, 0x40, 0x10, 0x40, 0x13, 0, 0, 1, 0x2E, 0, 0x30, 0, 0, 0x3}, /* Freq 5615 */
+	{124, 	(RF_A_BAND | RF_A_BAND_MB),	 0x02, 0x3F, 0x30, 0x97, 0xD2, 0x40, 0x04, 0x40, 0x0A, 0, 0, 1, 0x2E, 0, 0x30, 0, 0, 0x3}, /* Freq 5620 */
+	{125, 	(RF_A_BAND | RF_A_BAND_MB),	 0x02, 0x3F, 0x68, 0xDD, 0xD2, 0x40, 0x10, 0x40, 0x15, 0, 0, 1, 0x2E, 0, 0x30, 0, 0, 0x3}, /* Freq 5625 */
+	{126, 	(RF_A_BAND | RF_A_BAND_MB),	 0x02, 0x3F, 0x30, 0xDD, 0xD2, 0x40, 0x04, 0x40, 0x0B, 0, 0, 1, 0x2E, 0, 0x30, 0, 0, 0x3}, /* Freq 5630 */
+	{127, 	(RF_A_BAND | RF_A_BAND_MB),	 0x02, 0x3F, 0x70, 0xDD, 0xD2, 0x40, 0x10, 0x40, 0x17, 0, 0, 1, 0x2E, 0, 0x30, 0, 0, 0x3}, /* Freq 5635 */
+	{128, 	(RF_A_BAND | RF_A_BAND_MB),	 0x02, 0x3F, 0x30, 0x97, 0xD2, 0x40, 0x04, 0x40, 0x00, 0, 0, 1, 0x2F, 0, 0x30, 0, 0, 0x3}, /* Freq 5640 */
+	{129, 	(RF_A_BAND | RF_A_BAND_MB),	 0x02, 0x3F, 0x68, 0xDD, 0xD2, 0x40, 0x10, 0x40, 0x01, 0, 0, 1, 0x2F, 0, 0x30, 0, 0, 0x3}, /* Freq 5645 */
+	{130, 	(RF_A_BAND | RF_A_BAND_MB),	 0x02, 0x3F, 0x30, 0xDD, 0xD2, 0x40, 0x04, 0x40, 0x01, 0, 0, 1, 0x2F, 0, 0x30, 0, 0, 0x3}, /* Freq 5650 */
+	{131, 	(RF_A_BAND | RF_A_BAND_MB),	 0x02, 0x3F, 0x68, 0xDD, 0xD2, 0x40, 0x10, 0x40, 0x03, 0, 0, 1, 0x2F, 0, 0x30, 0, 0, 0x3}, /* Freq 5655 */
+	{132, 	(RF_A_BAND | RF_A_BAND_MB),	 0x02, 0x3F, 0x30, 0x97, 0xD2, 0x40, 0x04, 0x40, 0x02, 0, 0, 1, 0x2F, 0, 0x30, 0, 0, 0x3}, /* Freq 5660 */
+	{133, 	(RF_A_BAND | RF_A_BAND_MB),	 0x02, 0x3F, 0x68, 0xDD, 0xD2, 0x40, 0x10, 0x40, 0x05, 0, 0, 1, 0x2F, 0, 0x30, 0, 0, 0x3}, /* Freq 5665 */
+	{134, 	(RF_A_BAND | RF_A_BAND_MB),	 0x02, 0x3F, 0x30, 0x97, 0xD2, 0x40, 0x04, 0x40, 0x03, 0, 0, 1, 0x2F, 0, 0x30, 0, 0, 0x3}, /* Freq 5670 */
+	{135, 	(RF_A_BAND | RF_A_BAND_MB),	 0x02, 0x3F, 0x68, 0xDD, 0xD2, 0x40, 0x10, 0x40, 0x07, 0, 0, 1, 0x2F, 0, 0x30, 0, 0, 0x3}, /* Freq 5675 */
+	{136, 	(RF_A_BAND | RF_A_BAND_MB),	 0x02, 0x3F, 0x30, 0x97, 0xD2, 0x40, 0x04, 0x40, 0x04, 0, 0, 1, 0x2F, 0, 0x30, 0, 0, 0x3}, /* Freq 5680 */
+
+	{137, 	(RF_A_BAND | RF_A_BAND_HB),	 0x02, 0x3F, 0x68, 0xDD, 0xD2, 0x40, 0x10, 0x40, 0x09, 0, 0, 1, 0x2F, 0, 0x30, 0, 0, 0x3}, /* Freq 5685 */
+	{138, 	(RF_A_BAND | RF_A_BAND_HB),	 0x02, 0x3F, 0x30, 0xDD, 0xD2, 0x40, 0x04, 0x40, 0x05, 0, 0, 1, 0x2F, 0, 0x30, 0, 0, 0x3}, /* Freq 5690 */
+	{139, 	(RF_A_BAND | RF_A_BAND_HB),	 0x02, 0x3F, 0x68, 0xDD, 0xD2, 0x40, 0x10, 0x40, 0x0B, 0, 0, 1, 0x2F, 0, 0x30, 0, 0, 0x3}, /* Freq 5695 */
+	{140, 	(RF_A_BAND | RF_A_BAND_HB),	 0x02, 0x3F, 0x30, 0x97, 0xD2, 0x40, 0x04, 0x40, 0x06, 0, 0, 1, 0x2F, 0, 0x30, 0, 0, 0x3}, /* Freq 5700 */
+	{141, 	(RF_A_BAND | RF_A_BAND_HB),	 0x02, 0x3F, 0x68, 0xDD, 0xD2, 0x40, 0x10, 0x40, 0x0D, 0, 0, 1, 0x2F, 0, 0x30, 0, 0, 0x3}, /* Freq 5705 */
+	{142, 	(RF_A_BAND | RF_A_BAND_HB),	 0x02, 0x3F, 0x30, 0xDD, 0xD2, 0x40, 0x04, 0x40, 0x07, 0, 0, 1, 0x2F, 0, 0x30, 0, 0, 0x3}, /* Freq 5710 */
+	{143, 	(RF_A_BAND | RF_A_BAND_HB),	 0x02, 0x3F, 0x68, 0xDD, 0xD2, 0x40, 0x10, 0x40, 0x0F, 0, 0, 1, 0x2F, 0, 0x30, 0, 0, 0x3}, /* Freq 5715 */
+	{144, 	(RF_A_BAND | RF_A_BAND_HB),	 0x02, 0x3F, 0x30, 0x97, 0xD2, 0x40, 0x04, 0x40, 0x08, 0, 0, 1, 0x2F, 0, 0x30, 0, 0, 0x3}, /* Freq 5720 */
+	{145, 	(RF_A_BAND | RF_A_BAND_HB),	 0x02, 0x3F, 0x68, 0xDD, 0xD2, 0x40, 0x10, 0x40, 0x11, 0, 0, 1, 0x2F, 0, 0x30, 0, 0, 0x3}, /* Freq 5725 */
+	{146, 	(RF_A_BAND | RF_A_BAND_HB),	 0x02, 0x3F, 0x30, 0x97, 0xD2, 0x40, 0x04, 0x40, 0x09, 0, 0, 1, 0x2F, 0, 0x30, 0, 0, 0x3}, /* Freq 5730 */
+	{147, 	(RF_A_BAND | RF_A_BAND_HB),	 0x02, 0x3F, 0x68, 0xDD, 0xD2, 0x40, 0x10, 0x40, 0x13, 0, 0, 1, 0x2F, 0, 0x30, 0, 0, 0x3}, /* Freq 5735 */
+	{148, 	(RF_A_BAND | RF_A_BAND_HB),	 0x02, 0x3F, 0x30, 0x97, 0xD2, 0x40, 0x04, 0x40, 0x0A, 0, 0, 1, 0x2F, 0, 0x30, 0, 0, 0x3}, /* Freq 5740 */
+	{149, 	(RF_A_BAND | RF_A_BAND_HB),	 0x02, 0x3F, 0x68, 0xDD, 0xD2, 0x40, 0x10, 0x40, 0x15, 0, 0, 1, 0x2F, 0, 0x30, 0, 0, 0x3}, /* Freq 5745 */
+	{150, 	(RF_A_BAND | RF_A_BAND_HB),	 0x02, 0x3F, 0x30, 0xDD, 0xD2, 0x40, 0x04, 0x40, 0x0B, 0, 0, 1, 0x2F, 0, 0x30, 0, 0, 0x3}, /* Freq 5750 */
+	{151, 	(RF_A_BAND | RF_A_BAND_HB),	 0x02, 0x3F, 0x70, 0xDD, 0xD2, 0x40, 0x10, 0x40, 0x17, 0, 0, 1, 0x2F, 0, 0x30, 0, 0, 0x3}, /* Freq 5755 */
+	{152, 	(RF_A_BAND | RF_A_BAND_HB),	 0x02, 0x3F, 0x30, 0x97, 0xD2, 0x40, 0x04, 0x40, 0x00, 0, 0, 1, 0x30, 0, 0x30, 0, 0, 0x3}, /* Freq 5760 */
+	{153, 	(RF_A_BAND | RF_A_BAND_HB),	 0x02, 0x3F, 0x68, 0xDD, 0xD2, 0x40, 0x10, 0x40, 0x01, 0, 0, 1, 0x30, 0, 0x30, 0, 0, 0x3}, /* Freq 5765 */
+	{154, 	(RF_A_BAND | RF_A_BAND_HB),	 0x02, 0x3F, 0x30, 0xDD, 0xD2, 0x40, 0x04, 0x40, 0x01, 0, 0, 1, 0x30, 0, 0x30, 0, 0, 0x3}, /* Freq 5770 */
+	{155, 	(RF_A_BAND | RF_A_BAND_HB),	 0x02, 0x3F, 0x68, 0xDD, 0xD2, 0x40, 0x10, 0x40, 0x03, 0, 0, 1, 0x30, 0, 0x30, 0, 0, 0x3}, /* Freq 5775 */
+	{156, 	(RF_A_BAND | RF_A_BAND_HB),	 0x02, 0x3F, 0x30, 0x97, 0xD2, 0x40, 0x04, 0x40, 0x02, 0, 0, 1, 0x30, 0, 0x30, 0, 0, 0x3}, /* Freq 5780 */
+	{157, 	(RF_A_BAND | RF_A_BAND_HB),	 0x02, 0x3F, 0x68, 0xDD, 0xD2, 0x40, 0x10, 0x40, 0x05, 0, 0, 1, 0x30, 0, 0x30, 0, 0, 0x3}, /* Freq 5785 */
+	{158, 	(RF_A_BAND | RF_A_BAND_HB),	 0x02, 0x3F, 0x30, 0x97, 0xD2, 0x40, 0x04, 0x40, 0x03, 0, 0, 1, 0x30, 0, 0x30, 0, 0, 0x3}, /* Freq 5790 */
+	{159, 	(RF_A_BAND | RF_A_BAND_HB),	 0x02, 0x3F, 0x68, 0xDD, 0xD2, 0x40, 0x10, 0x40, 0x07, 0, 0, 1, 0x30, 0, 0x30, 0, 0, 0x3}, /* Freq 5795 */
+	{160, 	(RF_A_BAND | RF_A_BAND_HB),	 0x02, 0x3F, 0x30, 0x97, 0xD2, 0x40, 0x04, 0x40, 0x04, 0, 0, 1, 0x30, 0, 0x30, 0, 0, 0x3}, /* Freq 5800 */
+	{161, 	(RF_A_BAND | RF_A_BAND_HB),	 0x02, 0x3F, 0x68, 0xDD, 0xD2, 0x40, 0x10, 0x40, 0x09, 0, 0, 1, 0x30, 0, 0x30, 0, 0, 0x3}, /* Freq 5805 */
+	{162, 	(RF_A_BAND | RF_A_BAND_HB),	 0x02, 0x3F, 0x30, 0xDD, 0xD2, 0x40, 0x04, 0x40, 0x05, 0, 0, 1, 0x30, 0, 0x30, 0, 0, 0x3}, /* Freq 5810 */
+	{163, 	(RF_A_BAND | RF_A_BAND_HB),	 0x02, 0x3F, 0x68, 0xDD, 0xD2, 0x40, 0x10, 0x40, 0x0B, 0, 0, 1, 0x30, 0, 0x30, 0, 0, 0x3}, /* Freq 5815 */
+	{164, 	(RF_A_BAND | RF_A_BAND_HB),	 0x02, 0x3F, 0x30, 0x97, 0xD2, 0x40, 0x04, 0x40, 0x06, 0, 0, 1, 0x30, 0, 0x30, 0, 0, 0x3}, /* Freq 5820 */
+	{165, 	(RF_A_BAND | RF_A_BAND_HB),	 0x02, 0x3F, 0x68, 0xDD, 0xD2, 0x40, 0x10, 0x40, 0x0D, 0, 0, 1, 0x30, 0, 0x30, 0, 0, 0x3}, /* Freq 5825 */
+	{166, 	(RF_A_BAND | RF_A_BAND_HB),	 0x02, 0x3F, 0x30, 0xDD, 0xD2, 0x40, 0x04, 0x40, 0x07, 0, 0, 1, 0x30, 0, 0x30, 0, 0, 0x3}, /* Freq 5830 */
+	{167, 	(RF_A_BAND | RF_A_BAND_HB),	 0x02, 0x3F, 0x68, 0xDD, 0xD2, 0x40, 0x10, 0x40, 0x0F, 0, 0, 1, 0x30, 0, 0x30, 0, 0, 0x3}, /* Freq 5835 */
+	{168, 	(RF_A_BAND | RF_A_BAND_HB),	 0x02, 0x3F, 0x30, 0x97, 0xD2, 0x40, 0x04, 0x40, 0x08, 0, 0, 1, 0x30, 0, 0x30, 0, 0, 0x3}, /* Freq 5840 */
+	{169, 	(RF_A_BAND | RF_A_BAND_HB),	 0x02, 0x3F, 0x68, 0xDD, 0xD2, 0x40, 0x10, 0x40, 0x11, 0, 0, 1, 0x30, 0, 0x30, 0, 0, 0x3}, /* Freq 5845 */
+	{170, 	(RF_A_BAND | RF_A_BAND_HB),	 0x02, 0x3F, 0x30, 0x97, 0xD2, 0x40, 0x04, 0x40, 0x09, 0, 0, 1, 0x30, 0, 0x30, 0, 0, 0x3}, /* Freq 5850 */
+	{171, 	(RF_A_BAND | RF_A_BAND_HB),	 0x02, 0x3F, 0x68, 0xDD, 0xD2, 0x40, 0x10, 0x40, 0x13, 0, 0, 1, 0x30, 0, 0x30, 0, 0, 0x3}, /* Freq 5855 */
+	{172, 	(RF_A_BAND | RF_A_BAND_HB),	 0x02, 0x3F, 0x30, 0x97, 0xD2, 0x40, 0x04, 0x40, 0x0A, 0, 0, 1, 0x30, 0, 0x30, 0, 0, 0x3}, /* Freq 5860 */
+	{173, 	(RF_A_BAND | RF_A_BAND_HB),	 0x02, 0x3F, 0x68, 0xDD, 0xD2, 0x40, 0x10, 0x40, 0x15, 0, 0, 1, 0x30, 0, 0x30, 0, 0, 0x3}, /* Freq 5865 */
+};
+
+static const struct mt76x0_freq_item mt76x0_sdm_frequency_plan[] = {
+	{1,	RF_G_BAND,	0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x28, 0, 0x0, 0x8, 0xCCCC,  0x3}, /* Freq 2412 */
+	{2, 	RF_G_BAND,	0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x28, 0, 0x0, 0x8, 0x12222, 0x3}, /* Freq 2417 */
+	{3, 	RF_G_BAND,	0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x28, 0, 0x0, 0x8, 0x17777, 0x3}, /* Freq 2422 */
+	{4, 	RF_G_BAND,	0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x28, 0, 0x0, 0x8, 0x1CCCC, 0x3}, /* Freq 2427 */
+	{5, 	RF_G_BAND,	0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x28, 0, 0x0, 0x8, 0x22222, 0x3}, /* Freq 2432 */
+	{6, 	RF_G_BAND,	0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x28, 0, 0x0, 0x8, 0x27777, 0x3}, /* Freq 2437 */
+	{7, 	RF_G_BAND,	0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x28, 0, 0x0, 0x8, 0x2CCCC, 0x3}, /* Freq 2442 */
+	{8, 	RF_G_BAND,	0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x28, 0, 0x0, 0x8, 0x32222, 0x3}, /* Freq 2447 */
+	{9, 	RF_G_BAND,	0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x28, 0, 0x0, 0x8, 0x37777, 0x3}, /* Freq 2452 */
+	{10, 	RF_G_BAND,	0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x28, 0, 0x0, 0x8, 0x3CCCC, 0x3}, /* Freq 2457 */
+	{11, 	RF_G_BAND,	0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x29, 0, 0x0, 0x8, 0x2222, 0x3}, /* Freq 2462 */
+	{12, 	RF_G_BAND,	0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x29, 0, 0x0, 0x8, 0x7777, 0x3}, /* Freq 2467 */
+	{13, 	RF_G_BAND,	0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x29, 0, 0x0, 0x8, 0xCCCC, 0x3}, /* Freq 2472 */
+	{14, 	RF_G_BAND,	0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x29, 0, 0x0, 0x8, 0x19999, 0x3}, /* Freq 2484 */
+
+	{183, 	(RF_A_BAND | RF_A_BAND_11J), 0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x28, 0, 0x0, 0x8, 0x3D555, 0x3}, /* Freq 4915 */
+	{184, 	(RF_A_BAND | RF_A_BAND_11J), 0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x29, 0, 0x0, 0x8, 0x0,     0x3}, /* Freq 4920 */
+	{185, 	(RF_A_BAND | RF_A_BAND_11J), 0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x29, 0, 0x0, 0x8, 0x2AAA,  0x3}, /* Freq 4925 */
+	{187, 	(RF_A_BAND | RF_A_BAND_11J), 0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x29, 0, 0x0, 0x8, 0x8000,  0x3}, /* Freq 4935 */
+	{188, 	(RF_A_BAND | RF_A_BAND_11J), 0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x29, 0, 0x0, 0x8, 0xAAAA,  0x3}, /* Freq 4940 */
+	{189, 	(RF_A_BAND | RF_A_BAND_11J), 0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x29, 0, 0x0, 0x8, 0xD555,  0x3}, /* Freq 4945 */
+	{192, 	(RF_A_BAND | RF_A_BAND_11J), 0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x29, 0, 0x0, 0x8, 0x15555, 0x3}, /* Freq 4960 */
+	{196, 	(RF_A_BAND | RF_A_BAND_11J), 0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x29, 0, 0x0, 0x8, 0x20000, 0x3}, /* Freq 4980 */
+
+	{36, 	(RF_A_BAND | RF_A_BAND_LB),	 0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x2B, 0, 0x0, 0x8, 0xAAAA,  0x3}, /* Freq 5180 */
+	{37, 	(RF_A_BAND | RF_A_BAND_LB),	 0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x2B, 0, 0x0, 0x8, 0xD555,  0x3}, /* Freq 5185 */
+	{38, 	(RF_A_BAND | RF_A_BAND_LB),	 0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x2B, 0, 0x0, 0x8, 0x10000, 0x3}, /* Freq 5190 */
+	{39, 	(RF_A_BAND | RF_A_BAND_LB),	 0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x2B, 0, 0x0, 0x8, 0x12AAA, 0x3}, /* Freq 5195 */
+	{40, 	(RF_A_BAND | RF_A_BAND_LB),	 0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x2B, 0, 0x0, 0x8, 0x15555, 0x3}, /* Freq 5200 */
+	{41, 	(RF_A_BAND | RF_A_BAND_LB),	 0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x2B, 0, 0x0, 0x8, 0x18000, 0x3}, /* Freq 5205 */
+	{42, 	(RF_A_BAND | RF_A_BAND_LB),	 0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x2B, 0, 0x0, 0x8, 0x1AAAA, 0x3}, /* Freq 5210 */
+	{43, 	(RF_A_BAND | RF_A_BAND_LB),	 0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x2B, 0, 0x0, 0x8, 0x1D555, 0x3}, /* Freq 5215 */
+	{44, 	(RF_A_BAND | RF_A_BAND_LB),	 0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x2B, 0, 0x0, 0x8, 0x20000, 0x3}, /* Freq 5220 */
+	{45, 	(RF_A_BAND | RF_A_BAND_LB),	 0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x2B, 0, 0x0, 0x8, 0x22AAA, 0x3}, /* Freq 5225 */
+	{46, 	(RF_A_BAND | RF_A_BAND_LB),	 0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x2B, 0, 0x0, 0x8, 0x25555, 0x3}, /* Freq 5230 */
+	{47, 	(RF_A_BAND | RF_A_BAND_LB),	 0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x2B, 0, 0x0, 0x8, 0x28000, 0x3}, /* Freq 5235 */
+	{48, 	(RF_A_BAND | RF_A_BAND_LB),	 0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x2B, 0, 0x0, 0x8, 0x2AAAA, 0x3}, /* Freq 5240 */
+	{49, 	(RF_A_BAND | RF_A_BAND_LB),	 0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x2B, 0, 0x0, 0x8, 0x2D555, 0x3}, /* Freq 5245 */
+	{50, 	(RF_A_BAND | RF_A_BAND_LB),	 0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x2B, 0, 0x0, 0x8, 0x30000, 0x3}, /* Freq 5250 */
+	{51, 	(RF_A_BAND | RF_A_BAND_LB),	 0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x2B, 0, 0x0, 0x8, 0x32AAA, 0x3}, /* Freq 5255 */
+	{52, 	(RF_A_BAND | RF_A_BAND_LB),	 0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x2B, 0, 0x0, 0x8, 0x35555, 0x3}, /* Freq 5260 */
+	{53, 	(RF_A_BAND | RF_A_BAND_LB),	 0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x2B, 0, 0x0, 0x8, 0x38000, 0x3}, /* Freq 5265 */
+	{54, 	(RF_A_BAND | RF_A_BAND_LB),	 0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x2B, 0, 0x0, 0x8, 0x3AAAA, 0x3}, /* Freq 5270 */
+	{55, 	(RF_A_BAND | RF_A_BAND_LB),	 0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x2B, 0, 0x0, 0x8, 0x3D555, 0x3}, /* Freq 5275 */
+	{56, 	(RF_A_BAND | RF_A_BAND_LB),	 0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x2C, 0, 0x0, 0x8, 0x00000, 0x3}, /* Freq 5280 */
+	{57, 	(RF_A_BAND | RF_A_BAND_LB),	 0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x2C, 0, 0x0, 0x8, 0x02AAA, 0x3}, /* Freq 5285 */
+	{58, 	(RF_A_BAND | RF_A_BAND_LB),	 0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x2C, 0, 0x0, 0x8, 0x05555, 0x3}, /* Freq 5290 */
+	{59, 	(RF_A_BAND | RF_A_BAND_LB),	 0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x2C, 0, 0x0, 0x8, 0x08000, 0x3}, /* Freq 5295 */
+	{60, 	(RF_A_BAND | RF_A_BAND_LB),	 0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x2C, 0, 0x0, 0x8, 0x0AAAA, 0x3}, /* Freq 5300 */
+	{61, 	(RF_A_BAND | RF_A_BAND_LB),	 0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x2C, 0, 0x0, 0x8, 0x0D555, 0x3}, /* Freq 5305 */
+	{62, 	(RF_A_BAND | RF_A_BAND_LB),	 0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x2C, 0, 0x0, 0x8, 0x10000, 0x3}, /* Freq 5310 */
+	{63, 	(RF_A_BAND | RF_A_BAND_LB),	 0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x2C, 0, 0x0, 0x8, 0x12AAA, 0x3}, /* Freq 5315 */
+	{64, 	(RF_A_BAND | RF_A_BAND_LB),	 0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x2C, 0, 0x0, 0x8, 0x15555, 0x3}, /* Freq 5320 */
+
+	{100, 	(RF_A_BAND | RF_A_BAND_MB),	 0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x2D, 0, 0x0, 0x8, 0x35555, 0x3}, /* Freq 5500 */
+	{101, 	(RF_A_BAND | RF_A_BAND_MB),	 0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x2D, 0, 0x0, 0x8, 0x38000, 0x3}, /* Freq 5505 */
+	{102, 	(RF_A_BAND | RF_A_BAND_MB),	 0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x2D, 0, 0x0, 0x8, 0x3AAAA, 0x3}, /* Freq 5510 */
+	{103, 	(RF_A_BAND | RF_A_BAND_MB),	 0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x2D, 0, 0x0, 0x8, 0x3D555, 0x3}, /* Freq 5515 */
+	{104, 	(RF_A_BAND | RF_A_BAND_MB),	 0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x2E, 0, 0x0, 0x8, 0x00000, 0x3}, /* Freq 5520 */
+	{105, 	(RF_A_BAND | RF_A_BAND_MB),	 0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x2E, 0, 0x0, 0x8, 0x02AAA, 0x3}, /* Freq 5525 */
+	{106, 	(RF_A_BAND | RF_A_BAND_MB),	 0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x2E, 0, 0x0, 0x8, 0x05555, 0x3}, /* Freq 5530 */
+	{107, 	(RF_A_BAND | RF_A_BAND_MB),	 0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x2E, 0, 0x0, 0x8, 0x08000, 0x3}, /* Freq 5535 */
+	{108, 	(RF_A_BAND | RF_A_BAND_MB),	 0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x2E, 0, 0x0, 0x8, 0x0AAAA, 0x3}, /* Freq 5540 */
+	{109, 	(RF_A_BAND | RF_A_BAND_MB),	 0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x2E, 0, 0x0, 0x8, 0x0D555, 0x3}, /* Freq 5545 */
+	{110, 	(RF_A_BAND | RF_A_BAND_MB),	 0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x2E, 0, 0x0, 0x8, 0x10000, 0x3}, /* Freq 5550 */
+	{111, 	(RF_A_BAND | RF_A_BAND_MB),	 0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x2E, 0, 0x0, 0x8, 0x12AAA, 0x3}, /* Freq 5555 */
+	{112, 	(RF_A_BAND | RF_A_BAND_MB),	 0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x2E, 0, 0x0, 0x8, 0x15555, 0x3}, /* Freq 5560 */
+	{113, 	(RF_A_BAND | RF_A_BAND_MB),	 0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x2E, 0, 0x0, 0x8, 0x18000, 0x3}, /* Freq 5565 */
+	{114, 	(RF_A_BAND | RF_A_BAND_MB),	 0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x2E, 0, 0x0, 0x8, 0x1AAAA, 0x3}, /* Freq 5570 */
+	{115, 	(RF_A_BAND | RF_A_BAND_MB),	 0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x2E, 0, 0x0, 0x8, 0x1D555, 0x3}, /* Freq 5575 */
+	{116, 	(RF_A_BAND | RF_A_BAND_MB),	 0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x2E, 0, 0x0, 0x8, 0x20000, 0x3}, /* Freq 5580 */
+	{117, 	(RF_A_BAND | RF_A_BAND_MB),	 0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x2E, 0, 0x0, 0x8, 0x22AAA, 0x3}, /* Freq 5585 */
+	{118, 	(RF_A_BAND | RF_A_BAND_MB),	 0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x2E, 0, 0x0, 0x8, 0x25555, 0x3}, /* Freq 5590 */
+	{119, 	(RF_A_BAND | RF_A_BAND_MB),	 0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x2E, 0, 0x0, 0x8, 0x28000, 0x3}, /* Freq 5595 */
+	{120, 	(RF_A_BAND | RF_A_BAND_MB),	 0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x2E, 0, 0x0, 0x8, 0x2AAAA, 0x3}, /* Freq 5600 */
+	{121, 	(RF_A_BAND | RF_A_BAND_MB),	 0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x2E, 0, 0x0, 0x8, 0x2D555, 0x3}, /* Freq 5605 */
+	{122, 	(RF_A_BAND | RF_A_BAND_MB),	 0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x2E, 0, 0x0, 0x8, 0x30000, 0x3}, /* Freq 5610 */
+	{123, 	(RF_A_BAND | RF_A_BAND_MB),	 0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x2E, 0, 0x0, 0x8, 0x32AAA, 0x3}, /* Freq 5615 */
+	{124, 	(RF_A_BAND | RF_A_BAND_MB),	 0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x2E, 0, 0x0, 0x8, 0x35555, 0x3}, /* Freq 5620 */
+	{125, 	(RF_A_BAND | RF_A_BAND_MB),	 0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x2E, 0, 0x0, 0x8, 0x38000, 0x3}, /* Freq 5625 */
+	{126, 	(RF_A_BAND | RF_A_BAND_MB),	 0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x2E, 0, 0x0, 0x8, 0x3AAAA, 0x3}, /* Freq 5630 */
+	{127, 	(RF_A_BAND | RF_A_BAND_MB),	 0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x2E, 0, 0x0, 0x8, 0x3D555, 0x3}, /* Freq 5635 */
+	{128, 	(RF_A_BAND | RF_A_BAND_MB),	 0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x2F, 0, 0x0, 0x8, 0x00000, 0x3}, /* Freq 5640 */
+	{129, 	(RF_A_BAND | RF_A_BAND_MB),	 0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x2F, 0, 0x0, 0x8, 0x02AAA, 0x3}, /* Freq 5645 */
+	{130, 	(RF_A_BAND | RF_A_BAND_MB),	 0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x2F, 0, 0x0, 0x8, 0x05555, 0x3}, /* Freq 5650 */
+	{131, 	(RF_A_BAND | RF_A_BAND_MB),	 0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x2F, 0, 0x0, 0x8, 0x08000, 0x3}, /* Freq 5655 */
+	{132, 	(RF_A_BAND | RF_A_BAND_MB),	 0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x2F, 0, 0x0, 0x8, 0x0AAAA, 0x3}, /* Freq 5660 */
+	{133, 	(RF_A_BAND | RF_A_BAND_MB),	 0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x2F, 0, 0x0, 0x8, 0x0D555, 0x3}, /* Freq 5665 */
+	{134, 	(RF_A_BAND | RF_A_BAND_MB),	 0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x2F, 0, 0x0, 0x8, 0x10000, 0x3}, /* Freq 5670 */
+	{135, 	(RF_A_BAND | RF_A_BAND_MB),	 0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x2F, 0, 0x0, 0x8, 0x12AAA, 0x3}, /* Freq 5675 */
+	{136, 	(RF_A_BAND | RF_A_BAND_MB),	 0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x2F, 0, 0x0, 0x8, 0x15555, 0x3}, /* Freq 5680 */
+
+	{137, 	(RF_A_BAND | RF_A_BAND_HB),	 0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x2F, 0, 0x0, 0x8, 0x18000, 0x3}, /* Freq 5685 */
+	{138, 	(RF_A_BAND | RF_A_BAND_HB),	 0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x2F, 0, 0x0, 0x8, 0x1AAAA, 0x3}, /* Freq 5690 */
+	{139, 	(RF_A_BAND | RF_A_BAND_HB),	 0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x2F, 0, 0x0, 0x8, 0x1D555, 0x3}, /* Freq 5695 */
+	{140, 	(RF_A_BAND | RF_A_BAND_HB),	 0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x2F, 0, 0x0, 0x8, 0x20000, 0x3}, /* Freq 5700 */
+	{141, 	(RF_A_BAND | RF_A_BAND_HB),	 0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x2F, 0, 0x0, 0x8, 0x22AAA, 0x3}, /* Freq 5705 */
+	{142, 	(RF_A_BAND | RF_A_BAND_HB),	 0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x2F, 0, 0x0, 0x8, 0x25555, 0x3}, /* Freq 5710 */
+	{143, 	(RF_A_BAND | RF_A_BAND_HB),	 0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x2F, 0, 0x0, 0x8, 0x28000, 0x3}, /* Freq 5715 */
+	{144, 	(RF_A_BAND | RF_A_BAND_HB),	 0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x2F, 0, 0x0, 0x8, 0x2AAAA, 0x3}, /* Freq 5720 */
+	{145, 	(RF_A_BAND | RF_A_BAND_HB),	 0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x2F, 0, 0x0, 0x8, 0x2D555, 0x3}, /* Freq 5725 */
+	{146, 	(RF_A_BAND | RF_A_BAND_HB),	 0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x2F, 0, 0x0, 0x8, 0x30000, 0x3}, /* Freq 5730 */
+	{147, 	(RF_A_BAND | RF_A_BAND_HB),	 0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x2F, 0, 0x0, 0x8, 0x32AAA, 0x3}, /* Freq 5735 */
+	{148, 	(RF_A_BAND | RF_A_BAND_HB),	 0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x2F, 0, 0x0, 0x8, 0x35555, 0x3}, /* Freq 5740 */
+	{149, 	(RF_A_BAND | RF_A_BAND_HB),	 0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x2F, 0, 0x0, 0x8, 0x38000, 0x3}, /* Freq 5745 */
+	{150, 	(RF_A_BAND | RF_A_BAND_HB),	 0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x2F, 0, 0x0, 0x8, 0x3AAAA, 0x3}, /* Freq 5750 */
+	{151, 	(RF_A_BAND | RF_A_BAND_HB),	 0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x2F, 0, 0x0, 0x8, 0x3D555, 0x3}, /* Freq 5755 */
+	{152, 	(RF_A_BAND | RF_A_BAND_HB),	 0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x30, 0, 0x0, 0x8, 0x00000, 0x3}, /* Freq 5760 */
+	{153, 	(RF_A_BAND | RF_A_BAND_HB),	 0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x30, 0, 0x0, 0x8, 0x02AAA, 0x3}, /* Freq 5765 */
+	{154, 	(RF_A_BAND | RF_A_BAND_HB),	 0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x30, 0, 0x0, 0x8, 0x05555, 0x3}, /* Freq 5770 */
+	{155, 	(RF_A_BAND | RF_A_BAND_HB),	 0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x30, 0, 0x0, 0x8, 0x08000, 0x3}, /* Freq 5775 */
+	{156, 	(RF_A_BAND | RF_A_BAND_HB),	 0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x30, 0, 0x0, 0x8, 0x0AAAA, 0x3}, /* Freq 5780 */
+	{157, 	(RF_A_BAND | RF_A_BAND_HB),	 0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x30, 0, 0x0, 0x8, 0x0D555, 0x3}, /* Freq 5785 */
+	{158, 	(RF_A_BAND | RF_A_BAND_HB),	 0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x30, 0, 0x0, 0x8, 0x10000, 0x3}, /* Freq 5790 */
+	{159, 	(RF_A_BAND | RF_A_BAND_HB),	 0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x30, 0, 0x0, 0x8, 0x12AAA, 0x3}, /* Freq 5795 */
+	{160, 	(RF_A_BAND | RF_A_BAND_HB),	 0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x30, 0, 0x0, 0x8, 0x15555, 0x3}, /* Freq 5800 */
+	{161, 	(RF_A_BAND | RF_A_BAND_HB),	 0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x30, 0, 0x0, 0x8, 0x18000, 0x3}, /* Freq 5805 */
+	{162, 	(RF_A_BAND | RF_A_BAND_HB),	 0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x30, 0, 0x0, 0x8, 0x1AAAA, 0x3}, /* Freq 5810 */
+	{163, 	(RF_A_BAND | RF_A_BAND_HB),	 0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x30, 0, 0x0, 0x8, 0x1D555, 0x3}, /* Freq 5815 */
+	{164, 	(RF_A_BAND | RF_A_BAND_HB),	 0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x30, 0, 0x0, 0x8, 0x20000, 0x3}, /* Freq 5820 */
+	{165, 	(RF_A_BAND | RF_A_BAND_HB),	 0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x30, 0, 0x0, 0x8, 0x22AAA, 0x3}, /* Freq 5825 */
+	{166, 	(RF_A_BAND | RF_A_BAND_HB),	 0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x30, 0, 0x0, 0x8, 0x25555, 0x3}, /* Freq 5830 */
+	{167, 	(RF_A_BAND | RF_A_BAND_HB),	 0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x30, 0, 0x0, 0x8, 0x28000, 0x3}, /* Freq 5835 */
+	{168, 	(RF_A_BAND | RF_A_BAND_HB),	 0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x30, 0, 0x0, 0x8, 0x2AAAA, 0x3}, /* Freq 5840 */
+	{169, 	(RF_A_BAND | RF_A_BAND_HB),	 0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x30, 0, 0x0, 0x8, 0x2D555, 0x3}, /* Freq 5845 */
+	{170, 	(RF_A_BAND | RF_A_BAND_HB),	 0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x30, 0, 0x0, 0x8, 0x30000, 0x3}, /* Freq 5850 */
+	{171, 	(RF_A_BAND | RF_A_BAND_HB),	 0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x30, 0, 0x0, 0x8, 0x32AAA, 0x3}, /* Freq 5855 */
+	{172, 	(RF_A_BAND | RF_A_BAND_HB),	 0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x30, 0, 0x0, 0x8, 0x35555, 0x3}, /* Freq 5860 */
+	{173, 	(RF_A_BAND | RF_A_BAND_HB),	 0x02, 0x3F, 0x7F, 0xDD, 0xC3, 0x40, 0x0, 0x80, 0x0, 0/*0 -> 1*/, 0, 0, 0x30, 0, 0x0, 0x8, 0x38000, 0x3}, /* Freq 5865 */
+};
+
+static const u8 mt76x0_sdm_channel[] = {
+	183, 185, 43, 45, 54, 55, 57, 58, 102, 103, 105, 106, 115, 117, 126, 127, 129, 130, 139, 141, 150, 151, 153, 154, 163, 165
+};
+
+static const struct mt76x0_rf_switch_item mt76x0_rf_ext_pa_tab[] = {
+	{ MT_RF(6, 45),		RF_A_BAND_LB,	0x63},
+	{ MT_RF(6, 45),		RF_A_BAND_MB,	0x43},
+	{ MT_RF(6, 45),		RF_A_BAND_HB,	0x33},
+	{ MT_RF(6, 45),		RF_A_BAND_11J,	0x73},
+
+	{ MT_RF(6, 50),		RF_A_BAND_LB,	0x02},
+	{ MT_RF(6, 50),		RF_A_BAND_MB,	0x02},
+	{ MT_RF(6, 50),		RF_A_BAND_HB,	0x02},
+	{ MT_RF(6, 50),		RF_A_BAND_11J,	0x02},
+
+	{ MT_RF(6, 51),		RF_A_BAND_LB,	0x02},
+	{ MT_RF(6, 51),		RF_A_BAND_MB,	0x02},
+	{ MT_RF(6, 51),		RF_A_BAND_HB,	0x02},
+	{ MT_RF(6, 51),		RF_A_BAND_11J,	0x02},
+
+	{ MT_RF(6, 52),		RF_A_BAND_LB,	0x08},
+	{ MT_RF(6, 52),		RF_A_BAND_MB,	0x08},
+	{ MT_RF(6, 52),		RF_A_BAND_HB,	0x08},
+	{ MT_RF(6, 52),		RF_A_BAND_11J,	0x08},
+
+	{ MT_RF(6, 53),		RF_A_BAND_LB,	0x08},
+	{ MT_RF(6, 53),		RF_A_BAND_MB,	0x08},
+	{ MT_RF(6, 53),		RF_A_BAND_HB,	0x08},
+	{ MT_RF(6, 53),		RF_A_BAND_11J,	0x08},
+
+	{ MT_RF(6, 54),		RF_A_BAND_LB,	0x0A},
+	{ MT_RF(6, 54),		RF_A_BAND_MB,	0x0A},
+	{ MT_RF(6, 54),		RF_A_BAND_HB,	0x0A},
+	{ MT_RF(6, 54),		RF_A_BAND_11J,	0x0A},
+
+	{ MT_RF(6, 55),		RF_A_BAND_LB,	0x0A},
+	{ MT_RF(6, 55),		RF_A_BAND_MB,	0x0A},
+	{ MT_RF(6, 55),		RF_A_BAND_HB,	0x0A},
+	{ MT_RF(6, 55),		RF_A_BAND_11J,	0x0A},
+
+	{ MT_RF(6, 56),		RF_A_BAND_LB,	0x05},
+	{ MT_RF(6, 56),		RF_A_BAND_MB,	0x05},
+	{ MT_RF(6, 56),		RF_A_BAND_HB,	0x05},
+	{ MT_RF(6, 56),		RF_A_BAND_11J,	0x05},
+
+	{ MT_RF(6, 57),		RF_A_BAND_LB,	0x05},
+	{ MT_RF(6, 57),		RF_A_BAND_MB,	0x05},
+	{ MT_RF(6, 57),		RF_A_BAND_HB,	0x05},
+	{ MT_RF(6, 57),		RF_A_BAND_11J,	0x05},
+
+	{ MT_RF(6, 58),		RF_A_BAND_LB,	0x05},
+	{ MT_RF(6, 58),		RF_A_BAND_MB,	0x03},
+	{ MT_RF(6, 58),		RF_A_BAND_HB,	0x02},
+	{ MT_RF(6, 58),		RF_A_BAND_11J,	0x07},
+
+	{ MT_RF(6, 59),		RF_A_BAND_LB,	0x05},
+	{ MT_RF(6, 59),		RF_A_BAND_MB,	0x03},
+	{ MT_RF(6, 59),		RF_A_BAND_HB,	0x02},
+	{ MT_RF(6, 59),		RF_A_BAND_11J,	0x07},
+};
+
+#endif
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
new file mode 100644
index 000000000000..083028048723
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
@@ -0,0 +1,1008 @@
+/*
+ * (c) Copyright 2002-2010, Ralink Technology, Inc.
+ * Copyright (C) 2014 Felix Fietkau <nbd@openwrt.org>
+ * Copyright (C) 2015 Jakub Kicinski <kubakici@wp.pl>
+ * Copyright (C) 2018 Stanislaw Gruszka <stf_xl@wp.pl>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2
+ * as published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include "mt76x0.h"
+#include "mcu.h"
+#include "eeprom.h"
+#include "trace.h"
+#include "phy.h"
+#include "initvals.h"
+#include "initvals_phy.h"
+
+#include <linux/etherdevice.h>
+
+static int
+mt76x0_rf_csr_wr(struct mt76x0_dev *dev, u32 offset, u8 value)
+{
+	int ret = 0;
+	u8 bank, reg;
+
+	if (test_bit(MT76_REMOVED, &dev->mt76.state))
+		return -ENODEV;
+
+	bank = MT_RF_BANK(offset);
+	reg = MT_RF_REG(offset);
+
+	if (WARN_ON_ONCE(reg > 64) || WARN_ON_ONCE(bank) > 8)
+		return -EINVAL;
+
+	mutex_lock(&dev->reg_atomic_mutex);
+
+	if (!mt76_poll(dev, MT_RF_CSR_CFG, MT_RF_CSR_CFG_KICK, 0, 100)) {
+		ret = -ETIMEDOUT;
+		goto out;
+	}
+
+	mt76_wr(dev, MT_RF_CSR_CFG,
+		   FIELD_PREP(MT_RF_CSR_CFG_DATA, value) |
+		   FIELD_PREP(MT_RF_CSR_CFG_REG_BANK, bank) |
+		   FIELD_PREP(MT_RF_CSR_CFG_REG_ID, reg) |
+		   MT_RF_CSR_CFG_WR |
+		   MT_RF_CSR_CFG_KICK);
+	trace_rf_write(&dev->mt76, bank, offset, value);
+out:
+	mutex_unlock(&dev->reg_atomic_mutex);
+
+	if (ret < 0)
+		dev_err(dev->mt76.dev, "Error: RF write %d:%d failed:%d!!\n",
+			bank, reg, ret);
+
+	return ret;
+}
+
+static int
+mt76x0_rf_csr_rr(struct mt76x0_dev *dev, u32 offset)
+{
+	int ret = -ETIMEDOUT;
+	u32 val;
+	u8 bank, reg;
+
+	if (test_bit(MT76_REMOVED, &dev->mt76.state))
+		return -ENODEV;
+
+	bank = MT_RF_BANK(offset);
+	reg = MT_RF_REG(offset);
+
+	if (WARN_ON_ONCE(reg > 64) || WARN_ON_ONCE(bank) > 8)
+		return -EINVAL;
+
+	mutex_lock(&dev->reg_atomic_mutex);
+
+	if (!mt76_poll(dev, MT_RF_CSR_CFG, MT_RF_CSR_CFG_KICK, 0, 100))
+		goto out;
+
+	mt76_wr(dev, MT_RF_CSR_CFG,
+		   FIELD_PREP(MT_RF_CSR_CFG_REG_BANK, bank) |
+		   FIELD_PREP(MT_RF_CSR_CFG_REG_ID, reg) |
+		   MT_RF_CSR_CFG_KICK);
+
+	if (!mt76_poll(dev, MT_RF_CSR_CFG, MT_RF_CSR_CFG_KICK, 0, 100))
+		goto out;
+
+	val = mt76_rr(dev, MT_RF_CSR_CFG);
+	if (FIELD_GET(MT_RF_CSR_CFG_REG_ID, val) == reg &&
+	    FIELD_GET(MT_RF_CSR_CFG_REG_BANK, val) == bank) {
+		ret = FIELD_GET(MT_RF_CSR_CFG_DATA, val);
+		trace_rf_read(&dev->mt76, bank, offset, ret);
+	}
+out:
+	mutex_unlock(&dev->reg_atomic_mutex);
+
+	if (ret < 0)
+		dev_err(dev->mt76.dev, "Error: RF read %d:%d failed:%d!!\n",
+			bank, reg, ret);
+
+	return ret;
+}
+
+static int
+rf_wr(struct mt76x0_dev *dev, u32 offset, u8 val)
+{
+	if (test_bit(MT76_STATE_MCU_RUNNING, &dev->mt76.state)) {
+		struct mt76_reg_pair pair = {
+			.reg = offset,
+			.value = val,
+		};
+
+		return mt76x0_write_reg_pairs(dev, MT_MCU_MEMMAP_RF, &pair, 1);
+	} else {
+		WARN_ON_ONCE(1);
+		return mt76x0_rf_csr_wr(dev, offset, val);
+	}
+}
+
+static int
+rf_rr(struct mt76x0_dev *dev, u32 offset)
+{
+	int ret;
+	u32 val;
+
+	if (test_bit(MT76_STATE_MCU_RUNNING, &dev->mt76.state)) {
+		struct mt76_reg_pair pair = {
+			.reg = offset,
+		};
+
+		ret = mt76x0_read_reg_pairs(dev, MT_MCU_MEMMAP_RF, &pair, 1);
+		val = pair.value;
+	} else {
+		WARN_ON_ONCE(1);
+		ret = val = mt76x0_rf_csr_rr(dev, offset);
+	}
+
+	return (ret < 0) ? ret : val;
+}
+
+static int
+rf_rmw(struct mt76x0_dev *dev, u32 offset, u8 mask, u8 val)
+{
+	int ret;
+
+	ret = rf_rr(dev, offset);
+	if (ret < 0)
+		return ret;
+	val |= ret & ~mask;
+	ret = rf_wr(dev, offset, val);
+	if (ret)
+		return ret;
+
+	return val;
+}
+
+static int
+rf_set(struct mt76x0_dev *dev, u32 offset, u8 val)
+{
+	return rf_rmw(dev, offset, 0, val);
+}
+
+#if 0
+static int
+rf_clear(struct mt76x0_dev *dev, u32 offset, u8 mask)
+{
+	return rf_rmw(dev, offset, mask, 0);
+}
+#endif
+
+#define RF_RANDOM_WRITE(dev, tab) \
+	mt76x0_write_reg_pairs(dev, MT_MCU_MEMMAP_RF, tab, ARRAY_SIZE(tab));
+
+int mt76x0_wait_bbp_ready(struct mt76x0_dev *dev)
+{
+	int i = 20;
+	u32 val;
+
+	do {
+		val = mt76_rr(dev, MT_BBP(CORE, 0));
+		printk("BBP version %08x\n", val);
+		if (val && ~val)
+			break;
+	} while (--i);
+
+	if (!i) {
+		dev_err(dev->mt76.dev, "Error: BBP is not ready\n");
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static void
+mt76x0_bbp_set_ctrlch(struct mt76x0_dev *dev, enum nl80211_chan_width width,
+		      u8 ctrl)
+{
+	int core_val, agc_val;
+
+	switch (width) {
+	case NL80211_CHAN_WIDTH_80:
+		core_val = 3;
+		agc_val = 7;
+		break;
+	case NL80211_CHAN_WIDTH_40:
+		core_val = 2;
+		agc_val = 3;
+		break;
+	default:
+		core_val = 0;
+		agc_val = 1;
+		break;
+	}
+
+	mt76_rmw_field(dev, MT_BBP(CORE, 1), MT_BBP_CORE_R1_BW, core_val);
+	mt76_rmw_field(dev, MT_BBP(AGC, 0), MT_BBP_AGC_R0_BW, agc_val);
+	mt76_rmw_field(dev, MT_BBP(AGC, 0), MT_BBP_AGC_R0_CTRL_CHAN, ctrl);
+	mt76_rmw_field(dev, MT_BBP(TXBE, 0), MT_BBP_TXBE_R0_CTRL_CHAN, ctrl);
+}
+
+int mt76x0_phy_get_rssi(struct mt76x0_dev *dev, struct mt76x0_rxwi *rxwi)
+{
+	s8 lna_gain, rssi_offset;
+	int val;
+
+	if (dev->mt76.chandef.chan->band == NL80211_BAND_2GHZ) {
+		lna_gain = dev->ee->lna_gain_2ghz;
+		rssi_offset = dev->ee->rssi_offset_2ghz[0];
+	} else {
+		lna_gain = dev->ee->lna_gain_5ghz[0];
+		rssi_offset = dev->ee->rssi_offset_5ghz[0];
+	}
+
+	val = rxwi->rssi[0] + rssi_offset - lna_gain;
+
+	return val;
+}
+
+static void mt76x0_vco_cal(struct mt76x0_dev *dev, u8 channel)
+{
+	u8 val;
+
+	val = rf_rr(dev, MT_RF(0, 4));
+	if ((val & 0x70) != 0x30)
+		return;
+
+	/*
+	 * Calibration Mode - Open loop, closed loop, and amplitude:
+	 * B0.R06.[0]: 1
+	 * B0.R06.[3:1] bp_close_code: 100
+	 * B0.R05.[7:0] bp_open_code: 0x0
+	 * B0.R04.[2:0] cal_bits: 000
+	 * B0.R03.[2:0] startup_time: 011
+	 * B0.R03.[6:4] settle_time:
+	 *  80MHz channel: 110
+	 *  40MHz channel: 101
+	 *  20MHz channel: 100
+	 */
+	val = rf_rr(dev, MT_RF(0, 6));
+	val &= ~0xf;
+	val |= 0x09;
+	rf_wr(dev, MT_RF(0, 6), val);
+
+	val = rf_rr(dev, MT_RF(0, 5));
+	if (val != 0)
+		rf_wr(dev, MT_RF(0, 5), 0x0);
+
+	val = rf_rr(dev, MT_RF(0, 4));
+	val &= ~0x07;
+	rf_wr(dev, MT_RF(0, 4), val);
+
+	val = rf_rr(dev, MT_RF(0, 3));
+	val &= ~0x77;
+	if (channel == 1 || channel == 7 || channel == 9 || channel >= 13) {
+		val |= 0x63;
+	} else if (channel == 3 || channel == 4 || channel == 10) {
+		val |= 0x53;
+	} else if (channel == 2 || channel == 5 || channel == 6 ||
+		   channel == 8 || channel == 11 || channel == 12) {
+		val |= 0x43;
+	} else {
+		WARN(1, "Unknown channel %u\n", channel);
+		return;
+	}
+	rf_wr(dev, MT_RF(0, 3), val);
+
+	/* TODO replace by mt76x0_rf_set(dev, MT_RF(0, 4), BIT(7)); */
+	val = rf_rr(dev, MT_RF(0, 4));
+	val = ((val & ~(0x80)) | 0x80);
+	rf_wr(dev, MT_RF(0, 4), val);
+
+	msleep(2);
+}
+
+static void
+mt76x0_mac_set_ctrlch(struct mt76x0_dev *dev, bool primary_upper)
+{
+	mt76_rmw_field(dev, MT_TX_BAND_CFG, MT_TX_BAND_CFG_UPPER_40M,
+		       primary_upper);
+}
+
+static void
+mt76x0_phy_set_band(struct mt76x0_dev *dev, enum nl80211_band band)
+{
+	switch (band) {
+	case NL80211_BAND_2GHZ:
+		RF_RANDOM_WRITE(dev, mt76x0_rf_2g_channel_0_tab);
+
+		rf_wr(dev, MT_RF(5, 0), 0x45);
+		rf_wr(dev, MT_RF(6, 0), 0x44);
+
+		mt76_set(dev, MT_TX_BAND_CFG, MT_TX_BAND_CFG_2G);
+		mt76_clear(dev, MT_TX_BAND_CFG, MT_TX_BAND_CFG_5G);
+
+		mt76_wr(dev, MT_TX_ALC_VGA3, 0x00050007);
+		mt76_wr(dev, MT_TX0_RF_GAIN_CORR, 0x003E0002);
+		break;
+	case NL80211_BAND_5GHZ:
+		RF_RANDOM_WRITE(dev, mt76x0_rf_5g_channel_0_tab);
+
+		rf_wr(dev, MT_RF(5, 0), 0x44);
+		rf_wr(dev, MT_RF(6, 0), 0x45);
+
+		mt76_clear(dev, MT_TX_BAND_CFG, MT_TX_BAND_CFG_2G);
+		mt76_set(dev, MT_TX_BAND_CFG, MT_TX_BAND_CFG_5G);
+
+		mt76_wr(dev, MT_TX_ALC_VGA3, 0x00000005);
+		mt76_wr(dev, MT_TX0_RF_GAIN_CORR, 0x01010102);
+		break;
+	default:
+		break;
+	}
+}
+
+#define EXT_PA_2G_5G            0x0
+#define EXT_PA_5G_ONLY          0x1
+#define EXT_PA_2G_ONLY          0x2
+#define INT_PA_2G_5G            0x3
+
+static void
+mt76x0_phy_set_chan_rf_params(struct mt76x0_dev *dev, u8 channel, u16 rf_bw_band)
+{
+	u16 rf_band = rf_bw_band & 0xff00;
+	u16 rf_bw = rf_bw_band & 0x00ff;
+	u32 mac_reg;
+	u8 rf_val;
+	int i;
+	bool bSDM = false;
+	const struct mt76x0_freq_item *freq_item;
+
+	for (i = 0; i < ARRAY_SIZE(mt76x0_sdm_channel); i++) {
+		if (channel == mt76x0_sdm_channel[i]) {
+			bSDM = true;
+			break;
+		}
+	}
+
+	for (i = 0; i < ARRAY_SIZE(mt76x0_frequency_plan); i++) {
+		if (channel == mt76x0_frequency_plan[i].channel) {
+			rf_band = mt76x0_frequency_plan[i].band;
+
+			if (bSDM)
+				freq_item = &(mt76x0_sdm_frequency_plan[i]);
+			else
+				freq_item = &(mt76x0_frequency_plan[i]);
+
+			rf_wr(dev, MT_RF(0, 37), freq_item->pllR37);
+			rf_wr(dev, MT_RF(0, 36), freq_item->pllR36);
+			rf_wr(dev, MT_RF(0, 35), freq_item->pllR35);
+			rf_wr(dev, MT_RF(0, 34), freq_item->pllR34);
+			rf_wr(dev, MT_RF(0, 33), freq_item->pllR33);
+
+			rf_val = rf_rr(dev, MT_RF(0, 32));
+			rf_val &= ~0xE0;
+			rf_val |= freq_item->pllR32_b7b5;
+			rf_wr(dev, MT_RF(0, 32), rf_val);
+
+			/* R32<4:0> pll_den: (Denomina - 8) */
+			rf_val = rf_rr(dev, MT_RF(0, 32));
+			rf_val &= ~0x1F;
+			rf_val |= freq_item->pllR32_b4b0;
+			rf_wr(dev, MT_RF(0, 32), rf_val);
+
+			/* R31<7:5> */
+			rf_val = rf_rr(dev, MT_RF(0, 31));
+			rf_val &= ~0xE0;
+			rf_val |= freq_item->pllR31_b7b5;
+			rf_wr(dev, MT_RF(0, 31), rf_val);
+
+			/* R31<4:0> pll_k(Nominator) */
+			rf_val = rf_rr(dev, MT_RF(0, 31));
+			rf_val &= ~0x1F;
+			rf_val |= freq_item->pllR31_b4b0;
+			rf_wr(dev, MT_RF(0, 31), rf_val);
+
+			/* R30<7> sdm_reset_n */
+			rf_val = rf_rr(dev, MT_RF(0, 30));
+			rf_val &= ~0x80;
+			if (bSDM) {
+				rf_wr(dev, MT_RF(0, 30), rf_val);
+				rf_val |= 0x80;
+				rf_wr(dev, MT_RF(0, 30), rf_val);
+			} else {
+				rf_val |= freq_item->pllR30_b7;
+				rf_wr(dev, MT_RF(0, 30), rf_val);
+			}
+
+			/* R30<6:2> sdmmash_prbs,sin */
+			rf_val = rf_rr(dev, MT_RF(0, 30));
+			rf_val &= ~0x7C;
+			rf_val |= freq_item->pllR30_b6b2;
+			rf_wr(dev, MT_RF(0, 30), rf_val);
+
+			/* R30<1> sdm_bp */
+			rf_val = rf_rr(dev, MT_RF(0, 30));
+			rf_val &= ~0x02;
+			rf_val |= (freq_item->pllR30_b1 << 1);
+			rf_wr(dev, MT_RF(0, 30), rf_val);
+
+			/* R30<0> R29<7:0> (hex) pll_n */
+			rf_val = freq_item->pll_n & 0x00FF;
+			rf_wr(dev, MT_RF(0, 29), rf_val);
+
+			rf_val = rf_rr(dev, MT_RF(0, 30));
+			rf_val &= ~0x1;
+			rf_val |= ((freq_item->pll_n >> 8) & 0x0001);
+			rf_wr(dev, MT_RF(0, 30), rf_val);
+
+			/* R28<7:6> isi_iso */
+			rf_val = rf_rr(dev, MT_RF(0, 28));
+			rf_val &= ~0xC0;
+			rf_val |= freq_item->pllR28_b7b6;
+			rf_wr(dev, MT_RF(0, 28), rf_val);
+
+			/* R28<5:4> pfd_dly */
+			rf_val = rf_rr(dev, MT_RF(0, 28));
+			rf_val &= ~0x30;
+			rf_val |= freq_item->pllR28_b5b4;
+			rf_wr(dev, MT_RF(0, 28), rf_val);
+
+			/* R28<3:2> clksel option */
+			rf_val = rf_rr(dev, MT_RF(0, 28));
+			rf_val &= ~0x0C;
+			rf_val |= freq_item->pllR28_b3b2;
+			rf_wr(dev, MT_RF(0, 28), rf_val);
+
+			/* R28<1:0> R27<7:0> R26<7:0> (hex) sdm_k */
+			rf_val = freq_item->pll_sdm_k & 0x000000FF;
+			rf_wr(dev, MT_RF(0, 26), rf_val);
+
+			rf_val = ((freq_item->pll_sdm_k >> 8) & 0x000000FF);
+			rf_wr(dev, MT_RF(0, 27), rf_val);
+
+			rf_val = rf_rr(dev, MT_RF(0, 28));
+			rf_val &= ~0x3;
+			rf_val |= ((freq_item->pll_sdm_k >> 16) & 0x0003);
+			rf_wr(dev, MT_RF(0, 28), rf_val);
+
+			/* R24<1:0> xo_div */
+			rf_val = rf_rr(dev, MT_RF(0, 24));
+			rf_val &= ~0x3;
+			rf_val |= freq_item->pllR24_b1b0;
+			rf_wr(dev, MT_RF(0, 24), rf_val);
+
+			break;
+		}
+	}
+
+	for (i = 0; i < ARRAY_SIZE(mt76x0_rf_bw_switch_tab); i++) {
+		if (rf_bw == mt76x0_rf_bw_switch_tab[i].bw_band) {
+			rf_wr(dev, mt76x0_rf_bw_switch_tab[i].rf_bank_reg,
+				   mt76x0_rf_bw_switch_tab[i].value);
+		} else if ((rf_bw == (mt76x0_rf_bw_switch_tab[i].bw_band & 0xFF)) &&
+			   (rf_band & mt76x0_rf_bw_switch_tab[i].bw_band)) {
+			rf_wr(dev, mt76x0_rf_bw_switch_tab[i].rf_bank_reg,
+				   mt76x0_rf_bw_switch_tab[i].value);
+		}
+	}
+
+	for (i = 0; i < ARRAY_SIZE(mt76x0_rf_band_switch_tab); i++) {
+		if (mt76x0_rf_band_switch_tab[i].bw_band & rf_band) {
+			rf_wr(dev, mt76x0_rf_band_switch_tab[i].rf_bank_reg,
+				   mt76x0_rf_band_switch_tab[i].value);
+		}
+	}
+
+	mac_reg = mt76_rr(dev, MT_RF_MISC);
+	mac_reg &= ~0xC; /* Clear 0x518[3:2] */
+	mt76_wr(dev, MT_RF_MISC, mac_reg);
+
+	if (dev->ee->pa_type == INT_PA_2G_5G ||
+	    (dev->ee->pa_type == EXT_PA_5G_ONLY && (rf_band & RF_G_BAND)) ||
+	    (dev->ee->pa_type == EXT_PA_2G_ONLY && (rf_band & RF_A_BAND))) {
+		; /* Internal PA - nothing to do. */
+	} else {
+		/*
+			MT_RF_MISC (offset: 0x0518)
+			[2]1'b1: enable external A band PA, 1'b0: disable external A band PA
+			[3]1'b1: enable external G band PA, 1'b0: disable external G band PA
+		*/
+		if (rf_band & RF_A_BAND) {
+			mac_reg = mt76_rr(dev, MT_RF_MISC);
+			mac_reg |= 0x4;
+			mt76_wr(dev, MT_RF_MISC, mac_reg);
+		} else {
+			mac_reg = mt76_rr(dev, MT_RF_MISC);
+			mac_reg |= 0x8;
+			mt76_wr(dev, MT_RF_MISC, mac_reg);
+		}
+
+		/* External PA */
+		for (i = 0; i < ARRAY_SIZE(mt76x0_rf_ext_pa_tab); i++)
+			if (mt76x0_rf_ext_pa_tab[i].bw_band & rf_band)
+				rf_wr(dev, mt76x0_rf_ext_pa_tab[i].rf_bank_reg,
+					   mt76x0_rf_ext_pa_tab[i].value);
+	}
+
+	if (rf_band & RF_G_BAND) {
+		mt76_wr(dev, MT_TX0_RF_GAIN_ATTEN, 0x63707400);
+		/* Set Atten mode = 2 For G band, Disable Tx Inc dcoc. */
+		mac_reg = mt76_rr(dev, MT_TX_ALC_CFG_1);
+		mac_reg &= 0x896400FF;
+		mt76_wr(dev, MT_TX_ALC_CFG_1, mac_reg);
+	} else {
+		mt76_wr(dev, MT_TX0_RF_GAIN_ATTEN, 0x686A7800);
+		/* Set Atten mode = 0 For Ext A band, Disable Tx Inc dcoc Cal. */
+		mac_reg = mt76_rr(dev, MT_TX_ALC_CFG_1);
+		mac_reg &= 0x890400FF;
+		mt76_wr(dev, MT_TX_ALC_CFG_1, mac_reg);
+	}
+}
+
+static void
+mt76x0_phy_set_chan_bbp_params(struct mt76x0_dev *dev, u8 channel, u16 rf_bw_band)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(mt76x0_bbp_switch_tab); i++) {
+		const struct mt76x0_bbp_switch_item *item = &mt76x0_bbp_switch_tab[i];
+		const struct mt76_reg_pair *pair = &item->reg_pair;
+
+		if ((rf_bw_band & item->bw_band) != rf_bw_band)
+			continue;
+
+		if (pair->reg == MT_BBP(AGC, 8)) {
+			u32 val = pair->value;
+			u8 gain = FIELD_GET(MT_BBP_AGC_GAIN, val);
+
+			if (channel > 14) {
+				if (channel < 100)
+					gain -= dev->ee->lna_gain_5ghz[0]*2;
+				else if (channel < 137)
+					gain -= dev->ee->lna_gain_5ghz[1]*2;
+				else
+					gain -= dev->ee->lna_gain_5ghz[2]*2;
+
+			} else {
+				gain -= dev->ee->lna_gain_2ghz*2;
+			}
+
+			val &= ~MT_BBP_AGC_GAIN;
+			val |= FIELD_PREP(MT_BBP_AGC_GAIN, gain);
+			mt76_wr(dev, pair->reg, val);
+		} else {
+			mt76_wr(dev, pair->reg, pair->value);
+		}
+	}
+}
+
+#if 0
+static void
+mt76x0_extra_power_over_mac(struct mt76x0_dev *dev)
+{
+	u32 val;
+
+	val = ((mt76_rr(dev, MT_TX_PWR_CFG_1) & 0x00003f00) >> 8);
+	val |= ((mt76_rr(dev, MT_TX_PWR_CFG_2) & 0x00003f00) << 8);
+	mt76_wr(dev, MT_TX_PWR_CFG_7, val);
+
+	/* TODO: fix VHT */
+	val = ((mt76_rr(dev, MT_TX_PWR_CFG_3) & 0x0000ff00) >> 8);
+	mt76_wr(dev, MT_TX_PWR_CFG_8, val);
+
+	val = ((mt76_rr(dev, MT_TX_PWR_CFG_4) & 0x0000ff00) >> 8);
+	mt76_wr(dev, MT_TX_PWR_CFG_9, val);
+}
+
+static void
+mt76x0_phy_set_tx_power(struct mt76x0_dev *dev, u8 channel, u8 rf_bw_band)
+{
+	u32 val;
+	int i;
+	int bw = (rf_bw_band & RF_BW_20) ? 0 : 1;
+
+	for (i = 0; i < 4; i++) {
+		if (channel <= 14)
+			val = dev->ee->tx_pwr_cfg_2g[i][bw];
+		else
+			val = dev->ee->tx_pwr_cfg_5g[i][bw];
+
+		mt76_wr(dev, MT_TX_PWR_CFG_0 + 4*i, val);
+	}
+
+	mt76x0_extra_power_over_mac(dev);
+}
+#endif
+
+static void
+mt76x0_bbp_set_bw(struct mt76x0_dev *dev, enum nl80211_chan_width width)
+{
+	enum { BW_20 = 0, BW_40 = 1, BW_80 = 2, BW_10 = 4};
+	int bw;
+
+	switch (width) {
+	default:
+	case NL80211_CHAN_WIDTH_20_NOHT:
+	case NL80211_CHAN_WIDTH_20:
+		bw = BW_20;
+		break;
+	case NL80211_CHAN_WIDTH_40:
+		bw = BW_40;
+		break;
+	case NL80211_CHAN_WIDTH_80:
+		bw = BW_80;
+		break;
+	case NL80211_CHAN_WIDTH_10:
+		bw = BW_10;
+		break;
+	case NL80211_CHAN_WIDTH_80P80:
+	case NL80211_CHAN_WIDTH_160:
+	case NL80211_CHAN_WIDTH_5:
+		/* TODO error */
+		return ;
+	}
+
+	mt76x0_mcu_function_select(dev, BW_SETTING, bw);
+}
+
+static void
+mt76x0_phy_set_chan_pwr(struct mt76x0_dev *dev, u8 channel)
+{
+	static const int mt76x0_tx_pwr_ch_list[] = {
+		1,2,3,4,5,6,7,8,9,10,11,12,13,14,
+		36,38,40,44,46,48,52,54,56,60,62,64,
+		100,102,104,108,110,112,116,118,120,124,126,128,132,134,136,140,
+		149,151,153,157,159,161,165,167,169,171,173,
+		42,58,106,122,155
+	};
+	int i;
+	u32 val;
+
+	for (i = 0; i < ARRAY_SIZE(mt76x0_tx_pwr_ch_list); i++)
+		if (mt76x0_tx_pwr_ch_list[i] == channel)
+			break;
+
+	if (WARN_ON(i == ARRAY_SIZE(mt76x0_tx_pwr_ch_list)))
+		return;
+
+	val = mt76_rr(dev, MT_TX_ALC_CFG_0);
+	val &= ~0x3f3f;
+	val |= dev->ee->tx_pwr_per_chan[i];
+	val |= 0x2f2f << 16;
+	mt76_wr(dev, MT_TX_ALC_CFG_0, val);
+}
+
+static int
+__mt76x0_phy_set_channel(struct mt76x0_dev *dev,
+		       struct cfg80211_chan_def *chandef)
+{
+	u32 ext_cca_chan[4] = {
+		[0] = FIELD_PREP(MT_EXT_CCA_CFG_CCA0, 0) |
+		      FIELD_PREP(MT_EXT_CCA_CFG_CCA1, 1) |
+		      FIELD_PREP(MT_EXT_CCA_CFG_CCA2, 2) |
+		      FIELD_PREP(MT_EXT_CCA_CFG_CCA3, 3) |
+		      FIELD_PREP(MT_EXT_CCA_CFG_CCA_MASK, BIT(0)),
+		[1] = FIELD_PREP(MT_EXT_CCA_CFG_CCA0, 1) |
+		      FIELD_PREP(MT_EXT_CCA_CFG_CCA1, 0) |
+		      FIELD_PREP(MT_EXT_CCA_CFG_CCA2, 2) |
+		      FIELD_PREP(MT_EXT_CCA_CFG_CCA3, 3) |
+		      FIELD_PREP(MT_EXT_CCA_CFG_CCA_MASK, BIT(1)),
+		[2] = FIELD_PREP(MT_EXT_CCA_CFG_CCA0, 2) |
+		      FIELD_PREP(MT_EXT_CCA_CFG_CCA1, 3) |
+		      FIELD_PREP(MT_EXT_CCA_CFG_CCA2, 1) |
+		      FIELD_PREP(MT_EXT_CCA_CFG_CCA3, 0) |
+		      FIELD_PREP(MT_EXT_CCA_CFG_CCA_MASK, BIT(2)),
+		[3] = FIELD_PREP(MT_EXT_CCA_CFG_CCA0, 3) |
+		      FIELD_PREP(MT_EXT_CCA_CFG_CCA1, 2) |
+		      FIELD_PREP(MT_EXT_CCA_CFG_CCA2, 1) |
+		      FIELD_PREP(MT_EXT_CCA_CFG_CCA3, 0) |
+		      FIELD_PREP(MT_EXT_CCA_CFG_CCA_MASK, BIT(3)),
+	};
+	bool scan = test_bit(MT76_SCANNING, &dev->mt76.state);
+	int ch_group_index, freq, freq1;
+	u8 channel;
+	u32 val;
+	u16 rf_bw_band;
+
+	freq = chandef->chan->center_freq;
+	freq1 = chandef->center_freq1;
+	channel = chandef->chan->hw_value;
+	rf_bw_band = (channel <= 14) ? RF_G_BAND : RF_A_BAND;
+
+	switch (chandef->width) {
+	case NL80211_CHAN_WIDTH_40:
+		if (freq1 > freq)
+			ch_group_index = 0;
+		else
+			ch_group_index = 1;
+		channel += 2 - ch_group_index * 4;
+		rf_bw_band |= RF_BW_40;
+		break;
+	case NL80211_CHAN_WIDTH_80:
+		ch_group_index = (freq - freq1 + 30) / 20;
+		if (WARN_ON(ch_group_index < 0 || ch_group_index > 3))
+			ch_group_index = 0;
+		channel += 6 - ch_group_index * 4;
+		rf_bw_band |= RF_BW_80;
+		break;
+	default:
+		ch_group_index = 0;
+		rf_bw_band |= RF_BW_20;
+		break;
+	}
+
+	mt76x0_bbp_set_bw(dev, chandef->width);
+	mt76x0_bbp_set_ctrlch(dev, chandef->width, ch_group_index);
+	mt76x0_mac_set_ctrlch(dev, ch_group_index & 1);
+
+	mt76_rmw(dev, MT_EXT_CCA_CFG,
+		 (MT_EXT_CCA_CFG_CCA0 |
+		  MT_EXT_CCA_CFG_CCA1 |
+		  MT_EXT_CCA_CFG_CCA2 |
+		  MT_EXT_CCA_CFG_CCA3 |
+		  MT_EXT_CCA_CFG_CCA_MASK),
+		 ext_cca_chan[ch_group_index]);
+
+	mt76x0_phy_set_band(dev, chandef->chan->band);
+	mt76x0_phy_set_chan_rf_params(dev, channel, rf_bw_band);
+
+	/* set Japan Tx filter at channel 14 */
+	val = mt76_rr(dev, MT_BBP(CORE, 1));
+	if (channel == 14)
+		val |= 0x20;
+	else
+		val &= ~0x20;
+	mt76_wr(dev, MT_BBP(CORE, 1), val);
+
+	mt76x0_phy_set_chan_bbp_params(dev, channel, rf_bw_band);
+
+	/* Vendor driver don't do it */
+	/* mt76x0_phy_set_tx_power(dev, channel, rf_bw_band); */
+
+	if (scan)
+		mt76x0_vco_cal(dev, channel);
+
+	mt76x0_mcu_calibrate(dev, MCU_CAL_RXDCOC, 1);
+	mt76x0_phy_set_chan_pwr(dev, channel);
+
+	dev->mt76.chandef = *chandef;
+	return 0;
+}
+
+int mt76x0_phy_set_channel(struct mt76x0_dev *dev,
+			   struct cfg80211_chan_def *chandef)
+{
+	int ret;
+
+	mutex_lock(&dev->hw_atomic_mutex);
+	ret = __mt76x0_phy_set_channel(dev, chandef);
+	mutex_unlock(&dev->hw_atomic_mutex);
+
+	return ret;
+}
+
+void mt76x0_phy_recalibrate_after_assoc(struct mt76x0_dev *dev)
+{
+	u32 tx_alc, reg_val;
+	u8 channel = dev->mt76.chandef.chan->hw_value;
+	int is_5ghz = (dev->mt76.chandef.chan->band == NL80211_BAND_5GHZ) ? 1 : 0;
+
+	mt76x0_mcu_calibrate(dev, MCU_CAL_R, 0);
+
+	mt76x0_vco_cal(dev, channel);
+
+	tx_alc = mt76_rr(dev, MT_TX_ALC_CFG_0);
+	mt76_wr(dev, MT_TX_ALC_CFG_0, 0);
+	usleep_range(500, 700);
+
+	reg_val = mt76_rr(dev, 0x2124);
+	reg_val &= 0xffffff7e;
+	mt76_wr(dev, 0x2124, reg_val);
+
+	mt76x0_mcu_calibrate(dev, MCU_CAL_RXDCOC, 0);
+
+	mt76x0_mcu_calibrate(dev, MCU_CAL_LC, is_5ghz);
+	mt76x0_mcu_calibrate(dev, MCU_CAL_LOFT, is_5ghz);
+	mt76x0_mcu_calibrate(dev, MCU_CAL_TXIQ, is_5ghz);
+	mt76x0_mcu_calibrate(dev, MCU_CAL_TX_GROUP_DELAY, is_5ghz);
+	mt76x0_mcu_calibrate(dev, MCU_CAL_RXIQ, is_5ghz);
+	mt76x0_mcu_calibrate(dev, MCU_CAL_RX_GROUP_DELAY, is_5ghz);
+
+	mt76_wr(dev, 0x2124, reg_val);
+	mt76_wr(dev, MT_TX_ALC_CFG_0, tx_alc);
+	msleep(100);
+
+	mt76x0_mcu_calibrate(dev, MCU_CAL_RXDCOC, 1);
+}
+
+void mt76x0_agc_save(struct mt76x0_dev *dev)
+{
+	/* Only one RX path */
+	dev->agc_save = FIELD_GET(MT_BBP_AGC_GAIN, mt76_rr(dev, MT_BBP(AGC, 8)));
+}
+
+void mt76x0_agc_restore(struct mt76x0_dev *dev)
+{
+	mt76_rmw_field(dev, MT_BBP(AGC, 8), MT_BBP_AGC_GAIN, dev->agc_save);
+}
+
+static void mt76x0_temp_sensor(struct mt76x0_dev *dev)
+{
+	u8 rf_b7_73, rf_b0_66, rf_b0_67;
+	int cycle, temp;
+	u32 val;
+	s32 sval;
+
+	rf_b7_73 = rf_rr(dev, MT_RF(7, 73));
+	rf_b0_66 = rf_rr(dev, MT_RF(0, 66));
+	rf_b0_67 = rf_rr(dev, MT_RF(0, 73));
+
+	rf_wr(dev, MT_RF(7, 73), 0x02);
+	rf_wr(dev, MT_RF(0, 66), 0x23);
+	rf_wr(dev, MT_RF(0, 73), 0x01);
+
+	mt76_wr(dev, MT_BBP(CORE, 34), 0x00080055);
+
+	for (cycle = 0; cycle < 2000; cycle++) {
+		val = mt76_rr(dev, MT_BBP(CORE, 34));
+		if (!(val & 0x10))
+			break;
+		udelay(3);
+	}
+
+	if (cycle >= 2000) {
+		val &= 0x10;
+		mt76_wr(dev, MT_BBP(CORE, 34), val);
+		goto done;
+	}
+
+	sval = mt76_rr(dev, MT_BBP(CORE, 35)) & 0xff;
+	if (!(sval & 0x80))
+		sval &= 0x7f; /* Positive */
+	else
+		sval |= 0xffffff00; /* Negative */
+
+	temp = (35 * (sval - dev->ee->temp_off))/ 10 + 25;
+
+done:
+	rf_wr(dev, MT_RF(7, 73), rf_b7_73);
+	rf_wr(dev, MT_RF(0, 66), rf_b0_66);
+	rf_wr(dev, MT_RF(0, 73), rf_b0_67);
+}
+
+static void mt76x0_dynamic_vga_tuning(struct mt76x0_dev *dev)
+{
+	u32 val, init_vga;
+
+	init_vga = (dev->mt76.chandef.chan->band == NL80211_BAND_5GHZ) ? 0x54 : 0x4E;
+	if (dev->avg_rssi > -60)
+		init_vga -= 0x20;
+	else if (dev->avg_rssi > -70)
+		init_vga -= 0x10;
+
+	val = mt76_rr(dev, MT_BBP(AGC, 8));
+	val &= 0xFFFF80FF;
+	val |= init_vga << 8;
+	mt76_wr(dev, MT_BBP(AGC,8), val);
+}
+
+static void mt76x0_phy_calibrate(struct work_struct *work)
+{
+	struct mt76x0_dev *dev = container_of(work, struct mt76x0_dev,
+					    cal_work.work);
+
+	mt76x0_dynamic_vga_tuning(dev);
+	mt76x0_temp_sensor(dev);
+
+	ieee80211_queue_delayed_work(dev->mt76.hw, &dev->cal_work,
+				     MT_CALIBRATE_INTERVAL);
+}
+
+void mt76x0_phy_con_cal_onoff(struct mt76x0_dev *dev,
+			       struct ieee80211_bss_conf *info)
+{
+	/* Start/stop collecting beacon data */
+	spin_lock_bh(&dev->con_mon_lock);
+	ether_addr_copy(dev->ap_bssid, info->bssid);
+	dev->avg_rssi = 0;
+	dev->bcn_freq_off = MT_FREQ_OFFSET_INVALID;
+	spin_unlock_bh(&dev->con_mon_lock);
+}
+
+static void
+mt76x0_set_rx_chains(struct mt76x0_dev *dev)
+{
+	u32 val;
+
+	val = mt76_rr(dev, MT_BBP(AGC, 0));
+	val &= ~(BIT(3) | BIT(4));
+
+	if (dev->chainmask & BIT(1))
+		val |= BIT(3);
+
+	mt76_wr(dev, MT_BBP(AGC, 0), val);
+
+	mb();
+	val = mt76_rr(dev, MT_BBP(AGC, 0));
+}
+
+static void
+mt76x0_set_tx_dac(struct mt76x0_dev *dev)
+{
+	if (dev->chainmask & BIT(1))
+		mt76_set(dev, MT_BBP(TXBE, 5), 3);
+	else
+		mt76_clear(dev, MT_BBP(TXBE, 5), 3);
+}
+
+static void
+mt76x0_rf_init(struct mt76x0_dev *dev)
+{
+	int i;
+	u8 val;
+
+	RF_RANDOM_WRITE(dev, mt76x0_rf_central_tab);
+	RF_RANDOM_WRITE(dev, mt76x0_rf_2g_channel_0_tab);
+	RF_RANDOM_WRITE(dev, mt76x0_rf_5g_channel_0_tab);
+	RF_RANDOM_WRITE(dev, mt76x0_rf_vga_channel_0_tab);
+
+	for (i = 0; i < ARRAY_SIZE(mt76x0_rf_bw_switch_tab); i++) {
+		const struct mt76x0_rf_switch_item *item = &mt76x0_rf_bw_switch_tab[i];
+
+		if (item->bw_band == RF_BW_20)
+			rf_wr(dev, item->rf_bank_reg, item->value);
+		else if (((RF_G_BAND | RF_BW_20) & item->bw_band) == (RF_G_BAND | RF_BW_20))
+			rf_wr(dev, item->rf_bank_reg, item->value);
+	}
+
+	for (i = 0; i < ARRAY_SIZE(mt76x0_rf_band_switch_tab); i++) {
+		if (mt76x0_rf_band_switch_tab[i].bw_band & RF_G_BAND) {
+			rf_wr(dev,
+			      mt76x0_rf_band_switch_tab[i].rf_bank_reg,
+			      mt76x0_rf_band_switch_tab[i].value);
+		}
+	}
+
+	/*
+	   Frequency calibration
+	   E1: B0.R22<6:0>: xo_cxo<6:0>
+	   E2: B0.R21<0>: xo_cxo<0>, B0.R22<7:0>: xo_cxo<8:1>
+	 */
+	rf_wr(dev, MT_RF(0, 22), min_t(u8, dev->ee->rf_freq_off, 0xBF));
+	val = rf_rr(dev, MT_RF(0, 22));
+
+	/*
+	   Reset the DAC (Set B0.R73<7>=1, then set B0.R73<7>=0, and then set B0.R73<7>) during power up.
+	 */
+	val = rf_rr(dev, MT_RF(0, 73));
+	val |= 0x80;
+	rf_wr(dev, MT_RF(0, 73), val);
+	val &= ~0x80;
+	rf_wr(dev, MT_RF(0, 73), val);
+	val |= 0x80;
+	rf_wr(dev, MT_RF(0, 73), val);
+
+	/*
+	   vcocal_en (initiate VCO calibration (reset after completion)) - It should be at the end of RF configuration.
+	 */
+	rf_set(dev, MT_RF(0, 4), 0x80);
+}
+
+void mt76x0_ant_select(struct mt76x0_dev *dev)
+{
+	/* Single antenna mode. */
+	mt76_rmw(dev, MT_WLAN_FUN_CTRL, BIT(5), BIT(6));
+	mt76_clear(dev, MT_CMB_CTRL, BIT(14) | BIT(12));
+	mt76_clear(dev, MT_COEXCFG0, BIT(2));
+	mt76_rmw(dev, MT_COEXCFG3, BIT(5) | BIT(4) | BIT(3) | BIT(2), BIT(1));
+}
+
+void mt76x0_phy_init(struct mt76x0_dev *dev)
+{
+	INIT_DELAYED_WORK(&dev->cal_work, mt76x0_phy_calibrate);
+
+	mt76x0_ant_select(dev);
+
+	mt76x0_rf_init(dev);
+
+	mt76x0_set_rx_chains(dev);
+	mt76x0_set_tx_dac(dev);
+}
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.h b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.h
new file mode 100644
index 000000000000..2880a43c3cb0
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.h
@@ -0,0 +1,81 @@
+/*
+ * (c) Copyright 2002-2010, Ralink Technology, Inc.
+ * Copyright (C) 2018 Stanislaw Gruszka <stf_xl@wp.pl>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2
+ * as published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+#ifndef _MT76X0_PHY_H_
+#define _MT76X0_PHY_H_
+
+#define RF_G_BAND 	0x0100
+#define RF_A_BAND 	0x0200
+#define RF_A_BAND_LB	0x0400
+#define RF_A_BAND_MB	0x0800
+#define RF_A_BAND_HB	0x1000
+#define RF_A_BAND_11J	0x2000
+
+#define RF_BW_20        1
+#define RF_BW_40        2
+#define RF_BW_10        4
+#define RF_BW_80        8
+
+#define MT_RF(bank, reg) ((bank) << 16 | (reg))
+#define MT_RF_BANK(offset) (offset >> 16)
+#define MT_RF_REG(offset) (offset & 0xff)
+
+struct mt76x0_bbp_switch_item {
+	u16 bw_band;
+	struct mt76_reg_pair reg_pair;
+};
+
+struct mt76x0_rf_switch_item {
+	u32 rf_bank_reg;
+	u16 bw_band;
+	u8 value;
+};
+
+struct mt76x0_freq_item {
+	u8 channel;
+	u32 band;
+	u8 pllR37;
+	u8 pllR36;
+	u8 pllR35;
+	u8 pllR34;
+	u8 pllR33;
+	u8 pllR32_b7b5;
+	u8 pllR32_b4b0; /* PLL_DEN (Denomina - 8) */
+	u8 pllR31_b7b5;
+	u8 pllR31_b4b0; /* PLL_K (Nominator *)*/
+	u8 pllR30_b7;	/* sdm_reset_n */
+	u8 pllR30_b6b2; /* sdmmash_prbs,sin */
+	u8 pllR30_b1;	/* sdm_bp */
+	u16 pll_n;	/* R30<0>, R29<7:0> (hex) */
+	u8 pllR28_b7b6; /* isi,iso */
+	u8 pllR28_b5b4;	/* pfd_dly */
+	u8 pllR28_b3b2;	/* clksel option */
+	u32 pll_sdm_k;	/* R28<1:0>, R27<7:0>, R26<7:0> (hex) SDM_k */
+	u8 pllR24_b1b0;	/* xo_div */
+};
+
+struct mt76x0_rate_pwr_item {
+	s8 mcs_power;
+	u8 rf_pa_mode;
+};
+
+struct mt76x0_rate_pwr_tab {
+	struct mt76x0_rate_pwr_item cck[4];
+	struct mt76x0_rate_pwr_item ofdm[8];
+	struct mt76x0_rate_pwr_item ht[8];
+	struct mt76x0_rate_pwr_item vht[10];
+	struct mt76x0_rate_pwr_item stbc[8];
+	struct mt76x0_rate_pwr_item mcs32;
+};
+
+#endif /* _MT76X0_PHY_H_ */
-- 
1.9.3
