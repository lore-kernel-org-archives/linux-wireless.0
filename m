Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:33376 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752755AbcGFKoT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2016 06:44:19 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>
Date: Wed,  6 Jul 2016 13:40:26 +0300
Message-Id: <1467801651-1816-31-git-send-email-luca@coelho.fi> (sfid-20160706_124424_040412_5A3BD11F)
In-Reply-To: <1467801452.25088.20.camel@coelho.fi>
References: <1467801452.25088.20.camel@coelho.fi>
Subject: [PATCH 31/56] iwlwifi: mvm: cleanup the coex code
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

We removed support for old API for coexistence, but we
forgot to remove defines and variable that are not needed
anymore.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../net/wireless/intel/iwlwifi/mvm/fw-api-coex.h   | 222 ---------------------
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |   4 -
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |   5 -
 3 files changed, 231 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-coex.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-coex.h
index 2a33b69..204c1b1 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-coex.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-coex.h
@@ -70,85 +70,6 @@
 
 #define BITS(nb) (BIT(nb) - 1)
 
-/**
- * enum iwl_bt_coex_flags - flags for BT_COEX command
- * @BT_COEX_MODE_POS:
- * @BT_COEX_MODE_MSK:
- * @BT_COEX_DISABLE_OLD:
- * @BT_COEX_2W_OLD:
- * @BT_COEX_3W_OLD:
- * @BT_COEX_NW_OLD:
- * @BT_COEX_AUTO_OLD:
- * @BT_COEX_BT_OLD: Antenna is for BT (manufacuring tests)
- * @BT_COEX_WIFI_OLD: Antenna is for BT (manufacuring tests)
- * @BT_COEX_SYNC2SCO:
- * @BT_COEX_CORUNNING:
- * @BT_COEX_MPLUT:
- * @BT_COEX_TTC:
- * @BT_COEX_RRC:
- *
- * The COEX_MODE must be set for each command. Even if it is not changed.
- */
-enum iwl_bt_coex_flags {
-	BT_COEX_MODE_POS		= 3,
-	BT_COEX_MODE_MSK		= BITS(3) << BT_COEX_MODE_POS,
-	BT_COEX_DISABLE_OLD		= 0x0 << BT_COEX_MODE_POS,
-	BT_COEX_2W_OLD			= 0x1 << BT_COEX_MODE_POS,
-	BT_COEX_3W_OLD			= 0x2 << BT_COEX_MODE_POS,
-	BT_COEX_NW_OLD			= 0x3 << BT_COEX_MODE_POS,
-	BT_COEX_AUTO_OLD		= 0x5 << BT_COEX_MODE_POS,
-	BT_COEX_BT_OLD			= 0x6 << BT_COEX_MODE_POS,
-	BT_COEX_WIFI_OLD		= 0x7 << BT_COEX_MODE_POS,
-	BT_COEX_SYNC2SCO		= BIT(7),
-	BT_COEX_CORUNNING		= BIT(8),
-	BT_COEX_MPLUT			= BIT(9),
-	BT_COEX_TTC			= BIT(20),
-	BT_COEX_RRC			= BIT(21),
-};
-
-/*
- * indicates what has changed in the BT_COEX command.
- * BT_VALID_ENABLE must be set for each command. Commands without this bit will
- * discarded by the firmware
- */
-enum iwl_bt_coex_valid_bit_msk {
-	BT_VALID_ENABLE			= BIT(0),
-	BT_VALID_BT_PRIO_BOOST		= BIT(1),
-	BT_VALID_MAX_KILL		= BIT(2),
-	BT_VALID_3W_TMRS		= BIT(3),
-	BT_VALID_KILL_ACK		= BIT(4),
-	BT_VALID_KILL_CTS		= BIT(5),
-	BT_VALID_REDUCED_TX_POWER	= BIT(6),
-	BT_VALID_LUT			= BIT(7),
-	BT_VALID_WIFI_RX_SW_PRIO_BOOST	= BIT(8),
-	BT_VALID_WIFI_TX_SW_PRIO_BOOST	= BIT(9),
-	BT_VALID_MULTI_PRIO_LUT		= BIT(10),
-	BT_VALID_TRM_KICK_FILTER	= BIT(11),
-	BT_VALID_CORUN_LUT_20		= BIT(12),
-	BT_VALID_CORUN_LUT_40		= BIT(13),
-	BT_VALID_ANT_ISOLATION		= BIT(14),
-	BT_VALID_ANT_ISOLATION_THRS	= BIT(15),
-	BT_VALID_TXTX_DELTA_FREQ_THRS	= BIT(16),
-	BT_VALID_TXRX_MAX_FREQ_0	= BIT(17),
-	BT_VALID_SYNC_TO_SCO		= BIT(18),
-	BT_VALID_TTC			= BIT(20),
-	BT_VALID_RRC			= BIT(21),
-};
-
-/**
- * enum iwl_bt_reduced_tx_power - allows to reduce txpower for WiFi frames.
- * @BT_REDUCED_TX_POWER_CTL: reduce Tx power for control frames
- * @BT_REDUCED_TX_POWER_DATA: reduce Tx power for data frames
- *
- * This mechanism allows to have BT and WiFi run concurrently. Since WiFi
- * reduces its Tx power, it can work along with BT, hence reducing the amount
- * of WiFi frames being killed by BT.
- */
-enum iwl_bt_reduced_tx_power {
-	BT_REDUCED_TX_POWER_CTL		= BIT(0),
-	BT_REDUCED_TX_POWER_DATA	= BIT(1),
-};
-
 enum iwl_bt_coex_lut_type {
 	BT_COEX_TIGHT_LUT = 0,
 	BT_COEX_LOOSE_LUT,
@@ -158,64 +79,9 @@ enum iwl_bt_coex_lut_type {
 	BT_COEX_INVALID_LUT = 0xff,
 }; /* BT_COEX_DECISION_LUT_INDEX_API_E_VER_1 */
 
-#define BT_COEX_LUT_SIZE (12)
 #define BT_COEX_CORUN_LUT_SIZE (32)
-#define BT_COEX_MULTI_PRIO_LUT_SIZE (2)
-#define BT_COEX_BOOST_SIZE (4)
 #define BT_REDUCED_TX_POWER_BIT BIT(7)
 
-/**
- * struct iwl_bt_coex_cmd_old - bt coex configuration command
- * @flags:&enum iwl_bt_coex_flags
- * @max_kill:
- * @bt_reduced_tx_power: enum %iwl_bt_reduced_tx_power
- * @override_primary_lut: enum %iwl_bt_coex_lut_type: BT_COEX_INVALID_LUT
- *	should be set by default
- * @override_secondary_lut: enum %iwl_bt_coex_lut_type: BT_COEX_INVALID_LUT
- *	should be set by default
- * @bt4_antenna_isolation: antenna isolation
- * @bt4_antenna_isolation_thr: antenna threshold value
- * @bt4_tx_tx_delta_freq_thr: TxTx delta frequency
- * @bt4_tx_rx_max_freq0: TxRx max frequency
- * @bt_prio_boost: BT priority boost registers
- * @wifi_tx_prio_boost: SW boost of wifi tx priority
- * @wifi_rx_prio_boost: SW boost of wifi rx priority
- * @kill_ack_msk: kill ACK mask. 1 - Tx ACK, 0 - kill Tx of ACK.
- * @kill_cts_msk: kill CTS mask. 1 - Tx CTS, 0 - kill Tx of CTS.
- * @decision_lut: PTA decision LUT, per Prio-Ch
- * @bt4_multiprio_lut: multi priority LUT configuration
- * @bt4_corun_lut20: co-running 20 MHz LUT configuration
- * @bt4_corun_lut40: co-running 40 MHz LUT configuration
- * @valid_bit_msk: enum %iwl_bt_coex_valid_bit_msk
- *
- * The structure is used for the BT_COEX command.
- */
-struct iwl_bt_coex_cmd_old {
-	__le32 flags;
-	u8 max_kill;
-	u8 bt_reduced_tx_power;
-	u8 override_primary_lut;
-	u8 override_secondary_lut;
-
-	u8 bt4_antenna_isolation;
-	u8 bt4_antenna_isolation_thr;
-	u8 bt4_tx_tx_delta_freq_thr;
-	u8 bt4_tx_rx_max_freq0;
-
-	__le32 bt_prio_boost[BT_COEX_BOOST_SIZE];
-	__le32 wifi_tx_prio_boost;
-	__le32 wifi_rx_prio_boost;
-	__le32 kill_ack_msk;
-	__le32 kill_cts_msk;
-
-	__le32 decision_lut[BT_COEX_MAX_LUT][BT_COEX_LUT_SIZE];
-	__le32 bt4_multiprio_lut[BT_COEX_MULTI_PRIO_LUT_SIZE];
-	__le32 bt4_corun_lut20[BT_COEX_CORUN_LUT_SIZE];
-	__le32 bt4_corun_lut40[BT_COEX_CORUN_LUT_SIZE];
-
-	__le32 valid_bit_msk;
-} __packed; /* BT_COEX_CMD_API_S_VER_5 */
-
 enum iwl_bt_coex_mode {
 	BT_COEX_DISABLE			= 0x0,
 	BT_COEX_NW			= 0x1,
@@ -385,92 +251,4 @@ struct iwl_bt_coex_profile_notif {
 	u8 reserved[3];
 } __packed; /* BT_COEX_PROFILE_NTFY_API_S_VER_4 */
 
-enum iwl_bt_coex_prio_table_event {
-	BT_COEX_PRIO_TBL_EVT_INIT_CALIB1		= 0,
-	BT_COEX_PRIO_TBL_EVT_INIT_CALIB2		= 1,
-	BT_COEX_PRIO_TBL_EVT_PERIODIC_CALIB_LOW1	= 2,
-	BT_COEX_PRIO_TBL_EVT_PERIODIC_CALIB_LOW2	= 3,
-	BT_COEX_PRIO_TBL_EVT_PERIODIC_CALIB_HIGH1	= 4,
-	BT_COEX_PRIO_TBL_EVT_PERIODIC_CALIB_HIGH2	= 5,
-	BT_COEX_PRIO_TBL_EVT_DTIM			= 6,
-	BT_COEX_PRIO_TBL_EVT_SCAN52			= 7,
-	BT_COEX_PRIO_TBL_EVT_SCAN24			= 8,
-	BT_COEX_PRIO_TBL_EVT_IDLE			= 9,
-	BT_COEX_PRIO_TBL_EVT_MAX			= 16,
-}; /* BT_COEX_PRIO_TABLE_EVENTS_API_E_VER_1 */
-
-enum iwl_bt_coex_prio_table_prio {
-	BT_COEX_PRIO_TBL_DISABLED	= 0,
-	BT_COEX_PRIO_TBL_PRIO_LOW	= 1,
-	BT_COEX_PRIO_TBL_PRIO_HIGH	= 2,
-	BT_COEX_PRIO_TBL_PRIO_BYPASS	= 3,
-	BT_COEX_PRIO_TBL_PRIO_COEX_OFF	= 4,
-	BT_COEX_PRIO_TBL_PRIO_COEX_ON	= 5,
-	BT_COEX_PRIO_TBL_PRIO_COEX_IDLE = 6,
-	BT_COEX_PRIO_TBL_MAX		= 8,
-}; /* BT_COEX_PRIO_TABLE_PRIORITIES_API_E_VER_1 */
-
-#define BT_COEX_PRIO_TBL_SHRD_ANT_POS     (0)
-#define BT_COEX_PRIO_TBL_PRIO_POS         (1)
-#define BT_COEX_PRIO_TBL_RESERVED_POS     (4)
-
-/**
- * struct iwl_bt_coex_prio_tbl_cmd - priority table for BT coex
- * @prio_tbl:
- */
-struct iwl_bt_coex_prio_tbl_cmd {
-	u8 prio_tbl[BT_COEX_PRIO_TBL_EVT_MAX];
-} __packed;
-
-/**
- * struct iwl_bt_coex_ci_cmd_old - bt coex channel inhibition command
- * @bt_primary_ci:
- * @bt_secondary_ci:
- * @co_run_bw_primary:
- * @co_run_bw_secondary:
- * @primary_ch_phy_id:
- * @secondary_ch_phy_id:
- *
- * Used for BT_COEX_CI command
- */
-struct iwl_bt_coex_ci_cmd_old {
-	__le64 bt_primary_ci;
-	__le64 bt_secondary_ci;
-
-	u8 co_run_bw_primary;
-	u8 co_run_bw_secondary;
-	u8 primary_ch_phy_id;
-	u8 secondary_ch_phy_id;
-} __packed; /* BT_CI_MSG_API_S_VER_1 */
-
-/**
- * struct iwl_bt_coex_profile_notif_old - notification about BT coex
- * @mbox_msg: message from BT to WiFi
- * @msg_idx: the index of the message
- * @bt_status: 0 - off, 1 - on
- * @bt_open_conn: number of BT connections open
- * @bt_traffic_load: load of BT traffic
- * @bt_agg_traffic_load: aggregated load of BT traffic
- * @bt_ci_compliance: 0 - no CI compliance, 1 - CI compliant
- * @primary_ch_lut: LUT used for primary channel
- * @secondary_ch_lut: LUT used for secondary channel
- * @bt_activity_grading: the activity of BT enum %iwl_bt_activity_grading
- */
-struct iwl_bt_coex_profile_notif_old {
-	__le32 mbox_msg[4];
-	__le32 msg_idx;
-	u8 bt_status;
-	u8 bt_open_conn;
-	u8 bt_traffic_load;
-	u8 bt_agg_traffic_load;
-	u8 bt_ci_compliance;
-	u8 ttc_enabled;
-	u8 rrc_enabled;
-	u8 reserved;
-
-	__le32 primary_ch_lut;
-	__le32 secondary_ch_lut;
-	__le32 bt_activity_grading;
-} __packed; /* BT_COEX_PROFILE_NTFY_API_S_VER_3 */
-
 #endif /* __fw_api_bt_coex_h__ */
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 5c044ea..e44c337 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -1020,11 +1020,7 @@ static void iwl_mvm_restart_cleanup(struct iwl_mvm *mvm)
 	memset(mvm->sta_deferred_frames, 0, sizeof(mvm->sta_deferred_frames));
 	memset(mvm->tfd_drained, 0, sizeof(mvm->tfd_drained));
 	memset(&mvm->last_bt_notif, 0, sizeof(mvm->last_bt_notif));
-	memset(&mvm->last_bt_notif_old, 0, sizeof(mvm->last_bt_notif_old));
 	memset(&mvm->last_bt_ci_cmd, 0, sizeof(mvm->last_bt_ci_cmd));
-	memset(&mvm->last_bt_ci_cmd_old, 0, sizeof(mvm->last_bt_ci_cmd_old));
-	memset(&mvm->bt_ack_kill_msk, 0, sizeof(mvm->bt_ack_kill_msk));
-	memset(&mvm->bt_cts_kill_msk, 0, sizeof(mvm->bt_cts_kill_msk));
 
 	ieee80211_wake_queues(mvm->hw);
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index e240f19..c440b10 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -932,11 +932,6 @@ struct iwl_mvm {
 	wait_queue_head_t d0i3_exit_waitq;
 
 	/* BT-Coex */
-	u8 bt_ack_kill_msk[NUM_PHY_CTX];
-	u8 bt_cts_kill_msk[NUM_PHY_CTX];
-
-	struct iwl_bt_coex_profile_notif_old last_bt_notif_old;
-	struct iwl_bt_coex_ci_cmd_old last_bt_ci_cmd_old;
 	struct iwl_bt_coex_profile_notif last_bt_notif;
 	struct iwl_bt_coex_ci_cmd last_bt_ci_cmd;
 
-- 
2.8.1

