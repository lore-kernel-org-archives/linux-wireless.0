Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:15333 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752622Ab1BUUAO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Feb 2011 15:00:14 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 3/4] iwlwifi: enable 2-wire bt coex support for non-combo device
Date: Mon, 21 Feb 2011 11:45:35 -0800
Message-Id: <1298317536-5071-4-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1298317536-5071-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1298317536-5071-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For non-combo devices, 2-wire BT coex is needed to make sure BT coex
still function with external BT devices

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index c04d991..9965215 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2744,9 +2744,11 @@ static void iwl_alive_start(struct iwl_priv *priv)
 			priv->cfg->ops->hcmd->set_rxon_chain(priv, ctx);
 	}
 
-	if (priv->cfg->bt_params &&
-	    !priv->cfg->bt_params->advanced_bt_coexist) {
-		/* Configure Bluetooth device coexistence support */
+	if (!priv->cfg->bt_params || (priv->cfg->bt_params &&
+	    !priv->cfg->bt_params->advanced_bt_coexist)) {
+		/*
+		 * default is 2-wire BT coexexistence support
+		 */
 		priv->cfg->ops->hcmd->send_bt_config(priv);
 	}
 
-- 
1.7.0.4

