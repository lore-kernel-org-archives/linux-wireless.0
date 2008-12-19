Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:55976 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752537AbYLSCpB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2008 21:45:01 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Tomas Winkler <tomas.winkler@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 04/43] iwlwifi: use iwl-commands.h also in 3945
Date: Fri, 19 Dec 2008 10:37:04 +0800
Message-Id: <1229654263-21454-5-git-send-email-yi.zhu@intel.com> (sfid-20081219_034510_743610_15880FB0)
In-Reply-To: <1229654263-21454-4-git-send-email-yi.zhu@intel.com>
References: <1229654263-21454-1-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-2-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-3-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-4-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch uses iwl-commands.h also for iwl3945
more clean ups are required but this get to stage where it
compiles cleanly.
Most massive changes are in spectrum and power managment.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Acked-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945-commands.h |  426 +---------------------
 drivers/net/wireless/iwlwifi/iwl-3945-led.c      |    1 +
 drivers/net/wireless/iwlwifi/iwl-3945-rs.c       |    1 +
 drivers/net/wireless/iwlwifi/iwl-3945.c          |    1 +
 drivers/net/wireless/iwlwifi/iwl-3945.h          |   12 +-
 drivers/net/wireless/iwlwifi/iwl-commands.h      |   31 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c      |   31 +-
 7 files changed, 61 insertions(+), 442 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-commands.h b/drivers/net/wireless/iwlwifi/iwl-3945-commands.h
index e9ccd07..acc584f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-commands.h
@@ -75,74 +75,6 @@
 #define IWL_UCODE_API(ver)	(((ver) & 0x0000FF00) >> 8)
 #define IWL_UCODE_SERIAL(ver)	((ver) & 0x000000FF)
 
-enum {
-	REPLY_ALIVE = 0x1,
-	REPLY_ERROR = 0x2,
-
-	/* RXON and QOS commands */
-	REPLY_RXON = 0x10,
-	REPLY_RXON_ASSOC = 0x11,
-	REPLY_QOS_PARAM = 0x13,
-	REPLY_RXON_TIMING = 0x14,
-
-	/* Multi-Station support */
-	REPLY_ADD_STA = 0x18,
-	REPLY_REMOVE_STA = 0x19,	/* not used */
-	REPLY_REMOVE_ALL_STA = 0x1a,	/* not used */
-
-	/* RX, TX, LEDs */
-	REPLY_3945_RX = 0x1b,		/* 3945 only */
-	REPLY_TX = 0x1c,
-	REPLY_RATE_SCALE = 0x47,	/* 3945 only */
-	REPLY_LEDS_CMD = 0x48,
-	REPLY_TX_LINK_QUALITY_CMD = 0x4e, /* 4965 only */
-
-	/* 802.11h related */
-	RADAR_NOTIFICATION = 0x70,	/* not used */
-	REPLY_QUIET_CMD = 0x71,		/* not used */
-	REPLY_CHANNEL_SWITCH = 0x72,
-	CHANNEL_SWITCH_NOTIFICATION = 0x73,
-	REPLY_SPECTRUM_MEASUREMENT_CMD = 0x74,
-	SPECTRUM_MEASURE_NOTIFICATION = 0x75,
-
-	/* Power Management */
-	POWER_TABLE_CMD = 0x77,
-	PM_SLEEP_NOTIFICATION = 0x7A,
-	PM_DEBUG_STATISTIC_NOTIFIC = 0x7B,
-
-	/* Scan commands and notifications */
-	REPLY_SCAN_CMD = 0x80,
-	REPLY_SCAN_ABORT_CMD = 0x81,
-	SCAN_START_NOTIFICATION = 0x82,
-	SCAN_RESULTS_NOTIFICATION = 0x83,
-	SCAN_COMPLETE_NOTIFICATION = 0x84,
-
-	/* IBSS/AP commands */
-	BEACON_NOTIFICATION = 0x90,
-	REPLY_TX_BEACON = 0x91,
-	WHO_IS_AWAKE_NOTIFICATION = 0x94,	/* not used */
-
-	/* Miscellaneous commands */
-	QUIET_NOTIFICATION = 0x96,		/* not used */
-	REPLY_TX_PWR_TABLE_CMD = 0x97,
-	MEASURE_ABORT_NOTIFICATION = 0x99,	/* not used */
-
-	/* Bluetooth device coexistence config command */
-	REPLY_BT_CONFIG = 0x9b,
-
-	/* Statistics */
-	REPLY_STATISTICS_CMD = 0x9c,
-	STATISTICS_NOTIFICATION = 0x9d,
-
-	/* RF-KILL commands and notifications */
-	REPLY_CARD_STATE_CMD = 0xa0,
-	CARD_STATE_NOTIFICATION = 0xa1,
-
-	/* Missed beacons notification */
-	MISSED_BEACONS_NOTIFICATION = 0xa2,
-
-	REPLY_MAX = 0xff
-};
 
 /* Tx rates */
 #define IWL_CCK_RATES	4
@@ -320,17 +252,6 @@ struct iwl3945_error_resp {
  *
  *****************************************************************************/
 
-/*
- * Rx config defines & structure
- */
-/* rx_config device types  */
-enum {
-	RXON_DEV_TYPE_AP = 1,
-	RXON_DEV_TYPE_ESS = 3,
-	RXON_DEV_TYPE_IBSS = 4,
-	RXON_DEV_TYPE_SNIFFER = 6,
-};
-
 /* rx_config flags */
 /* band & modulation selection */
 #define RXON_FLG_BAND_24G_MSK           cpu_to_le32(1 << 0)
@@ -546,18 +467,6 @@ struct iwl3945_qosparam_cmd {
 #define	STA_MODIFY_TID_DISABLE_TX	0x02
 #define	STA_MODIFY_TX_RATE_MSK		0x04
 
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
 struct iwl3945_keyinfo {
 	__le16 key_flags;
 	u8 tkip_rx_tsc_byte2;	/* TSC[2] for key mix ph1 detection */
@@ -568,26 +477,6 @@ struct iwl3945_keyinfo {
 	u8 key[16];		/* 16-byte unicast decryption key */
 } __attribute__ ((packed));
 
-/**
- * struct sta_id_modify
- * @addr[ETH_ALEN]: station's MAC address
- * @sta_id: index of station in uCode's station table
- * @modify_mask: STA_MODIFY_*, 1: modify, 0: don't change
- *
- * Driver selects unused table index when adding new station,
- * or the index to a pre-existing station entry when modifying that station.
- * Some indexes have special purposes (IWL_AP_ID, index 0, is for AP).
- *
- * modify_mask flags select which parameters to modify vs. leave alone.
- */
-struct sta_id_modify {
-	u8 addr[ETH_ALEN];
-	__le16 reserved1;
-	u8 sta_id;
-	u8 modify_mask;
-	__le16 reserved2;
-} __attribute__ ((packed));
-
 /*
  * REPLY_ADD_STA = 0x18 (command)
  *
@@ -881,73 +770,6 @@ struct iwl3945_tx_cmd {
 	struct ieee80211_hdr hdr[0];
 } __attribute__ ((packed));
 
-/* TX command response is sent after *all* transmission attempts.
- *
- * NOTES:
- *
- * TX_STATUS_FAIL_NEXT_FRAG
- *
- * If the fragment flag in the MAC header for the frame being transmitted
- * is set and there is insufficient time to transmit the next frame, the
- * TX status will be returned with 'TX_STATUS_FAIL_NEXT_FRAG'.
- *
- * TX_STATUS_FIFO_UNDERRUN
- *
- * Indicates the host did not provide bytes to the FIFO fast enough while
- * a TX was in progress.
- *
- * TX_STATUS_FAIL_MGMNT_ABORT
- *
- * This status is only possible if the ABORT ON MGMT RX parameter was
- * set to true with the TX command.
- *
- * If the MSB of the status parameter is set then an abort sequence is
- * required.  This sequence consists of the host activating the TX Abort
- * control line, and then waiting for the TX Abort command response.  This
- * indicates that a the device is no longer in a transmit state, and that the
- * command FIFO has been cleared.  The host must then deactivate the TX Abort
- * control line.  Receiving is still allowed in this case.
- */
-enum {
-	TX_STATUS_SUCCESS = 0x01,
-	TX_STATUS_DIRECT_DONE = 0x02,
-	TX_STATUS_FAIL_SHORT_LIMIT = 0x82,
-	TX_STATUS_FAIL_LONG_LIMIT = 0x83,
-	TX_STATUS_FAIL_FIFO_UNDERRUN = 0x84,
-	TX_STATUS_FAIL_MGMNT_ABORT = 0x85,
-	TX_STATUS_FAIL_NEXT_FRAG = 0x86,
-	TX_STATUS_FAIL_LIFE_EXPIRE = 0x87,
-	TX_STATUS_FAIL_DEST_PS = 0x88,
-	TX_STATUS_FAIL_ABORTED = 0x89,
-	TX_STATUS_FAIL_BT_RETRY = 0x8a,
-	TX_STATUS_FAIL_STA_INVALID = 0x8b,
-	TX_STATUS_FAIL_FRAG_DROPPED = 0x8c,
-	TX_STATUS_FAIL_TID_DISABLE = 0x8d,
-	TX_STATUS_FAIL_FRAME_FLUSHED = 0x8e,
-	TX_STATUS_FAIL_INSUFFICIENT_CF_POLL = 0x8f,
-	TX_STATUS_FAIL_TX_LOCKED = 0x90,
-	TX_STATUS_FAIL_NO_BEACON_ON_RADAR = 0x91,
-};
-
-#define	TX_PACKET_MODE_REGULAR		0x0000
-#define	TX_PACKET_MODE_BURST_SEQ	0x0100
-#define	TX_PACKET_MODE_BURST_FIRST	0x0200
-
-enum {
-	TX_POWER_PA_NOT_ACTIVE = 0x0,
-};
-
-enum {
-	TX_STATUS_MSK = 0x000000ff,	/* bits 0:7 */
-	TX_STATUS_DELAY_MSK = 0x00000040,
-	TX_STATUS_ABORT_MSK = 0x00000080,
-	TX_PACKET_MODE_MSK = 0x0000ff00,	/* bits 8:15 */
-	TX_FIFO_NUMBER_MSK = 0x00070000,	/* bits 16:18 */
-	TX_RESERVED = 0x00780000,	/* bits 19:22 */
-	TX_POWER_PA_DETECT_MSK = 0x7f800000,	/* bits 23:30 */
-	TX_ABORT_REQUIRED_MSK = 0x80000000,	/* bits 31:31 */
-};
-
 /*
  * REPLY_TX = 0x1c (response)
  */
@@ -1038,191 +860,6 @@ struct iwl3945_measure_channel {
 	__le16 reserved;
 } __attribute__ ((packed));
 
-/*
- * REPLY_SPECTRUM_MEASUREMENT_CMD = 0x74 (command)
- */
-struct iwl3945_spectrum_cmd {
-	__le16 len;		/* number of bytes starting from token */
-	u8 token;		/* token id */
-	u8 id;			/* measurement id -- 0 or 1 */
-	u8 origin;		/* 0 = TGh, 1 = other, 2 = TGk */
-	u8 periodic;		/* 1 = periodic */
-	__le16 path_loss_timeout;
-	__le32 start_time;	/* start time in extended beacon format */
-	__le32 reserved2;
-	__le32 flags;		/* rxon flags */
-	__le32 filter_flags;	/* rxon filter flags */
-	__le16 channel_count;	/* minimum 1, maximum 10 */
-	__le16 reserved3;
-	struct iwl3945_measure_channel channels[10];
-} __attribute__ ((packed));
-
-/*
- * REPLY_SPECTRUM_MEASUREMENT_CMD = 0x74 (response)
- */
-struct iwl3945_spectrum_resp {
-	u8 token;
-	u8 id;			/* id of the prior command replaced, or 0xff */
-	__le16 status;		/* 0 - command will be handled
-				 * 1 - cannot handle (conflicts with another
-				 *     measurement) */
-} __attribute__ ((packed));
-
-enum iwl3945_measurement_state {
-	IWL_MEASUREMENT_START = 0,
-	IWL_MEASUREMENT_STOP = 1,
-};
-
-enum iwl3945_measurement_status {
-	IWL_MEASUREMENT_OK = 0,
-	IWL_MEASUREMENT_CONCURRENT = 1,
-	IWL_MEASUREMENT_CSA_CONFLICT = 2,
-	IWL_MEASUREMENT_TGH_CONFLICT = 3,
-	/* 4-5 reserved */
-	IWL_MEASUREMENT_STOPPED = 6,
-	IWL_MEASUREMENT_TIMEOUT = 7,
-	IWL_MEASUREMENT_PERIODIC_FAILED = 8,
-};
-
-#define NUM_ELEMENTS_IN_HISTOGRAM 8
-
-struct iwl3945_measurement_histogram {
-	__le32 ofdm[NUM_ELEMENTS_IN_HISTOGRAM];	/* in 0.8usec counts */
-	__le32 cck[NUM_ELEMENTS_IN_HISTOGRAM];	/* in 1usec counts */
-} __attribute__ ((packed));
-
-/* clear channel availability counters */
-struct iwl3945_measurement_cca_counters {
-	__le32 ofdm;
-	__le32 cck;
-} __attribute__ ((packed));
-
-enum iwl3945_measure_type {
-	IWL_MEASURE_BASIC = (1 << 0),
-	IWL_MEASURE_CHANNEL_LOAD = (1 << 1),
-	IWL_MEASURE_HISTOGRAM_RPI = (1 << 2),
-	IWL_MEASURE_HISTOGRAM_NOISE = (1 << 3),
-	IWL_MEASURE_FRAME = (1 << 4),
-	/* bits 5:6 are reserved */
-	IWL_MEASURE_IDLE = (1 << 7),
-};
-
-/*
- * SPECTRUM_MEASURE_NOTIFICATION = 0x75 (notification only, not a command)
- */
-struct iwl3945_spectrum_notification {
-	u8 id;			/* measurement id -- 0 or 1 */
-	u8 token;
-	u8 channel_index;	/* index in measurement channel list */
-	u8 state;		/* 0 - start, 1 - stop */
-	__le32 start_time;	/* lower 32-bits of TSF */
-	u8 band;		/* 0 - 5.2GHz, 1 - 2.4GHz */
-	u8 channel;
-	u8 type;		/* see enum iwl3945_measurement_type */
-	u8 reserved1;
-	/* NOTE:  cca_ofdm, cca_cck, basic_type, and histogram are only only
-	 * valid if applicable for measurement type requested. */
-	__le32 cca_ofdm;	/* cca fraction time in 40Mhz clock periods */
-	__le32 cca_cck;		/* cca fraction time in 44Mhz clock periods */
-	__le32 cca_time;	/* channel load time in usecs */
-	u8 basic_type;		/* 0 - bss, 1 - ofdm preamble, 2 -
-				 * unidentified */
-	u8 reserved2[3];
-	struct iwl3945_measurement_histogram histogram;
-	__le32 stop_time;	/* lower 32-bits of TSF */
-	__le32 status;		/* see iwl3945_measurement_status */
-} __attribute__ ((packed));
-
-/******************************************************************************
- * (7)
- * Power Management Commands, Responses, Notifications:
- *
- *****************************************************************************/
-
-/**
- * struct iwl3945_powertable_cmd - Power Table Command
- * @flags: See below:
- *
- * POWER_TABLE_CMD = 0x77 (command, has simple generic response)
- *
- * PM allow:
- *   bit 0 - '0' Driver not allow power management
- *           '1' Driver allow PM (use rest of parameters)
- * uCode send sleep notifications:
- *   bit 1 - '0' Don't send sleep notification
- *           '1' send sleep notification (SEND_PM_NOTIFICATION)
- * Sleep over DTIM
- *   bit 2 - '0' PM have to walk up every DTIM
- *           '1' PM could sleep over DTIM till listen Interval.
- * PCI power managed
- *   bit 3 - '0' (PCI_LINK_CTRL & 0x1)
- *           '1' !(PCI_LINK_CTRL & 0x1)
- * Force sleep Modes
- *   bit 31/30- '00' use both mac/xtal sleeps
- *              '01' force Mac sleep
- *              '10' force xtal sleep
- *              '11' Illegal set
- *
- * NOTE: if sleep_interval[SLEEP_INTRVL_TABLE_SIZE-1] > DTIM period then
- * ucode assume sleep over DTIM is allowed and we don't need to wakeup
- * for every DTIM.
- */
-#define IWL_POWER_VEC_SIZE 5
-
-#define IWL_POWER_DRIVER_ALLOW_SLEEP_MSK	cpu_to_le32(1 << 0)
-#define IWL_POWER_SLEEP_OVER_DTIM_MSK		cpu_to_le32(1 << 2)
-#define IWL_POWER_PCI_PM_MSK			cpu_to_le32(1 << 3)
-struct iwl3945_powertable_cmd {
-	__le32 flags;
-	__le32 rx_data_timeout;
-	__le32 tx_data_timeout;
-	__le32 sleep_interval[IWL_POWER_VEC_SIZE];
-} __attribute__((packed));
-
-/*
- * PM_SLEEP_NOTIFICATION = 0x7A (notification only, not a command)
- * 3945 and 4965 identical.
- */
-struct iwl3945_sleep_notification {
-	u8 pm_sleep_mode;
-	u8 pm_wakeup_src;
-	__le16 reserved;
-	__le32 sleep_time;
-	__le32 tsf_low;
-	__le32 bcon_timer;
-} __attribute__ ((packed));
-
-/* Sleep states.  3945 and 4965 identical. */
-enum {
-	IWL_PM_NO_SLEEP = 0,
-	IWL_PM_SLP_MAC = 1,
-	IWL_PM_SLP_FULL_MAC_UNASSOCIATE = 2,
-	IWL_PM_SLP_FULL_MAC_CARD_STATE = 3,
-	IWL_PM_SLP_PHY = 4,
-	IWL_PM_SLP_REPENT = 5,
-	IWL_PM_WAKEUP_BY_TIMER = 6,
-	IWL_PM_WAKEUP_BY_DRIVER = 7,
-	IWL_PM_WAKEUP_BY_RFKILL = 8,
-	/* 3 reserved */
-	IWL_PM_NUM_OF_MODES = 12,
-};
-
-/*
- * REPLY_CARD_STATE_CMD = 0xa0 (command, has simple generic response)
- */
-#define CARD_STATE_CMD_DISABLE 0x00	/* Put card to sleep */
-#define CARD_STATE_CMD_ENABLE  0x01	/* Wake up card */
-#define CARD_STATE_CMD_HALT    0x02	/* Power down permanently */
-struct iwl3945_card_state_cmd {
-	__le32 status;		/* CARD_STATE_CMD_* request new power state */
-} __attribute__ ((packed));
-
-/*
- * CARD_STATE_NOTIFICATION = 0xa1 (notification only, not a command)
- */
-struct iwl3945_card_state_notif {
-	__le32 flags;
-} __attribute__ ((packed));
 
 #define HW_CARD_DISABLED   0x01
 #define SW_CARD_DISABLED   0x02
@@ -1288,7 +925,8 @@ struct iwl3945_ssid_ie {
 	u8 ssid[32];
 } __attribute__ ((packed));
 
-#define PROBE_OPTION_MAX        0x4
+/* uCode API-1 take 4 probes */
+#define PROBE_OPTION_MAX_API1		0x4
 #define TX_CMD_LIFE_TIME_INFINITE	cpu_to_le32(0xFFFFFFFF)
 #define IWL_GOOD_CRC_TH		cpu_to_le16(1)
 #define IWL_MAX_SCAN_SIZE 1024
@@ -1369,7 +1007,7 @@ struct iwl3945_scan_cmd {
 	struct iwl3945_tx_cmd tx_cmd;
 
 	/* For directed active scans (set to all-0s otherwise) */
-	struct iwl3945_ssid_ie direct_scan[PROBE_OPTION_MAX];
+	struct iwl3945_ssid_ie direct_scan[PROBE_OPTION_MAX_API1];
 
 	/*
 	 * Probe request frame, followed by channel list.
@@ -1476,29 +1114,7 @@ struct iwl3945_tx_beacon_cmd {
  *
  *****************************************************************************/
 
-#define IWL_TEMP_CONVERT 260
-
-#define SUP_RATE_11A_MAX_NUM_CHANNELS  8
-#define SUP_RATE_11B_MAX_NUM_CHANNELS  4
-#define SUP_RATE_11G_MAX_NUM_CHANNELS  12
-
-/* Used for passing to driver number of successes and failures per rate */
-struct rate_histogram {
-	union {
-		__le32 a[SUP_RATE_11A_MAX_NUM_CHANNELS];
-		__le32 b[SUP_RATE_11B_MAX_NUM_CHANNELS];
-		__le32 g[SUP_RATE_11G_MAX_NUM_CHANNELS];
-	} success;
-	union {
-		__le32 a[SUP_RATE_11A_MAX_NUM_CHANNELS];
-		__le32 b[SUP_RATE_11B_MAX_NUM_CHANNELS];
-		__le32 g[SUP_RATE_11G_MAX_NUM_CHANNELS];
-	} failed;
-} __attribute__ ((packed));
-
-/* statistics command response */
-
-struct statistics_rx_phy {
+struct iwl39_statistics_rx_phy {
 	__le32 ina_cnt;
 	__le32 fina_cnt;
 	__le32 plcp_err;
@@ -1516,7 +1132,7 @@ struct statistics_rx_phy {
 	__le32 sent_cts_cnt;
 } __attribute__ ((packed));
 
-struct statistics_rx_non_phy {
+struct iwl39_statistics_rx_non_phy {
 	__le32 bogus_cts;	/* CTS received when not expecting CTS */
 	__le32 bogus_ack;	/* ACK received when not expecting ACK */
 	__le32 non_bssid_frames;	/* number of frames with BSSID that
@@ -1527,13 +1143,13 @@ struct statistics_rx_non_phy {
 					 * our serving channel */
 } __attribute__ ((packed));
 
-struct statistics_rx {
-	struct statistics_rx_phy ofdm;
-	struct statistics_rx_phy cck;
-	struct statistics_rx_non_phy general;
+struct iwl39_statistics_rx {
+	struct iwl39_statistics_rx_phy ofdm;
+	struct iwl39_statistics_rx_phy cck;
+	struct iwl39_statistics_rx_non_phy general;
 } __attribute__ ((packed));
 
-struct statistics_tx {
+struct iwl39_statistics_tx {
 	__le32 preamble_cnt;
 	__le32 rx_detected_cnt;
 	__le32 bt_prio_defer_cnt;
@@ -1545,27 +1161,21 @@ struct statistics_tx {
 	__le32 actual_ack_cnt;
 } __attribute__ ((packed));
 
-struct statistics_dbg {
-	__le32 burst_check;
-	__le32 burst_count;
-	__le32 reserved[4];
-} __attribute__ ((packed));
-
-struct statistics_div {
+struct iwl39_statistics_div {
 	__le32 tx_on_a;
 	__le32 tx_on_b;
 	__le32 exec_time;
 	__le32 probe_time;
 } __attribute__ ((packed));
 
-struct statistics_general {
+struct iwl39_statistics_general {
 	__le32 temperature;
 	struct statistics_dbg dbg;
 	__le32 sleep_time;
 	__le32 slots_out;
 	__le32 slots_idle;
 	__le32 ttl_timestamp;
-	struct statistics_div div;
+	struct iwl39_statistics_div div;
 } __attribute__ ((packed));
 
 /*
@@ -1688,14 +1298,14 @@ struct iwl3945_rx_packet {
 		struct iwl3945_alive_resp alive_frame;
 		struct iwl3945_rx_frame rx_frame;
 		struct iwl3945_tx_resp tx_resp;
-		struct iwl3945_spectrum_notification spectrum_notif;
-		struct iwl3945_csa_notification csa_notif;
+		struct iwl_spectrum_notification spectrum_notif;
+		struct iwl_csa_notification csa_notif;
 		struct iwl3945_error_resp err_resp;
-		struct iwl3945_card_state_notif card_state_notif;
+		struct iwl_card_state_notif card_state_notif;
 		struct iwl3945_beacon_notif beacon_status;
 		struct iwl3945_add_sta_resp add_sta;
-		struct iwl3945_sleep_notification sleep_notif;
-		struct iwl3945_spectrum_resp spectrum;
+		struct iwl_sleep_notification sleep_notif;
+		struct iwl_spectrum_resp spectrum;
 		struct iwl3945_notif_statistics stats;
 		__le32 status;
 		u8 raw[0];
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-led.c b/drivers/net/wireless/iwlwifi/iwl-3945-led.c
index b0d420f..525e90b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-led.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-led.c
@@ -38,6 +38,7 @@
 #include <linux/etherdevice.h>
 #include <asm/unaligned.h>
 
+#include "iwl-commands.h"
 #include "iwl-3945-commands.h"
 #include "iwl-3945.h"
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-rs.c b/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
index 48ca1ca..3b8db16 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
@@ -36,6 +36,7 @@
 
 #include <linux/workqueue.h>
 
+#include "iwl-commands.h"
 #include "iwl-3945-commands.h"
 #include "iwl-3945.h"
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 1874422..8cc56f0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -40,6 +40,7 @@
 
 #include "iwl-3945-core.h"
 #include "iwl-3945-fh.h"
+#include "iwl-commands.h"
 #include "iwl-3945-commands.h"
 #include "iwl-3945.h"
 #include "iwl-helpers.h"
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index d07aafe..0010932 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -250,7 +250,7 @@ struct iwl3945_clip_group {
 /* Power management (not Tx power) structures */
 
 struct iwl3945_power_vec_entry {
-	struct iwl3945_powertable_cmd cmd;
+	struct iwl_powertable_cmd cmd;
 	u8 no_dtim;
 };
 #define IWL_POWER_RANGE_0  (0)
@@ -289,12 +289,6 @@ struct iwl3945_frame {
 	struct list_head list;
 };
 
-#define SEQ_TO_QUEUE(x)  ((x >> 8) & 0xbf)
-#define QUEUE_TO_SEQ(x)  ((x & 0xbf) << 8)
-#define SEQ_TO_INDEX(x) ((u8)(x & 0xff))
-#define INDEX_TO_SEQ(x) ((u8)(x & 0xff))
-#define SEQ_HUGE_FRAME  (0x4000)
-#define SEQ_RX_FRAME    __constant_cpu_to_le16(0x8000)
 #define SEQ_TO_SN(seq) (((seq) & IEEE80211_SCTL_SEQ) >> 4)
 #define SN_TO_SEQ(ssn) (((ssn) << 4) & IEEE80211_SCTL_SEQ)
 #define MAX_SN ((IEEE80211_SCTL_SEQ) >> 4)
@@ -344,7 +338,7 @@ struct iwl3945_cmd {
 		u32 val32;
 		struct iwl3945_bt_cmd bt;
 		struct iwl3945_rxon_time_cmd rxon_time;
-		struct iwl3945_powertable_cmd powertable;
+		struct iwl_powertable_cmd powertable;
 		struct iwl3945_qosparam_cmd qosparam;
 		struct iwl3945_tx_cmd tx;
 		struct iwl3945_tx_beacon_cmd tx_beacon;
@@ -707,7 +701,7 @@ struct iwl3945_priv {
 
 #ifdef CONFIG_IWL3945_SPECTRUM_MEASUREMENT
 	/* spectrum measurement report caching */
-	struct iwl3945_spectrum_notification measure_report;
+	struct iwl_spectrum_notification measure_report;
 	u8 measurement_status;
 #endif
 	/* ucode beacon time */
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 52966ff..9cfdd1c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -300,11 +300,12 @@ struct iwl_cmd_header {
  * 5350 has 3 transmitters
  * bit14:16
  */
-#define RATE_MCS_ANT_POS      14
-#define RATE_MCS_ANT_A_MSK    0x04000
-#define RATE_MCS_ANT_B_MSK    0x08000
-#define RATE_MCS_ANT_C_MSK    0x10000
-#define RATE_MCS_ANT_ABC_MSK  0x1C000
+#define RATE_MCS_ANT_POS	14
+#define RATE_MCS_ANT_A_MSK	0x04000
+#define RATE_MCS_ANT_B_MSK	0x08000
+#define RATE_MCS_ANT_C_MSK	0x10000
+#define RATE_MCS_ANT_AB_MSK	(RATE_MCS_ANT_A_MSK | RATE_MCS_ANT_B_MSK)
+#define RATE_MCS_ANT_ABC_MSK	(RATE_MCS_ANT_AB_MSK | RATE_MCS_ANT_C_MSK)
 #define RATE_ANT_NUM 3
 
 #define POWER_TABLE_NUM_ENTRIES			33
@@ -2044,15 +2045,23 @@ struct iwl_spectrum_notification {
  */
 #define IWL_POWER_VEC_SIZE 5
 
-#define IWL_POWER_DRIVER_ALLOW_SLEEP_MSK	cpu_to_le16(1 << 0)
-#define IWL_POWER_SLEEP_OVER_DTIM_MSK		cpu_to_le16(1 << 2)
-#define IWL_POWER_PCI_PM_MSK			cpu_to_le16(1 << 3)
-#define IWL_POWER_FAST_PD			cpu_to_le16(1 << 4)
+#define IWL_POWER_DRIVER_ALLOW_SLEEP_MSK	cpu_to_le16(BIT(0))
+#define IWL_POWER_SLEEP_OVER_DTIM_MSK		cpu_to_le16(BIT(2))
+#define IWL_POWER_PCI_PM_MSK			cpu_to_le16(BIT(3))
+#define IWL_POWER_FAST_PD			cpu_to_le16(BIT(4))
+
+struct iwl3945_powertable_cmd {
+	__le16 flags;
+	u8 reserved[2];
+	__le32 rx_data_timeout;
+	__le32 tx_data_timeout;
+	__le32 sleep_interval[IWL_POWER_VEC_SIZE];
+} __attribute__ ((packed));
 
 struct iwl_powertable_cmd {
 	__le16 flags;
-	u8 keep_alive_seconds;
-	u8 debug_flags;
+	u8 keep_alive_seconds;		/* 3945 reserved */
+	u8 debug_flags;			/* 3945 reserved */
 	__le32 rx_data_timeout;
 	__le32 tx_data_timeout;
 	__le32 sleep_interval[IWL_POWER_VEC_SIZE];
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 5c09995..e6ed571 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -47,6 +47,7 @@
 #include <asm/div64.h>
 
 #include "iwl-3945-core.h"
+#include "iwl-commands.h"
 #include "iwl-3945-commands.h"
 #include "iwl-3945.h"
 #include "iwl-3945-fh.h"
@@ -635,7 +636,7 @@ static int iwl3945_enqueue_hcmd(struct iwl3945_priv *priv, struct iwl3945_host_c
 	out_cmd->hdr.sequence = cpu_to_le16(QUEUE_TO_SEQ(IWL_CMD_QUEUE_NUM) |
 			INDEX_TO_SEQ(q->write_ptr));
 	if (out_cmd->meta.flags & CMD_SIZE_HUGE)
-		out_cmd->hdr.sequence |= cpu_to_le16(SEQ_HUGE_FRAME);
+		out_cmd->hdr.sequence |= SEQ_HUGE_FRAME;
 
 	phys_addr = txq->dma_addr_cmd + sizeof(txq->cmd[0]) * idx +
 			offsetof(struct iwl3945_cmd, hdr);
@@ -1806,8 +1807,9 @@ static void iwl3945_activate_qos(struct iwl3945_priv *priv, u8 force)
  */
 #define MSEC_TO_USEC 1024
 
-#define NOSLP __constant_cpu_to_le32(0)
-#define SLP IWL_POWER_DRIVER_ALLOW_SLEEP_MSK
+
+#define NOSLP __constant_cpu_to_le16(0), 0, 0
+#define SLP IWL_POWER_DRIVER_ALLOW_SLEEP_MSK, 0, 0
 #define SLP_TIMEOUT(T) __constant_cpu_to_le32((T) * MSEC_TO_USEC)
 #define SLP_VEC(X0, X1, X2, X3, X4) {__constant_cpu_to_le32(X0), \
 				     __constant_cpu_to_le32(X1), \
@@ -1815,7 +1817,6 @@ static void iwl3945_activate_qos(struct iwl3945_priv *priv, u8 force)
 				     __constant_cpu_to_le32(X3), \
 				     __constant_cpu_to_le32(X4)}
 
-
 /* default power management (not Tx power) table values */
 /* for TIM  0-10 */
 static struct iwl3945_power_vec_entry range_0[IWL_POWER_AC] = {
@@ -1864,7 +1865,7 @@ int iwl3945_power_init_handle(struct iwl3945_priv *priv)
 	if (rc != 0)
 		return 0;
 	else {
-		struct iwl3945_powertable_cmd *cmd;
+		struct iwl_powertable_cmd *cmd;
 
 		IWL_DEBUG_POWER("adjust power command flags\n");
 
@@ -1881,7 +1882,7 @@ int iwl3945_power_init_handle(struct iwl3945_priv *priv)
 }
 
 static int iwl3945_update_power_cmd(struct iwl3945_priv *priv,
-				struct iwl3945_powertable_cmd *cmd, u32 mode)
+				struct iwl_powertable_cmd *cmd, u32 mode)
 {
 	int rc = 0, i;
 	u8 skip;
@@ -1948,7 +1949,7 @@ static int iwl3945_send_power_mode(struct iwl3945_priv *priv, u32 mode)
 {
 	u32 uninitialized_var(final_mode);
 	int rc;
-	struct iwl3945_powertable_cmd cmd;
+	struct iwl_powertable_cmd cmd;
 
 	/* If on battery, set to 3,
 	 * if plugged into AC power, set to CAM ("continuously aware mode"),
@@ -1967,7 +1968,9 @@ static int iwl3945_send_power_mode(struct iwl3945_priv *priv, u32 mode)
 
 	iwl3945_update_power_cmd(priv, &cmd, final_mode);
 
-	rc = iwl3945_send_cmd_pdu(priv, POWER_TABLE_CMD, sizeof(cmd), &cmd);
+	/* FIXME use get_hcmd_size 3945 command is 4 bytes shorter */
+	rc = iwl3945_send_cmd_pdu(priv, POWER_TABLE_CMD,
+				sizeof(struct iwl3945_powertable_cmd), &cmd);
 
 	if (final_mode == IWL_POWER_MODE_CAM)
 		clear_bit(STATUS_POWER_PMI, &priv->status);
@@ -2873,7 +2876,7 @@ static int iwl3945_get_measurement(struct iwl3945_priv *priv,
 			       struct ieee80211_measurement_params *params,
 			       u8 type)
 {
-	struct iwl3945_spectrum_cmd spectrum;
+	struct iwl_spectrum_cmd spectrum;
 	struct iwl3945_rx_packet *res;
 	struct iwl3945_host_cmd cmd = {
 		.id = REPLY_SPECTRUM_MEASUREMENT_CMD,
@@ -3014,7 +3017,7 @@ static void iwl3945_rx_csa(struct iwl3945_priv *priv, struct iwl3945_rx_mem_buff
 {
 	struct iwl3945_rx_packet *pkt = (void *)rxb->skb->data;
 	struct iwl3945_rxon_cmd *rxon = (void *)&priv->active_rxon;
-	struct iwl3945_csa_notification *csa = &(pkt->u.csa_notif);
+	struct iwl_csa_notification *csa = &(pkt->u.csa_notif);
 	IWL_DEBUG_11H("CSA notif: channel %d, status %d\n",
 		      le16_to_cpu(csa->channel), le32_to_cpu(csa->status));
 	rxon->channel = csa->channel;
@@ -3026,7 +3029,7 @@ static void iwl3945_rx_spectrum_measure_notif(struct iwl3945_priv *priv,
 {
 #ifdef CONFIG_IWL3945_SPECTRUM_MEASUREMENT
 	struct iwl3945_rx_packet *pkt = (void *)rxb->skb->data;
-	struct iwl3945_spectrum_notification *report = &(pkt->u.spectrum_notif);
+	struct iwl_spectrum_notification *report = &(pkt->u.spectrum_notif);
 
 	if (!report->state) {
 		IWL_DEBUG(IWL_DL_11H | IWL_DL_INFO,
@@ -3044,7 +3047,7 @@ static void iwl3945_rx_pm_sleep_notif(struct iwl3945_priv *priv,
 {
 #ifdef CONFIG_IWL3945_DEBUG
 	struct iwl3945_rx_packet *pkt = (void *)rxb->skb->data;
-	struct iwl3945_sleep_notification *sleep = &(pkt->u.sleep_notif);
+	struct iwl_sleep_notification *sleep = &(pkt->u.sleep_notif);
 	IWL_DEBUG_RX("sleep mode: %d, src: %d\n",
 		     sleep->pm_sleep_mode, sleep->pm_wakeup_src);
 #endif
@@ -3351,7 +3354,7 @@ static void iwl3945_tx_cmd_complete(struct iwl3945_priv *priv,
 	u16 sequence = le16_to_cpu(pkt->hdr.sequence);
 	int txq_id = SEQ_TO_QUEUE(sequence);
 	int index = SEQ_TO_INDEX(sequence);
-	int huge = sequence & SEQ_HUGE_FRAME;
+	int huge =  !!(pkt->hdr.sequence & SEQ_HUGE_FRAME);
 	int cmd_index;
 	struct iwl3945_cmd *cmd;
 
@@ -7424,7 +7427,7 @@ static ssize_t show_measurement(struct device *d,
 				struct device_attribute *attr, char *buf)
 {
 	struct iwl3945_priv *priv = dev_get_drvdata(d);
-	struct iwl3945_spectrum_notification measure_report;
+	struct iwl_spectrum_notification measure_report;
 	u32 size = sizeof(measure_report), len = 0, ofs = 0;
 	u8 *data = (u8 *)&measure_report;
 	unsigned long flags;
-- 
1.5.3.6

