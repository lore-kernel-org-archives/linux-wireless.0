Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:52315 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753160AbXLCLoj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Dec 2007 06:44:39 -0500
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, yi.zhu@intel.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Ben Cahill <ben.m.cahill@intel.com>
Subject: [PATCH 10/34] iwlwifi: Document 4965 rate_n_flags bits
Date: Mon,  3 Dec 2007 13:43:22 +0200
Message-Id: <1196682230902-git-send-email-tomas.winkler@intel.com> (sfid-20071203_114445_339296_4C63BB46)
In-Reply-To: <11966822302864-git-send-email-tomas.winkler@intel.com>
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
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Cahill <ben.m.cahill@intel.com>

Document 4965 rate_n_flags bits

Signed-off-by: Ben Cahill <ben.m.cahill@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965-commands.h |   98 +++++++++++++++++++---
 drivers/net/wireless/iwlwifi/iwl-4965.h          |   30 ++-----
 2 files changed, 92 insertions(+), 36 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-commands.h b/drivers/net/wireless/iwlwifi/iwl-4965-commands.h
index 2703c52..00d4ab7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-commands.h
@@ -141,7 +141,8 @@ enum {
 
 /******************************************************************************
  * (0)
- * Header
+ * Commonly used structures and definitions:
+ * Command header, rate_n_flags
  *
  *****************************************************************************/
 
@@ -167,6 +168,89 @@ struct iwl4965_cmd_header {
 	u8 data[0];
 } __attribute__ ((packed));
 
+/**
+ * 4965 rate_n_flags bit fields
+ *
+ * rate_n_flags format is used in following 4965 commands:
+ *  REPLY_4965_RX (response only)
+ *  REPLY_TX (both command and response)
+ *  REPLY_TX_LINK_QUALITY_CMD
+ *
+ * High-throughput (HT) rate format for bits 7:0 (bit 8 must be "1"):
+ *  2-0:  0)   6 Mbps
+ *        1)  12 Mbps
+ *        2)  18 Mbps
+ *        3)  24 Mbps
+ *        4)  36 Mbps
+ *        5)  48 Mbps
+ *        6)  54 Mbps
+ *        7)  60 Mbps
+ *
+ *    3:  0)  Single stream (SISO)
+ *        1)  Dual stream (MIMO)
+ *
+ *    5:  Value of 0x20 in bits 7:0 indicates 6 Mbps FAT duplicate data
+ *
+ * Legacy OFDM rate format for bits 7:0 (bit 8 must be "0", bit 9 "0"):
+ *  3-0:  0xD)   6 Mbps
+ *        0xF)   9 Mbps
+ *        0x5)  12 Mbps
+ *        0x7)  18 Mbps
+ *        0x9)  24 Mbps
+ *        0xB)  36 Mbps
+ *        0x1)  48 Mbps
+ *        0x3)  54 Mbps
+ *
+ * Legacy CCK rate format for bits 7:0 (bit 8 must be "0", bit 9 "1"):
+ *  3-0:   10)  1 Mbps
+ *         20)  2 Mbps
+ *         55)  5.5 Mbps
+ *        110)  11 Mbps
+ */
+#define RATE_MCS_CODE_MSK 0x7
+#define RATE_MCS_MIMO_POS 3
+#define RATE_MCS_MIMO_MSK 0x8
+#define RATE_MCS_HT_DUP_POS 5
+#define RATE_MCS_HT_DUP_MSK 0x20
+
+/* (1) HT format, (0) legacy format in bits 7:0 */
+#define RATE_MCS_FLAGS_POS 8
+#define RATE_MCS_HT_POS 8
+#define RATE_MCS_HT_MSK 0x100
+
+/* (1) CCK, (0) OFDM.  HT (bit 8) must be "0" for this bit to be valid */
+#define RATE_MCS_CCK_POS 9
+#define RATE_MCS_CCK_MSK 0x200
+
+/* (1) Use Green Field preamble */
+#define RATE_MCS_GF_POS 10
+#define RATE_MCS_GF_MSK 0x400
+
+/* (1) Use 40Mhz FAT channel width, (0) use 20 MHz legacy channel width */
+#define RATE_MCS_FAT_POS 11
+#define RATE_MCS_FAT_MSK 0x800
+
+/* (1) Duplicate data on both 20MHz channels.  FAT (bit 11) must be set. */
+#define RATE_MCS_DUP_POS 12
+#define RATE_MCS_DUP_MSK 0x1000
+
+/* (1) Short guard interval (0.4 usec), (0) normal GI (0.8 usec) */
+#define RATE_MCS_SGI_POS 13
+#define RATE_MCS_SGI_MSK 0x2000
+
+/**
+ * rate_n_flags Tx antenna masks (4965 has 2 transmitters):
+ * bit14:15 01 B inactive, A active
+ *          10 B active, A inactive
+ *          11 Both active
+ */
+#define RATE_MCS_ANT_A_POS	14
+#define RATE_MCS_ANT_B_POS	15
+#define RATE_MCS_ANT_A_MSK	0x4000
+#define RATE_MCS_ANT_B_MSK	0x8000
+#define RATE_MCS_ANT_AB_MSK	0xc000
+
+
 /******************************************************************************
  * (0a)
  * Alive and Error Commands & Responses:
@@ -452,18 +536,6 @@ struct iwl4965_qosparam_cmd {
 #define STA_MODIFY_DELBA_TID_MSK	0x10
 #define BUILD_RAxTID(sta_id, tid)	(((sta_id) << 4) + (tid))
 
-/*
- * Antenna masks:
- * bit14:15 01 B inactive, A active
- *          10 B active, A inactive
- *          11 Both active
- */
-#define RATE_MCS_ANT_A_POS	14
-#define RATE_MCS_ANT_B_POS	15
-#define RATE_MCS_ANT_A_MSK	0x4000
-#define RATE_MCS_ANT_B_MSK	0x8000
-#define RATE_MCS_ANT_AB_MSK	0xc000
-
 struct iwl4965_keyinfo {
 	__le16 key_flags;
 	u8 tkip_rx_tsc_byte2;	/* TSC[2] for key mix ph1 detection */
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.h b/drivers/net/wireless/iwlwifi/iwl-4965.h
index 028c66e..0fb8ee9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.h
@@ -885,6 +885,11 @@ struct iwl4965_traffic_load {
 };
 
 #ifdef CONFIG_IWL4965_HT_AGG
+/**
+ * struct iwl4965_agg_control
+ * @requested_ba: bit map of tids requesting aggregation/block-ack
+ * @granted_ba: bit map of tids granted aggregation/block-ack
+ */
 struct iwl4965_agg_control {
 	unsigned long next_retry;
 	u32 wait_for_agg_status;
@@ -1056,29 +1061,8 @@ struct iwl4965_chain_noise_data {
 	u8 radio_write;
 };
 
-/* IWL4965 */
-#define RATE_MCS_CODE_MSK 0x7
-#define RATE_MCS_MIMO_POS 3
-#define RATE_MCS_MIMO_MSK 0x8
-#define RATE_MCS_HT_DUP_POS 5
-#define RATE_MCS_HT_DUP_MSK 0x20
-#define RATE_MCS_FLAGS_POS 8
-#define RATE_MCS_HT_POS 8
-#define RATE_MCS_HT_MSK 0x100
-#define RATE_MCS_CCK_POS 9
-#define RATE_MCS_CCK_MSK 0x200
-#define RATE_MCS_GF_POS 10
-#define RATE_MCS_GF_MSK 0x400
-
-#define RATE_MCS_FAT_POS 11
-#define RATE_MCS_FAT_MSK 0x800
-#define RATE_MCS_DUP_POS 12
-#define RATE_MCS_DUP_MSK 0x1000
-#define RATE_MCS_SGI_POS 13
-#define RATE_MCS_SGI_MSK 0x2000
-
-#define	EEPROM_SEM_TIMEOUT 10
-#define EEPROM_SEM_RETRY_LIMIT 1000
+#define	EEPROM_SEM_TIMEOUT 10		/* milliseconds */
+#define EEPROM_SEM_RETRY_LIMIT 1000	/* number of attempts (not time) */
 
 
 #ifdef CONFIG_IWL4965_SPECTRUM_MEASUREMENT
-- 
1.5.2.2
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
