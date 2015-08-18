Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:25231 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752041AbbHRH5w (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Aug 2015 03:57:52 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Avri Altman <avri.altman@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 04/26] iwlwifi: mvm: revert to our old skip over dtim policy
Date: Tue, 18 Aug 2015 10:57:14 +0300
Message-Id: <1439884656-18146-4-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150818_095803_784380_AC802017)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E8110F8@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E8110F8@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avri Altman <avri.altman@intel.com>

Our firmware scheduler used to suffer from false wake-up on 500 time units.
We had to came up with a formula to address this buggy behavior.
Now that our firmware is fixed, we can go back to our old policy.

Signed-off-by: Avri Altman <avri.altman@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/power.c | 28 ++--------------------------
 1 file changed, 2 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/power.c b/drivers/net/wireless/iwlwifi/mvm/power.c
index 506294f..c4e0890 100644
--- a/drivers/net/wireless/iwlwifi/mvm/power.c
+++ b/drivers/net/wireless/iwlwifi/mvm/power.c
@@ -288,27 +288,6 @@ static bool iwl_mvm_power_allow_uapsd(struct iwl_mvm *mvm,
 	return true;
 }
 
-static int iwl_mvm_power_get_skip_over_dtim(int dtimper, int bi)
-{
-	int numerator;
-	int dtim_interval = dtimper * bi;
-
-	if (WARN_ON(!dtim_interval))
-		return 0;
-
-	if (dtimper == 1) {
-		if (bi > 100)
-			numerator = 408;
-		else
-			numerator = 510;
-	} else if (dtimper < 10) {
-		numerator = 612;
-	} else {
-		return 0;
-	}
-	return max(1, (numerator / dtim_interval));
-}
-
 static bool iwl_mvm_power_is_radar(struct ieee80211_vif *vif)
 {
 	struct ieee80211_chanctx_conf *chanctx_conf;
@@ -378,11 +357,8 @@ static void iwl_mvm_power_build_cmd(struct iwl_mvm *mvm,
 	if (!radar_detect && (dtimper < 10) &&
 	    (iwlmvm_mod_params.power_scheme == IWL_POWER_SCHEME_LP ||
 	     mvm->cur_ucode == IWL_UCODE_WOWLAN)) {
-		cmd->skip_dtim_periods =
-			iwl_mvm_power_get_skip_over_dtim(dtimper, bi);
-		if (cmd->skip_dtim_periods)
-			cmd->flags |=
-				cpu_to_le16(POWER_FLAGS_SKIP_OVER_DTIM_MSK);
+		cmd->flags |= cpu_to_le16(POWER_FLAGS_SKIP_OVER_DTIM_MSK);
+		cmd->skip_dtim_periods = 3;
 	}
 
 	if (mvm->cur_ucode != IWL_UCODE_WOWLAN) {
-- 
2.1.4

