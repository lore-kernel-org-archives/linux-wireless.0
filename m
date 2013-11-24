Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f179.google.com ([74.125.82.179]:63603 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752879Ab3KXUHJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Nov 2013 15:07:09 -0500
Received: by mail-we0-f179.google.com with SMTP id q59so3000696wes.38
        for <linux-wireless@vger.kernel.org>; Sun, 24 Nov 2013 12:07:08 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 14/29] iwlwifi: mvm: don't use void pointers in debugfs
Date: Sun, 24 Nov 2013 22:06:31 +0200
Message-Id: <1385323606-3603-14-git-send-email-egrumbach@gmail.com> (sfid-20131124_210809_716025_B38719F1)
In-Reply-To: <52925BE7.4050406@gmail.com>
References: <52925BE7.4050406@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's really no reason to use void *dbgfs_data
rather than a struct iwl_mvm *mvm, so do that.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c |    4 ++--
 drivers/net/wireless/iwlwifi/mvm/mvm.h         |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c b/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c
index a90dde0..67f6a20 100644
--- a/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c
+++ b/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c
@@ -69,7 +69,7 @@ static ssize_t iwl_dbgfs_mac_params_read(struct file *file,
 {
 	struct ieee80211_vif *vif = file->private_data;
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
-	struct iwl_mvm *mvm = mvmvif->dbgfs_data;
+	struct iwl_mvm *mvm = mvmvif->mvm;
 	u8 ap_sta_id;
 	struct ieee80211_chanctx_conf *chanctx_conf;
 	char buf[512];
@@ -144,7 +144,7 @@ void iwl_mvm_vif_dbgfs_register(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 		return;
 
 	mvmvif->dbgfs_dir = debugfs_create_dir("iwlmvm", dbgfs_dir);
-	mvmvif->dbgfs_data = mvm;
+	mvmvif->mvm = mvm;
 
 	if (!mvmvif->dbgfs_dir) {
 		IWL_ERR(mvm, "Failed to create debugfs directory under %s\n",
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index c002b45..e7c97cc 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -323,9 +323,9 @@ struct iwl_mvm_vif {
 #endif
 
 #ifdef CONFIG_IWLWIFI_DEBUGFS
+	struct iwl_mvm *mvm;
 	struct dentry *dbgfs_dir;
 	struct dentry *dbgfs_slink;
-	void *dbgfs_data;
 	struct iwl_dbgfs_pm dbgfs_pm;
 	struct iwl_dbgfs_bf dbgfs_bf;
 #endif
-- 
1.7.9.5

