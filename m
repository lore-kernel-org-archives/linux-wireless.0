Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:9395 "EHLO mga04.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757307AbcAaLGn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 Jan 2016 06:06:43 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Chaya Rachel Ivgi <chaya.rachel.ivgi@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 15/31] iwlwifi: mvm: add support for negative temperatures
Date: Sun, 31 Jan 2016 13:06:10 +0200
Message-Id: <1454238386-27032-15-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160131_120653_555201_5F781F67)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E9F363A@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E9F363A@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Chaya Rachel Ivgi <chaya.rachel.ivgi@intel.com>

The driver should support also negative temperatures.
So there is a need to separate between the return value and
temperature in order to be able to distinguish between
a negative temperature and error value.

Signed-off-by: Chaya Rachel Ivgi <chaya.rachel.ivgi@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c |  9 +++++----
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h     |  2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tt.c      | 17 ++++++++---------
 3 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
index 8059efa..5c0f939 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
@@ -261,17 +261,18 @@ static ssize_t iwl_dbgfs_nic_temp_read(struct file *file,
 {
 	struct iwl_mvm *mvm = file->private_data;
 	char buf[16];
-	int pos, temp;
+	int pos, ret;
+	s32 temp;
 
 	if (!mvm->ucode_loaded)
 		return -EIO;
 
 	mutex_lock(&mvm->mutex);
-	temp = iwl_mvm_get_temp(mvm);
+	ret = iwl_mvm_get_temp(mvm, &temp);
 	mutex_unlock(&mvm->mutex);
 
-	if (temp < 0)
-		return temp;
+	if (ret)
+		return -EIO;
 
 	pos = scnprintf(buf , sizeof(buf), "%d\n", temp);
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 5a92ab1..216c8d6 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -1489,7 +1489,7 @@ void iwl_mvm_tt_handler(struct iwl_mvm *mvm);
 void iwl_mvm_tt_initialize(struct iwl_mvm *mvm, u32 min_backoff);
 void iwl_mvm_tt_exit(struct iwl_mvm *mvm);
 void iwl_mvm_set_hw_ctkill_state(struct iwl_mvm *mvm, bool state);
-int iwl_mvm_get_temp(struct iwl_mvm *mvm);
+int iwl_mvm_get_temp(struct iwl_mvm *mvm, s32 *temp);
 
 /* Location Aware Regulatory */
 struct iwl_mcc_update_resp *
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tt.c b/drivers/net/wireless/intel/iwlwifi/mvm/tt.c
index fb76004..758d05a 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tt.c
@@ -194,12 +194,12 @@ static int iwl_mvm_get_temp_cmd(struct iwl_mvm *mvm)
 	return iwl_mvm_send_cmd_pdu(mvm, cmdid, 0, sizeof(extcmd), &extcmd);
 }
 
-int iwl_mvm_get_temp(struct iwl_mvm *mvm)
+int iwl_mvm_get_temp(struct iwl_mvm *mvm, s32 *temp)
 {
 	struct iwl_notification_wait wait_temp_notif;
 	static u16 temp_notif[] = { WIDE_ID(PHY_OPS_GROUP,
 					    DTS_MEASUREMENT_NOTIF_WIDE) };
-	int ret, temp;
+	int ret;
 
 	if (!fw_has_api(&mvm->fw->ucode_capa, IWL_UCODE_TLV_API_WIDE_CMD_HDR))
 		temp_notif[0] = DTS_MEASUREMENT_NOTIFICATION;
@@ -208,7 +208,7 @@ int iwl_mvm_get_temp(struct iwl_mvm *mvm)
 
 	iwl_init_notification_wait(&mvm->notif_wait, &wait_temp_notif,
 				   temp_notif, ARRAY_SIZE(temp_notif),
-				   iwl_mvm_temp_notif_wait, &temp);
+				   iwl_mvm_temp_notif_wait, temp);
 
 	ret = iwl_mvm_get_temp_cmd(mvm);
 	if (ret) {
@@ -219,12 +219,10 @@ int iwl_mvm_get_temp(struct iwl_mvm *mvm)
 
 	ret = iwl_wait_notification(&mvm->notif_wait, &wait_temp_notif,
 				    IWL_MVM_TEMP_NOTIF_WAIT_TIMEOUT);
-	if (ret) {
+	if (ret)
 		IWL_ERR(mvm, "Getting the temperature timed out\n");
-		return ret;
-	}
 
-	return temp;
+	return ret;
 }
 
 static void check_exit_ctkill(struct work_struct *work)
@@ -233,6 +231,7 @@ static void check_exit_ctkill(struct work_struct *work)
 	struct iwl_mvm *mvm;
 	u32 duration;
 	s32 temp;
+	int ret;
 
 	tt = container_of(work, struct iwl_mvm_tt_mgmt, ct_kill_exit.work);
 	mvm = container_of(tt, struct iwl_mvm, thermal_throttle);
@@ -250,13 +249,13 @@ static void check_exit_ctkill(struct work_struct *work)
 		goto reschedule;
 	}
 
-	temp = iwl_mvm_get_temp(mvm);
+	ret = iwl_mvm_get_temp(mvm, &temp);
 
 	iwl_mvm_unref(mvm, IWL_MVM_REF_CHECK_CTKILL);
 
 	__iwl_mvm_mac_stop(mvm);
 
-	if (temp < 0)
+	if (ret)
 		goto reschedule;
 
 	IWL_DEBUG_TEMP(mvm, "NIC temperature: %d\n", temp);
-- 
2.5.0

