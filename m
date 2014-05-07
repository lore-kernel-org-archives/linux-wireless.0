Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:47921 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752385AbaEGTxr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 May 2014 15:53:47 -0400
Received: by mail-wi0-f182.google.com with SMTP id r20so1978520wiv.3
        for <linux-wireless@vger.kernel.org>; Wed, 07 May 2014 12:53:46 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 09/23] iwlwifi: mvm: remove useless variable
Date: Wed,  7 May 2014 22:52:46 +0300
Message-Id: <1399492380-12050-9-git-send-email-egrumbach@gmail.com> (sfid-20140507_215442_230965_8AC101A8)
In-Reply-To: <536A8EE3.2050906@gmail.com>
References: <536A8EE3.2050906@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's no need to use a variable just to return the result
of another function call at the end of a function, remove it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c b/drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c
index 237efe0..eafc517 100644
--- a/drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c
+++ b/drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c
@@ -202,18 +202,15 @@ int iwl_mvm_phy_ctxt_add(struct iwl_mvm *mvm, struct iwl_mvm_phy_ctxt *ctxt,
 			 struct cfg80211_chan_def *chandef,
 			 u8 chains_static, u8 chains_dynamic)
 {
-	int ret;
-
 	WARN_ON(!test_bit(IWL_MVM_STATUS_IN_HW_RESTART, &mvm->status) &&
 		ctxt->ref);
 	lockdep_assert_held(&mvm->mutex);
 
 	ctxt->channel = chandef->chan;
-	ret = iwl_mvm_phy_ctxt_apply(mvm, ctxt, chandef,
-				     chains_static, chains_dynamic,
-				     FW_CTXT_ACTION_ADD, 0);
 
-	return ret;
+	return iwl_mvm_phy_ctxt_apply(mvm, ctxt, chandef,
+				      chains_static, chains_dynamic,
+				      FW_CTXT_ACTION_ADD, 0);
 }
 
 /*
-- 
1.8.3.2

