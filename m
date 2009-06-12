Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:6527 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756740AbZFLUPw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Jun 2009 16:15:52 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 7/8] iwlwifi: no need to refer to max_nrg_cck range value
Date: Fri, 12 Jun 2009 13:22:54 -0700
Message-Id: <1244838175-15491-8-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1244838175-15491-7-git-send-email-reinette.chatre@intel.com>
References: <1244838175-15491-1-git-send-email-reinette.chatre@intel.com>
 <1244838175-15491-2-git-send-email-reinette.chatre@intel.com>
 <1244838175-15491-3-git-send-email-reinette.chatre@intel.com>
 <1244838175-15491-4-git-send-email-reinette.chatre@intel.com>
 <1244838175-15491-5-git-send-email-reinette.chatre@intel.com>
 <1244838175-15491-6-git-send-email-reinette.chatre@intel.com>
 <1244838175-15491-7-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

max_nrg_cck value inside the sensitivity range structure is not needed
for sensitivity calibration.
Keep the parameter in sensitivity structure but set the value to "0" in case
needed in the future implementation.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c  |    2 +-
 drivers/net/wireless/iwlwifi/iwl-5000.c  |    2 +-
 drivers/net/wireless/iwlwifi/iwl-calib.c |    7 +------
 3 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 8f3d4bc..edbb0bf 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -728,7 +728,7 @@ static int iwl4965_alive_notify(struct iwl_priv *priv)
 
 static struct iwl_sensitivity_ranges iwl4965_sensitivity = {
 	.min_nrg_cck = 97,
-	.max_nrg_cck = 0,
+	.max_nrg_cck = 0, /* not used, set to 0 */
 
 	.auto_corr_min_ofdm = 85,
 	.auto_corr_min_ofdm_mrc = 170,
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 0e445a9..85e8bac 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -388,7 +388,7 @@ void iwl5000_rts_tx_cmd_flag(struct ieee80211_tx_info *info,
 
 static struct iwl_sensitivity_ranges iwl5000_sensitivity = {
 	.min_nrg_cck = 95,
-	.max_nrg_cck = 0,
+	.max_nrg_cck = 0, /* not used, set to 0 */
 	.auto_corr_min_ofdm = 90,
 	.auto_corr_min_ofdm_mrc = 170,
 	.auto_corr_min_ofdm_x1 = 120,
diff --git a/drivers/net/wireless/iwlwifi/iwl-calib.c b/drivers/net/wireless/iwlwifi/iwl-calib.c
index a5d6367..f8bf592 100644
--- a/drivers/net/wireless/iwlwifi/iwl-calib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-calib.c
@@ -251,12 +251,7 @@ static int iwl_sens_energy_cck(struct iwl_priv *priv,
 
 		/* increase energy threshold (reduce nrg value)
 		 *   to decrease sensitivity */
-		if (data->nrg_th_cck >
-			(ranges->max_nrg_cck + NRG_STEP_CCK))
-			data->nrg_th_cck = data->nrg_th_cck
-						 - NRG_STEP_CCK;
-		else
-			data->nrg_th_cck = ranges->max_nrg_cck;
+		data->nrg_th_cck = data->nrg_th_cck - NRG_STEP_CCK;
 	/* Else if we got fewer than desired, increase sensitivity */
 	} else if (false_alarms < min_false_alarms) {
 		data->nrg_curr_state = IWL_FA_TOO_FEW;
-- 
1.5.6.3

