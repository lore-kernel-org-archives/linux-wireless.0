Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:23998 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752229AbbJYMBn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Oct 2015 08:01:43 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 11/16] iwlwifi: mvm: Implement per vif frame registration API
Date: Sun, 25 Oct 2015 14:01:11 +0200
Message-Id: <1445774476-24792-11-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151025_130146_260586_84086881)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E8AF6CC@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E8AF6CC@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andrei Otcheretianski <andrei.otcheretianski@intel.com>

Implement config_iface_filter() driver op. Currently support only
probe request registration for p2p client vifs, by setting
MAC_FILTER_IN_PROBE_REQUEST flag in MAC_CONTEXT_CMD.
This is needed since WFDS spec and certification require a P2P client
to be discoverable on its operating channel.

Signed-off-by: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c |  3 +++
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 22 ++++++++++++++++++++++
 2 files changed, 25 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
index 9d36ba7..ad7ad72 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
@@ -843,6 +843,9 @@ static int iwl_mvm_mac_ctxt_cmd_sta(struct iwl_mvm *mvm,
 	ctxt_sta->listen_interval = cpu_to_le32(mvm->hw->conf.listen_interval);
 	ctxt_sta->assoc_id = cpu_to_le32(vif->bss_conf.aid);
 
+	if (vif->probe_req_reg && vif->bss_conf.assoc && vif->p2p)
+		cmd.filter_flags |= cpu_to_le32(MAC_FILTER_IN_PROBE_REQUEST);
+
 	return iwl_mvm_mac_ctxt_send_cmd(mvm, &cmd);
 }
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 8e69ab2..1d21e38 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -1996,6 +1996,27 @@ out:
 	*total_flags = 0;
 }
 
+static void iwl_mvm_config_iface_filter(struct ieee80211_hw *hw,
+					struct ieee80211_vif *vif,
+					unsigned int filter_flags,
+					unsigned int changed_flags)
+{
+	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
+
+	/* We support only filter for probe requests */
+	if (!(changed_flags & FIF_PROBE_REQ))
+		return;
+
+	/* Supported only for p2p client interfaces */
+	if (vif->type != NL80211_IFTYPE_STATION || !vif->bss_conf.assoc ||
+	    !vif->p2p)
+		return;
+
+	mutex_lock(&mvm->mutex);
+	iwl_mvm_mac_ctxt_changed(mvm, vif, false, NULL);
+	mutex_unlock(&mvm->mutex);
+}
+
 #ifdef CONFIG_IWLWIFI_BCAST_FILTERING
 struct iwl_bcast_iter_data {
 	struct iwl_mvm *mvm;
@@ -4175,6 +4196,7 @@ const struct ieee80211_ops iwl_mvm_hw_ops = {
 	.config = iwl_mvm_mac_config,
 	.prepare_multicast = iwl_mvm_prepare_multicast,
 	.configure_filter = iwl_mvm_configure_filter,
+	.config_iface_filter = iwl_mvm_config_iface_filter,
 	.bss_info_changed = iwl_mvm_bss_info_changed,
 	.hw_scan = iwl_mvm_mac_hw_scan,
 	.cancel_hw_scan = iwl_mvm_mac_cancel_hw_scan,
-- 
2.1.4

