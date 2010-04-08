Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:46704 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933136Ab0DHT1j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Apr 2010 15:27:39 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Felix Fietkau <nbd@openwrt.org>
Subject: [PATCH 005/102] ath9k_hw: add simple register abstraction for some AR9300 registers
Date: Thu,  8 Apr 2010 15:26:01 -0400
Message-Id: <1270754858-26266-6-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1270754858-26266-1-git-send-email-lrodriguez@atheros.com>
References: <1270754858-26266-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Felix Fietkau <nbd@openwrt.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/reg.h |   42 +++++++++++++++++-----------------
 1 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
index c1e58da..d56b4ea 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -20,7 +20,7 @@
 #include "../reg.h"
 
 #define AR_CR                0x0008
-#define AR_CR_RXE            0x00000004
+#define AR_CR_RXE            (AR_SREV_9300_20_OR_LATER(ah) ? 0x0000000c : 0x00000004)
 #define AR_CR_RXD            0x00000020
 #define AR_CR_SWI            0x00000040
 
@@ -232,7 +232,6 @@
 #define AR_ISR_S5_TIMER_THRESH      0x0007FE00
 #define AR_ISR_S5_TIM_TIMER         0x00000010
 #define AR_ISR_S5_DTIM_TIMER        0x00000020
-#define AR_ISR_S5_S                 0x00d8
 #define AR_IMR_S5                   0x00b8
 #define AR_IMR_S5_TIM_TIMER         0x00000010
 #define AR_IMR_S5_DTIM_TIMER        0x00000020
@@ -240,7 +239,6 @@
 #define AR_ISR_S5_GENTIMER_TRIG_S   0
 #define AR_ISR_S5_GENTIMER_THRESH   0xFF800000
 #define AR_ISR_S5_GENTIMER_THRESH_S 16
-#define AR_ISR_S5_S                 0x00d8
 #define AR_IMR_S5_GENTIMER_TRIG     0x0000FF80
 #define AR_IMR_S5_GENTIMER_TRIG_S   0
 #define AR_IMR_S5_GENTIMER_THRESH   0xFF800000
@@ -332,10 +330,10 @@
 #define AR_ISR_S1_QCU_TXEOL    0x03FF0000
 #define AR_ISR_S1_QCU_TXEOL_S  16
 
-#define AR_ISR_S2_S           0x00cc
-#define AR_ISR_S3_S           0x00d0
-#define AR_ISR_S4_S           0x00d4
-#define AR_ISR_S5_S           0x00d8
+#define AR_ISR_S2_S           (AR_SREV_9300_20_OR_LATER(ah) ? 0x00d0 : 0x00cc)
+#define AR_ISR_S3_S           (AR_SREV_9300_20_OR_LATER(ah) ? 0x00d4 : 0x00d0)
+#define AR_ISR_S4_S           (AR_SREV_9300_20_OR_LATER(ah) ? 0x00d8 : 0x00d4)
+#define AR_ISR_S5_S           (AR_SREV_9300_20_OR_LATER(ah) ? 0x00dc : 0x00d8)
 #define AR_DMADBG_0           0x00e0
 #define AR_DMADBG_1           0x00e4
 #define AR_DMADBG_2           0x00e8
@@ -968,19 +966,21 @@ enum {
 #define AR9287_GPIO_IN_VAL_S                     11
 #define AR9271_GPIO_IN_VAL                       0xFFFF0000
 #define AR9271_GPIO_IN_VAL_S                     16
+#define AR9300_GPIO_IN_VAL                       0x0001FFFF
+#define AR9300_GPIO_IN_VAL_S                     0
 
-#define AR_GPIO_OE_OUT                           0x404c
+#define AR_GPIO_OE_OUT                           (AR_SREV_9300_20_OR_LATER(ah) ? 0x4050 : 0x404c)
 #define AR_GPIO_OE_OUT_DRV                       0x3
 #define AR_GPIO_OE_OUT_DRV_NO                    0x0
 #define AR_GPIO_OE_OUT_DRV_LOW                   0x1
 #define AR_GPIO_OE_OUT_DRV_HI                    0x2
 #define AR_GPIO_OE_OUT_DRV_ALL                   0x3
 
-#define AR_GPIO_INTR_POL                         0x4050
-#define AR_GPIO_INTR_POL_VAL                     0x00001FFF
+#define AR_GPIO_INTR_POL                         (AR_SREV_9300_20_OR_LATER(ah) ? 0x4058 : 0x4050)
+#define AR_GPIO_INTR_POL_VAL                     0x0001FFFF
 #define AR_GPIO_INTR_POL_VAL_S                   0
 
-#define AR_GPIO_INPUT_EN_VAL                     0x4054
+#define AR_GPIO_INPUT_EN_VAL                     (AR_SREV_9300_20_OR_LATER(ah) ? 0x405c : 0x4054)
 #define AR_GPIO_INPUT_EN_VAL_BT_PRIORITY_DEF     0x00000004
 #define AR_GPIO_INPUT_EN_VAL_BT_PRIORITY_S       2
 #define AR_GPIO_INPUT_EN_VAL_BT_FREQUENCY_DEF    0x00000008
@@ -998,13 +998,13 @@ enum {
 #define AR_GPIO_RTC_RESET_OVERRIDE_ENABLE        0x00010000
 #define AR_GPIO_JTAG_DISABLE                     0x00020000
 
-#define AR_GPIO_INPUT_MUX1                       0x4058
+#define AR_GPIO_INPUT_MUX1                       (AR_SREV_9300_20_OR_LATER(ah) ? 0x4060 : 0x4058)
 #define AR_GPIO_INPUT_MUX1_BT_ACTIVE             0x000f0000
 #define AR_GPIO_INPUT_MUX1_BT_ACTIVE_S           16
 #define AR_GPIO_INPUT_MUX1_BT_PRIORITY           0x00000f00
 #define AR_GPIO_INPUT_MUX1_BT_PRIORITY_S         8
 
-#define AR_GPIO_INPUT_MUX2                       0x405c
+#define AR_GPIO_INPUT_MUX2                       (AR_SREV_9300_20_OR_LATER(ah) ? 0x4064 : 0x405c)
 #define AR_GPIO_INPUT_MUX2_CLK25                 0x0000000f
 #define AR_GPIO_INPUT_MUX2_CLK25_S               0
 #define AR_GPIO_INPUT_MUX2_RFSILENT              0x000000f0
@@ -1012,13 +1012,13 @@ enum {
 #define AR_GPIO_INPUT_MUX2_RTC_RESET             0x00000f00
 #define AR_GPIO_INPUT_MUX2_RTC_RESET_S           8
 
-#define AR_GPIO_OUTPUT_MUX1                      0x4060
-#define AR_GPIO_OUTPUT_MUX2                      0x4064
-#define AR_GPIO_OUTPUT_MUX3                      0x4068
+#define AR_GPIO_OUTPUT_MUX1                      (AR_SREV_9300_20_OR_LATER(ah) ? 0x4068 : 0x4060)
+#define AR_GPIO_OUTPUT_MUX2                      (AR_SREV_9300_20_OR_LATER(ah) ? 0x406c : 0x4064)
+#define AR_GPIO_OUTPUT_MUX3                      (AR_SREV_9300_20_OR_LATER(ah) ? 0x4070 : 0x4068)
 
-#define AR_INPUT_STATE                           0x406c
+#define AR_INPUT_STATE                           (AR_SREV_9300_20_OR_LATER(ah) ? 0x4074 : 0x406c)
 
-#define AR_EEPROM_STATUS_DATA                    0x407c
+#define AR_EEPROM_STATUS_DATA                    (AR_SREV_9300_20_OR_LATER(ah) ? 0x4084 : 0x407c)
 #define AR_EEPROM_STATUS_DATA_VAL                0x0000ffff
 #define AR_EEPROM_STATUS_DATA_VAL_S              0
 #define AR_EEPROM_STATUS_DATA_BUSY               0x00010000
@@ -1026,11 +1026,11 @@ enum {
 #define AR_EEPROM_STATUS_DATA_PROT_ACCESS        0x00040000
 #define AR_EEPROM_STATUS_DATA_ABSENT_ACCESS      0x00080000
 
-#define AR_OBS                  0x4080
+#define AR_OBS                  (AR_SREV_9300_20_OR_LATER(ah) ? 0x4088 : 0x4080)
 
-#define AR_GPIO_PDPU                             0x4088
+#define AR_GPIO_PDPU                             (AR_SREV_9300_20_OR_LATER(ah) ? 0x4090 : 0x4088)
 
-#define AR_PCIE_MSI                              0x4094
+#define AR_PCIE_MSI                              (AR_SREV_9300_20_OR_LATER(ah) ? 0x40a4 : 0x4094)
 #define AR_PCIE_MSI_ENABLE                       0x00000001
 
 
-- 
1.6.3.3

