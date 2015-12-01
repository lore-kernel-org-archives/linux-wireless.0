Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:8579 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753760AbbLAJ7R (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Dec 2015 04:59:17 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 06/41] iwlwifi: dvm: remove stray debug code
Date: Tue,  1 Dec 2015 11:58:32 +0200
Message-Id: <1448963947-24302-6-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151201_105921_992553_9B53F3B1)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E905B07@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E905B07@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This code was needed during initial PAN bringup, but now is
just cruft - remove it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c
index b3ad34e..a9d8b51 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c
@@ -1411,13 +1411,7 @@ static void iwlagn_mac_remove_interface(struct ieee80211_hw *hw,
 
 	mutex_lock(&priv->mutex);
 
-	if (WARN_ON(ctx->vif != vif)) {
-		struct iwl_rxon_context *tmp;
-		IWL_ERR(priv, "ctx->vif = %p, vif = %p\n", ctx->vif, vif);
-		for_each_context(priv, tmp)
-			IWL_ERR(priv, "\tID = %d:\tctx = %p\tctx->vif = %p\n",
-				tmp->ctxid, tmp, tmp->vif);
-	}
+	WARN_ON(ctx->vif != vif);
 	ctx->vif = NULL;
 
 	iwl_teardown_interface(priv, vif, false);
-- 
2.5.0

