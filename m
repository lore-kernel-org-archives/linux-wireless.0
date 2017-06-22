Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:34436 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753513AbdFVVWj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Jun 2017 17:22:39 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 23 Jun 2017 00:20:51 +0300
Message-Id: <20170622212101.16422-16-luca@coelho.fi> (sfid-20170622_232253_494569_F553ED5E)
In-Reply-To: <20170622212101.16422-1-luca@coelho.fi>
References: <20170622212101.16422-1-luca@coelho.fi>
Subject: [PATCH 15/25] iwlwifi: mvm: make iwl_mvm_update_mcc() easier to follow
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Some static checkers (e.g. smatch) complain about the logic, saying that
resp_cp might be leaked. Clearly that isn't true, but making the logic
easier to follow does not result in any significant code changes and makes
the code more readable by moving the NULL check closer to its source.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/nvm.c | 29 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c b/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c
index beead0bc08c9..ad8bd90deed2 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c
@@ -779,6 +779,10 @@ iwl_mvm_update_mcc(struct iwl_mvm *mvm, const char *alpha2,
 		resp_len = sizeof(struct iwl_mcc_update_resp) +
 			   n_channels * sizeof(__le32);
 		resp_cp = kmemdup(mcc_resp, resp_len, GFP_KERNEL);
+		if (!resp_cp) {
+			resp_cp = ERR_PTR(-ENOMEM);
+			goto exit;
+		}
 	} else {
 		struct iwl_mcc_update_resp_v1 *mcc_resp_v1 = (void *)pkt->data;
 
@@ -786,21 +790,18 @@ iwl_mvm_update_mcc(struct iwl_mvm *mvm, const char *alpha2,
 		resp_len = sizeof(struct iwl_mcc_update_resp) +
 			   n_channels * sizeof(__le32);
 		resp_cp = kzalloc(resp_len, GFP_KERNEL);
-
-		if (resp_cp) {
-			resp_cp->status = mcc_resp_v1->status;
-			resp_cp->mcc = mcc_resp_v1->mcc;
-			resp_cp->cap = mcc_resp_v1->cap;
-			resp_cp->source_id = mcc_resp_v1->source_id;
-			resp_cp->n_channels = mcc_resp_v1->n_channels;
-			memcpy(resp_cp->channels, mcc_resp_v1->channels,
-			       n_channels * sizeof(__le32));
+		if (!resp_cp) {
+			resp_cp = ERR_PTR(-ENOMEM);
+			goto exit;
 		}
-	}
 
-	if (!resp_cp) {
-		ret = -ENOMEM;
-		goto exit;
+		resp_cp->status = mcc_resp_v1->status;
+		resp_cp->mcc = mcc_resp_v1->mcc;
+		resp_cp->cap = mcc_resp_v1->cap;
+		resp_cp->source_id = mcc_resp_v1->source_id;
+		resp_cp->n_channels = mcc_resp_v1->n_channels;
+		memcpy(resp_cp->channels, mcc_resp_v1->channels,
+		       n_channels * sizeof(__le32));
 	}
 
 	status = le32_to_cpu(resp_cp->status);
@@ -820,8 +821,6 @@ iwl_mvm_update_mcc(struct iwl_mvm *mvm, const char *alpha2,
 
 exit:
 	iwl_free_resp(&cmd);
-	if (ret)
-		return ERR_PTR(ret);
 	return resp_cp;
 }
 
-- 
2.11.0
