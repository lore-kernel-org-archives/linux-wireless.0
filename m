Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:34247 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755863AbZAWVmy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 16:42:54 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Samuel Ortiz <samuel.ortiz@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 11/15] iwl3945: Add restart_fw module parameter
Date: Fri, 23 Jan 2009 13:45:19 -0800
Message-Id: <1232747123-7261-12-git-send-email-reinette.chatre@intel.com> (sfid-20090123_230907_036082_F203DEF1)
In-Reply-To: <1232747123-7261-11-git-send-email-reinette.chatre@intel.com>
References: <>
 <1232747123-7261-1-git-send-email-reinette.chatre@intel.com>
 <1232747123-7261-2-git-send-email-reinette.chatre@intel.com>
 <1232747123-7261-3-git-send-email-reinette.chatre@intel.com>
 <1232747123-7261-4-git-send-email-reinette.chatre@intel.com>
 <1232747123-7261-5-git-send-email-reinette.chatre@intel.com>
 <1232747123-7261-6-git-send-email-reinette.chatre@intel.com>
 <1232747123-7261-7-git-send-email-reinette.chatre@intel.com>
 <1232747123-7261-8-git-send-email-reinette.chatre@intel.com>
 <1232747123-7261-9-git-send-email-reinette.chatre@intel.com>
 <1232747123-7261-10-git-send-email-reinette.chatre@intel.com>
 <1232747123-7261-11-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Samuel Ortiz <samuel.ortiz@intel.com>

In order to be in sync with the agn code, we're ading a fw_restart3945 module
parameter to iwl3945.

Signed-off-by: Samuel Ortiz <samuel.ortiz@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 8aaa6bf..13fb618 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -90,6 +90,7 @@ MODULE_LICENSE("GPL");
 struct iwl_mod_params iwl3945_mod_params = {
 	.num_of_queues = IWL39_MAX_NUM_QUEUES,
 	.sw_crypto = 1,
+	.restart_fw = 1,
 	/* the rest are 0 by default */
 };
 
@@ -3088,7 +3089,8 @@ static void iwl3945_irq_handle_error(struct iwl_priv *priv)
 			       sizeof(priv->recovery39_rxon));
 			priv->error_recovering = 1;
 		}
-		queue_work(priv->workqueue, &priv->restart);
+		if (priv->cfg->mod_params->restart_fw)
+			queue_work(priv->workqueue, &priv->restart);
 	}
 }
 
@@ -6482,5 +6484,8 @@ MODULE_PARM_DESC(disable_hw_scan, "disable hardware scanning (default 0)");
 module_param_named(queues_num, iwl3945_mod_params.num_of_queues, int, 0444);
 MODULE_PARM_DESC(queues_num, "number of hw queues.");
 
+module_param_named(fw_restart3945, iwl3945_mod_params.restart_fw, int, 0444);
+MODULE_PARM_DESC(fw_restart3945, "restart firmware in case of error");
+
 module_exit(iwl3945_exit);
 module_init(iwl3945_init);
-- 
1.5.4.3

