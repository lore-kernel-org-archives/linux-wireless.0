Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:64293 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932280AbaKXOgW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2014 09:36:22 -0500
Received: by mail-wi0-f182.google.com with SMTP id h11so5937425wiw.15
        for <linux-wireless@vger.kernel.org>; Mon, 24 Nov 2014 06:36:21 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@intel.com>
Subject: [PATCH 51/75] iwlwifi: mvm: refactor iwl_mvm_switch_vif_chanctx to support other modes
Date: Mon, 24 Nov 2014 16:34:27 +0200
Message-Id: <1416839691-28533-51-git-send-email-egrumbach@gmail.com> (sfid-20141124_153849_667570_3D983477)
In-Reply-To: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
References: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
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
index 98bb846..1966a60 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -2954,18 +2954,12 @@ static void iwl_mvm_unassign_vif_chanctx(struct ieee80211_hw *hw,
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
@@ -3015,6 +3009,34 @@ out_restart:
 
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
1.9.1

