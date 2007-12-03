Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:31699 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752977AbXLCLsy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Dec 2007 06:48:54 -0500
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, yi.zhu@intel.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Ben Cahill <ben.m.cahill@intel.com>
Subject: [PATCH 26/34] iwlwifi: document command header and "alive" responses
Date: Mon,  3 Dec 2007 13:43:38 +0200
Message-Id: <11966822324036-git-send-email-tomas.winkler@intel.com> (sfid-20071203_114859_309439_654645E3)
In-Reply-To: <11966822321249-git-send-email-tomas.winkler@intel.com>
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
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Cahill <ben.m.cahill@intel.com>

Document command header and "alive" responses

Signed-off-by: Ben Cahill <ben.m.cahill@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945-commands.h |   85 +++++++++---
 drivers/net/wireless/iwlwifi/iwl-4965-commands.h |  160 +++++++++++++++++-----
 2 files changed, 192 insertions(+), 53 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-commands.h b/drivers/net/wireless/iwlwifi/iwl-3945-commands.h
index 794db78..3d3c7e3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-commands.h
@@ -121,7 +121,7 @@ enum {
 	REPLY_TX_PWR_TABLE_CMD = 0x97,
 	MEASURE_ABORT_NOTIFICATION = 0x99,	/* not used */
 
-	/* BT config command */
+	/* Bluetooth device coexistance config command */
 	REPLY_BT_CONFIG = 0x9b,
 
 	/* 4965 Statistics */
@@ -144,25 +144,42 @@ enum {
  *
  *****************************************************************************/
 
+/* iwl3945_cmd_header flags value */
 #define IWL_CMD_FAILED_MSK 0x40
 
+/**
+ * struct iwl3945_cmd_header
+ *
+ * This header format appears in the beginning of each command sent from the
+ * driver, and each response/notification received from uCode.
+ */
 struct iwl3945_cmd_header {
-	u8 cmd;
-	u8 flags;
-	/* We have 15 LSB to use as we please (MSB indicates
-	 * a frame Rx'd from the HW).  We encode the following
-	 * information into the sequence field:
+	u8 cmd;		/* Command ID:  REPLY_RXON, etc. */
+	u8 flags;	/* IWL_CMD_* */
+	/*
+	 * The driver sets up the sequence number to values of its chosing.
+	 * uCode does not use this value, but passes it back to the driver
+	 * when sending the response to each driver-originated command, so
+	 * the driver can match the response to the command.  Since the values
+	 * don't get used by uCode, the driver may set up an arbitrary format.
+	 *
+	 * There is one exception:  uCode sets bit 15 when it originates
+	 * the response/notification, i.e. when the response/notification
+	 * is not a direct response to a command sent by the driver.  For
+	 * example, uCode issues REPLY_3945_RX when it sends a received frame
+	 * to the driver; it is not a direct response to any driver command.
 	 *
-	 *  0:7    index in fifo
-	 *  8:13   fifo selection
-	 * 14:14   bit indicating if this packet references the 'extra'
-	 *         storage at the end of the memory queue
-	 * 15:15   (Rx indication)
+	 * The Linux driver uses the following format:
 	 *
+	 *  0:7    index/position within Tx queue
+	 *  8:13   Tx queue selection
+	 * 14:14   driver sets this to indicate command is in the 'huge'
+	 *         storage at the end of the command buffers, i.e. scan cmd
+	 * 15:15   uCode sets this in uCode-originated response/notification
 	 */
 	__le16 sequence;
 
-	/* command data follows immediately */
+	/* command or response/notification data follows immediately */
 	u8 data[0];
 } __attribute__ ((packed));
 
@@ -176,15 +193,22 @@ struct iwl3945_cmd_header {
 #define INITIALIZE_SUBTYPE    (9)
 
 /*
- * REPLY_ALIVE = 0x1 (response only, not a command)
+ * ("Initialize") REPLY_ALIVE = 0x1 (response only, not a command)
+ *
+ * uCode issues this "initialize alive" notification once the initialization
+ * uCode image has completed its work, and is ready to load the runtime image.
+ * This is the *first* "alive" notification that the driver will receive after
+ * rebooting uCode; the "initialize" alive is indicated by subtype field == 9.
+ *
+ * See comments documenting "BSM" (bootstrap state machine).
  */
-struct iwl3945_alive_resp {
+struct iwl3945_init_alive_resp {
 	u8 ucode_minor;
 	u8 ucode_major;
 	__le16 reserved1;
 	u8 sw_rev[8];
 	u8 ver_type;
-	u8 ver_subtype;
+	u8 ver_subtype;			/* "9" for initialize alive */
 	__le16 reserved2;
 	__le32 log_event_table_ptr;
 	__le32 error_event_table_ptr;
@@ -192,16 +216,39 @@ struct iwl3945_alive_resp {
 	__le32 is_valid;
 } __attribute__ ((packed));
 
-struct iwl3945_init_alive_resp {
+
+/**
+ * REPLY_ALIVE = 0x1 (response only, not a command)
+ *
+ * uCode issues this "alive" notification once the runtime image is ready
+ * to receive commands from the driver.  This is the *second* "alive"
+ * notification that the driver will receive after rebooting uCode;
+ * this "alive" is indicated by subtype field != 9.
+ *
+ * See comments documenting "BSM" (bootstrap state machine).
+ *
+ * This response includes two pointers to structures within the device's
+ * data SRAM (access via HBUS_TARG_MEM_* regs) that are useful for debugging:
+ *
+ * 1)  log_event_table_ptr indicates base of the event log.  This traces
+ *     a 256-entry history of uCode execution within a circular buffer.
+ *
+ * 2)  error_event_table_ptr indicates base of the error log.  This contains
+ *     information about any uCode error that occurs.
+ *
+ * The Linux driver can print both logs to the system log when a uCode error
+ * occurs.
+ */
+struct iwl3945_alive_resp {
 	u8 ucode_minor;
 	u8 ucode_major;
 	__le16 reserved1;
 	u8 sw_rev[8];
 	u8 ver_type;
-	u8 ver_subtype;
+	u8 ver_subtype;			/* not "9" for runtime alive */
 	__le16 reserved2;
-	__le32 log_event_table_ptr;
-	__le32 error_event_table_ptr;
+	__le32 log_event_table_ptr;	/* SRAM address for event log */
+	__le32 error_event_table_ptr;	/* SRAM address for error log */
 	__le32 timestamp;
 	__le32 is_valid;
 } __attribute__ ((packed));
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-commands.h b/drivers/net/wireless/iwlwifi/iwl-4965-commands.h
index 9910939..bde3aa0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-commands.h
@@ -120,7 +120,7 @@ enum {
 	REPLY_TX_PWR_TABLE_CMD = 0x97,
 	MEASURE_ABORT_NOTIFICATION = 0x99,	/* not used */
 
-	/* BT config command */
+	/* Bluetooth device coexistance config command */
 	REPLY_BT_CONFIG = 0x9b,
 
 	/* 4965 Statistics */
@@ -151,25 +151,42 @@ enum {
  *
  *****************************************************************************/
 
+/* iwl4965_cmd_header flags value */
 #define IWL_CMD_FAILED_MSK 0x40
 
+/**
+ * struct iwl4965_cmd_header
+ *
+ * This header format appears in the beginning of each command sent from the
+ * driver, and each response/notification received from uCode.
+ */
 struct iwl4965_cmd_header {
-	u8 cmd;
-	u8 flags;
-	/* We have 15 LSB to use as we please (MSB indicates
-	 * a frame Rx'd from the HW).  We encode the following
-	 * information into the sequence field:
+	u8 cmd;		/* Command ID:  REPLY_RXON, etc. */
+	u8 flags;	/* IWL_CMD_* */
+	/*
+	 * The driver sets up the sequence number to values of its chosing.
+	 * uCode does not use this value, but passes it back to the driver
+	 * when sending the response to each driver-originated command, so
+	 * the driver can match the response to the command.  Since the values
+	 * don't get used by uCode, the driver may set up an arbitrary format.
 	 *
-	 *  0:7    index in fifo
-	 *  8:13   fifo selection
-	 * 14:14   bit indicating if this packet references the 'extra'
-	 *         storage at the end of the memory queue
-	 * 15:15   (Rx indication)
+	 * There is one exception:  uCode sets bit 15 when it originates
+	 * the response/notification, i.e. when the response/notification
+	 * is not a direct response to a command sent by the driver.  For
+	 * example, uCode issues REPLY_3945_RX when it sends a received frame
+	 * to the driver; it is not a direct response to any driver command.
 	 *
+	 * The Linux driver uses the following format:
+	 *
+	 *  0:7    index/position within Tx queue
+	 *  8:13   Tx queue selection
+	 * 14:14   driver sets this to indicate command is in the 'huge'
+	 *         storage at the end of the command buffers, i.e. scan cmd
+	 * 15:15   uCode sets this in uCode-originated response/notification
 	 */
 	__le16 sequence;
 
-	/* command data follows immediately */
+	/* command or response/notification data follows immediately */
 	u8 data[0];
 } __attribute__ ((packed));
 
@@ -218,28 +235,28 @@ struct iwl4965_cmd_header {
 #define RATE_MCS_HT_DUP_POS 5
 #define RATE_MCS_HT_DUP_MSK 0x20
 
-/* (1) HT format, (0) legacy format in bits 7:0 */
+/* Bit 8: (1) HT format, (0) legacy format in bits 7:0 */
 #define RATE_MCS_FLAGS_POS 8
 #define RATE_MCS_HT_POS 8
 #define RATE_MCS_HT_MSK 0x100
 
-/* (1) CCK, (0) OFDM.  HT (bit 8) must be "0" for this bit to be valid */
+/* Bit 9: (1) CCK, (0) OFDM.  HT (bit 8) must be "0" for this bit to be valid */
 #define RATE_MCS_CCK_POS 9
 #define RATE_MCS_CCK_MSK 0x200
 
-/* (1) Use Green Field preamble */
+/* Bit 10: (1) Use Green Field preamble */
 #define RATE_MCS_GF_POS 10
 #define RATE_MCS_GF_MSK 0x400
 
-/* (1) Use 40Mhz FAT channel width, (0) use 20 MHz legacy channel width */
+/* Bit 11: (1) Use 40Mhz FAT chnl width, (0) use 20 MHz legacy chnl width */
 #define RATE_MCS_FAT_POS 11
 #define RATE_MCS_FAT_MSK 0x800
 
-/* (1) Duplicate data on both 20MHz channels.  FAT (bit 11) must be set. */
+/* Bit 12: (1) Duplicate data on both 20MHz chnls.  FAT (bit 11) must be set. */
 #define RATE_MCS_DUP_POS 12
 #define RATE_MCS_DUP_MSK 0x1000
 
-/* (1) Short guard interval (0.4 usec), (0) normal GI (0.8 usec) */
+/* Bit 13: (1) Short guard interval (0.4 usec), (0) normal GI (0.8 usec) */
 #define RATE_MCS_SGI_POS 13
 #define RATE_MCS_SGI_MSK 0x2000
 
@@ -266,45 +283,120 @@ struct iwl4965_cmd_header {
 #define INITIALIZE_SUBTYPE    (9)
 
 /*
- * REPLY_ALIVE = 0x1 (response only, not a command)
+ * ("Initialize") REPLY_ALIVE = 0x1 (response only, not a command)
+ *
+ * uCode issues this "initialize alive" notification once the initialization
+ * uCode image has completed its work, and is ready to load the runtime image.
+ * This is the *first* "alive" notification that the driver will receive after
+ * rebooting uCode; the "initialize" alive is indicated by subtype field == 9.
+ *
+ * See comments documenting "BSM" (bootstrap state machine).
+ *
+ * For 4965, this notification contains important calibration data for
+ * calculating txpower settings:
+ *
+ * 1)  Power supply voltage indication.  The voltage sensor outputs higher
+ *     values for lower voltage, and vice versa.
+ *
+ * 2)  Temperature measurement parameters, for each of two channel widths
+ *     (20 MHz and 40 MHz) supported by the radios.  Temperature sensing
+ *     is done via one of the receiver chains, and channel width influences
+ *     the results.
+ *
+ * 3)  Tx gain compensation to balance 4965's 2 Tx chains for MIMO operation,
+ *     for each of 5 frequency ranges.
  */
-struct iwl4965_alive_resp {
+struct iwl4965_init_alive_resp {
 	u8 ucode_minor;
 	u8 ucode_major;
 	__le16 reserved1;
 	u8 sw_rev[8];
 	u8 ver_type;
-	u8 ver_subtype;
+	u8 ver_subtype;		/* "9" for initialize alive */
 	__le16 reserved2;
 	__le32 log_event_table_ptr;
 	__le32 error_event_table_ptr;
 	__le32 timestamp;
 	__le32 is_valid;
+
+	/* calibration values from "initialize" uCode */
+	__le32 voltage;		/* signed, higher value is lower voltage */
+	__le32 therm_r1[2];	/* signed, 1st for normal, 2nd for FAT channel*/
+	__le32 therm_r2[2];	/* signed */
+	__le32 therm_r3[2];	/* signed */
+	__le32 therm_r4[2];	/* signed */
+	__le32 tx_atten[5][2];	/* signed MIMO gain comp, 5 freq groups,
+				 * 2 Tx chains */
 } __attribute__ ((packed));
 
-struct iwl4965_init_alive_resp {
+
+/**
+ * REPLY_ALIVE = 0x1 (response only, not a command)
+ *
+ * uCode issues this "alive" notification once the runtime image is ready
+ * to receive commands from the driver.  This is the *second* "alive"
+ * notification that the driver will receive after rebooting uCode;
+ * this "alive" is indicated by subtype field != 9.
+ *
+ * See comments documenting "BSM" (bootstrap state machine).
+ *
+ * This response includes two pointers to structures within the device's
+ * data SRAM (access via HBUS_TARG_MEM_* regs) that are useful for debugging:
+ *
+ * 1)  log_event_table_ptr indicates base of the event log.  This traces
+ *     a 256-entry history of uCode execution within a circular buffer.
+ *     Its header format is:
+ *
+ *	__le32 log_size;     log capacity (in number of entries)
+ *	__le32 type;         (1) timestamp with each entry, (0) no timestamp
+ *	__le32 wraps;        # times uCode has wrapped to top of circular buffer
+ *      __le32 write_index;  next circular buffer entry that uCode would fill
+ *
+ *     The header is followed by the circular buffer of log entries.  Entries
+ *     with timestamps have the following format:
+ *
+ *	__le32 event_id;     range 0 - 1500
+ *	__le32 timestamp;    low 32 bits of TSF (of network, if associated)
+ *	__le32 data;         event_id-specific data value
+ *
+ *     Entries without timestamps contain only event_id and data.
+ *
+ * 2)  error_event_table_ptr indicates base of the error log.  This contains
+ *     information about any uCode error that occurs.  For 4965, the format
+ *     of the error log is:
+ *
+ *	__le32 valid;        (nonzero) valid, (0) log is empty
+ *	__le32 error_id;     type of error
+ *	__le32 pc;           program counter
+ *	__le32 blink1;       branch link
+ *	__le32 blink2;       branch link
+ *	__le32 ilink1;       interrupt link
+ *	__le32 ilink2;       interrupt link
+ *	__le32 data1;        error-specific data
+ *	__le32 data2;        error-specific data
+ *	__le32 line;         source code line of error

+ *	__le32 bcon_time;    beacon timer
+ *	__le32 tsf_low;      network timestamp function timer
+ *	__le32 tsf_hi;       network timestamp function timer
+ *
+ * The Linux driver can print both logs to the system log when a uCode error
+ * occurs.
+ */
+struct iwl4965_alive_resp {
 	u8 ucode_minor;
 	u8 ucode_major;
 	__le16 reserved1;
 	u8 sw_rev[8];
 	u8 ver_type;
-	u8 ver_subtype;
+	u8 ver_subtype;			/* not "9" for runtime alive */
 	__le16 reserved2;
-	__le32 log_event_table_ptr;
-	__le32 error_event_table_ptr;
+	__le32 log_event_table_ptr;	/* SRAM address for event log */
+	__le32 error_event_table_ptr;	/* SRAM address for error log */
 	__le32 timestamp;
 	__le32 is_valid;
-
-	/* calibration values from "initialize" uCode */
-	__le32 voltage;		/* signed */
-	__le32 therm_r1[2];	/* signed 1st for normal, 2nd for FAT channel */
-	__le32 therm_r2[2];	/* signed */
-	__le32 therm_r3[2];	/* signed */
-	__le32 therm_r4[2];	/* signed */
-	__le32 tx_atten[5][2];	/* signed MIMO gain comp, 5 freq groups,
-				 * 2 Tx chains */
 } __attribute__ ((packed));
 
+
 union tsf {
 	u8 byte[8];
 	__le16 word[4];
-- 
1.5.2.2
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
