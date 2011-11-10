Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:56484 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756924Ab1KJBdg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Nov 2011 20:33:36 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 25/28] iwlwifi: fix an RCU sparse warning
Date: Wed,  9 Nov 2011 16:39:28 -0800
Message-Id: <1320885571-19122-26-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111110_023358_647289_530C37C8)
In-Reply-To: <1320885571-19122-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1320885571-19122-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Thanks to Johannes for the explanation (and the fix :-))

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index bb9b1ab..e235e84 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1638,7 +1638,7 @@ static void iwl_uninit_drv(struct iwl_priv *priv)
 		kmem_cache_destroy(priv->tx_cmd_pool);
 	kfree(priv->scan_cmd);
 	kfree(priv->beacon_cmd);
-	kfree(priv->noa_data);
+	kfree(rcu_dereference_raw(priv->noa_data));
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 	kfree(priv->wowlan_sram);
 #endif
-- 
1.7.0.4

