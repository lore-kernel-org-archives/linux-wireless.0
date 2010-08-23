Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:27344 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753874Ab0HWOx1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Aug 2010 10:53:27 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 02/26] iwlwifi: comments cleanup
Date: Mon, 23 Aug 2010 07:56:53 -0700
Message-Id: <1282575437-23270-3-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1282575437-23270-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1282575437-23270-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

No code or function changes, just some cleanup work for
out-of-date comments

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-commands.h |   62 ++++++++++++++------------
 1 files changed, 33 insertions(+), 29 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 4083e44..e2f3616 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -62,7 +62,7 @@
  *****************************************************************************/
 /*
  * Please use this file (iwl-commands.h) only for uCode API definitions.
- * Please use iwl-4965-hw.h for hardware-related definitions.
+ * Please use iwl-xxxx-hw.h for hardware-related definitions.
  * Please use iwl-dev.h for driver implementation definitions.
  */
 
@@ -1056,7 +1056,8 @@ struct sta_id_modify {
  *
  * The device contains an internal table of per-station information,
  * with info on security keys, aggregation parameters, and Tx rates for
- * initial Tx attempt and any retries (4965 uses REPLY_TX_LINK_QUALITY_CMD,
+ * initial Tx attempt and any retries (agn devices uses
+ * REPLY_TX_LINK_QUALITY_CMD,
  * 3945 uses REPLY_RATE_SCALE to set up rate tables).
  *
  * REPLY_ADD_STA sets up the table entry for one station, either creating
@@ -1427,12 +1428,12 @@ struct iwl_rx_mpdu_res_start {
  * uCode handles all timing and protocol related to control frames
  * (RTS/CTS/ACK), based on flags in the Tx command.  uCode and Tx scheduler
  * handle reception of block-acks; uCode updates the host driver via
- * REPLY_COMPRESSED_BA (4965).
+ * REPLY_COMPRESSED_BA.
  *
  * uCode handles retrying Tx when an ACK is expected but not received.
  * This includes trying lower data rates than the one requested in the Tx
  * command, as set up by the REPLY_RATE_SCALE (for 3945) or
- * REPLY_TX_LINK_QUALITY_CMD (4965).
+ * REPLY_TX_LINK_QUALITY_CMD (agn).
  *
  * Driver sets up transmit power for various rates via REPLY_TX_PWR_TABLE_CMD.
  * This command must be executed after every RXON command, before Tx can occur.
@@ -1468,7 +1469,7 @@ struct iwl_rx_mpdu_res_start {
  * Set this for unicast frames, but not broadcast/multicast. */
 #define TX_CMD_FLG_ACK_MSK cpu_to_le32(1 << 3)
 
-/* For 4965:
+/* For agn devices:
  * 1: Use rate scale table (see REPLY_TX_LINK_QUALITY_CMD).
  *    Tx command's initial_rate_index indicates first rate to try;
  *    uCode walks through table for additional Tx attempts.
@@ -1487,7 +1488,7 @@ struct iwl_rx_mpdu_res_start {
  */
 #define TX_CMD_FLG_FULL_TXOP_PROT_MSK cpu_to_le32(1 << 7)
 
-/* Tx antenna selection field; used only for 3945, reserved (0) for 4965.
+/* Tx antenna selection field; used only for 3945, reserved (0) for agn devices.
  * Set field to "0" to allow 3945 uCode to select antenna (normal usage). */
 #define TX_CMD_FLG_ANT_SEL_MSK cpu_to_le32(0xf00)
 #define TX_CMD_FLG_ANT_A_MSK cpu_to_le32(1 << 8)
@@ -1870,9 +1871,10 @@ enum {
  *     frame in this new agg block failed in previous agg block(s).
  *
  *     Note that, for aggregation, ACK (block-ack) status is not delivered here;
- *     block-ack has not been received by the time the 4965 records this status.
+ *     block-ack has not been received by the time the agn device records
+ *     this status.
  *     This status relates to reasons the tx might have been blocked or aborted
- *     within the sending station (this 4965), rather than whether it was
+ *     within the sending station (this agn device), rather than whether it was
  *     received successfully by the destination station.
  */
 struct agg_tx_status {
@@ -2140,14 +2142,16 @@ struct iwl_link_qual_agg_params {
 /*
  * REPLY_TX_LINK_QUALITY_CMD = 0x4e (command, has simple generic response)
  *
- * For 4965 only; 3945 uses REPLY_RATE_SCALE.
+ * For agn devices only; 3945 uses REPLY_RATE_SCALE.
  *
- * Each station in the 4965's internal station table has its own table of 16
+ * Each station in the agn device's internal station table has its own table
+ * of 16
  * Tx rates and modulation modes (e.g. legacy/SISO/MIMO) for retrying Tx when
  * an ACK is not received.  This command replaces the entire table for
  * one station.
  *
- * NOTE:  Station must already be in 4965's station table.  Use REPLY_ADD_STA.
+ * NOTE:  Station must already be in agn device's station table.
+ *	  Use REPLY_ADD_STA.
  *
  * The rate scaling procedures described below work well.  Of course, other
  * procedures are possible, and may work better for particular environments.
@@ -2184,12 +2188,12 @@ struct iwl_link_qual_agg_params {
  *
  * ACCUMULATING HISTORY
  *
- * The rate scaling algorithm for 4965, as implemented in Linux driver, uses
- * two sets of frame Tx success history:  One for the current/active modulation
- * mode, and one for a speculative/search mode that is being attempted.  If the
- * speculative mode turns out to be more effective (i.e. actual transfer
- * rate is better), then the driver continues to use the speculative mode
- * as the new current active mode.
+ * The rate scaling algorithm for agn devices, as implemented in Linux driver,
+ * uses two sets of frame Tx success history:  One for the current/active
+ * modulation mode, and one for a speculative/search mode that is being
+ * attempted. If the speculative mode turns out to be more effective (i.e.
+ * actual transfer rate is better), then the driver continues to use the
+ * speculative mode as the new current active mode.
  *
  * Each history set contains, separately for each possible rate, data for a
  * sliding window of the 62 most recent tx attempts at that rate.  The data
@@ -2200,12 +2204,12 @@ struct iwl_link_qual_agg_params {
  * The driver uses the bit map to remove successes from the success sum, as
  * the oldest tx attempts fall out of the window.
  *
- * When the 4965 makes multiple tx attempts for a given frame, each attempt
- * might be at a different rate, and have different modulation characteristics
- * (e.g. antenna, fat channel, short guard interval), as set up in the rate
- * scaling table in the Link Quality command.  The driver must determine
- * which rate table entry was used for each tx attempt, to determine which
- * rate-specific history to update, and record only those attempts that
+ * When the agn device makes multiple tx attempts for a given frame, each
+ * attempt might be at a different rate, and have different modulation
+ * characteristics (e.g. antenna, fat channel, short guard interval), as set
+ * up in the rate scaling table in the Link Quality command.  The driver must
+ * determine which rate table entry was used for each tx attempt, to determine
+ * which rate-specific history to update, and record only those attempts that
  * match the modulation characteristics of the history set.
  *
  * When using block-ack (aggregation), all frames are transmitted at the same
@@ -2335,7 +2339,7 @@ struct iwl_link_quality_cmd {
 	/*
 	 * Rate info; when using rate-scaling, Tx command's initial_rate_index
 	 * specifies 1st Tx rate attempted, via index into this table.
-	 * 4965 works its way through table when retrying Tx.
+	 * agn devices works its way through table when retrying Tx.
 	 */
 	struct {
 		__le32 rate_n_flags;	/* RATE_MCS_*, IWL_RATE_* */
@@ -2371,7 +2375,7 @@ struct iwl_link_quality_cmd {
 /*
  * REPLY_BT_CONFIG = 0x9b (command, has simple generic response)
  *
- * 3945 and 4965 support hardware handshake with Bluetooth device on
+ * 3945 and agn devices support hardware handshake with Bluetooth device on
  * same platform.  Bluetooth device alerts wireless device when it will Tx;
  * wireless device can delay or kill its own Tx to accommodate.
  */
@@ -2572,7 +2576,7 @@ struct iwl_powertable_cmd {
 
 /*
  * PM_SLEEP_NOTIFICATION = 0x7A (notification only, not a command)
- * 3945 and 4965 identical.
+ * all devices identical.
  */
 struct iwl_sleep_notification {
 	u8 pm_sleep_mode;
@@ -2583,7 +2587,7 @@ struct iwl_sleep_notification {
 	__le32 bcon_timer;
 } __packed;
 
-/* Sleep states.  3945 and 4965 identical. */
+/* Sleep states.  all devices identical. */
 enum {
 	IWL_PM_NO_SLEEP = 0,
 	IWL_PM_SLP_MAC = 1,
@@ -3270,7 +3274,7 @@ struct statistics_general_bt {
 
 /*
  * REPLY_STATISTICS_CMD = 0x9c,
- * 3945 and 4965 identical.
+ * all devices identical.
  *
  * This command triggers an immediate response containing uCode statistics.
  * The response is in the same format as STATISTICS_NOTIFICATION 0x9d, below.
@@ -3608,7 +3612,7 @@ struct iwl_enhance_sensitivity_cmd {
 /**
  * REPLY_PHY_CALIBRATION_CMD = 0xb0 (command, has simple generic response)
  *
- * This command sets the relative gains of 4965's 3 radio receiver chains.
+ * This command sets the relative gains of agn device's 3 radio receiver chains.
  *
  * After the first association, driver should accumulate signal and noise
  * statistics from the STATISTICS_NOTIFICATIONs that follow the first 20
-- 
1.7.0.4

