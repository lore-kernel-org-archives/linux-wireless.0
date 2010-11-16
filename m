Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:17196 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754533Ab0KPQGo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Nov 2010 11:06:44 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 18/18] iwlwifi: set STATUS_READY before commit_rxon
Date: Tue, 16 Nov 2010 08:01:51 -0800
Message-Id: <1289923311-14920-19-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1289923311-14920-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1289923311-14920-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Have the STATUS_READY bit set before commit_rxon call to avoid fail
to send tx power to uCode.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index c6e455e..5b96b0d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2717,6 +2717,8 @@ static void iwl_alive_start(struct iwl_priv *priv)
 
 	iwl_reset_run_time_calib(priv);
 
+	set_bit(STATUS_READY, &priv->status);
+
 	/* Configure the adapter for unassociated operation */
 	iwlcore_commit_rxon(priv, ctx);
 
@@ -2726,7 +2728,6 @@ static void iwl_alive_start(struct iwl_priv *priv)
 	iwl_leds_init(priv);
 
 	IWL_DEBUG_INFO(priv, "ALIVE processing complete.\n");
-	set_bit(STATUS_READY, &priv->status);
 	wake_up_interruptible(&priv->wait_command_queue);
 
 	iwl_power_update_mode(priv, true);
-- 
1.7.0.4

