Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:19186 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932076AbbCLNGd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2015 09:06:33 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@intel.com>
Subject: [PATCH 48/49] iwlwifi: mvm: don't double unlock the mutex in __iwl_mvm_resume()
Date: Thu, 12 Mar 2015 15:04:33 +0200
Message-Id: <1426165474-25586-48-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150312_140710_220381_61CFCD7C)
In-Reply-To: <1426164431.19690.4.camel@egrumbacBox>
References: <1426164431.19690.4.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

When IWLWIFI_DEBUGFS is not set, we should not unlock the mutex after
calling iwl_mvm_query_wakeup_reasons(), because this function unlocks
it already.  Move the goto out_iterate outside the #ifdef.

Change-Id: I13d86402aecf0eeec44b1abbe2b244fbc706a5eb
Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/d3.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/d3.c b/drivers/net/wireless/iwlwifi/mvm/d3.c
index 486fd4c..e3c3084 100644
--- a/drivers/net/wireless/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/iwlwifi/mvm/d3.c
@@ -1892,9 +1892,9 @@ static int __iwl_mvm_resume(struct iwl_mvm *mvm, bool test)
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 		if (keep)
 			mvm->keep_vif = vif;
+#endif
 		/* has unlocked the mutex, so skip that */
 		goto out_iterate;
-#endif
 	}
 
  out_unlock:
-- 
1.9.1

