Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:59368 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752075AbaKJJKg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Nov 2014 04:10:36 -0500
From: Luca Coelho <luca@coelho.fi>
To: emmanuel.grumbach@intel.com
Cc: linux-wireless@vger.kernel.org,
	Luciano Coelho <luciano.coelho@intel.com>
Date: Mon, 10 Nov 2014 11:10:08 +0200
Message-Id: <1415610621-27438-4-git-send-email-luca@coelho.fi> (sfid-20141110_101118_559814_339FA162)
In-Reply-To: <1415610621-27438-1-git-send-email-luca@coelho.fi>
References: <1415610621-27438-1-git-send-email-luca@coelho.fi>
Subject: [PATCH 03/16] iwlwifi: mvm: refactor iwl_mvm_switch_vif_chanctx to support other modes
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

Currently we only support the CHANCTX_SWMODE_SWAP_CONTEXTS mode, but
we need to support other modes as well.  Spin a new function off in
order to make it easier to support other modes.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 40 ++++++++++++++++++++++-------
 1 file changed, 31 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 8bb6f18..98c9e1b 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -2827,18 +2827,12 @@ static void iwl_mvm_unassign_vif_chanctx(struct ieee80211_hw *hw,
 	mutex_unlock(&mvm->mutex);
 }
 
-static int iwl_mvm_switch_vif_chanctx(struct ieee80211_hw *hw,
-				      struct ieee80211_vif_chanctx_switch *vifs,
-				      int n_vifs,
-				      enum ieee80211_chanctx_switch_mode mode)
+static int
+iwl_mvm_switch_vif_chanctx_swap(struct iwl_mvm *mvm,
+				struct ieee80211_vif_chanctx_switch *vifs)
 {
-	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
 	int ret;
 
-	/* we only support SWAP_CONTEXTS and with a single-vif right now */
-	if (mode != CHANCTX_SWMODE_SWAP_CONTEXTS || n_vifs > 1)
-		return -EOPNOTSUPP;
-
 	mutex_lock(&mvm->mutex);
 	__iwl_mvm_unassign_vif_chanctx(mvm, vifs[0].vif, vifs[0].old_ctx, true);
 	__iwl_mvm_remove_chanctx(mvm, vifs[0].old_ctx);
@@ -2888,6 +2882,34 @@ out_restart:
 
 out:
 	mutex_unlock(&mvm->mutex);
+
+	return ret;
+}
+
+static int iwl_mvm_switch_vif_chanctx(struct ieee80211_hw *hw,
+				      struct ieee80211_vif_chanctx_switch *vifs,
+				      int n_vifs,
+				      enum ieee80211_chanctx_switch_mode mode)
+{
+	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
+	int ret;
+
+	/* we only support a single-vif right now */
+	if (n_vifs > 1)
+		return -EOPNOTSUPP;
+
+	switch (mode) {
+	case CHANCTX_SWMODE_SWAP_CONTEXTS:
+		ret = iwl_mvm_switch_vif_chanctx_swap(mvm, vifs);
+		break;
+	case CHANCTX_SWMODE_REASSIGN_VIF:
+		ret = -EOPNOTSUPP;
+		break;
+	default:
+		ret = -EOPNOTSUPP;
+		break;
+	}
+
 	return ret;
 }
 
-- 
2.1.1

