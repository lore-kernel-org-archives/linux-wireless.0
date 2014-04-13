Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:53520 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755605AbaDMTVK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Apr 2014 15:21:10 -0400
Received: by mail-wg0-f47.google.com with SMTP id x12so7420218wgg.30
        for <linux-wireless@vger.kernel.org>; Sun, 13 Apr 2014 12:21:08 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 40/47] iwlwifi: mvm: BT Coex - minor API change
Date: Sun, 13 Apr 2014 22:19:55 +0300
Message-Id: <1397416802-32403-40-git-send-email-egrumbach@gmail.com> (sfid-20140413_213515_990347_E459892E)
In-Reply-To: <534AE330.2020805@gmail.com>
References: <534AE330.2020805@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

The BT Coex API underwent a minor backward compatible API
change.
We now need to set an invalid value in the override fields.
While at it, add kerneldoc comments on the fields in the
command.

Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/coex.c        |  2 ++
 drivers/net/wireless/iwlwifi/mvm/fw-api-coex.h | 38 +++++++++++++++-----------
 2 files changed, 24 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/coex.c b/drivers/net/wireless/iwlwifi/mvm/coex.c
index 3755ad4..a1403d4 100644
--- a/drivers/net/wireless/iwlwifi/mvm/coex.c
+++ b/drivers/net/wireless/iwlwifi/mvm/coex.c
@@ -580,6 +580,8 @@ int iwl_send_bt_init_conf(struct iwl_mvm *mvm)
 	bt_cmd->bt4_antenna_isolation = iwlwifi_mod_params.ant_coupling;
 	bt_cmd->bt4_tx_tx_delta_freq_thr = 15;
 	bt_cmd->bt4_tx_rx_max_freq0 = 15;
+	bt_cmd->override_primary_lut = BT_COEX_INVALID_LUT;
+	bt_cmd->override_secondary_lut = BT_COEX_INVALID_LUT;
 
 	flags = iwlwifi_mod_params.bt_coex_active ?
 			BT_COEX_NW : BT_COEX_DISABLE;
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api-coex.h b/drivers/net/wireless/iwlwifi/mvm/fw-api-coex.h
index 21877e5..5fe82c29 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api-coex.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api-coex.h
@@ -141,7 +141,8 @@ enum iwl_bt_coex_lut_type {
 	BT_COEX_TX_DIS_LUT,
 
 	BT_COEX_MAX_LUT,
-};
+	BT_COEX_INVALID_LUT = 0xff,
+}; /* BT_COEX_DECISION_LUT_INDEX_API_E_VER_1 */
 
 #define BT_COEX_LUT_SIZE (12)
 #define BT_COEX_CORUN_LUT_SIZE (32)
@@ -154,19 +155,23 @@ enum iwl_bt_coex_lut_type {
  * @flags:&enum iwl_bt_coex_flags
  * @max_kill:
  * @bt_reduced_tx_power: enum %iwl_bt_reduced_tx_power
- * @bt4_antenna_isolation:
- * @bt4_antenna_isolation_thr:
- * @bt4_tx_tx_delta_freq_thr:
- * @bt4_tx_rx_max_freq0:
- * @bt_prio_boost:
+ * @override_primary_lut: enum %iwl_bt_coex_lut_type: BT_COEX_INVALID_LUT
+ *	should be set by default
+ * @override_secondary_lut: enum %iwl_bt_coex_lut_type: BT_COEX_INVALID_LUT
+ *	should be set by default
+ * @bt4_antenna_isolation: antenna isolation
+ * @bt4_antenna_isolation_thr: antenna threshold value
+ * @bt4_tx_tx_delta_freq_thr: TxTx delta frequency
+ * @bt4_tx_rx_max_freq0: TxRx max frequency
+ * @bt_prio_boost: BT priority boost registers
  * @wifi_tx_prio_boost: SW boost of wifi tx priority
  * @wifi_rx_prio_boost: SW boost of wifi rx priority
- * @kill_ack_msk:
- * @kill_cts_msk:
- * @decision_lut:
- * @bt4_multiprio_lut:
- * @bt4_corun_lut20:
- * @bt4_corun_lut40:
+ * @kill_ack_msk: kill ACK mask. 1 - Tx ACK, 0 - kill Tx of ACK.
+ * @kill_cts_msk: kill CTS mask. 1 - Tx CTS, 0 - kill Tx of CTS.
+ * @decision_lut: PTA decision LUT, per Prio-Ch
+ * @bt4_multiprio_lut: multi priority LUT configuration
+ * @bt4_corun_lut20: co-running 20 MHz LUT configuration
+ * @bt4_corun_lut40: co-running 40 MHz LUT configuration
  * @valid_bit_msk: enum %iwl_bt_coex_valid_bit_msk
  *
  * The structure is used for the BT_COEX command.
@@ -175,7 +180,8 @@ struct iwl_bt_coex_cmd {
 	__le32 flags;
 	u8 max_kill;
 	u8 bt_reduced_tx_power;
-	u8 reserved[2];
+	u8 override_primary_lut;
+	u8 override_secondary_lut;
 
 	u8 bt4_antenna_isolation;
 	u8 bt4_antenna_isolation_thr;
@@ -194,7 +200,7 @@ struct iwl_bt_coex_cmd {
 	__le32 bt4_corun_lut40[BT_COEX_CORUN_LUT_SIZE];
 
 	__le32 valid_bit_msk;
-} __packed; /* BT_COEX_CMD_API_S_VER_3 */
+} __packed; /* BT_COEX_CMD_API_S_VER_5 */
 
 /**
  * struct iwl_bt_coex_ci_cmd - bt coex channel inhibition command
@@ -282,7 +288,7 @@ enum iwl_bt_activity_grading {
 	BT_ON_NO_CONNECTION	= 1,
 	BT_LOW_TRAFFIC		= 2,
 	BT_HIGH_TRAFFIC		= 3,
-};
+}; /* BT_COEX_BT_ACTIVITY_GRADING_API_E_VER_1 */
 
 /**
  * struct iwl_bt_coex_profile_notif - notification about BT coex
@@ -310,7 +316,7 @@ struct iwl_bt_coex_profile_notif {
 	__le32 primary_ch_lut;
 	__le32 secondary_ch_lut;
 	__le32 bt_activity_grading;
-} __packed; /* BT_COEX_PROFILE_NTFY_API_S_VER_2 */
+} __packed; /* BT_COEX_PROFILE_NTFY_API_S_VER_3 */
 
 enum iwl_bt_coex_prio_table_event {
 	BT_COEX_PRIO_TBL_EVT_INIT_CALIB1		= 0,
-- 
1.8.3.2

