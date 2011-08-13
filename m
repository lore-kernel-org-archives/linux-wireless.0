Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:16165 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751910Ab1HMSSj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Aug 2011 14:18:39 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 14/60] iwlagn: add IWL_DEBUG_FW_ERRORS
Date: Sat, 13 Aug 2011 10:37:50 -0700
Message-Id: <1313257116-2697-15-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110813_201959_074936_CD094D2E)
In-Reply-To: <1313257116-2697-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1313257116-2697-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

instead of IWL_DEBUG(priv, IWL_DL_FW_ERRORS

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c  |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-debug.h |    1 +
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index bf173b6..9857136 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -893,11 +893,11 @@ void iwlagn_fw_error(struct iwl_priv *priv, bool ondemand)
 
 	if (!test_bit(STATUS_EXIT_PENDING, &priv->shrd->status)) {
 		if (iwlagn_mod_params.restart_fw) {
-			IWL_DEBUG(priv, IWL_DL_FW_ERRORS,
+			IWL_DEBUG_FW_ERRORS(priv,
 				  "Restarting adapter due to uCode error.\n");
 			queue_work(priv->shrd->workqueue, &priv->restart);
 		} else
-			IWL_DEBUG(priv, IWL_DL_FW_ERRORS,
+			IWL_DEBUG_FW_ERRORS(priv,
 				  "Detected FW error, but not restarting\n");
 	}
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-debug.h b/drivers/net/wireless/iwlwifi/iwl-debug.h
index 7c9e9af..4b042e9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debug.h
+++ b/drivers/net/wireless/iwlwifi/iwl-debug.h
@@ -166,6 +166,7 @@ static inline void iwl_dbgfs_unregister(struct iwl_priv *priv)
 #define IWL_DEBUG_CALIB(p, f, a...)	IWL_DEBUG(p, IWL_DL_CALIB, f, ## a)
 #define IWL_DEBUG_FW(p, f, a...)	IWL_DEBUG(p, IWL_DL_FW, f, ## a)
 #define IWL_DEBUG_RF_KILL(p, f, a...)	IWL_DEBUG(p, IWL_DL_RF_KILL, f, ## a)
+#define IWL_DEBUG_FW_ERRORS(p, f, a...)	IWL_DEBUG(p, IWL_DL_FW_ERRORS, f, ## a)
 #define IWL_DEBUG_DROP(p, f, a...)	IWL_DEBUG(p, IWL_DL_DROP, f, ## a)
 #define IWL_DEBUG_DROP_LIMIT(p, f, a...)	\
 		IWL_DEBUG_LIMIT(p, IWL_DL_DROP, f, ## a)
-- 
1.7.0.4

