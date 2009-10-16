Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:40823 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752650AbZJPFUx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Oct 2009 01:20:53 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Samuel Ortiz <sameo@linux.intel.com>, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 08/16] iwmc3200wifi: Update fixed size config definitions
Date: Fri, 16 Oct 2009 13:18:52 +0800
Message-Id: <1255670340-22565-9-git-send-email-yi.zhu@intel.com>
In-Reply-To: <1255670340-22565-8-git-send-email-yi.zhu@intel.com>
References: <1255670340-22565-1-git-send-email-yi.zhu@intel.com>
 <1255670340-22565-2-git-send-email-yi.zhu@intel.com>
 <1255670340-22565-3-git-send-email-yi.zhu@intel.com>
 <1255670340-22565-4-git-send-email-yi.zhu@intel.com>
 <1255670340-22565-5-git-send-email-yi.zhu@intel.com>
 <1255670340-22565-6-git-send-email-yi.zhu@intel.com>
 <1255670340-22565-7-git-send-email-yi.zhu@intel.com>
 <1255670340-22565-8-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Samuel Ortiz <sameo@linux.intel.com>

We need to be in sync with the latest firmware API.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwmc3200wifi/commands.h |   60 +++++++++++++++++++++++++-
 1 files changed, 58 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwmc3200wifi/commands.h b/drivers/net/wireless/iwmc3200wifi/commands.h
index e486f8e..511b6e3 100644
--- a/drivers/net/wireless/iwmc3200wifi/commands.h
+++ b/drivers/net/wireless/iwmc3200wifi/commands.h
@@ -102,7 +102,6 @@ enum {
 	CFG_SCAN_NUM_PASSIVE_CHAN_PER_PARTIAL_SCAN,
 	CFG_TLC_SUPPORTED_TX_HT_RATES,
 	CFG_TLC_SUPPORTED_TX_RATES,
-	CFG_TLC_VALID_ANTENNA,
 	CFG_TLC_SPATIAL_STREAM_SUPPORTED,
 	CFG_TLC_RETRY_PER_RATE,
 	CFG_TLC_RETRY_PER_HT_RATE,
@@ -136,6 +135,10 @@ enum {
 	CFG_TLC_RENEW_ADDBA_DELAY,
 	CFG_TLC_NUM_OF_MULTISEC_TO_COUN_LOAD,
 	CFG_TLC_IS_STABLE_IN_HT,
+	CFG_TLC_SR_SIC_1ST_FAIL,
+	CFG_TLC_SR_SIC_1ST_PASS,
+	CFG_TLC_SR_SIC_TOTAL_FAIL,
+	CFG_TLC_SR_SIC_TOTAL_PASS,
 	CFG_RLC_CHAIN_CTRL,
 	CFG_TRK_TABLE_OP_MODE,
 	CFG_TRK_TABLE_RSSI_THRESHOLD,
@@ -147,6 +150,58 @@ enum {
 	CFG_MLME_DBG_NOTIF_BLOCK,
 	CFG_BT_OFF_BECONS_INTERVALS,
 	CFG_BT_FRAG_DURATION,
+	CFG_ACTIVE_CHAINS,
+	CFG_CALIB_CTRL,
+	CFG_CAPABILITY_SUPPORTED_HT_RATES,
+	CFG_HT_MAC_PARAM_INFO,
+	CFG_MIMO_PS_MODE,
+	CFG_HT_DEFAULT_CAPABILIES_INFO,
+	CFG_LED_SC_RESOLUTION_FACTOR,
+	CFG_PTAM_ENERGY_CCK_DET_DEFAULT,
+	CFG_PTAM_CORR40_4_TH_ADD_MIN_MRC_DEFAULT,
+	CFG_PTAM_CORR40_4_TH_ADD_MIN_DEFAULT,
+	CFG_PTAM_CORR32_4_TH_ADD_MIN_MRC_DEFAULT,
+	CFG_PTAM_CORR32_4_TH_ADD_MIN_DEFAULT,
+	CFG_PTAM_CORR32_1_TH_ADD_MIN_MRC_DEFAULT,
+	CFG_PTAM_CORR32_1_TH_ADD_MIN_DEFAULT,
+	CFG_PTAM_ENERGY_CCK_DET_MIN_VAL,
+	CFG_PTAM_CORR40_4_TH_ADD_MIN_MRC_MIN_VAL,
+	CFG_PTAM_CORR40_4_TH_ADD_MIN_MIN_VAL,
+	CFG_PTAM_CORR32_4_TH_ADD_MIN_MRC_MIN_VAL,
+	CFG_PTAM_CORR32_4_TH_ADD_MIN_MIN_VAL,
+	CFG_PTAM_CORR32_1_TH_ADD_MIN_MRC_MIN_VAL,
+	CFG_PTAM_CORR32_1_TH_ADD_MIN_MIN_VAL,
+	CFG_PTAM_ENERGY_CCK_DET_MAX_VAL,
+	CFG_PTAM_CORR40_4_TH_ADD_MIN_MRC_MAX_VAL,
+	CFG_PTAM_CORR40_4_TH_ADD_MIN_MAX_VAL,
+	CFG_PTAM_CORR32_4_TH_ADD_MIN_MRC_MAX_VAL,
+	CFG_PTAM_CORR32_4_TH_ADD_MIN_MAX_VAL,
+	CFG_PTAM_CORR32_1_TH_ADD_MIN_MRC_MAX_VAL,
+	CFG_PTAM_CORR32_1_TH_ADD_MIN_MAX_VAL,
+	CFG_PTAM_ENERGY_CCK_DET_STEP_VAL,
+	CFG_PTAM_CORR40_4_TH_ADD_MIN_MRC_STEP_VAL,
+	CFG_PTAM_CORR40_4_TH_ADD_MIN_STEP_VAL,
+	CFG_PTAM_CORR32_4_TH_ADD_MIN_MRC_STEP_VAL,
+	CFG_PTAM_CORR32_4_TH_ADD_MIN_STEP_VAL,
+	CFG_PTAM_CORR32_1_TH_ADD_MIN_MRC_STEP_VAL,
+	CFG_PTAM_CORR32_1_TH_ADD_MIN_STEP_VAL,
+	CFG_PTAM_LINK_SENS_FA_OFDM_MAX,
+	CFG_PTAM_LINK_SENS_FA_OFDM_MIN,
+	CFG_PTAM_LINK_SENS_FA_CCK_MAX,
+	CFG_PTAM_LINK_SENS_FA_CCK_MIN,
+	CFG_PTAM_LINK_SENS_NRG_DIFF,
+	CFG_PTAM_LINK_SENS_NRG_MARGIN,
+	CFG_PTAM_LINK_SENS_MAX_NUMBER_OF_TIMES_IN_CCK_NO_FA,
+	CFG_PTAM_LINK_SENS_AUTO_CORR_MAX_TH_CCK,
+	CFG_AGG_MGG_TID_LOAD_ADDBA_THRESHOLD,
+	CFG_AGG_MGG_TID_LOAD_DELBA_THRESHOLD,
+	CFG_AGG_MGG_ADDBA_BUF_SIZE,
+	CFG_AGG_MGG_ADDBA_INACTIVE_TIMEOUT,
+	CFG_AGG_MGG_ADDBA_DEBUG_FLAGS,
+	CFG_SCAN_PERIODIC_RSSI_HIGH_THRESHOLD,
+	CFG_SCAN_PERIODIC_COEF_RSSI_HIGH,
+	CFG_11D_ENABLED,
+	CFG_11H_FEATURE_FLAGS,
 
 	/* <-- LAST --> */
 	CFG_TBL_FIX_LAST
@@ -155,7 +210,8 @@ enum {
 /* variable size table */
 enum {
 	CFG_NET_ADDR = 0,
-	CFG_PROFILE,
+	CFG_LED_PATTERN_TABLE,
+
 	/* <-- LAST --> */
 	CFG_TBL_VAR_LAST
 };
-- 
1.6.0.4

