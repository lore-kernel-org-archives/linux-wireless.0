Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:60992 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753690AbYAOC1B (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jan 2008 21:27:01 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Reinette Chatre <reinette.chatre@intel.com>,
	Stefano Brivio <stefano.brivio@polimi.it>
Subject: [PATCH 12/12] iwlwifi: style fixes to usage of << and >> operators
Date: Mon, 14 Jan 2008 17:46:25 -0800
Message-Id: <1200361585-31801-13-git-send-email-reinette.chatre@intel.com> (sfid-20080115_024519_145527_4ABE22D9)
In-Reply-To: <1200361585-31801-12-git-send-email-reinette.chatre@intel.com>
References: <1200361585-31801-1-git-send-email-reinette.chatre@intel.com>
 <1200361585-31801-2-git-send-email-reinette.chatre@intel.com>
 <1200361585-31801-3-git-send-email-reinette.chatre@intel.com>
 <1200361585-31801-4-git-send-email-reinette.chatre@intel.com>
 <1200361585-31801-5-git-send-email-reinette.chatre@intel.com>
 <1200361585-31801-6-git-send-email-reinette.chatre@intel.com>
 <1200361585-31801-7-git-send-email-reinette.chatre@intel.com>
 <1200361585-31801-8-git-send-email-reinette.chatre@intel.com>
 <1200361585-31801-9-git-send-email-reinette.chatre@intel.com>
 <1200361585-31801-10-git-send-email-reinette.chatre@intel.com>
 <1200361585-31801-11-git-send-email-reinette.chatre@intel.com>
 <1200361585-31801-12-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The << and >> operators need space on each side.

Cc: Stefano Brivio <stefano.brivio@polimi.it>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Acked-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945-commands.h |   12 ++--
 drivers/net/wireless/iwlwifi/iwl-3945-debug.h    |   58 +++++++++++-----------
 drivers/net/wireless/iwlwifi/iwl-3945-hw.h       |   46 +++++++++---------
 drivers/net/wireless/iwlwifi/iwl-3945-rs.h       |   26 +++++-----
 drivers/net/wireless/iwlwifi/iwl-4965-commands.h |   40 ++++++++--------
 drivers/net/wireless/iwlwifi/iwl-4965-debug.h    |   58 +++++++++++-----------
 drivers/net/wireless/iwlwifi/iwl-4965-hw.h       |   36 +++++++-------
 drivers/net/wireless/iwlwifi/iwl-4965-rs.h       |   28 +++++-----
 drivers/net/wireless/iwlwifi/iwl-4965.c          |   12 ++--
 drivers/net/wireless/iwlwifi/iwl3945-base.c      |    2 +-
 drivers/net/wireless/iwlwifi/iwl4965-base.c      |    2 +-
 11 files changed, 160 insertions(+), 160 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-commands.h b/drivers/net/wireless/iwlwifi/iwl-3945-commands.h
index 0c80ed5..46bb2c7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-commands.h
@@ -508,8 +508,8 @@ struct iwl3945_qosparam_cmd {
 #define	IWL_STATION_COUNT	32 	/* MAX(3945,4965)*/
 #define	IWL_INVALID_STATION 	255
 
-#define STA_FLG_TX_RATE_MSK		__constant_cpu_to_le32(1<<2);
-#define STA_FLG_PWR_SAVE_MSK		__constant_cpu_to_le32(1<<8);
+#define STA_FLG_TX_RATE_MSK		__constant_cpu_to_le32(1 << 2);
+#define STA_FLG_PWR_SAVE_MSK		__constant_cpu_to_le32(1 << 8);
 
 /* Use in mode field.  1: modify existing entry, 0: add new station entry */
 #define STA_CONTROL_MODIFY_MSK		0x01
@@ -1010,7 +1010,7 @@ struct iwl3945_rate_scaling_info {
  * For example, if you set 9MB (PLCP 0x0f) as the first
  * rate in the rate table, the bit mask for that rate
  * when passed through ofdm_basic_rates on the REPLY_RXON
- * command would be bit 0 (1<<0)
+ * command would be bit 0 (1 << 0)
  */
 struct iwl3945_rate_scaling_cmd {
 	u8 table_id;
@@ -1190,9 +1190,9 @@ struct iwl3945_spectrum_notification {
  */
 #define IWL_POWER_VEC_SIZE 5
 
-#define IWL_POWER_DRIVER_ALLOW_SLEEP_MSK	__constant_cpu_to_le32(1<<0)
-#define IWL_POWER_SLEEP_OVER_DTIM_MSK		__constant_cpu_to_le32(1<<2)
-#define IWL_POWER_PCI_PM_MSK			__constant_cpu_to_le32(1<<3)
+#define IWL_POWER_DRIVER_ALLOW_SLEEP_MSK	__constant_cpu_to_le32(1 << 0)
+#define IWL_POWER_SLEEP_OVER_DTIM_MSK		__constant_cpu_to_le32(1 << 2)
+#define IWL_POWER_PCI_PM_MSK			__constant_cpu_to_le32(1 << 3)
 struct iwl3945_powertable_cmd {
 	__le32 flags;
 	__le32 rx_data_timeout;
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-debug.h b/drivers/net/wireless/iwlwifi/iwl-3945-debug.h
index ebf0168..f853c6b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-debug.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-debug.h
@@ -75,44 +75,44 @@ static inline void IWL_DEBUG_LIMIT(int level, const char *fmt, ...)
  *
  */
 
-#define IWL_DL_INFO          (1<<0)
-#define IWL_DL_MAC80211      (1<<1)
-#define IWL_DL_HOST_COMMAND  (1<<2)
-#define IWL_DL_STATE         (1<<3)
+#define IWL_DL_INFO          (1 << 0)
+#define IWL_DL_MAC80211      (1 << 1)
+#define IWL_DL_HOST_COMMAND  (1 << 2)
+#define IWL_DL_STATE         (1 << 3)
 
-#define IWL_DL_RADIO         (1<<7)
-#define IWL_DL_POWER         (1<<8)
-#define IWL_DL_TEMP          (1<<9)
+#define IWL_DL_RADIO         (1 << 7)
+#define IWL_DL_POWER         (1 << 8)
+#define IWL_DL_TEMP          (1 << 9)
 
-#define IWL_DL_NOTIF         (1<<10)
-#define IWL_DL_SCAN          (1<<11)
-#define IWL_DL_ASSOC         (1<<12)
-#define IWL_DL_DROP          (1<<13)
+#define IWL_DL_NOTIF         (1 << 10)
+#define IWL_DL_SCAN          (1 << 11)
+#define IWL_DL_ASSOC         (1 << 12)
+#define IWL_DL_DROP          (1 << 13)
 
-#define IWL_DL_TXPOWER       (1<<14)
+#define IWL_DL_TXPOWER       (1 << 14)
 
-#define IWL_DL_AP            (1<<15)
+#define IWL_DL_AP            (1 << 15)
 
-#define IWL_DL_FW            (1<<16)
-#define IWL_DL_RF_KILL       (1<<17)
-#define IWL_DL_FW_ERRORS     (1<<18)
+#define IWL_DL_FW            (1 << 16)
+#define IWL_DL_RF_KILL       (1 << 17)
+#define IWL_DL_FW_ERRORS     (1 << 18)
 
-#define IWL_DL_LED           (1<<19)
+#define IWL_DL_LED           (1 << 19)
 
-#define IWL_DL_RATE          (1<<20)
+#define IWL_DL_RATE          (1 << 20)
 
-#define IWL_DL_CALIB         (1<<21)
-#define IWL_DL_WEP           (1<<22)
-#define IWL_DL_TX            (1<<23)
-#define IWL_DL_RX            (1<<24)
-#define IWL_DL_ISR           (1<<25)
-#define IWL_DL_HT            (1<<26)
-#define IWL_DL_IO            (1<<27)
-#define IWL_DL_11H           (1<<28)
+#define IWL_DL_CALIB         (1 << 21)
+#define IWL_DL_WEP           (1 << 22)
+#define IWL_DL_TX            (1 << 23)
+#define IWL_DL_RX            (1 << 24)
+#define IWL_DL_ISR           (1 << 25)
+#define IWL_DL_HT            (1 << 26)
+#define IWL_DL_IO            (1 << 27)
+#define IWL_DL_11H           (1 << 28)
 
-#define IWL_DL_STATS         (1<<29)
-#define IWL_DL_TX_REPLY      (1<<30)
-#define IWL_DL_QOS           (1<<31)
+#define IWL_DL_STATS         (1 << 29)
+#define IWL_DL_TX_REPLY      (1 << 30)
+#define IWL_DL_QOS           (1 << 31)
 
 #define IWL_ERROR(f, a...) printk(KERN_ERR DRV_NAME ": " f, ## a)
 #define IWL_WARNING(f, a...) printk(KERN_WARNING DRV_NAME ": " f, ## a)
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-hw.h b/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
index 3020e5d..e4e4a85 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
@@ -369,17 +369,17 @@ struct iwl3945_eeprom {
 
 /* interrupt flags in INTA, set by uCode or hardware (e.g. dma),
  * acknowledged (reset) by host writing "1" to flagged bits. */
-#define CSR_INT_BIT_FH_RX        (1<<31) /* Rx DMA, cmd responses, FH_INT[17:16] */
-#define CSR_INT_BIT_HW_ERR       (1<<29) /* DMA hardware error FH_INT[31] */
-#define CSR_INT_BIT_DNLD         (1<<28) /* uCode Download */
-#define CSR_INT_BIT_FH_TX        (1<<27) /* Tx DMA FH_INT[1:0] */
-#define CSR_INT_BIT_MAC_CLK_ACTV (1<<26) /* NIC controller's clock toggled on/off */
-#define CSR_INT_BIT_SW_ERR       (1<<25) /* uCode error */
-#define CSR_INT_BIT_RF_KILL      (1<<7)  /* HW RFKILL switch GP_CNTRL[27] toggled */
-#define CSR_INT_BIT_CT_KILL      (1<<6)  /* Critical temp (chip too hot) rfkill */
-#define CSR_INT_BIT_SW_RX        (1<<3)  /* Rx, command responses, 3945 */
-#define CSR_INT_BIT_WAKEUP       (1<<1)  /* NIC controller waking up (pwr mgmt) */
-#define CSR_INT_BIT_ALIVE        (1<<0)  /* uCode interrupts once it initializes */
+#define CSR_INT_BIT_FH_RX        (1 << 31) /* Rx DMA, cmd responses, FH_INT[17:16] */
+#define CSR_INT_BIT_HW_ERR       (1 << 29) /* DMA hardware error FH_INT[31] */
+#define CSR_INT_BIT_DNLD         (1 << 28) /* uCode Download */
+#define CSR_INT_BIT_FH_TX        (1 << 27) /* Tx DMA FH_INT[1:0] */
+#define CSR_INT_BIT_MAC_CLK_ACTV (1 << 26) /* NIC controller's clock toggled on/off */
+#define CSR_INT_BIT_SW_ERR       (1 << 25) /* uCode error */
+#define CSR_INT_BIT_RF_KILL      (1 << 7)  /* HW RFKILL switch GP_CNTRL[27] toggled */
+#define CSR_INT_BIT_CT_KILL      (1 << 6)  /* Critical temp (chip too hot) rfkill */
+#define CSR_INT_BIT_SW_RX        (1 << 3)  /* Rx, command responses, 3945 */
+#define CSR_INT_BIT_WAKEUP       (1 << 1)  /* NIC controller waking up (pwr mgmt) */
+#define CSR_INT_BIT_ALIVE        (1 << 0)  /* uCode interrupts once it initializes */
 
 #define CSR_INI_SET_MASK	(CSR_INT_BIT_FH_RX   | \
 				 CSR_INT_BIT_HW_ERR  | \
@@ -391,14 +391,14 @@ struct iwl3945_eeprom {
 				 CSR_INT_BIT_ALIVE)
 
 /* interrupt flags in FH (flow handler) (PCI busmaster DMA) */
-#define CSR_FH_INT_BIT_ERR       (1<<31) /* Error */
-#define CSR_FH_INT_BIT_HI_PRIOR  (1<<30) /* High priority Rx, bypass coalescing */
-#define CSR_FH_INT_BIT_RX_CHNL2  (1<<18) /* Rx channel 2 (3945 only) */
-#define CSR_FH_INT_BIT_RX_CHNL1  (1<<17) /* Rx channel 1 */
-#define CSR_FH_INT_BIT_RX_CHNL0  (1<<16) /* Rx channel 0 */
-#define CSR_FH_INT_BIT_TX_CHNL6  (1<<6)  /* Tx channel 6 (3945 only) */
-#define CSR_FH_INT_BIT_TX_CHNL1  (1<<1)  /* Tx channel 1 */
-#define CSR_FH_INT_BIT_TX_CHNL0  (1<<0)  /* Tx channel 0 */
+#define CSR_FH_INT_BIT_ERR       (1 << 31) /* Error */
+#define CSR_FH_INT_BIT_HI_PRIOR  (1 << 30) /* High priority Rx, bypass coalescing */
+#define CSR_FH_INT_BIT_RX_CHNL2  (1 << 18) /* Rx channel 2 (3945 only) */
+#define CSR_FH_INT_BIT_RX_CHNL1  (1 << 17) /* Rx channel 1 */
+#define CSR_FH_INT_BIT_RX_CHNL0  (1 << 16) /* Rx channel 0 */
+#define CSR_FH_INT_BIT_TX_CHNL6  (1 << 6)  /* Tx channel 6 (3945 only) */
+#define CSR_FH_INT_BIT_TX_CHNL1  (1 << 1)  /* Tx channel 1 */
+#define CSR_FH_INT_BIT_TX_CHNL0  (1 << 0)  /* Tx channel 0 */
 
 #define CSR_FH_INT_RX_MASK	(CSR_FH_INT_BIT_HI_PRIOR | \
 				 CSR_FH_INT_BIT_RX_CHNL2 | \
@@ -629,10 +629,10 @@ struct iwl3945_eeprom {
 
 #define U32_PAD(n)		((4-(n))&0x3)
 
-#define TFD_CTL_COUNT_SET(n)       (n<<24)
-#define TFD_CTL_COUNT_GET(ctl)     ((ctl>>24) & 7)
-#define TFD_CTL_PAD_SET(n)         (n<<28)
-#define TFD_CTL_PAD_GET(ctl)       (ctl>>28)
+#define TFD_CTL_COUNT_SET(n)       (n << 24)
+#define TFD_CTL_COUNT_GET(ctl)     ((ctl >> 24) & 7)
+#define TFD_CTL_PAD_SET(n)         (n << 28)
+#define TFD_CTL_PAD_GET(ctl)       (ctl >> 28)
 
 #define TFD_TX_CMD_SLOTS 256
 #define TFD_CMD_SLOTS 32
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-rs.h b/drivers/net/wireless/iwlwifi/iwl-3945-rs.h
index e21a5ba..d5e9220 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-rs.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-rs.h
@@ -86,18 +86,18 @@ enum {
 };
 
 /* #define vs. enum to keep from defaulting to 'large integer' */
-#define	IWL_RATE_6M_MASK   (1<<IWL_RATE_6M_INDEX)
-#define	IWL_RATE_9M_MASK   (1<<IWL_RATE_9M_INDEX)
-#define	IWL_RATE_12M_MASK  (1<<IWL_RATE_12M_INDEX)
-#define	IWL_RATE_18M_MASK  (1<<IWL_RATE_18M_INDEX)
-#define	IWL_RATE_24M_MASK  (1<<IWL_RATE_24M_INDEX)
-#define	IWL_RATE_36M_MASK  (1<<IWL_RATE_36M_INDEX)
-#define	IWL_RATE_48M_MASK  (1<<IWL_RATE_48M_INDEX)
-#define	IWL_RATE_54M_MASK  (1<<IWL_RATE_54M_INDEX)
-#define	IWL_RATE_1M_MASK   (1<<IWL_RATE_1M_INDEX)
-#define	IWL_RATE_2M_MASK   (1<<IWL_RATE_2M_INDEX)
-#define	IWL_RATE_5M_MASK   (1<<IWL_RATE_5M_INDEX)
-#define	IWL_RATE_11M_MASK  (1<<IWL_RATE_11M_INDEX)
+#define	IWL_RATE_6M_MASK   (1 << IWL_RATE_6M_INDEX)
+#define	IWL_RATE_9M_MASK   (1 << IWL_RATE_9M_INDEX)
+#define	IWL_RATE_12M_MASK  (1 << IWL_RATE_12M_INDEX)
+#define	IWL_RATE_18M_MASK  (1 << IWL_RATE_18M_INDEX)
+#define	IWL_RATE_24M_MASK  (1 << IWL_RATE_24M_INDEX)
+#define	IWL_RATE_36M_MASK  (1 << IWL_RATE_36M_INDEX)
+#define	IWL_RATE_48M_MASK  (1 << IWL_RATE_48M_INDEX)
+#define	IWL_RATE_54M_MASK  (1 << IWL_RATE_54M_INDEX)
+#define	IWL_RATE_1M_MASK   (1 << IWL_RATE_1M_INDEX)
+#define	IWL_RATE_2M_MASK   (1 << IWL_RATE_2M_INDEX)
+#define	IWL_RATE_5M_MASK   (1 << IWL_RATE_5M_INDEX)
+#define	IWL_RATE_11M_MASK  (1 << IWL_RATE_11M_INDEX)
 
 /* 3945 uCode API values for (legacy) bit rates, both OFDM and CCK */
 enum {
@@ -157,7 +157,7 @@ enum {
 	(IWL_OFDM_BASIC_RATES_MASK | \
 	 IWL_CCK_BASIC_RATES_MASK)
 
-#define IWL_RATES_MASK ((1<<IWL_RATE_COUNT)-1)
+#define IWL_RATES_MASK ((1 << IWL_RATE_COUNT) - 1)
 
 #define IWL_INVALID_VALUE    -1
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-commands.h b/drivers/net/wireless/iwlwifi/iwl-4965-commands.h
index 9237f8b..f3470c8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-commands.h
@@ -492,18 +492,18 @@ enum {
 };
 
 
-#define RXON_RX_CHAIN_DRIVER_FORCE_MSK		__constant_cpu_to_le16(0x1<<0)
-#define RXON_RX_CHAIN_VALID_MSK			__constant_cpu_to_le16(0x7<<1)
+#define RXON_RX_CHAIN_DRIVER_FORCE_MSK		__constant_cpu_to_le16(0x1 << 0)
+#define RXON_RX_CHAIN_VALID_MSK			__constant_cpu_to_le16(0x7 << 1)
 #define RXON_RX_CHAIN_VALID_POS			(1)
-#define RXON_RX_CHAIN_FORCE_SEL_MSK		__constant_cpu_to_le16(0x7<<4)
+#define RXON_RX_CHAIN_FORCE_SEL_MSK		__constant_cpu_to_le16(0x7 << 4)
 #define RXON_RX_CHAIN_FORCE_SEL_POS		(4)
-#define RXON_RX_CHAIN_FORCE_MIMO_SEL_MSK	__constant_cpu_to_le16(0x7<<7)
+#define RXON_RX_CHAIN_FORCE_MIMO_SEL_MSK	__constant_cpu_to_le16(0x7 << 7)
 #define RXON_RX_CHAIN_FORCE_MIMO_SEL_POS	(7)
-#define RXON_RX_CHAIN_CNT_MSK			__constant_cpu_to_le16(0x3<<10)
+#define RXON_RX_CHAIN_CNT_MSK			__constant_cpu_to_le16(0x3 << 10)
 #define RXON_RX_CHAIN_CNT_POS			(10)
-#define RXON_RX_CHAIN_MIMO_CNT_MSK		__constant_cpu_to_le16(0x3<<12)
+#define RXON_RX_CHAIN_MIMO_CNT_MSK		__constant_cpu_to_le16(0x3 << 12)
 #define RXON_RX_CHAIN_MIMO_CNT_POS		(12)
-#define RXON_RX_CHAIN_MIMO_FORCE_MSK		__constant_cpu_to_le16(0x1<<14)
+#define RXON_RX_CHAIN_MIMO_FORCE_MSK		__constant_cpu_to_le16(0x1 << 14)
 #define RXON_RX_CHAIN_MIMO_FORCE_POS		(14)
 
 /* rx_config flags */
@@ -532,17 +532,17 @@ enum {
 
 /* HT flags */
 #define RXON_FLG_CTRL_CHANNEL_LOC_POS		(22)
-#define RXON_FLG_CTRL_CHANNEL_LOC_HI_MSK	__constant_cpu_to_le32(0x1<<22)
+#define RXON_FLG_CTRL_CHANNEL_LOC_HI_MSK	__constant_cpu_to_le32(0x1 << 22)
 
 #define RXON_FLG_HT_OPERATING_MODE_POS		(23)
 
-#define RXON_FLG_HT_PROT_MSK			__constant_cpu_to_le32(0x1<<23)
-#define RXON_FLG_FAT_PROT_MSK			__constant_cpu_to_le32(0x2<<23)
+#define RXON_FLG_HT_PROT_MSK			__constant_cpu_to_le32(0x1 << 23)
+#define RXON_FLG_FAT_PROT_MSK			__constant_cpu_to_le32(0x2 << 23)
 
 #define RXON_FLG_CHANNEL_MODE_POS		(25)
-#define RXON_FLG_CHANNEL_MODE_MSK		__constant_cpu_to_le32(0x3<<25)
-#define RXON_FLG_CHANNEL_MODE_PURE_40_MSK	__constant_cpu_to_le32(0x1<<25)
-#define RXON_FLG_CHANNEL_MODE_MIXED_MSK		__constant_cpu_to_le32(0x2<<25)
+#define RXON_FLG_CHANNEL_MODE_MSK		__constant_cpu_to_le32(0x3 << 25)
+#define RXON_FLG_CHANNEL_MODE_PURE_40_MSK	__constant_cpu_to_le32(0x1 << 25)
+#define RXON_FLG_CHANNEL_MODE_MIXED_MSK		__constant_cpu_to_le32(0x2 << 25)
 
 /* rx_config filter flags */
 /* accept all data frames */
@@ -713,7 +713,7 @@ struct iwl4965_qosparam_cmd {
 #define	IWL_STATION_COUNT	32 	/* MAX(3945,4965)*/
 #define	IWL_INVALID_STATION 	255
 
-#define STA_FLG_PWR_SAVE_MSK		__constant_cpu_to_le32(1<<8);
+#define STA_FLG_PWR_SAVE_MSK		__constant_cpu_to_le32(1 << 8);
 #define STA_FLG_RTS_MIMO_PROT_MSK	__constant_cpu_to_le32(1 << 17)
 #define STA_FLG_AGG_MPDU_8US_MSK	__constant_cpu_to_le32(1 << 18)
 #define STA_FLG_MAX_AGG_SIZE_POS	(19)
@@ -1333,7 +1333,7 @@ struct iwl4965_txpowertable_cmd {
 } __attribute__ ((packed));
 
 /*RS_NEW_API: only TLC_RTS remains and moved to bit 0 */
-#define  LINK_QUAL_FLAGS_SET_STA_TLC_RTS_MSK	(1<<0)
+#define  LINK_QUAL_FLAGS_SET_STA_TLC_RTS_MSK	(1 << 0)
 
 /* # of EDCA prioritized tx fifos */
 #define  LINK_QUAL_AC_NUM AC_NUM
@@ -1342,8 +1342,8 @@ struct iwl4965_txpowertable_cmd {
 #define  LINK_QUAL_MAX_RETRY_NUM 16
 
 /* Tx antenna selection values */
-#define  LINK_QUAL_ANT_A_MSK (1<<0)
-#define  LINK_QUAL_ANT_B_MSK (1<<1)
+#define  LINK_QUAL_ANT_A_MSK (1 << 0)
+#define  LINK_QUAL_ANT_B_MSK (1 << 1)
 #define  LINK_QUAL_ANT_MSK   (LINK_QUAL_ANT_A_MSK|LINK_QUAL_ANT_B_MSK)
 
 
@@ -1785,9 +1785,9 @@ struct iwl4965_spectrum_notification {
  */
 #define IWL_POWER_VEC_SIZE 5
 
-#define IWL_POWER_DRIVER_ALLOW_SLEEP_MSK	__constant_cpu_to_le16(1<<0)
-#define IWL_POWER_SLEEP_OVER_DTIM_MSK		__constant_cpu_to_le16(1<<2)
-#define IWL_POWER_PCI_PM_MSK			__constant_cpu_to_le16(1<<3)
+#define IWL_POWER_DRIVER_ALLOW_SLEEP_MSK	__constant_cpu_to_le16(1 << 0)
+#define IWL_POWER_SLEEP_OVER_DTIM_MSK		__constant_cpu_to_le16(1 << 2)
+#define IWL_POWER_PCI_PM_MSK			__constant_cpu_to_le16(1 << 3)
 
 struct iwl4965_powertable_cmd {
 	__le16 flags;
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-debug.h b/drivers/net/wireless/iwlwifi/iwl-4965-debug.h
index 00bc1fa..36696bb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-debug.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-debug.h
@@ -75,44 +75,44 @@ static inline void IWL_DEBUG_LIMIT(int level, const char *fmt, ...)
  *
  */
 
-#define IWL_DL_INFO          (1<<0)
-#define IWL_DL_MAC80211      (1<<1)
-#define IWL_DL_HOST_COMMAND  (1<<2)
-#define IWL_DL_STATE         (1<<3)
+#define IWL_DL_INFO          (1 << 0)
+#define IWL_DL_MAC80211      (1 << 1)
+#define IWL_DL_HOST_COMMAND  (1 << 2)
+#define IWL_DL_STATE         (1 << 3)
 
-#define IWL_DL_RADIO         (1<<7)
-#define IWL_DL_POWER         (1<<8)
-#define IWL_DL_TEMP          (1<<9)
+#define IWL_DL_RADIO         (1 << 7)
+#define IWL_DL_POWER         (1 << 8)
+#define IWL_DL_TEMP          (1 << 9)
 
-#define IWL_DL_NOTIF         (1<<10)
-#define IWL_DL_SCAN          (1<<11)
-#define IWL_DL_ASSOC         (1<<12)
-#define IWL_DL_DROP          (1<<13)
+#define IWL_DL_NOTIF         (1 << 10)
+#define IWL_DL_SCAN          (1 << 11)
+#define IWL_DL_ASSOC         (1 << 12)
+#define IWL_DL_DROP          (1 << 13)
 
-#define IWL_DL_TXPOWER       (1<<14)
+#define IWL_DL_TXPOWER       (1 << 14)
 
-#define IWL_DL_AP            (1<<15)
+#define IWL_DL_AP            (1 << 15)
 
-#define IWL_DL_FW            (1<<16)
-#define IWL_DL_RF_KILL       (1<<17)
-#define IWL_DL_FW_ERRORS     (1<<18)
+#define IWL_DL_FW            (1 << 16)
+#define IWL_DL_RF_KILL       (1 << 17)
+#define IWL_DL_FW_ERRORS     (1 << 18)
 
-#define IWL_DL_LED           (1<<19)
+#define IWL_DL_LED           (1 << 19)
 
-#define IWL_DL_RATE          (1<<20)
+#define IWL_DL_RATE          (1 << 20)
 
-#define IWL_DL_CALIB         (1<<21)
-#define IWL_DL_WEP           (1<<22)
-#define IWL_DL_TX            (1<<23)
-#define IWL_DL_RX            (1<<24)
-#define IWL_DL_ISR           (1<<25)
-#define IWL_DL_HT            (1<<26)
-#define IWL_DL_IO            (1<<27)
-#define IWL_DL_11H           (1<<28)
+#define IWL_DL_CALIB         (1 << 21)
+#define IWL_DL_WEP           (1 << 22)
+#define IWL_DL_TX            (1 << 23)
+#define IWL_DL_RX            (1 << 24)
+#define IWL_DL_ISR           (1 << 25)
+#define IWL_DL_HT            (1 << 26)
+#define IWL_DL_IO            (1 << 27)
+#define IWL_DL_11H           (1 << 28)
 
-#define IWL_DL_STATS         (1<<29)
-#define IWL_DL_TX_REPLY      (1<<30)
-#define IWL_DL_QOS           (1<<31)
+#define IWL_DL_STATS         (1 << 29)
+#define IWL_DL_TX_REPLY      (1 << 30)
+#define IWL_DL_QOS           (1 << 31)
 
 #define IWL_ERROR(f, a...) printk(KERN_ERR DRV_NAME ": " f, ## a)
 #define IWL_WARNING(f, a...) printk(KERN_WARNING DRV_NAME ": " f, ## a)
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-hw.h b/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
index 7e7d6e4..ff71c09 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
@@ -461,17 +461,17 @@ struct iwl4965_eeprom {
 
 /* interrupt flags in INTA, set by uCode or hardware (e.g. dma),
  * acknowledged (reset) by host writing "1" to flagged bits. */
-#define CSR_INT_BIT_FH_RX        (1<<31) /* Rx DMA, cmd responses, FH_INT[17:16] */
-#define CSR_INT_BIT_HW_ERR       (1<<29) /* DMA hardware error FH_INT[31] */
-#define CSR_INT_BIT_DNLD         (1<<28) /* uCode Download */
-#define CSR_INT_BIT_FH_TX        (1<<27) /* Tx DMA FH_INT[1:0] */
-#define CSR_INT_BIT_MAC_CLK_ACTV (1<<26) /* NIC controller's clock toggled on/off */
-#define CSR_INT_BIT_SW_ERR       (1<<25) /* uCode error */
-#define CSR_INT_BIT_RF_KILL      (1<<7)  /* HW RFKILL switch GP_CNTRL[27] toggled */
-#define CSR_INT_BIT_CT_KILL      (1<<6)  /* Critical temp (chip too hot) rfkill */
-#define CSR_INT_BIT_SW_RX        (1<<3)  /* Rx, command responses, 3945 */
-#define CSR_INT_BIT_WAKEUP       (1<<1)  /* NIC controller waking up (pwr mgmt) */
-#define CSR_INT_BIT_ALIVE        (1<<0)  /* uCode interrupts once it initializes */
+#define CSR_INT_BIT_FH_RX        (1 << 31) /* Rx DMA, cmd responses, FH_INT[17:16] */
+#define CSR_INT_BIT_HW_ERR       (1 << 29) /* DMA hardware error FH_INT[31] */
+#define CSR_INT_BIT_DNLD         (1 << 28) /* uCode Download */
+#define CSR_INT_BIT_FH_TX        (1 << 27) /* Tx DMA FH_INT[1:0] */
+#define CSR_INT_BIT_MAC_CLK_ACTV (1 << 26) /* NIC controller's clock toggled on/off */
+#define CSR_INT_BIT_SW_ERR       (1 << 25) /* uCode error */
+#define CSR_INT_BIT_RF_KILL      (1 << 7)  /* HW RFKILL switch GP_CNTRL[27] toggled */
+#define CSR_INT_BIT_CT_KILL      (1 << 6)  /* Critical temp (chip too hot) rfkill */
+#define CSR_INT_BIT_SW_RX        (1 << 3)  /* Rx, command responses, 3945 */
+#define CSR_INT_BIT_WAKEUP       (1 << 1)  /* NIC controller waking up (pwr mgmt) */
+#define CSR_INT_BIT_ALIVE        (1 << 0)  /* uCode interrupts once it initializes */
 
 #define CSR_INI_SET_MASK	(CSR_INT_BIT_FH_RX   | \
 				 CSR_INT_BIT_HW_ERR  | \
@@ -483,12 +483,12 @@ struct iwl4965_eeprom {
 				 CSR_INT_BIT_ALIVE)
 
 /* interrupt flags in FH (flow handler) (PCI busmaster DMA) */
-#define CSR_FH_INT_BIT_ERR       (1<<31) /* Error */
-#define CSR_FH_INT_BIT_HI_PRIOR  (1<<30) /* High priority Rx, bypass coalescing */
-#define CSR_FH_INT_BIT_RX_CHNL1  (1<<17) /* Rx channel 1 */
-#define CSR_FH_INT_BIT_RX_CHNL0  (1<<16) /* Rx channel 0 */
-#define CSR_FH_INT_BIT_TX_CHNL1  (1<<1)  /* Tx channel 1 */
-#define CSR_FH_INT_BIT_TX_CHNL0  (1<<0)  /* Tx channel 0 */
+#define CSR_FH_INT_BIT_ERR       (1 << 31) /* Error */
+#define CSR_FH_INT_BIT_HI_PRIOR  (1 << 30) /* High priority Rx, bypass coalescing */
+#define CSR_FH_INT_BIT_RX_CHNL1  (1 << 17) /* Rx channel 1 */
+#define CSR_FH_INT_BIT_RX_CHNL0  (1 << 16) /* Rx channel 0 */
+#define CSR_FH_INT_BIT_TX_CHNL1  (1 << 1)  /* Tx channel 1 */
+#define CSR_FH_INT_BIT_TX_CHNL0  (1 << 0)  /* Tx channel 0 */
 
 #define CSR_FH_INT_RX_MASK	(CSR_FH_INT_BIT_HI_PRIOR | \
 				 CSR_FH_INT_BIT_RX_CHNL1 | \
@@ -1683,7 +1683,7 @@ enum {
 
 /* Mask to enable contiguous Tx DMA/FIFO channels between "lo" and "hi". */
 #define SCD_TXFACT_REG_TXFIFO_MASK(lo, hi) \
-       ((1<<(hi))|((1<<(hi))-(1<<(lo))))
+       ((1 << (hi)) | ((1 << (hi)) - (1 << (lo))))
 
 /*
  * Queue (x) Write Pointers (indexes, really!), one for each Tx queue.
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-rs.h b/drivers/net/wireless/iwlwifi/iwl-4965-rs.h
index 31e21e2..55f7073 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-rs.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-rs.h
@@ -73,19 +73,19 @@ enum {
 };
 
 /* #define vs. enum to keep from defaulting to 'large integer' */
-#define	IWL_RATE_6M_MASK   (1<<IWL_RATE_6M_INDEX)
-#define	IWL_RATE_9M_MASK   (1<<IWL_RATE_9M_INDEX)
-#define	IWL_RATE_12M_MASK  (1<<IWL_RATE_12M_INDEX)
-#define	IWL_RATE_18M_MASK  (1<<IWL_RATE_18M_INDEX)
-#define	IWL_RATE_24M_MASK  (1<<IWL_RATE_24M_INDEX)
-#define	IWL_RATE_36M_MASK  (1<<IWL_RATE_36M_INDEX)
-#define	IWL_RATE_48M_MASK  (1<<IWL_RATE_48M_INDEX)
-#define	IWL_RATE_54M_MASK  (1<<IWL_RATE_54M_INDEX)
-#define IWL_RATE_60M_MASK  (1<<IWL_RATE_60M_INDEX)
-#define	IWL_RATE_1M_MASK   (1<<IWL_RATE_1M_INDEX)
-#define	IWL_RATE_2M_MASK   (1<<IWL_RATE_2M_INDEX)
-#define	IWL_RATE_5M_MASK   (1<<IWL_RATE_5M_INDEX)
-#define	IWL_RATE_11M_MASK  (1<<IWL_RATE_11M_INDEX)
+#define	IWL_RATE_6M_MASK   (1 << IWL_RATE_6M_INDEX)
+#define	IWL_RATE_9M_MASK   (1 << IWL_RATE_9M_INDEX)
+#define	IWL_RATE_12M_MASK  (1 << IWL_RATE_12M_INDEX)
+#define	IWL_RATE_18M_MASK  (1 << IWL_RATE_18M_INDEX)
+#define	IWL_RATE_24M_MASK  (1 << IWL_RATE_24M_INDEX)
+#define	IWL_RATE_36M_MASK  (1 << IWL_RATE_36M_INDEX)
+#define	IWL_RATE_48M_MASK  (1 << IWL_RATE_48M_INDEX)
+#define	IWL_RATE_54M_MASK  (1 << IWL_RATE_54M_INDEX)
+#define IWL_RATE_60M_MASK  (1 << IWL_RATE_60M_INDEX)
+#define	IWL_RATE_1M_MASK   (1 << IWL_RATE_1M_INDEX)
+#define	IWL_RATE_2M_MASK   (1 << IWL_RATE_2M_INDEX)
+#define	IWL_RATE_5M_MASK   (1 << IWL_RATE_5M_INDEX)
+#define	IWL_RATE_11M_MASK  (1 << IWL_RATE_11M_INDEX)
 
 /* 4965 uCode API values for legacy bit rates, both OFDM and CCK */
 enum {
@@ -169,7 +169,7 @@ enum {
 	(IWL_OFDM_BASIC_RATES_MASK | \
 	 IWL_CCK_BASIC_RATES_MASK)
 
-#define IWL_RATES_MASK ((1<<IWL_RATE_COUNT)-1)
+#define IWL_RATES_MASK ((1 << IWL_RATE_COUNT) - 1)
 
 #define IWL_INVALID_VALUE    -1
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 5fcc2a6..04db34b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -815,11 +815,11 @@ static int iwl4965_sens_energy_cck(struct iwl4965_priv *priv,
 	 * This is background noise, which may include transmissions from other
 	 *    networks, measured during silence before our network's beacon */
 	silence_rssi_a = (u8)((rx_info->beacon_silence_rssi_a &
-			    ALL_BAND_FILTER)>>8);
+			    ALL_BAND_FILTER) >> 8);
 	silence_rssi_b = (u8)((rx_info->beacon_silence_rssi_b &
-			    ALL_BAND_FILTER)>>8);
+			    ALL_BAND_FILTER) >> 8);
 	silence_rssi_c = (u8)((rx_info->beacon_silence_rssi_c &
-			    ALL_BAND_FILTER)>>8);
+			    ALL_BAND_FILTER) >> 8);
 
 	val = max(silence_rssi_b, silence_rssi_c);
 	max_silence_rssi = max(silence_rssi_a, (u8) val);
@@ -4233,14 +4233,14 @@ static int iwl4965_tx_status_reply_compressed_ba(struct iwl4965_priv *priv,
 	IWL_DEBUG_TX_REPLY("BA %d %d\n", agg->start_idx, ba_resp->ba_seq_ctl);
 
 	/* Calculate shift to align block-ack bits with our Tx window bits */
-	sh = agg->start_idx - SEQ_TO_INDEX(ba_seq_ctl>>4);
+	sh = agg->start_idx - SEQ_TO_INDEX(ba_seq_ctl >> 4);
 	if (sh < 0) /* tbw something is wrong with indices */
 		sh += 0x100;
 
 	/* don't use 64-bit values for now */
 	bitmap0 = resp_bitmap0 >> sh;
 	bitmap1 = resp_bitmap1 >> sh;
-	bitmap0 |= (resp_bitmap1 & ((1<<sh)|((1<<sh)-1))) << (32 - sh);
+	bitmap0 |= (resp_bitmap1 & ((1 << sh) | ((1 << sh) - 1))) << (32 - sh);
 
 	if (agg->frame_count > (64 - sh)) {
 		IWL_DEBUG_TX_REPLY("more frames than bitmap size");
@@ -4425,7 +4425,7 @@ static int iwl4965_tx_queue_agg_enable(struct iwl4965_priv *priv, int txq_id,
 	iwl4965_tx_queue_set_q2ratid(priv, ra_tid, txq_id);
 
 	/* Set this queue as a chain-building queue */
-	iwl4965_set_bits_prph(priv, KDR_SCD_QUEUECHAIN_SEL, (1<<txq_id));
+	iwl4965_set_bits_prph(priv, KDR_SCD_QUEUECHAIN_SEL, (1 << txq_id));
 
 	/* Place first TFD at index corresponding to start sequence number.
 	 * Assumes that ssn_idx is valid (!= 0xFFF) */
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index d35c0bf..d2a8df4 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -5267,7 +5267,7 @@ static int iwl3945_get_channels_for_scan(struct iwl3945_priv *priv, int phymode,
 			scan_ch->tpc.tx_gain = ((1 << 5) | (5 << 3));
 			/* NOTE: if we were doing 6Mb OFDM for scans we'd use
 			 * power level:
-			 * scan_ch->tpc.tx_gain = ((1<<5) | (2 << 3)) | 3;
+			 * scan_ch->tpc.tx_gain = ((1 << 5) | (2 << 3)) | 3;
 			 */
 		}
 
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index b300e61..9ae071e 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -5698,7 +5698,7 @@ static int iwl4965_get_channels_for_scan(struct iwl4965_priv *priv, int phymode,
 			scan_ch->tpc.tx_gain = ((1 << 5) | (5 << 3));
 			/* NOTE: if we were doing 6Mb OFDM for scans we'd use
 			 * power level:
-			 * scan_ch->tpc.tx_gain = ((1<<5) | (2 << 3)) | 3;
+			 * scan_ch->tpc.tx_gain = ((1 << 5) | (2 << 3)) | 3;
 			 */
 		}
 
-- 
1.5.3.4

