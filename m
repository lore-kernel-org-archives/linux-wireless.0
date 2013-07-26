Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:58156 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756248Ab3GZIaE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Jul 2013 04:30:04 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 15/30] iwlwifi: mvm: reprobe device on firmware error during restart
Date: Fri, 26 Jul 2013 10:28:32 +0200
Message-Id: <1374827327-3464-16-git-send-email-johannes@sipsolutions.net> (sfid-20130726_103019_812200_A7B09F56)
In-Reply-To: <1374827327-3464-1-git-send-email-johannes@sipsolutions.net>
References: <1374827327-3464-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If we get a firmware error during restart, we currently abandon any
hope and simply fail, getting stuck until the driver is reloaded.
Unfortunately, there isn't really much else we can do since restart
will likely continue to fail, and asking mac80211 for disconnection
just causes more error.

To allow the user to at least set up the device again completely
from scratch, reprobe the device and in doing so completely destroy
any mac80211/driver state.

Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/ops.c | 38 +++++++++++++++++++++++++++++++++-
 1 file changed, 37 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index fa1e1ce..2ffa593 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -644,6 +644,22 @@ static void iwl_mvm_free_skb(struct iwl_op_mode *op_mode, struct sk_buff *skb)
 	ieee80211_free_txskb(mvm->hw, skb);
 }
 
+struct iwl_mvm_reprobe {
+	struct device *dev;
+	struct work_struct work;
+};
+
+static void iwl_mvm_reprobe_wk(struct work_struct *wk)
+{
+	struct iwl_mvm_reprobe *reprobe;
+
+	reprobe = container_of(wk, struct iwl_mvm_reprobe, work);
+	if (device_reprobe(reprobe->dev))
+		dev_err(reprobe->dev, "reprobe failed!\n");
+	kfree(reprobe);
+	module_put(THIS_MODULE);
+}
+
 static void iwl_mvm_nic_restart(struct iwl_mvm *mvm)
 {
 	iwl_abort_notification_waits(&mvm->notif_wait);
@@ -655,7 +671,27 @@ static void iwl_mvm_nic_restart(struct iwl_mvm *mvm)
 	 * can't recover this since we're already half suspended.
 	 */
 	if (test_and_set_bit(IWL_MVM_STATUS_IN_HW_RESTART, &mvm->status)) {
-		IWL_ERR(mvm, "Firmware error during reconfiguration! Abort.\n");
+		struct iwl_mvm_reprobe *reprobe;
+
+		IWL_ERR(mvm,
+			"Firmware error during reconfiguration - reprobe!\n");
+
+		/*
+		 * get a module reference to avoid doing this while unloading
+		 * anyway and to avoid scheduling a work with code that's
+		 * being removed.
+		 */
+		if (!try_module_get(THIS_MODULE)) {
+			IWL_ERR(mvm, "Module is being unloaded - abort\n");
+			return;
+		}
+
+		reprobe = kzalloc(sizeof(*reprobe), GFP_ATOMIC);
+		if (!reprobe)
+			return;
+		reprobe->dev = mvm->trans->dev;
+		INIT_WORK(&reprobe->work, iwl_mvm_reprobe_wk);
+		schedule_work(&reprobe->work);
 	} else if (mvm->cur_ucode == IWL_UCODE_REGULAR &&
 		   iwlwifi_mod_params.restart_fw) {
 		/*
-- 
1.8.0

