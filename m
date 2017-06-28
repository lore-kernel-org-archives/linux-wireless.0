Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:35976 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751650AbdF1UPX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Jun 2017 16:15:23 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed, 28 Jun 2017 23:13:19 +0300
Message-Id: <20170628201330.9432-21-luca@coelho.fi> (sfid-20170628_221555_609725_09D23D73)
In-Reply-To: <20170628201330.9432-1-luca@coelho.fi>
References: <20170628201330.9432-1-luca@coelho.fi>
Subject: [PATCH 20/31] iwlwifi: mvm: change when the BT_COEX is sent
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

The BT_COEX command should not be sent to the INIT
firmware image starting from 8000 family.
The firmware team also requested to send the BT_COEX
command after the PHY_DB_CMD and the PHY_CFG_CMD.

While at it:
s/iwl_send_bt_init_conf/iwl_mvm_send_bt_init_conf/

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/coex.c    |  2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c |  2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c      | 16 +++++++++-------
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h     |  2 +-
 4 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/coex.c b/drivers/net/wireless/intel/iwlwifi/mvm/coex.c
index fe7f1e424f55..34dd5c40ce77 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/coex.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/coex.c
@@ -406,7 +406,7 @@ iwl_get_coex_type(struct iwl_mvm *mvm, const struct ieee80211_vif *vif)
 	return ret;
 }
 
-int iwl_send_bt_init_conf(struct iwl_mvm *mvm)
+int iwl_mvm_send_bt_init_conf(struct iwl_mvm *mvm)
 {
 	struct iwl_bt_coex_cmd bt_cmd = {};
 	u32 mode;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
index c3ab13ee4097..f87a43dad086 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
@@ -644,7 +644,7 @@ iwl_dbgfs_bt_force_ant_write(struct iwl_mvm *mvm, char *buf,
 		       modes_str[mvm->bt_force_ant_mode]);
 
 	if (iwl_mvm_firmware_running(mvm))
-		ret = iwl_send_bt_init_conf(mvm);
+		ret = iwl_mvm_send_bt_init_conf(mvm);
 	else
 		ret = 0;
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index 273e19460016..07308912486a 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -836,9 +836,11 @@ int iwl_run_init_mvm_ucode(struct iwl_mvm *mvm, bool read_nvm)
 		goto error;
 	}
 
-	ret = iwl_send_bt_init_conf(mvm);
-	if (ret)
-		goto error;
+	if (mvm->cfg->device_family < IWL_DEVICE_FAMILY_8000) {
+		ret = iwl_mvm_send_bt_init_conf(mvm);
+		if (ret)
+			goto error;
+	}
 
 	/* Read the NVM only at driver load time, no need to do this twice */
 	if (read_nvm) {
@@ -1545,10 +1547,6 @@ int iwl_mvm_up(struct iwl_mvm *mvm)
 	if (ret)
 		goto error;
 
-	ret = iwl_send_bt_init_conf(mvm);
-	if (ret)
-		goto error;
-
 	/* Send phy db control command and then phy db calibration*/
 	if (!iwl_mvm_has_new_tx_api(mvm)) {
 		ret = iwl_send_phy_db_data(mvm->phy_db);
@@ -1560,6 +1558,10 @@ int iwl_mvm_up(struct iwl_mvm *mvm)
 			goto error;
 	}
 
+	ret = iwl_mvm_send_bt_init_conf(mvm);
+	if (ret)
+		goto error;
+
 	/* Init RSS configuration */
 	/* TODO - remove a000 disablement when we have RXQ config API */
 	if (iwl_mvm_has_new_rx_api(mvm) && !iwl_mvm_has_new_tx_api(mvm)) {
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 9b777b847e22..f2f1e04f471d 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -1680,7 +1680,7 @@ int iwl_mvm_exit_d0i3(struct iwl_op_mode *op_mode);
 int _iwl_mvm_exit_d0i3(struct iwl_mvm *mvm);
 
 /* BT Coex */
-int iwl_send_bt_init_conf(struct iwl_mvm *mvm);
+int iwl_mvm_send_bt_init_conf(struct iwl_mvm *mvm);
 void iwl_mvm_rx_bt_coex_notif(struct iwl_mvm *mvm,
 			      struct iwl_rx_cmd_buffer *rxb);
 void iwl_mvm_bt_rssi_event(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
-- 
2.11.0
