Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:37228 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161438Ab2COU2D (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Mar 2012 16:28:03 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 08/26] iwlwifi: remove support_wimax_coexist
Date: Thu, 15 Mar 2012 13:26:48 -0700
Message-Id: <1331843226-29860-9-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120315_212854_115537_76886C64)
In-Reply-To: <1331843226-29860-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1331843226-29860-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's no device using this mechanism.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-shared.h |    2 -
 drivers/net/wireless/iwlwifi/iwl-ucode.c  |   51 +---------------------------
 2 files changed, 2 insertions(+), 51 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index 94b16cc..18ef286 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -217,7 +217,6 @@ enum iwl_led_mode {
  * @chain_noise_num_beacons: number of beacons used to compute chain noise
  * @adv_thermal_throttle: support advance thermal throttle
  * @support_ct_kill_exit: support ct kill exit condition
- * @support_wimax_coexist: support wimax/wifi co-exist
  * @plcp_delta_threshold: plcp error rate threshold used to trigger
  *	radio tuning when there is a high receiving plcp error rate
  * @chain_noise_scale: default chain noise scale used for gain computation
@@ -240,7 +239,6 @@ struct iwl_base_params {
 	u16 led_compensation;
 	bool adv_thermal_throttle;
 	bool support_ct_kill_exit;
-	const bool support_wimax_coexist;
 	u8 plcp_delta_threshold;
 	s32 chain_noise_scale;
 	unsigned int wd_timeout;
diff --git a/drivers/net/wireless/iwlwifi/iwl-ucode.c b/drivers/net/wireless/iwlwifi/iwl-ucode.c
index a5b2189..f23b283 100644
--- a/drivers/net/wireless/iwlwifi/iwl-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-ucode.c
@@ -40,37 +40,6 @@
 #include "iwl-fh.h"
 #include "iwl-op-mode.h"
 
-static struct iwl_wimax_coex_event_entry cu_priorities[COEX_NUM_OF_EVENTS] = {
-	{COEX_CU_UNASSOC_IDLE_RP, COEX_CU_UNASSOC_IDLE_WP,
-	 0, COEX_UNASSOC_IDLE_FLAGS},
-	{COEX_CU_UNASSOC_MANUAL_SCAN_RP, COEX_CU_UNASSOC_MANUAL_SCAN_WP,
-	 0, COEX_UNASSOC_MANUAL_SCAN_FLAGS},
-	{COEX_CU_UNASSOC_AUTO_SCAN_RP, COEX_CU_UNASSOC_AUTO_SCAN_WP,
-	 0, COEX_UNASSOC_AUTO_SCAN_FLAGS},
-	{COEX_CU_CALIBRATION_RP, COEX_CU_CALIBRATION_WP,
-	 0, COEX_CALIBRATION_FLAGS},
-	{COEX_CU_PERIODIC_CALIBRATION_RP, COEX_CU_PERIODIC_CALIBRATION_WP,
-	 0, COEX_PERIODIC_CALIBRATION_FLAGS},
-	{COEX_CU_CONNECTION_ESTAB_RP, COEX_CU_CONNECTION_ESTAB_WP,
-	 0, COEX_CONNECTION_ESTAB_FLAGS},
-	{COEX_CU_ASSOCIATED_IDLE_RP, COEX_CU_ASSOCIATED_IDLE_WP,
-	 0, COEX_ASSOCIATED_IDLE_FLAGS},
-	{COEX_CU_ASSOC_MANUAL_SCAN_RP, COEX_CU_ASSOC_MANUAL_SCAN_WP,
-	 0, COEX_ASSOC_MANUAL_SCAN_FLAGS},
-	{COEX_CU_ASSOC_AUTO_SCAN_RP, COEX_CU_ASSOC_AUTO_SCAN_WP,
-	 0, COEX_ASSOC_AUTO_SCAN_FLAGS},
-	{COEX_CU_ASSOC_ACTIVE_LEVEL_RP, COEX_CU_ASSOC_ACTIVE_LEVEL_WP,
-	 0, COEX_ASSOC_ACTIVE_LEVEL_FLAGS},
-	{COEX_CU_RF_ON_RP, COEX_CU_RF_ON_WP, 0, COEX_CU_RF_ON_FLAGS},
-	{COEX_CU_RF_OFF_RP, COEX_CU_RF_OFF_WP, 0, COEX_RF_OFF_FLAGS},
-	{COEX_CU_STAND_ALONE_DEBUG_RP, COEX_CU_STAND_ALONE_DEBUG_WP,
-	 0, COEX_STAND_ALONE_DEBUG_FLAGS},
-	{COEX_CU_IPAN_ASSOC_LEVEL_RP, COEX_CU_IPAN_ASSOC_LEVEL_WP,
-	 0, COEX_IPAN_ASSOC_LEVEL_FLAGS},
-	{COEX_CU_RSRVD1_RP, COEX_CU_RSRVD1_WP, 0, COEX_RSRVD1_FLAGS},
-	{COEX_CU_RSRVD2_RP, COEX_CU_RSRVD2_WP, 0, COEX_RSRVD2_FLAGS}
-};
-
 /******************************************************************************
  *
  * uCode download functions
@@ -215,25 +184,9 @@ static int iwl_send_wimax_coex(struct iwl_priv *priv)
 {
 	struct iwl_wimax_coex_cmd coex_cmd;
 
-	if (cfg(priv)->base_params->support_wimax_coexist) {
-		/* UnMask wake up src at associated sleep */
-		coex_cmd.flags = COEX_FLAGS_ASSOC_WA_UNMASK_MSK;
-
-		/* UnMask wake up src at unassociated sleep */
-		coex_cmd.flags |= COEX_FLAGS_UNASSOC_WA_UNMASK_MSK;
-		memcpy(coex_cmd.sta_prio, cu_priorities,
-			sizeof(struct iwl_wimax_coex_event_entry) *
-			 COEX_NUM_OF_EVENTS);
+	/* coexistence is disabled */
+	memset(&coex_cmd, 0, sizeof(coex_cmd));
 
-		/* enabling the coexistence feature */
-		coex_cmd.flags |= COEX_FLAGS_COEX_ENABLE_MSK;
-
-		/* enabling the priorities tables */
-		coex_cmd.flags |= COEX_FLAGS_STA_TABLE_VALID_MSK;
-	} else {
-		/* coexistence is disabled */
-		memset(&coex_cmd, 0, sizeof(coex_cmd));
-	}
 	return iwl_dvm_send_cmd_pdu(priv,
 				COEX_PRIORITY_TABLE_CMD, CMD_SYNC,
 				sizeof(coex_cmd), &coex_cmd);
-- 
1.7.0.4

