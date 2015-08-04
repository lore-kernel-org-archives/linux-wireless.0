Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:37379 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754910AbbHDU7N (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Aug 2015 16:59:13 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Gregory Greenman <gregory.greenman@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 29/37] iwlwifi: mvm: ignore CQM when setting beacon filtering in D0i3 enter flow
Date: Tue,  4 Aug 2015 23:43:19 +0300
Message-Id: <1438721007-23283-29-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150804_225928_333497_847CE6F7)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E7E11FA@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E7E11FA@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gregory Greenman <gregory.greenman@intel.com>

CQM overwrites a few thresholds in the bf command. On the other hand,
when entering D0i3 the thresholds are set to higher values on purpose,
so ignore CQM in this case.

Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/power.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/power.c b/drivers/net/wireless/iwlwifi/mvm/power.c
index 8e2490a..506294f 100644
--- a/drivers/net/wireless/iwlwifi/mvm/power.c
+++ b/drivers/net/wireless/iwlwifi/mvm/power.c
@@ -112,11 +112,12 @@ int iwl_mvm_beacon_filter_send_cmd(struct iwl_mvm *mvm,
 static
 void iwl_mvm_beacon_filter_set_cqm_params(struct iwl_mvm *mvm,
 					  struct ieee80211_vif *vif,
-					  struct iwl_beacon_filter_cmd *cmd)
+					  struct iwl_beacon_filter_cmd *cmd,
+					  bool d0i3)
 {
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
 
-	if (vif->bss_conf.cqm_rssi_thold) {
+	if (vif->bss_conf.cqm_rssi_thold && !d0i3) {
 		cmd->bf_energy_delta =
 			cpu_to_le32(vif->bss_conf.cqm_rssi_hyst);
 		/* fw uses an absolute value for this */
@@ -807,7 +808,7 @@ static int _iwl_mvm_enable_beacon_filter(struct iwl_mvm *mvm,
 	    vif->type != NL80211_IFTYPE_STATION || vif->p2p)
 		return 0;
 
-	iwl_mvm_beacon_filter_set_cqm_params(mvm, vif, cmd);
+	iwl_mvm_beacon_filter_set_cqm_params(mvm, vif, cmd, d0i3);
 	if (!d0i3)
 		iwl_mvm_beacon_filter_debugfs_parameters(vif, cmd);
 	ret = iwl_mvm_beacon_filter_send_cmd(mvm, cmd, cmd_flags);
-- 
2.1.4

