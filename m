Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:31699 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753596AbXLCLs4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Dec 2007 06:48:56 -0500
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, yi.zhu@intel.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Ben Cahill <ben.m.cahill@intel.com>
Subject: [PATCH 29/34] iwlwifi: add comments to Tx commands
Date: Mon,  3 Dec 2007 13:43:41 +0200
Message-Id: <11966822323588-git-send-email-tomas.winkler@intel.com> (sfid-20071203_114905_409586_3B9BEEFE)
In-Reply-To: <1196682232443-git-send-email-tomas.winkler@intel.com>
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
 <11966822321616-git-send-email-tomas.winkler@intel.com>
 <1196682232443-git-send-email-tomas.winkler@intel.com>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Cahill <ben.m.cahill@intel.com>

Add comments to Tx commands

Clean up unused definitions in iwl-3945-commands.h

Signed-off-by: Ben Cahill <ben.m.cahill@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945-commands.h |  161 ++++++++++--------
 drivers/net/wireless/iwlwifi/iwl-4965-commands.h |  201 +++++++++++++++++++---
 2 files changed, 267 insertions(+), 95 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-commands.h b/drivers/net/wireless/iwlwifi/iwl-3945-commands.h
index 4885971..3cac2c8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-commands.h
@@ -743,36 +743,86 @@ struct iwl4965_rx_mpdu_res_start {
  * (5)
  * Tx Commands & Responses:
  *
+ * Driver must place each REPLY_TX command into one of the prioritized Tx
+ * queues in host DRAM, shared between driver and device.  When the device's
+ * Tx scheduler and uCode are preparing to transmit, the device pulls the
+ * Tx command over the PCI bus via one of the device's Tx DMA channels,
+ * to fill an internal FIFO from which data will be transmitted.
+ *
+ * uCode handles all timing and protocol related to control frames
+ * (RTS/CTS/ACK), based on flags in the Tx command.
+ *
+ * uCode handles retrying Tx when an ACK is expected but not received.
+ * This includes trying lower data rates than the one requested in the Tx
+ * command, as set up by the REPLY_RATE_SCALE (for 3945) or
+ * REPLY_TX_LINK_QUALITY_CMD (4965).
+ *
+ * Driver sets up transmit power for various rates via REPLY_TX_PWR_TABLE_CMD.
+ * This command must be executed after every RXON command, before Tx can occur.
  *****************************************************************************/
 
-/* Tx flags */
+/* REPLY_TX Tx flags field */
+
+/* 1: Use Request-To-Send protocol before this frame.
+ * Mutually exclusive vs. TX_CMD_FLG_CTS_MSK. */
 #define TX_CMD_FLG_RTS_MSK __constant_cpu_to_le32(1 << 1)
+
+/* 1: Transmit Clear-To-Send to self before this frame.
+ * Driver should set this for AUTH/DEAUTH/ASSOC-REQ/REASSOC mgmnt frames.
+ * Mutually exclusive vs. TX_CMD_FLG_RTS_MSK. */
 #define TX_CMD_FLG_CTS_MSK __constant_cpu_to_le32(1 << 2)
+
+/* 1: Expect ACK from receiving station
+ * 0: Don't expect ACK (MAC header's duration field s/b 0)
+ * Set this for unicast frames, but not broadcast/multicast. */
 #define TX_CMD_FLG_ACK_MSK __constant_cpu_to_le32(1 << 3)
+
+/* 1: Use rate scale table (see REPLY_TX_LINK_QUALITY_CMD).
+ *    Tx command's initial_rate_index indicates first rate to try;
+ *    uCode walks through table for additional Tx attempts.
+ * 0: Use Tx rate/MCS from Tx command's rate_n_flags field.
+ *    This rate will be used for all Tx attempts; it will not be scaled. */
 #define TX_CMD_FLG_STA_RATE_MSK __constant_cpu_to_le32(1 << 4)
+
+/* 1: Expect immediate block-ack.
+ * Set when Txing a block-ack request frame.  Also set TX_CMD_FLG_ACK_MSK. */
 #define TX_CMD_FLG_IMM_BA_RSP_MASK  __constant_cpu_to_le32(1 << 6)
+
+/* 1: Frame requires full Tx-Op protection.
+ * Set this if either RTS or CTS Tx Flag gets set. */
 #define TX_CMD_FLG_FULL_TXOP_PROT_MSK __constant_cpu_to_le32(1 << 7)
+
+/* Tx antenna selection field; used only for 3945, reserved (0) for 4965.
+ * Set field to "0" to allow 3945 uCode to select antenna (normal usage). */
 #define TX_CMD_FLG_ANT_SEL_MSK __constant_cpu_to_le32(0xf00)
 #define TX_CMD_FLG_ANT_A_MSK __constant_cpu_to_le32(1 << 8)
 #define TX_CMD_FLG_ANT_B_MSK __constant_cpu_to_le32(1 << 9)
 
-/* ucode ignores BT priority for this frame */
+/* 1: Ignore Bluetooth priority for this frame.
+ * 0: Delay Tx until Bluetooth device is done (normal usage). */
 #define TX_CMD_FLG_BT_DIS_MSK __constant_cpu_to_le32(1 << 12)
 
-/* ucode overrides sequence control */
+/* 1: uCode overrides sequence control field in MAC header.
+ * 0: Driver provides sequence control field in MAC header.
+ * Set this for management frames, non-QOS data frames, non-unicast frames,
+ * and also in Tx command embedded in REPLY_SCAN_CMD for active scans. */
 #define TX_CMD_FLG_SEQ_CTL_MSK __constant_cpu_to_le32(1 << 13)
 
-/* signal that this frame is non-last MPDU */
+/* 1: This frame is non-last MPDU; more fragments are coming.
+ * 0: Last fragment, or not using fragmentation. */
 #define TX_CMD_FLG_MORE_FRAG_MSK __constant_cpu_to_le32(1 << 14)
 
-/* calculate TSF in outgoing frame */
+/* 1: uCode calculates and inserts Timestamp Function (TSF) in outgoing frame.
+ * 0: No TSF required in outgoing frame.
+ * Set this for transmitting beacons and probe responses. */
 #define TX_CMD_FLG_TSF_MSK __constant_cpu_to_le32(1 << 16)
 
-/* activate TX calibration. */
-#define TX_CMD_FLG_CALIB_MSK __constant_cpu_to_le32(1 << 17)
-
-/* signals that 2 bytes pad was inserted
-   after the MAC header */
+/* 1: Driver inserted 2 bytes pad after the MAC header, for (required) dword
+ *    alignment of frame's payload data field.
+ * 0: No pad
+ * Set this for MAC headers with 26 or 30 bytes, i.e. those with QOS or ADDR4
+ * field (but not both).  Driver must align frame data (i.e. data following
+ * MAC header) to DWORD boundary. */
 #define TX_CMD_FLG_MH_PAD_MSK __constant_cpu_to_le32(1 << 20)
 
 /* HCCA-AP - disable duration overwriting. */
@@ -789,23 +839,33 @@ struct iwl4965_rx_mpdu_res_start {
 #define TX_CMD_SEC_KEY128	0x08
 
 /*
- * TX command Frame life time
- */
-
-struct iwl3945_dram_scratch {
-	u8 try_cnt;
-	u8 bt_kill_cnt;
-	__le16 reserved;
-} __attribute__ ((packed));
-
-/*
  * REPLY_TX = 0x1c (command)
  */
 struct iwl3945_tx_cmd {
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
 	__le16 len;
+
+	/*
+	 * MPDU or MSDU byte count for next frame.
+	 * Used for fragmentation and bursting, but not 11n aggregation.
+	 * Same as "len", but for next frame.  Set to 0 if not applicable.
+	 */
 	__le16 next_frame_len;
-	__le32 tx_flags;
+
+	__le32 tx_flags;	/* TX_CMD_FLG_* */
+
 	u8 rate;
+
+	/* Index of recipient station in uCode's station table */
 	u8 sta_id;
 	u8 tid_tspec;
 	u8 sec_ctl;
@@ -827,7 +887,17 @@ struct iwl3945_tx_cmd {
 		__le16 pm_frame_timeout;
 		__le16 attempt_duration;
 	} timeout;
+
+	/*
+	 * Duration of EDCA burst Tx Opportunity, in 32-usec units.
+	 * Set this if txop time is not specified by HCCA protocol (e.g. by AP).
+	 */
 	__le16 driver_txop;
+
+	/*
+	 * MAC header goes here, followed by 2 bytes padding if MAC header
+	 * length is 26 or 30 bytes, followed by payload data
+	 */
 	u8 payload[0];
 	struct ieee80211_hdr hdr[0];
 } __attribute__ ((packed));
@@ -899,37 +969,6 @@ enum {
 	TX_ABORT_REQUIRED_MSK = 0x80000000,	/* bits 31:31 */
 };
 
-/* *******************************
- * TX aggregation state
- ******************************* */
-
-enum {
-	AGG_TX_STATE_TRANSMITTED = 0x00,
-	AGG_TX_STATE_UNDERRUN_MSK = 0x01,
-	AGG_TX_STATE_BT_PRIO_MSK = 0x02,
-	AGG_TX_STATE_FEW_BYTES_MSK = 0x04,
-	AGG_TX_STATE_ABORT_MSK = 0x08,
-	AGG_TX_STATE_LAST_SENT_TTL_MSK = 0x10,
-	AGG_TX_STATE_LAST_SENT_TRY_CNT_MSK = 0x20,
-	AGG_TX_STATE_LAST_SENT_BT_KILL_MSK = 0x40,
-	AGG_TX_STATE_SCD_QUERY_MSK = 0x80,
-	AGG_TX_STATE_TEST_BAD_CRC32_MSK = 0x100,
-	AGG_TX_STATE_RESPONSE_MSK = 0x1ff,
-	AGG_TX_STATE_DUMP_TX_MSK = 0x200,
-	AGG_TX_STATE_DELAY_TX_MSK = 0x400
-};
-
-#define AGG_TX_STATE_LAST_SENT_MSK \
-(AGG_TX_STATE_LAST_SENT_TTL_MSK | \
- AGG_TX_STATE_LAST_SENT_TRY_CNT_MSK | \
- AGG_TX_STATE_LAST_SENT_BT_KILL_MSK)
-
-#define AGG_TX_STATE_TRY_CNT_POS 12
-#define AGG_TX_STATE_TRY_CNT_MSK 0xf000
-
-#define AGG_TX_STATE_SEQ_NUM_POS 16
-#define AGG_TX_STATE_SEQ_NUM_MSK 0xffff0000
-
 /*
  * REPLY_TX = 0x1c (response)
  */
@@ -939,23 +978,7 @@ struct iwl3945_tx_resp {
 	u8 bt_kill_count;
 	u8 rate;
 	__le32 wireless_media_time;
-	__le32 status;	/* TX status (for aggregation status of 1st frame) */
-} __attribute__ ((packed));
-
-/*
- * REPLY_COMPRESSED_BA = 0xc5 (response only, not a command)
- */
-struct iwl3945_compressed_ba_resp {
-	__le32 sta_addr_lo32;
-	__le16 sta_addr_hi16;
-	__le16 reserved;
-	u8 sta_id;
-	u8 tid;
-	__le16 ba_seq_ctl;
-	__le32 ba_bitmap0;
-	__le32 ba_bitmap1;
-	__le16 scd_flow;
-	__le16 scd_ssn;
+	__le32 status;		/* TX status */
 } __attribute__ ((packed));
 
 /*
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-commands.h b/drivers/net/wireless/iwlwifi/iwl-4965-commands.h
index 44addea..cbe91db 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-commands.h
@@ -937,8 +937,8 @@ struct iwl4965_rx_phy_res {
 	__le16 channel;		/* channel number */
 	__le16 non_cfg_phy[RX_RES_PHY_CNT];	/* upto 14 phy entries */
 	__le32 reserved2;
-	__le32 rate_n_flags;
-	__le16 byte_count;		/* frame's byte-count */
+	__le32 rate_n_flags;	/* RATE_MCS_* */
+	__le16 byte_count;	/* frame's byte-count */
 	__le16 reserved3;
 } __attribute__ ((packed));
 
@@ -952,41 +952,96 @@ struct iwl4965_rx_mpdu_res_start {
  * (5)
  * Tx Commands & Responses:
  *
+ * Driver must place each REPLY_TX command into one of the prioritized Tx
+ * queues in host DRAM, shared between driver and device (see comments for
+ * SCD registers and Tx/Rx Queues).  When the device's Tx scheduler and uCode
+ * are preparing to transmit, the device pulls the Tx command over the PCI
+ * bus via one of the device's Tx DMA channels, to fill an internal FIFO
+ * from which data will be transmitted.
+ *
+ * uCode handles all timing and protocol related to control frames
+ * (RTS/CTS/ACK), based on flags in the Tx command.  uCode and Tx scheduler
+ * handle reception of block-acks; uCode updates the host driver via
+ * REPLY_COMPRESSED_BA (4965).
+ *
+ * uCode handles retrying Tx when an ACK is expected but not received.
+ * This includes trying lower data rates than the one requested in the Tx
+ * command, as set up by the REPLY_RATE_SCALE (for 3945) or
+ * REPLY_TX_LINK_QUALITY_CMD (4965).
+ *
+ * Driver sets up transmit power for various rates via REPLY_TX_PWR_TABLE_CMD.
+ * This command must be executed after every RXON command, before Tx can occur.
  *****************************************************************************/
 
-/* Tx flags */
+/* REPLY_TX Tx flags field */
+
+/* 1: Use Request-To-Send protocol before this frame.
+ * Mutually exclusive vs. TX_CMD_FLG_CTS_MSK. */
 #define TX_CMD_FLG_RTS_MSK __constant_cpu_to_le32(1 << 1)
+
+/* 1: Transmit Clear-To-Send to self before this frame.
+ * Driver should set this for AUTH/DEAUTH/ASSOC-REQ/REASSOC mgmnt frames.
+ * Mutually exclusive vs. TX_CMD_FLG_RTS_MSK. */
 #define TX_CMD_FLG_CTS_MSK __constant_cpu_to_le32(1 << 2)
+
+/* 1: Expect ACK from receiving station
+ * 0: Don't expect ACK (MAC header's duration field s/b 0)
+ * Set this for unicast frames, but not broadcast/multicast. */
 #define TX_CMD_FLG_ACK_MSK __constant_cpu_to_le32(1 << 3)
+
+/* For 4965:
+ * 1: Use rate scale table (see REPLY_TX_LINK_QUALITY_CMD).
+ *    Tx command's initial_rate_index indicates first rate to try;
+ *    uCode walks through table for additional Tx attempts.
+ * 0: Use Tx rate/MCS from Tx command's rate_n_flags field.
+ *    This rate will be used for all Tx attempts; it will not be scaled. */
 #define TX_CMD_FLG_STA_RATE_MSK __constant_cpu_to_le32(1 << 4)
+
+/* 1: Expect immediate block-ack.
+ * Set when Txing a block-ack request frame.  Also set TX_CMD_FLG_ACK_MSK. */
 #define TX_CMD_FLG_IMM_BA_RSP_MASK  __constant_cpu_to_le32(1 << 6)
+
+/* 1: Frame requires full Tx-Op protection.
+ * Set this if either RTS or CTS Tx Flag gets set. */
 #define TX_CMD_FLG_FULL_TXOP_PROT_MSK __constant_cpu_to_le32(1 << 7)
+
+/* Tx antenna selection field; used only for 3945, reserved (0) for 4965.
+ * Set field to "0" to allow 3945 uCode to select antenna (normal usage). */
 #define TX_CMD_FLG_ANT_SEL_MSK __constant_cpu_to_le32(0xf00)
 #define TX_CMD_FLG_ANT_A_MSK __constant_cpu_to_le32(1 << 8)
 #define TX_CMD_FLG_ANT_B_MSK __constant_cpu_to_le32(1 << 9)
 
-/* ucode ignores BT priority for this frame */
+/* 1: Ignore Bluetooth priority for this frame.
+ * 0: Delay Tx until Bluetooth device is done (normal usage). */
 #define TX_CMD_FLG_BT_DIS_MSK __constant_cpu_to_le32(1 << 12)
 
-/* ucode overrides sequence control */
+/* 1: uCode overrides sequence control field in MAC header.
+ * 0: Driver provides sequence control field in MAC header.
+ * Set this for management frames, non-QOS data frames, non-unicast frames,
+ * and also in Tx command embedded in REPLY_SCAN_CMD for active scans. */
 #define TX_CMD_FLG_SEQ_CTL_MSK __constant_cpu_to_le32(1 << 13)
 
-/* signal that this frame is non-last MPDU */
+/* 1: This frame is non-last MPDU; more fragments are coming.
+ * 0: Last fragment, or not using fragmentation. */
 #define TX_CMD_FLG_MORE_FRAG_MSK __constant_cpu_to_le32(1 << 14)
 
-/* calculate TSF in outgoing frame */
+/* 1: uCode calculates and inserts Timestamp Function (TSF) in outgoing frame.
+ * 0: No TSF required in outgoing frame.
+ * Set this for transmitting beacons and probe responses. */
 #define TX_CMD_FLG_TSF_MSK __constant_cpu_to_le32(1 << 16)
 
-/* activate TX calibration. */
-#define TX_CMD_FLG_CALIB_MSK __constant_cpu_to_le32(1 << 17)
-
-/* signals that 2 bytes pad was inserted
-   after the MAC header */
+/* 1: Driver inserted 2 bytes pad after the MAC header, for (required) dword
+ *    alignment of frame's payload data field.
+ * 0: No pad
+ * Set this for MAC headers with 26 or 30 bytes, i.e. those with QOS or ADDR4
+ * field (but not both).  Driver must align frame data (i.e. data following
+ * MAC header) to DWORD boundary. */
 #define TX_CMD_FLG_MH_PAD_MSK __constant_cpu_to_le32(1 << 20)
 
 /* HCCA-AP - disable duration overwriting. */
 #define TX_CMD_FLG_DUR_MSK __constant_cpu_to_le32(1 << 25)
 
+
 /*
  * TX command security control
  */
@@ -998,12 +1053,13 @@ struct iwl4965_rx_mpdu_res_start {
 #define TX_CMD_SEC_KEY128	0x08
 
 /*
- * TX command Frame life time
+ * 4965 uCode updates these Tx attempt count values in host DRAM.
+ * Used for managing Tx retries when expecting block-acks.
+ * Driver should set these fields to 0.
  */
-
 struct iwl4965_dram_scratch {
-	u8 try_cnt;
-	u8 bt_kill_cnt;
+	u8 try_cnt;		/* Tx attempts */
+	u8 bt_kill_cnt;		/* Tx attempts blocked by Bluetooth device */
 	__le16 reserved;
 } __attribute__ ((packed));
 
@@ -1011,13 +1067,47 @@ struct iwl4965_dram_scratch {
  * REPLY_TX = 0x1c (command)
  */
 struct iwl4965_tx_cmd {
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
 	__le16 len;
+
+	/*
+	 * MPDU or MSDU byte count for next frame.
+	 * Used for fragmentation and bursting, but not 11n aggregation.
+	 * Same as "len", but for next frame.  Set to 0 if not applicable.
+	 */
 	__le16 next_frame_len;
-	__le32 tx_flags;
+
+	__le32 tx_flags;	/* TX_CMD_FLG_* */
+
+	/* 4965's uCode may modify this field of the Tx command (in host DRAM!).
+	 * Driver must also set dram_lsb_ptr and dram_msb_ptr in this cmd. */
 	struct iwl4965_dram_scratch scratch;
-	__le32 rate_n_flags;
+
+	/* Rate for *all* Tx attempts, if TX_CMD_FLG_STA_RATE_MSK is cleared. */
+	__le32 rate_n_flags;	/* RATE_MCS_* */
+
+	/* Index of destination station in uCode's station table */
 	u8 sta_id;
-	u8 sec_ctl;
+
+	/* Type of security encryption:  CCM or TKIP */
+	u8 sec_ctl;		/* TX_CMD_SEC_* */
+
+	/*
+	 * Index into rate table (see REPLY_TX_LINK_QUALITY_CMD) for initial
+	 * Tx attempt, if TX_CMD_FLG_STA_RATE_MSK is set.  Normally "0" for
+	 * data frames, this field may be used to selectively reduce initial
+	 * rate (via non-0 value) for special frames (e.g. management), while
+	 * still supporting rate scaling for all frames.
+	 */
 	u8 initial_rate_index;
 	u8 reserved;
 	u8 key[16];
@@ -1027,8 +1117,12 @@ struct iwl4965_tx_cmd {
 		__le32 life_time;
 		__le32 attempt;
 	} stop_time;
+
+	/* Host DRAM physical address pointer to "scratch" in this command.
+	 * Must be dword aligned.  "0" in dram_lsb_ptr disables usage. */
 	__le32 dram_lsb_ptr;
 	u8 dram_msb_ptr;
+
 	u8 rts_retry_limit;	/*byte 50 */
 	u8 data_retry_limit;	/*byte 51 */
 	u8 tid_tspec;
@@ -1036,7 +1130,17 @@ struct iwl4965_tx_cmd {
 		__le16 pm_frame_timeout;
 		__le16 attempt_duration;
 	} timeout;
+
+	/*
+	 * Duration of EDCA burst Tx Opportunity, in 32-usec units.
+	 * Set this if txop time is not specified by HCCA protocol (e.g. by AP).
+	 */
 	__le16 driver_txop;
+
+	/*
+	 * MAC header goes here, followed by 2 bytes padding if MAC header
+	 * length is 26 or 30 bytes, followed by payload data
+	 */
 	u8 payload[0];
 	struct ieee80211_hdr hdr[0];
 } __attribute__ ((packed));
@@ -1109,7 +1213,7 @@ enum {
 };
 
 /* *******************************
- * TX aggregation state
+ * TX aggregation status
  ******************************* */
 
 enum {
@@ -1133,35 +1237,80 @@ enum {
  AGG_TX_STATE_LAST_SENT_TRY_CNT_MSK | \
  AGG_TX_STATE_LAST_SENT_BT_KILL_MSK)
 
+/* # tx attempts for first frame in aggregation */
 #define AGG_TX_STATE_TRY_CNT_POS 12
 #define AGG_TX_STATE_TRY_CNT_MSK 0xf000
 
+/* Command ID and sequence number of Tx command for this frame */
 #define AGG_TX_STATE_SEQ_NUM_POS 16
 #define AGG_TX_STATE_SEQ_NUM_MSK 0xffff0000
 
 /*
  * REPLY_TX = 0x1c (response)
+ *
+ * This response may be in one of two slightly different formats, indicated
+ * by the frame_count field:
+ *
+ * 1)  No aggregation (frame_count == 1).  This reports Tx results for
+ *     a single frame.  Multiple attempts, at various bit rates, may have
+ *     been made for this frame.
+ *
+ * 2)  Aggregation (frame_count > 1).  This reports Tx results for
+ *     2 or more frames that used block-acknowledge.  All frames were
+ *     transmitted at same rate.  Rate scaling may have been used if first
+ *     frame in this new agg block failed in previous agg block(s).
+ *
+ *     Note that, for aggregation, ACK (block-ack) status is not delivered here;
+ *     block-ack has not been received by the time the 4965 records this status.
+ *     This status relates to reasons the tx might have been blocked or aborted
+ *     within the sending station (this 4965), rather than whether it was
+ *     received successfully by the destination station.
  */
 struct iwl4965_tx_resp {
 	u8 frame_count;		/* 1 no aggregation, >1 aggregation */
-	u8 bt_kill_count;
-	u8 failure_rts;
-	u8 failure_frame;
-	__le32 rate_n_flags;
-	__le16 wireless_media_time;
+	u8 bt_kill_count;	/* # blocked by bluetooth (unused for agg) */
+	u8 failure_rts;		/* # failures due to unsuccessful RTS */
+	u8 failure_frame;	/* # failures due to no ACK (unused for agg) */
+
+	/* For non-agg:  Rate at which frame was successful.
+	 * For agg:  Rate at which all frames were transmitted. */
+	__le32 rate_n_flags;	/* RATE_MCS_*  */
+
+	/* For non-agg:  RTS + CTS + frame tx attempts time + ACK.
+	 * For agg:  RTS + CTS + aggregation tx time + block-ack time. */
+	__le16 wireless_media_time;	/* uSecs */
+
 	__le16 reserved;
-	__le32 pa_power1;
+	__le32 pa_power1;	/* RF power amplifier measurement (not used) */
 	__le32 pa_power2;
+
+	/*
+	 * For non-agg:  frame status TX_STATUS_*
+	 * For agg:  status of 1st frame, AGG_TX_STATE_*; other frame status
+	 *           fields follow this one, up to frame_count.
+	 *           Bit fields:
+	 *           11- 0:  AGG_TX_STATE_* status code
+	 *           15-12:  Retry count for 1st frame in aggregation (retries
+	 *                   occur if tx failed for this frame when it was a
+	 *                   member of a previous aggregation block).  If rate
+	 *                   scaling is used, retry count indicates the rate
+	 *                   table entry used for all frames in the new agg.
+	 *           31-16:  Sequence # for this frame's Tx cmd (not SSN!)
+	 */
 	__le32 status;	/* TX status (for aggregation status of 1st frame) */
 } __attribute__ ((packed));
 
 /*
  * REPLY_COMPRESSED_BA = 0xc5 (response only, not a command)
+ *
+ * Reports Block-Acknowledge from recipient station
  */
 struct iwl4965_compressed_ba_resp {
 	__le32 sta_addr_lo32;
 	__le16 sta_addr_hi16;
 	__le16 reserved;
+
+	/* Index of recipient (BA-sending) station in uCode's station table */
 	u8 sta_id;
 	u8 tid;
 	__le16 ba_seq_ctl;
-- 
1.5.2.2
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
