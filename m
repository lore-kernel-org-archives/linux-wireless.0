Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f185.google.com ([209.85.216.185]:46082 "EHLO
	mail-px0-f185.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879AbZGODVZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jul 2009 23:21:25 -0400
Received: by pxi15 with SMTP id 15so1398044pxi.33
        for <linux-wireless@vger.kernel.org>; Tue, 14 Jul 2009 20:21:25 -0700 (PDT)
Date: Wed, 15 Jul 2009 08:51:17 +0530
From: Vivek Natarajan <vivek.natraj@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 2/3] ath9k: Add AR9287 based chipsets' register information.
Message-ID: <20090715032117.GD4613@myhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/reg.h |   93 ++++++++++++++++++++++++++++++++++
 1 files changed, 93 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
index 387bbe7..b025800 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -574,6 +574,7 @@
 
 #define AR_D_GBL_IFS_SIFS         0x1030
 #define AR_D_GBL_IFS_SIFS_M       0x0000FFFF
+#define AR_D_GBL_IFS_SIFS_ASYNC_FIFO_DUR 0x000003AB
 #define AR_D_GBL_IFS_SIFS_RESV0   0xFFFFFFFF
 
 #define AR_D_TXBLK_BASE            0x1038
@@ -589,10 +590,12 @@
 #define AR_D_GBL_IFS_SLOT         0x1070
 #define AR_D_GBL_IFS_SLOT_M       0x0000FFFF
 #define AR_D_GBL_IFS_SLOT_RESV0   0xFFFF0000
+#define AR_D_GBL_IFS_SLOT_ASYNC_FIFO_DUR   0x00000420
 
 #define AR_D_GBL_IFS_EIFS         0x10b0
 #define AR_D_GBL_IFS_EIFS_M       0x0000FFFF
 #define AR_D_GBL_IFS_EIFS_RESV0   0xFFFF0000
+#define AR_D_GBL_IFS_EIFS_ASYNC_FIFO_DUR   0x0000A5EB
 
 #define AR_D_GBL_IFS_MISC        0x10f0
 #define AR_D_GBL_IFS_MISC_LFSR_SLICE_SEL        0x00000007
@@ -743,6 +746,9 @@
 #define AR_SREV_REVISION_9285_10              0
 #define AR_SREV_REVISION_9285_11              1
 #define AR_SREV_REVISION_9285_12              2
+#define AR_SREV_VERSION_9287                  0x180
+#define AR_SREV_REVISION_9287_10              0
+#define AR_SREV_REVISION_9287_11              1
 
 #define AR_SREV_5416(_ah) \
 	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_5416_PCI) || \
@@ -799,6 +805,21 @@
 	 (AR_SREV_9285(ah) && ((_ah)->hw_version.macRev >= \
 			       AR_SREV_REVISION_9285_12)))
 
+#define AR_SREV_9287(_ah) \
+	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9287))
+#define AR_SREV_9287_10_OR_LATER(_ah) \
+	(((_ah)->hw_version.macVersion >= AR_SREV_VERSION_9287))
+#define AR_SREV_9287_10(_ah) \
+	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9287) && \
+	 ((_ah)->hw_version.macRev == AR_SREV_REVISION_9287_10))
+#define AR_SREV_9287_11(_ah) \
+	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9287) && \
+	 ((_ah)->hw_version.macRev == AR_SREV_REVISION_9287_11))
+#define AR_SREV_9287_11_OR_LATER(_ah) \
+	(((_ah)->hw_version.macVersion > AR_SREV_VERSION_9287) || \
+	 (((_ah)->hw_version.macVersion == AR_SREV_VERSION_9287) && \
+	  ((_ah)->hw_version.macRev >= AR_SREV_REVISION_9287_11)))
+
 #define AR_RADIO_SREV_MAJOR                   0xf0
 #define AR_RAD5133_SREV_MAJOR                 0xc0
 #define AR_RAD2133_SREV_MAJOR                 0xd0
@@ -814,6 +835,9 @@
 #define AR_AHB_PAGE_SIZE_1K                   0x00000000
 #define AR_AHB_PAGE_SIZE_2K                   0x00000008
 #define AR_AHB_PAGE_SIZE_4K                   0x00000010
+#define AR_AHB_CUSTOM_BURST_EN                0x000000C0
+#define AR_AHB_CUSTOM_BURST_EN_S              6
+#define AR_AHB_CUSTOM_BURST_ASYNC_FIFO_VAL    3
 
 #define AR_INTR_RTC_IRQ                       0x00000001
 #define AR_INTR_MAC_IRQ                       0x00000002
@@ -890,6 +914,7 @@ enum {
 #define AR_NUM_GPIO                              14
 #define AR928X_NUM_GPIO                          10
 #define AR9285_NUM_GPIO                          12
+#define AR9287_NUM_GPIO                          11
 
 #define AR_GPIO_IN_OUT                           0x4048
 #define AR_GPIO_IN_VAL                           0x0FFFC000
@@ -898,6 +923,8 @@ enum {
 #define AR928X_GPIO_IN_VAL_S                     10
 #define AR9285_GPIO_IN_VAL                       0x00FFF000
 #define AR9285_GPIO_IN_VAL_S                     12
+#define AR9287_GPIO_IN_VAL                       0x003FF800
+#define AR9287_GPIO_IN_VAL_S                     11
 
 #define AR_GPIO_OE_OUT                           0x404c
 #define AR_GPIO_OE_OUT_DRV                       0x3
@@ -1159,6 +1186,33 @@ enum {
 #define AR9285_AN_TOP4           0x7870
 #define AR9285_AN_TOP4_DEFAULT   0x10142c00
 
+#define AR9287_AN_RF2G3_CH0             0x7808
+#define AR9287_AN_RF2G3_CH1             0x785c
+#define AR9287_AN_RF2G3_DB1             0xE0000000
+#define AR9287_AN_RF2G3_DB1_S           29
+#define AR9287_AN_RF2G3_DB2             0x1C000000
+#define AR9287_AN_RF2G3_DB2_S           26
+#define AR9287_AN_RF2G3_OB_CCK          0x03800000
+#define AR9287_AN_RF2G3_OB_CCK_S        23
+#define AR9287_AN_RF2G3_OB_PSK          0x00700000
+#define AR9287_AN_RF2G3_OB_PSK_S        20
+#define AR9287_AN_RF2G3_OB_QAM          0x000E0000
+#define AR9287_AN_RF2G3_OB_QAM_S        17
+#define AR9287_AN_RF2G3_OB_PAL_OFF      0x0001C000
+#define AR9287_AN_RF2G3_OB_PAL_OFF_S    14
+
+#define AR9287_AN_TXPC0                 0x7898
+#define AR9287_AN_TXPC0_TXPCMODE        0x0000C000
+#define AR9287_AN_TXPC0_TXPCMODE_S      14
+#define AR9287_AN_TXPC0_TXPCMODE_NORMAL    0
+#define AR9287_AN_TXPC0_TXPCMODE_TEST      1
+#define AR9287_AN_TXPC0_TXPCMODE_TEMPSENSE 2
+#define AR9287_AN_TXPC0_TXPCMODE_ATBTEST   3
+
+#define AR9287_AN_TOP2                  0x78b4
+#define AR9287_AN_TOP2_XPABIAS_LVL      0xC0000000
+#define AR9287_AN_TOP2_XPABIAS_LVL_S    30
+
 #define AR_STA_ID0                 0x8000
 #define AR_STA_ID1                 0x8004
 #define AR_STA_ID1_SADH_MASK       0x0000FFFF
@@ -1193,6 +1247,7 @@ enum {
 #define AR_TIME_OUT_ACK_S    0
 #define AR_TIME_OUT_CTS      0x3FFF0000
 #define AR_TIME_OUT_CTS_S    16
+#define AR_TIME_OUT_ACK_CTS_ASYNC_FIFO_DUR    0x16001D56
 
 #define AR_RSSI_THR          0x8018
 #define AR_RSSI_THR_MASK     0x000000FF
@@ -1208,6 +1263,7 @@ enum {
 #define AR_USEC_TX_LAT_S     14
 #define AR_USEC_RX_LAT       0x1F800000
 #define AR_USEC_RX_LAT_S     23
+#define AR_USEC_ASYNC_FIFO_DUR    0x12e00074
 
 #define AR_RESET_TSF        0x8020
 #define AR_RESET_TSF_ONCE   0x01000000
@@ -1473,6 +1529,10 @@ enum {
 #define AR_SLP_MIB_CLEAR   0x00000001
 #define AR_SLP_MIB_PENDING 0x00000002
 
+#define AR_MAC_PCU_LOGIC_ANALYZER               0x8264
+#define AR_MAC_PCU_LOGIC_ANALYZER_DISBUG20768   0x20000000
+
+
 #define AR_2040_MODE                0x8318
 #define AR_2040_JOINED_RX_CLEAR 0x00000001
 
@@ -1490,6 +1550,39 @@ enum {
 #define AR_PCU_MISC_MODE2_MGMT_CRYPTO_ENABLE           0x00000002
 #define AR_PCU_MISC_MODE2_NO_CRYPTO_FOR_NON_DATA_PKT   0x00000004
 
+#define AR_PCU_MISC_MODE2_RESERVED                     0x00000038
+#define AR_PCU_MISC_MODE2_ADHOC_MCAST_KEYID_ENABLE     0x00000040
+#define AR_PCU_MISC_MODE2_CFP_IGNORE                   0x00000080
+#define AR_PCU_MISC_MODE2_MGMT_QOS                     0x0000FF00
+#define AR_PCU_MISC_MODE2_MGMT_QOS_S                   8
+#define AR_PCU_MISC_MODE2_ENABLE_LOAD_NAV_BEACON_DURATION 0x00010000
+#define AR_PCU_MISC_MODE2_ENABLE_AGGWEP                0x00020000
+#define AR_PCU_MISC_MODE2_HWWAR1                       0x00100000
+#define AR_PCU_MISC_MODE2_HWWAR2                       0x02000000
+#define AR_PCU_MISC_MODE2_RESERVED2                    0xFFFE0000
+
+#define AR_MAC_PCU_ASYNC_FIFO_REG3                     0x8358
+#define AR_MAC_PCU_ASYNC_FIFO_REG3_DATAPATH_SEL        0x00000400
+#define AR_MAC_PCU_ASYNC_FIFO_REG3_SOFT_RESET          0x80000000
+
+
+#define AR_AES_MUTE_MASK0       0x805c
+#define AR_AES_MUTE_MASK0_FC    0x0000FFFF
+#define AR_AES_MUTE_MASK0_QOS   0xFFFF0000
+#define AR_AES_MUTE_MASK0_QOS_S 16
+
+#define AR_AES_MUTE_MASK1              0x8060
+#define AR_AES_MUTE_MASK1_SEQ          0x0000FFFF
+#define AR_AES_MUTE_MASK1_SEQ_S        0
+#define AR_AES_MUTE_MASK1_FC_MGMT      0xFFFF0000
+#define AR_AES_MUTE_MASK1_FC_MGMT_S    16
+
+#define AR_RATE_DURATION_0      0x8700
+#define AR_RATE_DURATION_31     0x87CC
+#define AR_RATE_DURATION_32     0x8780
+#define AR_RATE_DURATION(_n)    (AR_RATE_DURATION_0 + ((_n)<<2))
+
+
 #define AR_KEYTABLE_0           0x8800
 #define AR_KEYTABLE(_n)         (AR_KEYTABLE_0 + ((_n)*32))
 #define AR_KEY_CACHE_SIZE       128
-- 
1.6.0.1

