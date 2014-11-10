Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:59374 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752392AbaKJJKi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Nov 2014 04:10:38 -0500
From: Luca Coelho <luca@coelho.fi>
To: emmanuel.grumbach@intel.com
Cc: linux-wireless@vger.kernel.org,
	Luciano Coelho <luciano.coelho@intel.com>
Date: Mon, 10 Nov 2014 11:10:10 +0200
Message-Id: <1415610621-27438-6-git-send-email-luca@coelho.fi> (sfid-20141110_101105_353359_3833E471)
In-Reply-To: <1415610621-27438-1-git-send-email-luca@coelho.fi>
References: <1415610621-27438-1-git-send-email-luca@coelho.fi>
Subject: [PATCH 05/16] iwlwifi: mvm: return the actual error code when switch_vif_chanctx fails
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

We have code to recover and go back to the original channel context if
something fails in the middle of switch_vif_chanctx, but we return the
error code of the recover calls instead of the original code, so if
the recovery succeeds, we will return 0 (success).  Fix this by not
assigning the return value of the recovery calls to ret.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index b42124d..10347d1 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -2861,15 +2861,13 @@ out_remove:
 	__iwl_mvm_remove_chanctx(mvm, vifs[0].new_ctx);
 
 out_reassign:
-	ret = __iwl_mvm_add_chanctx(mvm, vifs[0].old_ctx);
-	if (ret) {
+	if (__iwl_mvm_add_chanctx(mvm, vifs[0].old_ctx)) {
 		IWL_ERR(mvm, "failed to add old_ctx back after failure.\n");
 		goto out_restart;
 	}
 
-	ret = __iwl_mvm_assign_vif_chanctx(mvm, vifs[0].vif, vifs[0].old_ctx,
-					   true);
-	if (ret) {
+	if (__iwl_mvm_assign_vif_chanctx(mvm, vifs[0].vif, vifs[0].old_ctx,
+					 true)) {
 		IWL_ERR(mvm, "failed to reassign old_ctx after failure.\n");
 		goto out_restart;
 	}
-- 
2.1.1

