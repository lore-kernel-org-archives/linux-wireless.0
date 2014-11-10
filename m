Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:59371 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752367AbaKJJKh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Nov 2014 04:10:37 -0500
From: Luca Coelho <luca@coelho.fi>
To: emmanuel.grumbach@intel.com
Cc: linux-wireless@vger.kernel.org,
	Luciano Coelho <luciano.coelho@intel.com>
Date: Mon, 10 Nov 2014 11:10:09 +0200
Message-Id: <1415610621-27438-5-git-send-email-luca@coelho.fi> (sfid-20141110_101133_435045_CB2B8A57)
In-Reply-To: <1415610621-27438-1-git-send-email-luca@coelho.fi>
References: <1415610621-27438-1-git-send-email-luca@coelho.fi>
Subject: [PATCH 04/16] iwlwifi: mvm: add support for CHANCTX_SWMODE_REASSIGN_VIF
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

Add support to reassign vif in switch_vif_chanctx.  This is similar to
the existing CHANCTX_SWMODE_SWAP_CONTEXTS mode, but doesn't delete the
old context nor creates a new one, doing to switch between two
existing contexts.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 40 ++++++++++++++++++++++++++++-
 1 file changed, 39 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 98c9e1b..b42124d 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -2886,6 +2886,44 @@ out:
 	return ret;
 }
 
+static int
+iwl_mvm_switch_vif_chanctx_reassign(struct iwl_mvm *mvm,
+				    struct ieee80211_vif_chanctx_switch *vifs)
+{
+	int ret;
+
+	mutex_lock(&mvm->mutex);
+	__iwl_mvm_unassign_vif_chanctx(mvm, vifs[0].vif, vifs[0].old_ctx, true);
+
+	ret = __iwl_mvm_assign_vif_chanctx(mvm, vifs[0].vif, vifs[0].new_ctx,
+					   true);
+	if (ret) {
+		IWL_ERR(mvm,
+			"failed to assign new_ctx during channel switch\n");
+		goto out_reassign;
+	}
+
+	goto out;
+
+out_reassign:
+	if (__iwl_mvm_assign_vif_chanctx(mvm, vifs[0].vif, vifs[0].old_ctx,
+					 true)) {
+		IWL_ERR(mvm, "failed to reassign old_ctx after failure.\n");
+		goto out_restart;
+	}
+
+	goto out;
+
+out_restart:
+	/* things keep failing, better restart the hw */
+	iwl_mvm_nic_restart(mvm, false);
+
+out:
+	mutex_unlock(&mvm->mutex);
+
+	return ret;
+}
+
 static int iwl_mvm_switch_vif_chanctx(struct ieee80211_hw *hw,
 				      struct ieee80211_vif_chanctx_switch *vifs,
 				      int n_vifs,
@@ -2903,7 +2941,7 @@ static int iwl_mvm_switch_vif_chanctx(struct ieee80211_hw *hw,
 		ret = iwl_mvm_switch_vif_chanctx_swap(mvm, vifs);
 		break;
 	case CHANCTX_SWMODE_REASSIGN_VIF:
-		ret = -EOPNOTSUPP;
+		ret = iwl_mvm_switch_vif_chanctx_reassign(mvm, vifs);
 		break;
 	default:
 		ret = -EOPNOTSUPP;
-- 
2.1.1

