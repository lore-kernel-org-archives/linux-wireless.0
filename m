Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:34002 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753152AbXLCLpN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Dec 2007 06:45:13 -0500
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, yi.zhu@intel.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Ben Cahill <ben.m.cahill@intel.com>
Subject: [PATCH 19/34] iwlwifi: move HT_IE_EXT_CHANNEL_* driver definitions to iwl-4965.h
Date: Mon,  3 Dec 2007 13:43:31 +0200
Message-Id: <11966822311588-git-send-email-tomas.winkler@intel.com> (sfid-20071203_120556_038017_30051DC4)
In-Reply-To: <11966822312049-git-send-email-tomas.winkler@intel.com>
References: <11966822261109-git-send-email-tomas.winkler@intel.com>
 <11966822291406-git-send-email-tomas.winkler@intel.com>
 <1196682229843-git-send-email-tomas.winkler@intel.com>
 <11966822293932-git-send-email-tomas.winkler@intel.com>
 <11966822291956-git-send-email-tomas.winkler@intel.com>
 <119668222978-git-send-email-tomas.winkler@intel.com>
 <11966822293340-git-send-email-tomas.winkler@intel.com>
 <11966822291143-git-send-email-tomas.winkler@intel.com>
 <11966822301152-git-send-email-tomas.winkler@intel.com>
 <11966822302864-git-send-email-tomas.winkler@intel.com>
 <1196682230902-git-send-email-tomas.winkler@intel.com>
 <11966822302932-git-send-email-tomas.winkler@intel.com>
 <11966822302681-git-send-email-tomas.winkler@intel.com>
 <11966822301936-git-send-email-tomas.winkler@intel.com>
 <11966822302007-git-send-email-tomas.winkler@intel.com>
 <1196682230754-git-send-email-tomas.winkler@intel.com>
 <1196682231211-git-send-email-tomas.winkler@intel.com>
 <11966822313647-git-send-email-tomas.winkler@intel.com>
 <11966822312049-git-send-email-tomas.winkler@intel.com>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Cahill <ben.m.cahill@intel.com>

Move HT_IE_EXT_CHANNEL_* driver definitions to iwl-4965.h

Add comments to guide .h file usage (hw/api/driver definitions)

Minor comment cleanup

Signed-off-by: Ben Cahill <ben.m.cahill@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945-commands.h |    5 +++
 drivers/net/wireless/iwlwifi/iwl-3945-hw.h       |   29 +++++++++----------
 drivers/net/wireless/iwlwifi/iwl-3945.h          |    6 +++-
 drivers/net/wireless/iwlwifi/iwl-4965-commands.h |    5 +++
 drivers/net/wireless/iwlwifi/iwl-4965-hw.h       |   33 ++++++++++-----------
 drivers/net/wireless/iwlwifi/iwl-4965.h          |   25 +++++++++++++---
 6 files changed, 65 insertions(+), 38 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-commands.h b/drivers/net/wireless/iwlwifi/iwl-3945-commands.h
index dc7498d..794db78 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-commands.h
@@ -60,6 +60,11 @@
  * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  *
  *****************************************************************************/
+/*
+ * Please use this file (iwl-3945-commands.h) only for uCode API definitions.
+ * Please use iwl-3945-hw.h for hardware-related definitions.
+ * Please use iwl-3945.h for driver implementation definitions.
+ */
 
 #ifndef __iwl_3945_commands_h__
 #define __iwl_3945_commands_h__
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-hw.h b/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
index b63cd72..c3ea6fb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
@@ -60,6 +60,11 @@
  * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  *
  *****************************************************************************/
+/*
+ * Please use this file (iwl-3945-hw.h) only for hardware-related definitions.
+ * Please use iwl-3945-commands.h for uCode API definitions.
+ * Please use iwl-3945.h for driver implementation definitions.
+ */
 
 #ifndef __iwl_3945_hw__
 #define __iwl_3945_hw__
@@ -73,9 +78,7 @@
 /* Tx rates */
 #define IWL_CCK_RATES 4
 #define IWL_OFDM_RATES 8
-
 #define IWL_HT_RATES 0
-
 #define IWL_MAX_RATES  (IWL_CCK_RATES+IWL_OFDM_RATES+IWL_HT_RATES)
 
 /* Time constants */
@@ -545,11 +548,6 @@ struct iwl3945_eeprom {
 #define FH_TSSR_CBB_BASE        (FH_TSSR_TABLE+0x000)
 #define FH_TSSR_MSG_CONFIG      (FH_TSSR_TABLE+0x008)
 #define FH_TSSR_TX_STATUS       (FH_TSSR_TABLE+0x010)
-/* 18 - reserved */
-
-/* card static random access memory (SRAM) for processor data and instructs */
-#define RTC_INST_LOWER_BOUND			(0x000000)
-#define RTC_DATA_LOWER_BOUND			(0x800000)
 
 
 /* DBM */
@@ -618,7 +616,6 @@ struct iwl3945_eeprom {
 #define TFD_QUEUE_MAX           6
 #define TFD_QUEUE_SIZE_MAX      (256)
 
-/* spectrum and channel data structures */
 #define IWL_NUM_SCAN_RATES         (2)
 
 #define IWL_DEFAULT_TX_RETRY  15
@@ -634,11 +631,6 @@ struct iwl3945_eeprom {
 
 #define U32_PAD(n)		((4-(n))&0x3)
 
-/*
- * Generic queue structure
- *
- * Contains common data for Rx and Tx queues
- */
 #define TFD_CTL_COUNT_SET(n)       (n<<24)
 #define TFD_CTL_COUNT_GET(ctl)     ((ctl>>24) & 7)
 #define TFD_CTL_PAD_SET(n)         (n<<28)
@@ -656,17 +648,24 @@ struct iwl3945_eeprom {
 #define RX_FREE_BUFFERS 64
 #define RX_LOW_WATERMARK 8
 
+/* Size of one Rx buffer in host DRAM */
+#define IWL_RX_BUF_SIZE 3000
 
-/* card static random access memory (SRAM) for processor data and instructs */
+#define RTC_DATA_LOWER_BOUND			(0x800000)
 #define ALM_RTC_INST_UPPER_BOUND		(0x014000)
 #define ALM_RTC_DATA_UPPER_BOUND		(0x808000)
 
 #define ALM_RTC_INST_SIZE (ALM_RTC_INST_UPPER_BOUND - RTC_INST_LOWER_BOUND)
 #define ALM_RTC_DATA_SIZE (ALM_RTC_DATA_UPPER_BOUND - RTC_DATA_LOWER_BOUND)
 
-#define IWL_MAX_BSM_SIZE ALM_RTC_INST_SIZE
+/* Sizes and addresses for instruction and data memory (SRAM) in
+ * 3945's embedded processor.  Driver access is via HBUS_TARG_MEM_* regs. */
+#define RTC_INST_LOWER_BOUND			(0x000000)
 #define IWL_MAX_INST_SIZE ALM_RTC_INST_SIZE
 #define IWL_MAX_DATA_SIZE ALM_RTC_DATA_SIZE
+
+/* Size of uCode instruction memory in bootstrap state machine */
+#define IWL_MAX_BSM_SIZE ALM_RTC_INST_SIZE
 #define IWL_MAX_NUM_QUEUES	8
 
 static inline int iwl3945_hw_valid_rtc_data_addr(u32 addr)
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index e4a9ad1..6f097a0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -23,6 +23,11 @@
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  *****************************************************************************/
+/*
+ * Please use this file (iwl-3945.h) for driver implementation definitions.
+ * Please use iwl-3945-commands.h for uCode API definitions.
+ * Please use iwl-3945-hw.h for hardware-related definitions.
+ */
 
 #ifndef __iwl_3945_h__
 #define __iwl_3945_h__
@@ -72,7 +77,6 @@ enum iwl3945_antenna {
  * else RTS for data/management frames where MPDU is larger
  *   than RTS value.
  */
-#define IWL_RX_BUF_SIZE           3000U
 #define DEFAULT_RTS_THRESHOLD     2347U
 #define MIN_RTS_THRESHOLD         0U
 #define MAX_RTS_THRESHOLD         2347U
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-commands.h b/drivers/net/wireless/iwlwifi/iwl-4965-commands.h
index 49582b9..9910939 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-commands.h
@@ -60,6 +60,11 @@
  * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  *
  *****************************************************************************/
+/*
+ * Please use this file (iwl-4965-commands.h) only for uCode API definitions.
+ * Please use iwl-4965-hw.h for hardware-related definitions.
+ * Please use iwl-4965.h for driver implementation definitions.
+ */
 
 #ifndef __iwl4965_commands_h__
 #define __iwl4965_commands_h__
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-hw.h b/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
index f4e75d7..439ef64 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
@@ -60,6 +60,11 @@
  * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  *
  *****************************************************************************/
+/*
+ * Please use this file (iwl-4965-hw.h) only for hardware-related definitions.
+ * Use iwl-4965-commands.h for uCode API definitions.
+ * Use iwl-4965.h for driver implementation definitions.
+ */
 
 #ifndef __iwl_4965_hw_h__
 #define __iwl_4965_hw_h__
@@ -77,9 +82,7 @@
 /* Tx rates */
 #define IWL_CCK_RATES 4
 #define IWL_OFDM_RATES 8
-
 #define IWL_HT_RATES 16
-
 #define IWL_MAX_RATES  (IWL_CCK_RATES+IWL_OFDM_RATES+IWL_HT_RATES)
 
 /* Time constants */
@@ -449,8 +452,6 @@ struct iwl4965_eeprom {
  */
 #define CSR_HW_REV_WA_REG	(CSR_BASE+0x22C)
 
-#define CSR_HW_IF_CONFIG_REG_BIT_EEPROM_OWN_SEM     (0x00200000)
-
 /* interrupt flags in INTA, set by uCode or hardware (e.g. dma),
  * acknowledged (reset) by host writing "1" to flagged bits. */
 #define CSR_INT_BIT_FH_RX        (1<<31) /* Rx DMA, cmd responses, FH_INT[17:16] */
@@ -592,17 +593,12 @@ struct iwl4965_eeprom {
 #define FH_TSSR_CBB_BASE        (FH_TSSR_TABLE+0x000)
 #define FH_TSSR_MSG_CONFIG      (FH_TSSR_TABLE+0x008)
 #define FH_TSSR_TX_STATUS       (FH_TSSR_TABLE+0x010)
-/* 18 - reserved */
 
-/* card static random access memory (SRAM) for processor data and instructs */
-#define RTC_INST_LOWER_BOUND			(0x000000)
-#define RTC_DATA_LOWER_BOUND			(0x800000)
 
 #define HBUS_TARG_MBX_C_REG_BIT_CMD_BLOCKED         (0x00000004)
 
 #define TFD_QUEUE_SIZE_MAX      (256)
 
-/* spectrum and channel data structures */
 #define IWL_NUM_SCAN_RATES         (2)
 
 #define IWL_DEFAULT_TX_RETRY  15
@@ -623,10 +619,16 @@ struct iwl4965_eeprom {
 #define RX_FREE_BUFFERS 64
 #define RX_LOW_WATERMARK 8
 
+/* Size of one Rx buffer in host DRAM */
 #define IWL_RX_BUF_SIZE_4K (4 * 1024)
 #define IWL_RX_BUF_SIZE_8K (8 * 1024)
-#define IWL_MAX_BSM_SIZE BSM_SRAM_SIZE
+
+/* Sizes and addresses for instruction and data memory (SRAM) in
+ * 4965's embedded processor.  Driver access is via HBUS_TARG_MEM_* regs. */
+#define RTC_INST_LOWER_BOUND			(0x000000)
 #define KDR_RTC_INST_UPPER_BOUND		(0x018000)
+
+#define RTC_DATA_LOWER_BOUND			(0x800000)
 #define KDR_RTC_DATA_UPPER_BOUND		(0x80A000)
 #define KDR_RTC_INST_SIZE    (KDR_RTC_INST_UPPER_BOUND - RTC_INST_LOWER_BOUND)
 #define KDR_RTC_DATA_SIZE    (KDR_RTC_DATA_UPPER_BOUND - RTC_DATA_LOWER_BOUND)
@@ -634,6 +636,9 @@ struct iwl4965_eeprom {
 #define IWL_MAX_INST_SIZE KDR_RTC_INST_SIZE
 #define IWL_MAX_DATA_SIZE KDR_RTC_DATA_SIZE
 
+/* Size of uCode instruction memory in bootstrap state machine */
+#define IWL_MAX_BSM_SIZE BSM_SRAM_SIZE
+
 static inline int iwl4965_hw_valid_rtc_data_addr(u32 addr)
 {
 	return (addr >= RTC_DATA_LOWER_BOUND) &&
@@ -641,13 +646,6 @@ static inline int iwl4965_hw_valid_rtc_data_addr(u32 addr)
 }
 
 /********************* START TXPOWER *****************************************/
-enum {
-	HT_IE_EXT_CHANNEL_NONE = 0,
-	HT_IE_EXT_CHANNEL_ABOVE,
-	HT_IE_EXT_CHANNEL_INVALID,
-	HT_IE_EXT_CHANNEL_BELOW,
-	HT_IE_EXT_CHANNEL_MAX
-};
 
 enum {
 	CALIB_CH_GROUP_1 = 0,
@@ -822,6 +820,7 @@ enum {
 #define CSR_HW_IF_CONFIG_REG_MSK_BOARD_VER	(0x00000C00)
 #define CSR_HW_IF_CONFIG_REG_BIT_MAC_SI		(0x00000100)
 #define CSR_HW_IF_CONFIG_REG_BIT_RADIO_SI	(0x00000200)
+#define CSR_HW_IF_CONFIG_REG_BIT_EEPROM_OWN_SEM (0x00200000)
 
 static inline u8 iwl4965_hw_get_rate(__le32 rate_n_flags)
 {
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.h b/drivers/net/wireless/iwlwifi/iwl-4965.h
index d297f1d..3f16bd8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.h
@@ -23,6 +23,12 @@
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  *****************************************************************************/
+/*
+ * Please use this file (iwl-4965.h) for driver implementation definitions.
+ * Please use iwl-4965-commands.h for uCode API definitions.
+ * Please use iwl-4965-hw.h for hardware-related definitions.
+ */
+
 #ifndef __iwl_4965_h__
 #define __iwl_4965_h__
 
@@ -193,6 +199,15 @@ struct iwl4965_scan_power_info {
 	s8 requested_power;	/* scan pwr (dBm) requested for chnl/rate */
 };
 
+/* For fat_extension_channel */
+enum {
+	HT_IE_EXT_CHANNEL_NONE = 0,
+	HT_IE_EXT_CHANNEL_ABOVE,
+	HT_IE_EXT_CHANNEL_INVALID,
+	HT_IE_EXT_CHANNEL_BELOW,
+	HT_IE_EXT_CHANNEL_MAX
+};
+
 /*
  * One for each channel, holds all channel setup data
  * Some of the fields (e.g. eeprom and flags/max_power_avg) are redundant
@@ -203,14 +218,14 @@ struct iwl4965_scan_power_info {
 struct iwl4965_channel_info {
 	struct iwl4965_channel_tgd_info tgd;
 	struct iwl4965_channel_tgh_info tgh;
-	struct iwl4965_eeprom_channel eeprom;	/* EEPROM regulatory limit */
-	struct iwl4965_eeprom_channel fat_eeprom;	/* EEPROM regulatory limit for
-						 * FAT channel */
+	struct iwl4965_eeprom_channel eeprom;	  /* EEPROM regulatory limit */
+	struct iwl4965_eeprom_channel fat_eeprom; /* EEPROM regulatory limit for
+						   * FAT channel */
 
 	u8 channel;	  /* channel number */
 	u8 flags;	  /* flags copied from EEPROM */
 	s8 max_power_avg; /* (dBm) regul. eeprom, normal Tx, any rate */
-	s8 curr_txpow;	  /* (dBm) regulatory/spectrum/user (not h/w) */
+	s8 curr_txpow;	  /* (dBm) regulatory/spectrum/user (not h/w) limit */
 	s8 min_power;	  /* always 0 */
 	s8 scan_power;	  /* (dBm) regul. eeprom, direct scans, any rate */
 
@@ -229,7 +244,7 @@ struct iwl4965_channel_info {
 	s8 fat_min_power;	/* always 0 */
 	s8 fat_scan_power;	/* (dBm) eeprom, direct scans, any rate */
 	u8 fat_flags;		/* flags copied from EEPROM */
-	u8 fat_extension_channel;
+	u8 fat_extension_channel; /* HT_IE_EXT_CHANNEL_* */
 
 	/* Radio/DSP gain settings for each scan rate, for directed scans. */
 	struct iwl4965_scan_power_info scan_pwr_info[IWL_NUM_SCAN_RATES];
-- 
1.5.2.2
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
