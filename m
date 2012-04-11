Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog122.obsmtp.com ([74.125.149.147]:44658 "EHLO
	na3sys009aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754255Ab2DKJiY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Apr 2012 05:38:24 -0400
Received: by lahj13 with SMTP id j13so540691lah.19
        for <linux-wireless@vger.kernel.org>; Wed, 11 Apr 2012 02:38:21 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: arik@wizery.com, linville@tuxdriver.com, coelho@ti.com
Subject: [PATCH 07/16] wlcore/wl12xx: implement chip-specific register tables
Date: Wed, 11 Apr 2012 12:37:54 +0300
Message-Id: <1334137083-13490-8-git-send-email-coelho@ti.com> (sfid-20120411_113840_366184_72E3EF15)
In-Reply-To: <1334137083-13490-1-git-send-email-coelho@ti.com>
References: <1334137083-13490-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add register tables support in wlcore, add some new IO functions to
read and write to chip-specific register and data addresses.  Move
some common register values from wl12xx to wlcore and add the
registers table to wl12xx.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wl12xx/main.c            |   43 +++-
 drivers/net/wireless/ti/{wlcore => wl12xx}/reg.h |  338 +++++++++++-----------
 drivers/net/wireless/ti/wlcore/acx.c             |    1 -
 drivers/net/wireless/ti/wlcore/boot.c            |   71 +++--
 drivers/net/wireless/ti/wlcore/boot.h            |   67 -----
 drivers/net/wireless/ti/wlcore/cmd.c             |   26 +-
 drivers/net/wireless/ti/wlcore/cmd.h             |   14 +-
 drivers/net/wireless/ti/wlcore/conf.h            |    1 -
 drivers/net/wireless/ti/wlcore/event.c           |    5 +-
 drivers/net/wireless/ti/wlcore/init.c            |    1 -
 drivers/net/wireless/ti/wlcore/io.c              |   29 +--
 drivers/net/wireless/ti/wlcore/io.h              |   36 +++-
 drivers/net/wireless/ti/wlcore/main.c            |   35 ++-
 drivers/net/wireless/ti/wlcore/ps.c              |    5 +-
 drivers/net/wireless/ti/wlcore/rx.c              |   20 +-
 drivers/net/wireless/ti/wlcore/sdio.c            |    4 +-
 drivers/net/wireless/ti/wlcore/spi.c             |    2 -
 drivers/net/wireless/ti/wlcore/testmode.c        |    1 -
 drivers/net/wireless/ti/wlcore/tx.c              |   17 +-
 drivers/net/wireless/ti/wlcore/wlcore.h          |  107 +++++++
 20 files changed, 468 insertions(+), 355 deletions(-)
 rename drivers/net/wireless/ti/{wlcore => wl12xx}/reg.h (70%)

diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index 0d3ed7d..ea8480c 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -27,7 +27,7 @@
 #include "../wlcore/wlcore.h"
 #include "../wlcore/debug.h"
 
-#include "../wlcore/reg.h"
+#include "reg.h"
 
 static struct wlcore_ops wl12xx_ops = {
 };
@@ -52,6 +52,26 @@ static struct wlcore_partition_set wl12xx_ptable[PART_TABLE_LEN] = {
 		},
 	},
 
+	[PART_BOOT] = { /* in wl12xx we can use a mix of work and down
+			 * partition here */
+		.mem = {
+			.start = 0x00040000,
+			.size  = 0x00014fc0
+		},
+		.reg = {
+			.start = REGISTERS_BASE,
+			.size  = 0x00008800
+		},
+		.mem2 = {
+			.start = 0x00000000,
+			.size  = 0x00000000
+		},
+		.mem3 = {
+			.start = 0x00000000,
+			.size  = 0x00000000
+		},
+	},
+
 	[PART_WORK] = {
 		.mem = {
 			.start = 0x00040000,
@@ -91,6 +111,26 @@ static struct wlcore_partition_set wl12xx_ptable[PART_TABLE_LEN] = {
 	}
 };
 
+static const int wl12xx_rtable[REG_TABLE_LEN] = {
+	[REG_ECPU_CONTROL]		= WL12XX_REG_ECPU_CONTROL,
+	[REG_INTERRUPT_NO_CLEAR]	= WL12XX_REG_INTERRUPT_NO_CLEAR,
+	[REG_INTERRUPT_ACK]		= WL12XX_REG_INTERRUPT_ACK,
+	[REG_COMMAND_MAILBOX_PTR]	= WL12XX_REG_COMMAND_MAILBOX_PTR,
+	[REG_EVENT_MAILBOX_PTR]		= WL12XX_REG_EVENT_MAILBOX_PTR,
+	[REG_INTERRUPT_TRIG]		= WL12XX_REG_INTERRUPT_TRIG,
+	[REG_INTERRUPT_MASK]		= WL12XX_REG_INTERRUPT_MASK,
+	[REG_PC_ON_RECOVERY]		= WL12XX_SCR_PAD4,
+	[REG_CHIP_ID_B]			= WL12XX_CHIP_ID_B,
+	[REG_CMD_MBOX_ADDRESS]		= WL12XX_CMD_MBOX_ADDRESS,
+
+	/* data access memory addresses, used with partition translation */
+	[REG_SLV_MEM_DATA]		= WL1271_SLV_MEM_DATA,
+	[REG_SLV_REG_DATA]		= WL1271_SLV_REG_DATA,
+
+	/* raw data access memory addresses */
+	[REG_RAW_FW_STATUS_ADDR]	= FW_STATUS_ADDR,
+};
+
 static int __devinit wl12xx_probe(struct platform_device *pdev)
 {
 	struct wl1271 *wl;
@@ -105,6 +145,7 @@ static int __devinit wl12xx_probe(struct platform_device *pdev)
 	wl = hw->priv;
 	wl->ops = &wl12xx_ops;
 	wl->ptable = wl12xx_ptable;
+	wl->rtable = wl12xx_rtable;
 
 	return wlcore_probe(wl, pdev);
 }
diff --git a/drivers/net/wireless/ti/wlcore/reg.h b/drivers/net/wireless/ti/wl12xx/reg.h
similarity index 70%
rename from drivers/net/wireless/ti/wlcore/reg.h
rename to drivers/net/wireless/ti/wl12xx/reg.h
index 340db32..c6a4743 100644
--- a/drivers/net/wireless/ti/wlcore/reg.h
+++ b/drivers/net/wireless/ti/wl12xx/reg.h
@@ -33,16 +33,8 @@
 #define REGISTERS_DOWN_SIZE 0x00008800
 #define REGISTERS_WORK_SIZE 0x0000b000
 
-#define HW_ACCESS_ELP_CTRL_REG_ADDR         0x1FFFC
 #define FW_STATUS_ADDR                      (0x14FC0 + 0xA000)
 
-/* ELP register commands */
-#define ELPCTRL_WAKE_UP             0x1
-#define ELPCTRL_WAKE_UP_WLAN_READY  0x5
-#define ELPCTRL_SLEEP               0x0
-/* ELP WLAN_READY bit */
-#define ELPCTRL_WLAN_READY          0x2
-
 /*===============================================
    Host Software Reset - 32bit RW
  ------------------------------------------
@@ -57,14 +49,14 @@
     (not self-clearing), the Wlan hardware
     exits the software reset state.
 ===============================================*/
-#define ACX_REG_SLV_SOFT_RESET         (REGISTERS_BASE + 0x0000)
+#define WL12XX_SLV_SOFT_RESET		(REGISTERS_BASE + 0x0000)
 
 #define WL1271_SLV_REG_DATA            (REGISTERS_BASE + 0x0008)
 #define WL1271_SLV_REG_ADATA           (REGISTERS_BASE + 0x000c)
 #define WL1271_SLV_MEM_DATA            (REGISTERS_BASE + 0x0018)
 
-#define ACX_REG_INTERRUPT_TRIG         (REGISTERS_BASE + 0x0474)
-#define ACX_REG_INTERRUPT_TRIG_H       (REGISTERS_BASE + 0x0478)
+#define WL12XX_REG_INTERRUPT_TRIG         (REGISTERS_BASE + 0x0474)
+#define WL12XX_REG_INTERRUPT_TRIG_H       (REGISTERS_BASE + 0x0478)
 
 /*=============================================
   Host Interrupt Mask Register - 32bit (RW)
@@ -94,7 +86,7 @@
  21-			-
  Default: 0x0001
 *==============================================*/
-#define ACX_REG_INTERRUPT_MASK         (REGISTERS_BASE + 0x04DC)
+#define WL12XX_REG_INTERRUPT_MASK         (REGISTERS_BASE + 0x04DC)
 
 /*=============================================
   Host Interrupt Mask Set 16bit, (Write only)
@@ -125,7 +117,7 @@
  Reading this register doesn't
  effect its content.
 =============================================*/
-#define ACX_REG_INTERRUPT_NO_CLEAR     (REGISTERS_BASE + 0x04E8)
+#define WL12XX_REG_INTERRUPT_NO_CLEAR     (REGISTERS_BASE + 0x04E8)
 
 /*=============================================
   Host Interrupt Status Clear on Read  Register
@@ -148,9 +140,9 @@
  HINT_STS_ND registers, thus making the
  assotiated interrupt inactive. (0-no effect)
 ==============================================*/
-#define ACX_REG_INTERRUPT_ACK          (REGISTERS_BASE + 0x04F0)
+#define WL12XX_REG_INTERRUPT_ACK          (REGISTERS_BASE + 0x04F0)
 
-#define RX_DRIVER_COUNTER_ADDRESS      (REGISTERS_BASE + 0x0538)
+#define WL12XX_REG_RX_DRIVER_COUNTER	(REGISTERS_BASE + 0x0538)
 
 /* Device Configuration registers*/
 #define SOR_CFG                        (REGISTERS_BASE + 0x0800)
@@ -175,9 +167,9 @@
  1 halt eCPU
  0 enable eCPU
  ===============================================*/
-#define ACX_REG_ECPU_CONTROL           (REGISTERS_BASE + 0x0804)
+#define WL12XX_REG_ECPU_CONTROL           (REGISTERS_BASE + 0x0804)
 
-#define HI_CFG                         (REGISTERS_BASE + 0x0808)
+#define WL12XX_HI_CFG			(REGISTERS_BASE + 0x0808)
 
 /*===============================================
  EEPROM Burst Read Start  - 32bit RW
@@ -196,72 +188,67 @@
 *================================================*/
 #define ACX_REG_EE_START               (REGISTERS_BASE + 0x080C)
 
-#define OCP_POR_CTR                    (REGISTERS_BASE + 0x09B4)
-#define OCP_DATA_WRITE                 (REGISTERS_BASE + 0x09B8)
-#define OCP_DATA_READ                  (REGISTERS_BASE + 0x09BC)
-#define OCP_CMD                        (REGISTERS_BASE + 0x09C0)
-
-#define WL1271_HOST_WR_ACCESS          (REGISTERS_BASE + 0x09F8)
+#define WL12XX_OCP_POR_CTR		(REGISTERS_BASE + 0x09B4)
+#define WL12XX_OCP_DATA_WRITE		(REGISTERS_BASE + 0x09B8)
+#define WL12XX_OCP_DATA_READ		(REGISTERS_BASE + 0x09BC)
+#define WL12XX_OCP_CMD			(REGISTERS_BASE + 0x09C0)
 
-#define CHIP_ID_B                      (REGISTERS_BASE + 0x5674)
+#define WL12XX_HOST_WR_ACCESS		(REGISTERS_BASE + 0x09F8)
 
-#define CHIP_ID_1271_PG10              (0x4030101)
-#define CHIP_ID_1271_PG20              (0x4030111)
-#define CHIP_ID_1283_PG10              (0x05030101)
-#define CHIP_ID_1283_PG20              (0x05030111)
+#define WL12XX_CHIP_ID_B		(REGISTERS_BASE + 0x5674)
 
-#define ENABLE                         (REGISTERS_BASE + 0x5450)
+#define WL12XX_ENABLE			(REGISTERS_BASE + 0x5450)
 
 /* Power Management registers */
-#define ELP_CFG_MODE                   (REGISTERS_BASE + 0x5804)
-#define ELP_CMD                        (REGISTERS_BASE + 0x5808)
-#define PLL_CAL_TIME                   (REGISTERS_BASE + 0x5810)
-#define CLK_REQ_TIME                   (REGISTERS_BASE + 0x5814)
-#define CLK_BUF_TIME                   (REGISTERS_BASE + 0x5818)
+#define WL12XX_ELP_CFG_MODE		(REGISTERS_BASE + 0x5804)
+#define WL12XX_ELP_CMD			(REGISTERS_BASE + 0x5808)
+#define WL12XX_PLL_CAL_TIME		(REGISTERS_BASE + 0x5810)
+#define WL12XX_CLK_REQ_TIME		(REGISTERS_BASE + 0x5814)
+#define WL12XX_CLK_BUF_TIME		(REGISTERS_BASE + 0x5818)
 
-#define CFG_PLL_SYNC_CNT               (REGISTERS_BASE + 0x5820)
+#define WL12XX_CFG_PLL_SYNC_CNT		(REGISTERS_BASE + 0x5820)
 
 /* Scratch Pad registers*/
-#define SCR_PAD0                       (REGISTERS_BASE + 0x5608)
-#define SCR_PAD1                       (REGISTERS_BASE + 0x560C)
-#define SCR_PAD2                       (REGISTERS_BASE + 0x5610)
-#define SCR_PAD3                       (REGISTERS_BASE + 0x5614)
-#define SCR_PAD4                       (REGISTERS_BASE + 0x5618)
-#define SCR_PAD4_SET                   (REGISTERS_BASE + 0x561C)
-#define SCR_PAD4_CLR                   (REGISTERS_BASE + 0x5620)
-#define SCR_PAD5                       (REGISTERS_BASE + 0x5624)
-#define SCR_PAD5_SET                   (REGISTERS_BASE + 0x5628)
-#define SCR_PAD5_CLR                   (REGISTERS_BASE + 0x562C)
-#define SCR_PAD6                       (REGISTERS_BASE + 0x5630)
-#define SCR_PAD7                       (REGISTERS_BASE + 0x5634)
-#define SCR_PAD8                       (REGISTERS_BASE + 0x5638)
-#define SCR_PAD9                       (REGISTERS_BASE + 0x563C)
+#define WL12XX_SCR_PAD0			(REGISTERS_BASE + 0x5608)
+#define WL12XX_SCR_PAD1			(REGISTERS_BASE + 0x560C)
+#define WL12XX_SCR_PAD2			(REGISTERS_BASE + 0x5610)
+#define WL12XX_SCR_PAD3			(REGISTERS_BASE + 0x5614)
+#define WL12XX_SCR_PAD4			(REGISTERS_BASE + 0x5618)
+#define WL12XX_SCR_PAD4_SET		(REGISTERS_BASE + 0x561C)
+#define WL12XX_SCR_PAD4_CLR		(REGISTERS_BASE + 0x5620)
+#define WL12XX_SCR_PAD5			(REGISTERS_BASE + 0x5624)
+#define WL12XX_SCR_PAD5_SET		(REGISTERS_BASE + 0x5628)
+#define WL12XX_SCR_PAD5_CLR		(REGISTERS_BASE + 0x562C)
+#define WL12XX_SCR_PAD6			(REGISTERS_BASE + 0x5630)
+#define WL12XX_SCR_PAD7			(REGISTERS_BASE + 0x5634)
+#define WL12XX_SCR_PAD8			(REGISTERS_BASE + 0x5638)
+#define WL12XX_SCR_PAD9			(REGISTERS_BASE + 0x563C)
 
 /* Spare registers*/
-#define SPARE_A1                       (REGISTERS_BASE + 0x0994)
-#define SPARE_A2                       (REGISTERS_BASE + 0x0998)
-#define SPARE_A3                       (REGISTERS_BASE + 0x099C)
-#define SPARE_A4                       (REGISTERS_BASE + 0x09A0)
-#define SPARE_A5                       (REGISTERS_BASE + 0x09A4)
-#define SPARE_A6                       (REGISTERS_BASE + 0x09A8)
-#define SPARE_A7                       (REGISTERS_BASE + 0x09AC)
-#define SPARE_A8                       (REGISTERS_BASE + 0x09B0)
-#define SPARE_B1                       (REGISTERS_BASE + 0x5420)
-#define SPARE_B2                       (REGISTERS_BASE + 0x5424)
-#define SPARE_B3                       (REGISTERS_BASE + 0x5428)
-#define SPARE_B4                       (REGISTERS_BASE + 0x542C)
-#define SPARE_B5                       (REGISTERS_BASE + 0x5430)
-#define SPARE_B6                       (REGISTERS_BASE + 0x5434)
-#define SPARE_B7                       (REGISTERS_BASE + 0x5438)
-#define SPARE_B8                       (REGISTERS_BASE + 0x543C)
-
-#define PLL_PARAMETERS                 (REGISTERS_BASE + 0x6040)
-#define WU_COUNTER_PAUSE               (REGISTERS_BASE + 0x6008)
-#define WELP_ARM_COMMAND               (REGISTERS_BASE + 0x6100)
-#define DRPW_SCRATCH_START             (DRPW_BASE + 0x002C)
-
-
-#define ACX_SLV_SOFT_RESET_BIT   BIT(1)
+#define WL12XX_SPARE_A1			(REGISTERS_BASE + 0x0994)
+#define WL12XX_SPARE_A2			(REGISTERS_BASE + 0x0998)
+#define WL12XX_SPARE_A3			(REGISTERS_BASE + 0x099C)
+#define WL12XX_SPARE_A4			(REGISTERS_BASE + 0x09A0)
+#define WL12XX_SPARE_A5			(REGISTERS_BASE + 0x09A4)
+#define WL12XX_SPARE_A6			(REGISTERS_BASE + 0x09A8)
+#define WL12XX_SPARE_A7			(REGISTERS_BASE + 0x09AC)
+#define WL12XX_SPARE_A8			(REGISTERS_BASE + 0x09B0)
+#define WL12XX_SPARE_B1			(REGISTERS_BASE + 0x5420)
+#define WL12XX_SPARE_B2			(REGISTERS_BASE + 0x5424)
+#define WL12XX_SPARE_B3			(REGISTERS_BASE + 0x5428)
+#define WL12XX_SPARE_B4			(REGISTERS_BASE + 0x542C)
+#define WL12XX_SPARE_B5			(REGISTERS_BASE + 0x5430)
+#define WL12XX_SPARE_B6			(REGISTERS_BASE + 0x5434)
+#define WL12XX_SPARE_B7			(REGISTERS_BASE + 0x5438)
+#define WL12XX_SPARE_B8			(REGISTERS_BASE + 0x543C)
+
+#define WL12XX_PLL_PARAMETERS		(REGISTERS_BASE + 0x6040)
+#define WL12XX_WU_COUNTER_PAUSE		(REGISTERS_BASE + 0x6008)
+#define WL12XX_WELP_ARM_COMMAND		(REGISTERS_BASE + 0x6100)
+#define WL12XX_DRPW_SCRATCH_START	(DRPW_BASE + 0x002C)
+
+#define WL12XX_CMD_MBOX_ADDRESS		0x407B4
+
 #define ACX_REG_EEPROM_START_BIT BIT(1)
 
 /* Command/Information Mailbox Pointers */
@@ -279,7 +266,7 @@
  the host receives the Init Complete interrupt from
  the Wlan hardware.
  ===============================================*/
-#define REG_COMMAND_MAILBOX_PTR				(SCR_PAD0)
+#define WL12XX_REG_COMMAND_MAILBOX_PTR		(WL12XX_SCR_PAD0)
 
 /*===============================================
   Information Mailbox Pointer - 32bit RW
@@ -294,7 +281,7 @@
  until after the host receives the Init Complete interrupt from
  the Wlan hardware.
  ===============================================*/
-#define REG_EVENT_MAILBOX_PTR				(SCR_PAD1)
+#define WL12XX_REG_EVENT_MAILBOX_PTR		(WL12XX_SCR_PAD1)
 
 /*===============================================
  EEPROM Read/Write Request 32bit RW
@@ -365,26 +352,6 @@
 #define ACX_CONT_WIND_MIN_MASK   0x0000007f
 #define ACX_CONT_WIND_MAX        0x03ff0000
 
-/*===============================================
-  HI_CFG Interface Configuration Register Values
-  ------------------------------------------
-  ===============================================*/
-#define HI_CFG_UART_ENABLE          0x00000004
-#define HI_CFG_RST232_ENABLE        0x00000008
-#define HI_CFG_CLOCK_REQ_SELECT     0x00000010
-#define HI_CFG_HOST_INT_ENABLE      0x00000020
-#define HI_CFG_VLYNQ_OUTPUT_ENABLE  0x00000040
-#define HI_CFG_HOST_INT_ACTIVE_LOW  0x00000080
-#define HI_CFG_UART_TX_OUT_GPIO_15  0x00000100
-#define HI_CFG_UART_TX_OUT_GPIO_14  0x00000200
-#define HI_CFG_UART_TX_OUT_GPIO_7   0x00000400
-
-#define HI_CFG_DEF_VAL              \
-	(HI_CFG_UART_ENABLE |        \
-	HI_CFG_RST232_ENABLE |      \
-	HI_CFG_CLOCK_REQ_SELECT |   \
-	HI_CFG_HOST_INT_ENABLE)
-
 #define REF_FREQ_19_2                       0
 #define REF_FREQ_26_0                       1
 #define REF_FREQ_38_4                       2
@@ -400,38 +367,19 @@
 #define LUT_PARAM_BB_PLL_LOOP_FILTER        5
 #define LUT_PARAM_NUM                       6
 
-#define ACX_EEPROMLESS_IND_REG              (SCR_PAD4)
+#define WL12XX_EEPROMLESS_IND		(WL12XX_SCR_PAD4)
 #define USE_EEPROM                          0
-#define SOFT_RESET_MAX_TIME                 1000000
-#define SOFT_RESET_STALL_TIME               1000
 #define NVS_DATA_BUNDARY_ALIGNMENT          4
 
-
-/* Firmware image load chunk size */
-#define CHUNK_SIZE	16384
-
 /* Firmware image header size */
 #define FW_HDR_SIZE 8
 
-#define ECPU_CONTROL_HALT					0x00000101
-
-
 /******************************************************************************
 
     CHANNELS, BAND & REG DOMAINS definitions
 
 ******************************************************************************/
 
-
-enum {
-	RADIO_BAND_2_4GHZ = 0,  /* 2.4 Ghz band */
-	RADIO_BAND_5GHZ = 1,    /* 5 Ghz band */
-	RADIO_BAND_JAPAN_4_9_GHZ = 2,
-	DEFAULT_BAND = RADIO_BAND_2_4GHZ,
-	INVALID_BAND = 0xFE,
-	MAX_RADIO_BANDS = 0xFF
-};
-
 #define SHORT_PREAMBLE_BIT   BIT(0) /* CCK or Barker depending on the rate */
 #define OFDM_RATE_BIT        BIT(6)
 #define PBCC_RATE_BIT        BIT(7)
@@ -465,65 +413,113 @@ b12-b0 - Supported Rate indicator bits as defined below.
 
 ******************************************************************************/
 
+#define OCP_CMD_LOOP		32
+#define OCP_CMD_WRITE		0x1
+#define OCP_CMD_READ		0x2
+#define OCP_READY_MASK		BIT(18)
+#define OCP_STATUS_MASK		(BIT(16) | BIT(17))
+#define OCP_STATUS_NO_RESP	0x00000
+#define OCP_STATUS_OK		0x10000
+#define OCP_STATUS_REQ_FAILED	0x20000
+#define OCP_STATUS_RESP_ERROR	0x30000
+
+#define OCP_REG_POLARITY     0x0064
+#define OCP_REG_CLK_TYPE     0x0448
+#define OCP_REG_CLK_POLARITY 0x0cb2
+#define OCP_REG_CLK_PULL     0x0cb4
+
+#define WL127X_REG_FUSE_DATA_2_1    0x050a
+#define WL128X_REG_FUSE_DATA_2_1    0x2152
+#define PG_VER_MASK          0x3c
+#define PG_VER_OFFSET        2
+
+#define PG_MAJOR_VER_MASK    0x3
+#define PG_MAJOR_VER_OFFSET  0x0
+#define PG_MINOR_VER_MASK    0xc
+#define PG_MINOR_VER_OFFSET  0x2
+
+#define POLARITY_LOW         BIT(1)
+#define NO_PULL              (BIT(14) | BIT(15))
+
+#define FREF_CLK_TYPE_BITS     0xfffffe7f
+#define CLK_REQ_PRCM           0x100
+#define FREF_CLK_POLARITY_BITS 0xfffff8ff
+#define CLK_REQ_OUTN_SEL       0x700
+
+#define WU_COUNTER_PAUSE_VAL 0x3FF
+#define WELP_ARM_COMMAND_VAL 0x4
+
+/* PLL configuration algorithm for wl128x */
+#define SYS_CLK_CFG_REG              0x2200
+/* Bit[0]   -  0-TCXO,  1-FREF */
+#define MCS_PLL_CLK_SEL_FREF         BIT(0)
+/* Bit[3:2] - 01-TCXO, 10-FREF */
+#define WL_CLK_REQ_TYPE_FREF         BIT(3)
+#define WL_CLK_REQ_TYPE_PG2          (BIT(3) | BIT(2))
+/* Bit[4]   -  0-TCXO,  1-FREF */
+#define PRCM_CM_EN_MUX_WLAN_FREF     BIT(4)
+
+#define TCXO_ILOAD_INT_REG           0x2264
+#define TCXO_CLK_DETECT_REG          0x2266
+
+#define TCXO_DET_FAILED              BIT(4)
+
+#define FREF_ILOAD_INT_REG           0x2084
+#define FREF_CLK_DETECT_REG          0x2086
+#define FREF_CLK_DETECT_FAIL         BIT(4)
+
+/* Use this reg for masking during driver access */
+#define WL_SPARE_REG                 0x2320
+#define WL_SPARE_VAL                 BIT(2)
+/* Bit[6:5:3] -  mask wl write SYS_CLK_CFG[8:5:2:4] */
+#define WL_SPARE_MASK_8526           (BIT(6) | BIT(5) | BIT(3))
+
+#define PLL_LOCK_COUNTERS_REG        0xD8C
+#define PLL_LOCK_COUNTERS_COEX       0x0F
+#define PLL_LOCK_COUNTERS_MCS        0xF0
+#define MCS_PLL_OVERRIDE_REG         0xD90
+#define MCS_PLL_CONFIG_REG           0xD92
+#define MCS_SEL_IN_FREQ_MASK         0x0070
+#define MCS_SEL_IN_FREQ_SHIFT        4
+#define MCS_PLL_CONFIG_REG_VAL       0x73
+#define MCS_PLL_ENABLE_HP            (BIT(0) | BIT(1))
+
+#define MCS_PLL_M_REG                0xD94
+#define MCS_PLL_N_REG                0xD96
+#define MCS_PLL_M_REG_VAL            0xC8
+#define MCS_PLL_N_REG_VAL            0x07
+
+#define SDIO_IO_DS                   0xd14
+
+/* SDIO/wSPI DS configuration values */
+enum {
+	HCI_IO_DS_8MA = 0,
+	HCI_IO_DS_4MA = 1, /* default */
+	HCI_IO_DS_6MA = 2,
+	HCI_IO_DS_2MA = 3,
+};
 
-/*************************************************************************
-
-    Interrupt Trigger Register (Host -> WiLink)
-
-**************************************************************************/
-
-/* Hardware to Embedded CPU Interrupts - first 32-bit register set */
-
-/*
- * Host Command Interrupt. Setting this bit masks
- * the interrupt that the host issues to inform
- * the FW that it has sent a command
- * to the Wlan hardware Command Mailbox.
- */
-#define INTR_TRIG_CMD       BIT(0)
-
-/*
- * Host Event Acknowlegde Interrupt. The host
- * sets this bit to acknowledge that it received
- * the unsolicited information from the event
- * mailbox.
- */
-#define INTR_TRIG_EVENT_ACK BIT(1)
-
-/*
- * The host sets this bit to inform the Wlan
- * FW that a TX packet is in the XFER
- * Buffer #0.
- */
-#define INTR_TRIG_TX_PROC0 BIT(2)
-
-/*
- * The host sets this bit to inform the FW
- * that it read a packet from RX XFER
- * Buffer #0.
- */
-#define INTR_TRIG_RX_PROC0 BIT(3)
-
-#define INTR_TRIG_DEBUG_ACK BIT(4)
-
-#define INTR_TRIG_STATE_CHANGED BIT(5)
-
-
-/* Hardware to Embedded CPU Interrupts - second 32-bit register set */
+/* end PLL configuration algorithm for wl128x */
 
-/*
- * The host sets this bit to inform the FW
- * that it read a packet from RX XFER
- * Buffer #1.
- */
-#define INTR_TRIG_RX_PROC1 BIT(17)
+/*===============================================
+  HI_CFG Interface Configuration Register Values
+  ------------------------------------------
+  ===============================================*/
+#define HI_CFG_UART_ENABLE          0x00000004
+#define HI_CFG_RST232_ENABLE        0x00000008
+#define HI_CFG_CLOCK_REQ_SELECT     0x00000010
+#define HI_CFG_HOST_INT_ENABLE      0x00000020
+#define HI_CFG_VLYNQ_OUTPUT_ENABLE  0x00000040
+#define HI_CFG_HOST_INT_ACTIVE_LOW  0x00000080
+#define HI_CFG_UART_TX_OUT_GPIO_15  0x00000100
+#define HI_CFG_UART_TX_OUT_GPIO_14  0x00000200
+#define HI_CFG_UART_TX_OUT_GPIO_7   0x00000400
 
-/*
- * The host sets this bit to inform the Wlan
- * hardware that a TX packet is in the XFER
- * Buffer #1.
- */
-#define INTR_TRIG_TX_PROC1 BIT(18)
+#define HI_CFG_DEF_VAL              \
+	(HI_CFG_UART_ENABLE |        \
+	HI_CFG_RST232_ENABLE |      \
+	HI_CFG_CLOCK_REQ_SELECT |   \
+	HI_CFG_HOST_INT_ENABLE)
 
 #define WL127X_REG_FUSE_DATA_2_1	0x050a
 #define WL128X_REG_FUSE_DATA_2_1	0x2152
diff --git a/drivers/net/wireless/ti/wlcore/acx.c b/drivers/net/wireless/ti/wlcore/acx.c
index 43cc6a2..cba8af2 100644
--- a/drivers/net/wireless/ti/wlcore/acx.c
+++ b/drivers/net/wireless/ti/wlcore/acx.c
@@ -31,7 +31,6 @@
 #include "wlcore.h"
 #include "debug.h"
 #include "wl12xx_80211.h"
-#include "reg.h"
 #include "ps.h"
 
 int wl1271_acx_wake_up_conditions(struct wl1271 *wl, struct wl12xx_vif *wlvif,
diff --git a/drivers/net/wireless/ti/wlcore/boot.c b/drivers/net/wireless/ti/wlcore/boot.c
index da37c59..69409ec 100644
--- a/drivers/net/wireless/ti/wlcore/boot.c
+++ b/drivers/net/wireless/ti/wlcore/boot.c
@@ -27,22 +27,27 @@
 
 #include "debug.h"
 #include "acx.h"
-#include "reg.h"
 #include "boot.h"
 #include "io.h"
 #include "event.h"
 #include "rx.h"
 
+/*
+ * TODO: this is here just for now, it will be removed when we move
+ * the top_reg stuff to wl12xx
+ */
+#include "../wl12xx/reg.h"
+
 static void wl1271_boot_set_ecpu_ctrl(struct wl1271 *wl, u32 flag)
 {
 	u32 cpu_ctrl;
 
 	/* 10.5.0 run the firmware (I) */
-	cpu_ctrl = wl1271_read32(wl, ACX_REG_ECPU_CONTROL);
+	cpu_ctrl = wlcore_read_reg(wl, REG_ECPU_CONTROL);
 
 	/* 10.5.1 run the firmware (II) */
 	cpu_ctrl |= flag;
-	wl1271_write32(wl, ACX_REG_ECPU_CONTROL, cpu_ctrl);
+	wlcore_write_reg(wl, REG_ECPU_CONTROL, cpu_ctrl);
 }
 
 static unsigned int wl12xx_get_fw_ver_quirks(struct wl1271 *wl)
@@ -289,9 +294,10 @@ static int wl1271_boot_upload_nvs(struct wl1271 *wl)
 
 		/*
 		 * Due to our new wl1271_translate_reg_addr function,
-		 * we need to add the REGISTER_BASE to the destination
+		 * we need to add the register partition start address
+		 * to the destination
 		 */
-		dest_addr += REGISTERS_BASE;
+		dest_addr += wl->curr_part.reg.start;
 
 		/* We move our pointer to the data */
 		nvs_ptr += 3;
@@ -340,7 +346,8 @@ static int wl1271_boot_upload_nvs(struct wl1271 *wl)
 		return -ENOMEM;
 
 	/* And finally we upload the NVS tables */
-	wl1271_write(wl, CMD_MBOX_ADDRESS, nvs_aligned, nvs_len, false);
+	wlcore_write_data(wl, REG_CMD_MBOX_ADDRESS,
+			  nvs_aligned, nvs_len, false);
 
 	kfree(nvs_aligned);
 	return 0;
@@ -353,9 +360,9 @@ out_badnvs:
 static void wl1271_boot_enable_interrupts(struct wl1271 *wl)
 {
 	wl1271_enable_interrupts(wl);
-	wl1271_write32(wl, ACX_REG_INTERRUPT_MASK,
-		       WL1271_ACX_INTR_ALL & ~(WL1271_INTR_MASK));
-	wl1271_write32(wl, HI_CFG, HI_CFG_DEF_VAL);
+	wlcore_write_reg(wl, REG_INTERRUPT_MASK,
+			 WL1271_ACX_INTR_ALL & ~(WL1271_INTR_MASK));
+	wl1271_write32(wl, WL12XX_HI_CFG, HI_CFG_DEF_VAL);
 }
 
 static int wl1271_boot_soft_reset(struct wl1271 *wl)
@@ -364,12 +371,12 @@ static int wl1271_boot_soft_reset(struct wl1271 *wl)
 	u32 boot_data;
 
 	/* perform soft reset */
-	wl1271_write32(wl, ACX_REG_SLV_SOFT_RESET, ACX_SLV_SOFT_RESET_BIT);
+	wl1271_write32(wl, WL12XX_SLV_SOFT_RESET, ACX_SLV_SOFT_RESET_BIT);
 
 	/* SOFT_RESET is self clearing */
 	timeout = jiffies + usecs_to_jiffies(SOFT_RESET_MAX_TIME);
 	while (1) {
-		boot_data = wl1271_read32(wl, ACX_REG_SLV_SOFT_RESET);
+		boot_data = wl1271_read32(wl, WL12XX_SLV_SOFT_RESET);
 		wl1271_debug(DEBUG_BOOT, "soft reset bootdata 0x%x", boot_data);
 		if ((boot_data & ACX_SLV_SOFT_RESET_BIT) == 0)
 			break;
@@ -385,10 +392,10 @@ static int wl1271_boot_soft_reset(struct wl1271 *wl)
 	}
 
 	/* disable Rx/Tx */
-	wl1271_write32(wl, ENABLE, 0x0);
+	wl1271_write32(wl, WL12XX_ENABLE, 0x0);
 
 	/* disable auto calibration on start*/
-	wl1271_write32(wl, SPARE_A2, 0xffff);
+	wl1271_write32(wl, WL12XX_SPARE_A2, 0xffff);
 
 	return 0;
 }
@@ -400,7 +407,7 @@ static int wl1271_boot_run_firmware(struct wl1271 *wl)
 
 	wl1271_boot_set_ecpu_ctrl(wl, ECPU_CONTROL_HALT);
 
-	chip_id = wl1271_read32(wl, CHIP_ID_B);
+	chip_id = wlcore_read_reg(wl, REG_CHIP_ID_B);
 
 	wl1271_debug(DEBUG_BOOT, "chip id after firmware boot: 0x%x", chip_id);
 
@@ -413,7 +420,7 @@ static int wl1271_boot_run_firmware(struct wl1271 *wl)
 	loop = 0;
 	while (loop++ < INIT_LOOP) {
 		udelay(INIT_LOOP_DELAY);
-		intr = wl1271_read32(wl, ACX_REG_INTERRUPT_NO_CLEAR);
+		intr = wlcore_read_reg(wl, REG_INTERRUPT_NO_CLEAR);
 
 		if (intr == 0xffffffff) {
 			wl1271_error("error reading hardware complete "
@@ -422,8 +429,8 @@ static int wl1271_boot_run_firmware(struct wl1271 *wl)
 		}
 		/* check that ACX_INTR_INIT_COMPLETE is enabled */
 		else if (intr & WL1271_ACX_INTR_INIT_COMPLETE) {
-			wl1271_write32(wl, ACX_REG_INTERRUPT_ACK,
-				       WL1271_ACX_INTR_INIT_COMPLETE);
+			wlcore_write_reg(wl, REG_INTERRUPT_ACK,
+					 WL1271_ACX_INTR_INIT_COMPLETE);
 			break;
 		}
 	}
@@ -435,10 +442,10 @@ static int wl1271_boot_run_firmware(struct wl1271 *wl)
 	}
 
 	/* get hardware config command mail box */
-	wl->cmd_box_addr = wl1271_read32(wl, REG_COMMAND_MAILBOX_PTR);
+	wl->cmd_box_addr = wlcore_read_reg(wl, REG_COMMAND_MAILBOX_PTR);
 
 	/* get hardware config event mail box */
-	wl->event_box_addr = wl1271_read32(wl, REG_EVENT_MAILBOX_PTR);
+	wl->event_box_addr = wlcore_read_reg(wl, REG_EVENT_MAILBOX_PTR);
 
 	/* set the working partition to its "running" mode offset */
 	wlcore_set_partition(wl, &wl->ptable[PART_WORK]);
@@ -668,15 +675,15 @@ static int wl127x_boot_clk(struct wl1271 *wl)
 		wl1271_top_reg_write(wl, OCP_REG_CLK_POLARITY, val);
 	}
 
-	wl1271_write32(wl, PLL_PARAMETERS, clk);
+	wl1271_write32(wl, WL12XX_PLL_PARAMETERS, clk);
 
-	pause = wl1271_read32(wl, PLL_PARAMETERS);
+	pause = wl1271_read32(wl, WL12XX_PLL_PARAMETERS);
 
 	wl1271_debug(DEBUG_BOOT, "pause1 0x%x", pause);
 
 	pause &= ~(WU_COUNTER_PAUSE_VAL);
 	pause |= WU_COUNTER_PAUSE_VAL;
-	wl1271_write32(wl, WU_COUNTER_PAUSE, pause);
+	wl1271_write32(wl, WL12XX_WU_COUNTER_PAUSE, pause);
 
 	return 0;
 }
@@ -699,7 +706,7 @@ int wl1271_load_firmware(struct wl1271 *wl)
 	}
 
 	/* Continue the ELP wake up sequence */
-	wl1271_write32(wl, WELP_ARM_COMMAND, WELP_ARM_COMMAND_VAL);
+	wl1271_write32(wl, WL12XX_WELP_ARM_COMMAND, WELP_ARM_COMMAND_VAL);
 	udelay(500);
 
 	wlcore_set_partition(wl, &wl->ptable[PART_DRPW]);
@@ -708,8 +715,7 @@ int wl1271_load_firmware(struct wl1271 *wl)
 	   to be used by DRPw FW. The RTRIM value will be added by the FW
 	   before taking DRPw out of reset */
 
-	wl1271_debug(DEBUG_BOOT, "DRPW_SCRATCH_START %08x", DRPW_SCRATCH_START);
-	clk = wl1271_read32(wl, DRPW_SCRATCH_START);
+	clk = wl1271_read32(wl, WL12XX_DRPW_SCRATCH_START);
 
 	wl1271_debug(DEBUG_BOOT, "clk2 0x%x", clk);
 
@@ -719,12 +725,12 @@ int wl1271_load_firmware(struct wl1271 *wl)
 		clk |= (wl->ref_clock << 1) << 4;
 	}
 
-	wl1271_write32(wl, DRPW_SCRATCH_START, clk);
+	wl1271_write32(wl, WL12XX_DRPW_SCRATCH_START, clk);
 
 	wlcore_set_partition(wl, &wl->ptable[PART_WORK]);
 
 	/* Disable interrupts */
-	wl1271_write32(wl, ACX_REG_INTERRUPT_MASK, WL1271_ACX_INTR_ALL);
+	wlcore_write_reg(wl, REG_INTERRUPT_MASK, WL1271_ACX_INTR_ALL);
 
 	ret = wl1271_boot_soft_reset(wl);
 	if (ret < 0)
@@ -739,20 +745,20 @@ int wl1271_load_firmware(struct wl1271 *wl)
 	 * ACX_EEPROMLESS_IND_REG */
 	wl1271_debug(DEBUG_BOOT, "ACX_EEPROMLESS_IND_REG");
 
-	wl1271_write32(wl, ACX_EEPROMLESS_IND_REG, ACX_EEPROMLESS_IND_REG);
+	wl1271_write32(wl, WL12XX_EEPROMLESS_IND, WL12XX_EEPROMLESS_IND);
 
-	tmp = wl1271_read32(wl, CHIP_ID_B);
+	tmp = wlcore_read_reg(wl, REG_CHIP_ID_B);
 
 	wl1271_debug(DEBUG_BOOT, "chip id 0x%x", tmp);
 
 	/* 6. read the EEPROM parameters */
-	tmp = wl1271_read32(wl, SCR_PAD2);
+	tmp = wl1271_read32(wl, WL12XX_SCR_PAD2);
 
 	/* WL1271: The reference driver skips steps 7 to 10 (jumps directly
 	 * to upload_fw) */
 
 	if (wl->chip.id == CHIP_ID_1283_PG20)
-		wl1271_top_reg_write(wl, SDIO_IO_DS, wl->conf.hci_io_ds);
+		wl1271_top_reg_write(wl, SDIO_IO_DS, HCI_IO_DS_6MA);
 
 	ret = wl1271_boot_upload_firmware(wl);
 	if (ret < 0)
@@ -781,8 +787,7 @@ int wl1271_boot(struct wl1271 *wl)
 	if (ret < 0)
 		goto out;
 
-	wl1271_write32(wl, ACX_REG_INTERRUPT_MASK,
-		       WL1271_ACX_ALL_EVENTS_VECTOR);
+	wlcore_write_reg(wl, REG_INTERRUPT_MASK, WL1271_ACX_ALL_EVENTS_VECTOR);
 
 	/* Enable firmware interrupts now */
 	wl1271_boot_enable_interrupts(wl);
diff --git a/drivers/net/wireless/ti/wlcore/boot.h b/drivers/net/wireless/ti/wlcore/boot.h
index a39e0e2..842ae3f 100644
--- a/drivers/net/wireless/ti/wlcore/boot.h
+++ b/drivers/net/wireless/ti/wlcore/boot.h
@@ -50,71 +50,4 @@ struct wl1271_static_data {
 #define WU_COUNTER_PAUSE_VAL 0x3FF
 #define WELP_ARM_COMMAND_VAL 0x4
 
-#define OCP_REG_POLARITY     0x0064
-#define OCP_REG_CLK_TYPE     0x0448
-#define OCP_REG_CLK_POLARITY 0x0cb2
-#define OCP_REG_CLK_PULL     0x0cb4
-
-#define CMD_MBOX_ADDRESS     0x407B4
-
-#define POLARITY_LOW         BIT(1)
-#define NO_PULL              (BIT(14) | BIT(15))
-
-#define FREF_CLK_TYPE_BITS     0xfffffe7f
-#define CLK_REQ_PRCM           0x100
-#define FREF_CLK_POLARITY_BITS 0xfffff8ff
-#define CLK_REQ_OUTN_SEL       0x700
-
-/* PLL configuration algorithm for wl128x */
-#define SYS_CLK_CFG_REG              0x2200
-/* Bit[0]   -  0-TCXO,  1-FREF */
-#define MCS_PLL_CLK_SEL_FREF         BIT(0)
-/* Bit[3:2] - 01-TCXO, 10-FREF */
-#define WL_CLK_REQ_TYPE_FREF         BIT(3)
-#define WL_CLK_REQ_TYPE_PG2          (BIT(3) | BIT(2))
-/* Bit[4]   -  0-TCXO,  1-FREF */
-#define PRCM_CM_EN_MUX_WLAN_FREF     BIT(4)
-
-#define TCXO_ILOAD_INT_REG           0x2264
-#define TCXO_CLK_DETECT_REG          0x2266
-
-#define TCXO_DET_FAILED              BIT(4)
-
-#define FREF_ILOAD_INT_REG           0x2084
-#define FREF_CLK_DETECT_REG          0x2086
-#define FREF_CLK_DETECT_FAIL         BIT(4)
-
-/* Use this reg for masking during driver access */
-#define WL_SPARE_REG                 0x2320
-#define WL_SPARE_VAL                 BIT(2)
-/* Bit[6:5:3] -  mask wl write SYS_CLK_CFG[8:5:2:4] */
-#define WL_SPARE_MASK_8526           (BIT(6) | BIT(5) | BIT(3))
-
-#define PLL_LOCK_COUNTERS_REG        0xD8C
-#define PLL_LOCK_COUNTERS_COEX       0x0F
-#define PLL_LOCK_COUNTERS_MCS        0xF0
-#define MCS_PLL_OVERRIDE_REG         0xD90
-#define MCS_PLL_CONFIG_REG           0xD92
-#define MCS_SEL_IN_FREQ_MASK         0x0070
-#define MCS_SEL_IN_FREQ_SHIFT        4
-#define MCS_PLL_CONFIG_REG_VAL       0x73
-#define MCS_PLL_ENABLE_HP            (BIT(0) | BIT(1))
-
-#define MCS_PLL_M_REG                0xD94
-#define MCS_PLL_N_REG                0xD96
-#define MCS_PLL_M_REG_VAL            0xC8
-#define MCS_PLL_N_REG_VAL            0x07
-
-#define SDIO_IO_DS                   0xd14
-
-/* SDIO/wSPI DS configuration values */
-enum {
-	HCI_IO_DS_8MA = 0,
-	HCI_IO_DS_4MA = 1, /* default */
-	HCI_IO_DS_6MA = 2,
-	HCI_IO_DS_2MA = 3,
-};
-
-/* end PLL configuration algorithm for wl128x */
-
 #endif
diff --git a/drivers/net/wireless/ti/wlcore/cmd.c b/drivers/net/wireless/ti/wlcore/cmd.c
index 68e686f..3ec86e9 100644
--- a/drivers/net/wireless/ti/wlcore/cmd.c
+++ b/drivers/net/wireless/ti/wlcore/cmd.c
@@ -30,7 +30,6 @@
 
 #include "wlcore.h"
 #include "debug.h"
-#include "reg.h"
 #include "io.h"
 #include "acx.h"
 #include "wl12xx_80211.h"
@@ -67,11 +66,11 @@ int wl1271_cmd_send(struct wl1271 *wl, u16 id, void *buf, size_t len,
 
 	wl1271_write(wl, wl->cmd_box_addr, buf, len, false);
 
-	wl1271_write32(wl, ACX_REG_INTERRUPT_TRIG, INTR_TRIG_CMD);
+	wlcore_write_reg(wl, REG_INTERRUPT_TRIG, INTR_TRIG_CMD);
 
 	timeout = jiffies + msecs_to_jiffies(WL1271_COMMAND_TIMEOUT);
 
-	intr = wl1271_read32(wl, ACX_REG_INTERRUPT_NO_CLEAR);
+	intr = wlcore_read_reg(wl, REG_INTERRUPT_NO_CLEAR);
 	while (!(intr & WL1271_ACX_INTR_CMD_COMPLETE)) {
 		if (time_after(jiffies, timeout)) {
 			wl1271_error("command complete timeout");
@@ -85,7 +84,7 @@ int wl1271_cmd_send(struct wl1271 *wl, u16 id, void *buf, size_t len,
 		else
 			msleep(1);
 
-		intr = wl1271_read32(wl, ACX_REG_INTERRUPT_NO_CLEAR);
+		intr = wlcore_read_reg(wl, REG_INTERRUPT_NO_CLEAR);
 	}
 
 	/* read back the status code of the command */
@@ -100,8 +99,7 @@ int wl1271_cmd_send(struct wl1271 *wl, u16 id, void *buf, size_t len,
 		goto fail;
 	}
 
-	wl1271_write32(wl, ACX_REG_INTERRUPT_ACK,
-		       WL1271_ACX_INTR_CMD_COMPLETE);
+	wlcore_write_reg(wl, REG_INTERRUPT_ACK, WL1271_ACX_INTR_CMD_COMPLETE);
 	return 0;
 
 fail:
@@ -529,7 +527,7 @@ static int wl12xx_cmd_role_start_dev(struct wl1271 *wl,
 
 	cmd->role_id = wlvif->dev_role_id;
 	if (wlvif->band == IEEE80211_BAND_5GHZ)
-		cmd->band = WL12XX_BAND_5GHZ;
+		cmd->band = WLCORE_BAND_5GHZ;
 	cmd->channel = wlvif->channel;
 
 	if (wlvif->dev_hlid == WL12XX_INVALID_LINK_ID) {
@@ -620,7 +618,7 @@ int wl12xx_cmd_role_start_sta(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 
 	cmd->role_id = wlvif->role_id;
 	if (wlvif->band == IEEE80211_BAND_5GHZ)
-		cmd->band = WL12XX_BAND_5GHZ;
+		cmd->band = WLCORE_BAND_5GHZ;
 	cmd->channel = wlvif->channel;
 	cmd->sta.basic_rate_set = cpu_to_le32(wlvif->basic_rate_set);
 	cmd->sta.beacon_interval = cpu_to_le16(wlvif->beacon_int);
@@ -757,14 +755,14 @@ int wl12xx_cmd_role_start_ap(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 
 	switch (wlvif->band) {
 	case IEEE80211_BAND_2GHZ:
-		cmd->band = RADIO_BAND_2_4GHZ;
+		cmd->band = WLCORE_BAND_2_4GHZ;
 		break;
 	case IEEE80211_BAND_5GHZ:
-		cmd->band = RADIO_BAND_5GHZ;
+		cmd->band = WLCORE_BAND_5GHZ;
 		break;
 	default:
 		wl1271_warning("ap start - unknown band: %d", (int)wlvif->band);
-		cmd->band = RADIO_BAND_2_4GHZ;
+		cmd->band = WLCORE_BAND_2_4GHZ;
 		break;
 	}
 
@@ -837,7 +835,7 @@ int wl12xx_cmd_role_start_ibss(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 
 	cmd->role_id = wlvif->role_id;
 	if (wlvif->band == IEEE80211_BAND_5GHZ)
-		cmd->band = WL12XX_BAND_5GHZ;
+		cmd->band = WLCORE_BAND_5GHZ;
 	cmd->channel = wlvif->channel;
 	cmd->ibss.basic_rate_set = cpu_to_le32(wlvif->basic_rate_set);
 	cmd->ibss.beacon_interval = cpu_to_le16(wlvif->beacon_int);
@@ -1737,10 +1735,10 @@ static int wl12xx_cmd_roc(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 	cmd->channel = wlvif->channel;
 	switch (wlvif->band) {
 	case IEEE80211_BAND_2GHZ:
-		cmd->band = RADIO_BAND_2_4GHZ;
+		cmd->band = WLCORE_BAND_2_4GHZ;
 		break;
 	case IEEE80211_BAND_5GHZ:
-		cmd->band = RADIO_BAND_5GHZ;
+		cmd->band = WLCORE_BAND_5GHZ;
 		break;
 	default:
 		wl1271_error("roc - unknown band: %d", (int)wlvif->band);
diff --git a/drivers/net/wireless/ti/wlcore/cmd.h b/drivers/net/wireless/ti/wlcore/cmd.h
index 58d2a8b..cd1eb2e 100644
--- a/drivers/net/wireless/ti/wlcore/cmd.h
+++ b/drivers/net/wireless/ti/wlcore/cmd.h
@@ -262,13 +262,13 @@ struct wl12xx_cmd_role_disable {
 	u8 padding[3];
 } __packed;
 
-enum wl12xx_band {
-	WL12XX_BAND_2_4GHZ		= 0,
-	WL12XX_BAND_5GHZ		= 1,
-	WL12XX_BAND_JAPAN_4_9_GHZ	= 2,
-	WL12XX_BAND_DEFAULT		= WL12XX_BAND_2_4GHZ,
-	WL12XX_BAND_INVALID		= 0x7E,
-	WL12XX_BAND_MAX_RADIO		= 0x7F,
+enum wlcore_band {
+	WLCORE_BAND_2_4GHZ		= 0,
+	WLCORE_BAND_5GHZ		= 1,
+	WLCORE_BAND_JAPAN_4_9_GHZ	= 2,
+	WLCORE_BAND_DEFAULT		= WLCORE_BAND_2_4GHZ,
+	WLCORE_BAND_INVALID		= 0x7E,
+	WLCORE_BAND_MAX_RADIO		= 0x7F,
 };
 
 struct wl12xx_cmd_role_start {
diff --git a/drivers/net/wireless/ti/wlcore/conf.h b/drivers/net/wireless/ti/wlcore/conf.h
index 5d2a9e0..3bdb1be 100644
--- a/drivers/net/wireless/ti/wlcore/conf.h
+++ b/drivers/net/wireless/ti/wlcore/conf.h
@@ -1320,7 +1320,6 @@ struct conf_drv_settings {
 	struct conf_fwlog fwlog;
 	struct conf_rate_policy_settings rate;
 	struct conf_hangover_settings hangover;
-	u8 hci_io_ds;
 };
 
 #endif
diff --git a/drivers/net/wireless/ti/wlcore/event.c b/drivers/net/wireless/ti/wlcore/event.c
index 8d79af9..078cb01 100644
--- a/drivers/net/wireless/ti/wlcore/event.c
+++ b/drivers/net/wireless/ti/wlcore/event.c
@@ -23,7 +23,6 @@
 
 #include "wlcore.h"
 #include "debug.h"
-#include "reg.h"
 #include "io.h"
 #include "event.h"
 #include "ps.h"
@@ -281,7 +280,7 @@ int wl1271_event_unmask(struct wl1271 *wl)
 
 void wl1271_event_mbox_config(struct wl1271 *wl)
 {
-	wl->mbox_ptr[0] = wl1271_read32(wl, REG_EVENT_MAILBOX_PTR);
+	wl->mbox_ptr[0] = wlcore_read_reg(wl, REG_EVENT_MAILBOX_PTR);
 	wl->mbox_ptr[1] = wl->mbox_ptr[0] + sizeof(struct event_mailbox);
 
 	wl1271_debug(DEBUG_EVENT, "MBOX ptrs: 0x%x 0x%x",
@@ -307,7 +306,7 @@ int wl1271_event_handle(struct wl1271 *wl, u8 mbox_num)
 		return ret;
 
 	/* then we let the firmware know it can go on...*/
-	wl1271_write32(wl, ACX_REG_INTERRUPT_TRIG, INTR_TRIG_EVENT_ACK);
+	wlcore_write_reg(wl, REG_INTERRUPT_TRIG, INTR_TRIG_EVENT_ACK);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/ti/wlcore/init.c b/drivers/net/wireless/ti/wlcore/init.c
index 203fbeb..f3b6067 100644
--- a/drivers/net/wireless/ti/wlcore/init.c
+++ b/drivers/net/wireless/ti/wlcore/init.c
@@ -30,7 +30,6 @@
 #include "wl12xx_80211.h"
 #include "acx.h"
 #include "cmd.h"
-#include "reg.h"
 #include "tx.h"
 #include "io.h"
 
diff --git a/drivers/net/wireless/ti/wlcore/io.c b/drivers/net/wireless/ti/wlcore/io.c
index 65c562c..30c60e3 100644
--- a/drivers/net/wireless/ti/wlcore/io.c
+++ b/drivers/net/wireless/ti/wlcore/io.c
@@ -32,18 +32,11 @@
 #include "io.h"
 #include "tx.h"
 
-#define OCP_CMD_LOOP  32
-
-#define OCP_CMD_WRITE 0x1
-#define OCP_CMD_READ  0x2
-
-#define OCP_READY_MASK  BIT(18)
-#define OCP_STATUS_MASK (BIT(16) | BIT(17))
-
-#define OCP_STATUS_NO_RESP    0x00000
-#define OCP_STATUS_OK         0x10000
-#define OCP_STATUS_REQ_FAILED 0x20000
-#define OCP_STATUS_RESP_ERROR 0x30000
+/*
+ * TODO: this is here just for now, it will be removed when we move
+ * the top_reg stuff to wl12xx
+ */
+#include "../wl12xx/reg.h"
 
 bool wl1271_set_block_size(struct wl1271 *wl)
 {
@@ -187,13 +180,13 @@ void wl1271_top_reg_write(struct wl1271 *wl, int addr, u16 val)
 {
 	/* write address >> 1 + 0x30000 to OCP_POR_CTR */
 	addr = (addr >> 1) + 0x30000;
-	wl1271_write32(wl, OCP_POR_CTR, addr);
+	wl1271_write32(wl, WL12XX_OCP_POR_CTR, addr);
 
 	/* write value to OCP_POR_WDATA */
-	wl1271_write32(wl, OCP_DATA_WRITE, val);
+	wl1271_write32(wl, WL12XX_OCP_DATA_WRITE, val);
 
 	/* write 1 to OCP_CMD */
-	wl1271_write32(wl, OCP_CMD, OCP_CMD_WRITE);
+	wl1271_write32(wl, WL12XX_OCP_CMD, OCP_CMD_WRITE);
 }
 
 u16 wl1271_top_reg_read(struct wl1271 *wl, int addr)
@@ -203,14 +196,14 @@ u16 wl1271_top_reg_read(struct wl1271 *wl, int addr)
 
 	/* write address >> 1 + 0x30000 to OCP_POR_CTR */
 	addr = (addr >> 1) + 0x30000;
-	wl1271_write32(wl, OCP_POR_CTR, addr);
+	wl1271_write32(wl, WL12XX_OCP_POR_CTR, addr);
 
 	/* write 2 to OCP_CMD */
-	wl1271_write32(wl, OCP_CMD, OCP_CMD_READ);
+	wl1271_write32(wl, WL12XX_OCP_CMD, OCP_CMD_READ);
 
 	/* poll for data ready */
 	do {
-		val = wl1271_read32(wl, OCP_DATA_READ);
+		val = wl1271_read32(wl, WL12XX_OCP_DATA_READ);
 	} while (!(val & OCP_READY_MASK) && --timeout);
 
 	if (!timeout) {
diff --git a/drivers/net/wireless/ti/wlcore/io.h b/drivers/net/wireless/ti/wlcore/io.h
index 495ab33..c5ca3c8 100644
--- a/drivers/net/wireless/ti/wlcore/io.h
+++ b/drivers/net/wireless/ti/wlcore/io.h
@@ -26,7 +26,6 @@
 #define __IO_H__
 
 #include <linux/irqreturn.h>
-#include "reg.h"
 
 #define HW_ACCESS_MEMORY_MAX_RANGE	0x1FFC0
 
@@ -65,6 +64,18 @@ static inline void wl1271_raw_read(struct wl1271 *wl, int addr, void *buf,
 	wl->if_ops->read(wl->dev, addr, buf, len, fixed);
 }
 
+static inline void wlcore_raw_read_data(struct wl1271 *wl, int reg, void *buf,
+					size_t len, bool fixed)
+{
+	wl1271_raw_read(wl, wl->rtable[reg], buf, len, fixed);
+}
+
+static inline void wlcore_raw_write_data(struct wl1271 *wl, int reg, void *buf,
+					 size_t len, bool fixed)
+{
+	wl1271_raw_write(wl, wl->rtable[reg], buf, len, fixed);
+}
+
 static inline u32 wl1271_raw_read32(struct wl1271 *wl, int addr)
 {
 	wl1271_raw_read(wl, addr, &wl->buffer_32,
@@ -100,6 +111,18 @@ static inline void wl1271_write(struct wl1271 *wl, int addr, void *buf,
 	wl1271_raw_write(wl, physical, buf, len, fixed);
 }
 
+static inline void wlcore_write_data(struct wl1271 *wl, int reg, void *buf,
+				     size_t len, bool fixed)
+{
+	wl1271_write(wl, wl->rtable[reg], buf, len, fixed);
+}
+
+static inline void wlcore_read_data(struct wl1271 *wl, int reg, void *buf,
+				    size_t len, bool fixed)
+{
+	wl1271_read(wl, wl->rtable[reg], buf, len, fixed);
+}
+
 static inline void wl1271_read_hwaddr(struct wl1271 *wl, int hwaddr,
 				      void *buf, size_t len, bool fixed)
 {
@@ -124,6 +147,17 @@ static inline void wl1271_write32(struct wl1271 *wl, int addr, u32 val)
 	wl1271_raw_write32(wl, wlcore_translate_addr(wl, addr), val);
 }
 
+static inline u32 wlcore_read_reg(struct wl1271 *wl, int reg)
+{
+	return wl1271_raw_read32(wl,
+				 wlcore_translate_addr(wl, wl->rtable[reg]));
+}
+
+static inline void wlcore_write_reg(struct wl1271 *wl, int reg, u32 val)
+{
+	wl1271_raw_write32(wl, wlcore_translate_addr(wl, wl->rtable[reg]), val);
+}
+
 static inline void wl1271_power_off(struct wl1271 *wl)
 {
 	wl->if_ops->power(wl->dev, false);
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 30d47b2..d3fde0a 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -38,7 +38,6 @@
 #include "wlcore.h"
 #include "debug.h"
 #include "wl12xx_80211.h"
-#include "reg.h"
 #include "io.h"
 #include "event.h"
 #include "tx.h"
@@ -51,6 +50,9 @@
 #include "testmode.h"
 #include "scan.h"
 
+/* TODO: remove this once the FUSE definitions are separated */
+#include "../wl12xx/reg.h"
+
 #define WL1271_BOOT_RETRIES 3
 
 static struct conf_drv_settings default_conf = {
@@ -354,7 +356,6 @@ static struct conf_drv_settings default_conf = {
 		.output                       = WL12XX_FWLOG_OUTPUT_HOST,
 		.threshold                    = 0,
 	},
-	.hci_io_ds = HCI_IO_DS_6MA,
 	.rate = {
 		.rate_retry_score = 32000,
 		.per_add = 8192,
@@ -796,7 +797,8 @@ static void wl12xx_fw_status(struct wl1271 *wl,
 	int avail, freed_blocks;
 	int i;
 
-	wl1271_raw_read(wl, FW_STATUS_ADDR, status, sizeof(*status), false);
+	wlcore_raw_read_data(wl, REG_RAW_FW_STATUS_ADDR, status,
+			     sizeof(*status), false);
 
 	wl1271_debug(DEBUG_IRQ, "intr: 0x%x (fw_rx_counter = %d, "
 		     "drv_rx_counter = %d, tx_results_counter = %d)",
@@ -1246,7 +1248,8 @@ static void wl1271_recovery_work(struct work_struct *work)
 	wl12xx_read_fwlog_panic(wl);
 
 	wl1271_info("Hardware recovery in progress. FW ver: %s pc: 0x%x",
-		    wl->chip.fw_ver_str, wl1271_read32(wl, SCR_PAD4));
+		    wl->chip.fw_ver_str,
+		    wlcore_read_reg(wl, REG_PC_ON_RECOVERY));
 
 	BUG_ON(bug_on_recovery &&
 	       !test_bit(WL1271_FLAG_INTENDED_FW_RECOVERY, &wl->flags));
@@ -1297,10 +1300,7 @@ out_unlock:
 
 static void wl1271_fw_wakeup(struct wl1271 *wl)
 {
-	u32 elp_reg;
-
-	elp_reg = ELPCTRL_WAKE_UP;
-	wl1271_raw_write32(wl, HW_ACCESS_ELP_CTRL_REG_ADDR, elp_reg);
+	wl1271_raw_write32(wl, HW_ACCESS_ELP_CTRL_REG, ELPCTRL_WAKE_UP);
 }
 
 static int wl1271_setup(struct wl1271 *wl)
@@ -1330,7 +1330,7 @@ static int wl12xx_set_power_on(struct wl1271 *wl)
 	wl1271_io_reset(wl);
 	wl1271_io_init(wl);
 
-	wlcore_set_partition(wl, &wl->ptable[PART_DOWN]);
+	wlcore_set_partition(wl, &wl->ptable[PART_BOOT]);
 
 	/* ELP module wake up */
 	wl1271_fw_wakeup(wl);
@@ -5107,22 +5107,25 @@ static int wl12xx_get_hw_info(struct wl1271 *wl)
 	if (ret < 0)
 		goto out;
 
-	wl->chip.id = wl1271_read32(wl, CHIP_ID_B);
+	wl->chip.id = wlcore_read_reg(wl, REG_CHIP_ID_B);
+
+	wl->fuse_oui_addr = 0;
+	wl->fuse_nic_addr = 0;
 
+	/* TODO: properly detect PG ver and read MAC addr in other families */
 	if (wl->chip.id == CHIP_ID_1283_PG20)
 		die_info = wl1271_top_reg_read(wl, WL128X_REG_FUSE_DATA_2_1);
-	else
+	else if (wl->chip.id < CHIP_ID_1283_PG20)
 		die_info = wl1271_top_reg_read(wl, WL127X_REG_FUSE_DATA_2_1);
+	else
+		goto skip_mac;
 
 	wl->hw_pg_ver = (s8) (die_info & PG_VER_MASK) >> PG_VER_OFFSET;
 
-	if (!wl12xx_mac_in_fuse(wl)) {
-		wl->fuse_oui_addr = 0;
-		wl->fuse_nic_addr = 0;
-	} else {
+	if (wl12xx_mac_in_fuse(wl))
 		wl12xx_get_fuse_mac(wl);
-	}
 
+skip_mac:
 	wl1271_power_off(wl);
 out:
 	return ret;
diff --git a/drivers/net/wireless/ti/wlcore/ps.c b/drivers/net/wireless/ti/wlcore/ps.c
index 78f598b..cfeb114 100644
--- a/drivers/net/wireless/ti/wlcore/ps.c
+++ b/drivers/net/wireless/ti/wlcore/ps.c
@@ -21,7 +21,6 @@
  *
  */
 
-#include "reg.h"
 #include "ps.h"
 #include "io.h"
 #include "tx.h"
@@ -62,7 +61,7 @@ void wl1271_elp_work(struct work_struct *work)
 	}
 
 	wl1271_debug(DEBUG_PSM, "chip to elp");
-	wl1271_raw_write32(wl, HW_ACCESS_ELP_CTRL_REG_ADDR, ELPCTRL_SLEEP);
+	wl1271_raw_write32(wl, HW_ACCESS_ELP_CTRL_REG, ELPCTRL_SLEEP);
 	set_bit(WL1271_FLAG_IN_ELP, &wl->flags);
 
 out:
@@ -125,7 +124,7 @@ int wl1271_ps_elp_wakeup(struct wl1271 *wl)
 		wl->elp_compl = &compl;
 	spin_unlock_irqrestore(&wl->wl_lock, flags);
 
-	wl1271_raw_write32(wl, HW_ACCESS_ELP_CTRL_REG_ADDR, ELPCTRL_WAKE_UP);
+	wl1271_raw_write32(wl, HW_ACCESS_ELP_CTRL_REG, ELPCTRL_WAKE_UP);
 
 	if (!pending) {
 		ret = wait_for_completion_timeout(
diff --git a/drivers/net/wireless/ti/wlcore/rx.c b/drivers/net/wireless/ti/wlcore/rx.c
index 4fc37f9..d7fab46 100644
--- a/drivers/net/wireless/ti/wlcore/rx.c
+++ b/drivers/net/wireless/ti/wlcore/rx.c
@@ -27,11 +27,16 @@
 #include "wlcore.h"
 #include "debug.h"
 #include "acx.h"
-#include "reg.h"
 #include "rx.h"
 #include "tx.h"
 #include "io.h"
 
+/*
+ * TODO: this is here just for now, it must be removed when the data
+ * operations are in place.
+ */
+#include "../wl12xx/reg.h"
+
 static u8 wl12xx_rx_get_mem_block(struct wl12xx_fw_status *status,
 				  u32 drv_rx_counter)
 {
@@ -231,14 +236,14 @@ void wl12xx_rx(struct wl1271 *wl, struct wl12xx_fw_status *status)
 			wl->rx_mem_pool_addr.addr_extra =
 				wl->rx_mem_pool_addr.addr + 4;
 
-			wl1271_write(wl, WL1271_SLV_REG_DATA,
-				     &wl->rx_mem_pool_addr,
-				     sizeof(wl->rx_mem_pool_addr), false);
+			wlcore_write_data(wl, REG_SLV_REG_DATA,
+					  &wl->rx_mem_pool_addr,
+					  sizeof(wl->rx_mem_pool_addr), false);
 		}
 
 		/* Read all available packets at once */
-		wl1271_read(wl, WL1271_SLV_MEM_DATA, wl->aggr_buf,
-				buf_size, true);
+		wlcore_read_data(wl, REG_SLV_MEM_DATA, wl->aggr_buf,
+				 buf_size, true);
 
 		/* Split data into separate packets */
 		pkt_offset = 0;
@@ -278,7 +283,8 @@ void wl12xx_rx(struct wl1271 *wl, struct wl12xx_fw_status *status)
 	 * for older hardware revisions
 	 */
 	if (wl->quirks & WL12XX_QUIRK_END_OF_TRANSACTION)
-		wl1271_write32(wl, RX_DRIVER_COUNTER_ADDRESS, wl->rx_counter);
+		wl1271_write32(wl, WL12XX_REG_RX_DRIVER_COUNTER,
+			       wl->rx_counter);
 
 	wl12xx_rearm_rx_streaming(wl, active_hlids);
 }
diff --git a/drivers/net/wireless/ti/wlcore/sdio.c b/drivers/net/wireless/ti/wlcore/sdio.c
index e407acf..0a72347 100644
--- a/drivers/net/wireless/ti/wlcore/sdio.c
+++ b/drivers/net/wireless/ti/wlcore/sdio.c
@@ -76,7 +76,7 @@ static void wl12xx_sdio_raw_read(struct device *child, int addr, void *buf,
 
 	sdio_claim_host(func);
 
-	if (unlikely(addr == HW_ACCESS_ELP_CTRL_REG_ADDR)) {
+	if (unlikely(addr == HW_ACCESS_ELP_CTRL_REG)) {
 		((u8 *)buf)[0] = sdio_f0_readb(func, addr, &ret);
 		dev_dbg(child->parent, "sdio read 52 addr 0x%x, byte 0x%02x\n",
 			addr, ((u8 *)buf)[0]);
@@ -105,7 +105,7 @@ static void wl12xx_sdio_raw_write(struct device *child, int addr, void *buf,
 
 	sdio_claim_host(func);
 
-	if (unlikely(addr == HW_ACCESS_ELP_CTRL_REG_ADDR)) {
+	if (unlikely(addr == HW_ACCESS_ELP_CTRL_REG)) {
 		sdio_f0_writeb(func, ((u8 *)buf)[0], addr, &ret);
 		dev_dbg(child->parent, "sdio write 52 addr 0x%x, byte 0x%02x\n",
 			addr, ((u8 *)buf)[0]);
diff --git a/drivers/net/wireless/ti/wlcore/spi.c b/drivers/net/wireless/ti/wlcore/spi.c
index 9eeb394..553cd3c 100644
--- a/drivers/net/wireless/ti/wlcore/spi.c
+++ b/drivers/net/wireless/ti/wlcore/spi.c
@@ -34,8 +34,6 @@
 #include "wl12xx_80211.h"
 #include "io.h"
 
-#include "reg.h"
-
 #define WSPI_CMD_READ                 0x40000000
 #define WSPI_CMD_WRITE                0x00000000
 #define WSPI_CMD_FIXED                0x20000000
diff --git a/drivers/net/wireless/ti/wlcore/testmode.c b/drivers/net/wireless/ti/wlcore/testmode.c
index 2ea4013..9cda706 100644
--- a/drivers/net/wireless/ti/wlcore/testmode.c
+++ b/drivers/net/wireless/ti/wlcore/testmode.c
@@ -28,7 +28,6 @@
 #include "wlcore.h"
 #include "debug.h"
 #include "acx.h"
-#include "reg.h"
 #include "ps.h"
 #include "io.h"
 
diff --git a/drivers/net/wireless/ti/wlcore/tx.c b/drivers/net/wireless/ti/wlcore/tx.c
index 83cb83c..4e90c07 100644
--- a/drivers/net/wireless/ti/wlcore/tx.c
+++ b/drivers/net/wireless/ti/wlcore/tx.c
@@ -28,11 +28,16 @@
 #include "wlcore.h"
 #include "debug.h"
 #include "io.h"
-#include "reg.h"
 #include "ps.h"
 #include "tx.h"
 #include "event.h"
 
+/*
+ * TODO: this is here just for now, it must be removed when the data
+ * operations are in place.
+ */
+#include "../wl12xx/reg.h"
+
 static int wl1271_set_default_wep_key(struct wl1271 *wl,
 				      struct wl12xx_vif *wlvif, u8 id)
 {
@@ -718,8 +723,8 @@ void wl1271_tx_work_locked(struct wl1271 *wl)
 			 * Flush buffer and try again.
 			 */
 			wl1271_skb_queue_head(wl, wlvif, skb);
-			wl1271_write(wl, WL1271_SLV_MEM_DATA, wl->aggr_buf,
-				     buf_offset, true);
+			wlcore_write_data(wl, REG_SLV_MEM_DATA, wl->aggr_buf,
+					  buf_offset, true);
 			sent_packets = true;
 			buf_offset = 0;
 			continue;
@@ -753,8 +758,8 @@ void wl1271_tx_work_locked(struct wl1271 *wl)
 
 out_ack:
 	if (buf_offset) {
-		wl1271_write(wl, WL1271_SLV_MEM_DATA, wl->aggr_buf,
-				buf_offset, true);
+		wlcore_write_data(wl, REG_SLV_MEM_DATA, wl->aggr_buf,
+				  buf_offset, true);
 		sent_packets = true;
 	}
 	if (sent_packets) {
@@ -763,7 +768,7 @@ out_ack:
 		 * required for older hardware revisions
 		 */
 		if (wl->quirks & WL12XX_QUIRK_END_OF_TRANSACTION)
-			wl1271_write32(wl, WL1271_HOST_WR_ACCESS,
+			wl1271_write32(wl, WL12XX_HOST_WR_ACCESS,
 				       wl->tx_packets_count);
 
 		wl1271_handle_tx_low_watermark(wl);
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index 84f05a4..f11e5c6 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -53,6 +53,29 @@ struct wlcore_partition_set {
 	struct wlcore_partition mem3;
 };
 
+enum wlcore_registers {
+	/* register addresses, used with partition translation */
+	REG_ECPU_CONTROL,
+	REG_INTERRUPT_NO_CLEAR,
+	REG_INTERRUPT_ACK,
+	REG_COMMAND_MAILBOX_PTR,
+	REG_EVENT_MAILBOX_PTR,
+	REG_INTERRUPT_TRIG,
+	REG_INTERRUPT_MASK,
+	REG_PC_ON_RECOVERY,
+	REG_CHIP_ID_B,
+	REG_CMD_MBOX_ADDRESS,
+
+	/* data access memory addresses, used with partition translation */
+	REG_SLV_MEM_DATA,
+	REG_SLV_REG_DATA,
+
+	/* raw data access memory addresses */
+	REG_RAW_FW_STATUS_ADDR,
+
+	REG_TABLE_LEN,
+};
+
 struct wl1271 {
 	struct ieee80211_hw *hw;
 	bool mac80211_registered;
@@ -266,6 +289,8 @@ struct wl1271 {
 	struct wlcore_ops *ops;
 	/* pointer to the lower driver partition table */
 	const struct wlcore_partition_set *ptable;
+	/* pointer to the lower driver register table */
+	const int *rtable;
 };
 
 int __devinit wlcore_probe(struct wl1271 *wl, struct platform_device *pdev);
@@ -273,5 +298,87 @@ int __devexit wlcore_remove(struct platform_device *pdev);
 struct ieee80211_hw *wlcore_alloc_hw(void);
 int wlcore_free_hw(struct wl1271 *wl);
 
+/* Firmware image load chunk size */
+#define CHUNK_SIZE	16384
+
+/* TODO: move to the lower drivers when all usages are abstracted */
+#define CHIP_ID_1271_PG10              (0x4030101)
+#define CHIP_ID_1271_PG20              (0x4030111)
+#define CHIP_ID_1283_PG10              (0x05030101)
+#define CHIP_ID_1283_PG20              (0x05030111)
+
+/* TODO: move all these common registers and values elsewhere */
+#define HW_ACCESS_ELP_CTRL_REG		0x1FFFC
+
+/* ELP register commands */
+#define ELPCTRL_WAKE_UP             0x1
+#define ELPCTRL_WAKE_UP_WLAN_READY  0x5
+#define ELPCTRL_SLEEP               0x0
+/* ELP WLAN_READY bit */
+#define ELPCTRL_WLAN_READY          0x2
+
+/*************************************************************************
+
+    Interrupt Trigger Register (Host -> WiLink)
+
+**************************************************************************/
+
+/* Hardware to Embedded CPU Interrupts - first 32-bit register set */
+
+/*
+ * Host Command Interrupt. Setting this bit masks
+ * the interrupt that the host issues to inform
+ * the FW that it has sent a command
+ * to the Wlan hardware Command Mailbox.
+ */
+#define INTR_TRIG_CMD       BIT(0)
+
+/*
+ * Host Event Acknowlegde Interrupt. The host
+ * sets this bit to acknowledge that it received
+ * the unsolicited information from the event
+ * mailbox.
+ */
+#define INTR_TRIG_EVENT_ACK BIT(1)
+
+/*
+ * The host sets this bit to inform the Wlan
+ * FW that a TX packet is in the XFER
+ * Buffer #0.
+ */
+#define INTR_TRIG_TX_PROC0 BIT(2)
+
+/*
+ * The host sets this bit to inform the FW
+ * that it read a packet from RX XFER
+ * Buffer #0.
+ */
+#define INTR_TRIG_RX_PROC0 BIT(3)
+
+#define INTR_TRIG_DEBUG_ACK BIT(4)
+
+#define INTR_TRIG_STATE_CHANGED BIT(5)
+
+/* Hardware to Embedded CPU Interrupts - second 32-bit register set */
+
+/*
+ * The host sets this bit to inform the FW
+ * that it read a packet from RX XFER
+ * Buffer #1.
+ */
+#define INTR_TRIG_RX_PROC1 BIT(17)
+
+/*
+ * The host sets this bit to inform the Wlan
+ * hardware that a TX packet is in the XFER
+ * Buffer #1.
+ */
+#define INTR_TRIG_TX_PROC1 BIT(18)
+
+#define ACX_SLV_SOFT_RESET_BIT	BIT(1)
+#define SOFT_RESET_MAX_TIME	1000000
+#define SOFT_RESET_STALL_TIME	1000
+
+#define ECPU_CONTROL_HALT	0x00000101
 
 #endif /* __WLCORE_H__ */
-- 
1.7.5.4

