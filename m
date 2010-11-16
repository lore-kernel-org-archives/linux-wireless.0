Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:56013 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754390Ab0KPQGo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Nov 2010 11:06:44 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Shanyu Zhao <shanyu.zhao@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 17/18] iwlagn: check change before commit RXON cmd
Date: Tue, 16 Nov 2010 08:01:50 -0800
Message-Id: <1289923311-14920-18-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1289923311-14920-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1289923311-14920-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Shanyu Zhao <shanyu.zhao@intel.com>

When setting rxon chain and filter, no need to commit RXON when the
chain flag is not changed. This reduces the number of RXON commands
we send down to uCode.

Signed-off-by: Shanyu Zhao <shanyu.zhao@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 59af06d..c6e455e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -97,7 +97,8 @@ void iwl_update_chain_flags(struct iwl_priv *priv)
 	if (priv->cfg->ops->hcmd->set_rxon_chain) {
 		for_each_context(priv, ctx) {
 			priv->cfg->ops->hcmd->set_rxon_chain(priv, ctx);
-			iwlcore_commit_rxon(priv, ctx);
+			if (ctx->active.rx_chain != ctx->staging.rx_chain)
+				iwlcore_commit_rxon(priv, ctx);
 		}
 	}
 }
-- 
1.7.0.4

