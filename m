Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:4146 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755672AbXK2DKy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2007 22:10:54 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Ben Cahill <ben.m.cahill@intel.com>, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 18/36] iwlwifi: clean up unused definitions in iwl-4965-hw.h
Date: Thu, 29 Nov 2007 11:09:58 +0800
Message-Id: <1196305816-23023-19-git-send-email-yi.zhu@intel.com> (sfid-20071129_033541_963640_227654F3)
In-Reply-To: <1196305816-23023-18-git-send-email-yi.zhu@intel.com>
References: <1196305816-23023-1-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-2-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-3-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-4-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-5-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-6-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-7-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-8-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-9-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-10-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-11-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-12-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-13-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-14-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-15-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-16-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-17-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-18-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Cahill <ben.m.cahill@intel.com>

Clean up unused definitions in iwl-4965-hw.h

Signed-off-by: Ben Cahill <ben.m.cahill@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965-hw.h |  395 +---------------------------
 1 files changed, 3 insertions(+), 392 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-hw.h b/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
index 2f0da4d..4b61b89 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
@@ -106,10 +106,6 @@
 #define IWL_EEPROM_ACCESS_TIMEOUT	5000 /* uSec */
 #define IWL_EEPROM_ACCESS_DELAY		10   /* uSec */
 
-/* EEPROM field values */
-#define ANTENNA_SWITCH_NORMAL     0
-#define ANTENNA_SWITCH_INVERSE    1
-
 /*
  * Regulatory channel usage flags in EEPROM struct iwl4965_eeprom_channel.flags.
  *
@@ -133,39 +129,13 @@ enum {
 	EEPROM_CHANNEL_ACTIVE = (1 << 3),	/* active scanning allowed */
 	EEPROM_CHANNEL_RADAR = (1 << 4),	/* radar detection required */
 	EEPROM_CHANNEL_WIDE = (1 << 5),		/* 20 MHz channel okay */
-	EEPROM_CHANNEL_NARROW = (1 << 6),	/* 10 MHz channel, not used */
+	EEPROM_CHANNEL_NARROW = (1 << 6),	/* 10 MHz channel (not used) */
 	EEPROM_CHANNEL_DFS = (1 << 7),	/* dynamic freq selection candidate */
 };
 
-/* EEPROM field lengths */
-#define EEPROM_BOARD_PBA_NUMBER_LENGTH                  11
-
-/* EEPROM field lengths */
-#define EEPROM_BOARD_PBA_NUMBER_LENGTH                  11
-#define EEPROM_REGULATORY_SKU_ID_LENGTH                 4
-#define EEPROM_REGULATORY_BAND1_CHANNELS_LENGTH         14
-#define EEPROM_REGULATORY_BAND2_CHANNELS_LENGTH         13
-#define EEPROM_REGULATORY_BAND3_CHANNELS_LENGTH         12
-#define EEPROM_REGULATORY_BAND4_CHANNELS_LENGTH         11
-#define EEPROM_REGULATORY_BAND5_CHANNELS_LENGTH         6
-
-#define EEPROM_REGULATORY_BAND_24_FAT_CHANNELS_LENGTH 7
-#define EEPROM_REGULATORY_BAND_52_FAT_CHANNELS_LENGTH 11
-#define EEPROM_REGULATORY_CHANNELS_LENGTH ( \
-	EEPROM_REGULATORY_BAND1_CHANNELS_LENGTH + \
-	EEPROM_REGULATORY_BAND2_CHANNELS_LENGTH + \
-	EEPROM_REGULATORY_BAND3_CHANNELS_LENGTH + \
-	EEPROM_REGULATORY_BAND4_CHANNELS_LENGTH + \
-	EEPROM_REGULATORY_BAND5_CHANNELS_LENGTH + \
-	EEPROM_REGULATORY_BAND_24_FAT_CHANNELS_LENGTH + \
-	EEPROM_REGULATORY_BAND_52_FAT_CHANNELS_LENGTH)
-
-#define EEPROM_REGULATORY_NUMBER_OF_BANDS               5
-
 /* SKU Capabilities */
 #define EEPROM_SKU_CAP_SW_RF_KILL_ENABLE                (1 << 0)
 #define EEPROM_SKU_CAP_HW_RF_KILL_ENABLE                (1 << 1)
-#define EEPROM_SKU_CAP_OP_MODE_MRC                      (1 << 7)
 
 /* *regulatory* channel data format in eeprom, one for each channel.
  * There are separate entries for FAT (40 MHz) vs. normal (20 MHz) channels. */
@@ -479,13 +449,6 @@ struct iwl4965_eeprom {
  */
 #define CSR_HW_REV_WA_REG	(CSR_BASE+0x22C)
 
-/* HW I/F configuration */
-#define CSR_HW_IF_CONFIG_REG_BIT_ALMAGOR_MB         (0x00000100)
-#define CSR_HW_IF_CONFIG_REG_BIT_ALMAGOR_MM         (0x00000200)
-#define CSR_HW_IF_CONFIG_REG_BIT_SKU_MRC            (0x00000400)
-#define CSR_HW_IF_CONFIG_REG_BIT_BOARD_TYPE         (0x00000800)
-#define CSR_HW_IF_CONFIG_REG_BITS_SILICON_TYPE_A    (0x00000000)
-#define CSR_HW_IF_CONFIG_REG_BITS_SILICON_TYPE_B    (0x00001000)
 #define CSR_HW_IF_CONFIG_REG_BIT_EEPROM_OWN_SEM     (0x00200000)
 
 /* interrupt flags in INTA, set by uCode or hardware (e.g. dma),
@@ -514,20 +477,16 @@ struct iwl4965_eeprom {
 /* interrupt flags in FH (flow handler) (PCI busmaster DMA) */
 #define CSR_FH_INT_BIT_ERR       (1<<31) /* Error */
 #define CSR_FH_INT_BIT_HI_PRIOR  (1<<30) /* High priority Rx, bypass coalescing */
-#define CSR_FH_INT_BIT_RX_CHNL2  (1<<18) /* Rx channel 2 (3945 only) */
 #define CSR_FH_INT_BIT_RX_CHNL1  (1<<17) /* Rx channel 1 */
 #define CSR_FH_INT_BIT_RX_CHNL0  (1<<16) /* Rx channel 0 */
-#define CSR_FH_INT_BIT_TX_CHNL6  (1<<6)  /* Tx channel 6 (3945 only) */
 #define CSR_FH_INT_BIT_TX_CHNL1  (1<<1)  /* Tx channel 1 */
 #define CSR_FH_INT_BIT_TX_CHNL0  (1<<0)  /* Tx channel 0 */
 
 #define CSR_FH_INT_RX_MASK	(CSR_FH_INT_BIT_HI_PRIOR | \
-				 CSR_FH_INT_BIT_RX_CHNL2 | \
 				 CSR_FH_INT_BIT_RX_CHNL1 | \
 				 CSR_FH_INT_BIT_RX_CHNL0)
 
-#define CSR_FH_INT_TX_MASK	(CSR_FH_INT_BIT_TX_CHNL6 | \
-				 CSR_FH_INT_BIT_TX_CHNL1 | \
+#define CSR_FH_INT_TX_MASK	(CSR_FH_INT_BIT_TX_CHNL1 | \
 				 CSR_FH_INT_BIT_TX_CHNL0 )
 
 
@@ -619,30 +578,6 @@ struct iwl4965_eeprom {
 /*=== FH (data Flow Handler) ===*/
 #define FH_BASE     (0x800)
 
-#define FH_CBCC_TABLE           (FH_BASE+0x140)
-#define FH_TFDB_TABLE           (FH_BASE+0x180)
-#define FH_RCSR_TABLE           (FH_BASE+0x400)
-#define FH_RSSR_TABLE           (FH_BASE+0x4c0)
-#define FH_TCSR_TABLE           (FH_BASE+0x500)
-#define FH_TSSR_TABLE           (FH_BASE+0x680)
-
-/* TFDB (Transmit Frame Buffer Descriptor) */
-#define FH_TFDB(_channel, buf) \
-	(FH_TFDB_TABLE+((_channel)*2+(buf))*0x28)
-#define ALM_FH_TFDB_CHNL_BUF_CTRL_REG(_channel) \
-	(FH_TFDB_TABLE + 0x50 * _channel)
-/* CBCC _channel is [0,2] */
-#define FH_CBCC(_channel)           (FH_CBCC_TABLE+(_channel)*0x8)
-#define FH_CBCC_CTRL(_channel)      (FH_CBCC(_channel)+0x00)
-#define FH_CBCC_BASE(_channel)      (FH_CBCC(_channel)+0x04)
-
-/* RCSR _channel is [0,2] */
-#define FH_RCSR(_channel)           (FH_RCSR_TABLE+(_channel)*0x40)
-#define FH_RCSR_CONFIG(_channel)    (FH_RCSR(_channel)+0x00)
-#define FH_RCSR_RBD_BASE(_channel)  (FH_RCSR(_channel)+0x04)
-#define FH_RCSR_WPTR(_channel)      (FH_RCSR(_channel)+0x20)
-#define FH_RCSR_RPTR_ADDR(_channel) (FH_RCSR(_channel)+0x24)
-
 #define FH_RSCSR_CHNL0_WPTR        (FH_RSCSR_CHNL0_RBDCB_WPTR_REG)
 
 /* RSSR */
@@ -663,202 +598,19 @@ struct iwl4965_eeprom {
 #define RTC_INST_LOWER_BOUND			(0x000000)
 #define RTC_DATA_LOWER_BOUND			(0x800000)
 
-
-/* DBM */
-
-#define ALM_FH_SRVC_CHNL                            (6)
-
-#define ALM_FH_RCSR_RX_CONFIG_REG_POS_RBDC_SIZE     (20)
-#define ALM_FH_RCSR_RX_CONFIG_REG_POS_IRQ_RBTH      (4)
-
-#define ALM_FH_RCSR_RX_CONFIG_REG_BIT_WR_STTS_EN    (0x08000000)
-
-#define ALM_FH_RCSR_RX_CONFIG_REG_VAL_DMA_CHNL_EN_ENABLE        (0x80000000)
-
-#define ALM_FH_RCSR_RX_CONFIG_REG_VAL_RDRBD_EN_ENABLE           (0x20000000)
-
-#define ALM_FH_RCSR_RX_CONFIG_REG_VAL_MAX_FRAG_SIZE_128         (0x01000000)
-
-#define ALM_FH_RCSR_RX_CONFIG_REG_VAL_IRQ_DEST_INT_HOST         (0x00001000)
-
-#define ALM_FH_RCSR_RX_CONFIG_REG_VAL_MSG_MODE_FH               (0x00000000)
-
-#define ALM_FH_TCSR_TX_CONFIG_REG_VAL_MSG_MODE_TXF              (0x00000000)
-#define ALM_FH_TCSR_TX_CONFIG_REG_VAL_MSG_MODE_DRIVER           (0x00000001)
-
-#define ALM_FH_TCSR_TX_CONFIG_REG_VAL_DMA_CREDIT_DISABLE_VAL    (0x00000000)
-#define ALM_FH_TCSR_TX_CONFIG_REG_VAL_DMA_CREDIT_ENABLE_VAL     (0x00000008)
-
-#define ALM_FH_TCSR_TX_CONFIG_REG_VAL_CIRQ_HOST_IFTFD           (0x00200000)
-
-#define ALM_FH_TCSR_TX_CONFIG_REG_VAL_CIRQ_RTC_NOINT            (0x00000000)
-
-#define ALM_FH_TCSR_TX_CONFIG_REG_VAL_DMA_CHNL_PAUSE            (0x00000000)
-#define ALM_FH_TCSR_TX_CONFIG_REG_VAL_DMA_CHNL_ENABLE           (0x80000000)
-
-#define ALM_FH_TCSR_CHNL_TX_BUF_STS_REG_VAL_TFDB_VALID          (0x00004000)
-
-#define ALM_FH_TCSR_CHNL_TX_BUF_STS_REG_BIT_TFDB_WPTR           (0x00000001)
-
-#define ALM_FH_TSSR_TX_MSG_CONFIG_REG_VAL_SNOOP_RD_TXPD_ON      (0xFF000000)
-#define ALM_FH_TSSR_TX_MSG_CONFIG_REG_VAL_ORDER_RD_TXPD_ON      (0x00FF0000)
-
-#define ALM_FH_TSSR_TX_MSG_CONFIG_REG_VAL_MAX_FRAG_SIZE_128B    (0x00000400)
-
-#define ALM_FH_TSSR_TX_MSG_CONFIG_REG_VAL_SNOOP_RD_TFD_ON       (0x00000100)
-#define ALM_FH_TSSR_TX_MSG_CONFIG_REG_VAL_ORDER_RD_CBB_ON       (0x00000080)
-
-#define ALM_FH_TSSR_TX_MSG_CONFIG_REG_VAL_ORDER_RSP_WAIT_TH     (0x00000020)
-#define ALM_FH_TSSR_TX_MSG_CONFIG_REG_VAL_RSP_WAIT_TH           (0x00000005)
-
-#define ALM_TB_MAX_BYTES_COUNT      (0xFFF0)
-
-#define ALM_FH_TSSR_TX_STATUS_REG_BIT_BUFS_EMPTY(_channel) \
-	((1LU << _channel) << 24)
-#define ALM_FH_TSSR_TX_STATUS_REG_BIT_NO_PEND_REQ(_channel) \
-	((1LU << _channel) << 16)
-
-#define ALM_FH_TSSR_TX_STATUS_REG_MSK_CHNL_IDLE(_channel) \
-	(ALM_FH_TSSR_TX_STATUS_REG_BIT_BUFS_EMPTY(_channel) | \
-	 ALM_FH_TSSR_TX_STATUS_REG_BIT_NO_PEND_REQ(_channel))
-#define PCI_CFG_REV_ID_BIT_BASIC_SKU                (0x40)	/* bit 6    */
-#define PCI_CFG_REV_ID_BIT_RTP                      (0x80)	/* bit 7    */
-
 #define HBUS_TARG_MBX_C_REG_BIT_CMD_BLOCKED         (0x00000004)
 
-#define TFD_QUEUE_MIN           0
-#define TFD_QUEUE_MAX           6
 #define TFD_QUEUE_SIZE_MAX      (256)
 
 /* spectrum and channel data structures */
 #define IWL_NUM_SCAN_RATES         (2)
 
-#define IWL_SCAN_FLAG_24GHZ  (1<<0)
-#define IWL_SCAN_FLAG_52GHZ  (1<<1)
-#define IWL_SCAN_FLAG_ACTIVE (1<<2)
-#define IWL_SCAN_FLAG_DIRECT (1<<3)
-
-#define IWL_MAX_CMD_SIZE 1024
-
 #define IWL_DEFAULT_TX_RETRY  15
-#define IWL_MAX_TX_RETRY      16
-
-/*********************************************/
-
-#define RFD_SIZE                              4
-#define NUM_TFD_CHUNKS                        4
 
 #define RX_QUEUE_SIZE                         256
 #define RX_QUEUE_MASK                         255
 #define RX_QUEUE_SIZE_LOG                     8
 
-/* QoS  definitions */
-
-#define CW_MIN_OFDM          15
-#define CW_MAX_OFDM          1023
-#define CW_MIN_CCK           31
-#define CW_MAX_CCK           1023
-
-#define QOS_TX0_CW_MIN_OFDM      CW_MIN_OFDM
-#define QOS_TX1_CW_MIN_OFDM      CW_MIN_OFDM
-#define QOS_TX2_CW_MIN_OFDM      ((CW_MIN_OFDM + 1) / 2 - 1)
-#define QOS_TX3_CW_MIN_OFDM      ((CW_MIN_OFDM + 1) / 4 - 1)
-
-#define QOS_TX0_CW_MIN_CCK       CW_MIN_CCK
-#define QOS_TX1_CW_MIN_CCK       CW_MIN_CCK
-#define QOS_TX2_CW_MIN_CCK       ((CW_MIN_CCK + 1) / 2 - 1)
-#define QOS_TX3_CW_MIN_CCK       ((CW_MIN_CCK + 1) / 4 - 1)
-
-#define QOS_TX0_CW_MAX_OFDM      CW_MAX_OFDM
-#define QOS_TX1_CW_MAX_OFDM      CW_MAX_OFDM
-#define QOS_TX2_CW_MAX_OFDM      CW_MIN_OFDM
-#define QOS_TX3_CW_MAX_OFDM      ((CW_MIN_OFDM + 1) / 2 - 1)
-
-#define QOS_TX0_CW_MAX_CCK       CW_MAX_CCK
-#define QOS_TX1_CW_MAX_CCK       CW_MAX_CCK
-#define QOS_TX2_CW_MAX_CCK       CW_MIN_CCK
-#define QOS_TX3_CW_MAX_CCK       ((CW_MIN_CCK + 1) / 2 - 1)
-
-#define QOS_TX0_AIFS            3
-#define QOS_TX1_AIFS            7
-#define QOS_TX2_AIFS            2
-#define QOS_TX3_AIFS            2
-
-#define QOS_TX0_ACM             0
-#define QOS_TX1_ACM             0
-#define QOS_TX2_ACM             0
-#define QOS_TX3_ACM             0
-
-#define QOS_TX0_TXOP_LIMIT_CCK          0
-#define QOS_TX1_TXOP_LIMIT_CCK          0
-#define QOS_TX2_TXOP_LIMIT_CCK          6016
-#define QOS_TX3_TXOP_LIMIT_CCK          3264
-
-#define QOS_TX0_TXOP_LIMIT_OFDM      0
-#define QOS_TX1_TXOP_LIMIT_OFDM      0
-#define QOS_TX2_TXOP_LIMIT_OFDM      3008
-#define QOS_TX3_TXOP_LIMIT_OFDM      1504
-
-#define DEF_TX0_CW_MIN_OFDM      CW_MIN_OFDM
-#define DEF_TX1_CW_MIN_OFDM      CW_MIN_OFDM
-#define DEF_TX2_CW_MIN_OFDM      CW_MIN_OFDM
-#define DEF_TX3_CW_MIN_OFDM      CW_MIN_OFDM
-
-#define DEF_TX0_CW_MIN_CCK       CW_MIN_CCK
-#define DEF_TX1_CW_MIN_CCK       CW_MIN_CCK
-#define DEF_TX2_CW_MIN_CCK       CW_MIN_CCK
-#define DEF_TX3_CW_MIN_CCK       CW_MIN_CCK
-
-#define DEF_TX0_CW_MAX_OFDM      CW_MAX_OFDM
-#define DEF_TX1_CW_MAX_OFDM      CW_MAX_OFDM
-#define DEF_TX2_CW_MAX_OFDM      CW_MAX_OFDM
-#define DEF_TX3_CW_MAX_OFDM      CW_MAX_OFDM
-
-#define DEF_TX0_CW_MAX_CCK       CW_MAX_CCK
-#define DEF_TX1_CW_MAX_CCK       CW_MAX_CCK
-#define DEF_TX2_CW_MAX_CCK       CW_MAX_CCK
-#define DEF_TX3_CW_MAX_CCK       CW_MAX_CCK
-
-#define DEF_TX0_AIFS            (2)
-#define DEF_TX1_AIFS            (2)
-#define DEF_TX2_AIFS            (2)
-#define DEF_TX3_AIFS            (2)
-
-#define DEF_TX0_ACM             0
-#define DEF_TX1_ACM             0
-#define DEF_TX2_ACM             0
-#define DEF_TX3_ACM             0
-
-#define DEF_TX0_TXOP_LIMIT_CCK        0
-#define DEF_TX1_TXOP_LIMIT_CCK        0
-#define DEF_TX2_TXOP_LIMIT_CCK        0
-#define DEF_TX3_TXOP_LIMIT_CCK        0
-
-#define DEF_TX0_TXOP_LIMIT_OFDM       0
-#define DEF_TX1_TXOP_LIMIT_OFDM       0
-#define DEF_TX2_TXOP_LIMIT_OFDM       0
-#define DEF_TX3_TXOP_LIMIT_OFDM       0
-
-#define QOS_QOS_SETS                  3
-#define QOS_PARAM_SET_ACTIVE          0
-#define QOS_PARAM_SET_DEF_CCK         1
-#define QOS_PARAM_SET_DEF_OFDM        2
-
-#define CTRL_QOS_NO_ACK               (0x0020)
-#define DCT_FLAG_EXT_QOS_ENABLED      (0x10)
-
-#define U32_PAD(n)		((4-(n))&0x3)
-
-/*
- * Generic queue structure
- *
- * Contains common data for Rx and Tx queues
- */
-#define TFD_CTL_COUNT_SET(n)       (n<<24)
-#define TFD_CTL_COUNT_GET(ctl)     ((ctl>>24) & 7)
-#define TFD_CTL_PAD_SET(n)         (n<<28)
-#define TFD_CTL_PAD_GET(ctl)       (ctl>>28)
-
 #define TFD_TX_CMD_SLOTS 256
 #define TFD_CMD_SLOTS 32
 
@@ -917,28 +669,13 @@ enum {
 	(((t) < IWL_TX_POWER_TEMPERATURE_MIN) || \
 	 ((t) > IWL_TX_POWER_TEMPERATURE_MAX))
 
-#define IWL_TX_POWER_ILLEGAL_TEMPERATURE (300)
-
-#define IWL_TX_POWER_TEMPERATURE_DIFFERENCE (2)
-
 #define IWL_TX_POWER_MIMO_REGULATORY_COMPENSATION (6)
 
 #define IWL_TX_POWER_TARGET_POWER_MIN       (0)	/* 0 dBm = 1 milliwatt */
 #define IWL_TX_POWER_TARGET_POWER_MAX      (16)	/* 16 dBm */
 
-/* timeout equivalent to 3 minutes */
-#define IWL_TX_POWER_TIMELIMIT_NOCALIB 1800000000
-
-#define IWL_TX_POWER_CCK_COMPENSATION (9)
-
 #define MIN_TX_GAIN_INDEX		(0)
 #define MIN_TX_GAIN_INDEX_52GHZ_EXT	(-9)
-#define MAX_TX_GAIN_INDEX_52GHZ		(98)
-#define MIN_TX_GAIN_52GHZ		(98)
-#define MAX_TX_GAIN_INDEX_24GHZ		(98)
-#define MIN_TX_GAIN_24GHZ		(98)
-#define MAX_TX_GAIN			(0)
-#define MAX_TX_GAIN_52GHZ_EXT		(-9)
 
 #define IWL_TX_POWER_DEFAULT_REGULATORY_24   (34)
 #define IWL_TX_POWER_DEFAULT_REGULATORY_52   (34)
@@ -949,48 +686,6 @@ enum {
 #define IWL_TX_POWER_SATURATION_MIN          (20)
 #define IWL_TX_POWER_SATURATION_MAX          (50)
 
-/* dv *0.4 = dt; so that 5 degrees temperature diff equals
- * 12.5 in voltage diff */
-#define IWL_TX_TEMPERATURE_UPDATE_LIMIT 9
-
-#define IWL_INVALID_CHANNEL                 (0xffffffff)
-#define IWL_TX_POWER_REGITRY_BIT            (2)
-
-#define MIN_IWL_TX_POWER_CALIB_DUR          (100)
-#define IWL_CCK_FROM_OFDM_POWER_DIFF        (-5)
-#define IWL_CCK_FROM_OFDM_INDEX_DIFF (9)
-
-/* Number of entries in the gain table */
-#define POWER_GAIN_NUM_ENTRIES 78
-#define TX_POW_MAX_SESSION_NUM 5
-/*  timeout equivalent to 3 minutes */
-#define TX_IWL_TIMELIMIT_NOCALIB 1800000000
-
-/* Kedron TX_CALIB_STATES */
-#define IWL_TX_CALIB_STATE_SEND_TX        0x00000001
-#define IWL_TX_CALIB_WAIT_TX_RESPONSE     0x00000002
-#define IWL_TX_CALIB_ENABLED              0x00000004
-#define IWL_TX_CALIB_XVT_ON               0x00000008
-#define IWL_TX_CALIB_TEMPERATURE_CORRECT  0x00000010
-#define IWL_TX_CALIB_WORKING_WITH_XVT     0x00000020
-#define IWL_TX_CALIB_XVT_PERIODICAL       0x00000040
-
-#define NUM_IWL_TX_CALIB_SETTINS 5	/* Number of tx correction groups */
-
-#define IWL_MIN_POWER_IN_VP_TABLE 1	/* 0.5dBm multiplied by 2 */
-#define IWL_MAX_POWER_IN_VP_TABLE 40	/* 20dBm - multiplied by 2 (because
-					 * entries are for each 0.5dBm) */
-#define IWL_STEP_IN_VP_TABLE 1	/* 0.5dB - multiplied by 2 */
-#define IWL_NUM_POINTS_IN_VPTABLE \
-	(1 + IWL_MAX_POWER_IN_VP_TABLE - IWL_MIN_POWER_IN_VP_TABLE)
-
-#define MIN_TX_GAIN_INDEX         (0)
-#define MAX_TX_GAIN_INDEX_52GHZ   (98)
-#define MIN_TX_GAIN_52GHZ         (98)
-#define MAX_TX_GAIN_INDEX_24GHZ   (98)
-#define MIN_TX_GAIN_24GHZ         (98)
-#define MAX_TX_GAIN               (0)
-
 /* First and last channels of all groups */
 #define CALIB_IWL_TX_ATTEN_GR1_FCH 34
 #define CALIB_IWL_TX_ATTEN_GR1_LCH 43
@@ -1003,7 +698,6 @@ enum {
 #define CALIB_IWL_TX_ATTEN_GR5_FCH 1
 #define CALIB_IWL_TX_ATTEN_GR5_LCH 20
 
-
 union iwl4965_tx_power_dual_stream {
 	struct {
 		u8 radio_tx_gain[2];
@@ -1043,23 +737,6 @@ union iwl4965_tx_power_dual_stream {
 #define RXON_RX_CHAIN_MIMO_FORCE_POS		(14)
 
 
-#define MCS_DUP_6M_PLCP 0x20
-
-/* OFDM HT rate masks */
-/* ***************************************** */
-#define R_MCS_6M_MSK 0x1
-#define R_MCS_12M_MSK 0x2
-#define R_MCS_18M_MSK 0x4
-#define R_MCS_24M_MSK 0x8
-#define R_MCS_36M_MSK 0x10
-#define R_MCS_48M_MSK 0x20
-#define R_MCS_54M_MSK 0x40
-#define R_MCS_60M_MSK 0x80
-#define R_MCS_12M_DUAL_MSK 0x100
-#define R_MCS_24M_DUAL_MSK 0x200
-#define R_MCS_36M_DUAL_MSK 0x400
-#define R_MCS_48M_DUAL_MSK 0x800
-
 /* Flow Handler Definitions */
 
 /**********************/
@@ -1107,7 +784,6 @@ union iwl4965_tx_power_dual_stream {
 #define IWL_FH_TCSR_LOWER_BOUND  (IWL_FH_REGS_LOWER_BOUND + 0xD00)
 #define IWL_FH_TCSR_UPPER_BOUND  (IWL_FH_REGS_LOWER_BOUND + 0xE60)
 
-#define IWL_FH_TCSR_CHNL_NUM                            (7)
 #define IWL_FH_TCSR_CHNL_TX_CONFIG_REG(_chnl) \
 	(IWL_FH_TCSR_LOWER_BOUND + 0x20 * _chnl)
 
@@ -1116,23 +792,8 @@ union iwl4965_tx_power_dual_stream {
 #define IWL_FH_TSSR_LOWER_BOUND		(IWL_FH_REGS_LOWER_BOUND + 0xEA0)
 #define IWL_FH_TSSR_UPPER_BOUND		(IWL_FH_REGS_LOWER_BOUND + 0xEC0)
 
-#define IWL_FH_TSSR_TX_MSG_CONFIG_REG	(IWL_FH_TSSR_LOWER_BOUND + 0x008)
 #define IWL_FH_TSSR_TX_STATUS_REG	(IWL_FH_TSSR_LOWER_BOUND + 0x010)
 
-#define IWL_FH_TSSR_TX_MSG_CONFIG_REG_VAL_SNOOP_RD_TXPD_ON	(0xFF000000)
-#define IWL_FH_TSSR_TX_MSG_CONFIG_REG_VAL_ORDER_RD_TXPD_ON	(0x00FF0000)
-
-#define IWL_FH_TSSR_TX_MSG_CONFIG_REG_VAL_MAX_FRAG_SIZE_64B	(0x00000000)
-#define IWL_FH_TSSR_TX_MSG_CONFIG_REG_VAL_MAX_FRAG_SIZE_128B	(0x00000400)
-#define IWL_FH_TSSR_TX_MSG_CONFIG_REG_VAL_MAX_FRAG_SIZE_256B	(0x00000800)
-#define IWL_FH_TSSR_TX_MSG_CONFIG_REG_VAL_MAX_FRAG_SIZE_512B	(0x00000C00)
-
-#define IWL_FH_TSSR_TX_MSG_CONFIG_REG_VAL_SNOOP_RD_TFD_ON	(0x00000100)
-#define IWL_FH_TSSR_TX_MSG_CONFIG_REG_VAL_ORDER_RD_CBB_ON	(0x00000080)
-
-#define IWL_FH_TSSR_TX_MSG_CONFIG_REG_VAL_ORDER_RSP_WAIT_TH	(0x00000020)
-#define IWL_FH_TSSR_TX_MSG_CONFIG_REG_VAL_RSP_WAIT_TH		(0x00000005)
-
 #define IWL_FH_TSSR_TX_STATUS_REG_BIT_BUFS_EMPTY(_chnl)	\
 	((1 << (_chnl)) << 24)
 #define IWL_FH_TSSR_TX_STATUS_REG_BIT_NO_PEND_REQ(_chnl) \
@@ -1142,60 +803,21 @@ union iwl4965_tx_power_dual_stream {
 	(IWL_FH_TSSR_TX_STATUS_REG_BIT_BUFS_EMPTY(_chnl) | \
 	IWL_FH_TSSR_TX_STATUS_REG_BIT_NO_PEND_REQ(_chnl))
 
-/* TCSR: tx_config register values */
-#define IWL_FH_TCSR_TX_CONFIG_REG_VAL_MSG_MODE_TXF              (0x00000000)
-#define IWL_FH_TCSR_TX_CONFIG_REG_VAL_MSG_MODE_DRIVER           (0x00000001)
-#define IWL_FH_TCSR_TX_CONFIG_REG_VAL_MSG_MODE_ARC              (0x00000002)
-
-#define IWL_FH_TCSR_TX_CONFIG_REG_VAL_DMA_CREDIT_DISABLE_VAL    (0x00000000)
 #define IWL_FH_TCSR_TX_CONFIG_REG_VAL_DMA_CREDIT_ENABLE_VAL     (0x00000008)
 
-#define IWL_FH_TCSR_TX_CONFIG_REG_VAL_CIRQ_HOST_NOINT           (0x00000000)
-#define IWL_FH_TCSR_TX_CONFIG_REG_VAL_CIRQ_HOST_ENDTFD          (0x00100000)
-#define IWL_FH_TCSR_TX_CONFIG_REG_VAL_CIRQ_HOST_IFTFD           (0x00200000)
-
-#define IWL_FH_TCSR_TX_CONFIG_REG_VAL_CIRQ_RTC_NOINT            (0x00000000)
-#define IWL_FH_TCSR_TX_CONFIG_REG_VAL_CIRQ_RTC_ENDTFD           (0x00400000)
-#define IWL_FH_TCSR_TX_CONFIG_REG_VAL_CIRQ_RTC_IFTFD            (0x00800000)
-
-#define IWL_FH_TCSR_TX_CONFIG_REG_VAL_DMA_CHNL_PAUSE            (0x00000000)
-#define IWL_FH_TCSR_TX_CONFIG_REG_VAL_DMA_CHNL_PAUSE_EOF        (0x40000000)
 #define IWL_FH_TCSR_TX_CONFIG_REG_VAL_DMA_CHNL_ENABLE           (0x80000000)
 
-#define IWL_FH_TCSR_CHNL_TX_BUF_STS_REG_VAL_TFDB_EMPTY          (0x00000000)
-#define IWL_FH_TCSR_CHNL_TX_BUF_STS_REG_VAL_TFDB_WAIT           (0x00002000)
-#define IWL_FH_TCSR_CHNL_TX_BUF_STS_REG_VAL_TFDB_VALID          (0x00000003)
-
-#define IWL_FH_TCSR_CHNL_TX_BUF_STS_REG_BIT_TFDB_WPTR           (0x00000001)
-
-#define IWL_FH_TCSR_CHNL_TX_BUF_STS_REG_POS_TB_NUM              (20)
-#define IWL_FH_TCSR_CHNL_TX_BUF_STS_REG_POS_TB_IDX              (12)
-
 /* RCSR:  channel 0 rx_config register defines */
-#define FH_RCSR_CHNL0_RX_CONFIG_DMA_CHNL_EN_MASK  (0xC0000000) /* bits 30-31 */
-#define FH_RCSR_CHNL0_RX_CONFIG_RBDBC_SIZE_MASK   (0x00F00000) /* bits 20-23 */
-#define FH_RCSR_CHNL0_RX_CONFIG_RB_SIZE_MASK	  (0x00030000) /* bits 16-17 */
-#define FH_RCSR_CHNL0_RX_CONFIG_SINGLE_FRAME_MASK (0x00008000) /* bit 15 */
-#define FH_RCSR_CHNL0_RX_CONFIG_IRQ_DEST_MASK     (0x00001000) /* bit 12 */
-#define FH_RCSR_CHNL0_RX_CONFIG_RB_TIMEOUT_MASK   (0x00000FF0) /* bit 4-11 */
 
 #define FH_RCSR_RX_CONFIG_RBDCB_SIZE_BITSHIFT       (20)
-#define FH_RCSR_RX_CONFIG_RB_SIZE_BITSHIFT			(16)
 
-/* RCSR: rx_config register values */
-#define FH_RCSR_RX_CONFIG_CHNL_EN_PAUSE_VAL         (0x00000000)
-#define FH_RCSR_RX_CONFIG_CHNL_EN_PAUSE_EOF_VAL     (0x40000000)
 #define FH_RCSR_RX_CONFIG_CHNL_EN_ENABLE_VAL        (0x80000000)
 
 #define IWL_FH_RCSR_RX_CONFIG_REG_VAL_RB_SIZE_4K    (0x00000000)
 
 /* RCSR channel 0 config register values */
-#define FH_RCSR_CHNL0_RX_CONFIG_IRQ_DEST_NO_INT_VAL       (0x00000000)
 #define FH_RCSR_CHNL0_RX_CONFIG_IRQ_DEST_INT_HOST_VAL     (0x00001000)
 
-/* RSCSR: defs used in normal mode */
-#define FH_RSCSR_CHNL0_RBDCB_WPTR_MASK		(0x00000FFF)	/* bits 0-11 */
-
 #define SCD_WIN_SIZE				64
 #define SCD_FRAME_LIMIT				64
 
@@ -1210,12 +832,6 @@ union iwl4965_tx_power_dual_stream {
 #define SCD_TXFACT_REG_TXFIFO_MASK(lo, hi) \
        ((1<<(hi))|((1<<(hi))-(1<<(lo))))
 
-
-#define SCD_MODE_REG_BIT_SEARCH_MODE		(1<<0)
-#define SCD_MODE_REG_BIT_SBYP_MODE		(1<<1)
-
-#define SCD_TXFIFO_POS_TID			(0)
-#define SCD_TXFIFO_POS_RA			(4)
 #define SCD_QUEUE_STTS_REG_POS_ACTIVE		(0)
 #define SCD_QUEUE_STTS_REG_POS_TXF		(1)
 #define SCD_QUEUE_STTS_REG_POS_WSL		(5)
@@ -1223,14 +839,9 @@ union iwl4965_tx_power_dual_stream {
 #define SCD_QUEUE_STTS_REG_POS_SCD_ACT_EN	(10)
 #define SCD_QUEUE_STTS_REG_MSK			(0x0007FC00)
 
-#define SCD_QUEUE_RA_TID_MAP_RATID_MSK		(0x01FF)
-
 #define SCD_QUEUE_CTX_REG1_WIN_SIZE_POS		(0)
 #define SCD_QUEUE_CTX_REG1_WIN_SIZE_MSK		(0x0000007F)
-#define SCD_QUEUE_CTX_REG1_CREDIT_POS		(8)
-#define SCD_QUEUE_CTX_REG1_CREDIT_MSK		(0x00FFFF00)
-#define SCD_QUEUE_CTX_REG1_SUPER_CREDIT_POS	(24)
-#define SCD_QUEUE_CTX_REG1_SUPER_CREDIT_MSK	(0xFF000000)
+
 #define SCD_QUEUE_CTX_REG2_FRAME_LIMIT_POS	(16)
 #define SCD_QUEUE_CTX_REG2_FRAME_LIMIT_MSK	(0x007F0000)
 
-- 
1.5.3.6
