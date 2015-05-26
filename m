Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:38881 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752069AbbEZTSa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 May 2015 15:18:30 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 17/39] iwlwifi: mvm: BT Coex - allocate a short command on the stack
Date: Tue, 26 May 2015 22:17:30 +0300
Message-Id: <1432667872-18092-17-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150526_211834_689896_47F86908)
In-Reply-To: <1432667798.26624.3.camel@intel.com>
References: <1432667798.26624.3.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The BT_CONFIG command used to be very long, hence it was
allocated on the heap in the previous API. In the new API,
this command is much smaller, and can now safely be
allocated on the stack.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/coex.c | 36 ++++++++++-----------------------
 1 file changed, 11 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/coex.c b/drivers/net/wireless/iwlwifi/mvm/coex.c
index 03dab95..a990886 100644
--- a/drivers/net/wireless/iwlwifi/mvm/coex.c
+++ b/drivers/net/wireless/iwlwifi/mvm/coex.c
@@ -6,7 +6,7 @@
  * GPL LICENSE SUMMARY
  *
  * Copyright(c) 2013 - 2014 Intel Corporation. All rights reserved.
- * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
+ * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -32,7 +32,7 @@
  * BSD LICENSE
  *
  * Copyright(c) 2013 - 2014 Intel Corporation. All rights reserved.
- * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
+ * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -408,23 +408,12 @@ iwl_get_coex_type(struct iwl_mvm *mvm, const struct ieee80211_vif *vif)
 
 int iwl_send_bt_init_conf(struct iwl_mvm *mvm)
 {
-	struct iwl_bt_coex_cmd *bt_cmd;
-	struct iwl_host_cmd cmd = {
-		.id = BT_CONFIG,
-		.len = { sizeof(*bt_cmd), },
-		.dataflags = { IWL_HCMD_DFL_NOCOPY, },
-	};
-	int ret;
+	struct iwl_bt_coex_cmd bt_cmd = {};
 	u32 mode;
 
 	if (!(mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_BT_COEX_SPLIT))
 		return iwl_send_bt_init_conf_old(mvm);
 
-	bt_cmd = kzalloc(sizeof(*bt_cmd), GFP_KERNEL);
-	if (!bt_cmd)
-		return -ENOMEM;
-	cmd.data[0] = bt_cmd;
-
 	lockdep_assert_held(&mvm->mutex);
 
 	if (unlikely(mvm->bt_force_ant_mode != BT_FORCE_ANT_DIS)) {
@@ -440,36 +429,33 @@ int iwl_send_bt_init_conf(struct iwl_mvm *mvm)
 			mode = 0;
 		}
 
-		bt_cmd->mode = cpu_to_le32(mode);
+		bt_cmd.mode = cpu_to_le32(mode);
 		goto send_cmd;
 	}
 
 	mode = iwlwifi_mod_params.bt_coex_active ? BT_COEX_NW : BT_COEX_DISABLE;
-	bt_cmd->mode = cpu_to_le32(mode);
+	bt_cmd.mode = cpu_to_le32(mode);
 
 	if (IWL_MVM_BT_COEX_SYNC2SCO)
-		bt_cmd->enabled_modules |=
+		bt_cmd.enabled_modules |=
 			cpu_to_le32(BT_COEX_SYNC2SCO_ENABLED);
 
 	if (iwl_mvm_bt_is_plcr_supported(mvm))
-		bt_cmd->enabled_modules |= cpu_to_le32(BT_COEX_CORUN_ENABLED);
+		bt_cmd.enabled_modules |= cpu_to_le32(BT_COEX_CORUN_ENABLED);
 
 	if (IWL_MVM_BT_COEX_MPLUT) {
-		bt_cmd->enabled_modules |= cpu_to_le32(BT_COEX_MPLUT_ENABLED);
-		bt_cmd->enabled_modules |=
+		bt_cmd.enabled_modules |= cpu_to_le32(BT_COEX_MPLUT_ENABLED);
+		bt_cmd.enabled_modules |=
 			cpu_to_le32(BT_COEX_MPLUT_BOOST_ENABLED);
 	}
 
-	bt_cmd->enabled_modules |= cpu_to_le32(BT_COEX_HIGH_BAND_RET);
+	bt_cmd.enabled_modules |= cpu_to_le32(BT_COEX_HIGH_BAND_RET);
 
 send_cmd:
 	memset(&mvm->last_bt_notif, 0, sizeof(mvm->last_bt_notif));
 	memset(&mvm->last_bt_ci_cmd, 0, sizeof(mvm->last_bt_ci_cmd));
 
-	ret = iwl_mvm_send_cmd(mvm, &cmd);
-
-	kfree(bt_cmd);
-	return ret;
+	return iwl_mvm_send_cmd_pdu(mvm, BT_CONFIG, 0, sizeof(bt_cmd), &bt_cmd);
 }
 
 static int iwl_mvm_bt_coex_reduced_txp(struct iwl_mvm *mvm, u8 sta_id,
-- 
2.1.4

