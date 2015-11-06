Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:37689 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031547AbbKFCRq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2015 21:17:46 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 57/73] staging: wilc1000: wilc_wlan.h: alignment defines
Date: Fri, 6 Nov 2015 11:19:56 +0900
Message-ID: <1446776412-30670-8-git-send-email-glen.lee@atmel.com> (sfid-20151106_031753_419528_800C2923)
In-Reply-To: <1446776412-30670-1-git-send-email-glen.lee@atmel.com>
References: <1446776412-30670-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch fixes alignment of defines.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_wlan.h | 292 ++++++++++++++++++-----------------
 1 file changed, 148 insertions(+), 144 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.h b/drivers/staging/wilc1000/wilc_wlan.h
index ff852b4..ba70630 100644
--- a/drivers/staging/wilc1000/wilc_wlan.h
+++ b/drivers/staging/wilc1000/wilc_wlan.h
@@ -3,7 +3,7 @@
 
 
 
-#define ISWILC1000(id)   (((id & 0xfffff000) == 0x100000) ? 1 : 0)
+#define ISWILC1000(id)			((id & 0xfffff000) == 0x100000 ? 1 : 0)
 
 
 /********************************************
@@ -11,27 +11,30 @@
  *      Mac eth header length
  *
  ********************************************/
-#define DRIVER_HANDLER_SIZE 4
-#define MAX_MAC_HDR_LEN         26 /* QOS_MAC_HDR_LEN */
-#define SUB_MSDU_HEADER_LENGTH  14
-#define SNAP_HDR_LEN            8
-#define ETHERNET_HDR_LEN          14
-#define WORD_ALIGNMENT_PAD        0
-
-#define ETH_ETHERNET_HDR_OFFSET   (MAX_MAC_HDR_LEN + SUB_MSDU_HEADER_LENGTH + \
-				   SNAP_HDR_LEN - ETHERNET_HDR_LEN + WORD_ALIGNMENT_PAD)
-
-#define HOST_HDR_OFFSET		4
-#define ETHERNET_HDR_LEN          14
-#define IP_HDR_LEN                20
-#define IP_HDR_OFFSET             ETHERNET_HDR_LEN
-#define UDP_HDR_OFFSET            (IP_HDR_LEN + IP_HDR_OFFSET)
-#define UDP_HDR_LEN               8
-#define UDP_DATA_OFFSET           (UDP_HDR_OFFSET + UDP_HDR_LEN)
-#define ETH_CONFIG_PKT_HDR_LEN    UDP_DATA_OFFSET
-
-#define ETH_CONFIG_PKT_HDR_OFFSET (ETH_ETHERNET_HDR_OFFSET + \
-				   ETH_CONFIG_PKT_HDR_LEN)
+#define DRIVER_HANDLER_SIZE		4
+#define MAX_MAC_HDR_LEN			26 /* QOS_MAC_HDR_LEN */
+#define SUB_MSDU_HEADER_LENGTH		14
+#define SNAP_HDR_LEN			8
+#define ETHERNET_HDR_LEN		14
+#define WORD_ALIGNMENT_PAD		0
+
+#define ETH_ETHERNET_HDR_OFFSET		(MAX_MAC_HDR_LEN + \
+					 SUB_MSDU_HEADER_LENGTH + \
+					 SNAP_HDR_LEN - \
+					 ETHERNET_HDR_LEN + \
+					 WORD_ALIGNMENT_PAD)
+
+#define HOST_HDR_OFFSET			4
+#define ETHERNET_HDR_LEN		14
+#define IP_HDR_LEN			20
+#define IP_HDR_OFFSET			ETHERNET_HDR_LEN
+#define UDP_HDR_OFFSET			(IP_HDR_LEN + IP_HDR_OFFSET)
+#define UDP_HDR_LEN			8
+#define UDP_DATA_OFFSET			(UDP_HDR_OFFSET + UDP_HDR_LEN)
+#define ETH_CONFIG_PKT_HDR_LEN		UDP_DATA_OFFSET
+
+#define ETH_CONFIG_PKT_HDR_OFFSET	(ETH_ETHERNET_HDR_OFFSET + \
+					 ETH_CONFIG_PKT_HDR_LEN)
 
 /********************************************
  *
@@ -39,91 +42,92 @@
  *
  ********************************************/
 
-#define BYTE_SWAP(val) ((((val) & 0x000000FF) << 24) + \
-			(((val) & 0x0000FF00) << 8)  + \
-			(((val) & 0x00FF0000) >> 8)   +	\
-			(((val) & 0xFF000000) >> 24))
+#define BYTE_SWAP(val)			(((val & 0x000000FF) << 24) + \
+					 ((val & 0x0000FF00) << 8) + \
+					 ((val & 0x00FF0000) >> 8) + \
+					 ((val & 0xFF000000) >> 24))
 
 /********************************************
  *
  *      Register Defines
  *
  ********************************************/
-#define WILC_PERIPH_REG_BASE 0x1000
-#define WILC_CHANGING_VIR_IF                     (0x108c)
-#define WILC_CHIPID	(WILC_PERIPH_REG_BASE)
-#define WILC_GLB_RESET_0 (WILC_PERIPH_REG_BASE + 0x400)
-#define WILC_PIN_MUX_0 (WILC_PERIPH_REG_BASE + 0x408)
-#define WILC_HOST_TX_CTRL (WILC_PERIPH_REG_BASE + 0x6c)
-#define WILC_HOST_RX_CTRL_0 (WILC_PERIPH_REG_BASE + 0x70)
-#define WILC_HOST_RX_CTRL_1 (WILC_PERIPH_REG_BASE + 0x74)
-#define WILC_HOST_VMM_CTL	(WILC_PERIPH_REG_BASE + 0x78)
-#define WILC_HOST_RX_CTRL	(WILC_PERIPH_REG_BASE + 0x80)
-#define WILC_HOST_RX_EXTRA_SIZE	(WILC_PERIPH_REG_BASE + 0x84)
-#define WILC_HOST_TX_CTRL_1	(WILC_PERIPH_REG_BASE + 0x88)
-#define WILC_MISC	(WILC_PERIPH_REG_BASE + 0x428)
-#define WILC_INTR_REG_BASE (WILC_PERIPH_REG_BASE + 0xa00)
-#define WILC_INTR_ENABLE (WILC_INTR_REG_BASE)
-#define WILC_INTR2_ENABLE (WILC_INTR_REG_BASE + 4)
-
-#define WILC_INTR_POLARITY (WILC_INTR_REG_BASE + 0x10)
-#define WILC_INTR_TYPE (WILC_INTR_REG_BASE + 0x20)
-#define WILC_INTR_CLEAR (WILC_INTR_REG_BASE + 0x30)
-#define WILC_INTR_STATUS (WILC_INTR_REG_BASE + 0x40)
-
-#define WILC_VMM_TBL_SIZE 64
-#define WILC_VMM_TX_TBL_BASE (0x150400)
-#define WILC_VMM_RX_TBL_BASE (0x150500)
-
-#define WILC_VMM_BASE 0x150000
-#define WILC_VMM_CORE_CTL (WILC_VMM_BASE)
-#define WILC_VMM_TBL_CTL (WILC_VMM_BASE + 0x4)
-#define WILC_VMM_TBL_ENTRY (WILC_VMM_BASE + 0x8)
-#define WILC_VMM_TBL0_SIZE (WILC_VMM_BASE + 0xc)
-#define WILC_VMM_TO_HOST_SIZE (WILC_VMM_BASE + 0x10)
-#define WILC_VMM_CORE_CFG (WILC_VMM_BASE + 0x14)
-#define WILC_VMM_TBL_ACTIVE (WILC_VMM_BASE + 040)
-#define WILC_VMM_TBL_STATUS (WILC_VMM_BASE + 0x44)
-
-#define WILC_SPI_REG_BASE 0xe800
-#define WILC_SPI_CTL (WILC_SPI_REG_BASE)
-#define WILC_SPI_MASTER_DMA_ADDR (WILC_SPI_REG_BASE + 0x4)
-#define WILC_SPI_MASTER_DMA_COUNT (WILC_SPI_REG_BASE + 0x8)
-#define WILC_SPI_SLAVE_DMA_ADDR (WILC_SPI_REG_BASE + 0xc)
-#define WILC_SPI_SLAVE_DMA_COUNT (WILC_SPI_REG_BASE + 0x10)
-#define WILC_SPI_TX_MODE (WILC_SPI_REG_BASE + 0x20)
-#define WILC_SPI_PROTOCOL_CONFIG (WILC_SPI_REG_BASE + 0x24)
-#define WILC_SPI_INTR_CTL (WILC_SPI_REG_BASE + 0x2c)
-
-#define WILC_SPI_PROTOCOL_OFFSET (WILC_SPI_PROTOCOL_CONFIG - WILC_SPI_REG_BASE)
-
-#define WILC_AHB_DATA_MEM_BASE 0x30000
-#define WILC_AHB_SHARE_MEM_BASE 0xd0000
-
-#define WILC_VMM_TBL_RX_SHADOW_BASE WILC_AHB_SHARE_MEM_BASE
-#define WILC_VMM_TBL_RX_SHADOW_SIZE (256)
-
-#define WILC_GP_REG_0   0x149c
-#define WILC_GP_REG_1   0x14a0
-
-#define rHAVE_SDIO_IRQ_GPIO_BIT      (0)
-#define rHAVE_USE_PMU_BIT            (1)
-#define rHAVE_SLEEP_CLK_SRC_RTC_BIT  (2)
-#define rHAVE_SLEEP_CLK_SRC_XO_BIT   (3)
-#define rHAVE_EXT_PA_INV_TX_RX_BIT   (4)
-#define rHAVE_LEGACY_RF_SETTINGS_BIT (5)
-#define rHAVE_XTAL_24_BIT            (6)
-#define rHAVE_DISABLE_WILC_UART_BIT   (7)
-
-
-#define WILC_HAVE_SDIO_IRQ_GPIO       (1 << rHAVE_SDIO_IRQ_GPIO_BIT)
-#define WILC_HAVE_USE_PMU             (1 << rHAVE_USE_PMU_BIT)
-#define WILC_HAVE_SLEEP_CLK_SRC_RTC   (1 << rHAVE_SLEEP_CLK_SRC_RTC_BIT)
-#define WILC_HAVE_SLEEP_CLK_SRC_XO    (1 << rHAVE_SLEEP_CLK_SRC_XO_BIT)
-#define WILC_HAVE_EXT_PA_INV_TX_RX    (1 << rHAVE_EXT_PA_INV_TX_RX_BIT)
-#define WILC_HAVE_LEGACY_RF_SETTINGS  (1 << rHAVE_LEGACY_RF_SETTINGS_BIT)
-#define WILC_HAVE_XTAL_24             (1 << rHAVE_XTAL_24_BIT)
-#define WILC_HAVE_DISABLE_WILC_UART    (1 << rHAVE_DISABLE_WILC_UART_BIT)
+#define WILC_PERIPH_REG_BASE		0x1000
+#define WILC_CHANGING_VIR_IF		0x108c
+#define WILC_CHIPID			WILC_PERIPH_REG_BASE
+#define WILC_GLB_RESET_0		(WILC_PERIPH_REG_BASE + 0x400)
+#define WILC_PIN_MUX_0			(WILC_PERIPH_REG_BASE + 0x408)
+#define WILC_HOST_TX_CTRL		(WILC_PERIPH_REG_BASE + 0x6c)
+#define WILC_HOST_RX_CTRL_0		(WILC_PERIPH_REG_BASE + 0x70)
+#define WILC_HOST_RX_CTRL_1		(WILC_PERIPH_REG_BASE + 0x74)
+#define WILC_HOST_VMM_CTL		(WILC_PERIPH_REG_BASE + 0x78)
+#define WILC_HOST_RX_CTRL		(WILC_PERIPH_REG_BASE + 0x80)
+#define WILC_HOST_RX_EXTRA_SIZE		(WILC_PERIPH_REG_BASE + 0x84)
+#define WILC_HOST_TX_CTRL_1		(WILC_PERIPH_REG_BASE + 0x88)
+#define WILC_MISC			(WILC_PERIPH_REG_BASE + 0x428)
+#define WILC_INTR_REG_BASE		(WILC_PERIPH_REG_BASE + 0xa00)
+#define WILC_INTR_ENABLE		WILC_INTR_REG_BASE
+#define WILC_INTR2_ENABLE		(WILC_INTR_REG_BASE + 4)
+
+#define WILC_INTR_POLARITY		(WILC_INTR_REG_BASE + 0x10)
+#define WILC_INTR_TYPE			(WILC_INTR_REG_BASE + 0x20)
+#define WILC_INTR_CLEAR			(WILC_INTR_REG_BASE + 0x30)
+#define WILC_INTR_STATUS		(WILC_INTR_REG_BASE + 0x40)
+
+#define WILC_VMM_TBL_SIZE		64
+#define WILC_VMM_TX_TBL_BASE		0x150400
+#define WILC_VMM_RX_TBL_BASE		0x150500
+
+#define WILC_VMM_BASE			0x150000
+#define WILC_VMM_CORE_CTL		WILC_VMM_BASE
+#define WILC_VMM_TBL_CTL		(WILC_VMM_BASE + 0x4)
+#define WILC_VMM_TBL_ENTRY		(WILC_VMM_BASE + 0x8)
+#define WILC_VMM_TBL0_SIZE		(WILC_VMM_BASE + 0xc)
+#define WILC_VMM_TO_HOST_SIZE		(WILC_VMM_BASE + 0x10)
+#define WILC_VMM_CORE_CFG		(WILC_VMM_BASE + 0x14)
+#define WILC_VMM_TBL_ACTIVE		(WILC_VMM_BASE + 040)
+#define WILC_VMM_TBL_STATUS		(WILC_VMM_BASE + 0x44)
+
+#define WILC_SPI_REG_BASE		0xe800
+#define WILC_SPI_CTL			WILC_SPI_REG_BASE
+#define WILC_SPI_MASTER_DMA_ADDR	(WILC_SPI_REG_BASE + 0x4)
+#define WILC_SPI_MASTER_DMA_COUNT	(WILC_SPI_REG_BASE + 0x8)
+#define WILC_SPI_SLAVE_DMA_ADDR		(WILC_SPI_REG_BASE + 0xc)
+#define WILC_SPI_SLAVE_DMA_COUNT	(WILC_SPI_REG_BASE + 0x10)
+#define WILC_SPI_TX_MODE		(WILC_SPI_REG_BASE + 0x20)
+#define WILC_SPI_PROTOCOL_CONFIG	(WILC_SPI_REG_BASE + 0x24)
+#define WILC_SPI_INTR_CTL		(WILC_SPI_REG_BASE + 0x2c)
+
+#define WILC_SPI_PROTOCOL_OFFSET	(WILC_SPI_PROTOCOL_CONFIG - \
+					 WILC_SPI_REG_BASE)
+
+#define WILC_AHB_DATA_MEM_BASE		0x30000
+#define WILC_AHB_SHARE_MEM_BASE		0xd0000
+
+#define WILC_VMM_TBL_RX_SHADOW_BASE	WILC_AHB_SHARE_MEM_BASE
+#define WILC_VMM_TBL_RX_SHADOW_SIZE	256
+
+#define WILC_GP_REG_0			0x149c
+#define WILC_GP_REG_1			0x14a0
+
+#define rHAVE_SDIO_IRQ_GPIO_BIT		0
+#define rHAVE_USE_PMU_BIT		1
+#define rHAVE_SLEEP_CLK_SRC_RTC_BIT	2
+#define rHAVE_SLEEP_CLK_SRC_XO_BIT	3
+#define rHAVE_EXT_PA_INV_TX_RX_BIT	4
+#define rHAVE_LEGACY_RF_SETTINGS_BIT	5
+#define rHAVE_XTAL_24_BIT		6
+#define rHAVE_DISABLE_WILC_UART_BIT	7
+
+
+#define WILC_HAVE_SDIO_IRQ_GPIO		(1 << rHAVE_SDIO_IRQ_GPIO_BIT)
+#define WILC_HAVE_USE_PMU		(1 << rHAVE_USE_PMU_BIT)
+#define WILC_HAVE_SLEEP_CLK_SRC_RTC	(1 << rHAVE_SLEEP_CLK_SRC_RTC_BIT)
+#define WILC_HAVE_SLEEP_CLK_SRC_XO	(1 << rHAVE_SLEEP_CLK_SRC_XO_BIT)
+#define WILC_HAVE_EXT_PA_INV_TX_RX	(1 << rHAVE_EXT_PA_INV_TX_RX_BIT)
+#define WILC_HAVE_LEGACY_RF_SETTINGS	(1 << rHAVE_LEGACY_RF_SETTINGS_BIT)
+#define WILC_HAVE_XTAL_24		(1 << rHAVE_XTAL_24_BIT)
+#define WILC_HAVE_DISABLE_WILC_UART	(1 << rHAVE_DISABLE_WILC_UART_BIT)
 
 
 /********************************************
@@ -131,25 +135,25 @@
  *      Wlan Defines
  *
  ********************************************/
-#define WILC_CFG_PKT	1
-#define WILC_NET_PKT 0
-#define WILC_MGMT_PKT 2
+#define WILC_CFG_PKT		1
+#define WILC_NET_PKT		0
+#define WILC_MGMT_PKT		2
 
-#define WILC_CFG_SET 1
-#define WILC_CFG_QUERY 0
+#define WILC_CFG_SET		1
+#define WILC_CFG_QUERY		0
 
-#define WILC_CFG_RSP	1
-#define WILC_CFG_RSP_STATUS 2
-#define WILC_CFG_RSP_SCAN 3
+#define WILC_CFG_RSP		1
+#define WILC_CFG_RSP_STATUS	2
+#define WILC_CFG_RSP_SCAN	3
 
 #ifdef WILC_SDIO
-#define WILC_PLL_TO	4
+#define WILC_PLL_TO		4
 #else
-#define WILC_PLL_TO	2
+#define WILC_PLL_TO		2
 #endif
 
 
-#define ABORT_INT   BIT(31)
+#define ABORT_INT		BIT(31)
 
 /*******************************************/
 /*        E0 and later Interrupt flags.    */
@@ -165,15 +169,15 @@
 /* 20: INT4 flag                           */
 /* 21: INT5 flag                           */
 /*******************************************/
-#define                 IRG_FLAGS_OFFSET 16
-#define IRQ_DMA_WD_CNT_MASK ((1ul << IRG_FLAGS_OFFSET) - 1)
-#define INT_0           (1 << (IRG_FLAGS_OFFSET))
-#define INT_1           (1 << (IRG_FLAGS_OFFSET + 1))
-#define INT_2           (1 << (IRG_FLAGS_OFFSET + 2))
-#define INT_3           (1 << (IRG_FLAGS_OFFSET + 3))
-#define INT_4           (1 << (IRG_FLAGS_OFFSET + 4))
-#define INT_5           (1 << (IRG_FLAGS_OFFSET + 5))
-#define MAX_NUM_INT     (6)
+#define IRG_FLAGS_OFFSET	16
+#define IRQ_DMA_WD_CNT_MASK	((1ul << IRG_FLAGS_OFFSET) - 1)
+#define INT_0			(1 << IRG_FLAGS_OFFSET)
+#define INT_1			(1 << (IRG_FLAGS_OFFSET + 1))
+#define INT_2			(1 << (IRG_FLAGS_OFFSET + 2))
+#define INT_3			(1 << (IRG_FLAGS_OFFSET + 3))
+#define INT_4			(1 << (IRG_FLAGS_OFFSET + 4))
+#define INT_5			(1 << (IRG_FLAGS_OFFSET + 5))
+#define MAX_NUM_INT		6
 
 /*******************************************/
 /*        E0 and later Interrupt flags.    */
@@ -188,28 +192,28 @@
 /* 7: Select VMM table 2                   */
 /* 8: Enable VMM                           */
 /*******************************************/
-#define CLR_INT0             BIT(0)
-#define CLR_INT1             BIT(1)
-#define CLR_INT2             BIT(2)
-#define CLR_INT3             BIT(3)
-#define CLR_INT4             BIT(4)
-#define CLR_INT5             BIT(5)
-#define SEL_VMM_TBL0         BIT(6)
-#define SEL_VMM_TBL1         BIT(7)
-#define EN_VMM               BIT(8)
-
-#define DATA_INT_EXT	INT_0
-#define PLL_INT_EXT         INT_1
-#define SLEEP_INT_EXT	INT_2
-#define ALL_INT_EXT     (DATA_INT_EXT | PLL_INT_EXT | SLEEP_INT_EXT)
-#define NUM_INT_EXT     (3)
-
-#define DATA_INT_CLR	CLR_INT0
-#define PLL_INT_CLR         CLR_INT1
-#define SLEEP_INT_CLR	CLR_INT2
-
-#define ENABLE_RX_VMM   (SEL_VMM_TBL1 | EN_VMM)
-#define ENABLE_TX_VMM   (SEL_VMM_TBL0 | EN_VMM)
+#define CLR_INT0		BIT(0)
+#define CLR_INT1		BIT(1)
+#define CLR_INT2		BIT(2)
+#define CLR_INT3		BIT(3)
+#define CLR_INT4		BIT(4)
+#define CLR_INT5		BIT(5)
+#define SEL_VMM_TBL0		BIT(6)
+#define SEL_VMM_TBL1		BIT(7)
+#define EN_VMM			BIT(8)
+
+#define DATA_INT_EXT		INT_0
+#define PLL_INT_EXT		INT_1
+#define SLEEP_INT_EXT		INT_2
+#define ALL_INT_EXT		(DATA_INT_EXT | PLL_INT_EXT | SLEEP_INT_EXT)
+#define NUM_INT_EXT		3
+
+#define DATA_INT_CLR		CLR_INT0
+#define PLL_INT_CLR		CLR_INT1
+#define SLEEP_INT_CLR		CLR_INT2
+
+#define ENABLE_RX_VMM		(SEL_VMM_TBL1 | EN_VMM)
+#define ENABLE_TX_VMM		(SEL_VMM_TBL0 | EN_VMM)
 
 
 /*time for expiring the semaphores of cfg packets*/
@@ -276,7 +280,7 @@ typedef struct {
  *
  ********************************************/
 
-#define MAX_CFG_FRAME_SIZE 1468
+#define MAX_CFG_FRAME_SIZE	1468
 
 typedef struct {
 	u8 ether_header[14];
-- 
1.9.1

