Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:59900 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179AbaGVT1D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jul 2014 15:27:03 -0400
Received: by mail-we0-f176.google.com with SMTP id q58so114431wes.21
        for <linux-wireless@vger.kernel.org>; Tue, 22 Jul 2014 12:27:01 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 01/20] iwlwifi: mvm: BT Coex - fix TLC with old API
Date: Tue, 22 Jul 2014 22:26:32 +0300
Message-Id: <1406057211-31752-1-git-send-email-egrumbach@gmail.com> (sfid-20140722_212709_754371_77964084)
In-Reply-To: <53CEB854.9000008@gmail.com>
References: <53CEB854.9000008@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

A copy paste issue broke the rate control when a firmware
with the old API is used.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/coex.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/coex.c b/drivers/net/wireless/iwlwifi/mvm/coex.c
index 8110fe0..e0a5cf2 100644
--- a/drivers/net/wireless/iwlwifi/mvm/coex.c
+++ b/drivers/net/wireless/iwlwifi/mvm/coex.c
@@ -1150,7 +1150,7 @@ bool iwl_mvm_bt_coex_is_mimo_allowed(struct iwl_mvm *mvm,
 	enum iwl_bt_coex_lut_type lut_type;
 
 	if (!(mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_BT_COEX_SPLIT))
-		return iwl_mvm_coex_agg_time_limit_old(mvm, sta);
+		return iwl_mvm_bt_coex_is_mimo_allowed_old(mvm, sta);
 
 	if (IWL_COEX_IS_TTC_ON(mvm->last_bt_notif.ttc_rrc_status, phy_ctxt->id))
 		return true;
-- 
1.8.3.2

