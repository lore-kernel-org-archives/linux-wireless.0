Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:35520 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751188AbdINIuO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Sep 2017 04:50:14 -0400
Received: by mail-pf0-f194.google.com with SMTP id i23so1226398pfi.2
        for <linux-wireless@vger.kernel.org>; Thu, 14 Sep 2017 01:50:14 -0700 (PDT)
From: gavinli@thegavinli.com
To: Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>
Cc: linux-wireless@vger.kernel.org, Gavin Li <git@thegavinli.com>
Subject: [PATCH v1] iwlwifi: mvm: allow monitor mode capture in STA mode
Date: Thu, 14 Sep 2017 01:50:06 -0700
Message-Id: <20170914085006.15933-1-gavinli@thegavinli.com> (sfid-20170914_105018_121624_BDD0005B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gavin Li <git@thegavinli.com>

Open up the filter if there is a monitor interface configured; this
allows all packets on the channel to be captured even if the device is
in STA mode and associated to a BSS.

Signed-off-by: Gavin Li <git@thegavinli.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c |  6 ++++++
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 15 +++++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
index a2bf530eeae4..38b933dc8545 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
@@ -654,6 +654,12 @@ static void iwl_mvm_mac_ctxt_cmd_common(struct iwl_mvm *mvm,
 
 	cmd->filter_flags = cpu_to_le32(MAC_FILTER_ACCEPT_GRP);
 
+	if (mvm->hw->conf.flags & IEEE80211_CONF_MONITOR)
+		cmd->filter_flags |= cpu_to_le32(MAC_FILTER_IN_PROMISC |
+						 MAC_FILTER_IN_CONTROL_AND_MGMT |
+						 MAC_FILTER_IN_BEACON |
+						 MAC_FILTER_IN_PROBE_REQUEST);
+
 	for (i = 0; i < IEEE80211_NUM_ACS; i++) {
 		u8 txf = iwl_mvm_mac_ac_to_tx_fifo(mvm, i);
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 15f2d826bb4b..c529fb8228df 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -1530,8 +1530,23 @@ static void iwl_mvm_mac_remove_interface(struct ieee80211_hw *hw,
 	mutex_unlock(&mvm->mutex);
 }
 
+static void iwl_mvm_monitor_changed_iterator(void *_mvm, u8 *mac, struct ieee80211_vif *vif)
+{
+	struct iwl_mvm *mvm = _mvm;
+	iwl_mvm_mac_ctxt_changed(mvm, vif, false, NULL);
+}
+
 static int iwl_mvm_mac_config(struct ieee80211_hw *hw, u32 changed)
 {
+	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
+
+	if (changed & IEEE80211_CONF_CHANGE_MONITOR) {
+		mutex_lock(&mvm->mutex);
+		ieee80211_iterate_active_interfaces(hw, IEEE80211_IFACE_ITER_NORMAL,
+				iwl_mvm_monitor_changed_iterator, mvm);
+		mutex_unlock(&mvm->mutex);
+	}
+
 	return 0;
 }
 
-- 
2.14.1
