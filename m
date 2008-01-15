Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:60992 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751024AbYAOC04 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jan 2008 21:26:56 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Ben Cahill <ben.m.cahill@intel.com>, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 04/12] iwlwifi: document scan command
Date: Mon, 14 Jan 2008 17:46:17 -0800
Message-Id: <1200361585-31801-5-git-send-email-reinette.chatre@intel.com> (sfid-20080115_022705_457944_D9860755)
In-Reply-To: <1200361585-31801-4-git-send-email-reinette.chatre@intel.com>
References: <1200361585-31801-1-git-send-email-reinette.chatre@intel.com>
 <1200361585-31801-2-git-send-email-reinette.chatre@intel.com>
 <1200361585-31801-3-git-send-email-reinette.chatre@intel.com>
 <1200361585-31801-4-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Cahill <ben.m.cahill@intel.com>

Document scan command.

Signed-off-by: Ben Cahill <ben.m.cahill@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945-commands.h |  143 +++++++++++++++++----
 drivers/net/wireless/iwlwifi/iwl-4965-commands.h |  147 +++++++++++++++++-----
 2 files changed, 234 insertions(+), 56 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-commands.h b/drivers/net/wireless/iwlwifi/iwl-3945-commands.h
index 3cac2c8..0c80ed5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-commands.h
@@ -1020,6 +1020,10 @@ struct iwl3945_rate_scaling_cmd {
 
 /*
  * REPLY_BT_CONFIG = 0x9b (command, has simple generic response)
+ *
+ * 3945 and 4965 support hardware handshake with Bluetooth device on
+ * same platform.  Bluetooth device alerts wireless device when it will Tx;
+ * wireless device can delay or kill its own Tx to accomodate.
  */
 struct iwl3945_bt_cmd {
 	u8 flags;
@@ -1258,20 +1262,47 @@ struct iwl3945_ct_kill_config {
  *
  *****************************************************************************/
 
+/**
+ * struct iwl3945_scan_channel - entry in REPLY_SCAN_CMD channel table
+ *
+ * One for each channel in the scan list.
+ * Each channel can independently select:
+ * 1)  SSID for directed active scans
+ * 2)  Txpower setting (for rate specified within Tx command)
+ * 3)  How long to stay on-channel (behavior may be modified by quiet_time,
+ *     quiet_plcp_th, good_CRC_th)
+ *
+ * To avoid uCode errors, make sure the following are true (see comments
+ * under struct iwl3945_scan_cmd about max_out_time and quiet_time):
+ * 1)  If using passive_dwell (i.e. passive_dwell != 0):
+ *     active_dwell <= passive_dwell (< max_out_time if max_out_time != 0)
+ * 2)  quiet_time <= active_dwell
+ * 3)  If restricting off-channel time (i.e. max_out_time !=0):
+ *     passive_dwell < max_out_time
+ *     active_dwell < max_out_time
+ */
 struct iwl3945_scan_channel {
-	/* type is defined as:
-	 * 0:0 active (0 - passive)
-	 * 1:4 SSID direct
-	 *     If 1 is set then corresponding SSID IE is transmitted in probe
+	/*
+	 * type is defined as:
+	 * 0:0 1 = active, 0 = passive
+	 * 1:4 SSID direct bit map; if a bit is set, then corresponding
+	 *     SSID IE is transmitted in probe request.
 	 * 5:7 reserved
 	 */
 	u8 type;
-	u8 channel;
+	u8 channel;	/* band is selected by iwl3945_scan_cmd "flags" field */
 	struct iwl3945_tx_power tpc;
-	__le16 active_dwell;
-	__le16 passive_dwell;
+	__le16 active_dwell;	/* in 1024-uSec TU (time units), typ 5-50 */
+	__le16 passive_dwell;	/* in 1024-uSec TU (time units), typ 20-500 */
 } __attribute__ ((packed));
 
+/**
+ * struct iwl3945_ssid_ie - directed scan network information element
+ *
+ * Up to 4 of these may appear in REPLY_SCAN_CMD, selected by "type" field
+ * in struct iwl3945_scan_channel; each channel may select different ssids from
+ * among the 4 entries.  SSID IEs get transmitted in reverse order of entry.
+ */
 struct iwl3945_ssid_ie {
 	u8 id;
 	u8 len;
@@ -1285,40 +1316,98 @@ struct iwl3945_ssid_ie {
 
 /*
  * REPLY_SCAN_CMD = 0x80 (command)
+ *
+ * The hardware scan command is very powerful; the driver can set it up to
+ * maintain (relatively) normal network traffic while doing a scan in the
+ * background.  The max_out_time and suspend_time control the ratio of how
+ * long the device stays on an associated network channel ("service channel")
+ * vs. how long it's away from the service channel, tuned to other channels
+ * for scanning.
+ *
+ * max_out_time is the max time off-channel (in usec), and suspend_time
+ * is how long (in "extended beacon" format) that the scan is "suspended"
+ * after returning to the service channel.  That is, suspend_time is the
+ * time that we stay on the service channel, doing normal work, between
+ * scan segments.  The driver may set these parameters differently to support
+ * scanning when associated vs. not associated, and light vs. heavy traffic
+ * loads when associated.
+ *
+ * After receiving this command, the device's scan engine does the following;
+ *
+ * 1)  Sends SCAN_START notification to driver
+ * 2)  Checks to see if it has time to do scan for one channel
+ * 3)  Sends NULL packet, with power-save (PS) bit set to 1,
+ *     to tell AP that we're going off-channel
+ * 4)  Tunes to first channel in scan list, does active or passive scan
+ * 5)  Sends SCAN_RESULT notification to driver
+ * 6)  Checks to see if it has time to do scan on *next* channel in list
+ * 7)  Repeats 4-6 until it no longer has time to scan the next channel
+ *     before max_out_time expires
+ * 8)  Returns to service channel
+ * 9)  Sends NULL packet with PS=0 to tell AP that we're back
+ * 10) Stays on service channel until suspend_time expires
+ * 11) Repeats entire process 2-10 until list is complete
+ * 12) Sends SCAN_COMPLETE notification
+ *
+ * For fast, efficient scans, the scan command also has support for staying on
+ * a channel for just a short time, if doing active scanning and getting no
+ * responses to the transmitted probe request.  This time is controlled by
+ * quiet_time, and the number of received packets below which a channel is
+ * considered "quiet" is controlled by quiet_plcp_threshold.
+ *
+ * For active scanning on channels that have regulatory restrictions against
+ * blindly transmitting, the scan can listen before transmitting, to make sure
+ * that there is already legitimate activity on the channel.  If enough
+ * packets are cleanly received on the channel (controlled by good_CRC_th,
+ * typical value 1), the scan engine starts transmitting probe requests.
+ *
+ * Driver must use separate scan commands for 2.4 vs. 5 GHz bands.
+ *
+ * To avoid uCode errors, see timing restrictions described under
+ * struct iwl3945_scan_channel.
  */
 struct iwl3945_scan_cmd {
 	__le16 len;
 	u8 reserved0;
-	u8 channel_count;
-	__le16 quiet_time;     /* dwell only this long on quiet chnl
-				* (active scan) */
-	__le16 quiet_plcp_th;  /* quiet chnl is < this # pkts (typ. 1) */
-	__le16 good_CRC_th;    /* passive -> active promotion threshold */
+	u8 channel_count;	/* # channels in channel list */
+	__le16 quiet_time;	/* dwell only this # millisecs on quiet channel
+				 * (only for active scan) */
+	__le16 quiet_plcp_th;	/* quiet chnl is < this # pkts (typ. 1) */
+	__le16 good_CRC_th;	/* passive -> active promotion threshold */
 	__le16 reserved1;
-	__le32 max_out_time;   /* max usec to be out of associated (service)
-				* chnl */
-	__le32 suspend_time;   /* pause scan this long when returning to svc
-				* chnl.
-				* 3945 -- 31:24 # beacons, 19:0 additional usec,
-				* 4965 -- 31:22 # beacons, 21:0 additional usec.
-				*/
-	__le32 flags;
-	__le32 filter_flags;
-
+	__le32 max_out_time;	/* max usec to be away from associated (service)
+				 * channel */
+	__le32 suspend_time;	/* pause scan this long (in "extended beacon
+				 * format") when returning to service channel:
+				 * 3945; 31:24 # beacons, 19:0 additional usec,
+				 * 4965; 31:22 # beacons, 21:0 additional usec.
+				 */
+	__le32 flags;		/* RXON_FLG_* */
+	__le32 filter_flags;	/* RXON_FILTER_* */
+
+	/* For active scans (set to all-0s for passive scans).
+	 * Does not include payload.  Must specify Tx rate; no rate scaling. */
 	struct iwl3945_tx_cmd tx_cmd;
+
+	/* For directed active scans (set to all-0s otherwise) */
 	struct iwl3945_ssid_ie direct_scan[PROBE_OPTION_MAX];
 
-	u8 data[0];
 	/*
-	 * The channels start after the probe request payload and are of type:
+	 * Probe request frame, followed by channel list.
+	 *
+	 * Size of probe request frame is specified by byte count in tx_cmd.
+	 * Channel list follows immediately after probe request frame.
+	 * Number of channels in list is specified by channel_count.
+	 * Each channel in list is of type:
 	 *
 	 * struct iwl3945_scan_channel channels[0];
 	 *
 	 * NOTE:  Only one band of channels can be scanned per pass.  You
-	 * can not mix 2.4GHz channels and 5.2GHz channels and must
-	 * request a scan multiple times (not concurrently)
-	 *
+	 * must not mix 2.4GHz channels and 5.2GHz channels, and you must wait
+	 * for one scan to complete (i.e. receive SCAN_COMPLETE_NOTIFICATION)
+	 * before requesting another scan.
 	 */
+	u8 data[0];
 } __attribute__ ((packed));
 
 /* Can abort will notify by complete notification with abort status. */
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-commands.h b/drivers/net/wireless/iwlwifi/iwl-4965-commands.h
index 7988c75..9237f8b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-commands.h
@@ -1615,6 +1615,10 @@ struct iwl4965_link_quality_cmd {
 
 /*
  * REPLY_BT_CONFIG = 0x9b (command, has simple generic response)
+ *
+ * 3945 and 4965 support hardware handshake with Bluetooth device on
+ * same platform.  Bluetooth device alerts wireless device when it will Tx;
+ * wireless device can delay or kill its own Tx to accomodate.
  */
 struct iwl4965_bt_cmd {
 	u8 flags;
@@ -1857,20 +1861,47 @@ struct iwl4965_ct_kill_config {
  *
  *****************************************************************************/
 
+/**
+ * struct iwl4965_scan_channel - entry in REPLY_SCAN_CMD channel table
+ *
+ * One for each channel in the scan list.
+ * Each channel can independently select:
+ * 1)  SSID for directed active scans
+ * 2)  Txpower setting (for rate specified within Tx command)
+ * 3)  How long to stay on-channel (behavior may be modified by quiet_time,
+ *     quiet_plcp_th, good_CRC_th)
+ *
+ * To avoid uCode errors, make sure the following are true (see comments
+ * under struct iwl4965_scan_cmd about max_out_time and quiet_time):
+ * 1)  If using passive_dwell (i.e. passive_dwell != 0):
+ *     active_dwell <= passive_dwell (< max_out_time if max_out_time != 0)
+ * 2)  quiet_time <= active_dwell
+ * 3)  If restricting off-channel time (i.e. max_out_time !=0):
+ *     passive_dwell < max_out_time
+ *     active_dwell < max_out_time
+ */
 struct iwl4965_scan_channel {
-	/* type is defined as:
-	 * 0:0 active (0 - passive)
-	 * 1:4 SSID direct
-	 *     If 1 is set then corresponding SSID IE is transmitted in probe
+	/*
+	 * type is defined as:
+	 * 0:0 1 = active, 0 = passive
+	 * 1:4 SSID direct bit map; if a bit is set, then corresponding
+	 *     SSID IE is transmitted in probe request.
 	 * 5:7 reserved
 	 */
 	u8 type;
-	u8 channel;
+	u8 channel;	/* band is selected by iwl4965_scan_cmd "flags" field */
 	struct iwl4965_tx_power tpc;
-	__le16 active_dwell;
-	__le16 passive_dwell;
+	__le16 active_dwell;	/* in 1024-uSec TU (time units), typ 5-50 */
+	__le16 passive_dwell;	/* in 1024-uSec TU (time units), typ 20-500 */
 } __attribute__ ((packed));
 
+/**
+ * struct iwl4965_ssid_ie - directed scan network information element
+ *
+ * Up to 4 of these may appear in REPLY_SCAN_CMD, selected by "type" field
+ * in struct iwl4965_scan_channel; each channel may select different ssids from
+ * among the 4 entries.  SSID IEs get transmitted in reverse order of entry.
+ */
 struct iwl4965_ssid_ie {
 	u8 id;
 	u8 len;
@@ -1884,40 +1915,98 @@ struct iwl4965_ssid_ie {
 
 /*
  * REPLY_SCAN_CMD = 0x80 (command)
+ *
+ * The hardware scan command is very powerful; the driver can set it up to
+ * maintain (relatively) normal network traffic while doing a scan in the
+ * background.  The max_out_time and suspend_time control the ratio of how
+ * long the device stays on an associated network channel ("service channel")
+ * vs. how long it's away from the service channel, i.e. tuned to other channels
+ * for scanning.
+ *
+ * max_out_time is the max time off-channel (in usec), and suspend_time
+ * is how long (in "extended beacon" format) that the scan is "suspended"
+ * after returning to the service channel.  That is, suspend_time is the
+ * time that we stay on the service channel, doing normal work, between
+ * scan segments.  The driver may set these parameters differently to support
+ * scanning when associated vs. not associated, and light vs. heavy traffic
+ * loads when associated.
+ *
+ * After receiving this command, the device's scan engine does the following;
+ *
+ * 1)  Sends SCAN_START notification to driver
+ * 2)  Checks to see if it has time to do scan for one channel
+ * 3)  Sends NULL packet, with power-save (PS) bit set to 1,
+ *     to tell AP that we're going off-channel
+ * 4)  Tunes to first channel in scan list, does active or passive scan
+ * 5)  Sends SCAN_RESULT notification to driver
+ * 6)  Checks to see if it has time to do scan on *next* channel in list
+ * 7)  Repeats 4-6 until it no longer has time to scan the next channel
+ *     before max_out_time expires
+ * 8)  Returns to service channel
+ * 9)  Sends NULL packet with PS=0 to tell AP that we're back
+ * 10) Stays on service channel until suspend_time expires
+ * 11) Repeats entire process 2-10 until list is complete
+ * 12) Sends SCAN_COMPLETE notification
+ *
+ * For fast, efficient scans, the scan command also has support for staying on
+ * a channel for just a short time, if doing active scanning and getting no
+ * responses to the transmitted probe request.  This time is controlled by
+ * quiet_time, and the number of received packets below which a channel is
+ * considered "quiet" is controlled by quiet_plcp_threshold.
+ *
+ * For active scanning on channels that have regulatory restrictions against
+ * blindly transmitting, the scan can listen before transmitting, to make sure
+ * that there is already legitimate activity on the channel.  If enough
+ * packets are cleanly received on the channel (controlled by good_CRC_th,
+ * typical value 1), the scan engine starts transmitting probe requests.
+ *
+ * Driver must use separate scan commands for 2.4 vs. 5 GHz bands.
+ *
+ * To avoid uCode errors, see timing restrictions described under
+ * struct iwl4965_scan_channel.
  */
 struct iwl4965_scan_cmd {
 	__le16 len;
 	u8 reserved0;
-	u8 channel_count;
-	__le16 quiet_time;     /* dwell only this long on quiet chnl
-				* (active scan) */
-	__le16 quiet_plcp_th;  /* quiet chnl is < this # pkts (typ. 1) */
-	__le16 good_CRC_th;    /* passive -> active promotion threshold */
-	__le16 rx_chain;
-	__le32 max_out_time;   /* max usec to be out of associated (service)
-				* chnl */
-	__le32 suspend_time;   /* pause scan this long when returning to svc
-				* chnl.
-				* 3945 -- 31:24 # beacons, 19:0 additional usec,
-				* 4965 -- 31:22 # beacons, 21:0 additional usec.
-				*/
-	__le32 flags;
-	__le32 filter_flags;
-
+	u8 channel_count;	/* # channels in channel list */
+	__le16 quiet_time;	/* dwell only this # millisecs on quiet channel
+				 * (only for active scan) */
+	__le16 quiet_plcp_th;	/* quiet chnl is < this # pkts (typ. 1) */
+	__le16 good_CRC_th;	/* passive -> active promotion threshold */
+	__le16 rx_chain;	/* RXON_RX_CHAIN_* */
+	__le32 max_out_time;	/* max usec to be away from associated (service)
+				 * channel */
+	__le32 suspend_time;	/* pause scan this long (in "extended beacon
+				 * format") when returning to service chnl:
+				 * 3945; 31:24 # beacons, 19:0 additional usec,
+				 * 4965; 31:22 # beacons, 21:0 additional usec.
+				 */
+	__le32 flags;		/* RXON_FLG_* */
+	__le32 filter_flags;	/* RXON_FILTER_* */
+
+	/* For active scans (set to all-0s for passive scans).
+	 * Does not include payload.  Must specify Tx rate; no rate scaling. */
 	struct iwl4965_tx_cmd tx_cmd;
+
+	/* For directed active scans (set to all-0s otherwise) */
 	struct iwl4965_ssid_ie direct_scan[PROBE_OPTION_MAX];
 
-	u8 data[0];
 	/*
-	 * The channels start after the probe request payload and are of type:
+	 * Probe request frame, followed by channel list.
+	 *
+	 * Size of probe request frame is specified by byte count in tx_cmd.
+	 * Channel list follows immediately after probe request frame.
+	 * Number of channels in list is specified by channel_count.
+	 * Each channel in list is of type:
 	 *
 	 * struct iwl4965_scan_channel channels[0];
 	 *
 	 * NOTE:  Only one band of channels can be scanned per pass.  You
-	 * can not mix 2.4GHz channels and 5.2GHz channels and must
-	 * request a scan multiple times (not concurrently)
-	 *
+	 * must not mix 2.4GHz channels and 5.2GHz channels, and you must wait
+	 * for one scan to complete (i.e. receive SCAN_COMPLETE_NOTIFICATION)
+	 * before requesting another scan.
 	 */
+	u8 data[0];
 } __attribute__ ((packed));
 
 /* Can abort will notify by complete notification with abort status. */
@@ -2087,7 +2176,7 @@ struct statistics_rx_non_phy {
 	__le32 interference_data_flag;	/* flag for interference data
 					 * availability. 1 when data is
 					 * available. */
-	__le32 channel_load;	/* counts RX Enable time */
+	__le32 channel_load;		/* counts RX Enable time in uSec */
 	__le32 dsp_false_alarms;	/* DSP false alarm (both OFDM
 					 * and CCK) counter */
 	__le32 beacon_rssi_a;
-- 
1.5.3.4

