Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:20191 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757010AbZEVVbM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 May 2009 17:31:12 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH] iwlwifi: fix merge error
Date: Fri, 22 May 2009 14:37:54 -0700
Message-Id: <1243028275-15833-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Reinette Chatre <reinette.chatre@intel.com>

This hunk of code was removed in patch "iwlwifi: do not
cancel delayed work inside spin_lock_irqsave" submitted at
http://marc.info/?l=linux-wireless&m=124267503030042&w=2

This same patch in this repo does not remove this hunk.
Remove it here.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index e93ddb7..a9da06f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -2685,13 +2685,6 @@ int iwl_set_mode(struct iwl_priv *priv, int mode)
 	if (!iwl_is_ready_rf(priv))
 		return -EAGAIN;
 
-	cancel_delayed_work(&priv->scan_check);
-	if (iwl_scan_cancel_timeout(priv, 100)) {
-		IWL_WARN(priv, "Aborted scan still in progress after 100ms\n");
-		IWL_DEBUG_MAC80211(priv, "leaving - scan abort failed.\n");
-		return -EAGAIN;
-	}
-
 	iwlcore_commit_rxon(priv);
 
 	return 0;
-- 
1.5.6.3

