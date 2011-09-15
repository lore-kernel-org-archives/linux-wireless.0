Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:19373 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934538Ab1IOTcH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Sep 2011 15:32:07 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 13/27] iwlagn: provide data after WARN_ON
Date: Thu, 15 Sep 2011 11:46:40 -0700
Message-Id: <1316112414-6341-14-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110915_213241_249901_9A5E4CCC)
In-Reply-To: <1316112414-6341-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1316112414-6341-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

>From time to time, we hit a WARN_ON in iwl_mac_remove_interface.
This basically means that we got out of sync with mac80211: the vif
we hold differs from the vif 80211 passes as parameter. Try to get
some data that will help to debug this.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 0a426cb..ce8a015 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1328,7 +1328,13 @@ void iwl_mac_remove_interface(struct ieee80211_hw *hw,
 
 	mutex_lock(&priv->shrd->mutex);
 
-	WARN_ON(ctx->vif != vif);
+	if (WARN_ON(ctx->vif != vif)) {
+		struct iwl_rxon_context *tmp;
+		IWL_ERR(priv, "ctx->vif = %p, vif = %p\n", ctx->vif, vif);
+		for_each_context(priv, tmp)
+			IWL_ERR(priv, "\tID = %d:\tctx = %p\tctx->vif = %p\n",
+				tmp->ctxid, tmp, tmp->vif);
+	}
 	ctx->vif = NULL;
 
 	iwl_teardown_interface(priv, vif, false);
-- 
1.7.0.4

