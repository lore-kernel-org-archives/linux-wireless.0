Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:10633 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752517AbYLSCpB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2008 21:45:01 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Tomas Winkler <tomas.winkler@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 05/43] iwlwifi: 3945 remove duplicated code from iwl-3945-commands.h
Date: Fri, 19 Dec 2008 10:37:05 +0800
Message-Id: <1229654263-21454-6-git-send-email-yi.zhu@intel.com> (sfid-20081219_034514_676415_FEBF9B77)
In-Reply-To: <1229654263-21454-5-git-send-email-yi.zhu@intel.com>
References: <1229654263-21454-1-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-2-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-3-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-4-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-5-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch remove trivial (renames) commands and defines
from iwl-3945-commands.h

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Acked-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945-commands.h |  525 +---------------------
 drivers/net/wireless/iwlwifi/iwl-3945-led.c      |   13 +-
 drivers/net/wireless/iwlwifi/iwl-3945.h          |   10 +-
 drivers/net/wireless/iwlwifi/iwl-commands.h      |   11 +
 drivers/net/wireless/iwlwifi/iwl3945-base.c      |   27 +-
 5 files changed, 39 insertions(+), 547 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-commands.h b/drivers/net/wireless/iwlwifi/iwl-3945-commands.h
index acc584f..fe71e0a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-commands.h
@@ -69,64 +69,12 @@
 #ifndef __iwl_3945_commands_h__
 #define __iwl_3945_commands_h__
 
-/* uCode version contains 4 values: Major/Minor/API/Serial */
-#define IWL_UCODE_MAJOR(ver)	(((ver) & 0xFF000000) >> 24)
-#define IWL_UCODE_MINOR(ver)	(((ver) & 0x00FF0000) >> 16)
-#define IWL_UCODE_API(ver)	(((ver) & 0x0000FF00) >> 8)
-#define IWL_UCODE_SERIAL(ver)	((ver) & 0x000000FF)
-
-
-/* Tx rates */
-#define IWL_CCK_RATES	4
-#define IWL_OFDM_RATES	8
-#define IWL_MAX_RATES	(IWL_CCK_RATES + IWL_OFDM_RATES)
-
 /******************************************************************************
  * (0)
  * Commonly used structures and definitions:
  * Command header, txpower
  *
  *****************************************************************************/
-
-/* iwl3945_cmd_header flags value */
-#define IWL_CMD_FAILED_MSK 0x40
-
-/**
- * struct iwl3945_cmd_header
- *
- * This header format appears in the beginning of each command sent from the
- * driver, and each response/notification received from uCode.
- */
-struct iwl3945_cmd_header {
-	u8 cmd;		/* Command ID:  REPLY_RXON, etc. */
-	u8 flags;	/* IWL_CMD_* */
-	/*
-	 * The driver sets up the sequence number to values of its choosing.
-	 * uCode does not use this value, but passes it back to the driver
-	 * when sending the response to each driver-originated command, so
-	 * the driver can match the response to the command.  Since the values
-	 * don't get used by uCode, the driver may set up an arbitrary format.
-	 *
-	 * There is one exception:  uCode sets bit 15 when it originates
-	 * the response/notification, i.e. when the response/notification
-	 * is not a direct response to a command sent by the driver.  For
-	 * example, uCode issues REPLY_3945_RX when it sends a received frame
-	 * to the driver; it is not a direct response to any driver command.
-	 *
-	 * The Linux driver uses the following format:
-	 *
-	 *  0:7    index/position within Tx queue
-	 *  8:13   Tx queue selection
-	 * 14:14   driver sets this to indicate command is in the 'huge'
-	 *         storage at the end of the command buffers, i.e. scan cmd
-	 * 15:15   uCode sets this in uCode-originated response/notification
-	 */
-	__le16 sequence;
-
-	/* command or response/notification data follows immediately */
-	u8 data[0];
-} __attribute__ ((packed));
-
 /**
  * struct iwl3945_tx_power
  *
@@ -163,8 +111,6 @@ struct iwl3945_power_per_rate {
  *
  *****************************************************************************/
 
-#define UCODE_VALID_OK	cpu_to_le32(0x1)
-#define INITIALIZE_SUBTYPE    (9)
 
 /*
  * ("Initialize") REPLY_ALIVE = 0x1 (response only, not a command)
@@ -252,45 +198,6 @@ struct iwl3945_error_resp {
  *
  *****************************************************************************/
 
-/* rx_config flags */
-/* band & modulation selection */
-#define RXON_FLG_BAND_24G_MSK           cpu_to_le32(1 << 0)
-#define RXON_FLG_CCK_MSK                cpu_to_le32(1 << 1)
-/* auto detection enable */
-#define RXON_FLG_AUTO_DETECT_MSK        cpu_to_le32(1 << 2)
-/* TGg protection when tx */
-#define RXON_FLG_TGG_PROTECT_MSK        cpu_to_le32(1 << 3)
-/* cck short slot & preamble */
-#define RXON_FLG_SHORT_SLOT_MSK          cpu_to_le32(1 << 4)
-#define RXON_FLG_SHORT_PREAMBLE_MSK     cpu_to_le32(1 << 5)
-/* antenna selection */
-#define RXON_FLG_DIS_DIV_MSK            cpu_to_le32(1 << 7)
-#define RXON_FLG_ANT_SEL_MSK            cpu_to_le32(0x0f00)
-#define RXON_FLG_ANT_A_MSK              cpu_to_le32(1 << 8)
-#define RXON_FLG_ANT_B_MSK              cpu_to_le32(1 << 9)
-/* radar detection enable */
-#define RXON_FLG_RADAR_DETECT_MSK       cpu_to_le32(1 << 12)
-#define RXON_FLG_TGJ_NARROW_BAND_MSK    cpu_to_le32(1 << 13)
-/* rx response to host with 8-byte TSF
-* (according to ON_AIR deassertion) */
-#define RXON_FLG_TSF2HOST_MSK           cpu_to_le32(1 << 15)
-
-/* rx_config filter flags */
-/* accept all data frames */
-#define RXON_FILTER_PROMISC_MSK         cpu_to_le32(1 << 0)
-/* pass control & management to host */
-#define RXON_FILTER_CTL2HOST_MSK        cpu_to_le32(1 << 1)
-/* accept multi-cast */
-#define RXON_FILTER_ACCEPT_GRP_MSK      cpu_to_le32(1 << 2)
-/* don't decrypt uni-cast frames */
-#define RXON_FILTER_DIS_DECRYPT_MSK     cpu_to_le32(1 << 3)
-/* don't decrypt multi-cast frames */
-#define RXON_FILTER_DIS_GRP_DECRYPT_MSK cpu_to_le32(1 << 4)
-/* STA is associated */
-#define RXON_FILTER_ASSOC_MSK           cpu_to_le32(1 << 5)
-/* transfer to host non bssid beacons in associated state */
-#define RXON_FILTER_BCON_AWARE_MSK      cpu_to_le32(1 << 6)
-
 /**
  * REPLY_RXON = 0x10 (command, has simple generic response)
  *
@@ -363,121 +270,12 @@ struct iwl3945_channel_switch_cmd {
 	struct iwl3945_power_per_rate power[IWL_MAX_RATES];
 } __attribute__ ((packed));
 
-/*
- * CHANNEL_SWITCH_NOTIFICATION = 0x73 (notification only, not a command)
- */
-struct iwl3945_csa_notification {
-	__le16 band;
-	__le16 channel;
-	__le32 status;		/* 0 - OK, 1 - fail */
-} __attribute__ ((packed));
-
-/******************************************************************************
- * (2)
- * Quality-of-Service (QOS) Commands & Responses:
- *
- *****************************************************************************/
-
-/**
- * struct iwl_ac_qos -- QOS timing params for REPLY_QOS_PARAM
- * One for each of 4 EDCA access categories in struct iwl_qosparam_cmd
- *
- * @cw_min: Contention window, start value in numbers of slots.
- *          Should be a power-of-2, minus 1.  Device's default is 0x0f.
- * @cw_max: Contention window, max value in numbers of slots.
- *          Should be a power-of-2, minus 1.  Device's default is 0x3f.
- * @aifsn:  Number of slots in Arbitration Interframe Space (before
- *          performing random backoff timing prior to Tx).  Device default 1.
- * @edca_txop:  Length of Tx opportunity, in uSecs.  Device default is 0.
- *
- * Device will automatically increase contention window by (2*CW) + 1 for each
- * transmission retry.  Device uses cw_max as a bit mask, ANDed with new CW
- * value, to cap the CW value.
- */
-struct iwl3945_ac_qos {
-	__le16 cw_min;
-	__le16 cw_max;
-	u8 aifsn;
-	u8 reserved1;
-	__le16 edca_txop;
-} __attribute__ ((packed));
-
-/* QoS flags defines */
-#define QOS_PARAM_FLG_UPDATE_EDCA_MSK	cpu_to_le32(0x01)
-#define QOS_PARAM_FLG_TGN_MSK		cpu_to_le32(0x02)
-#define QOS_PARAM_FLG_TXOP_TYPE_MSK	cpu_to_le32(0x10)
-
-/* Number of Access Categories (AC) (EDCA), queues 0..3 */
-#define AC_NUM                4
-
-/*
- * REPLY_QOS_PARAM = 0x13 (command, has simple generic response)
- *
- * This command sets up timings for each of the 4 prioritized EDCA Tx FIFOs
- * 0: Background, 1: Best Effort, 2: Video, 3: Voice.
- */
-struct iwl3945_qosparam_cmd {
-	__le32 qos_flags;
-	struct iwl3945_ac_qos ac[AC_NUM];
-} __attribute__ ((packed));
-
 /******************************************************************************
  * (3)
  * Add/Modify Stations Commands & Responses:
  *
  *****************************************************************************/
 /*
- * Multi station support
- */
-
-/* Special, dedicated locations within device's station table */
-#define	IWL_AP_ID		0
-#define IWL_MULTICAST_ID	1
-#define	IWL_STA_ID		2
-#define	IWL3945_BROADCAST_ID	24
-#define IWL3945_STATION_COUNT	25
-
-#define	IWL_STATION_COUNT	32 	/* MAX(3945,4965)*/
-#define	IWL_INVALID_STATION 	255
-
-#define STA_FLG_TX_RATE_MSK		cpu_to_le32(1 << 2);
-#define STA_FLG_PWR_SAVE_MSK		cpu_to_le32(1 << 8);
-
-/* Use in mode field.  1: modify existing entry, 0: add new station entry */
-#define STA_CONTROL_MODIFY_MSK		0x01
-
-/* key flags __le16*/
-#define STA_KEY_FLG_ENCRYPT_MSK	cpu_to_le16(0x0007)
-#define STA_KEY_FLG_NO_ENC	cpu_to_le16(0x0000)
-#define STA_KEY_FLG_WEP		cpu_to_le16(0x0001)
-#define STA_KEY_FLG_CCMP	cpu_to_le16(0x0002)
-#define STA_KEY_FLG_TKIP	cpu_to_le16(0x0003)
-
-#define STA_KEY_FLG_KEYID_POS	8
-#define STA_KEY_FLG_INVALID 	cpu_to_le16(0x0800)
-/* wep key is either from global key (0) or from station info array (1) */
-#define STA_KEY_FLG_WEP_KEY_MAP_MSK  cpu_to_le16(0x0008)
-
-/* wep key in STA: 5-bytes (0) or 13-bytes (1) */
-#define STA_KEY_FLG_KEY_SIZE_MSK     cpu_to_le16(0x1000)
-#define STA_KEY_MULTICAST_MSK        cpu_to_le16(0x4000)
-
-/* Flags indicate whether to modify vs. don't change various station params */
-#define	STA_MODIFY_KEY_MASK		0x01
-#define	STA_MODIFY_TID_DISABLE_TX	0x02
-#define	STA_MODIFY_TX_RATE_MSK		0x04
-
-struct iwl3945_keyinfo {
-	__le16 key_flags;
-	u8 tkip_rx_tsc_byte2;	/* TSC[2] for key mix ph1 detection */
-	u8 reserved1;
-	__le16 tkip_rx_ttak[5];	/* 10-byte unicast TKIP TTAK */
-	u8 key_offset;
-	u8 reserved2;
-	u8 key[16];		/* 16-byte unicast decryption key */
-} __attribute__ ((packed));
-
-/*
  * REPLY_ADD_STA = 0x18 (command)
  *
  * The device contains an internal table of per-station information,
@@ -506,7 +304,7 @@ struct iwl3945_addsta_cmd {
 	u8 mode;		/* 1: modify existing, 0: add new station */
 	u8 reserved[3];
 	struct sta_id_modify sta;
-	struct iwl3945_keyinfo key;
+	struct iwl4965_keyinfo key;
 	__le32 station_flags;		/* STA_FLG_* */
 	__le32 station_flags_msk;	/* STA_FLG_* */
 
@@ -530,16 +328,6 @@ struct iwl3945_addsta_cmd {
 	__le16 add_immediate_ba_ssn;
 } __attribute__ ((packed));
 
-#define ADD_STA_SUCCESS_MSK		0x1
-#define ADD_STA_NO_ROOM_IN_TABLE	0x2
-#define ADD_STA_NO_BLOCK_ACK_RESOURCE	0x4
-/*
- * REPLY_ADD_STA = 0x18 (response)
- */
-struct iwl3945_add_sta_resp {
-	u8 status;	/* ADD_STA_* */
-} __attribute__ ((packed));
-
 
 /******************************************************************************
  * (4)
@@ -566,26 +354,7 @@ struct iwl3945_rx_frame_hdr {
 	u8 payload[0];
 } __attribute__ ((packed));
 
-#define RX_RES_STATUS_NO_CRC32_ERROR	cpu_to_le32(1 << 0)
-#define RX_RES_STATUS_NO_RXE_OVERFLOW	cpu_to_le32(1 << 1)
 
-#define RX_RES_PHY_FLAGS_BAND_24_MSK	cpu_to_le16(1 << 0)
-#define RX_RES_PHY_FLAGS_MOD_CCK_MSK		cpu_to_le16(1 << 1)
-#define RX_RES_PHY_FLAGS_SHORT_PREAMBLE_MSK	cpu_to_le16(1 << 2)
-#define RX_RES_PHY_FLAGS_NARROW_BAND_MSK	cpu_to_le16(1 << 3)
-#define RX_RES_PHY_FLAGS_ANTENNA_MSK		cpu_to_le16(0xf0)
-
-#define RX_RES_STATUS_SEC_TYPE_MSK	(0x7 << 8)
-#define RX_RES_STATUS_SEC_TYPE_NONE	(0x0 << 8)
-#define RX_RES_STATUS_SEC_TYPE_WEP	(0x1 << 8)
-#define RX_RES_STATUS_SEC_TYPE_CCMP	(0x2 << 8)
-#define RX_RES_STATUS_SEC_TYPE_TKIP	(0x3 << 8)
-
-#define RX_RES_STATUS_DECRYPT_TYPE_MSK	(0x3 << 11)
-#define RX_RES_STATUS_NOT_DECRYPT	(0x0 << 11)
-#define RX_RES_STATUS_DECRYPT_OK	(0x3 << 11)
-#define RX_RES_STATUS_BAD_ICV_MIC	(0x1 << 11)
-#define RX_RES_STATUS_BAD_KEY_TTAK	(0x2 << 11)
 
 struct iwl3945_rx_frame_end {
 	__le32 status;
@@ -629,83 +398,6 @@ struct iwl3945_rx_frame {
  * This command must be executed after every RXON command, before Tx can occur.
  *****************************************************************************/
 
-/* REPLY_TX Tx flags field */
-
-/* 1: Use Request-To-Send protocol before this frame.
- * Mutually exclusive vs. TX_CMD_FLG_CTS_MSK. */
-#define TX_CMD_FLG_RTS_MSK cpu_to_le32(1 << 1)
-
-/* 1: Transmit Clear-To-Send to self before this frame.
- * Driver should set this for AUTH/DEAUTH/ASSOC-REQ/REASSOC mgmnt frames.
- * Mutually exclusive vs. TX_CMD_FLG_RTS_MSK. */
-#define TX_CMD_FLG_CTS_MSK cpu_to_le32(1 << 2)
-
-/* 1: Expect ACK from receiving station
- * 0: Don't expect ACK (MAC header's duration field s/b 0)
- * Set this for unicast frames, but not broadcast/multicast. */
-#define TX_CMD_FLG_ACK_MSK cpu_to_le32(1 << 3)
-
-/* 1: Use rate scale table (see REPLY_TX_LINK_QUALITY_CMD).
- *    Tx command's initial_rate_index indicates first rate to try;
- *    uCode walks through table for additional Tx attempts.
- * 0: Use Tx rate/MCS from Tx command's rate_n_flags field.
- *    This rate will be used for all Tx attempts; it will not be scaled. */
-#define TX_CMD_FLG_STA_RATE_MSK cpu_to_le32(1 << 4)
-
-/* 1: Expect immediate block-ack.
- * Set when Txing a block-ack request frame.  Also set TX_CMD_FLG_ACK_MSK. */
-#define TX_CMD_FLG_IMM_BA_RSP_MASK  cpu_to_le32(1 << 6)
-
-/* 1: Frame requires full Tx-Op protection.
- * Set this if either RTS or CTS Tx Flag gets set. */
-#define TX_CMD_FLG_FULL_TXOP_PROT_MSK cpu_to_le32(1 << 7)
-
-/* Tx antenna selection field; used only for 3945, reserved (0) for 4965.
- * Set field to "0" to allow 3945 uCode to select antenna (normal usage). */
-#define TX_CMD_FLG_ANT_SEL_MSK cpu_to_le32(0xf00)
-#define TX_CMD_FLG_ANT_A_MSK cpu_to_le32(1 << 8)
-#define TX_CMD_FLG_ANT_B_MSK cpu_to_le32(1 << 9)
-
-/* 1: Ignore Bluetooth priority for this frame.
- * 0: Delay Tx until Bluetooth device is done (normal usage). */
-#define TX_CMD_FLG_BT_DIS_MSK cpu_to_le32(1 << 12)
-
-/* 1: uCode overrides sequence control field in MAC header.
- * 0: Driver provides sequence control field in MAC header.
- * Set this for management frames, non-QOS data frames, non-unicast frames,
- * and also in Tx command embedded in REPLY_SCAN_CMD for active scans. */
-#define TX_CMD_FLG_SEQ_CTL_MSK cpu_to_le32(1 << 13)
-
-/* 1: This frame is non-last MPDU; more fragments are coming.
- * 0: Last fragment, or not using fragmentation. */
-#define TX_CMD_FLG_MORE_FRAG_MSK cpu_to_le32(1 << 14)
-
-/* 1: uCode calculates and inserts Timestamp Function (TSF) in outgoing frame.
- * 0: No TSF required in outgoing frame.
- * Set this for transmitting beacons and probe responses. */
-#define TX_CMD_FLG_TSF_MSK cpu_to_le32(1 << 16)
-
-/* 1: Driver inserted 2 bytes pad after the MAC header, for (required) dword
- *    alignment of frame's payload data field.
- * 0: No pad
- * Set this for MAC headers with 26 or 30 bytes, i.e. those with QOS or ADDR4
- * field (but not both).  Driver must align frame data (i.e. data following
- * MAC header) to DWORD boundary. */
-#define TX_CMD_FLG_MH_PAD_MSK cpu_to_le32(1 << 20)
-
-/* HCCA-AP - disable duration overwriting. */
-#define TX_CMD_FLG_DUR_MSK cpu_to_le32(1 << 25)
-
-/*
- * TX command security control
- */
-#define TX_CMD_SEC_WEP  	0x01
-#define TX_CMD_SEC_CCM  	0x02
-#define TX_CMD_SEC_TKIP		0x03
-#define TX_CMD_SEC_MSK		0x03
-#define TX_CMD_SEC_SHIFT	6
-#define TX_CMD_SEC_KEY128	0x08
-
 /*
  * REPLY_TX = 0x1c (command)
  */
@@ -819,59 +511,6 @@ struct iwl3945_rate_scaling_cmd {
 	struct iwl3945_rate_scaling_info table[IWL_MAX_RATES];
 } __attribute__ ((packed));
 
-/*
- * REPLY_BT_CONFIG = 0x9b (command, has simple generic response)
- *
- * 3945 and 4965 support hardware handshake with Bluetooth device on
- * same platform.  Bluetooth device alerts wireless device when it will Tx;
- * wireless device can delay or kill its own Tx to accommodate.
- */
-struct iwl3945_bt_cmd {
-	u8 flags;
-	u8 lead_time;
-	u8 max_kill;
-	u8 reserved;
-	__le32 kill_ack_mask;
-	__le32 kill_cts_mask;
-} __attribute__ ((packed));
-
-/******************************************************************************
- * (6)
- * Spectrum Management (802.11h) Commands, Responses, Notifications:
- *
- *****************************************************************************/
-
-/*
- * Spectrum Management
- */
-#define MEASUREMENT_FILTER_FLAG (RXON_FILTER_PROMISC_MSK         | \
-				 RXON_FILTER_CTL2HOST_MSK        | \
-				 RXON_FILTER_ACCEPT_GRP_MSK      | \
-				 RXON_FILTER_DIS_DECRYPT_MSK     | \
-				 RXON_FILTER_DIS_GRP_DECRYPT_MSK | \
-				 RXON_FILTER_ASSOC_MSK           | \
-				 RXON_FILTER_BCON_AWARE_MSK)
-
-struct iwl3945_measure_channel {
-	__le32 duration;	/* measurement duration in extended beacon
-				 * format */
-	u8 channel;		/* channel to measure */
-	u8 type;		/* see enum iwl3945_measure_type */
-	__le16 reserved;
-} __attribute__ ((packed));
-
-
-#define HW_CARD_DISABLED   0x01
-#define SW_CARD_DISABLED   0x02
-#define RF_CARD_DISABLED   0x04
-#define RXON_CARD_DISABLED 0x10
-
-struct iwl3945_ct_kill_config {
-	__le32   reserved;
-	__le32   critical_temperature_M;
-	__le32   critical_temperature_R;
-}  __attribute__ ((packed));
-
 /******************************************************************************
  * (8)
  * Scan Commands, Responses, Notifications:
@@ -912,24 +551,6 @@ struct iwl3945_scan_channel {
 	__le16 passive_dwell;	/* in 1024-uSec TU (time units), typ 20-500 */
 } __attribute__ ((packed));
 
-/**
- * struct iwl3945_ssid_ie - directed scan network information element
- *
- * Up to 4 of these may appear in REPLY_SCAN_CMD, selected by "type" field
- * in struct iwl3945_scan_channel; each channel may select different ssids from
- * among the 4 entries.  SSID IEs get transmitted in reverse order of entry.
- */
-struct iwl3945_ssid_ie {
-	u8 id;
-	u8 len;
-	u8 ssid[32];
-} __attribute__ ((packed));
-
-/* uCode API-1 take 4 probes */
-#define PROBE_OPTION_MAX_API1		0x4
-#define TX_CMD_LIFE_TIME_INFINITE	cpu_to_le32(0xFFFFFFFF)
-#define IWL_GOOD_CRC_TH		cpu_to_le16(1)
-#define IWL_MAX_SCAN_SIZE 1024
 
 /*
  * REPLY_SCAN_CMD = 0x80 (command)
@@ -1007,7 +628,7 @@ struct iwl3945_scan_cmd {
 	struct iwl3945_tx_cmd tx_cmd;
 
 	/* For directed active scans (set to all-0s otherwise) */
-	struct iwl3945_ssid_ie direct_scan[PROBE_OPTION_MAX_API1];
+	struct iwl_ssid_ie direct_scan[PROBE_OPTION_MAX_API1];
 
 	/*
 	 * Probe request frame, followed by channel list.
@@ -1027,60 +648,6 @@ struct iwl3945_scan_cmd {
 	u8 data[0];
 } __attribute__ ((packed));
 
-/* Can abort will notify by complete notification with abort status. */
-#define CAN_ABORT_STATUS	cpu_to_le32(0x1)
-/* complete notification statuses */
-#define ABORT_STATUS            0x2
-
-/*
- * REPLY_SCAN_CMD = 0x80 (response)
- */
-struct iwl3945_scanreq_notification {
-	__le32 status;		/* 1: okay, 2: cannot fulfill request */
-} __attribute__ ((packed));
-
-/*
- * SCAN_START_NOTIFICATION = 0x82 (notification only, not a command)
- */
-struct iwl3945_scanstart_notification {
-	__le32 tsf_low;
-	__le32 tsf_high;
-	__le32 beacon_timer;
-	u8 channel;
-	u8 band;
-	u8 reserved[2];
-	__le32 status;
-} __attribute__ ((packed));
-
-#define  SCAN_OWNER_STATUS 0x1;
-#define  MEASURE_OWNER_STATUS 0x2;
-
-#define NUMBER_OF_STATISTICS 1	/* first __le32 is good CRC */
-/*
- * SCAN_RESULTS_NOTIFICATION = 0x83 (notification only, not a command)
- */
-struct iwl3945_scanresults_notification {
-	u8 channel;
-	u8 band;
-	u8 reserved[2];
-	__le32 tsf_low;
-	__le32 tsf_high;
-	__le32 statistics[NUMBER_OF_STATISTICS];
-} __attribute__ ((packed));
-
-/*
- * SCAN_COMPLETE_NOTIFICATION = 0x84 (notification only, not a command)
- */
-struct iwl3945_scancomplete_notification {
-	u8 scanned_channels;
-	u8 status;
-	u8 reserved;
-	u8 last_channel;
-	__le32 tsf_low;
-	__le32 tsf_high;
-} __attribute__ ((packed));
-
-
 /******************************************************************************
  * (9)
  * IBSS/AP Commands and Notifications:
@@ -1179,27 +746,6 @@ struct iwl39_statistics_general {
 } __attribute__ ((packed));
 
 /*
- * REPLY_STATISTICS_CMD = 0x9c,
- * 3945 and 4965 identical.
- *
- * This command triggers an immediate response containing uCode statistics.
- * The response is in the same format as STATISTICS_NOTIFICATION 0x9d, below.
- *
- * If the CLEAR_STATS configuration flag is set, uCode will clear its
- * internal copy of the statistics (counters) after issuing the response.
- * This flag does not affect STATISTICS_NOTIFICATIONs after beacons (see below).
- *
- * If the DISABLE_NOTIF configuration flag is set, uCode will not issue
- * STATISTICS_NOTIFICATIONs after received beacons (see below).  This flag
- * does not affect the response to the REPLY_STATISTICS_CMD 0x9c itself.
- */
-#define IWL_STATS_CONF_CLEAR_STATS cpu_to_le32(0x1)	/* see above */
-#define IWL_STATS_CONF_DISABLE_NOTIF cpu_to_le32(0x2)/* see above */
-struct iwl3945_statistics_cmd {
-	__le32 configuration_flags;	/* IWL_STATS_CONF_* */
-} __attribute__ ((packed));
-
-/*
  * STATISTICS_NOTIFICATION = 0x9d (notification only, not a command)
  *
  * By default, uCode issues this notification after receiving a beacon
@@ -1214,8 +760,6 @@ struct iwl3945_statistics_cmd {
  * appropriately so that each notification contains statistics for only the
  * one channel that has just been scanned.
  */
-#define STATISTICS_REPLY_FLG_BAND_24G_MSK         cpu_to_le32(0x2)
-#define STATISTICS_REPLY_FLG_FAT_MODE_MSK         cpu_to_le32(0x8)
 struct iwl3945_notif_statistics {
 	__le32 flag;
 	struct statistics_rx rx;
@@ -1224,67 +768,6 @@ struct iwl3945_notif_statistics {
 } __attribute__ ((packed));
 
 
-/*
- * MISSED_BEACONS_NOTIFICATION = 0xa2 (notification only, not a command)
- */
-/* if ucode missed CONSECUTIVE_MISSED_BCONS_TH beacons in a row,
- * then this notification will be sent. */
-#define CONSECUTIVE_MISSED_BCONS_TH 20
-
-struct iwl3945_missed_beacon_notif {
-	__le32 consequtive_missed_beacons;
-	__le32 total_missed_becons;
-	__le32 num_expected_beacons;
-	__le32 num_recvd_beacons;
-} __attribute__ ((packed));
-
-/******************************************************************************
- * (11)
- * Rx Calibration Commands:
- *
- *****************************************************************************/
-
-#define PHY_CALIBRATE_DIFF_GAIN_CMD (7)
-#define HD_TABLE_SIZE  (11)
-
-struct iwl3945_sensitivity_cmd {
-	__le16 control;
-	__le16 table[HD_TABLE_SIZE];
-} __attribute__ ((packed));
-
-struct iwl3945_calibration_cmd {
-	u8 opCode;
-	u8 flags;
-	__le16 reserved;
-	s8 diff_gain_a;
-	s8 diff_gain_b;
-	s8 diff_gain_c;
-	u8 reserved1;
-} __attribute__ ((packed));
-
-/******************************************************************************
- * (12)
- * Miscellaneous Commands:
- *
- *****************************************************************************/
-
-/*
- * LEDs Command & Response
- * REPLY_LEDS_CMD = 0x48 (command, has simple generic response)
- *
- * For each of 3 possible LEDs (Activity/Link/Tech, selected by "id" field),
- * this command turns it on or off, or sets up a periodic blinking cycle.
- */
-struct iwl3945_led_cmd {
-	__le32 interval;	/* "interval" in uSec */
-	u8 id;			/* 1: Activity, 2: Link, 3: Tech */
-	u8 off;			/* # intervals off while blinking;
-				 * "0", with >0 "on" value, turns LED on */
-	u8 on;			/* # intervals on while blinking;
-				 * "0", regardless of "off", turns LED off */
-	u8 reserved;
-} __attribute__ ((packed));
-
 /******************************************************************************
  * (13)
  * Union of all expected notifications/responses:
@@ -1293,7 +776,7 @@ struct iwl3945_led_cmd {
 
 struct iwl3945_rx_packet {
 	__le32 len;
-	struct iwl3945_cmd_header hdr;
+	struct iwl_cmd_header hdr;
 	union {
 		struct iwl3945_alive_resp alive_frame;
 		struct iwl3945_rx_frame rx_frame;
@@ -1303,7 +786,7 @@ struct iwl3945_rx_packet {
 		struct iwl3945_error_resp err_resp;
 		struct iwl_card_state_notif card_state_notif;
 		struct iwl3945_beacon_notif beacon_status;
-		struct iwl3945_add_sta_resp add_sta;
+		struct iwl_add_sta_resp add_sta;
 		struct iwl_sleep_notification sleep_notif;
 		struct iwl_spectrum_resp spectrum;
 		struct iwl3945_notif_statistics stats;
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-led.c b/drivers/net/wireless/iwlwifi/iwl-3945-led.c
index 525e90b..b34bef4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-led.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-led.c
@@ -82,11 +82,11 @@ static inline int iwl3945_brightness_to_idx(enum led_brightness brightness)
 
 /* Send led command */
 static int iwl_send_led_cmd(struct iwl3945_priv *priv,
-			    struct iwl3945_led_cmd *led_cmd)
+			    struct iwl_led_cmd *led_cmd)
 {
 	struct iwl3945_host_cmd cmd = {
 		.id = REPLY_LEDS_CMD,
-		.len = sizeof(struct iwl3945_led_cmd),
+		.len = sizeof(struct iwl_led_cmd),
 		.data = led_cmd,
 		.meta.flags = CMD_ASYNC,
 		.meta.u.callback = iwl3945_led_cmd_callback,
@@ -101,7 +101,7 @@ static int iwl_send_led_cmd(struct iwl3945_priv *priv,
 static int iwl3945_led_pattern(struct iwl3945_priv *priv, int led_id,
 			       unsigned int idx)
 {
-	struct iwl3945_led_cmd led_cmd = {
+	struct iwl_led_cmd led_cmd = {
 		.id = led_id,
 		.interval = IWL_DEF_LED_INTRVL
 	};
@@ -115,11 +115,10 @@ static int iwl3945_led_pattern(struct iwl3945_priv *priv, int led_id,
 }
 
 
-#if 1
 /* Set led on command */
 static int iwl3945_led_on(struct iwl3945_priv *priv, int led_id)
 {
-	struct iwl3945_led_cmd led_cmd = {
+	struct iwl_led_cmd led_cmd = {
 		.id = led_id,
 		.on = IWL_LED_SOLID,
 		.off = 0,
@@ -131,7 +130,7 @@ static int iwl3945_led_on(struct iwl3945_priv *priv, int led_id)
 /* Set led off command */
 static int iwl3945_led_off(struct iwl3945_priv *priv, int led_id)
 {
-	struct iwl3945_led_cmd led_cmd = {
+	struct iwl_led_cmd led_cmd = {
 		.id = led_id,
 		.on = 0,
 		.off = 0,
@@ -140,8 +139,6 @@ static int iwl3945_led_off(struct iwl3945_priv *priv, int led_id)
 	IWL_DEBUG_LED("led off %d\n", led_id);
 	return iwl_send_led_cmd(priv, &led_cmd);
 }
-#endif
-
 
 /*
  * brightness call back function for Tx/Rx LED
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index 0010932..1c9e126 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -328,18 +328,18 @@ struct iwl3945_cmd_meta {
  */
 struct iwl3945_cmd {
 	struct iwl3945_cmd_meta meta;
-	struct iwl3945_cmd_header hdr;
+	struct iwl_cmd_header hdr;
 	union {
 		struct iwl3945_addsta_cmd addsta;
-		struct iwl3945_led_cmd led;
+		struct iwl_led_cmd led;
 		u32 flags;
 		u8 val8;
 		u16 val16;
 		u32 val32;
-		struct iwl3945_bt_cmd bt;
+		struct iwl_bt_cmd bt;
 		struct iwl3945_rxon_time_cmd rxon_time;
 		struct iwl_powertable_cmd powertable;
-		struct iwl3945_qosparam_cmd qosparam;
+		struct iwl_qosparam_cmd qosparam;
 		struct iwl3945_tx_cmd tx;
 		struct iwl3945_tx_beacon_cmd tx_beacon;
 		struct iwl3945_rxon_assoc_cmd rxon_assoc;
@@ -466,7 +466,7 @@ union iwl3945_qos_capabity {
 struct iwl3945_qos_info {
 	int qos_active;
 	union iwl3945_qos_capabity qos_cap;
-	struct iwl3945_qosparam_cmd def_qos_parm;
+	struct iwl_qosparam_cmd def_qos_parm;
 };
 
 #define STA_PS_STATUS_WAKE             0
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 9cfdd1c..53796b4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -75,6 +75,12 @@
 #define IWL_UCODE_API(ver)	(((ver) & 0x0000FF00) >> 8)
 #define IWL_UCODE_SERIAL(ver)	((ver) & 0x000000FF)
 
+
+/* Tx rates */
+#define IWL_CCK_RATES	4
+#define IWL_OFDM_RATES	8
+#define IWL_MAX_RATES	(IWL_CCK_RATES + IWL_OFDM_RATES)
+
 enum {
 	REPLY_ALIVE = 0x1,
 	REPLY_ERROR = 0x2,
@@ -784,6 +790,8 @@ struct iwl_qosparam_cmd {
 #define	IWL_AP_ID		0
 #define IWL_MULTICAST_ID	1
 #define	IWL_STA_ID		2
+#define	IWL3945_BROADCAST_ID	24
+#define IWL3945_STATION_COUNT	25
 #define IWL4965_BROADCAST_ID	31
 #define	IWL4965_STATION_COUNT	32
 #define IWL5000_BROADCAST_ID	15
@@ -792,6 +800,8 @@ struct iwl_qosparam_cmd {
 #define	IWL_STATION_COUNT	32 	/* MAX(3945,4965)*/
 #define	IWL_INVALID_STATION 	255
 
+#define STA_FLG_TX_RATE_MSK		cpu_to_le32(1 << 2);
+#define STA_FLG_PWR_SAVE_MSK		cpu_to_le32(1 << 8);
 #define STA_FLG_PWR_SAVE_MSK		cpu_to_le32(1 << 8);
 #define STA_FLG_RTS_MIMO_PROT_MSK	cpu_to_le32(1 << 17)
 #define STA_FLG_AGG_MPDU_8US_MSK	cpu_to_le32(1 << 18)
@@ -2181,6 +2191,7 @@ struct iwl_ssid_ie {
 	u8 ssid[32];
 } __attribute__ ((packed));
 
+#define PROBE_OPTION_MAX_API1		0x4
 #define PROBE_OPTION_MAX        	0x14
 #define TX_CMD_LIFE_TIME_INFINITE	cpu_to_le32(0xFFFFFFFF)
 #define IWL_GOOD_CRC_TH			cpu_to_le16(1)
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index e6ed571..0764f37 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -1141,7 +1141,7 @@ static int iwl3945_commit_rxon(struct iwl3945_priv *priv)
 
 static int iwl3945_send_bt_config(struct iwl3945_priv *priv)
 {
-	struct iwl3945_bt_cmd bt_cmd = {
+	struct iwl_bt_cmd bt_cmd = {
 		.flags = 3,
 		.lead_time = 0xAA,
 		.max_kill = 1,
@@ -1150,7 +1150,7 @@ static int iwl3945_send_bt_config(struct iwl3945_priv *priv)
 	};
 
 	return iwl3945_send_cmd_pdu(priv, REPLY_BT_CONFIG,
-				sizeof(struct iwl3945_bt_cmd), &bt_cmd);
+					sizeof(bt_cmd), &bt_cmd);
 }
 
 static int iwl3945_send_scan_abort(struct iwl3945_priv *priv)
@@ -1345,7 +1345,8 @@ static int iwl3945_clear_sta_key_info(struct iwl3945_priv *priv, u8 sta_id)
 
 	spin_lock_irqsave(&priv->sta_lock, flags);
 	memset(&priv->stations[sta_id].keyinfo, 0, sizeof(struct iwl3945_hw_key));
-	memset(&priv->stations[sta_id].sta.key, 0, sizeof(struct iwl3945_keyinfo));
+	memset(&priv->stations[sta_id].sta.key, 0,
+		sizeof(struct iwl4965_keyinfo));
 	priv->stations[sta_id].sta.key.key_flags = STA_KEY_FLG_NO_ENC;
 	priv->stations[sta_id].sta.sta.modify_mask = STA_MODIFY_KEY_MASK;
 	priv->stations[sta_id].sta.mode = STA_CONTROL_MODIFY_MSK;
@@ -1674,11 +1675,11 @@ static u16 iwl3945_fill_probe_req(struct iwl3945_priv *priv,
  * QoS  support
 */
 static int iwl3945_send_qos_params_command(struct iwl3945_priv *priv,
-				       struct iwl3945_qosparam_cmd *qos)
+				       struct iwl_qosparam_cmd *qos)
 {
 
 	return iwl3945_send_cmd_pdu(priv, REPLY_QOS_PARAM,
-				sizeof(struct iwl3945_qosparam_cmd), qos);
+				sizeof(struct iwl_qosparam_cmd), qos);
 }
 
 static void iwl3945_reset_qos(struct iwl3945_priv *priv)
@@ -2587,7 +2588,7 @@ static int iwl3945_tx_skb(struct iwl3945_priv *priv, struct sk_buff *skb)
 	 * We'll tell device about this padding later.
 	 */
 	len = priv->hw_setting.tx_cmd_len +
-		sizeof(struct iwl3945_cmd_header) + hdr_len;
+			sizeof(struct iwl_cmd_header) + hdr_len;
 
 	len_org = len;
 	len = (len + 3) & ~3;
@@ -3116,8 +3117,8 @@ static void iwl3945_rx_reply_scan(struct iwl3945_priv *priv,
 {
 #ifdef CONFIG_IWL3945_DEBUG
 	struct iwl3945_rx_packet *pkt = (void *)rxb->skb->data;
-	struct iwl3945_scanreq_notification *notif =
-	    (struct iwl3945_scanreq_notification *)pkt->u.raw;
+	struct iwl_scanreq_notification *notif =
+	    (struct iwl_scanreq_notification *)pkt->u.raw;
 
 	IWL_DEBUG_RX("Scan request status = 0x%x\n", notif->status);
 #endif
@@ -3128,8 +3129,8 @@ static void iwl3945_rx_scan_start_notif(struct iwl3945_priv *priv,
 				    struct iwl3945_rx_mem_buffer *rxb)
 {
 	struct iwl3945_rx_packet *pkt = (void *)rxb->skb->data;
-	struct iwl3945_scanstart_notification *notif =
-	    (struct iwl3945_scanstart_notification *)pkt->u.raw;
+	struct iwl_scanstart_notification *notif =
+	    (struct iwl_scanstart_notification *)pkt->u.raw;
 	priv->scan_start_tsf = le32_to_cpu(notif->tsf_low);
 	IWL_DEBUG_SCAN("Scan start: "
 		       "%d [802.11%s] "
@@ -3145,8 +3146,8 @@ static void iwl3945_rx_scan_results_notif(struct iwl3945_priv *priv,
 				      struct iwl3945_rx_mem_buffer *rxb)
 {
 	struct iwl3945_rx_packet *pkt = (void *)rxb->skb->data;
-	struct iwl3945_scanresults_notification *notif =
-	    (struct iwl3945_scanresults_notification *)pkt->u.raw;
+	struct iwl_scanresults_notification *notif =
+	    (struct iwl_scanresults_notification *)pkt->u.raw;
 
 	IWL_DEBUG_SCAN("Scan ch.res: "
 		       "%d [802.11%s] "
@@ -3170,7 +3171,7 @@ static void iwl3945_rx_scan_complete_notif(struct iwl3945_priv *priv,
 				       struct iwl3945_rx_mem_buffer *rxb)
 {
 	struct iwl3945_rx_packet *pkt = (void *)rxb->skb->data;
-	struct iwl3945_scancomplete_notification *scan_notif = (void *)pkt->u.raw;
+	struct iwl_scancomplete_notification *scan_notif = (void *)pkt->u.raw;
 
 	IWL_DEBUG_SCAN("Scan complete: %d channels (TSF 0x%08X:%08X) - %d\n",
 		       scan_notif->scanned_channels,
-- 
1.5.3.6

