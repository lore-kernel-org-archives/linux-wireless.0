Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:61057 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932135AbaKXOfO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2014 09:35:14 -0500
Received: by mail-wi0-f181.google.com with SMTP id r20so5974669wiv.14
        for <linux-wireless@vger.kernel.org>; Mon, 24 Nov 2014 06:35:13 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 11/75] iwlwifi: mvm: don't capture firmware coredump for D3->D0 reconfig
Date: Mon, 24 Nov 2014 16:33:47 +0200
Message-Id: <1416839691-28533-11-git-send-email-egrumbach@gmail.com> (sfid-20141124_153524_006973_04785463)
In-Reply-To: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
References: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The code to capture firmware errors works during the reconfiguration
phase after an error. As the D3->D0 transition uses the same flow to
get the D0 image reconfigured, this triggered and caused a firmware
coredump to be collected. This in turn, if it isn't picked up by
userspace, can cause module unloading to fail, which is how the bug
was detected.

To fix this issue, introduce a new status flag (D3_RECONFIG) and use
it to detect that during reconfiguration no coredump should be taken
and reported.

Reported-by: Avi Kraif <avix.kraif@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/d3.c       | 1 +
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 7 ++++++-
 drivers/net/wireless/iwlwifi/mvm/mvm.h      | 1 +
 3 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/d3.c b/drivers/net/wireless/iwlwifi/mvm/d3.c
index 3bbb511..b61075b 100644
--- a/drivers/net/wireless/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/iwlwifi/mvm/d3.c
@@ -1651,6 +1651,7 @@ static int __iwl_mvm_resume(struct iwl_mvm *mvm, bool test)
 
 	/* return 1 to reconfigure the device */
 	set_bit(IWL_MVM_STATUS_IN_HW_RESTART, &mvm->status);
+	set_bit(IWL_MVM_STATUS_D3_RECONFIG, &mvm->status);
 	return 1;
 }
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 4f9f77f..ed2c219 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -839,7 +839,12 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 
 static void iwl_mvm_restart_cleanup(struct iwl_mvm *mvm)
 {
-	iwl_mvm_fw_error_dump(mvm);
+	/* clear the D3 reconfig, we only need it to avoid dumping a
+	 * firmware coredump on reconfiguration, we shouldn't do that
+	 * on D3->D0 transition
+	 */
+	if (!test_and_clear_bit(IWL_MVM_STATUS_D3_RECONFIG, &mvm->status))
+		iwl_mvm_fw_error_dump(mvm);
 
 	iwl_trans_stop_device(mvm->trans);
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 105a76b..e56abdd 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -750,6 +750,7 @@ enum iwl_mvm_status {
 	IWL_MVM_STATUS_IN_HW_RESTART,
 	IWL_MVM_STATUS_IN_D0I3,
 	IWL_MVM_STATUS_ROC_AUX_RUNNING,
+	IWL_MVM_STATUS_D3_RECONFIG,
 };
 
 static inline bool iwl_mvm_is_radio_killed(struct iwl_mvm *mvm)
-- 
1.9.1

