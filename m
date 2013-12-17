Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f182.google.com ([209.85.215.182]:52933 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753907Ab3LQUpE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Dec 2013 15:45:04 -0500
Received: by mail-ea0-f182.google.com with SMTP id a15so3152163eae.27
        for <linux-wireless@vger.kernel.org>; Tue, 17 Dec 2013 12:45:03 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eliad Peller <eliad@wizery.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 13/36] iwlwifi: mvm: add multicast filtering support
Date: Tue, 17 Dec 2013 22:44:16 +0200
Message-Id: <1387313079-28123-13-git-send-email-egrumbach@gmail.com> (sfid-20131217_214636_535588_16E6005B)
In-Reply-To: <52B0B72A.5070704@gmail.com>
References: <52B0B72A.5070704@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

Configure the fw to filter multicast according to
the addresses given by mac80211.

Note that bssid should be given even if we want
to pass all the multicast frames.

Signed-off-by: Eliad Peller <eliad@wizery.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/fw-api.h   |    1 +
 drivers/net/wireless/iwlwifi/mvm/mac80211.c |  111 +++++++++++++++++++++++----
 drivers/net/wireless/iwlwifi/mvm/mvm.h      |    1 +
 drivers/net/wireless/iwlwifi/mvm/ops.c      |    2 +
 4 files changed, 102 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
index d0b9399..1c30797 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
@@ -1134,6 +1134,7 @@ struct iwl_set_calib_default_cmd {
 } __packed; /* PHY_CALIB_OVERRIDE_VALUES_S */
 
 #define MAX_PORT_ID_NUM	2
+#define MAX_MCAST_FILTERING_ADDRESSES 256
 
 /**
  * struct iwl_mcast_filter_cmd - configure multicast filter.
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 9a27f57..01b58fc 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -755,26 +755,109 @@ static int iwl_mvm_mac_config(struct ieee80211_hw *hw, u32 changed)
 	return 0;
 }
 
+struct iwl_mvm_mc_iter_data {
+	struct iwl_mvm *mvm;
+	int port_id;
+};
+
+static void iwl_mvm_mc_iface_iterator(void *_data, u8 *mac,
+				      struct ieee80211_vif *vif)
+{
+	struct iwl_mvm_mc_iter_data *data = _data;
+	struct iwl_mvm *mvm = data->mvm;
+	struct iwl_mcast_filter_cmd *cmd = mvm->mcast_filter_cmd;
+	int ret, len;
+
+	/* if we don't have free ports, mcast frames will be dropped */
+	if (WARN_ON_ONCE(data->port_id >= MAX_PORT_ID_NUM))
+		return;
+
+	if (vif->type != NL80211_IFTYPE_STATION ||
+	    !vif->bss_conf.assoc)
+		return;
+
+	cmd->port_id = data->port_id++;
+	memcpy(cmd->bssid, vif->bss_conf.bssid, ETH_ALEN);
+	len = roundup(sizeof(*cmd) + cmd->count * ETH_ALEN, 4);
+
+	ret = iwl_mvm_send_cmd_pdu(mvm, MCAST_FILTER_CMD, CMD_SYNC, len, cmd);
+	if (ret)
+		IWL_ERR(mvm, "mcast filter cmd error. ret=%d\n", ret);
+}
+
+static void iwl_mvm_recalc_multicast(struct iwl_mvm *mvm)
+{
+	struct iwl_mvm_mc_iter_data iter_data = {
+		.mvm = mvm,
+	};
+
+	lockdep_assert_held(&mvm->mutex);
+
+	if (WARN_ON_ONCE(!mvm->mcast_filter_cmd))
+		return;
+
+	ieee80211_iterate_active_interfaces(
+		mvm->hw, IEEE80211_IFACE_ITER_NORMAL,
+		iwl_mvm_mc_iface_iterator, &iter_data);
+}
+
+static u64 iwl_mvm_prepare_multicast(struct ieee80211_hw *hw,
+				     struct netdev_hw_addr_list *mc_list)
+{
+	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
+	struct iwl_mcast_filter_cmd *cmd;
+	struct netdev_hw_addr *addr;
+	int addr_count = netdev_hw_addr_list_count(mc_list);
+	bool pass_all = false;
+	int len;
+
+	if (addr_count > MAX_MCAST_FILTERING_ADDRESSES) {
+		pass_all = true;
+		addr_count = 0;
+	}
+
+	len = roundup(sizeof(*cmd) + addr_count * ETH_ALEN, 4);
+	cmd = kzalloc(len, GFP_ATOMIC);
+	if (!cmd)
+		return 0;
+
+	if (pass_all) {
+		cmd->pass_all = 1;
+		return (u64)(unsigned long)cmd;
+	}
+
+	netdev_hw_addr_list_for_each(addr, mc_list) {
+		IWL_DEBUG_MAC80211(mvm, "mcast addr (%d): %pM\n",
+				   cmd->count, addr->addr);
+		memcpy(&cmd->addr_list[cmd->count * ETH_ALEN],
+		       addr->addr, ETH_ALEN);
+		cmd->count++;
+	}
+
+	return (u64)(unsigned long)cmd;
+}
+
 static void iwl_mvm_configure_filter(struct ieee80211_hw *hw,
 				     unsigned int changed_flags,
 				     unsigned int *total_flags,
 				     u64 multicast)
 {
-	*total_flags = 0;
-}
+	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
+	struct iwl_mcast_filter_cmd *cmd = (void *)(unsigned long)multicast;
 
-static int iwl_mvm_configure_mcast_filter(struct iwl_mvm *mvm,
-					  struct ieee80211_vif *vif)
-{
-	struct iwl_mcast_filter_cmd mcast_filter_cmd = {
-		.pass_all = 1,
-	};
+	mutex_lock(&mvm->mutex);
 
-	memcpy(mcast_filter_cmd.bssid, vif->bss_conf.bssid, ETH_ALEN);
+	/* replace previous configuration */
+	kfree(mvm->mcast_filter_cmd);
+	mvm->mcast_filter_cmd = cmd;
 
-	return iwl_mvm_send_cmd_pdu(mvm, MCAST_FILTER_CMD, CMD_SYNC,
-				    sizeof(mcast_filter_cmd),
-				    &mcast_filter_cmd);
+	if (!cmd)
+		goto out;
+
+	iwl_mvm_recalc_multicast(mvm);
+out:
+	mutex_unlock(&mvm->mutex);
+	*total_flags = 0;
 }
 
 static void iwl_mvm_bss_info_changed_station(struct iwl_mvm *mvm,
@@ -797,7 +880,6 @@ static void iwl_mvm_bss_info_changed_station(struct iwl_mvm *mvm,
 				IWL_ERR(mvm, "failed to update quotas\n");
 				return;
 			}
-			iwl_mvm_configure_mcast_filter(mvm, vif);
 
 			if (test_bit(IWL_MVM_STATUS_IN_HW_RESTART,
 				     &mvm->status)) {
@@ -841,6 +923,8 @@ static void iwl_mvm_bss_info_changed_station(struct iwl_mvm *mvm,
 				IWL_ERR(mvm, "failed to update quotas\n");
 		}
 
+		iwl_mvm_recalc_multicast(mvm);
+
 		/* reset rssi values */
 		mvmvif->bf_data.ave_beacon_signal = 0;
 
@@ -1764,6 +1848,7 @@ struct ieee80211_ops iwl_mvm_hw_ops = {
 	.add_interface = iwl_mvm_mac_add_interface,
 	.remove_interface = iwl_mvm_mac_remove_interface,
 	.config = iwl_mvm_mac_config,
+	.prepare_multicast = iwl_mvm_prepare_multicast,
 	.configure_filter = iwl_mvm_configure_filter,
 	.bss_info_changed = iwl_mvm_bss_info_changed,
 	.hw_scan = iwl_mvm_mac_hw_scan,
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 7295f8e..4275720 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -488,6 +488,7 @@ struct iwl_mvm {
 	/* Scan status, cmd (pre-allocated) and auxiliary station */
 	enum iwl_scan_status scan_status;
 	struct iwl_scan_cmd *scan_cmd;
+	struct iwl_mcast_filter_cmd *mcast_filter_cmd;
 
 	/* rx chain antennas set through debugfs for the scan command */
 	u8 scan_rx_ant;
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index 2e9af9f..668525f 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -495,6 +495,8 @@ static void iwl_op_mode_mvm_stop(struct iwl_op_mode *op_mode)
 	ieee80211_unregister_hw(mvm->hw);
 
 	kfree(mvm->scan_cmd);
+	kfree(mvm->mcast_filter_cmd);
+	mvm->mcast_filter_cmd = NULL;
 
 #if defined(CONFIG_PM_SLEEP) && defined(CONFIG_IWLWIFI_DEBUGFS)
 	kfree(mvm->d3_resume_sram);
-- 
1.7.9.5

