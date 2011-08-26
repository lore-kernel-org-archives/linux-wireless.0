Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:44772 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752278Ab1HZGxa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Aug 2011 02:53:30 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 14/60] iwlagn: add IWL_DEBUG_FW_ERRORS
Date: Thu, 25 Aug 2011 23:10:46 -0700
Message-Id: <1314339092-20797-15-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110826_085455_275751_5E8173D5)
In-Reply-To: <1314339092-20797-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1314339092-20797-1-git-send-email-wey-yi.w.guy@intel.com>
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

