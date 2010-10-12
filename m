Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:9253 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932719Ab0JLPzL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Oct 2010 11:55:11 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 1/3] iiwlagn: always download priority table
Date: Tue, 12 Oct 2010 08:53:53 -0700
Message-Id: <1286898835-31812-2-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1286898835-31812-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1286898835-31812-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For advance BT/WiFi co-exist, always download bt priority table
before sending bt_config command

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index c4fe3f9..4470e8c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2835,8 +2835,7 @@ static void iwl_alive_start(struct iwl_priv *priv)
 		priv->kill_cts_mask = IWLAGN_BT_KILL_CTS_MASK_DEFAULT;
 		priv->cfg->ops->hcmd->send_bt_config(priv);
 		priv->bt_valid = IWLAGN_BT_VALID_ENABLE_FLAGS;
-		if (bt_coex_active && priv->iw_mode != NL80211_IFTYPE_ADHOC)
-			iwlagn_send_prio_tbl(priv);
+		iwlagn_send_prio_tbl(priv);
 
 		/* FIXME: w/a to force change uCode BT state machine */
 		iwlagn_send_bt_env(priv, IWL_BT_COEX_ENV_OPEN,
-- 
1.7.0.4

