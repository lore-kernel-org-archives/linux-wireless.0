Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:58112 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753432Ab3GZI3U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Jul 2013 04:29:20 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Eran Harary <eran.harary@intel.com>
Subject: [PATCH 24/30] iwlwifi: mvm: fix debugfs restart if fw_restart is disabled
Date: Fri, 26 Jul 2013 10:28:41 +0200
Message-Id: <1374827327-3464-25-git-send-email-johannes@sipsolutions.net> (sfid-20130726_103019_093676_85197B95)
In-Reply-To: <1374827327-3464-1-git-send-email-johannes@sipsolutions.net>
References: <1374827327-3464-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eran Harary <eran.harary@intel.com>

If fw_restart is disabled, using the fw_restart debugfs
file will enable fw_restart and then send the failing
command, but this still frequently fails restart because
it resets fw_restart afterwards and is thus racy.

Fix this by tracking fw_restart separately and allowing
"always restart", "never restart" and "restart N times".

Signed-off-by: Eran Harary <eran.harary@intel.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/debugfs.c | 9 ++++-----
 drivers/net/wireless/iwlwifi/mvm/mvm.h     | 3 +++
 drivers/net/wireless/iwlwifi/mvm/ops.c     | 9 ++++++---
 3 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
index 347aa1c..15d52ba 100644
--- a/drivers/net/wireless/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
@@ -597,20 +597,19 @@ static ssize_t iwl_dbgfs_fw_restart_write(struct file *file,
 					  size_t count, loff_t *ppos)
 {
 	struct iwl_mvm *mvm = file->private_data;
-	bool restart_fw = iwlwifi_mod_params.restart_fw;
 	int ret;
 
-	iwlwifi_mod_params.restart_fw = true;
-
 	mutex_lock(&mvm->mutex);
 
+	/* allow one more restart that we're provoking here */
+	if (mvm->restart_fw >= 0)
+		mvm->restart_fw++;
+
 	/* take the return value to make compiler happy - it will fail anyway */
 	ret = iwl_mvm_send_cmd_pdu(mvm, REPLY_ERROR, CMD_SYNC, 0, NULL);
 
 	mutex_unlock(&mvm->mutex);
 
-	iwlwifi_mod_params.restart_fw = restart_fw;
-
 	return count;
 }
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index dda0cd0..5dc5dfd 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -477,6 +477,9 @@ struct iwl_mvm {
 	 */
 	u8 vif_count;
 
+	/* -1 for always, 0 for never, >0 for that many times */
+	s8 restart_fw;
+
 	struct led_classdev led;
 
 	struct ieee80211_vif *p2p_device_vif;
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index ef1ad5b..17207c9 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -342,6 +342,8 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 	mvm->fw = fw;
 	mvm->hw = hw;
 
+	mvm->restart_fw = iwlwifi_mod_params.restart_fw ? -1 : 0;
+
 	mutex_init(&mvm->mutex);
 	spin_lock_init(&mvm->async_handlers_lock);
 	INIT_LIST_HEAD(&mvm->time_event_list);
@@ -693,8 +695,7 @@ static void iwl_mvm_nic_restart(struct iwl_mvm *mvm)
 		reprobe->dev = mvm->trans->dev;
 		INIT_WORK(&reprobe->work, iwl_mvm_reprobe_wk);
 		schedule_work(&reprobe->work);
-	} else if (mvm->cur_ucode == IWL_UCODE_REGULAR &&
-		   iwlwifi_mod_params.restart_fw) {
+	} else if (mvm->cur_ucode == IWL_UCODE_REGULAR && mvm->restart_fw) {
 		/*
 		 * This is a bit racy, but worst case we tell mac80211 about
 		 * a stopped/aborted (sched) scan when that was already done
@@ -712,6 +713,8 @@ static void iwl_mvm_nic_restart(struct iwl_mvm *mvm)
 			break;
 		}
 
+		if (mvm->restart_fw > 0)
+			mvm->restart_fw--;
 		ieee80211_restart_hw(mvm->hw);
 	}
 }
@@ -721,7 +724,7 @@ static void iwl_mvm_nic_error(struct iwl_op_mode *op_mode)
 	struct iwl_mvm *mvm = IWL_OP_MODE_GET_MVM(op_mode);
 
 	iwl_mvm_dump_nic_error_log(mvm);
-	if (!iwlwifi_mod_params.restart_fw)
+	if (!mvm->restart_fw)
 		iwl_mvm_dump_sram(mvm);
 
 	iwl_mvm_nic_restart(mvm);
-- 
1.8.0

