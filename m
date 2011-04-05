Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:4582 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755401Ab1DERB2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Apr 2011 13:01:28 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 02/25] iwlagn: clean up some 3945/4965 remnants
Date: Tue,  5 Apr 2011 09:41:49 -0700
Message-Id: <1302021732-21250-3-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1302021732-21250-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1302021732-21250-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When the driver was split, a bunch of definitions
for the 3945 and 4965 devices stayed around, but
they're now useless so remove (some of) them.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.h   |   28 --
 drivers/net/wireless/iwlwifi/iwl-agn-sta.c  |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn.h      |    2 -
 drivers/net/wireless/iwlwifi/iwl-commands.h |  591 +--------------------------
 drivers/net/wireless/iwlwifi/iwl-core.c     |    1 -
 drivers/net/wireless/iwlwifi/iwl-dev.h      |  235 +++--------
 drivers/net/wireless/iwlwifi/iwl-eeprom.h   |  185 ---------
 drivers/net/wireless/iwlwifi/iwl-hcmd.c     |    2 -
 drivers/net/wireless/iwlwifi/iwl-prph.h     |   11 -
 9 files changed, 63 insertions(+), 994 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.h b/drivers/net/wireless/iwlwifi/iwl-agn-rs.h
index 184828c..b356a39 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.h
@@ -41,20 +41,6 @@ struct iwl_rate_info {
 	u8 next_rs_tgg;  /* next rate used in TGG rs algo */
 };
 
-struct iwl3945_rate_info {
-	u8 plcp;		/* uCode API:  IWL_RATE_6M_PLCP, etc. */
-	u8 ieee;		/* MAC header:  IWL_RATE_6M_IEEE, etc. */
-	u8 prev_ieee;		/* previous rate in IEEE speeds */
-	u8 next_ieee;		/* next rate in IEEE speeds */
-	u8 prev_rs;		/* previous rate used in rs algo */
-	u8 next_rs;		/* next rate used in rs algo */
-	u8 prev_rs_tgg;		/* previous rate used in TGG rs algo */
-	u8 next_rs_tgg;		/* next rate used in TGG rs algo */
-	u8 table_rs_index;	/* index in rate scale table cmd */
-	u8 prev_table_rs;	/* prev in rate table cmd */
-};
-
-
 /*
  * These serve as indexes into
  * struct iwl_rate_info iwl_rates[IWL_RATE_COUNT];
@@ -75,7 +61,6 @@ enum {
 	IWL_RATE_60M_INDEX,
 	IWL_RATE_COUNT, /*FIXME:RS:change to IWL_RATE_INDEX_COUNT,*/
 	IWL_RATE_COUNT_LEGACY = IWL_RATE_COUNT - 1,	/* Excluding 60M */
-	IWL_RATE_COUNT_3945 = IWL_RATE_COUNT - 1,
 	IWL_RATE_INVM_INDEX = IWL_RATE_COUNT,
 	IWL_RATE_INVALID = IWL_RATE_COUNT,
 };
@@ -213,7 +198,6 @@ enum {
 	 IWL_CCK_BASIC_RATES_MASK)
 
 #define IWL_RATES_MASK ((1 << IWL_RATE_COUNT) - 1)
-#define IWL_RATES_MASK_3945 ((1 << IWL_RATE_COUNT_3945) - 1)
 
 #define IWL_INVALID_VALUE    -1
 
@@ -453,19 +437,9 @@ static inline u8 first_antenna(u8 mask)
 }
 
 
-/**
- * iwl3945_rate_scale_init - Initialize the rate scale table based on assoc info
- *
- * The specific throughput table used is based on the type of network
- * the associated with, including A, B, G, and G w/ TGG protection
- */
-extern void iwl3945_rate_scale_init(struct ieee80211_hw *hw, s32 sta_id);
-
 /* Initialize station's rate scaling information after adding station */
 extern void iwl_rs_rate_init(struct iwl_priv *priv,
 			     struct ieee80211_sta *sta, u8 sta_id);
-extern void iwl3945_rs_rate_init(struct iwl_priv *priv,
-				 struct ieee80211_sta *sta, u8 sta_id);
 
 /**
  * iwl_rate_control_register - Register the rate control algorithm callbacks
@@ -478,7 +452,6 @@ extern void iwl3945_rs_rate_init(struct iwl_priv *priv,
  *
  */
 extern int iwlagn_rate_control_register(void);
-extern int iwl3945_rate_control_register(void);
 
 /**
  * iwl_rate_control_unregister - Unregister the rate control callbacks
@@ -487,6 +460,5 @@ extern int iwl3945_rate_control_register(void);
  * the driver is unloaded.
  */
 extern void iwlagn_rate_control_unregister(void);
-extern void iwl3945_rate_control_unregister(void);
 
 #endif /* __iwl_agn__rs__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
index 35f085a..3782fe8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
@@ -474,7 +474,7 @@ int iwl_remove_dynamic_key(struct iwl_priv *priv,
 	memset(&priv->stations[sta_id].keyinfo, 0,
 					sizeof(struct iwl_hw_key));
 	memset(&priv->stations[sta_id].sta.key, 0,
-					sizeof(struct iwl4965_keyinfo));
+					sizeof(struct iwl_keyinfo));
 	priv->stations[sta_id].sta.key.key_flags =
 			STA_KEY_FLG_NO_ENC | STA_KEY_FLG_INVALID;
 	priv->stations[sta_id].sta.key.key_offset = WEP_INVALID_OFFSET;
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 39313ac..80de8a1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -66,7 +66,6 @@
 #include "iwl-dev.h"
 
 /* configuration for the _agn devices */
-extern struct iwl_cfg iwl4965_agn_cfg;
 extern struct iwl_cfg iwl5300_agn_cfg;
 extern struct iwl_cfg iwl5100_agn_cfg;
 extern struct iwl_cfg iwl5350_agn_cfg;
@@ -114,7 +113,6 @@ extern struct iwl_hcmd_ops iwlagn_bt_hcmd;
 extern struct iwl_hcmd_utils_ops iwlagn_hcmd_utils;
 
 extern struct ieee80211_ops iwlagn_hw_ops;
-extern struct ieee80211_ops iwl4965_hw_ops;
 
 int iwl_reset_ict(struct iwl_priv *priv);
 void iwl_disable_ict(struct iwl_priv *priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index cc21514..e605843 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -103,9 +103,7 @@ enum {
 	REPLY_WEPKEY = 0x20,
 
 	/* RX, TX, LEDs */
-	REPLY_3945_RX = 0x1b,           /* 3945 only */
 	REPLY_TX = 0x1c,
-	REPLY_RATE_SCALE = 0x47,	/* 3945 only */
 	REPLY_LEDS_CMD = 0x48,
 	REPLY_TX_LINK_QUALITY_CMD = 0x4e, /* for 4965 and up */
 
@@ -229,7 +227,7 @@ struct iwl_cmd_header {
 	 * There is one exception:  uCode sets bit 15 when it originates
 	 * the response/notification, i.e. when the response/notification
 	 * is not a direct response to a command sent by the driver.  For
-	 * example, uCode issues REPLY_3945_RX when it sends a received frame
+	 * example, uCode issues REPLY_RX when it sends a received frame
 	 * to the driver; it is not a direct response to any driver command.
 	 *
 	 * The Linux driver uses the following format:
@@ -249,36 +247,6 @@ struct iwl_cmd_header {
 
 
 /**
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
-} __packed;
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
-} __packed;
-
-/**
  * iwlagn rate_n_flags bit fields
  *
  * rate_n_flags format is used in following iwlagn commands:
@@ -377,30 +345,6 @@ struct iwl3945_power_per_rate {
 #define IWL_PWR_CCK_ENTRIES			2
 
 /**
- * union iwl4965_tx_power_dual_stream
- *
- * Host format used for REPLY_TX_PWR_TABLE_CMD, REPLY_CHANNEL_SWITCH
- * Use __le32 version (struct tx_power_dual_stream) when building command.
- *
- * Driver provides radio gain and DSP attenuation settings to device in pairs,
- * one value for each transmitter chain.  The first value is for transmitter A,
- * second for transmitter B.
- *
- * For SISO bit rates, both values in a pair should be identical.
- * For MIMO rates, one value may be different from the other,
- * in order to balance the Tx output between the two transmitters.
- *
- * See more details in doc for TXPOWER in iwl-4965-hw.h.
- */
-union iwl4965_tx_power_dual_stream {
-	struct {
-		u8 radio_tx_gain[2];
-		u8 dsp_predis_atten[2];
-	} s;
-	u32 dw;
-};
-
-/**
  * struct tx_power_dual_stream
  *
  * Table entries in REPLY_TX_PWR_TABLE_CMD, REPLY_CHANNEL_SWITCH
@@ -412,15 +356,6 @@ struct tx_power_dual_stream {
 } __packed;
 
 /**
- * struct iwl4965_tx_power_db
- *
- * Entire table within REPLY_TX_PWR_TABLE_CMD, REPLY_CHANNEL_SWITCH
- */
-struct iwl4965_tx_power_db {
-	struct tx_power_dual_stream power_tbl[POWER_TABLE_NUM_ENTRIES];
-} __packed;
-
-/**
  * Command REPLY_TX_POWER_DBM_CMD = 0x98
  * struct iwlagn_tx_power_dbm_cmd
  */
@@ -724,46 +659,6 @@ enum {
  *        regardless of whether RXON_FILTER_ASSOC_MSK is set.
  */
 
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
-} __packed;
-
-struct iwl4965_rxon_cmd {
-	u8 node_addr[6];
-	__le16 reserved1;
-	u8 bssid_addr[6];
-	__le16 reserved2;
-	u8 wlap_bssid_addr[6];
-	__le16 reserved3;
-	u8 dev_type;
-	u8 air_propagation;
-	__le16 rx_chain;
-	u8 ofdm_basic_rates;
-	u8 cck_basic_rates;
-	__le16 assoc_id;
-	__le32 flags;
-	__le32 filter_flags;
-	__le16 channel;
-	u8 ofdm_ht_single_stream_basic_rates;
-	u8 ofdm_ht_dual_stream_basic_rates;
-} __packed;
-
-/* 5000 HW just extend this command */
 struct iwl_rxon_cmd {
 	u8 node_addr[6];
 	__le16 reserved1;
@@ -791,25 +686,6 @@ struct iwl_rxon_cmd {
 /*
  * REPLY_RXON_ASSOC = 0x11 (command, has simple generic response)
  */
-struct iwl3945_rxon_assoc_cmd {
-	__le32 flags;
-	__le32 filter_flags;
-	u8 ofdm_basic_rates;
-	u8 cck_basic_rates;
-	__le16 reserved;
-} __packed;
-
-struct iwl4965_rxon_assoc_cmd {
-	__le32 flags;
-	__le32 filter_flags;
-	u8 ofdm_basic_rates;
-	u8 cck_basic_rates;
-	u8 ofdm_ht_single_stream_basic_rates;
-	u8 ofdm_ht_dual_stream_basic_rates;
-	__le16 rx_chain_select_flags;
-	__le16 reserved;
-} __packed;
-
 struct iwl5000_rxon_assoc_cmd {
 	__le32 flags;
 	__le32 filter_flags;
@@ -845,26 +721,6 @@ struct iwl_rxon_time_cmd {
 /*
  * REPLY_CHANNEL_SWITCH = 0x72 (command, has simple generic response)
  */
-struct iwl3945_channel_switch_cmd {
-	u8 band;
-	u8 expect_beacon;
-	__le16 channel;
-	__le32 rxon_flags;
-	__le32 rxon_filter_flags;
-	__le32 switch_time;
-	struct iwl3945_power_per_rate power[IWL_MAX_RATES];
-} __packed;
-
-struct iwl4965_channel_switch_cmd {
-	u8 band;
-	u8 expect_beacon;
-	__le16 channel;
-	__le32 rxon_flags;
-	__le32 rxon_filter_flags;
-	__le32 switch_time;
-	struct iwl4965_tx_power_db tx_power;
-} __packed;
-
 /**
  * struct iwl5000_channel_switch_cmd
  * @band: 0- 5.2GHz, 1- 2.4GHz
@@ -978,15 +834,10 @@ struct iwl_qosparam_cmd {
 #define	IWL_AP_ID		0
 #define	IWL_AP_ID_PAN		1
 #define	IWL_STA_ID		2
-#define	IWL3945_BROADCAST_ID	24
-#define IWL3945_STATION_COUNT	25
-#define IWL4965_BROADCAST_ID	31
-#define	IWL4965_STATION_COUNT	32
 #define IWLAGN_PAN_BCAST_ID	14
 #define IWLAGN_BROADCAST_ID	15
 #define	IWLAGN_STATION_COUNT	16
 
-#define	IWL_STATION_COUNT	32 	/* MAX(3945,4965)*/
 #define	IWL_INVALID_STATION 	255
 
 #define STA_FLG_TX_RATE_MSK		cpu_to_le32(1 << 2)
@@ -1034,16 +885,6 @@ struct iwl_qosparam_cmd {
  * combined with Traffic ID (QOS priority), in format used by Tx Scheduler */
 #define BUILD_RAxTID(sta_id, tid)	(((sta_id) << 4) + (tid))
 
-struct iwl4965_keyinfo {
-	__le16 key_flags;
-	u8 tkip_rx_tsc_byte2;	/* TSC[2] for key mix ph1 detection */
-	u8 reserved1;
-	__le16 tkip_rx_ttak[5];	/* 10-byte unicast TKIP TTAK */
-	u8 key_offset;
-	u8 reserved2;
-	u8 key[16];		/* 16-byte unicast decryption key */
-} __packed;
-
 /* agn */
 struct iwl_keyinfo {
 	__le16 key_flags;
@@ -1085,7 +926,6 @@ struct sta_id_modify {
  * with info on security keys, aggregation parameters, and Tx rates for
  * initial Tx attempt and any retries (agn devices uses
  * REPLY_TX_LINK_QUALITY_CMD,
- * 3945 uses REPLY_RATE_SCALE to set up rate tables).
  *
  * REPLY_ADD_STA sets up the table entry for one station, either creating
  * a new entry, or modifying a pre-existing one.
@@ -1105,72 +945,6 @@ struct sta_id_modify {
  *        entries for all STAs in network, starting with index IWL_STA_ID.
  */
 
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
-} __packed;
-
-struct iwl4965_addsta_cmd {
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
-	__le16	reserved1;
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
-
-	/*
-	 * Number of packets OK to transmit to station even though
-	 * it is asleep -- used to synchronise PS-poll and u-APSD
-	 * responses while ucode keeps track of STA sleep state.
-	 */
-	__le16 sleep_tx_count;
-
-	__le16 reserved2;
-} __packed;
-
-/* agn */
 struct iwl_addsta_cmd {
 	u8 mode;		/* 1: modify existing, 0: add new station */
 	u8 reserved[3];
@@ -1339,62 +1113,6 @@ struct iwl_wep_cmd {
 #define RX_MPDU_RES_STATUS_DEC_DONE_MSK	(0x800)
 
 
-struct iwl3945_rx_frame_stats {
-	u8 phy_count;
-	u8 id;
-	u8 rssi;
-	u8 agc;
-	__le16 sig_avg;
-	__le16 noise_diff;
-	u8 payload[0];
-} __packed;
-
-struct iwl3945_rx_frame_hdr {
-	__le16 channel;
-	__le16 phy_flags;
-	u8 reserved1;
-	u8 rate;
-	__le16 len;
-	u8 payload[0];
-} __packed;
-
-struct iwl3945_rx_frame_end {
-	__le32 status;
-	__le64 timestamp;
-	__le32 beacon_timestamp;
-} __packed;
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
-} __packed;
-
-#define IWL39_RX_FRAME_SIZE	(4 + sizeof(struct iwl3945_rx_frame))
-
-/* Fixed (non-configurable) rx data from phy */
-
-#define IWL49_RX_RES_PHY_CNT 14
-#define IWL49_RX_PHY_FLAGS_ANTENNAE_OFFSET	(4)
-#define IWL49_RX_PHY_FLAGS_ANTENNAE_MASK	(0x70)
-#define IWL49_AGC_DB_MASK			(0x3f80)	/* MASK(7,13) */
-#define IWL49_AGC_DB_POS			(7)
-struct iwl4965_rx_non_cfg_phy {
-	__le16 ant_selection;	/* ant A bit 4, ant B bit 5, ant C bit 6 */
-	__le16 agc_info;	/* agc code 0:6, agc dB 7:13, reserved 14:15 */
-	u8 rssi_info[6];	/* we use even entries, 0/2/4 for A/B/C rssi */
-	u8 pad[0];
-} __packed;
-
-
 #define IWLAGN_RX_RES_PHY_CNT 8
 #define IWLAGN_RX_RES_AGC_IDX     1
 #define IWLAGN_RX_RES_RSSI_AB_IDX 2
@@ -1578,80 +1296,6 @@ struct iwl_rx_mpdu_res_start {
  * REPLY_TX = 0x1c (command)
  */
 
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
-} __packed;
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
-} __packed;
-
-
 /*
  * 4965 uCode updates these Tx attempt count values in host DRAM.
  * Used for managing Tx retries when expecting block-acks.
@@ -1742,54 +1386,6 @@ struct iwl_tx_cmd {
 	struct ieee80211_hdr hdr[0];
 } __packed;
 
-/* TX command response is sent after *3945* transmission attempts.
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
-	TX_3945_STATUS_SUCCESS = 0x01,
-	TX_3945_STATUS_DIRECT_DONE = 0x02,
-	TX_3945_STATUS_FAIL_SHORT_LIMIT = 0x82,
-	TX_3945_STATUS_FAIL_LONG_LIMIT = 0x83,
-	TX_3945_STATUS_FAIL_FIFO_UNDERRUN = 0x84,
-	TX_3945_STATUS_FAIL_MGMNT_ABORT = 0x85,
-	TX_3945_STATUS_FAIL_NEXT_FRAG = 0x86,
-	TX_3945_STATUS_FAIL_LIFE_EXPIRE = 0x87,
-	TX_3945_STATUS_FAIL_DEST_PS = 0x88,
-	TX_3945_STATUS_FAIL_ABORTED = 0x89,
-	TX_3945_STATUS_FAIL_BT_RETRY = 0x8a,
-	TX_3945_STATUS_FAIL_STA_INVALID = 0x8b,
-	TX_3945_STATUS_FAIL_FRAG_DROPPED = 0x8c,
-	TX_3945_STATUS_FAIL_TID_DISABLE = 0x8d,
-	TX_3945_STATUS_FAIL_FRAME_FLUSHED = 0x8e,
-	TX_3945_STATUS_FAIL_INSUFFICIENT_CF_POLL = 0x8f,
-	TX_3945_STATUS_FAIL_TX_LOCKED = 0x90,
-	TX_3945_STATUS_FAIL_NO_BEACON_ON_RADAR = 0x91,
-};
-
 /*
  * TX command response is sent after *agn* transmission attempts.
  *
@@ -1907,43 +1503,6 @@ struct agg_tx_status {
 	__le16 sequence;
 } __packed;
 
-struct iwl4965_tx_resp {
-	u8 frame_count;		/* 1 no aggregation, >1 aggregation */
-	u8 bt_kill_count;	/* # blocked by bluetooth (unused for agg) */
-	u8 failure_rts;		/* # failures due to unsuccessful RTS */
-	u8 failure_frame;	/* # failures due to no ACK (unused for agg) */
-
-	/* For non-agg:  Rate at which frame was successful.
-	 * For agg:  Rate at which all frames were transmitted. */
-	__le32 rate_n_flags;	/* RATE_MCS_*  */
-
-	/* For non-agg:  RTS + CTS + frame tx attempts time + ACK.
-	 * For agg:  RTS + CTS + aggregation tx time + block-ack time. */
-	__le16 wireless_media_time;	/* uSecs */
-
-	__le16 reserved;
-	__le32 pa_power1;	/* RF power amplifier measurement (not used) */
-	__le32 pa_power2;
-
-	/*
-	 * For non-agg:  frame status TX_STATUS_*
-	 * For agg:  status of 1st frame, AGG_TX_STATE_*; other frame status
-	 *           fields follow this one, up to frame_count.
-	 *           Bit fields:
-	 *           11- 0:  AGG_TX_STATE_* status code
-	 *           15-12:  Retry count for 1st frame in aggregation (retries
-	 *                   occur if tx failed for this frame when it was a
-	 *                   member of a previous aggregation block).  If rate
-	 *                   scaling is used, retry count indicates the rate
-	 *                   table entry used for all frames in the new agg.
-	 *           31-16:  Sequence # for this frame's Tx cmd (not SSN!)
-	 */
-	union {
-		__le32 status;
-		struct agg_tx_status agg_status[0]; /* for each agg frame */
-	} u;
-} __packed;
-
 /*
  * definitions for initial rate index field
  * bits [3:0] initial rate index
@@ -2032,52 +1591,8 @@ struct iwl_compressed_ba_resp {
 /*
  * REPLY_TX_PWR_TABLE_CMD = 0x97 (command, has simple generic response)
  *
- * See details under "TXPOWER" in iwl-4965-hw.h.
  */
 
-struct iwl3945_txpowertable_cmd {
-	u8 band;		/* 0: 5 GHz, 1: 2.4 GHz */
-	u8 reserved;
-	__le16 channel;
-	struct iwl3945_power_per_rate power[IWL_MAX_RATES];
-} __packed;
-
-struct iwl4965_txpowertable_cmd {
-	u8 band;		/* 0: 5 GHz, 1: 2.4 GHz */
-	u8 reserved;
-	__le16 channel;
-	struct iwl4965_tx_power_db tx_power;
-} __packed;
-
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
-struct iwl3945_rate_scaling_info {
-	__le16 rate_n_flags;
-	u8 try_cnt;
-	u8 next_rate_index;
-} __packed;
-
-struct iwl3945_rate_scaling_cmd {
-	u8 table_id;
-	u8 reserved[3];
-	struct iwl3945_rate_scaling_info table[IWL_MAX_RATES];
-} __packed;
-
-
 /*RS_NEW_API: only TLC_RTS remains and moved to bit 0 */
 #define  LINK_QUAL_FLAGS_SET_STA_TLC_RTS_MSK	(1 << 0)
 
@@ -2698,14 +2213,6 @@ struct iwl_spectrum_notification {
 #define IWL_POWER_BT_SCO_ENA			cpu_to_le16(BIT(8))
 #define IWL_POWER_ADVANCE_PM_ENA_MSK		cpu_to_le16(BIT(9))
 
-struct iwl3945_powertable_cmd {
-	__le16 flags;
-	u8 reserved[2];
-	__le32 rx_data_timeout;
-	__le32 tx_data_timeout;
-	__le32 sleep_interval[IWL_POWER_VEC_SIZE];
-} __packed;
-
 struct iwl_powertable_cmd {
 	__le16 flags;
 	u8 keep_alive_seconds;		/* 3945 reserved */
@@ -2808,25 +2315,6 @@ struct iwl_ct_kill_throttling_config {
  *     active_dwell < max_out_time
  */
 
-/* FIXME: rename to AP1, remove tpc */
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
-} __packed;
-
-/* set number of direct probes u8 type */
-#define IWL39_SCAN_PROBE_MASK(n) ((BIT(n) | (BIT(n) - BIT(1))))
-
 struct iwl_scan_channel {
 	/*
 	 * type is defined as:
@@ -2922,50 +2410,6 @@ struct iwl_ssid_ie {
  * struct iwl_scan_channel.
  */
 
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
-	struct iwl_ssid_ie direct_scan[PROBE_OPTION_MAX_3945];
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
-} __packed;
-
 enum iwl_scan_flags {
 	/* BIT(0) currently unused */
 	IWL_SCAN_FLAGS_ACTION_FRAME_TX	= BIT(1),
@@ -3092,20 +2536,6 @@ enum iwl_ibss_manager {
  * BEACON_NOTIFICATION = 0x90 (notification only, not a command)
  */
 
-struct iwl3945_beacon_notif {
-	struct iwl3945_tx_resp beacon_notify_hdr;
-	__le32 low_tsf;
-	__le32 high_tsf;
-	__le32 ibss_mgr_status;
-} __packed;
-
-struct iwl4965_beacon_notif {
-	struct iwl4965_tx_resp beacon_notify_hdr;
-	__le32 low_tsf;
-	__le32 high_tsf;
-	__le32 ibss_mgr_status;
-} __packed;
-
 struct iwlagn_beacon_notif {
 	struct iwlagn_tx_resp beacon_notify_hdr;
 	__le32 low_tsf;
@@ -3117,14 +2547,6 @@ struct iwlagn_beacon_notif {
  * REPLY_TX_BEACON = 0x91 (command, has simple generic response)
  */
 
-struct iwl3945_tx_beacon_cmd {
-	struct iwl3945_tx_cmd tx;
-	__le16 tim_idx;
-	u8 tim_size;
-	u8 reserved1;
-	struct ieee80211_hdr frame[0];	/* beacon frame */
-} __packed;
-
 struct iwl_tx_beacon_cmd {
 	struct iwl_tx_cmd tx;
 	__le16 tim_idx;
@@ -3473,13 +2895,6 @@ struct iwl_statistics_cmd {
 #define STATISTICS_REPLY_FLG_BAND_24G_MSK         cpu_to_le32(0x2)
 #define STATISTICS_REPLY_FLG_HT40_MODE_MSK        cpu_to_le32(0x8)
 
-struct iwl3945_notif_statistics {
-	__le32 flag;
-	struct iwl39_statistics_rx rx;
-	struct iwl39_statistics_tx tx;
-	struct iwl39_statistics_general general;
-} __packed;
-
 struct iwl_notif_statistics {
 	__le32 flag;
 	struct statistics_rx rx;
@@ -4453,10 +3868,6 @@ struct iwl_rx_packet {
 	__le32 len_n_flags;
 	struct iwl_cmd_header hdr;
 	union {
-		struct iwl3945_rx_frame rx_frame;
-		struct iwl3945_tx_resp tx_resp;
-		struct iwl3945_beacon_notif beacon_status;
-
 		struct iwl_alive_resp alive_frame;
 		struct iwl_spectrum_notification spectrum_notif;
 		struct iwl_csa_notification csa_notif;
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 6c30fa6..d778f52 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1430,7 +1430,6 @@ void iwl_mac_remove_interface(struct ieee80211_hw *hw,
 
 	iwl_teardown_interface(priv, vif, false);
 
-	memset(priv->bssid, 0, ETH_ALEN);
 	mutex_unlock(&priv->mutex);
 
 	IWL_DEBUG_MAC80211(priv, "leave\n");
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index a5d438d..70f1785 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -26,7 +26,6 @@
 /*
  * Please use this file (iwl-dev.h) for driver implementation definitions.
  * Please use iwl-commands.h for uCode API definitions.
- * Please use iwl-4965-hw.h for hardware-related definitions.
  */
 
 #ifndef __iwl_dev_h__
@@ -179,53 +178,12 @@ struct iwl_tx_queue {
 
 #define IWL_NUM_SCAN_RATES         (2)
 
-struct iwl4965_channel_tgd_info {
-	u8 type;
-	s8 max_power;
-};
-
-struct iwl4965_channel_tgh_info {
-	s64 last_radar_time;
-};
-
-#define IWL4965_MAX_RATE (33)
-
-struct iwl3945_clip_group {
-	/* maximum power level to prevent clipping for each rate, derived by
-	 *   us from this band's saturation power in EEPROM */
-	const s8 clip_powers[IWL_MAX_RATES];
-};
-
-/* current Tx power values to use, one for each rate for each channel.
- * requested power is limited by:
- * -- regulatory EEPROM limits for this channel
- * -- hardware capabilities (clip-powers)
- * -- spectrum management
- * -- user preference (e.g. iwconfig)
- * when requested power is set, base power index must also be set. */
-struct iwl3945_channel_power_info {
-	struct iwl3945_tx_power tpc;	/* actual radio and DSP gain settings */
-	s8 power_table_index;	/* actual (compenst'd) index into gain table */
-	s8 base_power_index;	/* gain index for power at factory temp. */
-	s8 requested_power;	/* power (dBm) requested for this chnl/rate */
-};
-
-/* current scan Tx power values to use, one for each scan rate for each
- * channel. */
-struct iwl3945_scan_power_info {
-	struct iwl3945_tx_power tpc;	/* actual radio and DSP gain settings */
-	s8 power_table_index;	/* actual (compenst'd) index into gain table */
-	s8 requested_power;	/* scan pwr (dBm) requested for chnl/rate */
-};
-
 /*
  * One for each channel, holds all channel setup data
  * Some of the fields (e.g. eeprom and flags/max_power_avg) are redundant
  *     with one another!
  */
 struct iwl_channel_info {
-	struct iwl4965_channel_tgd_info tgd;
-	struct iwl4965_channel_tgh_info tgh;
 	struct iwl_eeprom_channel eeprom;	/* EEPROM regulatory limit */
 	struct iwl_eeprom_channel ht40_eeprom;	/* EEPROM regulatory limit for
 						 * HT40 channel */
@@ -245,14 +203,6 @@ struct iwl_channel_info {
 	s8 ht40_max_power_avg;	/* (dBm) regul. eeprom, normal Tx, any rate */
 	u8 ht40_flags;		/* flags copied from EEPROM */
 	u8 ht40_extension_channel; /* HT_IE_EXT_CHANNEL_* */
-
-	/* Radio/DSP gain settings for each "normal" data Tx rate.
-	 * These include, in addition to RF and DSP gain, a few fields for
-	 *   remembering/modifying gain settings (indexes). */
-	struct iwl3945_channel_power_info power_info[IWL4965_MAX_RATE];
-
-	/* Radio/DSP gain settings for each scan rate, for directed scans. */
-	struct iwl3945_scan_power_info scan_pwr_info[IWL_NUM_SCAN_RATES];
 };
 
 #define IWL_TX_FIFO_BK		0	/* shared */
@@ -500,9 +450,6 @@ struct iwl_station_priv_common {
  * When mac80211 creates a station it reserves some space (hw->sta_data_size)
  * in the structure for use by driver. This structure is places in that
  * space.
- *
- * The common struct MUST be first because it is shared between
- * 3945 and agn!
  */
 struct iwl_station_priv {
 	struct iwl_station_priv_common common;
@@ -620,14 +567,6 @@ struct iwl_tlv_ucode_header {
 	u8 data[0];
 };
 
-struct iwl4965_ibss_seq {
-	u8 mac[ETH_ALEN];
-	u16 seq_num;
-	u16 frag_num;
-	unsigned long packet_time;
-	struct list_head list;
-};
-
 struct iwl_sensitivity_ranges {
 	u16 min_nrg_cck;
 	u16 max_nrg_cck;
@@ -723,8 +662,6 @@ struct iwl_hw_params {
  * Naming convention --
  * iwl_         <-- Is part of iwlwifi
  * iwlXXXX_     <-- Hardware specific (implemented in iwl-XXXX.c for XXXX)
- * iwl4965_bg_      <-- Called from work queue context
- * iwl4965_mac_     <-- mac80211 callback
  *
  ****************************************************************************/
 extern void iwl_update_chain_flags(struct iwl_priv *priv);
@@ -773,7 +710,6 @@ struct iwl_dma_ptr {
 
 /* Sensitivity and chain noise calibration */
 #define INITIALIZATION_VALUE		0xFFFF
-#define IWL4965_CAL_NUM_BEACONS		20
 #define IWL_CAL_NUM_BEACONS		16
 #define MAXIMUM_ALLOWED_PATHLOSS	15
 
@@ -807,24 +743,19 @@ struct iwl_dma_ptr {
 #define NRG_NUM_PREV_STAT_L     20
 #define NUM_RX_CHAINS           3
 
-enum iwl4965_false_alarm_state {
+enum iwlagn_false_alarm_state {
 	IWL_FA_TOO_MANY = 0,
 	IWL_FA_TOO_FEW = 1,
 	IWL_FA_GOOD_RANGE = 2,
 };
 
-enum iwl4965_chain_noise_state {
+enum iwlagn_chain_noise_state {
 	IWL_CHAIN_NOISE_ALIVE = 0,  /* must be 0 */
 	IWL_CHAIN_NOISE_ACCUMULATE,
 	IWL_CHAIN_NOISE_CALIBRATED,
 	IWL_CHAIN_NOISE_DONE,
 };
 
-enum iwl4965_calib_enabled_state {
-	IWL_CALIB_DISABLED = 0,  /* must be 0 */
-	IWL_CALIB_ENABLED = 1,
-};
-
 
 /*
  * enum iwl_calib
@@ -1132,12 +1063,6 @@ struct iwl_force_reset {
 
 /* extend beacon time format bit shifting  */
 /*
- * for _3945 devices
- * bits 31:24 - extended
- * bits 23:0  - interval
- */
-#define IWL3945_EXT_BEACON_TIME_POS	24
-/*
  * for _agn devices
  * bits 31:22 - extended
  * bits 21:0  - interval
@@ -1391,15 +1316,12 @@ struct iwl_priv {
 	struct iwl_power_mgr power_data;
 	struct iwl_tt_mgmt thermal_throttle;
 
-	/* context information */
-	u8 bssid[ETH_ALEN]; /* used only on 3945 but filled by core */
-
 	/* station table variables */
 
 	/* Note: if lock and sta_lock are needed, lock must be acquired first */
 	spinlock_t sta_lock;
 	int num_stations;
-	struct iwl_station_entry stations[IWL_STATION_COUNT];
+	struct iwl_station_entry stations[IWLAGN_STATION_COUNT];
 	unsigned long ucode_key_table;
 
 	/* queue refcounts */
@@ -1423,101 +1345,66 @@ struct iwl_priv {
 	/* Last Rx'd beacon timestamp */
 	u64 timestamp;
 
-	union {
-#if defined(CONFIG_IWL3945) || defined(CONFIG_IWL3945_MODULE)
-		struct {
-			void *shared_virt;
-			dma_addr_t shared_phys;
-
-			struct delayed_work thermal_periodic;
-			struct delayed_work rfkill_poll;
-
-			struct iwl3945_notif_statistics statistics;
-#ifdef CONFIG_IWLWIFI_DEBUGFS
-			struct iwl3945_notif_statistics accum_statistics;
-			struct iwl3945_notif_statistics delta_statistics;
-			struct iwl3945_notif_statistics max_delta;
-#endif
-
-			u32 sta_supp_rates;
-			int last_rx_rssi;	/* From Rx packet statistics */
-
-			/* Rx'd packet timing information */
-			u32 last_beacon_time;
-			u64 last_tsf;
-
-			/*
-			 * each calibration channel group in the
-			 * EEPROM has a derived clip setting for
-			 * each rate.
-			 */
-			const struct iwl3945_clip_group clip_groups[5];
-
-		} _3945;
-#endif
-#if defined(CONFIG_IWLAGN) || defined(CONFIG_IWLAGN_MODULE)
-		struct {
-			/* INT ICT Table */
-			__le32 *ict_tbl;
-			void *ict_tbl_vir;
-			dma_addr_t ict_tbl_dma;
-			dma_addr_t aligned_ict_tbl_dma;
-			int ict_index;
-			u32 inta;
-			bool use_ict;
-			/*
-			 * reporting the number of tids has AGG on. 0 means
-			 * no AGGREGATION
-			 */
-			u8 agg_tids_count;
-
-			struct iwl_rx_phy_res last_phy_res;
-			bool last_phy_res_valid;
-
-			struct completion firmware_loading_complete;
-
-			u32 init_evtlog_ptr, init_evtlog_size, init_errlog_ptr;
-			u32 inst_evtlog_ptr, inst_evtlog_size, inst_errlog_ptr;
-
-			/*
-			 * chain noise reset and gain commands are the
-			 * two extra calibration commands follows the standard
-			 * phy calibration commands
-			 */
-			u8 phy_calib_chain_noise_reset_cmd;
-			u8 phy_calib_chain_noise_gain_cmd;
-
-			struct iwl_notif_statistics statistics;
-			struct iwl_bt_notif_statistics statistics_bt;
-			/* counts reply_tx error */
-			struct reply_tx_error_statistics reply_tx_stats;
-			struct reply_agg_tx_error_statistics reply_agg_tx_stats;
+	struct {
+		/* INT ICT Table */
+		__le32 *ict_tbl;
+		void *ict_tbl_vir;
+		dma_addr_t ict_tbl_dma;
+		dma_addr_t aligned_ict_tbl_dma;
+		int ict_index;
+		u32 inta;
+		bool use_ict;
+		/*
+		 * reporting the number of tids has AGG on. 0 means
+		 * no AGGREGATION
+		 */
+		u8 agg_tids_count;
+
+		struct iwl_rx_phy_res last_phy_res;
+		bool last_phy_res_valid;
+
+		struct completion firmware_loading_complete;
+
+		u32 init_evtlog_ptr, init_evtlog_size, init_errlog_ptr;
+		u32 inst_evtlog_ptr, inst_evtlog_size, inst_errlog_ptr;
+
+		/*
+		 * chain noise reset and gain commands are the
+		 * two extra calibration commands follows the standard
+		 * phy calibration commands
+		 */
+		u8 phy_calib_chain_noise_reset_cmd;
+		u8 phy_calib_chain_noise_gain_cmd;
+
+		struct iwl_notif_statistics statistics;
+		struct iwl_bt_notif_statistics statistics_bt;
+		/* counts reply_tx error */
+		struct reply_tx_error_statistics reply_tx_stats;
+		struct reply_agg_tx_error_statistics reply_agg_tx_stats;
 #ifdef CONFIG_IWLWIFI_DEBUGFS
-			struct iwl_notif_statistics accum_statistics;
-			struct iwl_notif_statistics delta_statistics;
-			struct iwl_notif_statistics max_delta;
-			struct iwl_bt_notif_statistics accum_statistics_bt;
-			struct iwl_bt_notif_statistics delta_statistics_bt;
-			struct iwl_bt_notif_statistics max_delta_bt;
-#endif
-
-			/* notification wait support */
-			struct list_head notif_waits;
-			spinlock_t notif_wait_lock;
-			wait_queue_head_t notif_waitq;
-
-			/* remain-on-channel offload support */
-			struct ieee80211_channel *hw_roc_channel;
-			struct delayed_work hw_roc_work;
-			enum nl80211_channel_type hw_roc_chantype;
-			int hw_roc_duration;
-
-			struct sk_buff *offchan_tx_skb;
-			int offchan_tx_timeout;
-			struct ieee80211_channel *offchan_tx_chan;
-		} _agn;
+		struct iwl_notif_statistics accum_statistics;
+		struct iwl_notif_statistics delta_statistics;
+		struct iwl_notif_statistics max_delta;
+		struct iwl_bt_notif_statistics accum_statistics_bt;
+		struct iwl_bt_notif_statistics delta_statistics_bt;
+		struct iwl_bt_notif_statistics max_delta_bt;
 #endif
-	};
+		/* notification wait support */
+		struct list_head notif_waits;
+		spinlock_t notif_wait_lock;
+		wait_queue_head_t notif_waitq;
+
+		/* remain-on-channel offload support */
+		struct ieee80211_channel *hw_roc_channel;
+		struct delayed_work hw_roc_work;
+		enum nl80211_channel_type hw_roc_chantype;
+		int hw_roc_duration;
+		bool hw_roc_setup;
+
+		struct sk_buff *offchan_tx_skb;
+		int offchan_tx_timeout;
+		struct ieee80211_channel *offchan_tx_chan;
+	} _agn;
 
 	/* bt coex */
 	u8 bt_enable_flag;
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.h b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
index 98aa8af..d0f858a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.h
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
@@ -110,10 +110,6 @@ enum {
 };
 
 /* SKU Capabilities */
-/* 3945 only */
-#define EEPROM_SKU_CAP_SW_RF_KILL_ENABLE                (1 << 0)
-#define EEPROM_SKU_CAP_HW_RF_KILL_ENABLE                (1 << 1)
-
 /* 5000 and up */
 #define EEPROM_SKU_CAP_BAND_POS				(4)
 #define EEPROM_SKU_CAP_BAND_SELECTION	                \
@@ -168,28 +164,6 @@ struct iwl_eeprom_enhanced_txpwr {
 	s8 mimo3_max;
 } __packed;
 
-/* 3945 Specific */
-#define EEPROM_3945_EEPROM_VERSION	(0x2f)
-
-/* 4965 has two radio transmitters (and 3 radio receivers) */
-#define EEPROM_TX_POWER_TX_CHAINS      (2)
-
-/* 4965 has room for up to 8 sets of txpower calibration data */
-#define EEPROM_TX_POWER_BANDS          (8)
-
-/* 4965 factory calibration measures txpower gain settings for
- * each of 3 target output levels */
-#define EEPROM_TX_POWER_MEASUREMENTS   (3)
-
-/* 4965 Specific */
-/* 4965 driver does not work with txpower calibration version < 5 */
-#define EEPROM_4965_TX_POWER_VERSION    (5)
-#define EEPROM_4965_EEPROM_VERSION	(0x2f)
-#define EEPROM_4965_CALIB_VERSION_OFFSET       (2*0xB6) /* 2 bytes */
-#define EEPROM_4965_CALIB_TXPOWER_OFFSET       (2*0xE8) /* 48  bytes */
-#define EEPROM_4965_BOARD_REVISION             (2*0x4F) /* 2 bytes */
-#define EEPROM_4965_BOARD_PBA                  (2*0x56+1) /* 9 bytes */
-
 /* 5000 Specific */
 #define EEPROM_5000_TX_POWER_VERSION    (4)
 #define EEPROM_5000_EEPROM_VERSION	(0x11A)
@@ -282,90 +256,6 @@ struct iwl_eeprom_enhanced_txpwr {
 /* 2.4 GHz */
 extern const u8 iwl_eeprom_band_1[14];
 
-/*
- * factory calibration data for one txpower level, on one channel,
- * measured on one of the 2 tx chains (radio transmitter and associated
- * antenna).  EEPROM contains:
- *
- * 1)  Temperature (degrees Celsius) of device when measurement was made.
- *
- * 2)  Gain table index used to achieve the target measurement power.
- *     This refers to the "well-known" gain tables (see iwl-4965-hw.h).
- *
- * 3)  Actual measured output power, in half-dBm ("34" = 17 dBm).
- *
- * 4)  RF power amplifier detector level measurement (not used).
- */
-struct iwl_eeprom_calib_measure {
-	u8 temperature;		/* Device temperature (Celsius) */
-	u8 gain_idx;		/* Index into gain table */
-	u8 actual_pow;		/* Measured RF output power, half-dBm */
-	s8 pa_det;		/* Power amp detector level (not used) */
-} __packed;
-
-
-/*
- * measurement set for one channel.  EEPROM contains:
- *
- * 1)  Channel number measured
- *
- * 2)  Measurements for each of 3 power levels for each of 2 radio transmitters
- *     (a.k.a. "tx chains") (6 measurements altogether)
- */
-struct iwl_eeprom_calib_ch_info {
-	u8 ch_num;
-	struct iwl_eeprom_calib_measure
-		measurements[EEPROM_TX_POWER_TX_CHAINS]
-			[EEPROM_TX_POWER_MEASUREMENTS];
-} __packed;
-
-/*
- * txpower subband info.
- *
- * For each frequency subband, EEPROM contains the following:
- *
- * 1)  First and last channels within range of the subband.  "0" values
- *     indicate that this sample set is not being used.
- *
- * 2)  Sample measurement sets for 2 channels close to the range endpoints.
- */
-struct iwl_eeprom_calib_subband_info {
-	u8 ch_from;	/* channel number of lowest channel in subband */
-	u8 ch_to;	/* channel number of highest channel in subband */
-	struct iwl_eeprom_calib_ch_info ch1;
-	struct iwl_eeprom_calib_ch_info ch2;
-} __packed;
-
-
-/*
- * txpower calibration info.  EEPROM contains:
- *
- * 1)  Factory-measured saturation power levels (maximum levels at which
- *     tx power amplifier can output a signal without too much distortion).
- *     There is one level for 2.4 GHz band and one for 5 GHz band.  These
- *     values apply to all channels within each of the bands.
- *
- * 2)  Factory-measured power supply voltage level.  This is assumed to be
- *     constant (i.e. same value applies to all channels/bands) while the
- *     factory measurements are being made.
- *
- * 3)  Up to 8 sets of factory-measured txpower calibration values.
- *     These are for different frequency ranges, since txpower gain
- *     characteristics of the analog radio circuitry vary with frequency.
- *
- *     Not all sets need to be filled with data;
- *     struct iwl_eeprom_calib_subband_info contains range of channels
- *     (0 if unused) for each set of data.
- */
-struct iwl_eeprom_calib_info {
-	u8 saturation_power24;	/* half-dBm (e.g. "34" = 17 dBm) */
-	u8 saturation_power52;	/* half-dBm */
-	__le16 voltage;		/* signed */
-	struct iwl_eeprom_calib_subband_info
-		band_info[EEPROM_TX_POWER_BANDS];
-} __packed;
-
-
 #define ADDRESS_MSK                 0x0000FFFF
 #define INDIRECT_TYPE_MSK           0x000F0000
 #define INDIRECT_HOST               0x00010000
@@ -398,83 +288,8 @@ struct iwl_eeprom_calib_info {
 #define EEPROM_RF_CFG_TX_ANT_MSK(x) ((x >> 8)  & 0xF) /* bits 8-11  */
 #define EEPROM_RF_CFG_RX_ANT_MSK(x) ((x >> 12) & 0xF) /* bits 12-15 */
 
-#define EEPROM_3945_RF_CFG_TYPE_MAX  0x0
-#define EEPROM_4965_RF_CFG_TYPE_MAX  0x1
-
-/* Radio Config for 5000 and up */
-#define EEPROM_RF_CONFIG_TYPE_R3x3	0x0
-#define EEPROM_RF_CONFIG_TYPE_R2x2	0x1
-#define EEPROM_RF_CONFIG_TYPE_R1x2	0x2
 #define EEPROM_RF_CONFIG_TYPE_MAX	0x3
 
-/*
- * Per-channel regulatory data.
- *
- * Each channel that *might* be supported by iwl has a fixed location
- * in EEPROM containing EEPROM_CHANNEL_* usage flags (LSB) and max regulatory
- * txpower (MSB).
- *
- * Entries immediately below are for 20 MHz channel width.  HT40 (40 MHz)
- * channels (only for 4965, not supported by 3945) appear later in the EEPROM.
- *
- * 2.4 GHz channels 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14
- */
-#define EEPROM_REGULATORY_SKU_ID            (2*0x60)    /* 4  bytes */
-#define EEPROM_REGULATORY_BAND_1            (2*0x62)	/* 2  bytes */
-#define EEPROM_REGULATORY_BAND_1_CHANNELS   (2*0x63)	/* 28 bytes */
-
-/*
- * 4.9 GHz channels 183, 184, 185, 187, 188, 189, 192, 196,
- * 5.0 GHz channels 7, 8, 11, 12, 16
- * (4915-5080MHz) (none of these is ever supported)
- */
-#define EEPROM_REGULATORY_BAND_2            (2*0x71)	/* 2  bytes */
-#define EEPROM_REGULATORY_BAND_2_CHANNELS   (2*0x72)	/* 26 bytes */
-
-/*
- * 5.2 GHz channels 34, 36, 38, 40, 42, 44, 46, 48, 52, 56, 60, 64
- * (5170-5320MHz)
- */
-#define EEPROM_REGULATORY_BAND_3            (2*0x7F)	/* 2  bytes */
-#define EEPROM_REGULATORY_BAND_3_CHANNELS   (2*0x80)	/* 24 bytes */
-
-/*
- * 5.5 GHz channels 100, 104, 108, 112, 116, 120, 124, 128, 132, 136, 140
- * (5500-5700MHz)
- */
-#define EEPROM_REGULATORY_BAND_4            (2*0x8C)	/* 2  bytes */
-#define EEPROM_REGULATORY_BAND_4_CHANNELS   (2*0x8D)	/* 22 bytes */
-
-/*
- * 5.7 GHz channels 145, 149, 153, 157, 161, 165
- * (5725-5825MHz)
- */
-#define EEPROM_REGULATORY_BAND_5            (2*0x98)	/* 2  bytes */
-#define EEPROM_REGULATORY_BAND_5_CHANNELS   (2*0x99)	/* 12 bytes */
-
-/*
- * 2.4 GHz HT40 channels 1 (5), 2 (6), 3 (7), 4 (8), 5 (9), 6 (10), 7 (11)
- *
- * The channel listed is the center of the lower 20 MHz half of the channel.
- * The overall center frequency is actually 2 channels (10 MHz) above that,
- * and the upper half of each HT40 channel is centered 4 channels (20 MHz) away
- * from the lower half; e.g. the upper half of HT40 channel 1 is channel 5,
- * and the overall HT40 channel width centers on channel 3.
- *
- * NOTE:  The RXON command uses 20 MHz channel numbers to specify the
- *        control channel to which to tune.  RXON also specifies whether the
- *        control channel is the upper or lower half of a HT40 channel.
- *
- * NOTE:  4965 does not support HT40 channels on 2.4 GHz.
- */
-#define EEPROM_4965_REGULATORY_BAND_24_HT40_CHANNELS (2*0xA0)	/* 14 bytes */
-
-/*
- * 5.2 GHz HT40 channels 36 (40), 44 (48), 52 (56), 60 (64),
- * 100 (104), 108 (112), 116 (120), 124 (128), 132 (136), 149 (153), 157 (161)
- */
-#define EEPROM_4965_REGULATORY_BAND_52_HT40_CHANNELS (2*0xA8)	/* 22 bytes */
-
 #define EEPROM_REGULATORY_BAND_NO_HT40			(0)
 
 struct iwl_eeprom_ops {
diff --git a/drivers/net/wireless/iwlwifi/iwl-hcmd.c b/drivers/net/wireless/iwlwifi/iwl-hcmd.c
index 02499f6..f8a25a1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-hcmd.c
+++ b/drivers/net/wireless/iwlwifi/iwl-hcmd.c
@@ -51,9 +51,7 @@ const char *get_cmd_string(u8 cmd)
 		IWL_CMD(REPLY_REMOVE_ALL_STA);
 		IWL_CMD(REPLY_TXFIFO_FLUSH);
 		IWL_CMD(REPLY_WEPKEY);
-		IWL_CMD(REPLY_3945_RX);
 		IWL_CMD(REPLY_TX);
-		IWL_CMD(REPLY_RATE_SCALE);
 		IWL_CMD(REPLY_LEDS_CMD);
 		IWL_CMD(REPLY_TX_LINK_QUALITY_CMD);
 		IWL_CMD(COEX_PRIORITY_TABLE_CMD);
diff --git a/drivers/net/wireless/iwlwifi/iwl-prph.h b/drivers/net/wireless/iwlwifi/iwl-prph.h
index 86f5123..81c4647 100644
--- a/drivers/net/wireless/iwlwifi/iwl-prph.h
+++ b/drivers/net/wireless/iwlwifi/iwl-prph.h
@@ -91,7 +91,6 @@
 #define APMG_PS_CTRL_VAL_RESET_REQ		(0x04000000)
 #define APMG_PS_CTRL_MSK_PWR_SRC		(0x03000000)
 #define APMG_PS_CTRL_VAL_PWR_SRC_VMAIN		(0x00000000)
-#define APMG_PS_CTRL_VAL_PWR_SRC_MAX		(0x01000000) /* 3945 only */
 #define APMG_PS_CTRL_VAL_PWR_SRC_VAUX		(0x02000000)
 #define APMG_SVR_VOLTAGE_CONFIG_BIT_MSK	(0x000001E0) /* bit 8:5 */
 #define APMG_SVR_DIGITAL_VOLTAGE_1_32		(0x00000060)
@@ -234,16 +233,6 @@
 #define BSM_SRAM_SIZE			(1024) /* bytes */
 
 
-/* 3945 Tx scheduler registers */
-#define ALM_SCD_BASE                        (PRPH_BASE + 0x2E00)
-#define ALM_SCD_MODE_REG                    (ALM_SCD_BASE + 0x000)
-#define ALM_SCD_ARASTAT_REG                 (ALM_SCD_BASE + 0x004)
-#define ALM_SCD_TXFACT_REG                  (ALM_SCD_BASE + 0x010)
-#define ALM_SCD_TXF4MF_REG                  (ALM_SCD_BASE + 0x014)
-#define ALM_SCD_TXF5MF_REG                  (ALM_SCD_BASE + 0x020)
-#define ALM_SCD_SBYP_MODE_1_REG             (ALM_SCD_BASE + 0x02C)
-#define ALM_SCD_SBYP_MODE_2_REG             (ALM_SCD_BASE + 0x030)
-
 /**
  * Tx Scheduler
  *
-- 
1.7.0.4

