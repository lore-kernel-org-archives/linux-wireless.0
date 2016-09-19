Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:55936 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1760256AbcISHbS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Sep 2016 03:31:18 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Mon, 19 Sep 2016 10:30:27 +0300
Message-Id: <20160919073028.22065-24-luca@coelho.fi> (sfid-20160919_093135_926616_B8E995A6)
In-Reply-To: <1474270071.5664.89.camel@coelho.fi>
References: <1474270071.5664.89.camel@coelho.fi>
Subject: [PATCH 24/25] iwlwifi: mvm: use LIST_HEAD() macro
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's no need to declare a list and then init it manually,
just use the LIST_HEAD() macro.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 3eccd89..75f3ca0 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -858,9 +858,7 @@ static void iwl_mvm_async_handlers_wk(struct work_struct *wk)
 	struct iwl_mvm *mvm =
 		container_of(wk, struct iwl_mvm, async_handlers_wk);
 	struct iwl_async_handler_entry *entry, *tmp;
-	struct list_head local_list;
-
-	INIT_LIST_HEAD(&local_list);
+	LIST_HEAD(local_list);
 
 	/* Ensure that we are not in stop flow (check iwl_mvm_mac_stop) */
 
-- 
2.9.3
