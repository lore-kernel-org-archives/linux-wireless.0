Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:59436 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932150AbaKXOfp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2014 09:35:45 -0500
Received: by mail-wi0-f176.google.com with SMTP id ex7so5894523wid.3
        for <linux-wireless@vger.kernel.org>; Mon, 24 Nov 2014 06:35:44 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 29/75] iwlwifi: mvm: make nd_ies part of the mvm struct
Date: Mon, 24 Nov 2014 16:34:05 +0200
Message-Id: <1416839691-28533-29-git-send-email-egrumbach@gmail.com> (sfid-20141124_154213_424567_643229AF)
In-Reply-To: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
References: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

Instead of allocating nd_ies separately, make it part of the iwl_mvm
structure so it's easier to handle its lifetime.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/d3.c      | 2 +-
 drivers/net/wireless/iwlwifi/mvm/debugfs.c | 8 --------
 drivers/net/wireless/iwlwifi/mvm/mvm.h     | 2 +-
 drivers/net/wireless/iwlwifi/mvm/ops.c     | 2 --
 4 files changed, 2 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/d3.c b/drivers/net/wireless/iwlwifi/mvm/d3.c
index faa7d5c..0fc72fc 100644
--- a/drivers/net/wireless/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/iwlwifi/mvm/d3.c
@@ -1036,7 +1036,7 @@ static int __iwl_mvm_suspend(struct ieee80211_hw *hw,
 			goto out;
 
 		ret = iwl_mvm_scan_offload_start(mvm, vif, mvm->nd_config,
-						 mvm->nd_ies);
+						 &mvm->nd_ies);
 		if (ret)
 			goto out;
 	} else {
diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
index 8212b00..5a0f104 100644
--- a/drivers/net/wireless/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
@@ -1198,14 +1198,8 @@ static ssize_t iwl_dbgfs_netdetect_write(struct iwl_mvm *mvm, char *buf,
 		kfree(mvm->nd_config->match_sets);
 		kfree(mvm->nd_config);
 		mvm->nd_config = NULL;
-		kfree(mvm->nd_ies);
-		mvm->nd_ies = NULL;
 	}
 
-	mvm->nd_ies = kzalloc(sizeof(*mvm->nd_ies), GFP_KERNEL);
-	if (!mvm->nd_ies)
-		return -ENOMEM;
-
 	mvm->nd_config = kzalloc(sizeof(*mvm->nd_config) +
 				 (11 * sizeof(struct ieee80211_channel *)),
 				 GFP_KERNEL);
@@ -1262,8 +1256,6 @@ out_free:
 		kfree(mvm->nd_config->match_sets);
 	kfree(mvm->nd_config);
 	mvm->nd_config = NULL;
-	kfree(mvm->nd_ies);
-	mvm->nd_ies = NULL;
 out:
 	return ret;
 }
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index cbfba80..db52f65 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -666,7 +666,7 @@ struct iwl_mvm {
 
 	/* sched scan settings for net detect */
 	struct cfg80211_sched_scan_request *nd_config;
-	struct ieee80211_scan_ies *nd_ies;
+	struct ieee80211_scan_ies nd_ies;
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 	u32 d3_wake_sysassert; /* must be u32 for debugfs_create_bool */
 	bool d3_test_active;
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index 5ab10fb..b022fc0 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -597,8 +597,6 @@ static void iwl_op_mode_mvm_stop(struct iwl_op_mode *op_mode)
 		kfree(mvm->nd_config->match_sets);
 		kfree(mvm->nd_config);
 		mvm->nd_config = NULL;
-		kfree(mvm->nd_ies);
-		mvm->nd_ies = NULL;
 	}
 #endif
 
-- 
1.9.1

