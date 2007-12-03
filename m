Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:32093 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753344AbXLCLpO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Dec 2007 06:45:14 -0500
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, yi.zhu@intel.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Ben Cahill <ben.m.cahill@intel.com>
Subject: [PATCH 18/34] iwlwifi: move uCode API definitions to iwl-4965-commands.h
Date: Mon,  3 Dec 2007 13:43:30 +0200
Message-Id: <11966822312049-git-send-email-tomas.winkler@intel.com> (sfid-20071203_120557_177730_CC4961CF)
In-Reply-To: <11966822313647-git-send-email-tomas.winkler@intel.com>
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
Content-Type: text/plain; charset="us-ascii"
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
index 5a61b84..f4e75d7 100644
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
1.5.2.2
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
