Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f175.google.com ([209.85.215.175]:56192 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753434AbaBCU7T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Feb 2014 15:59:19 -0500
Received: by mail-ea0-f175.google.com with SMTP id z10so3948859ead.6
        for <linux-wireless@vger.kernel.org>; Mon, 03 Feb 2014 12:59:18 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 39/62] iwlwifi: mvm: configure vifs upon D0i3 entry/exit
Date: Mon,  3 Feb 2014 22:57:45 +0200
Message-Id: <1391461088-8082-39-git-send-email-egrumbach@gmail.com> (sfid-20140203_220010_483252_372BB180)
In-Reply-To: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
References: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

Upon D0i3 entry/exit, iterate over the active interfaces
and configure them appropriately.

Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/ops.c |   51 +++++++++++++++++++++++++++++++-
 1 file changed, 50 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index 6e46b7c..cdb4c92 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -813,6 +813,27 @@ static void iwl_mvm_cmd_queue_full(struct iwl_op_mode *op_mode)
 	iwl_mvm_nic_restart(mvm);
 }
 
+static void iwl_mvm_enter_d0i3_iterator(void *_data, u8 *mac,
+					struct ieee80211_vif *vif)
+{
+	struct iwl_mvm *mvm = _data;
+	u32 flags = CMD_ASYNC | CMD_HIGH_PRIO | CMD_SEND_IN_IDLE;
+
+	IWL_DEBUG_RPM(mvm, "entering D0i3 - vif %pM\n", vif->addr);
+	if (vif->type != NL80211_IFTYPE_STATION ||
+	    !vif->bss_conf.assoc)
+		return;
+
+	iwl_mvm_update_d0i3_power_mode(mvm, vif, true, flags);
+
+	/*
+	 * on init/association, mvm already configures POWER_TABLE_CMD
+	 * and REPLY_MCAST_FILTER_CMD, so currently don't
+	 * reconfigure them (we might want to use different
+	 * params later on, though).
+	 */
+}
+
 static int iwl_mvm_enter_d0i3(struct iwl_op_mode *op_mode)
 {
 	struct iwl_mvm *mvm = IWL_OP_MODE_GET_MVM(op_mode);
@@ -823,20 +844,48 @@ static int iwl_mvm_enter_d0i3(struct iwl_op_mode *op_mode)
 
 	IWL_DEBUG_RPM(mvm, "MVM entering D0i3\n");
 
+	ieee80211_iterate_active_interfaces_atomic(mvm->hw,
+						   IEEE80211_IFACE_ITER_NORMAL,
+						   iwl_mvm_enter_d0i3_iterator,
+						   mvm);
+
 	return iwl_mvm_send_cmd_pdu(mvm, D3_CONFIG_CMD,
 				    flags | CMD_MAKE_TRANS_IDLE,
 				    sizeof(d3_cfg_cmd), &d3_cfg_cmd);
 }
 
+static void iwl_mvm_exit_d0i3_iterator(void *_data, u8 *mac,
+				       struct ieee80211_vif *vif)
+{
+	struct iwl_mvm *mvm = _data;
+	u32 flags = CMD_ASYNC | CMD_HIGH_PRIO;
+
+	IWL_DEBUG_RPM(mvm, "exiting D0i3 - vif %pM\n", vif->addr);
+	if (vif->type != NL80211_IFTYPE_STATION ||
+	    !vif->bss_conf.assoc)
+		return;
+
+	iwl_mvm_update_d0i3_power_mode(mvm, vif, false, flags);
+}
+
 static int iwl_mvm_exit_d0i3(struct iwl_op_mode *op_mode)
 {
 	struct iwl_mvm *mvm = IWL_OP_MODE_GET_MVM(op_mode);
 	u32 flags = CMD_ASYNC | CMD_HIGH_PRIO | CMD_SEND_IN_IDLE |
 		    CMD_WAKE_UP_TRANS;
+	int ret;
 
 	IWL_DEBUG_RPM(mvm, "MVM exiting D0i3\n");
 
-	return iwl_mvm_send_cmd_pdu(mvm, D0I3_END_CMD, flags, 0, NULL);
+	ret = iwl_mvm_send_cmd_pdu(mvm, D0I3_END_CMD, flags, 0, NULL);
+	if (ret)
+		return ret;
+
+	ieee80211_iterate_active_interfaces_atomic(mvm->hw,
+						   IEEE80211_IFACE_ITER_NORMAL,
+						   iwl_mvm_exit_d0i3_iterator,
+						   mvm);
+	return 0;
 }
 
 static const struct iwl_op_mode_ops iwl_mvm_ops = {
-- 
1.7.9.5

