Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f180.google.com ([74.125.82.180]:48720 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753995AbaICT4p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Sep 2014 15:56:45 -0400
Received: by mail-we0-f180.google.com with SMTP id w61so9175589wes.39
        for <linux-wireless@vger.kernel.org>; Wed, 03 Sep 2014 12:56:44 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 11/36] iwlwifi: mvm: add debugfs entry for ps_disabled
Date: Wed,  3 Sep 2014 22:55:59 +0300
Message-Id: <1409774184-24665-11-git-send-email-egrumbach@gmail.com> (sfid-20140903_215653_836313_7363A9B2)
In-Reply-To: <540771E5.6080908@gmail.com>
References: <540771E5.6080908@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

In order to make debugging easier, add an entry to export the
ps_disabled value via debugfs.  To make usage of the
debugfs_create_*() function easier, change the ps_disabled element to
u8.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/debugfs.c | 3 +++
 drivers/net/wireless/iwlwifi/mvm/mvm.h     | 2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
index 83e562b..1fcbc23 100644
--- a/drivers/net/wireless/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
@@ -1447,6 +1447,9 @@ int iwl_mvm_dbgfs_register(struct iwl_mvm *mvm, struct dentry *dbgfs_dir)
 		goto err;
 #endif
 
+	if (!debugfs_create_u8("ps_disabled", S_IRUSR,
+			       mvm->debugfs_dir, &mvm->ps_disabled))
+		goto err;
 	if (!debugfs_create_blob("nvm_hw", S_IRUSR,
 				  mvm->debugfs_dir, &mvm->nvm_hw_blob))
 		goto err;
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 83a00ab..d6b00b9 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -719,7 +719,7 @@ struct iwl_mvm {
 	u8 last_agg_queue;
 
 	/* Indicate if device power save is allowed */
-	bool ps_disabled;
+	u8 ps_disabled; /* u8 instead of bool to ease debugfs_create_* usage */
 
 	struct ieee80211_vif __rcu *csa_vif;
 	struct ieee80211_vif __rcu *csa_tx_blocked_vif;
-- 
1.9.1

