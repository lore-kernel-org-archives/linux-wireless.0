Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39055 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752926Ab2FUNw5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jun 2012 09:52:57 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3/3] iwlwifi: limit mac_change_interface to BSS context
Date: Thu, 21 Jun 2012 15:52:53 +0200
Message-Id: <1340286773-2381-4-git-send-email-johannes@sipsolutions.net> (sfid-20120621_155304_857718_FCD1B345)
In-Reply-To: <1340286773-2381-1-git-send-email-johannes@sipsolutions.net>
References: <1340286773-2381-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Currently when mac80211 asks to change the interface
type, we will accept it for both the BSS and PAN
contexts. This is not terribly complicated today,
but with the addition of the P2P Device abstraction
the PAN context handling will get more complex, so
restrict mac_change_interface to the BSS context.

Also fix a small locking issue and use is_active
instead of the vif pointer to check if the other
context is activated, guarding exclusive interface
types on the BSS context (IBSS) against the PAN
context being used for something else.

Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/mac80211.c |   37 ++++++++++++---------------
 1 file changed, 17 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/mac80211.c b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
index b581f03..b83ca35 100644
--- a/drivers/net/wireless/iwlwifi/dvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
@@ -1411,13 +1411,11 @@ static void iwlagn_mac_remove_interface(struct ieee80211_hw *hw,
 }
 
 static int iwlagn_mac_change_interface(struct ieee80211_hw *hw,
-				struct ieee80211_vif *vif,
-				enum nl80211_iftype newtype, bool newp2p)
+				       struct ieee80211_vif *vif,
+				       enum nl80211_iftype newtype, bool newp2p)
 {
 	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
-	struct iwl_rxon_context *ctx = iwl_rxon_ctx_from_vif(vif);
-	struct iwl_rxon_context *bss_ctx = &priv->contexts[IWL_RXON_CTX_BSS];
-	struct iwl_rxon_context *tmp;
+	struct iwl_rxon_context *ctx, *tmp;
 	enum nl80211_iftype newviftype = newtype;
 	u32 interface_modes;
 	int err;
@@ -1428,6 +1426,18 @@ static int iwlagn_mac_change_interface(struct ieee80211_hw *hw,
 
 	mutex_lock(&priv->mutex);
 
+	ctx = iwl_rxon_ctx_from_vif(vif);
+
+	/*
+	 * To simplify this code, only support changes on the
+	 * BSS context. The PAN context is usually reassigned
+	 * by creating/removing P2P interfaces anyway.
+	 */
+	if (ctx->ctxid != IWL_RXON_CTX_BSS) {
+		err = -EBUSY;
+		goto out;
+	}
+
 	if (!ctx->vif || !iwl_is_ready_rf(priv)) {
 		/*
 		 * Huh? But wait ... this can maybe happen when
@@ -1437,32 +1447,19 @@ static int iwlagn_mac_change_interface(struct ieee80211_hw *hw,
 		goto out;
 	}
 
+	/* Check if the switch is supported in the same context */
 	interface_modes = ctx->interface_modes | ctx->exclusive_interface_modes;
-
 	if (!(interface_modes & BIT(newtype))) {
 		err = -EBUSY;
 		goto out;
 	}
 
-	/*
-	 * Refuse a change that should be done by moving from the PAN
-	 * context to the BSS context instead, if the BSS context is
-	 * available and can support the new interface type.
-	 */
-	if (ctx->ctxid == IWL_RXON_CTX_PAN && !bss_ctx->vif &&
-	    (bss_ctx->interface_modes & BIT(newtype) ||
-	     bss_ctx->exclusive_interface_modes & BIT(newtype))) {
-		BUILD_BUG_ON(NUM_IWL_RXON_CTX != 2);
-		err = -EBUSY;
-		goto out;
-	}
-
 	if (ctx->exclusive_interface_modes & BIT(newtype)) {
 		for_each_context(priv, tmp) {
 			if (ctx == tmp)
 				continue;
 
-			if (!tmp->vif)
+			if (!tmp->is_active)
 				continue;
 
 			/*
-- 
1.7.10

