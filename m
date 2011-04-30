Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:62414 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756477Ab1D3Qkw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Apr 2011 12:40:52 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 13/14] iwlagn: prefer BSS context
Date: Sat, 30 Apr 2011 09:17:39 -0700
Message-Id: <1304180260-13875-14-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110430_184057_759929_62B369DE)
In-Reply-To: <1304180260-13875-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1304180260-13875-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If an interface type changes from a type that is
only supported on the PAN context (e.g. P2P GO)
to a type that is supported on the BSS context,
and the BSS context is not in use, then we need
to use the BSS context instead of changing the
device type within the context. To achieve this,
refuse the type change, which causes a down/up
cycle that will allocate the BSS context for the
interface.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 98cfbb6..4653dea 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1765,6 +1765,7 @@ int iwl_mac_change_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 {
 	struct iwl_priv *priv = hw->priv;
 	struct iwl_rxon_context *ctx = iwl_rxon_ctx_from_vif(vif);
+	struct iwl_rxon_context *bss_ctx = &priv->contexts[IWL_RXON_CTX_BSS];
 	struct iwl_rxon_context *tmp;
 	u32 interface_modes;
 	int err;
@@ -1789,6 +1790,19 @@ int iwl_mac_change_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		goto out;
 	}
 
+	/*
+	 * Refuse a change that should be done by moving from the PAN
+	 * context to the BSS context instead, if the BSS context is
+	 * available and can support the new interface type.
+	 */
+	if (ctx->ctxid == IWL_RXON_CTX_PAN && !bss_ctx->vif &&
+	    (bss_ctx->interface_modes & BIT(newtype) ||
+	     bss_ctx->exclusive_interface_modes & BIT(newtype))) {
+		BUILD_BUG_ON(NUM_IWL_RXON_CTX != 2);
+		err = -EBUSY;
+		goto out;
+	}
+
 	if (ctx->exclusive_interface_modes & BIT(newtype)) {
 		for_each_context(priv, tmp) {
 			if (ctx == tmp)
-- 
1.7.0.4

