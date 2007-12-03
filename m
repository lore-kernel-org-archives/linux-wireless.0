Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:31715 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753518AbXLCLs5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Dec 2007 06:48:57 -0500
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, yi.zhu@intel.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Ben Cahill <ben.m.cahill@intel.com>
Subject: [PATCH 28/34] iwlwifi: add comments to QOS and ADD_STA commands
Date: Mon,  3 Dec 2007 13:43:40 +0200
Message-Id: <1196682232443-git-send-email-tomas.winkler@intel.com> (sfid-20071203_114908_289454_C57FE686)
In-Reply-To: <11966822321616-git-send-email-tomas.winkler@intel.com>
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
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Cahill <ben.m.cahill@intel.com>

Add comments to QOS and ADD_STA commands

Signed-off-by: Ben Cahill <ben.m.cahill@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945-commands.h |   97 +++++++++++++++++----
 drivers/net/wireless/iwlwifi/iwl-4965-commands.h |   99 +++++++++++++++++++---
 2 files changed, 165 insertions(+), 31 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-commands.h b/drivers/net/wireless/iwlwifi/iwl-3945-commands.h
index 4a8fc68..4885971 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-commands.h
@@ -445,6 +445,23 @@ struct iwl3945_csa_notification {
  * Quality-of-Service (QOS) Commands & Responses:
  *
  *****************************************************************************/
+
+/**
+ * struct iwl_ac_qos -- QOS timing params for REPLY_QOS_PARAM
+ * One for each of 4 EDCA access categories in struct iwl_qosparam_cmd
+ *
+ * @cw_min: Contention window, start value in numbers of slots.
+ *          Should be a power-of-2, minus 1.  Device's default is 0x0f.
+ * @cw_max: Contention window, max value in numbers of slots.
+ *          Should be a power-of-2, minus 1.  Device's default is 0x3f.
+ * @aifsn:  Number of slots in Arbitration Interframe Space (before
+ *          performing random backoff timing prior to Tx).  Device default 1.
+ * @edca_txop:  Length of Tx opportunity, in uSecs.  Device default is 0.
+ *
+ * Device will automatically increase contention window by (2*CW) + 1 for each
+ * transmission retry.  Device uses cw_max as a bit mask, ANDed with new CW
+ * value, to cap the CW value.
+ */
 struct iwl3945_ac_qos {
 	__le16 cw_min;
 	__le16 cw_max;
@@ -458,14 +475,14 @@ struct iwl3945_ac_qos {
 #define QOS_PARAM_FLG_TGN_MSK		__constant_cpu_to_le32(0x02)
 #define QOS_PARAM_FLG_TXOP_TYPE_MSK	__constant_cpu_to_le32(0x10)
 
-/*
- *  TXFIFO Queue number defines
- */
-/* number of Access categories (AC) (EDCA), queues 0..3 */
+/* Number of Access Categories (AC) (EDCA), queues 0..3 */
 #define AC_NUM                4
 
 /*
  * REPLY_QOS_PARAM = 0x13 (command, has simple generic response)
+ *
+ * This command sets up timings for each of the 4 prioritized EDCA Tx FIFOs
+ * 0: Background, 1: Best Effort, 2: Video, 3: Voice.
  */
 struct iwl3945_qosparam_cmd {
 	__le32 qos_flags;
@@ -480,22 +497,21 @@ struct iwl3945_qosparam_cmd {
 /*
  * Multi station support
  */
+
+/* Special, dedicated locations within device's station table */
 #define	IWL_AP_ID		0
 #define IWL_MULTICAST_ID	1
 #define	IWL_STA_ID		2
-
 #define	IWL3945_BROADCAST_ID	24
 #define IWL3945_STATION_COUNT	25
 
-#define IWL4965_BROADCAST_ID	31
-#define	IWL4965_STATION_COUNT	32
-
 #define	IWL_STATION_COUNT	32 	/* MAX(3945,4965)*/
 #define	IWL_INVALID_STATION 	255
 
 #define STA_FLG_TX_RATE_MSK		__constant_cpu_to_le32(1<<2);
 #define STA_FLG_PWR_SAVE_MSK		__constant_cpu_to_le32(1<<8);
 
+/* Use in mode field.  1: modify existing entry, 0: add new station entry */
 #define STA_CONTROL_MODIFY_MSK		0x01
 
 /* key flags __le16*/
@@ -508,13 +524,10 @@ struct iwl3945_qosparam_cmd {
 #define STA_KEY_FLG_KEYID_POS	8
 #define STA_KEY_FLG_INVALID 	__constant_cpu_to_le16(0x0800)
 
-/* modify flags  */
+/* Flags indicate whether to modify vs. don't change various station params */
 #define	STA_MODIFY_KEY_MASK		0x01
 #define	STA_MODIFY_TID_DISABLE_TX	0x02
 #define	STA_MODIFY_TX_RATE_MSK		0x04
-#define STA_MODIFY_ADDBA_TID_MSK	0x08
-#define STA_MODIFY_DELBA_TID_MSK	0x10
-#define BUILD_RAxTID(sta_id, tid)	(((sta_id) << 4) + (tid))
 
 /*
  * Antenna masks:
@@ -537,6 +550,18 @@ struct iwl3945_keyinfo {
 	u8 key[16];		/* 16-byte unicast decryption key */
 } __attribute__ ((packed));
 
+/**
+ * struct sta_id_modify
+ * @addr[ETH_ALEN]: station's MAC address
+ * @sta_id: index of station in uCode's station table
+ * @modify_mask: STA_MODIFY_*, 1: modify, 0: don't change
+ *
+ * Driver selects unused table index when adding new station,
+ * or the index to a pre-existing station entry when modifying that station.
+ * Some indexes have special purposes (IWL_AP_ID, index 0, is for AP).
+ *
+ * modify_mask flags select which parameters to modify vs. leave alone.
+ */
 struct sta_id_modify {
 	u8 addr[ETH_ALEN];
 	__le16 reserved1;
@@ -547,29 +572,67 @@ struct sta_id_modify {
 
 /*
  * REPLY_ADD_STA = 0x18 (command)
+ *
+ * The device contains an internal table of per-station information,
+ * with info on security keys, aggregation parameters, and Tx rates for
+ * initial Tx attempt and any retries (4965 uses REPLY_TX_LINK_QUALITY_CMD,
+ * 3945 uses REPLY_RATE_SCALE to set up rate tables).
+ *
+ * REPLY_ADD_STA sets up the table entry for one station, either creating
+ * a new entry, or modifying a pre-existing one.
+ *
+ * NOTE:  RXON command (without "associated" bit set) wipes the station table
+ *        clean.  Moving into RF_KILL state does this also.  Driver must set up
+ *        new station table before transmitting anything on the RXON channel
+ *        (except active scans or active measurements; those commands carry
+ *        their own txpower/rate setup data).
+ *
+ *        When getting started on a new channel, driver must set up the
+ *        IWL_BROADCAST_ID entry (last entry in the table).  For a client
+ *        station in a BSS, once an AP is selected, driver sets up the AP STA
+ *        in the IWL_AP_ID entry (1st entry in the table).  BROADCAST and AP
+ *        are all that are needed for a BSS client station.  If the device is
+ *        used as AP, or in an IBSS network, driver must set up station table
+ *        entries for all STAs in network, starting with index IWL_STA_ID.
  */
 struct iwl3945_addsta_cmd {
-	u8 mode;
+	u8 mode;		/* 1: modify existing, 0: add new station */
 	u8 reserved[3];
 	struct sta_id_modify sta;
 	struct iwl3945_keyinfo key;
-	__le32 station_flags;
-	__le32 station_flags_msk;
+	__le32 station_flags;		/* STA_FLG_* */
+	__le32 station_flags_msk;	/* STA_FLG_* */
+
+	/* bit field to disable (1) or enable (0) Tx for Traffic ID (TID)
+	 * corresponding to bit (e.g. bit 5 controls TID 5).
+	 * Set modify_mask bit STA_MODIFY_TID_DISABLE_TX to use this field. */
 	__le16 tid_disable_tx;
+
 	__le16 rate_n_flags;
+
+	/* TID for which to add block-ack support.
+	 * Set modify_mask bit STA_MODIFY_ADDBA_TID_MSK to use this field. */
 	u8 add_immediate_ba_tid;
+
+	/* TID for which to remove block-ack support.
+	 * Set modify_mask bit STA_MODIFY_DELBA_TID_MSK to use this field. */
 	u8 remove_immediate_ba_tid;
+
+	/* Starting Sequence Number for added block-ack support.
+	 * Set modify_mask bit STA_MODIFY_ADDBA_TID_MSK to use this field. */
 	__le16 add_immediate_ba_ssn;
 } __attribute__ ((packed));
 
+#define ADD_STA_SUCCESS_MSK		0x1
+#define ADD_STA_NO_ROOM_IN_TABLE	0x2
+#define ADD_STA_NO_BLOCK_ACK_RESOURCE	0x4
 /*
  * REPLY_ADD_STA = 0x18 (response)
  */
 struct iwl3945_add_sta_resp {
-	u8 status;
+	u8 status;	/* ADD_STA_* */
 } __attribute__ ((packed));
 
-#define ADD_STA_SUCCESS_MSK              0x1
 
 /******************************************************************************
  * (4)
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-commands.h b/drivers/net/wireless/iwlwifi/iwl-4965-commands.h
index 0813e3e..44addea 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-commands.h
@@ -650,6 +650,23 @@ struct iwl4965_csa_notification {
  * Quality-of-Service (QOS) Commands & Responses:
  *
  *****************************************************************************/
+
+/**
+ * struct iwl_ac_qos -- QOS timing params for REPLY_QOS_PARAM
+ * One for each of 4 EDCA access categories in struct iwl_qosparam_cmd
+ *
+ * @cw_min: Contention window, start value in numbers of slots.
+ *          Should be a power-of-2, minus 1.  Device's default is 0x0f.
+ * @cw_max: Contention window, max value in numbers of slots.
+ *          Should be a power-of-2, minus 1.  Device's default is 0x3f.
+ * @aifsn:  Number of slots in Arbitration Interframe Space (before
+ *          performing random backoff timing prior to Tx).  Device default 1.
+ * @edca_txop:  Length of Tx opportunity, in uSecs.  Device default is 0.
+ *
+ * Device will automatically increase contention window by (2*CW) + 1 for each
+ * transmission retry.  Device uses cw_max as a bit mask, ANDed with new CW
+ * value, to cap the CW value.
+ */
 struct iwl4965_ac_qos {
 	__le16 cw_min;
 	__le16 cw_max;
@@ -663,14 +680,14 @@ struct iwl4965_ac_qos {
 #define QOS_PARAM_FLG_TGN_MSK		__constant_cpu_to_le32(0x02)
 #define QOS_PARAM_FLG_TXOP_TYPE_MSK	__constant_cpu_to_le32(0x10)
 
-/*
- *  TXFIFO Queue number defines
- */
-/* number of Access categories (AC) (EDCA), queues 0..3 */
+/* Number of Access Categories (AC) (EDCA), queues 0..3 */
 #define AC_NUM                4
 
 /*
  * REPLY_QOS_PARAM = 0x13 (command, has simple generic response)
+ *
+ * This command sets up timings for each of the 4 prioritized EDCA Tx FIFOs
+ * 0: Background, 1: Best Effort, 2: Video, 3: Voice.
  */
 struct iwl4965_qosparam_cmd {
 	__le32 qos_flags;
@@ -685,13 +702,11 @@ struct iwl4965_qosparam_cmd {
 /*
  * Multi station support
  */
+
+/* Special, dedicated locations within device's station table */
 #define	IWL_AP_ID		0
 #define IWL_MULTICAST_ID	1
 #define	IWL_STA_ID		2
-
-#define	IWL3945_BROADCAST_ID	24
-#define IWL3945_STATION_COUNT	25
-
 #define IWL4965_BROADCAST_ID	31
 #define	IWL4965_STATION_COUNT	32
 
@@ -708,6 +723,7 @@ struct iwl4965_qosparam_cmd {
 #define STA_FLG_AGG_MPDU_DENSITY_POS	(23)
 #define STA_FLG_AGG_MPDU_DENSITY_MSK	__constant_cpu_to_le32(7 << 23)
 
+/* Use in mode field.  1: modify existing entry, 0: add new station entry */
 #define STA_CONTROL_MODIFY_MSK		0x01
 
 /* key flags __le16*/
@@ -720,12 +736,15 @@ struct iwl4965_qosparam_cmd {
 #define STA_KEY_FLG_KEYID_POS	8
 #define STA_KEY_FLG_INVALID 	__constant_cpu_to_le16(0x0800)
 
-/* modify flags  */
+/* Flags indicate whether to modify vs. don't change various station params */
 #define	STA_MODIFY_KEY_MASK		0x01
 #define	STA_MODIFY_TID_DISABLE_TX	0x02
 #define	STA_MODIFY_TX_RATE_MSK		0x04
 #define STA_MODIFY_ADDBA_TID_MSK	0x08
 #define STA_MODIFY_DELBA_TID_MSK	0x10
+
+/* Receiver address (actually, Rx station's index into station table),
+ * combined with Traffic ID (QOS priority), in format used by Tx Scheduler */
 #define BUILD_RAxTID(sta_id, tid)	(((sta_id) << 4) + (tid))
 
 struct iwl4965_keyinfo {
@@ -737,6 +756,18 @@ struct iwl4965_keyinfo {
 	u8 key[16];		/* 16-byte unicast decryption key */
 } __attribute__ ((packed));
 
+/**
+ * struct sta_id_modify
+ * @addr[ETH_ALEN]: station's MAC address
+ * @sta_id: index of station in uCode's station table
+ * @modify_mask: STA_MODIFY_*, 1: modify, 0: don't change
+ *
+ * Driver selects unused table index when adding new station,
+ * or the index to a pre-existing station entry when modifying that station.
+ * Some indexes have special purposes (IWL_AP_ID, index 0, is for AP).
+ *
+ * modify_mask flags select which parameters to modify vs. leave alone.
+ */
 struct sta_id_modify {
 	u8 addr[ETH_ALEN];
 	__le16 reserved1;
@@ -747,30 +778,70 @@ struct sta_id_modify {
 
 /*
  * REPLY_ADD_STA = 0x18 (command)
+ *
+ * The device contains an internal table of per-station information,
+ * with info on security keys, aggregation parameters, and Tx rates for
+ * initial Tx attempt and any retries (4965 uses REPLY_TX_LINK_QUALITY_CMD,
+ * 3945 uses REPLY_RATE_SCALE to set up rate tables).
+ *
+ * REPLY_ADD_STA sets up the table entry for one station, either creating
+ * a new entry, or modifying a pre-existing one.
+ *
+ * NOTE:  RXON command (without "associated" bit set) wipes the station table
+ *        clean.  Moving into RF_KILL state does this also.  Driver must set up
+ *        new station table before transmitting anything on the RXON channel
+ *        (except active scans or active measurements; those commands carry
+ *        their own txpower/rate setup data).
+ *
+ *        When getting started on a new channel, driver must set up the
+ *        IWL_BROADCAST_ID entry (last entry in the table).  For a client
+ *        station in a BSS, once an AP is selected, driver sets up the AP STA
+ *        in the IWL_AP_ID entry (1st entry in the table).  BROADCAST and AP
+ *        are all that are needed for a BSS client station.  If the device is
+ *        used as AP, or in an IBSS network, driver must set up station table
+ *        entries for all STAs in network, starting with index IWL_STA_ID.
  */
 struct iwl4965_addsta_cmd {
-	u8 mode;
+	u8 mode;		/* 1: modify existing, 0: add new station */
 	u8 reserved[3];
 	struct sta_id_modify sta;
 	struct iwl4965_keyinfo key;
-	__le32 station_flags;
-	__le32 station_flags_msk;
+	__le32 station_flags;		/* STA_FLG_* */
+	__le32 station_flags_msk;	/* STA_FLG_* */
+
+	/* bit field to disable (1) or enable (0) Tx for Traffic ID (TID)
+	 * corresponding to bit (e.g. bit 5 controls TID 5).
+	 * Set modify_mask bit STA_MODIFY_TID_DISABLE_TX to use this field. */
 	__le16 tid_disable_tx;
+
 	__le16	reserved1;
+
+	/* TID for which to add block-ack support.
+	 * Set modify_mask bit STA_MODIFY_ADDBA_TID_MSK to use this field. */
 	u8 add_immediate_ba_tid;
+
+	/* TID for which to remove block-ack support.
+	 * Set modify_mask bit STA_MODIFY_DELBA_TID_MSK to use this field. */
 	u8 remove_immediate_ba_tid;
+
+	/* Starting Sequence Number for added block-ack support.
+	 * Set modify_mask bit STA_MODIFY_ADDBA_TID_MSK to use this field. */
 	__le16 add_immediate_ba_ssn;
+
 	__le32 reserved2;
 } __attribute__ ((packed));
 
+#define ADD_STA_SUCCESS_MSK		0x1
+#define ADD_STA_NO_ROOM_IN_TABLE	0x2
+#define ADD_STA_NO_BLOCK_ACK_RESOURCE	0x4
+#define ADD_STA_MODIFY_NON_EXIST_STA	0x8
 /*
  * REPLY_ADD_STA = 0x18 (response)
  */
 struct iwl4965_add_sta_resp {
-	u8 status;
+	u8 status;	/* ADD_STA_* */
 } __attribute__ ((packed));
 
-#define ADD_STA_SUCCESS_MSK              0x1
 
 /******************************************************************************
  * (4)
-- 
1.5.2.2
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
