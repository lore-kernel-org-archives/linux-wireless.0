Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:37368 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932173AbbHDU7R (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Aug 2015 16:59:17 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: David Spinadel <david.spinadel@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 37/37] iwlwifi: mvm: clean up fw-api-scan.h
Date: Tue,  4 Aug 2015 23:43:27 +0300
Message-Id: <1438721007-23283-37-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150804_225927_154374_EDA073EC)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E7E11FA@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E7E11FA@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Spinadel <david.spinadel@intel.com>

Remove outdated and unused definitions

Signed-off-by: David Spinadel <david.spinadel@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h | 129 -------------------------
 1 file changed, 129 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h b/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h
index 4787c32..be9b665 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h
@@ -87,41 +87,6 @@ struct iwl_ssid_ie {
 	u8 ssid[IEEE80211_MAX_SSID_LEN];
 } __packed; /* SCAN_DIRECT_SSID_IE_API_S_VER_1 */
 
-/* How many statistics are gathered for each channel */
-#define SCAN_RESULTS_STATISTICS 1
-
-/**
- * enum iwl_scan_complete_status - status codes for scan complete notifications
- * @SCAN_COMP_STATUS_OK:  scan completed successfully
- * @SCAN_COMP_STATUS_ABORT: scan was aborted by user
- * @SCAN_COMP_STATUS_ERR_SLEEP: sending null sleep packet failed
- * @SCAN_COMP_STATUS_ERR_CHAN_TIMEOUT: timeout before channel is ready
- * @SCAN_COMP_STATUS_ERR_PROBE: sending probe request failed
- * @SCAN_COMP_STATUS_ERR_WAKEUP: sending null wakeup packet failed
- * @SCAN_COMP_STATUS_ERR_ANTENNAS: invalid antennas chosen at scan command
- * @SCAN_COMP_STATUS_ERR_INTERNAL: internal error caused scan abort
- * @SCAN_COMP_STATUS_ERR_COEX: medium was lost ot WiMax
- * @SCAN_COMP_STATUS_P2P_ACTION_OK: P2P public action frame TX was successful
- *	(not an error!)
- * @SCAN_COMP_STATUS_ITERATION_END: indicates end of one repetition the driver
- *	asked for
- * @SCAN_COMP_STATUS_ERR_ALLOC_TE: scan could not allocate time events
-*/
-enum iwl_scan_complete_status {
-	SCAN_COMP_STATUS_OK = 0x1,
-	SCAN_COMP_STATUS_ABORT = 0x2,
-	SCAN_COMP_STATUS_ERR_SLEEP = 0x3,
-	SCAN_COMP_STATUS_ERR_CHAN_TIMEOUT = 0x4,
-	SCAN_COMP_STATUS_ERR_PROBE = 0x5,
-	SCAN_COMP_STATUS_ERR_WAKEUP = 0x6,
-	SCAN_COMP_STATUS_ERR_ANTENNAS = 0x7,
-	SCAN_COMP_STATUS_ERR_INTERNAL = 0x8,
-	SCAN_COMP_STATUS_ERR_COEX = 0x9,
-	SCAN_COMP_STATUS_P2P_ACTION_OK = 0xA,
-	SCAN_COMP_STATUS_ITERATION_END = 0x0B,
-	SCAN_COMP_STATUS_ERR_ALLOC_TE = 0x0C,
-};
-
 /* scan offload */
 #define IWL_SCAN_MAX_BLACKLIST_LEN	64
 #define IWL_SCAN_SHORT_BLACKLIST_LEN	16
@@ -144,71 +109,6 @@ enum scan_framework_client {
 };
 
 /**
- * struct iwl_scan_offload_cmd - SCAN_REQUEST_FIXED_PART_API_S_VER_6
- * @scan_flags:		see enum iwl_scan_flags
- * @channel_count:	channels in channel list
- * @quiet_time:		dwell time, in milliseconds, on quiet channel
- * @quiet_plcp_th:	quiet channel num of packets threshold
- * @good_CRC_th:	passive to active promotion threshold
- * @rx_chain:		RXON rx chain.
- * @max_out_time:	max TUs to be out of associated channel
- * @suspend_time:	pause scan this TUs when returning to service channel
- * @flags:		RXON flags
- * @filter_flags:	RXONfilter
- * @tx_cmd:		tx command for active scan; for 2GHz and for 5GHz.
- * @direct_scan:	list of SSIDs for directed active scan
- * @scan_type:		see enum iwl_scan_type.
- * @rep_count:		repetition count for each scheduled scan iteration.
- */
-struct iwl_scan_offload_cmd {
-	__le16 len;
-	u8 scan_flags;
-	u8 channel_count;
-	__le16 quiet_time;
-	__le16 quiet_plcp_th;
-	__le16 good_CRC_th;
-	__le16 rx_chain;
-	__le32 max_out_time;
-	__le32 suspend_time;
-	/* RX_ON_FLAGS_API_S_VER_1 */
-	__le32 flags;
-	__le32 filter_flags;
-	struct iwl_tx_cmd tx_cmd[2];
-	/* SCAN_DIRECT_SSID_IE_API_S_VER_1 */
-	struct iwl_ssid_ie direct_scan[PROBE_OPTION_MAX];
-	__le32 scan_type;
-	__le32 rep_count;
-} __packed;
-
-enum iwl_scan_offload_channel_flags {
-	IWL_SCAN_OFFLOAD_CHANNEL_ACTIVE		= BIT(0),
-	IWL_SCAN_OFFLOAD_CHANNEL_NARROW		= BIT(22),
-	IWL_SCAN_OFFLOAD_CHANNEL_FULL		= BIT(24),
-	IWL_SCAN_OFFLOAD_CHANNEL_PARTIAL	= BIT(25),
-};
-
-/* channel configuration for struct iwl_scan_offload_cfg. Each channels needs:
- * __le32 type:	bitmap; bits 1-20 are for directed scan to i'th ssid and
- *	see enum iwl_scan_offload_channel_flags.
- * __le16 channel_number: channel number 1-13 etc.
- * __le16 iter_count: repetition count for the channel.
- * __le32 iter_interval: interval between two iterations on one channel.
- * u8 active_dwell.
- * u8 passive_dwell.
- */
-#define IWL_SCAN_CHAN_SIZE 14
-
-/**
- * iwl_scan_offload_cfg - SCAN_OFFLOAD_CONFIG_API_S
- * @scan_cmd:		scan command fixed part
- * @data:		scan channel configuration and probe request frames
- */
-struct iwl_scan_offload_cfg {
-	struct iwl_scan_offload_cmd scan_cmd;
-	u8 data[0];
-} __packed;
-
-/**
  * iwl_scan_offload_blacklist - SCAN_OFFLOAD_BLACKLIST_S
  * @ssid:		MAC address to filter out
  * @reported_rssi:	AP rssi reported to the host
@@ -298,35 +198,6 @@ enum iwl_scan_ebs_status {
 };
 
 /**
- * iwl_scan_offload_complete - SCAN_OFFLOAD_COMPLETE_NTF_API_S_VER_1
- * @last_schedule_line:		last schedule line executed (fast or regular)
- * @last_schedule_iteration:	last scan iteration executed before scan abort
- * @status:			enum iwl_scan_offload_compleate_status
- * @ebs_status: last EBS status, see IWL_SCAN_EBS_*
- */
-struct iwl_scan_offload_complete {
-	u8 last_schedule_line;
-	u8 last_schedule_iteration;
-	u8 status;
-	u8 ebs_status;
-} __packed;
-
-/**
- * iwl_sched_scan_results - SCAN_OFFLOAD_MATCH_FOUND_NTF_API_S_VER_1
- * @ssid_bitmap:	SSIDs indexes found in this iteration
- * @client_bitmap:	clients that are active and wait for this notification
- */
-struct iwl_sched_scan_results {
-	__le16 ssid_bitmap;
-	u8 client_bitmap;
-	u8 reserved;
-};
-
-/* Unified LMAC scan API */
-
-#define IWL_MVM_BASIC_PASSIVE_DWELL 110
-
-/**
  * iwl_scan_req_tx_cmd - SCAN_REQ_TX_CMD_API_S
  * @tx_flags: combination of TX_CMD_FLG_*
  * @rate_n_flags: rate for *all* Tx attempts, if TX_CMD_FLG_STA_RATE_MSK is
-- 
2.1.4

