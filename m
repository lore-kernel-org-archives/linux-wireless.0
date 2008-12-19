Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:54843 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752548AbYLSCpC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2008 21:45:02 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Tomas Winkler <tomas.winkler@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 07/43] iwlwifi: 3945 remove iwl-3945-commands.h
Date: Fri, 19 Dec 2008 10:37:07 +0800
Message-Id: <1229654263-21454-8-git-send-email-yi.zhu@intel.com> (sfid-20081219_034519_417492_4F625598)
In-Reply-To: <1229654263-21454-7-git-send-email-yi.zhu@intel.com>
References: <1229654263-21454-1-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-2-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-3-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-4-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-5-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-6-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-7-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch remove iwl-3945-commands.h
eliminating duplicated and moving all definitions to iwl-commands.h

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Acked-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945-commands.h |  769 ----------------------
 drivers/net/wireless/iwlwifi/iwl-3945-led.c      |    1 -
 drivers/net/wireless/iwlwifi/iwl-3945-rs.c       |    1 -
 drivers/net/wireless/iwlwifi/iwl-3945.c          |   15 +-
 drivers/net/wireless/iwlwifi/iwl-3945.h          |    5 +-
 drivers/net/wireless/iwlwifi/iwl-commands.h      |  448 ++++++++++++-
 drivers/net/wireless/iwlwifi/iwl3945-base.c      |   64 +-
 7 files changed, 468 insertions(+), 835 deletions(-)
 delete mode 100644 drivers/net/wireless/iwlwifi/iwl-3945-commands.h

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-commands.h b/drivers/net/wireless/iwlwifi/iwl-3945-commands.h
deleted file mode 100644
index 42ef51f..0000000
--- a/drivers/net/wireless/iwlwifi/iwl-3945-commands.h
+++ /dev/null
@@ -1,769 +0,0 @@
-/******************************************************************************
- *
- * This file is provided under a dual BSD/GPLv2 license.  When using or
- * redistributing this file, you may do so under either license.
- *
- * GPL LICENSE SUMMARY
- *
- * Copyright(c) 2005 - 2008 Intel Corporation. All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of version 2 of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
- * USA
- *
- * The full GNU General Public License is included in this distribution
- * in the file called LICENSE.GPL.
- *
- * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
- * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
- *
- * BSD LICENSE
- *
- * Copyright(c) 2005 - 2008 Intel Corporation. All rights reserved.
- * All rights reserved.
- *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions
- * are met:
- *
- *  * Redistributions of source code must retain the above copyright
- *    notice, this list of conditions and the following disclaimer.
- *  * Redistributions in binary form must reproduce the above copyright
- *    notice, this list of conditions and the following disclaimer in
- *    the documentation and/or other materials provided with the
- *    distribution.
- *  * Neither the name Intel Corporation nor the names of its
- *    contributors may be used to endorse or promote products derived
- *    from this software without specific prior written permission.
- *
- * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
- * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
- * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
- * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
- * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
- * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
- * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
- * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
- * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
- * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
- * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
- *
- *****************************************************************************/
-/*
- * Please use this file (iwl-3945-commands.h) only for uCode API definitions.
- * Please use iwl-3945-hw.h for hardware-related definitions.
- * Please use iwl-3945.h for driver implementation definitions.
- */
-
-#ifndef __iwl_3945_commands_h__
-#define __iwl_3945_commands_h__
-
-/******************************************************************************
- * (0)
- * Commonly used structures and definitions:
- * Command header, txpower
- *
- *****************************************************************************/
-/**
- * struct iwl3945_tx_power
- *
- * Used in REPLY_TX_PWR_TABLE_CMD, REPLY_SCAN_CMD, REPLY_CHANNEL_SWITCH
- *
- * Each entry contains two values:
- * 1)  DSP gain (or sometimes called DSP attenuation).  This is a fine-grained
- *     linear value that multiplies the output of the digital signal processor,
- *     before being sent to the analog radio.
- * 2)  Radio gain.  This sets the analog gain of the radio Tx path.
- *     It is a coarser setting, and behaves in a logarithmic (dB) fashion.
- *
- * Driver obtains values from struct iwl3945_tx_power power_gain_table[][].
- */
-struct iwl3945_tx_power {
-	u8 tx_gain;		/* gain for analog radio */
-	u8 dsp_atten;		/* gain for DSP */
-} __attribute__ ((packed));
-
-/**
- * struct iwl3945_power_per_rate
- *
- * Used in REPLY_TX_PWR_TABLE_CMD, REPLY_CHANNEL_SWITCH
- */
-struct iwl3945_power_per_rate {
-	u8 rate;		/* plcp */
-	struct iwl3945_tx_power tpc;
-	u8 reserved;
-} __attribute__ ((packed));
-
-/******************************************************************************
- * (0a)
- * Alive and Error Commands & Responses:
- *
- *****************************************************************************/
-
-
-/*
- * ("Initialize") REPLY_ALIVE = 0x1 (response only, not a command)
- *
- * uCode issues this "initialize alive" notification once the initialization
- * uCode image has completed its work, and is ready to load the runtime image.
- * This is the *first* "alive" notification that the driver will receive after
- * rebooting uCode; the "initialize" alive is indicated by subtype field == 9.
- *
- * See comments documenting "BSM" (bootstrap state machine).
- */
-struct iwl3945_init_alive_resp {
-	u8 ucode_minor;
-	u8 ucode_major;
-	__le16 reserved1;
-	u8 sw_rev[8];
-	u8 ver_type;
-	u8 ver_subtype;			/* "9" for initialize alive */
-	__le16 reserved2;
-	__le32 log_event_table_ptr;
-	__le32 error_event_table_ptr;
-	__le32 timestamp;
-	__le32 is_valid;
-} __attribute__ ((packed));
-
-
-/**
- * REPLY_ALIVE = 0x1 (response only, not a command)
- *
- * uCode issues this "alive" notification once the runtime image is ready
- * to receive commands from the driver.  This is the *second* "alive"
- * notification that the driver will receive after rebooting uCode;
- * this "alive" is indicated by subtype field != 9.
- *
- * See comments documenting "BSM" (bootstrap state machine).
- *
- * This response includes two pointers to structures within the device's
- * data SRAM (access via HBUS_TARG_MEM_* regs) that are useful for debugging:
- *
- * 1)  log_event_table_ptr indicates base of the event log.  This traces
- *     a 256-entry history of uCode execution within a circular buffer.
- *
- * 2)  error_event_table_ptr indicates base of the error log.  This contains
- *     information about any uCode error that occurs.
- *
- * The Linux driver can print both logs to the system log when a uCode error
- * occurs.
- */
-struct iwl3945_alive_resp {
-	u8 ucode_minor;
-	u8 ucode_major;
-	__le16 reserved1;
-	u8 sw_rev[8];
-	u8 ver_type;
-	u8 ver_subtype;			/* not "9" for runtime alive */
-	__le16 reserved2;
-	__le32 log_event_table_ptr;	/* SRAM address for event log */
-	__le32 error_event_table_ptr;	/* SRAM address for error log */
-	__le32 timestamp;
-	__le32 is_valid;
-} __attribute__ ((packed));
-
-/******************************************************************************
- * (1)
- * RXON Commands & Responses:
- *
- *****************************************************************************/
-
-/**
- * REPLY_RXON = 0x10 (command, has simple generic response)
- *
- * RXON tunes the radio tuner to a service channel, and sets up a number
- * of parameters that are used primarily for Rx, but also for Tx operations.
- *
- * NOTE:  When tuning to a new channel, driver must set the
- *        RXON_FILTER_ASSOC_MSK to 0.  This will clear station-dependent
- *        info within the device, including the station tables, tx retry
- *        rate tables, and txpower tables.  Driver must build a new station
- *        table and txpower table before transmitting anything on the RXON
- *        channel.
- *
- * NOTE:  All RXONs wipe clean the internal txpower table.  Driver must
- *        issue a new REPLY_TX_PWR_TABLE_CMD after each REPLY_RXON (0x10),
- *        regardless of whether RXON_FILTER_ASSOC_MSK is set.
- */
-struct iwl3945_rxon_cmd {
-	u8 node_addr[6];
-	__le16 reserved1;
-	u8 bssid_addr[6];
-	__le16 reserved2;
-	u8 wlap_bssid_addr[6];
-	__le16 reserved3;
-	u8 dev_type;
-	u8 air_propagation;
-	__le16 reserved4;
-	u8 ofdm_basic_rates;
-	u8 cck_basic_rates;
-	__le16 assoc_id;
-	__le32 flags;
-	__le32 filter_flags;
-	__le16 channel;
-	__le16 reserved5;
-} __attribute__ ((packed));
-
-/*
- * REPLY_RXON_ASSOC = 0x11 (command, has simple generic response)
- */
-struct iwl3945_rxon_assoc_cmd {
-	__le32 flags;
-	__le32 filter_flags;
-	u8 ofdm_basic_rates;
-	u8 cck_basic_rates;
-	__le16 reserved;
-} __attribute__ ((packed));
-
-/*
- * REPLY_CHANNEL_SWITCH = 0x72 (command, has simple generic response)
- */
-struct iwl3945_channel_switch_cmd {
-	u8 band;
-	u8 expect_beacon;
-	__le16 channel;
-	__le32 rxon_flags;
-	__le32 rxon_filter_flags;
-	__le32 switch_time;
-	struct iwl3945_power_per_rate power[IWL_MAX_RATES];
-} __attribute__ ((packed));
-
-/******************************************************************************
- * (3)
- * Add/Modify Stations Commands & Responses:
- *
- *****************************************************************************/
-/*
- * REPLY_ADD_STA = 0x18 (command)
- *
- * The device contains an internal table of per-station information,
- * with info on security keys, aggregation parameters, and Tx rates for
- * initial Tx attempt and any retries (4965 uses REPLY_TX_LINK_QUALITY_CMD,
- * 3945 uses REPLY_RATE_SCALE to set up rate tables).
- *
- * REPLY_ADD_STA sets up the table entry for one station, either creating
- * a new entry, or modifying a pre-existing one.
- *
- * NOTE:  RXON command (without "associated" bit set) wipes the station table
- *        clean.  Moving into RF_KILL state does this also.  Driver must set up
- *        new station table before transmitting anything on the RXON channel
- *        (except active scans or active measurements; those commands carry
- *        their own txpower/rate setup data).
- *
- *        When getting started on a new channel, driver must set up the
- *        IWL_BROADCAST_ID entry (last entry in the table).  For a client
- *        station in a BSS, once an AP is selected, driver sets up the AP STA
- *        in the IWL_AP_ID entry (1st entry in the table).  BROADCAST and AP
- *        are all that are needed for a BSS client station.  If the device is
- *        used as AP, or in an IBSS network, driver must set up station table
- *        entries for all STAs in network, starting with index IWL_STA_ID.
- */
-struct iwl3945_addsta_cmd {
-	u8 mode;		/* 1: modify existing, 0: add new station */
-	u8 reserved[3];
-	struct sta_id_modify sta;
-	struct iwl4965_keyinfo key;
-	__le32 station_flags;		/* STA_FLG_* */
-	__le32 station_flags_msk;	/* STA_FLG_* */
-
-	/* bit field to disable (1) or enable (0) Tx for Traffic ID (TID)
-	 * corresponding to bit (e.g. bit 5 controls TID 5).
-	 * Set modify_mask bit STA_MODIFY_TID_DISABLE_TX to use this field. */
-	__le16 tid_disable_tx;
-
-	__le16 rate_n_flags;
-
-	/* TID for which to add block-ack support.
-	 * Set modify_mask bit STA_MODIFY_ADDBA_TID_MSK to use this field. */
-	u8 add_immediate_ba_tid;
-
-	/* TID for which to remove block-ack support.
-	 * Set modify_mask bit STA_MODIFY_DELBA_TID_MSK to use this field. */
-	u8 remove_immediate_ba_tid;
-
-	/* Starting Sequence Number for added block-ack support.
-	 * Set modify_mask bit STA_MODIFY_ADDBA_TID_MSK to use this field. */
-	__le16 add_immediate_ba_ssn;
-} __attribute__ ((packed));
-
-
-/******************************************************************************
- * (4)
- * Rx Responses:
- *
- *****************************************************************************/
-
-struct iwl3945_rx_frame_stats {
-	u8 phy_count;
-	u8 id;
-	u8 rssi;
-	u8 agc;
-	__le16 sig_avg;
-	__le16 noise_diff;
-	u8 payload[0];
-} __attribute__ ((packed));
-
-struct iwl3945_rx_frame_hdr {
-	__le16 channel;
-	__le16 phy_flags;
-	u8 reserved1;
-	u8 rate;
-	__le16 len;
-	u8 payload[0];
-} __attribute__ ((packed));
-
-
-
-struct iwl3945_rx_frame_end {
-	__le32 status;
-	__le64 timestamp;
-	__le32 beacon_timestamp;
-} __attribute__ ((packed));
-
-/*
- * REPLY_3945_RX = 0x1b (response only, not a command)
- *
- * NOTE:  DO NOT dereference from casts to this structure
- * It is provided only for calculating minimum data set size.
- * The actual offsets of the hdr and end are dynamic based on
- * stats.phy_count
- */
-struct iwl3945_rx_frame {
-	struct iwl3945_rx_frame_stats stats;
-	struct iwl3945_rx_frame_hdr hdr;
-	struct iwl3945_rx_frame_end end;
-} __attribute__ ((packed));
-
-/******************************************************************************
- * (5)
- * Tx Commands & Responses:
- *
- * Driver must place each REPLY_TX command into one of the prioritized Tx
- * queues in host DRAM, shared between driver and device.  When the device's
- * Tx scheduler and uCode are preparing to transmit, the device pulls the
- * Tx command over the PCI bus via one of the device's Tx DMA channels,
- * to fill an internal FIFO from which data will be transmitted.
- *
- * uCode handles all timing and protocol related to control frames
- * (RTS/CTS/ACK), based on flags in the Tx command.
- *
- * uCode handles retrying Tx when an ACK is expected but not received.
- * This includes trying lower data rates than the one requested in the Tx
- * command, as set up by the REPLY_RATE_SCALE (for 3945) or
- * REPLY_TX_LINK_QUALITY_CMD (4965).
- *
- * Driver sets up transmit power for various rates via REPLY_TX_PWR_TABLE_CMD.
- * This command must be executed after every RXON command, before Tx can occur.
- *****************************************************************************/
-
-/*
- * REPLY_TX = 0x1c (command)
- */
-struct iwl3945_tx_cmd {
-	/*
-	 * MPDU byte count:
-	 * MAC header (24/26/30/32 bytes) + 2 bytes pad if 26/30 header size,
-	 * + 8 byte IV for CCM or TKIP (not used for WEP)
-	 * + Data payload
-	 * + 8-byte MIC (not used for CCM/WEP)
-	 * NOTE:  Does not include Tx command bytes, post-MAC pad bytes,
-	 *        MIC (CCM) 8 bytes, ICV (WEP/TKIP/CKIP) 4 bytes, CRC 4 bytes.i
-	 * Range: 14-2342 bytes.
-	 */
-	__le16 len;
-
-	/*
-	 * MPDU or MSDU byte count for next frame.
-	 * Used for fragmentation and bursting, but not 11n aggregation.
-	 * Same as "len", but for next frame.  Set to 0 if not applicable.
-	 */
-	__le16 next_frame_len;
-
-	__le32 tx_flags;	/* TX_CMD_FLG_* */
-
-	u8 rate;
-
-	/* Index of recipient station in uCode's station table */
-	u8 sta_id;
-	u8 tid_tspec;
-	u8 sec_ctl;
-	u8 key[16];
-	union {
-		u8 byte[8];
-		__le16 word[4];
-		__le32 dw[2];
-	} tkip_mic;
-	__le32 next_frame_info;
-	union {
-		__le32 life_time;
-		__le32 attempt;
-	} stop_time;
-	u8 supp_rates[2];
-	u8 rts_retry_limit;	/*byte 50 */
-	u8 data_retry_limit;	/*byte 51 */
-	union {
-		__le16 pm_frame_timeout;
-		__le16 attempt_duration;
-	} timeout;
-
-	/*
-	 * Duration of EDCA burst Tx Opportunity, in 32-usec units.
-	 * Set this if txop time is not specified by HCCA protocol (e.g. by AP).
-	 */
-	__le16 driver_txop;
-
-	/*
-	 * MAC header goes here, followed by 2 bytes padding if MAC header
-	 * length is 26 or 30 bytes, followed by payload data
-	 */
-	u8 payload[0];
-	struct ieee80211_hdr hdr[0];
-} __attribute__ ((packed));
-
-/*
- * REPLY_TX = 0x1c (response)
- */
-struct iwl3945_tx_resp {
-	u8 failure_rts;
-	u8 failure_frame;
-	u8 bt_kill_count;
-	u8 rate;
-	__le32 wireless_media_time;
-	__le32 status;		/* TX status */
-} __attribute__ ((packed));
-
-/*
- * REPLY_TX_PWR_TABLE_CMD = 0x97 (command, has simple generic response)
- */
-struct iwl3945_txpowertable_cmd {
-	u8 band;		/* 0: 5 GHz, 1: 2.4 GHz */
-	u8 reserved;
-	__le16 channel;
-	struct iwl3945_power_per_rate power[IWL_MAX_RATES];
-} __attribute__ ((packed));
-
-struct iwl3945_rate_scaling_info {
-	__le16 rate_n_flags;
-	u8 try_cnt;
-	u8 next_rate_index;
-} __attribute__ ((packed));
-
-/**
- * struct iwl3945_rate_scaling_cmd - Rate Scaling Command & Response
- *
- * REPLY_RATE_SCALE = 0x47 (command, has simple generic response)
- *
- * NOTE: The table of rates passed to the uCode via the
- * RATE_SCALE command sets up the corresponding order of
- * rates used for all related commands, including rate
- * masks, etc.
- *
- * For example, if you set 9MB (PLCP 0x0f) as the first
- * rate in the rate table, the bit mask for that rate
- * when passed through ofdm_basic_rates on the REPLY_RXON
- * command would be bit 0 (1 << 0)
- */
-struct iwl3945_rate_scaling_cmd {
-	u8 table_id;
-	u8 reserved[3];
-	struct iwl3945_rate_scaling_info table[IWL_MAX_RATES];
-} __attribute__ ((packed));
-
-/******************************************************************************
- * (8)
- * Scan Commands, Responses, Notifications:
- *
- *****************************************************************************/
-
-/**
- * struct iwl3945_scan_channel - entry in REPLY_SCAN_CMD channel table
- *
- * One for each channel in the scan list.
- * Each channel can independently select:
- * 1)  SSID for directed active scans
- * 2)  Txpower setting (for rate specified within Tx command)
- * 3)  How long to stay on-channel (behavior may be modified by quiet_time,
- *     quiet_plcp_th, good_CRC_th)
- *
- * To avoid uCode errors, make sure the following are true (see comments
- * under struct iwl3945_scan_cmd about max_out_time and quiet_time):
- * 1)  If using passive_dwell (i.e. passive_dwell != 0):
- *     active_dwell <= passive_dwell (< max_out_time if max_out_time != 0)
- * 2)  quiet_time <= active_dwell
- * 3)  If restricting off-channel time (i.e. max_out_time !=0):
- *     passive_dwell < max_out_time
- *     active_dwell < max_out_time
- */
-struct iwl3945_scan_channel {
-	/*
-	 * type is defined as:
-	 * 0:0 1 = active, 0 = passive
-	 * 1:4 SSID direct bit map; if a bit is set, then corresponding
-	 *     SSID IE is transmitted in probe request.
-	 * 5:7 reserved
-	 */
-	u8 type;
-	u8 channel;	/* band is selected by iwl3945_scan_cmd "flags" field */
-	struct iwl3945_tx_power tpc;
-	__le16 active_dwell;	/* in 1024-uSec TU (time units), typ 5-50 */
-	__le16 passive_dwell;	/* in 1024-uSec TU (time units), typ 20-500 */
-} __attribute__ ((packed));
-
-
-/*
- * REPLY_SCAN_CMD = 0x80 (command)
- *
- * The hardware scan command is very powerful; the driver can set it up to
- * maintain (relatively) normal network traffic while doing a scan in the
- * background.  The max_out_time and suspend_time control the ratio of how
- * long the device stays on an associated network channel ("service channel")
- * vs. how long it's away from the service channel, tuned to other channels
- * for scanning.
- *
- * max_out_time is the max time off-channel (in usec), and suspend_time
- * is how long (in "extended beacon" format) that the scan is "suspended"
- * after returning to the service channel.  That is, suspend_time is the
- * time that we stay on the service channel, doing normal work, between
- * scan segments.  The driver may set these parameters differently to support
- * scanning when associated vs. not associated, and light vs. heavy traffic
- * loads when associated.
- *
- * After receiving this command, the device's scan engine does the following;
- *
- * 1)  Sends SCAN_START notification to driver
- * 2)  Checks to see if it has time to do scan for one channel
- * 3)  Sends NULL packet, with power-save (PS) bit set to 1,
- *     to tell AP that we're going off-channel
- * 4)  Tunes to first channel in scan list, does active or passive scan
- * 5)  Sends SCAN_RESULT notification to driver
- * 6)  Checks to see if it has time to do scan on *next* channel in list
- * 7)  Repeats 4-6 until it no longer has time to scan the next channel
- *     before max_out_time expires
- * 8)  Returns to service channel
- * 9)  Sends NULL packet with PS=0 to tell AP that we're back
- * 10) Stays on service channel until suspend_time expires
- * 11) Repeats entire process 2-10 until list is complete
- * 12) Sends SCAN_COMPLETE notification
- *
- * For fast, efficient scans, the scan command also has support for staying on
- * a channel for just a short time, if doing active scanning and getting no
- * responses to the transmitted probe request.  This time is controlled by
- * quiet_time, and the number of received packets below which a channel is
- * considered "quiet" is controlled by quiet_plcp_threshold.
- *
- * For active scanning on channels that have regulatory restrictions against
- * blindly transmitting, the scan can listen before transmitting, to make sure
- * that there is already legitimate activity on the channel.  If enough
- * packets are cleanly received on the channel (controlled by good_CRC_th,
- * typical value 1), the scan engine starts transmitting probe requests.
- *
- * Driver must use separate scan commands for 2.4 vs. 5 GHz bands.
- *
- * To avoid uCode errors, see timing restrictions described under
- * struct iwl3945_scan_channel.
- */
-struct iwl3945_scan_cmd {
-	__le16 len;
-	u8 reserved0;
-	u8 channel_count;	/* # channels in channel list */
-	__le16 quiet_time;	/* dwell only this # millisecs on quiet channel
-				 * (only for active scan) */
-	__le16 quiet_plcp_th;	/* quiet chnl is < this # pkts (typ. 1) */
-	__le16 good_CRC_th;	/* passive -> active promotion threshold */
-	__le16 reserved1;
-	__le32 max_out_time;	/* max usec to be away from associated (service)
-				 * channel */
-	__le32 suspend_time;	/* pause scan this long (in "extended beacon
-				 * format") when returning to service channel:
-				 * 3945; 31:24 # beacons, 19:0 additional usec,
-				 * 4965; 31:22 # beacons, 21:0 additional usec.
-				 */
-	__le32 flags;		/* RXON_FLG_* */
-	__le32 filter_flags;	/* RXON_FILTER_* */
-
-	/* For active scans (set to all-0s for passive scans).
-	 * Does not include payload.  Must specify Tx rate; no rate scaling. */
-	struct iwl3945_tx_cmd tx_cmd;
-
-	/* For directed active scans (set to all-0s otherwise) */
-	struct iwl_ssid_ie direct_scan[PROBE_OPTION_MAX_API1];
-
-	/*
-	 * Probe request frame, followed by channel list.
-	 *
-	 * Size of probe request frame is specified by byte count in tx_cmd.
-	 * Channel list follows immediately after probe request frame.
-	 * Number of channels in list is specified by channel_count.
-	 * Each channel in list is of type:
-	 *
-	 * struct iwl3945_scan_channel channels[0];
-	 *
-	 * NOTE:  Only one band of channels can be scanned per pass.  You
-	 * must not mix 2.4GHz channels and 5.2GHz channels, and you must wait
-	 * for one scan to complete (i.e. receive SCAN_COMPLETE_NOTIFICATION)
-	 * before requesting another scan.
-	 */
-	u8 data[0];
-} __attribute__ ((packed));
-
-/******************************************************************************
- * (9)
- * IBSS/AP Commands and Notifications:
- *
- *****************************************************************************/
-
-/*
- * BEACON_NOTIFICATION = 0x90 (notification only, not a command)
- */
-struct iwl3945_beacon_notif {
-	struct iwl3945_tx_resp beacon_notify_hdr;
-	__le32 low_tsf;
-	__le32 high_tsf;
-	__le32 ibss_mgr_status;
-} __attribute__ ((packed));
-
-/*
- * REPLY_TX_BEACON = 0x91 (command, has simple generic response)
- */
-struct iwl3945_tx_beacon_cmd {
-	struct iwl3945_tx_cmd tx;
-	__le16 tim_idx;
-	u8 tim_size;
-	u8 reserved1;
-	struct ieee80211_hdr frame[0];	/* beacon frame */
-} __attribute__ ((packed));
-
-/******************************************************************************
- * (10)
- * Statistics Commands and Notifications:
- *
- *****************************************************************************/
-
-struct iwl39_statistics_rx_phy {
-	__le32 ina_cnt;
-	__le32 fina_cnt;
-	__le32 plcp_err;
-	__le32 crc32_err;
-	__le32 overrun_err;
-	__le32 early_overrun_err;
-	__le32 crc32_good;
-	__le32 false_alarm_cnt;
-	__le32 fina_sync_err_cnt;
-	__le32 sfd_timeout;
-	__le32 fina_timeout;
-	__le32 unresponded_rts;
-	__le32 rxe_frame_limit_overrun;
-	__le32 sent_ack_cnt;
-	__le32 sent_cts_cnt;
-} __attribute__ ((packed));
-
-struct iwl39_statistics_rx_non_phy {
-	__le32 bogus_cts;	/* CTS received when not expecting CTS */
-	__le32 bogus_ack;	/* ACK received when not expecting ACK */
-	__le32 non_bssid_frames;	/* number of frames with BSSID that
-					 * doesn't belong to the STA BSSID */
-	__le32 filtered_frames;	/* count frames that were dumped in the
-				 * filtering process */
-	__le32 non_channel_beacons;	/* beacons with our bss id but not on
-					 * our serving channel */
-} __attribute__ ((packed));
-
-struct iwl39_statistics_rx {
-	struct iwl39_statistics_rx_phy ofdm;
-	struct iwl39_statistics_rx_phy cck;
-	struct iwl39_statistics_rx_non_phy general;
-} __attribute__ ((packed));
-
-struct iwl39_statistics_tx {
-	__le32 preamble_cnt;
-	__le32 rx_detected_cnt;
-	__le32 bt_prio_defer_cnt;
-	__le32 bt_prio_kill_cnt;
-	__le32 few_bytes_cnt;
-	__le32 cts_timeout;
-	__le32 ack_timeout;
-	__le32 expected_ack_cnt;
-	__le32 actual_ack_cnt;
-} __attribute__ ((packed));
-
-struct iwl39_statistics_div {
-	__le32 tx_on_a;
-	__le32 tx_on_b;
-	__le32 exec_time;
-	__le32 probe_time;
-} __attribute__ ((packed));
-
-struct iwl39_statistics_general {
-	__le32 temperature;
-	struct statistics_dbg dbg;
-	__le32 sleep_time;
-	__le32 slots_out;
-	__le32 slots_idle;
-	__le32 ttl_timestamp;
-	struct iwl39_statistics_div div;
-} __attribute__ ((packed));
-
-/*
- * STATISTICS_NOTIFICATION = 0x9d (notification only, not a command)
- *
- * By default, uCode issues this notification after receiving a beacon
- * while associated.  To disable this behavior, set DISABLE_NOTIF flag in the
- * REPLY_STATISTICS_CMD 0x9c, above.
- *
- * Statistics counters continue to increment beacon after beacon, but are
- * cleared when changing channels or when driver issues REPLY_STATISTICS_CMD
- * 0x9c with CLEAR_STATS bit set (see above).
- *
- * uCode also issues this notification during scans.  uCode clears statistics
- * appropriately so that each notification contains statistics for only the
- * one channel that has just been scanned.
- */
-struct iwl3945_notif_statistics {
-	__le32 flag;
-	struct statistics_rx rx;
-	struct statistics_tx tx;
-	struct statistics_general general;
-} __attribute__ ((packed));
-
-
-/******************************************************************************
- * (13)
- * Union of all expected notifications/responses:
- *
- *****************************************************************************/
-
-struct iwl3945_rx_packet {
-	__le32 len;
-	struct iwl_cmd_header hdr;
-	union {
-		struct iwl3945_alive_resp alive_frame;
-		struct iwl3945_rx_frame rx_frame;
-		struct iwl3945_tx_resp tx_resp;
-		struct iwl_spectrum_notification spectrum_notif;
-		struct iwl_csa_notification csa_notif;
-		struct iwl_error_resp err_resp;
-		struct iwl_card_state_notif card_state_notif;
-		struct iwl3945_beacon_notif beacon_status;
-		struct iwl_add_sta_resp add_sta;
-		struct iwl_sleep_notification sleep_notif;
-		struct iwl_spectrum_resp spectrum;
-		struct iwl3945_notif_statistics stats;
-		__le32 status;
-		u8 raw[0];
-	} u;
-} __attribute__ ((packed));
-
-#define IWL_RX_FRAME_SIZE        (4 + sizeof(struct iwl3945_rx_frame))
-
-#endif				/* __iwl3945_3945_commands_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-led.c b/drivers/net/wireless/iwlwifi/iwl-3945-led.c
index b34bef4..32d09ba 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-led.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-led.c
@@ -39,7 +39,6 @@
 #include <asm/unaligned.h>
 
 #include "iwl-commands.h"
-#include "iwl-3945-commands.h"
 #include "iwl-3945.h"
 
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-rs.c b/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
index 3b8db16..871c65e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
@@ -37,7 +37,6 @@
 #include <linux/workqueue.h>
 
 #include "iwl-commands.h"
-#include "iwl-3945-commands.h"
 #include "iwl-3945.h"
 
 #define RS_NAME "iwl-3945-rs"
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 8cc56f0..0fd8a22 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -41,7 +41,6 @@
 #include "iwl-3945-core.h"
 #include "iwl-3945-fh.h"
 #include "iwl-commands.h"
-#include "iwl-3945-commands.h"
 #include "iwl-3945.h"
 #include "iwl-helpers.h"
 #include "iwl-3945-rs.h"
@@ -333,7 +332,7 @@ static void iwl3945_tx_queue_reclaim(struct iwl3945_priv *priv,
 static void iwl3945_rx_reply_tx(struct iwl3945_priv *priv,
 			    struct iwl3945_rx_mem_buffer *rxb)
 {
-	struct iwl3945_rx_packet *pkt = (void *)rxb->skb->data;
+	struct iwl_rx_packet *pkt = (void *)rxb->skb->data;
 	u16 sequence = le16_to_cpu(pkt->hdr.sequence);
 	int txq_id = SEQ_TO_QUEUE(sequence);
 	int index = SEQ_TO_INDEX(sequence);
@@ -392,7 +391,7 @@ static void iwl3945_rx_reply_tx(struct iwl3945_priv *priv,
 
 void iwl3945_hw_rx_statistics(struct iwl3945_priv *priv, struct iwl3945_rx_mem_buffer *rxb)
 {
-	struct iwl3945_rx_packet *pkt = (void *)rxb->skb->data;
+	struct iwl_rx_packet *pkt = (void *)rxb->skb->data;
 	IWL_DEBUG_RX("Statistics notification received (%d vs %d).\n",
 		     (int)sizeof(struct iwl3945_notif_statistics),
 		     le32_to_cpu(pkt->len));
@@ -419,7 +418,7 @@ void iwl3945_hw_rx_statistics(struct iwl3945_priv *priv, struct iwl3945_rx_mem_b
  * group100 parameter selects whether to show 1 out of 100 good frames.
  */
 static void iwl3945_dbg_report_frame(struct iwl3945_priv *priv,
-		      struct iwl3945_rx_packet *pkt,
+		      struct iwl_rx_packet *pkt,
 		      struct ieee80211_hdr *header, int group100)
 {
 	u32 to_us;
@@ -547,7 +546,7 @@ static void iwl3945_dbg_report_frame(struct iwl3945_priv *priv,
 }
 #else
 static inline void iwl3945_dbg_report_frame(struct iwl3945_priv *priv,
-		      struct iwl3945_rx_packet *pkt,
+		      struct iwl_rx_packet *pkt,
 		      struct ieee80211_hdr *header, int group100)
 {
 }
@@ -575,7 +574,7 @@ static void iwl3945_pass_packet_to_mac80211(struct iwl3945_priv *priv,
 				   struct iwl3945_rx_mem_buffer *rxb,
 				   struct ieee80211_rx_status *stats)
 {
-	struct iwl3945_rx_packet *pkt = (struct iwl3945_rx_packet *)rxb->skb->data;
+	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
 #ifdef CONFIG_IWL3945_LEDS
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)IWL_RX_DATA(pkt);
 #endif
@@ -584,7 +583,7 @@ static void iwl3945_pass_packet_to_mac80211(struct iwl3945_priv *priv,
 	short len = le16_to_cpu(rx_hdr->len);
 
 	/* We received data from the HW, so stop the watchdog */
-	if (unlikely((len + IWL_RX_FRAME_SIZE) > skb_tailroom(rxb->skb))) {
+	if (unlikely((len + IWL39_RX_FRAME_SIZE) > skb_tailroom(rxb->skb))) {
 		IWL_DEBUG_DROP("Corruption detected!\n");
 		return;
 	}
@@ -619,7 +618,7 @@ static void iwl3945_rx_reply_rx(struct iwl3945_priv *priv,
 {
 	struct ieee80211_hdr *header;
 	struct ieee80211_rx_status rx_status;
-	struct iwl3945_rx_packet *pkt = (void *)rxb->skb->data;
+	struct iwl_rx_packet *pkt = (void *)rxb->skb->data;
 	struct iwl3945_rx_frame_stats *rx_stats = IWL_RX_STATS(pkt);
 	struct iwl3945_rx_frame_hdr *rx_hdr = IWL_RX_HDR(pkt);
 	struct iwl3945_rx_frame_end *rx_end = IWL_RX_END(pkt);
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index 12ead38..5d5176a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -768,8 +768,9 @@ struct iwl3945_priv {
 
 	/* 1st responses from initialize and runtime uCode images.
 	 * 4965's initialize alive response contains some calibration data. */
-	struct iwl3945_init_alive_resp card_alive_init;
-	struct iwl3945_alive_resp card_alive;
+	/* FIXME: 4965 uses bigger structure for init */
+	struct iwl_alive_resp card_alive_init;
+	struct iwl_alive_resp card_alive;
 
 #ifdef CONFIG_IWL3945_RFKILL
 	struct rfkill *rfkill;
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 53796b4..88467b0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -225,6 +225,37 @@ struct iwl_cmd_header {
 	u8 data[0];
 } __attribute__ ((packed));
 
+
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
 /**
  * iwlagn rate_n_flags bit fields
  *
@@ -499,8 +530,6 @@ struct iwl_alive_resp {
 	__le32 is_valid;
 } __attribute__ ((packed));
 
-
-
 /*
  * REPLY_ERROR = 0x2 (response only, not a command)
  */
@@ -618,6 +647,26 @@ enum {
  *        issue a new REPLY_TX_PWR_TABLE_CMD after each REPLY_RXON (0x10),
  *        regardless of whether RXON_FILTER_ASSOC_MSK is set.
  */
+
+struct iwl3945_rxon_cmd {
+	u8 node_addr[6];
+	__le16 reserved1;
+	u8 bssid_addr[6];
+	__le16 reserved2;
+	u8 wlap_bssid_addr[6];
+	__le16 reserved3;
+	u8 dev_type;
+	u8 air_propagation;
+	__le16 reserved4;
+	u8 ofdm_basic_rates;
+	u8 cck_basic_rates;
+	__le16 assoc_id;
+	__le32 flags;
+	__le32 filter_flags;
+	__le16 channel;
+	__le16 reserved5;
+} __attribute__ ((packed));
+
 struct iwl4965_rxon_cmd {
 	u8 node_addr[6];
 	__le16 reserved1;
@@ -663,33 +712,41 @@ struct iwl_rxon_cmd {
 	__le16 reserved6;
 } __attribute__ ((packed));
 
-struct iwl5000_rxon_assoc_cmd {
+/*
+ * REPLY_RXON_ASSOC = 0x11 (command, has simple generic response)
+ */
+struct iwl3945_rxon_assoc_cmd {
+	__le32 flags;
+	__le32 filter_flags;
+	u8 ofdm_basic_rates;
+	u8 cck_basic_rates;
+	__le16 reserved;
+} __attribute__ ((packed));
+
+struct iwl4965_rxon_assoc_cmd {
 	__le32 flags;
 	__le32 filter_flags;
 	u8 ofdm_basic_rates;
 	u8 cck_basic_rates;
-	__le16 reserved1;
 	u8 ofdm_ht_single_stream_basic_rates;
 	u8 ofdm_ht_dual_stream_basic_rates;
-	u8 ofdm_ht_triple_stream_basic_rates;
-	u8 reserved2;
 	__le16 rx_chain_select_flags;
-	__le16 acquisition_data;
-	__le32 reserved3;
+	__le16 reserved;
 } __attribute__ ((packed));
 
-/*
- * REPLY_RXON_ASSOC = 0x11 (command, has simple generic response)
- */
-struct iwl4965_rxon_assoc_cmd {
+struct iwl5000_rxon_assoc_cmd {
 	__le32 flags;
 	__le32 filter_flags;
 	u8 ofdm_basic_rates;
 	u8 cck_basic_rates;
+	__le16 reserved1;
 	u8 ofdm_ht_single_stream_basic_rates;
 	u8 ofdm_ht_dual_stream_basic_rates;
+	u8 ofdm_ht_triple_stream_basic_rates;
+	u8 reserved2;
 	__le16 rx_chain_select_flags;
-	__le16 reserved;
+	__le16 acquisition_data;
+	__le32 reserved3;
 } __attribute__ ((packed));
 
 #define IWL_CONN_MAX_LISTEN_INTERVAL	10
@@ -709,6 +766,16 @@ struct iwl_rxon_time_cmd {
 /*
  * REPLY_CHANNEL_SWITCH = 0x72 (command, has simple generic response)
  */
+struct iwl3945_channel_switch_cmd {
+	u8 band;
+	u8 expect_beacon;
+	__le16 channel;
+	__le32 rxon_flags;
+	__le32 rxon_filter_flags;
+	__le32 switch_time;
+	struct iwl3945_power_per_rate power[IWL_MAX_RATES];
+} __attribute__ ((packed));
+
 struct iwl_channel_switch_cmd {
 	u8 band;
 	u8 expect_beacon;
@@ -912,6 +979,35 @@ struct sta_id_modify {
  *        used as AP, or in an IBSS network, driver must set up station table
  *        entries for all STAs in network, starting with index IWL_STA_ID.
  */
+
+struct iwl3945_addsta_cmd {
+	u8 mode;		/* 1: modify existing, 0: add new station */
+	u8 reserved[3];
+	struct sta_id_modify sta;
+	struct iwl4965_keyinfo key;
+	__le32 station_flags;		/* STA_FLG_* */
+	__le32 station_flags_msk;	/* STA_FLG_* */
+
+	/* bit field to disable (1) or enable (0) Tx for Traffic ID (TID)
+	 * corresponding to bit (e.g. bit 5 controls TID 5).
+	 * Set modify_mask bit STA_MODIFY_TID_DISABLE_TX to use this field. */
+	__le16 tid_disable_tx;
+
+	__le16 rate_n_flags;
+
+	/* TID for which to add block-ack support.
+	 * Set modify_mask bit STA_MODIFY_ADDBA_TID_MSK to use this field. */
+	u8 add_immediate_ba_tid;
+
+	/* TID for which to remove block-ack support.
+	 * Set modify_mask bit STA_MODIFY_DELBA_TID_MSK to use this field. */
+	u8 remove_immediate_ba_tid;
+
+	/* Starting Sequence Number for added block-ack support.
+	 * Set modify_mask bit STA_MODIFY_ADDBA_TID_MSK to use this field. */
+	__le16 add_immediate_ba_ssn;
+} __attribute__ ((packed));
+
 struct iwl4965_addsta_cmd {
 	u8 mode;		/* 1: modify existing, 0: add new station */
 	u8 reserved[3];
@@ -1065,6 +1161,48 @@ struct iwl_wep_cmd {
 #define RX_MPDU_RES_STATUS_TTAK_OK	(1 << 7)
 #define RX_MPDU_RES_STATUS_DEC_DONE_MSK	(0x800)
 
+
+struct iwl3945_rx_frame_stats {
+	u8 phy_count;
+	u8 id;
+	u8 rssi;
+	u8 agc;
+	__le16 sig_avg;
+	__le16 noise_diff;
+	u8 payload[0];
+} __attribute__ ((packed));
+
+struct iwl3945_rx_frame_hdr {
+	__le16 channel;
+	__le16 phy_flags;
+	u8 reserved1;
+	u8 rate;
+	__le16 len;
+	u8 payload[0];
+} __attribute__ ((packed));
+
+struct iwl3945_rx_frame_end {
+	__le32 status;
+	__le64 timestamp;
+	__le32 beacon_timestamp;
+} __attribute__ ((packed));
+
+/*
+ * REPLY_3945_RX = 0x1b (response only, not a command)
+ *
+ * NOTE:  DO NOT dereference from casts to this structure
+ * It is provided only for calculating minimum data set size.
+ * The actual offsets of the hdr and end are dynamic based on
+ * stats.phy_count
+ */
+struct iwl3945_rx_frame {
+	struct iwl3945_rx_frame_stats stats;
+	struct iwl3945_rx_frame_hdr hdr;
+	struct iwl3945_rx_frame_end end;
+} __attribute__ ((packed));
+
+#define IWL39_RX_FRAME_SIZE	(4 + sizeof(struct iwl3945_rx_frame))
+
 /* Fixed (non-configurable) rx data from phy */
 
 #define IWL49_RX_RES_PHY_CNT 14
@@ -1245,6 +1383,84 @@ struct iwl4965_rx_mpdu_res_start {
 #define TKIP_ICV_LEN 4
 
 /*
+ * REPLY_TX = 0x1c (command)
+ */
+
+struct iwl3945_tx_cmd {
+	/*
+	 * MPDU byte count:
+	 * MAC header (24/26/30/32 bytes) + 2 bytes pad if 26/30 header size,
+	 * + 8 byte IV for CCM or TKIP (not used for WEP)
+	 * + Data payload
+	 * + 8-byte MIC (not used for CCM/WEP)
+	 * NOTE:  Does not include Tx command bytes, post-MAC pad bytes,
+	 *        MIC (CCM) 8 bytes, ICV (WEP/TKIP/CKIP) 4 bytes, CRC 4 bytes.i
+	 * Range: 14-2342 bytes.
+	 */
+	__le16 len;
+
+	/*
+	 * MPDU or MSDU byte count for next frame.
+	 * Used for fragmentation and bursting, but not 11n aggregation.
+	 * Same as "len", but for next frame.  Set to 0 if not applicable.
+	 */
+	__le16 next_frame_len;
+
+	__le32 tx_flags;	/* TX_CMD_FLG_* */
+
+	u8 rate;
+
+	/* Index of recipient station in uCode's station table */
+	u8 sta_id;
+	u8 tid_tspec;
+	u8 sec_ctl;
+	u8 key[16];
+	union {
+		u8 byte[8];
+		__le16 word[4];
+		__le32 dw[2];
+	} tkip_mic;
+	__le32 next_frame_info;
+	union {
+		__le32 life_time;
+		__le32 attempt;
+	} stop_time;
+	u8 supp_rates[2];
+	u8 rts_retry_limit;	/*byte 50 */
+	u8 data_retry_limit;	/*byte 51 */
+	union {
+		__le16 pm_frame_timeout;
+		__le16 attempt_duration;
+	} timeout;
+
+	/*
+	 * Duration of EDCA burst Tx Opportunity, in 32-usec units.
+	 * Set this if txop time is not specified by HCCA protocol (e.g. by AP).
+	 */
+	__le16 driver_txop;
+
+	/*
+	 * MAC header goes here, followed by 2 bytes padding if MAC header
+	 * length is 26 or 30 bytes, followed by payload data
+	 */
+	u8 payload[0];
+	struct ieee80211_hdr hdr[0];
+} __attribute__ ((packed));
+
+/*
+ * REPLY_TX = 0x1c (response)
+ */
+struct iwl3945_tx_resp {
+	u8 failure_rts;
+	u8 failure_frame;
+	u8 bt_kill_count;
+	u8 rate;
+	__le32 wireless_media_time;
+	__le32 status;		/* TX status */
+} __attribute__ ((packed));
+
+
+/*
  * 4965 uCode updates these Tx attempt count values in host DRAM.
  * Used for managing Tx retries when expecting block-acks.
  * Driver should set these fields to 0.
@@ -1255,9 +1471,6 @@ struct iwl_dram_scratch {
 	__le16 reserved;
 } __attribute__ ((packed));
 
-/*
- * REPLY_TX = 0x1c (command)
- */
 struct iwl_tx_cmd {
 	/*
 	 * MPDU byte count:
@@ -1595,6 +1808,14 @@ struct iwl_compressed_ba_resp {
  *
  * See details under "TXPOWER" in iwl-4965-hw.h.
  */
+
+struct iwl3945_txpowertable_cmd {
+	u8 band;		/* 0: 5 GHz, 1: 2.4 GHz */
+	u8 reserved;
+	__le16 channel;
+	struct iwl3945_power_per_rate power[IWL_MAX_RATES];
+} __attribute__ ((packed));
+
 struct iwl4965_txpowertable_cmd {
 	u8 band;		/* 0: 5 GHz, 1: 2.4 GHz */
 	u8 reserved;
@@ -1602,6 +1823,35 @@ struct iwl4965_txpowertable_cmd {
 	struct iwl4965_tx_power_db tx_power;
 } __attribute__ ((packed));
 
+
+/**
+ * struct iwl3945_rate_scaling_cmd - Rate Scaling Command & Response
+ *
+ * REPLY_RATE_SCALE = 0x47 (command, has simple generic response)
+ *
+ * NOTE: The table of rates passed to the uCode via the
+ * RATE_SCALE command sets up the corresponding order of
+ * rates used for all related commands, including rate
+ * masks, etc.
+ *
+ * For example, if you set 9MB (PLCP 0x0f) as the first
+ * rate in the rate table, the bit mask for that rate
+ * when passed through ofdm_basic_rates on the REPLY_RXON
+ * command would be bit 0 (1 << 0)
+ */
+struct iwl3945_rate_scaling_info {
+	__le16 rate_n_flags;
+	u8 try_cnt;
+	u8 next_rate_index;
+} __attribute__ ((packed));
+
+struct iwl3945_rate_scaling_cmd {
+	u8 table_id;
+	u8 reserved[3];
+	struct iwl3945_rate_scaling_info table[IWL_MAX_RATES];
+} __attribute__ ((packed));
+
+
 /*RS_NEW_API: only TLC_RTS remains and moved to bit 0 */
 #define  LINK_QUAL_FLAGS_SET_STA_TLC_RTS_MSK	(1 << 0)
 
@@ -2162,6 +2412,23 @@ struct iwl_ct_kill_config {
  *     passive_dwell < max_out_time
  *     active_dwell < max_out_time
  */
+
+/* FIXME: rename to AP1, remove tpc */
+struct iwl3945_scan_channel {
+	/*
+	 * type is defined as:
+	 * 0:0 1 = active, 0 = passive
+	 * 1:4 SSID direct bit map; if a bit is set, then corresponding
+	 *     SSID IE is transmitted in probe request.
+	 * 5:7 reserved
+	 */
+	u8 type;
+	u8 channel;	/* band is selected by iwl3945_scan_cmd "flags" field */
+	struct iwl3945_tx_power tpc;
+	__le16 active_dwell;	/* in 1024-uSec TU (time units), typ 5-50 */
+	__le16 passive_dwell;	/* in 1024-uSec TU (time units), typ 20-500 */
+} __attribute__ ((packed));
+
 struct iwl_scan_channel {
 	/*
 	 * type is defined as:
@@ -2249,6 +2516,51 @@ struct iwl_ssid_ie {
  * To avoid uCode errors, see timing restrictions described under
  * struct iwl_scan_channel.
  */
+
+struct iwl3945_scan_cmd {
+	__le16 len;
+	u8 reserved0;
+	u8 channel_count;	/* # channels in channel list */
+	__le16 quiet_time;	/* dwell only this # millisecs on quiet channel
+				 * (only for active scan) */
+	__le16 quiet_plcp_th;	/* quiet chnl is < this # pkts (typ. 1) */
+	__le16 good_CRC_th;	/* passive -> active promotion threshold */
+	__le16 reserved1;
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
+	struct iwl3945_tx_cmd tx_cmd;
+
+	/* For directed active scans (set to all-0s otherwise) */
+	struct iwl_ssid_ie direct_scan[PROBE_OPTION_MAX_API1];
+
+	/*
+	 * Probe request frame, followed by channel list.
+	 *
+	 * Size of probe request frame is specified by byte count in tx_cmd.
+	 * Channel list follows immediately after probe request frame.
+	 * Number of channels in list is specified by channel_count.
+	 * Each channel in list is of type:
+	 *
+	 * struct iwl3945_scan_channel channels[0];
+	 *
+	 * NOTE:  Only one band of channels can be scanned per pass.  You
+	 * must not mix 2.4GHz channels and 5.2GHz channels, and you must wait
+	 * for one scan to complete (i.e. receive SCAN_COMPLETE_NOTIFICATION)
+	 * before requesting another scan.
+	 */
+	u8 data[0];
+} __attribute__ ((packed));
+
 struct iwl_scan_cmd {
 	__le16 len;
 	u8 reserved0;
@@ -2356,6 +2668,14 @@ struct iwl_scancomplete_notification {
 /*
  * BEACON_NOTIFICATION = 0x90 (notification only, not a command)
  */
+
+struct iwl3945_beacon_notif {
+	struct iwl3945_tx_resp beacon_notify_hdr;
+	__le32 low_tsf;
+	__le32 high_tsf;
+	__le32 ibss_mgr_status;
+} __attribute__ ((packed));
+
 struct iwl4965_beacon_notif {
 	struct iwl4965_tx_resp beacon_notify_hdr;
 	__le32 low_tsf;
@@ -2366,6 +2686,15 @@ struct iwl4965_beacon_notif {
 /*
  * REPLY_TX_BEACON = 0x91 (command, has simple generic response)
  */
+
+struct iwl3945_tx_beacon_cmd {
+	struct iwl3945_tx_cmd tx;
+	__le16 tim_idx;
+	u8 tim_size;
+	u8 reserved1;
+	struct ieee80211_hdr frame[0];	/* beacon frame */
+} __attribute__ ((packed));
+
 struct iwl_tx_beacon_cmd {
 	struct iwl_tx_cmd tx;
 	__le16 tim_idx;
@@ -2402,6 +2731,76 @@ struct rate_histogram {
 
 /* statistics command response */
 
+struct iwl39_statistics_rx_phy {
+	__le32 ina_cnt;
+	__le32 fina_cnt;
+	__le32 plcp_err;
+	__le32 crc32_err;
+	__le32 overrun_err;
+	__le32 early_overrun_err;
+	__le32 crc32_good;
+	__le32 false_alarm_cnt;
+	__le32 fina_sync_err_cnt;
+	__le32 sfd_timeout;
+	__le32 fina_timeout;
+	__le32 unresponded_rts;
+	__le32 rxe_frame_limit_overrun;
+	__le32 sent_ack_cnt;
+	__le32 sent_cts_cnt;
+} __attribute__ ((packed));
+
+struct iwl39_statistics_rx_non_phy {
+	__le32 bogus_cts;	/* CTS received when not expecting CTS */
+	__le32 bogus_ack;	/* ACK received when not expecting ACK */
+	__le32 non_bssid_frames;	/* number of frames with BSSID that
+					 * doesn't belong to the STA BSSID */
+	__le32 filtered_frames;	/* count frames that were dumped in the
+				 * filtering process */
+	__le32 non_channel_beacons;	/* beacons with our bss id but not on
+					 * our serving channel */
+} __attribute__ ((packed));
+
+struct iwl39_statistics_rx {
+	struct iwl39_statistics_rx_phy ofdm;
+	struct iwl39_statistics_rx_phy cck;
+	struct iwl39_statistics_rx_non_phy general;
+} __attribute__ ((packed));
+
+struct iwl39_statistics_tx {
+	__le32 preamble_cnt;
+	__le32 rx_detected_cnt;
+	__le32 bt_prio_defer_cnt;
+	__le32 bt_prio_kill_cnt;
+	__le32 few_bytes_cnt;
+	__le32 cts_timeout;
+	__le32 ack_timeout;
+	__le32 expected_ack_cnt;
+	__le32 actual_ack_cnt;
+} __attribute__ ((packed));
+
+struct statistics_dbg {
+	__le32 burst_check;
+	__le32 burst_count;
+	__le32 reserved[4];
+} __attribute__ ((packed));
+
+struct iwl39_statistics_div {
+	__le32 tx_on_a;
+	__le32 tx_on_b;
+	__le32 exec_time;
+	__le32 probe_time;
+} __attribute__ ((packed));
+
+struct iwl39_statistics_general {
+	__le32 temperature;
+	struct statistics_dbg dbg;
+	__le32 sleep_time;
+	__le32 slots_out;
+	__le32 slots_idle;
+	__le32 ttl_timestamp;
+	struct iwl39_statistics_div div;
+} __attribute__ ((packed));
+
 struct statistics_rx_phy {
 	__le32 ina_cnt;
 	__le32 fina_cnt;
@@ -2513,11 +2912,6 @@ struct statistics_tx {
 	struct statistics_tx_non_phy_agg agg;
 } __attribute__ ((packed));
 
-struct statistics_dbg {
-	__le32 burst_check;
-	__le32 burst_count;
-	__le32 reserved[4];
-} __attribute__ ((packed));
 
 struct statistics_div {
 	__le32 tx_on_a;
@@ -2581,6 +2975,14 @@ struct iwl_statistics_cmd {
  */
 #define STATISTICS_REPLY_FLG_BAND_24G_MSK         cpu_to_le32(0x2)
 #define STATISTICS_REPLY_FLG_FAT_MODE_MSK         cpu_to_le32(0x8)
+
+struct iwl3945_notif_statistics {
+	__le32 flag;
+	struct iwl39_statistics_rx rx;
+	struct iwl39_statistics_tx tx;
+	struct iwl39_statistics_general general;
+} __attribute__ ((packed));
+
 struct iwl_notif_statistics {
 	__le32 flag;
 	struct statistics_rx rx;
@@ -3032,6 +3434,10 @@ struct iwl_rx_packet {
 	__le32 len;
 	struct iwl_cmd_header hdr;
 	union {
+		struct iwl3945_rx_frame rx_frame;
+		struct iwl3945_tx_resp tx_resp;
+		struct iwl3945_beacon_notif beacon_status;
+
 		struct iwl_alive_resp alive_frame;
 		struct iwl_spectrum_notification spectrum_notif;
 		struct iwl_csa_notification csa_notif;
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 5f90445..00600d6 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -48,7 +48,6 @@
 
 #include "iwl-3945-core.h"
 #include "iwl-commands.h"
-#include "iwl-3945-commands.h"
 #include "iwl-3945.h"
 #include "iwl-3945-fh.h"
 #include "iwl-helpers.h"
@@ -971,7 +970,7 @@ static int iwl3945_full_rxon_required(struct iwl3945_priv *priv)
 static int iwl3945_send_rxon_assoc(struct iwl3945_priv *priv)
 {
 	int rc = 0;
-	struct iwl3945_rx_packet *res = NULL;
+	struct iwl_rx_packet *res = NULL;
 	struct iwl3945_rxon_assoc_cmd rxon_assoc;
 	struct iwl3945_host_cmd cmd = {
 		.id = REPLY_RXON_ASSOC,
@@ -1000,7 +999,7 @@ static int iwl3945_send_rxon_assoc(struct iwl3945_priv *priv)
 	if (rc)
 		return rc;
 
-	res = (struct iwl3945_rx_packet *)cmd.meta.u.skb->data;
+	res = (struct iwl_rx_packet *)cmd.meta.u.skb->data;
 	if (res->hdr.flags & IWL_CMD_FAILED_MSK) {
 		IWL_ERROR("Bad return from REPLY_RXON_ASSOC command\n");
 		rc = -EIO;
@@ -1156,7 +1155,7 @@ static int iwl3945_send_bt_config(struct iwl3945_priv *priv)
 static int iwl3945_send_scan_abort(struct iwl3945_priv *priv)
 {
 	int rc = 0;
-	struct iwl3945_rx_packet *res;
+	struct iwl_rx_packet *res;
 	struct iwl3945_host_cmd cmd = {
 		.id = REPLY_SCAN_ABORT_CMD,
 		.meta.flags = CMD_WANT_SKB,
@@ -1176,7 +1175,7 @@ static int iwl3945_send_scan_abort(struct iwl3945_priv *priv)
 		return rc;
 	}
 
-	res = (struct iwl3945_rx_packet *)cmd.meta.u.skb->data;
+	res = (struct iwl_rx_packet *)cmd.meta.u.skb->data;
 	if (res->u.status != CAN_ABORT_STATUS) {
 		/* The scan abort will return 1 for success or
 		 * 2 for "failure".  A failure condition can be
@@ -1229,14 +1228,14 @@ static int iwl3945_send_card_state(struct iwl3945_priv *priv, u32 flags, u8 meta
 static int iwl3945_add_sta_sync_callback(struct iwl3945_priv *priv,
 				     struct iwl3945_cmd *cmd, struct sk_buff *skb)
 {
-	struct iwl3945_rx_packet *res = NULL;
+	struct iwl_rx_packet *res = NULL;
 
 	if (!skb) {
 		IWL_ERROR("Error: Response NULL in REPLY_ADD_STA.\n");
 		return 1;
 	}
 
-	res = (struct iwl3945_rx_packet *)skb->data;
+	res = (struct iwl_rx_packet *)skb->data;
 	if (res->hdr.flags & IWL_CMD_FAILED_MSK) {
 		IWL_ERROR("Bad return from REPLY_ADD_STA (0x%08X)\n",
 			  res->hdr.flags);
@@ -1257,7 +1256,7 @@ static int iwl3945_add_sta_sync_callback(struct iwl3945_priv *priv,
 int iwl3945_send_add_station(struct iwl3945_priv *priv,
 			 struct iwl3945_addsta_cmd *sta, u8 flags)
 {
-	struct iwl3945_rx_packet *res = NULL;
+	struct iwl_rx_packet *res = NULL;
 	int rc = 0;
 	struct iwl3945_host_cmd cmd = {
 		.id = REPLY_ADD_STA,
@@ -1276,7 +1275,7 @@ int iwl3945_send_add_station(struct iwl3945_priv *priv,
 	if (rc || (flags & CMD_ASYNC))
 		return rc;
 
-	res = (struct iwl3945_rx_packet *)cmd.meta.u.skb->data;
+	res = (struct iwl_rx_packet *)cmd.meta.u.skb->data;
 	if (res->hdr.flags & IWL_CMD_FAILED_MSK) {
 		IWL_ERROR("Bad return from REPLY_ADD_STA (0x%08X)\n",
 			  res->hdr.flags);
@@ -2875,7 +2874,7 @@ static int iwl3945_get_measurement(struct iwl3945_priv *priv,
 			       u8 type)
 {
 	struct iwl_spectrum_cmd spectrum;
-	struct iwl3945_rx_packet *res;
+	struct iwl_rx_packet *res;
 	struct iwl3945_host_cmd cmd = {
 		.id = REPLY_SPECTRUM_MEASUREMENT_CMD,
 		.data = (void *)&spectrum,
@@ -2920,7 +2919,7 @@ static int iwl3945_get_measurement(struct iwl3945_priv *priv,
 	if (rc)
 		return rc;
 
-	res = (struct iwl3945_rx_packet *)cmd.meta.u.skb->data;
+	res = (struct iwl_rx_packet *)cmd.meta.u.skb->data;
 	if (res->hdr.flags & IWL_CMD_FAILED_MSK) {
 		IWL_ERROR("Bad return from REPLY_RX_ON_ASSOC command\n");
 		rc = -EIO;
@@ -2952,8 +2951,8 @@ static int iwl3945_get_measurement(struct iwl3945_priv *priv,
 static void iwl3945_rx_reply_alive(struct iwl3945_priv *priv,
 			       struct iwl3945_rx_mem_buffer *rxb)
 {
-	struct iwl3945_rx_packet *pkt = (void *)rxb->skb->data;
-	struct iwl3945_alive_resp *palive;
+	struct iwl_rx_packet *pkt = (void *)rxb->skb->data;
+	struct iwl_alive_resp *palive;
 	struct delayed_work *pwork;
 
 	palive = &pkt->u.alive_frame;
@@ -2965,14 +2964,13 @@ static void iwl3945_rx_reply_alive(struct iwl3945_priv *priv,
 
 	if (palive->ver_subtype == INITIALIZE_SUBTYPE) {
 		IWL_DEBUG_INFO("Initialization Alive received.\n");
-		memcpy(&priv->card_alive_init,
-		       &pkt->u.alive_frame,
-		       sizeof(struct iwl3945_init_alive_resp));
+		memcpy(&priv->card_alive_init, &pkt->u.alive_frame,
+		       sizeof(struct iwl_alive_resp));
 		pwork = &priv->init_alive_start;
 	} else {
 		IWL_DEBUG_INFO("Runtime Alive received.\n");
 		memcpy(&priv->card_alive, &pkt->u.alive_frame,
-		       sizeof(struct iwl3945_alive_resp));
+		       sizeof(struct iwl_alive_resp));
 		pwork = &priv->alive_start;
 		iwl3945_disable_events(priv);
 	}
@@ -2989,7 +2987,7 @@ static void iwl3945_rx_reply_alive(struct iwl3945_priv *priv,
 static void iwl3945_rx_reply_add_sta(struct iwl3945_priv *priv,
 				 struct iwl3945_rx_mem_buffer *rxb)
 {
-	struct iwl3945_rx_packet *pkt = (void *)rxb->skb->data;
+	struct iwl_rx_packet *pkt = (void *)rxb->skb->data;
 
 	IWL_DEBUG_RX("Received REPLY_ADD_STA: 0x%02X\n", pkt->u.status);
 	return;
@@ -2998,7 +2996,7 @@ static void iwl3945_rx_reply_add_sta(struct iwl3945_priv *priv,
 static void iwl3945_rx_reply_error(struct iwl3945_priv *priv,
 			       struct iwl3945_rx_mem_buffer *rxb)
 {
-	struct iwl3945_rx_packet *pkt = (void *)rxb->skb->data;
+	struct iwl_rx_packet *pkt = (void *)rxb->skb->data;
 
 	IWL_ERROR("Error Reply type 0x%08X cmd %s (0x%02X) "
 		"seq 0x%04X ser 0x%08X\n",
@@ -3013,7 +3011,7 @@ static void iwl3945_rx_reply_error(struct iwl3945_priv *priv,
 
 static void iwl3945_rx_csa(struct iwl3945_priv *priv, struct iwl3945_rx_mem_buffer *rxb)
 {
-	struct iwl3945_rx_packet *pkt = (void *)rxb->skb->data;
+	struct iwl_rx_packet *pkt = (void *)rxb->skb->data;
 	struct iwl3945_rxon_cmd *rxon = (void *)&priv->active_rxon;
 	struct iwl_csa_notification *csa = &(pkt->u.csa_notif);
 	IWL_DEBUG_11H("CSA notif: channel %d, status %d\n",
@@ -3026,7 +3024,7 @@ static void iwl3945_rx_spectrum_measure_notif(struct iwl3945_priv *priv,
 					  struct iwl3945_rx_mem_buffer *rxb)
 {
 #ifdef CONFIG_IWL3945_SPECTRUM_MEASUREMENT
-	struct iwl3945_rx_packet *pkt = (void *)rxb->skb->data;
+	struct iwl_rx_packet *pkt = (void *)rxb->skb->data;
 	struct iwl_spectrum_notification *report = &(pkt->u.spectrum_notif);
 
 	if (!report->state) {
@@ -3044,7 +3042,7 @@ static void iwl3945_rx_pm_sleep_notif(struct iwl3945_priv *priv,
 				  struct iwl3945_rx_mem_buffer *rxb)
 {
 #ifdef CONFIG_IWL3945_DEBUG
-	struct iwl3945_rx_packet *pkt = (void *)rxb->skb->data;
+	struct iwl_rx_packet *pkt = (void *)rxb->skb->data;
 	struct iwl_sleep_notification *sleep = &(pkt->u.sleep_notif);
 	IWL_DEBUG_RX("sleep mode: %d, src: %d\n",
 		     sleep->pm_sleep_mode, sleep->pm_wakeup_src);
@@ -3054,7 +3052,7 @@ static void iwl3945_rx_pm_sleep_notif(struct iwl3945_priv *priv,
 static void iwl3945_rx_pm_debug_statistics_notif(struct iwl3945_priv *priv,
 					     struct iwl3945_rx_mem_buffer *rxb)
 {
-	struct iwl3945_rx_packet *pkt = (void *)rxb->skb->data;
+	struct iwl_rx_packet *pkt = (void *)rxb->skb->data;
 	IWL_DEBUG_RADIO("Dumping %d bytes of unhandled "
 			"notification for %s:\n",
 			le32_to_cpu(pkt->len), get_cmd_string(pkt->hdr.cmd));
@@ -3090,7 +3088,7 @@ static void iwl3945_rx_beacon_notif(struct iwl3945_priv *priv,
 				struct iwl3945_rx_mem_buffer *rxb)
 {
 #ifdef CONFIG_IWL3945_DEBUG
-	struct iwl3945_rx_packet *pkt = (void *)rxb->skb->data;
+	struct iwl_rx_packet *pkt = (void *)rxb->skb->data;
 	struct iwl3945_beacon_notif *beacon = &(pkt->u.beacon_status);
 	u8 rate = beacon->beacon_notify_hdr.rate;
 
@@ -3113,7 +3111,7 @@ static void iwl3945_rx_reply_scan(struct iwl3945_priv *priv,
 			      struct iwl3945_rx_mem_buffer *rxb)
 {
 #ifdef CONFIG_IWL3945_DEBUG
-	struct iwl3945_rx_packet *pkt = (void *)rxb->skb->data;
+	struct iwl_rx_packet *pkt = (void *)rxb->skb->data;
 	struct iwl_scanreq_notification *notif =
 	    (struct iwl_scanreq_notification *)pkt->u.raw;
 
@@ -3125,7 +3123,7 @@ static void iwl3945_rx_reply_scan(struct iwl3945_priv *priv,
 static void iwl3945_rx_scan_start_notif(struct iwl3945_priv *priv,
 				    struct iwl3945_rx_mem_buffer *rxb)
 {
-	struct iwl3945_rx_packet *pkt = (void *)rxb->skb->data;
+	struct iwl_rx_packet *pkt = (void *)rxb->skb->data;
 	struct iwl_scanstart_notification *notif =
 	    (struct iwl_scanstart_notification *)pkt->u.raw;
 	priv->scan_start_tsf = le32_to_cpu(notif->tsf_low);
@@ -3142,7 +3140,7 @@ static void iwl3945_rx_scan_start_notif(struct iwl3945_priv *priv,
 static void iwl3945_rx_scan_results_notif(struct iwl3945_priv *priv,
 				      struct iwl3945_rx_mem_buffer *rxb)
 {
-	struct iwl3945_rx_packet *pkt = (void *)rxb->skb->data;
+	struct iwl_rx_packet *pkt = (void *)rxb->skb->data;
 	struct iwl_scanresults_notification *notif =
 	    (struct iwl_scanresults_notification *)pkt->u.raw;
 
@@ -3167,7 +3165,7 @@ static void iwl3945_rx_scan_results_notif(struct iwl3945_priv *priv,
 static void iwl3945_rx_scan_complete_notif(struct iwl3945_priv *priv,
 				       struct iwl3945_rx_mem_buffer *rxb)
 {
-	struct iwl3945_rx_packet *pkt = (void *)rxb->skb->data;
+	struct iwl_rx_packet *pkt = (void *)rxb->skb->data;
 	struct iwl_scancomplete_notification *scan_notif = (void *)pkt->u.raw;
 
 	IWL_DEBUG_SCAN("Scan complete: %d channels (TSF 0x%08X:%08X) - %d\n",
@@ -3230,7 +3228,7 @@ reschedule:
 static void iwl3945_rx_card_state_notif(struct iwl3945_priv *priv,
 				    struct iwl3945_rx_mem_buffer *rxb)
 {
-	struct iwl3945_rx_packet *pkt = (void *)rxb->skb->data;
+	struct iwl_rx_packet *pkt = (void *)rxb->skb->data;
 	u32 flags = le32_to_cpu(pkt->u.card_state_notif.flags);
 	unsigned long status = priv->status;
 
@@ -3348,7 +3346,7 @@ static void iwl3945_cmd_queue_reclaim(struct iwl3945_priv *priv,
 static void iwl3945_tx_cmd_complete(struct iwl3945_priv *priv,
 				struct iwl3945_rx_mem_buffer *rxb)
 {
-	struct iwl3945_rx_packet *pkt = (struct iwl3945_rx_packet *)rxb->skb->data;
+	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
 	u16 sequence = le16_to_cpu(pkt->hdr.sequence);
 	int txq_id = SEQ_TO_QUEUE(sequence);
 	int index = SEQ_TO_INDEX(sequence);
@@ -3810,7 +3808,7 @@ int iwl3945_calc_sig_qual(int rssi_dbm, int noise_dbm)
 static void iwl3945_rx_handle(struct iwl3945_priv *priv)
 {
 	struct iwl3945_rx_mem_buffer *rxb;
-	struct iwl3945_rx_packet *pkt;
+	struct iwl_rx_packet *pkt;
 	struct iwl3945_rx_queue *rxq = &priv->rxq;
 	u32 r, i;
 	int reclaim;
@@ -3842,7 +3840,7 @@ static void iwl3945_rx_handle(struct iwl3945_priv *priv)
 		pci_dma_sync_single_for_cpu(priv->pci_dev, rxb->dma_addr,
 					    IWL_RX_BUF_SIZE,
 					    PCI_DMA_FROMDEVICE);
-		pkt = (struct iwl3945_rx_packet *)rxb->skb->data;
+		pkt = (struct iwl_rx_packet *)rxb->skb->data;
 
 		/* Reclaim a command buffer only if this packet is a response
 		 *   to a (driver-originated) command.
@@ -5847,7 +5845,7 @@ static void __iwl3945_down(struct iwl3945_priv *priv)
 	iwl3945_hw_nic_reset(priv);
 
  exit:
-	memset(&priv->card_alive, 0, sizeof(struct iwl3945_alive_resp));
+	memset(&priv->card_alive, 0, sizeof(struct iwl_alive_resp));
 
 	if (priv->ibss_beacon)
 		dev_kfree_skb(priv->ibss_beacon);
-- 
1.5.3.6

