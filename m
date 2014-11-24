Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:32851 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932285AbaKXOgZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2014 09:36:25 -0500
Received: by mail-wi0-f169.google.com with SMTP id r20so9204269wiv.0
        for <linux-wireless@vger.kernel.org>; Mon, 24 Nov 2014 06:36:24 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@intel.com>
Subject: [PATCH 53/75] iwlwifi: mvm: return the actual error code when switch_vif_chanctx fails
Date: Mon, 24 Nov 2014 16:34:29 +0200
Message-Id: <1416839691-28533-53-git-send-email-egrumbach@gmail.com> (sfid-20141124_153631_311815_2CC71560)
In-Reply-To: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
References: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
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
index 542e59f..1d55617 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -2988,15 +2988,13 @@ out_remove:
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
1.9.1

