Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:59641 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754580AbbCLNGN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2015 09:06:13 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 37/49] iwlwifi: mvm: remove warning on station exhaustion
Date: Thu, 12 Mar 2015 15:04:22 +0200
Message-Id: <1426165474-25586-37-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150312_143419_233925_BD3D918B)
In-Reply-To: <1426164431.19690.4.camel@egrumbacBox>
References: <1426164431.19690.4.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When using IBSS, it's easily possible to exhaust the number
of available stations in the driver, so don't warn on it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/sta.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/sta.c b/drivers/net/wireless/iwlwifi/mvm/sta.c
index 325cbbb..50f9288 100644
--- a/drivers/net/wireless/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/iwlwifi/mvm/sta.c
@@ -273,7 +273,7 @@ int iwl_mvm_add_sta(struct iwl_mvm *mvm,
 	else
 		sta_id = mvm_sta->sta_id;
 
-	if (WARN_ON_ONCE(sta_id == IWL_MVM_STATION_COUNT))
+	if (sta_id == IWL_MVM_STATION_COUNT)
 		return -ENOSPC;
 
 	spin_lock_init(&mvm_sta->lock);
-- 
1.9.1

