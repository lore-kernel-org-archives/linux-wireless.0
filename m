Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f50.google.com ([74.125.83.50]:50755 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753565AbaBCU7y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Feb 2014 15:59:54 -0500
Received: by mail-ee0-f50.google.com with SMTP id d17so3855014eek.23
        for <linux-wireless@vger.kernel.org>; Mon, 03 Feb 2014 12:59:53 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 57/62] iwlwifi: mvm: don't look at power commmand to decide if power is enabled
Date: Mon,  3 Feb 2014 22:58:03 +0200
Message-Id: <1391461088-8082-57-git-send-email-egrumbach@gmail.com> (sfid-20140203_220007_034338_50163A91)
In-Reply-To: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
References: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/power.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/power.c b/drivers/net/wireless/iwlwifi/mvm/power.c
index f9ddd79..20bc376 100644
--- a/drivers/net/wireless/iwlwifi/mvm/power.c
+++ b/drivers/net/wireless/iwlwifi/mvm/power.c
@@ -423,6 +423,7 @@ static int iwl_mvm_power_mac_update_mode(struct iwl_mvm *mvm,
 	int ret;
 	bool ba_enable;
 	struct iwl_mac_power_cmd cmd = {};
+	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
 
 	if (vif->type != NL80211_IFTYPE_STATION)
 		return 0;
@@ -439,8 +440,9 @@ static int iwl_mvm_power_mac_update_mode(struct iwl_mvm *mvm,
 	if (ret)
 		return ret;
 
-	ba_enable = !!(cmd.flags &
-		       cpu_to_le16(POWER_FLAGS_POWER_MANAGEMENT_ENA_MSK));
+	ba_enable = !(iwlmvm_mod_params.power_scheme == IWL_POWER_SCHEME_CAM ||
+		      mvm->ps_prevented || mvm->bound_vif_cnt > 1 ||
+		      !vif->bss_conf.ps || iwl_mvm_vif_low_latency(mvmvif));
 
 	return iwl_mvm_update_beacon_abort(mvm, vif, ba_enable);
 }
-- 
1.7.9.5

