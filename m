Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:26419 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756919Ab1KJBdf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Nov 2011 20:33:35 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 23/28] iwlwifi: remove the use of the QOS debug flag
Date: Wed,  9 Nov 2011 16:39:26 -0800
Message-Id: <1320885571-19122-24-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111110_023403_364436_70246A15)
In-Reply-To: <1320885571-19122-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1320885571-19122-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This bit was used only once. Use IWL_DL_INFO instead.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-debug.h    |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
index 8e45fba..b73077f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -117,7 +117,7 @@ static void iwlagn_update_qos(struct iwl_priv *priv,
 	if (ctx->ht.enabled)
 		ctx->qos_data.def_qos_parm.qos_flags |= QOS_PARAM_FLG_TGN_MSK;
 
-	IWL_DEBUG_QOS(priv, "send QoS cmd with Qos active=%d FLAGS=0x%X\n",
+	IWL_DEBUG_INFO(priv, "send QoS cmd with Qos active=%d FLAGS=0x%X\n",
 		      ctx->qos_data.qos_active,
 		      ctx->qos_data.def_qos_parm.qos_flags);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-debug.h b/drivers/net/wireless/iwlwifi/iwl-debug.h
index 1dddf9b..a11e7aa 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debug.h
+++ b/drivers/net/wireless/iwlwifi/iwl-debug.h
@@ -166,7 +166,7 @@ static inline void iwl_dbgfs_unregister(struct iwl_priv *priv)
 #define IWL_DL_11H		(1 << 28)
 #define IWL_DL_STATS		(1 << 29)
 #define IWL_DL_TX_REPLY		(1 << 30)
-#define IWL_DL_QOS		(1 << 31)
+#define IWL_DL_UNUSED		(1 << 31)
 
 #define IWL_DEBUG_INFO(p, f, a...)	IWL_DEBUG(p, IWL_DL_INFO, f, ## a)
 #define IWL_DEBUG_MAC80211(p, f, a...)	IWL_DEBUG(p, IWL_DL_MAC80211, f, ## a)
@@ -203,7 +203,7 @@ static inline void iwl_dbgfs_unregister(struct iwl_priv *priv)
 #define IWL_DEBUG_TX_REPLY(p, f, a...)	IWL_DEBUG(p, IWL_DL_TX_REPLY, f, ## a)
 #define IWL_DEBUG_TX_REPLY_LIMIT(p, f, a...) \
 		IWL_DEBUG_LIMIT(p, IWL_DL_TX_REPLY, f, ## a)
-#define IWL_DEBUG_QOS(p, f, a...)	IWL_DEBUG(p, IWL_DL_QOS, f, ## a)
+#define IWL_DEBUG_UNUSED(p, f, a...)	IWL_DEBUG(p, IWL_DL_UNUSED, f, ## a)
 #define IWL_DEBUG_RADIO(p, f, a...)	IWL_DEBUG(p, IWL_DL_RADIO, f, ## a)
 #define IWL_DEBUG_POWER(p, f, a...)	IWL_DEBUG(p, IWL_DL_POWER, f, ## a)
 #define IWL_DEBUG_11H(p, f, a...)	IWL_DEBUG(p, IWL_DL_11H, f, ## a)
-- 
1.7.0.4

