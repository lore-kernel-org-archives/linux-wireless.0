Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f54.google.com ([74.125.83.54]:57681 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753518AbaBCU7c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Feb 2014 15:59:32 -0500
Received: by mail-ee0-f54.google.com with SMTP id e53so3874610eek.41
        for <linux-wireless@vger.kernel.org>; Mon, 03 Feb 2014 12:59:31 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 45/62] iwlwifi: mvm: configure WOWLAN_CONFIGURATION on D0i3 entry
Date: Mon,  3 Feb 2014 22:57:51 +0200
Message-Id: <1391461088-8082-45-git-send-email-egrumbach@gmail.com> (sfid-20140203_220007_430458_CFA38BDD)
In-Reply-To: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
References: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

We need to ask the fw to wake up on incoming packets (that
pass the filters).

Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/fw-api-d3.h |    6 +++++-
 drivers/net/wireless/iwlwifi/mvm/ops.c       |   13 +++++++++++++
 2 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api-d3.h b/drivers/net/wireless/iwlwifi/mvm/fw-api-d3.h
index 8415ff3..5219976 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api-d3.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api-d3.h
@@ -231,8 +231,12 @@ enum iwl_wowlan_wakeup_filters {
 	IWL_WOWLAN_WAKEUP_RF_KILL_DEASSERT		= BIT(8),
 	IWL_WOWLAN_WAKEUP_REMOTE_LINK_LOSS		= BIT(9),
 	IWL_WOWLAN_WAKEUP_REMOTE_SIGNATURE_TABLE	= BIT(10),
-	/* BIT(11) reserved */
+	IWL_WOWLAN_WAKEUP_REMOTE_TCP_EXTERNAL		= BIT(11),
 	IWL_WOWLAN_WAKEUP_REMOTE_WAKEUP_PACKET		= BIT(12),
+	IWL_WOWLAN_WAKEUP_IOAC_MAGIC_PACKET		= BIT(13),
+	IWL_WOWLAN_WAKEUP_HOST_TIMER			= BIT(14),
+	IWL_WOWLAN_WAKEUP_RX_FRAME			= BIT(15),
+	IWL_WOWLAN_WAKEUP_BCN_FILTERING			= BIT(16),
 }; /* WOWLAN_WAKEUP_FILTER_API_E_VER_4 */
 
 struct iwl_wowlan_config_cmd {
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index 5bc4439..12b81ca 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -844,6 +844,13 @@ static int iwl_mvm_enter_d0i3(struct iwl_op_mode *op_mode)
 {
 	struct iwl_mvm *mvm = IWL_OP_MODE_GET_MVM(op_mode);
 	u32 flags = CMD_ASYNC | CMD_HIGH_PRIO | CMD_SEND_IN_IDLE;
+	int ret;
+	struct iwl_wowlan_config_cmd wowlan_config_cmd = {
+		.wakeup_filter = cpu_to_le32(IWL_WOWLAN_WAKEUP_RX_FRAME |
+					     IWL_WOWLAN_WAKEUP_BEACON_MISS |
+					     IWL_WOWLAN_WAKEUP_LINK_CHANGE |
+					     IWL_WOWLAN_WAKEUP_BCN_FILTERING),
+	};
 	struct iwl_d3_manager_config d3_cfg_cmd = {
 		.min_sleep_time = cpu_to_le32(1000),
 	};
@@ -855,6 +862,12 @@ static int iwl_mvm_enter_d0i3(struct iwl_op_mode *op_mode)
 						   iwl_mvm_enter_d0i3_iterator,
 						   mvm);
 
+	ret = iwl_mvm_send_cmd_pdu(mvm, WOWLAN_CONFIGURATION, flags,
+				   sizeof(wowlan_config_cmd),
+				   &wowlan_config_cmd);
+	if (ret)
+		return ret;
+
 	return iwl_mvm_send_cmd_pdu(mvm, D3_CONFIG_CMD,
 				    flags | CMD_MAKE_TRANS_IDLE,
 				    sizeof(d3_cfg_cmd), &d3_cfg_cmd);
-- 
1.7.9.5

