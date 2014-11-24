Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:39717 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932281AbaKXOgX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2014 09:36:23 -0500
Received: by mail-wi0-f172.google.com with SMTP id n3so5878917wiv.5
        for <linux-wireless@vger.kernel.org>; Mon, 24 Nov 2014 06:36:22 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@intel.com>
Subject: [PATCH 52/75] iwlwifi: mvm: add support for CHANCTX_SWMODE_REASSIGN_VIF
Date: Mon, 24 Nov 2014 16:34:28 +0200
Message-Id: <1416839691-28533-52-git-send-email-egrumbach@gmail.com> (sfid-20141124_153848_096600_F46AF2B9)
In-Reply-To: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
References: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
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
index 1966a60..542e59f 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -3013,6 +3013,44 @@ out:
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
@@ -3030,7 +3068,7 @@ static int iwl_mvm_switch_vif_chanctx(struct ieee80211_hw *hw,
 		ret = iwl_mvm_switch_vif_chanctx_swap(mvm, vifs);
 		break;
 	case CHANCTX_SWMODE_REASSIGN_VIF:
-		ret = -EOPNOTSUPP;
+		ret = iwl_mvm_switch_vif_chanctx_reassign(mvm, vifs);
 		break;
 	default:
 		ret = -EOPNOTSUPP;
-- 
1.9.1

