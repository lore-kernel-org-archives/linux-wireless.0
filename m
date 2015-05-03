Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:59736 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751469AbbECTcA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 May 2015 15:32:00 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Liad Kaufman <liad.kaufman@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 02/42] iwlwifi: rs: remove code duplication when filling lq cmd
Date: Sun,  3 May 2015 22:31:13 +0300
Message-Id: <1430681513-7838-2-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150503_213204_809856_665FB95C)
In-Reply-To: <1430681438.3240.3.camel@intel.com>
References: <1430681438.3240.3.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liad Kaufman <liad.kaufman@intel.com>

Same code appear a few lines later while the position has
no effect on the actual flow.

Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/rs.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index f9928f2..a9ad644 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -3223,9 +3223,6 @@ static void rs_fill_lq_cmd(struct iwl_mvm *mvm,
 	if (mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_LQ_SS_PARAMS)
 		rs_set_lq_ss_params(mvm, sta, lq_sta, initial_rate);
 
-	if (num_of_ant(initial_rate->ant) == 1)
-		lq_cmd->single_stream_ant_msk = initial_rate->ant;
-
 	mvmsta = iwl_mvm_sta_from_mac80211(sta);
 	mvmvif = iwl_mvm_vif_from_mac80211(mvmsta->vif);
 
-- 
2.1.0

