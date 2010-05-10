Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:48051 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756179Ab0EJW2Z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 May 2010 18:28:25 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 11/47] iwlwifi: checking for all the possible failure cases
Date: Mon, 10 May 2010 15:27:42 -0700
Message-Id: <1273530498-11876-12-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1273530498-11876-1-git-send-email-reinette.chatre@intel.com>
References: <1273530498-11876-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Multiple error condition require fw/rf reset, driver should check all
the possible errors as long as the error checking functions for the
devices are available.

Reported-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-rx.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index 1dff14a..d661fce 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -412,9 +412,11 @@ static void iwl_recover_from_statistics(struct iwl_priv *priv,
 				 */
 				IWL_ERR(priv, "low ack count detected, "
 					"restart firmware\n");
-				iwl_force_reset(priv, IWL_FW_RESET);
+				if (!iwl_force_reset(priv, IWL_FW_RESET))
+					return;
 			}
-		} else if (priv->cfg->ops->lib->check_plcp_health) {
+		}
+		if (priv->cfg->ops->lib->check_plcp_health) {
 			if (!priv->cfg->ops->lib->check_plcp_health(
 			    priv, pkt)) {
 				/*
-- 
1.6.3.3

