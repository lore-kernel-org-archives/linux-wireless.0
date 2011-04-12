Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:38769 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750720Ab1DLM52 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Apr 2011 08:57:28 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 12 Apr 2011 05:57:03 -0700
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 02/22] ath9k_hw: Take care of few host interface register changes for AR9340
Date: Tue, 12 Apr 2011 18:27:02 +0530
Message-ID: <1302613042-1754-3-git-send-email-vasanth@atheros.com>
In-Reply-To: <1302613042-1754-1-git-send-email-vasanth@atheros.com>
References: <1302613042-1754-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/reg.h |   73 ++++++++++++++++++++--------------
 1 files changed, 43 insertions(+), 30 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
index 69d75d5..53285a1 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -693,7 +693,7 @@
 #define AR_RC_APB            0x00000002
 #define AR_RC_HOSTIF         0x00000100
 
-#define AR_WA                		0x4004
+#define AR_WA			(AR_SREV_9340(ah) ? 0x40c4 : 0x4004)
 #define AR_WA_BIT6			(1 << 6)
 #define AR_WA_BIT7			(1 << 7)
 #define AR_WA_BIT23			(1 << 23)
@@ -712,7 +712,7 @@
 #define AR_PM_STATE                 0x4008
 #define AR_PM_STATE_PME_D3COLD_VAUX 0x00100000
 
-#define AR_HOST_TIMEOUT             0x4018
+#define AR_HOST_TIMEOUT             (AR_SREV_9340(ah) ? 0x4008 : 0x4018)
 #define AR_HOST_TIMEOUT_APB_CNTR    0x0000FFFF
 #define AR_HOST_TIMEOUT_APB_CNTR_S  0
 #define AR_HOST_TIMEOUT_LCL_CNTR    0xFFFF0000
@@ -742,7 +742,8 @@
 #define EEPROM_PROTECT_WP_1024_2047   0x8000
 
 #define AR_SREV \
-	((AR_SREV_9100(ah)) ? 0x0600 : 0x4020)
+	((AR_SREV_9100(ah)) ? 0x0600 : (AR_SREV_9340(ah) \
+					? 0x400c : 0x4020))
 
 #define AR_SREV_ID \
 	((AR_SREV_9100(ah)) ? 0x00000FFF : 0x000000FF)
@@ -916,11 +917,11 @@ enum ath_usb_dev {
 #define AR_INTR_SPURIOUS                      0xFFFFFFFF
 
 
-#define AR_INTR_SYNC_CAUSE_CLR                0x4028
+#define AR_INTR_SYNC_CAUSE                    (AR_SREV_9340(ah) ? 0x4010 : 0x4028)
+#define AR_INTR_SYNC_CAUSE_CLR                (AR_SREV_9340(ah) ? 0x4010 : 0x4028)
 
-#define AR_INTR_SYNC_CAUSE                    0x4028
 
-#define AR_INTR_SYNC_ENABLE                   0x402c
+#define AR_INTR_SYNC_ENABLE                   (AR_SREV_9340(ah) ? 0x4014 : 0x402c)
 #define AR_INTR_SYNC_ENABLE_GPIO              0xFFFC0000
 #define AR_INTR_SYNC_ENABLE_GPIO_S            18
 
@@ -960,24 +961,24 @@ enum {
 
 };
 
-#define AR_INTR_ASYNC_MASK                       0x4030
+#define AR_INTR_ASYNC_MASK                       (AR_SREV_9340(ah) ? 0x4018 : 0x4030)
 #define AR_INTR_ASYNC_MASK_GPIO                  0xFFFC0000
 #define AR_INTR_ASYNC_MASK_GPIO_S                18
 
-#define AR_INTR_SYNC_MASK                        0x4034
+#define AR_INTR_SYNC_MASK                        (AR_SREV_9340(ah) ? 0x401c : 0x4034)
 #define AR_INTR_SYNC_MASK_GPIO                   0xFFFC0000
 #define AR_INTR_SYNC_MASK_GPIO_S                 18
 
-#define AR_INTR_ASYNC_CAUSE_CLR                  0x4038
-#define AR_INTR_ASYNC_CAUSE                      0x4038
+#define AR_INTR_ASYNC_CAUSE_CLR                  (AR_SREV_9340(ah) ? 0x4020 : 0x4038)
+#define AR_INTR_ASYNC_CAUSE                      (AR_SREV_9340(ah) ? 0x4020 : 0x4038)
 
-#define AR_INTR_ASYNC_ENABLE                     0x403c
+#define AR_INTR_ASYNC_ENABLE                     (AR_SREV_9340(ah) ? 0x4024 : 0x403c)
 #define AR_INTR_ASYNC_ENABLE_GPIO                0xFFFC0000
 #define AR_INTR_ASYNC_ENABLE_GPIO_S              18
 
 #define AR_PCIE_SERDES                           0x4040
 #define AR_PCIE_SERDES2                          0x4044
-#define AR_PCIE_PM_CTRL                          0x4014
+#define AR_PCIE_PM_CTRL                          (AR_SREV_9340(ah) ? 0x4004 : 0x4014)
 #define AR_PCIE_PM_CTRL_ENA                      0x00080000
 
 #define AR_NUM_GPIO                              14
@@ -988,7 +989,7 @@ enum {
 #define AR9300_NUM_GPIO                          17
 #define AR7010_NUM_GPIO                          16
 
-#define AR_GPIO_IN_OUT                           0x4048
+#define AR_GPIO_IN_OUT                           (AR_SREV_9340(ah) ? 0x4028 : 0x4048)
 #define AR_GPIO_IN_VAL                           0x0FFFC000
 #define AR_GPIO_IN_VAL_S                         14
 #define AR928X_GPIO_IN_VAL                       0x000FFC00
@@ -1002,11 +1003,12 @@ enum {
 #define AR7010_GPIO_IN_VAL                       0x0000FFFF
 #define AR7010_GPIO_IN_VAL_S                     0
 
-#define AR_GPIO_IN				 0x404c
+#define AR_GPIO_IN				 (AR_SREV_9340(ah) ? 0x402c : 0x404c)
 #define AR9300_GPIO_IN_VAL                       0x0001FFFF
 #define AR9300_GPIO_IN_VAL_S                     0
 
-#define AR_GPIO_OE_OUT                           (AR_SREV_9300_20_OR_LATER(ah) ? 0x4050 : 0x404c)
+#define AR_GPIO_OE_OUT                           (AR_SREV_9340(ah) ? 0x4030 : \
+						  (AR_SREV_9300_20_OR_LATER(ah) ? 0x4050 : 0x404c))
 #define AR_GPIO_OE_OUT_DRV                       0x3
 #define AR_GPIO_OE_OUT_DRV_NO                    0x0
 #define AR_GPIO_OE_OUT_DRV_LOW                   0x1
@@ -1028,11 +1030,13 @@ enum {
 #define AR7010_GPIO_INT_MASK                     0x52024
 #define AR7010_GPIO_FUNCTION                     0x52028
 
-#define AR_GPIO_INTR_POL                         (AR_SREV_9300_20_OR_LATER(ah) ? 0x4058 : 0x4050)
+#define AR_GPIO_INTR_POL                         (AR_SREV_9340(ah) ? 0x4038 : \
+						  (AR_SREV_9300_20_OR_LATER(ah) ? 0x4058 : 0x4050))
 #define AR_GPIO_INTR_POL_VAL                     0x0001FFFF
 #define AR_GPIO_INTR_POL_VAL_S                   0
 
-#define AR_GPIO_INPUT_EN_VAL                     (AR_SREV_9300_20_OR_LATER(ah) ? 0x405c : 0x4054)
+#define AR_GPIO_INPUT_EN_VAL                     (AR_SREV_9340(ah) ? 0x403c : \
+						  (AR_SREV_9300_20_OR_LATER(ah) ? 0x405c : 0x4054))
 #define AR_GPIO_INPUT_EN_VAL_BT_PRIORITY_DEF     0x00000004
 #define AR_GPIO_INPUT_EN_VAL_BT_PRIORITY_S       2
 #define AR_GPIO_INPUT_EN_VAL_BT_FREQUENCY_DEF    0x00000008
@@ -1050,13 +1054,15 @@ enum {
 #define AR_GPIO_RTC_RESET_OVERRIDE_ENABLE        0x00010000
 #define AR_GPIO_JTAG_DISABLE                     0x00020000
 
-#define AR_GPIO_INPUT_MUX1                       (AR_SREV_9300_20_OR_LATER(ah) ? 0x4060 : 0x4058)
+#define AR_GPIO_INPUT_MUX1                       (AR_SREV_9340(ah) ? 0x4040 : \
+						  (AR_SREV_9300_20_OR_LATER(ah) ? 0x4060 : 0x4058))
 #define AR_GPIO_INPUT_MUX1_BT_ACTIVE             0x000f0000
 #define AR_GPIO_INPUT_MUX1_BT_ACTIVE_S           16
 #define AR_GPIO_INPUT_MUX1_BT_PRIORITY           0x00000f00
 #define AR_GPIO_INPUT_MUX1_BT_PRIORITY_S         8
 
-#define AR_GPIO_INPUT_MUX2                       (AR_SREV_9300_20_OR_LATER(ah) ? 0x4064 : 0x405c)
+#define AR_GPIO_INPUT_MUX2                       (AR_SREV_9340(ah) ? 0x4044 : \
+						  (AR_SREV_9300_20_OR_LATER(ah) ? 0x4064 : 0x405c))
 #define AR_GPIO_INPUT_MUX2_CLK25                 0x0000000f
 #define AR_GPIO_INPUT_MUX2_CLK25_S               0
 #define AR_GPIO_INPUT_MUX2_RFSILENT              0x000000f0
@@ -1064,13 +1070,18 @@ enum {
 #define AR_GPIO_INPUT_MUX2_RTC_RESET             0x00000f00
 #define AR_GPIO_INPUT_MUX2_RTC_RESET_S           8
 
-#define AR_GPIO_OUTPUT_MUX1                      (AR_SREV_9300_20_OR_LATER(ah) ? 0x4068 : 0x4060)
-#define AR_GPIO_OUTPUT_MUX2                      (AR_SREV_9300_20_OR_LATER(ah) ? 0x406c : 0x4064)
-#define AR_GPIO_OUTPUT_MUX3                      (AR_SREV_9300_20_OR_LATER(ah) ? 0x4070 : 0x4068)
+#define AR_GPIO_OUTPUT_MUX1                      (AR_SREV_9340(ah) ? 0x4048 : \
+						  (AR_SREV_9300_20_OR_LATER(ah) ? 0x4068 : 0x4060))
+#define AR_GPIO_OUTPUT_MUX2                      (AR_SREV_9340(ah) ? 0x404c : \
+						  (AR_SREV_9300_20_OR_LATER(ah) ? 0x406c : 0x4064))
+#define AR_GPIO_OUTPUT_MUX3                      (AR_SREV_9340(ah) ? 0x4050 : \
+						  (AR_SREV_9300_20_OR_LATER(ah) ? 0x4070 : 0x4068))
 
-#define AR_INPUT_STATE                           (AR_SREV_9300_20_OR_LATER(ah) ? 0x4074 : 0x406c)
+#define AR_INPUT_STATE                           (AR_SREV_9340(ah) ? 0x4054 : \
+						  (AR_SREV_9300_20_OR_LATER(ah) ? 0x4074 : 0x406c))
 
-#define AR_EEPROM_STATUS_DATA                    (AR_SREV_9300_20_OR_LATER(ah) ? 0x4084 : 0x407c)
+#define AR_EEPROM_STATUS_DATA                    (AR_SREV_9340(ah) ? 0x40c8 : \
+						  (AR_SREV_9300_20_OR_LATER(ah) ? 0x4084 : 0x407c))
 #define AR_EEPROM_STATUS_DATA_VAL                0x0000ffff
 #define AR_EEPROM_STATUS_DATA_VAL_S              0
 #define AR_EEPROM_STATUS_DATA_BUSY               0x00010000
@@ -1078,17 +1089,19 @@ enum {
 #define AR_EEPROM_STATUS_DATA_PROT_ACCESS        0x00040000
 #define AR_EEPROM_STATUS_DATA_ABSENT_ACCESS      0x00080000
 
-#define AR_OBS                  (AR_SREV_9300_20_OR_LATER(ah) ? 0x4088 : 0x4080)
+#define AR_OBS                  (AR_SREV_9340(ah) ? 0x405c : \
+				 (AR_SREV_9300_20_OR_LATER(ah) ? 0x4088 : 0x4080))
 
 #define AR_GPIO_PDPU                             (AR_SREV_9300_20_OR_LATER(ah) ? 0x4090 : 0x4088)
 
-#define AR_PCIE_MSI                              (AR_SREV_9300_20_OR_LATER(ah) ? 0x40a4 : 0x4094)
+#define AR_PCIE_MSI                             (AR_SREV_9340(ah) ? 0x40d8 : \
+						 (AR_SREV_9300_20_OR_LATER(ah) ? 0x40a4 : 0x4094))
 #define AR_PCIE_MSI_ENABLE                       0x00000001
 
-#define AR_INTR_PRIO_SYNC_ENABLE  0x40c4
-#define AR_INTR_PRIO_ASYNC_MASK   0x40c8
-#define AR_INTR_PRIO_SYNC_MASK    0x40cc
-#define AR_INTR_PRIO_ASYNC_ENABLE 0x40d4
+#define AR_INTR_PRIO_SYNC_ENABLE  (AR_SREV_9340(ah) ? 0x4088 : 0x40c4)
+#define AR_INTR_PRIO_ASYNC_MASK   (AR_SREV_9340(ah) ? 0x408c : 0x40c8)
+#define AR_INTR_PRIO_SYNC_MASK    (AR_SREV_9340(ah) ? 0x4090 : 0x40cc)
+#define AR_INTR_PRIO_ASYNC_ENABLE (AR_SREV_9340(ah) ? 0x4094 : 0x40d4)
 #define AR_ENT_OTP		  0x40d8
 #define AR_ENT_OTP_CHAIN2_DISABLE               0x00020000
 #define AR_ENT_OTP_MPSD		0x00800000
-- 
1.7.0.4

