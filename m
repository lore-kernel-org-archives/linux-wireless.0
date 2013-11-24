Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f173.google.com ([74.125.82.173]:46478 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752442Ab3KXUHF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Nov 2013 15:07:05 -0500
Received: by mail-we0-f173.google.com with SMTP id t61so3017995wes.18
        for <linux-wireless@vger.kernel.org>; Sun, 24 Nov 2013 12:07:02 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eliad Peller <eliad@wizery.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 10/29] iwlwifi: mvm: allow keeping connections in d3_test
Date: Sun, 24 Nov 2013 22:06:27 +0200
Message-Id: <1385323606-3603-10-git-send-email-egrumbach@gmail.com> (sfid-20131124_210710_073391_CC614BA0)
In-Reply-To: <52925BE7.4050406@gmail.com>
References: <52925BE7.4050406@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

Keeping connection can be useful also when testing d3
using the debugfs file (d3_test).

Save the vif to keep connection on, and consider it
when iterating over the interfaces.

Signed-off-by: Eliad Peller <eliad@wizery.com>
Reviewed-by: Luciano Coelho <luciano.coelho@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/d3.c  |   11 ++++++++++-
 drivers/net/wireless/iwlwifi/mvm/mvm.h |    1 +
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/d3.c b/drivers/net/wireless/iwlwifi/mvm/d3.c
index d9eb68e..6964b84 100644
--- a/drivers/net/wireless/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/iwlwifi/mvm/d3.c
@@ -1806,6 +1806,10 @@ static int __iwl_mvm_resume(struct iwl_mvm *mvm, bool test)
 	iwl_mvm_read_d3_sram(mvm);
 
 	keep = iwl_mvm_query_wakeup_reasons(mvm, vif);
+#ifdef CONFIG_IWLWIFI_DEBUGFS
+	if (keep)
+		mvm->keep_vif = vif;
+#endif
 	/* has unlocked the mutex, so skip that */
 	goto out;
 
@@ -1862,6 +1866,7 @@ static int iwl_mvm_d3_test_open(struct inode *inode, struct file *file)
 		return err;
 	}
 	mvm->d3_test_active = true;
+	mvm->keep_vif = NULL;
 	return 0;
 }
 
@@ -1890,6 +1895,10 @@ static ssize_t iwl_mvm_d3_test_read(struct file *file, char __user *user_buf,
 static void iwl_mvm_d3_test_disconn_work_iter(void *_data, u8 *mac,
 					      struct ieee80211_vif *vif)
 {
+	/* skip the one we keep connection on */
+	if (_data == vif)
+		return;
+
 	if (vif->type == NL80211_IFTYPE_STATION)
 		ieee80211_connection_loss(vif);
 }
@@ -1916,7 +1925,7 @@ static int iwl_mvm_d3_test_release(struct inode *inode, struct file *file)
 
 	ieee80211_iterate_active_interfaces_atomic(
 		mvm->hw, IEEE80211_IFACE_ITER_NORMAL,
-		iwl_mvm_d3_test_disconn_work_iter, NULL);
+		iwl_mvm_d3_test_disconn_work_iter, mvm->keep_vif);
 
 	ieee80211_wake_queues(mvm->hw);
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 7992baa..c002b45 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -531,6 +531,7 @@ struct iwl_mvm {
 	bool store_d3_resume_sram;
 	void *d3_resume_sram;
 	u32 d3_test_pme_ptr;
+	struct ieee80211_vif *keep_vif;
 #endif
 #endif
 
-- 
1.7.9.5

