Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42210 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633Ab2LJVs5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2012 16:48:57 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 02/10] iwlwifi: clear trans->op_mode pointer when it is leaving
Date: Mon, 10 Dec 2012 22:49:10 +0100
Message-Id: <1355176158-24675-2-git-send-email-johannes@sipsolutions.net> (sfid-20121210_224903_424653_36BD119D)
In-Reply-To: <1355176158-24675-1-git-send-email-johannes@sipsolutions.net>
References: <1355176087.8083.17.camel@jlt4.sipsolutions.net>
 <1355176158-24675-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Since the op_mode is leaving, the transport should set
its pointer to it to NULL to not point to freed memory.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-trans.h | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index e378ea6d..98072c2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -489,10 +489,6 @@ struct iwl_trans {
 static inline void iwl_trans_configure(struct iwl_trans *trans,
 				       const struct iwl_trans_config *trans_cfg)
 {
-	/*
-	 * only set the op_mode for the moment. Later on, this function will do
-	 * more
-	 */
 	trans->op_mode = trans_cfg->op_mode;
 
 	trans->ops->configure(trans, trans_cfg);
@@ -512,6 +508,9 @@ static inline void iwl_trans_stop_hw(struct iwl_trans *trans,
 
 	trans->ops->stop_hw(trans, op_mode_leaving);
 
+	if (op_mode_leaving)
+		trans->op_mode = NULL;
+
 	trans->state = IWL_TRANS_NO_FW;
 }
 
-- 
1.8.0

