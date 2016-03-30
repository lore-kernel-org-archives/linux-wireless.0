Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:9292 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754223AbcC3OGO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Mar 2016 10:06:14 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Eva Rachel Retuya <eraretuya@gmail.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 24/43] iwlwifi: dvm: use alloc_ordered_workqueue()
Date: Wed, 30 Mar 2016 17:04:56 +0300
Message-Id: <1459346715-7954-24-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160330_160747_831805_293DEF4F)
In-Reply-To: <1459346667.4731.9.camel@intel.com>
References: <1459346667.4731.9.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eva Rachel Retuya <eraretuya@gmail.com>

Use alloc_ordered_workqueue() to allocate the workqueue instead of
create_singlethread_workqueue() since the latter is deprecated and is scheduled
for removal.

There are work items doing related operations that shouldn't be swapped when
queued in a certain order hence preserve the strict execution ordering of a
single threaded (ST) workqueue by switching to alloc_ordered_workqueue().

WQ_MEM_RECLAIM flag is not needed since the worker is not depended
during memory reclaim.

Signed-off-by: Eva Rachel Retuya <eraretuya@gmail.com>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/dvm/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/main.c b/drivers/net/wireless/intel/iwlwifi/dvm/main.c
index 85628127..6147162 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/main.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/main.c
@@ -1071,7 +1071,7 @@ static void iwl_bg_restart(struct work_struct *data)
 
 static void iwl_setup_deferred_work(struct iwl_priv *priv)
 {
-	priv->workqueue = create_singlethread_workqueue(DRV_NAME);
+	priv->workqueue = alloc_ordered_workqueue(DRV_NAME, 0);
 
 	INIT_WORK(&priv->restart, iwl_bg_restart);
 	INIT_WORK(&priv->beacon_update, iwl_bg_beacon_update);
-- 
2.5.0

