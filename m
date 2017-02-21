Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:36042 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753728AbdBUQQY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Feb 2017 11:16:24 -0500
Received: by mail-lf0-f65.google.com with SMTP id 90so4026616lfr.3
        for <linux-wireless@vger.kernel.org>; Tue, 21 Feb 2017 08:16:23 -0800 (PST)
From: Erik Stromdahl <erik.stromdahl@gmail.com>
To: kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Cc: Erik Stromdahl <erik.stromdahl@gmail.com>
Subject: [RFC v4 05/21] ath10k: various sdio related definitions
Date: Tue, 21 Feb 2017 17:15:25 +0100
Message-Id: <1487693741-10042-6-git-send-email-erik.stromdahl@gmail.com> (sfid-20170221_171651_271868_6415F01B)
In-Reply-To: <1487693741-10042-1-git-send-email-erik.stromdahl@gmail.com>
References: <1487693741-10042-1-git-send-email-erik.stromdahl@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Debug masks for SDIO HIF layer.
Address definitions for SDIO/mbox based chipsets.
Augmented struct host_interest with more members.

Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
---
 drivers/net/wireless/ath/ath10k/core.h      |  3 ++
 drivers/net/wireless/ath/ath10k/debug.h     |  2 ++
 drivers/net/wireless/ath/ath10k/hw.h        | 53 +++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/targaddrs.h | 24 +++++++++++++
 4 files changed, 82 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 88d14be..5965d18 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -91,6 +91,7 @@ struct ath10k;
 enum ath10k_bus {
 	ATH10K_BUS_PCI,
 	ATH10K_BUS_AHB,
+	ATH10K_BUS_SDIO,
 };
 
 static inline const char *ath10k_bus_str(enum ath10k_bus bus)
@@ -100,6 +101,8 @@ static inline const char *ath10k_bus_str(enum ath10k_bus bus)
 		return "pci";
 	case ATH10K_BUS_AHB:
 		return "ahb";
+	case ATH10K_BUS_SDIO:
+		return "sdio";
 	}
 
 	return "unknown";
diff --git a/drivers/net/wireless/ath/ath10k/debug.h b/drivers/net/wireless/ath/ath10k/debug.h
index 2368f47..257d109 100644
--- a/drivers/net/wireless/ath/ath10k/debug.h
+++ b/drivers/net/wireless/ath/ath10k/debug.h
@@ -38,6 +38,8 @@ enum ath10k_debug_mask {
 	ATH10K_DBG_WMI_PRINT	= 0x00002000,
 	ATH10K_DBG_PCI_PS	= 0x00004000,
 	ATH10K_DBG_AHB		= 0x00008000,
+	ATH10K_DBG_SDIO		= 0x00010000,
+	ATH10K_DBG_SDIO_DUMP	= 0x00020000,
 	ATH10K_DBG_ANY		= 0xffffffff,
 };
 
diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index d370b57..4055144 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -856,6 +856,59 @@ ath10k_rx_desc_get_l3_pad_bytes(struct ath10k_hw_params *hw,
 #define QCA9887_EEPROM_ADDR_LO_MASK		0x00ff0000
 #define QCA9887_EEPROM_ADDR_LO_LSB		16
 
+#define MBOX_RESET_CONTROL_ADDRESS		0x00000000
+#define MBOX_HOST_INT_STATUS_ADDRESS		0x00000800
+#define MBOX_HOST_INT_STATUS_ERROR_LSB		7
+#define MBOX_HOST_INT_STATUS_ERROR_MASK		0x00000080
+#define MBOX_HOST_INT_STATUS_CPU_LSB		6
+#define MBOX_HOST_INT_STATUS_CPU_MASK		0x00000040
+#define MBOX_HOST_INT_STATUS_COUNTER_LSB	4
+#define MBOX_HOST_INT_STATUS_COUNTER_MASK	0x00000010
+#define MBOX_CPU_INT_STATUS_ADDRESS		0x00000801
+#define MBOX_ERROR_INT_STATUS_ADDRESS		0x00000802
+#define MBOX_ERROR_INT_STATUS_WAKEUP_LSB	2
+#define MBOX_ERROR_INT_STATUS_WAKEUP_MASK	0x00000004
+#define MBOX_ERROR_INT_STATUS_RX_UNDERFLOW_LSB	1
+#define MBOX_ERROR_INT_STATUS_RX_UNDERFLOW_MASK	0x00000002
+#define MBOX_ERROR_INT_STATUS_TX_OVERFLOW_LSB	0
+#define MBOX_ERROR_INT_STATUS_TX_OVERFLOW_MASK	0x00000001
+#define MBOX_COUNTER_INT_STATUS_ADDRESS		0x00000803
+#define MBOX_COUNTER_INT_STATUS_COUNTER_LSB	0
+#define MBOX_COUNTER_INT_STATUS_COUNTER_MASK	0x000000ff
+#define MBOX_RX_LOOKAHEAD_VALID_ADDRESS		0x00000805
+#define MBOX_INT_STATUS_ENABLE_ADDRESS		0x00000828
+#define MBOX_INT_STATUS_ENABLE_ERROR_LSB	7
+#define MBOX_INT_STATUS_ENABLE_ERROR_MASK	0x00000080
+#define MBOX_INT_STATUS_ENABLE_CPU_LSB		6
+#define MBOX_INT_STATUS_ENABLE_CPU_MASK		0x00000040
+#define MBOX_INT_STATUS_ENABLE_INT_LSB		5
+#define MBOX_INT_STATUS_ENABLE_INT_MASK		0x00000020
+#define MBOX_INT_STATUS_ENABLE_COUNTER_LSB	4
+#define MBOX_INT_STATUS_ENABLE_COUNTER_MASK	0x00000010
+#define MBOX_INT_STATUS_ENABLE_MBOX_DATA_LSB	0
+#define MBOX_INT_STATUS_ENABLE_MBOX_DATA_MASK	0x0000000f
+#define MBOX_CPU_INT_STATUS_ENABLE_ADDRESS	0x00000819
+#define MBOX_CPU_INT_STATUS_ENABLE_BIT_LSB	0
+#define MBOX_CPU_INT_STATUS_ENABLE_BIT_MASK	0x000000ff
+#define MBOX_ERROR_STATUS_ENABLE_ADDRESS	0x0000081a
+#define MBOX_ERROR_STATUS_ENABLE_RX_UNDERFLOW_LSB  1
+#define MBOX_ERROR_STATUS_ENABLE_RX_UNDERFLOW_MASK 0x00000002
+#define MBOX_ERROR_STATUS_ENABLE_TX_OVERFLOW_LSB   0
+#define MBOX_ERROR_STATUS_ENABLE_TX_OVERFLOW_MASK  0x00000001
+#define MBOX_COUNTER_INT_STATUS_ENABLE_ADDRESS	0x0000081b
+#define MBOX_COUNTER_INT_STATUS_ENABLE_BIT_LSB	0
+#define MBOX_COUNTER_INT_STATUS_ENABLE_BIT_MASK	0x000000ff
+#define MBOX_COUNT_ADDRESS			0x00000820
+#define MBOX_COUNT_DEC_ADDRESS			0x00000840
+#define MBOX_WINDOW_DATA_ADDRESS		0x00000874
+#define MBOX_WINDOW_WRITE_ADDR_ADDRESS		0x00000878
+#define MBOX_WINDOW_READ_ADDR_ADDRESS		0x0000087c
+#define MBOX_CPU_DBG_SEL_ADDRESS		0x00000883
+#define MBOX_CPU_DBG_ADDRESS			0x00000884
+#define MBOX_RTC_BASE_ADDRESS			0x00000000
+#define MBOX_GPIO_BASE_ADDRESS			0x00005000
+#define MBOX_MBOX_BASE_ADDRESS			0x00008000
+
 #define RTC_STATE_V_GET(x) (((x) & RTC_STATE_V_MASK) >> RTC_STATE_V_LSB)
 
 /* Register definitions for first generation ath10k cards. These cards include
diff --git a/drivers/net/wireless/ath/ath10k/targaddrs.h b/drivers/net/wireless/ath/ath10k/targaddrs.h
index a47cab4..58e0541 100644
--- a/drivers/net/wireless/ath/ath10k/targaddrs.h
+++ b/drivers/net/wireless/ath/ath10k/targaddrs.h
@@ -205,6 +205,24 @@ struct host_interest {
 	 */
 	/* Bit 1 - unused */
 	u32 hi_fw_swap;					/* 0x104 */
+
+	/* global arenas pointer address, used by host driver debug */
+	u32 hi_dynamic_mem_arenas_addr;			/* 0x108 */
+
+	/* allocated bytes of DRAM use by allocated */
+	u32 hi_dynamic_mem_allocated;			/* 0x10C */
+
+	/* remaining bytes of DRAM */
+	u32 hi_dynamic_mem_remaining;			/* 0x110 */
+
+	/* memory track count, configured by host */
+	u32 hi_dynamic_mem_track_max;			/* 0x114 */
+
+	/* minidump buffer */
+	u32 hi_minidump;				/* 0x118 */
+
+	/* bdata's sig and key addr */
+	u32 hi_bd_sig_key;				/* 0x11c */
 } __packed;
 
 #define HI_ITEM(item)  offsetof(struct host_interest, item)
@@ -319,6 +337,12 @@ Fw Mode/SubMode Mask
 #define HI_ACS_FLAGS_USE_WWAN       (1 << 1)
 /* Use test VAP */
 #define HI_ACS_FLAGS_TEST_VAP       (1 << 2)
+/* SDIO/mailbox ACS flag definitions */
+#define HI_ACS_FLAGS_SDIO_SWAP_MAILBOX_SET       (1 << 0)
+#define HI_ACS_FLAGS_SDIO_REDUCE_TX_COMPL_SET    (1 << 1)
+#define HI_ACS_FLAGS_ALT_DATA_CREDIT_SIZE        (1 << 2)
+#define HI_ACS_FLAGS_SDIO_SWAP_MAILBOX_FW_ACK    (1 << 16)
+#define HI_ACS_FLAGS_SDIO_REDUCE_TX_COMPL_FW_ACK (1 << 17)
 
 /*
  * CONSOLE FLAGS
-- 
2.7.4
