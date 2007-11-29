Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:4146 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755817AbXK2DK4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2007 22:10:56 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Ben Cahill <ben.m.cahill@intel.com>, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 19/36] iwlwifi: move uCode API definitions to iwl-4965-commands.h
Date: Thu, 29 Nov 2007 11:09:59 +0800
Message-Id: <1196305816-23023-20-git-send-email-yi.zhu@intel.com> (sfid-20071129_033548_883641_45A5CEFE)
In-Reply-To: <1196305816-23023-19-git-send-email-yi.zhu@intel.com>
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
 <1196305816-23023-19-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Cahill <ben.m.cahill@intel.com>

Move uCode API definitions to iwl-4965-commands.h

Signed-off-by: Ben Cahill <ben.m.cahill@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965-commands.h |   39 ++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-4965-hw.h       |   37 --------------------
 2 files changed, 39 insertions(+), 37 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-commands.h b/drivers/net/wireless/iwlwifi/iwl-4965-commands.h
index bd55709..49582b9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-commands.h
@@ -335,6 +335,21 @@ enum {
 	RXON_DEV_TYPE_SNIFFER = 6,
 };
 
+
+#define RXON_RX_CHAIN_DRIVER_FORCE_MSK		__constant_cpu_to_le16(0x1<<0)
+#define RXON_RX_CHAIN_VALID_MSK			__constant_cpu_to_le16(0x7<<1)
+#define RXON_RX_CHAIN_VALID_POS			(1)
+#define RXON_RX_CHAIN_FORCE_SEL_MSK		__constant_cpu_to_le16(0x7<<4)
+#define RXON_RX_CHAIN_FORCE_SEL_POS		(4)
+#define RXON_RX_CHAIN_FORCE_MIMO_SEL_MSK	__constant_cpu_to_le16(0x7<<7)
+#define RXON_RX_CHAIN_FORCE_MIMO_SEL_POS	(7)
+#define RXON_RX_CHAIN_CNT_MSK			__constant_cpu_to_le16(0x3<<10)
+#define RXON_RX_CHAIN_CNT_POS			(10)
+#define RXON_RX_CHAIN_MIMO_CNT_MSK		__constant_cpu_to_le16(0x3<<12)
+#define RXON_RX_CHAIN_MIMO_CNT_POS		(12)
+#define RXON_RX_CHAIN_MIMO_FORCE_MSK		__constant_cpu_to_le16(0x1<<14)
+#define RXON_RX_CHAIN_MIMO_FORCE_POS		(14)
+
 /* rx_config flags */
 /* band & modulation selection */
 #define RXON_FLG_BAND_24G_MSK           __constant_cpu_to_le32(1 << 0)
@@ -358,6 +373,21 @@ enum {
 * (according to ON_AIR deassertion) */
 #define RXON_FLG_TSF2HOST_MSK           __constant_cpu_to_le32(1 << 15)
 
+
+/* HT flags */
+#define RXON_FLG_CTRL_CHANNEL_LOC_POS		(22)
+#define RXON_FLG_CTRL_CHANNEL_LOC_HI_MSK	__constant_cpu_to_le32(0x1<<22)
+
+#define RXON_FLG_HT_OPERATING_MODE_POS		(23)
+
+#define RXON_FLG_HT_PROT_MSK			__constant_cpu_to_le32(0x1<<23)
+#define RXON_FLG_FAT_PROT_MSK			__constant_cpu_to_le32(0x2<<23)
+
+#define RXON_FLG_CHANNEL_MODE_POS		(25)
+#define RXON_FLG_CHANNEL_MODE_MSK		__constant_cpu_to_le32(0x3<<25)
+#define RXON_FLG_CHANNEL_MODE_PURE_40_MSK	__constant_cpu_to_le32(0x1<<25)
+#define RXON_FLG_CHANNEL_MODE_MIXED_MSK		__constant_cpu_to_le32(0x2<<25)
+
 /* rx_config filter flags */
 /* accept all data frames */
 #define RXON_FILTER_PROMISC_MSK         __constant_cpu_to_le32(1 << 0)
@@ -431,6 +461,15 @@ struct iwl4965_tx_power {
 #define POWER_TABLE_NUM_ENTRIES			33
 #define POWER_TABLE_NUM_HT_OFDM_ENTRIES		32
 #define POWER_TABLE_CCK_ENTRY			32
+
+union iwl4965_tx_power_dual_stream {
+	struct {
+		u8 radio_tx_gain[2];
+		u8 dsp_predis_atten[2];
+	} s;
+	u32 dw;
+};
+
 struct tx_power_dual_stream {
 	__le32 dw;
 } __attribute__ ((packed));
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-hw.h b/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
index 4b61b89..c5fa086 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
@@ -698,45 +698,8 @@ enum {
 #define CALIB_IWL_TX_ATTEN_GR5_FCH 1
 #define CALIB_IWL_TX_ATTEN_GR5_LCH 20
 
-union iwl4965_tx_power_dual_stream {
-	struct {
-		u8 radio_tx_gain[2];
-		u8 dsp_predis_atten[2];
-	} s;
-	u32 dw;
-};
-
 /********************* END TXPOWER *****************************************/
 
-/* HT flags */
-#define RXON_FLG_CTRL_CHANNEL_LOC_POS		(22)
-#define RXON_FLG_CTRL_CHANNEL_LOC_HI_MSK	__constant_cpu_to_le32(0x1<<22)
-
-#define RXON_FLG_HT_OPERATING_MODE_POS		(23)
-
-#define RXON_FLG_HT_PROT_MSK			__constant_cpu_to_le32(0x1<<23)
-#define RXON_FLG_FAT_PROT_MSK			__constant_cpu_to_le32(0x2<<23)
-
-#define RXON_FLG_CHANNEL_MODE_POS		(25)
-#define RXON_FLG_CHANNEL_MODE_MSK		__constant_cpu_to_le32(0x3<<25)
-#define RXON_FLG_CHANNEL_MODE_PURE_40_MSK	__constant_cpu_to_le32(0x1<<25)
-#define RXON_FLG_CHANNEL_MODE_MIXED_MSK		__constant_cpu_to_le32(0x2<<25)
-
-#define RXON_RX_CHAIN_DRIVER_FORCE_MSK		__constant_cpu_to_le16(0x1<<0)
-#define RXON_RX_CHAIN_VALID_MSK			__constant_cpu_to_le16(0x7<<1)
-#define RXON_RX_CHAIN_VALID_POS			(1)
-#define RXON_RX_CHAIN_FORCE_SEL_MSK		__constant_cpu_to_le16(0x7<<4)
-#define RXON_RX_CHAIN_FORCE_SEL_POS		(4)
-#define RXON_RX_CHAIN_FORCE_MIMO_SEL_MSK	__constant_cpu_to_le16(0x7<<7)
-#define RXON_RX_CHAIN_FORCE_MIMO_SEL_POS	(7)
-#define RXON_RX_CHAIN_CNT_MSK			__constant_cpu_to_le16(0x3<<10)
-#define RXON_RX_CHAIN_CNT_POS			(10)
-#define RXON_RX_CHAIN_MIMO_CNT_MSK		__constant_cpu_to_le16(0x3<<12)
-#define RXON_RX_CHAIN_MIMO_CNT_POS		(12)
-#define RXON_RX_CHAIN_MIMO_FORCE_MSK		__constant_cpu_to_le16(0x1<<14)
-#define RXON_RX_CHAIN_MIMO_FORCE_POS		(14)
-
-
 /* Flow Handler Definitions */
 
 /**********************/
-- 
1.5.3.6
