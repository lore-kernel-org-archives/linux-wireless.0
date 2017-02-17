Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:48428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932145AbdBQCJf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 16 Feb 2017 21:09:35 -0500
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
To: johannes.berg@intel.com, luciano.coelho@intel.com,
        emmanuel.grumbach@intel.com, tj@kernel.org, arjan@linux.intel.com,
        ming.lei@canonical.com, zajec5@gmail.com
Cc: jeyu@redhat.com, rusty@rustcorp.com.au, pmladek@suse.com,
        gregkh@linuxfoundation.org, linuxwifi@intel.com,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: [RFC 5/5] iwlwifi: convert final opmode work into a workqueue
Date: Thu, 16 Feb 2017 18:09:03 -0800
Message-Id: <20170217020903.6370-6-mcgrof@kernel.org> (sfid-20170217_031020_452993_76F3F951)
In-Reply-To: <20170217020903.6370-1-mcgrof@kernel.org>
References: <20170217020903.6370-1-mcgrof@kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This lets us offload and share all the final opmode related work
necessary for either an opmode driver or new device. This has the most
impact for opmode drivers as this now offloads opmode start for each
device onto the workqueue.

Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index 6cfbc3c6e0d6..d39a5c73afdc 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -145,6 +145,8 @@ static struct iwlwifi_opmode_table {
 	[DVM_OP_MODE] = { .name = "iwldvm", .ops = NULL },
 	[MVM_OP_MODE] = { .name = "iwlmvm", .ops = NULL },
 };
+static void iwlwifi_opmode_dowork(struct work_struct *work);
+static DECLARE_WORK(iwlwifi_opmode_work, iwlwifi_opmode_dowork);
 
 #define IWL_DEFAULT_SCAN_CHANNELS 40
 
@@ -1291,7 +1293,7 @@ static void iwlwifi_opmode_start(struct iwlwifi_opmode_table *op)
 		iwlwifi_opmode_start_drv(op, drv);
 }
 
-static void iwlwifi_opmode_dowork(void)
+static void iwlwifi_opmode_dowork(struct work_struct *unused_work)
 {
 	unsigned int i;
 	struct iwlwifi_opmode_table *op;
@@ -1530,7 +1532,7 @@ static void iwl_req_fw_callback(const struct firmware *ucode_raw, void *context)
 
 	mutex_unlock(&iwlwifi_opmode_table_mtx);
 
-	iwlwifi_opmode_dowork();
+	schedule_work(&iwlwifi_opmode_work);
 	goto free;
 
  try_again:
@@ -1614,6 +1616,7 @@ struct iwl_drv *iwl_drv_start(struct iwl_trans *trans)
 void iwl_drv_stop(struct iwl_drv *drv)
 {
 	wait_for_completion(&drv->request_firmware_complete);
+	cancel_work_sync(&iwlwifi_opmode_work);
 
 	_iwl_op_mode_stop(drv);
 
@@ -1667,7 +1670,7 @@ int iwl_opmode_register(const char *name, const struct iwl_op_mode_ops *ops)
 	mutex_unlock(&iwlwifi_opmode_table_mtx);
 
 	if (!ret)
-		iwlwifi_opmode_dowork();
+		schedule_work(&iwlwifi_opmode_work);
 
 	return ret;
 }
-- 
2.11.0
