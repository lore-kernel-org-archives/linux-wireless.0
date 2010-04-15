Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:32931 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757375Ab0DOVjq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Apr 2010 17:39:46 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v3 69/97] ath9k_hw: Implement AR9003 eeprom callbacks
Date: Thu, 15 Apr 2010 17:39:14 -0400
Message-Id: <1271367582-992-70-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1271367582-992-1-git-send-email-lrodriguez@atheros.com>
References: <1271367582-992-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Senthil Balasubramanian <senthilkumar@atheros.com>

Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/Makefile        |    3 +-
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c | 1842 ++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.h |  319 ++++
 drivers/net/wireless/ath/ath9k/eeprom.c        |    4 +-
 drivers/net/wireless/ath/ath9k/eeprom.h        |   11 +-
 drivers/net/wireless/ath/ath9k/hw.h            |    1 +
 drivers/net/wireless/ath/ath9k/reg.h           |   11 +
 7 files changed, 2187 insertions(+), 4 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
 create mode 100644 drivers/net/wireless/ath/ath9k/ar9003_eeprom.h

diff --git a/drivers/net/wireless/ath/ath9k/Makefile b/drivers/net/wireless/ath/ath9k/Makefile
index ee8f7e8..b0702fc 100644
--- a/drivers/net/wireless/ath/ath9k/Makefile
+++ b/drivers/net/wireless/ath/ath9k/Makefile
@@ -30,7 +30,8 @@ ath9k_hw-y:=	\
 		ani.o \
 		btcoex.o \
 		mac.o \
-		ar9003_mac.o
+		ar9003_mac.o \
+		ar9003_eeprom.o
 
 obj-$(CONFIG_ATH9K_HW) += ath9k_hw.o
 
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
new file mode 100644
index 0000000..fb39e39
--- /dev/null
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -0,0 +1,1842 @@
+/*
+ * Copyright (c) 2010 Atheros Communications Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#include "hw.h"
+#include "ar9003_phy.h"
+#include "ar9003_eeprom.h"
+
+#define COMP_HDR_LEN 4
+#define COMP_CKSUM_LEN 2
+
+#define AR_CH0_TOP (0x00016288)
+#define AR_CH0_TOP_XPABIASLVL (0x3)
+#define AR_CH0_TOP_XPABIASLVL_S (8)
+
+#define AR_CH0_THERM (0x00016290)
+#define AR_CH0_THERM_SPARE (0x3f)
+#define AR_CH0_THERM_SPARE_S (0)
+
+#define AR_SWITCH_TABLE_COM_ALL (0xffff)
+#define AR_SWITCH_TABLE_COM_ALL_S (0)
+
+#define AR_SWITCH_TABLE_COM2_ALL (0xffffff)
+#define AR_SWITCH_TABLE_COM2_ALL_S (0)
+
+#define AR_SWITCH_TABLE_ALL (0xfff)
+#define AR_SWITCH_TABLE_ALL_S (0)
+
+static const struct ar9300_eeprom ar9300_default = {
+	.eepromVersion = 2,
+	.templateVersion = 2,
+	.macAddr = {1, 2, 3, 4, 5, 6},
+	.custData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
+		     0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
+	.baseEepHeader = {
+		.regDmn = {0, 0x1f},
+		.txrxMask =  0x77, /* 4 bits tx and 4 bits rx */
+		.opCapFlags = {
+			.opFlags = AR9300_OPFLAGS_11G | AR9300_OPFLAGS_11A,
+			.eepMisc = 0,
+		},
+		.rfSilent = 0,
+		.blueToothOptions = 0,
+		.deviceCap = 0,
+		.deviceType = 5, /* takes lower byte in eeprom location */
+		.pwrTableOffset = AR9300_PWR_TABLE_OFFSET,
+		.params_for_tuning_caps = {0, 0},
+		.featureEnable = 0x0c,
+		 /*
+		  * bit0 - enable tx temp comp - disabled
+		  * bit1 - enable tx volt comp - disabled
+		  * bit2 - enable fastClock - enabled
+		  * bit3 - enable doubling - enabled
+		  * bit4 - enable internal regulator - disabled
+		  */
+		.miscConfiguration = 0, /* bit0 - turn down drivestrength */
+		.eepromWriteEnableGpio = 3,
+		.wlanDisableGpio = 0,
+		.wlanLedGpio = 8,
+		.rxBandSelectGpio = 0xff,
+		.txrxgain = 0,
+		.swreg = 0,
+	 },
+	.modalHeader2G = {
+	/* ar9300_modal_eep_header  2g */
+		/* 4 idle,t1,t2,b(4 bits per setting) */
+		.antCtrlCommon = 0x110,
+		/* 4 ra1l1, ra2l1, ra1l2, ra2l2, ra12 */
+		.antCtrlCommon2 = 0x22222,
+
+		/*
+		 * antCtrlChain[AR9300_MAX_CHAINS]; 6 idle, t, r,
+		 * rx1, rx12, b (2 bits each)
+		 */
+		.antCtrlChain = {0x150, 0x150, 0x150},
+
+		/*
+		 * xatten1DB[AR9300_MAX_CHAINS];  3 xatten1_db
+		 * for ar9280 (0xa20c/b20c 5:0)
+		 */
+		.xatten1DB = {0, 0, 0},
+
+		/*
+		 * xatten1Margin[AR9300_MAX_CHAINS]; 3 xatten1_margin
+		 * for ar9280 (0xa20c/b20c 16:12
+		 */
+		.xatten1Margin = {0, 0, 0},
+		.tempSlope = 36,
+		.voltSlope = 0,
+
+		/*
+		 * spurChans[OSPREY_EEPROM_MODAL_SPURS]; spur
+		 * channels in usual fbin coding format
+		 */
+		.spurChans = {0, 0, 0, 0, 0},
+
+		/*
+		 * noiseFloorThreshCh[AR9300_MAX_CHAINS]; 3 Check
+		 * if the register is per chain
+		 */
+		.noiseFloorThreshCh = {-1, 0, 0},
+		.ob = {1, 1, 1},/* 3 chain */
+		.db_stage2 = {1, 1, 1}, /* 3 chain  */
+		.db_stage3 = {0, 0, 0},
+		.db_stage4 = {0, 0, 0},
+		.xpaBiasLvl = 0,
+		.txFrameToDataStart = 0x0e,
+		.txFrameToPaOn = 0x0e,
+		.txClip = 3, /* 4 bits tx_clip, 4 bits dac_scale_cck */
+		.antennaGain = 0,
+		.switchSettling = 0x2c,
+		.adcDesiredSize = -30,
+		.txEndToXpaOff = 0,
+		.txEndToRxOn = 0x2,
+		.txFrameToXpaOn = 0xe,
+		.thresh62 = 28,
+		.futureModal = { /* [32] */
+			0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
+			0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
+		},
+	 },
+	.calFreqPier2G = {
+		FREQ2FBIN(2412, 1),
+		FREQ2FBIN(2437, 1),
+		FREQ2FBIN(2472, 1),
+	 },
+	/* ar9300_cal_data_per_freq_op_loop 2g */
+	.calPierData2G = {
+		{ {0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0} },
+		{ {0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0} },
+		{ {0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0} },
+	 },
+	.calTarget_freqbin_Cck = {
+		FREQ2FBIN(2412, 1),
+		FREQ2FBIN(2484, 1),
+	 },
+	.calTarget_freqbin_2G = {
+		FREQ2FBIN(2412, 1),
+		FREQ2FBIN(2437, 1),
+		FREQ2FBIN(2472, 1)
+	 },
+	.calTarget_freqbin_2GHT20 = {
+		FREQ2FBIN(2412, 1),
+		FREQ2FBIN(2437, 1),
+		FREQ2FBIN(2472, 1)
+	 },
+	.calTarget_freqbin_2GHT40 = {
+		FREQ2FBIN(2412, 1),
+		FREQ2FBIN(2437, 1),
+		FREQ2FBIN(2472, 1)
+	 },
+	.calTargetPowerCck = {
+		 /* 1L-5L,5S,11L,11S */
+		 { {36, 36, 36, 36} },
+		 { {36, 36, 36, 36} },
+	},
+	.calTargetPower2G = {
+		 /* 6-24,36,48,54 */
+		 { {32, 32, 28, 24} },
+		 { {32, 32, 28, 24} },
+		 { {32, 32, 28, 24} },
+	},
+	.calTargetPower2GHT20 = {
+		{ {32, 32, 32, 32, 28, 20, 32, 32, 28, 20, 32, 32, 28, 20} },
+		{ {32, 32, 32, 32, 28, 20, 32, 32, 28, 20, 32, 32, 28, 20} },
+		{ {32, 32, 32, 32, 28, 20, 32, 32, 28, 20, 32, 32, 28, 20} },
+	},
+	.calTargetPower2GHT40 = {
+		{ {32, 32, 32, 32, 28, 20, 32, 32, 28, 20, 32, 32, 28, 20} },
+		{ {32, 32, 32, 32, 28, 20, 32, 32, 28, 20, 32, 32, 28, 20} },
+		{ {32, 32, 32, 32, 28, 20, 32, 32, 28, 20, 32, 32, 28, 20} },
+	},
+	.ctlIndex_2G =  {
+		0x11, 0x12, 0x15, 0x17, 0x41, 0x42,
+		0x45, 0x47, 0x31, 0x32, 0x35, 0x37,
+	},
+	.ctl_freqbin_2G = {
+		{
+			FREQ2FBIN(2412, 1),
+			FREQ2FBIN(2417, 1),
+			FREQ2FBIN(2457, 1),
+			FREQ2FBIN(2462, 1)
+		},
+		{
+			FREQ2FBIN(2412, 1),
+			FREQ2FBIN(2417, 1),
+			FREQ2FBIN(2462, 1),
+			0xFF,
+		},
+
+		{
+			FREQ2FBIN(2412, 1),
+			FREQ2FBIN(2417, 1),
+			FREQ2FBIN(2462, 1),
+			0xFF,
+		},
+		{
+			FREQ2FBIN(2422, 1),
+			FREQ2FBIN(2427, 1),
+			FREQ2FBIN(2447, 1),
+			FREQ2FBIN(2452, 1)
+		},
+
+		{
+			/* Data[4].ctlEdges[0].bChannel */ FREQ2FBIN(2412, 1),
+			/* Data[4].ctlEdges[1].bChannel */ FREQ2FBIN(2417, 1),
+			/* Data[4].ctlEdges[2].bChannel */ FREQ2FBIN(2472, 1),
+			/* Data[4].ctlEdges[3].bChannel */ FREQ2FBIN(2484, 1),
+		},
+
+		{
+			/* Data[5].ctlEdges[0].bChannel */ FREQ2FBIN(2412, 1),
+			/* Data[5].ctlEdges[1].bChannel */ FREQ2FBIN(2417, 1),
+			/* Data[5].ctlEdges[2].bChannel */ FREQ2FBIN(2472, 1),
+			0,
+		},
+
+		{
+			/* Data[6].ctlEdges[0].bChannel */ FREQ2FBIN(2412, 1),
+			/* Data[6].ctlEdges[1].bChannel */ FREQ2FBIN(2417, 1),
+			FREQ2FBIN(2472, 1),
+			0,
+		},
+
+		{
+			/* Data[7].ctlEdges[0].bChannel */ FREQ2FBIN(2422, 1),
+			/* Data[7].ctlEdges[1].bChannel */ FREQ2FBIN(2427, 1),
+			/* Data[7].ctlEdges[2].bChannel */ FREQ2FBIN(2447, 1),
+			/* Data[7].ctlEdges[3].bChannel */ FREQ2FBIN(2462, 1),
+		},
+
+		{
+			/* Data[8].ctlEdges[0].bChannel */ FREQ2FBIN(2412, 1),
+			/* Data[8].ctlEdges[1].bChannel */ FREQ2FBIN(2417, 1),
+			/* Data[8].ctlEdges[2].bChannel */ FREQ2FBIN(2472, 1),
+		},
+
+		{
+			/* Data[9].ctlEdges[0].bChannel */ FREQ2FBIN(2412, 1),
+			/* Data[9].ctlEdges[1].bChannel */ FREQ2FBIN(2417, 1),
+			/* Data[9].ctlEdges[2].bChannel */ FREQ2FBIN(2472, 1),
+			0
+		},
+
+		{
+			/* Data[10].ctlEdges[0].bChannel */ FREQ2FBIN(2412, 1),
+			/* Data[10].ctlEdges[1].bChannel */ FREQ2FBIN(2417, 1),
+			/* Data[10].ctlEdges[2].bChannel */ FREQ2FBIN(2472, 1),
+			0
+		},
+
+		{
+			/* Data[11].ctlEdges[0].bChannel */ FREQ2FBIN(2422, 1),
+			/* Data[11].ctlEdges[1].bChannel */ FREQ2FBIN(2427, 1),
+			/* Data[11].ctlEdges[2].bChannel */ FREQ2FBIN(2447, 1),
+			/* Data[11].ctlEdges[3].bChannel */
+			FREQ2FBIN(2462, 1),
+		}
+	 },
+	.ctlPowerData_2G = {
+		 { { {60, 0}, {60, 1}, {60, 0}, {60, 0} } },
+		 { { {60, 0}, {60, 1}, {60, 0}, {60, 0} } },
+		 { { {60, 1}, {60, 0}, {60, 0}, {60, 1} } },
+
+		 { { {60, 1}, {60, 0}, {0, 0}, {0, 0} } },
+		 { { {60, 0}, {60, 1}, {60, 0}, {60, 0} } },
+		 { { {60, 0}, {60, 1}, {60, 0}, {60, 0} } },
+
+		 { { {60, 0}, {60, 1}, {60, 1}, {60, 0} } },
+		 { { {60, 0}, {60, 1}, {60, 0}, {60, 0} } },
+		 { { {60, 0}, {60, 1}, {60, 0}, {60, 0} } },
+
+		 { { {60, 0}, {60, 1}, {60, 0}, {60, 0} } },
+		 { { {60, 0}, {60, 1}, {60, 1}, {60, 1} } },
+	 },
+	.modalHeader5G = {
+		/* 4 idle,t1,t2,b (4 bits per setting) */
+		.antCtrlCommon = 0x110,
+		/* 4 ra1l1, ra2l1, ra1l2,ra2l2,ra12 */
+		.antCtrlCommon2 = 0x22222,
+		 /* antCtrlChain 6 idle, t,r,rx1,rx12,b (2 bits each) */
+		.antCtrlChain = {
+			0x000, 0x000, 0x000,
+		},
+		 /* xatten1DB 3 xatten1_db for AR9280 (0xa20c/b20c 5:0) */
+		.xatten1DB = {0, 0, 0},
+
+		/*
+		 * xatten1Margin[AR9300_MAX_CHAINS]; 3 xatten1_margin
+		 * for merlin (0xa20c/b20c 16:12
+		 */
+		.xatten1Margin = {0, 0, 0},
+		.tempSlope = 68,
+		.voltSlope = 0,
+		/* spurChans spur channels in usual fbin coding format */
+		.spurChans = {0, 0, 0, 0, 0},
+		/* noiseFloorThreshCh Check if the register is per chain */
+		.noiseFloorThreshCh = {-1, 0, 0},
+		.ob = {3, 3, 3}, /* 3 chain */
+		.db_stage2 = {3, 3, 3}, /* 3 chain */
+		.db_stage3 = {3, 3, 3}, /* doesn't exist for 2G */
+		.db_stage4 = {3, 3, 3},	 /* don't exist for 2G */
+		.xpaBiasLvl = 0,
+		.txFrameToDataStart = 0x0e,
+		.txFrameToPaOn = 0x0e,
+		.txClip = 3, /* 4 bits tx_clip, 4 bits dac_scale_cck */
+		.antennaGain = 0,
+		.switchSettling = 0x2d,
+		.adcDesiredSize = -30,
+		.txEndToXpaOff = 0,
+		.txEndToRxOn = 0x2,
+		.txFrameToXpaOn = 0xe,
+		.thresh62 = 28,
+		.futureModal = {
+			0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
+			0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
+		},
+	 },
+	.calFreqPier5G = {
+		FREQ2FBIN(5180, 0),
+		FREQ2FBIN(5220, 0),
+		FREQ2FBIN(5320, 0),
+		FREQ2FBIN(5400, 0),
+		FREQ2FBIN(5500, 0),
+		FREQ2FBIN(5600, 0),
+		FREQ2FBIN(5725, 0),
+		FREQ2FBIN(5825, 0)
+	},
+	.calPierData5G = {
+			{
+				{0, 0, 0, 0, 0},
+				{0, 0, 0, 0, 0},
+				{0, 0, 0, 0, 0},
+				{0, 0, 0, 0, 0},
+				{0, 0, 0, 0, 0},
+				{0, 0, 0, 0, 0},
+				{0, 0, 0, 0, 0},
+				{0, 0, 0, 0, 0},
+			},
+			{
+				{0, 0, 0, 0, 0},
+				{0, 0, 0, 0, 0},
+				{0, 0, 0, 0, 0},
+				{0, 0, 0, 0, 0},
+				{0, 0, 0, 0, 0},
+				{0, 0, 0, 0, 0},
+				{0, 0, 0, 0, 0},
+				{0, 0, 0, 0, 0},
+			},
+			{
+				{0, 0, 0, 0, 0},
+				{0, 0, 0, 0, 0},
+				{0, 0, 0, 0, 0},
+				{0, 0, 0, 0, 0},
+				{0, 0, 0, 0, 0},
+				{0, 0, 0, 0, 0},
+				{0, 0, 0, 0, 0},
+				{0, 0, 0, 0, 0},
+			},
+
+	},
+	.calTarget_freqbin_5G = {
+		FREQ2FBIN(5180, 0),
+		FREQ2FBIN(5220, 0),
+		FREQ2FBIN(5320, 0),
+		FREQ2FBIN(5400, 0),
+		FREQ2FBIN(5500, 0),
+		FREQ2FBIN(5600, 0),
+		FREQ2FBIN(5725, 0),
+		FREQ2FBIN(5825, 0)
+	},
+	.calTarget_freqbin_5GHT20 = {
+		FREQ2FBIN(5180, 0),
+		FREQ2FBIN(5240, 0),
+		FREQ2FBIN(5320, 0),
+		FREQ2FBIN(5500, 0),
+		FREQ2FBIN(5700, 0),
+		FREQ2FBIN(5745, 0),
+		FREQ2FBIN(5725, 0),
+		FREQ2FBIN(5825, 0)
+	},
+	.calTarget_freqbin_5GHT40 = {
+		FREQ2FBIN(5180, 0),
+		FREQ2FBIN(5240, 0),
+		FREQ2FBIN(5320, 0),
+		FREQ2FBIN(5500, 0),
+		FREQ2FBIN(5700, 0),
+		FREQ2FBIN(5745, 0),
+		FREQ2FBIN(5725, 0),
+		FREQ2FBIN(5825, 0)
+	 },
+	.calTargetPower5G = {
+		/* 6-24,36,48,54 */
+		{ {20, 20, 20, 10} },
+		{ {20, 20, 20, 10} },
+		{ {20, 20, 20, 10} },
+		{ {20, 20, 20, 10} },
+		{ {20, 20, 20, 10} },
+		{ {20, 20, 20, 10} },
+		{ {20, 20, 20, 10} },
+		{ {20, 20, 20, 10} },
+	 },
+	.calTargetPower5GHT20 = {
+		/*
+		 * 0_8_16,1-3_9-11_17-19,
+		 * 4,5,6,7,12,13,14,15,20,21,22,23
+		 */
+		{ {20, 20, 10, 10, 0, 0, 10, 10, 0, 0, 10, 10, 0, 0} },
+		{ {20, 20, 10, 10, 0, 0, 10, 10, 0, 0, 10, 10, 0, 0} },
+		{ {20, 20, 10, 10, 0, 0, 10, 10, 0, 0, 10, 10, 0, 0} },
+		{ {20, 20, 10, 10, 0, 0, 10, 10, 0, 0, 10, 10, 0, 0} },
+		{ {20, 20, 10, 10, 0, 0, 10, 10, 0, 0, 10, 10, 0, 0} },
+		{ {20, 20, 10, 10, 0, 0, 10, 10, 0, 0, 10, 10, 0, 0} },
+		{ {20, 20, 10, 10, 0, 0, 10, 10, 0, 0, 10, 10, 0, 0} },
+		{ {20, 20, 10, 10, 0, 0, 10, 10, 0, 0, 10, 10, 0, 0} },
+	 },
+	.calTargetPower5GHT40 =  {
+		/*
+		 * 0_8_16,1-3_9-11_17-19,
+		 * 4,5,6,7,12,13,14,15,20,21,22,23
+		 */
+		{ {20, 20, 10, 10, 0, 0, 10, 10, 0, 0, 10, 10, 0, 0} },
+		{ {20, 20, 10, 10, 0, 0, 10, 10, 0, 0, 10, 10, 0, 0} },
+		{ {20, 20, 10, 10, 0, 0, 10, 10, 0, 0, 10, 10, 0, 0} },
+		{ {20, 20, 10, 10, 0, 0, 10, 10, 0, 0, 10, 10, 0, 0} },
+		{ {20, 20, 10, 10, 0, 0, 10, 10, 0, 0, 10, 10, 0, 0} },
+		{ {20, 20, 10, 10, 0, 0, 10, 10, 0, 0, 10, 10, 0, 0} },
+		{ {20, 20, 10, 10, 0, 0, 10, 10, 0, 0, 10, 10, 0, 0} },
+		{ {20, 20, 10, 10, 0, 0, 10, 10, 0, 0, 10, 10, 0, 0} },
+	 },
+	.ctlIndex_5G =  {
+		0x10, 0x16, 0x18, 0x40, 0x46,
+		0x48, 0x30, 0x36, 0x38
+	},
+	.ctl_freqbin_5G =  {
+		{
+			/* Data[0].ctlEdges[0].bChannel */ FREQ2FBIN(5180, 0),
+			/* Data[0].ctlEdges[1].bChannel */ FREQ2FBIN(5260, 0),
+			/* Data[0].ctlEdges[2].bChannel */ FREQ2FBIN(5280, 0),
+			/* Data[0].ctlEdges[3].bChannel */ FREQ2FBIN(5500, 0),
+			/* Data[0].ctlEdges[4].bChannel */ FREQ2FBIN(5600, 0),
+			/* Data[0].ctlEdges[5].bChannel */ FREQ2FBIN(5700, 0),
+			/* Data[0].ctlEdges[6].bChannel */ FREQ2FBIN(5745, 0),
+			/* Data[0].ctlEdges[7].bChannel */ FREQ2FBIN(5825, 0)
+		},
+		{
+			/* Data[1].ctlEdges[0].bChannel */ FREQ2FBIN(5180, 0),
+			/* Data[1].ctlEdges[1].bChannel */ FREQ2FBIN(5260, 0),
+			/* Data[1].ctlEdges[2].bChannel */ FREQ2FBIN(5280, 0),
+			/* Data[1].ctlEdges[3].bChannel */ FREQ2FBIN(5500, 0),
+			/* Data[1].ctlEdges[4].bChannel */ FREQ2FBIN(5520, 0),
+			/* Data[1].ctlEdges[5].bChannel */ FREQ2FBIN(5700, 0),
+			/* Data[1].ctlEdges[6].bChannel */ FREQ2FBIN(5745, 0),
+			/* Data[1].ctlEdges[7].bChannel */ FREQ2FBIN(5825, 0)
+		},
+
+		{
+			/* Data[2].ctlEdges[0].bChannel */ FREQ2FBIN(5190, 0),
+			/* Data[2].ctlEdges[1].bChannel */ FREQ2FBIN(5230, 0),
+			/* Data[2].ctlEdges[2].bChannel */ FREQ2FBIN(5270, 0),
+			/* Data[2].ctlEdges[3].bChannel */ FREQ2FBIN(5310, 0),
+			/* Data[2].ctlEdges[4].bChannel */ FREQ2FBIN(5510, 0),
+			/* Data[2].ctlEdges[5].bChannel */ FREQ2FBIN(5550, 0),
+			/* Data[2].ctlEdges[6].bChannel */ FREQ2FBIN(5670, 0),
+			/* Data[2].ctlEdges[7].bChannel */ FREQ2FBIN(5755, 0)
+		},
+
+		{
+			/* Data[3].ctlEdges[0].bChannel */ FREQ2FBIN(5180, 0),
+			/* Data[3].ctlEdges[1].bChannel */ FREQ2FBIN(5200, 0),
+			/* Data[3].ctlEdges[2].bChannel */ FREQ2FBIN(5260, 0),
+			/* Data[3].ctlEdges[3].bChannel */ FREQ2FBIN(5320, 0),
+			/* Data[3].ctlEdges[4].bChannel */ FREQ2FBIN(5500, 0),
+			/* Data[3].ctlEdges[5].bChannel */ FREQ2FBIN(5700, 0),
+			/* Data[3].ctlEdges[6].bChannel */ 0xFF,
+			/* Data[3].ctlEdges[7].bChannel */ 0xFF,
+		},
+
+		{
+			/* Data[4].ctlEdges[0].bChannel */ FREQ2FBIN(5180, 0),
+			/* Data[4].ctlEdges[1].bChannel */ FREQ2FBIN(5260, 0),
+			/* Data[4].ctlEdges[2].bChannel */ FREQ2FBIN(5500, 0),
+			/* Data[4].ctlEdges[3].bChannel */ FREQ2FBIN(5700, 0),
+			/* Data[4].ctlEdges[4].bChannel */ 0xFF,
+			/* Data[4].ctlEdges[5].bChannel */ 0xFF,
+			/* Data[4].ctlEdges[6].bChannel */ 0xFF,
+			/* Data[4].ctlEdges[7].bChannel */ 0xFF,
+		},
+
+		{
+			/* Data[5].ctlEdges[0].bChannel */ FREQ2FBIN(5190, 0),
+			/* Data[5].ctlEdges[1].bChannel */ FREQ2FBIN(5270, 0),
+			/* Data[5].ctlEdges[2].bChannel */ FREQ2FBIN(5310, 0),
+			/* Data[5].ctlEdges[3].bChannel */ FREQ2FBIN(5510, 0),
+			/* Data[5].ctlEdges[4].bChannel */ FREQ2FBIN(5590, 0),
+			/* Data[5].ctlEdges[5].bChannel */ FREQ2FBIN(5670, 0),
+			/* Data[5].ctlEdges[6].bChannel */ 0xFF,
+			/* Data[5].ctlEdges[7].bChannel */ 0xFF
+		},
+
+		{
+			/* Data[6].ctlEdges[0].bChannel */ FREQ2FBIN(5180, 0),
+			/* Data[6].ctlEdges[1].bChannel */ FREQ2FBIN(5200, 0),
+			/* Data[6].ctlEdges[2].bChannel */ FREQ2FBIN(5220, 0),
+			/* Data[6].ctlEdges[3].bChannel */ FREQ2FBIN(5260, 0),
+			/* Data[6].ctlEdges[4].bChannel */ FREQ2FBIN(5500, 0),
+			/* Data[6].ctlEdges[5].bChannel */ FREQ2FBIN(5600, 0),
+			/* Data[6].ctlEdges[6].bChannel */ FREQ2FBIN(5700, 0),
+			/* Data[6].ctlEdges[7].bChannel */ FREQ2FBIN(5745, 0)
+		},
+
+		{
+			/* Data[7].ctlEdges[0].bChannel */ FREQ2FBIN(5180, 0),
+			/* Data[7].ctlEdges[1].bChannel */ FREQ2FBIN(5260, 0),
+			/* Data[7].ctlEdges[2].bChannel */ FREQ2FBIN(5320, 0),
+			/* Data[7].ctlEdges[3].bChannel */ FREQ2FBIN(5500, 0),
+			/* Data[7].ctlEdges[4].bChannel */ FREQ2FBIN(5560, 0),
+			/* Data[7].ctlEdges[5].bChannel */ FREQ2FBIN(5700, 0),
+			/* Data[7].ctlEdges[6].bChannel */ FREQ2FBIN(5745, 0),
+			/* Data[7].ctlEdges[7].bChannel */ FREQ2FBIN(5825, 0)
+		},
+
+		{
+			/* Data[8].ctlEdges[0].bChannel */ FREQ2FBIN(5190, 0),
+			/* Data[8].ctlEdges[1].bChannel */ FREQ2FBIN(5230, 0),
+			/* Data[8].ctlEdges[2].bChannel */ FREQ2FBIN(5270, 0),
+			/* Data[8].ctlEdges[3].bChannel */ FREQ2FBIN(5510, 0),
+			/* Data[8].ctlEdges[4].bChannel */ FREQ2FBIN(5550, 0),
+			/* Data[8].ctlEdges[5].bChannel */ FREQ2FBIN(5670, 0),
+			/* Data[8].ctlEdges[6].bChannel */ FREQ2FBIN(5755, 0),
+			/* Data[8].ctlEdges[7].bChannel */ FREQ2FBIN(5795, 0)
+		}
+	 },
+	.ctlPowerData_5G = {
+		{
+			{
+				{60, 1}, {60, 1}, {60, 1}, {60, 1},
+				{60, 1}, {60, 1}, {60, 1}, {60, 0},
+			}
+		},
+		{
+			{
+				{60, 1}, {60, 1}, {60, 1}, {60, 1},
+				{60, 1}, {60, 1}, {60, 1}, {60, 0},
+			}
+		},
+		{
+			{
+				{60, 0}, {60, 1}, {60, 0}, {60, 1},
+				{60, 1}, {60, 1}, {60, 1}, {60, 1},
+			}
+		},
+		{
+			{
+				{60, 0}, {60, 1}, {60, 1}, {60, 0},
+				{60, 1}, {60, 0}, {60, 0}, {60, 0},
+			}
+		},
+		{
+			{
+				{60, 1}, {60, 1}, {60, 1}, {60, 0},
+				{60, 0}, {60, 0}, {60, 0}, {60, 0},
+			}
+		},
+		{
+			{
+				{60, 1}, {60, 1}, {60, 1}, {60, 1},
+				{60, 1}, {60, 0}, {60, 0}, {60, 0},
+			}
+		},
+		{
+			{
+				{60, 1}, {60, 1}, {60, 1}, {60, 1},
+				{60, 1}, {60, 1}, {60, 1}, {60, 1},
+			}
+		},
+		{
+			{
+				{60, 1}, {60, 1}, {60, 0}, {60, 1},
+				{60, 1}, {60, 1}, {60, 1}, {60, 0},
+			}
+		},
+		{
+			{
+				{60, 1}, {60, 0}, {60, 1}, {60, 1},
+				{60, 1}, {60, 1}, {60, 0}, {60, 1},
+			}
+		},
+	 }
+};
+
+static int ath9k_hw_ar9300_check_eeprom(struct ath_hw *ah)
+{
+	return 0;
+}
+
+static u32 ath9k_hw_ar9300_get_eeprom(struct ath_hw *ah,
+				      enum eeprom_param param)
+{
+	struct ar9300_eeprom *eep = &ah->eeprom.ar9300_eep;
+	struct ar9300_base_eep_hdr *pBase = &eep->baseEepHeader;
+
+	switch (param) {
+	case EEP_MAC_LSW:
+		return eep->macAddr[0] << 8 | eep->macAddr[1];
+	case EEP_MAC_MID:
+		return eep->macAddr[2] << 8 | eep->macAddr[3];
+	case EEP_MAC_MSW:
+		return eep->macAddr[4] << 8 | eep->macAddr[5];
+	case EEP_REG_0:
+		return pBase->regDmn[0];
+	case EEP_REG_1:
+		return pBase->regDmn[1];
+	case EEP_OP_CAP:
+		return pBase->deviceCap;
+	case EEP_OP_MODE:
+		return pBase->opCapFlags.opFlags;
+	case EEP_RF_SILENT:
+		return pBase->rfSilent;
+	case EEP_TX_MASK:
+		return (pBase->txrxMask >> 4) & 0xf;
+	case EEP_RX_MASK:
+		return pBase->txrxMask & 0xf;
+	case EEP_DRIVE_STRENGTH:
+#define AR9300_EEP_BASE_DRIV_STRENGTH	0x1
+		return pBase->miscConfiguration & AR9300_EEP_BASE_DRIV_STRENGTH;
+	case EEP_INTERNAL_REGULATOR:
+		/* Bit 4 is internal regulator flag */
+		return (pBase->featureEnable & 0x10) >> 4;
+	case EEP_SWREG:
+		return pBase->swreg;
+	default:
+		return 0;
+	}
+}
+
+#ifdef __BIG_ENDIAN
+static void ar9300_swap_eeprom(struct ar9300_eeprom *eep)
+{
+	u32 dword;
+	u16 word;
+	int i;
+
+	word = swab16(eep->baseEepHeader.regDmn[0]);
+	eep->baseEepHeader.regDmn[0] = word;
+
+	word = swab16(eep->baseEepHeader.regDmn[1]);
+	eep->baseEepHeader.regDmn[1] = word;
+
+	dword = swab32(eep->modalHeader2G.antCtrlCommon);
+	eep->modalHeader2G.antCtrlCommon = dword;
+
+	dword = swab32(eep->modalHeader2G.antCtrlCommon2);
+	eep->modalHeader2G.antCtrlCommon2 = dword;
+
+	dword = swab32(eep->modalHeader5G.antCtrlCommon);
+	eep->modalHeader5G.antCtrlCommon = dword;
+
+	dword = swab32(eep->modalHeader5G.antCtrlCommon2);
+	eep->modalHeader5G.antCtrlCommon2 = dword;
+
+	for (i = 0; i < AR9300_MAX_CHAINS; i++) {
+		word = swab16(eep->modalHeader2G.antCtrlChain[i]);
+		eep->modalHeader2G.antCtrlChain[i] = word;
+
+		word = swab16(eep->modalHeader5G.antCtrlChain[i]);
+		eep->modalHeader5G.antCtrlChain[i] = word;
+	}
+}
+#endif
+
+static bool ar9300_hw_read_eeprom(struct ath_hw *ah,
+				  long address, u8 *buffer, int many)
+{
+	int i;
+	u8 value[2];
+	unsigned long eepAddr;
+	unsigned long byteAddr;
+	u16 *svalue;
+	struct ath_common *common = ath9k_hw_common(ah);
+
+	if ((address < 0) || ((address + many) > AR9300_EEPROM_SIZE - 1)) {
+		ath_print(common, ATH_DBG_EEPROM,
+			  "eeprom address not in range\n");
+		return false;
+	}
+
+	for (i = 0; i < many; i++) {
+		eepAddr = (u16) (address + i) / 2;
+		byteAddr = (u16) (address + i) % 2;
+		svalue = (u16 *) value;
+		if (!ath9k_hw_nvram_read(common, eepAddr, svalue)) {
+			ath_print(common, ATH_DBG_EEPROM,
+				  "unable to read eeprom region\n");
+			return false;
+		}
+		*svalue = le16_to_cpu(*svalue);
+		buffer[i] = value[byteAddr];
+	}
+
+	return true;
+}
+
+static bool ar9300_read_eeprom(struct ath_hw *ah,
+			       int address, u8 *buffer, int many)
+{
+	int it;
+
+	for (it = 0; it < many; it++)
+		if (!ar9300_hw_read_eeprom(ah,
+					   (address - it),
+					   (buffer + it), 1))
+			return false;
+	return true;
+}
+
+static void ar9300_comp_hdr_unpack(u8 *best, int *code, int *reference,
+				   int *length, int *major, int *minor)
+{
+	unsigned long value[4];
+
+	value[0] = best[0];
+	value[1] = best[1];
+	value[2] = best[2];
+	value[3] = best[3];
+	*code = ((value[0] >> 5) & 0x0007);
+	*reference = (value[0] & 0x001f) | ((value[1] >> 2) & 0x0020);
+	*length = ((value[1] << 4) & 0x07f0) | ((value[2] >> 4) & 0x000f);
+	*major = (value[2] & 0x000f);
+	*minor = (value[3] & 0x00ff);
+}
+
+static u16 ar9300_comp_cksum(u8 *data, int dsize)
+{
+	int it, checksum = 0;
+
+	for (it = 0; it < dsize; it++) {
+		checksum += data[it];
+		checksum &= 0xffff;
+	}
+
+	return checksum;
+}
+
+static bool ar9300_uncompress_block(struct ath_hw *ah,
+				    u8 *mptr,
+				    int mdataSize,
+				    u8 *block,
+				    int size)
+{
+	int it;
+	int spot;
+	int offset;
+	int length;
+	struct ath_common *common = ath9k_hw_common(ah);
+
+	spot = 0;
+
+	for (it = 0; it < size; it += (length+2)) {
+		offset = block[it];
+		offset &= 0xff;
+		spot += offset;
+		length = block[it+1];
+		length &= 0xff;
+
+		if (length > 0 && spot >= 0 && spot+length < mdataSize) {
+			ath_print(common, ATH_DBG_EEPROM,
+				  "Restore at %d: spot=%d "
+				  "offset=%d length=%d\n",
+				   it, spot, offset, length);
+			memcpy(&mptr[spot], &block[it+2], length);
+			spot += length;
+		} else if (length > 0) {
+			ath_print(common, ATH_DBG_EEPROM,
+				  "Bad restore at %d: spot=%d "
+				  "offset=%d length=%d\n",
+				  it, spot, offset, length);
+			return false;
+		}
+	}
+	return true;
+}
+
+static int ar9300_compress_decision(struct ath_hw *ah,
+				    int it,
+				    int code,
+				    int reference,
+				    u8 *mptr,
+				    u8 *word, int length, int mdata_size)
+{
+	struct ath_common *common = ath9k_hw_common(ah);
+	u8 *dptr;
+
+	switch (code) {
+	case _CompressNone:
+		if (length != mdata_size) {
+			ath_print(common, ATH_DBG_EEPROM,
+				  "EEPROM structure size mismatch"
+				  "memory=%d eeprom=%d\n", mdata_size, length);
+			return -1;
+		}
+		memcpy(mptr, (u8 *) (word + COMP_HDR_LEN), length);
+		ath_print(common, ATH_DBG_EEPROM, "restored eeprom %d:"
+			  " uncompressed, length %d\n", it, length);
+		break;
+	case _CompressBlock:
+		if (reference == 0) {
+			dptr = mptr;
+		} else {
+			if (reference != 2) {
+				ath_print(common, ATH_DBG_EEPROM,
+					  "cant find reference eeprom"
+					  "struct %d\n", reference);
+				return -1;
+			}
+			memcpy(mptr, &ar9300_default, mdata_size);
+		}
+		ath_print(common, ATH_DBG_EEPROM,
+			  "restore eeprom %d: block, reference %d,"
+			  " length %d\n", it, reference, length);
+		ar9300_uncompress_block(ah, mptr, mdata_size,
+					(u8 *) (word + COMP_HDR_LEN), length);
+		break;
+	default:
+		ath_print(common, ATH_DBG_EEPROM, "unknown compression"
+			  " code %d\n", code);
+		return -1;
+	}
+	return 0;
+}
+
+/*
+ * Read the configuration data from the eeprom.
+ * The data can be put in any specified memory buffer.
+ *
+ * Returns -1 on error.
+ * Returns address of next memory location on success.
+ */
+static int ar9300_eeprom_restore_internal(struct ath_hw *ah,
+					  u8 *mptr, int mdata_size)
+{
+#define MDEFAULT 15
+#define MSTATE 100
+	int cptr;
+	u8 *word;
+	int code;
+	int reference, length, major, minor;
+	int osize;
+	int it;
+	u16 checksum, mchecksum;
+	struct ath_common *common = ath9k_hw_common(ah);
+
+	word = kzalloc(2048, GFP_KERNEL);
+	if (!word)
+		return -1;
+
+	memcpy(mptr, &ar9300_default, mdata_size);
+
+	cptr = AR9300_BASE_ADDR;
+	for (it = 0; it < MSTATE; it++) {
+		if (!ar9300_read_eeprom(ah, cptr, word, COMP_HDR_LEN))
+			goto fail;
+
+		if ((word[0] == 0 && word[1] == 0 && word[2] == 0 &&
+		     word[3] == 0) || (word[0] == 0xff && word[1] == 0xff
+				       && word[2] == 0xff && word[3] == 0xff))
+			break;
+
+		ar9300_comp_hdr_unpack(word, &code, &reference,
+				       &length, &major, &minor);
+		ath_print(common, ATH_DBG_EEPROM,
+			  "Found block at %x: code=%d ref=%d"
+			  "length=%d major=%d minor=%d\n", cptr, code,
+			  reference, length, major, minor);
+		if (length >= 1024) {
+			ath_print(common, ATH_DBG_EEPROM,
+				  "Skipping bad header\n");
+			cptr -= COMP_HDR_LEN;
+			continue;
+		}
+
+		osize = length;
+		ar9300_read_eeprom(ah, cptr, word,
+				   COMP_HDR_LEN + osize + COMP_CKSUM_LEN);
+		checksum = ar9300_comp_cksum(&word[COMP_HDR_LEN], length);
+		mchecksum = word[COMP_HDR_LEN + osize] |
+		    (word[COMP_HDR_LEN + osize + 1] << 8);
+		ath_print(common, ATH_DBG_EEPROM,
+			  "checksum %x %x\n", checksum, mchecksum);
+		if (checksum == mchecksum) {
+			ar9300_compress_decision(ah, it, code, reference, mptr,
+						 word, length, mdata_size);
+		} else {
+			ath_print(common, ATH_DBG_EEPROM,
+				  "skipping block with bad checksum\n");
+		}
+		cptr -= (COMP_HDR_LEN + osize + COMP_CKSUM_LEN);
+	}
+
+	kfree(word);
+	return cptr;
+
+fail:
+	kfree(word);
+	return -1;
+}
+
+/*
+ * Restore the configuration structure by reading the eeprom.
+ * This function destroys any existing in-memory structure
+ * content.
+ */
+static bool ath9k_hw_ar9300_fill_eeprom(struct ath_hw *ah)
+{
+	u8 *mptr = NULL;
+	int mdata_size;
+
+	mptr = (u8 *) &ah->eeprom.ar9300_eep;
+	mdata_size = sizeof(struct ar9300_eeprom);
+
+	if (mptr && mdata_size > 0) {
+		/* At this point, mptr points to the eeprom data structure
+		 * in it's "default" state. If this is big endian, swap the
+		 * data structures back to "little endian"
+		 */
+		/* First swap, default to Little Endian */
+#ifdef __BIG_ENDIAN
+		ar9300_swap_eeprom((struct ar9300_eeprom *)mptr);
+#endif
+		if (ar9300_eeprom_restore_internal(ah, mptr, mdata_size) >= 0)
+			return true;
+
+		/* Second Swap, back to Big Endian */
+#ifdef __BIG_ENDIAN
+		ar9300_swap_eeprom((struct ar9300_eeprom *)mptr);
+#endif
+	}
+	return false;
+}
+
+/* XXX: review hardware docs */
+static int ath9k_hw_ar9300_get_eeprom_ver(struct ath_hw *ah)
+{
+	return ah->eeprom.ar9300_eep.eepromVersion;
+}
+
+/* XXX: could be read from the eepromVersion, not sure yet */
+static int ath9k_hw_ar9300_get_eeprom_rev(struct ath_hw *ah)
+{
+	return 0;
+}
+
+static u8 ath9k_hw_ar9300_get_num_ant_config(struct ath_hw *ah,
+					     enum ieee80211_band freq_band)
+{
+	return 1;
+}
+
+static u16 ath9k_hw_ar9300_get_eeprom_antenna_cfg(struct ath_hw *ah,
+						  struct ath9k_channel *chan)
+{
+	return -EINVAL;
+}
+
+static s32 ar9003_hw_xpa_bias_level_get(struct ath_hw *ah, bool is2ghz)
+{
+	struct ar9300_eeprom *eep = &ah->eeprom.ar9300_eep;
+
+	if (is2ghz)
+		return eep->modalHeader2G.xpaBiasLvl;
+	else
+		return eep->modalHeader5G.xpaBiasLvl;
+}
+
+static void ar9003_hw_xpa_bias_level_apply(struct ath_hw *ah, bool is2ghz)
+{
+	int bias = ar9003_hw_xpa_bias_level_get(ah, is2ghz);
+	REG_RMW_FIELD(ah, AR_CH0_TOP, AR_CH0_TOP_XPABIASLVL, (bias & 0x3));
+	REG_RMW_FIELD(ah, AR_CH0_THERM, AR_CH0_THERM_SPARE,
+		      ((bias >> 2) & 0x3));
+}
+
+static u32 ar9003_hw_ant_ctrl_common_get(struct ath_hw *ah, bool is2ghz)
+{
+	struct ar9300_eeprom *eep = &ah->eeprom.ar9300_eep;
+
+	if (is2ghz)
+		return eep->modalHeader2G.antCtrlCommon;
+	else
+		return eep->modalHeader5G.antCtrlCommon;
+}
+
+static u32 ar9003_hw_ant_ctrl_common_2_get(struct ath_hw *ah, bool is2ghz)
+{
+	struct ar9300_eeprom *eep = &ah->eeprom.ar9300_eep;
+
+	if (is2ghz)
+		return eep->modalHeader2G.antCtrlCommon2;
+	else
+		return eep->modalHeader5G.antCtrlCommon2;
+}
+
+static u16 ar9003_hw_ant_ctrl_chain_get(struct ath_hw *ah,
+					int chain,
+					bool is2ghz)
+{
+	struct ar9300_eeprom *eep = &ah->eeprom.ar9300_eep;
+
+	if (chain >= 0 && chain < AR9300_MAX_CHAINS) {
+		if (is2ghz)
+			return eep->modalHeader2G.antCtrlChain[chain];
+		else
+			return eep->modalHeader5G.antCtrlChain[chain];
+	}
+
+	return 0;
+}
+
+static void ar9003_hw_ant_ctrl_apply(struct ath_hw *ah, bool is2ghz)
+{
+	u32 value = ar9003_hw_ant_ctrl_common_get(ah, is2ghz);
+	REG_RMW_FIELD(ah, AR_PHY_SWITCH_COM, AR_SWITCH_TABLE_COM_ALL, value);
+
+	value = ar9003_hw_ant_ctrl_common_2_get(ah, is2ghz);
+	REG_RMW_FIELD(ah, AR_PHY_SWITCH_COM_2, AR_SWITCH_TABLE_COM2_ALL, value);
+
+	value = ar9003_hw_ant_ctrl_chain_get(ah, 0, is2ghz);
+	REG_RMW_FIELD(ah, AR_PHY_SWITCH_CHAIN_0, AR_SWITCH_TABLE_ALL, value);
+
+	value = ar9003_hw_ant_ctrl_chain_get(ah, 1, is2ghz);
+	REG_RMW_FIELD(ah, AR_PHY_SWITCH_CHAIN_1, AR_SWITCH_TABLE_ALL, value);
+
+	value = ar9003_hw_ant_ctrl_chain_get(ah, 2, is2ghz);
+	REG_RMW_FIELD(ah, AR_PHY_SWITCH_CHAIN_2, AR_SWITCH_TABLE_ALL, value);
+}
+
+static void ar9003_hw_drive_strength_apply(struct ath_hw *ah)
+{
+	int drive_strength;
+	unsigned long reg;
+
+	drive_strength = ath9k_hw_ar9300_get_eeprom(ah, EEP_DRIVE_STRENGTH);
+
+	if (!drive_strength)
+		return;
+
+	reg = REG_READ(ah, AR_PHY_65NM_CH0_BIAS1);
+	reg &= ~0x00ffffc0;
+	reg |= 0x5 << 21;
+	reg |= 0x5 << 18;
+	reg |= 0x5 << 15;
+	reg |= 0x5 << 12;
+	reg |= 0x5 << 9;
+	reg |= 0x5 << 6;
+	REG_WRITE(ah, AR_PHY_65NM_CH0_BIAS1, reg);
+
+	reg = REG_READ(ah, AR_PHY_65NM_CH0_BIAS2);
+	reg &= ~0xffffffe0;
+	reg |= 0x5 << 29;
+	reg |= 0x5 << 26;
+	reg |= 0x5 << 23;
+	reg |= 0x5 << 20;
+	reg |= 0x5 << 17;
+	reg |= 0x5 << 14;
+	reg |= 0x5 << 11;
+	reg |= 0x5 << 8;
+	reg |= 0x5 << 5;
+	REG_WRITE(ah, AR_PHY_65NM_CH0_BIAS2, reg);
+
+	reg = REG_READ(ah, AR_PHY_65NM_CH0_BIAS4);
+	reg &= ~0xff800000;
+	reg |= 0x5 << 29;
+	reg |= 0x5 << 26;
+	reg |= 0x5 << 23;
+	REG_WRITE(ah, AR_PHY_65NM_CH0_BIAS4, reg);
+}
+
+static void ar9003_hw_internal_regulator_apply(struct ath_hw *ah)
+{
+	int internal_regulator =
+		ath9k_hw_ar9300_get_eeprom(ah, EEP_INTERNAL_REGULATOR);
+
+	if (internal_regulator) {
+		/* Internal regulator is ON. Write swreg register. */
+		int swreg = ath9k_hw_ar9300_get_eeprom(ah, EEP_SWREG);
+		REG_WRITE(ah, AR_RTC_REG_CONTROL1,
+		REG_READ(ah, AR_RTC_REG_CONTROL1) &
+			 (~AR_RTC_REG_CONTROL1_SWREG_PROGRAM));
+		REG_WRITE(ah, AR_RTC_REG_CONTROL0, swreg);
+		/* Set REG_CONTROL1.SWREG_PROGRAM */
+		REG_WRITE(ah, AR_RTC_REG_CONTROL1,
+			  REG_READ(ah,
+				   AR_RTC_REG_CONTROL1) |
+				   AR_RTC_REG_CONTROL1_SWREG_PROGRAM);
+	} else {
+		REG_WRITE(ah, AR_RTC_SLEEP_CLK,
+			  (REG_READ(ah,
+				    AR_RTC_SLEEP_CLK) |
+				    AR_RTC_FORCE_SWREG_PRD));
+	}
+}
+
+static void ath9k_hw_ar9300_set_board_values(struct ath_hw *ah,
+					     struct ath9k_channel *chan)
+{
+	ar9003_hw_xpa_bias_level_apply(ah, IS_CHAN_2GHZ(chan));
+	ar9003_hw_ant_ctrl_apply(ah, IS_CHAN_2GHZ(chan));
+	ar9003_hw_drive_strength_apply(ah);
+	ar9003_hw_internal_regulator_apply(ah);
+}
+
+static void ath9k_hw_ar9300_set_addac(struct ath_hw *ah,
+				      struct ath9k_channel *chan)
+{
+}
+
+/*
+ * Returns the interpolated y value corresponding to the specified x value
+ * from the np ordered pairs of data (px,py).
+ * The pairs do not have to be in any order.
+ * If the specified x value is less than any of the px,
+ * the returned y value is equal to the py for the lowest px.
+ * If the specified x value is greater than any of the px,
+ * the returned y value is equal to the py for the highest px.
+ */
+static int ar9003_hw_power_interpolate(int32_t x,
+				       int32_t *px, int32_t *py, u_int16_t np)
+{
+	int ip = 0;
+	int lx = 0, ly = 0, lhave = 0;
+	int hx = 0, hy = 0, hhave = 0;
+	int dx = 0;
+	int y = 0;
+
+	lhave = 0;
+	hhave = 0;
+
+	/* identify best lower and higher x calibration measurement */
+	for (ip = 0; ip < np; ip++) {
+		dx = x - px[ip];
+
+		/* this measurement is higher than our desired x */
+		if (dx <= 0) {
+			if (!hhave || dx > (x - hx)) {
+				/* new best higher x measurement */
+				hx = px[ip];
+				hy = py[ip];
+				hhave = 1;
+			}
+		}
+		/* this measurement is lower than our desired x */
+		if (dx >= 0) {
+			if (!lhave || dx < (x - lx)) {
+				/* new best lower x measurement */
+				lx = px[ip];
+				ly = py[ip];
+				lhave = 1;
+			}
+		}
+	}
+
+	/* the low x is good */
+	if (lhave) {
+		/* so is the high x */
+		if (hhave) {
+			/* they're the same, so just pick one */
+			if (hx == lx)
+				y = ly;
+			else	/* interpolate  */
+				y = ly + (((x - lx) * (hy - ly)) / (hx - lx));
+		} else		/* only low is good, use it */
+			y = ly;
+	} else if (hhave)	/* only high is good, use it */
+		y = hy;
+	else /* nothing is good,this should never happen unless np=0, ???? */
+		y = -(1 << 30);
+	return y;
+}
+
+static u8 ar9003_hw_eeprom_get_tgt_pwr(struct ath_hw *ah,
+				       u16 rateIndex, u16 freq, bool is2GHz)
+{
+	u16 numPiers, i;
+	s32 targetPowerArray[AR9300_NUM_5G_20_TARGET_POWERS];
+	s32 freqArray[AR9300_NUM_5G_20_TARGET_POWERS];
+	struct ar9300_eeprom *eep = &ah->eeprom.ar9300_eep;
+	struct cal_tgt_pow_legacy *pEepromTargetPwr;
+	u8 *pFreqBin;
+
+	if (is2GHz) {
+		numPiers = AR9300_NUM_5G_20_TARGET_POWERS;
+		pEepromTargetPwr = eep->calTargetPower2G;
+		pFreqBin = eep->calTarget_freqbin_2G;
+	} else {
+		numPiers = AR9300_NUM_5G_20_TARGET_POWERS;
+		pEepromTargetPwr = eep->calTargetPower5G;
+		pFreqBin = eep->calTarget_freqbin_5G;
+	}
+
+	/*
+	 * create array of channels and targetpower from
+	 * targetpower piers stored on eeprom
+	 */
+	for (i = 0; i < numPiers; i++) {
+		freqArray[i] = FBIN2FREQ(pFreqBin[i], is2GHz);
+		targetPowerArray[i] = pEepromTargetPwr[i].tPow2x[rateIndex];
+	}
+
+	/* interpolate to get target power for given frequency */
+	return (u8) ar9003_hw_power_interpolate((s32) freq,
+						 freqArray,
+						 targetPowerArray, numPiers);
+}
+
+static u8 ar9003_hw_eeprom_get_ht20_tgt_pwr(struct ath_hw *ah,
+					    u16 rateIndex,
+					    u16 freq, bool is2GHz)
+{
+	u16 numPiers, i;
+	s32 targetPowerArray[AR9300_NUM_5G_20_TARGET_POWERS];
+	s32 freqArray[AR9300_NUM_5G_20_TARGET_POWERS];
+	struct ar9300_eeprom *eep = &ah->eeprom.ar9300_eep;
+	struct cal_tgt_pow_ht *pEepromTargetPwr;
+	u8 *pFreqBin;
+
+	if (is2GHz) {
+		numPiers = AR9300_NUM_5G_20_TARGET_POWERS;
+		pEepromTargetPwr = eep->calTargetPower2GHT20;
+		pFreqBin = eep->calTarget_freqbin_2GHT20;
+	} else {
+		numPiers = AR9300_NUM_5G_20_TARGET_POWERS;
+		pEepromTargetPwr = eep->calTargetPower5GHT20;
+		pFreqBin = eep->calTarget_freqbin_5GHT20;
+	}
+
+	/*
+	 * create array of channels and targetpower
+	 * from targetpower piers stored on eeprom
+	 */
+	for (i = 0; i < numPiers; i++) {
+		freqArray[i] = FBIN2FREQ(pFreqBin[i], is2GHz);
+		targetPowerArray[i] = pEepromTargetPwr[i].tPow2x[rateIndex];
+	}
+
+	/* interpolate to get target power for given frequency */
+	return (u8) ar9003_hw_power_interpolate((s32) freq,
+						 freqArray,
+						 targetPowerArray, numPiers);
+}
+
+static u8 ar9003_hw_eeprom_get_ht40_tgt_pwr(struct ath_hw *ah,
+					    u16 rateIndex,
+					    u16 freq, bool is2GHz)
+{
+	u16 numPiers, i;
+	s32 targetPowerArray[AR9300_NUM_5G_40_TARGET_POWERS];
+	s32 freqArray[AR9300_NUM_5G_40_TARGET_POWERS];
+	struct ar9300_eeprom *eep = &ah->eeprom.ar9300_eep;
+	struct cal_tgt_pow_ht *pEepromTargetPwr;
+	u8 *pFreqBin;
+
+	if (is2GHz) {
+		numPiers = AR9300_NUM_2G_40_TARGET_POWERS;
+		pEepromTargetPwr = eep->calTargetPower2GHT40;
+		pFreqBin = eep->calTarget_freqbin_2GHT40;
+	} else {
+		numPiers = AR9300_NUM_5G_40_TARGET_POWERS;
+		pEepromTargetPwr = eep->calTargetPower5GHT40;
+		pFreqBin = eep->calTarget_freqbin_5GHT40;
+	}
+
+	/*
+	 * create array of channels and targetpower from
+	 * targetpower piers stored on eeprom
+	 */
+	for (i = 0; i < numPiers; i++) {
+		freqArray[i] = FBIN2FREQ(pFreqBin[i], is2GHz);
+		targetPowerArray[i] = pEepromTargetPwr[i].tPow2x[rateIndex];
+	}
+
+	/* interpolate to get target power for given frequency */
+	return (u8) ar9003_hw_power_interpolate((s32) freq,
+						 freqArray,
+						 targetPowerArray, numPiers);
+}
+
+static u8 ar9003_hw_eeprom_get_cck_tgt_pwr(struct ath_hw *ah,
+					   u16 rateIndex, u16 freq)
+{
+	u16 numPiers = AR9300_NUM_2G_CCK_TARGET_POWERS, i;
+	s32 targetPowerArray[AR9300_NUM_2G_CCK_TARGET_POWERS];
+	s32 freqArray[AR9300_NUM_2G_CCK_TARGET_POWERS];
+	struct ar9300_eeprom *eep = &ah->eeprom.ar9300_eep;
+	struct cal_tgt_pow_legacy *pEepromTargetPwr = eep->calTargetPowerCck;
+	u8 *pFreqBin = eep->calTarget_freqbin_Cck;
+
+	/*
+	 * create array of channels and targetpower from
+	 * targetpower piers stored on eeprom
+	 */
+	for (i = 0; i < numPiers; i++) {
+		freqArray[i] = FBIN2FREQ(pFreqBin[i], 1);
+		targetPowerArray[i] = pEepromTargetPwr[i].tPow2x[rateIndex];
+	}
+
+	/* interpolate to get target power for given frequency */
+	return (u8) ar9003_hw_power_interpolate((s32) freq,
+						 freqArray,
+						 targetPowerArray, numPiers);
+}
+
+/* Set tx power registers to array of values passed in */
+static int ar9003_hw_tx_power_regwrite(struct ath_hw *ah, u8 * pPwrArray)
+{
+#define POW_SM(_r, _s)     (((_r) & 0x3f) << (_s))
+	/* make sure forced gain is not set */
+	REG_WRITE(ah, 0xa458, 0);
+
+	/* Write the OFDM power per rate set */
+
+	/* 6 (LSB), 9, 12, 18 (MSB) */
+	REG_WRITE(ah, 0xa3c0,
+		  POW_SM(pPwrArray[ALL_TARGET_LEGACY_6_24], 24) |
+		  POW_SM(pPwrArray[ALL_TARGET_LEGACY_6_24], 16) |
+		  POW_SM(pPwrArray[ALL_TARGET_LEGACY_6_24], 8) |
+		  POW_SM(pPwrArray[ALL_TARGET_LEGACY_6_24], 0));
+
+	/* 24 (LSB), 36, 48, 54 (MSB) */
+	REG_WRITE(ah, 0xa3c4,
+		  POW_SM(pPwrArray[ALL_TARGET_LEGACY_54], 24) |
+		  POW_SM(pPwrArray[ALL_TARGET_LEGACY_48], 16) |
+		  POW_SM(pPwrArray[ALL_TARGET_LEGACY_36], 8) |
+		  POW_SM(pPwrArray[ALL_TARGET_LEGACY_6_24], 0));
+
+	/* Write the CCK power per rate set */
+
+	/* 1L (LSB), reserved, 2L, 2S (MSB) */
+	REG_WRITE(ah, 0xa3c8,
+		  POW_SM(pPwrArray[ALL_TARGET_LEGACY_1L_5L], 24) |
+		  POW_SM(pPwrArray[ALL_TARGET_LEGACY_1L_5L], 16) |
+		  /* POW_SM(txPowerTimes2,  8) | this is reserved for AR9003 */
+		  POW_SM(pPwrArray[ALL_TARGET_LEGACY_1L_5L], 0));
+
+	/* 5.5L (LSB), 5.5S, 11L, 11S (MSB) */
+	REG_WRITE(ah, 0xa3cc,
+		  POW_SM(pPwrArray[ALL_TARGET_LEGACY_11S], 24) |
+		  POW_SM(pPwrArray[ALL_TARGET_LEGACY_11L], 16) |
+		  POW_SM(pPwrArray[ALL_TARGET_LEGACY_5S], 8) |
+		  POW_SM(pPwrArray[ALL_TARGET_LEGACY_1L_5L], 0)
+	    );
+
+	/* Write the HT20 power per rate set */
+
+	/* 0/8/16 (LSB), 1-3/9-11/17-19, 4, 5 (MSB) */
+	REG_WRITE(ah, 0xa3d0,
+		  POW_SM(pPwrArray[ALL_TARGET_HT20_5], 24) |
+		  POW_SM(pPwrArray[ALL_TARGET_HT20_4], 16) |
+		  POW_SM(pPwrArray[ALL_TARGET_HT20_1_3_9_11_17_19], 8) |
+		  POW_SM(pPwrArray[ALL_TARGET_HT20_0_8_16], 0)
+	    );
+
+	/* 6 (LSB), 7, 12, 13 (MSB) */
+	REG_WRITE(ah, 0xa3d4,
+		  POW_SM(pPwrArray[ALL_TARGET_HT20_13], 24) |
+		  POW_SM(pPwrArray[ALL_TARGET_HT20_12], 16) |
+		  POW_SM(pPwrArray[ALL_TARGET_HT20_7], 8) |
+		  POW_SM(pPwrArray[ALL_TARGET_HT20_6], 0)
+	    );
+
+	/* 14 (LSB), 15, 20, 21 */
+	REG_WRITE(ah, 0xa3e4,
+		  POW_SM(pPwrArray[ALL_TARGET_HT20_21], 24) |
+		  POW_SM(pPwrArray[ALL_TARGET_HT20_20], 16) |
+		  POW_SM(pPwrArray[ALL_TARGET_HT20_15], 8) |
+		  POW_SM(pPwrArray[ALL_TARGET_HT20_14], 0)
+	    );
+
+	/* Mixed HT20 and HT40 rates */
+
+	/* HT20 22 (LSB), HT20 23, HT40 22, HT40 23 (MSB) */
+	REG_WRITE(ah, 0xa3e8,
+		  POW_SM(pPwrArray[ALL_TARGET_HT40_23], 24) |
+		  POW_SM(pPwrArray[ALL_TARGET_HT40_22], 16) |
+		  POW_SM(pPwrArray[ALL_TARGET_HT20_23], 8) |
+		  POW_SM(pPwrArray[ALL_TARGET_HT20_22], 0)
+	    );
+
+	/*
+	 * Write the HT40 power per rate set
+	 * correct PAR difference between HT40 and HT20/LEGACY
+	 * 0/8/16 (LSB), 1-3/9-11/17-19, 4, 5 (MSB)
+	 */
+	REG_WRITE(ah, 0xa3d8,
+		  POW_SM(pPwrArray[ALL_TARGET_HT40_5], 24) |
+		  POW_SM(pPwrArray[ALL_TARGET_HT40_4], 16) |
+		  POW_SM(pPwrArray[ALL_TARGET_HT40_1_3_9_11_17_19], 8) |
+		  POW_SM(pPwrArray[ALL_TARGET_HT40_0_8_16], 0)
+	    );
+
+	/* 6 (LSB), 7, 12, 13 (MSB) */
+	REG_WRITE(ah, 0xa3dc,
+		  POW_SM(pPwrArray[ALL_TARGET_HT40_13], 24) |
+		  POW_SM(pPwrArray[ALL_TARGET_HT40_12], 16) |
+		  POW_SM(pPwrArray[ALL_TARGET_HT40_7], 8) |
+		  POW_SM(pPwrArray[ALL_TARGET_HT40_6], 0)
+	    );
+
+	/* 14 (LSB), 15, 20, 21 */
+	REG_WRITE(ah, 0xa3ec,
+		  POW_SM(pPwrArray[ALL_TARGET_HT40_21], 24) |
+		  POW_SM(pPwrArray[ALL_TARGET_HT40_20], 16) |
+		  POW_SM(pPwrArray[ALL_TARGET_HT40_15], 8) |
+		  POW_SM(pPwrArray[ALL_TARGET_HT40_14], 0)
+	    );
+
+	return 0;
+#undef POW_SM
+}
+
+static void ar9003_hw_set_target_power_eeprom(struct ath_hw *ah, u16 freq)
+{
+	u8 targetPowerValT2[ar9300RateSize];
+	/* XXX: hard code for now, need to get from eeprom struct */
+	u8 ht40PowerIncForPdadc = 0;
+	bool is2GHz = false;
+	unsigned int i = 0;
+	struct ath_common *common = ath9k_hw_common(ah);
+
+	if (freq < 4000)
+		is2GHz = true;
+
+	targetPowerValT2[ALL_TARGET_LEGACY_6_24] =
+	    ar9003_hw_eeprom_get_tgt_pwr(ah, LEGACY_TARGET_RATE_6_24, freq,
+					 is2GHz);
+	targetPowerValT2[ALL_TARGET_LEGACY_36] =
+	    ar9003_hw_eeprom_get_tgt_pwr(ah, LEGACY_TARGET_RATE_36, freq,
+					 is2GHz);
+	targetPowerValT2[ALL_TARGET_LEGACY_48] =
+	    ar9003_hw_eeprom_get_tgt_pwr(ah, LEGACY_TARGET_RATE_48, freq,
+					 is2GHz);
+	targetPowerValT2[ALL_TARGET_LEGACY_54] =
+	    ar9003_hw_eeprom_get_tgt_pwr(ah, LEGACY_TARGET_RATE_54, freq,
+					 is2GHz);
+	targetPowerValT2[ALL_TARGET_LEGACY_1L_5L] =
+	    ar9003_hw_eeprom_get_cck_tgt_pwr(ah, LEGACY_TARGET_RATE_1L_5L,
+					     freq);
+	targetPowerValT2[ALL_TARGET_LEGACY_5S] =
+	    ar9003_hw_eeprom_get_cck_tgt_pwr(ah, LEGACY_TARGET_RATE_5S, freq);
+	targetPowerValT2[ALL_TARGET_LEGACY_11L] =
+	    ar9003_hw_eeprom_get_cck_tgt_pwr(ah, LEGACY_TARGET_RATE_11L, freq);
+	targetPowerValT2[ALL_TARGET_LEGACY_11S] =
+	    ar9003_hw_eeprom_get_cck_tgt_pwr(ah, LEGACY_TARGET_RATE_11S, freq);
+	targetPowerValT2[ALL_TARGET_HT20_0_8_16] =
+	    ar9003_hw_eeprom_get_ht20_tgt_pwr(ah, HT_TARGET_RATE_0_8_16, freq,
+					      is2GHz);
+	targetPowerValT2[ALL_TARGET_HT20_1_3_9_11_17_19] =
+	    ar9003_hw_eeprom_get_ht20_tgt_pwr(ah, HT_TARGET_RATE_1_3_9_11_17_19,
+					      freq, is2GHz);
+	targetPowerValT2[ALL_TARGET_HT20_4] =
+	    ar9003_hw_eeprom_get_ht20_tgt_pwr(ah, HT_TARGET_RATE_4, freq,
+					      is2GHz);
+	targetPowerValT2[ALL_TARGET_HT20_5] =
+	    ar9003_hw_eeprom_get_ht20_tgt_pwr(ah, HT_TARGET_RATE_5, freq,
+					      is2GHz);
+	targetPowerValT2[ALL_TARGET_HT20_6] =
+	    ar9003_hw_eeprom_get_ht20_tgt_pwr(ah, HT_TARGET_RATE_6, freq,
+					      is2GHz);
+	targetPowerValT2[ALL_TARGET_HT20_7] =
+	    ar9003_hw_eeprom_get_ht20_tgt_pwr(ah, HT_TARGET_RATE_7, freq,
+					      is2GHz);
+	targetPowerValT2[ALL_TARGET_HT20_12] =
+	    ar9003_hw_eeprom_get_ht20_tgt_pwr(ah, HT_TARGET_RATE_12, freq,
+					      is2GHz);
+	targetPowerValT2[ALL_TARGET_HT20_13] =
+	    ar9003_hw_eeprom_get_ht20_tgt_pwr(ah, HT_TARGET_RATE_13, freq,
+					      is2GHz);
+	targetPowerValT2[ALL_TARGET_HT20_14] =
+	    ar9003_hw_eeprom_get_ht20_tgt_pwr(ah, HT_TARGET_RATE_14, freq,
+					      is2GHz);
+	targetPowerValT2[ALL_TARGET_HT20_15] =
+	    ar9003_hw_eeprom_get_ht20_tgt_pwr(ah, HT_TARGET_RATE_15, freq,
+					      is2GHz);
+	targetPowerValT2[ALL_TARGET_HT20_20] =
+	    ar9003_hw_eeprom_get_ht20_tgt_pwr(ah, HT_TARGET_RATE_20, freq,
+					      is2GHz);
+	targetPowerValT2[ALL_TARGET_HT20_21] =
+	    ar9003_hw_eeprom_get_ht20_tgt_pwr(ah, HT_TARGET_RATE_21, freq,
+					      is2GHz);
+	targetPowerValT2[ALL_TARGET_HT20_22] =
+	    ar9003_hw_eeprom_get_ht20_tgt_pwr(ah, HT_TARGET_RATE_22, freq,
+					      is2GHz);
+	targetPowerValT2[ALL_TARGET_HT20_23] =
+	    ar9003_hw_eeprom_get_ht20_tgt_pwr(ah, HT_TARGET_RATE_23, freq,
+					      is2GHz);
+	targetPowerValT2[ALL_TARGET_HT40_0_8_16] =
+	    ar9003_hw_eeprom_get_ht40_tgt_pwr(ah, HT_TARGET_RATE_0_8_16, freq,
+					      is2GHz) + ht40PowerIncForPdadc;
+	targetPowerValT2[ALL_TARGET_HT40_1_3_9_11_17_19] =
+	    ar9003_hw_eeprom_get_ht40_tgt_pwr(ah, HT_TARGET_RATE_1_3_9_11_17_19,
+					      freq,
+					      is2GHz) + ht40PowerIncForPdadc;
+	targetPowerValT2[ALL_TARGET_HT40_4] =
+	    ar9003_hw_eeprom_get_ht40_tgt_pwr(ah, HT_TARGET_RATE_4, freq,
+					      is2GHz) + ht40PowerIncForPdadc;
+	targetPowerValT2[ALL_TARGET_HT40_5] =
+	    ar9003_hw_eeprom_get_ht40_tgt_pwr(ah, HT_TARGET_RATE_5, freq,
+					      is2GHz) + ht40PowerIncForPdadc;
+	targetPowerValT2[ALL_TARGET_HT40_6] =
+	    ar9003_hw_eeprom_get_ht40_tgt_pwr(ah, HT_TARGET_RATE_6, freq,
+					      is2GHz) + ht40PowerIncForPdadc;
+	targetPowerValT2[ALL_TARGET_HT40_7] =
+	    ar9003_hw_eeprom_get_ht40_tgt_pwr(ah, HT_TARGET_RATE_7, freq,
+					      is2GHz) + ht40PowerIncForPdadc;
+	targetPowerValT2[ALL_TARGET_HT40_12] =
+	    ar9003_hw_eeprom_get_ht40_tgt_pwr(ah, HT_TARGET_RATE_12, freq,
+					      is2GHz) + ht40PowerIncForPdadc;
+	targetPowerValT2[ALL_TARGET_HT40_13] =
+	    ar9003_hw_eeprom_get_ht40_tgt_pwr(ah, HT_TARGET_RATE_13, freq,
+					      is2GHz) + ht40PowerIncForPdadc;
+	targetPowerValT2[ALL_TARGET_HT40_14] =
+	    ar9003_hw_eeprom_get_ht40_tgt_pwr(ah, HT_TARGET_RATE_14, freq,
+					      is2GHz) + ht40PowerIncForPdadc;
+	targetPowerValT2[ALL_TARGET_HT40_15] =
+	    ar9003_hw_eeprom_get_ht40_tgt_pwr(ah, HT_TARGET_RATE_15, freq,
+					      is2GHz) + ht40PowerIncForPdadc;
+	targetPowerValT2[ALL_TARGET_HT40_20] =
+	    ar9003_hw_eeprom_get_ht40_tgt_pwr(ah, HT_TARGET_RATE_20, freq,
+					      is2GHz) + ht40PowerIncForPdadc;
+	targetPowerValT2[ALL_TARGET_HT40_21] =
+	    ar9003_hw_eeprom_get_ht40_tgt_pwr(ah, HT_TARGET_RATE_21, freq,
+					      is2GHz) + ht40PowerIncForPdadc;
+	targetPowerValT2[ALL_TARGET_HT40_22] =
+	    ar9003_hw_eeprom_get_ht40_tgt_pwr(ah, HT_TARGET_RATE_22, freq,
+					      is2GHz) + ht40PowerIncForPdadc;
+	targetPowerValT2[ALL_TARGET_HT40_23] =
+	    ar9003_hw_eeprom_get_ht40_tgt_pwr(ah, HT_TARGET_RATE_23, freq,
+					      is2GHz) + ht40PowerIncForPdadc;
+
+	while (i < ar9300RateSize) {
+		ath_print(common, ATH_DBG_EEPROM,
+			  "TPC[%02d] 0x%08x ", i, targetPowerValT2[i]);
+		i++;
+
+		ath_print(common, ATH_DBG_EEPROM,
+			  "TPC[%02d] 0x%08x ", i, targetPowerValT2[i]);
+		i++;
+
+		ath_print(common, ATH_DBG_EEPROM,
+			  "TPC[%02d] 0x%08x ", i, targetPowerValT2[i]);
+		i++;
+
+		ath_print(common, ATH_DBG_EEPROM,
+			  "TPC[%02d] 0x%08x\n", i, targetPowerValT2[i]);
+		i++;
+	}
+
+	/* Write target power array to registers */
+	ar9003_hw_tx_power_regwrite(ah, targetPowerValT2);
+}
+
+static int ar9003_hw_cal_pier_get(struct ath_hw *ah,
+				  int mode,
+				  int ipier,
+				  int ichain,
+				  int *pfrequency,
+				  int *pcorrection,
+				  int *ptemperature, int *pvoltage)
+{
+	u8 *pCalPier;
+	struct ar9300_cal_data_per_freq_op_loop *pCalPierStruct;
+	int is2GHz;
+	struct ar9300_eeprom *eep = &ah->eeprom.ar9300_eep;
+	struct ath_common *common = ath9k_hw_common(ah);
+
+	if (ichain >= AR9300_MAX_CHAINS) {
+		ath_print(common, ATH_DBG_EEPROM,
+			  "Invalid chain index, must be less than %d\n",
+			  AR9300_MAX_CHAINS);
+		return -1;
+	}
+
+	if (mode) {		/* 5GHz */
+		if (ipier >= AR9300_NUM_5G_CAL_PIERS) {
+			ath_print(common, ATH_DBG_EEPROM,
+				  "Invalid 5GHz cal pier index, must "
+				  "be less than %d\n",
+				  AR9300_NUM_5G_CAL_PIERS);
+			return -1;
+		}
+		pCalPier = &(eep->calFreqPier5G[ipier]);
+		pCalPierStruct = &(eep->calPierData5G[ichain][ipier]);
+		is2GHz = 0;
+	} else {
+		if (ipier >= AR9300_NUM_2G_CAL_PIERS) {
+			ath_print(common, ATH_DBG_EEPROM,
+				  "Invalid 2GHz cal pier index, must "
+				  "be less than %d\n", AR9300_NUM_2G_CAL_PIERS);
+			return -1;
+		}
+
+		pCalPier = &(eep->calFreqPier2G[ipier]);
+		pCalPierStruct = &(eep->calPierData2G[ichain][ipier]);
+		is2GHz = 1;
+	}
+
+	*pfrequency = FBIN2FREQ(*pCalPier, is2GHz);
+	*pcorrection = pCalPierStruct->refPower;
+	*ptemperature = pCalPierStruct->tempMeas;
+	*pvoltage = pCalPierStruct->voltMeas;
+
+	return 0;
+}
+
+static int ar9003_hw_power_control_override(struct ath_hw *ah,
+					    int frequency,
+					    int *correction,
+					    int *voltage, int *temperature)
+{
+	int tempSlope = 0;
+	struct ar9300_eeprom *eep = &ah->eeprom.ar9300_eep;
+
+	REG_RMW(ah, AR_PHY_TPC_11_B0,
+		(correction[0] << AR_PHY_TPC_OLPC_GAIN_DELTA_S),
+		AR_PHY_TPC_OLPC_GAIN_DELTA);
+	REG_RMW(ah, AR_PHY_TPC_11_B1,
+		(correction[1] << AR_PHY_TPC_OLPC_GAIN_DELTA_S),
+		AR_PHY_TPC_OLPC_GAIN_DELTA);
+	REG_RMW(ah, AR_PHY_TPC_11_B2,
+		(correction[2] << AR_PHY_TPC_OLPC_GAIN_DELTA_S),
+		AR_PHY_TPC_OLPC_GAIN_DELTA);
+
+	/* enable open loop power control on chip */
+	REG_RMW(ah, AR_PHY_TPC_6_B0,
+		(3 << AR_PHY_TPC_6_ERROR_EST_MODE_S),
+		AR_PHY_TPC_6_ERROR_EST_MODE);
+	REG_RMW(ah, AR_PHY_TPC_6_B1,
+		(3 << AR_PHY_TPC_6_ERROR_EST_MODE_S),
+		AR_PHY_TPC_6_ERROR_EST_MODE);
+	REG_RMW(ah, AR_PHY_TPC_6_B2,
+		(3 << AR_PHY_TPC_6_ERROR_EST_MODE_S),
+		AR_PHY_TPC_6_ERROR_EST_MODE);
+
+	/*
+	 * enable temperature compensation
+	 * Need to use register names
+	 */
+	if (frequency < 4000)
+		tempSlope = eep->modalHeader2G.tempSlope;
+	else
+		tempSlope = eep->modalHeader5G.tempSlope;
+
+	REG_RMW_FIELD(ah, AR_PHY_TPC_19, AR_PHY_TPC_19_ALPHA_THERM, tempSlope);
+	REG_RMW_FIELD(ah, AR_PHY_TPC_18, AR_PHY_TPC_18_THERM_CAL_VALUE,
+		      temperature[0]);
+
+	return 0;
+}
+
+/* Apply the recorded correction values. */
+static int ar9003_hw_calibration_apply(struct ath_hw *ah, int frequency)
+{
+	int ichain, ipier, npier;
+	int mode;
+	int lfrequency[AR9300_MAX_CHAINS],
+	    lcorrection[AR9300_MAX_CHAINS],
+	    ltemperature[AR9300_MAX_CHAINS], lvoltage[AR9300_MAX_CHAINS];
+	int hfrequency[AR9300_MAX_CHAINS],
+	    hcorrection[AR9300_MAX_CHAINS],
+	    htemperature[AR9300_MAX_CHAINS], hvoltage[AR9300_MAX_CHAINS];
+	int fdiff;
+	int correction[AR9300_MAX_CHAINS],
+	    voltage[AR9300_MAX_CHAINS], temperature[AR9300_MAX_CHAINS];
+	int pfrequency, pcorrection, ptemperature, pvoltage;
+	struct ath_common *common = ath9k_hw_common(ah);
+
+	mode = (frequency >= 4000);
+	if (mode)
+		npier = AR9300_NUM_5G_CAL_PIERS;
+	else
+		npier = AR9300_NUM_2G_CAL_PIERS;
+
+	for (ichain = 0; ichain < AR9300_MAX_CHAINS; ichain++) {
+		lfrequency[ichain] = 0;
+		hfrequency[ichain] = 100000;
+	}
+	/* identify best lower and higher frequency calibration measurement */
+	for (ichain = 0; ichain < AR9300_MAX_CHAINS; ichain++) {
+		for (ipier = 0; ipier < npier; ipier++) {
+			if (!ar9003_hw_cal_pier_get(ah, mode, ipier, ichain,
+						    &pfrequency, &pcorrection,
+						    &ptemperature, &pvoltage)) {
+				fdiff = frequency - pfrequency;
+
+				/*
+				 * this measurement is higher than
+				 * our desired frequency
+				 */
+				if (fdiff <= 0) {
+					if (hfrequency[ichain] <= 0 ||
+					    hfrequency[ichain] >= 100000 ||
+					    fdiff >
+					    (frequency - hfrequency[ichain])) {
+						/*
+						 * new best higher
+						 * frequency measurement
+						 */
+						hfrequency[ichain] = pfrequency;
+						hcorrection[ichain] =
+						    pcorrection;
+						htemperature[ichain] =
+						    ptemperature;
+						hvoltage[ichain] = pvoltage;
+					}
+				}
+				if (fdiff >= 0) {
+					if (lfrequency[ichain] <= 0
+					    || fdiff <
+					    (frequency - lfrequency[ichain])) {
+						/*
+						 * new best lower
+						 * frequency measurement
+						 */
+						lfrequency[ichain] = pfrequency;
+						lcorrection[ichain] =
+						    pcorrection;
+						ltemperature[ichain] =
+						    ptemperature;
+						lvoltage[ichain] = pvoltage;
+					}
+				}
+			}
+		}
+	}
+
+	/* interpolate  */
+	for (ichain = 0; ichain < AR9300_MAX_CHAINS; ichain++) {
+		ath_print(common, ATH_DBG_EEPROM,
+			  "ch=%d f=%d low=%d %d h=%d %d\n",
+			  ichain, frequency, lfrequency[ichain],
+			  lcorrection[ichain], hfrequency[ichain],
+			  hcorrection[ichain]);
+		/* they're the same, so just pick one */
+		if (hfrequency[ichain] == lfrequency[ichain]) {
+			correction[ichain] = lcorrection[ichain];
+			voltage[ichain] = lvoltage[ichain];
+			temperature[ichain] = ltemperature[ichain];
+		}
+		/* the low frequency is good */
+		else if (frequency - lfrequency[ichain] < 1000) {
+			/* so is the high frequency, interpolate */
+			if (hfrequency[ichain] - frequency < 1000) {
+
+				correction[ichain] = lcorrection[ichain] +
+				    (((frequency - lfrequency[ichain]) *
+				      (hcorrection[ichain] -
+				       lcorrection[ichain])) /
+				     (hfrequency[ichain] - lfrequency[ichain]));
+
+				temperature[ichain] = ltemperature[ichain] +
+				    (((frequency - lfrequency[ichain]) *
+				      (htemperature[ichain] -
+				       ltemperature[ichain])) /
+				     (hfrequency[ichain] - lfrequency[ichain]));
+
+				voltage[ichain] =
+				    lvoltage[ichain] +
+				    (((frequency -
+				       lfrequency[ichain]) * (hvoltage[ichain] -
+							      lvoltage[ichain]))
+				     / (hfrequency[ichain] -
+					lfrequency[ichain]));
+			}
+			/* only low is good, use it */
+			else {
+				correction[ichain] = lcorrection[ichain];
+				temperature[ichain] = ltemperature[ichain];
+				voltage[ichain] = lvoltage[ichain];
+			}
+		}
+		/* only high is good, use it */
+		else if (hfrequency[ichain] - frequency < 1000) {
+			correction[ichain] = hcorrection[ichain];
+			temperature[ichain] = htemperature[ichain];
+			voltage[ichain] = hvoltage[ichain];
+		} else {	/* nothing is good, presume 0???? */
+			correction[ichain] = 0;
+			temperature[ichain] = 0;
+			voltage[ichain] = 0;
+		}
+	}
+
+	ar9003_hw_power_control_override(ah, frequency, correction, voltage,
+					 temperature);
+
+	ath_print(common, ATH_DBG_EEPROM,
+		  "for frequency=%d, calibration correction = %d %d %d\n",
+		  frequency, correction[0], correction[1], correction[2]);
+
+	return 0;
+}
+
+static void ath9k_hw_ar9300_set_txpower(struct ath_hw *ah,
+					struct ath9k_channel *chan, u16 cfgCtl,
+					u8 twiceAntennaReduction,
+					u8 twiceMaxRegulatoryPower,
+					u8 powerLimit)
+{
+	ar9003_hw_set_target_power_eeprom(ah, chan->channel);
+	ar9003_hw_calibration_apply(ah, chan->channel);
+}
+
+static u16 ath9k_hw_ar9300_get_spur_channel(struct ath_hw *ah,
+					    u16 i, bool is2GHz)
+{
+	return AR_NO_SPUR;
+}
+
+const struct eeprom_ops eep_ar9300_ops = {
+	.check_eeprom = ath9k_hw_ar9300_check_eeprom,
+	.get_eeprom = ath9k_hw_ar9300_get_eeprom,
+	.fill_eeprom = ath9k_hw_ar9300_fill_eeprom,
+	.get_eeprom_ver = ath9k_hw_ar9300_get_eeprom_ver,
+	.get_eeprom_rev = ath9k_hw_ar9300_get_eeprom_rev,
+	.get_num_ant_config = ath9k_hw_ar9300_get_num_ant_config,
+	.get_eeprom_antenna_cfg = ath9k_hw_ar9300_get_eeprom_antenna_cfg,
+	.set_board_values = ath9k_hw_ar9300_set_board_values,
+	.set_addac = ath9k_hw_ar9300_set_addac,
+	.set_txpower = ath9k_hw_ar9300_set_txpower,
+	.get_spur_channel = ath9k_hw_ar9300_get_spur_channel
+};
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.h b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.h
new file mode 100644
index 0000000..3ca520c
--- /dev/null
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.h
@@ -0,0 +1,319 @@
+#ifndef AR9003_EEPROM_H
+#define AR9003_EEPROM_H
+
+#include <linux/types.h>
+
+#define AR9300_EEP_VER               0xD000
+#define AR9300_EEP_VER_MINOR_MASK    0xFFF
+#define AR9300_EEP_MINOR_VER_1       0x1
+#define AR9300_EEP_MINOR_VER         AR9300_EEP_MINOR_VER_1
+
+/* 16-bit offset location start of calibration struct */
+#define AR9300_EEP_START_LOC         256
+#define AR9300_NUM_5G_CAL_PIERS      8
+#define AR9300_NUM_2G_CAL_PIERS      3
+#define AR9300_NUM_5G_20_TARGET_POWERS  8
+#define AR9300_NUM_5G_40_TARGET_POWERS  8
+#define AR9300_NUM_2G_CCK_TARGET_POWERS 2
+#define AR9300_NUM_2G_20_TARGET_POWERS  3
+#define AR9300_NUM_2G_40_TARGET_POWERS  3
+/* #define AR9300_NUM_CTLS              21 */
+#define AR9300_NUM_CTLS_5G           9
+#define AR9300_NUM_CTLS_2G           12
+#define AR9300_CTL_MODE_M            0xF
+#define AR9300_NUM_BAND_EDGES_5G     8
+#define AR9300_NUM_BAND_EDGES_2G     4
+#define AR9300_NUM_PD_GAINS          4
+#define AR9300_PD_GAINS_IN_MASK      4
+#define AR9300_PD_GAIN_ICEPTS        5
+#define AR9300_EEPROM_MODAL_SPURS    5
+#define AR9300_MAX_RATE_POWER        63
+#define AR9300_NUM_PDADC_VALUES      128
+#define AR9300_NUM_RATES             16
+#define AR9300_BCHAN_UNUSED          0xFF
+#define AR9300_MAX_PWR_RANGE_IN_HALF_DB 64
+#define AR9300_OPFLAGS_11A           0x01
+#define AR9300_OPFLAGS_11G           0x02
+#define AR9300_OPFLAGS_5G_HT40       0x04
+#define AR9300_OPFLAGS_2G_HT40       0x08
+#define AR9300_OPFLAGS_5G_HT20       0x10
+#define AR9300_OPFLAGS_2G_HT20       0x20
+#define AR9300_EEPMISC_BIG_ENDIAN    0x01
+#define AR9300_EEPMISC_WOW           0x02
+#define AR9300_CUSTOMER_DATA_SIZE    20
+
+#define FREQ2FBIN(x, y) ((y) ? ((x) - 2300) : (((x) - 4800) / 5))
+#define FBIN2FREQ(x, y) ((y) ? (2300 + x) : (4800 + 5 * x))
+#define AR9300_MAX_CHAINS            3
+#define AR9300_ANT_16S               25
+#define AR9300_FUTURE_MODAL_SZ       6
+
+#define AR9300_NUM_ANT_CHAIN_FIELDS     7
+#define AR9300_NUM_ANT_COMMON_FIELDS    4
+#define AR9300_SIZE_ANT_CHAIN_FIELD     3
+#define AR9300_SIZE_ANT_COMMON_FIELD    4
+#define AR9300_ANT_CHAIN_MASK           0x7
+#define AR9300_ANT_COMMON_MASK          0xf
+#define AR9300_CHAIN_0_IDX              0
+#define AR9300_CHAIN_1_IDX              1
+#define AR9300_CHAIN_2_IDX              2
+
+#define AR928X_NUM_ANT_CHAIN_FIELDS     6
+#define AR928X_SIZE_ANT_CHAIN_FIELD     2
+#define AR928X_ANT_CHAIN_MASK           0x3
+
+/* Delta from which to start power to pdadc table */
+/* This offset is used in both open loop and closed loop power control
+ * schemes. In open loop power control, it is not really needed, but for
+ * the "sake of consistency" it was kept. For certain AP designs, this
+ * value is overwritten by the value in the flag "pwrTableOffset" just
+ * before writing the pdadc vs pwr into the chip registers.
+ */
+#define AR9300_PWR_TABLE_OFFSET  0
+
+/* enable flags for voltage and temp compensation */
+#define ENABLE_TEMP_COMPENSATION 0x01
+#define ENABLE_VOLT_COMPENSATION 0x02
+/* byte addressable */
+#define AR9300_EEPROM_SIZE (16*1024)
+#define FIXED_CCA_THRESHOLD 15
+
+#define AR9300_BASE_ADDR 0x3ff
+
+enum targetPowerHTRates {
+	HT_TARGET_RATE_0_8_16,
+	HT_TARGET_RATE_1_3_9_11_17_19,
+	HT_TARGET_RATE_4,
+	HT_TARGET_RATE_5,
+	HT_TARGET_RATE_6,
+	HT_TARGET_RATE_7,
+	HT_TARGET_RATE_12,
+	HT_TARGET_RATE_13,
+	HT_TARGET_RATE_14,
+	HT_TARGET_RATE_15,
+	HT_TARGET_RATE_20,
+	HT_TARGET_RATE_21,
+	HT_TARGET_RATE_22,
+	HT_TARGET_RATE_23
+};
+
+enum targetPowerLegacyRates {
+	LEGACY_TARGET_RATE_6_24,
+	LEGACY_TARGET_RATE_36,
+	LEGACY_TARGET_RATE_48,
+	LEGACY_TARGET_RATE_54
+};
+
+enum targetPowerCckRates {
+	LEGACY_TARGET_RATE_1L_5L,
+	LEGACY_TARGET_RATE_5S,
+	LEGACY_TARGET_RATE_11L,
+	LEGACY_TARGET_RATE_11S
+};
+
+enum ar9300_Rates {
+	ALL_TARGET_LEGACY_6_24,
+	ALL_TARGET_LEGACY_36,
+	ALL_TARGET_LEGACY_48,
+	ALL_TARGET_LEGACY_54,
+	ALL_TARGET_LEGACY_1L_5L,
+	ALL_TARGET_LEGACY_5S,
+	ALL_TARGET_LEGACY_11L,
+	ALL_TARGET_LEGACY_11S,
+	ALL_TARGET_HT20_0_8_16,
+	ALL_TARGET_HT20_1_3_9_11_17_19,
+	ALL_TARGET_HT20_4,
+	ALL_TARGET_HT20_5,
+	ALL_TARGET_HT20_6,
+	ALL_TARGET_HT20_7,
+	ALL_TARGET_HT20_12,
+	ALL_TARGET_HT20_13,
+	ALL_TARGET_HT20_14,
+	ALL_TARGET_HT20_15,
+	ALL_TARGET_HT20_20,
+	ALL_TARGET_HT20_21,
+	ALL_TARGET_HT20_22,
+	ALL_TARGET_HT20_23,
+	ALL_TARGET_HT40_0_8_16,
+	ALL_TARGET_HT40_1_3_9_11_17_19,
+	ALL_TARGET_HT40_4,
+	ALL_TARGET_HT40_5,
+	ALL_TARGET_HT40_6,
+	ALL_TARGET_HT40_7,
+	ALL_TARGET_HT40_12,
+	ALL_TARGET_HT40_13,
+	ALL_TARGET_HT40_14,
+	ALL_TARGET_HT40_15,
+	ALL_TARGET_HT40_20,
+	ALL_TARGET_HT40_21,
+	ALL_TARGET_HT40_22,
+	ALL_TARGET_HT40_23,
+	ar9300RateSize,
+};
+
+
+struct eepFlags {
+	u8 opFlags;
+	u8 eepMisc;
+} __packed;
+
+enum CompressAlgorithm {
+	_CompressNone = 0,
+	_CompressLzma,
+	_CompressPairs,
+	_CompressBlock,
+	_Compress4,
+	_Compress5,
+	_Compress6,
+	_Compress7,
+};
+
+struct ar9300_base_eep_hdr {
+	u16 regDmn[2];
+	/* 4 bits tx and 4 bits rx */
+	u8 txrxMask;
+	struct eepFlags opCapFlags;
+	u8 rfSilent;
+	u8 blueToothOptions;
+	u8 deviceCap;
+	/* takes lower byte in eeprom location */
+	u8 deviceType;
+	/* offset in dB to be added to beginning
+	 * of pdadc table in calibration
+	 */
+	int8_t pwrTableOffset;
+	u8 params_for_tuning_caps[2];
+	/*
+	 * bit0 - enable tx temp comp
+	 * bit1 - enable tx volt comp
+	 * bit2 - enable fastClock - default to 1
+	 * bit3 - enable doubling - default to 1
+	 * bit4 - enable internal regulator - default to 1
+	 */
+	u8 featureEnable;
+	/* misc flags: bit0 - turn down drivestrength */
+	u8 miscConfiguration;
+	u8 eepromWriteEnableGpio;
+	u8 wlanDisableGpio;
+	u8 wlanLedGpio;
+	u8 rxBandSelectGpio;
+	u8 txrxgain;
+	/* SW controlled internal regulator fields */
+	u32 swreg;
+} __packed;
+
+struct ar9300_modal_eep_header {
+	/* 4 idle, t1, t2, b (4 bits per setting) */
+	u32 antCtrlCommon;
+	/* 4 ra1l1, ra2l1, ra1l2, ra2l2, ra12 */
+	u32 antCtrlCommon2;
+	/* 6 idle, t, r, rx1, rx12, b (2 bits each) */
+	u16 antCtrlChain[AR9300_MAX_CHAINS];
+	/* 3 xatten1_db for AR9280 (0xa20c/b20c 5:0) */
+	u8 xatten1DB[AR9300_MAX_CHAINS];
+	/* 3  xatten1_margin for merlin (0xa20c/b20c 16:12 */
+	u8 xatten1Margin[AR9300_MAX_CHAINS];
+	int8_t tempSlope;
+	int8_t voltSlope;
+	/* spur channels in usual fbin coding format */
+	u8 spurChans[AR9300_EEPROM_MODAL_SPURS];
+	/* 3  Check if the register is per chain */
+	int8_t noiseFloorThreshCh[AR9300_MAX_CHAINS];
+	u8 ob[AR9300_MAX_CHAINS];
+	u8 db_stage2[AR9300_MAX_CHAINS];
+	u8 db_stage3[AR9300_MAX_CHAINS];
+	u8 db_stage4[AR9300_MAX_CHAINS];
+	u8 xpaBiasLvl;
+	u8 txFrameToDataStart;
+	u8 txFrameToPaOn;
+	u8 txClip;
+	int8_t antennaGain;
+	u8 switchSettling;
+	int8_t adcDesiredSize;
+	u8 txEndToXpaOff;
+	u8 txEndToRxOn;
+	u8 txFrameToXpaOn;
+	u8 thresh62;
+	u8 futureModal[32];
+} __packed;
+
+struct ar9300_cal_data_per_freq_op_loop {
+	int8_t refPower;
+	/* pdadc voltage at power measurement */
+	u8 voltMeas;
+	/* pcdac used for power measurement   */
+	u8 tempMeas;
+	/* range is -60 to -127 create a mapping equation 1db resolution */
+	int8_t rxNoisefloorCal;
+	/*range is same as noisefloor */
+	int8_t rxNoisefloorPower;
+	/* temp measured when noisefloor cal was performed */
+	u8 rxTempMeas;
+} __packed;
+
+struct cal_tgt_pow_legacy {
+	u8 tPow2x[4];
+} __packed;
+
+struct cal_tgt_pow_ht {
+	u8 tPow2x[14];
+} __packed;
+
+struct cal_ctl_edge_pwr {
+	u8 tPower:6,
+	   flag:2;
+} __packed;
+
+struct cal_ctl_data_2g {
+	struct cal_ctl_edge_pwr ctlEdges[AR9300_NUM_BAND_EDGES_5G];
+} __packed;
+
+struct cal_ctl_data_5g {
+	struct cal_ctl_edge_pwr ctlEdges[AR9300_NUM_BAND_EDGES_5G];
+} __packed;
+
+struct ar9300_eeprom {
+	u8 eepromVersion;
+	u8 templateVersion;
+	u8 macAddr[6];
+	u8 custData[AR9300_CUSTOMER_DATA_SIZE];
+
+	struct ar9300_base_eep_hdr baseEepHeader;
+
+	struct ar9300_modal_eep_header modalHeader2G;
+	u8 calFreqPier2G[AR9300_NUM_2G_CAL_PIERS];
+	struct ar9300_cal_data_per_freq_op_loop
+	 calPierData2G[AR9300_MAX_CHAINS][AR9300_NUM_2G_CAL_PIERS];
+	u8 calTarget_freqbin_Cck[AR9300_NUM_2G_CCK_TARGET_POWERS];
+	u8 calTarget_freqbin_2G[AR9300_NUM_2G_20_TARGET_POWERS];
+	u8 calTarget_freqbin_2GHT20[AR9300_NUM_2G_20_TARGET_POWERS];
+	u8 calTarget_freqbin_2GHT40[AR9300_NUM_2G_40_TARGET_POWERS];
+	struct cal_tgt_pow_legacy
+	 calTargetPowerCck[AR9300_NUM_2G_CCK_TARGET_POWERS];
+	struct cal_tgt_pow_legacy
+	 calTargetPower2G[AR9300_NUM_2G_20_TARGET_POWERS];
+	struct cal_tgt_pow_ht
+	 calTargetPower2GHT20[AR9300_NUM_2G_20_TARGET_POWERS];
+	struct cal_tgt_pow_ht
+	 calTargetPower2GHT40[AR9300_NUM_2G_40_TARGET_POWERS];
+	u8 ctlIndex_2G[AR9300_NUM_CTLS_2G];
+	u8 ctl_freqbin_2G[AR9300_NUM_CTLS_2G][AR9300_NUM_BAND_EDGES_2G];
+	struct cal_ctl_data_2g ctlPowerData_2G[AR9300_NUM_CTLS_2G];
+	struct ar9300_modal_eep_header modalHeader5G;
+	u8 calFreqPier5G[AR9300_NUM_5G_CAL_PIERS];
+	struct ar9300_cal_data_per_freq_op_loop
+	 calPierData5G[AR9300_MAX_CHAINS][AR9300_NUM_5G_CAL_PIERS];
+	u8 calTarget_freqbin_5G[AR9300_NUM_5G_20_TARGET_POWERS];
+	u8 calTarget_freqbin_5GHT20[AR9300_NUM_5G_20_TARGET_POWERS];
+	u8 calTarget_freqbin_5GHT40[AR9300_NUM_5G_40_TARGET_POWERS];
+	struct cal_tgt_pow_legacy
+	 calTargetPower5G[AR9300_NUM_5G_20_TARGET_POWERS];
+	struct cal_tgt_pow_ht
+	 calTargetPower5GHT20[AR9300_NUM_5G_20_TARGET_POWERS];
+	struct cal_tgt_pow_ht
+	 calTargetPower5GHT40[AR9300_NUM_5G_40_TARGET_POWERS];
+	u8 ctlIndex_5G[AR9300_NUM_CTLS_5G];
+	u8 ctl_freqbin_5G[AR9300_NUM_CTLS_5G][AR9300_NUM_BAND_EDGES_5G];
+	struct cal_ctl_data_5g ctlPowerData_5G[AR9300_NUM_CTLS_5G];
+} __packed;
+#endif
diff --git a/drivers/net/wireless/ath/ath9k/eeprom.c b/drivers/net/wireless/ath/ath9k/eeprom.c
index aec6ebb..bd9dff3 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom.c
@@ -256,7 +256,9 @@ int ath9k_hw_eeprom_init(struct ath_hw *ah)
 {
 	int status;
 
-	if (AR_SREV_9287(ah)) {
+	if (AR_SREV_9300_20_OR_LATER(ah))
+		ah->eep_ops = &eep_ar9300_ops;
+	else if (AR_SREV_9287(ah)) {
 		ah->eep_ops = &eep_ar9287_ops;
 	} else if (AR_SREV_9285(ah) || AR_SREV_9271(ah)) {
 		ah->eep_ops = &eep_4k_ops;
diff --git a/drivers/net/wireless/ath/ath9k/eeprom.h b/drivers/net/wireless/ath/ath9k/eeprom.h
index 289084c..fb9c8c9 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom.h
+++ b/drivers/net/wireless/ath/ath9k/eeprom.h
@@ -19,6 +19,7 @@
 
 #include "../ath.h"
 #include <net/cfg80211.h>
+#include "ar9003_eeprom.h"
 
 #define AH_USE_EEPROM   0x1
 
@@ -249,16 +250,20 @@ enum eeprom_param {
 	EEP_MINOR_REV,
 	EEP_TX_MASK,
 	EEP_RX_MASK,
+	EEP_FSTCLK_5G,
 	EEP_RXGAIN_TYPE,
-	EEP_TXGAIN_TYPE,
 	EEP_OL_PWRCTRL,
+	EEP_TXGAIN_TYPE,
 	EEP_RC_CHAIN_MASK,
 	EEP_DAC_HPWR_5G,
 	EEP_FRAC_N_5G,
 	EEP_DEV_TYPE,
 	EEP_TEMPSENSE_SLOPE,
 	EEP_TEMPSENSE_SLOPE_PAL_ON,
-	EEP_PWR_TABLE_OFFSET
+	EEP_PWR_TABLE_OFFSET,
+	EEP_DRIVE_STRENGTH,
+	EEP_INTERNAL_REGULATOR,
+	EEP_SWREG
 };
 
 enum ar5416_rates {
@@ -707,5 +712,7 @@ int ath9k_hw_eeprom_init(struct ath_hw *ah);
 extern const struct eeprom_ops eep_def_ops;
 extern const struct eeprom_ops eep_4k_ops;
 extern const struct eeprom_ops eep_ar9287_ops;
+extern const struct eeprom_ops eep_ar9287_ops;
+extern const struct eeprom_ops eep_ar9300_ops;
 
 #endif /* EEPROM_H */
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index cb0421a..d1b9940 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -568,6 +568,7 @@ struct ath_hw {
 		struct ar5416_eeprom_def def;
 		struct ar5416_eeprom_4k map4k;
 		struct ar9287_eeprom map9287;
+		struct ar9300_eeprom ar9300_eep;
 	} eeprom;
 	const struct eeprom_ops *eep_ops;
 
diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
index aacc29a..12de95e 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -1070,6 +1070,16 @@ enum {
 #define AR_RTC_RC_COLD_RESET    0x00000004
 #define AR_RTC_RC_WARM_RESET    0x00000008
 
+/* Crystal Control */
+#define AR_RTC_XTAL_CONTROL     0x7004
+
+/* Reg Control 0 */
+#define AR_RTC_REG_CONTROL0     0x7008
+
+/* Reg Control 1 */
+#define AR_RTC_REG_CONTROL1     0x700c
+#define AR_RTC_REG_CONTROL1_SWREG_PROGRAM       0x00000001
+
 #define AR_RTC_PLL_CONTROL \
 	((AR_SREV_9100(ah)) ? (AR_RTC_BASE + 0x0014) : 0x7014)
 
@@ -1100,6 +1110,7 @@ enum {
 #define AR_RTC_SLEEP_CLK \
 	((AR_SREV_9100(ah)) ? (AR_RTC_BASE + 0x0048) : 0x7048)
 #define AR_RTC_FORCE_DERIVED_CLK    0x2
+#define AR_RTC_FORCE_SWREG_PRD      0x00000004
 
 #define AR_RTC_FORCE_WAKE \
 	((AR_SREV_9100(ah)) ? (AR_RTC_BASE + 0x004c) : 0x704c)
-- 
1.6.3.3

