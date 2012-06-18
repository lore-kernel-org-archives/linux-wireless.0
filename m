Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:2225 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055Ab2FRGWa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jun 2012 02:22:30 -0400
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	Sujith Manoharan <c_manoha@qca.qualcomm.com>,
	<vadivel@qca.qualcomm.com>, <rhu@qca.qualcomm.com>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: <linux-wireless@vger.kernel.org>
Subject: [RFC 01/10] ath9k_hw: Add register definitions for WoW support
Date: Mon, 18 Jun 2012 11:51:45 +0530
Message-ID: <1340000514-7779-2-git-send-email-mohammed@qca.qualcomm.com> (sfid-20120618_082233_253921_715864FF)
In-Reply-To: <1340000514-7779-1-git-send-email-mohammed@qca.qualcomm.com>
References: <1340000514-7779-1-git-send-email-mohammed@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

*MAC WoW registers

back-off shift, MAC interrupt enable, magic packet enable,
pattern match enable, aifs, slot wait period, keep alive
frame failure count, beacon fail enable, beacon timeout,
keep alive timeout, auto keep alive disable,
keep alive fail disable and their corresponding
status registers. keep alive frame delay,
pattern end/byte offsets, transmit buffers for
keep alive frames and storing the user patterns

*Power Management Control registers

pme_d3cold_vaux, host_pme_enable, aux_pwr_detect,
power_state_mask, wow_pme_clear

Signed-off-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/reg.h |  145 +++++++++++++++++++++++++++++++++-
 1 files changed, 144 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
index 75acefb..e904f0a 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -696,9 +696,12 @@
 #define AR_WA_BIT7			(1 << 7)
 #define AR_WA_BIT23			(1 << 23)
 #define AR_WA_D3_L1_DISABLE		(1 << 14)
+#define AR_WA_UNTIE_RESET_EN		(1 << 15) /* Enable PCI Reset
+						     to POR (power-on-reset) */
 #define AR_WA_D3_TO_L1_DISABLE_REAL     (1 << 16)
 #define AR_WA_ASPM_TIMER_BASED_DISABLE  (1 << 17)
-#define AR_WA_RESET_EN                  (1 << 18) /* Sw Control to enable PCI-Reset to POR (bit 15) */
+#define AR_WA_RESET_EN                  (1 << 18) /* Enable PCI-Reset to
+						     POR (bit 15) */
 #define AR_WA_ANALOG_SHIFT              (1 << 20)
 #define AR_WA_POR_SHORT                 (1 << 21) /* PCI-E Phy reset control */
 #define AR_WA_BIT22			(1 << 22)
@@ -1028,6 +1031,8 @@ enum {
 #define AR_PCIE_PM_CTRL                          (AR_SREV_9340(ah) ? 0x4004 : 0x4014)
 #define AR_PCIE_PM_CTRL_ENA                      0x00080000
 
+#define AR_PCIE_PHY_REG3			 0x18c08
+
 #define AR_NUM_GPIO                              14
 #define AR928X_NUM_GPIO                          10
 #define AR9285_NUM_GPIO                          12
@@ -1231,6 +1236,8 @@ enum {
 #define AR_RTC_PLL_CLKSEL       0x00000300
 #define AR_RTC_PLL_CLKSEL_S     8
 #define AR_RTC_PLL_BYPASS	0x00010000
+#define AR_RTC_PLL_NOPWD	0x00040000
+#define AR_RTC_PLL_NOPWD_S	18
 
 #define PLL3 0x16188
 #define PLL3_DO_MEAS_MASK 0x40000000
@@ -1883,6 +1890,8 @@ enum {
 #define AR_PCU_MISC_MODE2_HWWAR2                       0x02000000
 #define AR_PCU_MISC_MODE2_RESERVED2                    0xFFFE0000
 
+#define AR_PCU_MISC_MODE3			       0x83d0
+
 #define AR_MAC_PCU_ASYNC_FIFO_REG3			0x8358
 #define AR_MAC_PCU_ASYNC_FIFO_REG3_DATAPATH_SEL		0x00000400
 #define AR_MAC_PCU_ASYNC_FIFO_REG3_SOFT_RESET		0x80000000
@@ -1905,6 +1914,140 @@ enum {
 #define AR_RATE_DURATION_32     0x8780
 #define AR_RATE_DURATION(_n)    (AR_RATE_DURATION_0 + ((_n)<<2))
 
+/* WoW - Wake On Wireless */
+
+#define AR_PMCTRL_AUX_PWR_DET		0x10000000 /* Puts Chip in L2 state */
+#define AR_PMCTRL_D3COLD_VAUX		0x00800000
+#define AR_PMCTRL_HOST_PME_EN		0x00400000 /* Send OOB WAKE_L on WoW
+						      event */
+#define AR_PMCTRL_WOW_PME_CLR		0x00200000 /* Clear WoW event */
+#define AR_PMCTRL_PWR_STATE_MASK	0x0f000000 /* Power State Mask */
+#define AR_PMCTRL_PWR_STATE_D1D3	0x0f000000 /* Activate D1 and D3 */
+#define AR_PMCTRL_PWR_STATE_D1D3_REAL	0x0f000000 /* Activate D1 and D3 */
+#define AR_PMCTRL_PWR_STATE_D0		0x08000000 /* Activate D0 */
+#define AR_PMCTRL_PWR_PM_CTRL_ENA	0x00008000 /* Enable power mgmt */
+
+#define AR_WOW_BEACON_TIMO_MAX		0xffffffff
+
+/*
+ * MAC WoW Registers
+ */
+
+#define AR_WOW_PATTERN			0x825C
+#define AR_WOW_COUNT			0x8260
+#define AR_WOW_BCN_EN			0x8270
+#define AR_WOW_BCN_TIMO			0x8274
+#define AR_WOW_KEEP_ALIVE_TIMO		0x8278
+#define AR_WOW_KEEP_ALIVE		0x827c
+#define AR_WOW_US_SCALAR		0x8284
+#define AR_WOW_KEEP_ALIVE_DELAY		0x8288
+#define AR_WOW_PATTERN_MATCH		0x828c
+#define AR_WOW_PATTERN_OFF1		0x8290	/* pattern bytes 0 -> 3 */
+#define AR_WOW_PATTERN_OFF2		0x8294	/* pattern bytes 4 -> 7 */
+
+/* for AR9285 or later version of chips */
+#define AR_WOW_EXACT			0x829c
+#define AR_WOW_LENGTH1			0x8360
+#define AR_WOW_LENGTH2			0X8364
+/* register to enable match for less than 256 bytes packets */
+#define AR_WOW_PATTERN_MATCH_LT_256B	0x8368
+
+#define AR_SW_WOW_CONTROL		0x20018
+#define AR_SW_WOW_ENABLE		0x1
+#define AR_SWITCH_TO_REFCLK		0x2
+#define AR_RESET_CONTROL		0x4
+#define AR_RESET_VALUE_MASK		0x8
+#define AR_HW_WOW_DISABLE		0x10
+#define AR_CLR_MAC_INTERRUPT		0x20
+#define AR_CLR_KA_INTERRUPT		0x40
+
+/* AR_WOW_PATTERN register values */
+#define AR_WOW_BACK_OFF_SHIFT(x)	((x & 0xf) << 28) /* in usecs */
+#define AR_WOW_MAC_INTR_EN		0x00040000
+#define AR_WOW_MAGIC_EN			0x00010000
+#define AR_WOW_PATTERN_EN(x)		(x & 0xff)
+#define AR_WOW_PAT_FOUND_SHIFT	8
+#define AR_WOW_PATTERN_FOUND(x)		(x & (0xff << AR_WOW_PAT_FOUND_SHIFT))
+#define AR_WOW_PATTERN_FOUND_MASK	((0xff) << AR_WOW_PAT_FOUND_SHIFT)
+#define AR_WOW_MAGIC_PAT_FOUND		0x00020000
+#define AR_WOW_MAC_INTR			0x00080000
+#define AR_WOW_KEEP_ALIVE_FAIL		0x00100000
+#define AR_WOW_BEACON_FAIL		0x00200000
+
+#define AR_WOW_STATUS(x)		(x & (AR_WOW_PATTERN_FOUND_MASK | \
+					      AR_WOW_MAGIC_PAT_FOUND	| \
+					      AR_WOW_KEEP_ALIVE_FAIL	| \
+					      AR_WOW_BEACON_FAIL))
+#define AR_WOW_CLEAR_EVENTS(x)		(x & ~(AR_WOW_PATTERN_EN(0xff) | \
+					       AR_WOW_MAGIC_EN | \
+					       AR_WOW_MAC_INTR_EN | \
+					       AR_WOW_BEACON_FAIL | \
+					       AR_WOW_KEEP_ALIVE_FAIL))
+
+/* AR_WOW_COUNT register values */
+#define AR_WOW_AIFS_CNT(x)		(x & 0xff)
+#define AR_WOW_SLOT_CNT(x)		((x & 0xff) << 8)
+#define AR_WOW_KEEP_ALIVE_CNT(x)	((x & 0xff) << 16)
+
+/* AR_WOW_BCN_EN register */
+#define AR_WOW_BEACON_FAIL_EN		0x00000001
+
+/* AR_WOW_BCN_TIMO rgister */
+#define AR_WOW_BEACON_TIMO		0x40000000 /* valid if BCN_EN is set */
+
+/* AR_WOW_KEEP_ALIVE_TIMO register */
+#define AR_WOW_KEEP_ALIVE_TIMO_VALUE
+#define AR_WOW_KEEP_ALIVE_NEVER		0xffffffff
+
+/* AR_WOW_KEEP_ALIVE register  */
+#define AR_WOW_KEEP_ALIVE_AUTO_DIS	0x00000001
+#define AR_WOW_KEEP_ALIVE_FAIL_DIS	0x00000002
+
+/* AR_WOW_KEEP_ALIVE_DELAY register */
+#define AR_WOW_KEEP_ALIVE_DELAY_VALUE	0x000003e8 /* 1 msec */
+
+
+/*
+ * keep it long for beacon workaround - ensure no false alarm
+ */
+#define AR_WOW_BMISSTHRESHOLD		0x20
+
+/* AR_WOW_PATTERN_MATCH register */
+#define AR_WOW_PAT_END_OF_PKT(x)	(x & 0xf)
+#define AR_WOW_PAT_OFF_MATCH(x)		((x & 0xf) << 8)
+
+/*
+ * default values for Wow Configuration for backoff, aifs, slot, keep-alive
+ * to be programmed into various registers.
+ */
+#define AR_WOW_PAT_BACKOFF	0x00000004 /* AR_WOW_PATTERN_REG */
+#define AR_WOW_CNT_AIFS_CNT	0x00000022 /* AR_WOW_COUNT_REG */
+#define AR_WOW_CNT_SLOT_CNT	0x00000009 /* AR_WOW_COUNT_REG */
+/*
+ * Keepalive count applicable for AR9280 2.0 and above.
+ */
+#define AR_WOW_CNT_KA_CNT 0x00000008    /* AR_WOW_COUNT register */
+
+/* WoW - Transmit buffer for keep alive frames */
+#define AR_WOW_TRANSMIT_BUFFER	0xe000 /* E000 - EFFC */
+
+#define AR_WOW_TXBUF(i)		(AR_WOW_TRANSMIT_BUFFER + ((i) << 2))
+
+#define AR_WOW_KA_DESC_WORD2	0xe000
+
+#define AR_WOW_KA_DATA_WORD0	0xe030
+
+/* WoW Transmit Buffer for patterns */
+#define AR_WOW_TB_PATTERN(i)	(0xe100 + (i << 8))
+#define AR_WOW_TB_MASK(i)	(0xec00 + (i << 5))
+
+/* Currently Pattern 0-7 are supported - so bit 0-7 are set */
+#define AR_WOW_PATTERN_SUPPORTED	0xff
+#define AR_WOW_LENGTH_MAX		0xff
+#define AR_WOW_LEN1_SHIFT(_i)	((0x3 - ((_i) & 0x3)) << 0x3)
+#define AR_WOW_LENGTH1_MASK(_i)	(AR_WOW_LENGTH_MAX << AR_WOW_LEN1_SHIFT(_i))
+#define AR_WOW_LEN2_SHIFT(_i)	((0x7 - ((_i) & 0x7)) << 0x3)
+#define AR_WOW_LENGTH2_MASK(_i)	(AR_WOW_LENGTH_MAX << AR_WOW_LEN2_SHIFT(_i))
 
 #define AR9271_CORE_CLOCK	117   /* clock to 117Mhz */
 #define AR9271_TARGET_BAUD_RATE	19200 /* 115200 */
-- 
1.7.0.4

