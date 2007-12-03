Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:31699 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752574AbXLCLsy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Dec 2007 06:48:54 -0500
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, yi.zhu@intel.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Ben Cahill <ben.m.cahill@intel.com>
Subject: [PATCH 27/34] iwlwifi: add comments to RXON command and txpower formats
Date: Mon,  3 Dec 2007 13:43:39 +0200
Message-Id: <11966822321616-git-send-email-tomas.winkler@intel.com> (sfid-20071203_114858_029458_CE88EFBB)
In-Reply-To: <11966822324036-git-send-email-tomas.winkler@intel.com>
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
 <11966822311588-git-send-email-tomas.winkler@intel.com>
 <11966822314158-git-send-email-tomas.winkler@intel.com>
 <11966822311498-git-send-email-tomas.winkler@intel.com>
 <11966822311945-git-send-email-tomas.winkler@intel.com>
 <11966822312882-git-send-email-tomas.winkler@intel.com>
 <11966822323269-git-send-email-tomas.winkler@intel.com>
 <11966822321249-git-send-email-tomas.winkler@intel.com>
 <11966822324036-git-send-email-tomas.winkler@intel.com>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Cahill <ben.m.cahill@intel.com>

Add comments to RXON command and txpower formats

Signed-off-by: Ben Cahill <ben.m.cahill@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945-commands.h |   62 ++++++++++---
 drivers/net/wireless/iwlwifi/iwl-4965-commands.h |  104 ++++++++++++++++------
 2 files changed, 124 insertions(+), 42 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-commands.h b/drivers/net/wireless/iwlwifi/iwl-3945-commands.h
index 3d3c7e3..4a8fc68 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-commands.h
@@ -124,7 +124,7 @@ enum {
 	/* Bluetooth device coexistance config command */
 	REPLY_BT_CONFIG = 0x9b,
 
-	/* 4965 Statistics */
+	/* Statistics */
 	REPLY_STATISTICS_CMD = 0x9c,
 	STATISTICS_NOTIFICATION = 0x9d,
 
@@ -140,7 +140,8 @@ enum {
 
 /******************************************************************************
  * (0)
- * Header
+ * Commonly used structures and definitions:
+ * Command header, txpower
  *
  *****************************************************************************/
 
@@ -183,6 +184,36 @@ struct iwl3945_cmd_header {
 	u8 data[0];
 } __attribute__ ((packed));
 
+/**
+ * struct iwl3945_tx_power
+ *
+ * Used in REPLY_TX_PWR_TABLE_CMD, REPLY_SCAN_CMD, REPLY_CHANNEL_SWITCH
+ *
+ * Each entry contains two values:
+ * 1)  DSP gain (or sometimes called DSP attenuation).  This is a fine-grained
+ *     linear value that multiplies the output of the digital signal processor,
+ *     before being sent to the analog radio.
+ * 2)  Radio gain.  This sets the analog gain of the radio Tx path.
+ *     It is a coarser setting, and behaves in a logarithmic (dB) fashion.
+ *
+ * Driver obtains values from struct iwl3945_tx_power power_gain_table[][].
+ */
+struct iwl3945_tx_power {
+	u8 tx_gain;		/* gain for analog radio */
+	u8 dsp_atten;		/* gain for DSP */
+} __attribute__ ((packed));
+
+/**
+ * struct iwl3945_power_per_rate
+ *
+ * Used in REPLY_TX_PWR_TABLE_CMD, REPLY_CHANNEL_SWITCH
+ */
+struct iwl3945_power_per_rate {
+	u8 rate;		/* plcp */
+	struct iwl3945_tx_power tpc;
+	u8 reserved;
+} __attribute__ ((packed));
+
 /******************************************************************************
  * (0a)
  * Alive and Error Commands & Responses:
@@ -328,8 +359,22 @@ enum {
 /* transfer to host non bssid beacons in associated state */
 #define RXON_FILTER_BCON_AWARE_MSK      __constant_cpu_to_le32(1 << 6)
 
-/*
+/**
  * REPLY_RXON = 0x10 (command, has simple generic response)
+ *
+ * RXON tunes the radio tuner to a service channel, and sets up a number
+ * of parameters that are used primarily for Rx, but also for Tx operations.
+ *
+ * NOTE:  When tuning to a new channel, driver must set the
+ *        RXON_FILTER_ASSOC_MSK to 0.  This will clear station-dependent
+ *        info within the device, including the station tables, tx retry
+ *        rate tables, and txpower tables.  Driver must build a new station
+ *        table and txpower table before transmitting anything on the RXON
+ *        channel.
+ *
+ * NOTE:  All RXONs wipe clean the internal txpower table.  Driver must
+ *        issue a new REPLY_TX_PWR_TABLE_CMD after each REPLY_RXON (0x10),
+ *        regardless of whether RXON_FILTER_ASSOC_MSK is set.
  */
 struct iwl3945_rxon_cmd {
 	u8 node_addr[6];
@@ -373,17 +418,6 @@ struct iwl3945_rxon_time_cmd {
 	__le16 reserved;
 } __attribute__ ((packed));
 
-struct iwl3945_tx_power {
-	u8 tx_gain;		/* gain for analog radio */
-	u8 dsp_atten;		/* gain for DSP */
-} __attribute__ ((packed));
-
-struct iwl3945_power_per_rate {
-	u8 rate;		/* plcp */
-	struct iwl3945_tx_power tpc;
-	u8 reserved;
-} __attribute__ ((packed));
-
 /*
  * REPLY_CHANNEL_SWITCH = 0x72 (command, has simple generic response)
  */
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-commands.h b/drivers/net/wireless/iwlwifi/iwl-4965-commands.h
index bde3aa0..0813e3e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-commands.h
@@ -123,7 +123,7 @@ enum {
 	/* Bluetooth device coexistance config command */
 	REPLY_BT_CONFIG = 0x9b,
 
-	/* 4965 Statistics */
+	/* Statistics */
 	REPLY_STATISTICS_CMD = 0x9c,
 	STATISTICS_NOTIFICATION = 0x9d,
 
@@ -147,7 +147,7 @@ enum {
 /******************************************************************************
  * (0)
  * Commonly used structures and definitions:
- * Command header, rate_n_flags
+ * Command header, rate_n_flags, txpower
  *
  *****************************************************************************/
 
@@ -273,6 +273,65 @@ struct iwl4965_cmd_header {
 #define RATE_MCS_ANT_AB_MSK	0xc000
 
 
+/**
+ * struct iwl4965_tx_power - txpower format used in REPLY_SCAN_CMD
+ *
+ * Scan uses only one transmitter, so only one analog/dsp gain pair is needed.
+ */
+struct iwl4965_tx_power {
+	u8 tx_gain;		/* gain for analog radio */
+	u8 dsp_atten;		/* gain for DSP */
+} __attribute__ ((packed));
+
+#define POWER_TABLE_NUM_ENTRIES			33
+#define POWER_TABLE_NUM_HT_OFDM_ENTRIES		32
+#define POWER_TABLE_CCK_ENTRY			32
+
+/**
+ * union iwl4965_tx_power_dual_stream
+ *
+ * Host format used for REPLY_TX_PWR_TABLE_CMD, REPLY_CHANNEL_SWITCH
+ * Use __le32 version (struct tx_power_dual_stream) when building command.
+ *
+ * Driver provides radio gain and DSP attenuation settings to device in pairs,
+ * one value for each transmitter chain.  The first value is for transmitter A,
+ * second for transmitter B.
+ *
+ * For SISO bit rates, both values in a pair should be identical.
+ * For MIMO rates, one value may be different from the other,
+ * in order to balance the Tx output between the two transmitters.
+ *
+ * See more details in doc for TXPOWER in iwl-4965-hw.h.
+ */
+union iwl4965_tx_power_dual_stream {
+	struct {
+		u8 radio_tx_gain[2];
+		u8 dsp_predis_atten[2];
+	} s;
+	u32 dw;
+};
+
+/**
+ * struct tx_power_dual_stream
+ *
+ * Table entries in REPLY_TX_PWR_TABLE_CMD, REPLY_CHANNEL_SWITCH
+ *
+ * Same format as iwl_tx_power_dual_stream, but __le32
+ */
+struct tx_power_dual_stream {
+	__le32 dw;
+} __attribute__ ((packed));
+
+/**
+ * struct iwl4965_tx_power_db
+ *
+ * Entire table within REPLY_TX_PWR_TABLE_CMD, REPLY_CHANNEL_SWITCH
+ */
+struct iwl4965_tx_power_db {
+	struct tx_power_dual_stream power_tbl[POWER_TABLE_NUM_ENTRIES];
+} __attribute__ ((packed));
+
+
 /******************************************************************************
  * (0a)
  * Alive and Error Commands & Responses:
@@ -501,8 +560,22 @@ enum {
 /* transfer to host non bssid beacons in associated state */
 #define RXON_FILTER_BCON_AWARE_MSK      __constant_cpu_to_le32(1 << 6)
 
-/*
+/**
  * REPLY_RXON = 0x10 (command, has simple generic response)
+ *
+ * RXON tunes the radio tuner to a service channel, and sets up a number
+ * of parameters that are used primarily for Rx, but also for Tx operations.
+ *
+ * NOTE:  When tuning to a new channel, driver must set the
+ *        RXON_FILTER_ASSOC_MSK to 0.  This will clear station-dependent
+ *        info within the device, including the station tables, tx retry
+ *        rate tables, and txpower tables.  Driver must build a new station
+ *        table and txpower table before transmitting anything on the RXON
+ *        channel.
+ *
+ * NOTE:  All RXONs wipe clean the internal txpower table.  Driver must
+ *        issue a new REPLY_TX_PWR_TABLE_CMD after each REPLY_RXON (0x10),
+ *        regardless of whether RXON_FILTER_ASSOC_MSK is set.
  */
 struct iwl4965_rxon_cmd {
 	u8 node_addr[6];
@@ -550,31 +623,6 @@ struct iwl4965_rxon_time_cmd {
 	__le16 reserved;
 } __attribute__ ((packed));
 
-struct iwl4965_tx_power {
-	u8 tx_gain;		/* gain for analog radio */
-	u8 dsp_atten;		/* gain for DSP */
-} __attribute__ ((packed));
-
-#define POWER_TABLE_NUM_ENTRIES			33
-#define POWER_TABLE_NUM_HT_OFDM_ENTRIES		32
-#define POWER_TABLE_CCK_ENTRY			32
-
-union iwl4965_tx_power_dual_stream {
-	struct {
-		u8 radio_tx_gain[2];
-		u8 dsp_predis_atten[2];
-	} s;
-	u32 dw;
-};
-
-struct tx_power_dual_stream {
-	__le32 dw;
-} __attribute__ ((packed));
-
-struct iwl4965_tx_power_db {
-	struct tx_power_dual_stream power_tbl[POWER_TABLE_NUM_ENTRIES];
-} __attribute__ ((packed));
-
 /*
  * REPLY_CHANNEL_SWITCH = 0x72 (command, has simple generic response)
  */
-- 
1.5.2.2
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
