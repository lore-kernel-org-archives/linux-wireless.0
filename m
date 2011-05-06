Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:5015 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932212Ab1EFSfc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 May 2011 14:35:32 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>, stable@kernel.org,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH wireless-2.6] iwlagn: fix iwl_is_any_associated
Date: Fri,  6 May 2011 11:11:20 -0700
Message-Id: <1304705480-3044-1-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110506_203546_348551_FFC90CDD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The function iwl_is_any_associated() was intended
to check both contexts, but due to an oversight
it only checks the BSS context. This leads to a
problem with scanning since the passive dwell
time isn't restricted appropriately and a scan
that includes passive channels will never finish
if only the PAN context is associated since the
default dwell time of 120ms won't fit into the
normal 100 TU DTIM interval.

Fix the function by using for_each_context() and
also reorganise the other functions a bit to take
advantage of each other making the code easier to
read.

Cc: stable@kernel.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
these patches are also available from wireless-2.6 branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git

 drivers/net/wireless/iwlwifi/iwl-dev.h |   19 +++++++++++--------
 1 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 68b953f..c0a4cfb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1658,21 +1658,24 @@ iwl_rxon_ctx_from_vif(struct ieee80211_vif *vif)
 	     ctx < &priv->contexts[NUM_IWL_RXON_CTX]; ctx++)	\
 		if (priv->valid_contexts & BIT(ctx->ctxid))
 
-static inline int iwl_is_associated(struct iwl_priv *priv,
-				    enum iwl_rxon_context_id ctxid)
+static inline int iwl_is_associated_ctx(struct iwl_rxon_context *ctx)
 {
-	return (priv->contexts[ctxid].active.filter_flags &
-			RXON_FILTER_ASSOC_MSK) ? 1 : 0;
+	return (ctx->active.filter_flags & RXON_FILTER_ASSOC_MSK) ? 1 : 0;
 }
 
-static inline int iwl_is_any_associated(struct iwl_priv *priv)
+static inline int iwl_is_associated(struct iwl_priv *priv,
+				    enum iwl_rxon_context_id ctxid)
 {
-	return iwl_is_associated(priv, IWL_RXON_CTX_BSS);
+	return iwl_is_associated_ctx(&priv->contexts[ctxid]);
 }
 
-static inline int iwl_is_associated_ctx(struct iwl_rxon_context *ctx)
+static inline int iwl_is_any_associated(struct iwl_priv *priv)
 {
-	return (ctx->active.filter_flags & RXON_FILTER_ASSOC_MSK) ? 1 : 0;
+	struct iwl_rxon_context *ctx;
+	for_each_context(priv, ctx)
+		if (iwl_is_associated_ctx(ctx))
+			return true;
+	return false;
 }
 
 static inline int is_channel_valid(const struct iwl_channel_info *ch_info)
-- 
1.7.0.4

