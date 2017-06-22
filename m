Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:34346 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753842AbdFVVVq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Jun 2017 17:21:46 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 23 Jun 2017 00:20:47 +0300
Message-Id: <20170622212101.16422-12-luca@coelho.fi> (sfid-20170622_232159_781012_0B221837)
In-Reply-To: <20170622212101.16422-1-luca@coelho.fi>
References: <20170622212101.16422-1-luca@coelho.fi>
Subject: [PATCH 11/25] iwlwifi: mvm: track and report IBSS manager status to mac80211
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Shaul reported that when iwlmvm was sending beacons, it didn't properly
also take ownership of the probe responses. This is because the whole
mac80211 callback (tx_last_beacon) wasn't implemented. Fix that to make
IBSS discovery work better.

Reported-by: Shaul Triebitz <shaul.triebitz@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c | 1 +
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 9 +++++++++
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h      | 3 +++
 3 files changed, 13 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
index d573ac739414..50a71da2e96e 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
@@ -1457,6 +1457,7 @@ void iwl_mvm_rx_beacon_notif(struct iwl_mvm *mvm,
 
 	beacon_notify_hdr = &beacon->beacon_notify_hdr;
 	mvm->ap_last_beacon_gp2 = le32_to_cpu(beacon->gp2);
+	mvm->ibss_manager = beacon->ibss_mgr_status != 0;
 
 	agg_status = iwl_mvm_get_agg_status(mvm, beacon_notify_hdr);
 	status = le16_to_cpu(agg_status->status) & TX_STATUS_MSK;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 05041d37773b..75ec567ab9e2 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -3737,6 +3737,13 @@ static int iwl_mvm_switch_vif_chanctx(struct ieee80211_hw *hw,
 	return ret;
 }
 
+static int iwl_mvm_tx_last_beacon(struct ieee80211_hw *hw)
+{
+	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
+
+	return mvm->ibss_manager;
+}
+
 static int iwl_mvm_set_tim(struct ieee80211_hw *hw,
 			   struct ieee80211_sta *sta,
 			   bool set)
@@ -4338,6 +4345,8 @@ const struct ieee80211_ops iwl_mvm_hw_ops = {
 	.join_ibss = iwl_mvm_start_ap_ibss,
 	.leave_ibss = iwl_mvm_stop_ap_ibss,
 
+	.tx_last_beacon = iwl_mvm_tx_last_beacon,
+
 	.set_tim = iwl_mvm_set_tim,
 
 	.channel_switch = iwl_mvm_channel_switch,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index cdd13bc343e6..a4bee9c740e0 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -1021,6 +1021,9 @@ struct iwl_mvm {
 	/* system time of last beacon (for AP/GO interface) */
 	u32 ap_last_beacon_gp2;
 
+	/* indicates that we transmitted the last beacon */
+	bool ibss_manager;
+
 	bool lar_regdom_set;
 	enum iwl_mcc_source mcc_src;
 
-- 
2.11.0
