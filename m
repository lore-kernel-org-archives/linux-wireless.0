Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:44836 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754073AbXJYJWd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Oct 2007 05:22:33 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 05/30] iwlwifi: add TGN flag to qos parameters
Date: Thu, 25 Oct 2007 17:15:26 +0800
Message-Id: <11933037584069-git-send-email-yi.zhu@intel.com> (sfid-20071025_102243_698411_FBF66840)
In-Reply-To: <119330375796-git-send-email-yi.zhu@intel.com>
References: <11933037512140-git-send-email-yi.zhu@intel.com>
 <11933037541699-git-send-email-yi.zhu@intel.com>
 <11933037553170-git-send-email-yi.zhu@intel.com>
 <119330375796-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch adds TGN flag to QoS parameters. This flag governs enablement of
NAV shortening with CF-End and filters in 4 or 8K RX AMSDU packets

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 04d2927..2a86f0e 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -2055,16 +2055,21 @@ static void iwl_activate_qos(struct iwl_priv *priv, u8 force)
 	    !priv->qos_data.qos_cap.q_AP.txop_request)
 		priv->qos_data.def_qos_parm.qos_flags |=
 			QOS_PARAM_FLG_TXOP_TYPE_MSK;
-
 	if (priv->qos_data.qos_active)
 		priv->qos_data.def_qos_parm.qos_flags |=
 			QOS_PARAM_FLG_UPDATE_EDCA_MSK;
 
+#ifdef CONFIG_IWLWIFI_HT
+	if (priv->is_ht_enabled && priv->current_assoc_ht.is_ht)
+		priv->qos_data.def_qos_parm.qos_flags |= QOS_PARAM_FLG_TGN_MSK;
+#endif /* CONFIG_IWLWIFI_HT */
+
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	if (force || iwl_is_associated(priv)) {
-		IWL_DEBUG_QOS("send QoS cmd with Qos active %d \n",
-			      priv->qos_data.qos_active);
+		IWL_DEBUG_QOS("send QoS cmd with Qos active=%d FLAGS=0x%X\n",
+				priv->qos_data.qos_active,
+				priv->qos_data.def_qos_parm.qos_flags);
 
 		iwl_send_qos_params_command(priv,
 				&(priv->qos_data.def_qos_parm));
-- 
1.5.2
