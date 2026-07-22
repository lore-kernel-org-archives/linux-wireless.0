Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9279A41D10C
	for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2026 20:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784750663; cv=none; b=BeDAbC5XjbcNEPAWp7ETWk8dDSfHF0uNIuCwfDkqB1SOVtmSrE1a7ERJ9j4ihA4g1JSPlz26DU4iKwf/+mprt0eP74ATOiEDkUM0EHrzozXLhbk/Tm6oLxboSnGTFekfRiG9CHslcZIcoqtpAE6TzYiu1Ud3Vl+zyh3eOBLUmaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784750663; c=relaxed/simple;
	bh=ijKiw39JWHYiHz9TmcuSWw4iMuSFa/FP/N9ggjFIZ/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=n2IDZwbVFxkdnxerHlIkI6stajtBbQElNJoUDIVgICTge7sRmYkET0uPuZakxu3HlhcvwGkomDoGNqp5cVEuLlU6OigCxsUZ/tRNZQxMSvptfKuj/4yUsp0UIoQ6pOvy02MvXh5cFOFf9RLni/DlsKxVOAqt+HCxDkfpEOJX+AY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=LlC3YAcI; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="LlC3YAcI"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784750652;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=y+kdaUNuwQ//BvL2CkNnI5tiZ5XMPnkBBZNnM4A/LK8=;
	b=LlC3YAcIKqEt5wcuq/DKygFw/NErn3ux+hK5aQW1SLeep685cfLbLEexfOeH2/5CApStGo
	ElU+H1yZxVpjBUSRNtDvQTwsVtfY/KkvNGyM0M+/uudBg/r1iiYSKRF/YbLPju0moS6oNB
	/ZitA7qlkFnQ8HIoe1o3KV5Mk7naQK4=
From: luka.gejak@linux.dev
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Michael Straube <straube.linux@gmail.com>,
	Peter Robinson <pbrobinson@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Luka Gejak <luka.gejak@linux.dev>
Subject: [PATCH v2 2/4] wifi: rtw88: 8723b: add RTL8723B chip support
Date: Wed, 22 Jul 2026 22:03:29 +0200
Message-ID: <20260722200337.135150-3-luka.gejak@linux.dev>
In-Reply-To: <20260722200337.135150-1-luka.gejak@linux.dev>
References: <20260722200337.135150-1-luka.gejak@linux.dev>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Luka Gejak <luka.gejak@linux.dev>

Add the Realtek RTL8723B 802.11n chip driver: the chip operations, the
BB/RF/AGC parameter tables, the power sequences, and the RTL8723BS SDIO
bind.

The shared core handling this builds on was added by the previous patch.
The driver is not built yet; the Kconfig and Makefile entries follow.

The RTL8723B chip support is based on the initial work by
Michael Straube <straube.linux@gmail.com>.
Link: https://github.com/mistraube/rtw88/tree/rtl8723bs

Signed-off-by: Luka Gejak <luka.gejak@linux.dev>
---
 drivers/net/wireless/realtek/rtw88/rtw8723b.c | 3094 +++++++++++++++++
 drivers/net/wireless/realtek/rtw88/rtw8723b.h |   16 +
 .../wireless/realtek/rtw88/rtw8723b_table.c   |  862 +++++
 .../wireless/realtek/rtw88/rtw8723b_table.h   |   18 +
 .../net/wireless/realtek/rtw88/rtw8723bs.c    |   39 +
 5 files changed, 4029 insertions(+)
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8723b.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8723b.h
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8723b_table.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8723b_table.h
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8723bs.c

diff --git a/drivers/net/wireless/realtek/rtw88/rtw8723b.c b/drivers/net/wireless/realtek/rtw88/rtw8723b.c
new file mode 100644
index 000000000000..ef9ac4548ad9
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtw88/rtw8723b.c
@@ -0,0 +1,3094 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+/*
+ * Copyright(c) 2007-2017  Realtek Corporation
+ * Copyright(c) Michael Straube <straube.linux@gmail.com>
+ * Copyright(c) 2024-2026 Luka Gejak <luka.gejak@linux.dev>
+ */
+
+#include <linux/unaligned.h>
+#include "main.h"
+#include "coex.h"
+#include "fw.h"
+#include "mac.h"
+#include "phy.h"
+#include "rtw8703b.h"
+#include "rtw8723b.h"
+#include "rtw8723b_table.h"
+#include "sdio.h"
+#include "tx.h"
+
+#define TRANS_SEQ_END			\
+	0xFFFF,				\
+	RTW_PWR_CUT_ALL_MSK,		\
+	RTW_PWR_INTF_ALL_MSK,		\
+	0,				\
+	RTW_PWR_CMD_END, 0, 0
+
+#define TBTT_PROHIBIT_SETUP_TIME		0x04
+#define TBTT_PROHIBIT_HOLD_TIME_STOP_BCN	0x64
+#define WLAN_BCN_DMA_TIME			0x02
+#define WLAN_ANT_SEL				0x82
+#define WLAN_BAR_VAL				0x0201ffff
+#define WLAN_SLOT_TIME				0x09
+#define WLAN_SYS_FUNC_BB_ENABLE			(BIT_FEN_BB_GLB_RST | \
+						 BIT_FEN_BB_RSTB)
+#define WLAN_RF_CTRL_ENABLE			(BIT_RF_EN | BIT_RF_RSTB | \
+						 BIT_RF_SDM_RSTB)
+/*
+ * Staging and the BB table use 0x03a05611 as the normal RX path. 0x03a05600
+ * is only an IQK temporary value and must not be reasserted during scan.
+ */
+#define WLAN_RX_PATH_A_8723B			0x03a05611
+
+#define ADDA_ON_VAL_8723B			0x01c00014
+
+#define MASK_NETTYPE	0x30000
+#define _NETTYPE(x)	(((x) & 0x3) << 16)
+#define NT_LINK_AP	0x2
+
+#define WLAN_RX_FILTER0			0xFFFF
+#define WLAN_RX_FILTER1			0x400
+#define WLAN_RX_FILTER2			0xFFFF
+#define WLAN_RCR_CFG			(0x700060CE | BIT_AMF)
+
+#define IQK_DELAY_TIME_8723B		20
+
+/* REG_EARLY_MODE_CONTROL for 8723B is now in reg.h */
+
+/* local page-layout constants (no rtw88 equivalents exist); used below */
+#define BCNQ_PAGE_NUM_8723B	0x08
+#define BCNQ1_PAGE_NUM_8723B		0x00
+#define WOWLAN_PAGE_NUM_8723B		0x00
+#define TX_TOTAL_PAGE_NUMBER_8723B\
+	(0xFF - BCNQ_PAGE_NUM_8723B - BCNQ1_PAGE_NUM_8723B - \
+	 WOWLAN_PAGE_NUM_8723B)
+
+/* local TXPKTBUF boundary regs (no rtw88 equivalents exist); used below */
+
+/* rssi in percentage % (dbm = % - 100) */
+/*
+ * These are used to select simple signal quality levels, might need
+ * tweaking. Same for rf_para tables below.
+ */
+static const u8 wl_rssi_step_8723b[] = {60, 50, 44, 30};
+static const u8 bt_rssi_step_8723b[] = {30, 30, 30, 30};
+static const struct coex_5g_afh_map afh_5g_8723b[] = { {0, 0, 0} };
+
+static const struct coex_rf_para rf_para_tx_8723b[] = {
+	{0, 0, false, 7},  /* for normal */
+	{0, 10, false, 7}, /* for WL-CPT */
+	{1, 0, true, 4},
+	{1, 2, true, 4},
+	{1, 10, true, 4},
+	{1, 15, true, 4}
+};
+
+static const struct coex_rf_para rf_para_rx_8723b[] = {
+	{0, 0, false, 7},  /* for normal */
+	{0, 10, false, 7}, /* for WL-CPT */
+	{1, 0, true, 5},
+	{1, 2, true, 5},
+	{1, 10, true, 5},
+	{1, 15, true, 5}
+};
+
+static_assert(ARRAY_SIZE(rf_para_tx_8723b) == ARRAY_SIZE(rf_para_rx_8723b));
+
+static const u32 rtw8723b_ofdm_swing_table[] = {
+	0x0b40002d, /* 0, -15.0dB */
+	0x0c000030, /* 1, -14.5dB */
+	0x0cc00033, /* 2, -14.0dB */
+	0x0d800036, /* 3, -13.5dB */
+	0x0e400039, /* 4, -13.0dB */
+	0x0f00003c, /* 5, -12.5dB */
+	0x10000040, /* 6, -12.0dB */
+	0x11000044, /* 7, -11.5dB */
+	0x12000048, /* 8, -11.0dB */
+	0x1300004c, /* 9, -10.5dB */
+	0x14400051, /* 10, -10.0dB */
+	0x15800056, /* 11, -9.5dB */
+	0x16c0005b, /* 12, -9.0dB */
+	0x18000060, /* 13, -8.5dB */
+	0x19800066, /* 14, -8.0dB */
+	0x1b00006c, /* 15, -7.5dB */
+	0x1c800072, /* 16, -7.0dB */
+	0x1e400079, /* 17, -6.5dB */
+	0x20000080, /* 18, -6.0dB */
+	0x22000088, /* 19, -5.5dB */
+	0x24000090, /* 20, -5.0dB */
+	0x26000098, /* 21, -4.5dB */
+	0x288000a2, /* 22, -4.0dB */
+	0x2ac000ab, /* 23, -3.5dB */
+	0x2d4000b5, /* 24, -3.0dB */
+	0x300000c0, /* 25, -2.5dB */
+	0x32c000cb, /* 26, -2.0dB */
+	0x35c000d7, /* 27, -1.5dB */
+	0x390000e4, /* 28, -1.0dB */
+	0x3c8000f2, /* 29, -0.5dB */
+	0x40000100, /* 30, +0dB */
+	0x43c0010f, /* 31, +0.5dB */
+	0x47c0011f, /* 32, +1.0dB */
+	0x4c000130, /* 33, +1.5dB */
+	0x50800142, /* 34, +2.0dB */
+	0x55400155, /* 35, +2.5dB */
+	0x5a400169, /* 36, +3.0dB */
+	0x5fc0017f, /* 37, +3.5dB */
+	0x65400195, /* 38, +4.0dB */
+	0x6b8001ae, /* 39, +4.5dB */
+	0x71c001c7, /* 40, +5.0dB */
+	0x788001e2, /* 41, +5.5dB */
+	0x7f8001fe, /* 42, +6.0dB */
+};
+
+static const u32 rtw8723b_cck_pwr_regs[] = {
+	0x0a22, 0x0a23, 0x0a24, 0x0a25, 0x0a26, 0x0a27, 0x0a28, 0x0a29,
+};
+
+static const u8 rtw8732b_cck_swing_table_ch1_ch13[][8] = {
+	{0x09, 0x08, 0x07, 0x06, 0x04, 0x03, 0x01, 0x01},	/* 0, -16.0dB */
+	{0x09, 0x09, 0x08, 0x06, 0x05, 0x03, 0x01, 0x01},	/* 1, -15.5dB */
+	{0x0a, 0x09, 0x08, 0x07, 0x05, 0x03, 0x02, 0x01},	/* 2, -15.0dB */
+	{0x0a, 0x0a, 0x09, 0x07, 0x05, 0x03, 0x02, 0x01},	/* 3, -14.5dB */
+	{0x0b, 0x0a, 0x09, 0x08, 0x06, 0x04, 0x02, 0x01},	/* 4, -14.0dB */
+	{0x0b, 0x0b, 0x0a, 0x08, 0x06, 0x04, 0x02, 0x01},	/* 5, -13.5dB */
+	{0x0c, 0x0c, 0x0a, 0x09, 0x06, 0x04, 0x02, 0x01},	/* 6, -13.0dB */
+	{0x0d, 0x0c, 0x0b, 0x09, 0x07, 0x04, 0x02, 0x01},	/* 7, -12.5dB */
+	{0x0d, 0x0d, 0x0c, 0x0a, 0x07, 0x05, 0x02, 0x01},	/* 8, -12.0dB */
+	{0x0e, 0x0e, 0x0c, 0x0a, 0x08, 0x05, 0x02, 0x01},	/* 9, -11.5dB */
+	{0x0f, 0x0f, 0x0d, 0x0b, 0x08, 0x05, 0x03, 0x01},	/* 10, -11.0dB */
+	{0x10, 0x10, 0x0e, 0x0b, 0x08, 0x05, 0x03, 0x01},	/* 11, -10.5dB */
+	{0x11, 0x11, 0x0f, 0x0c, 0x09, 0x06, 0x03, 0x01},	/* 12, -10.0dB */
+	{0x12, 0x12, 0x0f, 0x0c, 0x09, 0x06, 0x03, 0x01},	/* 13, -9.5dB */
+	{0x13, 0x13, 0x10, 0x0d, 0x0a, 0x06, 0x03, 0x01},	/* 14, -9.0dB */
+	{0x14, 0x14, 0x11, 0x0e, 0x0b, 0x07, 0x03, 0x02},	/* 15, -8.5dB */
+	{0x16, 0x15, 0x12, 0x0f, 0x0b, 0x07, 0x04, 0x01},	/* 16, -8.0dB */
+	{0x17, 0x16, 0x13, 0x10, 0x0c, 0x08, 0x04, 0x02},	/* 17, -7.5dB */
+	{0x18, 0x17, 0x15, 0x11, 0x0c, 0x08, 0x04, 0x02},	/* 18, -7.0dB */
+	{0x1a, 0x19, 0x16, 0x12, 0x0d, 0x09, 0x04, 0x02},	/* 19, -6.5dB */
+	{0x1b, 0x1a, 0x17, 0x13, 0x0e, 0x09, 0x04, 0x02},	/* 20, -6.0dB */
+	{0x1d, 0x1c, 0x18, 0x14, 0x0f, 0x0a, 0x05, 0x02},	/* 21, -5.5dB */
+	{0x1f, 0x1e, 0x1a, 0x15, 0x10, 0x0a, 0x05, 0x02},	/* 22, -5.0dB */
+	{0x20, 0x20, 0x1b, 0x16, 0x11, 0x08, 0x05, 0x02},	/* 23, -4.5dB */
+	{0x22, 0x21, 0x1d, 0x18, 0x11, 0x0b, 0x06, 0x02},	/* 24, -4.0dB */
+	{0x24, 0x23, 0x1f, 0x19, 0x13, 0x0c, 0x06, 0x03},	/* 25, -3.5dB */
+	{0x26, 0x25, 0x21, 0x1b, 0x14, 0x0d, 0x06, 0x03},	/* 26, -3.0dB */
+	{0x28, 0x28, 0x22, 0x1c, 0x15, 0x0d, 0x07, 0x03},	/* 27, -2.5dB */
+	{0x2b, 0x2a, 0x25, 0x1e, 0x16, 0x0e, 0x07, 0x03},	/* 28, -2.0dB */
+	{0x2d, 0x2d, 0x27, 0x1f, 0x18, 0x0f, 0x08, 0x03},	/* 29, -1.5dB */
+	{0x30, 0x2f, 0x29, 0x21, 0x19, 0x10, 0x08, 0x03},	/* 30, -1.0dB */
+	{0x33, 0x32, 0x2b, 0x23, 0x1a, 0x11, 0x08, 0x04},	/* 31, -0.5dB */
+	{0x36, 0x35, 0x2e, 0x25, 0x1c, 0x12, 0x09, 0x04},	/* 32, +0dB */
+};
+
+static const u8 rtw8732b_cck_swing_table_ch14[][8] = {
+	{0x09, 0x08, 0x07, 0x04, 0x00, 0x00, 0x00, 0x00},	/* 0, -16.0dB */
+	{0x09, 0x09, 0x08, 0x05, 0x00, 0x00, 0x00, 0x00},	/* 1, -15.5dB */
+	{0x0a, 0x09, 0x08, 0x05, 0x00, 0x00, 0x00, 0x00},	/* 2, -15.0dB */
+	{0x0a, 0x0a, 0x09, 0x05, 0x00, 0x00, 0x00, 0x00},	/* 3, -14.5dB */
+	{0x0b, 0x0a, 0x09, 0x05, 0x00, 0x00, 0x00, 0x00},	/* 4, -14.0dB */
+	{0x0b, 0x0b, 0x0a, 0x06, 0x00, 0x00, 0x00, 0x00},	/* 5, -13.5dB */
+	{0x0c, 0x0c, 0x0a, 0x06, 0x00, 0x00, 0x00, 0x00},	/* 6, -13.0dB */
+	{0x0d, 0x0c, 0x0b, 0x06, 0x00, 0x00, 0x00, 0x00},	/* 7, -12.5dB */
+	{0x0d, 0x0d, 0x0c, 0x07, 0x00, 0x00, 0x00, 0x00},	/* 8, -12.0dB */
+	{0x0e, 0x0e, 0x0c, 0x07, 0x00, 0x00, 0x00, 0x00},	/* 9, -11.5dB */
+	{0x0f, 0x0f, 0x0d, 0x08, 0x00, 0x00, 0x00, 0x00},	/* 10, -11.0dB */
+	{0x10, 0x10, 0x0e, 0x08, 0x00, 0x00, 0x00, 0x00},	/* 11, -10.5dB */
+	{0x11, 0x11, 0x0f, 0x09, 0x00, 0x00, 0x00, 0x00},	/* 12, -10.0dB */
+	{0x12, 0x12, 0x0f, 0x09, 0x00, 0x00, 0x00, 0x00},	/* 13, -9.5dB */
+	{0x13, 0x13, 0x10, 0x0a, 0x00, 0x00, 0x00, 0x00},	/* 14, -9.0dB */
+	{0x14, 0x14, 0x11, 0x0a, 0x00, 0x00, 0x00, 0x00},	/* 15, -8.5dB */
+	{0x16, 0x15, 0x12, 0x0b, 0x00, 0x00, 0x00, 0x00},	/* 16, -8.0dB */
+	{0x17, 0x16, 0x13, 0x0b, 0x00, 0x00, 0x00, 0x00},	/* 17, -7.5dB */
+	{0x18, 0x17, 0x15, 0x0c, 0x00, 0x00, 0x00, 0x00},	/* 18, -7.0dB */
+	{0x1a, 0x19, 0x16, 0x0d, 0x00, 0x00, 0x00, 0x00},	/* 19, -6.5dB */
+	{0x1b, 0x1a, 0x17, 0x0e, 0x00, 0x00, 0x00, 0x00},	/* 20, -6.0dB */
+	{0x1d, 0x1c, 0x18, 0x0e, 0x00, 0x00, 0x00, 0x00},	/* 21, -5.5dB */
+	{0x1f, 0x1e, 0x1a, 0x0f, 0x00, 0x00, 0x00, 0x00},	/* 22, -5.0dB */
+	{0x20, 0x20, 0x1b, 0x10, 0x00, 0x00, 0x00, 0x00},	/* 23, -4.5dB */
+	{0x22, 0x21, 0x1d, 0x11, 0x00, 0x00, 0x00, 0x00},	/* 24, -4.0dB */
+	{0x24, 0x23, 0x1f, 0x12, 0x00, 0x00, 0x00, 0x00},	/* 25, -3.5dB */
+	{0x26, 0x25, 0x21, 0x13, 0x00, 0x00, 0x00, 0x00},	/* 26, -3.0dB */
+	{0x28, 0x28, 0x24, 0x14, 0x00, 0x00, 0x00, 0x00},	/* 27, -2.5dB */
+	{0x2b, 0x2a, 0x25, 0x15, 0x00, 0x00, 0x00, 0x00},	/* 28, -2.0dB */
+	{0x2d, 0x2d, 0x17, 0x17, 0x00, 0x00, 0x00, 0x00},	/* 29, -1.5dB */
+	{0x30, 0x2f, 0x29, 0x18, 0x00, 0x00, 0x00, 0x00},	/* 30, -1.0dB */
+	{0x33, 0x32, 0x2b, 0x19, 0x00, 0x00, 0x00, 0x00},	/* 31, -0.5dB */
+	{0x36, 0x35, 0x2e, 0x1b, 0x00, 0x00, 0x00, 0x00},	/* 32, +0dB */
+};
+
+static_assert(ARRAY_SIZE(rtw8732b_cck_swing_table_ch1_ch13) ==
+	      ARRAY_SIZE(rtw8732b_cck_swing_table_ch14));
+
+#define RTW_OFDM_SWING_TABLE_SIZE	ARRAY_SIZE(rtw8723b_ofdm_swing_table)
+#define RTW_CCK_SWING_TABLE_SIZE	ARRAY_SIZE(rtw8732b_cck_swing_table_ch14)
+
+static const struct rtw_pwr_seq_cmd trans_pre_enable_8723b[] = {
+	/* unlock ISO/CLK/power control register */
+	{REG_RSV_CTRL,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_ALL_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, 0xff, 0},
+
+	{TRANS_SEQ_END},
+};
+
+static const struct rtw_pwr_seq_cmd trans_carddis_to_cardemu_8723b[] = {
+	{0x0005,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_ALL_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, BIT(3) | BIT(7), 0},
+
+	{0x0086,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_SDIO_MSK,
+	 RTW_PWR_ADDR_SDIO,
+	 RTW_PWR_CMD_WRITE, BIT(0), 0},
+
+	{0x0086,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_SDIO_MSK,
+	 RTW_PWR_ADDR_SDIO,
+	 RTW_PWR_CMD_POLLING, BIT(1), BIT(1)},
+
+	{0x004A,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_USB_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, BIT(0), 0},
+
+	{0x0005,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_ALL_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, BIT(3) | BIT(4), 0},
+
+	{0x0023,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_SDIO_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, BIT(4), 0},
+
+	{0x0301,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_PCI_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, 0xFF, 0},
+
+	{TRANS_SEQ_END},
+};
+
+static const struct rtw_pwr_seq_cmd trans_cardemu_to_act_8723b[] = {
+	{0x0020,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_USB_MSK | RTW_PWR_INTF_SDIO_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, BIT(0), BIT(0)},
+
+	{0x0067,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_USB_MSK | RTW_PWR_INTF_SDIO_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, BIT(4), 0},
+
+	{0x0001,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_USB_MSK | RTW_PWR_INTF_SDIO_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_DELAY, 1, RTW_PWR_DELAY_MS},
+
+	{0x0000,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_USB_MSK | RTW_PWR_INTF_SDIO_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, BIT(5), 0},
+
+	{0x0005,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_ALL_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, (BIT(4) | BIT(3) | BIT(2)), 0},
+
+	{0x0075,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_PCI_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, BIT(0), BIT(0)},
+
+	{0x0006,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_ALL_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_POLLING, BIT(1), BIT(1)},
+
+	{0x0075,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_PCI_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, BIT(0), 0},
+
+	{0x0006,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_ALL_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, BIT(0), BIT(0)},
+
+	{0x0005,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_ALL_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, BIT(7), 0},
+
+	{0x0005,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_ALL_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, BIT(4) | BIT(3), 0},
+
+	{0x0005,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_ALL_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, BIT(0), BIT(0)},
+
+	{0x0005,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_ALL_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_POLLING, BIT(0), 0},
+
+	{0x0010,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_ALL_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, BIT(6), BIT(6)},
+
+	{0x0049,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_ALL_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, BIT(1), BIT(1)},
+
+	{0x0063,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_ALL_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, BIT(1), BIT(1)},
+
+	{0x0062,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_ALL_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, BIT(1), 0},
+
+	{0x0058,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_ALL_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, BIT(0), BIT(0)},
+
+	{0x005A,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_ALL_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, BIT(1), BIT(1)},
+
+	{0x0068,
+	 RTW_PWR_CUT_TEST_MSK,
+	 RTW_PWR_INTF_ALL_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, BIT(3), BIT(3)},
+
+	{0x0069,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_ALL_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, BIT(6), BIT(6)},
+
+	 {TRANS_SEQ_END},
+};
+
+static const struct rtw_pwr_seq_cmd trans_act_to_lps_8723b[] = {
+	{0x0301,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_PCI_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, 0xFF, 0xFF},
+
+	{0x0522,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_ALL_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, 0xFF, 0xFF},
+
+	{0x05F8,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_ALL_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_POLLING, 0xFF, 0},
+
+	{0x05F9,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_ALL_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_POLLING, 0xFF, 0},
+
+	{0x05FA,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_ALL_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_POLLING, 0xFF, 0},
+
+	{0x05FB,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_ALL_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_POLLING, 0xFF, 0},
+
+	{0x0002,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_ALL_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, BIT(0), 0},
+
+	{0x0002,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_ALL_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_DELAY, 0, RTW_PWR_DELAY_US},
+
+	{0x0002,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_ALL_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, BIT(1), 0},
+
+	{0x0100,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_ALL_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, 0xFF, 0x03},
+
+	{0x0101,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_ALL_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, BIT(1), 0},
+
+	{0x0093,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_SDIO_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, 0xFF, 0x00},
+
+	{0x0553,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_ALL_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, BIT(5), BIT(5)},
+
+	{TRANS_SEQ_END},
+};
+
+static const struct rtw_pwr_seq_cmd trans_act_to_reset_mcu_8723b[] = {
+	{REG_SYS_FUNC_EN + 1,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_SDIO_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, BIT_FEN_CPUEN, 0},
+	/* reset MCU ready */
+	{REG_MCUFW_CTRL,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_SDIO_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, 0xff, 0},
+	/* reset MCU IO wrapper */
+	{REG_RSV_CTRL + 1,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_SDIO_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, BIT(0), 0},
+	{REG_RSV_CTRL + 1,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_SDIO_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, BIT(0), 1},
+	{TRANS_SEQ_END},
+};
+
+static const struct rtw_pwr_seq_cmd trans_act_to_cardemu_8723b[] = {
+	{0x001F,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_ALL_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, 0xFF, 0},
+
+	{0x0049,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_ALL_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, BIT(1), 0},
+
+	{0x0006,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_ALL_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, BIT(0), BIT(0)},
+
+	{0x0005,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_ALL_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, BIT(1), BIT(1)},
+
+	{0x0005,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_ALL_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_POLLING, BIT(1), 0},
+
+	{0x0010,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_ALL_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, BIT(6), 0},
+
+	{0x0000,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_USB_MSK | RTW_PWR_INTF_SDIO_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, BIT(5), BIT(5)},
+
+	{0x0020,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_USB_MSK | RTW_PWR_INTF_SDIO_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, BIT(0), 0},
+
+	{TRANS_SEQ_END},
+};
+
+static const struct rtw_pwr_seq_cmd trans_cardemu_to_carddis_8723b[] = {
+	{0x0007,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_SDIO_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, 0xFF, 0x20},
+
+	{0x0005,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_USB_MSK | RTW_PWR_INTF_SDIO_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, BIT(3) | BIT(4), BIT(3)},
+
+	{0x0005,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_PCI_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, BIT(2), BIT(2)},
+
+	{0x004A,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_USB_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, BIT(0), 1},
+
+	{0x0023,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_SDIO_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, BIT(4), BIT(4)},
+
+	{0x0086,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_SDIO_MSK,
+	 RTW_PWR_ADDR_SDIO,
+	 RTW_PWR_CMD_WRITE, BIT(0), BIT(0)},
+
+	{0x0086,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_SDIO_MSK,
+	 RTW_PWR_ADDR_SDIO,
+	 RTW_PWR_CMD_POLLING, BIT(1), 0},
+
+	{TRANS_SEQ_END},
+};
+
+static const struct rtw_pwr_seq_cmd * const card_enable_flow_8723b[] = {
+	trans_pre_enable_8723b,
+	trans_carddis_to_cardemu_8723b,
+	trans_cardemu_to_act_8723b,
+	NULL
+};
+
+static const struct rtw_pwr_seq_cmd * const card_disable_flow_8723b[] = {
+	trans_act_to_lps_8723b,
+	trans_act_to_reset_mcu_8723b,
+	trans_act_to_cardemu_8723b,
+	trans_cardemu_to_carddis_8723b,
+	NULL
+};
+
+static const struct rtw_page_table page_table_8723b[] = {
+	{12, 2, 2, 0, 1}, /* SDIO */
+	{12, 2, 2, 0, 1},
+	{12, 2, 2, 0, 1},
+	{12, 2, 2, 0, 1},
+	{12, 2, 2, 0, 1},
+};
+
+static const struct rtw_rqpn rqpn_table_8723b[] = {
+	/* SDIO maps VO, MGMT and HI to the high queue. */
+	{RTW_DMA_MAPPING_HIGH, RTW_DMA_MAPPING_NORMAL,
+	 RTW_DMA_MAPPING_LOW, RTW_DMA_MAPPING_LOW,
+	 RTW_DMA_MAPPING_HIGH, RTW_DMA_MAPPING_HIGH},
+	/* PCIE */
+	{RTW_DMA_MAPPING_NORMAL, RTW_DMA_MAPPING_NORMAL,
+	 RTW_DMA_MAPPING_LOW, RTW_DMA_MAPPING_LOW,
+	 RTW_DMA_MAPPING_HIGH, RTW_DMA_MAPPING_HIGH},
+	/* USB bulkout 2 */
+	{RTW_DMA_MAPPING_NORMAL, RTW_DMA_MAPPING_NORMAL,
+	 RTW_DMA_MAPPING_NORMAL, RTW_DMA_MAPPING_HIGH,
+	 RTW_DMA_MAPPING_HIGH, RTW_DMA_MAPPING_HIGH},
+	/* USB bulkout 3 */
+	{RTW_DMA_MAPPING_NORMAL, RTW_DMA_MAPPING_NORMAL,
+	 RTW_DMA_MAPPING_LOW, RTW_DMA_MAPPING_LOW,
+	 RTW_DMA_MAPPING_HIGH, RTW_DMA_MAPPING_HIGH},
+	/* USB bulkout 4 */
+	{RTW_DMA_MAPPING_NORMAL, RTW_DMA_MAPPING_NORMAL,
+	 RTW_DMA_MAPPING_LOW, RTW_DMA_MAPPING_LOW,
+	 RTW_DMA_MAPPING_HIGH, RTW_DMA_MAPPING_HIGH},
+};
+
+static const u8 rtw8723b_pwrtrk_2gb_n[] = {
+	0, 0, 1, 2, 2, 2, 3, 3, 3, 4, 5, 5, 6, 6, 6, 6,
+	7, 7, 7, 8, 8, 9, 9, 10, 10, 11, 12, 13, 14, 15
+};
+
+static const u8 rtw8723b_pwrtrk_2gb_p[] = {
+	0, 0, 1, 2, 2, 3, 3, 4, 5, 5, 6, 6, 7, 7, 8, 8,
+	9, 9, 10, 10, 10, 11, 11, 12, 12, 13, 13, 14, 15, 15
+};
+
+static const u8 rtw8723b_pwrtrk_2ga_n[] = {
+	0, 0, 1, 2, 2, 2, 3, 3, 3, 4, 5, 5, 6, 6, 6, 6,
+	7, 7, 7, 8, 8, 9, 9, 10, 10, 11, 12, 13, 14, 15
+};
+
+static const u8 rtw8723b_pwrtrk_2ga_p[] = {
+	0, 0, 1, 2, 2, 3, 3, 4, 5, 5, 6, 6, 7, 7, 8, 8,
+	9, 9, 10, 10, 10, 11, 11, 12, 12, 13, 13, 14, 15, 15
+};
+
+static const u8 rtw8723b_pwrtrk_2g_cck_b_n[] = {
+	0, 0, 1, 2, 2, 3, 3, 4, 4, 5, 6, 6, 7, 7, 7, 8,
+	8, 8, 9, 9, 9, 10, 10, 11, 11, 12, 12, 13, 14, 15
+};
+
+static const u8 rtw8723b_pwrtrk_2g_cck_b_p[] = {
+	0, 0, 1, 2, 2, 2, 3, 3, 3, 4, 5, 5, 6, 6, 7, 7,
+	8, 8, 9, 9, 9, 10, 10, 11, 11, 12, 12, 13, 14, 15
+};
+
+static const u8 rtw8723b_pwrtrk_2g_cck_a_n[] = {
+	0, 0, 1, 2, 2, 3, 3, 4, 4, 5, 6, 6, 7, 7, 7, 8,
+	8, 8, 9, 9, 9, 10, 10, 11, 11, 12, 12, 13, 14, 15
+};
+
+static const u8 rtw8723b_pwrtrk_2g_cck_a_p[] = {
+	0, 0, 1, 2, 2, 2, 3, 3, 3, 4, 5, 5, 6, 6, 7, 7,
+	8, 8, 9, 9, 9, 10, 10, 11, 11, 12, 12, 13, 14, 15
+};
+
+static const struct rtw_pwr_track_tbl rtw8723b_rtw_pwr_track_tbl = {
+	.pwrtrk_2gb_n = rtw8723b_pwrtrk_2gb_n,
+	.pwrtrk_2gb_p = rtw8723b_pwrtrk_2gb_p,
+	.pwrtrk_2ga_n = rtw8723b_pwrtrk_2ga_n,
+	.pwrtrk_2ga_p = rtw8723b_pwrtrk_2ga_p,
+	.pwrtrk_2g_cckb_n = rtw8723b_pwrtrk_2g_cck_b_n,
+	.pwrtrk_2g_cckb_p = rtw8723b_pwrtrk_2g_cck_b_p,
+	.pwrtrk_2g_ccka_n = rtw8723b_pwrtrk_2g_cck_a_n,
+	.pwrtrk_2g_ccka_p = rtw8723b_pwrtrk_2g_cck_a_p,
+	/* rtw8723x_pwrtrack_set_xtal() is not used on this chip. */
+	.pwrtrk_xtal_n = NULL,
+	.pwrtrk_xtal_p = NULL,
+};
+
+static const struct rtw_rfe_def rtw8723b_rfe_defs[] = {
+	[0] = { .phy_pg_tbl	= &rtw8723b_bb_pg_tbl,
+		.txpwr_lmt_tbl	= &rtw8723b_txpwr_lmt_tbl,
+		.pwr_track_tbl	= &rtw8723b_rtw_pwr_track_tbl, },
+};
+
+/* Shared-Antenna Coex Table */
+static const struct coex_table_para table_sant_8723b[] = {
+	{0xffffffff, 0xffffffff}, /* case-0 */
+	{0x55555555, 0x55555555},
+	{0x66555555, 0x66555555},
+	{0xaaaaaaaa, 0xaaaaaaaa},
+	{0x5a5a5a5a, 0x5a5a5a5a},
+	{0xfafafafa, 0xfafafafa}, /* case-5 */
+	{0x6a5a5555, 0xaaaaaaaa},
+	{0x6a5a56aa, 0x6a5a56aa},
+	{0x6a5a5a5a, 0x6a5a5a5a},
+	{0x66555555, 0x5a5a5a5a},
+	{0x66555555, 0x6a5a5a5a}, /* case-10 */
+	{0x66555555, 0x6a5a5aaa},
+	{0x66555555, 0x5a5a5aaa},
+	{0x66555555, 0x6aaa5aaa},
+	{0x66555555, 0xaaaa5aaa},
+	{0x66555555, 0xaaaaaaaa}, /* case-15 */
+	{0xffff55ff, 0xfafafafa},
+	{0xffff55ff, 0x6afa5afa},
+	{0xaaffffaa, 0xfafafafa},
+	{0xaa5555aa, 0x5a5a5a5a},
+	{0xaa5555aa, 0x6a5a5a5a}, /* case-20 */
+	{0xaa5555aa, 0xaaaaaaaa},
+	{0xffffffff, 0x5a5a5a5a},
+	{0xffffffff, 0x5a5a5a5a},
+	{0xffffffff, 0x55555555},
+	{0xffffffff, 0x5a5a5aaa}, /* case-25 */
+	{0x55555555, 0x5a5a5a5a},
+	{0x55555555, 0xaaaaaaaa},
+	{0x55555555, 0x6a5a6a5a},
+	{0x66556655, 0x66556655},
+	{0x66556aaa, 0x6a5a6aaa}, /* case-30 */
+	{0xffffffff, 0x5aaa5aaa},
+	{0x56555555, 0x5a5a5aaa},
+};
+
+/* Non-Shared-Antenna Coex Table */
+static const struct coex_table_para table_nsant_8723b[] = {
+	{0xffffffff, 0xffffffff}, /* case-100 */
+	{0x55555555, 0x55555555},
+	{0x66555555, 0x66555555},
+	{0xaaaaaaaa, 0xaaaaaaaa},
+	{0x5a5a5a5a, 0x5a5a5a5a},
+	{0xfafafafa, 0xfafafafa}, /* case-105 */
+	{0x5afa5afa, 0x5afa5afa},
+	{0x55555555, 0xfafafafa},
+	{0x66555555, 0xfafafafa},
+	{0x66555555, 0x5a5a5a5a},
+	{0x66555555, 0x6a5a5a5a}, /* case-110 */
+	{0x66555555, 0xaaaaaaaa},
+	{0xffff55ff, 0xfafafafa},
+	{0xffff55ff, 0x5afa5afa},
+	{0xffff55ff, 0xaaaaaaaa},
+	{0xffff55ff, 0xffff55ff}, /* case-115 */
+	{0xaaffffaa, 0x5afa5afa},
+	{0xaaffffaa, 0xaaaaaaaa},
+	{0xffffffff, 0xfafafafa},
+	{0xffffffff, 0x5afa5afa},
+	{0xffffffff, 0xaaaaaaaa}, /* case-120 */
+	{0x55ff55ff, 0x5afa5afa},
+	{0x55ff55ff, 0xaaaaaaaa},
+	{0x55ff55ff, 0x55ff55ff}
+};
+
+/* Shared-Antenna TDMA */
+static const struct coex_tdma_para tdma_sant_8723b[] = {
+	{ {0x00, 0x00, 0x00, 0x00, 0x00} }, /* case-0 */
+	{ {0x61, 0x45, 0x03, 0x11, 0x11} }, /* case-1 */
+	{ {0x61, 0x3a, 0x03, 0x11, 0x11} },
+	{ {0x61, 0x30, 0x03, 0x11, 0x11} },
+	{ {0x61, 0x20, 0x03, 0x11, 0x11} },
+	{ {0x61, 0x10, 0x03, 0x11, 0x11} }, /* case-5 */
+	{ {0x61, 0x45, 0x03, 0x11, 0x10} },
+	{ {0x61, 0x3a, 0x03, 0x11, 0x10} },
+	{ {0x61, 0x30, 0x03, 0x11, 0x10} },
+	{ {0x61, 0x20, 0x03, 0x11, 0x10} },
+	{ {0x61, 0x10, 0x03, 0x11, 0x10} }, /* case-10 */
+	{ {0x61, 0x08, 0x03, 0x11, 0x14} },
+	{ {0x61, 0x08, 0x03, 0x10, 0x14} },
+	{ {0x51, 0x08, 0x03, 0x10, 0x54} },
+	{ {0x51, 0x08, 0x03, 0x10, 0x55} },
+	{ {0x51, 0x08, 0x07, 0x10, 0x54} }, /* case-15 */
+	{ {0x51, 0x45, 0x03, 0x10, 0x50} },
+	{ {0x51, 0x3a, 0x03, 0x10, 0x50} },
+	{ {0x51, 0x30, 0x03, 0x10, 0x50} },
+	{ {0x51, 0x20, 0x03, 0x10, 0x50} },
+	{ {0x51, 0x10, 0x03, 0x10, 0x50} }, /* case-20 */
+	{ {0x51, 0x4a, 0x03, 0x10, 0x50} },
+	{ {0x51, 0x0c, 0x03, 0x10, 0x54} },
+	{ {0x55, 0x08, 0x03, 0x10, 0x54} },
+	{ {0x65, 0x10, 0x03, 0x11, 0x10} },
+	{ {0x51, 0x10, 0x03, 0x10, 0x51} }, /* case-25 */
+	{ {0x51, 0x08, 0x03, 0x10, 0x50} },
+	{ {0x61, 0x08, 0x03, 0x11, 0x11} }
+};
+
+/* Non-Shared-Antenna TDMA */
+static const struct coex_tdma_para tdma_nsant_8723b[] = {
+	{ {0x00, 0x00, 0x00, 0x00, 0x01} }, /* case-100 */
+	{ {0x61, 0x45, 0x03, 0x11, 0x11} }, /* case-101 */
+	{ {0x61, 0x3a, 0x03, 0x11, 0x11} },
+	{ {0x61, 0x30, 0x03, 0x11, 0x11} },
+	{ {0x61, 0x20, 0x03, 0x11, 0x11} },
+	{ {0x61, 0x10, 0x03, 0x11, 0x11} }, /* case-105 */
+	{ {0x61, 0x45, 0x03, 0x11, 0x10} },
+	{ {0x61, 0x3a, 0x03, 0x11, 0x10} },
+	{ {0x61, 0x30, 0x03, 0x11, 0x10} },
+	{ {0x61, 0x20, 0x03, 0x11, 0x10} },
+	{ {0x61, 0x10, 0x03, 0x11, 0x10} }, /* case-110 */
+	{ {0x61, 0x08, 0x03, 0x11, 0x14} },
+	{ {0x61, 0x08, 0x03, 0x10, 0x14} },
+	{ {0x51, 0x08, 0x03, 0x10, 0x54} },
+	{ {0x51, 0x08, 0x03, 0x10, 0x55} },
+	{ {0x51, 0x08, 0x07, 0x10, 0x54} }, /* case-115 */
+	{ {0x51, 0x45, 0x03, 0x10, 0x50} },
+	{ {0x51, 0x3a, 0x03, 0x10, 0x50} },
+	{ {0x51, 0x30, 0x03, 0x10, 0x50} },
+	{ {0x51, 0x20, 0x03, 0x10, 0x50} },
+	{ {0x51, 0x10, 0x03, 0x10, 0x50} }, /* case-120 */
+	{ {0x51, 0x08, 0x03, 0x10, 0x50} }
+};
+
+static void rtw8723b_efuse_grant(struct rtw_dev *rtwdev, bool on)
+{
+	/*
+	 * The BT power-cut and output-isolation writes are part of the WiFi
+	 * efuse power switch on this chip, so the common
+	 * __rtw8723x_efuse_grant() cannot be used here.
+	 */
+	if (on) {
+		/* enable BT power cut 0x6A[14] = 1 */
+		rtw_write8_set(rtwdev, 0x6b, BIT(6));
+
+		rtw_write8(rtwdev, REG_EFUSE_ACCESS, EFUSE_ACCESS_ON);
+
+		rtw_write16_set(rtwdev, REG_SYS_FUNC_EN, BIT_FEN_ELDR);
+		rtw_write16_set(rtwdev, REG_SYS_CLKR, BIT_LOADER_CLK_EN | BIT_ANA8M);
+	} else {
+		/* enable BT output isolation 0x6A[15] = 1 */
+		rtw_write8_set(rtwdev, 0x6b, BIT(7));
+
+		rtw_write8(rtwdev, REG_EFUSE_ACCESS, EFUSE_ACCESS_OFF);
+	}
+}
+
+static u8 rtw8723b_default_ofdm_index(struct rtw_dev *rtwdev)
+{
+	u8 i;
+	u32 val32;
+	u32 swing;
+
+	swing = rtw_read32_mask(rtwdev, REG_OFDM_0_XA_TX_IQ_IMBALANCE, 0xffc00000);
+
+	for (i = 0; i < RTW_OFDM_SWING_TABLE_SIZE; i++) {
+		val32 = rtw8723b_ofdm_swing_table[i];
+
+		if (val32 >= 0x100000)
+			val32 >>= 22;
+
+		if (val32 == swing)
+			break;
+	}
+
+	if (i >= RTW_OFDM_SWING_TABLE_SIZE)
+		i = 30;
+
+	return i;
+}
+
+static u8 rtw8723b_default_cck_index(struct rtw_dev *rtwdev)
+{
+	u8 i;
+	u8 swing;
+
+	swing = rtw_read8(rtwdev, rtw8723b_cck_pwr_regs[0]);
+
+	for (i = 0; i < RTW_CCK_SWING_TABLE_SIZE; i++) {
+		if (rtw8732b_cck_swing_table_ch1_ch13[i][0] == swing)
+			break;
+	}
+
+	if (i >= RTW_CCK_SWING_TABLE_SIZE)
+		i = 20;
+
+	return i;
+}
+
+static void rtw8723b_pwrtrack_init(struct rtw_dev *rtwdev)
+{
+	struct rtw_dm_info *dm_info = &rtwdev->dm_info;
+	u8 path;
+
+	dm_info->default_ofdm_index = rtw8723b_default_ofdm_index(rtwdev);
+	dm_info->default_cck_index = rtw8723b_default_cck_index(rtwdev);
+
+	/* thermal/power-track init is identical to rtw8723d dm_init */
+	for (path = RF_PATH_A; path < rtwdev->hal.rf_path_num; path++) {
+		ewma_thermal_init(&dm_info->avg_thermal[path]);
+		dm_info->delta_power_index[path] = 0;
+	}
+	dm_info->pwr_trk_triggered = false;
+	dm_info->pwr_trk_init_trigger = true;
+	dm_info->thermal_meter_k = rtwdev->efuse.thermal_meter_k;
+	dm_info->txagc_remnant_cck = 0;
+	dm_info->txagc_remnant_ofdm[RF_PATH_A] = 0;
+}
+
+static bool rtw8723b_sdio_needs_rx_path_fix(struct rtw_dev *rtwdev)
+{
+	return rtw_hci_type(rtwdev) == RTW_HCI_TYPE_SDIO;
+}
+
+static void rtw8723b_sdio_restore_pad_ctrl(struct rtw_dev *rtwdev,
+					   bool keep_pta_owner)
+{
+	u32 before;
+	u32 after;
+
+	if (!rtw8723b_sdio_needs_rx_path_fix(rtwdev))
+		return;
+
+	before = rtw_read32(rtwdev, REG_PAD_CTRL1);
+	after = before & ~(BIT_LNAON_WLBT_SEL | BIT_SW_DPDT_SEL_DATA);
+	if (keep_pta_owner)
+		after |= BIT_PAPE_WLBT_SEL;
+	else
+		after &= ~BIT_PAPE_WLBT_SEL;
+	if (after == before)
+		return;
+
+	rtw_write32(rtwdev, REG_PAD_CTRL1, after);
+}
+
+static void rtw8723b_post_enable_flow(struct rtw_dev *rtwdev)
+{
+	u32 value32;
+
+	/* These two are also done in card_enable_flow. */
+	rtw_write8_set(rtwdev, 0x0049, BIT(1));
+	rtw_write8_set(rtwdev, 0x0063, BIT(1));
+
+	rtw_write16_set(rtwdev, REG_APS_FSMCO, BIT_EN_PDN);
+
+	/*
+	 * The RQPN page split is already latched at this point. Writing CR to
+	 * zero would reset the hardware free-page counters and leave the TX
+	 * DMA with no allocatable pages, so only OR in the missing enables.
+	 */
+	rtw_write16_set(rtwdev, REG_CR, MAC_TRX_ENABLE | BIT_MAC_SEC_EN |
+				       BIT_32K_CAL_TMR_EN);
+
+	if (rtw_hci_type(rtwdev) == RTW_HCI_TYPE_SDIO) {
+		rtw_write16_set(rtwdev, REG_PWR_DATA, BIT(11));
+
+		/*
+		 * rtw_mac_power_on() sets generic PAD mux bits that this chip
+		 * needs cleared, so restore the SDIO PAD mux before RF and
+		 * coex setup.
+		 */
+		rtw8723b_sdio_restore_pad_ctrl(rtwdev, false);
+
+		/*
+		 * The firmware needs this bit set to deliver CCX TX reports;
+		 * without it management TX reports are not generated.
+		 */
+		value32 = rtw_read32(rtwdev, REG_FWHW_TXQ_CTRL);
+		value32 |= BIT(12);
+		rtw_write32(rtwdev, REG_FWHW_TXQ_CTRL, value32);
+	}
+
+	rtw_write8(rtwdev, REG_EARLY_MODE_CONTROL, 0);
+
+	/*
+	 * Keep every MACID eligible for firmware-scheduled TX at power-on;
+	 * mac80211 and firmware state handle the real peer lifetime.
+	 */
+	rtw_write32(rtwdev, REG_MACID_PKT_DROP0, 0);
+	rtw_write32(rtwdev, REG_MACID_PKT_SLEEP, 0);
+}
+
+static void rtw8723b_phy_bb_config(struct rtw_dev *rtwdev)
+{
+	u8 xtal_cap;
+
+	/* Enable BB and RF */
+	rtw_write16_set(rtwdev, REG_SYS_FUNC_EN,
+			BIT_FEN_EN_25_1 | BIT_FEN_BB_GLB_RST | BIT_FEN_BB_RSTB);
+
+	if (rtw_hci_type(rtwdev) == RTW_HCI_TYPE_USB)
+		rtw_write32(rtwdev, REG_BB_SEL_BTG, 0x0);
+	else
+		rtw_write32(rtwdev, REG_BB_SEL_BTG, 0x280);
+
+	/*
+	 * Use a full write rather than a read-modify-write: preserving
+	 * spuriously set bits can leave the RF bus in an unexpected state.
+	 */
+	rtw_write8(rtwdev, REG_RF_CTRL,
+		   BIT_RF_EN | BIT_RF_RSTB | BIT_RF_SDM_RSTB);
+	usleep_range(1000, 1100);
+	rtw_write_rf(rtwdev, RF_PATH_A, RF_WLINT, RFREG_MASK, 0x0780);
+	rtw_write8(rtwdev, REG_SYS_FUNC_EN,
+		   BIT_FEN_PPLL | BIT_FEN_PCIEA | BIT_FEN_DIO_PCIE |
+		   BIT_FEN_BB_GLB_RST | BIT_FEN_BB_RSTB); /* 0xe3 */
+	rtw_write8(rtwdev, REG_AFE_CTRL1 + 1, 0x80);
+
+	xtal_cap = rtwdev->efuse.crystal_cap & 0x3f;
+	rtw_write32_mask(rtwdev,  REG_AFE_CTRL3, BIT_MASK_XTAL,
+			 xtal_cap | (xtal_cap << 6));
+}
+
+static void rtw8723b_phy_load_bb_tables(struct rtw_dev *rtwdev)
+{
+	const struct rtw_chip_info *chip = rtwdev->chip;
+	const struct rtw_rfe_def *rfe_def = rtw_get_rfe_def(rtwdev);
+
+	rtw_load_table(rtwdev, chip->bb_tbl);
+	rtw_load_table(rtwdev, chip->agc_tbl);
+	if (rfe_def && rfe_def->agc_btg_tbl)
+		rtw_load_table(rtwdev, rfe_def->agc_btg_tbl);
+}
+
+static void rtw8723b_phy_rf6052_config(struct rtw_dev *rtwdev)
+{
+	struct rtw_hal *hal = &rtwdev->hal;
+	u32 intf_s, intf_oe, hssi_2;
+	u32 val32, mask;
+	u8 path;
+
+	for (path = RF_PATH_A; path < hal->rf_path_num; path++) {
+		switch (path) {
+		case RF_PATH_A:
+			intf_s = REG_FPGA0_XA_RF_SW_CTRL;
+			intf_oe = REG_FPGA0_XA_RF_INT_OE;
+			hssi_2 = REG_FPGA0_XA_HSSI_PARM2;
+			mask = RFSI_RFENV;
+			break;
+		case RF_PATH_B:
+			intf_s = REG_FPGA0_XB_RF_SW_CTRL;
+			intf_oe = REG_FPGA0_XB_RF_INT_OE;
+			hssi_2 = REG_FPGA0_XB_HSSI_PARM2;
+			mask = RFSI_RFENV << 16;
+			break;
+		default:
+			rtw_err(rtwdev, "invalid rf path %c\n", path + 'A');
+			return;
+		}
+
+		val32 = rtw_read32_mask(rtwdev, intf_s, mask);
+
+		rtw_write32_mask(rtwdev, intf_oe, RFSI_RFENV << 16, 0x1);
+		udelay(1);
+
+		rtw_write32_mask(rtwdev, intf_oe, RFSI_RFENV, 0x1);
+		udelay(1);
+
+		rtw_write32_mask(rtwdev, hssi_2, HSSI_3WIRE_ADDR_LEN, 0x0);
+		udelay(1);
+
+		rtw_write32_mask(rtwdev, hssi_2, HSSI_3WIRE_DATA_LEN, 0x0);
+		udelay(1);
+
+		/*
+		 * NOTE: path A only, there is no table for path B
+		 * The radio_a table is used for both paths.
+		 */
+		rtw_load_table(rtwdev, rtwdev->chip->rf_tbl[RF_PATH_A]);
+
+		rtw_write32_mask(rtwdev, intf_s, mask, val32);
+	}
+
+	/* 3 Configuration of Tx Power Tracking */
+}
+
+static void rtw8723b_phy_lck(struct rtw_dev *rtwdev)
+{
+	rtw_write_rf(rtwdev, RF_PATH_A, 0xb0, RFREG_MASK, 0xdfbe0);
+	rtw_write_rf(rtwdev, RF_PATH_A, RF_CFGCH, RFREG_MASK, 0x8c01);
+	fsleep(200 * 1000);
+	rtw_write_rf(rtwdev, RF_PATH_A, 0xb0, RFREG_MASK, 0xdffe0);
+}
+
+static void rtw8723b_phy_rf_config(struct rtw_dev *rtwdev)
+{
+	rtw8723b_phy_rf6052_config(rtwdev);
+
+	/* LCK must run as part of the RF configuration. */
+	rtw8723b_phy_lck(rtwdev);
+}
+
+static void rtw8723b_init_available_page_threshold(struct rtw_dev *rtwdev)
+{
+	const struct rtw_chip_info *chip = rtwdev->chip;
+	struct rtw_fifo_conf *fifo = &rtwdev->fifo;
+	const struct rtw_page_table *pg_tbl = NULL;
+	u16 hq_threshold, nq_threshold, lq_threshold;
+	u16 pubq_num;
+
+	/*
+	 * Only initialize these page thresholds for SDIO devices.
+	 * PCIe and USB handle TX FIFO/thresholds differently (DMA/host
+	 * scheduling) and writing these registers on those buses can be
+	 * unnecessary or counter-productive.
+	 */
+	if (rtw_hci_type(rtwdev) != RTW_HCI_TYPE_SDIO)
+		return;
+
+	pg_tbl = &chip->page_table[0]; /* SDIO */
+
+	/* fifo must be initialized before this is called */
+	if (fifo->acq_pg_num == 0)
+		return;
+
+	/* ensure we don't underflow if tables are misconfigured */
+	if (fifo->acq_pg_num <= (pg_tbl->hq_num + pg_tbl->lq_num +
+				   pg_tbl->nq_num + pg_tbl->exq_num +
+				   pg_tbl->gapq_num))
+		return;
+
+	pubq_num = fifo->acq_pg_num - pg_tbl->hq_num - pg_tbl->lq_num -
+		   pg_tbl->nq_num - pg_tbl->exq_num - pg_tbl->gapq_num;
+
+	hq_threshold = (pubq_num + pg_tbl->hq_num + 1) >> 1;
+	hq_threshold |= hq_threshold << 8;
+
+	nq_threshold = (pubq_num + pg_tbl->nq_num + 1) >> 1;
+	nq_threshold |= nq_threshold << 8;
+
+	lq_threshold = (pubq_num + pg_tbl->lq_num + 1) >> 1;
+	lq_threshold |= lq_threshold << 8;
+
+	rtw_write16(rtwdev, 0x218, hq_threshold);
+	rtw_write16(rtwdev, 0x21a, nq_threshold);
+	rtw_write16(rtwdev, 0x21c, lq_threshold);
+}
+
+static void rtw8723b_init_queue_reserved_page(struct rtw_dev *rtwdev)
+{
+	/*
+	 * The reserved-page and RQPN setup is handled by
+	 * __priority_queue_cfg_legacy(). The available-page thresholds must
+	 * not be programmed on 8723BS SDIO: against the small SDIO page pools
+	 * they end up larger than the pool and the MAC never releases pages.
+	 */
+	if (rtw_hci_type(rtwdev) == RTW_HCI_TYPE_SDIO &&
+	    rtwdev->chip->id == RTW_CHIP_TYPE_8723B)
+		return;
+
+	rtw8723b_init_available_page_threshold(rtwdev);
+}
+
+static void rtw8723b_init_tx_buffer_boundary(struct rtw_dev *rtwdev)
+{
+	u8 val8 = TX_TOTAL_PAGE_NUMBER_8723B + 1; /* 0xf7 */
+
+	rtw_write8(rtwdev, REG_BCNQ_BDNY, val8);
+	rtw_write8(rtwdev, REG_MGQ_BDNY, val8);
+	rtw_write8(rtwdev, REG_WMAC_LBK_BF_HD, val8);
+	rtw_write8(rtwdev, REG_TRXFF_BNDY, val8);
+	rtw_write8(rtwdev, REG_DWBCN0_CTRL + 1, val8);
+}
+
+static void rtw8723b_init_llt_table(struct rtw_dev *rtwdev)
+{
+	/* Handled by __priority_queue_cfg_legacy(). */
+}
+
+static void rtw8723b_init_page_boundary(struct rtw_dev *rtwdev)
+{
+	 /*
+	  * NOTE: this is also done in __priority_queue_cfg_legacy,
+	  * maybe we can remove it
+	  */
+	rtw_write16(rtwdev, REG_TRXFF_BNDY + 2, 0x4000 - REPORT_BUF - 1);
+}
+
+static void rtw8723b_init_transfer_page_size(struct rtw_dev *rtwdev)
+{
+	rtw_write8(rtwdev, REG_PBP, 0x11);
+}
+
+static void rtw8723b_init_driver_info_size(struct rtw_dev *rtwdev)
+{
+	/* NOTE: also is done in rtw_drv_info_cfg */
+	rtw_write8(rtwdev, REG_RX_DRVINFO_SZ, PHY_STATUS_SIZE);
+}
+
+static void rtw8723b_init_network_type(struct rtw_dev *rtwdev)
+{
+	u32 val32;
+
+	val32 = rtw_read32(rtwdev, REG_CR);
+	val32 = (val32 & ~MASK_NETTYPE) | _NETTYPE(NT_LINK_AP);
+	rtw_write32(rtwdev, REG_CR, val32);
+}
+
+static void rtw8723b_init_wmac_setting(struct rtw_dev *rtwdev)
+{
+	/* Override the default rcr filter for 8723B */
+	rtwdev->hal.rcr = WLAN_RCR_CFG;
+	rtw_write32(rtwdev, REG_RCR, rtwdev->hal.rcr);
+
+	rtw_write32(rtwdev, REG_MAR, 0xffffffff);
+	rtw_write32(rtwdev, REG_MAR + 4, 0xffffffff);
+
+	rtw_write16(rtwdev, REG_RXFLTMAP2, WLAN_RX_FILTER2);
+	rtw_write16(rtwdev, REG_RXFLTMAP1, WLAN_RX_FILTER1);
+	rtw_write16(rtwdev, REG_RXFLTMAP0, WLAN_RX_FILTER0);
+}
+
+static void rtw8723b_init_adaptive_ctrl(struct rtw_dev *rtwdev)
+{
+	/*
+	 * REG_RRSR selects the rates used for ACK/CTS and response duration.
+	 * The firmware validates it during init, and narrowing it to the
+	 * mandatory rates here makes the firmware silently discard all
+	 * management TX, so keep the full rate set.
+	 */
+	rtw_write32_mask(rtwdev, REG_RRSR, 0xfffff, 0xffff1);
+	rtwdev->dm_info.rrsr_val_init = 0xffff1;
+	rtw_write16(rtwdev, REG_RETRY_LIMIT, 0x3030);
+}
+
+static void rtw8723b_init_edca(struct rtw_dev *rtwdev)
+{
+	rtw_write16(rtwdev, REG_SPEC_SIFS, 0x100a);
+	rtw_write16(rtwdev, REG_MAC_SPEC_SIFS, 0x100a);
+	rtw_write16(rtwdev, REG_SIFS, 0x100a);
+	rtw_write16(rtwdev, REG_SIFS + 2, 0x100a);
+
+	/*
+	 * RESP_SIFS controls how soon an ACK follows a received unicast
+	 * frame. The chip default leaves too little slack inside the SIFS
+	 * window, so the AP can time out before the ACK reaches the air.
+	 * Shorten it so the unicast handshake completes reliably.
+	 */
+	rtw_write16(rtwdev, REG_RESP_SIFS_CCK, 0x0808);
+	rtw_write16(rtwdev, REG_RESP_SIFS_OFDM, 0x0a0a);
+
+	/* TXOP */
+	rtw_write32(rtwdev, REG_EDCA_BE_PARAM, 0x005EA42B);
+	rtw_write32(rtwdev, REG_EDCA_BK_PARAM, 0x0000A44F);
+	rtw_write32(rtwdev, REG_EDCA_VI_PARAM, 0x005EA324);
+	rtw_write32(rtwdev, REG_EDCA_VO_PARAM, 0x002FA226);
+}
+
+static void rtw8723b_init_retry_function(struct rtw_dev *rtwdev)
+{
+	rtw_write8_set(rtwdev, REG_FWHW_TXQ_CTRL, BIT(7));
+	rtw_write8(rtwdev, REG_ACKTO, 0x40);
+}
+
+static void rtw8723b_init_operation_mode(struct rtw_dev *rtwdev)
+{
+	rtw_write8(rtwdev, REG_BWOPMODE, BIT_BWOPMODE_20MHZ);
+}
+
+static void rtw8723b_init_beacon_parameters(struct rtw_dev *rtwdev)
+{
+	/*
+	 * Program port-0 and port-1 BCN_CTRL with DIS_TSF_UDT and
+	 * EN_BCN_FUNCTION only. DIS_BCNQ_SUB belongs to the AP and IBSS
+	 * paths and must stay clear for station mode.
+	 */
+	rtw_write16(rtwdev, REG_BCN_CTRL,
+		    (BIT_DIS_TSF_UDT | BIT_EN_BCN_FUNCTION) |
+		    ((BIT_DIS_TSF_UDT | BIT_EN_BCN_FUNCTION) << 8));
+	rtw_write8(rtwdev, REG_TBTT_PROHIBIT, TBTT_PROHIBIT_SETUP_TIME);
+	rtw_write8(rtwdev, REG_TBTT_PROHIBIT + 1,
+		   TBTT_PROHIBIT_HOLD_TIME_STOP_BCN & 0xff);
+	rtw_write8(rtwdev, REG_TBTT_PROHIBIT + 2,
+		   (rtw_read8(rtwdev, REG_TBTT_PROHIBIT + 2) & 0xf0) |
+		   (TBTT_PROHIBIT_HOLD_TIME_STOP_BCN >> 8));
+
+	rtw_write8(rtwdev, REG_BCNDMATIM, WLAN_BCN_DMA_TIME);
+	/*
+	 * Use the largest beacon AIFS, since the chip does not contend for
+	 * the medium before sending a beacon.
+	 */
+	rtw_write16(rtwdev, REG_BCNTCFG, 0x660F);
+}
+
+static void rtw8723b_init_burst_pkt_len(struct rtw_dev *rtwdev)
+{
+	rtw_write8_set(rtwdev, REG_SINGLE_AMPDU_CTRL, BIT_EN_SINGLE_APMDU);
+	rtw_write8(rtwdev, REG_RX_PKT_LIMIT, 0x18);
+	rtw_write8(rtwdev, REG_MAX_AGGR_NUM, 0x1F);
+	rtw_write8(rtwdev, REG_PIFS, 0x00);
+	rtw_write8_clr(rtwdev, REG_FWHW_TXQ_CTRL, BIT(7));
+	rtw_write8(rtwdev, REG_AMPDU_MAX_TIME, 0x70);
+}
+
+static void rtw8723b_init_antenna_selection(struct rtw_dev *rtwdev)
+{
+	/* BIT(7) lets the 8051 control antenna selection, BIT(1) is LED2_CM. */
+	rtw_write8(rtwdev, REG_LEDCFG2, BIT(7) | BIT(1));
+}
+
+#define RF_AC	0x00
+
+static void rtw8723b_lck(struct rtw_dev *rtwdev)
+{
+	u32 rf_mode = 0, lc_cal;
+	u8 val_ctx;
+	u8 rf_val;
+	int ret;
+
+	val_ctx = rtw_read8(rtwdev, REG_CTX);
+
+	if ((val_ctx & BIT_MASK_CTX_TYPE) != 0)
+		rtw_write8(rtwdev, REG_CTX, val_ctx & ~BIT_MASK_CTX_TYPE);
+	else
+		rtw_write8(rtwdev, REG_TXPAUSE, 0xff);
+
+	if ((val_ctx & BIT_MASK_CTX_TYPE) != 0) {
+		/* 1. Read original RF mode */
+		rf_mode = rtw_read_rf(rtwdev, RF_PATH_A, RF_AC, MASK12BITS);
+		/* 2. Set RF mode = standby mode */
+		rtw_write_rf(rtwdev, RF_PATH_A, RF_AC, MASK12BITS, (rf_mode & 0x8ffff) | 0x10000);
+	}
+
+	/* 3. Read RF reg18 */
+	lc_cal = rtw_read_rf(rtwdev, RF_PATH_A, RF_CFGCH, MASK12BITS);
+
+	/* 4. Set LC calibration begin	bit15 */
+	rtw_write_rf(rtwdev, RF_PATH_A, 0xb0, RFREG_MASK, 0xdfbe0); /* LDO ON */
+	rtw_write_rf(rtwdev, RF_PATH_A, RF_CFGCH, MASK12BITS, lc_cal | BIT_LCK);
+
+	ret = read_poll_timeout(rtw_read_rf, rf_val, rf_val != 0x1,
+				10000, 1000000, false,
+			 rtwdev, RF_PATH_A, RF_CFGCH, BIT_LCK);
+	if (ret)
+		rtw_warn(rtwdev, "failed to poll LCK status bit\n");
+
+	rtw_write_rf(rtwdev, RF_PATH_A, 0xb0, RFREG_MASK, 0xdffe0); /* LDO OFF */
+
+	/* Restore original situation */
+	if ((val_ctx & BIT_MASK_CTX_TYPE) != 0) {
+		rtw_write8(rtwdev, REG_CTX, val_ctx);
+
+		rtw_write_rf(rtwdev, RF_PATH_A, RF_AC, MASK12BITS, rf_mode);
+	} else {
+		rtw_write8(rtwdev, REG_TXPAUSE, 0x00);
+	}
+}
+
+static void rtw8723b_inform_rfk_status(struct rtw_dev *rtwdev, bool start)
+{
+	u8 val8;
+	int ret;
+
+	rtw_fw_inform_rfk_status(rtwdev, start);
+
+	if (!start)
+		return;
+
+	ret = read_poll_timeout(rtw_read8, val8,
+				val8 & BIT_RFK_FW_ACK_8723B,
+				50000, 400000, false,
+				rtwdev, REG_RFK_FW_ACK_8723B);
+	if (ret)
+		rtw_warn(rtwdev, "failed to poll firmware RFK start ack\n");
+}
+
+static int rtw8723b_mac_init(struct rtw_dev *rtwdev)
+{
+	rtw8723b_init_wmac_setting(rtwdev);
+
+	rtw_write32(rtwdev, REG_INT_MIG, 0);
+	rtw_write32(rtwdev, REG_MCUTST_1, 0x0);
+
+	rtw_write8(rtwdev, REG_MISC_CTRL, 0x3); /* CCA */
+	rtw_write8(rtwdev, REG_2ND_CCA_CTRL, 0x0);
+
+	return 0;
+}
+
+static void rtw8723b_phy_set_param(struct rtw_dev *rtwdev)
+{
+	const struct rtw_chip_info *chip = rtwdev->chip;
+	u32 val32;
+
+	rtw8723b_post_enable_flow(rtwdev);
+
+	rtw_load_table(rtwdev, chip->mac_tbl);
+	rtw8723b_phy_bb_config(rtwdev);
+	rtw8723b_phy_load_bb_tables(rtwdev);
+	rtw8723b_phy_rf_config(rtwdev);
+
+	/* enable CCK and OFDM block */
+	rtw_write32_set(rtwdev, REG_FPGA0_RFMOD, BIT_CCKEN | BIT_OFDMEN);
+
+	rtw8723b_init_queue_reserved_page(rtwdev);
+	rtw8723b_init_tx_buffer_boundary(rtwdev);
+	rtw8723b_init_llt_table(rtwdev);
+
+	rtw8723b_init_page_boundary(rtwdev);
+	rtw8723b_init_transfer_page_size(rtwdev);
+	rtw8723b_init_driver_info_size(rtwdev);
+	rtw8723b_init_network_type(rtwdev);
+
+	rtw8723b_init_wmac_setting(rtwdev);
+
+	rtw8723b_init_adaptive_ctrl(rtwdev);
+	rtw8723b_init_edca(rtwdev);
+	rtw8723b_init_retry_function(rtwdev);
+
+	/*
+	 * Set up RX aggregation. sdio.c also sets DMA mode, but not
+	 * the burst parameters.
+	 */
+	rtw_write8(rtwdev, REG_RXDMA_MODE,
+		   BIT_DMA_MODE |
+		   FIELD_PREP_CONST(BIT_MASK_AGG_BURST_NUM, AGG_BURST_NUM) |
+		   FIELD_PREP_CONST(BIT_MASK_AGG_BURST_SIZE, AGG_BURST_SIZE));
+
+	rtw8723b_init_operation_mode(rtwdev);
+	rtw8723b_init_beacon_parameters(rtwdev);
+	rtw8723b_init_burst_pkt_len(rtwdev);
+
+	/*
+	 * Program the per-AC packet lifetime to 256 ms. The ROM default of
+	 * ~1 s lets the chip retry data frames well past the supplicant
+	 * EAPOL retry window, which reorders TX during the connect exchange.
+	 */
+	rtw_write16(rtwdev, REG_PKT_VO_VI_LIFE_TIME, 0x0400);
+	rtw_write16(rtwdev, REG_PKT_BE_BK_LIFE_TIME, 0x0400);
+
+	rtw_write8(rtwdev, REG_SLOT, WLAN_SLOT_TIME);
+
+	/* disable BAR */
+	rtw_write32(rtwdev, REG_BAR_MODE_CTRL, WLAN_BAR_VAL);
+
+	/* Enable hardware sequence numbering for all queues. */
+	rtw_write8(rtwdev, REG_HWSEQ_CTRL, 0xff);
+
+	/*
+	 * Configure SDIO TxRx Control to enable Rx DMA timer masking. Only
+	 * clear the necessary bits 0x0[2:0] and 0x2[15:0], keeping 0x0[15:3].
+	 */
+	val32 = rtw_read32(rtwdev, REG_SDIO_TX_CTRL);
+	val32 &= 0x0000fff8;
+	rtw_write32(rtwdev, REG_SDIO_TX_CTRL, val32);
+
+	rtw_write16(rtwdev, REG_ATIMWND, 0x2);
+
+	rtw8723b_init_antenna_selection(rtwdev);
+
+	/* NOTE: the following is also done in rtw8723b_post_enable_flow */
+	/* Enable MACTXEN/MACRXEN block */
+	rtw_write8_set(rtwdev, REG_CR, BIT_MACTXEN | BIT_MACRXEN);
+
+	rtw_write8(rtwdev, REG_NAV_UPPER, 0xeb); /* ((30000 + 128 - 1) / 128) */
+
+	/* ack for xmit mgmt frames */
+	rtw_write32_set(rtwdev, REG_FWHW_TXQ_CTRL, BIT(12));
+
+	rtw_phy_init(rtwdev);
+
+	/*
+	 * 8723d does these two alongside its cck_pd_set, but chip_ops.cck_pd_set
+	 * is NULL on 8723b (REG_CSRATIO does not exist on this generation - see
+	 * the chip_ops comment), so they stay disabled.  Kept for reference in
+	 * case cck_pd is ever wired up; the registers/constants would then need
+	 * checking against rtl8723b.
+	 */
+
+	rtw_write32_mask(rtwdev, REG_OFDM0_XAAGC1, MASKBYTE0, 0x50);
+	rtw_write32_mask(rtwdev, REG_OFDM0_XAAGC1, MASKBYTE0, 0x20);
+
+	rtw8723b_pwrtrack_init(rtwdev);
+}
+
+static u32 rtw8723b_iqk_ant_switch_path(struct rtw_dev *rtwdev)
+{
+	if (rtw_hci_type(rtwdev) != RTW_HCI_TYPE_SDIO)
+		return rtw_hci_type(rtwdev) == RTW_HCI_TYPE_USB ? 0x280 : 0x0;
+
+	/*
+	 * Scan and connect run through the PTA mux, so run IQK through the
+	 * same mux and calibrate the path actually used for auth/assoc TX.
+	 */
+	return (rtwdev->efuse.bt_setting & BIT(6)) ? 0x80 : 0x200;
+}
+
+static void rtw8723b_reassert_rx_path(struct rtw_dev *rtwdev)
+{
+	u32 rf_wlint_before;
+	u32 rx_path_before;
+	u32 fpga0_before;
+	u8 sys_func_before;
+	u8 rf_ctrl_before;
+	bool changed = false;
+
+	if (!rtw8723b_sdio_needs_rx_path_fix(rtwdev))
+		return;
+
+	sys_func_before = rtw_read8(rtwdev, REG_SYS_FUNC_EN);
+	rf_ctrl_before = rtw_read8(rtwdev, REG_RF_CTRL);
+	fpga0_before = rtw_read32(rtwdev, REG_FPGA0_RFMOD);
+	rx_path_before = rtw_read32(rtwdev, REG_BB_RX_PATH_11N);
+	rf_wlint_before = rtw_read_rf(rtwdev, RF_PATH_A, RF_WLINT, RFREG_MASK);
+
+	if ((sys_func_before & WLAN_SYS_FUNC_BB_ENABLE) !=
+	    WLAN_SYS_FUNC_BB_ENABLE) {
+		rtw_write8_set(rtwdev, REG_SYS_FUNC_EN,
+			       WLAN_SYS_FUNC_BB_ENABLE);
+		changed = true;
+	}
+
+	if ((rf_ctrl_before & WLAN_RF_CTRL_ENABLE) != WLAN_RF_CTRL_ENABLE) {
+		rtw_write8_set(rtwdev, REG_RF_CTRL, WLAN_RF_CTRL_ENABLE);
+		usleep_range(10, 11);
+		changed = true;
+	}
+
+	if ((fpga0_before & (BIT_CCKEN | BIT_OFDMEN)) !=
+	    (BIT_CCKEN | BIT_OFDMEN)) {
+		rtw_write32_set(rtwdev, REG_FPGA0_RFMOD,
+				BIT_CCKEN | BIT_OFDMEN);
+		changed = true;
+	}
+
+	if (rx_path_before != WLAN_RX_PATH_A_8723B) {
+		rtw_write32(rtwdev, REG_BB_RX_PATH_11N,
+			    WLAN_RX_PATH_A_8723B);
+		changed = true;
+	}
+
+	if (rf_wlint_before != 0x0780) {
+		rtw_write_rf(rtwdev, RF_PATH_A, RF_WLINT, RFREG_MASK,
+			     0x0780);
+		changed = true;
+	}
+
+	if (!changed)
+		return;
+}
+
+static void rtw8723b_set_channel_rf(struct rtw_dev *rtwdev, u8 channel, u8 bw)
+{
+	u32 rf_cfgch_a;
+	u32 rf_cfgch_b = 0;
+
+	rf_cfgch_a = rtw_read_rf(rtwdev, RF_PATH_A, RF_CFGCH, RFREG_MASK);
+	if (rtwdev->hal.rf_path_num > 1)
+		rf_cfgch_b = rtw_read_rf(rtwdev, RF_PATH_B, RF_CFGCH, RFREG_MASK);
+
+	rf_cfgch_a &= ~RFCFGCH_CHANNEL_MASK;
+	if (rtwdev->hal.rf_path_num > 1)
+		rf_cfgch_b &= ~RFCFGCH_CHANNEL_MASK;
+
+	rf_cfgch_a |= (channel & RFCFGCH_CHANNEL_MASK);
+	if (rtwdev->hal.rf_path_num > 1)
+		rf_cfgch_b |= (channel & RFCFGCH_CHANNEL_MASK);
+
+	rf_cfgch_a &= ~RFCFGCH_BW_MASK;
+
+	switch (bw) {
+	case RTW_CHANNEL_WIDTH_20:
+		rf_cfgch_a |= RFCFGCH_BW_20M;
+		break;
+	case RTW_CHANNEL_WIDTH_40:
+		rf_cfgch_a |= RFCFGCH_BW_40M;
+		break;
+	default:
+		break;
+	}
+
+	if (rtwdev->hal.rf_path_num > 1) {
+		/* Path B takes the same value as path A. */
+		rf_cfgch_b = rf_cfgch_a;
+	}
+
+	rtw_write_rf(rtwdev, RF_PATH_A, RF_CFGCH, RFREG_MASK, rf_cfgch_a);
+	if (rtwdev->hal.rf_path_num > 1)
+		rtw_write_rf(rtwdev, RF_PATH_B, RF_CFGCH, RFREG_MASK, rf_cfgch_b);
+
+	rf_cfgch_a = rtw_read_rf(rtwdev, RF_PATH_A, RF_CFGCH, RFREG_MASK);
+	if (rtwdev->hal.rf_path_num > 1)
+		rf_cfgch_b = rtw_read_rf(rtwdev, RF_PATH_B, RF_CFGCH, RFREG_MASK);
+}
+
+static void rtw8723b_set_channel_bb(struct rtw_dev *rtwdev, u8 bw,
+				    u8 primary_ch_idx)
+{
+	switch (bw) {
+	case RTW_CHANNEL_WIDTH_20:
+		rtw_write32_mask(rtwdev, REG_FPGA0_RFMOD, BIT_MASK_RFMOD, 0x0);
+		rtw_write32_mask(rtwdev, REG_FPGA1_RFMOD, BIT_MASK_RFMOD, 0x0);
+		rtw_write32_mask(rtwdev, REG_OFDM0_TX_PSD_NOISE,
+				 GENMASK(31, 30), 0x0);
+		break;
+	case RTW_CHANNEL_WIDTH_40:
+		rtw_write32_mask(rtwdev, REG_FPGA0_RFMOD, BIT_MASK_RFMOD, 0x1);
+		rtw_write32_mask(rtwdev, REG_FPGA1_RFMOD, BIT_MASK_RFMOD, 0x1);
+		rtw_write32_mask(rtwdev, REG_CCK0_SYS, BIT_CCK_SIDE_BAND,
+				 primary_ch_idx == RTW_SC_20_UPPER ? 1 : 0);
+		rtw_write32_mask(rtwdev, REG_OFDM_FA_RSTD_11N, 0xc00,
+				 primary_ch_idx == RTW_SC_20_UPPER ? 2 : 1);
+		rtw_write32_mask(rtwdev, REG_BB_PWR_SAV5_11N, GENMASK(27, 26),
+				 primary_ch_idx == RTW_SC_20_UPPER ? 1 : 2);
+		break;
+	default:
+		break;
+	}
+}
+
+static void rtw8723b_set_channel(struct rtw_dev *rtwdev, u8 channel,
+				 u8 bw, u8 primary_chan_idx)
+{
+	rtw8723b_set_channel_rf(rtwdev, channel, bw);
+	rtw_set_channel_mac(rtwdev, channel, bw, primary_chan_idx);
+	rtw8723b_set_channel_bb(rtwdev, bw, primary_chan_idx);
+	rtw8723b_reassert_rx_path(rtwdev);
+
+	if (rtw8723b_sdio_needs_rx_path_fix(rtwdev)) {
+		bool keep_pta_owner;
+
+		keep_pta_owner = test_bit(RTW_FLAG_SCANNING, rtwdev->flags) ||
+				 (rtw_read32(rtwdev, REG_PAD_CTRL1) &
+				  BIT_PAPE_WLBT_SEL);
+		rtw8723b_sdio_restore_pad_ctrl(rtwdev, keep_pta_owner);
+
+		/*
+		 * RF_WLINT bits 0-1 gate the data path into the BB and a
+		 * prior IQK or coex run can leave them blocking TX, so re-arm
+		 * the RF block and restore the known-good value. REG_RF_CTRL
+		 * is never cleared to zero here: the RF does not recover from
+		 * a cold disable on every channel switch.
+		 */
+		rtw_write8(rtwdev, REG_RF_CTRL,
+			   WLAN_RF_CTRL_ENABLE | BIT_RF_RSTB |
+			   BIT_RF_SDM_RSTB);
+		usleep_range(1000, 1100);
+		rtw_write_rf(rtwdev, RF_PATH_A, RF_WLINT, RFREG_MASK,
+			     0x0780);
+	}
+}
+
+static s8 rtw8723b_cck_rx_power(u8 lna_idx, u8 vga_idx)
+{
+	s8 rx_power = 0;
+
+	switch (lna_idx) {
+	case 6:
+		rx_power = -40 - (2 * vga_idx);
+		break;
+	case 4:
+		rx_power = -20 - (2 * vga_idx);
+		break;
+	case 1:
+		rx_power = 0 - (2 * vga_idx);
+		break;
+	case 0:
+		rx_power = 10 - (2 * vga_idx);
+		break;
+	default:
+		break;
+	}
+
+	return rx_power;
+}
+
+static void rtw8723b_query_phy_status_cck(struct rtw_dev *rtwdev, u8 *phy_raw,
+					  struct rtw_rx_pkt_stat *pkt_stat)
+{
+	struct phy_status_8703b *phy_status = (struct phy_status_8703b *)phy_raw;
+	u8 lna_idx = (phy_status->cck_agc_rpt_ofdm_cfosho_a & 0xE0) >> 5;
+	u8 vga_idx = (phy_status->cck_agc_rpt_ofdm_cfosho_a & 0x1F);
+	s8 rx_power = rtw8723b_cck_rx_power(lna_idx, vga_idx);
+	s8 min_rx_power = -120;
+
+	pkt_stat->bw = RTW_CHANNEL_WIDTH_20;
+
+	pkt_stat->rx_power[RF_PATH_A] = rx_power;
+	pkt_stat->rssi = rtw_phy_rf_power_2_rssi(pkt_stat->rx_power, 1);
+	pkt_stat->signal_power = max(pkt_stat->rx_power[RF_PATH_A],
+				     min_rx_power);
+	rtwdev->dm_info.rssi[RF_PATH_A] = pkt_stat->rssi;
+}
+
+static void rtw8723b_query_phy_status_ofdm(struct rtw_dev *rtwdev, u8 *phy_raw,
+					   struct rtw_rx_pkt_stat *pkt_stat)
+{
+	struct phy_status_8703b *phy_status = (struct phy_status_8703b *)phy_raw;
+	struct rtw_dm_info *dm_info = &rtwdev->dm_info;
+	s8 val_s8;
+
+	/*
+	 * pkt_stat->bw is left at its default (RTW_CHANNEL_WIDTH_20), which is
+	 * correct while the driver only operates at 20 MHz.  Parsing the RX
+	 * bandwidth out of phy_status is only needed once HT40 is enabled.
+	 */
+
+	val_s8 = phy_status->path_agc[RF_PATH_A].gain & 0x3F;
+	pkt_stat->rx_power[RF_PATH_A] = (val_s8 * 2) - 110;
+
+	pkt_stat->rssi = rtw_phy_rf_power_2_rssi(pkt_stat->rx_power, 1);
+	pkt_stat->rx_snr[RF_PATH_A] = (s8)(phy_status->path_rxsnr[RF_PATH_A] / 2);
+
+	/* signal power reported by HW */
+	val_s8 = phy_status->cck_sig_qual_ofdm_pwdb_all >> 1;
+	pkt_stat->signal_power = (val_s8 & 0x7f) - 110;
+
+	pkt_stat->rx_evm[RF_PATH_A] = phy_status->stream_rxevm[RF_PATH_A];
+	pkt_stat->cfo_tail[RF_PATH_A] = phy_status->path_cfotail[RF_PATH_A];
+
+	dm_info->curr_rx_rate = pkt_stat->rate;
+	dm_info->rssi[RF_PATH_A] = pkt_stat->rssi;
+	dm_info->rx_snr[RF_PATH_A] = pkt_stat->rx_snr[RF_PATH_A] >> 1;
+	dm_info->cfo_tail[RF_PATH_A] = (pkt_stat->cfo_tail[RF_PATH_A] * 5) >> 1;
+
+	val_s8 = (s8)pkt_stat->rx_evm[RF_PATH_A];
+	val_s8 = clamp_t(s8, -val_s8 >> 1, 0, 64);
+	val_s8 &= 0x3F; /* 64->0: second path of 1SS rate is 64 */
+	dm_info->rx_evm_dbm[RF_PATH_A] = val_s8;
+}
+
+static void rtw8723b_query_phy_status(struct rtw_dev *rtwdev, u8 *phy_status,
+				      struct rtw_rx_pkt_stat *pkt_stat)
+{
+	/*
+	 * The 8723B PHY status does not report the channel, so we must
+	 * mark it invalid to allow mac80211/rtw88 to parse it from the IE
+	 * during scanning.
+	 */
+	pkt_stat->channel_invalid = true;
+
+	if (pkt_stat->rate <= DESC_RATE11M)
+		rtw8723b_query_phy_status_cck(rtwdev, phy_status, pkt_stat);
+	else
+		rtw8723b_query_phy_status_ofdm(rtwdev, phy_status, pkt_stat);
+}
+
+static void rtw8723b_set_iqk_matrix_by_result(struct rtw_dev *rtwdev,
+					      u32 ofdm_swing, u8 path)
+{
+	struct rtw_dm_info *dm_info = &rtwdev->dm_info;
+	s32 ele_A, ele_D, ele_C, ele_A_ext;
+	s32 iqk_result_x;
+	s32 iqk_result_y;
+	s32 value32;
+
+	switch (path) {
+	default:
+	case RF_PATH_A:
+		iqk_result_x = dm_info->iqk.result.s1_x;
+		iqk_result_y = dm_info->iqk.result.s1_y;
+		break;
+	case RF_PATH_B:
+		iqk_result_x = dm_info->iqk.result.s0_x;
+		iqk_result_y = dm_info->iqk.result.s0_y;
+		break;
+	}
+
+	/* new element D */
+	ele_D = OFDM_SWING_D(ofdm_swing);
+
+	/* new element A */
+	iqk_result_x = iqkxy_to_s32(iqk_result_x);
+	ele_A = iqk_mult(iqk_result_x, ele_D, &ele_A_ext);
+
+	/* new element C */
+	iqk_result_y = iqkxy_to_s32(iqk_result_y);
+	ele_C = iqk_mult(iqk_result_y, ele_D, NULL);
+
+	switch (path) {
+	case RF_PATH_A:
+	default:
+		/* write new elements A, C, D, element B is always 0 */
+		value32 = BIT_SET_TXIQ_ELM_ACD(ele_A, ele_C, ele_D);
+		rtw_write32(rtwdev, REG_OFDM_0_XA_TX_IQ_IMBALANCE, value32);
+		value32 = BIT_SET_TXIQ_ELM_C1(ele_C);
+		rtw_write32_mask(rtwdev, REG_TXIQK_MATRIXA_LSB2_11N, MASKH4BITS,
+				 value32);
+		rtw_write32_mask(rtwdev, REG_OFDM_0_ECCA_THRESHOLD, BIT(24),
+				 ele_A_ext);
+		break;
+
+	case RF_PATH_B:
+		/* write new elements A, C, D, element B is always 0 */
+		value32 = BIT_SET_TXIQ_ELM_ACD(ele_A, ele_C, ele_D);
+		rtw_write32(rtwdev, REG_OFDM_0_XB_TX_IQ_IMBALANCE, value32);
+		value32 = BIT_SET_TXIQ_ELM_C1(ele_C);
+		rtw_write32_mask(rtwdev, REG_TXIQK_MATRIXB_LSB2_11N, MASKH4BITS,
+				 value32);
+		rtw_write32_mask(rtwdev, REG_OFDM_0_ECCA_THRESHOLD, BIT(28),
+				 ele_A_ext);
+		break;
+	}
+}
+
+static void rtw8723b_set_iqk_matrix(struct rtw_dev *rtwdev, s8 ofdm_index,
+				    u8 path)
+{
+	struct rtw_dm_info *dm_info = &rtwdev->dm_info;
+	u32 ofdm_swing;
+
+	ofdm_index = clamp_t(s8, ofdm_index, 0, RTW_OFDM_SWING_TABLE_SIZE - 1);
+
+	ofdm_swing = rtw8723b_ofdm_swing_table[ofdm_index];
+
+	if (dm_info->iqk.done) {
+		rtw8723b_set_iqk_matrix_by_result(rtwdev, ofdm_swing, path);
+		return;
+	}
+
+	switch (path) {
+	case RF_PATH_A:
+	default:
+		rtw_write32(rtwdev, REG_OFDM_0_XA_TX_IQ_IMBALANCE, ofdm_swing);
+		rtw_write32_mask(rtwdev, REG_TXIQK_MATRIXA_LSB2_11N, MASKH4BITS,
+				 0x00);
+		rtw_write32_mask(rtwdev, REG_OFDM_0_ECCA_THRESHOLD, BIT(24),
+				 0x00);
+		break;
+
+	case RF_PATH_B:
+		rtw_write32(rtwdev, REG_OFDM_0_XB_TX_IQ_IMBALANCE, ofdm_swing);
+		rtw_write32_mask(rtwdev, REG_TXIQK_MATRIXB_LSB2_11N, MASKH4BITS,
+				 0x00);
+		rtw_write32_mask(rtwdev, REG_OFDM_0_ECCA_THRESHOLD, BIT(28),
+				 0x00);
+		break;
+	}
+}
+
+static u8 rtw8723b_iqk_check_tx_failed(struct rtw_dev *rtwdev)
+{
+	s32 tx_x, tx_y;
+	u32 tx_fail;
+
+	rtw_dbg(rtwdev, RTW_DBG_RFK, "[IQK] 0xeac = 0x%x\n",
+		rtw_read32(rtwdev, REG_IQK_RES_RY));
+	rtw_dbg(rtwdev, RTW_DBG_RFK, "[IQK] 0xe94 = 0x%x, 0xe9c = 0x%x\n",
+		rtw_read32(rtwdev, REG_IQK_RES_TX),
+		rtw_read32(rtwdev, REG_IQK_RES_TY));
+	rtw_dbg(rtwdev, RTW_DBG_RFK,
+		"[IQK] 0xe90(before IQK) = 0x%x, 0xe98(after IQK) = 0x%x\n",
+		rtw_read32(rtwdev, 0xe90),
+		rtw_read32(rtwdev, 0xe98));
+
+	tx_fail = rtw_read32_mask(rtwdev, REG_IQK_RES_RY, BIT_IQK_TX_FAIL);
+	tx_x = rtw_read32_mask(rtwdev, REG_IQK_RES_TX, BIT_MASK_RES_TX);
+	tx_y = rtw_read32_mask(rtwdev, REG_IQK_RES_TY, BIT_MASK_RES_TY);
+
+	if (!tx_fail && tx_x != IQK_TX_X_ERR && tx_y != IQK_TX_Y_ERR)
+		return IQK_TX_OK; /* BIT(0) */
+
+	rtw_dbg(rtwdev, RTW_DBG_RFK, "[IQK] A TX IQK failed\n");
+
+	return 0;
+}
+
+static u8 rtw8723b_iqk_check_rx_failed(struct rtw_dev *rtwdev)
+{
+	s32 rx_x, rx_y;
+	u32 rx_fail;
+
+	rtw_dbg(rtwdev, RTW_DBG_RFK, "[IQK] 0xea4 = 0x%x, 0xeac = 0x%x\n",
+		rtw_read32(rtwdev, REG_IQK_RES_RX),
+		rtw_read32(rtwdev, REG_IQK_RES_RY));
+	rtw_dbg(rtwdev, RTW_DBG_RFK,
+		"[IQK] 0xea0(before IQK) = 0x%x, 0xea8(after IQK) = 0x%x\n",
+		rtw_read32(rtwdev, 0xea0),
+		rtw_read32(rtwdev, 0xea8));
+
+	rx_fail = rtw_read32_mask(rtwdev, REG_IQK_RES_RY, BIT_IQK_RX_FAIL);
+	rx_x = rtw_read32_mask(rtwdev, REG_IQK_RES_RX, BIT_MASK_RES_RX);
+	rx_y = rtw_read32_mask(rtwdev, REG_IQK_RES_RY, BIT_MASK_RES_RY);
+	rx_y = abs(iqkxy_to_s32(rx_y));
+
+	if (!rx_fail && rx_x != IQK_RX_X_ERR && rx_y != IQK_RX_Y_ERR &&
+	    rx_x < IQK_RX_X_UPPER && rx_x > IQK_RX_X_LOWER &&
+	     rx_y < IQK_RX_Y_LMT)
+		return IQK_RX_OK; /* BIT(1) */
+
+	rtw_dbg(rtwdev, RTW_DBG_RFK, "[IQK] A RX IQK failed\n");
+
+	return 0;
+}
+
+static u8 rtw8723b_iqk_tx_path_a(struct rtw_dev *rtwdev)
+{
+	bool sdio_iqk = rtw8723b_sdio_needs_rx_path_fix(rtwdev);
+	u8 status;
+	u32 path_sel;
+
+	rtw_dbg(rtwdev, RTW_DBG_RFK, "[IQK] path A TX IQK!\n");
+
+	/* Save RF path */
+	path_sel = rtw_read32(rtwdev, REG_BB_SEL_BTG);
+
+	/* leave IQK mode */
+	rtw_write32_mask(rtwdev, REG_FPGA0_IQK_11N, MASKH3BYTES, 0x000000);
+
+	/* enable path A PA in TX IQK mode */
+	rtw_write_rf(rtwdev, RF_PATH_A, RF_LUTWE, 0x80000, 0x1);
+	rtw_write_rf(rtwdev, RF_PATH_A, RF_MODE_TABLE_ADDR, RFREG_MASK,
+		     sdio_iqk ? 0x18000 : 0x20000);
+	rtw_write_rf(rtwdev, RF_PATH_A, RF_MODE_TABLE_DATA0, RFREG_MASK, 0x0003f);
+	rtw_write_rf(rtwdev, RF_PATH_A, RF_MODE_TABLE_DATA1, RFREG_MASK, 0xc7f87);
+
+	/* Tx IQK setting */
+	rtw_write32(rtwdev, REG_TXIQK_11N, 0x01007c00);
+	rtw_write32(rtwdev, REG_RXIQK_11N, 0x01004800);
+
+	/* path-A IQK setting */
+	rtw_write32(rtwdev, REG_TXIQK_TONE_A_11N, 0x18008c1c);
+	rtw_write32(rtwdev, REG_RXIQK_TONE_A_11N, 0x38008c1c);
+	rtw_write32(rtwdev, REG_TX_IQK_TONE_B, 0x38008c1c);
+	rtw_write32(rtwdev, REG_RX_IQK_TONE_B, 0x38008c1c);
+
+	rtw_write32(rtwdev, REG_TXIQK_PI_A_11N,
+		    sdio_iqk ? 0x821303ea : 0x821403ea);
+	rtw_write32(rtwdev, REG_RXIQK_PI_A_11N, 0x28110000);
+	rtw_write32(rtwdev, REG_TXIQK_PI_B, 0x82110000);
+	rtw_write32(rtwdev, REG_RXIQK_PI_B, 0x28110000);
+
+	/* LO calibration setting */
+	rtw_write32(rtwdev, REG_IQK_AGC_RSP_11N, 0x00462911);
+
+	/* enter IQK mode */
+	rtw_write32_mask(rtwdev, REG_FPGA0_IQK_11N, MASKH3BYTES, 0x808000);
+
+	/* ant switch */
+	rtw_write32(rtwdev, REG_BB_SEL_BTG,
+		    rtw8723b_iqk_ant_switch_path(rtwdev));
+
+	/* GNT_BT = 0 */
+	rtw_write32(rtwdev, REG_BT_CONTROL_8723B, 0x00000800);
+
+	/* One shot, path A LOK & IQK */
+	rtw_write32(rtwdev, REG_IQK_AGC_PTS_11N, 0xf9000000);
+	rtw_write32(rtwdev, REG_IQK_AGC_PTS_11N, 0xf8000000);
+
+	mdelay(IQK_DELAY_TIME_8723B);
+
+	/* restore ant path */
+	rtw_write32(rtwdev, REG_BB_SEL_BTG, path_sel);
+
+	/* GNT_BT = 1 */
+	rtw_write32(rtwdev, REG_BT_CONTROL_8723B, 0x00001800);
+
+	/* leave IQK mode */
+	rtw_write32_mask(rtwdev, REG_FPGA0_IQK_11N, MASKH3BYTES, 0x000000);
+
+	/* Check failed */
+	status = rtw8723b_iqk_check_tx_failed(rtwdev);
+
+	return status;
+}
+
+static u8 rtw8723b_iqk_rx_path_a(struct rtw_dev *rtwdev)
+{
+	bool sdio_iqk = rtw8723b_sdio_needs_rx_path_fix(rtwdev);
+	u32 reg_e94, reg_e9c, val32, path_sel;
+	u8 status;
+
+	rtw_dbg(rtwdev, RTW_DBG_RFK, "[IQK] path A RX IQK step1!\n");
+
+	/* Save RF path */
+	path_sel = rtw_read32(rtwdev, REG_BB_SEL_BTG);
+
+	/* leave IQK mode */
+	rtw_write32_mask(rtwdev, REG_FPGA0_IQK_11N, MASKH3BYTES, 0x000000);
+
+	rtw_write_rf(rtwdev, RF_PATH_A, RF_LUTWE, 0x80000, 0x1);
+	rtw_write_rf(rtwdev, RF_PATH_A, RF_MODE_TABLE_ADDR, RFREG_MASK,
+		     sdio_iqk ? 0x18000 : 0x30000);
+	rtw_write_rf(rtwdev, RF_PATH_A, RF_MODE_TABLE_DATA0, RFREG_MASK, 0x0001f);
+	rtw_write_rf(rtwdev, RF_PATH_A, RF_MODE_TABLE_DATA1, RFREG_MASK, 0xf7fb7);
+
+	/* IQK setting */
+	rtw_write32(rtwdev, REG_TXIQK_11N, 0x01007c00);
+	rtw_write32(rtwdev, REG_RXIQK_11N, 0x01004800);
+
+	/* path-A IQK setting */
+	rtw_write32(rtwdev, REG_TXIQK_TONE_A_11N, 0x18008c1c);
+	rtw_write32(rtwdev, REG_RXIQK_TONE_A_11N, 0x38008c1c);
+	rtw_write32(rtwdev, REG_TX_IQK_TONE_B, 0x38008c1c);
+	rtw_write32(rtwdev, REG_RX_IQK_TONE_B, 0x38008c1c);
+
+	rtw_write32(rtwdev, REG_TXIQK_PI_A_11N,
+		    sdio_iqk ? 0x82130ff0 : 0x82160ff0);
+	rtw_write32(rtwdev, REG_RXIQK_PI_A_11N, 0x28110000);
+	rtw_write32(rtwdev, REG_TXIQK_PI_B, 0x82110000);
+	rtw_write32(rtwdev, REG_RXIQK_PI_B, 0x28110000);
+
+	/* LO calibration setting */
+	rtw_write32(rtwdev, REG_IQK_AGC_RSP_11N, 0x0046a911);
+
+	/* enter IQK mode */
+	rtw_write32_mask(rtwdev, REG_FPGA0_IQK_11N, MASKH3BYTES, 0x808000);
+
+	/* ant switch */
+	rtw_write32(rtwdev, REG_BB_SEL_BTG,
+		    rtw8723b_iqk_ant_switch_path(rtwdev));
+
+	/* GNT_BT = 0 (disable BT) */
+	rtw_write32(rtwdev, REG_BT_CONTROL_8723B, 0x00000800);
+
+	/* One shot, path A LOK & IQK */
+	rtw_write32(rtwdev, REG_IQK_AGC_PTS_11N, 0xf9000000);
+	rtw_write32(rtwdev, REG_IQK_AGC_PTS_11N, 0xf8000000);
+
+	mdelay(IQK_DELAY_TIME_8723B);
+
+	/* restore ant path */
+	rtw_write32(rtwdev, REG_BB_SEL_BTG, path_sel);
+
+	/* GNT_BT = 1 */
+	rtw_write32(rtwdev, REG_BT_CONTROL_8723B, 0x00001800);
+
+	/* leave IQK mode */
+	rtw_write32_mask(rtwdev, REG_FPGA0_IQK_11N, MASKH3BYTES, 0x000000);
+
+	/* Check failed */
+	status = rtw8723b_iqk_check_tx_failed(rtwdev);
+
+	/* if Tx not OK, ignore Rx */
+	if (!status)
+		return status;
+
+	reg_e94 = rtw_read32(rtwdev, REG_IQK_RES_TX);
+	reg_e9c = rtw_read32(rtwdev, REG_IQK_RES_TY);
+	val32 = 0x80007c00 | (reg_e94 & 0x3ff0000) |
+	((reg_e9c & 0x3ff0000) >> 16);
+	rtw_write32(rtwdev, REG_TXIQK_11N, val32);
+
+	rtw_dbg(rtwdev, RTW_DBG_RFK, "[IQK] path A RX IQK step2!");
+
+	/* modify RX IQK mode */
+	rtw_write32_mask(rtwdev, REG_FPGA0_IQK_11N, MASKH3BYTES, 0x000000);
+	rtw_write_rf(rtwdev, RF_PATH_A, RF_LUTWE, 0x80000, 0x1);
+	rtw_write_rf(rtwdev, RF_PATH_A, RF_MODE_TABLE_ADDR, RFREG_MASK,
+		     sdio_iqk ? 0x18000 : 0x30000);
+	rtw_write_rf(rtwdev, RF_PATH_A, RF_MODE_TABLE_DATA0, RFREG_MASK, 0x0001f);
+	rtw_write_rf(rtwdev, RF_PATH_A, RF_MODE_TABLE_DATA1, RFREG_MASK, 0xf7d77);
+
+	/* PA, PAD setting */
+	rtw_write_rf(rtwdev, RF_PATH_A, 0xdf, RFREG_MASK, 0xf80);
+	rtw_write_rf(rtwdev, RF_PATH_A, 0x55, RFREG_MASK, 0x4021f);
+
+	/* IQK setting */
+	rtw_write32(rtwdev, REG_RXIQK_11N, 0x01004800);
+
+	/* path-A IQK setting */
+	rtw_write32(rtwdev, REG_TXIQK_TONE_A_11N, 0x38008c1c);
+	rtw_write32(rtwdev, REG_RXIQK_TONE_A_11N, 0x18008c1c);
+	rtw_write32(rtwdev, REG_TX_IQK_TONE_B, 0x38008c1c);
+	rtw_write32(rtwdev, REG_RX_IQK_TONE_B, 0x38008c1c);
+
+	rtw_write32(rtwdev, REG_TXIQK_PI_A_11N, 0x82110000);
+	rtw_write32(rtwdev, REG_RXIQK_PI_A_11N,
+		    sdio_iqk ? 0x2813001f : 0x2816001f);
+	rtw_write32(rtwdev, REG_TXIQK_PI_B, 0x82110000);
+	rtw_write32(rtwdev, REG_RXIQK_PI_B, 0x28110000);
+
+	/* LO calibration setting */
+	rtw_write32(rtwdev, REG_IQK_AGC_RSP_11N, 0x0046a8d1);
+
+	/* enter IQK mode */
+	rtw_write32_mask(rtwdev, REG_FPGA0_IQK_11N, MASKH3BYTES, 0x808000);
+
+	/* ant switch */
+	rtw_write32(rtwdev, REG_BB_SEL_BTG,
+		    rtw8723b_iqk_ant_switch_path(rtwdev));
+
+	/* GNT_BT = 0 */
+	rtw_write32(rtwdev, REG_BT_CONTROL_8723B, 0x00000800);
+
+	/* One shot, path A LOK & IQK */
+	rtw_write32(rtwdev, REG_IQK_AGC_PTS_11N, 0xf9000000);
+	rtw_write32(rtwdev, REG_IQK_AGC_PTS_11N, 0xf8000000);
+
+	mdelay(IQK_DELAY_TIME_8723B);
+
+	/* restore ant path */
+	rtw_write32(rtwdev, REG_BB_SEL_BTG, path_sel);
+
+	/* GNT_BT = 1 */
+	rtw_write32(rtwdev, REG_BT_CONTROL_8723B, 0x00001800);
+
+	/* leave IQK mode */
+	rtw_write32_mask(rtwdev, REG_FPGA0_IQK_11N, MASKH3BYTES, 0x000000);
+
+	/* Check failed */
+
+	rtw_write_rf(rtwdev, RF_PATH_A, 0xdf, RFREG_MASK, 0x780);
+
+	status |= rtw8723b_iqk_check_rx_failed(rtwdev);
+
+	return status;
+}
+
+static
+void rtw8723b_iqk_fill_a_matrix(struct rtw_dev *rtwdev, const s32 result[])
+{
+	s32 tx1_a, tx1_a_ext;
+	s32 tx1_c, tx1_c_ext;
+	s32 oldval_1;
+	s32 x, y;
+
+	if (result[IQK_S1_TX_X] == 0)
+		return;
+
+	oldval_1 = rtw_read32_mask(rtwdev, REG_OFDM_0_XA_TX_IQ_IMBALANCE,
+				   BIT_MASK_TXIQ_ELM_D);
+
+	x = iqkxy_to_s32(result[IQK_S1_TX_X]);
+	tx1_a = iqk_mult(x, oldval_1, &tx1_a_ext);
+	rtw_write32_mask(rtwdev, REG_OFDM_0_XA_TX_IQ_IMBALANCE,
+			 BIT_MASK_TXIQ_ELM_A, tx1_a);
+	rtw_write32_mask(rtwdev, REG_OFDM_0_ECCA_THRESHOLD,
+			 BIT_MASK_OFDM0_EXT_A, tx1_a_ext);
+
+	y = iqkxy_to_s32(result[IQK_S1_TX_Y]);
+	tx1_c = iqk_mult(y, oldval_1, &tx1_c_ext);
+	rtw_write32_mask(rtwdev, REG_TXIQK_MATRIXA_LSB2_11N, MASKH4BITS,
+			 BIT_SET_TXIQ_ELM_C1(tx1_c));
+	rtw_write32_mask(rtwdev, REG_OFDM_0_XA_TX_IQ_IMBALANCE,
+			 BIT_MASK_TXIQ_ELM_C, BIT_SET_TXIQ_ELM_C2(tx1_c));
+	rtw_write32_mask(rtwdev, REG_OFDM_0_ECCA_THRESHOLD,
+			 BIT_MASK_OFDM0_EXT_C, tx1_c_ext);
+
+	rtw_dbg(rtwdev, RTW_DBG_RFK,
+		"[IQK] X = 0x%x, TX1_A = 0x%x, oldval_1 0x%x\n",
+		x, tx1_a, oldval_1);
+	rtw_dbg(rtwdev, RTW_DBG_RFK,
+		"[IQK] Y = 0x%x, TX1_C = 0x%x\n", y, tx1_c);
+
+	if (result[IQK_S1_RX_X] == 0)
+		return;
+
+	rtw_write32_mask(rtwdev, REG_A_RXIQI, BIT_MASK_RXIQ_S1_X,
+			 result[IQK_S1_RX_X]);
+	rtw_write32_mask(rtwdev, REG_A_RXIQI, BIT_MASK_RXIQ_S1_Y1,
+			 BIT_SET_RXIQ_S1_Y1(result[IQK_S1_RX_Y]));
+	rtw_write32_mask(rtwdev, REG_RXIQK_MATRIX_LSB_11N, BIT_MASK_RXIQ_S1_Y2,
+			 BIT_SET_RXIQ_S1_Y2(result[IQK_S1_RX_Y]));
+}
+
+static
+void rtw8723b_iqk_fill_b_matrix(struct rtw_dev *rtwdev, const s32 result[])
+{
+	s32 tx0_a, tx0_a_ext;
+	s32 tx0_c, tx0_c_ext;
+	s32 oldval_0;
+	s32 x, y;
+
+	if (result[IQK_S0_TX_X] == 0)
+		return;
+
+	oldval_0 = rtw_read32_mask(rtwdev, REG_OFDM_0_XB_TX_IQ_IMBALANCE,
+				   BIT_MASK_TXIQ_ELM_D);
+
+	x = iqkxy_to_s32(result[IQK_S0_TX_X]);
+	tx0_a = iqk_mult(x, oldval_0, &tx0_a_ext);
+
+	rtw_write32_mask(rtwdev, REG_OFDM_0_XB_TX_IQ_IMBALANCE,
+			 BIT_MASK_TXIQ_ELM_A, tx0_a);
+	rtw_write32_mask(rtwdev, REG_OFDM_0_ECCA_THRESHOLD, BIT(27),
+			 tx0_a_ext);
+
+	y = iqkxy_to_s32(result[IQK_S0_TX_Y]);
+	tx0_c = iqk_mult(y, oldval_0, &tx0_c_ext);
+
+	rtw_write32_mask(rtwdev, REG_TXIQK_MATRIXB_LSB2_11N, MASKH4BITS,
+			 BIT_SET_TXIQ_ELM_C1(tx0_c));
+	rtw_write32_mask(rtwdev, REG_OFDM_0_XB_TX_IQ_IMBALANCE,
+			 BIT_MASK_TXIQ_ELM_C, BIT_SET_TXIQ_ELM_C2(tx0_c));
+	rtw_write32_mask(rtwdev, REG_OFDM_0_ECCA_THRESHOLD, BIT(25),
+			 tx0_c_ext);
+
+	if (result[IQK_S0_RX_X] == 0)
+		return;
+
+	rtw_write32_mask(rtwdev, REG_B_RXIQI, BIT_MASK_RXIQ_X_S0,
+			 result[IQK_S0_RX_X]);
+	rtw_write32_mask(rtwdev, REG_B_RXIQI, BIT_MASK_RXIQ_S1_Y1,
+			 BIT_SET_RXIQ_S1_Y1(result[IQK_S0_RX_Y]));
+}
+
+static
+void rtw8723b_iqk_config_mac(struct rtw_dev *rtwdev,
+			     const struct rtw8723x_iqk_backup_regs *backup)
+{
+	int i;
+
+	rtw_write8(rtwdev, rtw8723x_common.iqk_mac8_regs[0], 0x3f);
+
+	for (i = 1; i < RTW8723X_IQK_MAC8_REG_NUM; i++)
+		rtw_write8(rtwdev, rtw8723x_common.iqk_mac8_regs[i],
+			   backup->mac8[i] & (~BIT(3)));
+
+	/* This MAC backup register needs a byte-wide write. */
+	rtw_write8(rtwdev, rtw8723x_common.iqk_mac32_regs[0],
+		   backup->mac32[0] & (~BIT(5)));
+}
+
+static
+void rtw8723b_iqk_one_round(struct rtw_dev *rtwdev, s32 result[][IQK_NR], u8 t,
+			    const struct rtw8723x_iqk_backup_regs *backup)
+{
+	u32 i;
+	u8 a_ok;
+	/* u8 b_ok; */
+
+	rtw_dbg(rtwdev, RTW_DBG_RFK,
+		"[IQK] IQ Calibration for 1T1R_S0/S1 for %d times\n", t);
+
+	rtw8723x_iqk_path_adda_on(rtwdev, ADDA_ON_VAL_8723B);
+	rtw8723b_iqk_config_mac(rtwdev, backup);
+
+	rtw_write32_mask(rtwdev, REG_CCK_ANT_SEL_11N, 0x0f000000, 0xf);
+	rtw_write32(rtwdev, REG_BB_RX_PATH_11N, 0x03a05600);
+	rtw_write32(rtwdev, REG_TRMUX_11N, 0x000800e4);
+	rtw_write32(rtwdev, REG_BB_PWR_SAV1_11N, 0x22204000);
+
+	/*
+	 * RX IQ calibration setting for 8723B D cut large current issue
+	 * when leaving IPS
+	 */
+	rtw_write32_mask(rtwdev, REG_FPGA0_IQK_11N, MASKH3BYTES, 0x000000);
+	rtw_write_rf(rtwdev, RF_PATH_A, RF_LUTWE, 0x80000, 0x1);
+	rtw_write_rf(rtwdev, RF_PATH_A, RF_MODE_TABLE_ADDR, RFREG_MASK, 0x30000);
+	rtw_write_rf(rtwdev, RF_PATH_A, RF_MODE_TABLE_DATA0, RFREG_MASK, 0x0001f);
+	rtw_write_rf(rtwdev, RF_PATH_A, RF_MODE_TABLE_DATA1, RFREG_MASK, 0xf7fb7);
+	rtw_write_rf(rtwdev, RF_PATH_A, 0xed, 0x20, 0x1);
+	rtw_write_rf(rtwdev, RF_PATH_A, 0x43, RFREG_MASK, 0x60fbd);
+
+	for (i = 0; i < PATH_IQK_RETRY; i++) {
+		a_ok = rtw8723b_iqk_tx_path_a(rtwdev);
+		if (a_ok == IQK_TX_OK) {
+			rtw_dbg(rtwdev, RTW_DBG_RFK,
+				"[IQK] path A TX IQK success!\n");
+
+			rtw_write32_mask(rtwdev, REG_FPGA0_IQK_11N,
+					 MASKH3BYTES, 0x000000);
+
+			result[t][IQK_S1_TX_X] =
+				rtw_read32_mask(rtwdev, REG_IQK_RES_TX,
+						BIT_MASK_RES_TX);
+			result[t][IQK_S1_TX_Y] =
+				rtw_read32_mask(rtwdev, REG_IQK_RES_TY,
+						BIT_MASK_RES_TY);
+			break;
+		}
+
+		rtw_dbg(rtwdev, RTW_DBG_RFK, "[IQK] path A TX IQK fail!\n");
+		result[t][IQK_S1_TX_X] = 0x100;
+		result[t][IQK_S1_TX_Y] = 0x0;
+	}
+
+	for (i = 0; i < PATH_IQK_RETRY; i++) {
+		a_ok = rtw8723b_iqk_rx_path_a(rtwdev);
+		if (a_ok == (IQK_TX_OK | IQK_RX_OK)) {
+			rtw_dbg(rtwdev, RTW_DBG_RFK,
+				"[IQK] path A RX IQK success!\n");
+			result[t][IQK_S1_RX_X] =
+				rtw_read32_mask(rtwdev, REG_IQK_RES_RX,
+						BIT_MASK_RES_RX);
+			result[t][IQK_S1_RX_Y] =
+				rtw_read32_mask(rtwdev, REG_IQK_RES_RY,
+						BIT_MASK_RES_RY);
+			break;
+		}
+
+		rtw_dbg(rtwdev, RTW_DBG_RFK, "[IQK] path A RX IQK fail!\n");
+		result[t][IQK_S1_RX_X] = 0x100;
+		result[t][IQK_S1_RX_Y] = 0x0;
+	}
+
+	if (a_ok == 0x0)
+		rtw_dbg(rtwdev, RTW_DBG_RFK, "[IQK] path A IQK fail!\n");
+
+	/* rtl8723b is 1T1R, so path B is not calibrated. */
+
+	rtw_write32_mask(rtwdev, REG_FPGA0_IQK_11N, MASKH3BYTES, 0x000000);
+}
+
+static void rtw8723b_phy_calibration(struct rtw_dev *rtwdev)
+{
+	struct rtw_dm_info *dm_info = &rtwdev->dm_info;
+	struct rtw8723x_iqk_backup_regs backup;
+	s32 result[IQK_ROUND_SIZE][IQK_NR];
+	u8 final_candidate = IQK_ROUND_INVALID;
+	u32 bt_control;
+	bool good;
+	u8 i, j;
+
+	rtw_dbg(rtwdev, RTW_DBG_RFK, "[IQK] Start!\n");
+	memset(result, 0, sizeof(result));
+
+	rtw8723b_lck(rtwdev);
+	rtw8723b_inform_rfk_status(rtwdev, true);
+
+	/* The LTE path GNT backup that 8723d does is not needed on SDIO. */
+	rtw8723x_iqk_backup_path_ctrl(rtwdev, &backup);
+	rtw8723x_iqk_backup_regs(rtwdev, &backup);
+
+	/* save default GNT_BT */
+	bt_control = rtw_read32(rtwdev, REG_BT_CONTROL_8723B);
+
+	for (i = IQK_ROUND_0; i <= IQK_ROUND_2; i++) {
+		if (!rtw8723b_sdio_needs_rx_path_fix(rtwdev))
+			rtw8723x_iqk_config_path_ctrl(rtwdev);
+
+		rtw8723b_iqk_one_round(rtwdev, result, i, &backup);
+
+		rtw_dbg(rtwdev, RTW_DBG_RFK,
+			"[IQK] back to BB mode, load original value!\n");
+
+		if (i > IQK_ROUND_0) {
+			rtw8723x_iqk_restore_regs(rtwdev, &backup);
+
+			/* Restore RX initial gain */
+			rtw_write32_mask(rtwdev, REG_OFDM0_XAAGC1, MASKBYTE0, 0x50);
+			rtw_write32_mask(rtwdev, REG_OFDM0_XAAGC1, MASKBYTE0, backup.igia);
+
+			/* path B; only for 2T */
+
+			/* load 0xe30 IQC default value */
+			rtw_write32(rtwdev, REG_TXIQK_TONE_A_11N, 0x01008c00);
+			rtw_write32(rtwdev, REG_RXIQK_TONE_A_11N, 0x01008c00);
+		}
+
+		if (!rtw8723b_sdio_needs_rx_path_fix(rtwdev))
+			rtw8723x_iqk_restore_path_ctrl(rtwdev, &backup);
+
+		for (j = IQK_ROUND_0; j < i; j++) {
+			good = rtw8723x_iqk_similarity_cmp(rtwdev, result, j, i);
+			if (good) {
+				final_candidate = j;
+				rtw_dbg(rtwdev, RTW_DBG_RFK,
+					"[IQK] cmp %d:%d final_candidate is %x\n",
+					j, i, final_candidate);
+				goto iqk_done;
+			}
+		}
+	}
+
+	if (final_candidate == IQK_ROUND_INVALID) {
+		s32 reg_tmp = 0;
+
+		for (i = 0; i < IQK_NR; i++)
+			reg_tmp += result[IQK_ROUND_HYBRID][i];
+
+		if (reg_tmp != 0) {
+			final_candidate = IQK_ROUND_HYBRID;
+		} else {
+			WARN(1, "IQK failed\n");
+			goto out;
+		}
+	}
+
+iqk_done:
+	if (result[final_candidate][IQK_S1_TX_X])
+		rtw8723b_iqk_fill_a_matrix(rtwdev, result[final_candidate]);
+	if (result[final_candidate][IQK_S0_TX_X])
+		rtw8723b_iqk_fill_b_matrix(rtwdev, result[final_candidate]);
+
+	dm_info->iqk.result.s1_x = result[final_candidate][IQK_S1_TX_X];
+	dm_info->iqk.result.s1_y = result[final_candidate][IQK_S1_TX_Y];
+	dm_info->iqk.result.s0_x = result[final_candidate][IQK_S0_TX_X];
+	dm_info->iqk.result.s0_y = result[final_candidate][IQK_S0_TX_Y];
+	dm_info->iqk.done = true;
+
+out:
+	/* restore RF path */
+	rtw_write32(rtwdev, REG_BB_SEL_BTG, backup.bb_sel_btg);
+
+	/* restore GNT_BT */
+	rtw_write32(rtwdev, REG_BT_CONTROL_8723B, bt_control);
+
+	/* Restore RX mode table parameter */
+	rtw_write_rf(rtwdev, RF_PATH_A, RF_LUTWE, 0x80000, 0x1);
+	rtw_write_rf(rtwdev, RF_PATH_A, RF_MODE_TABLE_ADDR, RFREG_MASK, 0x18000);
+	rtw_write_rf(rtwdev, RF_PATH_A, RF_MODE_TABLE_DATA0, RFREG_MASK, 0x0001f);
+	rtw_write_rf(rtwdev, RF_PATH_A, RF_MODE_TABLE_DATA1, RFREG_MASK, 0xe6177);
+	rtw_write_rf(rtwdev, RF_PATH_A, 0xed, 0x20, 0x1);
+	rtw_write_rf(rtwdev, RF_PATH_A, 0x43, RFREG_MASK, 0x300bd);
+
+	rtw_dbg(rtwdev, RTW_DBG_RFK, "[IQK] final_candidate is %x\n",
+		final_candidate);
+
+	for (i = IQK_ROUND_0; i < IQK_ROUND_SIZE; i++)
+		rtw_dbg(rtwdev, RTW_DBG_RFK,
+			"[IQK] Result %u: rege94_s1=%x rege9c_s1=%x regea4_s1=%x regeac_s1=%x rege94_s0=%x rege9c_s0=%x regea4_s0=%x regeac_s0=%x %s\n",
+			i,
+			result[i][0], result[i][1], result[i][2], result[i][3],
+			result[i][4], result[i][5], result[i][6], result[i][7],
+			final_candidate == i ? "(final candidate)" : "");
+
+	rtw_dbg(rtwdev, RTW_DBG_RFK,
+		"[IQK]0xc80 = 0x%x 0xc94 = 0x%x 0xc14 = 0x%x 0xca0 = 0x%x\n",
+	rtw_read32(rtwdev, REG_OFDM_0_XA_TX_IQ_IMBALANCE),
+		rtw_read32(rtwdev, REG_TXIQK_MATRIXA_LSB2_11N),
+		rtw_read32(rtwdev, REG_A_RXIQI),
+		rtw_read32(rtwdev, REG_RXIQK_MATRIX_LSB_11N));
+	rtw_dbg(rtwdev, RTW_DBG_RFK,
+		"[IQK]0xcd0 = 0x%x 0xcd4 = 0x%x 0xcd8 = 0x%x\n",
+	rtw_read32(rtwdev, REG_TXIQ_AB_S0),
+		rtw_read32(rtwdev, REG_TXIQ_CD_S0),
+		rtw_read32(rtwdev, REG_RXIQ_AB_S0));
+
+	rtw_dbg(rtwdev, RTW_DBG_RFK, "[IQK] finished\n");
+
+	rtw8723b_inform_rfk_status(rtwdev, false);
+}
+
+static void rtw8723b_pwrtrack_set_ofdm_pwr(struct rtw_dev *rtwdev, s8 swing_idx,
+					   s8 txagc_idx)
+{
+	struct rtw_dm_info *dm_info = &rtwdev->dm_info;
+
+	dm_info->txagc_remnant_ofdm[RF_PATH_A] = txagc_idx;
+
+	rtw8723b_set_iqk_matrix(rtwdev, swing_idx, RF_PATH_A);
+}
+
+static void rtw8723b_pwrtrack_set_cck_pwr(struct rtw_dev *rtwdev, s8 swing_idx,
+					  s8 txagc_idx)
+{
+	struct rtw_dm_info *dm_info = &rtwdev->dm_info;
+
+	dm_info->txagc_remnant_cck = txagc_idx;
+
+	swing_idx = clamp_t(s8, swing_idx, 0, RTW_CCK_SWING_TABLE_SIZE - 1);
+
+	BUILD_BUG_ON(ARRAY_SIZE(rtw8723b_cck_pwr_regs) !=
+		     ARRAY_SIZE(rtw8732b_cck_swing_table_ch1_ch13[0]));
+
+	/*
+	 * Only the ch1-13 CCK swing table is wired up. Channel 14 needs its
+	 * own table but is Japan-only and not reachable here.
+	 */
+	for (int i = 0; i < ARRAY_SIZE(rtw8723b_cck_pwr_regs); i++)
+		rtw_write8(rtwdev, rtw8723b_cck_pwr_regs[i],
+			   rtw8732b_cck_swing_table_ch1_ch13[swing_idx][i]);
+}
+
+static void rtw8723b_pwrtrack_set(struct rtw_dev *rtwdev, u8 path)
+{
+	struct rtw_dm_info *dm_info = &rtwdev->dm_info;
+	struct rtw_hal *hal = &rtwdev->hal;
+	u8 limit_ofdm;
+	/* 8703b and 8723d seem to use RTW_CCK_SWING_TABLE_SIZE */
+	u8 limit_cck = 28; /* -2dB */
+	s8 final_ofdm_swing_index;
+	s8 final_cck_swing_index;
+
+	limit_ofdm = rtw8723x_pwrtrack_get_limit_ofdm(rtwdev);
+
+	final_ofdm_swing_index = dm_info->default_ofdm_index +
+				 dm_info->delta_power_index[path];
+	final_cck_swing_index = dm_info->default_cck_index +
+				dm_info->delta_power_index[path];
+
+	if (final_ofdm_swing_index > limit_ofdm)
+		rtw8723b_pwrtrack_set_ofdm_pwr(rtwdev, limit_ofdm,
+					       final_ofdm_swing_index - limit_ofdm);
+	else if (final_ofdm_swing_index < 0)
+		rtw8723b_pwrtrack_set_ofdm_pwr(rtwdev, 0,
+					       final_ofdm_swing_index);
+	else
+		rtw8723b_pwrtrack_set_ofdm_pwr(rtwdev, final_ofdm_swing_index, 0);
+
+	if (final_cck_swing_index > limit_cck)
+		rtw8723b_pwrtrack_set_cck_pwr(rtwdev, limit_cck,
+					      final_cck_swing_index - limit_cck);
+	else if (final_cck_swing_index < 0)
+		rtw8723b_pwrtrack_set_cck_pwr(rtwdev, 0,
+					      final_cck_swing_index);
+	else
+		rtw8723b_pwrtrack_set_cck_pwr(rtwdev, final_cck_swing_index, 0);
+
+	rtw_phy_set_tx_power_level(rtwdev, hal->current_channel);
+}
+
+static void rtw8723b_phy_pwrtrack(struct rtw_dev *rtwdev)
+{
+	struct rtw_dm_info *dm_info = &rtwdev->dm_info;
+	struct rtw_swing_table swing_table;
+	u8 thermal_value, delta, path;
+	bool do_iqk = false;
+
+	rtw_phy_config_swing_table(rtwdev, &swing_table);
+
+	if (rtwdev->efuse.thermal_meter[0] == 0xff)
+		return;
+
+	thermal_value = rtw_read_rf(rtwdev, RF_PATH_A, RF_T_METER, 0xfc00);
+
+	/* Average the thermal meter readings. */
+	rtw_phy_pwrtrack_avg(rtwdev, thermal_value, RF_PATH_A);
+
+	do_iqk = rtw_phy_pwrtrack_need_iqk(rtwdev);
+
+	/*
+	 * matches rtw8723d power tracking: LCK via the common helper on the
+	 * IQK trigger, then the IQK itself below
+	 */
+	if (do_iqk)
+		rtw8723x_lck(rtwdev);
+
+	if (dm_info->pwr_trk_init_trigger)
+		dm_info->pwr_trk_init_trigger = false;
+	else if (!rtw_phy_pwrtrack_thermal_changed(rtwdev, thermal_value,
+						   RF_PATH_A))
+		goto iqk;
+
+	delta = rtw_phy_pwrtrack_get_delta(rtwdev, RF_PATH_A);
+
+	/* NOTE: also done in rtw_phy_pwrtrack_get_delta */
+	delta = min_t(u8, delta, RTW_PWR_TRK_TBL_SZ - 1);
+
+	for (path = 0; path < rtwdev->hal.rf_path_num; path++) {
+		s8 delta_cur, delta_last;
+
+		delta_last = dm_info->delta_power_index[path];
+		delta_cur = rtw_phy_pwrtrack_get_pwridx(rtwdev, &swing_table,
+							path, RF_PATH_A, delta);
+		if (delta_last == delta_cur)
+			continue;
+
+		dm_info->delta_power_index[path] = delta_cur;
+		rtw8723b_pwrtrack_set(rtwdev, path);
+	}
+
+iqk:
+	if (do_iqk)
+		rtw8723b_phy_calibration(rtwdev);
+}
+
+static void rtw8723b_pwr_track(struct rtw_dev *rtwdev)
+{
+	struct rtw_efuse *efuse = &rtwdev->efuse;
+	struct rtw_dm_info *dm_info = &rtwdev->dm_info;
+
+	if (efuse->power_track_type != 0) {
+		rtw_warn(rtwdev, "unsupported power track type");
+		return;
+	}
+
+	if (!dm_info->pwr_trk_triggered) {
+		rtw_write_rf(rtwdev, RF_PATH_A, RF_T_METER,
+			     GENMASK(17, 16), 0x03);
+		dm_info->pwr_trk_triggered = true;
+		return;
+	}
+
+	rtw8723b_phy_pwrtrack(rtwdev);
+	dm_info->pwr_trk_triggered = false;
+}
+
+static void rtw8723b_coex_cfg_init(struct rtw_dev *rtwdev)
+{
+	/* enable TBTT nterrupt */
+	rtw_write8_mask(rtwdev, 0x550, 0x8, 0x1);
+
+	/* 0x790[5:0]= 0x5 */
+	rtw_write8(rtwdev, 0x790, 0x5);
+
+	/* enable counter statistics */
+	rtw_write8(rtwdev, 0x778, 0x1);
+	rtw_write8_mask(rtwdev, 0x40, 0x20, 0x1);
+}
+
+static void rtw8723b_coex_set_gnt_fix(struct rtw_dev *rtwdev)
+{
+	/* intentionally empty: rtw8723d's coex_set_gnt_fix is empty too */
+}
+
+static void rtw8723b_coex_set_gnt_debug(struct rtw_dev *rtwdev)
+{
+	/*
+	 * Not implemented: rtw8723d routes GNT_BT to debug GPIOs here
+	 * (REG_LEDCFG2/REG_PAD_CTRL1/REG_GPIO_*).  That is coex debug
+	 * instrumentation only and is not needed for normal operation.
+	 */
+}
+
+static bool rtw8723b_coex_ant_is_aux(struct rtw_dev *rtwdev)
+{
+	return !!(rtwdev->efuse.bt_setting & BIT(6));
+}
+
+static void rtw8723b_coex_write8_verify(struct rtw_dev *rtwdev, u32 addr,
+					u8 value)
+{
+	u8 readback;
+
+	rtw_write8(rtwdev, addr, value);
+	readback = rtw_read8(rtwdev, addr);
+	if (readback == value)
+		return;
+
+	usleep_range(10, 11);
+	rtw_write8(rtwdev, addr, value);
+}
+
+static void rtw8723b_coex_set_ant_ctrl_by_wifi(struct rtw_dev *rtwdev)
+{
+	/* 0x4c[23] = 1, 0x4c[24] = 0: antenna control by 0x64. */
+	rtw_write32_clr(rtwdev, REG_LED_CFG, BIT(24));
+	rtw_write32_set(rtwdev, REG_LED_CFG, BIT(23));
+}
+
+static void rtw8723b_coex_set_ant_ctrl_by_bt(struct rtw_dev *rtwdev)
+{
+	/* 0x4c[24:23] = 0: antenna control by BT_RFE_CTRL. */
+	rtw_write32_clr(rtwdev, REG_LED_CFG, BIT(23) | BIT(24));
+}
+
+static void rtw8723b_coex_cfg_ant_buffer(struct rtw_dev *rtwdev)
+{
+	u8 sys_func_before;
+
+	sys_func_before = rtw_read8(rtwdev, REG_SYS_FUNC_EN);
+	if ((sys_func_before & WLAN_SYS_FUNC_BB_ENABLE) !=
+	    WLAN_SYS_FUNC_BB_ENABLE) {
+		rtw_write8_set(rtwdev, REG_SYS_FUNC_EN,
+			       WLAN_SYS_FUNC_BB_ENABLE);
+		usleep_range(10, 11);
+	}
+
+	rtw_write8_set(rtwdev, REG_BT_COEX_CTRL_8723B, BIT(3));
+	rtw8723b_coex_write8_verify(rtwdev, REG_RFE_CTRL_E, 0xff);
+	rtw_write8_mask(rtwdev, REG_BB_ANT_CFG1_8723B, 0x3, 0x3);
+	rtw_write8(rtwdev, REG_BB_ANT_CFG_8723B, 0x77);
+}
+
+static u32 rtw8723b_coex_write_bb_sel_btg(struct rtw_dev *rtwdev, u32 value)
+{
+	u8 sys_func_before;
+	u32 readback;
+
+	if (rtw_hci_type(rtwdev) != RTW_HCI_TYPE_SDIO) {
+		rtw_write32(rtwdev, REG_BB_SEL_BTG, value);
+		return rtw_read32(rtwdev, REG_BB_SEL_BTG);
+	}
+
+	sys_func_before = rtw_read8(rtwdev, REG_SYS_FUNC_EN);
+	if ((sys_func_before & WLAN_SYS_FUNC_BB_ENABLE) !=
+	    WLAN_SYS_FUNC_BB_ENABLE) {
+		rtw_write8_set(rtwdev, REG_SYS_FUNC_EN,
+			       WLAN_SYS_FUNC_BB_ENABLE);
+		usleep_range(10, 11);
+	}
+
+	rtw_write32(rtwdev, REG_BB_SEL_BTG, value);
+	readback = rtw_read32(rtwdev, REG_BB_SEL_BTG);
+	if (readback == value)
+		return readback;
+
+	rtw_write8_set(rtwdev, REG_SYS_FUNC_EN, WLAN_SYS_FUNC_BB_ENABLE);
+	usleep_range(10, 11);
+	rtw_write32(rtwdev, REG_BB_SEL_BTG, value);
+
+	return rtw_read32(rtwdev, REG_BB_SEL_BTG);
+}
+
+static u32 rtw8723b_coex_ant_path_value(struct rtw_dev *rtwdev, u8 pos_type)
+{
+	bool aux = rtw8723b_coex_ant_is_aux(rtwdev);
+
+	switch (pos_type) {
+	case COEX_SWITCH_TO_BT:
+		return aux ? 0x0 : 0x280;
+	case COEX_SWITCH_TO_WLG:
+	case COEX_SWITCH_TO_WLA:
+		return aux ? 0x280 : 0x0;
+	case COEX_SWITCH_TO_WLG_BT:
+	case COEX_SWITCH_TO_NOCARE:
+	default:
+		return aux ? 0x80 : 0x200;
+	}
+}
+
+static void rtw8723b_coex_cfg_ant_switch(struct rtw_dev *rtwdev,
+					 u8 ctrl_type, u8 pos_type)
+{
+	u32 ant_path;
+
+	if (rtw_hci_type(rtwdev) != RTW_HCI_TYPE_SDIO)
+		return;
+
+	if (ctrl_type == COEX_SWITCH_CTRL_BY_BT) {
+		rtw_write8(rtwdev, REG_GNT_BT, 0x18);
+		rtw_write8(rtwdev, REG_BT_COEX_ENH_INTR_CTRL, 0x4);
+		rtw_write8_clr(rtwdev, REG_BT_ANT_SEL_8723B,
+			       BIT_BT_SEL_BY_WIFI_8723B);
+		rtw8723b_coex_set_ant_ctrl_by_bt(rtwdev);
+		ant_path = rtw8723b_coex_ant_path_value(rtwdev,
+							COEX_SWITCH_TO_BT);
+		rtw8723b_coex_write_bb_sel_btg(rtwdev, ant_path);
+
+		rtw_dbg(rtwdev, RTW_DBG_COEX,
+			"[BTCoex], 8723bs ant switch by BT BB_SEL_BTG=0x%08x 0x4c=0x%08x 0x67=0x%02x 0x765=0x%02x 0x76e=0x%02x\n",
+			rtw_read32(rtwdev, REG_BB_SEL_BTG),
+			rtw_read32(rtwdev, REG_LED_CFG),
+			rtw_read8(rtwdev, REG_BT_ANT_SEL_8723B),
+			rtw_read8(rtwdev, REG_GNT_BT),
+			rtw_read8(rtwdev, REG_BT_COEX_ENH_INTR_CTRL));
+		return;
+	}
+
+	rtw8723b_coex_set_ant_ctrl_by_wifi(rtwdev);
+	rtw_write8(rtwdev, REG_BT_ANT_SEL_8723B, 0x20);
+
+	if (ctrl_type == COEX_SWITCH_CTRL_BY_BBSW &&
+	    pos_type == COEX_SWITCH_TO_BT) {
+		rtw_write8(rtwdev, REG_GNT_BT, 0x18);
+		rtw_write8(rtwdev, REG_BT_COEX_ENH_INTR_CTRL, 0x4);
+	} else {
+		if (rtw_read8(rtwdev, REG_GNT_BT) != 0)
+			rtw_write8(rtwdev, REG_GNT_BT, 0x0);
+
+		if (rtw_read8(rtwdev, REG_BT_COEX_ENH_INTR_CTRL) != 0xc)
+			rtw_write8(rtwdev, REG_BT_COEX_ENH_INTR_CTRL, 0xc);
+	}
+
+	if (ctrl_type == COEX_SWITCH_CTRL_BY_BBSW)
+		ant_path = rtw8723b_coex_ant_path_value(rtwdev, pos_type);
+	else
+		ant_path = rtw8723b_coex_ant_path_value(rtwdev,
+							COEX_SWITCH_TO_NOCARE);
+
+	rtw8723b_coex_write_bb_sel_btg(rtwdev, ant_path);
+	rtw8723b_sdio_restore_pad_ctrl(rtwdev,
+				       ctrl_type == COEX_SWITCH_CTRL_BY_PTA);
+
+	rtw_dbg(rtwdev, RTW_DBG_COEX,
+		"[BTCoex], 8723bs ant switch ctrl=%u pos=%u BB_SEL_BTG=0x%08x 0x4c=0x%08x 0x67=0x%02x 0x765=0x%02x 0x76e=0x%02x\n",
+		ctrl_type, pos_type, rtw_read32(rtwdev, REG_BB_SEL_BTG),
+		rtw_read32(rtwdev, REG_LED_CFG),
+		rtw_read8(rtwdev, REG_BT_ANT_SEL_8723B),
+		rtw_read8(rtwdev, REG_GNT_BT),
+		rtw_read8(rtwdev, REG_BT_COEX_ENH_INTR_CTRL));
+}
+
+static void rtw8723b_coex_set_rfe_type(struct rtw_dev *rtwdev)
+{
+	struct rtw_coex *coex = &rtwdev->coex;
+	struct rtw_coex_rfe *coex_rfe = &coex->rfe;
+	enum rtw_hci_type hci_type = rtw_hci_type(rtwdev);
+	bool aux = rtw8723b_coex_ant_is_aux(rtwdev);
+	u32 reg;
+
+	coex_rfe->rfe_module_type = rtwdev->efuse.rfe_option;
+	coex_rfe->ant_switch_polarity = aux ? 1 : 0;
+	coex_rfe->ant_switch_exist = hci_type == RTW_HCI_TYPE_SDIO;
+	coex_rfe->ant_switch_with_bt = false;
+	coex_rfe->ant_switch_diversity = false;
+	coex_rfe->wlg_at_btg = true;
+
+	rtw_write8(rtwdev, REG_BT_ANT_SEL_8723B, 0x20);
+
+	/* set GRAN_BT = 1 */
+	rtw_write8(rtwdev, REG_GNT_BT, 0x18);
+
+	/* set WLAN_ACT = 0 */
+	rtw_write8(rtwdev, REG_BT_COEX_ENH_INTR_CTRL, 0x4);
+
+	switch (hci_type) {
+	case RTW_HCI_TYPE_USB:
+		rtw8723b_coex_write_bb_sel_btg(rtwdev, 0x0);
+		rtw_write8(rtwdev, 0xfe08, 0x1); /* antenna inverse */
+		break;
+	case RTW_HCI_TYPE_PCIE:
+		reg = 0x384;
+		/*
+		 * efuse 0xc3[6] == 0, S1(Main), RF_PATH_A
+		 * efuse 0xc3[6] == 1, S0(Aux), RF_PATH_B
+		 */
+		if (aux) {
+			rtw8723b_coex_write_bb_sel_btg(rtwdev, 0x0);
+			rtw_write8(rtwdev, reg, 0x1);
+		} else {
+			rtw8723b_coex_write_bb_sel_btg(rtwdev, 0x280);
+			rtw_write8(rtwdev, reg, 0x0);
+		}
+		break;
+	case RTW_HCI_TYPE_SDIO:
+		/*
+		 * Internal antenna switch: keep WiFi TRx enabled, let WiFi
+		 * drive S0/S1, and program the firmware antenna-inverse hint.
+		 */
+		rtw_write_rf(rtwdev, RF_PATH_A, RF_WLINT, RFREG_MASK, 0x0780);
+
+		rtw_write8(rtwdev, REG_BT_ANT_SEL_8723B, 0x20);
+		rtw_write8(rtwdev, REG_GNT_BT, 0x18);
+		rtw_write8(rtwdev, REG_BT_COEX_ENH_INTR_CTRL, 0x4);
+
+		if (aux) {
+			rtw8723b_coex_write_bb_sel_btg(rtwdev, 0x0);
+			rtw_write8(rtwdev, REG_SDIO_H2C, 0x1);
+		} else {
+			rtw8723b_coex_write_bb_sel_btg(rtwdev, 0x280);
+			rtw_write8(rtwdev, REG_SDIO_H2C, 0x0);
+		}
+
+		rtw8723b_coex_set_ant_ctrl_by_wifi(rtwdev);
+		rtw_write8_mask(rtwdev, REG_PAD_CTRL1,
+				BIT_SW_DPDT_SEL_DATA, 0x0);
+		rtw8723b_coex_cfg_ant_buffer(rtwdev);
+		rtw8723b_sdio_restore_pad_ctrl(rtwdev, false);
+
+		/*
+		 * COEX_ANT_SEL_RSV is sent later from rtw_power_on(). The
+		 * register writes above stay here so the RFE and antenna
+		 * hardware are initialised before IQK.
+		 */
+		break;
+	default:
+		break;
+	}
+}
+
+static void rtw8723b_coex_set_wl_tx_power(struct rtw_dev *rtwdev, u8 wl_pwr)
+{
+	/*
+	 * Not implemented: rtw8723d adjusts WL Tx power (0xb2/0x90) when BT is
+	 * active.  Coexistence quality only, not needed for basic operation;
+	 * deferred like coex_set_wl_rx_gain.
+	 */
+}
+
+static void rtw8723b_coex_set_wl_rx_gain(struct rtw_dev *rtwdev, bool low_gain)
+{
+	/*
+	 * Not implemented: rtw8723d lowers the WL Rx AGC via gain tables when
+	 * BT is active.  This only affects WiFi/BT coexistence quality under
+	 * concurrent BT traffic, not basic operation; deferred.
+	 */
+}
+
+static void rtw8723b_cfg_ldo25(struct rtw_dev *rtwdev, bool enable)
+{
+	/*
+	 * Intentionally empty: the 2.5V efuse LDO is only needed when writing
+	 * the efuse, and rtw88 only ever reads it.
+	 */
+}
+
+static void rtw8723b_fill_txdesc_checksum(struct rtw_dev *rtwdev,
+					  struct rtw_tx_pkt_info *pkt_info,
+					  u8 *txdesc)
+{
+	struct rtw_tx_desc *tx_desc = (struct rtw_tx_desc *)txdesc;
+	const u8 *data = txdesc;
+	u16 checksum = 0;
+	int words = 32 / 2;
+
+	/*
+	 * Unlike the shared 8723x helper, the 8723B does not invert the XOR
+	 * checksum over the first 16 half-words of the TX descriptor.
+	 */
+	le32p_replace_bits(&tx_desc->w7, 0, RTW_TX_DESC_W7_TXDESC_CHECKSUM);
+
+	while (words--) {
+		checksum ^= get_unaligned_le16(data);
+		data += sizeof(__le16);
+	}
+
+	le32p_replace_bits(&tx_desc->w7, checksum,
+			   RTW_TX_DESC_W7_TXDESC_CHECKSUM);
+}
+
+static const struct rtw_chip_ops rtw8723b_ops = {
+	.power_on		= rtw_power_on,
+	.power_off		= rtw_power_off,
+
+	.mac_init		= rtw8723b_mac_init,
+	.mac_postinit		= rtw8723x_mac_postinit,
+
+	.dump_fw_crash		= NULL,
+	/*
+	 * 8723d sets REG_HCI_OPT_CTRL to BIT_USB_SUS_DIS in
+	 * its shutdown fubction, not needed for SDIO devices.
+	 */
+	.shutdown		= NULL,
+	.read_efuse		= rtw8723x_read_efuse,
+	.phy_set_param		= rtw8723b_phy_set_param,
+
+	.set_channel		= rtw8723b_set_channel,
+
+	.query_phy_status	= rtw8723b_query_phy_status,
+	.read_rf		= rtw_phy_read_rf_sipi,
+	.write_rf		= rtw_phy_write_rf_reg_sipi,
+	.set_tx_power_index	= rtw8723x_set_tx_power_index,
+	.rsvd_page_dump		= NULL,
+	.set_antenna		= NULL,
+	.cfg_ldo25		= rtw8723b_cfg_ldo25,
+	.efuse_grant		= rtw8723b_efuse_grant,
+	.set_ampdu_factor	= NULL,
+	.false_alarm_statistics	= rtw8723x_false_alarm_statistics,
+	.phy_calibration	= rtw8723b_phy_calibration,
+	.dpk_track		= NULL,
+	/*
+	 * REG_CSRATIO does not exist on this chip generation, so there is
+	 * nothing to read back for cck_pd_set. rtw8703b leaves this NULL too.
+	 */
+	.cck_pd_set		= NULL,
+	.pwr_track		= rtw8723b_pwr_track,
+	.config_bfee		= NULL,
+	.set_gid_table		= NULL,
+	.cfg_csi_rate		= NULL,
+	.adaptivity_init	= NULL,
+	.adaptivity		= NULL,
+	.cfo_init		= NULL,
+	.cfo_track		= NULL,
+	.config_tx_path		= NULL,
+	.config_txrx_mode	= NULL,
+	.led_set		= NULL,
+	.fill_txdesc_checksum	= rtw8723b_fill_txdesc_checksum,
+
+	.coex_set_init		= rtw8723b_coex_cfg_init,
+	.coex_set_ant_switch	= rtw8723b_coex_cfg_ant_switch,
+	.coex_set_gnt_fix	= rtw8723b_coex_set_gnt_fix,
+	.coex_set_gnt_debug	= rtw8723b_coex_set_gnt_debug,
+	.coex_set_rfe_type	= rtw8723b_coex_set_rfe_type,
+	.coex_set_wl_tx_power	= rtw8723b_coex_set_wl_tx_power,
+	.coex_set_wl_rx_gain	= rtw8723b_coex_set_wl_rx_gain,
+};
+
+const struct rtw_chip_info rtw8723b_hw_spec = {
+	.ops = &rtw8723b_ops,
+	.id = RTW_CHIP_TYPE_8723B,
+	.fw_name = "rtw88/rtw8723b_fw.bin",
+	.wlan_cpu = RTW_WCPU_8051,
+	.tx_pkt_desc_sz = 40,
+	.tx_buf_desc_sz = 16,
+	.rx_pkt_desc_sz = 24,
+	.rx_buf_desc_sz = 8,
+	.phy_efuse_size = 512,
+	.log_efuse_size = 512,
+	.ptct_efuse_size = 15,
+
+	.txff_size = 32768,
+	.rxff_size = 16384,
+	.rsvd_drv_pg_num = 8,
+
+	.txgi_factor = 1,
+	.is_pwr_by_rate_dec = true,
+	.rx_ldpc = false,
+	.tx_stbc = false,
+
+	.max_power_index = 0x3f,
+
+	.csi_buf_pg_num = 0,
+	.band = RTW_BAND_2G,
+	.page_size = TX_PAGE_SIZE,
+
+	.dig_min = 0x20,
+	.usb_tx_agg_desc_num = 1,
+
+	/*
+	 * The firmware reports id 0xfd instead of C2H_HW_FEATURE_REPORT, so
+	 * the hardware feature report is not supported on this chip.
+	 */
+	.hw_feature_report = false,
+
+	.c2h_ra_report_size = 4,	/* rtw88/rtw8723b_fw.bin v41 emits the
+					 * legacy 8051 4-byte rate report
+					 * (rate_sgi, mac_id, byte2, status).
+					 * Setting this to 7 — like the upstream
+					 * default — caused every C2H_RA_REPORT
+					 * to be dropped with
+					 * "short ra report c2h length 4
+					 * expected 7" on every connect attempt
+					 * so the firmware-driven rate adaptation
+					 * feedback path
+					 * never updated si->ra_report. The
+					 * legacy 8051 8723b/8703b/8723d firmware
+					 * uses the same 4-byte format as the
+					 * older 8821a/8812a chips. byte4..bw fall
+					 * back to the per-station defaults in
+					 * rtw_fw_ra_report_iter(), which matches
+					 * what those chips already do safely.
+					 */
+	.old_datarate_fb_limit = true,	/* likely true; see main-line commit c7706b1 */
+
+	.path_div_supported = false,
+	.ht_supported = true,
+	.vht_supported = false,
+	.lps_deep_mode_supported = 0,
+
+	.sys_func_en = 0xfd,
+	.pwr_on_seq = card_enable_flow_8723b,
+	.pwr_off_seq = card_disable_flow_8723b,
+	.page_table = page_table_8723b,
+
+	.rqpn_table = rqpn_table_8723b,
+	/* same shared table as the sibling rtw8703b and rtw8723d */
+	.prioq_addrs = &rtw8723x_common.prioq_addrs,
+
+	/* used only in pci.c, not needed for SDIO devices */
+	.intf_table = NULL,
+
+	.dig = rtw8723x_common.dig,
+	.dig_cck = rtw8723x_common.dig_cck,
+
+	.rf_sipi_addr = {0x840, 0x844},
+	.rf_sipi_read_addr = rtw8723x_common.rf_sipi_addr,
+
+	.fix_rf_phy_num = 2,
+
+	/* This chip has no LTE coex registers. */
+	.ltecoex_addr = NULL,
+
+	.mac_tbl = &rtw8723b_mac_tbl,
+	.agc_tbl = &rtw8723b_agc_tbl,
+	.bb_tbl = &rtw8723b_bb_tbl,
+	.rf_tbl = {&rtw8723b_rf_a_tbl},
+
+	.rfe_defs = rtw8723b_rfe_defs,
+	.rfe_defs_size = ARRAY_SIZE(rtw8723b_rfe_defs),
+	.iqk_threshold = 8,
+	.ampdu_density = IEEE80211_HT_MPDU_DENSITY_16,
+	.max_scan_ie_len = IEEE80211_MAX_DATA_LEN,
+
+	.coex_para_ver = 20180201,
+	.bt_desired_ver = 0x6d,
+	.scbd_support = false,
+	.new_scbd10_def = true,
+	.ble_hid_profile_support = false,
+	.wl_mimo_ps_support = false,
+	.pstdma_type = COEX_PSTDMA_FORCE_LPSOFF,
+	.bt_rssi_type = COEX_BTRSSI_RATIO,
+	.ant_isolation = 15,
+	.rssi_tolerance = 2,
+	.wl_rssi_step = wl_rssi_step_8723b,
+	.bt_rssi_step = bt_rssi_step_8723b,
+	.table_sant_num = ARRAY_SIZE(table_sant_8723b),
+	.table_sant = table_sant_8723b,
+	.table_nsant_num = ARRAY_SIZE(table_nsant_8723b),
+	.table_nsant = table_nsant_8723b,
+	.tdma_sant_num = ARRAY_SIZE(tdma_sant_8723b),
+	.tdma_sant = tdma_sant_8723b,
+	.tdma_nsant_num = ARRAY_SIZE(tdma_nsant_8723b),
+	.tdma_nsant = tdma_nsant_8723b,
+	.wl_rf_para_num = ARRAY_SIZE(rf_para_tx_8723b),
+	.wl_rf_para_tx = rf_para_tx_8723b,
+	.wl_rf_para_rx = rf_para_rx_8723b,
+	.bt_afh_span_bw20 = 0x20,
+	.bt_afh_span_bw40 = 0x30,
+	.afh_5g_num =  ARRAY_SIZE(afh_5g_8723b),
+	.afh_5g = afh_5g_8723b,
+	/* BTG_SEL is driven by the cardemu_to_act power sequence instead. */
+	.btg_reg = NULL,
+
+	/*
+	 * These registers are used to read (and print) from if
+	 * CONFIG_RTW88_DEBUGFS is enabled.
+	 */
+	.coex_info_hw_regs_num = 0,
+	.coex_info_hw_regs = NULL,
+};
+EXPORT_SYMBOL(rtw8723b_hw_spec);
+
+MODULE_FIRMWARE("rtw88/rtw8723b_fw.bin");
+
+MODULE_AUTHOR("Luka Gejak <luka.gejak@linux.dev>");
+MODULE_AUTHOR("Michael Straube <straube.linux@gmail.com>");
+MODULE_DESCRIPTION("Realtek 802.11n wireless 8723b driver");
+MODULE_LICENSE("Dual BSD/GPL");
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8723b.h b/drivers/net/wireless/realtek/rtw88/rtw8723b.h
new file mode 100644
index 000000000000..2880d41e4b01
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtw88/rtw8723b.h
@@ -0,0 +1,16 @@
+/* SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause */
+/* Copyright(c) 2018-2019  Realtek Corporation
+ */
+
+#ifndef __RTW8723B_H__
+#define __RTW8723B_H__
+
+#include "rtw8723x.h"
+
+extern const struct rtw_chip_info rtw8723b_hw_spec;
+
+/* shared with rtw8703b.c; could move to rtw8723x.h */
+#define REG_TXIQK_MATRIXB_LSB2_11N 0x0c9c
+#define REG_BB_PWR_SAV5_11N 0x0818
+
+#endif
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8723b_table.c b/drivers/net/wireless/realtek/rtw88/rtw8723b_table.c
new file mode 100644
index 000000000000..49989da3b8aa
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtw88/rtw8723b_table.c
@@ -0,0 +1,862 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+/*
+ * Copyright(c) 2007-2017  Realtek Corporation
+ * Copyright(c) Michael Straube <straube.linux@gmail.com>
+ * Copyright(c) 2024-2026 Luka Gejak <luka.gejak@linux.dev>
+ */
+
+#include "main.h"
+#include "phy.h"
+#include "rtw8723b_table.h"
+
+static const u32 rtw8723b_mac[] = {
+	0x02F, 0x00000030,
+	0x035, 0x00000000,
+	0x039, 0x00000008,
+	0x064, 0x00000000,
+	0x067, 0x00000020,
+	0x421, 0x0000000F,
+	0x428, 0x0000000A,
+	0x429, 0x00000010,
+	0x430, 0x00000000,
+	0x431, 0x00000000,
+	0x432, 0x00000000,
+	0x433, 0x00000001,
+	0x434, 0x00000004,
+	0x435, 0x00000005,
+	0x436, 0x00000007,
+	0x437, 0x00000008,
+	0x43C, 0x00000004,
+	0x43D, 0x00000005,
+	0x43E, 0x00000007,
+	0x43F, 0x00000008,
+	0x440, 0x0000005D,
+	0x441, 0x00000001,
+	0x442, 0x00000000,
+	0x444, 0x00000010,
+	0x445, 0x00000000,
+	0x446, 0x00000000,
+	0x447, 0x00000000,
+	0x448, 0x00000000,
+	0x449, 0x000000F0,
+	0x44A, 0x0000000F,
+	0x44B, 0x0000003E,
+	0x44C, 0x00000010,
+	0x44D, 0x00000000,
+	0x44E, 0x00000000,
+	0x44F, 0x00000000,
+	0x450, 0x00000000,
+	0x451, 0x000000F0,
+	0x452, 0x0000000F,
+	0x453, 0x00000000,
+	0x456, 0x0000005E,
+	0x460, 0x00000066,
+	0x461, 0x00000066,
+	0x4C8, 0x000000FF,
+	0x4C9, 0x00000008,
+	0x4CC, 0x000000FF,
+	0x4CD, 0x000000FF,
+	0x4CE, 0x00000001,
+	0x500, 0x00000026,
+	0x501, 0x000000A2,
+	0x502, 0x0000002F,
+	0x503, 0x00000000,
+	0x504, 0x00000028,
+	0x505, 0x000000A3,
+	0x506, 0x0000005E,
+	0x507, 0x00000000,
+	0x508, 0x0000002B,
+	0x509, 0x000000A4,
+	0x50A, 0x0000005E,
+	0x50B, 0x00000000,
+	0x50C, 0x0000004F,
+	0x50D, 0x000000A4,
+	0x50E, 0x00000000,
+	0x50F, 0x00000000,
+	0x512, 0x0000001C,
+	0x514, 0x0000000A,
+	0x516, 0x0000000A,
+	0x525, 0x0000004F,
+	0x550, 0x00000010,
+	0x551, 0x00000010,
+	0x559, 0x00000002,
+	0x55C, 0x00000050,
+	0x55D, 0x000000FF,
+	0x605, 0x00000030,
+	0x608, 0x0000000E,
+	0x609, 0x0000002A,
+	0x620, 0x000000FF,
+	0x621, 0x000000FF,
+	0x622, 0x000000FF,
+	0x623, 0x000000FF,
+	0x624, 0x000000FF,
+	0x625, 0x000000FF,
+	0x626, 0x000000FF,
+	0x627, 0x000000FF,
+	0x638, 0x00000050,
+	0x63C, 0x0000000A,
+	0x63D, 0x0000000A,
+	0x63E, 0x0000000E,
+	0x63F, 0x0000000E,
+	0x640, 0x00000040,
+	0x642, 0x00000040,
+	0x643, 0x00000000,
+	0x652, 0x000000C8,
+	0x66E, 0x00000005,
+	0x700, 0x00000021,
+	0x701, 0x00000043,
+	0x702, 0x00000065,
+	0x703, 0x00000087,
+	0x708, 0x00000021,
+	0x709, 0x00000043,
+	0x70A, 0x00000065,
+	0x70B, 0x00000087,
+	0x765, 0x00000018,
+	0x76E, 0x00000004,
+};
+
+RTW_DECL_TABLE_PHY_COND(rtw8723b_mac, rtw_phy_cfg_mac);
+
+static const u32 rtw8723b_agc[] = {
+	0xC78, 0xFD000001,
+	0xC78, 0xFC010001,
+	0xC78, 0xFB020001,
+	0xC78, 0xFA030001,
+	0xC78, 0xF9040001,
+	0xC78, 0xF8050001,
+	0xC78, 0xF7060001,
+	0xC78, 0xF6070001,
+	0xC78, 0xF5080001,
+	0xC78, 0xF4090001,
+	0xC78, 0xF30A0001,
+	0xC78, 0xF20B0001,
+	0xC78, 0xF10C0001,
+	0xC78, 0xF00D0001,
+	0xC78, 0xEF0E0001,
+	0xC78, 0xEE0F0001,
+	0xC78, 0xED100001,
+	0xC78, 0xEC110001,
+	0xC78, 0xEB120001,
+	0xC78, 0xEA130001,
+	0xC78, 0xE9140001,
+	0xC78, 0xE8150001,
+	0xC78, 0xE7160001,
+	0xC78, 0xE6170001,
+	0xC78, 0xE5180001,
+	0xC78, 0xE4190001,
+	0xC78, 0xE31A0001,
+	0xC78, 0xA51B0001,
+	0xC78, 0xA41C0001,
+	0xC78, 0xA31D0001,
+	0xC78, 0x671E0001,
+	0xC78, 0x661F0001,
+	0xC78, 0x65200001,
+	0xC78, 0x64210001,
+	0xC78, 0x63220001,
+	0xC78, 0x4A230001,
+	0xC78, 0x49240001,
+	0xC78, 0x48250001,
+	0xC78, 0x47260001,
+	0xC78, 0x46270001,
+	0xC78, 0x45280001,
+	0xC78, 0x44290001,
+	0xC78, 0x432A0001,
+	0xC78, 0x422B0001,
+	0xC78, 0x292C0001,
+	0xC78, 0x282D0001,
+	0xC78, 0x272E0001,
+	0xC78, 0x262F0001,
+	0xC78, 0x0A300001,
+	0xC78, 0x09310001,
+	0xC78, 0x08320001,
+	0xC78, 0x07330001,
+	0xC78, 0x06340001,
+	0xC78, 0x05350001,
+	0xC78, 0x04360001,
+	0xC78, 0x03370001,
+	0xC78, 0x02380001,
+	0xC78, 0x01390001,
+	0xC78, 0x013A0001,
+	0xC78, 0x013B0001,
+	0xC78, 0x013C0001,
+	0xC78, 0x013D0001,
+	0xC78, 0x013E0001,
+	0xC78, 0x013F0001,
+	0xC78, 0xFC400001,
+	0xC78, 0xFB410001,
+	0xC78, 0xFA420001,
+	0xC78, 0xF9430001,
+	0xC78, 0xF8440001,
+	0xC78, 0xF7450001,
+	0xC78, 0xF6460001,
+	0xC78, 0xF5470001,
+	0xC78, 0xF4480001,
+	0xC78, 0xF3490001,
+	0xC78, 0xF24A0001,
+	0xC78, 0xF14B0001,
+	0xC78, 0xF04C0001,
+	0xC78, 0xEF4D0001,
+	0xC78, 0xEE4E0001,
+	0xC78, 0xED4F0001,
+	0xC78, 0xEC500001,
+	0xC78, 0xEB510001,
+	0xC78, 0xEA520001,
+	0xC78, 0xE9530001,
+	0xC78, 0xE8540001,
+	0xC78, 0xE7550001,
+	0xC78, 0xE6560001,
+	0xC78, 0xE5570001,
+	0xC78, 0xE4580001,
+	0xC78, 0xE3590001,
+	0xC78, 0xA65A0001,
+	0xC78, 0xA55B0001,
+	0xC78, 0xA45C0001,
+	0xC78, 0xA35D0001,
+	0xC78, 0x675E0001,
+	0xC78, 0x665F0001,
+	0xC78, 0x65600001,
+	0xC78, 0x64610001,
+	0xC78, 0x63620001,
+	0xC78, 0x62630001,
+	0xC78, 0x61640001,
+	0xC78, 0x48650001,
+	0xC78, 0x47660001,
+	0xC78, 0x46670001,
+	0xC78, 0x45680001,
+	0xC78, 0x44690001,
+	0xC78, 0x436A0001,
+	0xC78, 0x426B0001,
+	0xC78, 0x286C0001,
+	0xC78, 0x276D0001,
+	0xC78, 0x266E0001,
+	0xC78, 0x256F0001,
+	0xC78, 0x24700001,
+	0xC78, 0x09710001,
+	0xC78, 0x08720001,
+	0xC78, 0x07730001,
+	0xC78, 0x06740001,
+	0xC78, 0x05750001,
+	0xC78, 0x04760001,
+	0xC78, 0x03770001,
+	0xC78, 0x02780001,
+	0xC78, 0x01790001,
+	0xC78, 0x017A0001,
+	0xC78, 0x017B0001,
+	0xC78, 0x017C0001,
+	0xC78, 0x017D0001,
+	0xC78, 0x017E0001,
+	0xC78, 0x017F0001,
+	0xC50, 0x69553422,
+	0xC50, 0x69553420,
+	0x824, 0x00390204,
+};
+
+RTW_DECL_TABLE_PHY_COND(rtw8723b_agc, rtw_phy_cfg_agc);
+
+static const u32 rtw8723b_bb[] = {
+	0x800, 0x80040000,
+	0x804, 0x00000003,
+	0x808, 0x0000FC00,
+	0x80C, 0x0000000A,
+	0x810, 0x10001331,
+	0x814, 0x020C3D10,
+	0x818, 0x02200385,
+	0x81C, 0x00000000,
+	0x820, 0x01000100,
+	0x824, 0x00190204,
+	0x828, 0x00000000,
+	0x82C, 0x00000000,
+	0x830, 0x00000000,
+	0x834, 0x00000000,
+	0x838, 0x00000000,
+	0x83C, 0x00000000,
+	0x840, 0x00010000,
+	0x844, 0x00000000,
+	0x848, 0x00000000,
+	0x84C, 0x00000000,
+	0x850, 0x00000000,
+	0x854, 0x00000000,
+	0x858, 0x569A11A9,
+	0x85C, 0x01000014,
+	0x860, 0x66F60110,
+	0x864, 0x061F0649,
+	0x868, 0x00000000,
+	0x86C, 0x27272700,
+	0x870, 0x07000760,
+	0x874, 0x25004000,
+	0x878, 0x00000808,
+	0x87C, 0x00000000,
+	0x880, 0xB0000C1C,
+	0x884, 0x00000001,
+	0x888, 0x00000000,
+	0x88C, 0xCCC000C0,
+	0x890, 0x00000800,
+	0x894, 0xFFFFFFFE,
+	0x898, 0x40302010,
+	0x89C, 0x00706050,
+	0x900, 0x00000000,
+	0x904, 0x00000023,
+	0x908, 0x00000000,
+	0x90C, 0x81121111,
+	0x910, 0x00000002,
+	0x914, 0x00000201,
+	0xA00, 0x00D047C8,
+	0xA04, 0x80FF800C,
+	0xA08, 0x8C838300,
+	0xA0C, 0x2E7F120F,
+	0xA10, 0x9500BB78,
+	0xA14, 0x1114D028,
+	0xA18, 0x00881117,
+	0xA1C, 0x89140F00,
+	0xA20, 0x1A1B0000,
+	0xA24, 0x090E1317,
+	0xA28, 0x00000204,
+	0xA2C, 0x00D30000,
+	0xA70, 0x101FBF00,
+	0xA74, 0x00000007,
+	0xA78, 0x00000900,
+	0xA7C, 0x225B0606,
+	0xA80, 0x21806490,
+	0xB2C, 0x00000000,
+	0xC00, 0x48071D40,
+	0xC04, 0x03A05611,
+	0xC08, 0x000000E4,
+	0xC0C, 0x6C6C6C6C,
+	0xC10, 0x08800000,
+	0xC14, 0x40000100,
+	0xC18, 0x08800000,
+	0xC1C, 0x40000100,
+	0xC20, 0x00000000,
+	0xC24, 0x00000000,
+	0xC28, 0x00000000,
+	0xC2C, 0x00000000,
+	0xC30, 0x69E9AC44,
+	0xC34, 0x469652AF,
+	0xC38, 0x49795994,
+	0xC3C, 0x0A97971C,
+	0xC40, 0x1F7C403F,
+	0xC44, 0x000100B7,
+	0xC48, 0xEC020107,
+	0xC4C, 0x007F037F,
+	0xC50, 0x69553420,
+	0xC54, 0x43BC0094,
+	0xC58, 0x00013147,
+	0xC5C, 0x00250492,
+	0xC60, 0x00000000,
+	0xC64, 0x5112848B,
+	0xC68, 0x47C00BFF,
+	0xC6C, 0x00000036,
+	0xC70, 0x2C7F000D,
+	0xC74, 0x020610DB,
+	0xC78, 0x0000001F,
+	0xC7C, 0x00B91612,
+	0xC80, 0x390000E4,
+	0xC84, 0x21F60000,
+	0xC88, 0x40000100,
+	0xC8C, 0x20200000,
+	0xC90, 0x00020E1A,
+	0xC94, 0x00000000,
+	0xC98, 0x00020E1A,
+	0xC9C, 0x00007F7F,
+	0xCA0, 0x00000000,
+	0xCA4, 0x000300A0,
+	0xCA8, 0x00000000,
+	0xCAC, 0x00000000,
+	0xCB0, 0x00000000,
+	0xCB4, 0x00000000,
+	0xCB8, 0x00000000,
+	0xCBC, 0x28000000,
+	0xCC0, 0x00000000,
+	0xCC4, 0x00000000,
+	0xCC8, 0x00000000,
+	0xCCC, 0x00000000,
+	0xCD0, 0x00000000,
+	0xCD4, 0x00000000,
+	0xCD8, 0x64B22427,
+	0xCDC, 0x00766932,
+	0xCE0, 0x00222222,
+	0xCE4, 0x00000000,
+	0xCE8, 0x37644302,
+	0xCEC, 0x2F97D40C,
+	0xD00, 0x00000740,
+	0xD04, 0x40020401,
+	0xD08, 0x0000907F,
+	0xD0C, 0x20010201,
+	0xD10, 0xA0633333,
+	0xD14, 0x3333BC53,
+	0xD18, 0x7A8F5B6F,
+	0xD2C, 0xCC979975,
+	0xD30, 0x00000000,
+	0xD34, 0x80608000,
+	0xD38, 0x00000000,
+	0xD3C, 0x00127353,
+	0xD40, 0x00000000,
+	0xD44, 0x00000000,
+	0xD48, 0x00000000,
+	0xD4C, 0x00000000,
+	0xD50, 0x6437140A,
+	0xD54, 0x00000000,
+	0xD58, 0x00000282,
+	0xD5C, 0x30032064,
+	0xD60, 0x4653DE68,
+	0xD64, 0x04518A3C,
+	0xD68, 0x00002101,
+	0xD6C, 0x2A201C16,
+	0xD70, 0x1812362E,
+	0xD74, 0x322C2220,
+	0xD78, 0x000E3C24,
+	0xE00, 0x2D2D2D2D,
+	0xE04, 0x2D2D2D2D,
+	0xE08, 0x0390272D,
+	0xE10, 0x2D2D2D2D,
+	0xE14, 0x2D2D2D2D,
+	0xE18, 0x2D2D2D2D,
+	0xE1C, 0x2D2D2D2D,
+	0xE28, 0x00000000,
+	0xE30, 0x1000DC1F,
+	0xE34, 0x10008C1F,
+	0xE38, 0x02140102,
+	0xE3C, 0x681604C2,
+	0xE40, 0x01007C00,
+	0xE44, 0x01004800,
+	0xE48, 0xFB000000,
+	0xE4C, 0x000028D1,
+	0xE50, 0x1000DC1F,
+	0xE54, 0x10008C1F,
+	0xE58, 0x02140102,
+	0xE5C, 0x28160D05,
+	0xE60, 0x00000048,
+	0xE68, 0x001B2556,
+	0xE6C, 0x00C00096,
+	0xE70, 0x00C00096,
+	0xE74, 0x01000056,
+	0xE78, 0x01000014,
+	0xE7C, 0x01000056,
+	0xE80, 0x01000014,
+	0xE84, 0x00C00096,
+	0xE88, 0x01000056,
+	0xE8C, 0x00C00096,
+	0xED0, 0x00C00096,
+	0xED4, 0x00C00096,
+	0xED8, 0x00C00096,
+	0xEDC, 0x000000D6,
+	0xEE0, 0x000000D6,
+	0xEEC, 0x01C00016,
+	0xF14, 0x00000003,
+	0xF4C, 0x00000000,
+	0xF00, 0x00000300,
+	0x820, 0x01000100,
+	0x800, 0x83040000,
+};
+
+RTW_DECL_TABLE_PHY_COND(rtw8723b_bb, rtw_phy_cfg_bb);
+
+static const struct rtw_phy_pg_cfg_pair rtw8723b_bb_pg[] = {
+	{ 0, 0, 0, 0x00000e08, 0x0000ff00, 0x00003800, },
+	{ 0, 0, 0, 0x0000086c, 0xffffff00, 0x32343600, },
+	{ 0, 0, 0, 0x00000e00, 0xffffffff, 0x40424444, },
+	{ 0, 0, 0, 0x00000e04, 0xffffffff, 0x28323638, },
+	{ 0, 0, 0, 0x00000e10, 0xffffffff, 0x38404244, },
+	{ 0, 0, 0, 0x00000e14, 0xffffffff, 0x26303436, },
+};
+
+RTW_DECL_TABLE_BB_PG(rtw8723b_bb_pg);
+
+static const u32 rtw8723b_rf_a[] = {
+	0x000, 0x00010000,
+	0x0B0, 0x000DFFE0,
+	0xFFE, 0x00000000,
+	0xFFE, 0x00000000,
+	0xFFE, 0x00000000,
+	0x0B1, 0x00000018,
+	0xFFE, 0x00000000,
+	0xFFE, 0x00000000,
+	0xFFE, 0x00000000,
+	0x0B2, 0x00084C00,
+	0x0B5, 0x0000D2CC,
+	0x0B6, 0x000925AA,
+	0x0B7, 0x00000010,
+	0x0B8, 0x0000907F,
+	0x05C, 0x00000002,
+	0x07C, 0x00000002,
+	0x07E, 0x00000005,
+	0x08B, 0x0006FC00,
+	0x0B0, 0x000FF9F0,
+	0x01C, 0x000739D2,
+	0x01E, 0x00000000,
+	0x0DF, 0x00000780,
+	0x050, 0x00067435,
+	0x80002000, 0x00000000, 0x40000000, 0x00000000,
+	0x051, 0x0006F10E,
+	0x052, 0x000007D3,
+	0x90003000, 0x00000000, 0x40000000, 0x00000000,
+	0x051, 0x0006F10E,
+	0x052, 0x000007D3,
+	0x90004000, 0x00000000, 0x40000000, 0x00000000,
+	0x051, 0x0006F10E,
+	0x052, 0x000007D3,
+	0xA0000000, 0x00000000,
+	0x051, 0x0006B04E,
+	0x052, 0x000007D2,
+	0xB0000000, 0x00000000,
+	0x053, 0x00000000,
+	0x054, 0x00050400,
+	0x055, 0x0004026E,
+	0x0DD, 0x0000004C,
+	0x070, 0x00067435,
+	0x80002000, 0x00000000, 0x40000000, 0x00000000,
+	0x071, 0x0006F10E,
+	0x072, 0x000007D3,
+	0x90003000, 0x00000000, 0x40000000, 0x00000000,
+	0x071, 0x0006F10E,
+	0x072, 0x000007D3,
+	0x90004000, 0x00000000, 0x40000000, 0x00000000,
+	0x071, 0x0006F10E,
+	0x072, 0x000007D3,
+	0xA0000000, 0x00000000,
+	0x071, 0x0006B04E,
+	0x072, 0x000007D2,
+	0xB0000000, 0x00000000,
+	0x073, 0x00000000,
+	0x074, 0x00050400,
+	0x075, 0x0004026E,
+	0x0EF, 0x00000100,
+	0x034, 0x0000ADD7,
+	0x035, 0x00005C00,
+	0x034, 0x00009DD4,
+	0x035, 0x00005000,
+	0x034, 0x00008DD1,
+	0x035, 0x00004400,
+	0x034, 0x00007DCE,
+	0x035, 0x00003800,
+	0x034, 0x00006CD1,
+	0x035, 0x00004400,
+	0x034, 0x00005CCE,
+	0x035, 0x00003800,
+	0x034, 0x000048CE,
+	0x035, 0x00004400,
+	0x034, 0x000034CE,
+	0x035, 0x00003800,
+	0x034, 0x00002451,
+	0x035, 0x00004400,
+	0x034, 0x0000144E,
+	0x035, 0x00003800,
+	0x034, 0x00000051,
+	0x035, 0x00004400,
+	0x0EF, 0x00000000,
+	0x0EF, 0x00000100,
+	0x0ED, 0x00000010,
+	0x044, 0x0000ADD7,
+	0x044, 0x00009DD4,
+	0x044, 0x00008DD1,
+	0x044, 0x00007DCE,
+	0x044, 0x00006CC1,
+	0x044, 0x00005CCE,
+	0x044, 0x000044D1,
+	0x044, 0x000034CE,
+	0x044, 0x00002451,
+	0x044, 0x0000144E,
+	0x044, 0x00000051,
+	0x0EF, 0x00000000,
+	0x0ED, 0x00000000,
+	0x07F, 0x00020080,
+	0x0EF, 0x00002000,
+	0x03B, 0x000389EF,
+	0x03B, 0x000302FE,
+	0x03B, 0x00028CE6,
+	0x03B, 0x000200BC,
+	0x03B, 0x000188A5,
+	0x03B, 0x00010FBC,
+	0x03B, 0x00008F71,
+	0x03B, 0x00000900,
+	0x0EF, 0x00000000,
+	0x0ED, 0x00000001,
+	0x040, 0x000380EF,
+	0x040, 0x000302FE,
+	0x040, 0x00028CE6,
+	0x040, 0x000200BC,
+	0x040, 0x000188A5,
+	0x040, 0x00010FBC,
+	0x040, 0x00008F71,
+	0x040, 0x00000900,
+	0x0ED, 0x00000000,
+	0x082, 0x00080000,
+	0x083, 0x00008000,
+	0x084, 0x00049F80,
+	0x085, 0x00068000,
+	0x0A2, 0x00080000,
+	0x0A3, 0x00008000,
+	0x0A4, 0x00048D80,
+	0x0A5, 0x00068000,
+	0x0ED, 0x00000002,
+	0x0EF, 0x00000002,
+	0x056, 0x00000032,
+	0x076, 0x00000032,
+	0x01F, 0x00001008,
+	0x001, 0x00000780,
+};
+
+RTW_DECL_TABLE_RF_RADIO(rtw8723b_rf_a, A);
+
+/*
+ * Regd: FCC -> 0, ETSI -> 2, MKK -> 1
+ * Band: 2.4G -> 0, 5G -> 1
+ * Bandwidth (bw): 20M -> 0, 40M -> 1, 80M -> 2, 160M -> 3
+ * Rate Section (rs): CCK -> 0, OFDM -> 1, HT -> 2, VHT -> 3
+ */
+static const struct rtw_txpwr_lmt_cfg_pair rtw8723b_txpwr_lmt[] = {
+	{0, 0, 0, 0, 1, 30},
+	{2, 0, 0, 0, 1, 26},
+	{1, 0, 0, 0, 1, 32},
+	{0, 0, 0, 0, 2, 30},
+	{2, 0, 0, 0, 2, 26},
+	{1, 0, 0, 0, 2, 32},
+	{0, 0, 0, 0, 3, 30},
+	{2, 0, 0, 0, 3, 26},
+	{1, 0, 0, 0, 3, 32},
+	{0, 0, 0, 0, 4, 30},
+	{2, 0, 0, 0, 4, 26},
+	{1, 0, 0, 0, 4, 32},
+	{0, 0, 0, 0, 5, 30},
+	{2, 0, 0, 0, 5, 26},
+	{1, 0, 0, 0, 5, 32},
+	{0, 0, 0, 0, 6, 30},
+	{2, 0, 0, 0, 6, 26},
+	{1, 0, 0, 0, 6, 32},
+	{0, 0, 0, 0, 7, 30},
+	{2, 0, 0, 0, 7, 26},
+	{1, 0, 0, 0, 7, 32},
+	{0, 0, 0, 0, 8, 30},
+	{2, 0, 0, 0, 8, 26},
+	{1, 0, 0, 0, 8, 32},
+	{0, 0, 0, 0, 9, 30},
+	{2, 0, 0, 0, 9, 26},
+	{1, 0, 0, 0, 9, 32},
+	{0, 0, 0, 0, 10, 30},
+	{2, 0, 0, 0, 10, 26},
+	{1, 0, 0, 0, 10, 32},
+	{0, 0, 0, 0, 11, 30},
+	{2, 0, 0, 0, 11, 26},
+	{1, 0, 0, 0, 11, 32},
+	{0, 0, 0, 0, 12, 63},
+	{2, 0, 0, 0, 12, 26},
+	{1, 0, 0, 0, 12, 32},
+	{0, 0, 0, 0, 13, 63},
+	{2, 0, 0, 0, 13, 26},
+	{1, 0, 0, 0, 13, 32},
+	{0, 0, 0, 0, 14, 63},
+	{2, 0, 0, 0, 14, 63},
+	{1, 0, 0, 0, 14, 32},
+	{0, 0, 0, 1, 1, 28},
+	{2, 0, 0, 1, 1, 28},
+	{1, 0, 0, 1, 1, 28},
+	{0, 0, 0, 1, 2, 28},
+	{2, 0, 0, 1, 2, 32},
+	{1, 0, 0, 1, 2, 32},
+	{0, 0, 0, 1, 3, 32},
+	{2, 0, 0, 1, 3, 32},
+	{1, 0, 0, 1, 3, 32},
+	{0, 0, 0, 1, 4, 32},
+	{2, 0, 0, 1, 4, 32},
+	{1, 0, 0, 1, 4, 32},
+	{0, 0, 0, 1, 5, 32},
+	{2, 0, 0, 1, 5, 32},
+	{1, 0, 0, 1, 5, 32},
+	{0, 0, 0, 1, 6, 32},
+	{2, 0, 0, 1, 6, 32},
+	{1, 0, 0, 1, 6, 32},
+	{0, 0, 0, 1, 7, 32},
+	{2, 0, 0, 1, 7, 32},
+	{1, 0, 0, 1, 7, 32},
+	{0, 0, 0, 1, 8, 32},
+	{2, 0, 0, 1, 8, 32},
+	{1, 0, 0, 1, 8, 32},
+	{0, 0, 0, 1, 9, 32},
+	{2, 0, 0, 1, 9, 32},
+	{1, 0, 0, 1, 9, 32},
+	{0, 0, 0, 1, 10, 28},
+	{2, 0, 0, 1, 10, 32},
+	{1, 0, 0, 1, 10, 32},
+	{0, 0, 0, 1, 11, 28},
+	{2, 0, 0, 1, 11, 32},
+	{1, 0, 0, 1, 11, 32},
+	{0, 0, 0, 1, 12, 63},
+	{2, 0, 0, 1, 12, 32},
+	{1, 0, 0, 1, 12, 32},
+	{0, 0, 0, 1, 13, 63},
+	{2, 0, 0, 1, 13, 28},
+	{1, 0, 0, 1, 13, 28},
+	{0, 0, 0, 1, 14, 63},
+	{2, 0, 0, 1, 14, 63},
+	{1, 0, 0, 1, 14, 63},
+	{0, 0, 0, 2, 1, 26},
+	{2, 0, 0, 2, 1, 26},
+	{1, 0, 0, 2, 1, 28},
+	{0, 0, 0, 2, 2, 26},
+	{2, 0, 0, 2, 2, 32},
+	{1, 0, 0, 2, 2, 32},
+	{0, 0, 0, 2, 3, 32},
+	{2, 0, 0, 2, 3, 32},
+	{1, 0, 0, 2, 3, 32},
+	{0, 0, 0, 2, 4, 32},
+	{2, 0, 0, 2, 4, 32},
+	{1, 0, 0, 2, 4, 32},
+	{0, 0, 0, 2, 5, 32},
+	{2, 0, 0, 2, 5, 32},
+	{1, 0, 0, 2, 5, 32},
+	{0, 0, 0, 2, 6, 32},
+	{2, 0, 0, 2, 6, 32},
+	{1, 0, 0, 2, 6, 32},
+	{0, 0, 0, 2, 7, 32},
+	{2, 0, 0, 2, 7, 32},
+	{1, 0, 0, 2, 7, 32},
+	{0, 0, 0, 2, 8, 32},
+	{2, 0, 0, 2, 8, 32},
+	{1, 0, 0, 2, 8, 32},
+	{0, 0, 0, 2, 9, 32},
+	{2, 0, 0, 2, 9, 32},
+	{1, 0, 0, 2, 9, 32},
+	{0, 0, 0, 2, 10, 26},
+	{2, 0, 0, 2, 10, 32},
+	{1, 0, 0, 2, 10, 32},
+	{0, 0, 0, 2, 11, 26},
+	{2, 0, 0, 2, 11, 32},
+	{1, 0, 0, 2, 11, 32},
+	{0, 0, 0, 2, 12, 63},
+	{2, 0, 0, 2, 12, 32},
+	{1, 0, 0, 2, 12, 32},
+	{0, 0, 0, 2, 13, 63},
+	{2, 0, 0, 2, 13, 26},
+	{1, 0, 0, 2, 13, 28},
+	{0, 0, 0, 2, 14, 63},
+	{2, 0, 0, 2, 14, 63},
+	{1, 0, 0, 2, 14, 63},
+	{0, 0, 0, 2, 1, 30},
+	{2, 0, 0, 2, 1, 32},
+	{1, 0, 0, 2, 1, 32},
+	{0, 0, 0, 2, 2, 32},
+	{2, 0, 0, 2, 2, 32},
+	{1, 0, 0, 2, 2, 32},
+	{0, 0, 0, 2, 3, 32},
+	{2, 0, 0, 2, 3, 32},
+	{1, 0, 0, 2, 3, 32},
+	{0, 0, 0, 2, 4, 32},
+	{2, 0, 0, 2, 4, 32},
+	{1, 0, 0, 2, 4, 32},
+	{0, 0, 0, 2, 5, 32},
+	{2, 0, 0, 2, 5, 32},
+	{1, 0, 0, 2, 5, 32},
+	{0, 0, 0, 2, 6, 32},
+	{2, 0, 0, 2, 6, 32},
+	{1, 0, 0, 2, 6, 32},
+	{0, 0, 0, 2, 7, 32},
+	{2, 0, 0, 2, 7, 32},
+	{1, 0, 0, 2, 7, 32},
+	{0, 0, 0, 2, 8, 32},
+	{2, 0, 0, 2, 8, 32},
+	{1, 0, 0, 2, 8, 32},
+	{0, 0, 0, 2, 9, 32},
+	{2, 0, 0, 2, 9, 32},
+	{1, 0, 0, 2, 9, 32},
+	{0, 0, 0, 2, 10, 32},
+	{2, 0, 0, 2, 10, 32},
+	{1, 0, 0, 2, 10, 32},
+	{0, 0, 0, 2, 11, 30},
+	{2, 0, 0, 2, 11, 32},
+	{1, 0, 0, 2, 11, 32},
+	{0, 0, 0, 2, 12, 63},
+	{2, 0, 0, 2, 12, 32},
+	{1, 0, 0, 2, 12, 32},
+	{0, 0, 0, 2, 13, 63},
+	{2, 0, 0, 2, 13, 32},
+	{1, 0, 0, 2, 13, 32},
+	{0, 0, 0, 2, 14, 63},
+	{2, 0, 0, 2, 14, 63},
+	{1, 0, 0, 2, 14, 63},
+	{0, 0, 1, 2, 1, 63},
+	{2, 0, 1, 2, 1, 63},
+	{1, 0, 1, 2, 1, 63},
+	{0, 0, 1, 2, 2, 63},
+	{2, 0, 1, 2, 2, 63},
+	{1, 0, 1, 2, 2, 63},
+	{0, 0, 1, 2, 3, 26},
+	{2, 0, 1, 2, 3, 26},
+	{1, 0, 1, 2, 3, 26},
+	{0, 0, 1, 2, 4, 26},
+	{2, 0, 1, 2, 4, 28},
+	{1, 0, 1, 2, 4, 26},
+	{0, 0, 1, 2, 5, 28},
+	{2, 0, 1, 2, 5, 28},
+	{1, 0, 1, 2, 5, 26},
+	{0, 0, 1, 2, 6, 28},
+	{2, 0, 1, 2, 6, 28},
+	{1, 0, 1, 2, 6, 26},
+	{0, 0, 1, 2, 7, 28},
+	{2, 0, 1, 2, 7, 28},
+	{1, 0, 1, 2, 7, 26},
+	{0, 0, 1, 2, 8, 26},
+	{2, 0, 1, 2, 8, 28},
+	{1, 0, 1, 2, 8, 26},
+	{0, 0, 1, 2, 9, 26},
+	{2, 0, 1, 2, 9, 28},
+	{1, 0, 1, 2, 9, 26},
+	{0, 0, 1, 2, 10, 26},
+	{2, 0, 1, 2, 10, 28},
+	{1, 0, 1, 2, 10, 26},
+	{0, 0, 1, 2, 11, 26},
+	{2, 0, 1, 2, 11, 26},
+	{1, 0, 1, 2, 11, 26},
+	{0, 0, 1, 2, 12, 63},
+	{2, 0, 1, 2, 12, 26},
+	{1, 0, 1, 2, 12, 26},
+	{0, 0, 1, 2, 13, 63},
+	{2, 0, 1, 2, 13, 26},
+	{1, 0, 1, 2, 13, 26},
+	{0, 0, 1, 2, 14, 63},
+	{2, 0, 1, 2, 14, 63},
+	{1, 0, 1, 2, 14, 63},
+	{0, 0, 1, 2, 1, 63},
+	{2, 0, 1, 2, 1, 63},
+	{1, 0, 1, 2, 1, 63},
+	{0, 0, 1, 2, 2, 63},
+	{2, 0, 1, 2, 2, 63},
+	{1, 0, 1, 2, 2, 63},
+	{0, 0, 1, 2, 3, 30},
+	{2, 0, 1, 2, 3, 30},
+	{1, 0, 1, 2, 3, 30},
+	{0, 0, 1, 2, 4, 32},
+	{2, 0, 1, 2, 4, 30},
+	{1, 0, 1, 2, 4, 30},
+	{0, 0, 1, 2, 5, 32},
+	{2, 0, 1, 2, 5, 30},
+	{1, 0, 1, 2, 5, 30},
+	{0, 0, 1, 2, 6, 32},
+	{2, 0, 1, 2, 6, 30},
+	{1, 0, 1, 2, 6, 30},
+	{0, 0, 1, 2, 7, 32},
+	{2, 0, 1, 2, 7, 30},
+	{1, 0, 1, 2, 7, 30},
+	{0, 0, 1, 2, 8, 32},
+	{2, 0, 1, 2, 8, 30},
+	{1, 0, 1, 2, 8, 30},
+	{0, 0, 1, 2, 9, 32},
+	{2, 0, 1, 2, 9, 30},
+	{1, 0, 1, 2, 9, 30},
+	{0, 0, 1, 2, 10, 32},
+	{2, 0, 1, 2, 10, 30},
+	{1, 0, 1, 2, 10, 30},
+	{0, 0, 1, 2, 11, 30},
+	{2, 0, 1, 2, 11, 30},
+	{1, 0, 1, 2, 11, 30},
+	{0, 0, 1, 2, 12, 63},
+	{2, 0, 1, 2, 12, 32},
+	{1, 0, 1, 2, 12, 32},
+	{0, 0, 1, 2, 13, 63},
+	{2, 0, 1, 2, 13, 32},
+	{1, 0, 1, 2, 13, 32},
+	{0, 0, 1, 2, 14, 63},
+	{2, 0, 1, 2, 14, 63},
+	{1, 0, 1, 2, 14, 63},
+};
+
+RTW_DECL_TABLE_TXPWR_LMT(rtw8723b_txpwr_lmt);
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8723b_table.h b/drivers/net/wireless/realtek/rtw88/rtw8723b_table.h
new file mode 100644
index 000000000000..49291fd1dd9d
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtw88/rtw8723b_table.h
@@ -0,0 +1,18 @@
+/* SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause */
+/*
+ * Copyright(c) 2007-2017  Realtek Corporation
+ * Copyright(c) Michael Straube <straube.linux@gmail.com>
+ * Copyright(c) 2024-2026 Luka Gejak <luka.gejak@linux.dev>
+ */
+
+#ifndef __RTW8723B_TABLE_H__
+#define __RTW8723B_TABLE_H__
+
+extern const struct rtw_table rtw8723b_mac_tbl;
+extern const struct rtw_table rtw8723b_agc_tbl;
+extern const struct rtw_table rtw8723b_bb_tbl;
+extern const struct rtw_table rtw8723b_bb_pg_tbl;
+extern const struct rtw_table rtw8723b_rf_a_tbl;
+extern const struct rtw_table rtw8723b_txpwr_lmt_tbl;
+
+#endif
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8723bs.c b/drivers/net/wireless/realtek/rtw88/rtw8723bs.c
new file mode 100644
index 000000000000..95bff0357b31
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtw88/rtw8723bs.c
@@ -0,0 +1,39 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+/*
+ * Copyright(c) 2007-2017  Realtek Corporation
+ * Copyright(c) Michael Straube <straube.linux@gmail.com>
+ * Copyright(c) 2024-2026 Luka Gejak <luka.gejak@linux.dev>
+ */
+
+#include <linux/mmc/sdio_func.h>
+#include <linux/mmc/sdio_ids.h>
+#include <linux/module.h>
+#include "main.h"
+#include "rtw8723b.h"
+#include "sdio.h"
+
+static const struct sdio_device_id rtw_8723bs_id_table[] = {
+	{
+		SDIO_DEVICE(SDIO_VENDOR_ID_REALTEK,
+			    SDIO_DEVICE_ID_REALTEK_RTW8723BS),
+		.driver_data = (kernel_ulong_t)&rtw8723b_hw_spec,
+	},
+	{}
+};
+MODULE_DEVICE_TABLE(sdio, rtw_8723bs_id_table);
+
+static struct sdio_driver rtw_8723bs_driver = {
+	.name = KBUILD_MODNAME,
+	.id_table = rtw_8723bs_id_table,
+	.probe = rtw_sdio_probe,
+	.remove = rtw_sdio_remove,
+	.shutdown = rtw_sdio_shutdown,
+	.drv = {
+		.pm = &rtw_sdio_pm_ops,
+	}};
+module_sdio_driver(rtw_8723bs_driver);
+
+MODULE_AUTHOR("Michael Straube <straube.linux@gmail.com>");
+MODULE_AUTHOR("Luka Gejak <luka.gejak@linux.dev>");
+MODULE_DESCRIPTION("Realtek 802.11n wireless 8723bs driver");
+MODULE_LICENSE("Dual BSD/GPL");
-- 
2.55.0

