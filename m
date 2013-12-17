Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f175.google.com ([209.85.215.175]:37259 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993Ab3LQUpF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Dec 2013 15:45:05 -0500
Received: by mail-ea0-f175.google.com with SMTP id z10so3123080ead.6
        for <linux-wireless@vger.kernel.org>; Tue, 17 Dec 2013 12:45:04 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eliad Peller <eliad@wizery.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 14/36] iwlwifi: mvm: configure phy_ctxt with min_def
Date: Tue, 17 Dec 2013 22:44:17 +0200
Message-Id: <1387313079-28123-14-git-send-email-egrumbach@gmail.com> (sfid-20131217_214514_775019_AE7ABE68)
In-Reply-To: <52B0B72A.5070704@gmail.com>
References: <52B0B72A.5070704@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

Configure the phy context to the minimum required
bandwidth, given by ctx->min_def.

Tuning to a narrower bandwidth should reduce the
noise level and consume less power.

Signed-off-by: Eliad Peller <eliad@wizery.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 01b58fc..fbd3114 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -1608,7 +1608,7 @@ static int iwl_mvm_add_chanctx(struct ieee80211_hw *hw,
 		goto out;
 	}
 
-	ret = iwl_mvm_phy_ctxt_changed(mvm, phy_ctxt, &ctx->def,
+	ret = iwl_mvm_phy_ctxt_changed(mvm, phy_ctxt, &ctx->min_def,
 				       ctx->rx_chains_static,
 				       ctx->rx_chains_dynamic);
 	if (ret) {
@@ -1652,7 +1652,7 @@ static void iwl_mvm_change_chanctx(struct ieee80211_hw *hw,
 		return;
 
 	mutex_lock(&mvm->mutex);
-	iwl_mvm_phy_ctxt_changed(mvm, phy_ctxt, &ctx->def,
+	iwl_mvm_phy_ctxt_changed(mvm, phy_ctxt, &ctx->min_def,
 				 ctx->rx_chains_static,
 				 ctx->rx_chains_dynamic);
 	iwl_mvm_bt_coex_vif_change(mvm);
-- 
1.7.9.5

